{
Copyright (c) 2005-2013, Loginov Dmitry Sergeevich
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
{ Модуль matrixNNetLVQ - реализация нейронной сети LVQ                        }
{ (c) 2005 - 2010 Логинов Дмитрий Сергеевич                                   }
{ Последнее обновление: 15.12.2010                                            }
{ Адрес сайта: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{$Include MatrixCommon.inc}

unit matrixNNetLVQ;

interface

uses
  SysUtils, Classes, Matrix32, matrixNNet, Math, DateUtils;

type
  TNNetLVQ = class(TNeuronNetwork)
  private
    {Выполняет создание массивов для хранения статистики}
    procedure CreateStatArrays;
  protected
    procedure InitNetworkData; override;
  public
    {Обучение нейронной сети LVQ по стандартному алгоритму, улучшенному автором
     благодаря применению дополнительной составляющей - метода выпуклой комбинации.
     Модицицированный алгоритм под авторством Бодина О.Н. и Логинова Д.С.
     опубликован в журнале "Нейрокомпьютеры и их применение" № 6, 2008г.}
    procedure Train; override;

    {Выполняет нейросетевой анализ обученной ИНС LVQ}
    procedure Simulate(Inputs, Outputs: TMatrix); override;
    
    class function GetAlias: TSignature; override;

    {Устанавливает параметры ИНС LVQ
    InputsCount - количество входов ИНС
    HiddenLayerSize - число нейронов в скрытов слое (слое Кохонена).
      Всем нейронам автоматически присваивается значение 1 / sqrt(InputsCount)
    OutLayerParts - определяет, какая часть нейронов скрытого слоя будет
      проецироваться на нейроны выходного слоя. Количество указанных значений
      берется в качестве числа нейронов выходного слоя. Сумма указанных значений
      должна быть равной 1. Функция SetLVQParams автоматически инициализирует
      веса нейронов выходного слоя }
    procedure SetLVQParams(InputsCount, HiddenLayerSize: Integer; OutLayerParts: array of Double); overload;

    procedure SetLVQParams(InputsCount, HiddenLayerSize: Integer; OutLayerParts: TMatrix); overload;
  end;

resourcestring
  matSLVQOutErrorSum = 'Сумма значений, определяющих свойства выходного слоя сети LVQ, должна быть равной 1';
  matSLVQWrongTrainDataSize = 'Неверная размерность обучающего набора данных';

implementation

{ TNNetLVQ }

procedure TNNetLVQ.CreateStatArrays;
var
  Stat: TRecordMatrix;
begin
  Stat := TRecordMatrix.Create();

  // Вся статистика для нейронов скрытого слоя
  Layers[0].Fields['Stat'] := Stat;

  // Размеры статистических массивов должны устанавливаться в начале обучения
  // При этом массивы должны инициализироваться пустыми значениями

  // Статистика полной коррекции (Correction) нейронов для каждой эпохи обучения
  // Число строк = числу эпох обучения
  // Число столбцов = числу нейронов
  Stat.Fields['CorFull'] := TIntegerMatrix.Create();

  // Тоже самое, что и Corr, только накопительное. Всего одна строка.
  // Число столбцов = числу нейронов
  Stat.Fields['CorFullAll'] := TIntegerMatrix.Create();

  // Статистика частичной коррекции нейронов для каждой эпохи обучения
  // Число строк = числу эпох обучения
  // Число столбцов = числу нейронов
  Stat.Fields['Cor'] := TIntegerMatrix.Create();

  // Тоже самое, что и Corr, только накопительное. Всего одна строка.
  // Число столбцов = числу нейронов
  Stat.Fields['CorAll'] := TIntegerMatrix.Create();

  // Статистика отталкиваний (Repulsion) нейронов для каждой эпохи обучения
  // Число строк = числу эпох обучения
  // Число столбцов = числу нейронов
  Stat.Fields['Rep'] := TIntegerMatrix.Create();

  Stat.Fields['RepAll'] := TIntegerMatrix.Create();

  // Статистика "правильных" побед для каждой эпохи обучения
  Stat.Fields['WinTrue'] := TIntegerMatrix.Create();

  // Общее количество "правильных" побед для каждого нейрона
  Stat.Fields['WinTrueAll'] := TIntegerMatrix.Create();

  // Статистика "ложных" побед для каждой эпохи обучения
  Stat.Fields['WinFalse'] := TIntegerMatrix.Create();
end;

class function TNNetLVQ.GetAlias: TSignature;
begin
  Result := 'netlvq';
end;

procedure TNNetLVQ.InitNetworkData;
begin
  inherited;

  // ИНС LVQ состоит из 2-х слоев: скрытого и выходного
  LayersCount := 2;

  // Создаем массивы статистических данных
  CreateStatArrays;
end;

procedure TNNetLVQ.SetLVQParams(InputsCount, HiddenLayerSize: Integer;
  OutLayerParts: array of Double);
var
  Sum: Double;
  I: Integer;
  Part, CurElem, CurRow, J, HighLimit: Integer;
  W: TMatrix;
begin
  try
    Sum := 0;
    for I := 0 to High(OutLayerParts) do
    begin
      if OutLayerParts[I] >= 0 then
        Sum := Sum + OutLayerParts[I]
      else
        raise EMatrixBadParams.CreateFmt('Error value OutLayerParts[%d]=%.2f', [I, OutLayerParts[I]]);
    end;

    if Math.SameValue(Sum, 1) then
    begin
      Layers[0].Fields['W'].Resize([HiddenLayerSize, InputsCount]);

      //Инициализируем массив весов значениями 1 / sqrt(InputsCount)
      Layers[0].Fields['W'].FillByValue(1 / sqrt(InputsCount));

      W := Layers[1].Fields['W']; // Ссылка на массив весов выходного слоя

      // Устанавливаем размер массива весов выходного слоя
      W.Resize([Length(OutLayerParts), HiddenLayerSize]);
      W.Zeros; // Обнуляем все элементы

      CurElem := 0; // Текущий элемент
      CurRow := 0; // Текущая строка массива Layers[1].Fields['W']

      // Проецируем нейроны скрытого слоя на выходной слой согласно значениям,
      // заданным в массиве OutLayerParts
      for I := 0 to High(OutLayerParts) do
      begin
        // Определяем, для скольки элементов выходного слоя мы должны установить значение 1
        Part := Round(HiddenLayerSize * OutLayerParts[I]);

        if CurRow = W.Rows - 1 then // Для последней строки нужно присвоить 1 всем оставшимся элементам
          HighLimit := W.Cols - 1
        else
          HighLimit := CurElem + Part - 1;

        for J := CurElem to HighLimit do
        begin
          // Страхуемся на случай выхода за пределы массива
          // Если мы неверно спроецируем какой-нибудь нейрон, то ничего страшного.
          // Это не настолько критично, как словить AV.
          if (J < W.Cols) and (CurRow < W.Rows) then
            W.ElemI[CurRow, J] := 1;
        end;

        Inc(CurRow);
        Inc(CurElem, Part);
      end;

    end else
    begin
      raise EMatrixBadParams.Create(matSLVQOutErrorSum);
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetLVQParams'){$ENDIF}
  end;
end;

procedure TNNetLVQ.SetLVQParams(InputsCount, HiddenLayerSize: Integer;
  OutLayerParts: TMatrix);
var
  Ar: array of Double;
  I: Integer;
begin
  try
    SetLength(Ar, OutLayerParts.ElemCount);
    for I := 0 to High(Ar) do
      Ar[I] := OutLayerParts.VecElem[I];
    SetLVQParams(InputsCount, HiddenLayerSize, Ar);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetLVQParams2'){$ENDIF}
  end;
end;

procedure TNNetLVQ.Simulate(Inputs, Outputs: TMatrix);
var
  MRes, W1, W2, Z, MinIndexes: TMatrix;
  I, J, Ind: Integer;
begin
  try
    CheckForMatrixTypes([Inputs, Outputs], [mtNumeric]);

    W1 := Layers[0].Fields['W'];
    W2 := Layers[1].Fields['W'];

    // Число строк матрицы Inputs должно совпадать с числом столбцов массива весов W
    if Inputs.Rows <> W1.Cols then
      raise EMatrixBadParams(matSLVQWrongTrainDataSize);

    MRes := Outputs.CreateInstance();
    try
      MRes.Resize([W2.Rows, Inputs.Cols]);
      MRes.Zeros; // Обнуляем все элементы массива

      // Сюда будет записан результат работы функции CalcDist
      Z := TDoubleMatrix.Create(MRes);

      CalcDist(W1, Inputs, Z);

      MinIndexes := TIntegerMatrix.Create(MRes);

      // Для каждого столбца матрицы Z ищем наименьшее значение. Нам нужен его индекс
      Z.GetMinMaxMean(Z.DimRows, nil, nil, nil, nil, MinIndexes, nil);

      // Теперь есть массив индексов наименьших элементов. MinIndexes имеет
      // 1 строку и столько же столбцов, что и у входного массива Inputs
      // Устанавливаем нужные элементы массива MRes в "1"
      for I := 0 to MinIndexes.ElemCount - 1 do
      begin
        Ind := MinIndexes.VecElemI[I]; // Номер нейрона

        // Копируем весь столбец из W2
        for J := 0 to W2.Rows - 1 do
          MRes.ElemI[J, I] := W2.ElemI[J, Ind];
      end;

      Outputs.MoveFrom(MRes); // Обращаемся к объекту Outputs в самом конце
    finally
      MRes.FreeMatrix;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Simulate'){$ENDIF}
  end;
end;

procedure TNNetLVQ.Train;
var
  W1, W2, Xh, MOut, TrainErrors, QuantErrors: TMatrix;
  N, VecCnt, CurrentEpoch, h, I, Index1, Index2, Xout: Integer;
  betta, e, etta, CurrentError, Eq: Double;
  Stop, FallIntoWindow, W1IsTrue, W2IsTrue, CanRepulsion: Boolean;
  Stat: TRecordMatrix;
  BegTrainTime: TDateTime;
  TmpValue: Extended;
  PenaltyThreshold: Integer;

  procedure CalcLVQErrorAndPerfomance(W1, W2, X, T: TMatrix; var Eq, Perf: Double);
  var
    d, MinVal, MinIdx, W2Vec: TMatrix;
    h, i, NetOut, p, p1, WinNum: Integer;
  begin
    Eq := 0;

    // Определяем кол-во анализируемых векторов в X
    p := X.Cols;

    // Делитель. В случае ошибок распознавания будет уменьшаться
    p1 := p;

    d := TDoubleMatrix.Create();
    try
      MinVal := TDoubleMatrix.Create(d);
      MinIdx := TIntegerMatrix.Create(d);
      W2Vec := TIntegerMatrix.Create(d);

      W2Vec.Resize([W2.Rows]);

      //Вычисляем Эвклидово расстояние между W1 и векторами в X
      CalcDist(W1, X, d);

      // Определяем минимальные Эвклидовы расстояния и номера нейронов-победителей
      d.GetMinMaxMean(d.DimRows, MinVal, nil, nil, nil, MinIdx);

      for h := 0 to p - 1 do
      begin

        // Запоминаем номер нейрона - победителя
        WinNum := MinIdx.VecElemI[h];

        // Копируем столбец WinNum из матрицы W2
        for i := 0 to W2Vec.ElemCount - 1 do
          W2Vec.VecElemI[i] := W2.ElemI[i, WinNum];

        // Определяем выход, к которому подключен нейрон-победитель
        W2Vec.GetMinMaxValues(nil, nil, nil, @NetOut);

        // Если совпадает со значением целевого вектора T, то прибавляем к Eq
        // эвклидово расстояние от h-го вектора до нейрона победителя
        if T.ElemI[NetOut, h] = 1 then
          Eq := Eq + MinVal.VecElem[h]
        else // Иначе уменьшаем на 1 значение делителя p1
          p1 := p1 - 1
      end;
    finally
      d.FreeMatrix;
    end;

    if p1 < 1 then p1 := 1;
    Eq := Eq / p1;
    Perf := 1 - p1 / p;
  end;

  procedure CalcCurrentError;
  begin
    CalcLVQErrorAndPerfomance(W1, W2, TrainInput, TrainTarget, Eq, CurrentError);
  end;

  procedure PrepareStatArrays;
  begin
    Stat.Fields['CorFull'].Resize([Epochs, W1.Rows]);
    Stat.Fields['CorFull'].Zeros;

    Stat.Fields['CorFullAll'].Resize([1, W1.Rows]);
    Stat.Fields['CorFullAll'].Zeros;

    Stat.Fields['Cor'].Resize([Epochs, W1.Rows]);
    Stat.Fields['Cor'].Zeros;

    Stat.Fields['CorAll'].Resize([1, W1.Rows]);
    Stat.Fields['CorAll'].Zeros;

    Stat.Fields['Rep'].Resize([Epochs, W1.Rows]);
    Stat.Fields['Rep'].Zeros;

    Stat.Fields['RepAll'].Resize([1, W1.Rows]);
    Stat.Fields['RepAll'].Zeros;

    Stat.Fields['WinTrue'].Resize([Epochs, W1.Rows]);
    Stat.Fields['WinTrue'].Zeros;

    Stat.Fields['WinFalse'].Resize([Epochs, W1.Rows]);
    Stat.Fields['WinFalse'].Zeros;

    Stat.Fields['WinTrueAll'].Resize([1, W1.Rows]);
    Stat.Fields['WinTrueAll'].Zeros;

  end;

  // IsCorrection = True | False (коррекция | отталкивание)
  // IsFull = True | False (полная | частичная)
  procedure WriteToStatArrays(IsCorrection, IsFull: Boolean; Index, CurrEpoch: Integer);
  var
    S1, S2: string;
    M: TMatrix;
  begin
    if IsCorrection then
    begin
      if IsFull then  // Полная коррекция
      begin
        S1 := 'CorFull';
        S2 := 'CorFullAll';
      end else
      begin           // Частичная коррекция
        S1 := 'Cor';
        S2 := 'CorAll';
      end;
    end else
    begin             // Частичное отталкивание
      S1 := 'Rep';
      S2 := 'RepAll';
    end;

    M := Stat.Fields[S1];
    M.ElemI[CurrEpoch, Index] := M.ElemI[CurrEpoch, Index] + 1;

    M := Stat.Fields[S2];
    M.ElemI[0, Index] := M.ElemI[0, Index] + 1;
  end;

  procedure SaveWinNeuronInfo(Value: Boolean; Index: Integer);
    function GetStatTrueFalseMatrix(Value: Boolean): TMatrix;
    begin
      if Value then
        Result := Stat.Fields['WinTrue']
      else
        Result := Stat.Fields['WinFalse'];
    end;
  var
    M: TMatrix;
  begin
    M := GetStatTrueFalseMatrix(Value);
    M.ElemI[CurrentEpoch - 1, Index] := M.ElemI[CurrentEpoch - 1, Index] + 1;

    if Value then // Если нейрон победил "правильно"
    begin         // Учитываем общее количество побед
      M := Stat.Fields['WinTrueAll'];
      M.ElemI[0, Index] := M.ElemI[0, Index] + 1;
    end;
  end;

  // Отыскивает 2 нейрона из W1, наиболее близкие к Xh. Возвращает их индексы
  // Index1 и Index2. Возвращает их принадлежность к правильным классам W1IsTrue и W2IsTrue
  // Возвращает Result - результат попадания в заданное окно "e"
  function FindClosestNeuronsAndClasses(W1, W2, MOut, Xh: TMatrix; e: Double;
    CurrentEpoch, VecCnt: Integer; var Index1, Index2: Integer;
    var W1IsTrue, W2IsTrue: Boolean): Boolean;
  var
    I: Integer;
    Dm, WinTrueAll: TMatrix;
    Dm1, Dm2, WinMin: Extended;
  begin
    Dm := TDoubleMatrix.Create(Xh);
    try
      // ОПРЕДЕЛЕНИЕ РАССТОЯНИЕ МЕЖДУ Xh И КАЖДЫМ НЕЙРОНОМ ИЗ W1
      // В результате получится вектор Dm с числом элементов = W1Cnt
      CalcDist(W1, Xh, Dm);

      // Модифицируем каждый вектор в соответствие с количеством побед нейронов в прошлом
      // Следует "штрафовать" нейрон, если он СЛИШКОМ часто обучается
      WinTrueAll := Stat.Fields['WinTrueAll'];

      // Определяем нейрон с минимальным количеством побед
      WinTrueAll.GetMinMaxValues(@WinMin, nil);

      // Штрафуем нейроны, число побед которых значительно превышает количество
      // побед самого "ленивого" нейрона. Таким образом даем шанс "ленивым" нейронам.
      // Расчитываем порог штрафования PenaltyThreshold. Если значение слишком маленькое,
      // то нейроны будут выигрывать по-очереди, и ничего хорошего не будет.
      // Если значение слишком большое, то эффекта от штрафования может и не быть.
      for I := 0 to Dm.ElemCount - 1 do
        if WinTrueAll.VecElem[I] > (WinMin + Dm.ElemCount * PenaltyThreshold) then
          Dm.VecElem[I] := Dm.VecElem[I] * Max(WinTrueAll.VecElem[I], 1);


      // ОПРЕДЕЛЯЕМ 2 МИНИМАЛЬНЫХ ЭЛЕМЕНТА В Dm И ИХ ИНДЕКСЫ
      Dm.GetMinMaxValues(@Dm1, nil, @Index1, nil);

      // Устанавливаем найденному элементу заведомо большое значение
      Dm.VecElem[Index1] := 10000000;

      Dm.GetMinMaxValues(@Dm2, nil, @Index2, nil);

      // Индексы двух ближайших нейронов определены!


      // ПРОВЕРЯЕМ, ВХОДЯТ ЛИ НАЙДЕННЫЕ ВЕСА В ПРАВИЛЬНЫЙ КЛАСС
      // - ПРОВЕРЯЕМ ДЛЯ Index1. ОПРЕДЕЛЯЕМ НОМЕР ВЫХОДА ДЛЯ ТЕКУЩЕГО
      // ОБУЧАЮЩЕГО ВЕКТОРА (Т.Е. НОМЕР СТРОКИ В TrainTarget С ЭЛЕМЕНТОМ = "1")
      MOut.GetMinMaxValues(nil, nil, nil, @XOut);
      // Теперь нам известно, в какой строке массива W2 должна быть "1"
      // Если там действительно "1", значит нейрон из W1 входит
      // в правильный класс.
      W1IsTrue := W2.ElemI[Xout, Index1] = 1;

      // Сохраняем информацию о победе первого нейрона
      SaveWinNeuronInfo(W1IsTrue, Index1);


      // ПРОВЕРЯЕМ ТО ЖЕ САМОЕ ДЛЯ Index2
      W2IsTrue := W2.ElemI[Xout, Index2] = 1;

      // Сохраняем информацию о победе второго нейрона
      SaveWinNeuronInfo(W2IsTrue, Index2);



      if CurrentEpoch = 1 then // Для первой эпохи никаких окон не нужно
        Result := True
      else
      begin
        // Для последующих эпох найденные нейроны должны относится к разным классам

        //Result := W1IsTrue <> W2IsTrue;

        // Внимание! Данное условие не улучшает качество обучения!???????????
        // Первую половину времени обучения сеть идет "вразнос", но затем сходимость
        // все-равно обеспечивается.


        // Дополнительно требуется вхождение в заданное окно

        // Поскольку Dm1 и Dm2 выступают в качестве делителей, то предотвращаем
        // их равенство нулю.
        if SameValue(Dm1, 0) then
          Dm1 := 0.0000000001;
        if SameValue(Dm2, 0) then
          Dm2 := 0.0000000001;

        //if W1IsTrue <> W2IsTrue

        // ПРОВЕРЯЕМ, ВЫПОЛНЯЕТСЯ ЛИ УСЛОВИЕ
        Result := min(Dm1 / Dm2, Dm2 / Dm1) > ((1 - e) / (1 + e));
                                               // 0.6666666666     //0.53?
        // Другими словами: условие выполняется, если разница между Dm1 и Dm2
        // существенная (более чем в 2 раза)
        // Условие НЕ ВЛИЯЕТ на качество обучения, однако оно СИЛЬНО влияет на
        // скорость обучения (в 10-ки и 100-ни раз).

      end;
    finally
      Dm.FreeMatrix;
    end;
  end;

  procedure DoAttraction(W1, Xh: TMatrix; N, Index, CurrentEpoch: Integer; etta: Double; IsFull: Boolean);
  var
    I: Integer;
    TmpValue: Extended;
  begin
    for I := 0 to N - 1 do
    begin
      TmpValue := W1.Elem[Index, I];
      // Если предыдущий нейрон - коррекция то делаем небольшую коррекцию
      if IsFull then // делаем полную коррекцию
        W1.Elem[Index, I] := TmpValue + etta * (Xh.VecElem[I] - TmpValue)
      else // Иначе делаем частичную коррекцию
        W1.Elem[Index, I] := TmpValue + etta * (Xh.VecElem[I] - TmpValue) * 0.1
    end;

    // Заполняем статистический массив коррекции
    WriteToStatArrays(True, IsFull, Index, CurrentEpoch - 1);
  end;

  procedure DoRepulsion(W1, Xh: TMatrix; N, Index, CurrentEpoch: Integer; etta: Double);
  var
    I: Integer;
    TmpValue: Extended;
  begin
    for I := 0 to N - 1 do
    begin
      TmpValue := W1.Elem[Index, I];

      // Данная формула "отталкивания" не соответствует формуле Кохонена,
      // однако при таком подходе сходимость - ГАРАНТИРОВАНА
      W1.Elem[Index, I] := TmpValue - etta * (Xh.VecElem[I] + TmpValue) * 0.2;
    end;

    // Заполняем статистический массив отталкивания
    WriteToStatArrays(False, True, Index, CurrentEpoch - 1);
  end;

begin
  try
    Stop := False;

    // Запоминаем время начала обучения
    BegTrainTime := Now;

    Fields['Trained'].Value := 0;

    TrainErrors := TDoubleMatrix.Create();
    Fields['TrainErrors'] := TrainErrors; // Ошибка обучения

    QuantErrors := TDoubleMatrix.Create();
    Fields['QuantErrors'] := QuantErrors; // Ошибка квантования

    // Запоминаем порог штрафования
    PenaltyThreshold := Fields['TrainDataInfo'].Fields['PenaltyThreshold'].ValueI;

    // ВЕСА НЕЙРОНОВ СКРЫТОГО СЛОЯ
    // W1.Cols = число входов каждого нейрона
    // W1.Rows = число нейронов скрытого слоя
    W1 := Layers[0].Fields['W'];

    // ВЕСА НЕЙРОНОВ ВЫХОДНОГО СЛОЯ
    W2 := Layers[1].Fields['W'];

    // Массив статистических данных
    Stat := TRecordMatrix(Layers[0].Fields['Stat']);

    // Подготовливаем статистические массивы для нейронов скрытого слоя
    PrepareStatArrays;

    // МОНОТОННО ВОЗРАСТАЮЩАЯ ФУНКЦИЯ, МЕНЯЮЩАЯСЯ ОТ 0 ДО 1 ПО МЕРЕ ОБУЧЕНИЯ
    // НА КАЖДОЙ ЭПОХЕ УВЕЛИЧИВАЕТСЯ НА ВЕЛИЧИНУ = 1/epochs
    betta := 0;

    // КОНСТАНТА, ВЫБИРАЕМАЯ ИЗ ДИАПАЗОНА ОТ 0.2 ДО 0.3
    e := 0.2;

    // МОНОТОННО УБЫВАЮЩАЯ ФУНКЦИЯ, МЕНЯЮЩАЯСЯ ОТ 1 ДО 0.2 ПО МЕРЕ ОБУЧЕНИЯ
    // НА КАЖДОЙ ЭПОХЕ УМЕНЬШАЕТСЯ НА ВЕЛИЧИНУ = (1 - 0.2)/epochs
    etta := 1;

    // ЧИСЛО ВХОДОВ НС
    N := TrainInput.Rows;

    // Проверяем, правильно ли задан обучающий набор данных
    if (N <> W1.Cols) or (W2.Rows <> TrainTarget.Rows) then
      raise EMatrixBadParams.Create(matSLVQWrongTrainDataSize);

    // КОЛ-ВО ОБУЧАЮЩИХ ВЕКТОРОВ
    VecCnt := TrainInput.Cols;

    // ПРИСВАИВАЕМ ВСЕМ ВЕСАМ СЛОЯ КОХОНЕНА ОДИНАКОВОЕ ЗНАЧЕНИЕ
    // W1(:,:) = 1 / sqrt(N); - не нужно! Это было сделано при создании ИНС LVQ

    CurrentEpoch := 0;


    Xh := TDoubleMatrix.Create(); // Будем хранить текущий вектор-столбец
    try
      Xh.Resize([N, 1]);

      MOut := TDoubleMatrix.Create(Xh); // Вектор. Хранит h-й столбец массива TrainTarget

      MOut.Resize([TrainTarget.Rows, 1]);

      TrainErrors.Resize([Epochs]); // Вектор ошибок обучения
      TrainErrors.Zeros;

      QuantErrors.Resize([Epochs]); // Вектор ошибок квантования
      QuantErrors.Zeros;

      CalcCurrentError; // Вычисляем ошибку обучения

      // Осуществляем вызов функции OnProgress - сообщаем о начале обучения
      if Assigned(OnProgress) then
        OnProgress(Self, Goal, CurrentError, Eq, Epochs, 0, Stop);

      // Досрочное завершение процедуры обучения по требованию пользователя
      // Это нормальная ситуация, поэтому не нужно генерировать никаких исключений
      if Stop then Exit;

      // Цикл по эпохам. Всего итераций = Epochs
      while CurrentEpoch < Epochs do
      begin
        Inc(CurrentEpoch);

        betta := betta + 1/epochs;

        // ВЫБИРАЕМ ОЧЕРЕДНОЙ ВЕКТОР Xh ИЗ ОБУЧАЮЩЕЙ ВЫБОРКИ
        for h := 0 to VecCnt - 1 do
        begin
          // Копируем элементы очередного обучающего вектора в Xh одновременно с
          // преобразованием элементов согласно метода выпусклой комбинации
          // Convex Combination
          for I := 0 to N - 1 do
          begin
            TmpValue := TrainInput.Elem[I, h];
            Xh.VecElem[I] := betta * TmpValue + (1 - betta) / sqrt(N);
          end;

          // Запоминаем соответствующий h-й целевой вектор
          for I := 0 to TrainTarget.Rows - 1 do
            MOut.VecElem[I] := TrainTarget.Elem[I, h];

          // Отталкивание на первой эпохе НЕДОПУСТИМО
          CanRepulsion := CurrentEpoch > 1;

          // Определяем индексы наиболее близких нейронов и их принадлежность
          // к соответствующим классам
          FallIntoWindow := FindClosestNeuronsAndClasses(
            W1, W2, MOut, Xh, e, CurrentEpoch, VecCnt, // Входные параметры
            Index1, Index2, W1IsTrue, W2IsTrue);       // Выходные параметры

          // Если попадает в заданное окно...
          if FallIntoWindow then
          begin

            // ЕСЛИ ВХОДИМ В ПРАВИЛЬНЫ КЛАСС, ТО ВЫПОЛНЯЕМ ПОЛНУЮ КОРРЕКЦИЮ
            if W1IsTrue then
            begin
              DoAttraction(W1, Xh, N, Index1, CurrentEpoch, etta, True);
            end else // ИНАЧЕ ВЫПОЛНЯЕМ ОТТАЛКИВАНИЕ (Repulsion)
            begin
              if CanRepulsion then // Не допускаем отторжение на первой эпохе
              begin
                DoRepulsion(W1, Xh, N, Index2, CurrentEpoch, etta);
              end;
            end;

            // ЕСЛИ ВХОДИМ В ПРАВИЛЬНЫ КЛАСС, ТО ВЫПОЛНЯЕМ КОРРЕКЦИЮ (полную или частичную)
            if W2IsTrue then
            begin
              DoAttraction(W1, Xh, N, Index2, CurrentEpoch, etta, not W1IsTrue);
            end else
            begin // ИНАЧЕ ВЫПОЛНЯЕМ ОТТАЛКИВАНИЕ (Repulsion)
              if CanRepulsion then
              begin
                DoRepulsion(W1, Xh, N, Index2, CurrentEpoch, etta);
              end;
            end;
          end; // if FallIntoWindow
        end; // for h := 1 to VecCnt do

        // ВСЕ ОБУЧАЮЩИЕ ВЕКТОРА ПЕРЕБРАЛИ. ОЧЕРЕДНАЯ ЭПОХА ОБУЧЕНИЯ ЗАКОНЧЕНА
        // ТЕПЕРЬ НУЖНО РАСЧИТАТЬ ПОГРЕШНОСТЬ ОБУЧЕНИЯ


        // Расчитываем ошибку обучения (ошибка квантования)
        // В простейшем случае - расчитываем количество входных векторов, которые
        // были проанализированы с ошибкой.
        CalcCurrentError;

        // Запоминаем текущую ошибку обучения
        TrainErrors.VecElem[CurrentEpoch - 1] := CurrentError;

        // Запоминаем текущую ошибку квантования
        QuantErrors.VecElem[CurrentEpoch - 1] := Eq;

        // КОРРЕКТИРОВКА ПЕРЕМЕННОЙ etta
        etta := etta - (1 - 0.2) / epochs;

        if Assigned(OnProgress) then
          OnProgress(Self, Goal, CurrentError, Eq, Epochs, CurrentEpoch, Stop);

        if Stop then Exit;
      end; // for CurrentEpoch

      // Отмечаем, что НС полностью обучена
      Fields['Trained'].Value := 1;

      with TCharMatrix.Create() do
      begin
        AsString := DateTimeToStr(Now);
        ThisNetwork.Fields['EndTrainTime'] := ThisMatrix;
      end;

      with TIntegerMatrix.Create() do
      begin
        Value := SecondsBetween(Now, BegTrainTime);
        ThisNetwork.Fields['TrainSecondCount'] := ThisMatrix;
      end;

      with TDoubleMatrix.Create() do
      begin
        Value := CurrentError;
        ThisNetwork.Fields['TrainError'] := ThisMatrix;
      end;

      with TDoubleMatrix.Create() do
      begin
        Value := Eq;
        ThisNetwork.Fields['QuantError'] := ThisMatrix;
      end;


    finally
      try
        CalcCurrentError;
        if Assigned(OnProgress) then
          OnProgress(Self, Goal, CurrentError, Eq, Epochs, CurrentEpoch, Stop);
      finally
        // Уничтожаем Xh и все временные массивы
        Xh.FreeMatrix;
      end;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Train'){$ENDIF}
  end;
end;

end.
