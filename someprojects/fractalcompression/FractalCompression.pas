{
Copyright (c) 2006-2009, Loginov Dmitry Sergeevich
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}

{ *************************************************************************** }
{                                                                             }
{                                                                             }
{                                                                             }
{ Модуль FractalCompression - содержит класс TFractal, используемый для       }
{ фрактального сжатия / распаковки изображений                                }
{ (c) 2006-2009 Логинов Дмитрий Сергеевич                                     }
{ Адрес сайта: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{ Последнее изменение: 07.06.2009                                             }
{                                                                             }
{ *************************************************************************** }

{
Изменения и исправления:
  * 07.06.2009 *
  - вместо массивов PByteArray используются объекты из модуля Matrix32.
    За счет этого код стал проще для понимания, его проще модифицировать.
  - изменена структура TIfsRec (сейчас называется TMemIfsRec).
    Раньше было Betta: Byte, стало Betta: ShortInt
    внесены соответствующие исправления. Модуль некорректно работал с черно-
    белыми изображениями - они становились слишком бледными даже при минимальном
    размере региона. Раньше на фотографических изображениях часто появлялись
    белые пятна необъяснимой природы. Теперь они не появляются. Для того, чтобы
    поместить разницу яркости между областями в переменную ShortInt она
    предварительно делится на 2. При декомпрессии она умножается на 2.
  - исправлена ошибка, связанная с некорректной организацией цикла по областям
    доменного изображения. Могла произойти ошибка доступа к памяти, иногда
    происходило неправильное восстановление изображения по доменам с помощью
    функции BuildImageWithDomains(). Ошибку удалось обраружить благодаря
    использованию системы Matrix32 с подключением опции MatrixCheckRange.
  - изменена структура TIfsHeader. Теперь поле FileExt состоит из 4х символов.
    В нем должно быть записано "2IFS".
  - данные хранятся в IFS-файле в компактном формате. Структура TFileIfsRec
    занимает теперь 5 байт (раньше было 6). Особым образом обрабатывается
    ситуация, когда друг за другом идум несколько регионов с одинаковым описанием.
    Смотрите реализацию функций SaveToFile() и LoadFromFile().

  * 11.06.2009 *
  - в методы Decompress и BuildImageWithDomains добавлена дополнительная проверка,
    ограничивающая яркость значениями от 0 до 255. Изображения получаются заметно
    более чистыми. Не возникают белые или черные крапинки, которые раньше резали глаз. 
}

unit FractalCompression;

interface

uses
  Windows, Messages, SysUtils, Graphics, Classes, Matrix32;

type
  // Сжатое описание одного региона в выходном файле (5 байт на 1 запись)
  // Для черно-белых изображений большая часть записей будет занимать 1 байт
  // т.е. один регион произвольных размеров занимает в файле 1 байт.
  // Предпологается, что пользователи не будут сжимать изображения размером
  // большим, чем 4096 х 4096 
  TFileIfsRec = packed record
    FormNum: Byte; // Номер преобразования
    Betta: ShortInt; // Тип изменен с Byte 07.06.2009

    // Координаты левого верхнего угла домена
    // 0й байт - младший байт от Х
    // 1й байт - младший байт от У
    // 2й байт - 4 ст. бита от Х, затем 4 ст. бита от У
    DomCoordXY: array[0..2] of Byte;
  end;

  // Описание одного региона в выходном файле составляет всего-навсего 6 байт
  // Таким образом размер файла = Кол-во регионов * 6
  TMemIfsRec = packed record
    FormNum: Byte; // Номер преобразования
    Betta: ShortInt; // Различие в яркости. Тип изменен с Byte 07.06.2009
    DomCoordX, DomCoordY: Word; // Координаты левого верхнего угла домена       
  end;

  TRegionRec = packed record
    MeanColor: Integer; // Усредненная цветояркость     
    Ifs: TMemIfsRec; // Параметры, вычисляемые при компрессии
  end;

  TDomainRec = packed record
    MeanColor: Integer; // Усредненная цветояркость 
  end;

  // Заголовок файла (9 байт)
  TIfsHeader = packed record
    FileExt: array[1..4] of AnsiChar;
    RegSize: Byte; // Размер региона
    XRegions, YRegions: Word; // Кол-во регионов по Х и У
  end;       

  // Типы афинных преобразований
  TTransformType = (ttRot0, ttRot90, ttRot180, ttRot270, ttSimmX, ttSimmY, ttSimmDiag1, ttSimmDiag2);

  TProgressProc = procedure(Percent: Integer; TimeRemain: Cardinal) of Object;

  TFractal = class(TComponent)
  private
    SourImage: TMatrix;     // Пиксели изображения после преобразования в серый
    DomainImage: TMatrix;   // Массив пикселей доменного изображения
    SourWidth: Integer;     // Ширина регионного изображения
    SourHeight: Integer;    // Высота регионного изображения
    FRegionSize: Integer;   // Размер региона
    FDomainOffset: Integer; // Смещение доменов
    Regions: array of array of TRegionRec; // Информация о регионах
    Domains: array of array of TDomainRec; // Информация о доменах
    FGamma: Real;
    FMaxImageSize: Integer; // Максимально допустимый размер изображения
    FStop: Boolean;
    FIfsIsLoad: Boolean; // Проверяет, была ли выполнена компрессия (загружены ли IFS-данные)
    FBaseRegionSize: Integer;  // Размер региона при сжатии

    {Очищает данные}
    procedure ClearData;

    {Генерирует исключительную ситуация с сообщением Msg}
    procedure Error(Msg: string; Args: array of const);

    {Создает массив ссылок Regions на регионы }
    procedure CreateRegions;

    {По исходному изображению SourImage создает доменное изображение}
    procedure CreateDomainImage;

    {Создает массив 2-мерный Domains, в который заносится усредненная цветояркость
     для каждого домена}
    procedure CreateDomains;

    {Определяет усредненную яркость для участка Image с началом в т. (X, Y)}
    function GetMeanBrigth(Image: TMatrix; X, Y, Width: Integer): Byte;

    function XRegions: Integer; // Число регионов по Х
    function YRegions: Integer; // Число регионов по У

    function XDomains: Integer; // Число доменов по Х
    function YDomains: Integer; // Число доменов по У
    function DomainImageWidth: Integer; // Ширина доменного изображения
    
    procedure SetGamma(const Value: Real);
    procedure SetMaxImageSize(const Value: Integer);

    procedure SetRegionSize(const Value: Integer);
    procedure SetDomainOffset(const Value: Integer);

    {Трансформирует заданный регион в соотв. с TransformType. Пиксели в
     заданном регионе должны идти друг за другом}
    procedure TransformRegion(Sour, Dest: TMatrix; TransformType: TTransformType);

    {Возвращает разницу (метрическое расстояние) между регионом и доменом}
    function GetDifference(Region: TMatrix; DomCoordX, DomCoordY, Betta: Integer): Integer;

    {Копирует указанный регион из массива AllImage в массив Dest.
     Width - ширина массива AllImage}
    procedure CopyRegion(AllImage, Dest: TMatrix; X, Y: Integer);
    function GetPixel(X, Y: Integer): Byte;
  public
    constructor Create(AOwner: TComponent); override;

    destructor Destroy; override;

    {Выполняет собственно само сжатие. При UseAllTransform будут выполнены
     все афинные преобразования: поворот и симметрая. В противном случае
     будет выполнен только поворот}
    procedure Compress(UseAllTransform: Boolean = True; BackProc: TProgressProc = nil);

    {Принудительно прерывает процесс фрактального сжатия}
    procedure Stop;

    {Выполняет распаковку изображения. IterCount - кол-во итераций распаковки,
     RegSize - размер региона с распакованном изображении. Если эта величина
     такая же, как RegionSize при сжатии, то размер изображение будет как при сжатии.
     При уменьшении RegSize распакованное изображение уменьшается и наоборот}
    procedure Decompress(IterCount: Integer = 15; RegSize: Integer = 0);

    {Строит изображение по доменам. Можно использовать сразу после сжатия для того,
     чтобы проверить качество сжатия. Изображение, построенное по доменам,
     похоже на восстановленное изображение, только имеет большую контрастность}
    procedure BuildImageWithDomains;

    {Проверяет, была ли выполнена компрессия (загружены ли IFS-данные, необходимые
     для декомпрессии). Если IfsIsLoad=True, то можно смело делать декомпрессию}
    property IfsIsLoad: Boolean read FIfsIsLoad;

    {Ширина изображения (исходного, построенного по доменам, или распакованного)}
    property ImageWidth: Integer read SourWidth;

    {Высота изображения (исходного, построенного по доменам, или распакованного)}
    property ImageHeight: Integer read SourHeight;

    {Возвращает значение яркости для указанного пикселя}
    property Pixel[X, Y: Integer]: Byte read GetPixel;

    {Загружает полноцветное изображение TBitMap для дальнейшей компрессии}
    procedure LoadImage(Image: TBitmap);

    {Рисует изображение на переданном TBitmap. При Regions = True рисуется исходное
     изображение, иначе рисуется доменное изображение (оно такое же, только
     в 4 раза меньше по площади)}
    procedure DrawImage(Image: TBitmap; Regions: Boolean = True);

    {Сохраняет результат сжатия в двоичный файл}
    procedure SaveToFile(FileName: string);

    {Выполняет загрузку данных из двоичного файла}
    procedure LoadFromFile(FileName: string);

    {Определяет, какой размер будет у IFS-файла после компрессии}
    function GetIFSFileSize(): Cardinal;
  published
    {Устанавливает размер региона.
     ВНИМАНИЕ! Нельзя изменять размер региона после загрузки изображения для
     компрессии, так как загруженное изображение корректируется в
     соответствии с RegionSize}
    property RegionSize: Integer read FRegionSize write SetRegionSize;

    {Величина смещения домена. По умолчанию = 1 (это число соответствует
     доменному изображению, которое в 4 раза меньше исходного)}
    property DomainOffset: Integer read FDomainOffset write SetDomainOffset;

    {Цветовой коэффициент Гамма}
    property Gamma: Real read FGamma write SetGamma;

    {Максимальный размер изображения}
    property MaxImageSize: Integer read FMaxImageSize write SetMaxImageSize;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TFractal]);
end;

var
  // Для обнуления переменных типа TMemIfsRec
  ClearIfs: TMemIfsRec;

{ TFractal }

procedure TFractal.ClearData;
begin
  SourImage.Clear;
  DomainImage.Clear;
  SourWidth := 0;
  SourHeight := 0;
  Regions := nil;
  Domains := nil;
end;

procedure TFractal.Compress(UseAllTransform: Boolean = True; BackProc: TProgressProc = nil);
var
  RegX, RegY, DomX, DomY, Error, BestError, Betta, TransNum, TransCount: Integer;
  Region, BaseRegion: TMatrix;
  DCoordX, DCoordY, BestFormNum, BestDomX, BestDomY, BestBetta: Integer;
  Percent: Real;
  Tc, OneRegTime, AllRegTime: Cardinal;
begin
  FStop := False;
  FIfsIsLoad := False;

  FBaseRegionSize := RegionSize;

  if UseAllTransform then
    TransCount := 8
  else
    TransCount := 4;

  if SourImage.ElemCount = 0 then
    raise Exception.Create('Изображение для фрактального сжатия еще не загружено!');

  CreateRegions;
  CreateDomains;

  Region := TShortMatrix.Create();
  try
    BaseRegion := TShortMatrix.Create(Region);

    // Устанавливаем размеры временных массивов (RegionSize x RegionSize)
    Region.Resize([RegionSize, RegionSize]);
    BaseRegion.Resize([RegionSize, RegionSize]);

    OneRegTime := 0; // Длительность обработки одного региона
    AllRegTime := 0; // Общая длительность обработки
    Tc := GetTickCount;

    // Перебираем регионы
    for RegY := 0 to YRegions - 1 do
    begin
      for RegX := 0 to XRegions - 1 do
      begin
        // Запоминаем время, если обработано более 10 регионов
        if RegY * XRegions + RegX > 10 then
          Tc := GetTickCount;

        // Вычисляем процент операции
        Percent := (RegY * XRegions + RegX) / (YRegions * XRegions) * 100;

        // Устанавливаем параметры, описывающие наиболее близкий к региону домен,
        // максимально далекими от действительности.
        BestError := $7FFFFFFF;
        BestFormNum := -1;
        BestDomX := -1;
        BestDomY := -1;
        BestBetta := 0;

        // Копируем очередной регион во временный массив
        CopyRegion(SourImage, BaseRegion, RegX * RegionSize, RegY * RegionSize);

        // Перебираем домены
        for DomY := 0 to YDomains - 1 do
        begin
          for DomX := 0 to XDomains - 1 do
          begin

            // Определяем разницу в яркости. Она всегда одна для любых трансформаций.
            Betta := Regions[RegX, RegY].MeanColor - Domains[DomX, DomY].MeanColor;

            // Вычисляем смещение участка в доменном изображении
            DCoordX := DomX * DomainOffset;
            DCoordY := DomY * DomainOffset;

            // Проходим цикл по трансформациям
            for TransNum := 0 to TransCount - 1 do
            begin
              // Выполняем афинное преобразование
              TransformRegion(BaseRegion, Region, TTransformType(TransNum));

              // Определяем величину разницы между трансформированным регионом
              // и текущим участком доменного изображения
              Error := GetDifference(Region, DCoordX, DCoordY, Betta);

              // Запоминаем во временные переменные лучшие показатели
              if Error < BestError then
              begin
                BestError := Error;
                BestFormNum := TransNum;
                BestDomX := DCoordX;
                BestDomY := DCoordY;
                BestBetta := Betta;
              end;

              if FStop then Exit; // Мгновенная реакция на команду выхода Stop
            end;  // Цикл по трансформациям
          end;  // Цикл по доменам
        end;

        // Теперь известно все, что нужно для данного региона
        with Regions[RegX, RegY].Ifs do
        begin
          DomCoordX := BestDomX;
          DomCoordY := BestDomY;

          // Сжимаем величину Betta в 2 раза, чтобы уместиться в диапазон [-128..127]
          BestBetta := BestBetta div 2;

          //ShowMessageFmt('Величина отклонения яркости: %d', [BestBetta]);
          if (BestBetta < Low(shortint)) or (BestBetta > High(shortint)) then
            raise Exception.CreateFmt('Недопустимая величина параметра Betta: %d', [BestBetta]);

          Betta := BestBetta;

          // Подменяем некоторые параметры трансформации, иначе это придется
          // делать в процедуре декомпрессии.
          if BestFormNum = 1 then BestFormNum := 3 else // 90 -> 270
            if BestFormNum = 3 then BestFormNum := 1;  // 270 -> 90
          FormNum := BestFormNum;
        end;

        // После обработки десятого региона прогнозируем общее время компрессии.
        if RegY * XRegions + RegX = 10 then
        begin
          OneRegTime := (GetTickCount - Tc) div 10;
          AllRegTime := OneRegTime * Cardinal(XRegions * YRegions);
        end;

        // Вызываем CallBack-функцию для визуализации полосы прогресса
        if Assigned(BackProc) and (Percent >= 0) then
          BackProc(Trunc(Percent), (AllRegTime - OneRegTime * Cardinal(RegY * XRegions + RegX)) div 1000);

      end; // Цикл по регионам
    end;

    FIfsIsLoad := True; // Необходимые для восстановления параметры загружены!
  finally
    Region.FreeMatrix;
  end;
end;

constructor TFractal.Create(AOwner: TComponent);
begin
  inherited;
  FRegionSize := 8;
  DomainOffset := 1;
  Gamma := 0.75;
  MaxImageSize := 512;

  SourImage := TShortMatrix.Create(nil);
  DomainImage := TShortMatrix.Create(nil);
end;

procedure TFractal.CreateDomains;
var
  Y, X: Integer;
begin
  Domains := nil;

  SetLength(Domains, XDomains, YDomains);

  // Для каждого домена определяем его координаты и усредненную яркость
  for Y := 0 to YDomains - 1 do
    for X := 0 to XDomains - 1 do
      Domains[X, Y].MeanColor := GetMeanBrigth(DomainImage, X * DomainOffset,
        Y * DomainOffset, DomainImageWidth);
end;

procedure TFractal.CreateRegions;
var
  X, Y: Integer;
begin
  Regions := nil;
  SetLength(Regions, XRegions, YRegions);

  // Для каждого региона определяем усредненную яркость
  for Y := 0 to YRegions - 1 do
    for X := 0 to XRegions - 1 do
      Regions[X, Y].MeanColor := GetMeanBrigth(SourImage, X * RegionSize, Y * RegionSize, SourWidth);
end;

destructor TFractal.Destroy;
begin
  ClearData();
  SourImage.FreeMatrix;
  DomainImage.FreeMatrix;
  inherited;
end;

procedure TFractal.DrawImage(Image: TBitmap; Regions: Boolean = True);
var
  X, Y, Pixel: Integer;
  Handle: HDC;
begin     
  if SourWidth * SourHeight < 1 then
    Error('Ошибка отрисовки изображения: нулевой размер!', []);

  Image.Width := SourWidth;
  Image.Height := SourHeight;
  Handle := Image.Canvas.Handle;

  for Y := 0 to SourImage.Rows - 1 do
  begin
    for X := 0 to SourImage.Cols - 1 do
    begin
      Pixel := SourImage.ElemI[Y, X];
      Pixel := (Pixel shl 16) + (Pixel shl 8) + Pixel;
      SetPixel(Handle, X, Y, Pixel);
    end;
  end;

  // В левом верхнем углу рисуем доменное изображение
  if not Regions then
  begin
    for Y := 0 to DomainImage.Rows - 1 do
    begin
      for X := 0 to DomainImage.Cols - 1 do
      begin
        Pixel := DomainImage.ElemI[Y, X];
        Pixel := (Pixel shl 16) + (Pixel shl 8) + Pixel;
        SetPixel(Handle, X, Y, Pixel);
      end;
    end;
  end;
end;

procedure TFractal.Error(Msg: string; Args: array of const);
begin
  raise Exception.CreateFmt(Msg, Args);
end;

function TFractal.GetMeanBrigth(Image: TMatrix; X, Y, Width: Integer): Byte;
var
  I, J, Bufer: Integer;
begin
  Bufer := 0;
  for I := Y to Y + RegionSize - 1 do
    for J := X to X + RegionSize - 1 do
      Inc(Bufer, Image.ElemI[I, J]);
  Result := Trunc(Bufer / (RegionSize * RegionSize));
end;

procedure TFractal.LoadImage(Image: TBitmap);
var
  X, Y: Integer;
  PixColor: TColor;
  red, green, blue, mask: integer;
begin
  ClearData;  // Удаляем массивы

  SourWidth := (Image.Width div RegionSize) * RegionSize;
  SourHeight := (Image.Height div RegionSize) * RegionSize;

  // Изображение должно быть не меньше, чем 16 х 16
  if (SourWidth > MaxImageSize) or (SourWidth < 16) or
     (SourHeight > MaxImageSize) or (SourHeight < 16)
    then Error('Недопустимые размеры изображения %d x %d', [Image.Width, Image.Height]);

  // ======= Заполняем массив SourImage (для регионов) ===========
  // Выделяем память под изображение
  SourImage.Resize([SourHeight, SourWidth]);

  // Делаем пиксели серыми и сохраняем их в строковом массиве SourImage
  mask := $000000FF;
  for Y := 0 to SourImage.Rows - 1 do
  begin
    for X := 0 to SourImage.Cols - 1 do
    begin
      PixColor := Image.Canvas.Pixels[X, Y]; // Определяем цвет пикселя
      red := (PixColor shr 16) and mask;
      green := (PixColor shr 8) and mask;
      blue := PixColor and mask;
      SourImage.ElemI[Y, X] := Byte((red + green + blue) div 3);
    end;
  end;
  // Теперь все пиксели серые.

  // ======= Заполняем массив DomenImage (для доменов) ===========
  // Вообще-то домены в 2 раза больше регионов, однако из-за этого их сложно сравнивать.
  // А вот если мы доменное изображение уменьшим в 4 раза (по площади), то
  // размер 1 домена станет равным размеру 1 региона, что гораздо лучше
  // и экономнее.
  CreateDomainImage;

  FIfsIsLoad := False;
end;

procedure TFractal.SetDomainOffset(const Value: Integer);
begin
  if (Value < 1) or (Value > 32) then
    Error('Задана недопустимая величина смещения домена %d', [Value]);

  FDomainOffset := Value;
end;

procedure TFractal.SetGamma(const Value: Real);
begin
  if (Value < 0.1) or (Value > 1) then
    Error('Параметр GAMMA имеет недопустимое значение %d', [Value]);

  FGamma := Value;
end;

procedure TFractal.SetMaxImageSize(const Value: Integer);
begin
  FMaxImageSize := Value;
end;

procedure TFractal.SetRegionSize(const Value: Integer);
begin
  if (Value < 2) or (Value > 64) then
    Error('Задано недопустимое значение региона %d', [Value]);

  FRegionSize := Value;
end;

function TFractal.XDomains: Integer;
begin
  Result := ((SourWidth div 2) - 1) div DomainOffset;

  // Уменьшаем количество участков доменов, чтобы их можно было
  // корректно перебрать в цикле
  while (Result * DomainOffset + RegionSize) > (SourWidth div 2) do
    Dec(Result);

  if Result <= 1 then
    Error('Недопустимое количество доменов по Х %d', [Result]);
end;

function TFractal.YDomains: Integer;
begin
  Result := ((SourHeight div 2) - 1) div DomainOffset;    

  // Уменьшаем количество участков доменов, чтобы их можно было
  // корректно перебрать в цикле  
  while (Result * DomainOffset + RegionSize) > (SourHeight div 2) do
    Dec(Result);
  
  if Result <= 1 then
    Error('Недопустимое количество доменов по Y %d', [Result]);
end;

function TFractal.XRegions: Integer;
begin
  Result := SourWidth div RegionSize;
end;

function TFractal.YRegions: Integer;
begin
  Result := SourHeight div RegionSize;
end;

procedure TFractal.TransformRegion(Sour, Dest: TMatrix; TransformType: TTransformType);
var
  I, J: Integer;
begin
  case TransformType of
    ttRot0: // Поворот на 0 градусов (просто копируем элементы массива)
      begin
        Dest.CopyFrom(Sour);
      end;

    ttRot90: // Поворот на 90 градусов
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[(RegionSize - 1 - J) * RegionSize + I] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttRot180: // Поворот на 180 градусов
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[(RegionSize - 1 - I) * RegionSize + (RegionSize - 1 - J)] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttRot270: // Поворот на 270 градусов
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[J * RegionSize + (RegionSize - 1 - I)] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttSimmX: // Симметрия относительно Х
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[(RegionSize - 1 - I) * RegionSize + J] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttSimmY: // Симметрия относительно У
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[I * RegionSize + (RegionSize - 1 - J)] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttSimmDiag1: // Симметрия от. главной диагонали
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[J * RegionSize + I] := Sour.VecElemI[I * RegionSize + J];
      end;

    ttSimmDiag2: // Симметрия от. второстепенной диагонали
      begin
        for I := 0 to RegionSize - 1 do
          for J := 0 to RegionSize - 1 do
            Dest.VecElemI[(RegionSize - 1 - J) * RegionSize + (RegionSize - 1 - I)] := Sour.VecElemI[I * RegionSize + J];
      end;
  end;
end;

function TFractal.DomainImageWidth: Integer;
begin
  Result := SourWidth div 2;
end;

procedure TFractal.LoadFromFile(FileName: string);
var
  X, Y: Integer;
  Header: TIfsHeader;
  OldIfs: TMemIfsRec;
  FileIfs: TFileIfsRec;
  AByte: Byte;
  SameIfsCount: Integer;
begin
  if not FileExists(FileName) then
    Error('Файл "%s" не существует', [FileName]);

  with TMemoryStream.Create do
  try
    LoadFromFile(FileName);
    Seek(0, soFromBeginning);
    Read(Header, SizeOf(TIfsHeader));
    if Header.FileExt <> '2IFS' then
      Error('Файл "%s" имеет недопустимый формат!', [FileName]);
    
    SourWidth := Header.XRegions * Header.RegSize;
    SourHeight := Header.YRegions * Header.RegSize;
    RegionSize := Header.RegSize;

    Regions := nil;
    OldIfs := ClearIfs;
    OldIfs.DomCoordX := MaxWord;
    SameIfsCount := 0;

    SetLength(Regions, XRegions, YRegions);
    for Y := 0 to YRegions - 1 do
    begin
      for X := 0 to XRegions - 1 do
      begin
        if SameIfsCount > 0 then
        begin
          Dec(SameIfsCount);
        end else
        begin    
          // Считываем один байт
          Read(AByte, SizeOf(AByte));

          if (AByte and $80) = $80 then // Старший бит установлен в единицу
          begin // Встретился байт повтора
            if OldIfs.DomCoordX = MaxWord then
              raise Exception.Create(
                'Из файла IFS был прочитан байт повтора 0xFF, '+
                'однако перед ним описание региона не найдено!');

            // Определяем число повторов
            SameIfsCount := AByte and $7F; // $7F = 01111111
            Dec(SameIfsCount);
          end else
          begin
            Position := Position - 1; // Возвращаемся на 1 байт назад
            Read(FileIfs, SizeOf(FileIfs));
            OldIfs.FormNum := FileIfs.FormNum;
            OldIfs.Betta := FileIfs.Betta;
            OldIfs.DomCoordX := ((FileIfs.DomCoordXY[2] and $F0) shl 4) + FileIfs.DomCoordXY[0];
            OldIfs.DomCoordY := ((FileIfs.DomCoordXY[2] and $0F) shl 8) + FileIfs.DomCoordXY[1];
          end;
        end;

        Regions[X, Y].Ifs := OldIfs; // Запоминаем считанные из файла данные
      end;
    end;

  finally
    Free;       
  end;

  // Нужен для масштабирования при декомпрессии
  FBaseRegionSize := RegionSize;
  
  FIfsIsLoad := True;
end;

procedure TFractal.SaveToFile(FileName: string);
var
  X, Y: Integer;
  Header: TIfsHeader;
  OldIfs: TMemIfsRec;
  FileIfs: TFileIfsRec;
  AByte: Byte;
  SameIfsCount: Integer;
  ms: TMemoryStream;

  procedure SaveRepeats;
  begin
    if SameIfsCount > 0 then
    begin
      AByte := $80 or Byte(SameIfsCount);
      ms.Write(AByte, SizeOf(AByte));
      SameIfsCount := 0; // Обнуляем счетчик
    end;
  end;
begin
  if Regions = nil then
    Error('Сжатие изображения не выполнено!', []);

  if FileExists(FileName) and (not DeleteFile(FileName)) then
    Error('Невозможно удалить файл "%s": %s', [FileName, SysErrorMessage(GetLastError)]);

  Header.FileExt := '2IFS';
  Header.RegSize := RegionSize;
  Header.XRegions := XRegions;
  Header.YRegions := YRegions;

  OldIfs := ClearIfs;
  OldIfs.DomCoordX := MaxWord;
  SameIfsCount := 0;

  ms := TMemoryStream.Create();
  try
    // Сохраняем заголовочную информацию
    ms.Write(Header, SizeOf(TIfsHeader));

    // Регионы сохраняем в компактном формате.
    // Если регионы, идущие друг за другом, отличаются по каки-либо параметрам,
    // то записываем в 5-байтном формате. При этом 1 байт выигрываем за счет
    // кодировки DomCoordX и DomCoordY.
    // Если же друг за другом идут полностью одинаковые регионы,
    // то записываем старшый бит = 1, а за ним количество повторяющихся регионов

    for Y := 0 to YRegions - 1 do
    begin
      for X := 0 to XRegions - 1 do
      begin
        // Если запись полность соответствует предыдущей записи (случай сжатия
        // черно-белых изображений), то записываем лишь один байт FF
        with Regions[X, Y].Ifs do
        begin
          if (DomCoordX = OldIfs.DomCoordX) and (DomCoordY = OldIfs.DomCoordY) and
            (Betta = OldIfs.Betta) and (FormNum = OldIfs.FormNum) then
          begin
            Inc(SameIfsCount);
            if SameIfsCount = High(ShortInt) then // Предотвращение переполнения
              SaveRepeats();
          end else
          begin
            // Если счетчик одинаковых IFS не нулевой, то записываем число повторов
            SaveRepeats();

            FileIfs.FormNum := FormNum;
            FileIfs.Betta := Betta;
            FileIfs.DomCoordXY[0] := Byte(DomCoordX);
            FileIfs.DomCoordXY[1] := Byte(DomCoordY);
            FileIfs.DomCoordXY[2] := ((Regions[X, Y].Ifs.DomCoordX and $0F00) shr 4) or
              ((Regions[X, Y].Ifs.DomCoordY and $0F00) shr 8);

            ms.Write(FileIfs, SizeOf(FileIfs));
          end;
        end;

        // Запоминаем обработанный регион
        OldIfs := Regions[X, Y].Ifs;
      end;
    end;

    // Сохраняем повторы, если они есть
    SaveRepeats();

    ms.SaveToFile(FileName);
  finally
    ms.Free;
  end; 
end;

procedure TFractal.Decompress(IterCount: Integer = 15; RegSize: Integer = 0);
var
  I, J, X, Y, Pixel, Iter: Integer;
  Domain1, Domain2: TMatrix;
  Scale: Real;
begin
  // Массив Region должен быть уже заполненным.
  if not FIfsIsLoad then
    Error('Данные, необходимые для декомпрессии, не загружены!', []);

  Scale := 1;

  if RegSize >= 2 then
  begin
    SourWidth := XRegions * RegSize;
    SourHeight := YRegions * RegSize;
    Scale := FBaseRegionSize / RegSize;
    RegionSize := RegSize;
  end;

  // Создаем серое изображение.
  SourImage.Resize([SourHeight, SourWidth]);
  // Делаем пиксели серыми и сохраняем их в строковом массиве SourImage
  SourImage.FillByValue(127);
  Domain1 := TShortMatrix.Create();
  try
    Domain2 := TShortMatrix.Create(Domain1);
    Domain1.Resize([RegionSize, RegionSize]);
    Domain2.Resize([RegionSize, RegionSize]);

    for Iter := 1 to IterCount do
    begin
      // Создаем доменное изображение
      CreateDomainImage;
      // Доменное изображение создали

      // Проходим по всем регионам
      for J := 0 to YRegions - 1 do
      begin
        for I := 0 to XRegions - 1 do
        begin
          // Запоминаем соответствующий домен, чтобы над ним можно было выполнить преобразования
          CopyRegion(DomainImage, Domain1,
            Trunc(Regions[I, J].Ifs.DomCoordX / Scale),
            Trunc(Regions[I, J].Ifs.DomCoordY / Scale));

          // Выполняем заданное преобразование
          TransformRegion(Domain1, Domain2, TTransformType(Regions[I, J].Ifs.FormNum));

          // Изменяем пиксели текущего региона
          for Y := 0 to RegionSize - 1 do
          begin
            for X := 0 to RegionSize - 1 do
            begin
              Pixel := Domain2.ElemI[Y, X] + Regions[I, J].Ifs.Betta * 2;    

              if Pixel > 255 then
                Pixel := 255
              else if Pixel < 0 then
                Pixel := 0;

              SourImage.ElemI[J * RegionSize + Y, I * RegionSize + X] := Pixel;
            end;
          end;
        end;
      end;
    end; // for Iter
  finally
    Domain1.FreeMatrix;
  end;   
end;

procedure TFractal.CreateDomainImage;
var
  X, Y, PixColor: Integer;
begin
  // Выделяем память под доменное изображение (в 4 раза меньше, чем у исходного)
  DomainImage.Resize([SourImage.Rows div 2, SourImage.Cols div 2]);

  for Y := 0 to DomainImage.Rows - 1 do
  begin
    for X := 0 to DomainImage.Cols - 1 do
    begin
      // Определяем усредненный цвет пикселя (по цветам 4-х соседних пикселей)
      PixColor :=
        SourImage.ElemI[Y * 2, X * 2] + SourImage.ElemI[Y * 2, X * 2 + 1] +           // 1 2
        SourImage.ElemI[Y * 2 + 1, X * 2] + SourImage.ElemI[Y * 2 + 1, X * 2 + 1];    // 3 4

      // Делим на 4 и умножаем на Гамма  
      DomainImage.ElemI[Y, X] := Trunc(PixColor / 4 * Gamma);
    end;
  end;
end;

function TFractal.GetDifference(Region: TMatrix; DomCoordX,
  DomCoordY, Betta: Integer): Integer;
var
  X, Y, Diff: Integer;
begin
  Result := 0;
  for Y := 0 to RegionSize - 1 do
    for X := 0 to RegionSize - 1 do
    begin
      Diff := Region.ElemI[Y, X] -
        DomainImage.ElemI[DomCoordY + Y, DomCoordX + X];

      Inc(Result, Sqr(Abs(Diff - Betta)));
    end;
end;

procedure TFractal.CopyRegion(AllImage, Dest: TMatrix; X, Y: Integer);
var
  I, J: Integer;
begin
  for I := 0 to Dest.Rows - 1 do
    for J := 0 to Dest.Cols - 1 do
      Dest.ElemI[I, J] := AllImage.ElemI[Y + I, X + J];
end;

procedure TFractal.BuildImageWithDomains;
var
  I, J, X, Y, Pixel: Integer;
  Domain1, Domain2: TMatrix;
begin
  if not FIfsIsLoad then
    Error('Данные, необходимые для восстановления по доменам, не загружены!', []);

  Domain1 := TShortMatrix.Create();
  try
    Domain2 := TShortMatrix.Create(Domain1);

    Domain1.Resize([RegionSize, RegionSize]);
    Domain2.Resize([RegionSize, RegionSize]);

    for J := 0 to YRegions - 1 do
    begin
      for I := 0 to XRegions - 1 do
      begin
        // Копируем домен
        CopyRegion(DomainImage, Domain1, Regions[I, J].Ifs.DomCoordX,
          Regions[I, J].Ifs.DomCoordY);

        // Выполняем афинное преобразование
        TransformRegion(Domain1, Domain2, TTransformType(Regions[I, J].Ifs.FormNum));

        // Копируем домен в регион
        for Y := 0 to RegionSize - 1 do
          for X := 0 to RegionSize - 1 do
          begin
            Pixel := Domain2.ElemI[Y, X] + Regions[I, J].Ifs.Betta * 2;
            
            if Pixel > 255 then
              Pixel := 255
            else if Pixel < 0 then
              Pixel := 0;

            SourImage.ElemI[J * RegionSize + Y, I * RegionSize + X] := Pixel
          end;
      end;
    end;
  finally
    Domain1.FreeMatrix;
  end;    
end;

procedure TFractal.Stop;
begin
  FStop := True;
end;

function TFractal.GetPixel(X, Y: Integer): Byte;
begin
  Result := SourImage.ElemI[Y, X];
end;

function TFractal.GetIFSFileSize: Cardinal;
begin
  Result := (ImageWidth div RegionSize) * (ImageHeight div RegionSize) * SizeOf(TFileIfsRec);
  if Result > 0 then Inc(Result, SizeOf(TIfsHeader));
end;

end.
