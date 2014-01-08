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
{ ������ Matrix32 - ���� �������������� ������� Matrix32                      }
{ (c) 2005 - 2011 ������� ������� ���������                                   }
{ ��������� ����������: 06.08.2011                                            }
{ �������������� �� D7, D2007, D2010                                          }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{=============================================================================}
{====================== ��������� �������� ���������� ========================}

{� Matrix32 ��������� �������� ���������� �������� �� ��� ����: ��������� � �����.
 ����� ��������� ����� �������������� � ��������� �������, ���������� ��
 Matrix32. ����� ��������� �������� � ����� "MatrixCommon.inc".
 ��������� ��������� ��������� � ���� ������ � ����� ����� ������ � ���}

{$Include MatrixCommon.inc}

{������� . ���� �� ������, ����� ������� CalcOperation ����� ���������� �������,
 ��������� �� ������ ��������. �� ��������� ������� ��������, ������������ �
 ��� ������� ������ ���� �����������. ������ ������ ������ ������, ���� �
 ����������� ����� ����������� ����-���������� �������. �� ��� �����������
 �������� ������ �����. ������ �����, ��� ��� ���������� ����� �������� ������
 ������� CalcOperation ��������� ��-�� ���������� �������������� ��������.
 ������������� ��� ��������� ����-���������� �������� ������������ ValueOperation()}
{$DEFINE ExtendedCalcOperation}

{������� . ���� �� ������, ����� ������� MatrixNameIsValid() ��� ��������
 ����� ������� ���������� ������ �����, ���������� ��� ������� Matlab.
 ���� ����� ���������, �� ������� ����� ����������� �� ����� (������ �����������
 �� ����� ����� ����������� �� �������� �� ���� �����)}
{$DEFINE CheckMatrixName}

{���� ������ ����� ��������, �� ������� TMatrix.IsLiving ��������� ������ ��
 ������ Self � ������� GUID ���� ����������� ������. ���� ����� ���������,
 �� ������� ������ True ��� ���� ��������� Self. ���������� ����� ��������
 ��������� ��������� �������� ������ Matrix32, ������ ����� ��������� �������}
{$DEFINE IsLivingEnabled}

    {������� . ���� �� ������, ����� Matrix32 �������� �������� ������������� �������
     �������� IsLiving() � ������� ���������� GUID, �������� � ������ ������
     ���������� ������ TMatrix. ����� ��� �������� �����, ���� �� �����������
     ������ ���������� � � ��� � � DLL ��� ���������� � bpl-�����
     ���� ������ ����� ���������, �� ��� ������ ������� IsLiving() �����
     �������������� ���������� ������ MatrixInstanceList.
     ������ ������ ����������� "�������" ������� ��������� �����
     ��������, ��� ��� ������������� GUID, ������ ���� �� ������ ������������
     �������� ������ ����� EXE � DLL, �� ��� �������� �������������� ������ ������
     � ���� run-time bpl-������ � ��������������� � �������� ��� EXE ��� � DLL.
     ����� ������ MatrixInstanceList ������ ����� � ������� IsLiving()
     ����� �������� ���������}
    {$IFDEF IsLivingEnabled}
      {.$DEFINE UseLifeGuid}
    {$ENDIF}

    {������� . ���� �� ������, ����� Matrix32 �������� ������ ������������ ������
     Free(), ������� ����������� � ������ TObject, ����������� ��������� �������
     ������. ����������� ����� Free() ������� �� ������� ����������, ���� �� ��������
     � ���, ��� ������ � ���������������� ����������. ������� ����� �����, ���
     ����������� ����� Free() �� ����������� ����� TObject.Free(). ������� �������
     ����� ��������� ���� ������ �������� � ������� ������ TMatrix ���� � �������
     ������ ������� ������-���������� �� TMatrix}
    {$IFDEF IsLivingEnabled}
      {.$DEFINE UseExtendedFree}
    {$ENDIF}

{����� AddDebugInfoToExceptObject ��������� ������� Matrix32 ��� �������������
 ���� ���� ����� ���������� ��������� � ����� ���������� ��������������
 ���������� �� ���������� (�������� ������ ���� �������, ����� ������� ������
 � ������������� ����������). ��� ���������� ���������� ������� ���������� �����
 ������� ��� ������ ������� ������������� ���� ��� ����� ����������}
{$DEFINE AddDebugInfoToExceptObject}

{��������� ������������ ������ ��� �������������� ����������� ����� � ������.
 �������� ����������� ��������� ���������� MatrixNumberDelimiter}
{$DEFINE UseSpaceDelimiter}

{�������� ��������� ���� ��������������� �������� ������� ������� Base.
 ������� �������, ����������� � ������ ������, ����� ���� �������� � ������
 ������ ������� ����� ��� � DLL ��� �������, ��� ������ Matrix32 �������������
 � ���� run-time ������. � ���� ������ ������ Base ����� ��� EXE � DLL �����}
{$DEFINE CreateBaseWorkspace}

{���� ����� ��������, �� ��� ������ �� ��������� ������� ���������� � �������
 ��������������� �������� TMatrix. ������ ������ ����� ������������� ������������
 ��������������� ����������� ���������� FastMM4 (������� � Delphi2006, ����������
 �������� � ������ ����������� ���������)}
{$DEFINE EnableMemoryLeakReporting}

{�������� ����������� ������������� ������ LDSLogger ��� ���������� �����. ���
 ������� ����� ������ ��������� ������� �������� �������� ������}
{.$DEFINE UseLogger}

{====================== ��������� �������� ���������� ========================}
{=============================================================================}

{����������: ����������� ������������, ������� �� ��������� �� ���� ������������
 � �������, ��������������� ����������� �������, � ������������� ����������
 � ���������� ������� Matrix32, ������������ ���������� Time2Help.}

{====================== ������� �������� Matrix32 ============================}

{:������� ������ (����) �������������� ������� Matrix32.
 <h2>������� �������� ����������</h2>

 <p>������������ � ������ ����� ��������� �������������� ����� ������� ����������
 ��������������� ������������ ��� �� �������. ����� �� ����� ������������ ��������
 �������������� ������� Matrix32. ��� ������������ ����������, ���������������
 ������������ ������� ����� ������� ��� ������� �������������� �����. �����������,
 ���������� � Matrix32, ��������� ��������� ��������� �����:
 <ul>
   <li>�������� ������ (������ ������)
   <li>������� �������
   <li>������ �����
   <li>������
 </ul>
 ����� ����� ������� �������� ����������� ��� ���������� ����������� ��������������
 �����.
 <p>Matrix32 ������������ �� ������������� �������������� ���������. ������������
 ����� ���������� ��� ���������� �������������� ������� ����� �� ����������� �
 ���, ������ ������ ���� ����� ������� � ������� ��� ���������. ���� �� ������
 ��������� Byte, ��� �� ������ ��������� Extended - ��� ���� ������� ����������
 ���������������� ����� �������������� �������. ��������, �� ����������� �������
 ��� ������� ������� �������� �������������� ��������� � ������� �� SLAU.<br>
 <code>  procedure SLAU(A, B, X: TMatrix);</code>
 ��� A - ������� �������������, B - ������ ��������� ������, X - ������, � �������
 ������ ���� ������� ���������. �� �������� �������������� ��, ����� ��� ���������
 � ����� �� ��������. ����� �� ��� ��������� � ��� ��� ���� ������� �� ���,
 ���� ������� � ����� ������ ����� ������� ��������� � ������� ��������� � �.
 <p>���� �� ���������� ������� SLAU ��� ������������� ������� Matrix32, �� � ����
 ������ �� ������� ������������ ����� ������� ��������, ��������� ��� ����������
 � ������� ������ ������� ���� �������, ������� ��� ������� ������������. �� ������
 �������� ������������� �������� ������� SLAU, ������ �������� ��� �� �� �������.
 <p>����������� ������� SLAU ����������� ��������� �������:
 <ul>
   <li>����������� ��� 2-������� ������������� �������
     <code>TDynExtendedMatrix = array of array of Extended;</code>
   <li>����������� ��� ������������� �������-�������
     <code>TDynExtendedVector = array of Extended;</code>
   <li>������� ����������� ���:
     <code>procedure(const A: TDynExtendedMatrix;
    const B: TDynExtendedVector; var X: TDynExtendedVector);</code>
 </ul>
 ������������ ����� ������� ����� ������ ����� ������ ��������.
 <p>������ ������ ��������� ������������ ������������ ����, ����������� �
 ����� ���������� (� ������ ������ ��� TDynExtendedMatrix � TDynExtendedVector).
 ���� ���� ������������ �� ��������� ������������� ���� Extended, ��� ��������
 � ���� ����� ��������, ����� �� �� ������ ��������������� �������������,
 ���������������� ��� ����� ��������. ������������ ���� �� ����������, ����
 �� ���� ������� ������������ ������� ������, ������ ��� ���������� ��������
 � �������������� ��������� ������ �� �������� ��������� � ������� Extended.

 <p>��� ���� �������, Matrix32 ��������� ������������ ���������� � �������
 SLAU ������� � ����� ����� ���������. ��� ������ ���� ������� ����������� ������,
 � � �� �� ����� ������� �������� �������������� ������� ������ (������������
 ��� ������, � ����� ������� ��� ����� ������� �������� ���� ��� ����� �������).

 <p>��� ������� ������ ����, ��� ������������ ����� ������������ ������� SLAU,
 ���������� �� ���������� Matrix32:
 <code>
  var
    A, B, X: TMatrix;
  begin
    // ������� ������ ������������� (��� ��������� - Byte)
    A := TByteMatrix.Create();
    try
      // ������� ������ ��������� ������ (��� ��������� - Short)
      B := TShortMatrix.Create(A);
      // ������� ������-��������� (��� ��������� - Integer)
      X := TIntegerMatrix.Create(A);
      
      // ��������� ������ �������������
      A.AsString := '2, 5, 7; 1, 0, 8; 3, 5, 1';
      // ��������� ������ ��������� ������
      B.AsString := '1; 2; 3';
      // ��������� ����
      SLAU(A, B, X);
      // ������� ���������
      ShowMessage(X.AsString);
    finally
      A.FreeMatrix;
    end;
  end;
 </code>

 <p>�������, ��� ��� ������� �������������� ��������, � ������ �������
 Matrix32 ������� ������ ������������.
 <p>����� ������� � �������� ������� �����������!}
unit Matrix32;

interface

uses
  Windows, SysUtils, Math, Classes, SysConst, Variants, SyncObjs, DateUtils
  {$IFDEF UseLangReader}, LangReader{$ENDIF} {$IFDEF UseLogger}, LDSLogger{$ENDIF};

{��������� D2009PLUS ����������, ��� ������� ������ Delphi: 2009 ��� ����}
{$IF RTLVersion >= 20.00}
   {$DEFINE D2009PLUS}
{$IFEND}

{$IF RTLVersion >= 24.00}
   {$DEFINE DXE3PLUS}
{$IFEND}

const
  {:������������ ����� ����� �������. �� ������ ������������� ������, ��� 255}
{$IFDEF CheckMatrixName}
  MaxArrayNameLength = 32; // 32 - ������������ ����� ����� ��� ������� Matlab
{$ELSE}
  MaxArrayNameLength = High(Byte);
{$ENDIF CheckMatrixName}

  {:������������ ����� ���������� ������ �������}
  MaxSignatureLength = 12;

  { TODO : ������� �� ��� ������ � BCD-�������}
  {:������������ ���-�� ���� � �������-���������� �����. ������ ��� ��������
   ������������ ��� ����������� � ����������� ���� TBCDNumber. �� ������� ��������
   ��� ����� ������ 18 (��� ����� ��� ���� �������������� ������������ ���������
   ������). �������� ��������� ������ ���� ������� ����� 2}
  MaxBCDLength = {1024}6;

  {:������, ������������� �� ����� DecimalSeparator � ��������� ���������������
   ����� � ������ ��������� ������� Matrix32}
  MatrixDecimalSeparator = '.';

  {:������, ������� ���������� ���� �� ����� ����� � ������}
  MatrixNumberDelimiter = ',';

  {:������, ������� ���������� ������ ���� �� �����}
  MatrixRowsDelimiter = ';';

  {:������ ������ ����� ������������ �����}
  ComplexImagSymbol: Char = 'i';     

type
  {:�������� �����, �������������� ���������� ��������� TMatrix}
  TMatrixType = (mtNumeric, mtInteger, mtInt64, mtFloat, mtComplex, mtCell,
    mtObject, mtRecord, mtDynamic, mtWorkspace, mtChar, mtNetwork);

  {:��������� �����, �������������� ���������� ��������� TMatrix}
  TMatrixTypes = set of TMatrixType;

  {:��������� ���� �������� Char}
  {��� ���������� ��� ���� � ������ Delphi:
  TSysCharSet = set of AnsiChar;}

  {:��� ��� ���������� ���������� ����� ������}
  TSignature = string[MaxSignatureLength];

  {:��� ��� ���������� ����� ������� TMatrix}
  TMatrixName = string;

  {:������������ ������ ����� Integer}
  TDynIntArray = array of Integer;         

  {:�������� ����� ������� ������}
  TMethodKind = (mkProc, mkFunc, mkConstructor, mkDestructor);

  PShortArray = ^TShortArray;
  TShortArray = array[0..MaxInt div SizeOf(Short) - 1] of Short;

  PShortIntArray = ^TShortIntArray;
  TShortIntArray = array[0..MaxInt div SizeOf(Shortint) - 1] of Shortint;

  PWordArray = ^TWordArray;
  TWordArray = array[0..MaxInt div SizeOf(Word) - 1] of Word;

  PCardinalArray = ^TCardinalArray;
  TCardinalArray = array[0..MaxInt div SizeOf(Cardinal) - 1] of Cardinal;

  PExtendedArray = ^TExtendedArray;
  TExtendedArray = array[0..MaxInt div SizeOf(Extended) - 1] of Extended;

  PSingleArray = ^TSingleArray;
  TSingleArray = array[0..MaxInt div SizeOf(Single) - 1] of Single;

  PDoubleArray = ^TDoubleArray;
  TDoubleArray = array[0..MaxInt div SizeOf(Double) - 1] of Double;

  PCompArray = ^TCompArray;
  TCompArray = array[0..MaxInt div SizeOf(Comp) - 1] of Comp;

  PCurrencyArray = ^TCurrencyArray;
  TCurrencyArray = array[0..MaxInt div SizeOf(Currency) - 1] of Currency;

  PInt64Array = ^TInt64Array;
  TInt64Array = array[0..MaxInt div SizeOf(Int64) - 1] of Int64;

  PPointerArray = ^TPointerArray;
  TPointerArray = array[0..MaxInt div SizeOf(Pointer) - 1] of Pointer;

  PSingleComplexArray = ^TSingleComplexArray;
  PSingleComplex = ^TSingleComplex;
  TSingleComplex = packed record mReal, mImag: Single; end;
  TSingleComplexArray = array[0..MaxInt div SizeOf(TSingleComplex) - 1] of TSingleComplex;

  PDoubleComplexArray = ^TDoubleComplexArray;
  PDoubleComplex = ^TDoubleComplex;
  TDoubleComplex = packed record mReal, mImag: Double; end;
  TDoubleComplexArray = array[0..MaxInt div SizeOf(TDoubleComplex) - 1] of TDoubleComplex;

  PExtendedComplexArray = ^TExtendedComplexArray;
  PExtendedComplex = ^TExtendedComplex;
  TExtendedComplex = packed record mReal, mImag: Extended; end;
  TExtendedComplexArray = array[0..MaxInt div SizeOf(TExtendedComplex) - 1] of TExtendedComplex;

  TDynExtendedComplexArray = array of TExtendedComplex;

  PBCDNumber = ^TBCDNumber;
  TBCDNumber = packed record
    BCDPrecision    : Short; // ������� ����� ����� (����� �������� �����)
    BCDSeparatorPos : Short; // ����� �����, ����� ������� ������� ���������� �����
    BCDSigned       : Short; // 1, ���� ����� �������������
    BCDData: array[0..MaxBCDLength div 2 - 1] of Byte; // ���������� ������
  end;

  {:��� �������������� ��������, ������������ �������� TMatrix.CalcOperation}
  TFloatOperation = function(const Value1, Value2: Extended): Extended;
  {:��� �������������� ��������, ������������ �������� TMatrix.CalcOperation}
  TIntOperation = function(const Value1, Value2: Integer): Integer;
  {:��� �������������� ��������, ������������ �������� TMatrix.CalcOperation}
  TInt64Operation = function(const Value1, Value2: Int64): Int64;
  {:��� �������������� ��������, ������������ �������� TMatrix.CalcOperation}
  TComplexOperation = function(const Value1, Value2: TExtendedComplex): TExtendedComplex;

  {:��� �������, ������������ �������� TMatrix.CalcFunction}
  TFloatFunction = function(const Value: Extended): Extended;
  {:��� �������, ������������ �������� TMatrix.CalcFunction}
  TIntFunction = function(const Value: Integer): Integer;
  {:��� �������, ������������ �������� TMatrix.CalcFunction}
  TInt64Function = function(const Value: Int64): Int64;
  {:��� �������, ������������ �������� TMatrix.CalcFunction}
  TComplexFunction = function(const Value: TExtendedComplex): TExtendedComplex;
  {:��� �������, ����������� �������� FloatToString}
  TFloatToStringFunction = function(Value: Extended): string;

  {:���������� ����� ���� ����� ������� ������ �� ����� ����� TMatrix}
  TMatrixClass = class of TMatrix;

  {:���������� ������� ���� �������� ���������� �� ���������� ���� TMatrix}
  PMatrixObject = ^TMatrix;

  {:������ ������ ������������ ��� ������ � ������������ EMatrixError}
  TMatrixErrorInfo = record
    MatrixName: string;                 // ��� ������� TMatrix
    MatrixClassName: string;            // ��� ������ ������� TMatrix
    MatrixClassType: TMatrixClass;      // ����� ������� TMatrix
    MatrixUsedMemory: Integer;          // ����� ������, ���������� ��������
    MatrixDimensions: TDynIntArray;     // ������� ������� ������
    MatrixElementsCount: Integer;       // ����� ��������� � �������
    MatrixElementSize: Integer;         // ������ �������� ������� � ������
    MatrixCopiedByRef: Boolean;         // �������� ������, ���������� �� ������
    MatrixFieldsCount: Integer;         // ����� ����� (��� ������)
    MatrixChildrenCount: Integer;       // ����� �������� ��������
    MatrixErrorFuncName: string;        // ��� �������, � ������� �������� ����������
  end;

  EMatrixError = class(Exception)
  private
    {�������������� ���������� �� ������}
    FMatrixInfo: TMatrixErrorInfo;
    
    {������������������ ������ ��������, ��������� � ������ EMatrixError}
    FExceptStack: string;
  public
    {:���������� �� ������� TMatrix}
    property MatrixInfo: TMatrixErrorInfo read FMatrixInfo write FMatrixInfo;
    {:���� �������, ��������� � ������� ����������}
    property ExceptStack: string read FExceptStack write FExceptStack;
  end;

  EMatrixRefError = class(EMatrixError);
  EMatrixBadRef = class(EMatrixRefError);
  EMatrixParsingError = class(EMatrixError);
  EMatrixStreamError = class(EMatrixError);
  EMatrixFileStreamError = class(EMatrixStreamError);
  EMatrixClassError = class(EMatrixError);
  EMatrixAliasError = class(EMatrixClassError);
  EMatrixBCDError = class(EMatrixError);
  EMatrixMemoryError = class(EMatrixError);
  EMatrixAbstractError = class(EMatrixError);
  EMatrixDimensionsError = class(EMatrixError);
  EMatrixWrongCoords = class(EMatrixError);
  EMatrixBadName = class(EMatrixError);
  EMatrixBadParams = class(EMatrixError);
  EMatrixWrongElemType = class(EMatrixError);
  EMatrixFunctionError = class(EMatrixError);
  EMatrixMatlabError = class(EMatrixError);

  {����� ���� �������, ����������� � ���� ������, �� ������ ��������� �������
   ��������� �������: }
  TByteMatrix = class;
  TShortIntMatrix = class;
  TCharMatrix = class;
  TShortMatrix = class;
  TWordMatrix = class;
  TIntegerMatrix = class;
  TCardinalMatrix = class;
  TInt64Matrix = class;

  TSingleMatrix = class;
  TDoubleMatrix = class;
  TExtendedMatrix = class;
  TCompMatrix = class;
  TCurrencyMatrix = class;

  TSingleComplexMatrix = class;
  TDoubleComplexMatrix = class;
  TExtendedComplexMatrix = class;
          
  TCellMatrix = class;
  TRecordMatrix = class;
  TWorkspace = class;    

  {================================ ����� TMatrix ==============================}
  {:������� ����� ��� ���� �������� Matrix32. ����� �������� �����������,
   ������� �� �� ������� ��������� ������� � ������� ������� ������.}
  TMatrix = class(TObject)
  private
    FName: TMatrixName;      // ��� �������
    FHash: Integer;          // ��� ����� �������

    FArrayList: TList;       // ������ �������� ��������
    FOwnerMatrix: TMatrix;   // ������ - ��������
    FNotifyList: TList;      // ������ ��������, ������� ����� ���������� �� �����������

    {������ ���������� �� ��������� ���������.
     ������ ��������� ������ ��� �������������}
    FPointerList: TList;

    {$IFDEF UseLifeGuid}
    FLifeGUID: TGUID;
    {$ENDIF UseLifeGuid}

    function GetDimensionCount: Integer;
    function GetDimension(Index: Integer): Integer;
    procedure SetDimension(Index: Integer; const Value: Integer);
    procedure SetCols(const Value: Integer);
    procedure SetRows(const Value: Integer);
    procedure SetMatrixName(const Value: TMatrixName);
    function GetMatrices(Index: Integer): TMatrix;
    procedure SetOwnerMatrix(const Value: TMatrix);
    function GetMatrixByName(const AName: TMatrixName): TMatrix;

    {���������, ����� �� ��������� �������� CalcOperation. ���������� ���������
     ������ AMatrix, ������� �������� ��������� ������ �������}
    function CheckForCalcOperation(const Matrices: array of TMatrix;
      var AMatrix: TMatrix): TDynIntArray;

    {:�������� ��� ��������� ������. �� ������ ������ ������������
     ����������� "�������" ����� ��������� ������. ����� �������� ��� �
     �������������, ��� � � ������������ �������}
    procedure DoMulMatrix(Matrix1, Matrix2: TMatrix);
    function GetValue: Extended;
    function GetValueCells: TMatrix;
    function GetValueCx: TExtendedComplex;
    function GetValueI: Integer;
    function GetValueI64: Int64;
    function GetValueStr: string;
    procedure SetValue(const Value: Extended);
    procedure SetValueI(const Value: Integer);
    procedure SetValueI64(const Value: Int64);
    procedure SetValueCx(const Value: TExtendedComplex);
    procedure SetValueCells(const Value: TMatrix);
    procedure SetValueStr(const Value: string);

  protected

    {================= ������ ������� � ��������� �������-������� =============}
    {������������ ��� ��������� ��������� ��������� ������ �������}
    function GetVecElem(const Index: Integer): Extended; virtual;
    function GetVecElemI(const Index: Integer): Integer; virtual;
    procedure SetVecElem(const Index: Integer; const Value: Extended); virtual;
    procedure SetVecElemI(const Index, Value: Integer); virtual;
    function GetVecElemI64(const Index: Integer): Int64; virtual;
    procedure SetVecElemI64(const Index: Integer; const Value: Int64); virtual;
    function GetVecElemCx(const Index: Integer): TExtendedComplex; virtual;
    procedure SetVecElemCx(const Index: Integer;
      const Value: TExtendedComplex); virtual;
    function GetVecElemStr(const Index: Integer): string; virtual;
    procedure SetVecElemStr(const Index: Integer; const Value: string); virtual;
    function GetVecCells(const Index: Integer): TMatrix; virtual;
    function GetVecObjects(const Index: Integer): TObject; virtual;
    procedure SetVecCells(const Index: Integer; const Value: TMatrix); virtual;
    procedure SetVecObjects(const Index: Integer; const Value: TObject); virtual;
    function GetVecChar(const Index: Integer): Char; virtual;
    procedure SetVecChar(const Index: Integer; const Value: Char); virtual;

    {================ ������ ������� � ��������� 2-������� ������� ============}
    function Get_Elem(const Row, Col: Integer): Extended; virtual;
    procedure Set_Elem(const Row, Col: Integer; const Value: Extended); virtual;
    function Get_ElemI(const Row, Col: Integer): Integer; virtual;
    procedure Set_ElemI(const Row, Col, Value: Integer); virtual;
    function Get_ElemI64(const Row, Col: Integer): Int64; virtual;
    procedure Set_ElemI64(const Row, Col: Integer; const Value: Int64); virtual;
    function Get_ElemCx(const Row, Col: Integer): TExtendedComplex; virtual;
    procedure Set_ElemCx(const Row, Col: Integer;
      const Value: TExtendedComplex); virtual;
    function Get_ElemStr(const Row, Col: Integer): string; virtual;
    procedure Set_ElemStr(const Row, Col: Integer; const Value: string); virtual;
    function Get_ElemChar(const Row, Col: Integer): Char; virtual;
    procedure Set_ElemChar(const Row, Col: Integer; const Value: Char); virtual;
    function Get_Cells(const Row, Col: Integer): TMatrix; virtual;
    procedure Set_Cells(const Row, Col: Integer; const Value: TMatrix); virtual;
    function Get_Objects(const Row, Col: Integer): TObject; virtual;
    procedure Set_Objects(const Row, Col: Integer; const Value: TObject); virtual;

    function GetAsString: string; virtual;
    procedure SetAsString(const Value: string); virtual;
    function GetArrayAddress: Pointer; virtual;
    procedure SetArrayAddress(const Value: Pointer); virtual;
    function GetAsStringEx: string; virtual;
    procedure SetAsStringEx(const Value: string); virtual;

    function GetFields(const AName: TMatrixName): TMatrix; virtual;
    procedure SetFields(const AName: TMatrixName; const Value: TMatrix); virtual;
  protected

    {:������ �������� ������� � ������}
    FElemSize: Integer;

    {:������ ������� � ������}
    FArraySize: Integer;

    {:������ ������� �������. ������� ����� �����, ��� � Matrix32 �������
     ����������� �������� � ������ ������� FDimensions, � ������� � �����.
     �.�. ���� ���� ������� (5 � 6), �� FDimensions[0] = 5, � FDimensions[1] = 6,
     ������� ������������ ������� ������ ������������ � ��������� ������ FDimensions}
    FDimensions: TDynIntArray;

    {:���������� ��������� �������}
    FElemCount: Int64;

    {:������ �������������� ��������� �������}
    FRows: Integer;

    {:������ ���������� ��������� �������}
    FCols: Integer;

    {:��������� �����, �������������� ��������}
    FMatrixTypes: TMatrixTypes;

    {:����� �������� � �������, � �������� ���������� ���������� �������. �
     ����������� ������� ������� ������������ �������, ������������ ����������
     ����� ����������� �������. ���� ������ 2-������, �� FBeginOfArray = 0}
    FBeginOfArray: Integer;

    {:����� ���������, �������� � ������ �����������. ��������, ���� ���� ������
     A(5, 5, 5), �� <br>
     FDimensions = [5, 5, 5] <br>
     FElemInDimensions = [125, 25, 5] <br>
     ���� ������ ������������ ��� ��������� �������� ������� � ���������
     ������������ �������}
    FElemInDimensions: TDynIntArray;

    {:����������, �������� �� ������ ������ �� ������}
    FIsCopyByRef: Boolean;

    {:��������� ������� ������ ��� ��������� ������� �������
     @raises EMatrixMemoryError ������������ ������ ��� ��������� �������� �������}
    procedure CheckMemoryForResize(ElementsCount: Int64);

    {:���������� ���������� ����� �������� ������� � ������� ������� ��������
     FElemInDimensions. ������������ � ��������� ������� � ��������
     ������� �� ����������� ��������, �������� � �������� ������}
    function GetOrderNum(const Values: array of Integer): Integer;

    {:����������� ������� �������� � ����� ��������� ��������� ��������
     � ������������ � ���������� ��������� ��� ����������������� ������
    (����������������� ���������� ��������� �������)}
    procedure SetDimValues(const DimValues: array of Integer); virtual;

    {:��������� �������������. ���������� ����� ����� Create. �� ������ �����������
     ������ ��������� � ����� �����������, ��� ������� �� �������������
     ���������� ������������}
    procedure Init; virtual;

    {:���������, ��������� �� ������ ����� ������ � ����� �������
     @raises EMatrixWrongCoords ������� � ���������� ������������ �� ����������}
    procedure CheckRowAndCol(Row, Col: Integer);

    {:��������� ���� �� ������� � ��������� ���������� �������.
     @raises EMatrixWrongCoords ������� � ��������� ������� �� ����������}
    procedure CheckVecIndex(const Index: Integer);

    {:����������� ���������� ������� ����� �����.
     @raises EMatrixDimensionsError ������� ������������ �������, ���� ���������
       ��������� �������� MaxInteger}
    function ProdDimensions(const DimValues: array of Integer): Int64;

    {:������������ �������� ������. ����������� �������� ��������� � �������
     ������ FArrayList. ��� �������� ������� �� ����� ����� ���������� ���,
     ������� ���� �������� ������ � ������ AMatrix.MatrixName ��� ����,
     �� �� ����� ���������. ������ ������ �� ��������� � �������� ��������
     �������� ����������, � �� ��� ����� ����������� ������������� ����������
     ��� �������� �������.
     @param AMatrix ������, ������� ���������� ����������������.}
    procedure RegisterChildMatrix(AMatrix: TMatrix); virtual;

    {:��������� �������������� ���������� ��������� �������.
     �������� ������� ������� ���������� ����� ���������� �� ����� �����������.
     ��� ����� ��� �������� ������� ��������� UnRegisterChildMatrix.
     @param AMatrix ������, ������� ���������� �����������������.}
    procedure UnRegisterChildMatrix(AMatrix: TMatrix); virtual;

    {:���������� ������ ������, ��� ��������� ������ ������ �����������.
     � ������� ������ TRecordMatrix �� ���� ��� ����� ����������� ������
     ���������� ������ ����� ������ ������� ������. � ������ ������� �����
     TCellMatrix ������ ����� ������ ���������� � ����� �����������.
     @param AMatrix ������, ������� ���������� � ����� �����������.}
    procedure DeletionNotify(AMatrix: TMatrix); virtual;

    {:��������� Notify-������ � ������. ����� ������ ������������ � �����
     ������� �� ��� ���� ����, ��� ��������� ���� � �������� Notify-�������
     � ������ FNotifyList ����� ����. ������ ����� �� ��������� � �����
     ������� ������ ���� �����. ���� � ��� �� ������ TMatrix ����� ���������
     ������������ � ��� ���� ������ TRecordMatrix � ��� ������ �������
     TCellMatrix. ������ �� ��� ��� ������� �� ������ � ������ FNotifyList.
     � ����������, ���� ������ ����� ������������, �� �������� �� ����
     ���� ��������, ������������������ � ��������� ������.}
    procedure AddNotifyClient(AMatrix: TMatrix);

    {:������� Notify-������� �� ������.}
    procedure DeleteNotifyClient(AMatrix: TMatrix);

    {:������� ������ ���������� EMatrixAbstractError.
     @param MethodName �����, � ������� ���������� ����������
     @param MethodKind ��� ������ (���������, �������, �����������, ����������)}
    function CreateAbstractErrorObj(MethodName: string; MethodKind: TMethodKind = mkProc): Exception;

    {:��������� ������ �������� ������.
     ���������� ������ �������� ������, ������� ��� ������ (�������, ���������
     � �.�.), ��� ������ �������, ��� ������. � ���������� ���������� ��������
     ���������: "procedure TMatrix.FreeMatrix". ������������ � ����� MethodName
     ��������� �� �����������. ������������� ������ ������� ��������� �������
     ��������� ������� ������������ �����, ��� ��� ��� ��������� ������
     ���������� ����� ��������� �� ������ �������� ������, � ������ ��� ���.}
    function FormatMethodName(MethodName: string; MethodKind: TMethodKind = mkProc): string;

    {:������� ������ ���������� ������ EClass c ������� ������ AMessage.
     @param EClass ����� ������������ ������� ����������
     @param AMessage ����� ��������� �� ������
     @param MethodName �����, � ������� ���������� ����������
     @param MethodKind ��� ������
     ������������ ����������� ��������� �������������� ���������� ����������}
    function CreateExceptObject(EClass: ExceptClass; AMessage: string;
      MethodName: string = ''; MethodKind: TMethodKind = mkProc): Exception;

    {:����������� ������ ���������� ExceptObj � ����� ���������� � ����
     �������������� ���������� ����������.
     @param ExceptObj ������ ����������, �������������� ���������� try...except
     @param MethodName �����, � ������� ���������� ���� �����������
     @param MethodKind ��� ������}
    function ReCreateExceptObject(ExceptObj: Exception; MethodName: string;
      MethodKind: TMethodKind = mkProc): Exception;

    {���������� ������ ������� � ������}
    function GetMatrixSize: Integer; virtual;

  public
    {:����������� �������. ������������ ��� �������� � ������������� �����
     ������ ������� TMatrix. �� ������������ ����������� � ����������� ���
     ������ �������������, ��� ��� � ����������� ������� ����������
     ��������� ����� Init. �� ���������� �������� AOwner, ���� ����� ������
     ��������� � ������, �������� �� ������ ������������� �������, �.�. �������
     ������ � ���� ������ �� �������������.
     @param AOwner �������� ��� ������������ ������� (�������� ���������� ���
       �������� ������� ��� ����� �����������). � �������� ����� ��������� ��
       ������ ������� <b>nil</b>. � ���� ������ �� ������ ������������ ����������
       ������ ������ � ������� ������ FreeMatrix.
     @param AName ��� ������������ �������}
    constructor Create(AOwner: TMatrix = nil; const AName: TMatrixName = ''); virtual;

    {:���������� �������. ������������ ��� ������������ ���� ������, ����������
     �������. �� ������������ ���������� � ����������� ��� ������ �������������,
     ��� ��� � ����������� ������� ���������� ��������� ����� Clear.}
    destructor Destroy; override;

    {:��������� ��������, ������� ���������� ��������� �� ��������� �����������.
     � ������ ������ ��������� ��������� ������������ ������ Self. ��� ����������
     ��� �������������� ������ ����������� ��������������� �������.}
    procedure BeforeDestruction; override;

    {:���������� ����������� �������. ������ ����� �������� �����, ��� � Free
     � ������� TObject, ������ ����� Destroy �� �������� ���� � ���
     ������, ���� ������ ������������� "�����". ���� ������ �������, �� �����
     ������ �� �������. ���� ������ �� �������� ������� �� ������ TMatrix, ��� ������
     ��� ��� ��������� �����, �� ����� ������������� ��������������� ����������}
    procedure FreeMatrix;

    {:�������� � ���������� ����� ����������� ����� Free() ����������� �����������}
    {$IFDEF UseExtendedFree}
    procedure Free;
    {$ENDIF UseExtendedFree}

    {:��������� �������� ������ Self.
     @raises EMatrixBadRef ������ �����, ���� �������}
    procedure CheckRef(const MethodName: string = ''; MethodKind: TMethodKind = mkProc);

    {:������� ����� ������ ���� �� ������, ��� � ������ ������}
    function CreateInstance(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix;

    {:������� ������, ���������� ������� �� ������ ������}
    function CreateReference(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix; virtual;

    {:������� ������, ���������� ������ ������� �������}
    function CreateCopy(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix; virtual;

     {__________________________________________________________________________

                     �������� ������� � ��������� �������

      ����������� ��������� �������� ���������� MatrixCheckRange ��� ����, �����
      ����������, ��������� �� �� ������� ������� �������� �������. ����
      ����������� ������������ �������, �� ����� ������������� ����������.
      __________________________________________________________________________}


    {:������ � �������� ������������� ������� �� ��� ����������� ������}
    property VecElem[const Index: Integer]: Extended read GetVecElem write SetVecElem;

    {:������ � �������� �������������� ������� �� ��� ����������� ������}
    property VecElemI[const Index: Integer]: Integer read GetVecElemI write SetVecElemI;

    {:������ � �������� ������� ������� ����� ����� Int64 �� ��� ����������� ������}
    property VecElemI64[const Index: Integer]: Int64 read GetVecElemI64 write SetVecElemI64;

    {:������ � �������� ������������ ������� �� ��� ����������� ������}
    property VecElemCx[const Index: Integer]: TExtendedComplex read GetVecElemCx write SetVecElemCx;

    {:������ � �������� �������, ��������������� � ��������� ����, �� ��� ����������� ������}
    property VecElemStr[const Index: Integer]: string read GetVecElemStr write SetVecElemStr;

    {:������ � �������� ������� ����� �� ��� ����������� ������}
    property VecCells[const Index: Integer]: TMatrix read GetVecCells write SetVecCells;

    {:������ � �������� ������� �������� �� ��� ����������� ������. ������ �������
     ����������� � ������ TObjectMatrix. �� ������������� ������������ ���������
     ����� � ����������� ����� ��-�� ���������� ����������� ����������������}
    property VecObjects[const Index: Integer]: TObject read GetVecObjects write SetVecObjects;

    {:������ � �������� ����������� ������� �� ��� ����������� ������}
    property VecChar[const Index: Integer]: Char read GetVecChar write SetVecChar;

    {:������ � ������ ������� �������� ������� � ������� Extended. 
      ��������! �� ���������� ���������� � ������ Value, ���� �� ���������� ��
      ������������ � ��������� WITH, ����������� � TMatrix, �.�. ������ ����������
      ����� �������������� ��� �������� (���������� ��� ����, ��������, �� ���������)}
    property Value: Extended read GetValue write SetValue;

    {:������ � ������ ������� �������� ������� � ������� Integer}
    property ValueI: Integer read GetValueI write SetValueI;

    {:������ � ������ ������� �������� ������� � ������� Integer64}
    property ValueI64: Int64 read GetValueI64 write SetValueI64;

    {:������ � ������ ������� �������� ������� � ������� Integer64}
    property ValueCx: TExtendedComplex read GetValueCx write SetValueCx;

    {:������ � ������ ������� �������� ������� � ������� string}
    property ValueStr: string read GetValueStr write SetValueStr;

    {:������ � ������ ������� �������� ������� �����}
    property ValueCells: TMatrix read GetValueCells write SetValueCells;

    {:������ � �������� ������������� ������� �� ������ ������ � �������.
     � ������, ���� ������ - ������, ������� � �������� ������ ������ ��������� 0.
     (�������, ��� �������� �������� � Matrix32 ���������� � ����)
     @param Row ����� ������
     @param Col ����� �������}
    property Elem[const Row, Col: Integer]: Extended read Get_Elem write Set_Elem;

    {:������ � �������� �������������� ������� �� ������ ������ � �������}
    property ElemI[const Row, Col: Integer]: Integer read Get_ElemI write Set_ElemI;

    {:������ � �������� ������� ������� ����� ����� Int64 �� ������ ������ � �������}
    property ElemI64[const Row, Col: Integer]: Int64 read Get_ElemI64 write Set_ElemI64;

    {:������ � �������� ������������ ������� �� ������ ������ � �������}
    property ElemCx[const Row, Col: Integer]: TExtendedComplex read Get_ElemCx write Set_ElemCx;

    {:������ � �������� �������, ��������������� � ��������� ����, �� ������ ������ � �������}
    property ElemStr[const Row, Col: Integer]: string read Get_ElemStr write Set_ElemStr;

    {:������ � �������� ����������� ������� �� ������ ������ � �������}
    property ElemChar[const Row, Col: Integer]: Char read Get_ElemChar write Set_ElemChar;

    {:������ � �������� ������� ����� �� ������ ������ � �������}
    property Cells[const Row, Col: Integer]: TMatrix read Get_Cells write Set_Cells;

    {:������ � �������� ������� �������� �� ������ ������ � �������}
    property Objects[const Row, Col: Integer]: TObject read Get_Objects write Set_Objects;

    {:������ �������� ������������� ������� ���������� �����������.
     ������� �������� �������� � ���� ��������� �������������� �������}
    procedure SetElem(const Indexes: array of Integer; const Value: Extended); virtual;

    {:������ �������� ������������� ������� ���������� �����������.}
    function GetElem(const Indexes: array of Integer): Extended; virtual;

    {:������ �������� �������������� ������� ���������� �����������.}
    procedure SetElemI(const Indexes: array of Integer; const Value: Integer); virtual;

    {:������ �������� �������������� ������� ���������� �����������.}
    function GetElemI(const Indexes: array of Integer): Integer; virtual;

    {:������ �������� ������� ������� ����� ����� Int64 ���������� �����������.}
    procedure SetElemI64(const Indexes: array of Integer; const Value: Int64); virtual;

    {:������ �������� ������� ������� ����� ����� Int64 ���������� �����������.}
    function GetElemI64(const Indexes: array of Integer): Int64; virtual;

    {:������ �������� ������������ ������� ���������� �����������.}
    procedure SetComplex(const Indexes: array of Integer;
      const Value: TExtendedComplex); virtual;

    {:������ �������� ������������ ������� ���������� �����������.}
    function GetComplex(const Indexes: array of Integer): TExtendedComplex; virtual;

    {:������ �������� ������� ���������� ����������� � ��������� ����}
    procedure SetElemStr(const Indexes: array of Integer; const Value: string); virtual;

    {:������ �������� ������� ���������� ����������� � ��������� ����}
    function GetElemStr(const Indexes: array of Integer): string; virtual;

    {:������ �������� ����������� ������� ���������� �����������.}
    procedure SetElemChar(const Indexes: array of Integer; const Value: Char); virtual;

    {:������ �������� ����������� ������� ���������� �����������.}
    function GetElemChar(const Indexes: array of Integer): Char; virtual;

    {:���������� �������� ��������� ������ ����������� ������� � ������� string}
    function GetRowChars(ARow: Integer): string; virtual;

    {:������ ��������� ��������� ������ ����������� ������� � ������� string}
    procedure SetRowChars(ARow: Integer; Text: string); virtual;

    {:������ �������� ������� ���������� ����������� � ���� Variant}
    procedure SetElemVar(const Indexes: array of Integer; const Value: Variant); virtual;

    {:������ �������� ������� ���������� ����������� � ���� Variant}
    function GetElemVar(const Indexes: array of Integer): Variant; virtual;

    {:������ �������� ������� ����� ���������� �����������.}
    procedure SetCell(const Indexes: array of Integer; const Value: TMatrix); virtual;

    {:������ �������� ������� ����� ���������� �����������.}
    function GetCell(const Indexes: array of Integer): TMatrix; virtual;

    {:������ �������� ������� �������� ���������� �����������.}
    procedure SetObject(const Indexes: array of Integer; const Value: TObject); virtual;

    {:������ �������� ������� �������� ���������� �����������.}
    function GetObject(const Indexes: array of Integer): TObject; virtual;

    {:�������� ������� ������� Matrix � ������������ MatrixRow �
     MatrixCol � ������ � ������������ SelfRow, SelfCol}
    procedure AssignElem(const Matrix: TMatrix;
      const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer); virtual;

    {:�������� ������� ������� Matrix � ������������ MatrixIndexes
     � ������ � ������������ SelfIndexes}
    procedure AssignDynElem(const Matrix: TMatrix;
      const SelfIndexes, MatrixIndexes: array of Integer); virtual;

    {:�������� ������� ������� Matrix � �������� MatrixIndex
     � ������ � ���������� ������� SelfIndex}
    procedure AssignVecElem(const Matrix: TMatrix;
      const SelfIndex, MatrixIndex: Integer); virtual;

    {:������������ ������ � ���� ������ �� ����� ����. ���� �������� ��������
     �� ������, � ���� � ������ AName ����� �� �������, �� ������������ ����������}
    property Fields[const AName: TMatrixName]: TMatrix read GetFields write SetFields;
                 
    {:���������� ����� �������� ������� � ���������� ������� Index}
    function VecAddress(Index: Integer): Pointer; virtual;

    {:���������� ����� �������� ������� � ������������ [Row, Col]}
    function ElemAddress(const Row, Col: Integer): Pointer; virtual;

    {:���������� ����� �������� ������� � ������������ Indexes}
    function DynElemAddress(const Indexes: array of Integer): Pointer; virtual;
    {__________________________________________________________________________

                        �������������� ��������
                        _______________________  

     �������������� �������� ����� ���������� �������� ���� TMatrix. ��� ����
     ��������� �� ����. � ������� ��� ����� ��������� ��� �������������� ��������,
     ���������� ������ ������ ���������. ������:

     with Matrix1 do
       CalcFunction(CalcOperation([Matr1, Matr2, Matr3], opSum), fncSin);

     ���������: ��� �������, ������������ � ������� CalcOperation ������ �����
     ���������� �������, ��� �������� ����� ���� �� ������ ��������.
     (��. ����������� � ��������� �������� ���������� ExtendedCalcOperation)

     __________________________________________________________________________}

    {:���������� �������� ������� ��� ������� ��������}
    function CalcFunction(const Matrix: TMatrix;
      AFunc: TFloatFunction): TMatrix; overload;

    {:���������� �������� ������� ��� ������������� ��������}
    function CalcFunction(const Matrix: TMatrix;
      AFunc: TIntFunction): TMatrix; overload;

    {:���������� �������� ������� ��� �������� ������� ����� ����� Int64}
    function CalcFunction(const Matrix: TMatrix;
      AFunc: TInt64Function): TMatrix; overload;

    {:���������� �������� ������� ��� ����������� ��������}
    function CalcFunction(const Matrix: TMatrix;
      AFunc: TComplexFunction): TMatrix; overload;

    {:���������� �������� �������� ��� ������� �������� �� ������ Matrices}
    function CalcOperation(const Matrices: array of TMatrix;
      AFunc: TFloatOperation): TMatrix; overload;

    {:���������� �������� �������� ��� ������������� �������� �� ������ Matrices}
    function CalcOperation(const Matrices: array of TMatrix;
      AFunc: TIntOperation): TMatrix; overload;

    {:���������� �������� �������� ��� �������� ������� ����� ����� �� ������ Matrices}
    function CalcOperation(const Matrices: array of TMatrix;
      AFunc: TInt64Operation): TMatrix; overload;

    {:���������� �������� �������� ��� ����������� �������� �� ������ Matrices}
    function CalcOperation(const Matrices: array of TMatrix;
      AFunc: TComplexOperation): TMatrix; overload;

    {:���������� �������� �������� � �������������� �������� ��������, ��������
     � ������ �����}
    function ValueOperation(const Matrix: TMatrix; Value: Extended;
      AFunc: TFloatOperation): TMatrix; overload;

    {:���������� �������� �������� � �������������� �������� ��������, ��������
     � ����� �����}
    function ValueOperation(Value: Extended; const Matrix: TMatrix;
      AFunc: TFloatOperation): TMatrix; overload;

    {:���������� �������� �������� � �������������� �������������� ��������,
     �������� � ������ �����}
    function ValueOperation(const Matrix: TMatrix; Value: Integer;
      AFunc: TIntOperation): TMatrix; overload;

    {:���������� �������� �������� � �������������� �������������� ��������,
     �������� � ����� �����}
    function ValueOperation(Value: Integer; const Matrix: TMatrix;
      AFunc: TIntOperation): TMatrix; overload;

    {:���������� �������� �������� � �������������� �������� ������ �������� Int64,
     �������� � ������ �����}
    function ValueOperation(const Matrix: TMatrix; Value: Int64;
      AFunc: TInt64Operation): TMatrix; overload;

    {:���������� �������� �������� � �������������� �������� ������ �������� Int64,
     �������� � ����� �����}
    function ValueOperation(Value: Int64; const Matrix: TMatrix;
      AFunc: TInt64Operation): TMatrix; overload;

    {:���������� �������� �������� � �������������� ������������ ��������,
     �������� � ������ �����}
    function ValueOperation(const Matrix: TMatrix; Value: TExtendedComplex;
      AFunc: TComplexOperation): TMatrix; overload;

    {:���������� �������� �������� � �������������� ������������ ��������,
     �������� � ����� �����}
    function ValueOperation(Value: TExtendedComplex; const Matrix: TMatrix;
      AFunc: TComplexOperation): TMatrix; overload;

    {:��������� �������� �������� ��� ��������� ���������� �������. ������
     �������� ����� ��������� ����� �������:
     @example
     <code>
       A.AsString := '1, 2, 3, 4, 5; 6, 7, 8, 9, 10';
       B.DimOperation(A, A.DimCols, opSumI);
       // � ���������� ����� ����������� ����� ������: [15; 40]
     </code> }
    function DimOperation(const Matrix: TMatrix; DIM: Integer;
      AFunc: TIntOperation): TMatrix; overload;

    {:��������� �������� �������� ��� ��������� ���������� �������. ������
     ������������ ��������� � �������� �������:
     @example
     <code>
       A.AsString := '1, 2, 3, 4, 5; 6, 7, 8, 9, 10';
       B.DimOperation(A, A.DimRows, opSumI);
       // � ���������� ����� ����������� ����� ������: [6, 14, 24, 36, 50]
     </code>
    }
    function DimOperation(const Matrix: TMatrix; DIM: Integer;
      AFunc: TInt64Operation): TMatrix; overload;

    {:��������� �������� �������� ��� ��������� ���������� �������.}
    function DimOperation(const Matrix: TMatrix; DIM: Integer;
      AFunc: TFloatOperation): TMatrix; overload;

    {:��������� �������� �������� ��� ��������� ���������� �������.}
    function DimOperation(const Matrix: TMatrix; DIM: Integer;
      AFunc: TComplexOperation): TMatrix; overload;

    {:����������� ������� �� ������ Matrices � ������� ���������� ���������}
    function MulMatrices(Matrices: array of TMatrix): TMatrix; 

    {:���������� ����� ����� �������� ��������, ������������� � Matrices}
    function DoAdd(Matrices: array of TMatrix): TMatrix;

    {:�������� ���� �� ����� �������� ��������, ������������� � Matrices}
    function DoSub(Matrices: array of TMatrix): TMatrix;

    {:����������� ����� ����� �������� ��������, ������������� � Matrices}
    function DoMul(Matrices: array of TMatrix): TMatrix;

    {:��������� ���������������� ������� ��������� ��������, ��������� � Matrices}
    function DoDiv(Matrices: array of TMatrix): TMatrix;

    {:��������� ���������������� ������� ������ ��������� ��������, ��������� � Matrices}
    function DoIntDiv(Matrices: array of TMatrix): TMatrix;

    {__________________________________________________________________________

                    �������, �������������� ��������� �������
     __________________________________________________________________________}

    {:�������� ������� �������. �������������� �������� ��
     �������������� ��������� � �� ��������� �� ���������. ��� ���������
     ��������� ����������� ����� Zeros}
    procedure Resize(const DimValues: array of Integer); virtual;

    {:�������� ������� ������� ����� �������� ��������� �������� ���������
     ������� FDimensions. ����� �������� ������ � ������, ���� � ����������
     ������� ����� ��������� ����� ��, ��� � � ������.
     @raises EMatrixDimensionsError � ��������� �������� ���������� ���������
       �� ��, ��� ������� � ������� �� ������ ������}
    procedure Reshape(const DimValues: array of Integer); virtual;

    {:�������� ������� �������. ��������� ������������ �������� �� ����� ������
     ������, ���, ����� �������� � ����� ������� ���������� �� ������ �������
     ������������. ���� ����������� �������������, �� ������� �������
     ������ ������������ - ������� (� ������� �������� - ������� ������� � ������
     ������ ������������). ������ ������������ ��� ������� �������� ������������
     �� �������������, ��� ��� ����� ���� �������� ��������� ��������.
     ������������� ������������� ������ ������� ������� ����� ���� ��� ��� ��������.
     � ������, ���� ����� � ������� �� ���� �� ������ ��������, ������ �������
     ��������������� ������� ����� Resize(), � ����� � ����� Zeros()}
    procedure PreservResize(const DimValues: array of Integer); virtual;
                                        
    {:��������� ���������������� ������� (������ ����� ���������).
     �������� ��������� ��������:
     <ul>
       <li> ���� ������ ����������, �� ������� ����������� �� � 2-������ ������
         � ����� ��������
       <li> ���� ������ 2-������, �� ��������� ������� ����������������
       <li> ���� ������ 3-������, �� ������������� �� ����������� ������ ��� ����
       <li> � ��������� ������ ������������ ����������
     </ul>}
    function Transpose(const Matrix: TMatrix): TMatrix; virtual;

    {:������� ������ � ����������, ������������� ���� �� ����� �� ��������
     StepValue. ������ ������� ������� ����� StartValue. FinishValue - ������������,
     ������ �������� �������� ��������� �� �������������}
    function Colon(const StartValue, StepValue, FinishValue: Extended): TMatrix; 

    {__________________________________________________________________________

                      ������� ��� ������ � ������� / ��������
     __________________________________________________________________________}

    {:���������� �������� ������� � �����, ������� � ������� �������. ������ � �����
     ����������� ���������� ������ SaverClass. ���� SaverClass = nil, �� ������
     ��������� ������������ ������. ����� ������������ ��� ������ � ��������, �
     ������� �� �������� �����-���� ���������� � ��������������� �������}
    procedure SaveToStream(AStream: TStream; SaverClass: TMatrixClass = nil); virtual;

    {:��������� �������� ������� �� ������ � ������� �������. ������ �� ������
     ����������� ���������� ������ LoaderClass. � ���������� ����� �����������
     ������ � ��������� DimValues. ���� LoaderClass = nil, �� ������ ���������
     ������������ ������. ����� ������������ ��� ������ � ��������, �
     ������� �� �������� �����-���� ���������� � ��������������� �������}
    procedure LoadFromStream(AStream: TStream; const DimValues: array of Integer;
      LoaderClass: TMatrixClass = nil); virtual;

    {:���������� ������ � ����� � ������� �������. ����� � ����� �� ������ ��������,
     �� � ����������� ��������� ����������, ��������� ������� ����� ����� �
     ���������� ��������� ������ ������� �� ������.
     <ul>
       <li> ���� ����������� ������� �������, �� ����������� ����� ��� �� ��������
         �������, ����� �������� ������� ��������
       <li> ���� ����������� ��������� TRecordMatrix, �� ����� ��������� ��� �� ����
       <li> ���� ����������� ������ �����, �� ����� ��������� ��� ������
     </ul>

     �������� SaverClass ������������ ��� ���������� ������������ ��������. ���
     ���������� ������� �������, ������ ��� ������� ����� �� ������������.

     ���� ������� AName, �� ������ ����� �������� ��� ���� ������. ���� ����
     �������� �� ���������, �� ����� ������������ ����������� ��� �������}  
    procedure SaveToStreamEx(AStream: TStream; AName: TMatrixName = '';
      SaverClass: TMatrixClass = nil); virtual;

    {:��������� ������ �� ������ � ������� �������. ��� �������� ������ �������,
     ����� ������� �������, ���������� ����� ������� ����� �������������� �������.

     ��� �������� ������� ������� �������� ����� ����������� �� ����������,
     ������ �������� ����� �������. ������ ����������� ������� ����� ����������.
     ����� �������� ������� ������� ���������� �������� ���������
     ������ �� ������� ������� �������.}
    procedure LoadFromStreamEx(AStream: TStream); virtual;

    {:���������� ������ � �������� ���� AFileName. ��� ����������
     �������� �������� ������������ �������� SaverClass. ��� ������������� ���������
     DoRewrite ��������� ���������� �����. ���� ����� �������� AName, �� �
     �������� ����� ������� ������������ ��, ����� ������������ ����������� ���
     �������. ����������� ������� �� ���������, ��� ��� ����� ������ ����.}
    procedure SaveToBinaryFile(const AFileName: string; AName: TMatrixName = '';
      SaverClass: TMatrixClass = nil; DoRewrite: Boolean = False); virtual;

    {:��������� ������ � ������ AName �� ��������� ����� AFileName. ���� AName
     �� �����, �� ������� ���� ������ � ����������� ������ MatrixName}
    procedure LoadFromBinaryFile(const AFileName: string; AName: TMatrixName = ''); virtual;

    {__________________________________________________________________________

                     ������� ������������ � ������ � ������� �������
     __________________________________________________________________________}


    {:��������� ������������ (�����������) �������� �� �������� �����������.
     ��� 3-D ������� (��� ������):<br>
     ��� DIM = 0 ����������� ����������� � ������� ���������� ����� �����.<br>
     ��� DIM = 1 ����������� ����������� � ������� ���������� ����� �����.<br>
     ��� DIM = 2 ����������� ����������� � ������� ���������� ����� ��������.<br>

     � �������� ����������� ��������� ������ �������, ��������� � ������ Matrices.
     ���� �� ������, ����� � ����������� ���������� ������ Self, �� ������� ���
     � ��� �� ������}
    function Concat(DIM: Integer; const Matrices: array of TMatrix): TMatrix; virtual;

    {:�������� � Self ����� ��������� �������. ��� ����� �� ��������� ��������
     ������� ��������� ���������� LoIntervals � ��  ������� IntervalsLen.
     ������ ���� ���������� UseLenAsHigh � True, �� �������� IntervalsLen
     ����� ������������ ��� ������� ������� ����������. �� ��������� ����������
     ��������, ����������� ������ ��������� ����������. ���� �������� ����
     CopyDataInIntervals, �� ����� ������������ ������ ������� ��������.
     ���� � �������� ������� ������� ��������� ��������� -1, �� ������� �������
     ����� ����������� ������������� ���, ����� ����� ��� ��������, ������� �
     LoIntervals. ������ ������� ����� ����� ������������ ��� ������� ���������
     ����� �� �������, � ��� ����� ��� �������� ����� ��� �������� �������.
     �������:
     <code>
      Matrix.CopyArrayPart(Matrix, [2, 3], [2, -1]); - �������� 2 ������, ������� ��
        ������ � ������� 2 �� ������������� ������� Matrix. ���������� �����
        ��� �������, ������� � ������� 3.

      Matrix.CopyArrayPart(Matrix, [2, 3], [2, -1], False, False) - �������� ��
        ������� Matrix �� �����, ������� ���� ����������� � ���������� �������

      Matrix.CopyArrayPart(Matrix, [2, 1], [2, 0], True, False) - ������� ��
        ������� Matrix ������ ������. ��� ���� ������� 1 � 0 ��������, ��� ����������
        ��� ������ �������. � ������ ������ CopyDataInIntervals=False, UseLenAsHigh=True.

      Matrix.CopyArrayPart(Matrix, [2, 1], [1, 0], False, False) - ����� �����
        ������� �� ������� Matrix ������ ������. � ������ ������
        CopyDataInIntervals=False, UseLenAsHigh=False

      Vec.CopyArrayPart(Vec, [2], [1], False, False) - ������� �� �������
        Vec ���� ������� � �������� 2

      Matrix.CopyArrayPart(Matrix, [1, 2], [0, 1], False, False) - ������� ��
        ������� Matrix ���� ������� � �������� 2
     </code>
     }
    function CopyArrayPart(AMatrix: TMatrix; const LoIntervals,
      IntervalsLen: array of Integer; UseLenAsHigh: Boolean = False;
      CopyDataInIntervals: Boolean = True): TMatrix; virtual;

    {__________________________________________________________________________

                     ������� ����������� ���������� �������
     __________________________________________________________________________}

    {:���������� ����� ����� �������}
    property Rows: Integer read FRows write SetRows;

    {:���������� ����� �������� �������}
    property Cols: Integer read FCols write SetCols;

    {:����� �����������, ������������ ������ �������}
    function DimRows: Integer;

    {:����� �����������, ������������ ������� �������}
    function DimCols: Integer;

    {:���������� ���������� ��������� �������}
    property DimensionCount: Integer read GetDimensionCount;

    {:���������� ���������� ��������� �������}
    property ElemCount: Int64 read FElemCount;

    {:���������� ������ �������� ������� � ������}
    property ElemSize: Integer read FElemSize;

    {:���������� ������ ������, ���������� �������� (� ������). ���� ����������
      ��� ��������-�����������, �� ���������� ������, ���������� ����� ���������
      ���������}
    property MatrixSize: Integer read GetMatrixSize;

    {:������ � �������� �������. ����� �������� �������� ����� �����������.
     ��� ���� ������������ �������� ������� ����� ���������}
    property Dimension[Index: Integer]: Integer read GetDimension write SetDimension;

    {:���������� ����� ������� ������������ FDimensions}
    function GetDimensions: TDynIntArray;

    {���������� �������, ����������� ��� ��������������� ������� � �������.
     ���� ������ ������ ������� � ���, ��� ����� �� ����������� �� ��� ������,
     ��� ��� ����� ����� ����������� � ���� ����� ������� ������������� �����.
     ������� ���������� ������ �� 2-� ���������, ������ �� ������� - �����������
     ����� �����, � ������ - ����� ��������. �������� ������ �������, �� �������
     �������� � �������� ����� �������� ��� � 2-������ ��������.
     @example
     <code>
       // ���������� ������� ������� AMatrix
       OldDimValues := AMatrix.GetDimensions;
       // ������ �� ������������ ������� AMatrix 2-������ �������
       AMatrix.Reshape(AMatrix.CalcMatrixDimensions);
       try
         // ����� ����� ��������� ��������� ����� �������
       finally
         // ��������������� ������� ������� AMatrix
         AMatrix.Reshape(OldDimValues);
       end;
     </code>}
    function CalcMatrixDimensions: TDynIntArray;

    {� ������� ��������� ������� ����� ��������� ��� �������. ��� �������
     ������������� ��������� ������������ ������ Self}

    {:���������, �������� �� ������ �������� ��������}
    function IsNumeric: Boolean;
    {:���������, �������� �� ������ �������� ��������.
     ���� ���, �� ���������� ����������}
    procedure CheckForNumeric;
    {:���������, �������� �� ������ �������� ����� �����}
    function IsInteger: Boolean;
    {:���������, �������� �� ������ �������� ������� ����� ����� Int64}
    function IsInt64: Boolean;
    {:���������, �������� �� ������ �������� ������������ �����}
    function IsFloat: Boolean;
    {:���������, �������� �� ������ �������� ����������� �����}
    function IsComplex: Boolean;
    {:���������, �������� �� ������ �������� �����}
    function IsCell: Boolean;
    {:���������, �������� �� ������ �������� ��������}
    function IsObject: Boolean;
    {:���������, �������� �� ������ �������}
    function IsRecord: Boolean;
    {:���������, �������� �� ������ ������������ �������� Matrix32}
    function IsDynamic: Boolean;
    {:���������, �������� �� ������ ������� ��������}
    function IsWorkspace: Boolean;
    {:���������, �������� �� ������ �������� ��������}
    function IsChar: Boolean;
    {:���������, �������� �� ������ ��������� �����}
    function IsNetwork: Boolean;

    {:����������, ���������� �� ������ ������. ���� ����� ����� �������
     � ����� �����: �� �������� �������, ����� ��������, ����� ��������}
    function IsLiving: Boolean; 

    {__________________________________________________________________________

                     ������� ������������� ��������� �������
     __________________________________________________________________________}

    {:��������� �������� ������ ���������� ������� �� 0 �� MaxValue}
    function Rand(const MaxValue: Cardinal): TMatrix; virtual;

    {:�������� �������� �������}
    function Zeros: TMatrix; virtual;

    {:������������� ��� �������� ������� ������� �������}
    function Ones: TMatrix; virtual;

    {:����������� ���� ��������� ������� �������� Value}
    function FillByValue(Value: Extended): TMatrix; virtual;

    {:��������� ������ ������������������� �����, ������� � FirstValue}
    procedure FillByOrder(FirstValue: Integer = 0); virtual;

    {:��������� �������� ������� ������������������� �����, ������� �
     StartValue, � ��������� ������ ��� �������� StepValue}
    procedure FillByStep(const StartValue, StepValue: Extended); virtual;

    {:��������� �������� ������� ������������������� �����.
     ������������������ ���������� �� StartValue � ������������� FinishValue.
     ��� ������������� �������������}
    procedure FillByStep2(const StartValue, FinishValue: Extended); virtual;
    {__________________________________________________________________________

                     ������� ����������� ��������
     __________________________________________________________________________}

    {:���������� ������ �� ������� Matrix � Self, ����� ���� ������ Matrix
     �������� ������}
    procedure MoveFrom(Matrix: TMatrix); virtual;

    {:�������� ������ �� ������� Matrix}
    procedure CopyFrom(Matrix: TMatrix); overload; virtual;

    {:��������� ����������� �������� ������� Delphi, �������������� � ������
     �� ������ Buffer, �������� ������� DimValues, ���������� �������
     ������ LoaderClass. ���� LoaderClass = nil, �� ������ ��������� ������������ ������}
    procedure CopyFrom(const Buffer: Pointer; const DimValues: array of Integer;
      LoaderClass: TMatrixClass = nil); overload; virtual;

    {:�������� ������ �� ������� Matrix � Self �� ������}
    procedure CopyByRef(Matrix: TMatrix); overload; virtual;

    {:������������� ������ �� ����������� ������ Delphi, ����������� �� ������
     Buffer, � ������� ������� DimValues}
    procedure CopyByRef(const Buffer: Pointer;
      const DimValues: array of Integer); overload; virtual;

    {__________________________________________________________________________}


    {:������� ���������� �������. ��� �������� � ����� ������� ��� ���������
     �������. ��� ������� �������� ������� ��� �������� �������, �� �����������
     �������� ������� ��������}
    procedure Clear; virtual;

    {:������� ��� ������������� ������ ����������� with..do}
    function ThisMatrix: TMatrix;

    {:������ � ������ ������� � ��������� �������, ������� ��� ������.
     � �������� ����������� ����� ������������ ������ MatrixNumberDelimiter.
     � �������� ����������� ����� ������������ ������ MatrixRowsDelimiter.
     �������������� ��� ������������, ��� � ����������� �����}
    property AsString: string read GetAsString write SetAsString;

    {������ � ������ ������� � ��������� �������. �������������� ������
     � ������������ ���������, ������ ������� ������������� ��� ���� �� �����}
    // TODO : �� ����������� (AsStringEx)!
    property AsStringEx: string read GetAsStringEx write SetAsStringEx;

    {:���������� ������ � ���� ����������� �������. ��������� ��� �������� ��������
     ����� �����������. �������� ������� �� ������ ��������� MaxDouble.
     � ����������� �������� ������ ������������ ������������.}
    function AsVariantArray(AVarType: TVarType): Variant;

    {:��������� ������ �� ���������� ����������� �������}
    procedure LoadFromVariantArray(const AVariant: Variant);

    {:���������� ��� �������}
    property MatrixName: TMatrixName read FName write SetMatrixName;

    {:��������� ������ � �������� ����� �������. ������� �� ������� �����
     �������� ������� � ������� ������� ������ ��� �������-��������}
    property ArrayAddress: Pointer read GetArrayAddress write SetArrayAddress;

    {:����������, �������� �� ������ ������, ���������� �� ������.
     ���� ��� ���, ��� ���������� �� ����� ������� ���������� �������.
     ���� ������ - ����������� ������, �� ������, ������� ������� �����������
     �� �����. ���� ������ - ������ TRecordMatrix, �� �������-������ �������
     �� �����.}
    property IsCopyByRef: Boolean read FIsCopyByRef write FIsCopyByRef;

    {:���������� True, ���� ������ ����}
    function IsEmpty: Boolean; virtual;

    {:���������� ��������� ������ ������� (�� ��������� MaxSignatureLength
     ��������� � ����� ��������������, ��������, ��� ������ � ��������� �������)}
    class function GetAlias: TSignature; virtual;

    {:��� ������� �������� (� ��������� ��� ������� �����) ������� ��� �������.
     �������� ������ �������}
    procedure DeleteObjects; virtual;

    {:���������� ������ �������� ��������. � ������ �������� ����� ��������
     � ������ �� ��� � ���� TObject.
     @param UseTypes ��������� ����� ��������, ������� ������ �������� � ������.
       ���� ��������� ������, �� �� ��������� � ������ ������� ��� �������
     @param IgnoreTypes ��������� ����� ��������, ������� �� ������ ������� � ������}
    procedure GetMatrixList(AList: TStrings;
      const UseTypes: TMatrixTypes = [];
      const IgnoreTypes: TMatrixTypes = [mtWorkspace]);

    {:���������� ������ ����� ������}
    procedure GetFieldList(AList: TStrings); virtual;

    {:���������� ���������� ����� ������}
    function FieldCount: Integer; virtual;

    {:���������� ������ �� ���� ������ �� ��� �������}
    function FieldByIndex(Index: Integer): TMatrix; virtual;

    {:���������� ��� ���� ������ �� ��� �������}
    function FieldName(Index: Integer): TMatrixName; virtual;

    {:���������� ������-���� ������ � ���������� ��� ������.
     ���� ������ �� ������, �� ���������� NIL}
    function FindField(AName: TMatrixName): TMatrix; virtual;

    {:���������� �������� ������ �� ��������� ����� � ���������� ��� ������}
    function FindMatrix(AName: TMatrixName): TMatrix;

    {:����������, ���������� �� �������� ������ � �������� ������}
    function MatrixExists(AName: TMatrixName): Boolean;

    {:���������� ������ �� �������� ������ TMatrix �� ��� �����. � ������,
     ���� ������ � ����� ������ �� ������, ������������ ����������}
    property MatrixByName[const AName: TMatrixName]: TMatrix read GetMatrixByName;

    {:���������� ���������� �������� ��������}
    function MatrixCount: Integer;

    {:���������� �������� ������ �� ��������� �������.
     @raises EMatrixBadRef ������ ������������ ������}
    property Matrices[Index: Integer]: TMatrix read GetMatrices;

    {:������ � ������� - ���������. ��� ������� � ������� ������� ��������
     ����� ������� ���������}
    property OwnerMatrix: TMatrix read FOwnerMatrix write SetOwnerMatrix;

    {:��������� � ������ �������� ������ ���������� �� ����������. ��� ����
     ��� ����������� ������� ��� ��������� ���������� ������� �������� NIL.
     ��� CanModify=True ���� ���������� ����� ��������� �������� Self
     @example
     <code>
       TMyClass = class(TObject)
       private
         FMyVar: TMatrix;         
       public
         property MyVar: TMatrix read FMyVar;
         constructor Create;
         destructor Destroy; override;
       end;

       .................................

       constructor TMyClass.Create;
       begin
         with TByteMatrix.Create do
           AssignPointers([@FMyVar]);
       end;

       destructor TMyClass.Destroy;
       begin
         FMyVar.FreeMatrix;
         inherited;
       end;

       var
         MyClass: TMyClass;
       // ������ ����� �������� ������� MyClass ���� ��� ���� �� ������ �����������
       // ���������� �������� ������� MyVar (MyClass.MyVar.FreeMatrix), �� ���
       // ������ ����������� ������� ������ �� ����������, ��� ��� FMyVar=nil
     </code>}     
    procedure AssignPointers(const Pointers: array of PMatrixObject; CanModify: Boolean = True);

    {__________________________________________________________________________

                          �������������� �������
     __________________________________________________________________________}

    {:���������� �������� � ������� ����������� � ����������� ��������� �������}
    procedure GetMinMaxValues(AMinValue, AMaxValue: PExtended;
      AMinIndex: PInteger = nil; AMaxIndex: PInteger = nil);

    {:���������� ��������� �������������� ���������� � �������. 
     ����� �� �������� ����� ������ ������� (nil). �������
     ������ ������ �� ��������, ��� ������� ������ ��������������� �������.

     @param AMin ���������� �������� �� ��������� �����������
     @param AMax ���������� �������� �� ��������� �����������
     @param AMinMax ����� � ���������� � ���������� ��������
     @param AMean ������� �������������� ��������. �������� �����
       ������� ������ ����� ����� ���, ������� ��������� ��������������
       ��� �������� ��������� ����������� ������� �������. �������������
       ������ AMean ��������� � ������� ������ TExtendedMatrix
     @param AMinIndexes ������� ���������� ��������
     @param AMaxIndexes ������� ���������� ��������

     @param DIM ����� �����������, �� ������� ����������� �����. �������� � ���
       ������� �������. DIM = DimRows (0, ������). � ���� ������ ������������
       ����� ����� ��������������� �������� ������� �������. �.�. �������
       �������������� �������� ������� ������� (������������ ����������, ����������
       ��������. ����� �������������� �������� ������� �������, � �.�. }
    procedure GetMinMaxMean(DIM: Integer; AMin: TMatrix; AMax: TMatrix = nil;
      AMinMax: TMatrix = nil; AMean: TMatrix = nil;
      AMinIndexes: TMatrix = nil; AMaxIndexes: TMatrix = nil);
  end; // TMatrix

    {__________________________________________________________________________

                          ����� TMatrix ��������!!!
     __________________________________________________________________________}      

  {:������ (������, ���������� ������ ������� ������������ �����, ������ �� �������
   �������� � ������). �������� ��������� ������� �������� �������,
   ������� ���������� Structure Array}
  TRecordMatrix = class(TMatrix)
  private
  protected
    FFieldList: TStringList;

    procedure Init; override;

    function GetFields(const AName: TMatrixName): TMatrix; override;
    procedure SetFields(const AName: TMatrixName; const Value: TMatrix); override;

    {������� ������ AMatrix �� ������ FFieldList, ��� ������ AMatrix ������
     ���� ����� �� ����� ������.}
    procedure DeletionNotify(AMatrix: TMatrix); override;

    function GetMatrixSize: Integer; override;
  public
    constructor Create(AOwner: TMatrix = nil; const AName: TMatrixName = ''); override;
    destructor Destroy; override;
    function CreateCopy(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix; override;
    procedure CopyFrom(Matrix: TMatrix); override;
    procedure MoveFrom(Matrix: TMatrix); override;
    procedure CopyByRef(Matrix: TMatrix); override;
    procedure Clear; override;
    class function GetAlias: TSignature; override;
    function IsEmpty: Boolean; override;

    procedure SaveToStreamEx(AStream: TStream; AName: TMatrixName = '';
      SaverClass: TMatrixClass = nil); override;

    procedure LoadFromStreamEx(AStream: TStream); override;

    function FindField(AName: TMatrixName): TMatrix; override;

    procedure GetFieldList(AList: TStrings); override;

    function FieldCount: Integer; override;

    function FieldName(Index: Integer): TMatrixName; override;

    function FieldByIndex(Index: Integer): TMatrix; override;

    property Fields; default;

    {:���������� ������ �� ������ ������-������}
    function ThisRecord: TMatrix;
  end;

  {:�����, �� �������� ����������� ��� ������������ �������. �� ��������,
   ������ ����� ������ ������������� ��� ���� � ���������� ���� �������,
   ������� ��������� � ������ ����������� ��������}
  TDynamicArrayMatrixClass = class(TMatrix)
  private

  protected
    procedure Init; override;
  public

  end;

  {:����� �����, ��������� ��������� ������������� ��������, �� ����������� ���
   ������, ������������ � �������}
  TCommonMatrixClass = class(TDynamicArrayMatrixClass)
  private
    procedure DoConcat(Dim: Integer; Matrix: TMatrix);
  protected
    {��������� �� ������}
    FArray: Pointer;

    function GetArrayAddress: Pointer; override;
    procedure SetArrayAddress(const Value: Pointer); override;
    procedure SetDimValues(const DimValues: array of Integer); override;
  public
    function Zeros: TMatrix; override;
    procedure CopyByRef(Matrix: TMatrix); override;
    procedure CopyByRef(const Buffer: Pointer;
      const DimValues: array of Integer); override;
    procedure CopyFrom(Matrix: TMatrix); override;
    procedure CopyFrom(const Buffer: Pointer; const DimValues: array of Integer;
      LoaderClass: TMatrixClass = nil); override;
    procedure MoveFrom(Matrix: TMatrix); override;
    procedure Resize(const DimValues: array of Integer); override;

    {������ ���������� ������� Transpose - �� ����� �������. ���������������
     ������ �������, 2D � 3D - �������. ��� �������� ���������� ���������
     ������� ���������� ����������}
    function Transpose(const Matrix: TMatrix): TMatrix; override;

    procedure PreservResize(const DimValues: array of Integer); override;
    procedure Clear; override;

    function VecAddress(Index: Integer): Pointer; override;
    function ElemAddress(const Row, Col: Integer): Pointer; override;
    function DynElemAddress(const Indexes: array of Integer): Pointer; override;

    {������ ���������� ������� Concat - �� ����� �������. ��� ��������� ���������
     ���� � ������ ����� ��������� ��������, ������ �������� ���������� �����������
     �� ����� ����������� �������, �.�. ��� ������ ��������� ���������� ����������
     ������ ����������������� ������ ��� �������������� ������}
    function Concat(DIM: Integer; const Matrices: array of TMatrix): TMatrix; override;
    
    function CopyArrayPart(AMatrix: TMatrix; const LoIntervals,
      IntervalsLen: array of Integer; UseLenAsHigh: Boolean = False;
      CopyDataInIntervals: Boolean = True): TMatrix; override;
      
    function IsEmpty: Boolean; override;

    procedure SaveToStream(AStream: TStream; SaverClass: TMatrixClass = nil); override;
    procedure LoadFromStream(AStream: TStream; const DimValues: array of Integer;
      LoaderClass: TMatrixClass = nil); override;

    procedure SaveToStreamEx(AStream: TStream; AName: TMatrixName = '';
      SaverClass: TMatrixClass = nil); override;

    procedure LoadFromStreamEx(AStream: TStream); override;
  end;

  {:����� �������� ���������� ������� �������� ������ �� ������� (������ ����)}
  TObjectMatrixClass = class(TCommonMatrixClass)
  protected
    procedure Init; override;

    function GetVecObjects(const Index: Integer): TObject; override;
    procedure SetVecObjects(const Index: Integer; const Value: TObject); override;

    function Get_Objects(const Row, Col: Integer): TObject; override;
    procedure Set_Objects(const Row, Col: Integer; const Value: TObject); override;
  public
    procedure CopyByRef(Matrix: TMatrix); override;
    procedure CopyFrom(Matrix: TMatrix); override;
    procedure MoveFrom(Matrix: TMatrix); override;
    function Transpose(const Matrix: TMatrix): TMatrix; override;
    procedure DeleteObjects; override;

    class function GetAlias: TSignature; override;

    procedure CopyFrom(const Buffer: Pointer; const DimValues: array of Integer;
      LoaderClass: TMatrixClass = nil); override;

    procedure SetObject(const Indexes: array of Integer; const Value: TObject); override;
    function GetObject(const Indexes: array of Integer): TObject; override;

    procedure AssignElem(const Matrix: TMatrix;
      const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer); override;

    procedure AssignDynElem(const Matrix: TMatrix;
      const SelfIndexes, MatrixIndexes: array of Integer); override;

    procedure AssignVecElem(const Matrix: TMatrix;
      const SelfIndex, MatrixIndex: Integer); override;
  end;

  {:������ ����� - ������ ������ �� ������ ������� TMatrix}
  TCellMatrix = class(TObjectMatrixClass)
  private
    {���������� ���������� �����, ������� ������ AMatrix}
    function GetCellsCount(AMatrix: TMatrix): Integer;
  protected
    procedure Init; override;

    function GetVecCells(const Index: Integer): TMatrix; override;
    procedure SetVecCells(const Index: Integer; const Value: TMatrix); override;

    function Get_Cells(const Row, Col: Integer): TMatrix; override;
    procedure Set_Cells(const Row, Col: Integer; const Value: TMatrix); override;

    procedure DeletionNotify(AMatrix: TMatrix); override;

    function GetMatrixSize: Integer; override;
  public
    procedure SetCell(const Indexes: array of Integer; const Value: TMatrix); override;
    function GetCell(const Indexes: array of Integer): TMatrix; override;

    function CreateCopy(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix; override;

    procedure DeleteObjects; override;

    {�������� ������� ������� �����. ��� ���� ������� ������������ �������.
     �������� �������� �������}
    procedure Resize(const DimValues: array of Integer); override;

    {�������� ������ �����}
    procedure CopyFrom(Matrix: TMatrix); override;

    procedure MoveFrom(Matrix: TMatrix); override;
     
    class function GetAlias: TSignature; override;

    procedure AssignElem(const Matrix: TMatrix;
      const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer); override;

    procedure AssignDynElem(const Matrix: TMatrix;
      const SelfIndexes, MatrixIndexes: array of Integer); override;

    procedure AssignVecElem(const Matrix: TMatrix;
      const SelfIndex, MatrixIndex: Integer); override;

    procedure SaveToStreamEx(AStream: TStream; AName: TMatrixName = '';
      SaverClass: TMatrixClass = nil); override;

    procedure LoadFromStreamEx(AStream: TStream); override;

    procedure Clear; override;

    property Cells; default;

    {:���������� ������ �� ������ ������ �����}
    function ThisCell: TMatrix;
  end;

  {:����� ����� ��� ���� �������� ��������.
   ��������� ��������� �������������� ��������. ��� �������,
   ��� ���������� ������� ��������� �������������� ��������,
   ������� ����������� �� ������� ������}
  TNumericMatrixClass = class(TCommonMatrixClass)
  protected
    function GetAsString: string; override;
    procedure SetAsString(const Value: string); override;
    procedure Init; override;
  public

    function Ones: TMatrix; override;
    
    function FillByValue(Value: Extended): TMatrix; override;

    function Rand(const MaxValue: Cardinal): TMatrix; override;

    procedure FillByOrder(FirstValue: Integer = 0); override;

    procedure FillByStep(const StartValue, StepValue: Extended); override;

    procedure FillByStep2(const StartValue, FinishValue: Extended); override;

    {__________________________________________________________________________

                        ������� ������� � �������� �������
     __________________________________________________________________________}

  protected
    function Get_Elem(const Row, Col: Integer): Extended; override;
    procedure Set_Elem(const Row, Col: Integer; const Value: Extended); override;

    function Get_ElemI(const Row, Col: Integer): Integer; override;
    procedure Set_ElemI(const Row, Col, Value: Integer); override;

    function Get_ElemI64(const Row, Col: Integer): Int64; override;
    procedure Set_ElemI64(const Row, Col: Integer; const Value: Int64); override;

    function Get_ElemCx(const Row, Col: Integer): TExtendedComplex; override;
    procedure Set_ElemCx(const Row, Col: Integer;
      const Value: TExtendedComplex); override;

    function Get_ElemStr(const Row, Col: Integer): string; override;
    procedure Set_ElemStr(const Row, Col: Integer; const Value: string); override;

    function Get_ElemChar(const Row, Col: Integer): Char; override;
    procedure Set_ElemChar(const Row, Col: Integer; const Value: Char); override;

    {��� ������ ��������� �������� � �������� ��������� �����, ��� �
     � ������������. � ����������� �������� ��� ������ ����������� ������
     �������������}
    function GetVecElemCx(const Index: Integer): TExtendedComplex; override;
    procedure SetVecElemCx(const Index: Integer;
      const Value: TExtendedComplex); override;

    {������ ������� � �������� ������� � ��������� ����}  
    function GetVecElemStr(const Index: Integer): string; override;
    procedure SetVecElemStr(const Index: Integer; const Value: string); override;

    function GetVecChar(const Index: Integer): Char; override;
    procedure SetVecChar(const Index: Integer; const Value: Char); override;

  public
    procedure SetElemI(const Indexes: array of Integer; const Value: Integer); override;
    function GetElemI(const Indexes: array of Integer): Integer; override;

    function GetElem(const Indexes: array of Integer): Extended; override;
    procedure SetElem(const Indexes: array of Integer; const Value: Extended); override;

    procedure SetComplex(const Indexes: array of Integer;
      const Value: TExtendedComplex); override;
    function GetComplex(const Indexes: array of Integer): TExtendedComplex; override;

    procedure SetElemI64(const Indexes: array of Integer; const Value: Int64); override;
    function GetElemI64(const Indexes: array of Integer): Int64; override;

    procedure SetElemStr(const Indexes: array of Integer; const Value: string); override;
    function GetElemStr(const Indexes: array of Integer): string; override;

    procedure SetElemVar(const Indexes: array of Integer; const Value: Variant); override;
    function GetElemVar(const Indexes: array of Integer): Variant; override;

    procedure SetElemChar(const Indexes: array of Integer; const Value: Char); override;
    function GetElemChar(const Indexes: array of Integer): Char; override;

    function GetRowChars(ARow: Integer): string; override;
    procedure SetRowChars(ARow: Integer; Text: string); override;
  end;

  {:����� �������� ����� �����, ����������� � Integer}
  TIntegerMatrixClass = class(TNumericMatrixClass)
  private

  protected
    procedure Init; override;

    function GetVecElem(const Index: Integer): Extended; override;
    procedure SetVecElem(const Index: Integer; const Value: Extended); override;

    function GetVecElemI64(const Index: Integer): Int64; override;
    procedure SetVecElemI64(const Index: Integer; const Value: Int64); override;
  public
    procedure AssignElem(const Matrix: TMatrix;
      const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer); override;

    procedure AssignDynElem(const Matrix: TMatrix;
      const SelfIndexes, MatrixIndexes: array of Integer); override;

    procedure AssignVecElem(const Matrix: TMatrix;
      const SelfIndex, MatrixIndex: Integer); override;
  end;

  {:����� �������� ������ ����� �����, ����������� � Int64. ������� ������� ������
   ������ ������������ ������ � ��������� �������� ������� � �������
   �������, ����������� �������� VecElemI64}
  TInt64MatrixClass = class(TNumericMatrixClass)
  private

  protected
    procedure Init; override;

    function GetVecElem(const Index: Integer): Extended; override;
    procedure SetVecElem(const Index: Integer; const Value: Extended); override;

    function GetVecElemI(const Index: Integer): Integer; override;
    procedure SetVecElemI(const Index, Value: Integer); override;
  public
    procedure AssignElem(const Matrix: TMatrix;
      const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer); override;

    procedure AssignDynElem(const Matrix: TMatrix;
      const SelfIndexes, MatrixIndexes: array of Integer); override;

    procedure AssignVecElem(const Matrix: TMatrix;
      const SelfIndex, MatrixIndex: Integer); override;
  end;  

  {:����� �������� ������������ �����, ����������� � Extended}
  TFloatMatrixClass = class(TNumericMatrixClass)
  private

  protected
    procedure Init; override;

    procedure SetVecElemI(const Index, Value: Integer); override;
    function GetVecElemI(const Index: Integer): Integer; override;

    function GetVecElemI64(const Index: Integer): Int64; override;
    procedure SetVecElemI64(const Index: Integer; const Value: Int64); override;
  public
    procedure AssignElem(const Matrix: TMatrix;
      const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer); override;

    procedure AssignDynElem(const Matrix: TMatrix;
      const SelfIndexes, MatrixIndexes: array of Integer); override;

    procedure AssignVecElem(const Matrix: TMatrix;
      const SelfIndex, MatrixIndex: Integer); override;
  end;

  {:����� �������� ������������ ����������� �����}
  TFloatComplexMatrixClass = class(TFloatMatrixClass)
  private

  protected
    procedure Init; override;

    function GetVecElem(const Index: Integer): Extended; override;
    procedure SetVecElem(const Index: Integer; const Value: Extended); override;

    function GetVecElemStr(const Index: Integer): string; override;
    procedure SetVecElemStr(const Index: Integer; const Value: string); override;

  public
    procedure AssignElem(const Matrix: TMatrix;
      const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer); override;

    procedure AssignDynElem(const Matrix: TMatrix;
      const SelfIndexes, MatrixIndexes: array of Integer); override;

    procedure AssignVecElem(const Matrix: TMatrix;
      const SelfIndex, MatrixIndex: Integer); override;
  end;

  {:������ ����� ����� ���� Byte. �������� ������� �������� 1 ���� � �����
   � ��������� 0..255}
  TByteMatrix = class(TIntegerMatrixClass)
  protected
    function GetVecElemI(const Index: Integer): Integer; override;
    procedure SetVecElemI(const Index, Value: Integer); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ �������� ���� AnsiChar. ������ ������ �������� 1 ���� }
  TCharMatrix = class(TByteMatrix)
  protected
    procedure Init; override;
    function GetAsString: string; override;
    procedure SetAsString(const Value: string); override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ����� ����� ���� Integer. �������� ������� �������� 4 ����� � �����
   � ��������� -2147483648..2147483647}
  TIntegerMatrix = class(TIntegerMatrixClass)
  protected
    function GetVecElemI(const Index: Integer): Integer; override;
    procedure SetVecElemI(const Index, Value: Integer); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;


  {:������ ����� ����� ���� Shortint. �������� ������� �������� 1 ���� � �����
   � ��������� -128 ... 127}
  TShortIntMatrix = class(TIntegerMatrixClass)
  protected
    function GetVecElemI(const Index: Integer): Integer; override;
    procedure SetVecElemI(const Index, Value: Integer); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ����� ����� ���� Short (Smallint). �������� ������� �������� 2 ����� � �����
   � ��������� -32768..32767}
  TShortMatrix = class(TIntegerMatrixClass)
  protected
    function GetVecElemI(const Index: Integer): Integer; override;
    procedure SetVecElemI(const Index, Value: Integer); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ����� ����� ���� Word. �������� ������� �������� 2 ����� � �����
   � ��������� 0..65535}
  TWordMatrix = class(TIntegerMatrixClass)
  protected
    function GetVecElemI(const Index: Integer): Integer; override;
    procedure SetVecElemI(const Index, Value: Integer); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ����� ����� ���� Int64. �������� ������� �������� 8 ���� � �����
   � ��������� -2^63..2^63-1}
  TInt64Matrix = class(TInt64MatrixClass)
  protected
    function GetVecElemI64(const Index: Integer): Int64; override;
    procedure SetVecElemI64(const Index: Integer; const Value: Int64); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ����� ����� ���� Cardinal. �������� ������� �������� 4 ����� � �����
   � ��������� 0..4294967295. ���� ����� �� ����������� �� TIntegerMatrixClass
   �� ������� ����, ��� ��� Integer �� ����� �������� ��������� ��������}
  TCardinalMatrix = class(TInt64MatrixClass)
  protected
    function GetVecElemI64(const Index: Integer): Int64; override;
    procedure SetVecElemI64(const Index: Integer; const Value: Int64); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ������� ����� ���� Extended. �������� ������� �������� 10 ����, �����
   � ��������� 3.6 x 10^-4951 .. 1.1 x 10^4932 � ����� �������� ������� 19-20 ��������}
  TExtendedMatrix = class(TFloatMatrixClass)
  protected
    function GetVecElem(const Index: Integer): Extended; override;
    procedure SetVecElem(const Index: Integer; const Value: Extended); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ������� ����� ���� Double. �������� ������� �������� 8 ����, �����
   � ��������� 5.0 x 10^-324 .. 1.7 x 10^308 � ����� �������� ������� 15-16 ��������.
   ��� Double ������������� ���� Real � ��������� ������� Delphi}
  TDoubleMatrix = class(TFloatMatrixClass)
  protected
    function GetVecElem(const Index: Integer): Extended; override;
    procedure SetVecElem(const Index: Integer; const Value: Extended); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ������� ����� ���� Single. �������� ������� �������� 4 �����, �����
   � ��������� 1.5 x 10^-45 .. 3.4 x 10^38 � ����� �������� ������� 7-8 ��������}
  TSingleMatrix = class(TFloatMatrixClass)
  protected
    function GetVecElem(const Index: Integer): Extended; override;
    procedure SetVecElem(const Index: Integer; const Value: Extended); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ������� ����� ���� Comp. �������� ������� �������� 8 ����, �����
   � ��������� -2^63+1 .. 2^63 -1  � ����� �������� ������� 19-20 ��������}
  TCompMatrix = class(TFloatMatrixClass)
  protected
    function GetVecElem(const Index: Integer): Extended; override;
    procedure SetVecElem(const Index: Integer; const Value: Extended); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ������� ����� ���� Currency. �������� ������� �������� 8 ����, �����
   � ��������� -922337203685477.5808..922337203685477.5807 � ����� ��������
   ������� 19-20 ��������}
  TCurrencyMatrix = class(TFloatMatrixClass)
  protected
    function GetVecElem(const Index: Integer): Extended; override;
    procedure SetVecElem(const Index: Integer; const Value: Extended); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ����������� ����� ���� TExtendedComplex. ������ ������� ������� ��
   ���� ����� ���� Extended � �������� 20 ����}
  TExtendedComplexMatrix = class(TFloatComplexMatrixClass)
  protected
    function GetVecElemCx(const Index: Integer): TExtendedComplex; override;
    procedure SetVecElemCx(const Index: Integer;
      const Value: TExtendedComplex); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ����������� ����� ���� TDoubleComplex. ������ ������� ������� ��
   ���� ����� ���� Double � �������� 16 ����}
  TDoubleComplexMatrix = class(TFloatComplexMatrixClass)
  protected
    function GetVecElemCx(const Index: Integer): TExtendedComplex; override;
    procedure SetVecElemCx(const Index: Integer;
      const Value: TExtendedComplex); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;

  {:������ ����������� ����� ���� TSingleComplex. ������ ������� ������� ��
   ���� ����� ���� Single � �������� 8 ����}
  TSingleComplexMatrix = class(TFloatComplexMatrixClass)
  protected
    function GetVecElemCx(const Index: Integer): TExtendedComplex; override;
    procedure SetVecElemCx(const Index: Integer;
      const Value: TExtendedComplex); override;

    procedure Init; override;
  public
    class function GetAlias: TSignature; override;
  end;


  {==================== ����� TWorkspace (������� �������) =====================}
  {:������� �������.
   ������� ������� ������ ������������� ���� ��� �������� � ��� ������ ��������
   (� ��� ����� � ������� ��������). ��������� ��������� ��������� �������� �����
   ��� ����� ��������� ��������� (��������, ������ / ������ ���� �������� �
   ����� / ���� � �.�.).}
  TWorkspace = class(TMatrix)
  protected
    procedure Init; override;

    function GetMatrixSize: Integer; override;
  public

    {:���������� ������ �� ������ ������� �������}
    function ThisWorkspace: TWorkspace;

    class function GetAlias: TSignature; override;

    {������� �� ������� ������� ��� �������. �������� ������� ������� ��
     �����������}
    procedure Clear; overload; override;

    {:������� ������� � ���������� ������� �� ������� �������.}
    procedure Clear(const Names: array of TMatrixName); reintroduce; overload;

    function IsEmpty: Boolean; override;

    {:���������� ������� ������� ������� � �����, ������� � ������� �������}
    procedure SaveToStreamEx(AStream: TStream; AName: TMatrixName = '';
      SaverClass: TMatrixClass = nil); override;

    {:��������� ������� ������� ������� �� ������, ������� � ������� �������}
    procedure LoadFromStreamEx(AStream: TStream); override;

    {:��������� ������� ������� ������� � ��������� ����}
    procedure SaveWorkspace(const AFileName: string; DoRewrite: Boolean = False);

    {:��������� ������� � ������� ������� �� ���������� �����}
    procedure LoadWorkspace(const AFileName: string);

    {:�������� �������� ������� ������� (������ � ��������� ������� �� �����)}
    property MatrixByName; default;
  end;

{====================== ����� TWorkspace �������� =============================}

{:���������� ����� ��������� ������. ������ ������� ���������� ����� ���������
 ������ ����� �������� ��������� ������ RAM � ��������� ������ ����� ��������.
 ��������� ����� ���������� ����� 2-� �����.}
function AvailMemory: Double;

{:���������� ������ ������, ��������� ���������� ����������������� ������ }
function GetTotalVirtualMemory: Cardinal;

{:��������� �� ������������ � ������ ����� ����������� �����}
function FloatComplex(const Real, Imag: Extended): TExtendedComplex;

{:��������� �� ������������ � ������ ����� ����������� �����}
function ExtendedComplex(const Real, Imag: Extended): TExtendedComplex;

{:��������� �� ������������ � ������ ����� ����������� �����}
function SingleComplex(const Real, Imag: Single): TSingleComplex;

{:��������� �� ������������ � ������ ����� ����������� �����}
function DoubleComplex(const Real, Imag: Double): TDoubleComplex;

{:������������ ����������� ����� ������� TExtendedComplex � TDoubleComplex}
function CmplxExtendedToDouble(Value: TExtendedComplex): TDoubleComplex;

{:������������ ����������� ����� ������� TExtendedComplex � TSingleComplex}
function CmplxExtendedToSingle(Value: TExtendedComplex): TSingleComplex;

{:������������ ����������� ����� ������� TDoubleComplex � TSingleComplex}
function CmplxDoubleToSingle(Value: TDoubleComplex): TSingleComplex;

{:������������ ����������� ����� ������� TSingleComplex � TDoubleComplex}
function CmplxSingleToDouble(Value: TSingleComplex): TDoubleComplex;

{:������������ ����������� ����� ������� TSingleComplex � TExtendedComplex}
function CmplxSingleToExtended(Value: TSingleComplex): TExtendedComplex;

{:���������� ��� ��������� ������ ��� ��������� �������� ������.
 @param Str ������, ��� ������� ������� ��������� ���.
 @result ���������� -1, ���� � �������� Str ������ ������ ������. ���������� 0,
   ���� � �������� Str ������ ������, ��� ������ ������ "$" (���� �������), ���
   � Matrix32 ������������� ��� ��� ��������������� �������. � ��������� �������
   ���������� �������� 1..MaxInteger.}
function GenerateHash(const Str: string): Integer;

{:����������, ���������� �� ��� � �������.
 ������ �����, ����� � ������ �������� "$", �����, ������� MaxArrayNameLength
 ������ ��������� ���������� � ��� ��� ������� ������ False. ��� ������������
 ����� �������� ���������� CheckMatrixName ������� ������ AName ����������� ��
 ������������. � ���� ������ ��� ������ ���������� � ���������� �������, � ����� 
 ����� ���� � ����� ��������� ��������� �������, ����� � ����� �������������.
 @param AName ��� �������, ���������� ��������.}
function MatrixNameIsValid(const AName: string): Boolean;

{:��������� ������� �� �������������� � ����� MatrixTypes.
 @param Matrices �������� ������ ������ �� ������� TMatrix
 @param MatrixTypes ��������� �����, ������������ ��� ��������
 @param IgnoreNil ��������� ������� ������� ������� ��������� ��������
 @raises EMatrixBadRef, ���� ��� IgnoreNil=False ������
   ���� �� ������ Matrices �� ������������� ������� TMatrix
 @example
 <code>
   if not IsSameMatrixTypes([Matrix1, Matrix2, Matrix3], [atNumeric]) then
     raise EMatrixWrongElemType.Create(matSNotNumericType);
 </code> }
function IsSameMatrixTypes(Matrices: array of TMatrix;
  MatrixTypes: TMatrixTypes; IgnoreNil: Boolean = False): Boolean;

{:��������� ������� �� �������������� � ����� MatrixTypes.
 @raises EMatrixBadRef ��� IgnoreNil=False ������
   ���� �� ������ Matrices �� ������������� ������� TMatrix
 @raises EMatrixWrongElemType ������ ���� �� �������� �� ������������� MatrixTypes}
procedure CheckForMatrixTypes(Matrices: array of TMatrix;
  MatrixTypes: TMatrixTypes; IgnoreNil: Boolean = False);

{:���������� ���������� ��� ��� ������� TMatrix. ��� ��������� ����� ������������
  ������ MATRIX_GEN_N, ��� N - �������� �������� ���������� ���������� ����
  GeneratorNameValue. ������� - ���������������� (�� ��� ������� ����������� �������)}
function GenMatrixName(): TMatrixName;

{:����������, ����� �� ������� �������� ����� �����.
 @param Matrices �������� ������ ������ �� ������� TMatrix
 @result ���������� True, ���� � ���� �������� ������ Matrices ������� ���������}
function IsEqualArraysSize(Matrices: array of TMatrix): Boolean;

{:����������, ��� �� ��������� ������� ����� ���������� ������ � ���������� ����������}
function IsEqualArrays(Matrices: array of TMatrix): Boolean;

{:���������, ��������� �� ��������� ������� � ������ ������.
 @param Matrices �������� ������ ������ �� ������� TMatrix}
function IsSameMatrixClass(Matrices: array of TMatrix): Boolean;

{:��������� ����� � ������.
 ������ ������� ���������� � �������� ����������� ����� � ������� ��������
 ������ MatrixDecimalSeparator (�� ��������� ��� �����)}
function FloatToString(Value: Extended): string;

{:������������� �������, �������������� ������� ����� � ������ �������� Matrix32.
 @example ����������, ����� Matrix32 ������� �������� 2-������� ������� � �������
 ��� ������ ���� (����� ������������ ��������� � ��������) � �������� �� �����
 4-� ������ ����� �������. ������ ����� �������:
 <code>
    function MyFloatToStr(Value: Extended): string;
    begin
      Result := Format('%10.4f', [Value]);
      Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
    end;
 </code> }
procedure SetFloatToStringFunction(Value: TFloatToStringFunction);

{:������������ ������ � �����. � �������� ����������� ����� � ������� ��������
 ����� ��������� ��� MatrixDecimalSeparator, ��� � DecimalSeparator.
 @raises EConvertError, ���� S �������� ������������ �����}
function StringToFloat(S: string): Extended;

{$IFNDEF D2009PLUS}
{:���������, ��������� �� ������ C � ��������� ��������� �������� CharSet.
  ������� CharInSet � Delphi 2009 � ���� ��������� � ������ SysUtils}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
{$ENDIF}

{:������� ������������� �������.
 ������� ������� ��� ��������� � �������� �������, � � ������ ��� �������������
 ������� ������ � ������. ���� � ������ ����������� �������, ��� ��� ������
 ���� �������, �� ��� ���������� �� ������. ���� ���� DeleteAllSpaces
 ���������� � True, �� ��� ������� ���������.}
function DeleteRepeatingSpaces(S: string; DeleteAllSpaces: Boolean = False): string;

{:������� ������������� �������.
 ������� �� ������ S ������������� ������� Chars, �������� ���� �� ��� �
 ������� ��� �� ������ ReplaceChar. ���� ������� �� ��������� Chars ���������
 � ������ ��� � ����� ������, �� ��� ��������� ����������.
 ������� �������������� ��� ������� ��������� ������� �����}
function DeleteRepeatingSymbols(const S: string; Chars: TSysCharSet; ReplaceChar: Char): string;

{:������������ ������ ��������� OldPattern � ������ S �� ������ NewPattern.
 ��������� ������������ SysUtils.StringReplace, ������ �������� �� �����
 ��� (� ��������� ������� � ������ ���) �������}
function FastStringReplace(const S: string; OldPattern: string; const NewPattern: string;
  Flags: TReplaceFlags = [rfReplaceAll]): string;

{:��������� ������ ARow �� ����� � �������� �� � ������������ ������.
 ����� � ������ ARow ������ ����������� �������� MatrixNumberDelimiter
 (���� ��������, ���� ����������� ����� ���������� UseSpaceDelimiter).
 ������� ���������� ��������� � ���� ������������� ������� ����������� �����.
 @raises EMatrixParsingError, ���� � ������ ARow ���������� ������������ �������}
function ParseMatrixRow(ARow: string): TDynExtendedComplexArray;

{:��������� ������ S �� ����� � �������� �� � ������������ ������.
 ������������ ��� ��������������� ��������� ������ � �������� �������� �������.
 �������� ��������� ��������� ������� ParseMatrixRow}
function StringToDimValues(S: string): TDynIntArray;

{:����������� �������� �������� ������� � ��������� ���.
 � ���������� ���������� �������������� ���������: '2 � 3 � 5 � 8'.
 @param DimValues ������ �������� �������
 @param ShowMaxDimensions ����������, ������� �������� ������������ ������� �����
 ��������� � ���������. ���� � ���, ��� ������������ ����� ������� ������ � �
 ��������� ���������, ��� ����������� � ��������� ���� ������ ��������������.}
function DimValuesToString(DimValues: array of Integer;
  ShowMaxDimensions: Integer = 10): string;

{:���������� � ������, ������� � ������� �������, ������ � �������� ������.
 @param AStream ������ �� �����, � ������� ����������� �����
 @param AName ��� �������� � ������ �������
 @param Alias ��������� ������ �������, ���������� � ������
 @param BeginAddress ����� ������ �������� ������� � ������
 @param NextAddress ����� ������ ���������� ������� � ������
 @param ReadedName ��� ���������� ������� � ������. ������������ ���
   ���������������� �������� ���� �������� ������. ������� �������� � ������
   ����������������� ��������, ���� � �������� AName ������� ������ ������.
 @result ��� �������� ������ ������� ������������� ��������� ������ � ������
   �������� ������� � ���������� True. ���� ����� ��������� ��������, �� �������
   ��������������� ��������� ������ � ��������� "��� ����" � ���������� False.}
function FindMatrixInStream(AStream: TStream; const AName: TMatrixName;
  var Alias: TSignature; var BeginAddress, NextAddress: Int64;
  var ReadedName: TMatrixName): Boolean;

{:��������� ����� ������� � ������ TFileStream, ������� ������������ ����.
 ��� �������, � ������� �� FindMatrixInStream, ��������� ������ �� ��������� �����,
 ������������ ������� � ������� ������������ ������������ ����, ��������� �� 32 ����.
 ��� ������� ������������� ��� �������� ����, ������������� �� �������� ���� �������
 Matrix32. ���� � ������ ������ ������ ������� ��������� ������ ��������� � ����,
 �� ������� ��������� �������� ������������ ����.
 @raises EMatrixFileStreamError �������� ������������ ���� ��������, ��� ������
   ������ �� �������� ���������� ��� Matrix32}
function FindMatrixInFileStream(AStream: TFileStream;
  const AName: TMatrixName; var Alias: TSignature;
  var BeginAddress, NextAddress: Int64; var ReadedName: TMatrixName): Boolean;

{:����������, ���� �� � ��������� ����� ������ � �������� ������.
 @param AFileName ��� ��������� �����, � ������� ����������� �����
 @param AName ��� �������� �������. ���� ��� �� �������, �� ������� ������ False
 @param Alias ��������� ������ �������� �������. ���� Alias �� ������, ��
   ������������ ����� ������ � ������ AName}
function MatrixExistsInFile(const AFileName: string; const AName: TMatrixName;
  const Alias: TSignature = ''): Boolean;

{:���������� ��� �������� ��� ���������� �����}
function GenerateFileMutexName(AFileName: string): string;

{:������� ������ TFileStream � ������������ �������� ������������ �����. ������
  ������������, ���� � ����� � ��� �� ������ ����� �������� ������������
  ��������� ����������, ���� ������� ������ ����������. 
 @param AFileName ��� �����
 @param AMode ����� ������ � ������
 @param WaitTime ����� � �������������, ������� ������� ��������� �������, ������
   ��� �������� ������� ���� � �������� �������. � ������� Matrix32 �����
   �������� �������� � ���������� ���������� MatrixWaitFileOpen. ���� ���� ��
   ������� ������� �� ��������� ������, �� ����� ������������� ��������������� ����������.}
function WaitAndCreateFileStream(const AFileName: string; AMode: Word; WaitTime: Integer): TFileStream;

{:��������� �������������� ��������� ����� AFileName.
 ���� � ���, ��� ���� � ��� �� ������ � ���� ����� ����������� ����� ���.
 ���� �� ������ ��� ����� ����� ������ ������, ��� ����� �������� � �������������
 ���������� ������� �����. ������������� ������������ ������������ ������ ��������
 @param AFileName ��� ��������� �����
 @param AWaitTime - ����� �������� �������� �����}
procedure DefragBinaryFile(const AFileName: string; AWaitTime: Integer = -1);

{:������������ ����� TMatrixClass.
 ����������� ������� ���������� ��� ������ ������� ��������/����������
 �������� TMatrix � ������ � �����
 @param AClass ������ �� ����� TMatrixClass}
procedure RegisterMatrixClass(AClass: TClass);

{:�������� ������, ����� ���� ���������� ������ TMatrix.
 ������ ����������� ��������� FreeAndNil, �� ���������� �� ��� ���, ��� ��������
 ������ ��� �������� TMatrix � ��������� ���������� ����������� ������� �
 ������� ������ TMatrix.FreeMatrix}
procedure MatrixFreeAndNil(var AMatrix: TMatrix); 

{:���������� ������ TMatrixName � ����� TStream.}
procedure WriteMatrixNameToStream(const Str: TMatrixName; AStream: TStream);

{:��������� ������ TMatrixName �� ������ TStream. ������ ������ ���������
  � 1-�������� ��������� ASCII}
function ReadMatrixNameFromStream(AStream: TStream): TMatrixName;

{:������������ �������� ������ ����� Integer � ������������ ������ TDynIntArray}
function ConvertToDynIntArray(const IntArray: array of Integer): TDynIntArray;

{:���������� ���������� ������ AClass � ���������� AText.
 @param AClass ����� ������� ����������
 @param AText ����� ��������� �� ������
 @param FuncName ��� �������, � ������� ���������� �������������
 @param AMatrix ������ TMatrix, �������������� � ������ �����������
 @example
 <code>
 function DivValues(A, B: Integer): Double;
 begin
   if B = 0 then
     RaiseMatrixError(EZeroDivide, SDivByZero, 'function DivValues', nil);
   Result := A / B;
 end;
 </code>}
procedure RaiseMatrixError(AClass: ExceptClass; const AText: string;
  FuncName: string = ''; AMatrix: TMatrix = nil);

{:��������� ����������� ����������.
 @param ExceptObject ������, ��������������� ���������� ����� � ������� ��������� try...except ����������.
 @param FuncName ��� �������, � ������� ���� ����������� ����������.
 @param AMatrix ������ TMatrix, �������������� � ������ �����������
 @example
 <code>
 procedure CallDivValues;
 begin
   try
     DivValues(100, 0);
   except
     on E: Exception do
       ReRaiseMatrixError(E, 'procedure CallDivValues', nil);
   end;
 end;
 </code> }
procedure ReRaiseMatrixError(ExceptObject: Exception;
  const FuncName: string; AMatrix: TMatrix = nil);

{:����������� ������ ���������� ������, �������� � ����� ���������� ��������������
 ���������� ����������. ������������� ������ ������� ����� ��������������� ��
 ��������� � �������������� ������� ReRaiseMatrixError, ��� ��� �������� ������
 �� ���������� �������, ��������� <A HRef="http://sourceforge.net/projects/jcl">JEDI</A>
 @param ExceptObject ������, ��������������� ���������� ����� � ������� ���������
   try...except ����������.
 @param FuncName ��� �������, � ������� ���� ����������� ����������.
 @param AMatrix ������ TMatrix, �������������� � ������ �����������
 @example
 <code>
 procedure CallDivValues;
 begin
   try
     DivValues(100, 0);
   except
     on E: Exception do
       raise MatrixReCreateExceptObj(E, 'procedure CallDivValues', nil);
   end;
 end;
 </code> }
function MatrixReCreateExceptObj(ExceptObject: Exception;
  const FuncName: string; AMatrix: TMatrix = nil): Exception;

{:������� ������ ���������� ������ AClass � ���������� AText.
 ������������� ������ ������� ����� ��������������� �� ��������� � ��������������
 ������� ReRaiseMatrixError, ��� ��� �������� ������ �� ���������� �������,
 ��������� <A HRef="http://sourceforge.net/projects/jcl">JEDI</A>
 @param AClass ����� ������� ����������
 @param AText ����� ��������� �� ������
 @param FuncName ��� �������, � ������� ���������� ����� �������������
 @param AMatrix ������ TMatrix, �������������� � ������ �����������
 @example
 <code>
 function DivValues(A, B: Integer): Double;
 begin
   if B = 0 then
     raise MatrixCreateExceptObj(EZeroDivide, SDivByZero, 'function DivValues', nil);
   Result := A / B;
 end;
 </code>}
function MatrixCreateExceptObj(AClass: ExceptClass; const AText: string;
  FuncName: string = ''; AMatrix: TMatrix = nil): Exception;

{:��������� � ����� ���������� ExceptObject �������������� ����������.
 � �������������� ���������� ���������: ����� ������� ����������, ���� �������,
 ����������� ���������� �� �������, �������������� � ������ �����������.
 @param ExceptObject ������, ��������������� ���������� ����� � ������� ��������� try...except ����������
 @param FuncName ��� �������, � ������� ���� ����������� ����������
 @param AMatrix ������ TMatrix, �������������� � ������ ����������� }
procedure MatrixCorrectExceptMsg(ExceptObject: Exception;
  const FuncName: string; AMatrix: TMatrix = nil);

{==============================================================================
 ============== ������� ��� ������ � �������-����������� ������� ==============}

{:������������ ����� �� ���������� ������������� � ������ TBCDNumber.
 @raises EMatrixBCDError ������ SValue �������� �����, ������� ����������
   ���������������� ��� BCD-�����.}
function StringToBCD(const SValue: string): TBCDNumber;

{:������������ ����� �� ���������� ������������� � ������ TBCDNumber.
 @result ���������� True, ���� ��������������� ��������� �������
   (� ���� ������ � ���������� BCDValue ����� ����������� ���������� BCD-�����)}
function TryStringToBCD(const SValue: string; var BCDValue: TBCDNumber): Boolean;

{:������������ ����� �� ���������� ������������� � ������ TBCDNumber.
 � ������ ������ ��������� ������ �������� �� ��������� �������� BCDDefault}
function StringToBCDDef(const SValue: string; const BCDDefault: TBCDNumber): TBCDNumber;

{:������������ ����� ������� TBCDNumber � ��������� �������������}
function BCDToString(const BCDValue: TBCDNumber): string;

{����������� BCD-����� ����� �������, ����� �� ����� ���� ���������,
 � ��������� ����������� ���� �� ����� � ��� �� �����.}
procedure _BCDAlign(BCDValue1, BCDValue2: TBCDNumber; var BCDOut1, BCDOut2: TBCDNumber);

{��������� �������� ���� BCD-�����. ���� ��������� �� ������ � ��������� �����,
 �� ���������� ��������� �� ������}
function BCDSum(const BCDValue1, BCDValue2: TBCDNumber): TBCDNumber;

{��������� ��������� ���� BCD-�����}
{ TODO : ������� BCDSub �� ��� ��� �� �����������}
function BCDSub(const BCDValue1, BCDValue2: TBCDNumber): TBCDNumber;

{========= ������� ��� ������ � �������-����������� ������� ��������� =========
 ==============================================================================}

var
  {:������� �������, ����������� �� ���������}
{$IFDEF CreateBaseWorkspace}
  Base: TWorkspace;
{$ENDIF}

  {:����� � �������������, � ������� �������� ������� ������ � ������� �����
    �������� ������� ���� ��� ������ ��� ������.}
  MatrixWaitFileOpen: Integer = 1000;

  {:������������� ������ ������� TMatrixClass. �������� ������ ����
   ClassAlias=ClassType. ������������ � �������� ��� ������ � ��������}
  MatrixClassList: TStringList;

  {���������� ����������. � ������� �������� ShowMessage ������ �����������
   with ... do. ������������ ������������� Matrix32}
  SDebug: string;

  {:������� BCD-�����.}
  BCDEmpty: TBCDNumber;

  {:������� �������� TMatrix. ��� �������� ������� ������� �������������. ���
    �������� - �����������}
  MatrixObjectCounter: Integer;

  {:�������� Epsilon ��� ������� ��������� ������������ ����� SameValue. ���������,
   ��� ��� ������������ ����� ����� ����� �����, ���� ������� ����� ���� �� ���������
   ������� ��������. �� ������ � run-time �������� ������ ��������, ���� ���
   �� �����-�� ������� ��� �� ����������}
  SameValueEpsilon: Extended = 1E-15;

{$IFDEF UseLogger}
  ALog: TLDSLogger;
{$ENDIF}

{============================ ��������� �������� ==============================}

{======================== ����������� �������������� �������� =================}

{:��������� �������� ������� �����}
function opSum(const Value1, Value2: Extended): Extended;
{:��������� �������� ����� �����}
function opSumI(const Value1, Value2: Integer): Integer;
{:��������� �������� ������� ����� ����� Int64}
function opSumI64(const Value1, Value2: Int64): Int64;
{:��������� ��������� ������� �����}
function opSub(const Value1, Value2: Extended): Extended;
{:��������� ��������� ����� �����}
function opSubI(const Value1, Value2: Integer): Integer;
{:��������� ��������� ������� ����� ����� Int64}
function opSubI64(const Value1, Value2: Int64): Int64;
{:��������� ��������� ������� �����}
function opMul(const Value1, Value2: Extended): Extended;
{:��������� ��������� ����� �����}
function opMulI(const Value1, Value2: Integer): Integer;
{:��������� ��������� ������� ����� ����� Int64}
function opMulI64(const Value1, Value2: Int64): Int64;
{:��������� ������� ������� �����}
function opDiv(const Value1, Value2: Extended): Extended;
{:��������� ������� ����� �����}
function opDivI(const Value1, Value2: Integer): Integer;
{:��������� ������� ������� ����� ����� Int64}
function opDivI64(const Value1, Value2: Int64): Int64;
{:��������� ������� ������� ����� � ����������� � ������� ����}
function opTruncDiv(const Value1, Value2: Extended): Extended;
{:�������� ������� ����� Value1 � ������� Value2}
function opPower(const Value1, Value2: Extended): Extended;

{================================= �������� ��������� ==========================}

{:���������� ����� ����� ����� Value1 � Value2.
 @result ���������� 1, ���� ����� �����, � ����, ���� �� �����}
function opEQ(const Value1, Value2: Extended): Extended;
{:���������� ����� ����� ����� Value1 � Value2.
 @result ���������� 1, ���� ����� �� �����, � 0, ���� �����}
function opNE(const Value1, Value2: Extended): Extended;
{:���������� ����� ����� ����� Value1 � Value2.
 @result ���������� 1, ���� Value1 < Value2, � 0 � ��������� �������}
function opLT(const Value1, Value2: Extended): Extended;
{:���������� ����� ����� ����� Value1 � Value2.
 @result ���������� 1, ���� Value1 > Value2, � 0 � ��������� �������}
function opGT(const Value1, Value2: Extended): Extended;
{:���������� ����� ����� ����� Value1 � Value2.
 @result ���������� 1, ���� Value1 <= Value2, � 0 � ��������� �������}
function opLE(const Value1, Value2: Extended): Extended;
{:���������� ����� ����� ����� Value1 � Value2.
 @result ���������� 1, ���� Value1 >= Value2, � 0 � ��������� �������}
function opGE(const Value1, Value2: Extended): Extended; 

{================== ���������� ��������. ���������� 0 ��� 1 ===================}

{:��������� ��� ���������� Value1 � Value2 �������� �������� AND
 @result ���������� 1, ���� �������� �� �������, � 0 � ��������� �������}
function opAnd(const Value1, Value2: Extended): Extended;
{:��������� ��� ���������� Value1 � Value2 �������� �������� OR
 @result ���������� 1, ���� ������ ���� �� ��������� ���������. ���� ��� ��������
   ����� ����, �� ������� ���������� 0}
function opOr(const Value1, Value2: Extended): Extended;
{:��������� ��� ���������� Value1 � Value2 �������� �������� XOR
 @result ���������� 1, ���� ���� �� ��������� ���������, � ������ ������� ����� ����.}
function opXor(const Value1, Value2: Extended): Extended; 

{============================= ������� �������� ================================}

{:��������� �������������� ����� ����� Value1 �� Value2 ��������.
 @result ��� Value2 > 0 ���������� ����� �����, � ��� Value2 < 0 - ����� ������}
function opBitShiftI(const Value1, Value2: Integer): Integer;
{:��������� ����������� �������� AND (Result := Value1 and Value2)}
function opBitAndI(const Value1, Value2: Integer): Integer;
{:��������� ����������� �������� OR (Result := Value1 or Value2)}
function opBitOrI(const Value1, Value2: Integer): Integer;
{:��������� ����������� �������� XOR (Result := Value1 xor Value2)}
function opBitXorI(const Value1, Value2: Integer): Integer;

{_______________________________________________________________________________

              �������� ��� ������ � ������������ �������

  ������ ������ ������� ����� �� ������ VarCmplx. ����� ����������� �� ���
  �������. � ������ ������������� �� ������ ������ ����������� �� ��������������.
 _______________________________________________________________________________}


{=============== ����� ������� ��� ������ � ������������ ������� ==============}

procedure ComplexGetAsPolar(const Value: TExtendedComplex;
  var ARadius, ATheta: Extended; AFixTheta: Boolean = True);
{:����������, �������� �� ����������� ����� �������}
function ComplexIsZero(const Value: TExtendedComplex): Boolean;
{:����������, ����� �� ����������� ����� ����� �����}
function ComplexIsEqual(const Value1, Value2: TExtendedComplex): Boolean;

function ComplexGetAbsSqr(const Value: TExtendedComplex): Extended;

function ComplexGetAbs(const Value: TExtendedComplex): Extended;
{:���������� NaN � �������������� � ������ �����}
function ComplexNaN: TExtendedComplex;
{:������������ ������ Value � ����������� ����� TExtendedComplex.}
function ComplexFromString(Value: string): TExtendedComplex;

{================= �������� ��� ������ � ������������ ������� =================}

{:��������� �������� ����������� ����� Value1 � Value2}
function opCmplxSum(const Value1, Value2: TExtendedComplex): TExtendedComplex;
{:��������� ��������� ����������� ����� Value1 � Value2}
function opCmplxSub(const Value1, Value2: TExtendedComplex): TExtendedComplex;
{:��������� ��������� ����������� ����� Value1 � Value2}
function opCmplxMul(const Value1, Value2: TExtendedComplex): TExtendedComplex;
{:��������� ������� ����������� ����� Value1 � Value2}
function opCmplxDiv(const Value1, Value2: TExtendedComplex): TExtendedComplex;
function opCmplxInvDiv(const Value1, Value2: TExtendedComplex): TExtendedComplex;
{:��������� ������� �������������� � ������ ����� ����� Value1 ��
  ������������ ����� ����� Value2}
function opCmplxDivBoth(const Value1, Value2: TExtendedComplex): TExtendedComplex;
{:�������� ����������� ����� Value1 � ������� Value2}
function opCmplxPower(const Value1, Value2: TExtendedComplex): TExtendedComplex;
{:��������� ����������� ����� �� �������������� ������ Value1 � Value2}
function opCmplxCopyRealParts(const Value1, Value2: TExtendedComplex): TExtendedComplex;

{================ ������� ��� ������ � ������������ ������� ===================}

{:���������� �������������� ����� ������������ ����� Value}
function fncCmplxReal(const Value: TExtendedComplex): TExtendedComplex;
{:�������� ������ ����� ����� Value � �������������� ����� ���������� Result.}
function fncCmplxImagToReal(const Value: TExtendedComplex): TExtendedComplex;

{:���������� ������ ����� ������������ �����.}
function fncCmplxImag(const Value: TExtendedComplex): TExtendedComplex;
{:����������� ���� �������������� � ������ ����� ������������ �����}
function fncCmplxNeg(const Value: TExtendedComplex): TExtendedComplex;
{:����������� ���� ������ ����� ������������ �����}
function fncCmplxConj(const Value: TExtendedComplex): TExtendedComplex;

function fncCmplxInverse(const Value: TExtendedComplex): TExtendedComplex;
{:��������� ���������� ������������ ����� Value}
function fncCmplxExp(const Value: TExtendedComplex): TExtendedComplex;  
{:��������� ����������� �������� ������������ ����� Value}
function fncCmplxLn(const Value: TExtendedComplex): TExtendedComplex;
{:��������� ���������� �������� ������������ ����� Value}
function fncCmplxLog10(const Value: TExtendedComplex): TExtendedComplex;
{:��������� �������� �� ��������� 2 ������������ ����� Value}
function fncCmplxLog2(const Value: TExtendedComplex): TExtendedComplex;
{:�������� ����������� ����� Value � �������}
function fncCmplxSqr(const Value: TExtendedComplex): TExtendedComplex;
{:��������� ���������� ������ ������������ ����� Value}
function fncCmplxSqrt(const Value: TExtendedComplex): TExtendedComplex;
{:��������� ������� ������������ ����� Value}
function fncCmplxCos(const Value: TExtendedComplex): TExtendedComplex;
{:��������� ����� ������������ ����� Value}
function fncCmplxSin(const Value: TExtendedComplex): TExtendedComplex;
{:��������� ������� ������������ ����� Value}
function fncCmplxTan(const Value: TExtendedComplex): TExtendedComplex;
{:��������� ��������� ������������ ����� Value}
function fncCmplxCot(const Value: TExtendedComplex): TExtendedComplex;
{:��������� �������� ������������ ����� Value}
function fncCmplxCsc(const Value: TExtendedComplex): TExtendedComplex;
{:��������� ������ ������������ ����� Value}
function fncCmplxSec(const Value: TExtendedComplex): TExtendedComplex;

{============ ������� ��� ������ � ������������ ������� ��������� =============}
{==============================================================================}

{==============================================================================}
{=========================== ��������� ������� ================================}

{:��������� �������� �������� Value.}
function fncNot(const Value: Extended): Extended; // ��������

{:������� - �������� (���������� ���������� �������� Value)}
function fncNone(const Value: Extended): Extended;

{============================= �������������� ������� ========================}

{:��������� ����� �������� Value}
function fncSin(const Value: Extended): Extended;
{:��������� ������� �������� Value}
function fncCos(const Value: Extended): Extended;
{:��������� ���������� �������� Value}
function fncRound(const Value: Extended): Extended;
{:��������� ���������� �������� Value � ������� ����}
function fncTrunc(const Value: Extended): Extended;
{:��������� ���������� �������� Value}
function fncInt(const Value: Extended): Extended;
{:���������� ������� ����� �������� Value}
function fncFrac(const Value: Extended): Extended;
{:��������� ���������� ������ �������� Value}
function fncSqrt(const Value: Extended): Extended;
{:�������� �������� Value � �������}
function fncSqr(const Value: Extended): Extended;
{:���������� ������ ����� Value (����������� �����)}
function fncAbs(const Value: Extended): Extended;
{:�������� ���� ����� Value}
function fncNeg(const Value: Extended): Extended;
{:��������� ���������� �������� Value}
function fncExp(const Value: Extended): Extended;
{:�������� �������. ��������� �� �������: ���� Value >= 0,
 �� ���������� 1, ����� ���������� 0}
function fncSign(const Value: Extended): Extended;

var
   {�������� ����������� �������. �� �������� �� ������� � ������� Delphi}

         fncTan: TFloatFunction = Tan;
         fncCotan: TFloatFunction = Cotan;
         fncArcsin: TFloatFunction = Arcsin;
         fncArccos: TFloatFunction = Arccos;
         fncSecant: TFloatFunction = Secant;
         fncCosecant: TFloatFunction = Cosecant;
         fncLog10: TFloatFunction = Log10;
         fncLog2: TFloatFunction = Log2;
         fncLnXP1: TFloatFunction = LnXP1;
         fncCosh: TFloatFunction = Cosh;
         fncSinh: TFloatFunction = Sinh;
         fncTanh: TFloatFunction = Tanh;
         fncCotH: TFloatFunction = CotH;
         fncSecH: TFloatFunction = SecH;
         fncCscH: TFloatFunction = CscH;
         fncArcCot: TFloatFunction = ArcCot;
         fncArcSec: TFloatFunction = ArcSec;
         fncArcCsc: TFloatFunction = ArcCsc;
         fncArcCosh: TFloatFunction = ArcCosh;
         fncArcSinh: TFloatFunction = ArcSinh;
         fncArcTanh: TFloatFunction = ArcTanh;
         fncArcCotH: TFloatFunction = ArcCotH;
         fncArcSecH: TFloatFunction = ArcSecH;
         fncArcCscH: TFloatFunction = ArcCscH;

const

  {:����������}
  Exp = 2.718281828459045235360287471352663;

  {:����� ��������, ���������� � ����� �������}
  ValidChars = ['a'..'z', 'A'..'Z', '0'..'9', '_'];

  {:����� ��������, ���������� � ��������� ������������� �����}
  NumberChars = ['0'..'9', MatrixDecimalSeparator, '-', '+', 'e', 'E'];

  {:����� ����� ���������� ������� (������������ � ��������� � �������� � �������)}
  MatrixNameRemoveLabel = '$';

{==============================================================================
 ========================== ��������� �� ������� ==============================}
 
{$Include Matrix32Messages.inc}

implementation

const
{$IFDEF UseLifeGuid}
  LifeMatrixGuid: TGUID = '{1A8FD2F3-4ABA-45AB-BDC4-A74689543E0C}';
  DeadMatrixGuid: TGUID = '{00000000-0000-0000-0000-000000000000}';
{$ENDIF UseLifeGuid}

  {������������ ����� ��������� ��� ������ �� ������}
  StreamMaxDimensions = 1000000;


var
  // �������, ���������� �������� Matrix32 ��� ���������� �������� FloatToString
  FloatToStringFunction: TFloatToStringFunction;

  {����������� ������, ���������� ��� ��������, ��������� � ������� ������ FArrayList}
  ArrayListCriticalSection: TCriticalSection;

  {����������� ������, ���������� ��� ��������, ��������� � ������� ������ FNotifyList}
  NotifyListCriticalSection: TCriticalSection;

  {����������� ������, ���������� ��� ��������, ��������� � ������� ������ FFieldList}
  FieldListCriticalSection: TCriticalSection;

{$IFDEF DXE3PLUS}
  DecimalSeparator: Char = '.';
{$ENDIF DXE3PLUS}

{$IFNDEF UseLifeGuid}
  MatrixInstanceList: TThreadList;
{$ENDIF UseLifeGuid}

{$IFNDEF D2009PLUS}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;
{$ENDIF}

function AvailMemory: Double;
var
  MemInfo: TMemoryStatus;
begin
  MemInfo.dwLength := Sizeof(MemInfo);
  GlobalMemoryStatus(MemInfo);
  Result := Min(MemInfo.dwAvailPhys + Int64(MemInfo.dwAvailPageFile), Int64(MemInfo.dwAvailVirtual));
end;

function GetTotalVirtualMemory: Cardinal;
var
  MemInfo: TMemoryStatus;
begin
  MemInfo.dwLength := Sizeof(MemInfo);
  GlobalMemoryStatus(MemInfo);
  Result := MemInfo.dwTotalVirtual;
end;

function FloatComplex(const Real, Imag: Extended): TExtendedComplex;
begin
  with Result do
  begin
    mReal := Real;
    mImag := Imag;
  end;
end;

function ExtendedComplex(const Real, Imag: Extended): TExtendedComplex;
begin
  with Result do
  begin
    mReal := Real;
    mImag := Imag;
  end;
end;

function SingleComplex(const Real, Imag: Single): TSingleComplex;
begin
  with Result do
  begin
    mReal := Real;
    mImag := Imag;
  end;
end;

function DoubleComplex(const Real, Imag: Double): TDoubleComplex;
begin
  with Result do
  begin
    mReal := Real;
    mImag := Imag;
  end;
end;

function CmplxExtendedToDouble(Value: TExtendedComplex): TDoubleComplex;
begin
  with Result do
  begin
    mReal := Value.mReal;
    mImag := Value.mImag;
  end;
end;

function CmplxExtendedToSingle(Value: TExtendedComplex): TSingleComplex;
begin
  with Result do
  begin
    mReal := Value.mReal;
    mImag := Value.mImag;
  end;
end;

function CmplxDoubleToSingle(Value: TDoubleComplex): TSingleComplex;
begin
  with Result do
  begin
    mReal := Value.mReal;
    mImag := Value.mImag;
  end;
end;

function CmplxSingleToDouble(Value: TSingleComplex): TDoubleComplex;
begin
  with Result do
  begin
    mReal := Value.mReal;
    mImag := Value.mImag;
  end;
end;

function CmplxSingleToExtended(Value: TSingleComplex): TExtendedComplex;
begin
  with Result do
  begin
    mReal := Value.mReal;
    mImag := Value.mImag;
  end;
end;

function GenerateHash(const Str: string): Integer;
var
  I: Integer;
  Flag: Boolean;
begin
  Result := 0;
  if Str = '' then
    Result := -1
  else
  if Str[1] = '$' then
    Result := 0
  else
  begin
    Flag := False;
    for I := 1 to Length(Str) do
    begin
      if Flag then
        Result := Result + not Ord(Str[I])
      else
        Result := Result + Ord(Str[I]);
      Flag := not Flag;
    end;
  end;
end;

function MatrixNameIsValid(const AName: string): Boolean;
var
  I, Len: Integer;
  Chars: PChar;
begin
  Result := False;
  Len := Length(AName);

  if (Len = 0) or (Len > MaxArrayNameLength) or
     (AName[1] = MatrixNameRemoveLabel) then
    Exit;

{$IFDEF CheckMatrixName}
  // ����������� �� ������������� ������� ��� ��������� ��������
  Chars := PChar(AName);

  // ����� �� ����� ���������� � ����� � ����� �������������
  if CharInSet(Chars[0], ['_', '0'..'9']) then
    Exit;
  for I := 0 to Len - 1 do
    if not CharInSet(Chars[I], ValidChars) then
      Exit;

{$ENDIF CheckMatrixName}
  Result := True;
end;

var
  {������ �������� ������������ ����������� ���������� ����}
  GeneratorNameValue: Int64;
  {������ ���� ���������� ���������� ����}
  GeneratorNameCriticalSection: TCriticalSection;

function GenMatrixName(): TMatrixName;
begin
  GeneratorNameCriticalSection.Enter;
  try
    Result := Format('MATRIX_GEN_%d', [GeneratorNameValue]);
    Inc(GeneratorNameValue);
  finally
    GeneratorNameCriticalSection.Leave;
  end;
end;

function IsEqualArraysSize(Matrices: array of TMatrix): Boolean;
var
  I, J: Integer;
begin
  try
    if not IsSameMatrixTypes(Matrices, [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    Result := False;
    if Length(Matrices) >= 2 then
    begin
      for I := 1 to High(Matrices) do
      begin
        if Matrices[I].DimensionCount <> Matrices[0].DimensionCount then
          Exit;

        for J := 0 to Matrices[0].DimensionCount - 1 do
          if Matrices[I].FDimensions[J] <> Matrices[0].FDimensions[J] then
            Exit;
      end;
      Result := True;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function IsEqualArraysSize'){$ENDIF}
  end;
end;

function IsEqualArrays(Matrices: array of TMatrix): Boolean;
var
  I, J: Integer;
  Value: TExtendedComplex;
begin
  try
    Result := IsEqualArraysSize(Matrices);

    if Result then
    begin
      for I := 0 to Matrices[0].ElemCount - 1 do
      begin
        Value := Matrices[0].VecElemCx[I];
        for J := 1 to High(Matrices) do
          if not ComplexIsEqual(Matrices[J].VecElemCx[I], Value) then
          begin
            Result := False;
            Exit;
          end;
      end;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function IsEqualArrays'){$ENDIF}
  end;
end;

function IsSameMatrixClass(Matrices: array of TMatrix): Boolean;
var
  I: Integer;
begin
  Result := False;
  if Length(Matrices) >= 2 then
  begin
    for I := 1 to High(Matrices) do
      if Matrices[I].ClassType <> Matrices[0].ClassType then
        Exit;
    Result := True;
  end; 
end;

function IsSameMatrixTypes(Matrices: array of TMatrix;
  MatrixTypes: TMatrixTypes; IgnoreNil: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 0 to High(Matrices) do
  begin
    if IgnoreNil and (Matrices[I] = nil) then
      Continue;

    Matrices[I].CheckRef('IsSameMatrixTypes', mkFunc);

    if not (Matrices[I].FMatrixTypes * MatrixTypes = MatrixTypes) then
      Exit;
  end;

  Result := True;
end;

procedure CheckForMatrixTypes(Matrices: array of TMatrix;
  MatrixTypes: TMatrixTypes; IgnoreNil: Boolean);
var
  I: Integer;
begin
  try
    for I := 0 to High(Matrices) do
    begin
      if IgnoreNil and (Matrices[I] = nil) then
        Continue;
      Matrices[I].CheckRef;
      if not (Matrices[I].FMatrixTypes * MatrixTypes = MatrixTypes) then
        raise Matrices[I].CreateExceptObject(EMatrixWrongElemType,
          Format(masSIsBadClassForOperation, [Matrices[I].ClassName]));
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(
        E, 'procedure CheckForMatrixTypes'){$ENDIF}
  end;
end;

function FloatToString(Value: Extended): string;
var
  Buffer: array[0..63] of Char;
  I: Integer;
begin
  SetString(Result, Buffer, FloatToText(Buffer, Value, fvExtended, ffGeneral, 15, 0));
  I := Pos(DecimalSeparator, Result);
  if I > 0 then
    Result[I] := MatrixDecimalSeparator;
end;

procedure SetFloatToStringFunction(Value: TFloatToStringFunction);
begin
  try
    if @Value = nil then
      raise EMatrixBadParams.Create(matSBadInputData);

    // ������� ������ ����� ���������� ����� ������������ �����,
    // ������� ������ ������������ ��������
    if (Value(1.00E100) = '') or (Value(-1.00E-100) = '') then
      raise EMatrixError.Create('Check convertion: failed!');

    // ���������� ������ ������ � ������ ��������� ���������� ��������
    FloatToStringFunction := Value;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure SetFloatToStringFunction'){$ENDIF}
  end;
end;

function StringToFloat(S: string): Extended;
var
  I: Byte;
begin
  I := Pos(MatrixDecimalSeparator, S);
  if I > 0 then
    S[I] := DecimalSeparator;
  if not TextToFloat(PChar(S), Result, fvExtended) then
    raise MatrixCreateExceptObj(EConvertError, Format(matSInvalidFloat, [S]),
      'function StringToFloat');
end;

function DeleteRepeatingSpaces(S: string; DeleteAllSpaces: Boolean): string;
var
  I, Counter: Integer;
begin
  S := DeleteRepeatingSymbols(S, [#0..' '], ' ');
  Result := S;

  if DeleteAllSpaces then
  begin
    Counter := 0;
    for I := 1 to Length(S) do
    begin
      if not CharInSet(S[I], [#0..' ']) then
      begin
        Inc(Counter);
        Result[Counter] := S[I];
      end;
    end;
    SetLength(Result, Counter);
  end;     
end;

function DeleteRepeatingSymbols(const S: string; Chars: TSysCharSet;
  ReplaceChar: Char): string;
var
  I, Counter: Integer;
begin
  SetLength(Result, Length(S));
  Counter := 0;

  for I := 1 to Length(S) do
  begin
    if not CharInSet(S[I], Chars) then
    begin
      Inc(Counter);
      Result[Counter] := S[I];
    end else
    if Counter > 0 then
    begin
      if Result[Counter] <> ReplaceChar then
      begin
        Inc(Counter);
        Result[Counter] := ReplaceChar;
      end;
    end;
  end;
  if (Counter > 0) and (Result[Counter] = ReplaceChar) then
    Dec(Counter);

  SetLength(Result, Counter);
end;

function FastStringReplace(const S: string; OldPattern: string;
  const NewPattern: string; Flags: TReplaceFlags = [rfReplaceAll]): string;
var
  I, J, Idx: Integer;
  IsEqual: Boolean;
  UpperFindStr: string;
  pS: PChar; // ��������� �� ������ ��� ��������� ��������
  CanReplace: Boolean;
begin
  if OldPattern = '' then
  begin
    Result := S;
    Exit;
  end;

  Result := '';
  if S = '' then Exit;

  if rfIgnoreCase in Flags then
  begin
    OldPattern := AnsiUpperCase(OldPattern);

    // ��� ������ "�� ��������� �������" ����������� �������������� ������
    UpperFindStr := AnsiUpperCase(S);

    pS := PChar(UpperFindStr);
  end else
    pS := PChar(S);

  // ���� ����� ��������� �� ��������� ������, ��...
  if Length(OldPattern) >= Length(NewPattern) then
  begin
    SetLength(Result, Length(S));
  end else // ������ ������ ������ �� ��������...
    SetLength(Result, (Length(S) + Length(OldPattern) + Length(NewPattern)) * 2);

  I := 1;
  Idx := 0;
  CanReplace := True;
  while I <= Length(S) do
  begin
    IsEqual := False;

    if CanReplace then // ���� ������ ���������
    begin
      // ���� I-� ������ ��������� � OldPattern[1]
      if pS[I - 1] = OldPattern[1] then // ��������� ���� ������
      begin
        IsEqual := True;
        for J := 2 to Length(OldPattern) do
        begin
          if pS[I + J - 2] <> OldPattern[J] then
          begin
            IsEqual := False;
            Break; // ��������� ���������� ����
          end;
        end;

        // ���������� �������! ��������� ������
        if IsEqual then
        begin
          for J := 1 to Length(NewPattern) do
          begin
            Inc(Idx);

            // ��������� ������ Result ��� �������������
            if Idx > Length(Result) then
              SetLength(Result, Length(Result) * 2);

            Result[Idx] := NewPattern[J];
          end;

          // ���������� ����� � �������� ������
          Inc(I, Length(OldPattern));

          if not (rfReplaceAll in Flags) then
            CanReplace := False; // ��������� ���������� ������
        end;
      end;
    end;

    // ���� ��������� �� �������, �� ������ �������� ������
    if not IsEqual then
    begin
      Inc(Idx);

      // ��������� ������ Result ��� �������������
      if Idx > Length(Result) then
        SetLength(Result, Length(Result) * 2);

      Result[Idx] := S[I];
      Inc(I);
    end;
  end; // while I <= Length(S) do

  // ������������ ����� ������-����������
  SetLength(Result, Idx);
end;

function StringToDimValues(S: string): TDynIntArray;
var
  I: Integer;
  TempArray: TDynExtendedComplexArray;
begin
  try
    TempArray := ParseMatrixRow(S);
    SetLength(Result, Length(TempArray));
    for I := 0 to High(TempArray) do
      Result[I] := Trunc(TempArray[I].mReal);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function StringToDimValues'){$ENDIF}
  end;
end;

function DimValuesToString(DimValues: array of Integer;
  ShowMaxDimensions: Integer = 10): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Min(High(DimValues), ShowMaxDimensions - 1) do
    if I = 0 then
      Result := IntToStr(DimValues[I])
    else
      Result := Format('%s x %d', [Result, DimValues[I]]);
  if Length(DimValues) > ShowMaxDimensions then
    Result := Result + ' ...';
end;

function ParseMatrixRow(ARow: string): TDynExtendedComplexArray;
var
  I: Integer;
begin
  try
    Result := nil;

    if ARow = '' then
      Exit;

    ARow := DeleteRepeatingSpaces(ARow);
    ARow := DeleteRepeatingSymbols(ARow,
      [MatrixNumberDelimiter {$IFDEF UseSpaceDelimiter}, ' ' {$ENDIF}],
      MatrixNumberDelimiter);

    for I := 1 to Length(ARow) do
    begin
      if not (CharInSet(ARow[I], NumberChars) or
        CharInSet(ARow[I], [MatrixNumberDelimiter, ComplexImagSymbol])) then
        raise EMatrixParsingError.CreateFmt(matSInvalidNumericSymbol, [ARow[I]]);
    end;

    with TStringList.Create do
    try
      Text := FastStringReplace(ARow, MatrixNumberDelimiter, sLineBreak, [rfReplaceAll]);
      SetLength(Result, Count);
      for I := 0 to Count - 1 do
        Result[I] := ComplexFromString(Strings[I]);
    finally
      Free;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function ParseMatrixRow'){$ENDIF}
  end;
end;

function FindMatrixInStream(AStream: TStream; const AName: TMatrixName;
  var Alias: TSignature; var BeginAddress, NextAddress: Int64;
  var ReadedName: TMatrixName): Boolean;
var
  StartPosition: Int64;
begin
  Result := True;

  StartPosition := AStream.Position; // ���������� ��������� ���������

  while AStream.Position < AStream.Size do
  begin
    BeginAddress := AStream.Position;
    ReadedName := ReadMatrixNameFromStream(AStream);
    AStream.Read(NextAddress, SizeOf(NextAddress));
    if AStream.Size < NextAddress then
      raise MatrixCreateExceptObj(EMatrixStreamError,
        matSMatrixRangeOutOfStream, 'function FindMatrixInStream');

    Alias := AnsiString(ReadMatrixNameFromStream(AStream));

    if (ReadedName = '') or (ReadedName[1] <> MatrixNameRemoveLabel) then
    begin     
      if (AName = '') or (AName = ReadedName) then
      begin     
        AStream.Position := BeginAddress;
        Exit;
      end;
    end;

    // ��������� � ������ ���������� �������
    AStream.Position := NextAddress;
  end;

  Result := False;

  AStream.Position := StartPosition; // ��������������� ��������� ���������
end;

function FindMatrixInFileStream(AStream: TFileStream;
  const AName: TMatrixName; var Alias: TSignature;
  var BeginAddress, NextAddress: Int64; var ReadedName: TMatrixName): Boolean;
var
  S: AnsiString;
begin
  try
    // ��������� ������������ ����
    if AStream.Position = 0 then
    begin
      SetLength(S, Length(matSBinaryHeader));
      AStream.Read(S[1], Length(S));
      if string(S) <> matSBinaryHeader then
        raise MatrixCreateExceptObj(EMatrixFileStreamError,
          matSBadBINFile, 'function FindMatrixInFileStream');
    end;

    Result := FindMatrixInStream(AStream, AName, Alias, BeginAddress,
      NextAddress, ReadedName);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function FindMatrixInFileStream'){$ENDIF}
  end;
end;

function MatrixExistsInFile(const AFileName: string; const AName: TMatrixName;
  const Alias: TSignature = ''): Boolean;
var
  Fs: TFileStream;
  BeginAddress, NextAddress: Int64;
  TempAlias: TSignature;
  ReadedName: TMatrixName;
begin
  try
    Result := False;

    if AName = '' then Exit;

    Fs := WaitAndCreateFileStream(AFileName, fmOpenRead or fmShareDenyWrite, MatrixWaitFileOpen);
    try
      if FindMatrixInFileStream(Fs, AName, TempAlias, BeginAddress,
        NextAddress, ReadedName) then
      begin
        if Alias = '' then
          Result := True
        else
          Result := AnsiSameText(string(Alias), string(TempAlias));
      end;

    finally
      Fs.Free;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function MatrixExistsInFile'){$ENDIF}
  end;
end;

function GenerateFileMutexName(AFileName: string): string;
var
  I: Integer;
begin
  // ���� ���� � ����� �� �����, �� ����������� ���
  if ExtractFilePath(AFileName) = '' then
    AFileName := IncludeTrailingPathDelimiter(GetCurrentDir) + AFileName;

  Result := AnsiLowerCase(AFileName);
  for I := 1 to Length(Result) do
    if CharInSet(Result[I], ['\', '/', ':', '*', '"', '?', '|', '<', '>']) then
      Result[I] := '_';
  Result := 'MatrixFileProtect_' + Result;
end;

function WaitAndCreateFileStream(const AFileName: string; AMode: Word; WaitTime: Integer): TFileStream;
const
  SleepTime = 20;
var
  EndTime: TDateTime;
  AMutex: THandle;
  ALastError: Integer;
begin
  try
    ALastError := 0;
    
    if WaitTime < 0 then
      WaitTime := MatrixWaitFileOpen;

    if WaitTime = 0 then
      Result := TFileStream.Create(AFileName, AMode)
    else
    begin
      Result := nil;
      AMutex := CreateMutex(nil, False, PChar(GenerateFileMutexName(AFileName)));
      if AMutex = 0 then
        RaiseLastOSError;   
      try
        // �������� ��� �������� �����
        EndTime := IncMilliSecond(Now, WaitTime);

        try
          if WaitForSingleObject(AMutex, WaitTime) = WAIT_OBJECT_0 then
          try
            while True do
            try
              Result := TFileStream.Create(AFileName, AMode);
              Exit;
            except
              on E: Exception do
              begin
                ALastError := GetLastError; // �� ���� ����� ������ �������� ����� ��������!
                if (Now >= EndTime) or (ALastError = 3) then raise;
                Sleep(SleepTime); // �������� ����� ��������� �������� �������� �����
              end;
            end;
          finally
            ReleaseMutex(AMutex);
          end
          else
          try
            Result := TFileStream.Create(AFileName, AMode); // ������ ������� ������
          except
            on E: Exception do
              raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'Mutex wait timeout'){$ENDIF};
          end;
        except
          on E: Exception do
            if ALastError = 3 then // ����������� ������ ��� �����
              raise
            else
              raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(
                E, Format('File open timeout: %d ms', [WaitTime])){$ENDIF};
        end;

      finally
        CloseHandle(AMutex);
      end;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function WaitAndCreateFileStream'){$ENDIF}
  end;
end;

var
  DefragValue: Int64;
  DefragCriticalSection: TCriticalSection;

procedure DefragBinaryFile(const AFileName: string; AWaitTime: Integer = -1);
var
  Fs, TempFs: TFileStream;
  BeginAddress, NextAddress, Int64Buf: Int64;
  Alias, LoaderAlias: TSignature;
  ReadedName: TMatrixName;
  MatrixClass, SaverClass: TMatrixClass;
  TempFileName: string;
  Idx: Integer;
  Ms: TMemoryStream;
begin
  try
    {������ �� ������, ���� � ���� � ��� �� ������ ������� 2 ������ �����
     ��������� �������������� ������ � ���� �� �����}
    DefragCriticalSection.Enter;
    try
      Inc(DefragValue);
      // ���������� ���������� ��� ����� ��� ������.
      TempFileName := Format('%s ~%d_%d_%d', [AFileName, GetCurrentThreadId, GetTickCount, DefragValue]);
    finally
      DefragCriticalSection.Leave;
    end; 

    Fs := WaitAndCreateFileStream(AFileName, fmOpenReadWrite or fmShareDenyWrite, AWaitTime);
    try
      while FindMatrixInFileStream(Fs, '', Alias, BeginAddress, NextAddress, ReadedName) do
      begin
        if SameText('Workspace', string(Alias)) then
          MatrixClass := TWorkspace
        else
        begin
          Idx := MatrixClassList.IndexOf(string(Alias));
          if Idx < 0 then
            raise EMatrixClassError.CreateFmt(matSClassNotFound, [Alias]);

          MatrixClass := TMatrixClass(MatrixClassList.Objects[Idx]);
        end;

        ReadMatrixNameFromStream(Fs);
        Fs.Seek(SizeOf(Int64), soFromCurrent);
        ReadMatrixNameFromStream(Fs);
        LoaderAlias := AnsiString(ReadMatrixNameFromStream(Fs));
        Idx := MatrixClassList.IndexOf(string(LoaderAlias));
        if Idx >= 0 then
          SaverClass := TMatrixClass(MatrixClassList.Objects[Idx])
        else
          SaverClass := nil;

        Fs.Position := BeginAddress;

        with MatrixClass.Create() do
        try
          Ms := TMemoryStream.Create;
          try
            // ���������� ����� � ������ ��� ��������� �������� ��������
            Ms.CopyFrom(Fs, NextAddress - BeginAddress);
            Ms.Position := 0;
            // ������������ ����� ��������� ������
            ReadMatrixNameFromStream(Ms);
            Int64Buf := Ms.Size;
            Ms.Write(Int64Buf, SizeOf(Int64Buf));
            Ms.Position := 0;
            LoadFromStreamEx(Ms);
          finally
            Ms.Free;
          end;
          // ��������� ��������� ������ �� ��������� �����
          SaveToBinaryFile(TempFileName, ReadedName, SaverClass);
        finally
          Free;
        end;
      end;

      try
        TempFs := WaitAndCreateFileStream(TempFileName, fmOpenRead or fmShareDenyWrite, AWaitTime);
        try
          Fs.Size := TempFs.Size;
          Fs.Seek(0, soFromBeginning);
          Fs.CopyFrom(TempFs, TempFs.Size);
        finally
          TempFs.Free;
        end;
      except
        on E: Exception do
        begin
          if E is EOSError then
          begin
            // ��� ���������� ������� ����� ����� ��������� ����������, ���� ��� �����
            // ����� ������ ������� ������ FileMapping. � ���� ������ ��������� �����
            // �� ������� ��� ��������� ����������.
            if not DeleteFile(TempFileName) then // ������ ��������� �� ������!!!
              raise EMatrixFileStreamError.CreateFmt(matSCanNotRenameFile, [TempFileName, AFileName]);
            Exit;
          end else
            raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'TFileStream.Size'){$ENDIF}
        end;
      end;

      // ������ ��������� �� ������!!!
      if not DeleteFile(TempFileName) then
        raise EMatrixFileStreamError.CreateFmt(matSCanNotRenameFile, [TempFileName, AFileName]);
    finally
      Fs.Free;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure DefragBinaryFile'){$ENDIF}
  end;
end;

function opSum(const Value1, Value2: Extended): Extended;
begin
  Result := Value1 + Value2;
end;

function opSumI(const Value1, Value2: Integer): Integer;
begin
  Result := Value1 + Value2;
end;

function opSumI64(const Value1, Value2: Int64): Int64;
begin
  Result := Value1 + Value2;
end;

function opSub(const Value1, Value2: Extended): Extended;
begin
  Result := Value1 - Value2;
end;

function opSubI(const Value1, Value2: Integer): Integer;
begin
  Result := Value1 - Value2;
end;

function opSubI64(const Value1, Value2: Int64): Int64;
begin
  Result := Value1 - Value2;
end;

function opMul(const Value1, Value2: Extended): Extended;
begin
  Result := Value1 * Value2;
end;

function opMulI(const Value1, Value2: Integer): Integer;
begin
  Result := Value1 * Value2;
end;

function opMulI64(const Value1, Value2: Int64): Int64;
begin
  Result := Value1 * Value2;
end;

function opDiv(const Value1, Value2: Extended): Extended;
begin
  Result := Value1 / Value2;
end;

function opDivI(const Value1, Value2: Integer): Integer;
begin
  Result := Value1 div Value2;
end;

function opDivI64(const Value1, Value2: Int64): Int64;
begin
  Result := Value1 div Value2;
end;

function opTruncDiv(const Value1, Value2: Extended): Extended;
begin
  Result := Trunc(Value1 / Value2);
end;

function opPower(const Value1, Value2: Extended): Extended;
begin
  Result := Power(Value1, Value2);
end;

function opEQ(const Value1, Value2: Extended): Extended;
begin
  Result := Integer(Math.SameValue(Value1, Value2, SameValueEpsilon));
end;

function opNE(const Value1, Value2: Extended): Extended;
begin
  Result := Integer(not Math.SameValue(Value1, Value2, SameValueEpsilon));
end;

function opLT(const Value1, Value2: Extended): Extended;
begin
  Result := Integer(Value1 < Value2);
end;

function opGT(const Value1, Value2: Extended): Extended;
begin
  Result := Integer(Value1 > Value2);
end;

function opLE(const Value1, Value2: Extended): Extended;
begin
  Result := Integer(Value1 <= Value2);
end;

function opGE(const Value1, Value2: Extended): Extended;
begin
  Result := Integer(Value1 >= Value2);
end;

function opAnd(const Value1, Value2: Extended): Extended;
begin
  Result := Integer(not IsZero(Value1) and not IsZero(Value2));
end;

function opOr(const Value1, Value2: Extended): Extended;
begin
  Result := Integer(not IsZero(Value1) or not IsZero(Value2));
end;

function opXor(const Value1, Value2: Extended): Extended;
begin
  Result := Integer(not IsZero(Value1) xor not IsZero(Value2));
end;

function opBitShiftI(const Value1, Value2: Integer): Integer;
begin
  if Value2 > 0 then
    Result := Value1 shl Value2
  else
    Result := Value1 shr (0 - Value2)
end;

function opBitAndI(const Value1, Value2: Integer): Integer;
begin
  Result := Value1 and Value2;
end;

function opBitOrI(const Value1, Value2: Integer): Integer;
begin
  Result := Value1 or Value2;
end;

function opBitXorI(const Value1, Value2: Integer): Integer;
begin
  Result := Value1 xor Value2;
end;

function opCmplxMul(const Value1, Value2: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(
    Value1.mReal * Value2.mReal - Value1.mImag * Value2.mImag,
    Value1.mReal * Value2.mImag + Value1.mImag * Value2.mReal);
end;

function opCmplxDiv(const Value1, Value2: TExtendedComplex): TExtendedComplex;
var
  LDenominator: Extended;
begin
  LDenominator := (Value2.mReal * Value2.mReal) + (Value2.mImag * Value2.mImag);
  if Math.IsZero(LDenominator) then
    raise MatrixCreateExceptObj(EZeroDivide, SDivByZero, 'function opCmplxDiv');

  Result := FloatComplex(
    ((Value1.mReal * Value2.mReal) + (Value1.mImag * Value2.mImag)) / LDenominator,
    ((Value1.mImag * Value2.mReal) - (Value1.mReal * Value2.mImag)) / LDenominator);
end;

function opCmplxInvDiv(const Value1, Value2: TExtendedComplex): TExtendedComplex;
var
  LDenominator: Extended;
begin
  LDenominator := ComplexGetAbsSqr(Value1);
  if Math.IsZero(LDenominator) then
    raise MatrixCreateExceptObj(EZeroDivide, SDivByZero, 'function opCmplxInvDiv');
  Result := FloatComplex(
    ((Value2.mReal * Value1.mReal) + (Value2.mImag * Value1.mImag)) / LDenominator,
    ((Value2.mImag * Value1.mReal) - (Value2.mReal * Value1.mImag)) / LDenominator);
end;

function opCmplxDivBoth(const Value1, Value2: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(Value1.mReal / Value2.mReal, Value1.mImag / Value2.mReal)
end;

function opCmplxPower(const Value1, Value2: TExtendedComplex): TExtendedComplex;
begin
  if Math.IsZero(ComplexGetAbsSqr(Value1)) then
  begin
    if Math.IsZero(ComplexGetAbsSqr(Value2)) then
      Result := FloatComplex(1, 0)
    else
      Result := FloatComplex(0, 0)
  end else
    Result := fncCmplxExp(opCmplxMul(fncCmplxLn(Value1), Value2));
end;

function opCmplxCopyRealParts(const Value1, Value2: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(Value1.mReal, Value2.mReal);
end;

function opCmplxSum(const Value1, Value2: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(Value1.mReal + Value2.mReal, Value1.mImag + Value2.mImag);
end;

function opCmplxSub(const Value1, Value2: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(Value1.mReal - Value2.mReal, Value1.mImag - Value2.mImag);
end;

function fncCmplxReal(const Value: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(Value.mReal, 0);
end;

function fncCmplxImagToReal(const Value: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(Value.mImag, 0);
end;

function fncCmplxImag(const Value: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(0, Value.mImag);
end;

function fncCmplxNeg(const Value: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex( - Value.mReal, - Value.mImag);
end;

function fncCmplxConj(const Value: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(Value.mReal, - Value.mImag);
end;

function fncCmplxInverse(const Value: TExtendedComplex): TExtendedComplex;
var
  LDenominator: Extended;
begin
  LDenominator := ComplexGetAbsSqr(Value);

  if Math.IsZero(LDenominator) then
    raise MatrixCreateExceptObj(EZeroDivide, SDivByZero, 'function fncCmplxInverse');
  Result := FloatComplex(Value.mReal / LDenominator, - (Value.mImag / LDenominator));
end;

function fncCmplxExp(const Value: TExtendedComplex): TExtendedComplex;
var
  LExp: Extended;
begin
  LExp := System.Exp(Value.mReal);
  Result := FloatComplex(LExp * Cos(Value.mImag), LExp * Sin(Value.mImag));
end;

procedure ComplexGetAsPolar(const Value: TExtendedComplex;
  var ARadius, ATheta: Extended; AFixTheta: Boolean = True);
begin
  ATheta := ArcTan2(Value.mImag, Value.mReal);
  ARadius := ComplexGetAbs(Value);
  if AFixTheta then
  begin
    while ATheta > Pi do
      ATheta := ATheta - 2.0 * Pi;
    while ATheta <= -Pi do
      ATheta := ATheta + 2.0 * Pi;
  end;
end;

function ComplexIsZero(const Value: TExtendedComplex): Boolean;
begin
  Result := Math.IsZero(Value.mReal) and Math.IsZero(Value.mImag);
end;

function ComplexIsEqual(const Value1, Value2: TExtendedComplex): Boolean;
begin
  Result :=
    Math.SameValue(Value1.mReal, Value2.mReal, SameValueEpsilon) and
    Math.SameValue(Value1.mImag, Value2.mImag, SameValueEpsilon);
end;

function ComplexGetAbsSqr(const Value: TExtendedComplex): Extended;
begin
  Result := Value.mReal * Value.mReal + Value.mImag * Value.mImag;
end;

function ComplexGetAbs(const Value: TExtendedComplex): Extended;
begin
  Result := Sqrt(ComplexGetAbsSqr(Value));
end;

function ComplexNaN: TExtendedComplex;
begin
  Result.mReal := NaN;
  Result.mImag := NaN;
end;

function ComplexFromString(Value: string): TExtendedComplex;
const
  SFuncName = 'function ComplexFromString';
var
  Part: string;
  I: Integer;
begin
  Result := FloatComplex(0, 0);

  if Pos(' ', Value) > 0 then
  begin
    Value := DeleteRepeatingSpaces(Value, False);

    for I := 1 to Length(Value) do
    begin
      // ���� ��� ����� ���������� ���� �� ����� ��������, �� ���������� ����������
      if (I > 1) and (I < Length(Value)) and (Value[I] = ' ')
        and CharInSet(Value[I - 1], ['0'..'9', 'e', 'E'])
        and CharInSet(Value[I + 1], ['0'..'9', 'e', 'E']) then
        raise MatrixCreateExceptObj(EMatrixParsingError,
          Format(matSInvalidComplex, [Value]), SFuncName);
    end;
    Value := DeleteRepeatingSpaces(Value, True);
  end;

  if Pos(ComplexImagSymbol, Value) = 0 then
    Result.mReal := StringToFloat(Value)
  else
  begin
    // �������� ��� �������, ������ ����� ComplexImagSymbol
    SetLength(Value, Pos(ComplexImagSymbol, Value) - 1);

    // ���� ������ �����
    for I := Length(Value) downto 1 do
    begin
      if CharInSet(Value[I], NumberChars) then
        Part := Value[I] + Part;

      if (I > 1) and CharInSet(Value[I], ['+', '-']) and
         CharInSet(Value[I - 1], ['e', 'E']) then
        Continue;

      if CharInSet(Value[I], ['+', '-']) then
        Break;
    end;
    Result.mImag := StringToFloat(Part);

    // ���������� ����� ������� ��������������
    SetLength(Value, Length(Value) - Length(Part));
    if Value = '' then
      Result.mReal := 0
    else
      Result.mReal := StringToFloat(Value);
  end;

end;

function fncCmplxLn(const Value: TExtendedComplex): TExtendedComplex;
var
  LRadius, LTheta: Extended;
begin
  if ComplexIsZero(Value) then
    Result := FloatComplex(-Infinity, 0)
  else
  begin
    ComplexGetAsPolar(Value, LRadius, LTheta);
    Result := FloatComplex(Ln(LRadius), LTheta);
  end;
end;

function fncCmplxLog10(const Value: TExtendedComplex): TExtendedComplex;
var
  LRadius, LTheta: Extended;
begin
  if ComplexIsZero(Value) then
    Result := FloatComplex(-Infinity, 0)
  else
  begin
    ComplexGetAsPolar(Value, LRadius, LTheta);
    Result := opCmplxDiv(FloatComplex(Ln(LRadius), LTheta), FloatComplex(Ln(10), 0));
  end;
end;

function fncCmplxLog2(const Value: TExtendedComplex): TExtendedComplex;
var
  LRadius, LTheta: Extended;
begin
  if ComplexIsZero(Value) then
    Result := FloatComplex(-Infinity, 0)
  else
  begin
    ComplexGetAsPolar(Value, LRadius, LTheta);
    Result := opCmplxDiv(FloatComplex(Ln(LRadius), LTheta), FloatComplex(Ln(2), 0));
  end;
end;

function fncCmplxSqr(const Value: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(
    (Value.mReal * Value.mReal) - (Value.mImag * Value.mImag),
    (Value.mReal * Value.mImag) + (Value.mImag * Value.mReal));
end;

function fncCmplxSqrt(const Value: TExtendedComplex): TExtendedComplex;
var
  LValue, AbsValue: Extended;
begin
  if not ComplexIsZero(Value) then
  begin
    AbsValue := ComplexGetAbs(Value);
    if Value.mReal > 0 then
    begin
      LValue := AbsValue + Value.mReal;
      Result := FloatComplex(Sqrt(LValue / 2), Value.mImag / Sqrt(LValue * 2));
    end else
    begin
      LValue := AbsValue - Value.mReal;
      if Value.mImag < 0 then
        Result := FloatComplex(
          Abs(Value.mImag) / Sqrt(LValue * 2), -Sqrt(LValue / 2))
      else
        Result := FloatComplex(
          Abs(Value.mImag) / Sqrt(LValue * 2), Sqrt(LValue / 2));
    end;
  end;
end;

function fncCmplxCos(const Value: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(
     Cos(Value.mReal) * CosH(Value.mImag),
    -Sin(Value.mReal) * SinH(Value.mImag));
end;

function fncCmplxSin(const Value: TExtendedComplex): TExtendedComplex;
begin
  Result := FloatComplex(
    Sin(Value.mReal) * CosH(Value.mImag),
    Cos(Value.mReal) * SinH(Value.mImag));
end;

function fncCmplxTan(const Value: TExtendedComplex): TExtendedComplex;
var
  LDenominator: Extended;
begin
  if ComplexIsEqual(Value, FloatComplex(PI / 2, 0)) then
    Result := ComplexNaN
  else begin
    LDenominator := Cos(2.0 * Value.mReal) + CosH(2.0 * Value.mImag);
    if Math.IsZero(LDenominator) then
      raise MatrixCreateExceptObj(EZeroDivide, SDivByZero, 'function fncCmplxTan');
    Result := FloatComplex(
      Sin(2.0 * Value.mReal) / LDenominator,
      SinH(2.0 * Value.mImag) / LDenominator);
  end;
end;

function fncCmplxCot(const Value: TExtendedComplex): TExtendedComplex;
begin
  if ComplexIsZero(Value) then
    Result := ComplexNaN
  else
    Result := opCmplxDiv(fncCmplxCos(Value), fncCmplxSin(Value));
end;

function fncCmplxCsc(const Value: TExtendedComplex): TExtendedComplex;
begin
  if ComplexIsZero(Value) then
    Result := ComplexNaN
  else
    Result := opCmplxInvDiv(fncCmplxSin(Value), FloatComplex(1, 0));
end;

function fncCmplxSec(const Value: TExtendedComplex): TExtendedComplex;
begin
  if ComplexIsEqual(Value, FloatComplex(PI / 2, 0)) then
    Result := ComplexNaN
  else
    Result := opCmplxInvDiv(fncCmplxCos(Value), FloatComplex(1, 0)); 
end;

function fncNot(const Value: Extended): Extended;
begin
  Result := Integer(not (Value <> 0));
end;

function fncNone(const Value: Extended): Extended;
begin
  Result := Value;
end;

function fncSin(const Value: Extended): Extended;
begin
  Result := Sin(Value);
end;

function fncCos(const Value: Extended): Extended;
begin
  Result := Cos(Value);
end;

function fncRound(const Value: Extended): Extended;
begin
  Result := Round(Value);
end;

function fncTrunc(const Value: Extended): Extended;
begin
  Result := Trunc(Value);
end;

function fncInt(const Value: Extended): Extended;
begin
  Result := Int(Value);
end;

function fncFrac(const Value: Extended): Extended;
begin
  Result := Frac(Value);
end;

function fncSqrt(const Value: Extended): Extended;
begin
  Result := Sqrt(Value);
end;

function fncSqr(const Value: Extended): Extended;
begin
  Result := Sqr(Value);
end;

function fncAbs(const Value: Extended): Extended;
begin
  Result := Abs(Value);
end;

function fncNeg(const Value: Extended): Extended;
begin
  Result := -Value;
end;

function fncExp(const Value: Extended): Extended;
begin
  Result := System.Exp(Value);
end;

function fncSign(const Value: Extended): Extended;
begin
  Result := Integer(Value >= 0); 
end;

procedure RegisterMatrixClass(AClass: TClass);
var
  I: Integer;
begin
  // ���� ������� � ����� �������� ��� ����������������, ��
  // ������� �� �� ������
  I := MatrixClassList.IndexOf(string(TMatrixClass(AClass).GetAlias));
  if I >= 0 then
    MatrixClassList.Delete(I);

  MatrixClassList.AddObject(string(TMatrixClass(AClass).GetAlias), TObject(AClass));
end;

procedure MatrixFreeAndNil(var AMatrix: TMatrix);
var
  ATemp: TMatrix;
begin
  try
    ATemp := AMatrix;
    AMatrix := nil;
    ATemp.FreeMatrix;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure MatrixFreeAndNil'){$ENDIF}
  end;
end;

procedure WriteMatrixNameToStream(const Str: TMatrixName; AStream: TStream);
var
  ByteBuf: Byte;
  sAnsi: AnsiString;
begin
  ByteBuf := Length(Str);
  AStream.Write(ByteBuf, SizeOf(ByteBuf));
  if ByteBuf > 0 then
  begin
    sAnsi := AnsiString(Str);
    AStream.Write(sAnsi[1], ByteBuf);
  end;
end;

function ReadMatrixNameFromStream(AStream: TStream): TMatrixName;
var
  ByteBuf: Byte;
  sAnsi: AnsiString;
begin
  AStream.Read(ByteBuf, SizeOf(ByteBuf));
  SetLength(sAnsi, ByteBuf);

  if ByteBuf > 0 then
    AStream.Read(sAnsi[1], ByteBuf);

  Result := string(sAnsi);
end;

function ConvertToDynIntArray(const IntArray: array of Integer): TDynIntArray;
var
  I: Integer;
begin
  SetLength(Result, Length(IntArray));
  for I := 0 to High(IntArray) do
    Result[I] := IntArray[I];
end;

procedure RaiseMatrixError(AClass: ExceptClass; const AText: string;
  FuncName: string = ''; AMatrix: TMatrix = nil);
begin
  raise MatrixCreateExceptObj(AClass, AText, FuncName, AMatrix);
end;

procedure ReRaiseMatrixError(ExceptObject: Exception;
  const FuncName: string; AMatrix: TMatrix = nil);
begin
  raise MatrixReCreateExceptObj(ExceptObject, FuncName, AMatrix);
end;

function MatrixReCreateExceptObj(ExceptObject: Exception;
  const FuncName: string; AMatrix: TMatrix = nil): Exception;
begin
  Result := ExceptClass(ExceptObject.ClassType).Create(ExceptObject.Message);
  if Result is EMatrixError then
  begin
    EMatrixError(Result).MatrixInfo := EMatrixError(ExceptObject).MatrixInfo;
    EMatrixError(Result).ExceptStack := EMatrixError(ExceptObject).ExceptStack;
  end;
  MatrixCorrectExceptMsg(Result, FuncName, AMatrix);
end;

function MatrixCreateExceptObj(AClass: ExceptClass; const AText: string;
  FuncName: string; AMatrix: TMatrix): Exception;
begin
  Result := AClass.Create(AText);
  MatrixCorrectExceptMsg(Result, FuncName, AMatrix);
end;

var
  ClearMatrixErrorInfo: TMatrixErrorInfo;

procedure MatrixCorrectExceptMsg(ExceptObject: Exception;
  const FuncName: string; AMatrix: TMatrix);
const
  DoubleCR = sLineBreak + sLineBreak;
var
{$IFDEF AddDebugInfoToExceptObject}
  CatchStackSection: Integer; 
{$ENDIF}
  AMatrixInfo: TMatrixErrorInfo;
begin
  // ��������� ��������� ���������� �� ������� TMatrix �
  // ���������� ��� ����� ����
  if AMatrix.IsLiving and (ExceptObject is EMatrixError) then
  with EMatrixError(ExceptObject) do
  begin
    {���� ���������� ��� �� ���������, �� ��������� �� � ������ MatrixInfo}
    if MatrixInfo.MatrixClassName = '' then
    begin
      AMatrixInfo := ClearMatrixErrorInfo;

      AMatrixInfo.MatrixName := AMatrix.MatrixName;
      AMatrixInfo.MatrixClassName := AMatrix.ClassName;
      AMatrixInfo.MatrixClassType := TMatrixClass(AMatrix.ClassType);
      if AMatrix.IsDynamic then
      begin
        AMatrixInfo.MatrixUsedMemory := AMatrix.MatrixSize;
        AMatrixInfo.MatrixDimensions := AMatrix.GetDimensions;
        AMatrixInfo.MatrixElementsCount := AMatrix.ElemCount;
        AMatrixInfo.MatrixElementSize := AMatrix.FElemSize;
      end;
      AMatrixInfo.MatrixCopiedByRef := AMatrix.IsCopyByRef;

      if AMatrix.IsRecord then
        AMatrixInfo.MatrixFieldsCount := AMatrix.FieldCount;
      AMatrixInfo.MatrixChildrenCount := AMatrix.MatrixCount;
      AMatrixInfo.MatrixErrorFuncName := FuncName;

      MatrixInfo := AMatrixInfo;
    end;

    // ������������ ������ ����� �������
    if FExceptStack = '' then
      FExceptStack := FuncName
    else
    begin
      with TStringList.Create do
      begin
        Text := FExceptStack;
        if Strings[Count - 1] <> FuncName then
        begin
          Add(FuncName);
          FExceptStack := Text;
        end;
        Free;
      end;
    end; // if
  end; // with
  
{$IFDEF AddDebugInfoToExceptObject}
  with TStringList.Create do
  try
    Text := ExceptObject.Message;

    if IndexOf(matSOriginalErrorMsg) < 0 then
     Text := matSOriginalErrorMsg + DoubleCR + Format('<%s>', [Trim(Text)]) +
       DoubleCR + matSExceptionClass + ExceptObject.ClassName +
       Format(' = class(%s);', [ExceptObject.ClassParent.ClassName]) + DoubleCR;

    {���������, ����� �� ������. ����������� ������ � ������ �������
     (���� ������ �� ����������) ������, �.�. �� �������� ������� ������ ����������}
    if AMatrix.IsLiving and (IndexOf(matSMatrixObjectInformation) < 0) then
    begin
      CatchStackSection := IndexOf(matSCatchStack);
      if CatchStackSection < 0 then
        CatchStackSection := Count - 1;
        
      Insert(CatchStackSection, Format(matSMatrixChildrenCount, [AMatrix.MatrixCount]));

      if AMatrix.IsRecord then
        Insert(CatchStackSection, Format(matSMatrixFieldsCount, [AMatrix.FieldCount]));

      if AMatrix.IsDynamic then
      begin
        Insert(CatchStackSection, Format(matSMatrixDimensions,
          [AMatrix.DimensionCount, DimValuesToString(AMatrix.GetDimensions)]));
        Insert(CatchStackSection, Format(matSMatrixElemCount, [AMatrix.ElemCount]));
        Insert(CatchStackSection, Format(matSMatrixElemSize, [AMatrix.FElemSize]));
        Insert(CatchStackSection, Format(matSMatrixUsedMemory, [AMatrix.MatrixSize]));
      end;
      Insert(CatchStackSection, Format(matSMatrixClassName,
        [AMatrix.ClassName, AMatrix.ClassParent.ClassName]));
      Insert(CatchStackSection, matSMatrixName + AMatrix.MatrixName);
      Insert(CatchStackSection, matSMatrixObjectInformation);
      Insert(CatchStackSection, '');
    end;

    if FuncName <> '' then
    begin
      if IndexOf(matSCatchStack) < 0 then
      begin
        if Strings[Count - 1] <> '' then
          Add('');
        Add(matSCatchStack);
      end;

      if Strings[Count - 1] <> FuncName then
        Add(FuncName);
    end;

    ExceptObject.Message := Text;
  finally
    Free;
  end;
{$ENDIF}
end;

{�������� ��������� � ��������� ���� �� BCD-������ S.
 � �������, ������ "000001.100000" ����������� � "1.1"}
procedure _BCDTrim0(var S: string);
var
  I: Integer;
begin 
  for I := 1 to Length(S) do
    if S[I] <> '0' then
      Break
    else
    begin
      if (I < Length(S)) and CharInSet(S[I + 1], [MatrixDecimalSeparator, DecimalSeparator]) then
        Break;
      S[I] := ' ';
    end;

  if (Pos(DecimalSeparator, S) > 0) or (Pos(MatrixDecimalSeparator, S) > 0) then
    for I := Length(S) downto 1 do
      if S[I] <> '0' then
        Break
      else
        S[I] := ' ';

  if (S <> '') and CharInSet(S[Length(S)], [MatrixDecimalSeparator, DecimalSeparator]) then
    S[Length(S)] := ' ';

    S := Trim(S);
    if S = '' then
      S := '0';
end;

function StringToBCD(const SValue: string): TBCDNumber;
var
  I, APos: Integer;
  S: string;
  PointCount, PointPos, MinusCount: Integer;    

  procedure RaiseBCDErrorString;
  begin
    raise EMatrixBCDError.CreateFmt(matSBCDErrorString, [SValue]);
  end;

  procedure CheckEmptyStr;
  begin
    if S = '' then RaiseBCDErrorString;
  end;

  procedure StrToBCDBuffer;
  var
    I, LenDiv2: Integer;
    Byte1, Byte2: Byte;
  begin
    LenDiv2 := Length(S) div 2;
    for I := LenDiv2 downto 1 do
    begin
      Byte1 := Byte(S[I * 2    ]) - Byte('0');
      Byte2 := Byte(S[I * 2 - 1]) - Byte('0');     
      Result.BCDData[LenDiv2 - I] := Byte1 or (Byte2 shl 4);
    end;
  end;

begin
  try
    S := Trim(SValue);

    MinusCount := 0;
    APos := 0;

    for I := 1 to Length(S) do
      if CharInSet(S[I], ['+', '-', ' ']) then
      begin
        if S[I] = '-' then
          Inc(MinusCount);
        APos := I;
      end else
        Break;

    if APos >= Length(S) then
      RaiseBCDErrorString;

    S := Copy(S, APos + 1, Length(S) - APos);

    if (S = '') or (S = DecimalSeparator) or (S = MatrixDecimalSeparator) then
      RaiseBCDErrorString;

    _BCDTrim0(S);  

    PointCount := 0;
    PointPos := 0;

    // ���� ������ ������ - �����������, �� ���������� ����� ����� "0"
    if CharInSet(S[1], [DecimalSeparator, MatrixDecimalSeparator]) then
      S := '0' + S;

    // �������� DecimalSeparator �� ".". ������ �������� ������
    for I := 1 to Length(S) do
    begin
      if S[I] = DecimalSeparator then
        S[I] := MatrixDecimalSeparator;

      if not CharInSet(S[I], ['0'..'9', MatrixDecimalSeparator]) then
        RaiseBCDErrorString;

      if S[I] = MatrixDecimalSeparator then
      begin
        Inc(PointCount);
        PointPos := I;
      end;
        
    end;

    if PointCount > 1 then
      RaiseBCDErrorString;

    // ������� ����������� ��� ��������.
    if PointPos > 0 then
    begin
      APos := PointPos;
      // ������������� ������� ����������� ������������ ������� ��������
      PointPos := Length(S) - PointPos + 1;

      // ���� ������� ����������� ������, �� ����������� � ����� "0"
      if PointPos mod 2 = 0 then
      begin
        S := S + '0';
        Inc(PointPos);
      end;
      Delete(S, APos, 1);
      Dec(PointPos);
      // ������ PointPos ��������� �� ������ ����� ������� �����
    end;

    // ������ ���, ����� ���-�� ���� � ����� ���� ������� ����
    if Length(S) mod 2 <> 0 then
      S := '0' + S;

    // ���� ���-�� ���� � ����� ����� ��������� MaxBCDLength, �� ���������� ������
    if Length(S) - PointPos > MaxBCDLength then
      raise EMatrixBCDError.CreateFmt(matSBCDTooBigNumber, [SValue]);

    // �������� ����� ���, ����� ��� �� ��������� MaxBCDLength
    if Length(S) > MaxBCDLength then
    begin
      Dec(PointPos, Length(S) - MaxBCDLength);
      SetLength(S, MaxBCDLength);
    end;

    Result := BCDEmpty; // �������������� ������

    Result.BCDPrecision := Length(S);
    Result.BCDSeparatorPos := PointPos;
    Result.BCDSigned := Byte(MinusCount mod 2 <> 0);

    // ���������� ���������� ������ � Result
    StrToBCDBuffer;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function StringToBCD'){$ENDIF}
  end;
end;

function TryStringToBCD(const SValue: string; var BCDValue: TBCDNumber): Boolean;
begin
  Result := True;
  try
    BCDValue := StringToBCD(SValue);
  except
    Result := False;
  end;
end;

function StringToBCDDef(const SValue: string; const BCDDefault: TBCDNumber): TBCDNumber;
begin
  try
    Result := StringToBCD(SValue);
  except
    Result := BCDDefault;
  end;
end;

function BCDToString(const BCDValue: TBCDNumber): string;
var
  I, LenDiv2: Integer;
begin
  try
    SetLength(Result, BCDValue.BCDPrecision);

    // ���������� � ������ ��� �������
    LenDiv2 := BCDValue.BCDPrecision div 2;
    for I := 0 to LenDiv2 - 1 do
    begin
      Result[(LenDiv2 - I) * 2] := Chr(BCDValue.BCDData[I] and $0F + Byte('0'));
      Result[(LenDiv2 - I) * 2 - 1] := Chr(BCDValue.BCDData[I] shr 4 + Byte('0'))
    end;
    // ��������� ������ �����������
    if BCDValue.BCDSeparatorPos > 0 then
      Insert(MatrixDecimalSeparator, Result, BCDValue.BCDPrecision - BCDValue.BCDSeparatorPos + 1);

    _BCDTrim0(Result);  

    if BCDValue.BCDSigned = 1 then
      Result := '-' + Result;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function BCDToString'){$ENDIF}
  end;
end;

{����������� BCD-����� ����� �������, ����� �� ����� ���� ���������,
 � ��������� ����������� ���� �� ����� � ��� �� �����}
procedure _BCDAlign(BCDValue1, BCDValue2: TBCDNumber; var BCDOut1, BCDOut2: TBCDNumber);
var
  Pos1, Pos2, MaxPos, Prec1, Prec2, Int1, Int2, MaxIntPart: Integer;
  NewSepPos: Integer;
begin
  try
    BCDOut1 := BCDEmpty;
    BCDOut2 := BCDEmpty;

    Pos1 := BCDValue1.BCDSeparatorPos;
    Pos2 := BCDValue2.BCDSeparatorPos;
    MaxPos := Max(Pos1, Pos2);
    Prec1 := BCDValue1.BCDPrecision;
    Prec2 := BCDValue2.BCDPrecision;
    Int1 := Prec1 - Pos1;
    Int2 := Prec2 - Pos2;
    MaxIntPart := Max(Int1, Int2);

    if MaxIntPart + MaxPos <= MaxBCDLength then // ���� ��������� ��������� � �������
    begin
      NewSepPos := MaxPos;
      MoveMemory(@BCDOut1.BCDData[(MaxPos - Pos1) div 2],
        @BCDValue1.BCDData[0], Prec1 div 2);
      MoveMemory(@BCDOut2.BCDData[(MaxPos - Pos2) div 2],
        @BCDValue2.BCDData[0], Prec2 div 2);
    end else
    begin
      NewSepPos := MaxBCDLength - MaxIntPart;
      MoveMemory(@BCDOut1.BCDData[0],
        @BCDValue1.BCDData[(Pos1 - NewSepPos) div 2], (Int1 + NewSepPos) div 2);
      MoveMemory(@BCDOut2.BCDData[0],
        @BCDValue2.BCDData[(Pos2 - NewSepPos) div 2], (Int2 + NewSepPos) div 2);
    end;

    BCDOut1.BCDSeparatorPos := NewSepPos;
    BCDOut1.BCDPrecision := MaxIntPart + NewSepPos;
    BCDOut1.BCDSigned := BCDValue1.BCDSigned;
    BCDOut2.BCDSeparatorPos := NewSepPos;
    BCDOut2.BCDPrecision := MaxIntPart + NewSepPos;
    BCDOut2.BCDSigned := BCDValue2.BCDSigned;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure _BCDAlign'){$ENDIF}
  end;
end;

type
  // BCD-����� ��������� ��������. ������������ � �������� ���������� ������
  // ��� ���������� ��������� �������������� ��������
  PBCDDouble = ^TBCDDouble;
  TBCDDouble = packed record
    BCDPrecision    : Short; // ������� ����� ����� (����� �������� �����)
    BCDSeparatorPos : Short; // ����� �����, ����� ������� ������� ���������� �����
    BCDSigned       : Short; // 1, ���� ����� �������������
    BCDData: array[0..MaxBCDLength - 1] of Byte; // ���������� ������
  end;

//var
//  BCDDoubleClear: TBCDDouble;

function BCDSum(const BCDValue1, BCDValue2: TBCDNumber): TBCDNumber;
var
  BigBCD: TBCDDouble;
  BCD1, BCD2: TBCDNumber;
  I: Integer;
  Bits, AByte, Byte1, Byte2: Byte; // ���� ��������
begin
  try
    if BCDValue1.BCDSigned + BCDValue2.BCDSigned = 1 then
    begin
      if BCDValue1.BCDSigned = 1 then
        Result := BCDSub(BCDValue2, BCDValue1)
      else
        Result := BCDSub(BCDValue1, BCDValue2);
      Exit;
    end;

    _BCDAlign(BCDValue1, BCDValue2, BCD1, BCD2);

    BigBCD.BCDPrecision := BCD1.BCDPrecision;
    BigBCD.BCDSeparatorPos := BCD1.BCDSeparatorPos;
    Bits := 0;
    for I := 0 to BCD1.BCDPrecision div 2 - 1 do
    begin
      Byte1 := BCD1.BCDData[I];
      Byte2 := BCD2.BCDData[I];

      // ���������� ������� �����
      Bits := Byte1 and $0F + Byte2 and $0F + Bits shr 4;
      if Bits > 9 then
        Bits := $10 + (Bits - 10);
      AByte := Bits and $0F;
      // ���������� ������� �����
      Bits := (Byte1 and $F0) shr 4 + (Byte2 and $F0) shr 4 + Bits shr 4;
      if Bits > 9 then
        Bits := $10 + (Bits - 10);
      AByte := Bits shl 4 + AByte;
      BigBCD.BCDData[I] := AByte;
    end;
    // ���� ��� �������� ��� ������� �������, �� ���������� ���
    if (Bits and $F0) shr 4 = 1 then
    begin
      Inc(BigBCD.BCDPrecision, 2);
      BigBCD.BCDData[BigBCD.BCDPrecision div 2 - 1] := 1;
    end;

    // ��������  BigBCD � Result
    if BigBCD.BCDPrecision <= MaxBCDLength then
    begin
      MoveMemory(@Result.BCDData[0], @BigBCD.BCDData[0], BigBCD.BCDPrecision div 2);
      Result.BCDSeparatorPos := BigBCD.BCDSeparatorPos;
      Result.BCDPrecision := BigBCD.BCDPrecision;       
    end else // ����� ���� ���������� �������� ��� ����� �����
    if BigBCD.BCDPrecision - BigBCD.BCDSeparatorPos <= MaxBCDLength then
    begin
      MoveMemory(@Result.BCDData[0],
        @BigBCD.BCDData[(BigBCD.BCDPrecision - MaxBCDLength) div 2], MaxBCDLength div 2);
      Result.BCDSeparatorPos := MaxBCDLength - (BigBCD.BCDPrecision - BigBCD.BCDSeparatorPos);
      Result.BCDPrecision := MaxBCDLength;
    end else
      raise EMatrixBCDError.Create(matSBCDOverFlow);

    if BCDValue1.BCDSigned + BCDValue2.BCDSigned = 0 then
      Result.BCDSigned := 0
    else // �� ����� ���� 2
      Result.BCDSigned := 1
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function BCDSum'){$ENDIF}
  end;
end;

function BCDSub(const BCDValue1, BCDValue2: TBCDNumber): TBCDNumber;
begin

end;

{$IFNDEF UseLifeGuid}
{������������ ������ AMatrix � ���������� ������ MatrixInstanceList}
procedure RegisterMatrixInstance(AMatrix: TMatrix);
begin
  with MatrixInstanceList.LockList do
  try
    Add(AMatrix);
  finally
    MatrixInstanceList.UnlockList;
  end;
end;

{������� ������ AMatrix �� ����������� ������ MatrixInstanceList}
procedure UnRegisterMatrixInstance(AMatrix: TMatrix);
begin
  with MatrixInstanceList.LockList do
  try
    Remove(AMatrix);
  finally
    MatrixInstanceList.UnlockList;
  end;
end;
{$ENDIF UseLifeGuid}

{ TMatrix }

procedure TMatrix.CheckMemoryForResize(ElementsCount: Int64);
var
  NeedMem: Double;
begin
  try
    NeedMem := ElementsCount * FElemSize;
    if NeedMem > AvailMemory then
      raise EMatrixMemoryError.CreateFmt(matSOutOfMemory, [NeedMem, AvailMemory]);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CheckMemoryForResize'){$ENDIF}
  end;
end;

destructor TMatrix.Destroy;
var
  I: Integer;
begin
  // ������� ������
  if FMatrixTypes <> [] then
    Clear;

  // ������� ��� �������� �������
  if Assigned(FArrayList) then
  begin
    ArrayListCriticalSection.Enter;
    try
      for I := FArrayList.Count - 1 downto 0 do
        TMatrix(FArrayList.Items[I]).FreeMatrix;
    finally
      ArrayListCriticalSection.Leave;
    end;
    FreeAndNil(FArrayList);
  end;

  if Assigned(FNotifyList) then
  begin
    NotifyListCriticalSection.Enter;
    try
      // ���������� ��� Notify-������� � ����� ��������
      for I := 0 to FNotifyList.Count - 1 do
        TMatrix(FNotifyList[I]).DeletionNotify(Self);
    finally
      NotifyListCriticalSection.Leave;
    end;
    FreeAndNil(FNotifyList);   
  end;

  // ������� ��������������� ���������� � ���������
  if Assigned(FOwnerMatrix) then
    FOwnerMatrix.UnRegisterChildMatrix(Self);

  // ������������� �������� ���� ��������� ���������� � 0
  if Assigned(FPointerList) then
  begin
    for I := 0 to FPointerList.Count - 1 do
      if PMatrixObject(FPointerList[I])^ = Self then
        PMatrixObject(FPointerList[I])^ := nil;
    FPointerList.Free;
  end;

  // ��� ������� ������� ����������� ������� ������ � ��������������� ����������
  if IsDynamic then
    ArrayAddress := nil;

{$IFDEF UseLifeGuid}
  FLifeGUID := DeadMatrixGuid;
{$ELSE}
  UnRegisterMatrixInstance(Self);
{$ENDIF UseLifeGuid}
  InterlockedDecrement(MatrixObjectCounter);

  inherited;
end;

procedure TMatrix.Reshape(const DimValues: array of Integer);
begin
  if ProdDimensions(DimValues) <> ProdDimensions(FDimensions) then
    raise CreateExceptObject(EMatrixDimensionsError, matSCanNotChangeSize, 'Reshape')
  else
    SetDimValues(DimValues);
end;

procedure TMatrix.Resize(const DimValues: array of Integer);
begin
  raise CreateAbstractErrorObj('Resize');
end;

procedure TMatrix.SetCols(const Value: Integer);
begin
  Dimension[DimensionCount - 1] := Value;
end;

procedure TMatrix.SetElemI(const Indexes: array of Integer;
  const Value: Integer);
begin
  raise CreateAbstractErrorObj('SetElemI');
end;

procedure TMatrix.SetElem(const Indexes: array of Integer;
  const Value: Extended);
begin
  raise CreateAbstractErrorObj('SetElem');
end;

procedure TMatrix.SetRows(const Value: Integer);
begin
  Dimension[DimensionCount - 2] := Value;
end;

function TMatrix.ThisMatrix: TMatrix;
begin
  Result := Self;
end;

function TMatrix.ProdDimensions(const DimValues: array of Integer): Int64;
var
  I: Integer;
begin
  Result := 0;
  if Length(DimValues) > 0 then
  begin
    Result := DimValues[0];
    for I := 1 to High(DimValues) do
    begin
      if DimValues[I] < 0 then
        raise CreateExceptObject(EMatrixDimensionsError, matSDimensionError,
          'ProdDimensions', mkFunc)
      else
        Result := Result * DimValues[I];

      // ������ �� ����� ��������� ����� 2 ���� ���������!
      if Result > High(Integer) then
        raise CreateExceptObject(EMatrixDimensionsError, matSDimensionError,
          'ProdDimensions', mkFunc);
    end;
  end;
end;

function TMatrix.GetDimensionCount: Integer;
begin
  Result := Length(FDimensions);
end;

function TMatrix.GetDimension(Index: Integer): Integer;
begin
  if (Index < 0) or (Index > Length(FDimensions) - 1) then
    Result := 0
  else
    Result := FDimensions[Index];
end;

procedure TMatrix.SetDimension(Index: Integer; const Value: Integer);
var
  ADimensions: TDynIntArray;
begin
  try
    if (Index < 0) or (Index > High(FDimensions)) then
      raise EMatrixDimensionsError.Create(matSNoDimension);

    ADimensions := Copy(FDimensions);

    ADimensions[Index] := Value;

    PreservResize(ADimensions);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetDimension'){$ENDIF}  
  end;
end;

procedure TMatrix.CheckRowAndCol(Row, Col: Integer);
begin
  if (Row < 0) or (Col < 0) or ((Row <> 0)
    and (Row > Rows - 1)) or (Col > Cols - 1) then
    raise CreateExceptObject(EMatrixWrongCoords,
      Format(matSWrongCoords + matSTryAccessToElem,
        [IntToStr(Row) + ' x ' + IntToStr(Col)]), 'CheckRowAndCol');
end;

function TMatrix.GetElemI(const Indexes: array of Integer): Integer;
begin
  raise CreateAbstractErrorObj('GetElemI', mkFunc);
end;

function TMatrix.GetElem(const Indexes: array of Integer): Extended;
begin
  raise CreateAbstractErrorObj('GetElem', mkFunc);
end;

procedure TMatrix.SetAsString(const Value: string);
begin
  raise CreateAbstractErrorObj('SetAsString');
end;

function TMatrix.Zeros: TMatrix;
begin
  raise CreateAbstractErrorObj('Zeros', mkFunc);
end;

procedure TMatrix.Init;
begin
  raise CreateAbstractErrorObj('Init');
end;

function TMatrix.MulMatrices(Matrices: array of TMatrix): TMatrix;
var
  I: Integer;
  Matrix: TMatrix;
begin
  try
    if not IsSameMatrixTypes(Matrices, [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if Length(Matrices) < 2 then
      raise EMatrixBadParams.Create(matSBadInputData);

    Matrix := CreateInstance;
    try
      TNumericMatrixClass(Matrix).DoMulMatrix(Matrices[0], Matrices[1]);
      for I := 2 to Length(Matrices) - 1 do
        TNumericMatrixClass(Matrix).DoMulMatrix(Matrix, Matrices[I]);
      MoveFrom(Matrix);
    finally
      Matrix.FreeMatrix;
    end;

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'MulMatrices', mkFunc){$ENDIF}
  end;
end;

procedure TMatrix.MoveFrom(Matrix: TMatrix);
begin
  raise CreateAbstractErrorObj('MoveFrom');
end;

procedure TMatrix.CopyFrom(Matrix: TMatrix);
begin
  raise CreateAbstractErrorObj('CopyFrom');
end;

procedure TMatrix.SetMatrixName(const Value: TMatrixName);
var
  AMatrix: TMatrix;
begin
  try
    if Value = FName then Exit;

    if Value <> '' then
    begin
      if (Value[1] = MatrixNameRemoveLabel) or (Length(Value) > High(Byte)) then
        raise EMatrixBadName.CreateFmt(matSBadName, [Value]);

      if Assigned(FOwnerMatrix) then
      begin
        // ���� � �������� ��� ���� ������ � ��� �� ������, �� ������� ���
        AMatrix := FOwnerMatrix.FindMatrix(Value);
        if Assigned(AMatrix) then
          AMatrix.FreeMatrix;
      end;

      // ���� ������ �� �������� ������� ��������, �� ���������
      // �������������� �������� ��� �����
      if not IsWorkspace then
        if not MatrixNameIsValid(Value) then
          raise EMatrixBadName.CreateFmt(matSBadName, [Value]);
    end;

    FHash := GenerateHash(Value);
    FName := Value;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetMatrixName'){$ENDIF}
  end;
end;

procedure TMatrix.CopyByRef(Matrix: TMatrix);
begin
  raise CreateAbstractErrorObj('CopyByRef');
end;

procedure TMatrix.Clear;
begin
  raise CreateAbstractErrorObj('Clear');
end;

procedure TMatrix.PreservResize(const DimValues: array of Integer);
begin
  raise CreateAbstractErrorObj('PreservResize');
end;

function TMatrix.FillByValue(Value: Extended): TMatrix;
begin
  raise CreateAbstractErrorObj('FillByValue', mkFunc);
end;

function TMatrix.Rand(const MaxValue: Cardinal): TMatrix;
begin
  raise CreateAbstractErrorObj('Rand');
end;

function TMatrix.GetOrderNum(const Values: array of Integer): Integer;
var
  I: Integer;
begin
{$IFDEF MatrixCheckRange}
  if Length(Values) <> Length(FDimensions) then
    raise CreateExceptObject(EMatrixWrongCoords, matSWrongCoords +
      Format(matSTryAccessToElem, [DimValuesToString(Values, 20)]),
      'GetOrderNum', mkFunc);

  for I := 0 to Length(Values) - 1 do
    if (Values[I] < 0) or (Values[I] >= FDimensions[I]) then
      raise CreateExceptObject(EMatrixWrongCoords, matSWrongCoords +
        Format(matSTryAccessToElem, [DimValuesToString(Values, 20)]),
        'GetOrderNum', mkFunc);
{$ENDIF MatrixCheckRange}

  // ��������� ��������
  Result := Values[Length(Values) - 1];
  for I := 0 to Length(Values) - 2 do
    Inc(Result, Values[I] * FElemInDimensions[I]);
end;

function TMatrix.CalcFunction(const Matrix: TMatrix; AFunc: TIntFunction): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);

    Matrix.CheckForNumeric;

    if Matrix <> Self then
      Resize(Matrix.FDimensions);
    for I := 0 to FElemCount - 1 do
      VecElemI[I] := AFunc(Matrix.VecElemI[I]);
    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CalcFunction', mkFunc){$ENDIF}
  end;
end;

function TMatrix.CalcFunction(const Matrix: TMatrix; AFunc: TFloatFunction): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);

    if Matrix <> Self then
      Resize(Matrix.FDimensions);
    for I := 0 to FElemCount - 1 do
      VecElem[I] := AFunc(Matrix.VecElem[I]);
    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CalcFunction', mkFunc){$ENDIF}
  end;
end;

function TMatrix.CalcOperation(const Matrices: array of TMatrix;
  AFunc: TIntOperation): TMatrix;
var
  I, J: Integer;
  Value: Integer;
  TempMatrix: TMatrix;
{$IFDEF ExtendedCalcOperation}
  MatrixElemCount: TDynIntArray;
{$ENDIF ExtendedCalcOperation}
begin
  try
{$IFDEF ExtendedCalcOperation}
    MatrixElemCount :=
{$ENDIF ExtendedCalcOperation}
    CheckForCalcOperation(Matrices, TempMatrix);

    try
      for I := 0 to TempMatrix.FElemCount - 1 do
      begin
{$IFDEF ExtendedCalcOperation}
        if MatrixElemCount[0] = 1 then
          Value := Matrices[0].VecElemI[0]
        else
{$ENDIF ExtendedCalcOperation}
          Value := Matrices[0].VecElemI[I];

        for J := 1 to Length(Matrices) - 1 do
{$IFDEF ExtendedCalcOperation}
          if MatrixElemCount[J] = 1 then
            Value := AFunc(Value, Matrices[J].VecElemI[0])
          else
{$ENDIF ExtendedCalcOperation}
            Value := AFunc(Value, Matrices[J].VecElemI[I]);

        TempMatrix.VecElemI[I] := Value;
      end;

      MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CalcOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.CalcOperation(const Matrices: array of TMatrix;
  AFunc: TFloatOperation): TMatrix;
var
  I, J: Integer;
  Value: Extended;
  TempMatrix: TMatrix;
{$IFDEF ExtendedCalcOperation}
  MatrixElemCount: TDynIntArray;
{$ENDIF ExtendedCalcOperation}
begin
  try
{$IFDEF ExtendedCalcOperation}
    MatrixElemCount :=
{$ENDIF ExtendedCalcOperation}
    CheckForCalcOperation(Matrices, TempMatrix);
    try
      for I := 0 to TempMatrix.FElemCount - 1 do
      begin
{$IFDEF ExtendedCalcOperation}
        if MatrixElemCount[0] = 1 then
          Value := Matrices[0].VecElem[0]
        else
{$ENDIF ExtendedCalcOperation}
          Value := Matrices[0].VecElem[I];

        for J := 1 to Length(Matrices) - 1 do
{$IFDEF ExtendedCalcOperation}
          if MatrixElemCount[J] = 1 then
            Value := AFunc(Value, Matrices[J].VecElem[0])
          else
{$ENDIF ExtendedCalcOperation}
            Value := AFunc(Value, Matrices[J].VecElem[I]);

        TempMatrix.VecElem[I] := Value;
      end;
      MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CalcOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.GetAsStringEx: string;
begin
  raise CreateAbstractErrorObj('GetAsStringEx', mkFunc);
end;

procedure TMatrix.SetAsStringEx(const Value: string);
begin
  raise CreateAbstractErrorObj('SetAsStringEx');
end;

class function TMatrix.GetAlias: TSignature;
begin
  Result := '';
end;

function TMatrix.GetElemStr(const Indexes: array of Integer): string;
begin
  raise CreateAbstractErrorObj('GetElemStr', mkFunc);
end;

procedure TMatrix.SetElemStr(const Indexes: array of Integer;
  const Value: string);
begin
  raise CreateAbstractErrorObj('SetElemStr');
end;

procedure TMatrix.FillByOrder(FirstValue: Integer = 0);
begin
  raise CreateAbstractErrorObj('FillByOrder');
end;

function TMatrix.GetElemVar(const Indexes: array of Integer): Variant;
begin
  raise CreateAbstractErrorObj('GetElemVar', mkFunc);
end;

procedure TMatrix.SetElemVar(const Indexes: array of Integer;
  const Value: Variant);
begin
  raise CreateAbstractErrorObj('SetElemVar');
end;

function TMatrix.Transpose(const Matrix: TMatrix): TMatrix;
begin
  raise CreateAbstractErrorObj('Transpose', mkFunc);
end;

function TMatrix.Ones: TMatrix;
begin
  raise CreateAbstractErrorObj('Ones', mkFunc);
end;

function TMatrix.ValueOperation(const Matrix: TMatrix; Value: Extended;
  AFunc: TFloatOperation): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    if Self <> Matrix then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElem[I] := AFunc(Matrix.VecElem[I], Value);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'ValueOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.ValueOperation(Value: Extended; const Matrix: TMatrix;
  AFunc: TFloatOperation): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    if Self <> Matrix then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElem[I] := AFunc(Value, Matrix.VecElem[I]);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'ValueOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.ValueOperation(const Matrix: TMatrix; Value: Integer;
  AFunc: TIntOperation): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    if Self <> Matrix then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElemI[I] := AFunc(Matrix.VecElemI[I], Value);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'ValueOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.ValueOperation(Value: Integer; const Matrix: TMatrix;
  AFunc: TIntOperation): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    if Self <> Matrix then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElemI[I] := AFunc(Value, Matrix.VecElemI[I]);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'ValueOperation', mkFunc){$ENDIF}
  end;
end;

procedure TMatrix.CheckVecIndex(const Index: Integer);
begin
  if (Length(FDimensions) < 1) or (Index < 0) or (Index >= FElemCount) then
    raise CreateExceptObject(EMatrixWrongCoords,
      Format(matSWrongCoords + matSTryAccessToElem, [IntToStr(Index)]), 'CheckVecIndex');
end;

function TMatrix.GetElemI64(const Indexes: array of Integer): Int64;
begin
  raise CreateAbstractErrorObj('GetElemI64', mkFunc);
end;

procedure TMatrix.SetElemI64(const Indexes: array of Integer;
  const Value: Int64);
begin
  raise CreateAbstractErrorObj('SetElemI64');
end;

function TMatrix.CalcFunction(const Matrix: TMatrix;
  AFunc: TInt64Function): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    
    if Matrix <> Self then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElemI64[I] := AFunc(Matrix.VecElemI64[I]);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CalcFunction', mkFunc){$ENDIF}
  end;
end;

function TMatrix.CalcOperation(const Matrices: array of TMatrix;
  AFunc: TInt64Operation): TMatrix;
var
  I, J: Integer;
  Value: Int64;
  TempMatrix: TMatrix;
{$IFDEF ExtendedCalcOperation}
  MatrixElemCount: TDynIntArray;
{$ENDIF ExtendedCalcOperation}
begin
  try
{$IFDEF ExtendedCalcOperation}
    MatrixElemCount :=
{$ENDIF ExtendedCalcOperation}
    CheckForCalcOperation(Matrices, TempMatrix);
    try

      for I := 0 to TempMatrix.FElemCount - 1 do
      begin
{$IFDEF ExtendedCalcOperation}
        if MatrixElemCount[0] = 1 then
          Value := Matrices[0].VecElemI64[0]
        else
{$ENDIF ExtendedCalcOperation}
          Value := Matrices[0].VecElemI64[I];

        for J := 1 to Length(Matrices) - 1 do
{$IFDEF ExtendedCalcOperation}
          if MatrixElemCount[J] = 1 then
            Value := AFunc(Value, Matrices[J].VecElemI64[0])
          else
{$ENDIF ExtendedCalcOperation}
            Value := AFunc(Value, Matrices[J].VecElemI64[I]);

        TempMatrix.VecElemI64[I] := Value;
      end;

      MoveFrom(TempMatrix);

    finally
      TempMatrix.FreeMatrix;
    end;

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CalcOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.ValueOperation(Value: Int64; const Matrix: TMatrix;
  AFunc: TInt64Operation): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    if Self <> Matrix then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElemI64[I] := AFunc(Value, Matrix.VecElemI64[I]);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'ValueOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.ValueOperation(const Matrix: TMatrix; Value: Int64;
  AFunc: TInt64Operation): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    if Self <> Matrix then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElemI64[I] := AFunc(Matrix.VecElemI64[I], Value);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'ValueOperation', mkFunc){$ENDIF}
  end;
end;

procedure TMatrix.CopyFrom(const Buffer: Pointer; const DimValues: array of Integer;
  LoaderClass: TMatrixClass = nil);
begin
  raise CreateAbstractErrorObj('CopyFrom');
end;

procedure TMatrix.CopyByRef(const Buffer: Pointer;
  const DimValues: array of Integer);
begin
  raise CreateAbstractErrorObj('CopyByRef');
end;

function TMatrix.GetComplex(const Indexes: array of Integer): TExtendedComplex;
begin
  raise CreateAbstractErrorObj('GetComplex', mkFunc);
end;

procedure TMatrix.SetComplex(const Indexes: array of Integer;
  const Value: TExtendedComplex);
begin
  raise CreateAbstractErrorObj('SetComplex');
end;

procedure TMatrix.AssignDynElem(const Matrix: TMatrix; const SelfIndexes,
  MatrixIndexes: array of Integer);
begin
  raise CreateAbstractErrorObj('AssignDynElem');
end;

procedure TMatrix.AssignElem(const Matrix: TMatrix; const SelfRow, SelfCol,
  MatrixRow, MatrixCol: Integer);
begin
  raise CreateAbstractErrorObj('AssignElem');
end;

procedure TMatrix.AssignVecElem(const Matrix: TMatrix; const SelfIndex,
  MatrixIndex: Integer);
begin
  raise CreateAbstractErrorObj('AssignVecElem');
end;

function TMatrix.CalcFunction(const Matrix: TMatrix;
  AFunc: TComplexFunction): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    if Matrix <> Self then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElemCx[I] := AFunc(Matrix.VecElemCx[I]);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CalcFunction', mkFunc){$ENDIF}
  end;
end;

function TMatrix.CalcOperation(const Matrices: array of TMatrix;
  AFunc: TComplexOperation): TMatrix;
var
  I, J: Integer;
  Value: TExtendedComplex;
  TempMatrix: TMatrix;
{$IFDEF ExtendedCalcOperation}
  MatrixElemCount: TDynIntArray;
{$ENDIF ExtendedCalcOperation}
begin
  try
{$IFDEF ExtendedCalcOperation}
    MatrixElemCount :=
{$ENDIF ExtendedCalcOperation}
    CheckForCalcOperation(Matrices, TempMatrix);
    try
      for I := 0 to TempMatrix.FElemCount - 1 do
      begin
{$IFDEF ExtendedCalcOperation}
        if MatrixElemCount[0] = 1 then
          Value := Matrices[0].VecElemCx[0]
        else
{$ENDIF ExtendedCalcOperation}
          Value := Matrices[0].VecElemCx[I];

        for J := 1 to Length(Matrices) - 1 do
{$IFDEF ExtendedCalcOperation}
          if MatrixElemCount[J] = 1 then
            Value := AFunc(Value, Matrices[J].VecElemCx[0])
          else
{$ENDIF ExtendedCalcOperation}
            Value := AFunc(Value, Matrices[J].VecElemCx[I]);

        TempMatrix.VecElemCx[I] := Value;
      end;
      MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CalcOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.ValueOperation(Value: TExtendedComplex;
  const Matrix: TMatrix; AFunc: TComplexOperation): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    if Self <> Matrix then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElemCx[I] := AFunc(Value, Matrix.VecElemCx[I]);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'ValueOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.ValueOperation(const Matrix: TMatrix;
  Value: TExtendedComplex; AFunc: TComplexOperation): TMatrix;
var
  I: Integer;
begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);
    if Self <> Matrix then
      Resize(Matrix.FDimensions);

    for I := 0 to FElemCount - 1 do
      VecElemCx[I] := AFunc(Matrix.VecElemCx[I], Value);

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'ValueOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.IsComplex: Boolean;
begin
  CheckRef('IsComplex', mkFunc);
  Result := mtComplex in FMatrixTypes;
end;

function TMatrix.IsFloat: Boolean;
begin
  CheckRef('IsFloat', mkFunc);
  Result := mtFloat in FMatrixTypes;
end;

function TMatrix.IsInt64: Boolean;
begin
  CheckRef('IsInt64', mkFunc);
  Result := mtInt64 in FMatrixTypes;
end;

function TMatrix.IsInteger: Boolean;
begin
  CheckRef('IsInteger', mkFunc);
  Result := mtInteger in FMatrixTypes;
end;

procedure TMatrix.LoadFromStream(AStream: TStream;
  const DimValues: array of Integer; LoaderClass: TMatrixClass);
begin
  raise CreateAbstractErrorObj('LoadFromStream');
end;

procedure TMatrix.SaveToStream(AStream: TStream; SaverClass: TMatrixClass);
begin
  raise CreateAbstractErrorObj('SaveToStream');
end;

function TMatrix.IsCell: Boolean;
begin
  CheckRef('IsCell', mkFunc);
  Result := mtCell in FMatrixTypes;
end;

function TMatrix.GetCell(const Indexes: array of Integer): TMatrix;
begin
  raise CreateAbstractErrorObj('GetCell', mkFunc);
end;

procedure TMatrix.SetCell(const Indexes: array of Integer;
  const Value: TMatrix);
begin
  raise CreateAbstractErrorObj('SetCell');
end;

function TMatrix.GetObject(const Indexes: array of Integer): TObject;
begin
  raise CreateAbstractErrorObj('GetObject', mkFunc);
end;

procedure TMatrix.SetObject(const Indexes: array of Integer;
  const Value: TObject);
begin
  raise CreateAbstractErrorObj('SetObject');
end;

function TMatrix.IsObject: Boolean;
begin
  CheckRef('IsObject', mkFunc);
  Result := mtObject in FMatrixTypes;
end;

function TMatrix.IsNumeric: Boolean;
begin
  CheckRef('IsNumeric', mkFunc);
  Result := mtNumeric in FMatrixTypes;
end;

function TMatrix.IsRecord: Boolean;
begin
  CheckRef('IsRecord', mkFunc);
  Result := mtRecord in FMatrixTypes;
end;

function TMatrix.IsDynamic: Boolean;
begin
  CheckRef('IsDynamic', mkFunc);
  Result := mtDynamic in FMatrixTypes;
end;

function TMatrix.IsWorkspace: Boolean;
begin
  CheckRef('IsWorkspace', mkFunc);
  Result := mtWorkspace in FMatrixTypes;
end;

function TMatrix.IsChar: Boolean;
begin
  CheckRef('IsChar', mkFunc);
  Result := mtChar in FMatrixTypes;
end;

function TMatrix.IsNetwork: Boolean;
begin
  CheckRef('IsNNetwork', mkFunc);
  Result := mtNetwork in FMatrixTypes;
end;

procedure TMatrix.DeleteObjects;
begin
  raise CreateAbstractErrorObj('DeleteObjects');
end;

function TMatrix.CreateCopy(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix;
begin
  Result := CreateInstance(AOwner, AName);
  Result.CopyFrom(Self);
end;

function TMatrix.DoAdd(Matrices: array of TMatrix): TMatrix;
begin
  if IsComplex then
    CalcOperation(Matrices, opCmplxSum)
  else if IsInt64 then
    CalcOperation(Matrices, opSumI64)
  else if IsFloat then
    CalcOperation(Matrices, opSum)
  else if IsInteger then
    CalcOperation(Matrices, opSumI);
  Result := Self;
end;

function TMatrix.DoSub(Matrices: array of TMatrix): TMatrix;
begin
  if IsComplex then
    CalcOperation(Matrices, opCmplxSub)
  else if IsInt64 then
    CalcOperation(Matrices, opSubI64)
  else if IsFloat then
    CalcOperation(Matrices, opSub)
  else if IsInteger then
    CalcOperation(Matrices, opSubI);
  Result := Self;
end;

function TMatrix.DoMul(Matrices: array of TMatrix): TMatrix;
begin
  if IsComplex then
    CalcOperation(Matrices, opCmplxMul)
  else if IsInt64 then
    CalcOperation(Matrices, opMulI64)
  else if IsFloat then
    CalcOperation(Matrices, opMul)
  else if IsInteger then
    CalcOperation(Matrices, opMulI);
  Result := Self;
end;

function TMatrix.DoDiv(Matrices: array of TMatrix): TMatrix;
begin
  if IsComplex then
    CalcOperation(Matrices, opCmplxDiv)
  else if IsInt64 or IsFloat or IsInteger then
    CalcOperation(Matrices, opDiv);
  Result := Self;
end;

function TMatrix.DoIntDiv(Matrices: array of TMatrix): TMatrix;
begin
  if IsComplex then
    CalcOperation(Matrices, opCmplxInvDiv)
  else if IsInt64 then
    CalcOperation(Matrices, opDivI64)
  else if IsFloat then
    CalcOperation(Matrices, opTruncDiv)
  else if IsInteger then
    CalcOperation(Matrices, opDivI);
  Result := Self;
end;

procedure TMatrix.RegisterChildMatrix(AMatrix: TMatrix);
var
  ATemp: TMatrix;
begin
  try
    AMatrix.CheckRef;

    ArrayListCriticalSection.Enter;
    try
      if FArrayList.IndexOf(AMatrix) < 0 then
      begin
        // ���� ��� ������� ������ � ��� �� ������, �� ������� ���
        ATemp := FindMatrix(AMatrix.MatrixName);
        if Assigned(ATemp) then
          ATemp.FreeMatrix;
        FArrayList.Add(AMatrix);
      end;
    finally
      ArrayListCriticalSection.Leave;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'RegisterChildMatrix'){$ENDIF}
  end;
end;

procedure TMatrix.UnRegisterChildMatrix(AMatrix: TMatrix);
begin
  ArrayListCriticalSection.Enter;
  try
    FArrayList.Remove(AMatrix);
  finally
    ArrayListCriticalSection.Leave;
  end;                              
end;

constructor TMatrix.Create(AOwner: TMatrix; const AName: TMatrixName);
begin
  inherited Create;

{$IFDEF UseLifeGuid}
  FLifeGUID := LifeMatrixGuid;
{$ELSE}
  RegisterMatrixInstance(Self);
{$ENDIF UseLifeGuid}
  InterlockedIncrement(MatrixObjectCounter);

  FArrayList := TList.Create;
  FNotifyList := TList.Create;

  if GetAlias = '' then
    raise CreateAbstractErrorObj('Create', mkConstructor);

  if (Length(AName) > 0) then
  begin
    // ������ ������ ��������� ������ MatrixNameRemoveLabel, ��� ��� �� ��������
    // ����������������� � ������������ ��� ��������� � ��������� �������
    if AName[1] = MatrixNameRemoveLabel then
      raise CreateExceptObject(EMatrixBadName,
        Format(matSBadName, [AName]), 'Create', mkConstructor);

    // ���� ����������� ������ - �� ������� �������, �� ����� ���������
    // ������������ �����
    if ClassType <> TWorkspace then // IsWorkspace ����� �� ��������� (���� ���)
      if not MatrixNameIsValid(AName) then
      begin
        raise CreateExceptObject(EMatrixBadName,
          Format(matSBadName, [AName]), 'Create', mkConstructor);
        Exit;
      end;

    FHash := GenerateHash(AName);
    FName := AName;
  end;

  if Assigned(AOwner) then
  begin
    AOwner.CheckRef('Create', mkConstructor);
    FOwnerMatrix := AOwner;
    // �������������� � ���������
    FOwnerMatrix.RegisterChildMatrix(Self);
  end;

  Init;  
end;

procedure TMatrix.GetMatrixList(AList: TStrings;
  const UseTypes: TMatrixTypes = [];
  const IgnoreTypes: TMatrixTypes = [mtWorkspace]);
var
  I: Integer;
  AMatrix: TMatrix;
  ATypes: TMatrixTypes;
begin
  try
    AList.Clear;
    for I := 0 to MatrixCount - 1 do
    begin
      AMatrix := Matrices[I];
      ATypes := AMatrix.FMatrixTypes;

      if (ATypes * IgnoreTypes = []) then
        if (UseTypes = []) or (ATypes * UseTypes <> []) then
          AList.AddObject(AMatrix.MatrixName, AMatrix);
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetMatrixList'){$ENDIF}
  end;
end;

procedure TMatrix.GetFieldList(AList: TStrings);
begin
  raise CreateAbstractErrorObj('GetFieldList')
end;

function TMatrix.FindMatrix(AName: TMatrixName): TMatrix;
var
  I, Hash: Integer;
  AMatrix: TMatrix;
begin
  Result := nil;
  if AName = '' then Exit;
  
  Hash := GenerateHash(AName);

  ArrayListCriticalSection.Enter;
  try
    // ������ ��������� ��������� ������� �������� �������� ����� �������������,
    // ������� ��������� �����, ������� � ����� ������.
    for I := FArrayList.Count - 1 downto 0 do
    begin
      AMatrix := FArrayList.Items[I];
      AMatrix.CheckRef('FindMatrix', mkFunc);

      if (AMatrix.FHash = Hash) and (AMatrix.FName = AName) then
      begin
        Result := AMatrix;
        Exit;
      end;
    end;
  finally
    ArrayListCriticalSection.Leave;
  end;
end;

function TMatrix.MatrixExists(AName: TMatrixName): Boolean;
begin
  Result := FindMatrix(AName) <> nil;
end;

function TMatrix.GetMatrixByName(const AName: TMatrixName): TMatrix;
begin
  Result := FindMatrix(AName);
  if Result = nil then
    raise CreateExceptObject(EMatrixError, Format(matSArrayNotFound, [AName]),
      'GetMatrixByName', mkFunc);
end;

function TMatrix.MatrixCount: Integer;
begin
  ArrayListCriticalSection.Enter;
  try
    Result := FArrayList.Count;
  finally
    ArrayListCriticalSection.Leave;
  end;
end;

function TMatrix.GetMatrices(Index: Integer): TMatrix;
begin
  Result := nil;

  ArrayListCriticalSection.Enter;
  try
    if (Index >= 0) and (Index < FArrayList.Count) then
      Result := FArrayList.Items[Index];
  finally
    ArrayListCriticalSection.Leave;
  end;

  Result.CheckRef('GetMatrices', mkFunc);
end;

function TMatrix.VecAddress(Index: Integer): Pointer;
begin
  raise CreateAbstractErrorObj('VecAddress', mkFunc)
end;

function TMatrix.ElemAddress(const Row, Col: Integer): Pointer;
begin
  raise CreateAbstractErrorObj('ElemAddress', mkFunc)
end;

function TMatrix.DynElemAddress(const Indexes: array of Integer): Pointer;
begin
  raise CreateAbstractErrorObj('DynElemAddress', mkFunc)
end;

function TMatrix.Concat(DIM: Integer; const Matrices: array of TMatrix): TMatrix;
begin
  raise CreateAbstractErrorObj('Concat', mkFunc)
end;

function TMatrix.IsEmpty: Boolean;
begin
  raise CreateAbstractErrorObj('IsEmpty', mkFunc)
end;

function TMatrix.CopyArrayPart(AMatrix: TMatrix; const LoIntervals,
  IntervalsLen: array of Integer; UseLenAsHigh,
  CopyDataInIntervals: Boolean): TMatrix;
begin
  raise CreateAbstractErrorObj('CopyArrayPart', mkFunc)
end;

procedure TMatrix.SaveToStreamEx(AStream: TStream; AName: TMatrixName = '';
  SaverClass: TMatrixClass = nil);
begin
  raise CreateAbstractErrorObj('SaveToStreamEx')
end;

procedure TMatrix.LoadFromStreamEx(AStream: TStream);
begin
  raise CreateAbstractErrorObj('LoadFromStreamEx')
end;

procedure TMatrix.SaveToBinaryFile(const AFileName: string;
  AName: TMatrixName; SaverClass: TMatrixClass; DoRewrite: Boolean);
var
  sAnsi: AnsiString;
  Fs: TFileStream;
  Ms: TMemoryStream;
  Alias: TSignature;
  BeginAddress, NextAddress, Int64Buf: Int64;
  ReadedName: TMatrixName;
  OpenFileMode: Word;
  MustCreate: Boolean; // ���� ������ ���� ������ ������
begin
  try
    if AName = '' then
      AName := MatrixName;

    if AName = '' then
      raise EMatrixFileStreamError.Create(matSBadNameForBinFile);

    if not FileExists(AFileName) or DoRewrite then
    begin
      OpenFileMode := fmCreate or fmShareDenyWrite;
      MustCreate := True
    end else
    begin
      OpenFileMode := fmOpenReadWrite or fmShareDenyWrite;
      MustCreate := False
    end;

    Fs := WaitAndCreateFileStream(AFileName, OpenFileMode, MatrixWaitFileOpen);
    try
      Ms := TMemoryStream.Create;
      try
        if MustCreate then
        begin
          // ���������� ������������ ����������
          sAnsi := AnsiString(matSBinaryHeader);
          Fs.Write(sAnsi[1], Length(sAnsi));
          Fs.Seek(0, soFromBeginning);
        end;

        // ���������� �������������� ������ � ����� � ������
        SaveToStreamEx(Ms, AName, SaverClass);
        Ms.Seek(0, soFromBeginning);

        // �������� ����� ������ � ������ AName, � ���� �� ������, �� ������������
        // ����� ��������
        if FindMatrixInFileStream(Fs, AName, Alias, BeginAddress, NextAddress, ReadedName) then
        begin
          // ���� ����� �������� �������� ���������, �� �������������� ���������
          // ������� �����
          if NextAddress - BeginAddress = Ms.Size then
          begin
            Fs.Position := BeginAddress;
            Fs.CopyFrom(Ms, Ms.Size);
          end else
          begin
            // "������" ������, ����� ��� ������ ���� ��������
            Fs.Position := BeginAddress + SizeOf(Byte);
            sAnsi := MatrixNameRemoveLabel;
            Fs.Write(sAnsi[1], SizeOf(Byte));

            // ���������� � ����� �����
            Fs.Seek(0,soFromEnd);
            BeginAddress := Fs.Position;
            Fs.CopyFrom(Ms, Ms.Size);
          end;
        end else
        begin
          // ���������� ������ � ����� �����
          Fs.Seek(0,soFromEnd);
          BeginAddress := Fs.Position;
          Fs.CopyFrom(Ms, Ms.Size);
        end;

        // ������������ ����� ����� �������
        Int64Buf := Fs.Position;
        Fs.Position := BeginAddress;
        ReadMatrixNameFromStream(Fs);
        Fs.Write(Int64Buf, SizeOf(Int64Buf));
      finally
        Ms.Free;
      end;
    finally
      Fs.Free;
    end;
    
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SaveToBinaryFile'){$ENDIF}
  end;
end;

procedure TMatrix.LoadFromBinaryFile(const AFileName: string;
  AName: TMatrixName = '');
var
  Fs: TFileStream;
  Ms: TMemoryStream;
  Alias: TSignature;
  BeginAddress, NextAddress, Int64Buf: Int64;
  ReadedName: TMatrixName;
begin
  try
    if AName = '' then
      AName := MatrixName;

    if AName = '' then
      raise EMatrixFileStreamError.Create(matSBadNameForBinFile);

    Fs := WaitAndCreateFileStream(AFileName, fmOpenRead or fmShareDenyWrite, MatrixWaitFileOpen);
    try
      Ms := TMemoryStream.Create;
      try
        if FindMatrixInFileStream(Fs, AName, Alias, BeginAddress,
           NextAddress, ReadedName) then
        begin
          // ���������� ����� � ������ ��� ��������� �������� ��������
          Ms.CopyFrom(Fs, NextAddress - BeginAddress);
          Ms.Position := 0;
          // ������������ ����� ��������� ������
          ReadMatrixNameFromStream(Ms);
          Int64Buf := Ms.Size;
          Ms.Write(Int64Buf, SizeOf(Int64Buf));
          Ms.Position := 0;

          LoadFromStreamEx(Ms);
        end else
          raise EMatrixFileStreamError.CreateFmt(matSArrayNotFound, [AName]);
      finally
        Ms.Free;
      end;
    finally
      Fs.Free;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'LoadFromBinaryFile'){$ENDIF}
  end;
end;

function TMatrix.FindField(AName: TMatrixName): TMatrix;
begin
  raise CreateAbstractErrorObj('FindField', mkFunc)
end;

function TMatrix.CreateInstance(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix;
begin
  if Assigned(AOwner) then
    AOwner.CheckRef('CreateInstance', mkFunc);
  Result := TMatrixClass(ClassType).Create(AOwner, AName);
end;

function TMatrix.CreateReference(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix;
begin
  Result := CreateInstance(AOwner, AName);
  Result.CopyByRef(Self);
end;

function TMatrix.Colon(const StartValue, StepValue,
  FinishValue: Extended): TMatrix;
var
  Value: Extended;
  Counter: Int64;
  I: Integer;
begin
  try
    Clear;
    Result := Self;

    if Math.IsZero(StepValue) then Exit;
    if (FinishValue > StartValue) and (StepValue < 0) then Exit;
    if (FinishValue < StartValue) and (StepValue > 0) then Exit;

    if Abs(Abs(FinishValue) - Abs(StartValue)) / StepValue > High(Integer) then
      raise EMatrixBadParams.Create(matSErrorCreateArray);

    // ����������� ���������� ��������� �������
    Value := StartValue;
    Counter := 1;

    if (FinishValue >= StartValue) then
      while Value + StepValue < FinishValue do
      begin
        Value := Value + StepValue;
        Inc(Counter);
      end
    else
      while Value + StepValue > FinishValue do
      begin
        Value := Value + StepValue;
        Inc(Counter);
      end;    

    Resize([1, Counter]);

    // ��������� ������
    Value := StartValue;
    for I := 0 to Counter - 1 do
    begin
      VecElem[I] := Value;
      Value := Value + StepValue;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Colon', mkFunc){$ENDIF}
  end;
end;

procedure TMatrix.FillByStep(const StartValue, StepValue: Extended);
begin
  raise CreateAbstractErrorObj('FillByStep')
end;

procedure TMatrix.FillByStep2(const StartValue, FinishValue: Extended);
begin
  raise CreateAbstractErrorObj('FillByStep2')
end;

function TMatrix.GetDimensions: TDynIntArray;
begin
  Result := Copy(FDimensions);
end;

function TMatrix.CalcMatrixDimensions: TDynIntArray;
var
  ARows: Integer;
begin
  Result := nil;
  SetLength(Result, 2);
  if Cols > 0 then
  begin
    ARows := ElemCount div Cols;
    Result[0] := ARows;
    Result[1] := Cols;
  end;
end;

function TMatrix.AsVariantArray(AVarType: TVarType): Variant;
var
  Bounds, Coords, VCoords: TDynIntArray;
  I: Integer;
  V: Variant; // ��������� ������ ���������
  SelfLen: Integer;

  procedure PutElems(DimValue: Integer);
  var
    I: Integer;
    C: Char;
  begin
    if DimValue >= SelfLen then Exit;

    for I := 0 to FDimensions[DimValue] - 1 do
    begin
      Coords[DimValue] := I;
      VCoords[DimValue] := I + 1;
      PutElems(DimValue + 1);
      if mtChar in FMatrixTypes then
      begin
        C := GetElemChar(Coords);
        VarArrayPut(V, Ord(C), VCoords);
      end else
      begin
        VarArrayPut(V, GetElem(Coords), VCoords);
      end;

    end;
  end;

begin
  try
    CheckForMatrixTypes([Self], [mtNumeric]);

    if DimensionCount = 0 then Exit;

    // ��������� ������ ������ ���������
    SetLength(Bounds, DimensionCount * 2);
    for I := 0 to DimensionCount - 1 do
    begin
      Bounds[I * 2] := 1;
      Bounds[I * 2 + 1] := Dimension[I];
    end;

    V := VarArrayCreate(Bounds, AVarType);

    SelfLen := DimensionCount;
    SetLength(Coords, SelfLen);

    // ������� � ������� ��������� ����� ������������ �� 1
    SetLength(VCoords, SelfLen);

    // ��������� ������
    PutElems(0);

    // ���������� ���������
    Result := V;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'AsVariantArray', mkFunc){$ENDIF}
  end;
end;

procedure TMatrix.LoadFromVariantArray(const AVariant: Variant);
var
  I, DimCount: Integer;
  DimValues, Coords, VCoords, VLowBounds: TDynIntArray;

  procedure GetElems(DimValue: Integer);
  var
    I, CharCode: Integer;
  begin
    if DimValue >= DimCount then Exit;

    for I := 0 to FDimensions[DimValue] - 1 do
    begin
      Coords[DimValue] := I;
      VCoords[DimValue] := I + VLowBounds[DimValue];
      GetElems(DimValue + 1);

      if mtChar in FMatrixTypes then
      begin
        CharCode := VarArrayGet(AVariant, VCoords);
        SetElemChar(Coords, Chr(CharCode));
      end
      else
        SetElem(Coords, VarArrayGet(AVariant, VCoords));
    end;
  end;    
begin
  try

    CheckForMatrixTypes([Self], [mtNumeric]);
    
    Clear;

    DimCount := VarArrayDimCount(AVariant);
    SetLength(DimValues, DimCount);
    SetLength(VLowBounds, DimCount);

    for I := 0 to DimCount - 1 do
    begin
      VLowBounds[I] := VarArrayLowBound(AVariant, I + 1);
      DimValues[I] :=
        VarArrayHighBound(AVariant, I + 1) - VLowBounds[I] + 1;
    end;

    Resize(DimValues);

    SetLength(Coords, DimCount);
    SetLength(VCoords, DimCount);

    GetElems(0);

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'LoadFromVariantArray'){$ENDIF}
  end;
end;

function TMatrix.FieldCount: Integer;
begin
  raise CreateAbstractErrorObj('FieldCount', mkFunc)
end;

function TMatrix.FieldName(Index: Integer): TMatrixName;
begin
  raise CreateAbstractErrorObj('FieldName', mkFunc)
end;

function TMatrix.FieldByIndex(Index: Integer): TMatrix;
begin
  raise CreateAbstractErrorObj('FieldByIndex', mkFunc)
end;

function TMatrix.GetElemChar(const Indexes: array of Integer): Char;
begin
  raise CreateAbstractErrorObj('GetElemChar', mkFunc)
end;

procedure TMatrix.SetElemChar(const Indexes: array of Integer;
  const Value: Char);
begin
  raise CreateAbstractErrorObj('SetElemChar')
end;

function TMatrix.GetRowChars(ARow: Integer): string;
begin
  raise CreateAbstractErrorObj('GetRowChars', mkFunc)
end;

procedure TMatrix.GetMinMaxMean(DIM: Integer;
  AMin, AMax, AMinMax, AMean, AMinIndexes, AMaxIndexes: TMatrix);
var
  AMatrixDimValues, ResultDimValues, CorrectDimValues: TDynIntArray;
  ATempMin, ATempMax, ATempMinMax, ATempMean: TMatrix;
  ATempMinIndexes, ATempMaxIndexes, AStorage: TMatrix;
  SelfLen: Integer;
  AMinValue, AMaxValue, TempValue: Extended;


  procedure _AssignElems(ADim: Integer);
  var
    I: Integer;
  begin
    if ADim >= SelfLen then Exit;
    for I := 0 to FDimensions[ADim] - 1 do
    begin
      AMatrixDimValues[ADim] := I;
      if ADim <> DIM then
        ResultDimValues[ADim] := I
      else
        ResultDimValues[ADim] := 0;

      _AssignElems(ADim + 1);

      // ��� ���������� ��������� ������ ��� ��������� ���������� ���������.
      if ADim = SelfLen - 1 then
      begin

        if Assigned(ATempMin) and (GetElem(AMatrixDimValues) < ATempMin.GetElem(ResultDimValues)) then
        begin
          ATempMin.AssignDynElem(Self, ResultDimValues, AMatrixDimValues);
          if Assigned(ATempMinIndexes) then
            ATempMinIndexes.SetElemI(ResultDimValues, AMatrixDimValues[DIM]);
        end;

        if Assigned(ATempMax) and (GetElem(AMatrixDimValues) > ATempMax.GetElem(ResultDimValues)) then
        begin
          ATempMax.AssignDynElem(Self, ResultDimValues, AMatrixDimValues);
          if Assigned(ATempMaxIndexes) then
            ATempMaxIndexes.SetElemI(ResultDimValues, AMatrixDimValues[DIM]);
        end;

        if Assigned(ATempMinMax) then
        begin
          ATempMinMax.AssignDynElem(ATempMin, ResultDimValues, ResultDimValues);
          TempValue := ATempMax.GetElem(ResultDimValues);
          ResultDimValues[DIM] := 1;
          ATempMinMax.SetElem(ResultDimValues, TempValue);
          ResultDimValues[DIM] := 0;
        end;

        if Assigned(ATempMean) then
        begin
          ATempMean.SetElem(ResultDimValues,
            ATempMean.GetElem(ResultDimValues) + GetElem(AMatrixDimValues));
        end;

      end;  // if
    end; // for I

  end;
begin
  try

    CheckForMatrixTypes([Self], [mtNumeric]);

    ATempMin         := nil;
    ATempMax         := nil;
    ATempMinMax      := nil;
    ATempMean        := nil;
    ATempMinIndexes  := nil;
    ATempMaxIndexes  := nil;

    if not IsSameMatrixTypes([AMin, AMax, AMinMax, AMean,
      AMinIndexes, AMaxIndexes], [mtNumeric], True) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if (DIM >= DimensionCount) or (DIM < 0) then
      raise EMatrixDimensionsError.Create(matSDimensionError);

    SelfLen := DimensionCount;

    SetLength(AMatrixDimValues, SelfLen);
    SetLength(ResultDimValues, SelfLen);
    SetLength(CorrectDimValues, 0);
    CorrectDimValues := Copy(GetDimensions);
    CorrectDimValues[DIM] := 1;

    // ���������� ���������� � ���������� �������� ������� �������
    GetMinMaxValues(@AMinValue, @AMaxValue);

    AStorage := CreateInstance();

    try

      if Assigned(AMin) or Assigned(AMinIndexes) or Assigned(AMinMax) then
      begin
        ATempMin := CreateInstance(AStorage);
        ATempMin.Resize(CorrectDimValues);
        ATempMin.FillByValue(AMaxValue);
      end;

      if Assigned(AMax) or Assigned(AMaxIndexes) or Assigned(AMinMax) then
      begin
        ATempMax := CreateInstance(AStorage);
        ATempMax.Resize(CorrectDimValues);
        ATempMax.FillByValue(AMinValue);
      end;

      if Assigned(AMean) then
      begin
        ATempMean := AMean.CreateInstance(AStorage);
        ATempMean.PreservResize(CorrectDimValues);
      end;

      if Assigned(AMinIndexes) then
      begin
        ATempMinIndexes := AMinIndexes.CreateInstance(AStorage);
        ATempMinIndexes.PreservResize(CorrectDimValues);
      end;

      if Assigned(AMaxIndexes) then
      begin
        ATempMaxIndexes := AMaxIndexes.CreateInstance(AStorage);
        ATempMaxIndexes.PreservResize(CorrectDimValues);
      end;

      if Assigned(AMinMax) then
      begin
        ATempMinMax := AMinMax.CreateInstance(AStorage);
        CorrectDimValues[DIM] := 2;
        ATempMinMax.PreservResize(CorrectDimValues);
      end;

      if not IsEmpty then
      begin
        _AssignElems(0);
      end;

      // ���������� ��������
      if Assigned(AMean) then
      begin
        ATempMean.ValueOperation(ATempMean, FDimensions[DIM], opDiv);
        AMean.MoveFrom(ATempMean);
      end;
      if Assigned(AMin) then AMin.MoveFrom(ATempMin);
      if Assigned(AMinIndexes) then AMinIndexes.MoveFrom(ATempMinIndexes);
      if Assigned(AMax) then AMax.MoveFrom(ATempMax);
      if Assigned(AMaxIndexes) then AMaxIndexes.MoveFrom(ATempMaxIndexes);
      if Assigned(AMinMax) then AMinMax.MoveFrom(ATempMinMax);
    finally
      AStorage.FreeMatrix;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetMinMaxMean'){$ENDIF}
  end;
end;

function TMatrix.DimCols: Integer;
begin
  if DimensionCount > 0 then
    Result := DimensionCount - 1
  else
    raise CreateExceptObject(EMatrixDimensionsError, matSDimensionError, 'DimCols', mkFunc);
end;

function TMatrix.DimRows: Integer;
begin
  if DimensionCount > 1 then
    Result := DimensionCount - 2
  else
    raise CreateExceptObject(EMatrixDimensionsError, matSDimensionError, 'DimRows', mkFunc)
end;

procedure TMatrix.DeletionNotify(AMatrix: TMatrix);
begin
//
end;

procedure TMatrix.AddNotifyClient(AMatrix: TMatrix);
begin
  AMatrix.CheckRef('AddNotifyClient');

  NotifyListCriticalSection.Enter;
  try
    if FNotifyList.IndexOf(AMatrix) < 0 then
      FNotifyList.Add(AMatrix);
  finally
    NotifyListCriticalSection.Leave;
  end;   
end;

procedure TMatrix.DeleteNotifyClient(AMatrix: TMatrix);
begin
  NotifyListCriticalSection.Enter;
  try
    if Assigned(FNotifyList) then
      FNotifyList.Remove(AMatrix);
  finally
    NotifyListCriticalSection.Leave;
  end;
end;

{$IFDEF UseExtendedFree}
procedure TMatrix.Free;
begin
  try
    FreeMatrix;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Free'){$ENDIF}
  end;
end;
{$ENDIF UseExtendedFree}

procedure TMatrix.BeforeDestruction;
begin
  inherited;
  CheckRef('BeforeDestruction');
end;

procedure TMatrix.FreeMatrix;
begin
  if Self = nil then Exit;
  CheckRef('FreeMatrix');
  Destroy;
end;

function TMatrix.IsLiving: Boolean;
begin
{$IFDEF IsLivingEnabled}

  if Self = nil then
  begin
    Result := False;
    Exit;
  end;

  {$IFDEF UseLifeGuid}
  Result := True;
  try
    if not IsEqualGUID(FLifeGUID, LifeMatrixGuid) then
      Result := False;
  except // ��������� AMatrix.FLifeGUID ����� �������� � ����������
    Result := False;
  end;
  {$ELSE}
  with MatrixInstanceList.LockList do
  try
    Result := IndexOf(Self) >= 0;
  finally
    MatrixInstanceList.UnlockList;
  end;
  {$ENDIF UseLifeGuid}

{$ELSE}
  Result := Self <> nil;
{$ENDIF}
end;

function TMatrix.CreateAbstractErrorObj(MethodName: string;
  MethodKind: TMethodKind = mkProc): Exception;
begin                        
  Result := MatrixCreateExceptObj(EMatrixAbstractError, matSAbstractError,
    FormatMethodName(MethodName, MethodKind), Self);
end;

procedure TMatrix.SetOwnerMatrix(const Value: TMatrix);
begin
  try
    if FOwnerMatrix = Value then Exit;

    if FOwnerMatrix = Self then
      raise EMatrixRefError.Create(matSIsRefToSelf);

    // ��������� ��������������
    if Assigned(FOwnerMatrix) then
      FOwnerMatrix.UnRegisterChildMatrix(Self);

    FOwnerMatrix := Value;

    // ��������� �����������
    if Assigned(FOwnerMatrix) then
      FOwnerMatrix.RegisterChildMatrix(Self);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetOwnerMatrix'){$ENDIF}
  end;
end;

procedure TMatrix.GetMinMaxValues(AMinValue, AMaxValue: PExtended;
  AMinIndex: PInteger = nil; AMaxIndex: PInteger = nil);
var
  AMinVal, AMaxVal: Extended;
  AMaxInd, AMinInd, I: Integer;

begin
  try
    CheckForMatrixTypes([Self], [mtNumeric]);

    if IsEmpty then
      raise EMatrixError.Create(matSArrayIsEmpty);

    AMinVal := VecElem[0];
    AMaxVal := AMinVal;
    AMaxInd := 0;
    AMinInd := 0;

    for I := 1 to ElemCount - 1 do
    begin
      if VecElem[I] > AMaxVal then
      begin
        AMaxVal := VecElem[I];
        AMaxInd := I;
      end else if VecElem[I] < AMinVal then
      begin
        AMinVal := VecElem[I];
        AMinInd := I;
      end;
    end;

    if Assigned(AMinValue) then AMinValue^ := AMinVal;
    if Assigned(AMaxValue) then AMaxValue^ := AMaxVal;

    if Assigned(AMinIndex) then AMinIndex^ := AMinInd;
    if Assigned(AMaxIndex) then AMaxIndex^ := AMaxInd;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetMinMaxValues'){$ENDIF}
  end;
end;

function TMatrix.FormatMethodName(MethodName: string;
  MethodKind: TMethodKind): string;
const
  MethodKinds: array[TMethodKind] of string = (
    'procedure', 'function', 'constructor', 'destructor');
var
  S: string;
begin
  if Self.IsLiving then
    S := ClassName
  else
    S := 'TMatrix';

  if MethodName = '' then
    Result := ''
  else
    Result := Format('%s %s.%s', [MethodKinds[MethodKind], S, MethodName]);
end;

function TMatrix.ReCreateExceptObject(ExceptObj: Exception;
  MethodName: string; MethodKind: TMethodKind): Exception;
begin
  Result := MatrixReCreateExceptObj(ExceptObj,
    FormatMethodName(MethodName, MethodKind), Self);
end;

function TMatrix.CreateExceptObject(EClass: ExceptClass; AMessage,
  MethodName: string; MethodKind: TMethodKind): Exception;
begin
  Result := MatrixCreateExceptObj(EClass, AMessage,
    FormatMethodName(MethodName, MethodKind), Self);
end;

procedure TMatrix.CheckRef(const MethodName: string; MethodKind: TMethodKind);
begin
  if not IsLiving then
    raise CreateExceptObject(EMatrixBadRef,
      Format(matSRefIsNotMatrix, [Pointer(Self)]), MethodName, MethodKind);
end;

function TMatrix.DimOperation(const Matrix: TMatrix; DIM: Integer;
  AFunc: TFloatOperation): TMatrix;
var
  TempMatrix: TMatrix;
  MatrixDimValues, TempDimValues: TDynIntArray;
  ResultDimValues: TDynIntArray; // ������� ������� � ����������
  MatrixLen: Integer;
  Value1, Value2: Extended;

  procedure _AssignElems(ADim: Integer);
  var
    I: Integer;
  begin
    if ADim >= MatrixLen then Exit;
    for I := 0 to Matrix.FDimensions[ADim] - 1 do
    begin
      MatrixDimValues[ADim] := I;
      if ADim = DIM then
        TempDimValues[ADim] := 0
      else
        TempDimValues[ADim] := I;

      _AssignElems(ADim + 1);

      // ��� ���������� ��������� ������ ��� ��������� ���������� ���������.
      if ADim = MatrixLen - 1 then
      begin
        // ���� �������������� ����� ������ ������� �� ��������� ���������,
        // �� ��������� ��� �����������
        if MatrixDimValues[DIM] = 0 then
          TempMatrix.SetElem(TempDimValues, Matrix.GetElem(MatrixDimValues))
        else // ����� ��������� �������� ��������
        begin
          Value1 := TempMatrix.GetElem(TempDimValues);
          Value2 := Matrix.GetElem(MatrixDimValues);
          TempMatrix.SetElem(TempDimValues, AFunc(Value1, Value2));
        end;
      end;
    end;
  end;

begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);

    MatrixLen := Matrix.DimensionCount;

    if (DIM >= MatrixLen) or (DIM < 0) then
      raise EMatrixDimensionsError.Create(matSDimensionError);

    ResultDimValues := Matrix.GetDimensions;
    ResultDimValues[DIM] := 1;
    SetLength(MatrixDimValues, MatrixLen);
    SetLength(TempDimValues, MatrixLen);

    TempMatrix := CreateInstance();
    try
      TempMatrix.Resize(ResultDimValues);
      _AssignElems(0);
      MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'DimOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.DimOperation(const Matrix: TMatrix; DIM: Integer;
  AFunc: TComplexOperation): TMatrix;
var
  TempMatrix: TMatrix;
  MatrixDimValues, TempDimValues: TDynIntArray;
  ResultDimValues: TDynIntArray; // ������� ������� � ����������
  MatrixLen: Integer;
  Value1, Value2: TExtendedComplex;

  procedure _AssignElems(ADim: Integer);
  var
    I: Integer;
  begin
    if ADim >= MatrixLen then Exit;
    for I := 0 to Matrix.FDimensions[ADim] - 1 do
    begin
      MatrixDimValues[ADim] := I;
      if ADim = DIM then
        TempDimValues[ADim] := 0
      else
        TempDimValues[ADim] := I;

      _AssignElems(ADim + 1);

      // ��� ���������� ��������� ������ ��� ��������� ���������� ���������.
      if ADim = MatrixLen - 1 then
      begin
        // ���� �������������� ����� ������ ������� �� ��������� ���������,
        // �� ��������� ��� �����������
        if MatrixDimValues[DIM] = 0 then
          TempMatrix.SetComplex(TempDimValues, Matrix.GetComplex(MatrixDimValues))
        else // ����� ��������� �������� ��������
        begin
          Value1 := TempMatrix.GetComplex(TempDimValues);
          Value2 := Matrix.GetComplex(MatrixDimValues);
          TempMatrix.SetComplex(TempDimValues, AFunc(Value1, Value2));
        end;
      end;
    end;
  end;

begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);

    MatrixLen := Matrix.DimensionCount;

    if (DIM >= MatrixLen) or (DIM < 0) then
      raise EMatrixDimensionsError.Create(matSDimensionError);

    ResultDimValues := Matrix.GetDimensions;
    ResultDimValues[DIM] := 1;
    SetLength(MatrixDimValues, MatrixLen);
    SetLength(TempDimValues, MatrixLen);

    TempMatrix := CreateInstance();
    try
      TempMatrix.Resize(ResultDimValues);
      _AssignElems(0);
      MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'DimOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.DimOperation(const Matrix: TMatrix; DIM: Integer;
  AFunc: TIntOperation): TMatrix;
var
  TempMatrix: TMatrix;
  MatrixDimValues, TempDimValues: TDynIntArray;
  ResultDimValues: TDynIntArray; // ������� ������� � ����������
  MatrixLen: Integer;
  Value1, Value2: Integer;

  procedure _AssignElems(ADim: Integer);
  var
    I: Integer;
  begin
    if ADim >= MatrixLen then Exit;
    for I := 0 to Matrix.FDimensions[ADim] - 1 do
    begin
      MatrixDimValues[ADim] := I;
      if ADim = DIM then
        TempDimValues[ADim] := 0
      else
        TempDimValues[ADim] := I;

      _AssignElems(ADim + 1);

      // ��� ���������� ��������� ������ ��� ��������� ���������� ���������.
      if ADim = MatrixLen - 1 then
      begin
        // ���� �������������� ����� ������ ������� �� ��������� ���������,
        // �� ��������� ��� �����������
        if MatrixDimValues[DIM] = 0 then
          TempMatrix.SetElemI(TempDimValues, Matrix.GetElemI(MatrixDimValues))
        else // ����� ��������� �������� ��������
        begin
          Value1 := TempMatrix.GetElemI(TempDimValues);
          Value2 := Matrix.GetElemI(MatrixDimValues);
          TempMatrix.SetElemI(TempDimValues, AFunc(Value1, Value2));
        end;
      end;
    end;
  end;

begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);

    MatrixLen := Matrix.DimensionCount;

    if (DIM >= MatrixLen) or (DIM < 0) then
      raise EMatrixDimensionsError.Create(matSDimensionError);

    ResultDimValues := Matrix.GetDimensions;
    ResultDimValues[DIM] := 1;
    SetLength(MatrixDimValues, MatrixLen);
    SetLength(TempDimValues, MatrixLen);

    TempMatrix := CreateInstance();
    try
      TempMatrix.Resize(ResultDimValues);
      _AssignElems(0);
      MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'DimOperation', mkFunc){$ENDIF}
  end;
end;

function TMatrix.DimOperation(const Matrix: TMatrix; DIM: Integer;
  AFunc: TInt64Operation): TMatrix;
var
  TempMatrix: TMatrix;
  MatrixDimValues, TempDimValues: TDynIntArray;
  ResultDimValues: TDynIntArray; // ������� ������� � ����������
  MatrixLen: Integer;
  Value1, Value2: Int64;

  procedure _AssignElems(ADim: Integer);
  var
    I: Integer;
  begin
    if ADim >= MatrixLen then Exit;
    for I := 0 to Matrix.FDimensions[ADim] - 1 do
    begin
      MatrixDimValues[ADim] := I;
      if ADim = DIM then
        TempDimValues[ADim] := 0
      else
        TempDimValues[ADim] := I;

      _AssignElems(ADim + 1);

      // ��� ���������� ��������� ������ ��� ��������� ���������� ���������.
      if ADim = MatrixLen - 1 then
      begin
        // ���� �������������� ����� ������ ������� �� ��������� ���������,
        // �� ��������� ��� �����������
        if MatrixDimValues[DIM] = 0 then
          TempMatrix.SetElemI64(TempDimValues, Matrix.GetElemI64(MatrixDimValues))
        else // ����� ��������� �������� ��������
        begin
          Value1 := TempMatrix.GetElemI64(TempDimValues);
          Value2 := Matrix.GetElemI64(MatrixDimValues);
          TempMatrix.SetElemI64(TempDimValues, AFunc(Value1, Value2));
        end;
      end;
    end;
  end;

begin
  try
    CheckForMatrixTypes([Self, Matrix], [mtNumeric]);

    MatrixLen := Matrix.DimensionCount;

    if (DIM >= MatrixLen) or (DIM < 0) then
      raise EMatrixDimensionsError.Create(matSDimensionError);

    ResultDimValues := Matrix.GetDimensions;
    ResultDimValues[DIM] := 1;
    SetLength(MatrixDimValues, MatrixLen);
    SetLength(TempDimValues, MatrixLen);

    TempMatrix := CreateInstance();
    try
      TempMatrix.Resize(ResultDimValues);
      _AssignElems(0);
      MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'DimOperation', mkFunc){$ENDIF}
  end;
end;

procedure TMatrix.CheckForNumeric;
begin
  try
    if not IsNumeric then
      raise EMatrixWrongElemType.Create(matSNotNumericType);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CheckForNumeric'){$ENDIF}
  end;
end;

function TMatrix.CheckForCalcOperation(const Matrices: array of TMatrix;
  var AMatrix: TMatrix): TDynIntArray;
var
  I: Integer;
  MatrixRef: TMatrix;
begin
  try
    if not (Self.IsNumeric and IsSameMatrixTypes(Matrices, [mtNumeric])) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if Length(Matrices) < 2 then
      raise EMatrixBadParams.Create(matSMatrixListIsSmall);

  {$IFNDEF ExtendedCalcOperation}
    if not IsEqualSize(Matrices) then
      raise EMatrixDimensionsError.Create(matSArraysNotAgree);
  {$ENDIF ExtendedCalcOperation}

    MatrixRef := nil;

    for I := 0 to High(Matrices) do
    begin
      if Matrices[I].IsEmpty then
        raise EMatrixError.Create(matSArrayIsEmpty);

      if (MatrixRef = nil) and (Matrices[I].ElemCount > 1) then
        MatrixRef := Matrices[I];
    end;

    SetLength(Result, Length(Matrices));
    for I := 0 to Length(Matrices) - 1 do
      Result[I] := Matrices[I].ElemCount;

    if Assigned(MatrixRef) then
      for I := 0 to Length(Matrices) - 1 do
        if Result[I] > 1 then
          if not IsEqualArraysSize([MatrixRef, Matrices[I]]) then
            raise EMatrixDimensionsError.Create(matSArraysNotAgree);

    AMatrix := CreateInstance;

    if Assigned(MatrixRef) then
    begin
      if IsEqualArraysSize([Self, MatrixRef]) then
        AMatrix.CopyByRef(Self)
      else
        AMatrix.Resize(MatrixRef.FDimensions);
    end else
      AMatrix.Resize(Matrices[0].FDimensions);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CheckForCalcOperation', mkFunc){$ENDIF}
  end;
end;

procedure TMatrix.DoMulMatrix(Matrix1, Matrix2: TMatrix);
var
  TempMatrix: TMatrix;
  I, J, K: Integer;
  SumInt: Integer;
  SumInt64: Int64;
  SumFloat: Extended;
  SumCx: TExtendedComplex;
begin
  try
    if Matrix1.Cols <> Matrix2.Rows then
      raise EMatrixDimensionsError.Create(matSArraysNotAgree);

    TempMatrix := CreateInstance;

    try

      TempMatrix.Resize([Matrix1.Rows, Matrix2.Cols]);

      if Matrix1.IsComplex or Matrix2.IsComplex then
      begin
        for I := 0 to Matrix1.Rows - 1 do
          for J := 0 to Matrix2.Cols - 1 do
          begin
            SumCx := FloatComplex(0, 0);
            for K := 0 to Matrix2.Rows - 1 do
              SumCx := opCmplxSum(SumCx, opCmplxMul(
                Matrix1.ElemCx[I, K], Matrix2.ElemCx[K, J]));
            TempMatrix.ElemCx[I, J] := SumCx;
          end;
      end
      else if Matrix1.IsInteger and Matrix2.IsInteger then
      begin
        for I := 0 to Matrix1.Rows - 1 do
          for J := 0 to Matrix2.Cols - 1 do
          begin
            SumInt := 0;
            for K := 0 to Matrix2.Rows - 1 do
              Inc(SumInt, Matrix1.ElemI[I, K] * Matrix2.ElemI[K, J]);
            TempMatrix.ElemI[I, J] := SumInt;
          end;
      end
      else if Matrix1.IsInt64 and Matrix2.IsInt64 then
      begin
        for I := 0 to Matrix1.Rows - 1 do
          for J := 0 to Matrix2.Cols - 1 do
          begin
            SumInt64 := 0;
            for K := 0 to Matrix2.Rows - 1 do
              Inc(SumInt64, Matrix1.ElemI64[I, K] * Matrix2.ElemI64[K, J]);
            TempMatrix.ElemI64[I, J] := SumInt64;
          end;
      end else
      begin // ������� �������
        for I := 0 to Matrix1.Rows - 1 do
          for J := 0 to Matrix2.Cols - 1 do
          begin
            SumFloat := 0;
            for K := 0 to Matrix2.Rows - 1 do
              SumFloat := SumFloat + Matrix1.Elem[I, K] * Matrix2.Elem[K, J];
            TempMatrix.Elem[I, J] := SumFloat;
          end;
      end;

      MoveFrom(TempMatrix);

    finally
      TempMatrix.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'DoMulMatrix'){$ENDIF}
  end;
end;

function TMatrix.GetValue: Extended;
begin
  Result := VecElem[0];
end;

procedure TMatrix.SetValue(const Value: Extended);
begin
  if ElemCount = 0 then Resize([1]);
  VecElem[0] := Value;
end;

function TMatrix.GetValueCells: TMatrix;
begin
  Result := VecCells[0];
end;

function TMatrix.GetValueCx: TExtendedComplex;
begin
  Result := VecElemCx[0];
end;

function TMatrix.GetValueI: Integer;
begin
  Result := VecElemI[0];
end;

function TMatrix.GetValueI64: Int64;
begin
  Result := VecElemI64[0];
end;

function TMatrix.GetValueStr: string;
begin
  Result := VecElemStr[0];
end;

function TMatrix.GetVecCells(const Index: Integer): TMatrix;
begin
  raise CreateAbstractErrorObj('GetVecCells', mkFunc);
end;

function TMatrix.GetVecChar(const Index: Integer): Char;
begin
  raise CreateAbstractErrorObj('GetVecChar', mkFunc);
end;

function TMatrix.GetVecElem(const Index: Integer): Extended;
begin
  raise CreateAbstractErrorObj('GetVecElem', mkFunc);
end;

function TMatrix.GetVecElemCx(const Index: Integer): TExtendedComplex;
begin
  raise CreateAbstractErrorObj('GetVecElemCx', mkFunc);
end;

function TMatrix.GetVecElemI(const Index: Integer): Integer;
begin
  raise CreateAbstractErrorObj('GetVecElemI', mkFunc);
end;

function TMatrix.GetVecElemI64(const Index: Integer): Int64;
begin
  raise CreateAbstractErrorObj('GetVecElemI64', mkFunc);
end;

function TMatrix.GetVecElemStr(const Index: Integer): string;
begin
  raise CreateAbstractErrorObj('GetVecElemStr', mkFunc);
end;

function TMatrix.GetVecObjects(const Index: Integer): TObject;
begin
  raise CreateAbstractErrorObj('GetVecObjects', mkFunc);
end;

function TMatrix.Get_Cells(const Row, Col: Integer): TMatrix;
begin
  raise CreateAbstractErrorObj('Get_Cells', mkFunc);
end;

function TMatrix.Get_Elem(const Row, Col: Integer): Extended;
begin
  raise CreateAbstractErrorObj('Get_Elem', mkFunc);
end;

function TMatrix.Get_ElemChar(const Row, Col: Integer): Char;
begin
  raise CreateAbstractErrorObj('Get_ElemChar', mkFunc);
end;

function TMatrix.Get_ElemCx(const Row, Col: Integer): TExtendedComplex;
begin
  raise CreateAbstractErrorObj('Get_ElemCx', mkFunc);
end;

function TMatrix.Get_ElemI(const Row, Col: Integer): Integer;
begin
  raise CreateAbstractErrorObj('Get_ElemI', mkFunc);
end;

function TMatrix.Get_ElemI64(const Row, Col: Integer): Int64;
begin
  raise CreateAbstractErrorObj('Get_ElemI64', mkFunc);
end;

function TMatrix.Get_ElemStr(const Row, Col: Integer): string;
begin
  raise CreateAbstractErrorObj('Get_ElemStr', mkFunc);
end;

procedure TMatrix.SetValueCells(const Value: TMatrix);
begin
  if ElemCount = 0 then Resize([1]);
  VecCells[0] := Value;
end;

procedure TMatrix.SetValueCx(const Value: TExtendedComplex);
begin
  if ElemCount = 0 then Resize([1]);
  VecElemCx[0] := Value;
end;

procedure TMatrix.SetValueI(const Value: Integer);
begin
  if ElemCount = 0 then Resize([1]);
  VecElemI[0] := Value;
end;

procedure TMatrix.SetValueI64(const Value: Int64);
begin
  if ElemCount = 0 then Resize([1]);
  VecElemI64[0] := Value;
end;

procedure TMatrix.SetValueStr(const Value: string);
begin
  if ElemCount = 0 then Resize([1]);
  VecElemStr[0] := Value;
end;

procedure TMatrix.SetVecCells(const Index: Integer; const Value: TMatrix);
begin
  raise CreateAbstractErrorObj('SetVecCells');
end;

procedure TMatrix.SetVecChar(const Index: Integer; const Value: Char);
begin
  raise CreateAbstractErrorObj('SetVecChar');
end;

procedure TMatrix.SetVecElem(const Index: Integer; const Value: Extended);
begin
  raise CreateAbstractErrorObj('SetVecElem');
end;

procedure TMatrix.SetVecElemCx(const Index: Integer;
  const Value: TExtendedComplex);
begin
  raise CreateAbstractErrorObj('SetVecElemCx');
end;

procedure TMatrix.SetVecElemI(const Index, Value: Integer);
begin
  raise CreateAbstractErrorObj('SetVecElemI');
end;

procedure TMatrix.SetVecElemI64(const Index: Integer; const Value: Int64);
begin
  raise CreateAbstractErrorObj('SetVecElemI64');
end;

procedure TMatrix.SetVecElemStr(const Index: Integer; const Value: string);
begin
  raise CreateAbstractErrorObj('SetVecElemStr');
end;

procedure TMatrix.SetVecObjects(const Index: Integer; const Value: TObject);
begin
  raise CreateAbstractErrorObj('SetVecObjects');
end;

procedure TMatrix.Set_Elem(const Row, Col: Integer; const Value: Extended);
begin
  raise CreateAbstractErrorObj('Set_Elem');
end;

procedure TMatrix.Set_ElemChar(const Row, Col: Integer; const Value: Char);
begin
  raise CreateAbstractErrorObj('Set_ElemChar');
end;

procedure TMatrix.Set_ElemCx(const Row, Col: Integer;
  const Value: TExtendedComplex);
begin
  raise CreateAbstractErrorObj('Set_ElemCx');
end;

procedure TMatrix.Set_ElemI(const Row, Col, Value: Integer);
begin
  raise CreateAbstractErrorObj('Set_ElemI');
end;

procedure TMatrix.Set_ElemI64(const Row, Col: Integer; const Value: Int64);
begin
  raise CreateAbstractErrorObj('Set_ElemI64');
end;

procedure TMatrix.Set_ElemStr(const Row, Col: Integer; const Value: string);
begin
  raise CreateAbstractErrorObj('Set_ElemStr');
end;

procedure TMatrix.SetRowChars(ARow: Integer; Text: string);
begin
  raise CreateAbstractErrorObj('SetRowChars');
end;

procedure TMatrix.Set_Cells(const Row, Col: Integer; const Value: TMatrix);
begin
  raise CreateAbstractErrorObj('Set_Cells');
end;

function TMatrix.Get_Objects(const Row, Col: Integer): TObject;
begin
  raise CreateAbstractErrorObj('Get_Objects', mkFunc);
end;

procedure TMatrix.Set_Objects(const Row, Col: Integer;
  const Value: TObject);
begin
  raise CreateAbstractErrorObj('Set_Objects');
end;

function TMatrix.GetAsString: string;
begin
  raise CreateAbstractErrorObj('GetAsString', mkFunc);
end;

function TMatrix.GetArrayAddress: Pointer;
begin
  raise CreateAbstractErrorObj('GetArrayAddress', mkFunc);
end;

function TMatrix.GetMatrixSize: Integer;
begin
  Result := FArraySize;
end;

procedure TMatrix.SetArrayAddress(const Value: Pointer);
begin
  raise CreateAbstractErrorObj('SetArrayAddress');
end;

function TMatrix.GetFields(const AName: TMatrixName): TMatrix;
begin
  raise CreateAbstractErrorObj('GetFields', mkFunc);
end;

procedure TMatrix.SetFields(const AName: TMatrixName;
  const Value: TMatrix);
begin
  raise CreateAbstractErrorObj('SetFields');
end;

procedure TMatrix.SetDimValues(const DimValues: array of Integer);
begin
  raise CreateAbstractErrorObj('SetDimValues');
end;

procedure TMatrix.AssignPointers(const Pointers: array of PMatrixObject; CanModify: Boolean);
var
  I: Integer;
begin
  try
    CheckRef('AssignPointers');

    if FPointerList = nil then
      FPointerList := TList.Create;

    for I := Low(Pointers) to High(Pointers) do
    begin
      if Assigned(Pointers[I]) then // ���������� ������� ���������
      begin
        if CanModify then
          Pointers[I]^ := Self;

        if FPointerList.IndexOf(Pointers[I]) < 0 then
          FPointerList.Add(Pointers[I]);
      end;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'AssignPointers'){$ENDIF}
  end;
end;

{ TWorkspace }

procedure TWorkspace.Clear;
var
  I: Integer;
  AMatrix: TMatrix;
begin
  try
    ArrayListCriticalSection.Enter;
    try
      for I := FArrayList.Count - 1 downto 0 do
      begin
        AMatrix := Matrices[I];
        if not AMatrix.IsWorkspace then
          AMatrix.FreeMatrix;
      end;
    finally
      ArrayListCriticalSection.Leave;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Clear'){$ENDIF}
  end;
end;

procedure TWorkspace.Clear(const Names: array of TMatrixName);
var
  I: Integer;
  AMatrix: TMatrix;
begin
  try
    for I := 0 to High(Names) do
    begin
      AMatrix := FindMatrix(Names[I]);
      if Assigned(AMatrix) then
        AMatrix.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Clear'){$ENDIF}
  end;
end;

class function TWorkspace.GetAlias: TSignature;
begin
  Result := 'Workspace';
end;

function TWorkspace.GetMatrixSize: Integer;
var
  I: Integer;
  Obj: TMatrix;
begin
  Result := 0;
  for I := 0 to MatrixCount - 1 do
  begin
    Obj := Matrices[I];
    if Obj.IsLiving then
      Result := Result + Obj.MatrixSize;
  end;

  // ���� Result < 0, ������ �� ����������� � �������������
  if Result < 0 then
    raise EMatrixMemoryError.CreateFmt('ArraySize=%d', [Result]);
end;

procedure TWorkspace.Init;
begin
  FMatrixTypes := FMatrixTypes + [mtWorkspace];
end;

function TWorkspace.IsEmpty: Boolean;
begin
  ArrayListCriticalSection.Enter;
  try
    Result := FArrayList.Count = 0;
  finally
    ArrayListCriticalSection.Leave;
  end;
end;

procedure TWorkspace.LoadFromStreamEx(AStream: TStream);
var
  S, Alias: string;
  LoaderClass: TMatrixClass;
  EndPosition, CurrentPos, Int64Buf: Int64;
  Idx: Integer;
  AMatrix: TMatrix;
begin
  try
    // ���������� ��� �������
    ReadMatrixNameFromStream(AStream);

    // ��������� ����� ����� ������ �������
    AStream.Read(EndPosition, SizeOf(EndPosition));
    if AStream.Size < EndPosition then
      raise EMatrixStreamError.Create(matSFunctionError);

    // ��������� ��������� ������
    Alias := ReadMatrixNameFromStream(AStream);
    if (Length(Alias) < 1) or (Length(Alias) > MaxSignatureLength) then
      raise EMatrixAliasError.Create(matSAliasError);

    // ��������� ������������ �������
    if not AnsiSameText(string(GetAlias), string(Alias)) then
      raise EMatrixAliasError.Create(matSAliasError);

    // ���������� ���������-��������
    ReadMatrixNameFromStream(AStream);

    while AStream.Position < EndPosition do
    begin
      CurrentPos := AStream.Position;

      // ��������� ��� ���� ������
      S := ReadMatrixNameFromStream(AStream);

      // ���������� ����� ����� ���� ������
      AStream.Read(Int64Buf, SizeOf(Int64Buf));

      if not MatrixNameIsValid(S) then
        raise EMatrixBadName.CreateFmt(matSBadName, [S]);

      // ��������� ��������� ������
      Alias := ReadMatrixNameFromStream(AStream);

      Idx := MatrixClassList.IndexOf(Alias);
      if Idx < 0 then
        raise EMatrixClassError.CreateFmt(matSClassNotFound, [Alias]);

      LoaderClass := TMatrixClass(MatrixClassList.Objects[Idx]);

      // ������������ � ������ �������� �������
      AStream.Position := CurrentPos;

      AMatrix := LoaderClass.Create(Self, S);
      AMatrix.LoadFromStreamEx(AStream);
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'LoadFromStreamEx'){$ENDIF}
  end;
end;

procedure TWorkspace.LoadWorkspace(const AFileName: string);
var
  Fs: TFileStream;
  Ms: TMemoryStream;
  AName: TMatrixName;
  Alias: TSignature;
  BeginAddress, NextAddress, Int64Buf: Int64;
  Idx: Integer;
  MatrixClass: TMatrixClass;
  AMatrix: TMatrix;
begin
  try       
    Fs := WaitAndCreateFileStream(AFileName, fmOpenRead or fmShareDenyWrite, MatrixWaitFileOpen);
    try
      Ms := TMemoryStream.Create;
      try
        while FindMatrixInFileStream(Fs, '', Alias, BeginAddress, NextAddress, AName) do
        begin
          if not AnsiSameText(string(Alias), string(GetAlias)) then
          begin
            Idx := MatrixClassList.IndexOf(string(Alias));
            if Idx < 0 then
              raise EMatrixClassError.CreateFmt(matSClassNotFound, [Alias]);

            MatrixClass := TMatrixClass(MatrixClassList.Objects[Idx]);

            // �������� ����� Fs � ����� Ms
            Ms.Clear;
            Ms.CopyFrom(Fs, NextAddress - BeginAddress);
            Ms.Position := 0;

            // ������������ ����� ����� ������
            ReadMatrixNameFromStream(Ms);
            Int64Buf := Ms.Size;
            Ms.Write(Int64Buf, SizeOf(Int64Buf));
            Ms.Position := 0;

            // ������� ������ � ��������� � ���� ������
            AMatrix := MatrixClass.Create(Self, AName);
            AMatrix.LoadFromStreamEx(Ms);
          end;
        end;
      finally
        Ms.Free;
      end;
    finally
      Fs.Free;
    end;
    
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'LoadWorkspace'){$ENDIF}
  end;
end;

procedure TWorkspace.SaveToStreamEx(AStream: TStream; AName: TMatrixName;
  SaverClass: TMatrixClass); 
var
  Int64Buf, Int64BufPos: Int64;
  I: Integer;
begin
  try  
    
    if AName = '' then
      AName := MatrixName;
    // ���������� ��� �������
    WriteMatrixNameToStream(AName, AStream);

    // ����������� ����� ��� ������� ���������
    Int64BufPos := AStream.Position;
    Int64Buf := 0;
    AStream.Write(Int64Buf, SizeOf(Int64Buf));

    // ���������� ���������
    WriteMatrixNameToStream(string(GetAlias), AStream);
    // ���������� ��������� - ��������
    WriteMatrixNameToStream('', AStream);

    // ���������� ��������������� �������� ������� �������, �������� ��������
    // ������� �������
    for I := 0 to MatrixCount - 1 do
      with Matrices[I] do
        if not IsWorkspace and (MatrixName <> '') then
          SaveToStreamEx(AStream);

   // ���������� ����� ����� ���������
   Int64Buf := AStream.Position;
   AStream.Position := Int64BufPos;
   AStream.Write(Int64Buf, SizeOf(Int64Buf));
   AStream.Position := Int64Buf;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SaveToStreamEx'){$ENDIF}
  end;
end;

procedure TWorkspace.SaveWorkspace(const AFileName: string;
  DoRewrite: Boolean);
var
  I: Integer;
begin
  try  
    if DoRewrite and FileExists(AFileName) then
      DeleteFile(AFileName);

    for I := 0 to MatrixCount - 1 do
      with Matrices[I] do
        if not IsWorkspace and (MatrixName <> '') then
          SaveToBinaryFile(AFileName, '', nil);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SaveWorkspace'){$ENDIF}
  end;
end;

function TWorkspace.ThisWorkspace: TWorkspace;
begin
  Result := Self;
end;

{ TExtendedMatrix }

procedure TExtendedMatrix.SetVecElem(const Index: Integer;
  const Value: Extended);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PExtendedArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElem'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

class function TExtendedMatrix.GetAlias: TSignature;
begin
  Result := 'Extended';
end;

function TExtendedMatrix.GetVecElem(const Index: Integer): Extended;
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    Result := PExtendedArray(FArray)[Index];
{$IFDEF MatrixCheckRange}
    Result := Result + 0.0;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecElem', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TExtendedMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Extended);
end;

{ TNumericMatrixClass }  

function TNumericMatrixClass.FillByValue(Value: Extended): TMatrix;
var
  I: Integer;
  IntValue: Int64;
begin
  if IsInteger or IsInt64 then
  begin
    IntValue := Trunc(Value);
    for I := 0 to FElemCount - 1 do
      VecElemI64[I] := IntValue;
  end else
    for I := 0 to FElemCount - 1 do
      VecElem[I] := Value;

  Result := Self;
end;

function TNumericMatrixClass.Rand(const MaxValue: Cardinal): TMatrix;
var
  I: Integer;
begin
  Result := Self;
  if MaxValue = 1 then
    for I := 0 to FElemCount - 1 do
      VecElem[I] := Random
  else
    for I := 0 to FElemCount - 1 do
      VecElemI[I] := Random(MaxValue);
end;

function TNumericMatrixClass.GetAsString: string;
var
  I, J, K, C, Counter, ARows: Integer;
  S: string;
begin
  Result := '';

  SetLength(Result, 100);
  C := 0;
  Counter := 0;

  if (Cols > 0) then
  begin
    ARows := Max(Rows, 1);

    for I := 0 to ARows - 1 do
    begin
      for J := 0 to Cols - 1 do
      begin
        // ����������� ������ ������ ��� �������������
        if C > Length(Result) * 2 / 3 then
          SetLength(Result, Length(Result) * 2);

        if FRows = 0 then
          S := GetElemStr([Counter])
        else
          S := ElemStr[I, J];

        if J < Cols - 1 then
          S := S + MatrixNumberDelimiter + ' '
        else
          S := S + MatrixRowsDelimiter + sLineBreak;

        Inc(Counter);    
        
        for K := 1 to Length(S) do
          Result[C + K] := S[K];

        Inc(C, Length(S));
      end;
    end;
  end;    

  SetLength(Result, C);
end;

procedure TNumericMatrixClass.SetAsString(const Value: string);
var
  ComplexAr: TDynExtendedComplexArray;
  I, J: Integer;
  ARow: Integer;
begin
  try
    ARow := 0;
    Clear;
    ComplexAr := nil;

    with TStringList.Create do
    try
      if Pos(MatrixRowsDelimiter, Value) > 0 then
        Text := FastStringReplace(Value, MatrixRowsDelimiter, sLineBreak, [rfReplaceAll])
      else
        Text := Value;

      for I := 0 to Count - 1 do
      begin
        ComplexAr := ParseMatrixRow(Strings[I]);
        if Length(ComplexAr) = 0 then
          Continue;
        if I = 0 then
          Resize([Count, Length(ComplexAr)]);
        for J := 0 to Min(Length(ComplexAr), Cols) - 1 do
          SetComplex([ARow, J], ComplexAr[J]);
        Inc(ARow);
      end    
    finally
      Free;
    end;

    Resize([ARow, Cols]);

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetAsString'){$ENDIF}
  end;
end;

function TNumericMatrixClass.GetElemStr(const Indexes: array of Integer): string;
begin             
  Result := VecElemStr[GetOrderNum(Indexes)];
end;

procedure TNumericMatrixClass.SetElemStr(const Indexes: array of Integer;
  const Value: string);
begin
  VecElemStr[GetOrderNum(Indexes)] := Value;
end;

procedure TNumericMatrixClass.FillByOrder(FirstValue: Integer = 0);
var
  I: Integer;
begin
  for I := 0 to FElemCount - 1 do
    VecElemI[I] := I + FirstValue;
end;

function TNumericMatrixClass.GetElemVar(const Indexes: array of Integer): Variant;
begin
  Result := GetElem(Indexes);
end;

procedure TNumericMatrixClass.SetElemVar(const Indexes: array of Integer;
  const Value: Variant);
begin
  SetElem(Indexes, Value);
end;

function TNumericMatrixClass.Ones: TMatrix;
begin
  Result := FillByValue(1);
end;

function TNumericMatrixClass.Get_ElemI(const Row, Col: Integer): Integer;
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  Result := VecElemI[FBeginOfArray + Row * FCols + Col];
end;

procedure TNumericMatrixClass.Set_ElemI(const Row, Col, Value: Integer);
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  VecElemI[FBeginOfArray + Row * FCols + Col] := Value;
end;

function TNumericMatrixClass.Get_Elem(const Row, Col: Integer): Extended;
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  Result := VecElem[FBeginOfArray + Row * FCols + Col];
end;

procedure TNumericMatrixClass.Set_Elem(const Row, Col: Integer;
  const Value: Extended);
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  VecElem[FBeginOfArray + Row * FCols + Col] := Value;
end;

function TNumericMatrixClass.GetElemI(
  const Indexes: array of Integer): Integer;
begin
  Result := VecElemI[GetOrderNum(Indexes)];
end;

procedure TNumericMatrixClass.SetElemI(const Indexes: array of Integer;
  const Value: Integer);
begin
  VecElemI[GetOrderNum(Indexes)] := Value;
end;

function TNumericMatrixClass.GetElem(
  const Indexes: array of Integer): Extended;
begin
  Result := VecElem[GetOrderNum(Indexes)];
end;

procedure TNumericMatrixClass.SetElem(const Indexes: array of Integer;
  const Value: Extended);
begin
  VecElem[GetOrderNum(Indexes)] := Value;
end;

function TNumericMatrixClass.Get_ElemI64(const Row, Col: Integer): Int64;
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  Result := VecElemI64[FBeginOfArray + Row * FCols + Col];
end;

procedure TNumericMatrixClass.Set_ElemI64(const Row, Col: Integer;
  const Value: Int64);
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  VecElemI64[FBeginOfArray + Row * FCols + Col] := Value;
end;

function TNumericMatrixClass.GetElemI64(
  const Indexes: array of Integer): Int64;
begin
  Result := VecElemI64[GetOrderNum(Indexes)];
end;

procedure TNumericMatrixClass.SetElemI64(const Indexes: array of Integer;
  const Value: Int64);
begin
  VecElemI64[GetOrderNum(Indexes)] := Value;
end;

function TNumericMatrixClass.GetComplex(
  const Indexes: array of Integer): TExtendedComplex;
begin
  Result := VecElemCx[GetOrderNum(Indexes)];
end;

procedure TNumericMatrixClass.SetComplex(const Indexes: array of Integer;
  const Value: TExtendedComplex);
begin
  VecElemCx[GetOrderNum(Indexes)] := Value;
end;

function TNumericMatrixClass.GetVecElemCx(const Index: Integer): TExtendedComplex;
begin
  Result := FloatComplex(VecElem[Index], 0);
end;

procedure TNumericMatrixClass.SetVecElemCx(const Index: Integer;
  const Value: TExtendedComplex);
begin
  VecElem[Index] := Value.mReal;
end;

function TNumericMatrixClass.Get_ElemCx(const Row,
  Col: Integer): TExtendedComplex;
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  Result := VecElemCx[FBeginOfArray + Row * FCols + Col];
end;

procedure TNumericMatrixClass.Set_ElemCx(const Row, Col: Integer;
  const Value: TExtendedComplex);
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  VecElemCx[FBeginOfArray + Row * FCols + Col] := Value;
end;

function TNumericMatrixClass.Get_ElemStr(const Row, Col: Integer): string;
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  Result := VecElemStr[FBeginOfArray + Row * FCols + Col];
end;

procedure TNumericMatrixClass.Set_ElemStr(const Row, Col: Integer;
  const Value: string);
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  VecElemStr[FBeginOfArray + Row * FCols + Col] := Value;
end;

function TNumericMatrixClass.GetVecElemStr(const Index: Integer): string;
begin
  Result := FloatToStringFunction(VecElem[Index]);
end;

procedure TNumericMatrixClass.SetVecElemStr(const Index: Integer;
  const Value: string);
begin
  VecElem[Index] := StringToFloat(Value);
end;     

procedure TNumericMatrixClass.Init;
begin
  inherited;
  FMatrixTypes := FMatrixTypes + [mtNumeric];
end;

procedure TNumericMatrixClass.FillByStep(const StartValue, StepValue: Extended);
var
  I: Integer;
  Value: Extended;
begin
  Value := StartValue;
  for I := 0 to ElemCount - 1 do
  begin
    VecElem[I] := Value;
    Value := Value + StepValue;
  end;    
end;

procedure TNumericMatrixClass.FillByStep2(const StartValue,
  FinishValue: Extended);
var
  Step: Extended;
begin
  // ����������� �������� ����
  Step := (FinishValue - StartValue) / (ElemCount - 1);
  FillByStep(StartValue, Step);
  // �������� �������� ���������� ��������
  VecElem[ElemCount - 1] := FinishValue;
end;

function TNumericMatrixClass.Get_ElemChar(const Row, Col: Integer): Char;
{$IFDEF D2009PLUS}
var
  S: AnsiString;
  WS: string;
{$ENDIF D2009PLUS}
begin
{$IFDEF D2009PLUS}
  S := AnsiChar(ElemI[Row, Col]);
  WS := string(S);
  Result := WS[1];
{$ELSE D2009PLUS}
  Result := Chr(ElemI[Row, Col]);
{$ENDIF D2009PLUS}
end;

procedure TNumericMatrixClass.Set_ElemChar(const Row, Col: Integer;
  const Value: Char);
{$IFDEF D2009PLUS}
var
  S: AnsiString;
{$ENDIF D2009PLUS}
begin
{$IFDEF D2009PLUS}
  S := AnsiString(Value);
  ElemI[Row, Col] := Ord(S[1]);
{$ELSE D2009PLUS}
  ElemI[Row, Col] := Ord(Value);
{$ENDIF D2009PLUS}
end;

function TNumericMatrixClass.GetVecChar(const Index: Integer): Char;
{$IFDEF D2009PLUS}
var
  S: AnsiString;
  WS: string;
{$ENDIF D2009PLUS}
begin
{$IFDEF D2009PLUS}
  S := AnsiChar(VecElemI[Index]);
  WS := string(S);
  Result := WS[1];
{$ELSE D2009PLUS}
  Result := Chr(VecElemI[Index]);
{$ENDIF D2009PLUS}
end;

procedure TNumericMatrixClass.SetVecChar(const Index: Integer; const Value: Char);
{$IFDEF D2009PLUS}
var
  S: AnsiString;
{$ENDIF D2009PLUS}
begin
{$IFDEF D2009PLUS}
  S := AnsiString(Value);
  VecElemI[Index] := Ord(S[1]);
{$ELSE D2009PLUS}
  // ������ ����������� �������� ���
  VecElemI[Index] := Ord(Value);
{$ENDIF D2009PLUS}
end;

function TNumericMatrixClass.GetElemChar(const Indexes: array of Integer): Char;
{$IFDEF D2009PLUS}
var
  S: AnsiString;
  WS: string;
{$ENDIF D2009PLUS}
begin
{$IFDEF D2009PLUS}
  S := AnsiChar(GetElemI(Indexes));
  WS := string(S);
  Result := WS[1];
{$ELSE D2009PLUS}
  Result := Chr(GetElemI(Indexes));
{$ENDIF D2009PLUS}
end;

procedure TNumericMatrixClass.SetElemChar(const Indexes: array of Integer;
  const Value: Char);
{$IFDEF D2009PLUS}
var
  S: AnsiString;
{$ENDIF D2009PLUS}
begin
{$IFDEF D2009PLUS}
  S := AnsiString(Value);
  SetElemI(Indexes, Ord(S[1]));
{$ELSE D2009PLUS}
  SetElemI(Indexes, Ord(Value));
{$ENDIF D2009PLUS}
end;

function TNumericMatrixClass.GetRowChars(ARow: Integer): string;
var
  I: Integer;
begin
  SetLength(Result, Cols);

  for I := 0 to Cols - 1 do
    Result[I + 1] := ElemChar[ARow, I];

  // ����������� ��� ������� �������
  Result := PChar(Result);
end;

procedure TNumericMatrixClass.SetRowChars(ARow: Integer; Text: string);
var
  NewCols, NewRows, I: Integer;
begin
  if Cols < Length(Text) then
    NewCols := Length(Text)
  else
    NewCols := Cols;

  if Rows < ARow + 1 then
    NewRows := ARow + 1
  else
    NewRows := Rows;

  if (NewCols <> Cols) or (NewRows <> Rows) then
    PreservResize([NewRows, NewCols]);

  for I := 1 to Length(Text) do
    ElemChar[ARow, I - 1] := Text[I];
end;

{ TFloatMatrixClass }

procedure TFloatMatrixClass.AssignDynElem(const Matrix: TMatrix;
  const SelfIndexes, MatrixIndexes: array of Integer);
begin
  SetElem(SelfIndexes, Matrix.GetElem(MatrixIndexes));
end;

procedure TFloatMatrixClass.AssignElem(const Matrix: TMatrix;
  const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer);
begin
  Elem[SelfRow, SelfCol] := Matrix.Elem[MatrixRow, MatrixCol];
end;

procedure TFloatMatrixClass.AssignVecElem(const Matrix: TMatrix;
  const SelfIndex, MatrixIndex: Integer);
begin
  SetVecElem(SelfIndex, Matrix.GetVecElem(MatrixIndex));
end;

function TFloatMatrixClass.GetVecElemI(const Index: Integer): Integer;
begin
  Result := VecElemI64[Index];
end;

function TFloatMatrixClass.GetVecElemI64(const Index: Integer): Int64;
{$IFDEF MatrixCheckRange}
var
  Value: Extended;
{$ENDIF MatrixCheckRange}
begin
{$IFDEF MatrixCheckRange}
  Value := VecElem[Index];
  try
    Result := Trunc(Value);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecElemI64', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}

{$IFNDEF MatrixCheckRange}
  Result := Trunc(VecElem[Index]);
{$ENDIF MatrixCheckRange}
end;

procedure TFloatMatrixClass.Init;
begin
  inherited;
  FMatrixTypes := FMatrixTypes + [mtFloat];
end;

procedure TFloatMatrixClass.SetVecElemI(const Index, Value: Integer);
begin
  VecElem[Index] := Value;
end;

procedure TFloatMatrixClass.SetVecElemI64(const Index: Integer;
  const Value: Int64);
begin
  VecElem[Index] := Value;
end;

{ TIntegerMatrix }

class function TIntegerMatrix.GetAlias: TSignature;
begin
  Result := 'Integer';
end;

function TIntegerMatrix.GetVecElemI(const Index: Integer): Integer;
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}

  Result := PIntegerArray(FArray)[Index];
end;    

procedure TIntegerMatrix.SetVecElemI(const Index, Value: Integer);
begin
{$IFDEF MatrixCheckRange}    
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PIntegerArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemI'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TIntegerMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Integer);
end;

{ TIntegerMatrixClass }

procedure TIntegerMatrixClass.AssignDynElem(const Matrix: TMatrix;
  const SelfIndexes, MatrixIndexes: array of Integer);
begin
  SetElemI(SelfIndexes, Matrix.GetElemI(MatrixIndexes));
end;

procedure TIntegerMatrixClass.AssignElem(const Matrix: TMatrix;
  const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer);
begin
  ElemI[SelfRow, SelfCol] := Matrix.ElemI[MatrixRow, MatrixCol];
end;

procedure TIntegerMatrixClass.AssignVecElem(const Matrix: TMatrix;
  const SelfIndex, MatrixIndex: Integer);
begin
  SetVecElemI(SelfIndex, Matrix.GetVecElemI(MatrixIndex));
end;

function TIntegerMatrixClass.GetVecElem(const Index: Integer): Extended;
begin
  Result := VecElemI[Index];
end;

function TIntegerMatrixClass.GetVecElemI64(const Index: Integer): Int64;
begin
  Result := VecElemI[Index];
end;

procedure TIntegerMatrixClass.Init;
begin
  inherited;
  FMatrixTypes := FMatrixTypes + [mtInteger];
end;

procedure TIntegerMatrixClass.SetVecElem(const Index: Integer;
  const Value: Extended);
begin
{$IFDEF MatrixCheckRange}
  try
    {� ������ ������ ��� ����������, ����� ���������� ��������� ���
     ���������� ������ Trunc. ����������� if...then ��������� �����������
     �������������� ������ ���������}
    if Trunc(Value) = 0 then;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElem'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
  VecElemI[Index] := Trunc(Value);
end;

procedure TIntegerMatrixClass.SetVecElemI64(const Index: Integer;
  const Value: Int64);
begin
  VecElemI[Index] := Value;     
end;

{ TByteMatrix }

class function TByteMatrix.GetAlias: TSignature;
begin
  Result := 'Byte';
end;

function TByteMatrix.GetVecElemI(const Index: Integer): Integer;
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
  Result := PByteArray(FArray)[Index];
end;

procedure TByteMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Byte);
end;

procedure TByteMatrix.SetVecElemI(const Index, Value: Integer);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PByteArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemI'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TShortIntMatrix }

class function TShortIntMatrix.GetAlias: TSignature;
begin
  Result := 'Shortint';
end;

function TShortIntMatrix.GetVecElemI(const Index: Integer): Integer;
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}     
  Result := PShortIntArray(FArray)[Index];
end;

procedure TShortIntMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Shortint);
end;

procedure TShortIntMatrix.SetVecElemI(const Index, Value: Integer);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PShortIntArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemI'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;
          
{ TShortMatrix }

class function TShortMatrix.GetAlias: TSignature;
begin
  Result := 'Short';
end;

function TShortMatrix.GetVecElemI(const Index: Integer): Integer;
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
  Result := PShortArray(FArray)[Index];
end;

procedure TShortMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Short);
end;

procedure TShortMatrix.SetVecElemI(const Index, Value: Integer);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PShortArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemI'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;     

{ TWordMatrix }

class function TWordMatrix.GetAlias: TSignature;
begin
  Result := 'Word';
end;

function TWordMatrix.GetVecElemI(const Index: Integer): Integer;
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
  Result := PWordArray(FArray)[Index];
end;

procedure TWordMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Word);
end;

procedure TWordMatrix.SetVecElemI(const Index, Value: Integer);
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
  try
{$ENDIF MatrixCheckRange}
    PWordArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemI'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TSingleMatrix }

class function TSingleMatrix.GetAlias: TSignature;
begin
  Result := 'Single';
end;

function TSingleMatrix.GetVecElem(const Index: Integer): Extended;
begin
{$IFDEF MatrixCheckRange}   
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    Result := PSingleArray(FArray)[Index];
{$IFDEF MatrixCheckRange}
    Result := Result + 0.0;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecElem', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TSingleMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Single);
end;

procedure TSingleMatrix.SetVecElem(const Index: Integer;
  const Value: Extended);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PSingleArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElem'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TCompMatrix }

class function TCompMatrix.GetAlias: TSignature;
begin
  Result := 'Comp';
end;

function TCompMatrix.GetVecElem(const Index: Integer): Extended;
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    Result := PCompArray(FArray)[Index];
{$IFDEF MatrixCheckRange}
    Result := Result + 0.0;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecElem', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TCompMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Comp);
end;

procedure TCompMatrix.SetVecElem(const Index: Integer;
  const Value: Extended);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PCompArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElem'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TCurrencyMatrix }

class function TCurrencyMatrix.GetAlias: TSignature;
begin
  Result := 'Currency';
end;

function TCurrencyMatrix.GetVecElem(const Index: Integer): Extended;
begin
{$IFDEF MatrixCheckRange}   
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    Result := PCurrencyArray(FArray)[Index];
{$IFDEF MatrixCheckRange}
    Result := Result + 0.0;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecElem', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TCurrencyMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Currency);
end;

procedure TCurrencyMatrix.SetVecElem(const Index: Integer;
  const Value: Extended);
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
  try
{$ENDIF MatrixCheckRange}
    PCurrencyArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElem'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TInt64MatrixClass }

procedure TInt64MatrixClass.AssignDynElem(const Matrix: TMatrix;
  const SelfIndexes, MatrixIndexes: array of Integer);
begin
  SetElemI64(SelfIndexes, Matrix.GetElemI64(MatrixIndexes));
end;

procedure TInt64MatrixClass.AssignElem(const Matrix: TMatrix;
  const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer);
begin
  ElemI64[SelfRow, SelfCol] := Matrix.ElemI64[MatrixRow, MatrixCol];
end;

procedure TInt64MatrixClass.AssignVecElem(const Matrix: TMatrix;
  const SelfIndex, MatrixIndex: Integer);
begin
  SetVecElemI64(SelfIndex, Matrix.GetVecElemI64(MatrixIndex));
end;

function TInt64MatrixClass.GetVecElem(const Index: Integer): Extended;
begin
  Result := VecElemI64[Index];
end;

function TInt64MatrixClass.GetVecElemI(const Index: Integer): Integer;
begin
  Result := VecElemI64[Index];
end;

procedure TInt64MatrixClass.Init;
begin
  inherited;
  FMatrixTypes := FMatrixTypes + [mtInt64];
end;

procedure TInt64MatrixClass.SetVecElem(const Index: Integer;
  const Value: Extended);
begin
{$IFDEF MatrixCheckRange}
  try
{$ENDIF MatrixCheckRange}
    VecElemI64[Index] := Trunc(Value);
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElem'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TInt64MatrixClass.SetVecElemI(const Index, Value: Integer);
begin
  VecElemI64[Index] := Value;   
end;

{ TInt64Matrix }

class function TInt64Matrix.GetAlias: TSignature;
begin
  Result := 'Int64'
end;

function TInt64Matrix.GetVecElemI64(const Index: Integer): Int64;
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
  Result := PInt64Array(FArray)[Index];
end;

procedure TInt64Matrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Int64);
end;

procedure TInt64Matrix.SetVecElemI64(const Index: Integer;
  const Value: Int64);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PInt64Array(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemI64'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TCardinalMatrix }

class function TCardinalMatrix.GetAlias: TSignature;
begin
  Result := 'Cardinal';
end;

function TCardinalMatrix.GetVecElemI64(const Index: Integer): Int64;
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}     
  Result := PCardinalArray(FArray)[Index];
end;

procedure TCardinalMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Cardinal);
end;

procedure TCardinalMatrix.SetVecElemI64(const Index: Integer;
  const Value: Int64);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PCardinalArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemI64'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TDoubleMatrix }

class function TDoubleMatrix.GetAlias: TSignature;
begin
  Result := 'Double';
end;

function TDoubleMatrix.GetVecElem(const Index: Integer): Extended;
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    Result := PDoubleArray(FArray)[Index];
{$IFDEF MatrixCheckRange}
    Result := Result + 0.0;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecElem', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TDoubleMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(Double);
end;

procedure TDoubleMatrix.SetVecElem(const Index: Integer;
  const Value: Extended);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PDoubleArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElem', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end; 

{ TDoubleComplexMatrix }

class function TDoubleComplexMatrix.GetAlias: TSignature;
begin
  Result := 'DoubleCx';
end;

function TDoubleComplexMatrix.GetVecElemCx(
  const Index: Integer): TExtendedComplex;
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    Result.mReal := PDoubleComplexArray(FArray)[Index].mReal;
    Result.mImag := PDoubleComplexArray(FArray)[Index].mImag;
{$IFDEF MatrixCheckRange}
    Result.mReal := Result.mReal + 0.0;
    Result.mImag := Result.mImag + 0.0;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecElemCx', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TDoubleComplexMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(TDoubleComplex);
end;

procedure TDoubleComplexMatrix.SetVecElemCx(const Index: Integer;
  const Value: TExtendedComplex);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PDoubleComplexArray(FArray)[Index].mReal := Value.mReal;
    PDoubleComplexArray(FArray)[Index].mImag := Value.mImag;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemCx'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TFloatComplexMatrixClass }

procedure TFloatComplexMatrixClass.AssignDynElem(const Matrix: TMatrix;
  const SelfIndexes, MatrixIndexes: array of Integer);
begin
  SetComplex(SelfIndexes, Matrix.GetComplex(MatrixIndexes));
end;

procedure TFloatComplexMatrixClass.AssignElem(const Matrix: TMatrix;
  const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer);
begin
  ElemCx[SelfRow, SelfCol] := Matrix.ElemCx[MatrixRow, MatrixCol];
end;

procedure TFloatComplexMatrixClass.AssignVecElem(const Matrix: TMatrix;
  const SelfIndex, MatrixIndex: Integer);
begin
  SetVecElemCx(SelfIndex, Matrix.GetVecElemCx(MatrixIndex));
end;

function TFloatComplexMatrixClass.GetVecElem(
  const Index: Integer): Extended;
begin
  Result := VecElemCx[Index].mReal;
end;

function TFloatComplexMatrixClass.GetVecElemStr(const Index: Integer): string;
begin
  with VecElemCx[Index] do
  begin
    Result := FloatToStringFunction(mReal);
    if mImag < 0 then Result := Result + '-' else Result := Result + '+';
    Result := Result + FloatToStringFunction(Abs(mImag)) + ComplexImagSymbol;
  end;
end;

procedure TFloatComplexMatrixClass.Init;
begin
  inherited;
  FMatrixTypes := FMatrixTypes + [mtComplex];
end;

procedure TFloatComplexMatrixClass.SetVecElem(const Index: Integer;
  const Value: Extended);
begin
  VecElemCx[Index] := FloatComplex(Value, 0);
end;

procedure TFloatComplexMatrixClass.SetVecElemStr(const Index: Integer;
  const Value: string);
begin
  try
    VecElemCx[Index] := ComplexFromString(Value);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemStr'){$ENDIF}
  end;
end;

{ TSingleComplexMatrix }

class function TSingleComplexMatrix.GetAlias: TSignature;
begin
  Result := 'SingleCx';
end;

function TSingleComplexMatrix.GetVecElemCx(
  const Index: Integer): TExtendedComplex;
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    Result.mReal := PSingleComplexArray(FArray)[Index].mReal;
    Result.mImag := PSingleComplexArray(FArray)[Index].mImag;
{$IFDEF MatrixCheckRange}
    Result.mReal := Result.mReal + 0.0;
    Result.mImag := Result.mImag + 0.0;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecElemCx', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TSingleComplexMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(TSingleComplex);
end;

procedure TSingleComplexMatrix.SetVecElemCx(const Index: Integer;
  const Value: TExtendedComplex);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    PSingleComplexArray(FArray)[Index].mReal := Value.mReal;
    PSingleComplexArray(FArray)[Index].mImag := Value.mImag;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemCx'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TExtendedComplexMatrix }

class function TExtendedComplexMatrix.GetAlias: TSignature;
begin
  Result := 'ExtendedCx';
end;

function TExtendedComplexMatrix.GetVecElemCx(
  const Index: Integer): TExtendedComplex;
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
    Result := PExtendedComplexArray(FArray)[Index];
{$IFDEF MatrixCheckRange}
    Result.mReal := Result.mReal + 0.0;
    Result.mImag := Result.mImag + 0.0;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecElemCx', mkFunc){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

procedure TExtendedComplexMatrix.Init;
begin
  inherited;
  FElemSize := SizeOf(TExtendedComplex);
end;

procedure TExtendedComplexMatrix.SetVecElemCx(const Index: Integer;
  const Value: TExtendedComplex);
begin
{$IFDEF MatrixCheckRange}
  try
    CheckVecIndex(Index);
{$ENDIF MatrixCheckRange} 
    PExtendedComplexArray(FArray)[Index] := Value;
{$IFDEF MatrixCheckRange}
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecElemCx'){$ENDIF}
  end;
{$ENDIF MatrixCheckRange}
end;

{ TCommonMatrixClass }

{ TODO : PreservResize - ��������� �������� ������������� �� ��������� ���}
procedure TCommonMatrixClass.PreservResize(const DimValues: array of Integer);
var
  NewMatrix: TMatrix;
  SourCoords, DestCoords: TDynIntArray;
  SourLen, DestLen, Delta: Integer;


  procedure _AssignElems(const Dim: Integer);
  var
    I: Integer;
  begin
    if Dim >= Min(SourLen, DestLen) then Exit;

    if DestLen > SourLen then
      for I := 0 to Min(FDimensions[Dim], NewMatrix.FDimensions[Dim + Delta]) - 1 do
      begin
        SourCoords[Dim] := I;
        DestCoords[Dim + Delta] := I;

        _AssignElems(Dim + 1);

        NewMatrix.AssignDynElem(Self, DestCoords, SourCoords);
      end
    else
      for I := 0 to Min(FDimensions[Dim + Delta], NewMatrix.FDimensions[Dim]) - 1 do
      begin
        SourCoords[Dim + Delta] := I;
        DestCoords[Dim] := I;

        _AssignElems(Dim + 1);

        NewMatrix.AssignDynElem(Self, DestCoords, SourCoords);
      end
  end;

begin
  try
    SourLen := DimensionCount;
    DestLen := Length(DimValues);
    Delta := Abs(SourLen - DestLen);

    SetLength(SourCoords, SourLen);
    SetLength(DestCoords, DestLen);

    NewMatrix := CreateInstance;
    try
      NewMatrix.Resize(DimValues);
      NewMatrix.Zeros;

      if (SourLen > 0) and (NewMatrix.ElemCount > 0) then
        _AssignElems(0);

      MoveFrom(NewMatrix);

    finally
      NewMatrix.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'PreservResize'){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.Resize(const DimValues: array of Integer);
var
  NeedMem: Double;
  ElementsCount: Int64;
begin
  try
    CheckRef;

    if FIsCopyByRef then
      raise EMatrixRefError(matSIsCopyByRef);

    ElementsCount := ProdDimensions(DimValues);

    // ���������, ������ �� ������
    CheckMemoryForResize(ElementsCount);

    // �������� ������
    try
      ReallocMem(FArray, ElementsCount * FElemSize);
    except
      on E: EOutOfMemory do
      begin
        // ��������� ����������� ��������� "Out of memory" �� ����� �������������
        // ��������� ������� Matrix32. ���������� �� ReallocMem ����� ����������
        // ������ � ������, ���� ������� �� ������� ����� ����������� ����
        // ������ ��������� �������, ���� ��������� ��������� ������ ����������.
        NeedMem := ElementsCount * FElemSize;
        raise EMatrixMemoryError.CreateFmt(E.ClassName + ': ' + matSOutOfMemory,
          [NeedMem, AvailMemory]);
      end else
        raise;
    end;

    // ����������� �������
    SetDimValues(DimValues);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Resize'){$ENDIF}
  end;
end;


procedure TCommonMatrixClass.MoveFrom(Matrix: TMatrix);
var
  I, J: Integer;
begin
  try
    if Self = Matrix then Exit;

    if not Matrix.IsDynamic then
      raise EMatrixWrongElemType.Create(matSNotDynamicType);

    // ���� ����� ����� ������ � ��� �� ����� ������ � Matrix ������� �� ������...
    if Matrix.IsCopyByRef and IsEqualArraysSize([Self, Matrix]) and
      (ArrayAddress = Matrix.ArrayAddress) then
    begin
      Matrix.Clear;
      Exit;
    end;

    if FIsCopyByRef then
      Clear;

    // ���� ��� ����� ��, �� ������ ���������� ��� ������
    if IsSameMatrixClass([Self, Matrix]) then
    begin
      // ��� ������� ����� �� �� ����� ������ ��� ����� � ������� Resize([0])
      // � ������, ���� MoveFrom ������ �� PreservResize, ���������� �����������
      // ��������, � ��� ������� ����� ���������� ��� � Self, ��� � � Matrix
      if IsCell then
      begin
        // ������������� NIL �������� ������� Self, ���� ��� ������������
        // � ������� Matrix. ��� ���������� �������� NIL ������ �� ������������.
        for I := 0 to Self.ElemCount - 1 do
        begin
          for J := 0 to Matrix.ElemCount - 1 do
            if Self.VecCells[I] = Matrix.VecCells[J] then
            begin
              Self.VecCells[I] := nil;
              Break;
            end;
        end;
      end;

      // �������� ������ ������
      Resize([0]);


      // �������� ���� ������ ������
      ArrayAddress := Matrix.ArrayAddress;
      // ����������� ������� �������
      SetDimValues(Matrix.FDimensions);
      // �������� ������� �������
      Matrix.SetDimValues([0]);
    end else
    begin // ����� ������� �������� ������
      CopyFrom(Matrix);
      Matrix.Resize([0]);
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'MoveFrom'){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.CopyFrom(Matrix: TMatrix);
var
  I: Integer;
begin
  try
    if Self = Matrix then Exit;

    if not Matrix.IsDynamic then
      raise EMatrixWrongElemType.Create(matSNotDynamicType);

    Resize(Matrix.FDimensions);

    // ���� ������� ����������� ����, �� �������� � ������� Move
    if IsSameMatrixClass([Self, Matrix]) then
    begin
      Move(TNumericMatrixClass(Matrix).FArray^, FArray^, FArraySize);
    end else
      for I := 0 to FElemCount - 1 do
        AssignVecElem(Matrix, I, I); 
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CopyFrom'){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.CopyFrom(const Buffer: Pointer; const DimValues: array of Integer;
  LoaderClass: TMatrixClass = nil);
var
  Matrix: TMatrix;
begin
  try
    if LoaderClass = nil then
      LoaderClass := TMatrixClass(ClassType);

    // ������� ������ ���������� ������
    Matrix := LoaderClass.Create();
    try
      Matrix.ArrayAddress := Buffer;
      Matrix.SetDimValues(DimValues);
      Matrix.FIsCopyByRef := True;

      // �������� ������ � Self
      CopyFrom(Matrix);
    finally
      Matrix.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CopyFrom'){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.CopyByRef(Matrix: TMatrix);
begin
  try
    if Self = Matrix then Exit;

    if not Matrix.IsDynamic then
      raise EMatrixWrongElemType.Create(matSNotDynamicType);

    // ���� ��� ����� ��, �� �������� ���������
    if IsSameMatrixClass([Self, Matrix]) then
    begin
      if not FIsCopyByRef then Resize([0]);
      // �������� ���� ������ ������
      ArrayAddress := Matrix.ArrayAddress;
      // ������������� �������� ��������
      SetDimValues(Matrix.FDimensions);
      // ����������, ��� ���������� ������ �� ������
      FIsCopyByRef := True;
    end else // ����� ���������� ����������
      raise EMatrixWrongElemType.Create(matSMustHaveSameType);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CopyByRef'){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.CopyByRef(const Buffer: Pointer;
  const DimValues: array of Integer);
begin
  Clear;
  ArrayAddress := Buffer;
  SetDimValues(DimValues); 
  FIsCopyByRef := True;
end;

function TCommonMatrixClass.Zeros: TMatrix;
begin
  FillChar(FArray^, FArraySize, 0);
  Result := Self;
end;

function TCommonMatrixClass.GetArrayAddress: Pointer;
begin
  Result := FArray;
end;

procedure TCommonMatrixClass.SetArrayAddress(const Value: Pointer);
begin
  FArray := Value;
end;

procedure TCommonMatrixClass.SetDimValues(const DimValues: array of Integer);
var
  I, TempValue: Integer;
begin
  try
    FArraySize := ProdDimensions(DimValues) * FElemSize;
    FBeginOfArray := 0;
    FRows := 0;
    FCols := 0;

    // ���������� ����� �������
    if FArraySize = 0 then
    begin
      FDimensions := nil;
      FElemInDimensions := nil;
      FElemCount := 0;
      FArray := nil;
    end else
    begin
      SetLength(FDimensions, Length(DimValues));
      SetLength(FElemInDimensions, Length(DimValues) - 1);
      FElemCount := 1;
      for I := 0 to Length(DimValues) - 1 do
      begin
        FDimensions[I] := DimValues[I];
        FElemCount := FElemCount * DimValues[I];
      end;

      FCols := FDimensions[Length(FDimensions) - 1];
      if Length(FDimensions) > 1 then
        FRows := FDimensions[Length(FDimensions) - 2];

      TempValue := 1;
      for I := Length(FDimensions) - 1 downto 1 do
      begin
        TempValue := TempValue * FDimensions[I];
        FElemInDimensions[I - 1] := TempValue;
      end;

      if Length(FDimensions) > 2 then
        FBeginOfArray := FElemCount - FElemInDimensions[Length(FElemInDimensions) - 2];
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetDimValues'){$ENDIF}
  end;
end;

function TCommonMatrixClass.Transpose(const Matrix: TMatrix): TMatrix;
var
  TempMatrix: TMatrix;
  I, J, K, AIndex, BIndex: Integer;
begin
  try
    if not Matrix.IsDynamic then
      raise EMatrixWrongElemType.Create(matSNotDynamicType);

    case Matrix.DimensionCount of
      0: Clear;
      1:
        begin
          CopyFrom(Matrix);
          Reshape([Matrix.FElemCount, 1]);
        end;

      2, 3:
        begin
          TempMatrix := CreateInstance;
          try
            if Matrix.DimensionCount = 2 then // ���� ������ 2-������
            begin

              // �������� ������� �������. ��������� ���������� ������� ��������
              // �������, ������ �������� ������ ������ ����������
              TempMatrix.Resize([Matrix.FCols, Matrix.FRows]);

              // ���������� �������� ���������������� ��� 2-������ ������
              // �� ���� ���������� �������� ���������, ������������ � ������
              // AssignElem, �������������� ������� � �������� �� 10%
              AIndex := 0;
              for I := 0 to Matrix.FRows - 1 do
              begin
                BIndex := I;
                for J := 0 to Matrix.FCols - 1 do
                begin
                  TempMatrix.AssignVecElem(Matrix, BIndex, AIndex);
                  Inc(AIndex);
                  Inc(BIndex, Matrix.Rows);
                end;
              end;

            end else
            begin // ���� ������ 3-������
              TempMatrix.Resize([Matrix.FDimensions[0], Matrix.FCols, Matrix.FRows]);
              for K := 0 to Matrix.FDimensions[0] - 1 do
                for I := 0 to Matrix.FRows - 1 do
                  for J := 0 to Matrix.FCols - 1 do
                    TempMatrix.AssignDynElem(Matrix, [K, J, I], [K, I, J]);
            end;

            // ���������� ������ �� ���������� �������
            MoveFrom(TempMatrix);

          finally
            TempMatrix.FreeMatrix;
          end; 
        end;
    else // ������ ����� ����������� ������ 3-�.
      raise EMatrixDimensionsError.Create(matSDimNotValid);
    end;

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Transpose', mkFunc){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.Clear;
begin
  if FIsCopyByRef then
  begin
    ArrayAddress := nil;   // ��������� ����������� �������
    FIsCopyByRef := False; // ������ ���������� �������
  end;
  ReallocMem(FArray, 0);
  SetDimValues([0]); 
end;

function TCommonMatrixClass.DynElemAddress(const Indexes: array of Integer): Pointer;
begin
  Result := VecAddress(GetOrderNum(Indexes));
end;

function TCommonMatrixClass.ElemAddress(const Row, Col: Integer): Pointer;
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  Result := VecAddress(FBeginOfArray + Row * FCols + Col);
end;

function TCommonMatrixClass.VecAddress(Index: Integer): Pointer;
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
  Result := Pointer(Integer(FArray) + Index * FElemSize);
end;

function TCommonMatrixClass.Concat(DIM: Integer;
  const Matrices: array of TMatrix): TMatrix;
var
  I, J, DimCount: Integer;
  AMatrix: TMatrix;
begin
  try
    if not IsSameMatrixTypes(Matrices, [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);
    if Length(Matrices) = 0 then
      raise EMatrixBadParams.Create(matSBadInputData);

    DimCount := Matrices[0].DimensionCount;

    for I := 1 to Length(Matrices) - 1 do
      if Matrices[I].DimensionCount <> DimCount then
        raise EMatrixDimensionsError.Create(matSDifferentDimCount);

    if DIM >= DimCount then
      raise EMatrixDimensionsError.Create(matSDimNotValid);

    // ��������� �� ��, ����� ��� ����������� �� ����������� DIM ����� ���������� ������
    for I := 0 to DimCount - 1 do
      if I <> DIM then
        for J := 1 to Length(Matrices) - 1 do
          if Matrices[0].Dimension[I] <> Matrices[J].Dimension[I] then
            raise EMatrixDimensionsError.Create(matSArraysNotAgree);

    AMatrix := CreateInstance;
    try
      for I := 0 to Length(Matrices) - 1 do
        TCommonMatrixClass(AMatrix).DoConcat(DIM, Matrices[I]);  
      MoveFrom(AMatrix);
    finally
      AMatrix.FreeMatrix;
    end;

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Concat', mkFunc){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.DoConcat(Dim: Integer; Matrix: TMatrix);
var
  SelfCoords, MatrixCoords: TDynIntArray;
  SelfLen, OldDimValue: Integer;

  {�������� �������� ������� Matrix � Self}
  procedure _AssignElems(DimValue: Integer);
  var
    I: Integer;
  begin
    if DimValue >= SelfLen then Exit;

    for I := 0 to Matrix.FDimensions[DimValue] - 1 do
    begin
      MatrixCoords[DimValue] := I;

      if DimValue <> Dim then
        SelfCoords[DimValue] := I
      else
        SelfCoords[DimValue] := OldDimValue + I;

      _AssignElems(DimValue + 1);

      AssignDynElem(Matrix, SelfCoords, MatrixCoords);
    end;
  end;
begin
  try
    if IsEmpty then
      CopyFrom(Matrix)
    else
    begin
      SelfLen := DimensionCount;
      SetLength(SelfCoords, SelfLen);
      SetLength(MatrixCoords, SelfLen);

      OldDimValue := Dimension[Dim];
      Dimension[Dim] := Dimension[Dim] + Matrix.Dimension[Dim];
      _AssignElems(0);
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'DoConcat'){$ENDIF}
  end;
end;

function TCommonMatrixClass.IsEmpty: Boolean;
begin
  Result := FElemCount = 0;
end;

function TCommonMatrixClass.CopyArrayPart(AMatrix: TMatrix;
  const LoIntervals, IntervalsLen: array of Integer; UseLenAsHigh,
  CopyDataInIntervals: Boolean): TMatrix;
var
  I, DimLen: Integer;
  CorrectIntervalsLen, DimValues, MatrixCoords, TempCoords: TDynIntArray;
  TempMatrix: TMatrix;

  procedure _AssignElems(const Dim: Integer);
  var
    I, MatrixIndex: Integer;
  begin
    if Dim >= DimLen then // ���� Dim ��������� ����� ��������� DimLen
      Exit;

    if CopyDataInIntervals then
      MatrixIndex := LoIntervals[Dim]
    else
      MatrixIndex := 0;

    for I := 0 to DimValues[Dim] - 1 do
    begin
      TempCoords[Dim] := I;

      if not CopyDataInIntervals then // ���� ���������� ������ ��� ���������
      begin
        if MatrixIndex = LoIntervals[Dim] then
          MatrixIndex := CorrectIntervalsLen[Dim] + 1;
        // ���� � ����������� Dim ��� �������� � �������� MatrixIndex, ��
        // ����������� ������� ������
        if MatrixIndex >= AMatrix.FDimensions[Dim] then
          MatrixIndex := 0;
      end;

      MatrixCoords[Dim] := MatrixIndex;

      _AssignElems(Dim + 1);

      TempMatrix.AssignDynElem(AMatrix, TempCoords, MatrixCoords);

      Inc(MatrixIndex);
    end;
  end;

begin

  try
    AMatrix.CheckRef;

    // ��������� ����� �������� ������ ����������
    if (Length(LoIntervals) <> Length(AMatrix.FDimensions)) or
       (Length(IntervalsLen) <> Length(AMatrix.FDimensions)) then
      raise EMatrixBadParams.Create(matSBadInputData);

    // ��������� ������������ ������ ������
    for I := 0 to Length(LoIntervals) - 1 do
      if (LoIntervals[I] < 0) or ((LoIntervals[I] >= AMatrix.FDimensions[I]) and CopyDataInIntervals) then
        raise EMatrixBadParams.Create(matSDimIntervError);

    CorrectIntervalsLen := ConvertToDynIntArray(IntervalsLen);

    // ������������ ������� ������� ����������
    for I := 0 to Length(CorrectIntervalsLen) - 1 do
      if CorrectIntervalsLen[I] = -1 then
        CorrectIntervalsLen[I] := AMatrix.FDimensions[I] - 1
      else if not UseLenAsHigh then
        CorrectIntervalsLen[I] := LoIntervals[I] + CorrectIntervalsLen[I] - 1;

    // ��������� ������� �������
    for I := 0 to Length(CorrectIntervalsLen) - 1 do
      if (CopyDataInIntervals and (CorrectIntervalsLen[I] < LoIntervals[I])) or
        (not CopyDataInIntervals and (CorrectIntervalsLen[I] < LoIntervals[I] - 1)) or
        (CorrectIntervalsLen[I] >= AMatrix.FDimensions[I]) then
        raise EMatrixBadParams.Create(matSDimIntervError);

    SetLength(DimValues, Length(IntervalsLen));

    // ��������� �������� ������������ ��� ��������������� �������
    for I := 0 to Length(CorrectIntervalsLen) - 1 do
    begin
      DimValues[I] := CorrectIntervalsLen[I] - LoIntervals[I] + 1;
      if not CopyDataInIntervals then
      begin
        DimValues[I] := AMatrix.FDimensions[I] - DimValues[I];
        if DimValues[I] = 0 then
          DimValues[I] := 1;
      end;
    end;

    DimLen := Length(DimValues);
    SetLength(MatrixCoords, DimLen);
    SetLength(TempCoords, DimLen);

    TempMatrix := CreateInstance;
    try
      TempMatrix.Resize(DimValues);
      TempMatrix.Zeros;

      if not TempMatrix.IsEmpty then
        _AssignElems(0);

      MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;

    Result := Self;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CopyArrayPart', mkFunc){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.LoadFromStreamEx(AStream: TStream);
var
  LoaderClass: TMatrixClass;
  ByteBuf: Byte;
  EndPosition: Int64;
  Alias: string;
  Idx, IntBuf: Integer;
  DimValues: TDynIntArray;
begin

  try
    // ��������� ��� �������
    ReadMatrixNameFromStream(AStream);

    // ��������� ����� ����� ������ �������
    AStream.Read(EndPosition, SizeOf(EndPosition));
    if AStream.Size < EndPosition then
      raise EMatrixFunctionError.Create(matSFunctionError);

    // ���������� ��������� ������ �������
    AStream.Read(ByteBuf, SizeOf(ByteBuf));
    if (ByteBuf < 1) or (ByteBuf > MaxSignatureLength) then
      raise EMatrixAliasError(matSAliasError);

    AStream.Seek(ByteBuf, soFromCurrent);

    // ��������� ��������� ������������ ������
    Alias := ReadMatrixNameFromStream(AStream);
    if (Length(Alias) < 1) or (Length(Alias) > MaxSignatureLength) then
      raise EMatrixAliasError(matSAliasError);

    // ���������, ��������������� �� ��������� ��������� � ������ MatrixClassList
    Idx := MatrixClassList.IndexOf(Alias);
    if Idx < 0 then
      raise EMatrixClassError.CreateFmt(matSClassNotFound, [Alias]);

    // ���������� ����������� �����
    LoaderClass := TMatrixClass(MatrixClassList.Objects[Idx]);

    // ��������� ���-�� ������������
    AStream.Read(IntBuf, SizeOf(IntBuf));
    if (IntBuf < 0) or (IntBuf > StreamMaxDimensions) then
      raise EMatrixDimensionsError.Create(matSDimNotValid);

    // ��������� �������� ������������
    SetLength(DimValues, IntBuf);
    if IntBuf > 0 then
      AStream.Read(DimValues[0], IntBuf * SizeOf(Integer));

    // ��������� �������� ������� �� ������
    LoadFromStream(AStream, DimValues, LoaderClass);

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'LoadFromStreamEx'){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.SaveToStreamEx(AStream: TStream;
  AName: TMatrixName; SaverClass: TMatrixClass);
var
  ASaver: TMatrix;
  IntBuf: Integer;
  MatrixSizePos, CurrentPos, Int64Buf: Int64;
begin

  try

    ASaver := Self;
    if (SaverClass <> Self.ClassType) and (SaverClass <> nil) then
      ASaver := SaverClass.Create;

    try
      if not ASaver.IsNumeric then
        raise EMatrixWrongElemType.Create(matSNotNumericType);

      // ��������� ��� �������
      if AName = '' then
        AName := MatrixName;

      WriteMatrixNameToStream(AName, AStream);

      // ��������� ����� ��� ����� ��������� ���������
      MatrixSizePos := AStream.Position;
      Int64Buf := 0; // �� ������ ������ ��������� ��� �������� � ����
      AStream.Write(Int64Buf, SizeOf(Int64Buf));

      // ��������� ��������� ������ �������
      WriteMatrixNameToStream(string(GetAlias), AStream);

      // ��������� ��������� ������ ������������ �������
      WriteMatrixNameToStream(string(ASaver.GetAlias), AStream);

      // ��������� ���-�� ������������
      IntBuf := DimensionCount;
      AStream.Write(IntBuf, SizeOf(IntBuf));

      // ��������� �������� ������������
      if IntBuf > 0 then
        AStream.Write(FDimensions[0], IntBuf * SizeOf(IntBuf));

      if ASaver <> Self then
        ASaver.CopyFrom(Self);

      // ��������� �������� ������� � �����
      if ASaver.FArraySize > 0 then
        AStream.Write(TNumericMatrixClass(ASaver).FArray^, ASaver.FArraySize);

      // ���������� ������� �������
      CurrentPos := AStream.Position;

      // ���������� �������� CurrentPos ����� ����� ����� �������
      AStream.Position := MatrixSizePos;
      AStream.Write(CurrentPos, SizeOf(CurrentPos));

      // ��������������� ������� �������
      AStream.Position := CurrentPos;

    finally
      if ASaver <> Self then
        ASaver.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SaveToStreamEx'){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.LoadFromStream(AStream: TStream;
  const DimValues: array of Integer; LoaderClass: TMatrixClass);
begin
  try
    if (LoaderClass <> Self.ClassType) and (LoaderClass <> nil) then
    begin
      with LoaderClass.Create() do
      try
        LoadFromStream(AStream, DimValues, nil);
        Self.MoveFrom(ThisMatrix);
      finally
        Free;
      end;
    end else
    begin
      Clear; // ��������������� ������� ���������� �������
      Resize(DimValues);
      Zeros; // ��������, �.�. ����� Resize ����� ��������� �� ����� � ������
      AStream.Read(ArrayAddress^, FArraySize);
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'LoadFromStream'){$ENDIF}
  end;
end;

procedure TCommonMatrixClass.SaveToStream(AStream: TStream;
  SaverClass: TMatrixClass);
begin
  try
    if (SaverClass <> Self.ClassType) and (SaverClass <> nil) then
    begin
      with SaverClass.Create() do
      try
        CopyFrom(Self);
        SaveToStream(AStream, nil);
      finally
        Free;
      end;
    end else
      AStream.Write(ArrayAddress^, FArraySize);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SaveToStream'){$ENDIF}
  end;
end;

{ TObjectMatrixClass }

procedure TObjectMatrixClass.AssignDynElem(const Matrix: TMatrix;
  const SelfIndexes, MatrixIndexes: array of Integer);
begin
  if not Matrix.IsObject then
    raise CreateExceptObject(EMatrixWrongElemType, matSNotObjectType, 'AssignDynElem');
  SetObject(SelfIndexes, Matrix.GetObject(MatrixIndexes));
end;

procedure TObjectMatrixClass.AssignElem(const Matrix: TMatrix;
  const SelfRow, SelfCol, MatrixRow, MatrixCol: Integer);
begin
  if not Matrix.IsObject then
    raise CreateExceptObject(EMatrixWrongElemType, matSNotObjectType, 'AssignElem');
  Objects[SelfRow, SelfCol] := Matrix.Objects[MatrixRow, MatrixCol];
end;

procedure TObjectMatrixClass.AssignVecElem(const Matrix: TMatrix;
  const SelfIndex, MatrixIndex: Integer);
begin
  if not Matrix.IsObject then
    raise CreateExceptObject(EMatrixWrongElemType, matSNotObjectType, 'AssignVecElem');
  VecObjects[SelfIndex] := Matrix.VecObjects[MatrixIndex];
end;

procedure TObjectMatrixClass.CopyByRef(Matrix: TMatrix);
begin
  if not Matrix.IsObject then
    raise CreateExceptObject(EMatrixWrongElemType, matSNotObjectType, 'CopyByRef');
  inherited;
end;

procedure TObjectMatrixClass.CopyFrom(Matrix: TMatrix);
begin
  if not Matrix.IsObject then
    raise CreateExceptObject(EMatrixWrongElemType, matSNotObjectType, 'CopyFrom');
  inherited;
end;

procedure TObjectMatrixClass.CopyFrom(const Buffer: Pointer;
  const DimValues: array of Integer; LoaderClass: TMatrixClass);
begin
  raise CreateAbstractErrorObj('CopyFrom');
end;

procedure TObjectMatrixClass.DeleteObjects;
var
  I: Integer;
begin
  for I := 0 to ElemCount - 1 do
    VecObjects[I].Free;

  Zeros;
end;

class function TObjectMatrixClass.GetAlias: TSignature;
begin
  Result := 'Object';
end;

function TObjectMatrixClass.GetObject(const Indexes: array of Integer): TObject;
begin
  Result := VecObjects[GetOrderNum(Indexes)];
end;

function TObjectMatrixClass.GetVecObjects(const Index: Integer): TObject;
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}
  Result := PPointerArray(FArray)[Index];
end;

function TObjectMatrixClass.Get_Objects(const Row, Col: Integer): TObject;
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  Result := VecObjects[FBeginOfArray + Row * FCols + Col];
end;

procedure TObjectMatrixClass.Init;
begin
  inherited;
  FElemSize := SizeOf(TObject);
  FMatrixTypes := FMatrixTypes + [mtObject];
end;

procedure TObjectMatrixClass.MoveFrom(Matrix: TMatrix);
begin
  if not Matrix.IsObject then
    raise CreateExceptObject(EMatrixWrongElemType, matSNotObjectType, 'MoveFrom');

  inherited;
end;

procedure TObjectMatrixClass.SetObject(const Indexes: array of Integer;
  const Value: TObject);
begin
  VecObjects[GetOrderNum(Indexes)] := Value;
end;

procedure TObjectMatrixClass.SetVecObjects(const Index: Integer;
  const Value: TObject);
begin
{$IFDEF MatrixCheckRange}
  CheckVecIndex(Index);
{$ENDIF MatrixCheckRange}

  if Value = Self then
    raise CreateExceptObject(EMatrixError, matSIsRefToSelf, 'SetVecObjects');

  PPointerArray(FArray)[Index] := Value;
end;

procedure TObjectMatrixClass.Set_Objects(const Row, Col: Integer;
  const Value: TObject);
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  VecObjects[FBeginOfArray + Row * FCols + Col] := Value;
end;

function TObjectMatrixClass.Transpose(const Matrix: TMatrix): TMatrix;
begin
  if not Matrix.IsObject then
    raise CreateExceptObject(EMatrixWrongElemType, matSNotObjectType, 'Transpose');

  Result := inherited Transpose(Matrix);
end;

{ TCellMatrix }

procedure TCellMatrix.AssignDynElem(const Matrix: TMatrix;
  const SelfIndexes, MatrixIndexes: array of Integer);
begin
  try
    if not Matrix.IsCell then
      raise EMatrixWrongElemType.Create(matSNotCellType);

    SetCell(SelfIndexes, Matrix.GetCell(MatrixIndexes));
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'AssignDynElem'){$ENDIF}
  end;
end;

procedure TCellMatrix.AssignElem(const Matrix: TMatrix; const SelfRow,
  SelfCol, MatrixRow, MatrixCol: Integer);
begin
  try
    if not Matrix.IsCell then
      raise EMatrixWrongElemType.Create(matSNotCellType);

    Cells[SelfRow, SelfCol] := Matrix.Cells[MatrixRow, MatrixCol];
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'AssignElem'){$ENDIF}
  end;
end;

procedure TCellMatrix.AssignVecElem(const Matrix: TMatrix; const SelfIndex,
  MatrixIndex: Integer);
begin
  try
    if not Matrix.IsCell then
      raise EMatrixWrongElemType.Create(matSNotCellType);

    VecCells[SelfIndex] := Matrix.VecCells[MatrixIndex];
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'AssignVecElem'){$ENDIF}
  end;
end;

procedure TCellMatrix.CopyFrom(Matrix: TMatrix);
begin
  try
    if Self = Matrix then Exit;
    if not Matrix.IsCell then
      raise EMatrixWrongElemType.Create(matSNotCellType);

    {������ ����� Matrix ����� ��������� ��� �������, ��� � ������ ������
     � ��� ��� ������ ������ ���� ����������� � ������ ������}

    with Matrix.CreateCopy do
    try
      Self.MoveFrom(ThisMatrix);
    finally
      Free;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CopyFrom'){$ENDIF}
  end;
end;

class function TCellMatrix.GetAlias: TSignature;
begin
  Result := 'Cell';
end;

function TCellMatrix.GetMatrixSize: Integer;
var
  I: Integer;
  Obj: TMatrix;
begin
  Result := 0;
  for I := 0 to ElemCount - 1 do
  begin
    Obj := VecCells[I];
    if Obj.IsLiving then
      Result := Result + Obj.MatrixSize;
  end;

  // ���������� ����������� ������
  Result := Result + FArraySize;

  // ���� Result < 0, ������ �� ����������� � �������������
  if Result < 0 then
    raise EMatrixMemoryError.CreateFmt('ArraySize=%d', [Result]);
end;

function TCellMatrix.GetCell(const Indexes: array of Integer): TMatrix;
begin
  Result := VecCells[GetOrderNum(Indexes)];
end;

function TCellMatrix.CreateCopy(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix;
var
  I: Integer;
  Obj: TMatrix;
begin
  try
    Result := CreateInstance(AOwner, AName);
    Result.Resize(FDimensions);

    for I := 0 to ElemCount - 1 do
    begin
      Obj := VecCells[I];
      if Assigned(Obj) then
      begin
        Result.VecCells[I] := Obj.CreateCopy;
        Result.VecCells[I].AddNotifyClient(Result);
      end;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CreateCopy', mkFunc){$ENDIF}
  end;
end;

function TCellMatrix.GetVecCells(const Index: Integer): TMatrix;
begin
  try
    Result := TMatrix(VecObjects[Index]);
    if Assigned(Result) then
      Result.CheckRef;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetVecCells', mkFunc){$ENDIF}
  end
end;

function TCellMatrix.Get_Cells(const Row, Col: Integer): TMatrix;
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  Result := VecCells[FBeginOfArray + Row * FCols + Col];
end;

procedure TCellMatrix.Init;
begin
  inherited;
  FMatrixTypes := FMatrixTypes + [mtCell];
end;

procedure TCellMatrix.Resize(const DimValues: array of Integer);
begin
  try
    if IsCopyByRef then
      raise EMatrixRefError.Create(matSIsCopyByRef);

    // ������� ��� ������������ ��������
    if Assigned(FArray) then
      DeleteObjects;

    // �������� ������� �������
    inherited;

    // �������� �������� �������
    Zeros;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Resize'){$ENDIF}
  end;
end;

procedure TCellMatrix.LoadFromStreamEx(AStream: TStream);
var
  ByteBuf: Byte;
  Int64Buf, CurrentPos: Int64;
  S, Alias: string;
  DimValues: TDynIntArray;
  DimCount, I, Idx: Integer;
  AMatrix: TMatrix;
  LoaderClass: TMatrixClass;
begin
  try
    // ��������� ��� �������
    ReadMatrixNameFromStream(AStream);

    // ���������� ����� ��������� �������
    AStream.Read(Int64Buf, SizeOf(Int64Buf));

    if AStream.Size < Int64Buf then
      raise EMatrixFunctionError.Create(matSFunctionError);

    // ��������� ���������
    S := ReadMatrixNameFromStream(AStream);
    // ��������� ��������� - ��������
    ReadMatrixNameFromStream(AStream);

    // ��������� ������������ �������
    if not AnsiSameText(string(GetAlias), S) then
      raise EMatrixAliasError.Create(matSAliasError);

    // ��������� �������� ������������
    AStream.Read(DimCount, SizeOf(DimCount));
    if (DimCount < 0) or (DimCount > StreamMaxDimensions) then
      raise EMatrixDimensionsError.Create(matSDimNotValid);

    SetLength(DimValues, DimCount);
    if DimCount > 0 then
      AStream.Read(DimValues[0], DimCount * SizeOf(Integer));

    // ������� ���������� ������� �����
    Clear;
    
    // ������������� �������� �������
    Resize(DimValues);

    // ��������� ���������� ����� �������
    for I := 0 to ElemCount - 1 do
    begin
      AStream.Read(ByteBuf, SizeOf(ByteBuf));
      if ByteBuf = 1 then
      begin
        CurrentPos := AStream.Position;

        // ��������� ��� ������
        S := ReadMatrixNameFromStream(AStream);

        // ���������� ����� ����� �������
        AStream.Seek(SizeOf(Int64), soFromCurrent);

        // ��������� ���������
        Alias := ReadMatrixNameFromStream(AStream);

        Idx := MatrixClassList.IndexOf(Alias);
        if Idx < 0 then
          raise EMatrixClassError.CreateFmt(matSClassNotFound, [Alias]);

        LoaderClass := TMatrixClass(MatrixClassList.Objects[Idx]);

        AStream.Position := CurrentPos;

        AMatrix := LoaderClass.Create(nil, S);
        AMatrix.LoadFromStreamEx(AStream);

        VecCells[I] := AMatrix;
      end;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'LoadFromStreamEx'){$ENDIF}
  end;
end;

procedure TCellMatrix.SaveToStreamEx(AStream: TStream; AName: TMatrixName;
  SaverClass: TMatrixClass);
var
  ByteBuf: Byte;
  Int64Buf, EndAddressPos: Int64;
  DimCount, I: Integer;
  AMatrix: TMatrix;
begin
  try
    if AName = '' then
      AName := MatrixName;

    // ���������� ��� �������
    WriteMatrixNameToStream(AName, AStream);

    // ���������� �������, ���� ����� ���������� ������ ���������
    EndAddressPos := AStream.Position;
    Int64Buf := 0;
    AStream.Write(Int64Buf, SizeOf(Int64Buf));

    // ���������� ���������
    WriteMatrixNameToStream(string(GetAlias), AStream);
    // ���������� ��������� - ��������
    WriteMatrixNameToStream('', AStream);

    // ���������� �������� ������������ �������
    DimCount := DimensionCount;
    AStream.Write(DimCount, SizeOf(DimCount));
    if DimCount > 0 then
      AStream.Write(FDimensions[0], DimCount * SizeOf(Integer));

    // ���������� � ����� ������ �������
    for I := 0 to FElemCount - 1 do
    begin
      ByteBuf := 0;

      // ���� ������� ������ �� ����������, �� ����� ����
      AMatrix := VecCells[I];
      if AMatrix = nil then
        AStream.Write(ByteBuf, SizeOf(ByteBuf))
      else
      begin
        ByteBuf := 1; // ������� ������ ����������
        AStream.Write(ByteBuf, SizeOf(ByteBuf));

        // ���������� ��������� ������ � �����
        AMatrix.SaveToStreamEx(AStream);
      end;
    end; // of for

    // ���������� ������� ���������
    Int64Buf := AStream.Position;

    // ���������� ������ �������� � EndAddressPos
    AStream.Position := EndAddressPos;
    AStream.Write(Int64Buf, SizeOf(Int64Buf));

    AStream.Position := Int64Buf;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SaveToStreamEx'){$ENDIF}
  end;
end;

procedure TCellMatrix.SetCell(const Indexes: array of Integer;
  const Value: TMatrix);
begin
  VecCells[GetOrderNum(Indexes)] := Value;
end;

procedure TCellMatrix.SetVecCells(const Index: Integer;
  const Value: TMatrix);
var
  AMatrix: TMatrix;
begin
  try

    {��������� ��������� ��������� ��� ������� �����, ����������� �� ������}
    if IsCopyByRef then
      raise EMatrixRefError.Create(matSCanNotWriteCell);

    if Assigned(Value) then
    begin
      if Value.IsWorkspace then
        raise EMatrixRefError.Create(matSIsRefToWorkspace);
    end;

    AMatrix := VecCells[Index];
    if AMatrix = Value then Exit;

    if Assigned(AMatrix) then
      if GetCellsCount(AMatrix) = 1 then
        if Value = nil then
          AMatrix.DeleteNotifyClient(Self)
        else
          AMatrix.FreeMatrix;

    VecObjects[Index] := Value;

    // �������, ����� ������ ������� � ����� ��������
    if Value <> nil then
      Value.AddNotifyClient(Self);

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetVecCells'){$ENDIF}
  end;
end;

procedure TCellMatrix.Set_Cells(const Row, Col: Integer;
  const Value: TMatrix);
begin
{$IFDEF MatrixCheckRange}
  CheckRowAndCol(Row, Col);
{$ENDIF MatrixCheckRange}
  VecCells[FBeginOfArray + Row * FCols + Col] := Value;;
end;

procedure TCellMatrix.DeleteObjects;
var
  I: Integer;
  AMatrix: TMatrix;
begin
  try
    for I := 0 to ElemCount - 1 do
    begin
      AMatrix := VecCells[I];
      if Assigned(AMatrix) then
        if FIsCopyByRef then
          AMatrix.DeleteNotifyClient(Self)
        else
          AMatrix.FreeMatrix;
    end;

    if not IsCopyByRef then
      Zeros;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'DeleteObjects'){$ENDIF}
  end;
end;

function TCellMatrix.ThisCell: TMatrix;
begin
  Result := Self;
end;

procedure TCellMatrix.DeletionNotify(AMatrix: TMatrix);
var
  I: Integer;
begin
  try
    if IsCopyByRef then Exit;
    AMatrix.CheckRef;
    for I := 0 to ElemCount - 1 do
      if VecCells[I] = AMatrix then
        VecObjects[I] := nil;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'DeletionNotify'){$ENDIF}
  end;
end;

procedure TCellMatrix.Clear;
begin
  DeleteObjects;
  inherited;   
end;

procedure TCellMatrix.MoveFrom(Matrix: TMatrix);
var
  I: Integer;
  AMatrix: TMatrix;
begin
  inherited;

  for I := 0 to ElemCount - 1 do
  begin
    AMatrix := VecCells[I];
    if Assigned(AMatrix) then
    begin
      AMatrix.DeleteNotifyClient(Matrix);
      AMatrix.AddNotifyClient(Self);
    end;
  end;
end;

function TCellMatrix.GetCellsCount(AMatrix: TMatrix): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ElemCount - 1 do
    if VecCells[I] = AMatrix then
      Inc(Result);
end;

{ TRecordMatrix }

procedure TRecordMatrix.Clear;
var
  I: Integer;
  AMatrix: TMatrix;
begin
  try
    FieldListCriticalSection.Enter;
    try
      for I := FFieldList.Count - 1 downto 0 do
      begin
        AMatrix := FieldByIndex(I);
        if FIsCopyByRef then
          AMatrix.DeleteNotifyClient(Self)
        else
          AMatrix.FreeMatrix;
      end;

      FFieldList.Clear;
    finally
      FieldListCriticalSection.Leave;
    end;
    FIsCopyByRef := False;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Clear'){$ENDIF}
  end;
end;

procedure TRecordMatrix.CopyByRef(Matrix: TMatrix);
var
  I: Integer;
begin
  try
    if Self = Matrix then Exit;
    if not Matrix.IsRecord then
      raise EMatrixWrongElemType.Create(matSNotRecordType);

    Clear;

    FieldListCriticalSection.Enter;
    try
      FFieldList.Assign(TRecordMatrix(Matrix).FFieldList);
      for I := 0 to FieldCount - 1 do
        FieldByIndex(I).AddNotifyClient(Self);
    finally
      FieldListCriticalSection.Leave;
    end; 

    FIsCopyByRef := True;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CopyByRef'){$ENDIF}
  end;
end;

procedure TRecordMatrix.CopyFrom(Matrix: TMatrix);
var
  I: Integer;
  AList: TStringList;
begin
  try
    if Self = Matrix then Exit;
    if not Matrix.IsRecord then
      raise EMatrixWrongElemType.Create(matSNotRecordType);

    Clear;

    FieldListCriticalSection.Enter;
    try
      AList := TRecordMatrix(Matrix).FFieldList;
      for I := 0 to AList.Count - 1 do
        Fields[AList[I]] := Matrix.FieldByIndex(I).CreateCopy;
    finally
      FieldListCriticalSection.Leave;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'CopyFrom'){$ENDIF}
  end;
end;

destructor TRecordMatrix.Destroy;
begin
  {�������� inherited ������, ��� ��� ��� ���������� ����� Clear, � �������
   ���� ��������� � ��������� ������ FFieldList}
  inherited;
  FreeAndNil(FFieldList);
end;

class function TRecordMatrix.GetAlias: TSignature;
begin
  Result := 'Record';
end;

function TRecordMatrix.GetMatrixSize: Integer;
var
  I: Integer;
  Obj: TMatrix;
begin
  Result := 0;
  for I := 0 to FieldCount - 1 do
  begin
    Obj := FieldByIndex(I);
    if Obj.IsLiving then
      Result := Result + Obj.MatrixSize;
  end;

  // ���� Result < 0, ������ �� ����������� � �������������
  if Result < 0 then
    raise EMatrixMemoryError.CreateFmt('ArraySize=%d', [Result]);
end;

function TRecordMatrix.CreateCopy(AOwner: TMatrix = nil; const AName: TMatrixName = ''): TMatrix;
var
  I: Integer;
begin
  Result := CreateInstance(AOwner, AName);

  FieldListCriticalSection.Enter;
  try
    for I := 0 to FieldCount - 1 do
      Result.Fields[FFieldList[I]] := FieldByIndex(I).CreateCopy;
  finally
    FieldListCriticalSection.Leave;
  end;
end;

function TRecordMatrix.GetFields(const AName: TMatrixName): TMatrix;
begin
  try
    Result := FindField(AName);
    if Result = nil then
      raise EMatrixError.CreateFmt(matSRecordFieldIsNil, [AName]);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'GetFields', mkFunc){$ENDIF}
  end;
end;

procedure TRecordMatrix.Init;
begin  
  FMatrixTypes := FMatrixTypes + [mtRecord];
end;

function TRecordMatrix.IsEmpty: Boolean;
begin
  FieldListCriticalSection.Enter;
  try
    Result := FFieldList.Count = 0;
  finally
    FieldListCriticalSection.Leave;
  end;
end;

procedure TRecordMatrix.MoveFrom(Matrix: TMatrix);
var
  I: Integer;
begin
  try
    if Self = Matrix then Exit;
    if not Matrix.IsRecord then
      raise EMatrixWrongElemType.Create(matSNotRecordType);

    Clear;

    FieldListCriticalSection.Enter;
    try
      FFieldList.Assign(TRecordMatrix(Matrix).FFieldList);
      for I := FFieldList.Count - 1 downto 0 do
        FieldByIndex(I).AddNotifyClient(Self);
    finally
      FieldListCriticalSection.Leave;
    end;  

    Matrix.IsCopyByRef := True;
    Matrix.Clear;
    Matrix.IsCopyByRef := False;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'MoveFrom'){$ENDIF}
  end;
end;

procedure TRecordMatrix.LoadFromStreamEx(AStream: TStream);
var
  S, Alias: string;
  LoaderClass: TMatrixClass;
  EndPosition, CurrentPos, Int64Buf: Int64;
  Idx: Integer;
begin
  try
    // ���������� ��� �������
    ReadMatrixNameFromStream(AStream);

    // ��������� ����� ����� ������ �������
    AStream.Read(EndPosition, SizeOf(EndPosition));
    if AStream.Size < EndPosition then
      raise EMatrixFunctionError.Create(matSFunctionError);

    // ��������� ��������� ������
    Alias := ReadMatrixNameFromStream(AStream);
    if (Length(Alias) < 1) or (Length(Alias) > MaxSignatureLength) then
      raise EMatrixAliasError.Create(matSAliasError);

    // ��������� ������������ �������
    if not AnsiSameText(string(GetAlias), Alias) then
      raise EMatrixAliasError.Create(matSAliasError);

    // ��������� ���������-��������
    ReadMatrixNameFromStream(AStream);

    Clear;

    while AStream.Position < EndPosition do
    begin
      CurrentPos := AStream.Position;

      // ��������� ��� ���� ������
      S := ReadMatrixNameFromStream(AStream);

      // ���������� ����� ����� ���� ������
      AStream.Read(Int64Buf, SizeOf(Int64Buf));

      if not MatrixNameIsValid(S) then
        raise EMatrixBadName.CreateFmt(matSBadName, [S]);

      // ��������� ��������� ������
      Alias := ReadMatrixNameFromStream(AStream);

      Idx := MatrixClassList.IndexOf(Alias);
      if Idx < 0 then
        raise EMatrixClassError.CreateFmt(matSClassNotFound, [Alias]);

      LoaderClass := TMatrixClass(MatrixClassList.Objects[Idx]);

      // ������������ � ������ �������� �������
      AStream.Position := CurrentPos;

      Fields[S] := LoaderClass.Create;
      Fields[S].LoadFromStreamEx(AStream);
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'LoadFromStreamEx'){$ENDIF}
  end;
end;

procedure TRecordMatrix.SaveToStreamEx(AStream: TStream;
  AName: TMatrixName; SaverClass: TMatrixClass);
var
  Int64Buf, Int64BufPos: Int64;
  I: Integer;
begin
  try

    // ���������� ��� �������
    if AName = '' then
      AName := MatrixName;

    WriteMatrixNameToStream(AName, AStream);

    // ����������� ����� ��� ������� ���������
    Int64BufPos := AStream.Position;
    Int64Buf := 0;
    AStream.Write(Int64Buf, SizeOf(Int64Buf));

    // ���������� ���������
    WriteMatrixNameToStream(string(GetAlias), AStream);
    // ���������� ���������-��������
    WriteMatrixNameToStream('', AStream);

    // ���������� ��������������� ��� ���� ������
    FieldListCriticalSection.Enter;
    try
      for I := 0 to FieldCount - 1 do
        FieldByIndex(I).SaveToStreamEx(AStream, FFieldList[I]);
    finally
      FieldListCriticalSection.Leave;
    end;                              

   // ���������� ����� ����� ���������
   Int64Buf := AStream.Position;
   AStream.Position := Int64BufPos;
   AStream.Write(Int64Buf, SizeOf(Int64Buf));
   AStream.Position := Int64Buf;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SaveToStreamEx'){$ENDIF}
  end;
end;

procedure TRecordMatrix.SetFields(const AName: TMatrixName;
  const Value: TMatrix);
var
  Index: Integer;
  AMatrix: TMatrix;
begin
  try
    if Assigned(Value) then
    begin
      Value.CheckRef;
      if Value.IsWorkspace then
        raise EMatrixRefError.Create(matSIsRefToWorkspace);
      if Value = Self then
        raise EMatrixRefError.Create(matSIsRefToSelf);
    end;

    if not MatrixNameIsValid(AName) then
      raise EMatrixBadName.CreateFmt(matSBadName, [AName]);

    FieldListCriticalSection.Enter;
    try
      // ���� ������ ������ ��� ��� ��������������� ��� ������ ������,
      // �� ������ �������� ��� ���
      if Assigned(Value) then
      begin
        Index := FFieldList.IndexOfObject(Value);
        if Index >= 0 then
        begin
          FFieldList[Index] := AName;
          Exit;
        end;
      end;

      Index := FFieldList.IndexOf(AName);

      if Index >= 0 then
      begin
        AMatrix := FieldByIndex(Index);

        if Value = nil then
        begin
          // ������ ������� ������ �� ������. ��� ����������� ��������
          // ������� ����������� ����� FreeMatrix ����� ������.
          AMatrix.DeleteNotifyClient(Self);
          FFieldList.Delete(Index);
          Exit;
        end else if FFieldList.Objects[Index] = Value then
          Exit
        else
        begin
          if FIsCopyByRef then
            AMatrix.DeleteNotifyClient(Self)
          else
            AMatrix.FreeMatrix;
        end;
      end;

      if Value <> nil then
      begin
        FFieldList.AddObject(AName, Value);
        // �������, ����� ������ ������� ��� � ����� ��������
        Value.AddNotifyClient(Self);
      end;
    finally
      FieldListCriticalSection.Leave;
    end;   
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetFields'){$ENDIF}
  end;
end;

constructor TRecordMatrix.Create(AOwner: TMatrix;
  const AName: TMatrixName);
begin
  {� ���� ������ ������������� ������������ ����� ��������� ����������, � ����������
   ���� ����� ������������� ������ ����� Destroy. ���� ������ ������ �������
   ����� inherited, �� ��� ������ ����������� ���������� AV}
  FFieldList := TStringList.Create;
  FFieldList.CaseSensitive := True;
  inherited;
end;

function TRecordMatrix.FindField(AName: TMatrixName): TMatrix;
var
  Index: Integer;
begin
  Result := nil;
  try
    FieldListCriticalSection.Enter;
    try
      Index := FFieldList.IndexOf(AName);
      if Index >= 0 then
        Result := FieldByIndex(Index);
    finally
      FieldListCriticalSection.Leave;
    end;    
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'FindField', mkFunc){$ENDIF}
  end;
end;

procedure TRecordMatrix.GetFieldList(AList: TStrings);
begin
  AList.Clear;
  FieldListCriticalSection.Enter;
  try
    AList.Assign(FFieldList);
  finally
    FieldListCriticalSection.Leave;
  end;
end;

function TRecordMatrix.FieldCount: Integer;
begin
  FieldListCriticalSection.Enter;
  try
    Result := FFieldList.Count;
  finally
    FieldListCriticalSection.Leave;
  end;
end;

function TRecordMatrix.FieldName(Index: Integer): TMatrixName;
begin
  try
    FieldListCriticalSection.Enter;
    try
      if (Index < 0) or (Index >= FFieldList.Count) then
        raise EMatrixError.CreateFmt(matSRecordIndexNotExists, [Index]);
      Result := FFieldList[Index];
    finally
      FieldListCriticalSection.Leave;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'FieldName', mkFunc){$ENDIF}
  end;
end;

function TRecordMatrix.FieldByIndex(Index: Integer): TMatrix;
begin
  Result := nil;
  try
    FieldListCriticalSection.Enter;
    try
      if (Index < 0) or (Index >= FFieldList.Count) then
        raise EMatrixError.CreateFmt(matSRecordIndexNotExists, [Index]);

      Result := TMatrix(FFieldList.Objects[Index]);
    finally
      FieldListCriticalSection.Leave;
    end;
    Result.CheckRef;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'FieldByIndex', mkFunc){$ENDIF}
  end;
end;

function TRecordMatrix.ThisRecord: TMatrix;
begin
  Result := Self;
end;

procedure TRecordMatrix.DeletionNotify(AMatrix: TMatrix);
var
  I: Integer;
begin
  FieldListCriticalSection.Enter;
  try
    I := FFieldList.IndexOfObject(AMatrix);
    if I >= 0 then
      FFieldList.Delete(I);
  finally
    FieldListCriticalSection.Leave;
  end;
end;

{ TDynamicArrayMatrixClass }

procedure TDynamicArrayMatrixClass.Init;
begin
  FMatrixTypes := FMatrixTypes + [mtDynamic];
end;      

{ TCharMatrix }

class function TCharMatrix.GetAlias: TSignature;
begin
  Result := 'Char';
end;

function TCharMatrix.GetAsString: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Rows - 1 do
    Result := Result + GetRowChars(I) + sLineBreak;

  Result := Trim(Result);
end;

procedure TCharMatrix.Init;
begin
  inherited;
  FMatrixTypes := FMatrixTypes + [mtChar];
end;

procedure TCharMatrix.SetAsString(const Value: string);
var
  MaxLen, I, J: Integer;
  TempStr: string;
begin
  MaxLen := 0;
  with TStringList.Create do
  try
    Text := Value;

    // ���������� ������������ ����� ������
    for I := 0 to Count - 1 do
      if Length(Strings[I]) > MaxLen then
        MaxLen := Length(Strings[I]);

    // ������������� ������� �������
    Self.Clear;
    PreservResize([Count, MaxLen]);
    for I := 0 to Count - 1 do
    begin
      TempStr := Strings[I];
      for J := 1 to Length(TempStr) do
        ElemChar[I, J - 1] := TempStr[J];
    end;     
  finally
    Free;
  end;
end;

initialization
{$IFNDEF UseLifeGuid}
  MatrixInstanceList := TThreadList.Create;
{$ENDIF UseLifeGuid}

  GeneratorNameCriticalSection := TCriticalSection.Create;
  DefragCriticalSection := TCriticalSection.Create;
  ArrayListCriticalSection := TCriticalSection.Create;
  NotifyListCriticalSection := TCriticalSection.Create;
  FieldListCriticalSection := TCriticalSection.Create;

{$IFDEF UseLogger}
  ALog := TLDSLogger.Create('MatrixDebug.log');
  ALog.CanWriteThreadID := True;
{$ENDIF}

{$IFDEF DXE3PLUS}
  DecimalSeparator := FormatSettings.DecimalSeparator;
{$ENDIF DXE3PLUS}

{$IFDEF CreateBaseWorkspace}
  Base := TWorkspace.Create(nil, matSBaseWorkspace);
{$ENDIF}

  {������������� ������ �������}
  MatrixClassList := TStringList.Create;

{$IFDEF RegisterMatrixClasses}
  RegisterMatrixClass(TByteMatrix);         //  0..255
  RegisterMatrixClass(TCharMatrix);         //  #0..�
  RegisterMatrixClass(TShortIntMatrix);     // -128 ... 127
  RegisterMatrixClass(TShortMatrix);        // -32768..32767
  RegisterMatrixClass(TWordMatrix);         //  0..65535
  RegisterMatrixClass(TIntegerMatrix);      // -2147483648..2147483647
  RegisterMatrixClass(TCardinalMatrix);     //  0..4294967295
  RegisterMatrixClass(TInt64Matrix);        // -2^63..2^63-1

  RegisterMatrixClass(TSingleMatrix);       //  1.5 x 10^-45 .. 3.4 x 10^38
  RegisterMatrixClass(TDoubleMatrix);       //  5.0 x 10^-324 .. 1.7 x 10^308
  RegisterMatrixClass(TExtendedMatrix);     //  3.6 x 10^-4951 .. 1.1 x 10^4932
  RegisterMatrixClass(TCompMatrix);         // -2^63+1 .. 2^63 -1
  RegisterMatrixClass(TCurrencyMatrix);     // -922337203685477.5808..922337203685477.5807

  RegisterMatrixClass(TSingleComplexMatrix);
  RegisterMatrixClass(TDoubleComplexMatrix);
  RegisterMatrixClass(TExtendedComplexMatrix);

  RegisterMatrixClass(TCellMatrix);
  RegisterMatrixClass(TRecordMatrix);
{$ENDIF RegisterMatrixClasses}

  {�������, ���������� Matrix32 ��� �������� ����� � ������. ������������ �����
   �� �������������� � ������� ������� SetFloatToStringFunction()}
  FloatToStringFunction := FloatToString;
finalization
{$IFDEF CreateBaseWorkspace}
  Base.FreeMatrix;
{$ENDIF}  
  MatrixClassList.Free;
{$IFNDEF UseLifeGuid}
  MatrixInstanceList.Free;
{$ENDIF UseLifeGuid}
  GeneratorNameCriticalSection.Free;
  DefragCriticalSection.Free;
  NotifyListCriticalSection.Free;
  ArrayListCriticalSection.Free;
  FieldListCriticalSection.Free;

{$IFDEF UseLogger}
  ALog.Free;
{$ENDIF}

{$IFDEF EnableMemoryLeakReporting}
  if MatrixObjectCounter > 0 then
    MessageBox(0,
      PChar('Memory leaks: ' + IntToStr(MatrixObjectCounter) + ' TMatrix objects'),
     'Matrix32 memory leaks reporting',
      MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_DEFAULT_DESKTOP_ONLY);
{$ENDIF}
end.

