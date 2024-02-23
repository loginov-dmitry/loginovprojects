{$IFDEF FPC}
{$MODE DELPHI}{$H+}{$CODEPAGE UTF8}
{$ENDIF}

{ *************************************************************************** }
{                                                                             }
{                                                                             }
{                                                                             }
{ Модуль matrixNNetLVQ - реализация нейронной сети LVQ                        }
{ (c) 2005 - 2009 Логинов Дмитрий Сергеевич                                   }
{ Последнее обновление: 11.06.2009                                            }
{ Адрес сайта: http://matrix.kladovka.net.ru/                                 }
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
  W1, W2, Xh, Dm, MOut, SumOut, Vec1, Vec2, TrainErrors: TMatrix;
  N, VecCnt, CurrentEpoch, h, I, Index1, Index2, Xout: Integer;
  betta, e, etta, CurrentError: Double;
  Dm1, Dm2, Dm12, TmpValue: Extended;
  Stop, cond1, W1IsTrue, W2IsTrue, CanRepulsion: Boolean;
  Stat: TRecordMatrix;
  BegTrainTime: TDateTime;

  procedure CalcCurrentError;
  var
    h, I: Integer;
  begin
    CurrentError := 0;
    Simulate(TrainInput, SumOut);

    // Каждый столбец массива SumOut должен совпадать с TrainTarget
    for h := 0 to VecCnt - 1 do
    begin
      for I := 0 to TrainTarget.Rows - 1 do
      begin
        if SumOut.ElemI[I, h] <> TrainTarget.ElemI[I, h] then
        begin
          CurrentError := CurrentError + 1;
          Break; // Переходим к следующему вектору
        end;
      end;
    end;

    CurrentError := CurrentError / TrainInput.Cols;
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

begin
  try
    Stop := False;

    BegTrainTime := Now;

    Fields['Trained'].Value := 0;

    TrainErrors := TDoubleMatrix.Create();
    Fields['TrainErrors'] := TrainErrors;

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

      Vec1 := TDoubleMatrix.Create(Xh); // Для временного хранения весов нейрона победителя 1
      Vec1.Resize([1, N]);
      Vec2 := TDoubleMatrix.Create(Xh); // Для временного хранения весов нейрона победителя 2
      Vec2.Resize([N, 1]);

      Dm := TDoubleMatrix.Create(Xh); // Вектор Эвклидовых расстояний
      MOut := TDoubleMatrix.Create(Xh); // Вектор. Хранит h-й столбец массива TrainTarget

      MOut.Resize([TrainTarget.Rows, 1]);

      TrainErrors.Resize([Epochs]); // Вектор ошибок обучения
      TrainErrors.Zeros;

      SumOut := TDoubleMatrix.Create(Xh); // Будет использоваться при расчете целевой функции

      CalcCurrentError; // Вычисляем ошибку обущения

      // Осуществляем вызов функции OnProgress - сообщаем о начале обучения
      if Assigned(OnProgress) then
        OnProgress(Self, Goal, CurrentError, Epochs, 0, Stop);

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
          for I := 0 to N - 1 do
          begin
            TmpValue := TrainInput.Elem[I, h];
            Xh.VecElem[I] := betta * TmpValue + (1 - betta) / sqrt(N);
          end;

          // Запоминаем соответствующий h-й целевой вектор
          for I := 0 to TrainTarget.Rows - 1 do
            MOut.VecElem[I] := TrainTarget.Elem[I, h];

          // ОПРЕДЕЛЕНИЕ РАССТОЯНИЕ МЕЖДУ Xh И КАЖДЫМ НЕЙРОНОМ ИЗ W1
          // В результате получится вектор Dm с числом элементов = W1Cnt
          CalcDist(W1, Xh, Dm);

          // ОПРЕДЕЛЯЕМ 2 МИНИМАЛЬНЫХ ЭЛЕМЕНТА В Dm И ИХ ИНДЕКСЫ
          Dm.GetMinMaxValues(@Dm1, nil, @Index1, nil);

          // Устанавливаем найденному элементу заведомо большое значение
          Dm.VecElem[Index1] := 10000000;

          Dm.GetMinMaxValues(@Dm2, nil, @Index2, nil);

          // Поскольку Dm1 и Dm2 выступают в качестве делителей, то предотвращаем
          // их равенство нулю.
          if SameValue(Dm1, 0) then
            Dm1 := 0.0000000001;
          if SameValue(Dm2, 0) then
            Dm2 := 0.0000000001;

          // =Определяем расстояние между найденными нейронами (29-10-2010) =
          // Копируем веса 1-го и 2-го нейрона победителя в Vec1 и Vec2
          for I := 0 to N - 1 do
          begin
            Vec1.VecElem[I] := W1.Elem[Index1, I];
            Vec2.VecElem[I] := W1.Elem[Index2, I];
          end;
          CalcDist(Vec1, Vec2, Dm);
          Dm12 := Dm.VecElem[0];
          if SameValue(Dm12, 0) then
            Dm12 := 0.0000000001;

          // ПРОВЕРЯЕМ, ВЫПОЛНЯЕТСЯ ЛИ УСЛОВИЕ
          cond1 := min(Dm1 / Dm12, Dm2 / Dm1) > ((1 - e) / (1 + e));
                                                 // 0.6666666666     //0.53?
          // Другими словами: условие выполняется, если разница между Dm1 и Dm2
          // существенная (более чем в 2 раза)
          // Условие НЕ ВЛИЯЕТ на качество обучения, однако оно СИЛЬНО влияет на
          // скорость обучения (в 10-ки и 100-ни раз).

          //cond1 := True; // TODO: нужен ли этот критерий на самом деле?

          if cond1 then
          begin
            // ПРОВЕРЯЕМ, ВХОДЯТ ЛИ НАЙДЕННЫЕ ВЕСА В ПРАВИЛЬНЫЙ КЛАСС
            // - ПРОВЕРЯЕМ ДЛЯ Index1. ОПРЕДЕЛЯЕМ НОМЕР ВЫХОДА ДЛЯ ТЕКУЩЕГО
            // ОБУЧАЮЩЕГО ВЕКТОРА (Т.Е. НОМЕР СТРОКИ В TrainTarget С ЭЛЕМЕНТОМ = "1")
            MOut.GetMinMaxValues(nil, nil, nil, @XOut);
            // Теперь нам известно, в какой строке массива W2 должна быть "1"
            // Если там действительно "1", значит нейрон из W1 входит
            // в правильный класс.

            W1IsTrue := W2.ElemI[Xout, Index1] = 1;

            CanRepulsion := CurrentEpoch > 1;

            // ЕСЛИ ВХОДИМ В ПРАВИЛЬНЫ КЛАСС, ТО ВЫПОЛНЯЕМ ПОЛНУЮ КОРРЕКЦИЮ
            if W1IsTrue then
            begin
              for I := 0 to N - 1 do
              begin
                TmpValue := W1.Elem[Index1, I];
                W1.Elem[Index1, I] := TmpValue + etta * (Xh.VecElem[I] - TmpValue);
              end;

              // Заполняем статистический массив коррекции
              WriteToStatArrays(True, True, Index1, CurrentEpoch - 1);
            end else
            begin
              if CanRepulsion then // Не допускаем отторжение на первой эпохе
              begin
                for I := 0 to N - 1 do
                begin
                  TmpValue := W1.Elem[Index1, I];
                  W1.Elem[Index1, I] := TmpValue - etta * (Xh.VecElem[I] + TmpValue) * 0.2;
                end;

                // Заполняем статистический массив отталкивания
                WriteToStatArrays(False, True, Index1, CurrentEpoch - 1);
              end;
            end;

            // ПРОВЕРЯЕМ ТО ЖЕ САМОЕ ДЛЯ Index2
            W2IsTrue := W2.ElemI[Xout, Index2] = 1;

            // ЕСЛИ ВХОДИМ В ПРАВИЛЬНЫ КЛАСС, ТО ВЫПОЛНЯЕМ КОРРЕКЦИЮ (полную или частичную)
            if W2IsTrue then
            begin
              for I := 0 to N - 1 do
              begin
                TmpValue := W1.Elem[Index2, I];
                // Если предыдущий нейрон - коррекция то делаем небольшую коррекцию
                if W1IsTrue then
                  W1.Elem[Index2, I] := TmpValue + etta * (Xh.VecElem[I] - TmpValue) * 0.1
                else // Иначе делаем полную коррекцию
                  W1.Elem[Index2, I] := TmpValue + etta * (Xh.VecElem[I] - TmpValue)
              end;

              // Заполняем статистический массив коррекции
              WriteToStatArrays(True, not W1IsTrue, Index2, CurrentEpoch - 1);
            end else
            begin // ИНАЧЕ ВЫПОЛНЯЕМ ОТТАЛКИВАНИЕ (Repulsion)
              if CanRepulsion then
              begin
                for I := 0 to N - 1 do
                begin
                  TmpValue := W1.Elem[Index2, I];
                  W1.Elem[Index2, I] := TmpValue - etta * (Xh.VecElem[I] + TmpValue) * 0.2;
                end;

                // Заполняем статистический массив отталкивания
                WriteToStatArrays(False, True, Index2, CurrentEpoch - 1);
              end;
            end;

          end; // if cond1
        end; // for h := 1 to VecCnt do

        // ВСЕ ОБУЧАЮЩИЕ ВЕКТОРА ПЕРЕБРАЛИ. ОЧЕРЕДНАЯ ЭПОХА ОБУЧЕНИЯ ЗАКОНЧЕНА
        // ТЕПЕРЬ НУЖНО РАСЧИТАТЬ ПОГРЕШНОСТЬ ОБУЧЕНИЯ


        // Расчитываем ошибку обучения (ошибка квантования)
        // В простейшем случае - расчитываем количество входных векторов, которые
        // были проанализированы с ошибкой.
        CalcCurrentError;

        // Запоминаем текущую ошибку обучения
        TrainErrors.VecElem[CurrentEpoch - 1] := CurrentError;

        // TODO: исключительно в целях отладки!!! Удалить!!!
        //try
        //Stat.SaveToBinaryFile('C:\TEMP\LVQStat.bin', 'Stat');
        //except
        //end;


        // КОРРЕКТИРОВКА ПЕРЕМЕННЫХ etta, betta
        etta := etta - (1 - 0.2)/epochs;

        if Assigned(OnProgress) then
          OnProgress(Self, Goal, CurrentError, Epochs, CurrentEpoch, Stop);

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


    finally
      try
        CalcCurrentError;
        if Assigned(OnProgress) then
          OnProgress(Self, Goal, CurrentError, Epochs, CurrentEpoch, Stop);
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
