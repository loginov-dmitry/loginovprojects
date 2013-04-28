{$Include MatrixCommon.inc}

unit matrixProcessSignal;

interface

uses
  Windows, Messages, Classes, SysUtils, Math, Matrix32;


type
  TDim2 = (dimRows, dimCols);

{ Fast3PointInterp()
 Быстрая 3-точечная (параболическая) интерполяция с помощью
 интерполяционных полиномов Ньютона.
  Values - перечень значений
  OldSteps - перечень координат Х, соответствующих значениям Values
  NewSteps - точки, в которых нужно вычислить приближенные значения
  AResult - новые (приближенные) значения в точках NewSteps
  Faster - позволяет значительно ускорить вычисления, если сетка NewSteps является
    регулярной. Используется для работы функции масштабирования StretchRows() 

 Данный способ для вычисления очередного восстановленного значения использует
 следующий алгоритм:

 P(E) = Y0 + (Y1 - Y0) * E + (Y2 - 2 * Y1 + Y0) / 2 * E * (E - 1), где Е
 расчитывается по формуле
 E = (X - X0) / (X1 - X0)

 Функция поддерживает работу с массивами любых размерностей}
procedure Fast3PointInterp(Values, OldSteps, NewSteps, AResult: TMatrix; Faster: Boolean = False);

{Осуществляет изменение длины строк матрицы AMatrix в соответствии с NewLength.
 Эта операция выполняется посредством параболической интерполяции.
 Функция поддерживает работу с массивами любых размерностей}
procedure StretchRows(AMatrix, AResult: TMatrix; NewLength: Integer);

implementation

const
  SigNames: array[1..12] of string = (
    'I', 'II', 'III', 'aVR', 'aVL', 'aVF', 'V1', 'V2', 'V3', 'V4', 'V5', 'V6');

procedure Fast3PointInterp(Values, OldSteps, NewSteps, AResult: TMatrix; Faster: Boolean);
var
  TempMatrix, ValuesRef: TMatrix;
  ColNum, I, J, K: Integer;
  OldDimValues: TDynIntArray;
  Tmp: Extended;
const
  SFuncName = 'procedure Fast3PointInterp';

  function CalcElem(X0, X1, Y0, Y1, Y2, X: Double): Double;
  var E: Real;
  begin
    E := (X - X0) / (X1 - X0);
    if (E < 0) or (E > 2) then
      raise MatrixCreateExceptObj(EMatrixError, 'CalcElem Error', 'function CalcElem');
    Result := Y0 + (Y1 - Y0) * E + (Y2 - 2 * Y1 + Y0) / 2 * E * (E - 1);
  end;
begin
  try

    if not IsSameMatrixTypes([Values, OldSteps, NewSteps, AResult], [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if (OldSteps.Rows > 1) or (Values.Cols <> OldSteps.Cols) or (OldSteps.Rows > 1) then
      raise EMatrixDimensionsError.Create(matSArraysNotAgree);

    if Values.ElemCount = 0 then
      raise EMatrixError.Create(matSArrayIsEmpty);

    // Создаем ссылку на исходный массив. Нам нужно будет преобразовать
    // исходный массив в матрицу. Однако не хочется этого делать над
    // массивом Values. Вдруг он используется в многопоточном приложении.
    ValuesRef := Values.CreateReference;

    // Создаем временный массив
    TempMatrix := AResult.CreateInstance;  

    try

      // Запоминаем размеры массива
      SetLength(OldDimValues, 0);
      OldDimValues := Values.GetDimensions;

      // Исходный массив может быть многомерным. Превращаем его в матрицу
      ValuesRef.Reshape(ValuesRef.CalcMatrixDimensions);

      // Устанавливаем требуемые размеры массива
      TempMatrix.Resize([ValuesRef.Rows, NewSteps.Cols]);

      // Запоминаем число эл-в
      ColNum := OldSteps.Cols;


      for I := NewSteps.Cols - 1 downto 0 do
      begin
        // Запоминаем очередную точку
        Tmp := NewSteps.VecElem[I];

        // Ищем точку в массиве исходных отсчетов
        for J := ColNum - 1 downto 0 do
        begin
          if Tmp >= OldSteps.VecElem[J] then
          begin
            for K := 0 to ValuesRef.Rows - 1 do
            begin
              if J = OldSteps.Cols - 1 then
                TempMatrix.Elem[K, I] := ValuesRef.Elem[K, J]
              else if J = OldSteps.Cols - 2 then
                TempMatrix.Elem[K, I] :=
                  CalcElem(
                    OldSteps.VecElem[OldSteps.Cols - 3],
                    OldSteps.VecElem[OldSteps.Cols - 2],
                    ValuesRef.Elem[K, OldSteps.Cols - 3],
                    ValuesRef.Elem[K, OldSteps.Cols - 2],
                    ValuesRef.Elem[K, OldSteps.Cols - 1],
                    NewSteps.VecElem[I])
              else
                TempMatrix.Elem[K, I] :=
                  CalcElem(
                    OldSteps.VecElem[J],
                    OldSteps.VecElem[J + 1],
                    ValuesRef.Elem[K, J],
                    ValuesRef.Elem[K, J + 1],
                    ValuesRef.Elem[K, J + 2],
                    NewSteps.VecElem[I]);
            end;
            if Faster then
              ColNum := J + 1;
            Break;
          end;
        end;

      end; // for I

      // Устанавливаем для массива TempMatrix правильные размеры
      OldDimValues[Length(OldDimValues) - 1] := TempMatrix.Cols;
      TempMatrix.Reshape(OldDimValues);

      // Перемещаем элементы в AResult
      AResult.MoveFrom(TempMatrix);
    finally
      TempMatrix.Free;
      ValuesRef.Free;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, SFuncName){$ENDIF}
  end;
end;

procedure DoIncRows(AMatrix, AResult: TMatrix; NewLength: Integer);
var
  TempMatrix, OldSteps, NewSteps: TMatrix;
begin

  TempMatrix := AResult.CreateInstance;

  // Создаем массивы отсчетов
  OldSteps := TIntegerMatrix.Create;
  NewSteps := TSingleMatrix.Create;

  try
    OldSteps.Resize([AMatrix.Cols]);
    OldSteps.FillByOrder;

    NewSteps.Resize([NewLength]);
    NewSteps.FillByStep2(0, AMatrix.Cols - 1);

    Fast3PointInterp(AMatrix, OldSteps, NewSteps, TempMatrix, True);

    AResult.MoveFrom(TempMatrix);

  finally
    TempMatrix.Free;
    OldSteps.Free;
    NewSteps.Free;
  end;
end;

procedure DoDecRows(AMatrix, AResult: TMatrix; NewLength: Integer);
var
  TempMatrix, TempMatrix2, MatrixRef: TMatrix;
  Interval, Num, I, J, Column: Integer;
  OldDimValues: TDynIntArray;
begin

  MatrixRef := AMatrix.CreateReference;
  TempMatrix := AResult.CreateInstance;
  TempMatrix2 := AResult.CreateInstance;

  try

    Interval := AMatrix.Cols div (NewLength - 1) + 1;
    Num := Interval * (NewLength - 1) + 1;

    // Запоминаем размеры AMatrix
    OldDimValues := AMatrix.GetDimensions;


    // Делаем MatrixRef 2-мерной матрицей
    MatrixRef.Reshape(MatrixRef.CalcMatrixDimensions);

    DoIncRows(MatrixRef, TempMatrix2, Num);

    TempMatrix.Resize([MatrixRef.Rows, NewLength]);

    Column := -1;
    for J := 1 to Num do
    begin
      if (J mod Interval) <> 1 then Continue;
      Inc(Column);
      for I := 0 to MatrixRef.Rows - 1 do
        TempMatrix.Elem[I, Column] := TempMatrix2.Elem[I, J - 1];
    end;

    // Корректируем размеры TempMatrix
    OldDimValues[Length(OldDimValues) - 1] := NewLength;
    TempMatrix.Reshape(OldDimValues); 

    AResult.MoveFrom(TempMatrix);

  finally
    TempMatrix.Free;
    TempMatrix2.Free;
    MatrixRef.Free;
  end;
end;

procedure StretchRows(AMatrix, AResult: TMatrix; NewLength: Integer);
const
  SFuncName = 'procedure StretchRows';
resourcestring  
  SMustBeLessOne = 'Значение длины массива должно быть больше единицы!';
begin
  try
    if NewLength < 2 then
      RaiseMatrixError(EMatrixBadParams, SMustBeLessOne);

    if NewLength > AMatrix.Cols then
    begin
      DoIncRows(AMatrix, AResult, NewLength);
    end else if NewLength < AMatrix.Cols then
      DoDecRows(AMatrix, AResult, NewLength)
    else
      AResult.CopyFrom(AMatrix);

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, SFuncName){$ENDIF}
  end;
end;

end.
