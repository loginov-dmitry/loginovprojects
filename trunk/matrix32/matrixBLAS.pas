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
{ ������ matrixBLAS - ��������� �������������� � ������� BLAS.                }
{ (c) 2008 ������� ������� ���������                                          }
{ ��������� ����������: 16.03.2008                                            }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ ����� ����� ������� Lapack: http://www.nag.com/lapack/                      }
{                             http://www.netlib.org/lapack/                   }
{                                                                             }
{ *************************************************************************** }

{ *************************************************************************** }
{ BLAS (Basic linear algebra subrutines) - ��� ����� ������ ����������������  }
{ �����������, ������������ ���������� �������������� ����������� Lapack.     }
{ � ������� Matrix32 BLAS ����������� ����������� matrixatlas.dll. ������     }
{ ���������� �������� ���������-��������� � �� ��������� ��������� �������    }
{ ����������, ���������������� ��� Pentium III (��� �� ��������, ���          }
{ ���������� �� ������ �������� � ������� ������������). �������� �����       }
{ �������� ����������, ���������������� ��� PII, P4, PPro, Athlon.            }
{ ���������� matrixatlas.dll ����� ���������� ����������� �����������         }
{ matrixlapack.dll, �������� � ������ Matrix32 - � ���� ������                }
{ ��������������� �� - �����������. �� ������ �������������� �����������      }
{ ������ ��������� BLAS � Lapack � ��������� �� � �������������� �������      }
{ LoadBLASLibrary() � LoadLapackLibrary()                                     }
{ *************************************************************************** }

{ *************************************************************************** }
{ ��������! ������� BLAS ������������� �� ������� ����, ������� ����������    }
{ ���� ������� ������ ���� � ���������� CDECL                                 }
{ *************************************************************************** }

{$Include MatrixCommon.inc}

unit matrixBLAS;

interface

uses
  Windows, SysUtils, Classes, Matrix32;

type
  EBlasError = class(EMatrixError);

{:��������� ��������� ��������� � �������������� ������� "dgemm"}  
procedure BlasMulMatrices(A, B, C: TMatrix; Alpha: Double = 1; Beta: Double = 0);

{��������� ���������� BLAS, ����������� ���������-��������� ������� ����������.
 Lapack. ��� ���������� ����� ���� �����. �� ��������� ��������������}
function LoadBLASLibrary(const AFileName: string = 'matrixatlas.dll'): Boolean;

{==============================================================================
 ���� ���������� ���������, ��� ����� �������� � ���������� ���������������
 ������� ���������� BLAS. ��� ������ ���� ���� �������� ���������� ���������
 ��� ���������. ���������� ����� �����, ��� BLAS ���������� �� ��������, �
 ������� ������� ������������ ��������� (� �������) ���������� �� �������,
 ������������� � Delphi, ������� ��������� ������� ������� ����������������
 ���������������� ������������ ������
 ==============================================================================}

{:��������� ��������� �� ������� C := alpha * A * B  + beta * C.
 @param TRANSA ������, ������������, �������� �� ������� A �����������������.
  ��������� ��������: N (Not transpose), T (Transpose), C (���������� T).
 @param TRANSB ���������� TRANSA � ��������� ������� B.
 @param M ����� ����� ������� A
 @param N ����� �������� ������� �
 @param K ����� �������� ������� A (��� ����� ����� ������� B)
 @param ALPHA ���������. ������ ����� "1"
 @param A ������ �������-���������. �� ���������� �� ���������� ������ �������
 @param LDA ����� ��������� ������ ������� A (��������� ���� � "1")
 @param B ������ �������-���������. �� ���������� �� ���������� ������ �������
 @param LDB ����� ���������� ������� ������� B (��������� ���� � "1")
 @param BETA ���������. ������ ����� "0"
 @param C ������� (M x N), � ������� ������������ ��������� ���������.
 @param LDC ����� ��������� ������ ������� C (��������� ���� � "1")}      
function BlasDGEMM(TRANSA, TRANSB: PChar; M, N, K: PInteger; ALPHA, A: PDouble;
  LDA: PInteger; B: PDouble; LDB: PInteger; BETA, C: PDouble; LDC: PInteger): Integer; stdcall;

var
  HBLAS: THandle;
  BlasAutoUnload: Boolean;

  // �������� ����������� ���������� ��������� BLAS � Lapack
  // (�� ����� ���� ������ �������� - ��� �� ����� DoubleResolution �� ������ Math)
  BlasResolution: Double = 1E-12;

implementation

type
  // ��������� ���������
  TBlasDGEMM = function(TRANSA, TRANSB: PChar; M, N, K: PInteger; ALPHA, A: PDouble;
    LDA: PInteger; B: PDouble; LDB: PInteger; BETA, C: PDouble; LDC: PInteger): Integer; cdecl;

var
  BlasLibShortName: string = 'matrixatlas.dll';
  BlasDGEMM_: TBlasDGEMM; // ��������� ���������

procedure CheckBlasLibrary;
begin
  if HBLAS = 0 then
    raise EBlasError.CreateFmt(matSLibraryNotLoaded, [BlasLibShortName]);
end;


procedure CheckBlasProcAddress(AProcAddress: Pointer; const ProcName: string);
begin
  CheckBlasLibrary;
  if AProcAddress = nil then
    raise EBlasError.CreateFmt(matSProcNotFoundInLibrary, [ProcName, BlasLibShortName]);
end;

function BlasDGEMM(TRANSA, TRANSB: PChar; M, N, K: PInteger; ALPHA, A: PDouble;
  LDA: PInteger; B: PDouble; LDB: PInteger; BETA, C: PDouble; LDC: PInteger): Integer; stdcall;
begin
  CheckBlasProcAddress(@BlasDGEMM_, 'dgemm');
  Result := BlasDGEMM_(TRANSA, TRANSB, M, N, K, ALPHA, A, LDA, B, LDB, BETA, C, LDC);
end;

procedure DoBlasMulMatrices(A, B, C: TMatrix; Alpha: Double = 1; Beta: Double = 0);
var
  M, N, K, LDA, LDB, LDC: Integer;
  BufA, BufB, BufC: TMatrix;
begin
  M := A.Rows;
  N := B.Cols;
  K := A.Cols;
  LDA := M;
  LDB := K;
  LDC := M;

  BufA := TDoubleMatrix.Create();
  try
    BufB := TDoubleMatrix.Create(BufA);
    BufC := TDoubleMatrix.Create(BufA);

    // ���������� ��������� ���������� ���������� �������� - ����������������, �.�.
    // � �������� �������� ������� � ������ ����������� �����, ��� � Delphi
    // ����� ���������������� �������� �������� 13% �� ���� �������� ���������
    // ��� �� ������������� ������ ������ (�� ��������� � ��������)
    BufA.Transpose(A);
    BufB.Transpose(B);

    if Beta = 0 then
    begin
      BufC.Resize([M, N]);
      BufC.Zeros;
    end else
      BufC.Transpose(C);

    BlasDGEMM('N', 'N', @M, @N, @K, @Alpha, BufA.ArrayAddress, @LDA, BufB.ArrayAddress, @LDB,
      @Beta, BufC.ArrayAddress, @LDC);

    BufC.Reshape([N, M]);
    C.Transpose(BufC);
  finally
    BufA.FreeMatrix;
  end;
end;

procedure BlasMulMatrices(A, B, C: TMatrix; Alpha: Double = 1; Beta: Double = 0);
begin
  try
    if not IsSameMatrixTypes([A, B, C], [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if (A.Cols <> B.Rows) then
      raise EMatrixDimensionsError.Create(matSArraysNotAgree);

    if Beta > 0 then
      if (A.Rows <> C.Rows) or (B.Cols <> C.Cols) then
        raise EMatrixDimensionsError.Create(matSArraysNotAgree);

    DoBlasMulMatrices(A, B, C, Alpha, Beta);

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure DGEMM'){$ENDIF}
  end;
end;

procedure LoadBlasProcAddresses;
begin
  // ���������� ������ ������� ���������� Blas

  BlasDGEMM_ := GetProcAddress(HBLAS, 'dgemm');
end;

function LoadBLASLibrary(const AFileName: string = 'matrixatlas.dll'): Boolean;
var
  HModule: THandle;
begin
  HModule := GetModuleHandle(PChar(AFileName));
  if (HBLAS = 0) and (HModule = 0) then
    HBLAS := LoadLibrary(PChar(AFileName))
  else
  if HBLAS <> HModule then
  begin
    FreeLibrary(HBLAS); // ��� HBLAS=0 ��� �� �������� � ������
    HBLAS := LoadLibrary(PChar(AFileName));
  end;
  Result := HBLAS <> 0;

  BlasLibShortName := ExtractFileName(AFileName);
  if BlasLibShortName = '' then
     BlasLibShortName := 'Blas library not specified';

  LoadBlasProcAddresses;
end;

initialization
{$IFDEF BLASLoadLibOnInit}
  BlasAutoUnload := LoadBLASLibrary();
{$ENDIF}

finalization
  if BlasAutoUnload and (HBLAS <> 0) then
  begin
    FreeLibrary(HBLAS);
    HBLAS := 0;
  end;
end.
