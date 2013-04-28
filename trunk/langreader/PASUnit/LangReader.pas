unit LangReader;

{(c) 2006-2009 - Loginov Dmitry

 http://matrix.kladovka.net.ru/
 e-mail: loginov_d@inbox.ru
 last update: 12.12.2009

 Description

 Модуль предназначен для упрощения локализации приложений, создаваемых в
 Delphi с использованием VCL, на различные иностранные языки, символы алфавита
 которых поддаются стандарту ASCII (русский, английский, немецкий и т.п., т.е.
 практически любые языки, не использующие иероглифов).
 Данный модуль крайне прост в использовании.
 Необходимо подготовить языковой файл, например English.lng. Он должен быть
 в формате ini-файла, так как работа с ним выполняется средствами экземпляра
 класса TIniFile (вернее, TMemIniFile). Простой пример:

 [TMainForm]
 Caption=MainForm caption
 Width=400
 Heigth=300
 Panel1.Color = $000000FF
 LabeledEdit1.EditLabel.Caption=Must die!
 Memo1.Lines = "Строка 1\nСтрока 2"
 RadioGroup1.Items ="Элемент 1\nЭлемент 2"
 NewButton.Anchors = [akLeft,akTop,akRight,akBottom]
 Image1.Picture=C:\Delphi\Projects\LangReader\mainicon.ico

 Как видите, имя класса компонента записывается в названии секции.
 Изменяемые свойства записываются практически так же, как и в коде. Конечно же
 есть несколько ограничений:
 - вы не можете записать так: Panel1.Color = clRed, так как ассоциируемые
   с цветами строки в целочисленный вид автоматически не преобразуются
   (не исключено, что в будущем это будет подправлено)
 - вы не можете записать так: Memo1.Lines.Text = "Строка 1\nСтрока 2", так
   как (в данном случае :) к сожалению свойство Text не опубликовано. Для
   RadioGroup1.Items действует то же самое ограничение. Как надо записывать -
   смотрите в примерах.   

 В общем, языковой файл условно можно рассматривать как файл ресурсов (dfm-файл),
 содержимое которого можно подгружать во время работы программы. Пользователю
 позволено изменять практически любое свойство. Хорошо это или плохо - судить
 не мне. Вы можете запретить пользователю изменять нестроковые свойства. Для этого
 достаточно присвоить переменной UseOnlyStringProperties значение True

 Загрузка свойств компонентов выполняется с помощью процедуры SetLanguage(),
 в которую должна передаваться ссылка на компонент, подлежащий локализации
 (отмечу, что таким компонентом может быть не только форма, но и любой другой
 контролл), а также имя языкового файла. Если в качестве ссылки на компонент
 выставить NIL, то локализация подействует на все формы и модули данных
 приложения, ссылки на которые хранятся в Screen.
 
 Локализацию изображений можно выполнить двумя способами:
 1 - свойству Image.Picture задать имя графического файла.
   Этот способ неудобен тем, что все графические файлы необходимо поставлять
   отдельно для каждого языка. А файлов может быть очень много.
 2 - воспользоваться утилитой bmp2str.exe, которая сохранит заданное изображение
   в LNG-файл в формате HEX. В этом случае все изображения можно хранить в одном-
   единственном LNG-файле. К томуже, пользователь не сможет "рихтануть"
   изображение, т.к. он может увидеть его только при работающей программе.
   Отмечу, что благодаря использованию класса TMemIniFile на длину строк и
   размер LNG-файла не действуют никакие ограничения, свойственные TIniFile.

 По-умолчанию модуль работает в режиме кэширования LNG-файлов. Этот режим можно
 выключить, установив KeepLngFiles в False. В режиме кэширования все LNG-файлы
 грузятся в память программы всего один раз - при их первом использовании. В
 дальнейшем LNG-файлы программой не используются.

 Вызов функции SetLanguage() можно поместить в конструктор формы /
 модуля данных / фрейма. В этом случае, чтобы каждый раз не переводить все
 контролы приложения, первым параметром следует задать SELF.

 Локализация приложения безполезна без возможности трансляции текстовых сообщений.
 Для хранения сообщений можно использовать тот же самый ini-файл (English.lng)
 Все текстовые сообщения, используемые в программе, можно занести в отдельную
 секцию. Пример:

 [Messages]
 SConfirmClose=Do you want close this program?
 SConfirm=Confirm

 Для работы с сообщениями необходимо создать экземпляр класса TTextMessages и
 загрузить содержимое указанной секции из ini-файла с помощью функции
 TTextMessages.LoadFromFile(). Сообщения можно считывать, добавлять и изменять с
 помощью default-свойства SMsg. Рекомендуется все сообщения, задаваемые по
 умолчанию, добавить в самом начале работы программы. Пример добавления:

   Messages['SConfirmClose'] := 'Вы действительно хотите закончить работу с программой?';
   Messages['SConfirm'] := 'Подтверждение';

 в противном случае программа может оказаться крайне немногословной, если у нее
 украсть файлы переводов.  

 Пример использования сообщения в фукнции MessageBox:

 CanClose := Application.MessageBox(
               Messages.PMsg['SConfirmClose'],
               Messages.PMsg['SConfirm'],
               MB_ICONQUESTION or MB_OKCANCEL) = IDOK;

 Само-собой, предлагаемый метод локализации приложений - не единственный.
 Delphi предлагает свой способ достичь желаемого - с помощью инструмента
 Translation Manager. Такой метод считается более мощным, однако для хранения
 значений свойств он генерирует двоичные файлы ресурсов, которые в случае
 необходимости не исправишь с помощью обычного блокнота.

 Ряд компонентов для локализации можно найти в Интернете, в частности на
 сайте (и огромнейшей базе компоненов) torry.net.
 Одним из аналогов данного модуля является библиотека TsiLang. Она
 предоставляет гораздо больше возможностей и при этом является платной.

 Протестировано на следующих версия Delphi: 7, 2006, 2007, 2009, 2010

 Изменения:
 20.05.2008
  - добавлен класс TFastMessageList, позволяющий значительно уменьшить время загрузки
    текста за счет оптимизации функции сравнения строк.

 12.12.2009
  - код проверен на совместимость с UnicodeString. Исправление свелось к добавлению
    tkUString в функции SetControlProperty (для D2009 и выше).
    Языковые файлы можно оставить в кодировке ANSI, либо переконвертировать в
    UTF8 или Unicode (при этом следует обязательно указать в текстовом файле
    преамбулу, т.е. первые 3 байта порядка символов).

 09.12.2010
  - теперь проверка входимости символа в множество осуществляется с помощью CharInSet
  }

{UseGraphics. Подключите данную опцию, чтобы дать программе возможность обработать
 изображение, хранящееся в LNG-файле в формате НЕХ}
{$DEFINE UseGraphics}

{$IFDEF UseGraphics}
  {.$DEFINE UseJPEG}
{$ENDIF UseGraphics}


interface
uses
  Windows, SysUtils, Classes, Controls, Forms, TypInfo, IniFiles, SyncObjs,
  Graphics {$IFDEF UseJPEG}, JPEG {$ENDIF};

{ Директива D2009PLUS определяет, что текущая версия Delphi: 2009 или выше}
{$IF RTLVersion >= 20.00}
   {$DEFINE D2009PLUS}
{$IFEND}

type
  {Абстрактный класс, предоставляющий методы Lock и UnLock, выполняющих
   блокировку с помощью критической секции.}
  TLockClass = class(TObject)
  private
    FCriticalSection: TCriticalSection;
  protected
    {Блокировка операций записи/чтения}
    procedure Lock;

    {Снятие блокировки операций записи/чтения}
    procedure UnLock;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  {Класс управления текстовыми сообщениями. Для загрузки сообщений из ини-файла
   используйте метод LoadFromFile(). Для записи/чтения/добавления сообщений
   используйте default-свойство SMsg}
  TTextMessages = class(TLockClass)
  private
    FMessageList: TObject;

    function GetPMsg(const MsgName: string): PChar;
    function GetSMsg(const MsgName: string): string;
    procedure SetSMsg(const MsgName, Value: string);

  public
    constructor Create; override;
    destructor Destroy; override;

    property SMsg[const MsgName: string]: string read GetSMsg write SetSMsg; default;
    property PMsg[const MsgName: string]: PChar read GetPMsg;

    {Загружает строки из секции Section файла FileName}
    procedure LoadFromFile(const FileName, Section: string);

    {Загружает строки из скиска Strings}
    procedure LoadFromStrings(Strings: TStringList);

    {Очистка скисков}
    procedure Clear;

    {Возвращает количество текстовых сообщений}
    function Count: Integer;
  end;

{Загружает язык интерфейса из указанного ini-файла. Если AControl = nil,
 то изменения коснутся всех форм и модулей данных приложения, иначе - только для
 указанного контрола (можно указать любой контрол, например - форму, модуль
 даных, фрейм, сложный компонент и т.п. В любом случае программа попытается найти
 для него секцию, чье имя совпадает в именем класса контрола, и уже оттуда
 загружать доступные данные)

 Не все параметры элементов интерфейса можно изменить, указав лишь
 нужные параметры в ини-файле. Например для загрузки текста в ТМемо пришлось
 писать дополнительный код (к счастью, он универсален, и работает для
 всех списков TStrings (у любого компонента)). Нельзя изменять набор иконок,
 хранящийся в TImageList (посмотрите его методы ReadData и WriteData, и вы поймете,
 почему так).
 Примеры ини-файлов можно найти в папке с программой}
procedure SetLanguage(AControl: TComponent; const LangFileName: string);

{Переводит буфер в строку. Каждый байт буфера представляется двумя HEX-символами}
function BufferToStr(Buffer: Pointer; BufSize: Integer): string;

{Переводит поток в строку}
function StreamToStr(AStream: TMemoryStream): string;

{Переводит строку в поток. Функция оптимизирована для возможности
 работы с большими изображениями}
procedure StrToStream(const Str: string; AStream: TMemoryStream);

{$IFDEF UseGraphics}
{Проверяет, зарегистрирован ли класс AClass в списке}
function IsRegistredGraphicFormat(AClass: TClass): Boolean;
{$ENDIF UseGraphics}

{Генерирует хэш строки по алгоритму ROT13 (без операций умножения)}
function GenerateStringHashROT13(const S: string): Cardinal;

var
  {Просто строковая переменная. Вы можете в ней хранить имя языкового файла
   а можете ее вообще нигде не использовать. В данном модуле она не используется
   поэтому и компоноваться просто так она не будет}
  LangFileName: string;

  {Позволяет хранить в памяти содержимое загруженных LNG-файлов все время
   работы программы. Это позволяет сохранить высокую скорость локализации
   даже при больших размерах LNG-файлов. Отрицательная сторона данного подхода
   в том, что нельзя будет при запущенной программе подправить что-либо и
   сразу посмотреть результат. В принципе, вы можете сделать в своей программе
   что-нибудь вроде настройки "буферизация файлов локализации"}
  KeepLngFiles: Boolean = True;

  {Установите данную переменную в True, если вы не хотите, чтобы при чтении
   свойств формы из ини-файла менялись все (в том числе и нестроковые) свойства}
  UseOnlyStringProperties: Boolean;

{$IFDEF UseGraphics}
  {Ассоциативный список, в котором каждому имени класса сопоставлен ClassType.
   В данном модуле регистрируются только стандартные классы изображений.
   Регистрацию TJPEGImage и других изображений вы должны выполнять самостоятельно.
   Для этого переменная GraphicFormats объявлена как глобальная}
  GraphicFormats: TStringList;
{$ENDIF UseGraphics}

implementation

type
  PTextMessageItem = ^TTextMessageItem;
  TTextMessageItem = record
    tmiKey: string; // Идентификатор (хранится в верхнем регистре)
    tmiValue: string; // Текстовое сообщение
    tmiHash: Cardinal; // Хэш идентификатора (для ускорения поиска)
  end;

  {Список, хранящий текстовые сообщения для TTextMessages. Работает на несколько
   порядков быстрее, чем TStringList, т.к. хорошо оптимизирована функция IndexOfKey.
   Для дополнительного ускорения используется вычисление хэша искомой строки. В
   некоторых случаях это работает быстрее простого сравнения строк, но в любом
   случае - не медленнее. Хэш-функция работает по алгоритму ROT13, без
   единой операции умножения.}
  TFastMessageList = class(TObject)
  private
    FList: array of PTextMessageItem; // Список элементов
    FCount: Integer; // Количество элементов в списке
    FCapacity: Integer; // Количество элементов в массиве TFastMessageList

    // Устанавливает кол-во элементов в списке
    procedure SetCapacity(NewCapacity: Integer);

    // Увеличивает число элементов в массиве (обычно на 1/3)
    procedure Grow;
  public
    destructor Destroy; override;

    // Возвращает индекс идентификатора. Возвращает -1, если элемент не найден
    // Key должен передаваться в верхнем регистре
    function IndexOfKey(const Key: string): Integer;

    // Добавляет новый элемент в список. Возвращает индекс добавленного элемента
    // Key должен передаваться в верхнем регистре
    function Add(const Key, Value: string): Integer;

    // Возвращает кол-во элементов в списке
    property Count: Integer read FCount;

    // Возвращает текстовое сообщение по заданному идентификатору
    function GetValueByKey(const Key: string): PChar;

    // Возвращает текстовое сообщение по его индексу
    function GetValueByIndex(Index: Integer): PChar;

    // Возвращает идентификатор по его индексу
    function GetKeyByIndex(Index: Integer): PChar;

    // Удаляет все данные из массива
    procedure Clear;
  end;

  TLngFilesManager = class(TLockClass)
  private
    {Ассоциативный список LNG-файлов}
    FFileList: TStringList;

    function CreateMemIniFile(const FileName: string): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Clear;
    {Возвращает объект класса TMemIniFile. Если ранее обработка файла FileName
     велась, то соответствующий объект уже создан - в этом случае функция вернет
     ссылку на него. В противном случае объект будет создан.}
    function GetMemIniFile(const FileName: string): TMemIniFile;
  end;

var
  LngManager: TLngFilesManager;


{$IFNDEF D2009PLUS}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;
{$ENDIF}

{ TTextMessages }

procedure TTextMessages.Clear;
begin
  Lock;
  try
    TFastMessageList(FMessageList).Clear;
  finally
    UnLock;
  end;
end;

function TTextMessages.Count: Integer;
begin
  Result := TFastMessageList(FMessageList).Count;
end;

constructor TTextMessages.Create;
begin
  inherited;
  FMessageList := TFastMessageList.Create;
end;

destructor TTextMessages.Destroy;
begin
  FreeAndNil(FMessageList);
  inherited;
end;

function TTextMessages.GetPMsg(const MsgName: string): PChar;
var
  I: Integer;
begin
  Lock;
  try
    Result := nil;
    // Определяем индекс идентификатора
    I := TFastMessageList(FMessageList).IndexOfKey(AnsiUpperCase(Trim(MsgName)));
    
    if I >= 0 then
      Result := TFastMessageList(FMessageList).GetValueByIndex(I);
  finally
    UnLock;
  end;
end;

function TTextMessages.GetSMsg(const MsgName: string): string;
begin
  Result := PMsg[MsgName];
end;

procedure TTextMessages.LoadFromFile(const FileName, Section: string);
var
  AList: TStringList;
  MemIni: TMemIniFile;
begin
  Lock;
  AList := TStringList.Create;
  try
    if KeepLngFiles then
      MemIni := LngManager.GetMemIniFile(FileName)
    else
    begin
      LngManager.Clear;
      MemIni := TMemIniFile.Create(FileName);
    end;       
      
    try
      MemIni.ReadSectionValues(Section, AList);
      LoadFromStrings(AList);
    finally
      if not KeepLngFiles then
        MemIni.Free;
    end;
  finally
    AList.Free;
    UnLock;
  end;  
end;

procedure TTextMessages.LoadFromStrings(Strings: TStringList);
var
  I, EqPos: Integer;
  S: string;
  AName, AValue: string;
begin
  for I := 0 to Strings.Count - 1 do
  begin
    {Ниже идет замена функции ValueFromIndex для поддержки Delphi6}
    S := Strings[I];
    EqPos := Pos('=', S);
    if EqPos > 1 then
    begin
      AName := Trim(Copy(S, 1, EqPos - 1));
      if AName <> '' then
      begin
        AValue := AnsiDequotedStr(Copy(S, EqPos + 1, MaxInt), '"');
        SMsg[AName] := AValue;
      end;
    end;
  end;
    
end;

procedure TTextMessages.SetSMsg(const MsgName, Value: string);
begin
  if Trim(MsgName) = '' then Exit;
  
  Lock;
  try
    TFastMessageList(FMessageList).Add(AnsiUpperCase(Trim(MsgName)),
      StringReplace(Value, '\n', sLineBreak, [rfReplaceAll, rfIgnoreCase]))
  finally
    UnLock;
  end;
end;

procedure ParseString(S: string; APropList: TStrings; var AText: string);
var
  I: Integer;
begin
  APropList.Clear;
  AText := '';

  S := Trim(S);
  if S = '' then Exit;

  with TStringList.Create do
  try
    Text := S;
    AText := StringReplace(AnsiDequotedStr(Values[Names[0]], '"'), '\n',
      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

   // if Trim(AText) = '' then Exit; Не нужно!

    Delimiter := '.';
    DelimitedText := Names[0];
    for I := 0 to Count - 1 do
      Strings[I] := Trim(Strings[I]);

    APropList.Text := Text;
  finally
    Free;
  end;
end;

procedure SetControlProperty(AControl: TComponent; PropName: string; Value: Variant);
var
  PropInfo: PPropInfo;
  ObjClass: TClass;

  procedure SetStringList;
  var
    AList: TStringList;
  begin
    AList := TStringList.Create;
    try
      AList.Text := string(Value);
      TypInfo.SetObjectProp(AControl, PropName, AList);
    finally
      AList.Free;
    end;
  end;

  {$IFDEF UseGraphics}
  procedure SetPicture;
  var
    MS: TMemoryStream;
    CName: string[63];
    gr: TGraphic;
    gClass: TGraphicClass;
    Pict: TPicture;
    I: Integer;
  begin
    if (Length(Value) <= MAX_PATH) and FileExists(Value) then
    begin
      Pict := TPicture.Create;
      try
        Pict.LoadFromFile(Value);
        TypInfo.SetObjectProp(AControl, PropName, Pict);
      finally
        Pict.Free;
      end;
    end else
    begin
      MS := TMemoryStream.Create;
      try
        StrToStream(Value, MS);

        // Считываем имя класса
        MS.Read(CName[0], 1);
        MS.Read(CName[1], Integer(CName[0]));
        I := GraphicFormats.IndexOf(string(CName));
        if I >= 0 then
        begin
          gClass := TGraphicClass(GraphicFormats.Objects[I]);
          Pict := TPicture.Create;
          try
            gr := gClass.Create;
            try
              gr.LoadFromStream(MS);
              Pict.Graphic := gr;
              TypInfo.SetObjectProp(AControl, PropName, Pict);
            finally
              gr.Free;
            end;
          finally
            Pict.Free;
          end;
        end;
      finally
        MS.Free;
      end;
    end;
  end;

  procedure SetGraphic;
  var
    gr: TGraphic;
    MS: TMemoryStream;
  begin
    gr := TGraphicClass(ObjClass).Create;
    try
      MS := TMemoryStream.Create;
      try
        if (Length(Value) <= MAX_PATH) and FileExists(Value) then
          gr.LoadFromFile(Value)
        else
        begin
          StrToStream(Value, MS);
          gr.LoadFromStream(MS);
        end;

        TypInfo.SetObjectProp(AControl, PropName, gr);
      finally
        MS.Free;
      end;
    finally
      gr.Free;       
    end; 
  end;
  {$ENDIF UseGraphics}

begin
  PropInfo := GetPropInfo(AControl, PropName);
  if PropInfo <> nil then
  begin
    case PropType(AControl, PropName) of
      tkLString, tkString, tkWString{$IF RTLVersion >= 20.00}, tkUString{$IFEND}:
        SetStrProp(AControl, PropName, string(Value));


      tkInteger:
        if not UseOnlyStringProperties then
          SetOrdProp(AControl, PropName, Integer(Value));
      tkFloat:
        if not UseOnlyStringProperties then
          SetFloatProp(AControl, PropName, Extended(Value));
      tkEnumeration:
        if not UseOnlyStringProperties then
          SetEnumProp(AControl, PropName, string(Value));
      tkSet:
        if not UseOnlyStringProperties then
          SetSetProp(AControl, PropName, string(Value));

      tkClass:
        begin
          // Определяем, к какому классу относится свойство
          ObjClass := GetObjectPropClass(AControl, PropName);

          // Если свойство относится к списку строк, то...
          if ObjClass = TStrings then
            SetStringList;

          {$IFDEF UseGraphics}
          if ObjClass = TPicture then
            SetPicture;

          if IsRegistredGraphicFormat(ObjClass) then
            SetGraphic;
          {$ENDIF UseGraphics}
        end;
    end; // of case
  end;
end;

procedure SetFormLanguage(AForm: TComponent; LangFileName: string; IniFile: TMemIniFile);
var
  I, J: Integer;
  AList: TStringList;
  S: string;
  Vrnt: Variant;
  AControl, AChildControl: TComponent;
  TranslateList: TStringList;
  PropInfo: PPropInfo;
begin
  TranslateList := TStringList.Create;
  AList := nil;
  try
    AList := TStringList.Create;
    // Считываем содержимое секции
    IniFile.ReadSectionValues(AForm.ClassName, TranslateList);

    for I := 0 to TranslateList.Count - 1 do
    begin
      ParseString(TranslateList[I], AList, S);

      if AList.Count = 0 then Continue;
      Vrnt := S;

      AControl := AForm;
      for J := 0 to AList.Count - 2 do
      begin
        if AControl = nil then Break;
        AChildControl := AControl.FindComponent(AList[J]);

        if AChildControl = nil then
        begin
          // Если объект-компонент не найден, то
          // вероятно он является published-свойством
          PropInfo := GetPropInfo(AControl, AList[J]);
          if (PropInfo <> nil) and (PropType(AControl, AList[J]) = tkClass) then
            AChildControl := TComponent(GetObjectProp(AControl, AList[J]));

          // Если объект не найден даже как свойство, то есть еще один вариант-
          // он может быть относительно самостоятельным, но дочерним контролом
          if (AChildControl = nil) and (AControl is TControl) then
            AChildControl := TWinControl(AControl).FindChildControl(AList[J]);

          // Если объект совсем не удалось найти, то предотвращаем любые попытки
          // изменения его свойства
          if (AChildControl = nil) and (PropInfo = nil) then
            AControl := nil;
        end;

        if AChildControl = nil then Break;
        AControl := AChildControl;
      end;
      if (AControl <> nil) then
      try
        SetControlProperty(AControl, AList[AList.Count - 1], Vrnt);
      except
        on E: Exception do
          Application.MessageBox(
            PChar('Error loading file ' + LangFileName + sLineBreak +
            'Can''t set property: ' + AForm.Name + '.' + TranslateList[I] + sLineBreak +
            'Error reason: ' + E.Message),
            'Error', MB_ICONERROR);
      end
    end;

  finally
    TranslateList.Free;
    AList.Free;
  end;
end;

procedure SetLanguage(AControl: TComponent; const LangFileName: string);
var
  I: Integer;
  IniFile: TMemIniFile;
begin
  if KeepLngFiles then
    IniFile := LngManager.GetMemIniFile(LangFileName)
  else
  begin
    LngManager.Clear;
    IniFile := TMemIniFile.Create(LangFileName);
  end;      

  try
    if AControl <> nil then
      SetFormLanguage(AControl, LangFileName, IniFile)
    else
    begin
      // Меняем свойства всех форм
      for I := 0 to Screen.FormCount - 1 do
        SetFormLanguage(Screen.Forms[I], LangFileName, IniFile);

      // Меняем свойства всех модулей данных
      for I := 0 to Screen.DataModuleCount - 1 do
        SetFormLanguage(Screen.DataModules[I], LangFileName, IniFile);
    end;

  finally
    if not KeepLngFiles then
      IniFile.Free;
  end;
end;

function BufferToStr(Buffer: Pointer; BufSize: Integer): string;
var
  Bytes: PByteArray;
  I: Integer;
  S: string;
begin
  Result := '';
  if Assigned(Buffer) and (BufSize > 0) then
  begin
    SetLength(Result, BufSize * 2);
    Bytes := Buffer;
    for I := 0 to BufSize - 1 do
    begin
      S := IntToHex(Bytes[I], 2);
      Result[I * 2 + 1] := S[1];
      Result[I * 2 + 2] := S[2];
    end;
  end;
end;

function StreamToStr(AStream: TMemoryStream): string;
begin
  Result := BufferToStr(AStream.Memory, AStream.Size);
end;

procedure StrToStream(const Str: string; AStream: TMemoryStream);
var
  I: Integer;
  Bytes: PByteArray;

  function CharToByte(const AChar: Char): Byte;
  begin
    if CharInSet(AChar, ['0'..'9']) then
      Result := Ord(AChar) - Ord('0')
    else
      Result := Ord(AChar) - Ord('A') + 10;
  end;
begin
  AStream.Size := Length(Str) div 2;
  Bytes := AStream.Memory;
  for I := 1 to Length(Str) div 2 do
  begin
    Bytes[I - 1] := CharToByte(Str[I * 2 - 1]) shl 4;
    Bytes[I - 1] := Bytes[I - 1] or CharToByte(Str[I * 2]);
  end;
end;

function IsRegistredGraphicFormat(AClass: TClass): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to GraphicFormats.Count - 1 do
    if GraphicFormats.Objects[I] = TObject(AClass) then Exit;
  Result := False;
end;

{ TLockClass }

constructor TLockClass.Create;
begin
  FCriticalSection := TCriticalSection.Create;
end;

destructor TLockClass.Destroy;
begin
  FreeAndNil(FCriticalSection);
  inherited;
end;

procedure TLockClass.Lock;
begin
  FCriticalSection.Enter;
end;

procedure TLockClass.UnLock;
begin
  FCriticalSection.Leave;
end;

{ TLngFilesManager }

procedure TLngFilesManager.Clear;
var
  I: Integer;
begin
  for I := 0 to FFileList.Count - 1 do
    FFileList.Objects[I].Free;
  FFileList.Clear;
end;

constructor TLngFilesManager.Create;
begin
  inherited;
  FFileList := TStringList.Create;
end;

function TLngFilesManager.CreateMemIniFile(
  const FileName: string): Integer;
var
  MemIni: TMemIniFile;
begin
  Result := FFileList.IndexOf(FileName);
  if Result >= 0 then Exit
  else
  begin
    MemIni := TMemIniFile.Create(FileName);
    Result := FFileList.AddObject(FileName, MemIni);
  end;
end;

destructor TLngFilesManager.Destroy;
begin
  Clear;
  FFileList.Free;
  inherited;
end;

function TLngFilesManager.GetMemIniFile(const FileName: string): TMemIniFile;
var
  I: Integer;
begin
  Lock;
  try
    Result := nil;
    I := CreateMemIniFile(FileName);
    if I >= 0 then
      Result := TMemIniFile(FFileList.Objects[I]);
  finally
    UnLock;
  end; 
end;

function GenerateStringHashROT13(const S: string): Cardinal;
var
  Hash: Cardinal;
  I: Integer;
begin
  Hash := 0;

  for I := 1 to Length(S) do
  begin
    Hash := Hash + Ord(S[I]);
    Hash := Hash - ((Hash shl 13) or (Hash shr 19));
  end;

  Result := Cardinal(Hash);
end;

{ TFastMessageList }

function TFastMessageList.Add(const Key, Value: string): Integer;
var
  AHash: Cardinal;
  I: Integer;

  Item: PTextMessageItem;
begin
  AHash := GenerateStringHashROT13(Key);
  Result := -1;
  for I := 0 to Count - 1 do
    if (FList[I].tmiHash = AHash) and (Key = FList[I].tmiKey) then
    begin
      Result := I;
      Break;
    end;

  if Result < 0 then
  begin
    // Добавляем элемент в список
    if FCount = FCapacity then
      Grow;

    Result := FCount;
    Inc(FCount);
    New(Item);
    Item.tmiKey := Key;
    Item.tmiHash := AHash;
    FList[Result] := Item;
  end;

  FList[Result].tmiValue := Value;
end;

procedure TFastMessageList.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Dispose(FList[I]);
  FList := nil;
  FCount := 0;
  FCapacity := 0;
end;

destructor TFastMessageList.Destroy;
begin
  Clear;
  inherited;
end;

function TFastMessageList.GetKeyByIndex(Index: Integer): PChar;
begin
  if (Index < 0) or (Index >= Count) then
    raise Exception.Create('Wrong index');
  Result := PChar(FList[Index].tmiKey);
end;

function TFastMessageList.GetValueByIndex(Index: Integer): PChar;
begin
  if (Index < 0) or (Index >= Count) then
    raise Exception.Create('Wrong index');
  Result := PChar(FList[Index].tmiValue);
end;

function TFastMessageList.GetValueByKey(const Key: string): PChar;
var
  Index: Integer;
begin
  Result := '';
  Index := IndexOfKey(Key);
  if Index >= 0 then
    Result := PChar(FList[Index].tmiValue);
end;

procedure TFastMessageList.Grow;
begin
  if FCapacity < 50 then
    SetCapacity(50)
  else
    SetCapacity(FCapacity + FCapacity div 3);
end;

function TFastMessageList.IndexOfKey(const Key: string): Integer;
var
  AHash: Cardinal;
  I: Integer;
begin
  AHash := GenerateStringHashROT13(Key);
  for I := 0 to Count - 1 do
    if (FList[I].tmiHash = AHash) and (Key = FList[I].tmiKey) then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TFastMessageList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) then
    raise Exception.Create('Wrong capacity');
  if NewCapacity <> FCapacity then
  begin
    SetLength(FList, NewCapacity);
    FCapacity := NewCapacity;
  end;
end;

initialization
{$IFDEF UseGraphics}
  GraphicFormats := TStringList.Create;
  GraphicFormats.AddObject('TMetafile', TObject(TMetafile));
  GraphicFormats.AddObject('TIcon', TObject(TIcon));
  GraphicFormats.AddObject('TBitmap', TObject(TBitmap));
  {$IFDEF UseJPEG}
  GraphicFormats.AddObject('TJPEGImage', TObject(TJPEGImage));
  {$ENDIF UseJPEG}
{$ENDIF UseGraphics}

  LngManager := TLngFilesManager.Create;
finalization
{$IFDEF UseGraphics}
  GraphicFormats.Free;
{$ENDIF UseGraphics}
  FreeAndNil(LngManager);
end.
