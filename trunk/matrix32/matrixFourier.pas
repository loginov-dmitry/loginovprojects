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
{ Модуль matrixFourier - модуль дискретного преобразования Фурье              }
{ (c) 2005 - 2007 Логинов Дмитрий Сергеевич                                   }
{ Последнее изменение: 03.03.2007                                             }
{ Адрес сайта: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{$Include MatrixCommon.inc}

unit matrixFourier;

interface

uses
  SysUtils, Math, Matrix32,

  {David Butler}cUtils, cMaths {/David Butler};

{Выполняет быстрое преобразование Фурье над элементами комплексного массива
 AVector. Результирующий массив AResult должен быть установлен заранее.
 В качестве ALength задается длина массива AVector. Массив AResult также
 должен имет длину ALength. Что означает аргумент AngleNumerator не знаю.
 Функцию передрал из модуля "cMaths" by David Butler.
 Длина вектора ALength должна быть кратной степени двойки.}
procedure VecFourierTransform(const AngleNumerator: Extended;
  AVector, AResult: PExtendedComplexArray; ALength: Cardinal);

{Выполняем быстрое преобразование Фурье над массивом AMatrix. Допускается
 любая размерность. Количество столбцов не должно быть меньше 2-х
 Если ALength задано, то использоется это значение, в противном случае
 используется значение количества стобцов массива AMatrix. Кроме того
 ALength расчитывается так, чтобы быть кратным степени двойки
 Длина возвращаемого массива AResult всегда кратна степени двойки}
procedure FourierTransform(const AngleNumerator: Extended;
  AMatrix, AResult: TMatrix; ALength: Integer = 0);

{Облегченный вариант вызова функции FourierTransform. Аналогична
 одноименной функции Матлаба. Число столбцов в возвращаемом массиве кратно
 степени двойки}
procedure FFT(AMatrix, AResult: TMatrix; ALength: Integer = 0);

{Обратное преобразование фурье. Аналогична одноименной функции Матлаба. Число
 столбцов в возвращаемом массиве кратно степени двойки}
procedure IFFT(AMatrix, AResult: TMatrix; ALength: Integer = 0);

{Выполняет проверку работоспособности процедуры FFT. Могу удалить эту функцию
 когда угодно.}
procedure TestFFT(AResult: TMatrix; ALength: Integer);

implementation

resourcestring
  SMatchElemCount = 'Задано недопустимое количество элементов';
  SIsNotPowerOfTwo = 'Длина массива должна быть кратной степени двойки';

  procedure VecFourierTransform(const AngleNumerator: Extended;
  AVector, AResult: PExtendedComplexArray; ALength: Cardinal);
var
  I, J, N, NumBits           : Cardinal;
  PComplexElem, QComplexElem : PExtendedComplex;
  BlockSize, Blockend        : Cardinal;
  delta_angle, delta_ar      : Extended;
  alpha, beta                : Extended;
  tr, ti, ar, ai             : Extended;
begin
  try
    if Integer(ALength) < 2 then
      raise EMatrixError.Create(SMatchElemCount);

    // Значение ALength должно быть кратным степени двойки. Это может быть
    // только в случае, если имеется всего один неустановленный бит
    if BitCount(ALength) <> 1 then
      raise EMatrixError.Create(SIsNotPowerOfTwo);

    // Обнуляем элементы результирующего массива AResult
    // Это наверно не обязательно, но точно не повредит
    FillChar(AResult^, ALength * SizeOf(TExtendedComplex), 0);

    // Определяем порядковый номер первого установленного бита
    NumBits := SetBitScanForward(ALength);

    // Инициализируем результирующий массив по хитрому алгоритму
    // После этого исходный массив становится не нужным
    for I := 0 to ALength - 1 do
    begin
      J := ReverseBits (I, NumBits);   
      AResult[J] := AVector[I];
    end;     //exit;

    Blockend := 1;
    BlockSize := 2;
    while BlockSize <= ALength do
    begin
      delta_angle := AngleNumerator / BlockSize;
      alpha := Sin (0.5 * delta_angle);
      alpha := 2.0 * alpha * alpha;
      beta := Sin (delta_angle);

      I := 0;
      while I < ALength do
      begin
        ar := 1.0;    { cos(0) }
        ai := 0.0;    { sin(0) }

        PComplexElem := @AResult[I];
        J := I + Blockend;     
        QComplexElem := @AResult[J];

        for N := 0 to Blockend - 1 do
        begin
          tr := ar * QComplexElem.mReal - ai * QComplexElem.mImag;
          ti := ar * QComplexElem.mImag + ai * QComplexElem.mReal;
          QComplexElem.mReal := PComplexElem.mReal - tr;
          QComplexElem.mImag := PComplexElem.mImag - ti;
          PComplexElem.mReal := PComplexElem.mReal + tr;
          PComplexElem.mImag := PComplexElem.mImag + ti;
          delta_ar := alpha * ar + beta * ai;
          ai := ai - (alpha * ai - beta * ar);
          ar := ar - delta_ar;
          Inc(PComplexElem);
          Inc(QComplexElem);
        end;

        Inc(I, BlockSize);
      end;

      Blockend := BlockSize;
      BlockSize := BlockSize shl 1;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(
        E, 'procedure VecFourierTransform'){$ENDIF}
  end;
end;

procedure FourierTransform(const AngleNumerator: Extended;
  AMatrix, AResult: TMatrix; ALength: Integer = 0);
var
  I: Integer;
  NewLength: Cardinal;
  TempMatrix, TempResult: TMatrix;
  DimValues: TDynIntArray;
const
  SFuncName = 'procedure FourierTransform';
begin
  try
    if not IsSameMatrixTypes([AMatrix, AResult], [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if (AMatrix.Cols < 2) or (ALength < 0) then
      raise EMatrixDimensionsError.Create(SMatchElemCount);

    if ALength = 0 then
      ALength := AMatrix.Cols;

    NewLength := ALength;

    // Пересчитываем NewLength так, чтобы эта величина была кратной степени двойки

    for I := 0 to High(BitMaskTable) do
      if BitMaskTable[I] >= NewLength then
      begin
        NewLength := BitMaskTable[I];
        Break;
      end;

    // Проверяем, является ли NewLength кратным степени двойки

    if NewLength > 0 then
      if BitCount(NewLength) <> 1 then
        raise EMatrixError.Create(SIsNotPowerOfTwo);

    {Здесь мы должны создать массив определенного класса, а именно
     TExtendedComplexMatrix, так как процедура VecFourierTransform
     работает только с элементами типа TExtendedComplex}
    TempMatrix := TExtendedComplexMatrix.Create();
    TempResult := TExtendedComplexMatrix.Create();

    try
      TempMatrix.CopyFrom(AMatrix);

      // Устанавливаем число столбцов в соответствие с NewLength
      TempMatrix.Reshape(TempMatrix.CalcMatrixDimensions);
      TempMatrix.Cols := NewLength;
      
      TempResult.PreservResize(TempMatrix.GetDimensions);

      for I := 0 to TempMatrix.Rows - 1 do
        VecFourierTransform(
          AngleNumerator,
          TempMatrix.ElemAddress(I, 0),
          TempResult.ElemAddress(I, 0),
          NewLength);

      // Восстанавливаем размеры массива

      SetLength(DimValues, 0); // Это чтобы Варнинги не показывались
      DimValues := AMatrix.GetDimensions;

      // Устанавливаем требуемое число столбцов
      DimValues[Length(DimValues) - 1] := NewLength;
      TempResult.Reshape(DimValues);  

      // Передаем данные в результирующий массив
      AResult.MoveFrom(TempResult);

    finally
      TempMatrix.Free;
      TempResult.Free;
    end;
     
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, SFuncName){$ENDIF}
  end;
end;

procedure FFT(AMatrix, AResult: TMatrix; ALength: Integer = 0);
begin
  try
    FourierTransform(Pi2, AMatrix, AResult, ALength);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure FFT'){$ENDIF}
  end;
end;

procedure IFFT(AMatrix, AResult: TMatrix; ALength: Integer = 0);
begin
  try
    FourierTransform(-Pi2, AMatrix, AResult, ALength);

    AResult.ValueOperation(AResult, FloatComplex(AResult.Cols, 0), opCmplxDivBoth); 
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure IFFT'){$ENDIF}
  end;
end;

procedure TestFFT(AResult: TMatrix; ALength: Integer);
var
  M1, M2, X, Y, ResMatrix, Pyy: TMatrix;
begin
  try
    M1 := TDoubleMatrix.Create();
    M2 := M1.CreateInstance();
    X := M1.CreateInstance();
    Y := M1.CreateInstance();
    ResMatrix := TExtendedComplexMatrix.Create();
    Pyy := ResMatrix.CreateInstance();
    try
      M1.Colon(0, 0.001, 0.6);
      M2.ValueOperation(M1, Pi2 * 50, opMul);  // 2*pi*50*t
      M2.CalcFunction(M2, fncSin);

      X.ValueOperation(M1, Pi2 * 200, opMul);  // 2*pi*120*t
      X.CalcFunction(X, fncSin);

      X.DoAdd([M2, X]); // x = sin(2*pi*50*t)+sin(2*pi*120*t)

      Y.CopyFrom(X);

      iFFT(Y, ResMatrix, ALength);

      //Pyy = Y.* conj(Y) / 512;
      Pyy.CalcFunction(ResMatrix, fncCmplxConj);
      Pyy.CalcOperation([ResMatrix, Pyy], opCmplxMul);
      Pyy.ValueOperation(Pyy, ALength, opDiv);


      AResult.MoveFrom(Pyy);

    finally
      M1.Free;
      M2.Free;
      X.Free;
      Y.Free;
      ResMatrix.Free;
      Pyy.Free;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure TestFFT'){$ENDIF}
  end;
end;


end.
