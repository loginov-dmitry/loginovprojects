{$IFDEF FPC}
{$MODE DELPHI}{$H+}{$CODEPAGE UTF8}
{$ENDIF}

{ *************************************************************************** }
{                                                                             }
{                                                                             }
{                                                                             }
{ Модуль matrixLapack - интерфейс взаимодействия с библиотекой Lapack.dll     }
{ (c) 2008 Логинов Дмитрий Сергеевич                                          }
{ Последнее обновление: 16.03.2008                                            }
{ Адрес сайта: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ Адрес сайта проекта Lapack: http://www.nag.com/lapack/                      }
{                             http://www.netlib.org/lapack/                   }
{                                                                             }
{ *************************************************************************** }

{*****************************************************************************}
{ Lapack (Linear Algebra PACKage) - это очень популярная математическая       }
{ библиотека, используемая во многих известных математических пакетах         }
{ (Matlab, Maple и др.). Lapack всегда используется в паре с BLAS, и вместе   }
{ они позволяют наиболее эффективно решать наиболее распространенные задачи   }
{ математики (умножение матриц, решение СЛАУ, LU-разложение, нахождение       }
{ матрицы и многое другое). Всего программисту предоставляется несколько сотен}
{ различных функций, которых достаточно для решения большинства задач         }
{ современной математики.                                                     }
{ В Matrix32 библиотека Lapack представлена файлом matrixlapack.dll, а        }
{ BLAS - файлом  matrixatlas.dll. Вы можете скомпилировать собственные        }
{ версии библиотек BLAS и Lapack и загружать их с использованием функций      }
{ LoadBLASLibrary() и LoadLapackLibrary()                                     }
{ Имейте ввиду, что при загрузке библиотеки Lapack грузится статически        }
{ библиотека BLAS, поэтому библиотека BLAS должна располагаться либо в        }
{ каталоге с основным EXE-модулем, либо в текущей директории, либо в каталоге }
{ %WINDIR%\System32.                                                          }
{*****************************************************************************}

{ *************************************************************************** }
{ Внимание! Функции LAPACK автоматически НЕ ОЧИЩАЮТ стэк, поэтому объявление  }
{ всех функций должно идти с директивой CDECL                                 }
{ *************************************************************************** }

{$Include MatrixCommon.inc}

unit matrixLapack;

interface

uses
  Windows, Messages, SysUtils, Classes, Matrix32, matrixBLAS, Math, dialogs;

resourcestring
  matSlauNotSolutions = 'СЛАУ не имеет решений!';
  matNotSolutionsFounded = 'Задача не имеет решений!';
  matSArgumentIllegalValue = 'Аргумент №%d функции "%s" имеет недопустимое значение!';

{LU-разложение матрицы A в форме A = P * L * U
 @param A прямоугольная матрица, которую функция должна разложить
 @param LU результат разложения (L и U - матрицы находятся в одном массиве)
 @param L нижняя треугольная матрица, полученная в результате разложения
 @param U верхняя треугольная матрица, полученная в результате разложения
 @param IPIV вектор перестановок строк}
procedure LapackLUFactorization(A, L, U: TMatrix; LU: TMatrix = nil; IPIV: TMatrix = nil);

{Вычисляет детерминант квадратной матрицы с помощью LU-разложения. В отличие от
 Матлаба, в котором использование типа Double не позволяет вычислить определитель
 для матриц размером более 510 x 510, данная функция имеет менее строгое
 ограничение на размер матрицы (матрицу 3000 x 3000 обрабатывает без проблем).
 Функция тестировалась на массивах, заполненных случайными числами в диапазоне
 от 0 до 1. Функция может обнулить возвращаемое значение, если оно
 не превышает BlasResolution. Не используйте данную функцию для проверки
 возможности решения СЛАУ, т.к. можно сразу вызвать функцию LapackSolveSLE -
 она и СЛАУ решит и детерминант вычислит. То же самое касается функции вычисления
 обратной матрицы LapackInverseMatrix }
function LapackDeterminant(A: TMatrix): Extended;

{:Вычисляет СЛАУ (system of linear equations) A * X = B методом LU-разложения.
  Массив B может содержать сколько угодно столбцов.
  Соответственно и решений будет столько же. Скорость вычислений практически не
  зависит от числа столбцов массива B. Со стороны Matrix32 будет происходить
  снижение скорости из-за необходимости предварительного транспонирования.
  Функция возвращает детерминант матрицы А. Если Детерминант = 0, значит
  система уравнений не была решена, т.к. она не имеет решения.
  При установленном параметре CanRaiseException функция генерирует исключение E
  LapackNotSolutions, если СЛАУ не имеет решения. Если CanRaiseException=False,
  а решение не найдено, то матрица X не изменяется}
function LapackSolveSLE(A, B, X: TMatrix; CanRaiseException: Boolean = True): Extended;

{:Вычисляет обратную матрицу X с использованием LU-разложения. На выходе - значение
 определителя. Если Определитель = 0, значит обратной матрицы не существут. В этом
 случае функция или вернет 0, или сгенерирует исключение ELapackNotSolutions, но
 изменения матрицы Х не произойдет. Не вычисляйте обратную матрицу для решения
 СЛАУ, т.к. функция LapackSolveSLE сделает это гораздо эффективнее}
function LapackInverseMatrix(A, X: TMatrix; CanRaiseException: Boolean = True): Extended;

{==============================================================================
 Ниже приводятся процедуры, чей вызов приведет к выполнению соответствующих
 функций библиотеки Lapack. Для вызова всех этих процедур необходимо указывать
 все параметры. Необходимо иметь ввиду, что Lapack реализован на фортране, в
 котором порядок расположения элементов (в матрице) отличается от порядка,
 используемого в Delphi, поэтому некоторые функции требуют предварительного
 транспонирования передаваемых матриц
 ==============================================================================}

{:Выполняет LU-разложение в форме A = P * L * U.
 @param M число строк матрицы A
 @param N число столбцов матрицы A
 @param A на входе - раскладываемая матрица A. На выходе - коэффициенты разложения
   L и U. Диагональные элементы матрицы L не хранятся
 @param LDA номер последней строки матрицы A (нумерация идет с "1")
 @param IPIV массив индексов min(M,N). Для 1 <= i <= min(M,N), строка i матрицы
   была заменена строкой IPIV(i)
 @param INFO результат выполнения операции. Если INFO=0, то разложение выполнено
   без ошибок. Если INFO<0, это значит, что аргумент Abs(INFO) задан неверно.
   Если INFO>0, то задача не имеет решения в области действительных чисел. }
procedure LapackDGETRF(M, N: PInteger; A: PDouble; LDA: PInteger;
  IPIV: PInteger; INFO: PInteger);

{:Вычисляет СЛАУ (system of linear equations) A * X = B методом LU-разложения.
 @param N Число строк / столбцов матрицы А
 @param NRHS Число столбцов массива В
 @param A Входной буфер. После вычислений в буфере окажутся результаты LU-разложения
 @param LDA Номер последней строки матрицы А (нумерация идет с "1")
 @param IPIV Массив перестановок строк, выполненных при LU-разложении
 @param B Входной буфер. После вычислений в буфере окажутся элементы массива Х
 @param LDB Номер последней строки матрицы B (нумерация идет с "1")
 @param INFO результат выполнения операции. Если INFO=0, то решение СЛАУ выполнено
   успешно, иначе - неверные параметры, либо СЛАУ не имеет решений }
function LapackDGESV(N, NRHS: PInteger; A: PDouble; LDA, IPIV: PInteger; B: PDouble;
  LDB, INFO: PInteger): Integer;

{:Вычисляет обратную матрицу по результатам LU-разложения
 @param N Число строк / столбцов матрицы А
 @param A На входе - треугольные матрицы L и U по результатам LU-разложения.
   На выходе - вычисленная обратная матрица
 @param LDA Номер последней строки матрицы А (нумерация идет с "1")
 @param IPIV Массив перестановок строк, выполненных при LU-разложении
 @param WORK Массив дополнительных коэффициентов
 @param LWORK Размер массива WORK
 @param INFO результат выполнения операции. Если INFO=0, то вычисление обратной
   матрицы прошло успешно, иначе - неверные параметры, либо решение невозможно,
   т.к. обратной матрицы не существует}
procedure LapackDGETRI(N: PInteger; A: PDouble; LDA: PInteger; IPIV: PInteger;
    WORK: PDouble; LWORK: PInteger; INFO: PInteger);

var
  HLapack: THandle;
  LapackAutoUnload: Boolean;

type     
  ELapackError = class(EMatrixError);
  ELapackNotSolutions = class(ELapackError); // Нет решений

{:Загружает библиотеку "Lapack.dll". Если ранее она уже была загружена, но
  указано другое имя файла, то старая библиотека выгружается и грузится
  указанная библиотека. Поскольку Lapack состоит из нескольки библиотек, перед
  загрузкой необходимо убедиться, что все они находятся в ТЕКУЩЕЙ директории}
function LoadLapackLibrary(const AFileName: string = 'matrixlapack.dll'): Boolean;

procedure ErrorArgumentIllegalValue(const ProcName: string; Info: Integer);

implementation

type
  // LU - разложение
  TLapackDGETRF = procedure(M, N: PInteger; A: PDouble; LDA: PInteger;
    IPIV: PInteger; INFO: PInteger); cdecl;

  // Решение СЛАУ
  TLapackDGESV = function(n, nrhs: PInteger; a: PDouble; lda, ipiv: PInteger; b: PDouble;
    ldb, info: PInteger): Integer; cdecl;

  // Вычисление обратной матрицы  
  TLapackDGETRI = procedure(N: PInteger; A: PDouble; LDA: PInteger; IPIV: PInteger;
    WORK: PDouble; LWORK: PInteger; INFO: PInteger); cdecl;
var
  { Короткое имя файла библиотеки Lapack }
  LapackLibShortName: string = 'matrixlapack.dll';

  LapackDGETRF_: TLapackDGETRF;
  LapackDGESV_: TLapackDGESV;
  LapackDGETRI_: TLapackDGETRI;

procedure CheckLapackLibrary;
begin
  if HLapack = 0 then
    raise EBlasError.CreateFmt(matSLibraryNotLoaded, [LapackLibShortName]);
end;

procedure CheckLapackProcAddress(AProcAddress: Pointer; const ProcName: string);
begin
  CheckLapackLibrary;
  if AProcAddress = nil then
    raise ELapackError.CreateFmt(matSProcNotFoundInLibrary, [ProcName, LapackLibShortName]);
end;

procedure LapackDGETRF(M, N: PInteger; A: PDouble; LDA: PInteger;
  IPIV: PInteger; INFO: PInteger);
begin
  CheckLapackProcAddress(@LapackDGETRF_, 'dgetrf');
  LapackDGETRF_(M, N, A, LDA, IPIV, INFO);
end;

function LapackDGESV(N, NRHS: PInteger; A: PDouble; LDA, IPIV: PInteger; B: PDouble;
  LDB, INFO: PInteger): Integer;
begin
  CheckLapackProcAddress(@LapackDGETRF_, 'dgesv');
  Result := LapackDGESV_(N, NRHS, A, Lda, IPIV, B, Ldb, Info);
end;

procedure LapackDGETRI(N: PInteger; A: PDouble; LDA: PInteger; IPIV: PInteger;
  WORK: PDouble; LWORK: PInteger; INFO: PInteger);
begin
  CheckLapackProcAddress(@LapackDGETRF_, 'dgetri');
  LapackDGETRI_(N, A, LDA, IPIV, WORK, LWORK, INFO);
end;

procedure LapackLUFactorization(A, L, U: TMatrix; LU: TMatrix = nil; IPIV: TMatrix = nil);
var
  M, N, LRows, INFO, LDA, I, J: Integer;
  BufIPIV: TMatrix;
  BufA: TMatrix;
begin
  try
    if Assigned(L) then
      L.CheckForNumeric;
    if Assigned(U) then
      U.CheckForNumeric;
    if Assigned(LU) then
      LU.CheckForNumeric;
    if Assigned(IPIV) then
      IPIV.CheckForNumeric;

    BufA := TDoubleMatrix.Create();
    try
      BufIPIV := TIntegerMatrix.Create(BufA);
      BufA.Transpose(A);
      M := A.Rows;
      N := A.Cols;
      LRows := Min(M, N);
      LDA := M;
      BufIPIV.PreservResize([LRows]);
      INFO := 0;

      LapackDGETRF(@M, @N, BufA.ArrayAddress, @LDA, BufIPIV.ArrayAddress, @INFO);

      if INFO < 0 then
        ErrorArgumentIllegalValue('dgetrf', Info);

      BufA.Transpose(BufA);

      // Возвращаем вектор перестановок строк
      if Assigned(IPIV) then
        IPIV.MoveFrom(BufIPIV);

      // Формируем верхнюю треугольную матрицу
      if U <> nil then
      begin
        if N > M then
          U.Resize([M, N])
        else if N = M then
          U.Resize([M, M])
        else
          U.Resize([N, N]);

        U.Zeros;

        for J := 0 to U.Cols - 1 do
          for I := 0 to U.Rows - 1 do
            if I <= J then
              U.AssignElem(BufA, I, J, I, J);
      end;

      // Формируем нижнюю треугольную матрицу
      if L <> nil then
      begin
        if N > M then
          L.Resize([M, M])
        else
          L.Resize([M, N]);

        L.Zeros;

        for J := 0 to L.Cols - 1 do
          for I := 0 to L.Rows - 1 do
            if I = J then
              L.Elem[I, J] := 1
            else if I > J then
              L.AssignElem(BufA, I, J, I, J);
      end;

      // Возвращаем массив, сформированный библиотекой Lapack
      if Assigned(LU) then
        LU.MoveFrom(BufA);
              
    finally
      BufA.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function LapackLUFactorization'){$ENDIF}
  end;
end;

function LapackDeterminant(A: TMatrix): Extended;
var
  M, N, INFO, LDA, I: Integer;
  BufIPIV: TMatrix;
  BufA: TMatrix;
begin
  try
    A.CheckForNumeric;
    if A.IsEmpty then
      Result := 1
    else if (A.DimensionCount > 2) or (A.Rows <> A.Cols) then
      raise EMatrixDimensionsError.Create(matSIsNotSquareArray)
    else
    begin
      BufA := TDoubleMatrix.Create();
      BufIPIV := TIntegerMatrix.Create(BufA);
      try
        BufA.Transpose(A);
        M := A.Rows;
        N := M;
        LDA := M;
        BufIPIV.PreservResize([M]);
        INFO := 0;

        LapackDGETRF(@M, @N, BufA.ArrayAddress, @LDA, BufIPIV.ArrayAddress, @INFO);

        // Вычисляем определитель
        Result := 1;
        for I := 0 to M - 1 do
          if BufIPIV.VecElemI[I] <> I + 1 then
            Result := -Result * BufA.Elem[I, I]
          else
            Result := Result * BufA.Elem[I, I];

        if Abs(Result) < BlasResolution then
          Result := 0;
      finally
        BufA.FreeMatrix;
      end;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function LapackDeterminant'){$ENDIF}
  end;
end;

procedure ErrorArgumentIllegalValue(const ProcName: string; Info: Integer);
begin
  raise ELapackError.CreateFmt(matSArgumentIllegalValue, [-Info, ProcName]);
end;

function DoLapackSolveSLE(A, B, X: TMatrix; CanRaiseException: Boolean): Extended;
var
  N, Nrhs, Lda, Ldb, Info, I: Integer;
  BufA, BufB, IPiv: TMatrix;
begin
  N := A.Rows; // Число строк / столбцов матрицы А
  Nrhs := B.Cols; // Число столбцов массива В
  lda := N; // Номер последней строки матрицы А
  ldb := N; // Номер последней строки матрицы В
  info := 0; // Буфер результата операции

  BufA := TDoubleMatrix.Create(); // Входной буфер. После вычислений в буфере окажутся результаты LU-разложения
  BufB := TDoubleMatrix.Create(BufA); // Входной буфер. После вычислений в буфере окажутся элементы массива Х
  IPiv := TIntegerMatrix.Create(BufA); // Массив индексов перестановки строк
  try
    IPiv.PreservResize([N]);  
    BufA.Transpose(A);
    BufB.Transpose(B);

    LapackDGESV(@N, @NRHS, BufA.ArrayAddress, @Lda, IPiv.ArrayAddress,
      BufB.ArrayAddress, @Ldb, @Info);

    Result := 1;

    if Info < 0 then
      ErrorArgumentIllegalValue('dgesv', Info);

    if not (CanRaiseException and (Info > 0)) then
    begin
      // Вычисляем определитель
      Result := 1;
      for I := 0 to N - 1 do
        if IPiv.VecElemI[I] <> I + 1 then
          Result := -Result * BufA.Elem[I, I]
        else
          Result := Result * BufA.Elem[I, I];

      if Abs(Result) < BlasResolution then
      begin
        Result := 0;
        Info := 1;
      end;
    end;

    if Info = 0 then
      X.Transpose(BufB) // Обратное транспонирование
    else // Info > 0
    if CanRaiseException then
      raise ELapackNotSolutions.Create(matSlauNotSolutions);

  finally
    BufA.FreeMatrix;
  end;      
end;

function LapackSolveSLE(A, B, X: TMatrix; CanRaiseException: Boolean = True): Extended;
begin
  try
    if not IsSameMatrixTypes([A, B, X], [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if (A.Cols <> A.Rows) or (A.Rows < 1) then
      raise EMatrixDimensionsError.Create(matSIsNotSquareArray);

    if (A.Rows <> B.Rows) then
      raise EMatrixDimensionsError.Create(matSArraysNotAgree);

    Result := DoLapackSolveSLE(A, B, X, CanRaiseException);

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function LapackSolveSLE'){$ENDIF}
  end;
end;

function LapackInverseMatrix(A, X: TMatrix; CanRaiseException: Boolean = True): Extended;
var
  I, N, M, LDA, LWORK, INFO: Integer;
  BufA, IPIV, WORK: TMatrix;
begin
  try
    if not IsSameMatrixTypes([A, X], [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if (A.Cols <> A.Rows) then
      raise EMatrixDimensionsError.Create(matSIsNotSquareArray);

    if A.IsEmpty then
    begin
      X.Clear;
      Result := 1;
    end else
    begin
      BufA := TDoubleMatrix.Create();
      WORK := TDoubleMatrix.Create(BufA);
      IPIV := TIntegerMatrix.Create(BufA);
      try
        N := A.Rows;
        M := N;
        LDA := N;
        LWORK := N;
        INFO := 0;
        BufA.Transpose(A);
        IPIV.PreservResize([N]);
        WORK.PreservResize([N]);
        LapackDGETRF(@M, @N, BufA.ArrayAddress, @LDA, IPIV.ArrayAddress, @INFO);

        Result := 1;

        if INFO < 0 then
          ErrorArgumentIllegalValue('dgetrf', INFO);

        if not (CanRaiseException and (INFO > 0)) then
        begin
          // Вычисляем определитель
          Result := 1;
          for I := 0 to N - 1 do
            if IPIV.VecElemI[I] <> I + 1 then
              Result := -Result * BufA.Elem[I, I]
            else
              Result := Result * BufA.Elem[I, I];

          if Abs(Result) < BlasResolution then
          begin
            Result := 0;
            INFO := 1; // Дальше нужно сгенерировать исключение
          end;
        end;

        if INFO = 0 then // Решение есть!
        begin
          LapackDGETRI(@N, BufA.ArrayAddress, @LDA, IPIV.ArrayAddress,
            WORK.ArrayAddress, @LWORK, @INFO);

          if INFO < 0 then
            ErrorArgumentIllegalValue('dgetri', INFO);

          if INFO = 0 then
            X.Transpose(BufA)
          else
            if CanRaiseException then
              raise ELapackNotSolutions.Create(matNotSolutionsFounded);
        end else // Info > 0
          if CanRaiseException then
            raise ELapackNotSolutions.Create(matNotSolutionsFounded);
      finally
        BufA.FreeMatrix;
      end;              
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function LapackInverseMatrix'){$ENDIF}
  end;
end;

procedure LoadLapackProcAddresses;
begin
  // Определяем адреса функций библиотеки Lapack

  LapackDGETRF_ := GetProcAddress(HLapack, 'dgetrf');
  LapackDGESV_  := GetProcAddress(HLapack, 'dgesv');
  LapackDGETRI_  := GetProcAddress(HLapack, 'dgetri');
end;

function LoadLapackLibrary(const AFileName: string = 'matrixlapack.dll'): Boolean;
var
  HModule: THandle;
begin
  HModule := GetModuleHandle(PChar(AFileName));
  if (HLapack = 0) and (HModule = 0) then
    HLapack := LoadLibrary(PChar(AFileName))
  else
  if HLapack <> HModule then
  begin
    FreeLibrary(HLapack); // При HLapack=0 код не приведет к ошибке
    HLapack := LoadLibrary(PChar(AFileName));
  end;
  Result := HLapack <> 0;

  LapackLibShortName := ExtractFileName(AFileName);
  if LapackLibShortName = '' then
     LapackLibShortName := 'Lapack library not specified';

  LoadLapackProcAddresses;  
end;

initialization
{$IFDEF LapackLoadLibOnInit}
  LapackAutoUnload := LoadLapackLibrary();
{$ENDIF}
finalization
  if LapackAutoUnload and (HLapack <> 0) then
  begin
    FreeLibrary(HLapack);
    HLapack := 0;
  end;
end.
