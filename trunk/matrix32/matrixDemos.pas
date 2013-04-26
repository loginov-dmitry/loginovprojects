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
{ Модуль matrixDemos - сборник авторских примеров                             }
{ (c) 2005 - 2007 Логинов Дмитрий Сергеевич                                   }
{ Последнее обновление: 11.03.2007                                            }
{ Адрес сайта: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{$Include MatrixCommon.inc}

unit matrixDemos;

interface

uses
  Windows, Messages, Classes, SysUtils, Math, Matrix32, dialogs;

resourcestring
  matSlauNotSolutions = 'СЛАУ не имеет решений';
  matSMustBeLessOne = 'Значение длины массива должно быть больше единицы';

{Тестирует функции данного модуля на работоспособность.}  
procedure RunTests;

{Быстрая 3-точечная (параболическая) интерполяция с помощью
 интерполяционных полиномов Ньютона.
  Values - перечень значений
  OldSteps - перечень координат Х, соответствующих значениям Values
  NewSteps - точки, в которых нужно вычислить приближенные значения
  ResultVec - новые (приближенные) значения в точках NewSteps
  Faster - позволяет значительно ускорить вычислений, если сетка NewSteps является
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

{Решение системы линейный алгебраических уравнений с помощью одного из
 методов Гаусса. Метод не самый быстрый, но обеспечивает неплохую сходимость.
 A - Квадратная матрица коэффициентов
 B - Массив свободных членов
 X - Результат решения СЛАУ

 В данной реализации массив свободных членов должен быть вектором-столбцом.
 Функция не поддерживает решение СЛАУ сразу для нескольких векторов свободных
 членов. Принимаются более быстрые и гибкие варианты реализации данной функции}
procedure SlauGauss(A, B, X: TMatrix);

{Перемножает матрицы А и В в соответствии с алгоритмом Копперсмита — Винограда.
 Сложность алгоритма должна составить n^2.38 (что до 70 раз быстрее, чем при
 использовании лобового метода)}
procedure FastMulMatrix(A, B, C: TMatrix);

implementation

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
begin
  try
    if NewLength < 2 then
      raise EMatrixBadParams.Create(matSMustBeLessOne);

    if NewLength > AMatrix.Cols then
    begin
      DoIncRows(AMatrix, AResult, NewLength);
    end else if NewLength < AMatrix.Cols then
      DoDecRows(AMatrix, AResult, NewLength)
    else
      AResult.CopyFrom(AMatrix);

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure StretchRows'){$ENDIF}
  end;
end;

procedure SlauGauss(A, B, X: TMatrix);
var
  TempRes, ExtMatrix: TMatrix;
  I, J, K, ARow: Integer;
  Tmp1, Tmp2: Extended;
begin
  try
    if not IsSameMatrixTypes([A, B, X], [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if A.Cols <> A.Rows then
      raise EMatrixDimensionsError.Create(matSIsNotSquareArray);

    if (A.Rows <> B.Rows) or (B.Cols > 1) then
      raise EMatrixDimensionsError.Create(matSArraysNotAgree);

    // Создаем массив для хранения результата
    TempRes := TExtendedMatrix.Create;
    // Создаем массив для хранения расширенной матрицы
    ExtMatrix := TempRes.CreateInstance(TempRes);
    try

      if not A.IsEmpty then
      begin
        // Формируем расширенную матрицу
        ExtMatrix.Concat(A.DimCols, [A, B]);
      
        // Выполняем перестановку строк
        for I := 0 to ExtMatrix.Rows - 1 do
        begin
          Tmp1 := ExtMatrix.Elem[I, I];
          ARow := I;
          for J := I + 1 to ExtMatrix.Rows - 1 do
          begin
            Tmp2 := ExtMatrix.Elem[J, I];
            if Abs(Tmp2) > Abs(Tmp1) then
            begin
              Tmp1 := Tmp2;
              ARow := J;
            end;
          end;

          if ARow <> I then
            for J := 0 to ExtMatrix.Cols - 1 do
            begin
              Tmp2 := ExtMatrix.Elem[I, J];
              ExtMatrix.Elem[I, J] := ExtMatrix.Elem[ARow, J];
              ExtMatrix.Elem[ARow, J]:= Tmp2;
            end;
        end; // Перестанока строк закончена

        if SameValue(ExtMatrix.Elem[0, 0], 0) then
          EMatrixError.Create(matSlauNotSolutions);

        // Прямой шаг

        for I := 1 to ExtMatrix.Cols - 1 do
          ExtMatrix.Elem[0, I] := ExtMatrix.Elem[0, I] / ExtMatrix.Elem[0, 0];

        for I := 1 to ExtMatrix.Rows - 1 do
        begin
          for J := I to ExtMatrix.Rows - 1 do
          begin
            Tmp1 := 0;
            for K := 0 to I - 1 do
              Tmp1 := Tmp1 + ExtMatrix.Elem[J, K] * ExtMatrix.Elem[K, I];
            ExtMatrix.Elem[J, I] := ExtMatrix.Elem[J, I] - Tmp1;
          end;

          for J := I + 1 to ExtMatrix.Cols - 1 do
          begin
            Tmp1 := 0;
            for K := 0 to I - 1 do
              Tmp1 := Tmp1 + ExtMatrix.Elem[I, K] * ExtMatrix.Elem[K, J];
            ExtMatrix.Elem[I, J] := (ExtMatrix.Elem[I, J] - Tmp1) / ExtMatrix.Elem[I, I];
          end;
        end;

        // Прямой шаг завершен!

        // Обратный шаг

        TempRes.Resize([A.Cols]);
        TempRes.AssignVecElem(ExtMatrix, TempRes.ElemCount - 1, ExtMatrix.ElemCount - 1);

        for I := 0 to ExtMatrix.Rows - 2 do
        begin
          K := ExtMatrix.Rows - I - 2;
          Tmp1 := 0;
          for J := K + 1 to ExtMatrix.Rows - 1 do
            Tmp1 := Tmp1 + ExtMatrix.Elem[K, J] * TempRes.VecElem[J];
          TempRes.VecElem[K] := ExtMatrix.Elem[K, ExtMatrix.Rows] - Tmp1;
        end;
        TempRes.Reshape([TempRes.ElemCount, 1]);

        // Вычисление СЛАУ завершено!
      end;

      X.MoveFrom(TempRes);
    finally
      TempRes.FreeMatrix;
    end;       
      
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure SlauGauss'){$ENDIF}
  end;
end;

procedure FastMulMatrix(A, B, C: TMatrix);
type
  T6x6Ar = array[1..6, 1..6] of Extended;
  P6x6Ar = ^T6x6Ar;

  TVec = array[1..100] of Extended;
  PVec = ^TVec;
var
  Temp: TMatrix;
  ARowFactor, BColFactor: TMatrix;
  //PRowFactor, PColFactor: PVec;
  //PRes, P_A, P_B: P6x6Ar;
  I, J, K, D: Integer;
  Buf: Extended;
  Tc: DWORD;

begin
  try
    if A.Cols <> B.Rows then
      raise EMatrixError.Create('Массивы не согласованы');

    D := A.Cols div 2;
    Temp := TExtendedMatrix.Create();
    ARowFactor := TExtendedMatrix.Create(Temp);
    BColFactor := TExtendedMatrix.Create(Temp);
    try
      ARowFactor.Resize([A.Rows]);
     // PRowFactor := ARowFactor.ArrayAddress;
      //P_A := A.ArrayAddress;

      Tc := GetTickCount;
      for I := 0 to A.Rows - 1 do
      begin
        ARowFactor.VecElem[I] := A.Elem[I, 0] * A.Elem[I, 1];
        for J := 1 to D - 1 do
          ARowFactor.VecElem[I] := ARowFactor.VecElem[I] + A.Elem[I, 2 * J] * A.Elem[I, 2 * J + 1];
      end;

      Tc := GetTickCount - Tc;
      ShowMessageFmt('%d', [Tc]);

      BColFactor.Resize([B.Cols]);
      //PColFactor := BColFactor.ArrayAddress;
      //P_B := B.ArrayAddress;

      Tc := GetTickCount;
      for I := 0 to B.Cols - 1 do
      begin
        BColFactor.VecElem[I] := B.Elem[0, I] * B.Elem[1, I];
        for J := 1 to D - 1 do
          BColFactor.VecElem[I] := BColFactor.VecElem[I] + B.Elem[2 * J, I] * B.Elem[2 * J + 1, I]
      end;
      Tc := GetTickCount - Tc;
      ShowMessageFmt('%d', [Tc]);

      Temp.Resize([A.Rows, B.Cols]);
      //PRes := Temp.ArrayAddress;

      Buf := 0;
      Tc := GetTickCount;
      for I := 0 to A.Rows - 1 do
      begin
        for J := 0 to B.Cols - 1 do
        begin
          Temp.Elem[I, J] := -ARowFactor.VecElem[I] - BColFactor.VecElem[J];
          for K := 0 to D - 1 do
            Buf := Buf * Buf / (Buf + 1) + 1;
            //Temp.Elem[I, J] := 2{Temp.Elem[I, J] + (Temp.Elem[I, J]+Temp.Elem[I, J]+Temp.Elem[I, J])};
              {(A.Elem[I, 2 * K] + B.Elem[2 * K + 1, J]) *
              (A.Elem[I, 2 * K + 1] + B.Elem[2 * K, J]);}
        end;
      end;
      Tc := GetTickCount - Tc;
      ShowMessageFmt('%d', [Tc]);

      if A.Cols mod 2 <> 0 then
      begin
        for I := 0 to A.Rows - 1 do
          for J := 0 to B.Cols - 1 do
            Temp.Elem[I, J] := Temp.Elem[I, J] + A.Elem[I, A.Cols - 1] * B.Elem[A.Cols - 1, J];
      end;

      C.MoveFrom(Temp);
    finally
      Temp.FreeMatrix;
    end;

  except                         
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure FastMulMatrix'){$ENDIF}
  end;
end;

procedure RunTests;
begin

end;

end.

