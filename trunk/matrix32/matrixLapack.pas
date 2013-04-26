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
{ ������ matrixLapack - ��������� �������������� � ����������� Lapack.dll     }
{ (c) 2008 ������� ������� ���������                                          }
{ ��������� ����������: 16.03.2008                                            }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ ����� ����� ������� Lapack: http://www.nag.com/lapack/                      }
{                             http://www.netlib.org/lapack/                   }
{                                                                             }
{ *************************************************************************** }

{*****************************************************************************}
{ Lapack (Linear Algebra PACKage) - ��� ����� ���������� ��������������       }
{ ����������, ������������ �� ������ ��������� �������������� �������         }
{ (Matlab, Maple � ��.). Lapack ������ ������������ � ���� � BLAS, � ������   }
{ ��� ��������� �������� ���������� ������ �������� ���������������� ������   }
{ ���������� (��������� ������, ������� ����, LU-����������, ����������       }
{ ������� � ������ ������). ����� ������������ ��������������� ��������� �����}
{ ��������� �������, ������� ���������� ��� ������� ����������� �����         }
{ ����������� ����������.                                                     }
{ � Matrix32 ���������� Lapack ������������ ������ matrixlapack.dll, �        }
{ BLAS - ������  matrixatlas.dll. �� ������ �������������� �����������        }
{ ������ ��������� BLAS � Lapack � ��������� �� � �������������� �������      }
{ LoadBLASLibrary() � LoadLapackLibrary()                                     }
{ ������ �����, ��� ��� �������� ���������� Lapack �������� ����������        }
{ ���������� BLAS, ������� ���������� BLAS ������ ������������� ���� �        }
{ �������� � �������� EXE-�������, ���� � ������� ����������, ���� � �������� }
{ %WINDIR%\System32.                                                          }
{*****************************************************************************}

{ *************************************************************************** }
{ ��������! ������� LAPACK ������������� �� ������� ����, ������� ����������  }
{ ���� ������� ������ ���� � ���������� CDECL                                 }
{ *************************************************************************** }

{$Include MatrixCommon.inc}

unit matrixLapack;

interface

uses
  Windows, Messages, SysUtils, Classes, Matrix32, matrixBLAS, Math, dialogs;

resourcestring
  matSlauNotSolutions = '���� �� ����� �������!';
  matNotSolutionsFounded = '������ �� ����� �������!';
  matSArgumentIllegalValue = '�������� �%d ������� "%s" ����� ������������ ��������!';

{LU-���������� ������� A � ����� A = P * L * U
 @param A ������������� �������, ������� ������� ������ ���������
 @param LU ��������� ���������� (L � U - ������� ��������� � ����� �������)
 @param L ������ ����������� �������, ���������� � ���������� ����������
 @param U ������� ����������� �������, ���������� � ���������� ����������
 @param IPIV ������ ������������ �����}
procedure LapackLUFactorization(A, L, U: TMatrix; LU: TMatrix = nil; IPIV: TMatrix = nil);

{��������� ����������� ���������� ������� � ������� LU-����������. � ������� ��
 �������, � ������� ������������� ���� Double �� ��������� ��������� ������������
 ��� ������ �������� ����� 510 x 510, ������ ������� ����� ����� �������
 ����������� �� ������ ������� (������� 3000 x 3000 ������������ ��� �������).
 ������� ������������� �� ��������, ����������� ���������� ������� � ���������
 �� 0 �� 1. ������� ����� �������� ������������ ��������, ���� ���
 �� ��������� BlasResolution. �� ����������� ������ ������� ��� ��������
 ����������� ������� ����, �.�. ����� ����� ������� ������� LapackSolveSLE -
 ��� � ���� ����� � ����������� ��������. �� �� ����� �������� ������� ����������
 �������� ������� LapackInverseMatrix }
function LapackDeterminant(A: TMatrix): Extended;

{:��������� ���� (system of linear equations) A * X = B ������� LU-����������.
  ������ B ����� ��������� ������� ������ ��������.
  �������������� � ������� ����� ������� ��. �������� ���������� ����������� ��
  ������� �� ����� �������� ������� B. �� ������� Matrix32 ����� �����������
  �������� �������� ��-�� ������������� ���������������� ����������������.
  ������� ���������� ����������� ������� �. ���� ����������� = 0, ������
  ������� ��������� �� ���� ������, �.�. ��� �� ����� �������.
  ��� ������������� ��������� CanRaiseException ������� ���������� ���������� E
  LapackNotSolutions, ���� ���� �� ����� �������. ���� CanRaiseException=False,
  � ������� �� �������, �� ������� X �� ����������}
function LapackSolveSLE(A, B, X: TMatrix; CanRaiseException: Boolean = True): Extended;

{:��������� �������� ������� X � �������������� LU-����������. �� ������ - ��������
 ������������. ���� ������������ = 0, ������ �������� ������� �� ���������. � ����
 ������ ������� ��� ������ 0, ��� ����������� ���������� ELapackNotSolutions, ��
 ��������� ������� � �� ����������. �� ���������� �������� ������� ��� �������
 ����, �.�. ������� LapackSolveSLE ������� ��� ������� �����������}
function LapackInverseMatrix(A, X: TMatrix; CanRaiseException: Boolean = True): Extended;

{==============================================================================
 ���� ���������� ���������, ��� ����� �������� � ���������� ���������������
 ������� ���������� Lapack. ��� ������ ���� ���� �������� ���������� ���������
 ��� ���������. ���������� ����� �����, ��� Lapack ���������� �� ��������, �
 ������� ������� ������������ ��������� (� �������) ���������� �� �������,
 ������������� � Delphi, ������� ��������� ������� ������� ����������������
 ���������������� ������������ ������
 ==============================================================================}

{:��������� LU-���������� � ����� A = P * L * U.
 @param M ����� ����� ������� A
 @param N ����� �������� ������� A
 @param A �� ����� - �������������� ������� A. �� ������ - ������������ ����������
   L � U. ������������ �������� ������� L �� ��������
 @param LDA ����� ��������� ������ ������� A (��������� ���� � "1")
 @param IPIV ������ �������� min(M,N). ��� 1 <= i <= min(M,N), ������ i �������
   ���� �������� ������� IPIV(i)
 @param INFO ��������� ���������� ��������. ���� INFO=0, �� ���������� ���������
   ��� ������. ���� INFO<0, ��� ������, ��� �������� Abs(INFO) ����� �������.
   ���� INFO>0, �� ������ �� ����� ������� � ������� �������������� �����. }
procedure LapackDGETRF(M, N: PInteger; A: PDouble; LDA: PInteger;
  IPIV: PInteger; INFO: PInteger);

{:��������� ���� (system of linear equations) A * X = B ������� LU-����������.
 @param N ����� ����� / �������� ������� �
 @param NRHS ����� �������� ������� �
 @param A ������� �����. ����� ���������� � ������ �������� ���������� LU-����������
 @param LDA ����� ��������� ������ ������� � (��������� ���� � "1")
 @param IPIV ������ ������������ �����, ����������� ��� LU-����������
 @param B ������� �����. ����� ���������� � ������ �������� �������� ������� �
 @param LDB ����� ��������� ������ ������� B (��������� ���� � "1")
 @param INFO ��������� ���������� ��������. ���� INFO=0, �� ������� ���� ���������
   �������, ����� - �������� ���������, ���� ���� �� ����� ������� }
function LapackDGESV(N, NRHS: PInteger; A: PDouble; LDA, IPIV: PInteger; B: PDouble;
  LDB, INFO: PInteger): Integer;

{:��������� �������� ������� �� ����������� LU-����������
 @param N ����� ����� / �������� ������� �
 @param A �� ����� - ����������� ������� L � U �� ����������� LU-����������.
   �� ������ - ����������� �������� �������
 @param LDA ����� ��������� ������ ������� � (��������� ���� � "1")
 @param IPIV ������ ������������ �����, ����������� ��� LU-����������
 @param WORK ������ �������������� �������������
 @param LWORK ������ ������� WORK
 @param INFO ��������� ���������� ��������. ���� INFO=0, �� ���������� ��������
   ������� ������ �������, ����� - �������� ���������, ���� ������� ����������,
   �.�. �������� ������� �� ����������}
procedure LapackDGETRI(N: PInteger; A: PDouble; LDA: PInteger; IPIV: PInteger;
    WORK: PDouble; LWORK: PInteger; INFO: PInteger);

var
  HLapack: THandle;
  LapackAutoUnload: Boolean;

type     
  ELapackError = class(EMatrixError);
  ELapackNotSolutions = class(ELapackError); // ��� �������

{:��������� ���������� "Lapack.dll". ���� ����� ��� ��� ���� ���������, ��
  ������� ������ ��� �����, �� ������ ���������� ����������� � ��������
  ��������� ����������. ��������� Lapack ������� �� ��������� ���������, �����
  ��������� ���������� ���������, ��� ��� ��� ��������� � ������� ����������}
function LoadLapackLibrary(const AFileName: string = 'matrixlapack.dll'): Boolean;

procedure ErrorArgumentIllegalValue(const ProcName: string; Info: Integer);

implementation

type
  // LU - ����������
  TLapackDGETRF = procedure(M, N: PInteger; A: PDouble; LDA: PInteger;
    IPIV: PInteger; INFO: PInteger); cdecl;

  // ������� ����
  TLapackDGESV = function(n, nrhs: PInteger; a: PDouble; lda, ipiv: PInteger; b: PDouble;
    ldb, info: PInteger): Integer; cdecl;

  // ���������� �������� �������  
  TLapackDGETRI = procedure(N: PInteger; A: PDouble; LDA: PInteger; IPIV: PInteger;
    WORK: PDouble; LWORK: PInteger; INFO: PInteger); cdecl;
var
  { �������� ��� ����� ���������� Lapack }
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

      // ���������� ������ ������������ �����
      if Assigned(IPIV) then
        IPIV.MoveFrom(BufIPIV);

      // ��������� ������� ����������� �������
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

      // ��������� ������ ����������� �������
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

      // ���������� ������, �������������� ����������� Lapack
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

        // ��������� ������������
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
  N := A.Rows; // ����� ����� / �������� ������� �
  Nrhs := B.Cols; // ����� �������� ������� �
  lda := N; // ����� ��������� ������ ������� �
  ldb := N; // ����� ��������� ������ ������� �
  info := 0; // ����� ���������� ��������

  BufA := TDoubleMatrix.Create(); // ������� �����. ����� ���������� � ������ �������� ���������� LU-����������
  BufB := TDoubleMatrix.Create(BufA); // ������� �����. ����� ���������� � ������ �������� �������� ������� �
  IPiv := TIntegerMatrix.Create(BufA); // ������ �������� ������������ �����
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
      // ��������� ������������
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
      X.Transpose(BufB) // �������� ����������������
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
          // ��������� ������������
          Result := 1;
          for I := 0 to N - 1 do
            if IPIV.VecElemI[I] <> I + 1 then
              Result := -Result * BufA.Elem[I, I]
            else
              Result := Result * BufA.Elem[I, I];

          if Abs(Result) < BlasResolution then
          begin
            Result := 0;
            INFO := 1; // ������ ����� ������������� ����������
          end;
        end;

        if INFO = 0 then // ������� ����!
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
  // ���������� ������ ������� ���������� Lapack

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
    FreeLibrary(HLapack); // ��� HLapack=0 ��� �� �������� � ������
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
