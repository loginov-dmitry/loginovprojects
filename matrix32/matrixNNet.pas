{$IFDEF FPC}
{$MODE DELPHI}{$H+}{$CODEPAGE UTF8}
{$ENDIF}

{ *************************************************************************** }
{                                                                             }
{                                                                             }
{                                                                             }
{ Модуль matrixNNet - сборник функций для работы с нейронными сетями (ИНС)    }
{ (c) 2005 - 2009 Логинов Дмитрий Сергеевич                                   }
{ Последнее обновление: 11.06.2009                                            }
{ Адрес сайта: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{$Include MatrixCommon.inc}
 
unit matrixNNet;

interface

uses
  SysUtils, Classes, Matrix32;

type
  {Абстрактный класс, от которого наследуются другие нейросетевые структуры}
  TNeuronNetwork = class;

  {Объявление функции, которая периодически вызывается в процессе обучения
   нейронной сети. ANetwork - нейронная сеть. Goal - пороговое значение,
   которое при обучении сеть стремиться достичь. CurrentError - текущее значение
   ошибки обучения сети. Epochs - максимальное количество эпох обучения.
   CurrentEpoch - номер текущей эпохи обучения (начинается с 1).
   Если вы хотите использовать данную функцию вне класса, то не забудьте
   добавить в качестве первого параметра любое 4-байтное значение (например,
   Pointer), только так вы обеспечите правильный порядок вызовов}
  TTrainingProgressFunc = procedure(ANetwork: TNeuronNetwork;
    const Goal, CurrentError: Extended; Epochs, CurrentEpoch: Integer; var Stop: Boolean) of object;

  EMatrixNetworkError = EMatrixError;

  {Нейронная сеть, основанная на движке Matrix32. Является полноценным объектом
   TMatrix, поддерживает все возможности класса TRecordMatrix. Абсолютно все
   данные нейронной сети хранятся в объектах TMatrix. Это немного усложняет код,
   однако обеспечивает возможность работы с потоками и файлами. Благодаря этому
   вы можете сохранить всю ИНС в файл или поток, а в нужный момент загрузить ее.
   TNeuronNetwork - абстрактрый класс. Вы должны пользоваться его потомками.}
  TNeuronNetwork = class(TRecordMatrix) // abstract!!!
  private
    {Созданный объект содержит следующие поля:
     Layers: TCellMatrix - информация по каждому слою. Каждая ячейча это объект
           TRecordMatrix. Включает в себя:
             W: TDoubleMatrix - массив весов нейронов данного слоя
     Trained: TByteMatrix - 1 если сеть обучена, 0 - есле не обучена
     Epochs: максимальное количество эпох обучения
     Goal: цель обучения. Минимальная погрешность, при достижении которой
           сеть останавливает свое обучение
     TrainInput: TDoubleMatrix - обучающий входной набор данных. Каждый столбец -
           это один обучающий вектор. Число строк - это число входов в ИНС
     TrainTarget: TDoubleMatrix - обучающий целевой набор данных. Число столбцов в TrainTarget
           равно числу столбцов в TrainInput. Число строк в TrainTarget равно
           числу выходов ИНС}

    {Векторный массив ячеек, каждый элемент которого является ссылкой на
     объект TRecordMatrix, в котором хранится вся необходимая информация по
     соответствующему слою. Для доступа с данным слоя используется следующая
     запись: Layers[Index]}
    FLayers: TCellMatrix;

    FOnProgress: TTrainingProgressFunc;

    function GetIsTrained: Boolean;
    function GetLayersCount: Integer;
    procedure SetLayersCount(const Value: Integer);
    function GetLayers(Index: Integer): TRecordMatrix;
    function GetEpochs: Integer;
    procedure SetEpochs(const Value: Integer);
    function GetGoal: Extended;
    procedure SetGoal(const Value: Extended);
    function GetTrainInput: TMatrix;
    function GetTrainTarget: TMatrix;
  protected
    {Процедура инициализации объекта. Она реализуется вместо конструктора}
    procedure Init; override;

    {Создает основные массивы и структуры TMatrix. Вызывается из Init}
    procedure InitNetworkData; virtual;
  public
    {Не перекрываем функцию GetAlias, для того, чтобы пользователь не смог
     создать объект абстрактного класса TNeuronNetwork}
    //class function GetAlias: TSignature; override;

    {Выполняет обучение нейронной сети. В потомках данный метод должен перекрываться
     с директивой override}
    procedure Train; virtual;

    {Осуществляем прогон обученной нейронной сети. На вход подается массив Inputs.
     Результат работы ИНС будет записан в массив Outputs. В потомках данный метод
     должен перекрываться с директивой override.
     Матрица Inputs может содержать несколько столбцов. Столько же столбцов
     будет в массиве Outputs}
    procedure Simulate(Inputs, Outputs: TMatrix); virtual;

    {Доступ к данным указанного слоя ИНС}
    property Layers[Index: Integer]: TRecordMatrix read GetLayers;

    {Максимальное количество эпох обучения}
    property Epochs: Integer read GetEpochs write SetEpochs;

    {Цель (минимальная ошибка) обучения}
    property Goal: Extended read GetGoal write SetGoal;

    {Обучающий входной набор данных}
    property TrainInput: TMatrix read GetTrainInput;

    {Обучающий целевой набор данных}
    property TrainTarget: TMatrix read GetTrainTarget;

    {Массив слоев ИНС}
    property LayersArray: TCellMatrix read FLayers;

    {С помощью этого свойства можно узнать или изменить число слоев в ИНС.
     Входы ИНС не относятся к слоям ИНС! }
    property LayersCount: Integer read GetLayersCount write SetLayersCount;

    {Определяет, обучена ли ИНС в даннй момент}
    property IsTrained: Boolean read GetIsTrained;

    {Возвращает Self. Можно использовать внутри блока WITH}
    function ThisNetwork: TNeuronNetwork;

    {Функция вызывается периодически в процессе обучения ИНС (после каждой эпохи обучения)}
    property OnProgress: TTrainingProgressFunc read FOnProgress write FOnProgress;
  end;

{Вычисляет Евклидово расстояние между весами нейросети
 W - веса, P - входы НС, Z - результат. Формула: z = -sqrt(sum((w-p)^2))
 Каждая строка массива весов описывает один нейрон. Соответственно число
 элементов в строке есть число входов нейрона, и оно должно соответствовать
 числу строк массива анализируемых данных Р. Каждый столбец массива Р есть
 изолированный входной вектор. Таких векторов может быть множество.}
procedure CalcDist(W, P, Z: TMatrix);

{Вычисляет отрицательное Евклидово расстояние}
procedure CalcNegDist(W, P, Z: TMatrix);

{Функция вычисляет среднеквадратичную ошибку. Соответствует формату
 TPerformFunction. Параметры XMatrix и PPMatrix игнорируются}
function CalcMSE(EMatrix: TMatrix;
  XMatrix: TMatrix = nil; PPMatrix: TMatrix = nil): Extended;

{perform - функция. В качестве EMatrix может выступать как числовой массив,
 так и массив ячеек. В качестве XMatrix может выступать как числовой вектор,
 так и нейронная сеть. Если в качестве XMatrix задать нейронную сеть, то
 параметр PPMatrix игнорируется
 TODO : Функция CalcMSEReg еще не реализована}
function CalcMSEReg(EMatrix: TMatrix;
  XMatrix: TMatrix; PPMatrix: TMatrix = nil): Extended;

{Передаточная функия. Осуществляет мягкое шкалирование.}
procedure CalcSoftMax(AMatrix, AResult: TMatrix);

{Передаточная функия. Выступает в роле заглушки. Возвращает на выходе то,
 что в нее было передано на входе}
procedure CalcPurelin(AMatrix, AResult: TMatrix);

{Передаточная функия. Logarithmic sigmoid transfer function.
 Формула: logsig(n) = 1 / (1 + exp(-n))}
procedure CalcLogSig(AMatrix, AResult: TMatrix);

{Передаточная функия.  Hyperbolic tangent sigmoid transfer function.
 Формула: n = 2/(1+exp(-2*n))-1}
procedure CalcTanSig(AMatrix, AResult: TMatrix);

{Передаточная функия.  Действует по правилу:
  | 1 для Value >= 0
  | 0 для Value < 0}
procedure CalcSign(AMatrix, AResult: TMatrix);

const
  {Максимальное число входов НС}
  MaxInputsCount = 100000;

resourcestring
  matSFuncNotFound = 'Функция с именем "%s" не найдена';
  matSWrongInputsCount = 'Указано неверное число входов нейронной сети';
  matSWrongRangeSize = 'Матрица ограничений значений входов НС имеет недопустимые размеры';


implementation

uses Math;   

procedure CalcDist(W, P, Z: TMatrix);
var
  I, J, K: Integer;
  Buf: Extended;
begin
  try
    if W.Cols <> P.Rows then
      raise Exception.Create(matSArraysNotAgree);

    // Инициализируем выходной массив Z, у которого число строк должно
    // соответствовать числу нейронов (W.Rows), а число столбцов должно
    // равняться кол-во входных векторов (P.Cols)
    Z.Resize([W.Rows, P.Cols]);

    for I := 0 to W.Rows - 1 do     // Перебор нейронов
      for K := 0 to P.Cols - 1 do   // Перебор входных векторов
      begin
        Buf := 0;
        for J := 0 to W.Cols - 1 do // Перебор входов рассматриваемого слоя
          Buf := Buf + Sqr(W.Elem[I, J] - P.Elem[J, K]);

        Z.Elem[I, K] := Sqrt(Buf);
      end;    

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcDist'){$ENDIF}
  end;
end;

procedure CalcNegDist(W, P, Z: TMatrix);
begin
  try
    CalcDist(W, P, Z);
    Z.ValueOperation(0, Z, opSub);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcNegDist'){$ENDIF}
  end;
end;

function CalcMSE(EMatrix, XMatrix, PPMatrix: TMatrix): Extended;
var
  I, J: Integer;
  Elements: Integer;
  ACell: TMatrix;
begin
  try
    if not (EMatrix.IsNumeric or EMatrix.IsCell) then
      raise EMatrixWrongElemType.CreateFmt(
        masSIsBadClassForOperation, [EMatrix.ClassName]);

    Result := 0;
    if EMatrix.IsNumeric then
    begin
      for I := 0 to EMatrix.ElemCount - 1 do
        Result := Result + Sqr(EMatrix.VecElem[I]);
      Result := Result / EMatrix.ElemCount;
    end else // IsCell
    begin
      Elements := 0;
      for I := 0 to EMatrix.ElemCount - 1 do
        if EMatrix.VecCells[I] <> nil then
        begin
          ACell := EMatrix.VecCells[I];
          for J := 0 to ACell.ElemCount - 1 do
            Result := Result + Sqr(ACell.VecElem[J]);
          Elements := Elements + ACell.ElemCount;
        end;    
      Result := Result / Elements;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function CalcMSE'){$ENDIF}
  end;
end;

function CalcMSEReg(EMatrix: TMatrix;
  XMatrix: TMatrix; PPMatrix: TMatrix = nil): Extended;
var
  TempPP: TMatrix;
begin
  {В Матлабе про параметр PPMatrix сказано следующее:
   PP - Performance parameter.
     where PP defines one performance parameter,
   PP.ratio - Relative importance of errors vs. weight and bias values.
     and returns the sum of mean squared errors (times PP.ratio) with the
     mean squared weight and bias values (times 1-PP.ratio).}
  try
    Result := 0;
    if XMatrix = nil then
      EMatrixNetworkError.Create(matSBadInputData);

    TempPP := TRecordMatrix.Create();
    try
     { if XMatrix.IsRecord then // Если запись или нейронная сеть
        TempPP.CopyByRef(XMatrix.Fields['performParam'])
      else
        TempPP.CopyByRef(PPMatrix);}
    finally
      TempPP.FreeMatrix;
    end;


  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function CalcMSEReg'){$ENDIF}
  end;
end;


procedure CalcSoftMax(AMatrix, AResult: TMatrix);
var
  Expn, Denom: TMatrix;
  I, J: Integer;
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);
    Expn := TExtendedMatrix.Create();
    Denom := TExtendedMatrix.Create(Expn);
    try
      // Вычисляем экспоненту
      Expn.CalcFunction(AMatrix, fncExp);
      // Суммируем строки матрицы
      Denom.DimOperation(Expn, Expn.DimRows, opSum);

      Denom.ValueOperation(1, Denom, opDiv);

      // Каждую строку матрицы Expn поэлементно умножаем на Denom
      for I := 0 to Expn.Rows - 1 do
        for J := 0 to Expn.Cols - 1 do
          Expn.Elem[I, J] := Expn.Elem[I, J] * Denom.VecElem[J];

      AResult.MoveFrom(Expn);
    finally
      Expn.FreeMatrix;
    end;     
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcSoftMax'){$ENDIF}
  end;
end;

procedure CalcPurelin(AMatrix, AResult: TMatrix);
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);
    AResult.CopyFrom(AMatrix);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcPurelin'){$ENDIF}
  end;
end;

procedure CalcLogSig(AMatrix, AResult: TMatrix);
var
  TempMatrix: TMatrix;
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);

    TempMatrix := TExtendedMatrix.Create();
    try
      TempMatrix.CalcFunction(AMatrix, fncNeg);
      TempMatrix.CalcFunction(TempMatrix, fncExp);
      TempMatrix.ValueOperation(1, TempMatrix, opSum);
      TempMatrix.ValueOperation(1, TempMatrix, opDiv);

      AResult.MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcLogSig'){$ENDIF}
  end;
end;

procedure CalcTanSig(AMatrix, AResult: TMatrix);
var
  TempMatrix: TMatrix;
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);

    TempMatrix := TExtendedMatrix.Create();
    try
      TempMatrix.ValueOperation(-2, AMatrix, opMul);
      TempMatrix.CalcFunction(TempMatrix, fncExp);
      TempMatrix.ValueOperation(1, TempMatrix, opSum);
      TempMatrix.ValueOperation(2, TempMatrix, opDiv);
      TempMatrix.ValueOperation(TempMatrix, 1, opSub);
      AResult.MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcTanSig'){$ENDIF}
  end;
end;

procedure CalcSign(AMatrix, AResult: TMatrix);
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);
    AResult.CalcFunction(AMatrix, fncSign);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcSign'){$ENDIF}
  end;
end;

{ TNeuronNetwork }

function TNeuronNetwork.ThisNetwork: TNeuronNetwork;
begin
  Result := Self;
end;

function TNeuronNetwork.GetIsTrained: Boolean;
begin
  Result := Fields['Trained'].Value = 1;
end;

function TNeuronNetwork.GetLayers(Index: Integer): TRecordMatrix;
begin
  Result := TRecordMatrix(LayersArray.VecCells[Index]);
end;

function TNeuronNetwork.GetLayersCount: Integer;
begin
  Result := LayersArray.ElemCount;
end;

procedure TNeuronNetwork.Init;
begin
  inherited;
  FMatrixTypes := FMatrixTypes + [mtNetwork];

  InitNetworkData;
end;

procedure TNeuronNetwork.InitNetworkData;
begin
  FLayers := TCellMatrix.Create();
  Fields['Layers'] := FLayers;

  // Trained - флаг обучения ИНС. 1 - сеть обучена. 0 - сеть не обучена
  with TByteMatrix.Create() do
  begin
    ThisNetwork.Fields['Trained'] := ThisMatrix;
    Value := 0;
  end;

  with TIntegerMatrix.Create() do
  begin
    ThisNetwork.Fields['Epochs'] := ThisMatrix;
    Value := 100;
  end;

  with TExtendedMatrix.Create() do
  begin
    ThisNetwork.Fields['Goal'] := ThisMatrix;
    Value := 0;
  end;

  Fields['TrainInput'] := TDoubleMatrix.Create();

  Fields['TrainTarget'] := TDoubleMatrix.Create();
end;

procedure TNeuronNetwork.SetLayersCount(const Value: Integer);
var
  I: Integer;
  Rec: TRecordMatrix;
begin
  // Устанавливаем требуемое количество слоев
  LayersArray.PreservResize([Value]);

  // Инициализируем слои ИНС
  for I := 0 to LayersArray.ElemCount - 1 do
    if LayersArray.VecCells[I] = nil then
    begin
      Rec := TRecordMatrix.Create();
      LayersArray.VecCells[I] := Rec;

      // Каждый слой должен иметь массив весов W
      Rec.Fields['W'] := TDoubleMatrix.Create();
    end;
end;

function TNeuronNetwork.GetEpochs: Integer;
begin
  Result := Fields['Epochs'].ValueI;
end;

procedure TNeuronNetwork.SetEpochs(const Value: Integer);
begin
  Fields['Epochs'].ValueI := Value;
end;

function TNeuronNetwork.GetGoal: Extended;
begin
  Result := Fields['Goal'].Value;
end;

procedure TNeuronNetwork.SetGoal(const Value: Extended);
begin
  Fields['Goal'].Value := Value;
end;

function TNeuronNetwork.GetTrainInput: TMatrix;
begin
  Result := Fields['TrainInput'];
end;

function TNeuronNetwork.GetTrainTarget: TMatrix;
begin
  Result := Fields['TrainTarget'];
end;

procedure TNeuronNetwork.Train;
begin

end;

procedure TNeuronNetwork.Simulate(Inputs, Outputs: TMatrix);
begin

end;

initialization

finalization

end.
