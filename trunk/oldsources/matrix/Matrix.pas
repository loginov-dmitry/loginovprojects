{
Copyright (c) 2005-2006, Loginov Dmitry Sergeevich
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
{ ������ Matrix - ���� ������� ��������� ���������� MatriX                    }
{ (c) 2005 - 2006 ������� ������� ���������                                   }
{ ����� �����: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ ��������! ������� Matrix ���������� �����������. � ������ ���������������   }
{ � ����������� �������� ������� ����� �� ����� � ������� "��� ������?"       }
{                                                                             }
{ *************************************************************************** }

{
                              ������� � ����������...

MatriX, �������, ����� ������ ��������, ��������������� ��� ������ � �����������
��������� ������������ �����. �������������� ����� ���� ������ - Real (��� Double).
�������� �������� � ������ ���������� �������� ������������� ������� �������
TWorkspace, ������� �������� ���������� ����������� ��������������� ����� ��������.
���� �����, ���������� ������� �������� � ������� �������� ����� ����� ��
������������. ������ ������ �������� �������� �������� ������ � ���������� ���������.
��� ���� �� ����� �� ���������. ������ ������ ����� ���� ���������� ���
(� �������� ����� ������� �������), � ������ �� ����� ����� � ��������������
��������� � ������� �������. ������ �������� �������� ������� �������� 6 � 5:
  Base.NewZeros('MyFirstArray', 6, 5);
���� ������������� ������� �������� � ��������� � �������� �� �� ������
������������ �� ������� MATLAB. ��� ������ �������, ����������� � m-�����
����������� � ����� ������� �������, ������ ���� ������� ����� �������� ������
������� � ����������� ����� ������� �������������. ���� � �����-���� ��
����������� ������� ���������� ������, �� ���������� ��������� � ������, ����������
��������� ��������, ��������� �����������. ������� �������� ���������� � MatriX.
� ������� MatriX ����������� ����������� ��� ��������, ������� ����� ��������� ���
����������� ���������.
��� ���� �������� ������ - ����������� ������� ���������� ��������������
������������ �������. ������� � ���� ���������: �� ������ ��������� �����
���������� ����������� � ��������� �������, �� ������ ������ ���� (Matrix.pas).
� �������� ������� �� ������ ����������� ������ Signals.pas. � ��� ���������
��������� �������, ������� ����� ����������� � ����� �����������.
� ���������... ������� Delphi ����� ��������� ���������� � ����, ��� � �������
������� ������������ ��� STRING, � ������� �������� ��� ����� �����. MatriX
� ���� ������ ����������. ������� ����� ����������� ������ �����, � ���
�������� ��������� ����� ���������, ������� MatriX �������� ����� �������
�������� ��������� ����������.
}

{                      ��� ������������ �������� MatriX                       }

                                                                             {
������ ���������� ������ Matrix � ������ ������� � ����������� ������ ���
�������. ����� ����������� ��� ���������� ��������� ������� ������� Base,
������� ��������� ������ (��� �������� ��������� � ������� Initialization).
� �������� ������������ ������������, � ������� ������ ���������� ������
������� Matrix (������� ���������� ������ � ������������ � �������)
������������ �� ������ ������� �� ����� ����������
                                                                             }

{������� . ���� �� ������, ����� MatriX �������� �������� ������� ���������
 �������� �������. ��� ����� �������� � ����� ��������� ������ �������, ������
 ������� ����� �������������������� ������. �� �������� ����������������
 ��� ����� ��� ���������� ��������� ������ ����� ��������}
{.$define CheckRange}
   
unit Matrix;

interface

uses Windows, SysUtils, Classes, Math, ComObj, Variants;

var  
  {����������, ����� �� ��������� ������������ �� ������� (�������������)}
  MatrixShowErrorMessages: Boolean = True;

const
  MaxArrayCount = 1000000; // ������������ ����� �������� � ������� �������
  MaxElemCount  = $effffff; // 251658239 ��������� (�������� ������!)

{������������ ������ � �����. � �������� ����������� ����� ������ ���
 �����, ��� � �������}
function AnyStrToFloat(S: string): Extended;

{������������ ����� � ������ �������������� ������� (23 �������). � ��������
 ����������� �������� �����}
function FloatToStrExp(Value: Extended): string;

{������������ ����� � ������. ����� ������ ����������. � �������� �����������
 �������� �����}
function FloatToStrGen(Value: Extended): string;

{�������� ������� ������� Str}
procedure SendMatlabCommand(Str: string);  

type    {��������� ��� ����������� ����}
  RealArray  = array[0..MaxElemCount] of Real;
  PRealArray = ^RealArray;
  PDoubleArray = ^RealArray;

  {������������ ��� �������� ��������� �������}
  TDim = (dimRows, dimCols);

  {���������� ��� ����������� �������� �����}
  TStandartType =
     // � ������ ������ ������� ��������� ������ ���� �������������. ��� �����
     // ��� ���������� ������ ������� GetElemType
    (stReal, stByte, stShortint, stWord, stShort, stDword, stInteger,
     stSmallint, stLongint, stCardinal, stLongword, stInt64, stDouble, stReal48,
     stSingle, stExtended, stComp, stCurrency);

  {�������� �������}
  TMatrixData = record
    NameArray: string;
    Rows, Cols, Address, Hash: Integer;
  end;

  TNameArray = array[1..32] of Char;
  TRealFunc = function(const Value: Real): Real;
  TRealFunc2 = function(const Value1, Value2: Real): Real;
  TExtendFunc = function(const Value: Extended): Extended;

  {����� "������ ��������". ��� ������� ������� ������ ����� �����������
   ����������: ���, �����, ����� �����, ����� ��������. ������������
   ������������� � ������ TWorkspace, ������� ��� �� ����� ����� ���
   ������������}
  TMatrixList = class(TObject)
  private    
    FList: array of ^TMatrixData;
    FCount: Integer;
    FCapacity: Integer;
    FData: ^TMatrixData;
    FLastIndexes: array[1..10] of Integer;
    function GetItemsName(Index: Integer): string;
    procedure SetItemsName(Index: Integer; const Value: string);
    function GetItemsCols(Index: Integer): Integer;
    procedure SetItemsCols(Index: Integer; const Value: Integer);
    function GetItemsRows(Index: Integer): Integer;
    procedure SetItemsRows(Index: Integer; const Value: Integer);
    function GetItemsAddr(Index: Integer): Integer;
    procedure SetItemsAddr(Index: Integer; const Value: Integer);
    procedure Grow;
    procedure SetCapacity(NewCapacity: Integer);
  public
    {����������}
    destructor Destroy(); override;

    {��������� ������� � ������}
    function Add(Item: TMatrixData): Integer;

    {���������� �� �������, � ������������� ������� $ � ����� � �������� �����}
    procedure Delete(Index: Integer);

    {������������ ��� �������� ���������, ������� � �����}
    procedure DeleteFull(Index: Integer);

    {��������� ������� ������ � �������� ����� ������� ����������}
    procedure Clear;

    {���������� ����� ��������� ������}
    function Count: Integer;

    {������������ ����� ������� � �������� ������. ��������� ����������
     10 �������� ��� ��������� ������}
    function FindName(const ArrayName: string): Integer;

    {���������� ������ ������� (� ���������� Idx) OldName. ���� ������ ��
     ������, �� ������������ ������ ������� ���������� ������� (���������
     ������� �������� �������� '$') ��� -1, ���� ������ �� ���� �������}
    function FindOldName(const OldName: string; var Idx: Integer): Boolean;

    {����������, ���������� �� ������, �������� �������� Idx}
    function ArrayExistsForIndex(const Idx: Integer): Boolean;

    {������������� �������� Index � ������ ������ ������� FLastIndexes}
    procedure SetIndex(Index: Integer);

    {��������� �������� ������������ ������� ������ � ������� ����}
    property ItemsName[Index: Integer]: string read GetItemsName write SetItemsName; default;
    property ItemsRows[Index: Integer]: Integer read GetItemsRows write SetItemsRows;
    property ItemsCols[Index: Integer]: Integer read GetItemsCols write SetItemsCols;
    property ItemsAddr[Index: Integer]: Integer read GetItemsAddr write SetItemsAddr;
  end;
  {����� TMatrixList ��������}

  {����� TWorkspace. �������� ����� ������� Matrix. �� ������ ������������
   ������ �������, ������� ��������� � ������� PUBLIC, � �� ����������
   �� ������ ����� � ������ ����� ��� ������������}
  TWorkspace = class(TObject)
  private      
    FArrayList: TMatrixList;      // ������ �������� ������ ������� �������
    FRefList: TList;              // ������ ��������, ���������� �� ������
    FWorkspaceList: TList;        // ������ �������� ������� ��������
    FParentWorkspace: TWorkspace; // ���� �� NIL, �� �������� - ���. �������
    FUniqueNameCounter: Int64;    // ������� ���������� ����
    FElemCount: Integer;          // ����� ��������� � ������� �������
    FName: string;                // ��� ������� �������
    FSelf: TWorkspace;            // ������ �� ������� �������
    FMStream: TMemoryStream;      // ����� ������ ��� ������ � �������

    {��������� � �������, �������������� ������ � ���������� �������� �������}
    function GetElem(const Name: string; Row, Col: Integer): Real;
    procedure SetElem(const Name: string; Row, Col: Integer; const Value: Real);
    function GetElemI(Idx, Row, Col: Integer): Real;
    procedure SetElemI(Idx, Row, Col: Integer; const Value: Real);
    function GetElemFast(Adr, Row, Col, ColCount: Integer): Real;
    procedure SetElemFast(Adr, Row, Col, ColCount: Integer; const Value: Real);

    {����������, �������� �� ������ � �������� Index ���������� �� ������}
    function FIsRef(Index: Integer): Boolean;

    {��������� ������ �� ������}
    function FGetRef(Name: string): TMatrixData;

    {������������� ������ �� ������}
    procedure FSetRef(Ref: TMatrixData);

    {������� ������ �� ������}
    procedure FDelRef(Name: string);

    {���������� ��������� ������ � �������� ����. ���� AddToEnd=True,
     �� ������ ��������� � ����� �����, ����� ��������� ����� ���������
     ���� �� ������� � ��� ������� NameAr}
    procedure FSaveArrayToBinFile(const FileName: string; ArIdx: Integer;
      AddToEnd: Boolean = True);

    {��������� ������� ������� � ��������� �����}
    procedure FSaveToTextFile(FileName: string);

    {��������� ��������� ������ � ��������� ����}
    procedure FSaveArrayToTextFile(const FileName: string; Name: string);

    {��������� ������� ������� �� ���������� �����}
    procedure FLoadFromTextFile(const FileName: string);

    {��������� ��������� ������ �� ���������� �����}
    procedure FLoadArrayFromTextFile(const FileName: string; Name: string);

    {������� ��������� ������� ������� � ���������� ����������}
    procedure FDoError(Msg: string);
  public
    {��� ������� �������. �� ������ ��� �������� � ���� ������ ���������}
    property wsName: string read FName write FName;

    {������ �� ������ ������� ������� (�������������� Self)}
    property SelfWS: TWorkSpace read FSelf;

    {������ �� ������������ ������� �������}
    property ParentWS: TWorkSpace read FParentWorkspace;

    {������� ������� ������� � ������ Name. ���� ParentWorkspace �����, ��
     ��������� ������� ������� ��������� ���������, � ����� �������������
     ������������ ��� ����������� ParentWorkspace}
    constructor Create(const Name: string; ParentWorkspace: TWorkspace = nil);

    {���������� ������� �������}
    destructor Destroy; override;

    {���������� ���������� (���������� ������� ����� � ����� �����. ���������)
     ��������� ������� ������� �������� ������������ �� ��� ���, ���� �� �����
     ������� �������� ������� �������, � ������� ParentWorkspace=nil}
    procedure DoError(Msg: string);

    {���� ������ "Name" � ������� ������� � ���������� ��� ������. ���� �������
     ���, �� ������� ������ �������� -1}
    function Find(const Name: string): Integer;

    {����������, ���������� �� ��������� ������}
    function ArrayExists(const Name: string): Boolean; overload;

    {����������, ���������� �� ������ � ��������� ��������}
    function ArrayExists(Idx: Integer): Boolean; overload;

    {������� ������ "Name" �������� Rows � Cols. �������� ������ ������, ����
     �������� Init=True. ���������� ������ ���������� �������. ���� ������
     �������� ��������, �� ���������� �������������� ������, ����������� ������
     �������� ������ ������� ��� ������ ������� Resize}
    function NewArray(const Name: string; Rows, Cols: Integer;
      Init: Boolean = False): Integer; overload;

    {�������� ������ �������-������ (Name=StartValue:Step:FinishValue)}
    function NewArray(const Name: string;
      StartValue, FinishValue: Real; Step: Extended): Integer; overload;

    {������ ������� ������� �������}
    procedure Clear; overload;

    {�������� ������� "Name" �� ������� �������}
    function Clear(const Name: string): Integer; overload;

    {�������� - ��� ������ � ������ �������� ������� �� ����� � �������}
    property Elem[const Name: string; Row, Col: Integer]: Real read GetElem write SetElem;
    property ElemI[Idx, Row, Col: Integer]: Real read GetElemI write SetElemI;

    {����� ������� ������ ������� � �������� �������. ���������� �������������
     ��������� ����� ������ ������� � ����� �������� � �������}
    property ElemFast[Adr, Row, Col, ColCount: Integer]: Real read GetElemFast write SetElemFast;

    {������������� ����� �������� Value �������� �������, ��������� ������.
     ��� AutoSize=True ������� ������� ���������� �������������
     ��� AutoCreate=True ������ ���������, ���� �� ������ �� �����������}
    procedure SetEl(const Name: string; const Value: Real; Row, Col: Integer;
      AutoSize: Boolean = False; AutoCreate: Boolean = False); overload;

    {������������� ����� �������� �������� �������, ��������� ��������
     ��� AutoSize=True ������� ������� ���������� �������������}
    procedure SetEl(Idx: Integer; const Value: Real; Row, Col: Integer;
      AutoSize: Boolean = False); overload;

    {�������� ������ SourAr � ������ DestAr � �������� ������ ������� �������}
    function CopyArray(const SourAr, DestAr: string): Integer; overload;

    {�������� ������ SourAr � DestAr �� ������� ������� SourWS}
    function CopyArray(SourWS: TWorkspace; const SourAr, DestAr: string):
      Integer; overload;

    {�������� ������ �� ������ �� ��������� ������� �������. �.�., ����������
     �� ������ �������� � �������� SourAr, ������� ��������� � ������� �������
     SourWS. ������, ���������� �� ������, ������ �������������� ������ ���
     ������}
    function CopyRef(SourWS: TWorkspace; const SourAr, DestAr: string): Integer;

    {���������� ������ � ��������� ������� �������. ������ SourAr � �������
     ������� DestWS ����� ����� ��� DestAr}
    procedure MoveArray(DestWS: TWorkspace; const SourAr, DestAr: string);

    {�������� ������� � ������������ �� ������������ ������� �������.
     �������� ������� ����� ����������� �� ������ (ByRef=True) ��� � �������
     ����������� (ByRef=False). ���������� �� ������ ������ ������ ��������������
     ������ ��� ������}
    function LoadArray(const SourAr, DestAr: string; ByRef: Boolean = True): Integer;

    {���������� ��������� ������ ������������ (������) � ������������ �������
     �������. ���������� ����������� �������, ������� ����� ������ ������
     ������� ������ SourAr ����� ������ �� ������ ������� �������}
    procedure ReturnArray(const SourAr, DestAr: string);

    {��������������� ������}
    function RenameArray(const SourAr, DestAr: string): Integer;

    {������������� ������� (������ ����� ������� �� ���������)}
    function Transpose(const SourAr: string; DestAr: string): string;

    {��������� ������ ������� SourAr2 � ������� SourAr1. � ���������� ����������
     ������ DestAr. ����������� � �������� ������ �� ������� �������� ���������
     �������� ������ DestAr. ��� ��������� ������������ ���������� ����� �
     ������� DestAr � �����, ������ �� ������ ����� ������ DestAr �����
     �� ������������}
    function AddRows(const SourAr1, SourAr2: string; DestAr: string): string;

    {��������� ������� � �������}
    function AddCols(const SourAr1, SourAr2: string; DestAr: string): string;

    {��������� ������ ������� RowsAr ����� ������� Row ������� DestAr}
    function InsertRows(const RowsAr: string; DestAr: string; Row: Integer): string;

    {��������� ������� ������� ColsAr ����� �������� Col ������� DestAr}
    function InsertCols(const ColsAr: string; DestAr: string; Col: Integer): string;

    {�������� ��� �������� � ������ DestAr ������ �� ������� SourAr}
    function CopyCutRows(SourAr, DestAr: string;
      RowNumber, Rows: Integer; Cut: Boolean = False): string;

    {�������� ��� �������� � ������ DestAr ������� �� ������� SourAr}
    function CopyCutCols(SourAr, DestAr: string;
      ColNumber, Cols: Integer; Cut: Boolean = False): string;

    {�������� ��������� ����� ������� SourAr � ������ DestAr}
    function CopySubmatrix(SourAr, DestAr: string;
      FirstRow, Rows, FirstCol, Cols: Integer): string;

    {��������� ������ SourAr ������ ������� DestAr}
    function PasteSubmatrix(SourAr, DestAr: string;
      FirstPastRow, FirstPastCol: Integer): string;

    {�������� ������� ������� (�������� ������ ��������������� � ���� �������)}
    function Resize(const Name: string; Rows, Cols: Integer): Integer;

    {�������� ������� �������, �������� ���������� ���������}
    function ResizeMatrix(const Name: string; Rows, Cols: Integer): Integer;

    {��������� �������������� ������� � ����� ����������.
     ������. ����� ���� ������ A = [1 2 3 4 5];
     �������� ���������� � �������: CalcFunc('A', 'A', fncSqr);
     ������� ������ A = [1 4 9 16 25]
     ������ fncSqr ����� ��������� ������ �������, � ��� ����� � ����.
     ������� CalcFunc ��������� ��������������� ������ ������� ������� SourAr
     ����� �������� �������}
    function CalcFunc(const SourAr: string; DestAr: string; Func: TRealFunc): string; overload;
    function CalcFunc(const SourAr: string; DestAr: string; Func: TExtendFunc): string; overload;

    {�������, � ������� �� ����������, ���������� ��� ������� �������.
     ����� ���� ������� ������� A � B. �� ����� ������� ��������� �������:
     CalcFunc2('A', 'B', 'C', fncSum);
     ������ �������� ������� �� ������ ������� �������� ��������. ���� ��
     ������� ���������� ����, ��������� �� ���������� � �������������, ��
     ������������ ������ ������� �� �������������. ������� ������ ��������
     ������ ���� ��� ������� ����� ���������� ������, ��� ����� �� ���
     �������� ������ ���� �������}
    function CalcFunc2(const SourArray1, SourArray2: Variant; DestAr: string;
      Func: TRealFunc2): string;  

    {����������� ������� �� ������� ���������� ���������}
    function MulMatrix(const Matrix1, Matrix2: string; MatResult: string): string; 

    {��������� ������ ���������� ������� �� 0 �� 1. ���� ������� �� �������,
     �� ������������ ��������� ������. � ��������� ������ ����� ������
     ����� ������ c ��������� Rows x Cols}
    function RandomAr(const Name: string; Rows: Integer = 0; Cols: Integer = 0): string;

    {��������� ������ ���������� ����� � ����� Step}
    function FillAr(const Name: string; BaseValue: Real; Step: Extended): string;

    {������� ������ � ��������� ���������� �����. ������ ����� - BaseValue, �
     ��������� ���������� ����� ����������� �������� Step}
    function NewFillAr(const Name: string; Rows, Cols: Integer;
      const BaseValue: Real; Step: Extended): string; overload;

    {������� ������ (������) � ��������� ���������� �����. ������ ����� - BaseValue,
     ��������� - LastValue. ��� ������������� � ����������� �� ���������� ���������}
    function NewFillAr(const Name: string; const FirstValue, LastValue: Real;
      ElemCount: Integer): string; overload;

    {������� ������, ��� �������� �������� - ����}
    function NewZeros(const Name: string; Rows, Cols: Integer): string;

    {������� ������, ��� �������� �������� - �������}
    function NewOnes(const Name: string; Rows, Cols: Integer): string;

    {����������, ����� �� ������� ����� ����� ��� ���. ��������� ����� ����
     ������� � ������ ResArray (��� "1" ��� "0")}
    function IsEqual(const Array1, Array2: string; ResArray: string = ''): Boolean;

    {���� ������ ������� �� ������ ��������, �� ������� ������ True}
    function IsSingle(const Name: String): Boolean; overload;
    function IsSingle(Idx: Integer): Boolean; overload;

    {����������, �������� �� ������� ����������}
    function IsSquare(const Name: String): Boolean; overload;
    function IsSquare(Idx: Integer): Boolean; overload;

    {����������, ���������� �� ������� � �������� ��� ���}
    function SizeEqual(const Array1, Array2: string): Boolean; overload;
    function SizeEqual(Idx1, Idx2: Integer): Boolean; overload;

    {���������� ����������� �������� (� ��� ������������� �� �������) �
     ������� ��� �������� ������� SourAr}
    procedure GetMin(SourAr, MinElems, Indexes: string; Dim: TDim = dimCols);

    {���������� ������������ �������� (� ��� ������������� �� �������) �
     ������� ��� �������� ������� SourAr}
    procedure GetMax(SourAr, MaxElems, Indexes: string; Dim: TDim = dimCols);

    {���������� �������� ����������� � ����������� �������� ������� Name}  
    procedure GetMinMax(Name: string; var MinVal, MaxVal: Real); overload;

    {���������� ���������� � ���������� �������� ������ ������ ��� �������}
    function GetMinMax(SourAr, DestAr: string; Dim: TDim = dimRows): string; overload;

    {���������� ����������� ��� ������������ ������� ��������� ������
     ��� ������� ������� Name}
    function GetMinOrMax(Name: string; Num: Integer; Dim: TDim;
      ReturnMax: Boolean; var Index: Integer): Real;

    {���������� ������� �������������� �������� ��� �������� ��� ��� �����
     ������� SourAr}
    function GetMean(SourAr, DestAr: string; Dim: TDim = dimCols): string;

    {��������� ��������� ����� ��� �������� �������}
    function CalcProd(SourAr, DestAr: string; Dim: TDim = dimRows): string;

    {��������� ������ ������� ����� �����}
    function SumRows(SourAr, DestAr: string): string;

    {��������� ������� ������� ����� �����}
    function SumCols(SourAr, DestAr: string): string;

    {��������� ������ �� ������, �������� SLoad('A=[1 2 3; 4 5 6]');}
    function SLoad(const Str: string): string; overload;

    {������� ������ Name � ���������� Values, �������� SLoad('A', '[1 2 3]');}
    function SLoad(const Name, Values: string): string; overload;
    
    {������� ������ Name � ��������� Value, �������� SLoad('A', 100);}
    function SLoad(const Name: string; const Value: Real): string; overload;

    {���������� ������� ���������� ������� � ��� ������ - ��� �������}
    function GetSize(const Name: string; var Rows, Cols: Integer): Integer; overload;

    {���������� ������� ���������� ������� � ��� ������ - ��� �������}
    function GetSize(Idx: Integer; var Rows, Cols: Integer): Integer; overload;

    {���������� ����� ��������� �������}
    function GetSize(const Name: string): Integer; overload;
    function GetSize(Idx: Integer): Integer; overload;

    {���������� ������ �������. ���������� ����������, ���� ������� ���}
    function GetIndex(const Name: string): Integer;

    {���������� ����� ������� �� ����� � ������� Integer}
    function GetAddress(const Name: string): Integer; overload;

    {���������� ����� ������� �� ������� � ������� Integer}
    function GetAddress(Idx: Integer): Integer; overload;

    {���������� ����� ������ ������ RowNum}
    function GetRowAddress(const Name: string; RowNum: Integer = 1): Pointer; overload;

    {���������� ����� ������ ������ RowNum}
    function GetRowAddress(Idx: Integer; RowNum: Integer = 1): Pointer; overload;

    {���������� ��� ������� �� ��� �������}
    function GetName(Idx: Integer): string; overload;

    {���������� ����� �����}
    function GetRows(const Name: string): Integer; overload;

    {���������� ����� �����}
    function GetRows(Idx: Integer): Integer; overload;

    {���������� ����� ��������}
    function GetCols(const Name: string): Integer; overload;

    {���������� ����� ��������}
    function GetCols(Idx: Integer): Integer; overload;

    {���������� ������ �������� ������ ������� �������}
    procedure GetNameList(List: TStrings);

    {���������� ���������� ��������}
    function GetArrayCount(): Integer;

    {���������� ����� ����� � ������ �������� FArrayList}
    function GetArrayListSize(): Integer;

    {���������� ����� ����� ��������� � ������� �������}
    property GetElemCount: Integer read FElemCount;

    {���������, ��������� �� ��� ��������� �������. ���� ��� �� ������,
     �� ����� �������� ��� �� "ans"}
    function CheckResAr(var Name: string; DoANS: Boolean = True): string;

    {����������, ��������� �� ������ ��� �������. ��� ����� ����� ����� �� 32
     ��������. ������ �������� ������ ���� ����� ���������� ��������. �����
     ������ ������ ��������� �������: ['A'..'Z', 'a'..'z', '0'..'9', '_']}
    function IsTrueName(const Name: string): Boolean;

    {��������� ������ � ���������� ������}
    function SaveArrayToString(const Name: string): string;

    {��������� ������ �� ��������� ������}
    function LoadArrayFromString(Str: string): string;

    {��������� �������� ������� � ������. � �������� ����������� �����
     ������ ����������� #13#10}
    function SaveArrayToValues(const Name: string): string;

    {��������� ������ � ascii-����}
    procedure SaveToAscii(const FileName, Name: string; Fixed: Boolean = False);

    {��������� ������ �� ascii-�����}
    procedure LoadFromAscii(const FileName: string; ArName: string = '');

    {��������� ������� ������� ��� ������ � ��������� ����}
    procedure SaveToTextFile(const FileName: string; ArName: string = '');

    {��������� ������� ������� ��� ������ �� ���������� �����}
    procedure LoadFromTextFile(const FileName: string; ArName: string = '');

    {��������� ������� ������� ��� ������ � �������� ����}
    procedure SaveToBinFile(const FileName: string; ArName: string = '');

    {��������� ������� ������� ��� ������ �� ��������� �����}
    procedure LoadFromBinFile(const FileName: string; NameAr: string = '');

    {�������� ������ � ��������� ������� ������}
    procedure SaveArrayToMemory(ArrayName: string; ArrayAddress: Pointer;
      ElemType: TStandartType);

    {��������� ������ �� ��������� ������� ������}
    procedure LoadArrayFromMemory(ArrayName: string; ArrayAddress: Pointer;
      RowCount, ColCount: Integer; ElemType: TStandartType);

    {��������� ������ � ����� (�������� �� TStream)}
    procedure SaveArrayToStream(ArrayName: string; Stream: TStream;
      ElemType: TStandartType; StartByte: Integer = 0);

    {��������� ������ �� ������ (��������� �� TStream)}
    procedure LoadArrayFromStream(ArrayName: string; Stream: TStream;
      Rows, Cols: Integer; ElemType: TStandartType; StartByte: DWORD = 0);

    {�������� ��������� ������ � ������ (� �������� ������� �������)}
    procedure PutArrayToMatlab(const Name: string);

    {��������� ��������� ������ �� �������� ������� ������� �������
     ��� ������ ������ ������ False}
    function LoadArrayFromMatlab(const Name: string): Boolean;

    {�������� ����� MATLAB ������� Str}
    procedure SendMatlabCommand(Str: string);

    {�������� ������ ������ ������� ������ ���, ������ ��� ������� ��� � ���
     ������, ���� �� ������, ����� ���� ������������ ������������ ������������
     � �������� �������, ��������� ������ � �������, ��������� ������� �����.
     ����� InputArray - ��� �������, ����������� � ������������,
     TempArray - ��� ���������� �������. ������ ������ ������� ������, ��� ����
     InputArray - ������ �����, �� ����� ������������� ������ ������ TempArray, �
     ������� ���������� �������� ������ InputArray. ����� ������ InputArray �����
     ��������� ��� ���������� ������� TempArray.
     ����� �������, ����� ������ ������ ������� �� ������ ������� InputArray
     ������ �������� ������� � �������� � ��� ��� �� � ��� �� ������}
    function HandInput(var InputArray: string; var TempArray: string): Integer;
    
    {��������� ����������� ����� �������}
    function GenName(Str: string = ''): string;

    {���������� ��� ��������� �������, �������������� � ���� �����}
    function GetElemType(const Name: string): TStandartType;
  end;


var
  {����� ��������� ������� ������� Base. �� �� ������ ��������� ��� ���������� ��.
   ��� ������ �� ���������� ������ ������ � ������ �������, ��� ����� ����������
   ��������� ������� ������� Base. ���������� ��������� ������������� ��� ������
   ��������}
  Base: TWorkspace;


// ��������� ������� ������������ ��� �������� � ������� CalcFunc2

function fncSum(const Value1, Value2: Real): Real;   // ��������
function fncSub(const Value1, Value2: Real): Real;   // ���������
function fncMul(const Value1, Value2: Real): Real;   // ���������
function fncDiv(const Value1, Value2: Real): Real;   // �������
function fncPower(const Value1, Value2: Real): Real; // ���������� � �������

function fncEQ(const Value1, Value2: Real): Real; // �����
function fncNE(const Value1, Value2: Real): Real; // �� �����
function fncLT(const Value1, Value2: Real): Real; // ������
function fncGT(const Value1, Value2: Real): Real; // ������
function fncLE(const Value1, Value2: Real): Real; // ������ ��� �����
function fncGE(const Value1, Value2: Real): Real; // ������ ��� �����

function fncAnd(const Value1, Value2: Real): Real; // �
function fncOr(const Value1, Value2: Real): Real; // ���
function fncXor(const Value1, Value2: Real): Real; // Xor

// ��������� ������� ������������ ��� �������� � ������� CalcFunc

function fncNot(const Value: Real): Real; // Not

function fncNone(const Value: Real): Real; // Result := Value
function fncSin(const Value: Real): Real;
function fncCos(const Value: Real): Real;
function fncRound(const Value: Real): Real;
function fncTrunc(const Value: Real): Real;
function fncInt(const Value: Real): Real;
function fncFrac(const Value: Real): Real;
function fncSqrt(const Value: Real): Real;
function fncSqr(const Value: Real): Real;
function fncAbs(const Value: Real): Real; 
function fncExp(const Value: Real): Real;

// ��������� ���������� ������������ ��� �������� � ������� CalcFunc
var
         fncTan: TExtendFunc = Tan;
         fncCotan: TExtendFunc = Cotan;
         fncArcsin: TExtendFunc = Arcsin;
         fncArccos: TExtendFunc = Arccos;
         fncSecant: TExtendFunc = Secant;
         fncCosecant: TExtendFunc = Cosecant;
         fncLog10: TExtendFunc = Log10;
         fncLog2: TExtendFunc = Log2;
         fncLnXP1: TExtendFunc = LnXP1;
         fncCosh: TExtendFunc = Cosh;
         fncSinh: TExtendFunc = Sinh;
         fncTanh: TExtendFunc = Tanh;
         fncCotH: TExtendFunc = CotH;
         fncSecH: TExtendFunc = SecH;
         fncCscH: TExtendFunc = CscH;
         fncArcCot: TExtendFunc = ArcCot;
         fncArcSec: TExtendFunc = ArcSec;
         fncArcCsc: TExtendFunc = ArcCsc;
         fncArcCosh: TExtendFunc = ArcCosh;
         fncArcSinh: TExtendFunc = ArcSinh;
         fncArcTanh: TExtendFunc = ArcTanh;
         fncArcCotH: TExtendFunc = ArcCotH;
         fncArcSecH: TExtendFunc = ArcSecH;
         fncArcCscH: TExtendFunc = ArcCscH;

const
  // �������� ���������
  matrixPi = Pi;
  matrixExp = 2.7182818284590455;
  matrixEps = 1.0842021724855E-19;  

  // ��������� ���������
  matBaseWorkspace = '�������� ������� �������';
  matWrongIndex = '������ � ��������� �������� �� ����������';
  matWrongCapacity = '��������� ����������� ���������� ����� �������� � ������� �������';
  matArrayNotFound = '��������� ������ ����������� � ������� �������';
  matBadCoords = '������� ������������ ���������� ��������';
  matBadRow = '��������� ������ �� ����������';
  matBadCol = '���������� ������� �� ����������';
  matBadRowCol = '���������� �������/������ �� ����������';
  matBadSize = '������� ������� ������ �������';
  matBadInputData = '������������ ������� ������';
  matErrorCreateArray = '���������� ������� ������ � ���������� ���������';
  matIsNotVektor = '������ �� �������� ��������';
  matDivsionByZero = '������� �� ����';
  matBadOperation = '�������� �������� �� ��������������';
  matCalcFuncError = '��������� ������ ��� ������� �������';
  matErrorLoadingArray = '������ ��� ������� ��������� ������';
  matErrorPast = '���������� �������� ������ ��� � ����';
  matInvalidFloat = '"%s" �� �������� ���������� ������� ������';
  matOutOfMemory = '������������ ������ ��� ���������� ��������';
  matBadName = '������� ������������ ��� �������';
  matDirNotFound = '��������� ���������� �� �������';
  matBadType = '��������� ��� �� ��������������';
  matArraysNotAgree = '������� �������� �� �����������';
  matBadParams = '������������ ��������� �������� �������';
  matBadFileFormat = '������������ ������ ����� ';
  matFileNotFound = '���� �� ������';
  matBinaryHeader = 'Matrix binaries. Version 2.0. '; // 30 ����
  matWorkspaceError = '������� ������� ������ ��������';
  matReturnError = '������� �������� �������, ����������� �� ������';
  matCalcLimit =
    '��������� ���� �������� ������ ���������� ���������� ��������.' +
    '������ �� ����� �������. ��� ������ ����������� ���������� ��� ����� ��������' +
    '� �������. �� ������ ���������� ������ ���������?';

implementation
  
var
  Matlab: Variant;
  MatlabArray, MatlabVar: OleVariant;   

function fncSum(const Value1, Value2: Real): Real;
begin
  Result := Value1 + Value2;
end;

function fncSub(const Value1, Value2: Real): Real;
begin
  Result := Value1 - Value2;
end;

function fncMul(const Value1, Value2: Real): Real;
begin
  Result := Value1 * Value2;
end;

function fncDiv(const Value1, Value2: Real): Real;
begin
  Result := Value1 / Value2;
end;

function fncPower(const Value1, Value2: Real): Real;
begin
  Result := Power(Value1, Value2);
end;

function fncEQ(const Value1, Value2: Real): Real;
begin
  Result := Integer(Value1 = Value2);
end;

function fncNE(const Value1, Value2: Real): Real;
begin
  Result := Integer(Value1 <> Value2);
end;

function fncLT(const Value1, Value2: Real): Real;
begin
  Result := Integer(Value1 < Value2);
end;

function fncGT(const Value1, Value2: Real): Real;
begin
  Result := Integer(Value1 > Value2);
end;

function fncLE(const Value1, Value2: Real): Real;
begin
  Result := Integer(Value1 <= Value2);
end;

function fncGE(const Value1, Value2: Real): Real;
begin
  Result := Integer(Value1 >= Value2);
end;

function fncAnd(const Value1, Value2: Real): Real;
begin
  Result := Integer((Value1 <> 0) and (Value2 <> 0));
end;

function fncOr(const Value1, Value2: Real): Real;
begin
  Result := Integer((Value1 <> 0) or (Value2 <> 0));
end;

function fncXor(const Value1, Value2: Real): Real;
begin
  Result := Integer((Value1 <> 0) xor (Value2 <> 0));
end;

function fncNot(const Value: Real): Real;
begin
  Result := Integer(not (Value <> 0));
end;

function fncNone(const Value: Real): Real;
begin
  Result := Value;
end;

function fncSin(const Value: Real): Real;
begin
  Result := Sin(Value);
end;

function fncCos(const Value: Real): Real;
begin
  Result := Cos(Value);
end;

function fncRound(const Value: Real): Real;
begin
  Result := Round(Value);
end;

function fncTrunc(const Value: Real): Real;
begin
  Result := Trunc(Value);
end;

function fncInt(const Value: Real): Real;
begin
  Result := Int(Value);
end;

function fncFrac(const Value: Real): Real;
begin
  Result := Frac(Value);
end;

function fncSqrt(const Value: Real): Real;
begin
  Result := Sqrt(Value);
end;

function fncSqr(const Value: Real): Real;
begin
  Result := Sqr(Value);
end;

function fncAbs(const Value: Real): Real;
begin
  Result := Abs(Value);
end;

function fncExp(const Value: Real): Real;
begin
  Result := Exp(Value);
end;

procedure MsGrow(Ms: TMemoryStream);
var
  Pos: Integer;
begin
  if (Ms.Position < Ms.Size - 1) or (Ms.Size < 10000) then Exit;
  Pos := Ms.Position;
  // ����������� ������ ������ �� 20 %
  Ms.SetSize(Ms.Size + Ms.Size div 5);
  Ms.Position := Pos;
end;

function StrToName(S: string): TNameArray;
var
  I, J: Integer;
begin
  FillChar(Result, 32, 0);
  if S <> '' then
  begin
    I := Min(32, Length(S));
    for J := 1 to I do
      Result[J] := S[J];
  end;
end;

function AvailMemory: Real;
var
  MemInfo: TMemoryStatus;
begin
  MemInfo.dwLength := Sizeof(MemInfo);
  GlobalMemoryStatus(MemInfo);
  Result := MemInfo.dwAvailPhys + MemInfo.dwAvailPageFile;
end;

function FileSize(FileName: string): Integer;
var
  F: HFile;
begin
  Result := 0;
  if not FileExists(FileName) then Exit;
  F := _lopen(PChar(FileName), OF_READ);
  Result := _llseek(F, 0, FILE_END);
  _lclose(F);
end;

function MatrixData(const NameArray: string;
  const Rows, Cols, Address: Integer): TMatrixData;
begin
  Result.NameArray := NameArray;
  Result.Rows := Rows;
  Result.Cols := Cols;
  Result.Address := Address;
  Result.Hash := 0;
end;    

function AnyStrToFloat(S: string): Extended;
var
  C: Char;
  I: Byte;
begin
  if DecimalSeparator = '.' then C := ',' else C := '.';
  I := Pos(C, S);
  if I > 0 then S[I] := DecimalSeparator;
  if not TextToFloat(PChar(S), Result, fvExtended) then
    raise Exception.CreateFmt(matInvalidFloat, [S]);
end;

function FloatToStrExp(Value: Extended): string;
var
  Buffer: array[0..63] of Char;
  I: Byte;
begin
  SetString(Result, Buffer, FloatToText(Buffer, Value, fvExtended,
    ffExponent, 17, 3));
  I := Pos(',', Result);
  if I > 0 then Result[I] := '.';
end;

function FloatToStrGen(Value: Extended): string;
var
  Buffer: array[0..63] of Char;
  I: Byte;
begin
  SetString(Result, Buffer, FloatToText(Buffer, Value, fvExtended,
    ffGeneral, 15, 0));
  I := Pos(',', Result);
  if I > 0 then Result[I] := '.';
end;

function GenerateHash(const Str: string): Integer;
var
  Len, I: Integer;
  Flag: Boolean;
begin
  Result := 0;
  if Str = '' then Result := -1 else
    if Str[1] = '$' then Result := 0 else
    begin
      Len := Length(Str);
      Flag := False;
      for I := 1 to Len do
      begin
        if Flag then
          Result := Result + not Ord(Str[I])
        else
          Result := Result + Ord(Str[I]);
        Flag := not Flag;
      end;
    end;
end;

procedure SendMatlabCommand(Str: string);
begin
  Matlab := CreateOleObject('Matlab.Application');
  Matlab.Execute(Str);
end;

function TMatrixList.Add(Item: TMatrixData): Integer;
begin  
  if FCount > MaxArrayCount then
    raise Exception.Create(matWrongCapacity);
  Result := FCount;
  if Result = FCapacity then Grow;
  New(FData);
  FData^ := Item;
  FData^.Hash := GenerateHash(FData^.NameArray);
  Inc(FCount);
  FList[FCount - 1] := Pointer(FData);
end;

function TMatrixList.ArrayExistsForIndex(const Idx: Integer): Boolean;
begin
  Result := False;
  if (Idx < 0) or (Idx >= FCount) or (FList[Idx]^.NameArray[1] = '$') then Exit;
  Result := True;
end;

procedure TMatrixList.Clear;
var
  I: Integer;
begin
  if FCount > 0 then
    for I := FCount - 1 downto 0 do
      DeleteFull(I);
  FCount := 0; // �� ������ ������
  // ����� ������ �� ��������, �.�. ������������� ��� �� �������
end;

function TMatrixList.Count: Integer;
begin
  Result := FCount;
end;

procedure TMatrixList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then
    raise Exception.Create(matWrongIndex);
  with FList[Index]^ do begin
    NameArray := '$' + NameArray;
    Hash := 0;
    Rows := 0;
    Cols := 0;
    Address := 0;
  end;
end;

procedure TMatrixList.DeleteFull(Index: Integer);
begin
  if (Index <> FCount - 1) then
    raise Exception.Create('TMatrixList: You must delete only last elem!');
  if FList[Index] = nil then Exit;
  FList[Index]^.NameArray := '';
  FData := Pointer(FList[Index]);
  Dispose(FData);
  FList[Index] := nil;
  Dec(FCount);
end;

destructor TMatrixList.Destroy;
begin
  Clear;
  FList := nil;
  inherited Destroy;
end;

function TMatrixList.FindName(const ArrayName: string): Integer;
var
  I, J, Buf, Hash: Integer;
begin
  Hash := GenerateHash(ArrayName);
  Result := -1;      
  if FCount = 0 then Exit;
  // ���� ������� � ������� FLastIndexes
  for I := 1 to 10 do begin
    if (FLastIndexes[I] < FCount) and (FList[FLastIndexes[I]].Hash = Hash) and
       (FList[FLastIndexes[I]].NameArray = ArrayName) then
      begin
        Result := FLastIndexes[I];
        if I > 1 then
        begin // ���������� ������ � ������ ������� �� ���� �������
          Buf := FLastIndexes[I - 1];
          FLastIndexes[I - 1] := FLastIndexes[I];
          FLastIndexes[I] := Buf;
        end;
        Exit;
      end;
  end;   
  // ���� �� ����� � FLastIndexes, �� ���� � ����� ������
  for I := 0 to FCount - 1 do begin
    if (FList[I]^.Hash = Hash) and (FList[I]^.NameArray = ArrayName) then
    begin
      Result := I;
      for J := 9 downto 1 do
        FLastIndexes[J + 1] := FLastIndexes[J];
      FLastIndexes[1] := I;
      Exit;
    end;
  end;
end;

function TMatrixList.FindOldName(const OldName: string;
  var Idx: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  Idx := -1;
  if FCount = 0 then Exit;    
  for I := 0 to FCount - 1 do
    if (FList[I]^.Hash = 0) and (FList[I]^.NameArray[1] = '$') then
    begin
      if Idx = -1 then Idx := I;
      if FList[I]^.NameArray = OldName then
      begin
        Idx := I;
        Result := True;
        Exit;
      end;
    end;
end;

function TMatrixList.GetItemsAddr(Index: Integer): Integer;
begin
  Result := FList[Index]^.Address;
end;

function TMatrixList.GetItemsCols(Index: Integer): Integer;
begin
  Result := FList[Index]^.Cols;
end;

function TMatrixList.GetItemsName(Index: Integer): string;
begin
  Result := FList[Index]^.NameArray;
end;

function TMatrixList.GetItemsRows(Index: Integer): Integer;
begin
  Result := FList[Index]^.Rows;
end;

procedure TMatrixList.Grow;
begin
  if FCapacity < 50 then SetCapacity(50) else
    // ����������� ������ ������ �� 20 %
    SetCapacity(FCapacity + FCapacity div 5);  
end;

procedure TMatrixList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxArrayCount) then
    raise Exception.Create(matWrongCapacity);
  if NewCapacity <> FCapacity then
  begin
    SetLength(FList, NewCapacity);
    FCapacity := NewCapacity;
  end;
end;

procedure TMatrixList.SetIndex(Index: Integer);
var
  I: Integer;
begin
  for I := 1 to 10 do if FLastIndexes[I] = Index then Exit;
  for I := 9 downto 1 do FLastIndexes[I + 1] := FLastIndexes[I];
  FLastIndexes[1] := Index;
end;

procedure TMatrixList.SetItemsAddr(Index: Integer; const Value: Integer);
begin
  FList[Index]^.Address := Value;   
end;

procedure TMatrixList.SetItemsCols(Index: Integer; const Value: Integer);
begin
  FList[Index]^.Cols := Value;
end;

procedure TMatrixList.SetItemsName(Index: Integer; const Value: string);
begin
  FList[Index]^.NameArray := Value;
  FList[Index]^.Hash := GenerateHash(Value);
end;

procedure TMatrixList.SetItemsRows(Index: Integer; const Value: Integer);
begin
  FList[Index]^.Rows := Value;
end;  

function TWorkspace.Resize(const Name: string; Rows, Cols: Integer): Integer;
var
  C, OldSize, NewSize, RC, CC, I, I1: Integer;
  Tmp: string;
begin
  I := Find(Name);
  if I = -1 then begin
    Result := NewArray(Name, Rows, Cols, True);
    Exit;
  end;
  GetSize(I, RC, CC);
  OldSize := RC * CC;
  NewSize := Rows * Cols;
  // ���� �������������� ������ �������� ��������, �� �������� ���������
  // ���������� ���������� ��� ������� ������� ������
  if (((RC = 1) and (CC > 1)) or ((RC > 1) and (CC = 1))) and
     (NewSize div 100 = OldSize div 100) then
  begin
    // ������������ ����� ��������� � ������� �������
    FElemCount := FElemCount + NewSize - OldSize;
    FArrayList.ItemsRows[I] := Rows;
    FArrayList.ItemsCols[I] := Cols;
    // ���� ����� �������������� ������, �� �������� ��, ������� � OldSize
    if NewSize > OldSize then
      FillChar(Pointer(FArrayList.ItemsAddr[I] + OldSize * 8)^, (NewSize - OldSize) * 8, 0);
    Result := I;
    Exit;
  end;
  C := Min(NewSize, OldSize) * 8;
  Tmp := GenName();
  I1 := NewArray(Tmp, Rows, Cols, True);
  Move(Pointer(FArrayList.ItemsAddr[I])^, Pointer(FArrayList.ItemsAddr[I1])^, C);
  Result := RenameArray(Tmp, Name);
end;

procedure TWorkspace.Clear;
var
  I: Integer;
begin
  FElemCount := 0;
  FUniqueNameCounter := 0;
  with FArrayList do begin
    if Count = 0 then Exit;
    for I := 0 to Count - 1 do
    try
      if not FIsRef(I) then
        FreeMem(Pointer(ItemsAddr[I]));
    except
      // ����� ���������� ������ ����������
    end;
    Clear;
  end;
  if FMStream <> nil then FMStream.Clear;
end;

function TWorkspace.Clear(const Name: string): Integer;
var
  I, C, Rows, Cols: Integer;
begin
  Result := Find(Name);
  if Result = -1 then Exit;
  if Name[1] = '$' then Exit;
  if FIsRef(Result) then FDelRef(Name) else
  begin
    GetSize(Result, Rows, Cols);
    Dec(FElemCount, Rows * Cols);
  end;

  try
    FreeMem(Pointer(FArrayList.ItemsAddr[Result]));
  except
    // �������� ��������������� �������
    FArrayList.Delete(Result);
    Exit;
  end;
  // �������� ������ ��� ���������
  FArrayList.Delete(Result);

  // ������� ������ �����, ���� ��� ��� ��� ��������� � ���. �������
  C := FArrayList.Count;
  if C > Result + 1 then
    for I := C - 1 downto Result + 1 do
    begin
      if FArrayList.ItemsName[I][1] <> '$' then Break else
        FArrayList.DeleteFull(I);
    end;
end;

constructor TWorkspace.Create(const Name: string; ParentWorkspace: TWorkspace = nil);
begin
  inherited Create;
  FArrayList := TMatrixList.Create;
  FName := Name;
  FRefList := TList.Create;
  FWorkspaceList := TList.Create;
  FSelf := Self;
  // ��������� ������ �� ������� ������� � ������������ ������� �������
  if ParentWorkspace <> nil then
  begin
    ParentWorkspace.FWorkspaceList.Add(Self);
    FParentWorkspace := ParentWorkspace;
  end;  
end;

destructor TWorkspace.Destroy;
var
  I: Integer;  
begin
  // ������� ������ �� ��������
  if FParentWorkspace <> nil then
    FParentWorkspace.FWorkspaceList.Remove(Self);  

  // ������� ��� �������� ������� �������
  if FWorkspaceList.Count > 0 then
    for I := FWorkspaceList.Count - 1 downto 0 do
      TWorkspace(FWorkspaceList.Items[I]).Free;

  Clear;
  FWorkspaceList.Free;
  FRefList.Free;
  FArrayList.Free;
  if FMStream <> nil then FMStream.Free;
  inherited;
end;

procedure TWorkspace.DoError(Msg: string);  
begin
  Msg := wsName + ':'#13#10#13#10 + Msg;
  FDoError(Msg); 
end;

procedure TWorkspace.FDoError(Msg: string);
var
  I: Integer;
begin
  // ���������� ��� �������� ������� �������
  if FWorkspaceList.Count > 0 then
    for I := FWorkspaceList.Count - 1 downto 0 do
      TWorkspace(FWorkspaceList.Items[I]).Free;

  // ���� ����� �� ������� ������� �������, �� ���������� ������
  if FParentWorkspace = nil then
  begin
    if MatrixShowErrorMessages then
      raise Exception.Create(Msg)
    else
      Abort;
  end else
    FParentWorkspace.FDoError(Msg);
end;

function TWorkspace.Find(const Name: string): Integer;
begin
  Result := FArrayList.FindName(Name);
end;

function TWorkspace.GetAddress(const Name: string): Integer;
begin
  Result := FArrayList.ItemsAddr[GetIndex(Name)];
end;

function TWorkspace.GetIndex(const Name: string): Integer;
begin
  Result := FArrayList.FindName(Name);
  if Result = -1 then DoError(matArrayNotFound);
end;

function TWorkspace.GetSize(const Name: string; var Rows, Cols: Integer): Integer;
begin
  Result := Find(Name);
  if Result = -1 then DoError(matArrayNotFound);
  Rows := FArrayList.ItemsRows[Result];
  Cols := FArrayList.ItemsCols[Result];
end;

function TWorkspace.LoadArrayFromString(Str: string): string;
var
  I, Len, NextPos, Cols, Rows, ElCount, Adr: Integer;
  ArName, S: string;
  EquExists, ColsKnown: Boolean;
  R: Real;
  E: Extended;
begin
  if FMStream = nil then FMStream := TMemoryStream.Create;
  if Length(Str) < 3 then DoError(matErrorLoadingArray);
  if (Str[Length(Str) - 1] <> ']') and (Str[Length(Str)] <> ']') then
    Insert(']', Str, Length(Str) + 1);
  Len := Length(Str);
  NextPos := 0;

  // ���������� ��� �������
  for I := 1 to Len do
  begin
    if (ArName <> '') and (not (Str[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_'])) then
    begin
      NextPos := I;
      Break;
    end;
    if (Str[I] in ['A'..'Z', 'a'..'z']) and (ArName = '') then
    begin
      ArName := Str[I];
      Continue;
    end;
    if (Str[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) and (ArName <> '') then
      ArName := ArName + Str[I];     
  end;
    
  if ArName = '' then DoError(matErrorLoadingArray);
  Result := ArName;
  
  // ���� ������ '='
  EquExists := False;
  for I := NextPos to Len do
    if Str[I] = '=' then
    begin
      EquExists := True;
      NextPos := I + 1;
      Break;
    end;

  if not EquExists then DoError(matErrorLoadingArray);
  ColsKnown := False;
  ElCount := 0;
  Cols := 0;
  FMStream.Clear;

  // ��������� �������� �������
  for I := NextPos to Len do
  begin
    if Str[I] in ['0'..'9', '.', '-', '+', 'e', 'E'] then
    begin
      S := S + Str[I];
      Continue;
    end else
    begin
      if S <> '' then
      begin
        E := AnyStrToFloat(S);
        S := '';
        if E < -MaxDouble then E := -MaxDouble;
        if E >  MaxDouble then E :=  MaxDouble;
        R := E;
        MsGrow(FMStream);
        FMStream.Write(R, 8);
        if not ColsKnown then Inc(Cols);
        Inc(ElCount);
      end;

      if Str[I] = ']' then Break;
      if Str[I] = ';' then ColsKnown := True;
    end
  end;
  // �������� �������� � ������
  if FMStream.Size = 0 then DoError(matErrorLoadingArray);
  if (ElCount mod Cols) <> 0 then DoError(matErrorLoadingArray);

  Rows := ElCount div Cols;
  Adr := GetAddress(NewArray(ArName, Rows, Cols));
  FMStream.Seek(0, soFromBeginning);
  FMStream.Read(Pointer(Adr)^, ElCount * 8);
  FMStream.Clear;
end;

function TWorkspace.NewArray(const Name: string; Rows, Cols: Integer;
  Init: Boolean): Integer;
var
  f, InitCnt, Idxold: Integer;
  eRows, eCols, Size: Integer;
  P: Pointer;
begin
  eRows := 0;
  eCols := 0;
  if (Rows < 1) or (Cols < 1) or (Int64(Rows) * Cols > MaxElemCount) then
    DoError(matErrorCreateArray);
  if not IsTrueName(Name) then DoError(matBadName);
  // ���� ���������� � ����� ������ ���� � ����� �� �� �������, ��
  // ���������� ��
  f := Find(Name);
  Size := Rows * Cols;
  if f <> -1 then begin
    GetSize(f, eRows, eCols);
    if ((eRows = Rows) and (eCols = Cols)) or
       (((eRows * eCols) = Size) and (Rows <> 1) and (Cols <> 1)) then
    begin
      P := Pointer(GetAddress(f));
      if Init then FillChar(P^, Size shl 3, 0);
      Result := f;
      FArrayList.ItemsRows[f] := Rows;
      FArrayList.ItemsCols[f] := Cols;
      Exit;
    end else
      Clear(Name);
  end;
  FArrayList.FindOldName('$' + Name, Idxold);
  InitCnt := Size * 8;
  if InitCnt > AvailMemory then DoError(matOutOfMemory);
  // ���� ������ - ������, �� �������������� ������ ������� 100
  try
    if ((Rows = 1) and (Cols > 1)) or ((Rows > 1) and (Cols = 1)) then
      GetMem(P, (Size div 100 + 1) * 100 * 8)
    else
      GetMem(P, Size shl 3);
  except
    DoError(matOutOfMemory);
    P := nil; // ���� ���������� �� �������
  end;

  Inc(FElemCount, Size);

  if Idxold = -1 then
    FArrayList.Add(MatrixData(Name, Rows, Cols, Integer(P)))
  else begin
    FArrayList.ItemsName[Idxold] := Name;
    FArrayList.ItemsRows[Idxold] := Rows;
    FArrayList.ItemsCols[Idxold] := Cols;
    FArrayList.ItemsAddr[Idxold] := Integer(P);
  end;
  if Idxold <> -1 then Result := Idxold else Result := FArrayList.Count - 1;
  FArrayList.SetIndex(Result);
  if Init then FillChar(P^, InitCnt, 0);   
end;

function TWorkspace.SaveArrayToString(const Name: string): string;
var
  I, J, K, Rows, Cols, Idx: Integer;
  Len, L2, N: Integer;
  S: string;
begin
  Idx := GetSize(Name, Rows, Cols);
  Result := #13#10 + Name + '=' + '[';
  N := Length(Result);
  // ������������� ����������� ��������� ����� ������
  Len := Rows * (Cols + 1) * 25 + 100;
  SetLength(Result, Len);
  for I := 1 to Rows do
  begin
    for J := 1 to Cols do begin
      S := FloatToStrGen(ElemI[Idx, I, J]);
      L2 := Length(S);
      for K := 1 to L2 do
        Result[N + K] := S[K];
      Inc(N, L2 + 1);
     Result[N] := ' ';
    end;
    Dec(N);
    Result[N + 1] := ';';
    Result[N + 2] := #13;
    Result[N + 3] := #10;
    Inc(N, 3);
  end;
  Result[N - 2] := ']';
  Result[N - 1] := ';';
  Result[N + 0] := #13;
  Result[N + 1] := #10;
  SetLength(Result, N + 1);
end;

procedure TWorkspace.SetEl(const Name: string; const Value: Real; Row, Col: Integer;
  AutoSize: Boolean = False; AutoCreate: Boolean = False);
var
  I: Integer;
  Rows, Cols, NewRows, NewCols: Integer;
begin
  if (Row < 1) or (Col < 1) then DoError(matBadCoords);
  I := Find(Name);
  if AutoCreate and (I = -1) then I := NewArray(Name, Row, Col, True);
  GetSize(I, Rows, Cols);
  if (Row > Rows) or (Col > Cols) then
  begin
    if not AutoSize then DoError(matBadCoords) else
      begin
        NewRows := Max(Row, Rows);
        NewCols := Max(Col, Cols);
        if (NewRows = 1) or (NewCols = 1) then
          I := Resize(Name, NewRows, NewCols)
        else
          I := ResizeMatrix(Name, NewRows, NewCols);
      end;
  end;
  Real(Pointer((FArrayList.ItemsAddr[I] + ((Row - 1) * Cols + Col) shl 3 - 8))^) := Value;
end;

function TWorkspace.NewArray(const Name: string; StartValue,
  FinishValue: Real; Step: Extended): Integer;
var
  I, Mem: Integer;
  ColCount: Integer;
  ETemp: Extended;
  Adr: Integer;
  eps1, eps2: Real;
  P: Pointer;
begin
  if not IsTrueName(Name) then DoError(matBadName);
  if (Step = 0) or ((FinishValue - StartValue) / Step < 0) then DoError(matBadParams);

  // ���������� ���������� �������� � �������
  ColCount := 0;
  ETemp := StartValue;
  eps1 := abs(Step) / 2; // ��� �������������� ������������   
  eps2 := matrixEps;  // �������� �������

  if StartValue <= FinishValue then
    while ETemp <= FinishValue + eps1 do
    begin
      Inc(ColCount);
      ETemp := ETemp + Step;
      if (ETemp > FinishValue) and
        (abs((ETemp - FinishValue) / FinishValue) > eps2) then Break;
    end else
    while ETemp >= FinishValue - eps1 do
    begin
      Inc(ColCount);
      ETemp := ETemp + Step;
      if (ETemp < FinishValue) and
        (abs((FinishValue - ETemp) / FinishValue) > eps2) then Break;
    end;
  if ColCount = 0 then DoError(matBadCoords);
  // ���� ���������� � ����� ������ ��� ����, �� ���������� ��:
  Clear(Name);
  if (ColCount < 1) or (ColCount > MaxElemCount) then DoError(matErrorCreateArray);
  if AvailMemory() < (Int64(ColCount) * 8) then DoError(matOutOfMemory);
  // ����, ��� �� � ������ ���������� � ������ '$'+Name
  FArrayList.FindOldName('$' + Name, Mem);
  // ���� ������ - ������, �� �������������� ������ ������� 100

  try
    if ColCount > 1 then
      GetMem(P, (ColCount div 100 + 1) * 100 * 8)
    else
      GetMem(P, ColCount * 8);
  except
    DoError(matOutOfMemory);
    P := nil;
  end;       
    
  Inc(FElemCount, ColCount);

  if Mem = -1 then
    FArrayList.Add(MatrixData(Name, 1, ColCount, Integer(P)))   
  else
    with FArrayList do begin
      ItemsName[Mem] := Name;
      ItemsRows[Mem] := 1;
      ItemsCols[Mem] := ColCount;
      ItemsAddr[Mem] := Integer(P);
    end;

  if Mem <> -1 then Result := Mem else Result := FArrayList.Count - 1;
  FArrayList.SetIndex(Result);
  Adr := Integer(P);
  ETemp := StartValue;
  for I := 1 to ColCount do begin
    Real(Pointer(Adr)^) := ETemp;
    Inc(Adr, 8);
    ETemp := ETemp + Step;
  end;  
end;

procedure TWorkspace.SaveToAscii(const FileName, Name: string;
  Fixed: Boolean = False);
var
  FullFileName: string;
  I, J, Rows, Cols, Adr: Integer;
  TF: TextFile;
  Str, Path, fName: string;
begin
  Path := ExtractFilePath(FileName);
  fName := ExtractFileName(FileName);
  if Pos('.', fName) = 0 then fName := fName + '.asc';
  if Path = '' then Path := ExtractFilePath(ParamStr(0));
  if not DirectoryExists(Path) then DoError(matDirNotFound);

  Adr := GetAddress(GetSize(Name, Rows, Cols));
  FullFileName := Path + fName; 
  AssignFile(TF, FullFileName);
  Rewrite(TF);
    for I := 1 to Rows do begin
      for J := 1 to Cols do begin
        if Fixed then begin
          Str := FloatToStrExp(ElemFast[Adr, I, J, Cols]);
          while Length(Str) < 24 do Insert(' ', Str, 1);           
        end else
          Str := FloatToStrGen(ElemFast[Adr, I, J, Cols]);
        if J < Cols then Str := Str + ' ';
        Write(TF, Str);
      end;
      Writeln(TF);
    end;
  CloseFile(TF);
end;


procedure TWorkspace.LoadFromAscii(const FileName: string; ArName: string = '');
var
  R: Real;
  S, Name: string;
  ColCount, ElCount: Integer;
  RowCount: Integer;
  Adr: Integer;
  ColKnown: Boolean;
  E: Extended;
  C: Char;
begin
  if FMStream = nil then FMStream := TMemoryStream.Create;
  FMStream.Clear;
  ColCount := 0;
  ElCount := 0;
  ColKnown := False;
  
  with TMemoryStream.Create do
  try
    LoadFromFile(FileName);
    Seek(0, soFromBeginning);
    while Position < Size do
    begin
      Read(C, 1);
      if C in ['0'..'9', '.', '-', '+', 'e', 'E'] then S := S + C else
      begin
        if (S <> '') or (Position = Size - 1) then
        begin
          E := AnyStrToFloat(S);
          if E > MaxDouble then E := MaxDouble;
          if E < -MaxDouble then E := -MaxDouble;
          R := E;
          S := '';
          if not ColKnown then Inc(ColCount);
          if (C in [#13, #10]) then ColKnown := True;
          MsGrow(FMStream);
          FMStream.Write(R, 8);
          Inc(ElCount);
        end;
      end;
    end;
    Free;
  except
    Free;
    DoError(matErrorLoadingArray);
  end;
  FMStream.Seek(0, soFromBeginning);

  if (ElCount mod ColCount) <> 0 then DoError(matErrorLoadingArray);
  RowCount := ElCount div ColCount;

  if ArName = '' then
  begin
    Name := ExtractFileName(FileName);
    while Pos('.', Name) > 0 do Delete(Name, Length(Name), 1);
  end else
    Name := ArName;
    
  Adr := GetAddress(NewArray(Name, RowCount, ColCount));
  FMStream.Read(Pointer(Adr)^, RowCount * ColCount * 8);
  FMStream.Clear;
end;

function TWorkspace.SaveArrayToValues(const Name: string): string;
var
  I, J, Rows, Cols, Adr: Integer;
begin
  Result := '';
  Adr := GetAddress(GetSize(Name, Rows, Cols));
  for I := 1 to Rows do
    for J := 1 to Cols do
    begin
      if J < Cols then
        Insert(FloatToStrGen(ElemFast[Adr, I, J, Cols]) + ' ', Result, Length(Result) + 1)
      else
        Insert(FloatToStrGen(ElemFast[Adr, I, J, Cols]) + #13#10, Result, Length(Result) + 1)
    end;
end;

procedure TWorkspace.LoadArrayFromMemory(ArrayName: string;
  ArrayAddress: Pointer; RowCount, ColCount: Integer;
  ElemType: TStandartType);
var
  Adr, I, ElCount: Integer;
  Bextended: Extended;
begin
  Adr := GetAddress(NewArray(ArrayName, RowCount, ColCount));
  ElCount := RowCount * ColCount - 1;

  case ElemType of

    stByte:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Byte(Pointer(Integer(ArrayAddress) + I)^);

    stShortint:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := ShortInt(Pointer(Integer(ArrayAddress) + I)^);

    stWord:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Word(Pointer(Integer(ArrayAddress) + I shl 1)^);

    stSmallint, stShort:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Smallint(Pointer(Integer(ArrayAddress) + I shl 1)^);

    stCardinal, stLongword, stDword:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Cardinal(Pointer(Integer(ArrayAddress) + I shl 2)^);

    stInteger, stLongint:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Integer(Pointer(Integer(ArrayAddress) + I shl 2)^);

    stInt64:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Int64(Pointer(Integer(ArrayAddress) + I shl 3)^);

    stReal, stDouble:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Real(Pointer(Integer(ArrayAddress) + I shl 3)^);

    stReal48:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Real48(Pointer(Integer(ArrayAddress) + I * 6)^);

    stSingle:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Single(Pointer(Integer(ArrayAddress) + I shl 2)^);

    stExtended:
      for I := 0 to ElCount do
      begin
        Bextended := Extended(Pointer(Integer(ArrayAddress) + I * 10)^);
        if Bextended > MaxDouble then Bextended := MaxDouble;
        if Bextended < -MaxDouble then Bextended := -MaxDouble;
        Real(Pointer(Adr + I shl 3)^) := Bextended;
      end;

    stComp:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Comp(Pointer(Integer(ArrayAddress) + I shl 3)^);

    stCurrency:
      for I := 0 to ElCount do
        Real(Pointer(Adr + I shl 3)^) := Currency(Pointer(Integer(ArrayAddress) + I shl 3)^);

    else
      DoError(matBadType);
  end;
end;

procedure TWorkspace.LoadArrayFromStream(ArrayName: string;
  Stream: TStream; Rows, Cols: Integer; ElemType: TStandartType;
  StartByte: DWORD = 0);
var
  I, ElCount, Adr: Integer;
  Buf: array[1..10] of Byte;
  Bextended: Extended;
  Pos: DWORD;
begin
  Pos := Stream.Position;
  Stream.Seek(StartByte, soFromBeginning);
  Adr := GetAddress(NewArray(ArrayName, Rows, Cols));
  ElCount := Rows * Cols - 1;

  case ElemType of

    stByte:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 1);
        Real(Pointer(Adr + I shl 3)^) := Byte(Pointer(@Buf)^);
      end;

    stShortint:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 2);
        Real(Pointer(Adr + I shl 3)^) := ShortInt(Pointer(@Buf)^);
      end;

    stWord:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 2);
        Real(Pointer(Adr + I shl 3)^) := Word(Pointer(@Buf)^);
      end;

    stSmallint, stShort:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 2);
        Real(Pointer(Adr + I shl 3)^) := Smallint(Pointer(@Buf)^);
      end;

    stCardinal, stLongword, stDword:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 4);
        Real(Pointer(Adr + I shl 3)^) := Cardinal(Pointer(@Buf)^);
      end;

    stInteger, stLongint:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 4);
        Real(Pointer(Adr + I shl 3)^) := Integer(Pointer(@Buf)^);
      end;

    stInt64:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 8);
        Real(Pointer(Adr + I shl 3)^) := Int64(Pointer(@Buf)^);
      end;

    stReal, stDouble:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 8);
        Real(Pointer(Adr + I shl 3)^) := Real(Pointer(@Buf)^);
      end;

    stReal48:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 6);
        Real(Pointer(Adr + I shl 3)^) := Real48(Pointer(@Buf)^);
      end;

    stSingle:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 4);
        Real(Pointer(Adr + I shl 3)^) := Single(Pointer(@Buf)^);
      end;

    stExtended:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 10);
        Bextended := Extended(Pointer(@Buf)^);
        if Bextended > MaxDouble then Bextended := MaxDouble;
        if Bextended < -MaxDouble then Bextended := -MaxDouble;
        Real(Pointer(Adr + I shl 3)^) := Bextended;
      end;

    stComp:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 8);
        Real(Pointer(Adr + I shl 3)^) := Comp(Pointer(@Buf)^);
      end;

    stCurrency:
      for I := 0 to ElCount do
      begin
        Stream.Read(Buf, 8);
        Real(Pointer(Adr + I shl 3)^) := Currency(Pointer(@Buf)^);
      end;

    else
      DoError(matBadType);
  end;
  
  Stream.Position := Pos;
end;

procedure TWorkspace.SaveArrayToStream(ArrayName: string; Stream: TStream;
  ElemType: TStandartType; StartByte: Integer = 0);
var
  Adr, I, ElCount, Cols, Rows: Integer;
  Buf: array[1..10] of Byte;
  Pos: DWORD;
begin
  if StartByte < 0 then StartByte := 0;
  Pos := Stream.Position;
  Adr := GetAddress(GetSize(ArrayName, Rows, Cols));
  ElCount := Rows * Cols - 1;

  case ElemType of

    stByte:
      begin
        Stream.Size := StartByte + ElCount;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Byte(Pointer(@Buf)^) := Byte(Round(Real(Pointer(Adr + I shl 3)^)));
          Stream.Write(Buf, 1);
        end;
      end;

    stShortint:
      begin
        Stream.Size := StartByte + ElCount;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          ShortInt(Pointer(@Buf)^) := ShortInt(Round(Real(Pointer(Adr + I shl 3)^)));
          Stream.Write(Buf, 1);
        end;
      end;

    stWord:
      begin
        Stream.Size := StartByte + ElCount * 2;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Word(Pointer(@Buf)^) := Word(Round(Real(Pointer(Adr + I shl 3)^)));
          Stream.Write(Buf, 2);
        end;
      end;

    stSmallint, stShort:
      begin
        Stream.Size := StartByte + ElCount * 2;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Smallint(Pointer(@Buf)^) := Smallint(Round(Real(Pointer(Adr + I shl 3)^)));
          Stream.Write(Buf, 2);
        end;
      end;

    stInteger, stLongint:
      begin
        Stream.Size := StartByte + ElCount * 4;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Integer(Pointer(@Buf)^) := Integer(Round(Real(Pointer(Adr + I shl 3)^)));
          Stream.Write(Buf, 4);
        end;
      end;

    stCardinal, stLongword, stDWord:
      begin
        Stream.Size := StartByte + ElCount * 4;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Cardinal(Pointer(@Buf)^) := Cardinal(Round(Real(Pointer(Adr + I shl 3)^)));
          Stream.Write(Buf, 4);
        end;
      end;

    stInt64:
      begin
        Stream.Size := StartByte + ElCount * 8;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Int64(Pointer(@Buf)^) := Int64(Round(Real(Pointer(Adr + I shl 3)^)));
          Stream.Write(Buf, 8);
        end;
      end;
      
    stReal, stDouble:
      begin
        Stream.Size := StartByte + ElCount * 8;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Real(Pointer(@Buf)^) := Real(Pointer(Adr + I shl 3)^);
          Stream.Write(Buf, 8);
        end;
      end;

    stReal48:
      begin
        Stream.Size := StartByte + ElCount * 6;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Real48(Pointer(@Buf)^) := Real(Pointer(Adr + I shl 3)^);
          Stream.Write(Buf, 6);
        end;
      end;

    stSingle:
      begin
        Stream.Size := StartByte + ElCount * 4;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Single(Pointer(@Buf)^) := Real(Pointer(Adr + I shl 3)^);
          Stream.Write(Buf, 4);
        end;
      end;

    stExtended:
      begin
        Stream.Size := StartByte + ElCount * 10;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Extended(Pointer(@Buf)^) := Real(Pointer(Adr + I shl 3)^);
          Stream.Write(Buf, 10);
        end;
      end;

    stComp:
      begin
        Stream.Size := StartByte + ElCount * 8;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Comp(Pointer(@Buf)^) := Real(Pointer(Adr + I shl 3)^);
          Stream.Write(Buf, 8);
        end;
      end;

    stCurrency:
      begin
        Stream.Size := StartByte + ElCount * 8;
        Stream.Seek(StartByte, soFromBeginning);
        for I := 0 to ElCount do begin
          Currency(Pointer(@Buf)^) := Real(Pointer(Adr + I shl 3)^);
          Stream.Write(Buf, 8);
        end;
      end;

    else
      DoError(matBadType);
  end;

  Stream.Seek(Pos, soFromBeginning);
end;


procedure TWorkspace.SaveArrayToMemory(ArrayName: string; ArrayAddress: Pointer;
  ElemType: TStandartType);
var
  Adr, I, ElCount, Rows, Cols: Integer;   
begin
  Adr := GetAddress(GetSize(ArrayName, Rows, Cols));
  ElCount := Rows * Cols - 1;

  case ElemType of

    stByte:
      for I := 0 to ElCount do
        Byte(Pointer(Integer(ArrayAddress) + I)^) :=
          Byte(Round(Real(Pointer(Adr + I shl 3)^)));

    stShortint:
      for I := 0 to ElCount do
        ShortInt(Pointer(Integer(ArrayAddress) + I)^) :=
          ShortInt(Round(Real(Pointer(Adr + I shl 3)^)));

    stWord:
      for I := 0 to ElCount do
        Word(Pointer(Integer(ArrayAddress) + I shl 1)^) :=
          Word(Round(Real(Pointer(Adr + I shl 3 )^)));

    stSmallint, stShort:
      for I := 0 to ElCount do
        Smallint(Pointer(Integer(ArrayAddress) + I shl 1)^) :=
          Smallint(Round(Real(Pointer(Adr + I shl 3 )^)));

    stInteger, stLongint:
      for I := 0 to ElCount do
        Integer(Pointer(Integer(ArrayAddress) + I shl 2)^) :=
          Integer(Round(Real(Pointer(Adr + I shl 3)^)));

    stCardinal, stLongword, stDword:
      for I := 0 to ElCount do
        Cardinal(Pointer(Integer(ArrayAddress) + I shl 2)^) :=
          Cardinal(Round(Real(Pointer(Adr + I shl 3)^)));

    stInt64:
      for I := 0 to ElCount do
        Int64(Pointer(Integer(ArrayAddress) + I shl 3)^) :=
          Int64(Round(Real(Pointer(Adr + I shl 3)^)));

    stReal, stDouble:
      for I := 0 to ElCount do
        Real(Pointer(Integer(ArrayAddress) + I shl 3)^) := Real(Pointer(Adr + I shl 3)^);

    stReal48:
      for I := 0 to ElCount do
        Real48(Pointer(Integer(ArrayAddress) + I * 6)^) := Real(Pointer(Adr + I shl 3)^);

    stSingle:
      for I := 0 to ElCount do
        Single(Pointer(Integer(ArrayAddress) + I shl 2)^) := Real(Pointer(Adr + I shl 3)^);

    stExtended:
      for I := 0 to ElCount do
        Extended(Pointer(Integer(ArrayAddress) + I * 10)^) := Real(Pointer(Adr + I shl 3)^);

    stComp:
      for I := 0 to ElCount do
        Comp(Pointer(Integer(ArrayAddress) + I shl 3)^) := Real(Pointer(Adr + I shl 3)^);

    stCurrency:
      for I := 0 to ElCount do
        Currency(Pointer(Integer(ArrayAddress) + I shl 3)^) := Real(Pointer(Adr + I shl 3)^);

    else
      DoError(matBadType);

  end;
end;

procedure TWorkspace.FLoadFromTextFile(const FileName: string);
var
  C: Char;
  FormStr: Boolean;
  tStr, tStr2: string;
  fSize, Pos: Cardinal;
  MS: TMemoryStream;
begin
  if not FileExists(FileName) then DoError(matFileNotFound);
  fSize := FileSize(FileName);
  Pos := 0;

  tStr := ' ';
  tStr2 := '';
  FormStr := False;

  MS := TMemoryStream.Create;

  // ��������� ���� ���� � �����
  MS.LoadFromFile(FileName);
  MS.Seek(0, soFromBeginning);
  with MS do begin
    while Position < Size do begin
      Read(C, 1);
      Inc(Pos);

      tStr := tStr[Length(tStr)] + C;
      if (C in ['a'..'z', 'A'..'Z']) and ((tStr[Length(tStr) - 1] <= ' ') or
        (tStr[Length(tStr) - 1] in [']', ';'])) then FormStr := not FormStr;

      if FormStr then Insert(C, tStr2, Length(tStr2) + 1);

      if ((not FormStr) or (Pos >= fSize)) and (tStr2 <> '') then
      begin
        try
          LoadArrayFromString(tStr2);
        except
          MS.Free;
          DoError(matErrorLoadingArray);
        end;
        FormStr := True;
        tStr2 := C;
      end;
    end;
  end;
  MS.Free;
end;

procedure TWorkspace.FLoadArrayFromTextFile(const FileName: string;
  Name: string);
var
  TF: TextFile;
  C: Char;
  FormStr: Boolean;
  tStr, tStr2: string;
  fSize, Pos: Cardinal;
begin
  if not FileExists(FileName) then DoError(matFileNotFound);

  fSize := FileSize(FileName);
  Pos := 0;

  AssignFile(TF, FileName);
  Reset(TF);

  tStr := ' ';
  tStr2 := '';
  FormStr := False;

  while not EOF(TF) do begin
    Read(TF, C);
    Inc(Pos);

    tStr := tStr[Length(tStr)] + C;
    if (C in ['a'..'z', 'A'..'Z']) and ((tStr[Length(tStr) - 1] <= ' ')
      or (tStr[Length(tStr) - 1] in [']', ';'])) then FormStr := not FormStr;

    if FormStr then Insert(C, tStr2, Length(tStr2) + 1);

    if ((not FormStr) or (Pos >= fSize)) and (tStr2 <> '') then
    begin
      try
        if (Length(tStr2) > Length(Name)) and
           (Copy(tStr2, 1, Length(Name)) = Name) and
           (tStr2[Length(Name) + 1] in [#13, #10, ' ', '='])
        then
          LoadArrayFromString(tStr2);
      except
        CloseFile(TF);
        DoError(matErrorLoadingArray);
      end;
      FormStr := True;
      tStr2 := C;
    end;
  end;

  CloseFile(TF);
end;

procedure TWorkspace.SaveToTextFile(const FileName: string; ArName: string = '');
begin
  if ArName = '' then FSaveToTextFile(FileName) else
    FSaveArrayToTextFile(FileName, ArName);
end;

procedure TWorkspace.FSaveArrayToTextFile(const FileName: string;
  Name: string);
var
  Ws: TWorkspace;
begin
  GetSize(Name);
  Ws := SelfWS;
  with TWorkspace.Create('FSaveArrayToTextFile', Ws) do
  begin
    if FileExists(FileName) then FLoadFromTextFile(FileName);
    CopyRef(Ws, Name, Name);
    FSaveToTextFile(FileName);
    Free;
  end;
end;  

procedure TWorkspace.FSaveToTextFile(FileName: string);
var
  TF: TextFile;
  I: Integer;
  Str: string;
begin
  if FArrayList.Count = 0 then Exit;
  if ExtractFileExt(FileName) = '' then FileName := FileName + '.dat';
  AssignFile(TF, FileName);
  Rewrite(TF);
  for I := 0 to FArrayList.Count - 1 do
    if FArrayList[I][1] <> '$' then
    begin
      Str := SaveArrayToString(FArrayList[I]);
      Write(TF, Str);
    end;
  CloseFile(TF);
end;

procedure TWorkspace.LoadFromBinFile(const FileName: string; NameAr: string);
var
  FS: TFileStream;
  cHead, cHead1: array[1..30] of Char;
  ArName: TNameArray;
  Name: string;
  J, ArSize: Integer;
  Rang: TPoint;
  Adr: Integer; 
  TByte, ByteCnt: Byte;
  TWord, DataType: Word;
  TDWord: DWord;

begin
  if FMStream = nil then FMStream := TMemoryStream.Create;
  cHead := matBinaryHeader; //30 b

  if not FileExists(FileName) then DoError(matFileNotFound);

  FS := TFileStream.Create(FileName, fmOpenRead);
  FS.Seek(0, soFromBeginning);
  FS.Read(cHead1, 30); // ��������� ������������ ����������
  if cHead <> cHead1 then begin
    FS.Free;
    DoError(matBadFileFormat);
  end;

  while FS.Position < FS.Size do
  begin
    FS.Read(ArName, 32); // ��������� ��� �������
    Name := ArName;
    Name := Trim(Name);
    FS.Read(Rang, 8);     // ��������� �������
    ArSize := Rang.X * Rang.Y;
    FS.Read(DataType, 2); // ��������� ��� ���������

    case TStandartType(DataType) of
      stByte, stShortint : ByteCnt := 1;
      stWord, stShort    : ByteCnt := 2;
      stDWord, stInteger : ByteCnt := 4;
      else ByteCnt := 8;
    end;

    // ���� ��� ������������ ��� �� ��, ��� �����, �� ����������
    if (not IsTrueName(Name)) or (ArSize = 0) or
       ((NameAr <> '') and (Name <> NameAr)) then
    begin
      FS.Seek(ArSize * ByteCnt, soFromCurrent); // ���������� ��� ��������
      Continue;
    end;
    // ������� ������ Name
    Adr := GetAddress(NewArray(Name, Rang.X, Rang.Y));

    // ���� �������� ������������, �� ����� ��������� �� �����
    if DataType = 0 then FS.Read(Pointer(Adr)^, ArSize * 8) else
    begin
      // � ��������� ������ ��������� ������ � �����
      FMStream.SetSize(ArSize * ByteCnt); // ��������� �������
      FMStream.Seek(0, soFromBeginning);
      // ��������� ���� ������
      FS.Read(Pointer(FMStream.Memory)^, ArSize * ByteCnt);
      FMStream.Seek(0, soFromBeginning);

      case TStandartType(DataType) of
        stByte:
           for J := 1 to ArSize do begin
             FMStream.Read(TByte, 1);
             Real(Pointer(Adr)^) := TByte;
             Inc(Adr, 8);
           end;

        stShortint:
           for J := 1 to ArSize do begin
             FMStream.Read(TByte, 1);
             Real(Pointer(Adr)^) := Shortint(TByte);
             Inc(Adr, 8);
           end;

        stWord:
           for J := 1 to ArSize do begin
             FMStream.Read(TWord, 2);
             Real(Pointer(Adr)^) := TWord;
             Inc(Adr, 8);
           end;

        stShort:
           for J := 1 to ArSize do begin
             FMStream.Read(TWord, 2);
             Real(Pointer(Adr)^) := Short(TWord);
             Inc(Adr, 8);
           end;

        stDWord:
           for J := 1 to ArSize do begin
             FMStream.Read(TDWord, 4);
             Real(Pointer(Adr)^) := TDWord;
             Inc(Adr, 8);
           end;

        stInteger:
           for J := 1 to ArSize do begin
             FMStream.Read(TDWord, 4);
             Real(Pointer(Adr)^) := Integer(TDWord);
             Inc(Adr, 8);
           end;
      end; // of case
    end;
    if NameAr <> '' then Break; // ������ ������ �������, ������� �� �����
  end;
  FS.Free;
  FMStream.Clear;
end;

procedure TWorkspace.PutArrayToMatlab(const Name: string);
var
  I, J, aIdx: Integer;
  Rows, Cols: Integer;
begin
  aIdx := GetSize(Name, Rows, Cols);
  Matlab := CreateOleObject('Matlab.Application');
  if (Rows = 1) and (Cols = 1) then
    MatlabArray := VarArrayCreate([1, 1, 1, 2], varDouble)
  else
    MatlabArray := VarArrayCreate([1, Rows, 1, Cols], varDouble);

  MatlabVar := VarArrayCreate([1, 2], varDouble);
     
  if (Rows = 1) and (Cols = 1) then
  begin
    MatlabArray[1, 1] := ElemI[aIdx, 1, 1];
    MatlabArray[1, 2] := 0;
  end else
    for I := 1 to Rows do
      for J := 1 to Cols do
        MatlabArray[I, J] := ElemI[aIdx, I, J];

  Matlab.PutFullMatrix(Name, 'base', VarArrayRef(MatlabArray),
    VarArrayRef(MatlabVar));
   // ��������� ������ ����������� ������� �����
  if (Rows = 1) and (Cols = 1) then
    Matlab.Execute(Name + ' = ' + Name + '(1)') else
    Matlab.Execute(Name + ' = ' + Name + '(:,:)');
end;


function TWorkspace.LoadArrayFromMatlab(const Name: string): Boolean;
var
  I, J, aIdx: Integer;
  Rows, Cols: Integer;
begin
  Result := False;
  Matlab := CreateOleObject('Matlab.Application');

  MatlabArray := VarArrayCreate([1, 1], varDouble);
  MatlabVar := VarArrayCreate([1, 2], varDouble);

  Matlab.Execute('Matrix_tmp=size(' + Name + ')');
  Matlab.Execute('Matrix_tmp=length(Matrix_tmp)');

  try
    Matlab.GetFullMatrix('Matrix_tmp', 'base', VarArrayRef(MatlabArray), VarArrayRef(MatlabVar));
  except
    Exit;
  end;

  if MatlabArray[1] = 1 then
  begin // ���� �����
    MatlabArray := VarArrayCreate([1, 1], varDouble);
    Matlab.GetFullMatrix(Name, 'base', VarArrayRef(MatlabArray), VarArrayRef(MatlabVar));
    NewArray(Name, 1, 1);
    Elem[Name, 1, 1] := MatlabArray[1]
  end;

  if MatlabArray[1] = 2 then
  begin // �������
    // ����������� ���-�� ����� � ��������
    MatlabArray := VarArrayCreate([1, 1, 1, 2], varDouble);
    Matlab.Execute('Matrix_tmp=size(' + Name + ')');
    Matlab.GetFullMatrix('Matrix_tmp', 'base', VarArrayRef(MatlabArray), VarArrayRef(MatlabVar));
    Rows := MatlabArray[1, 1];
    Cols := MatlabArray[1, 2];
    if Rows * Cols = 0 then Exit;
    MatlabArray := VarArrayCreate([1, Rows, 1, Cols], varDouble);
    Matlab.GetFullMatrix(Name, 'base', VarArrayRef(MatlabArray), VarArrayRef(MatlabVar));
    aIdx := NewArray(Name, Rows, Cols);
    for I := 1 to Rows do
      for J := 1 to Cols do
        ElemI[aIdx, I, J] := MatlabArray[I, J];
  end;
  Matlab.Execute('clear Matrix_tmp');
  Result := True;
end;

function TWorkspace.GetAddress(Idx: Integer): Integer;
begin
  if not ArrayExists(Idx) then DoError(matArrayNotFound);
  Result := FArrayList.ItemsAddr[Idx];
end;

function TWorkspace.GetRowAddress(const Name: string; RowNum: Integer = 1): Pointer;
var
  Adr, Rows, Cols: Integer;
begin
  Adr := GetAddress(GetSize(Name, Rows, Cols));
  if RowNum > Rows then DoError(matBadRow);
  Result := Pointer(Adr + (RowNum - 1) * Cols * 8);
end;

function TWorkspace.GetRowAddress(Idx: Integer; RowNum: Integer = 1): Pointer;
var
  Adr, Rows, Cols: Integer;
begin
  Adr := GetAddress(GetSize(Idx, Rows, Cols));
  if RowNum > Rows then DoError(matBadRow);
  Result := Pointer(Adr + (RowNum - 1) * Cols * 8);
end;

function TWorkspace.GetName(Idx: Integer): string;
begin
  if Idx > FArrayList.Count - 1 then DoError(matArrayNotFound);
  Result := FArrayList[Idx];
  if Result[1] = '$' then DoError(matArrayNotFound);
end;

function TWorkspace.GetRows(const Name: string): Integer;
begin
  Result := FArrayList.ItemsRows[GetIndex(Name)];
end;

function TWorkspace.GetCols(const Name: string): Integer;
begin
  Result := FArrayList.ItemsCols[GetIndex(Name)];
end;

function TWorkspace.GetRows(Idx: Integer): Integer;
begin
  if not ArrayExists(Idx) then DoError(matArrayNotFound);
  Result := FArrayList.ItemsRows[Idx];
end;

function TWorkspace.GetCols(Idx: Integer): Integer;
begin
  if not ArrayExists(Idx) then DoError(matArrayNotFound);
  Result := FArrayList.ItemsCols[Idx];
end;

procedure TWorkspace.SetEl(Idx: Integer; const Value: Real; Row, Col: Integer;
  AutoSize: Boolean);
var
  Rows, Cols, NewRows, NewCols: Integer;
begin
  GetSize(Idx, Rows, Cols);
  if (Row < 1) or (Col < 1) then DoError(matBadCoords);
  if (Row > Rows) or (Col > Cols) then
  begin
    if not AutoSize then DoError(matBadCoords) else
      begin
        NewRows := Max(Row, Rows);
        NewCols := Max(Col, Cols);
        if (NewRows = 1) or (NewCols = 1) then
          Idx := Resize(FArrayList[Idx], NewRows, NewCols)
        else
          Idx := ResizeMatrix(FArrayList[Idx], NewRows, NewCols);
      end;
  end;
  Real(Pointer((FArrayList.ItemsAddr[Idx] + ((Row - 1) * Cols  + Col) shl 3 - 8))^) := Value;
end;  

function TWorkspace.FGetRef(Name: string): TMatrixData;
var
  I: Integer;
begin
  I := Find(Name);
  if I = -1 then begin
    Result.NameArray := '';
    Exit;
  end;
  Result.NameArray := Name;
  Result.Address := FArrayList.ItemsAddr[I];
  Result.Rows := FArrayList.ItemsRows[I];
  Result.Cols := FArrayList.ItemsCols[I];
end;

procedure TWorkspace.FSetRef(Ref: TMatrixData);
var
  f, I: Integer;
begin
  if Ref.NameArray = '' then Exit;
  f := Find(Ref.NameArray);
  if (f = -1) and (FArrayList.Count <> 0) then
    for I := 0 to FArrayList.Count - 1 do
      if FArrayList[I][1] = '$' then
      begin
        f := I;
        Break;
      end;

  if f <> -1 then
  begin
    // ���� ������� � ������ ������, �� ������� ������
    if (FArrayList.ItemsAddr[f] <> 0) and
      (FArrayList.ItemsAddr[f] <> Ref.Address)
      then Clear(Ref.NameArray);
    with FArrayList do
    begin
      ItemsName[f] := Ref.NameArray;
      ItemsRows[f] := Ref.Rows;
      ItemsCols[f] := Ref.Cols;
      ItemsAddr[f] := Ref.Address;
    end;
    Exit;
  end;
  FArrayList.Add(MatrixData(Ref.NameArray, Ref.Rows, Ref.Cols, Ref.Address));
end;

procedure TWorkspace.FDelRef(Name: string);
var
  f: Integer;
begin
  f := Find(Name);
  if f = -1 then Exit;
  FArrayList.Delete(f);   
  FRefList.Remove(Pointer(f));
end;

function TWorkspace.CopyArray(const SourAr, DestAr: string): Integer;
var
  I, K, C, Rows, Cols: Integer;
begin
  I := GetSize(SourAr, Rows, Cols);
  Result := I;
  if SourAr = DestAr then Exit;
  C := Rows * Cols * 8;
  K := NewArray(DestAr, Rows, Cols);
  Result := K;   
  Move(Pointer(FArrayList.ItemsAddr[I])^, Pointer(FArrayList.ItemsAddr[K])^, C);
end;

function TWorkspace.RenameArray(const SourAr, DestAr: string): Integer;
var
  I, ResInd: Integer;
begin
  if not IsTrueName(DestAr) then DoError(matBadName);
  I := GetIndex(SourAr);
  Result := I;
  if SourAr = DestAr then Exit;
  ResInd := Clear(DestAr);    
  if ResInd <> -1 then
  begin
    with FArrayList do
    begin
      ItemsName[ResInd] := DestAr;
      ItemsRows[ResInd] := ItemsRows[I];
      ItemsCols[ResInd] := ItemsCols[I];
      ItemsAddr[ResInd] := ItemsAddr[I];
    end; 
    FArrayList.Delete(I);
    Result := ResInd;
  end else
    FArrayList[I] := DestAr;
  FArrayList.SetIndex(Result);
end;

function TWorkspace.GetElem(const Name: string; Row, Col: Integer): Real;
var
  Idx: Integer;
begin
  Idx := GetIndex(Name);
{$ifdef CheckRange}
  if (Row < 1) or (Col < 1) or (Row > FArrayList.ItemsRows[Idx])
    or (Col > FArrayList.ItemsCols[Idx]) then DoError(matBadRowCol);
{$endif}
  Result := Real(Pointer((FArrayList.ItemsAddr[Idx] + ((Row - 1) *
   FArrayList.ItemsCols[Idx] + Col - 1) shl 3))^);
end;

procedure TWorkspace.SetElem(const Name: string; Row, Col: Integer; const Value: Real);
var
  Idx: Integer;
begin
  Idx := GetIndex(Name);
{$ifdef CheckRange}
  if (Row < 1) or (Col < 1) or (Row > FArrayList.ItemsRows[Idx])
    or (Col > FArrayList.ItemsCols[Idx]) then DoError(matBadRowCol);
{$endif}
  Real(Pointer((FArrayList.ItemsAddr[Idx] + ((Row - 1) *
    FArrayList.ItemsCols[Idx] + Col - 1) shl 3))^) := Value;
end;

function TWorkspace.GetElemI(Idx, Row, Col: Integer): Real;
begin
{$ifdef CheckRange}
  if (Row < 1) or (Col < 1) or (Row > FArrayList.ItemsRows[Idx])
    or (Col > FArrayList.ItemsCols[Idx]) then DoError(matBadRowCol);
{$endif}
  Result := Real(Pointer((FArrayList.ItemsAddr[Idx] +
    ((Row - 1) * FArrayList.ItemsCols[Idx] + Col - 1) shl 3))^);
end;

procedure TWorkspace.SetElemI(Idx, Row, Col: Integer; const Value: Real);
begin
{$ifdef CheckRange}
  if (Row < 1) or (Col < 1) or (Row > FArrayList.ItemsRows[Idx])
    or (Col > FArrayList.ItemsCols[Idx]) then DoError(matBadRowCol);
{$endif}
  Real(Pointer((FArrayList.ItemsAddr[Idx] +
    ((Row - 1) * FArrayList.ItemsCols[Idx] + Col - 1) shl 3))^) := Value;
end;

function TWorkspace.Transpose(const SourAr: string; DestAr: string): string;
var
  NewRowCount, NewColCount, IdS: Integer;
  AdrMain, AdrRes, IRes, MainShift, ResShift, NewColCount8: Integer;
  I, J: Integer;
  TempVar: string;
begin   
  Result := CheckResAr(DestAr);
  IdS := GetSize(SourAr, NewColCount, NewRowCount);
  AdrMain := GetAddress(IdS);
  IRes := Find(DestAr);
  if (IRes <> -1) and (DestAr <> SourAr) and (GetRows(IRes) = NewRowCount) and
    (GetCols(IRes) = NewColCount) then AdrRes := GetAddress(IRes)
  else begin
    TempVar := GenName();
    AdrRes := GetAddress(NewArray(TempVar, NewRowCount, NewColCount));
  end;
  if (NewColCount = 1) or (NewRowCount = 1) then
    Move(Pointer(AdrMain)^, Pointer(AdrRes)^, NewRowCount * NewColCount * 8)
  else
  
  begin
    NewColCount8 := NewColCount * 8;
    for I := 0 to NewColCount - 1 do
    begin
      MainShift := I * NewRowCount * 8;
      ResShift := I * 8;
      for J := 1 to NewRowCount do
      begin
        Real(Pointer(AdrRes + ResShift)^) := Real(Pointer(AdrMain + MainShift)^);
        Inc(ResShift, NewColCount8);
        Inc(MainShift, 8);
      end;
    end;
  end;

  if TempVar <> '' then RenameArray(TempVar, DestAr); 
end;

function TWorkspace.CheckResAr(var Name: string; DoANS: Boolean = True): string;
begin
  if DoANS and (Name = '') then Name := 'ans' else
    if not IsTrueName(Name) then DoError(matBadName);
  Result := Name;
end;

function TWorkspace.IsTrueName(const Name: string): Boolean;
var
  I, Len: Integer;
begin
  Result := False;
  Len := Length(Name);
  if (Len = 0) or (Len > 32) then Exit;
  if not (Name[1] in ['A'..'Z', 'a'..'z']) then Exit;
  for I := 2 to Len do
    if not (Name[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_']) then Exit;
  Result := True;
end;

function TWorkspace.HandInput(var InputArray,
  TempArray: string): Integer;
var
  I: Integer;
begin
  I := Find(InputArray);    
  if I <> -1 then
  begin
    Result := I;
    Exit;
  end;
  if InputArray <> '' then
    if InputArray[1] in ['0'..'9', '.', '-', '+', '['] then
    begin
      TempArray := GenName();
      SLoad(TempArray, InputArray);
      InputArray := TempArray;
      Result := GetIndex(InputArray);
      Exit;
    end;
  Result := -1;
  DoError(matArrayNotFound);
end;

function TWorkspace.GenName(Str: string = ''): string;
begin
  if Str <> '' then Result := 'I_' + Str + '_TV' else begin
    Inc(FUniqueNameCounter);
    Result := 'I_' + IntToStr(FUniqueNameCounter) + '_TV';
    if FUniqueNameCounter >= MaxComp then
    begin
      FUniqueNameCounter := 0;
      if MessageBox(GetActiveWindow, matCalcLimit, 'Warning!',
        MB_ICONWARNING or MB_OKCANCEL) = IDCANCEL then DoError('');
    end;
  end;
end;

function TWorkspace.AddRows(const SourAr1, SourAr2: string; DestAr: string): string;
var
  ColCnt1, ColCnt2, ColCntRes: Integer;
  RowCnt1, RowCnt2, RowCntRes: Integer;
  Adr1, Adr2, AdrRes: Integer;
  TempRes: string;
begin  
  Result := CheckResAr(DestAr);
  if (SourAr1 = DestAr) and (Find(DestAr) = -1) then
  begin
    CopyArray(SourAr2, DestAr);
    Exit;
  end;
  if (SourAr2 = DestAr) and (Find(DestAr) = -1) then
  begin
    CopyArray(SourAr1, DestAr);
    Exit;
  end;
  TempRes := GenName();
  Adr1 := GetAddress(GetSize(SourAr1, RowCnt1, ColCnt1));
  Adr2 := GetAddress(GetSize(SourAr2, RowCnt2, ColCnt2));
  if ColCnt1 <> ColCnt2 then DoError(matArraysNotAgree);
  ColCntRes := ColCnt1;
  RowCntRes := RowCnt1 + RowCnt2;
  AdrRes := GetAddress(NewArray(TempRes, RowCntRes, ColCntRes));
  Move(Pointer(Adr1)^, Pointer(AdrRes)^, RowCnt1 * ColCnt1 * 8);
  Move(Pointer(Adr2)^, Pointer(AdrRes + RowCnt1 * ColCnt1 * 8)^, RowCnt2 * ColCnt2 * 8);
  RenameArray(TempRes, DestAr);
end;

function TWorkspace.AddCols(const SourAr1, SourAr2: string; DestAr: string): string;
var
  ColCnt1, ColCnt2, ColCntRes: Integer;
  RowCnt1, RowCnt2, RowCntRes: Integer;
  Adr1, Adr2, AdrRes: Integer;
  I: Integer;
  CurrentAddress: Integer;
  TempRes: string;
begin
  Result := CheckResAr(DestAr);
  if (SourAr1 = DestAr) and (Find(DestAr) = -1) then
  begin
    CopyArray(SourAr2, DestAr);
    Exit;
  end;
  if (SourAr2 = DestAr) and (Find(DestAr) = -1) then
  begin
    CopyArray(SourAr1, DestAr);
    Exit;
  end;
  TempRes := GenName();
  Adr1 := GetAddress(GetSize(SourAr1, RowCnt1, ColCnt1));
  Adr2 := GetAddress(GetSize(SourAr2, RowCnt2, ColCnt2));
  if RowCnt1 <> RowCnt2 then DoError(matArraysNotAgree);
  RowCntRes := RowCnt1;
  ColCntRes := ColCnt1 + ColCnt2;
  AdrRes := GetAddress(NewArray(TempRes, RowCntRes, ColCntRes));
  CurrentAddress := AdrRes; 
  ColCnt1 := ColCnt1 shl 3;
  ColCnt2 := ColCnt2 shl 3;
  for I := 0 to RowCntRes-1 do
  begin
    Move(Pointer(Adr1)^, Pointer(CurrentAddress)^, ColCnt1);
    Inc(CurrentAddress, ColCnt1);
    Move(Pointer(Adr2)^, Pointer(CurrentAddress)^, ColCnt2);
    Inc(CurrentAddress, ColCnt2);
    Inc(Adr1, ColCnt1);
    Inc(Adr2, ColCnt2);
  end;
  RenameArray(TempRes, DestAr);
end;

function TWorkspace.CopyCutRows(SourAr, DestAr: string;
  RowNumber, Rows: Integer; Cut: Boolean = False): string;
var
  AdrMat1, AdrMat2, AdrMatRes, Idx, iTmp: Integer;
  ColCnt, RowCnt: Integer;
  TempRes, Temp2: string;
begin 
  Result := CheckResAr(DestAr);
  Temp2 := GenName();
  TempRes := GenName();
  AdrMat1 := GetAddress(GetSize(SourAr, RowCnt, ColCnt));
  if (RowCnt < RowNumber) or (RowNumber < 1) then DoError(matBadRow);
  if RowNumber + Rows > RowCnt + 1 then DoError(matBadRow);
  // ������� ��������� ������
  // ���� ���. ������ ��� ���� � ����� ����������� �����������, ��
  // ��� ������������� ��������� ��� ������
  Idx := Find(DestAr);
  if (Idx <> -1) and (GetRows(Idx) = Rows) and (GetCols(Idx) = ColCnt) then
    AdrMatRes := GetAddress(RenameArray(DestAr, TempRes)) else
    AdrMatRes := GetAddress(NewArray(TempRes, Rows, ColCnt));
   // �������� ������ �� ��������� ������
  Move(Pointer(AdrMat1 + (RowNumber - 1) * ColCnt shl 3)^,
    Pointer(AdrMatRes)^, (ColCnt shl 3) * Rows);
   // ���� ����� ���� ��������, �� ...
  if Cut and (Rows < RowCnt) then
  begin
    AdrMat2 := GetAddress(NewArray(Temp2, RowCnt - Rows, ColCnt));
    ColCnt := ColCnt * 8;
    Dec(RowNumber);
    iTmp := ColCnt * RowNumber;
    Move(Pointer(AdrMat1)^, Pointer(AdrMat2)^, iTmp); 
    Move(Pointer(AdrMat1 + iTmp + ColCnt * Rows)^, Pointer(AdrMat2 + iTmp)^,
      ColCnt * (RowCnt - Rows) - iTmp);
    RenameArray(Temp2, SourAr);
  end;
  // ���� �� ��������� ������� ������ �� ��������, �� ������� ���
  if Cut and (Rows >= RowCnt) then Clear(SourAr);
  RenameArray(TempRes, DestAr);
  Clear(Temp2);
end;

function TWorkspace.CopyCutCols(SourAr, DestAr: string; ColNumber,
  Cols: Integer; Cut: Boolean): string;
var
  IndMat2, Idx: Integer;
  AdrMat1, AdrMat2, AdrMatRes, tmpCols, tmpCNumber, tmpAdr, tmpCCnt: Integer;
  ColCnt, RowCnt: Integer;
  Mat2CC: Integer;
  I: Integer;
  Temp2, TempRes: string;
begin
  Result := CheckResAr(DestAr);
  AdrMat1 := GetAddress(GetSize(SourAr, RowCnt, ColCnt));
  if (ColCnt < ColNumber) or (ColNumber < 1) then DoError(matBadCol);
  if ColNumber + Cols > ColCnt + 1 then DoError(matBadCol);
  Temp2 := GenName();
  TempRes := GenName();
  // ������� ��������� ������, ���� ����� ������������ �������
  Idx := Find(DestAr);
  if (Idx <> -1) and (GetRows(Idx) = RowCnt) and (GetCols(Idx) = Cols) then
    AdrMatRes := GetAddress(RenameArray(DestAr, TempRes))
  else
    AdrMatRes := GetAddress(NewArray(TempRes, RowCnt, Cols));
    
  // �������� ������� �� ��������� ������
  tmpCols := Cols shl 3;
  tmpCCnt := ColCnt shl 3;
  tmpCNumber := (ColNumber - 1) shl 3;
  tmpAdr := AdrMat1 + tmpCNumber;
  for I := 0 to RowCnt-1 do
  begin
    Move(Pointer(tmpAdr)^, Pointer(AdrMatRes)^, tmpCols);
    Inc(tmpAdr, tmpCCnt);
    Inc(AdrMatRes, tmpCols);
  end;
  
  // ���� ����� ���� ��������, �� ...
  if Cut and (Cols < ColCnt) then
  begin
    // ������� ����� ��������� ����������
    IndMat2 := NewArray(Temp2, RowCnt, ColCnt - Cols);
    AdrMat2 := GetAddress(IndMat2);
    Mat2CC := GetCols(IndMat2);

    ColNumber := (ColNumber - 1) shl 3;
    tmpCols := Cols shl 3 + ColNumber;
    tmpCCnt := ColCnt shl 3;
    Mat2CC := Mat2CC shl 3;
    for I := 1 to RowCnt do
    begin
      Move(Pointer(AdrMat1)^, Pointer(AdrMat2)^, ColNumber);
      Move(Pointer(AdrMat1 + tmpCols)^, Pointer(AdrMat2 + ColNumber)^, Mat2CC - ColNumber);
      Inc(AdrMat1, tmpCCnt);
      Inc(AdrMat2, Mat2CC);
    end;
    RenameArray(Temp2, SourAr);
  end;
  if Cut and (Cols >= ColCnt) then Clear(SourAr);
  RenameArray(TempRes, DestAr);
  Clear(Temp2);
end;

function TWorkspace.CopySubmatrix(SourAr, DestAr: string; FirstRow, Rows,
  FirstCol, Cols: Integer): string;
var
  RowCnt, ColCnt, I, Idx: Integer;
  Adr1, Adr2: Integer;
  Temp1: string;
begin
  if (FirstRow < 1) or (FirstCol < 1) then DoError(matBadRowCol);
  Result := CheckResAr(DestAr);
  Adr1 := GetAddress(GetSize(SourAr, RowCnt, ColCnt)) +
    ((FirstRow - 1) * ColCnt + FirstCol - 1) shl 3;
    
  if (FirstRow > RowCnt) or (FirstCol > ColCnt) then DoError(matBadRowCol);
  if (FirstRow + Rows - 1 > RowCnt) or (FirstCol + Cols - 1 > ColCnt) then
    DoError(matBadRowCol);
  Temp1 := GenName();

  Idx := Find(DestAr);
  if (Idx <> -1) and (GetRows(Idx) = Rows) and (GetCols(Idx) = Cols)
    then Temp1 := DestAr else NewArray(Temp1, Rows, Cols, True);
  Adr2 := GetAddress(Temp1);

  ColCnt := ColCnt shl 3;
  Cols := Cols shl 3;
  for I := 1 to Rows do
  begin
    Move(Pointer(Adr1)^, Pointer(Adr2)^, Cols);
    Inc(Adr1, ColCnt);
    Inc(Adr2, Cols);
  end;             
  // ��������������� ��������� ������ � ��������������
  if Temp1 <> DestAr then RenameArray(Temp1, DestAr);
end;

function TWorkspace.PasteSubmatrix(SourAr, DestAr: string; FirstPastRow,
  FirstPastCol: Integer): string;
var
  RowCnt, ColCnt, Id1, Id2: Integer;
  MinDestRowCnt, MinDestColCnt: Integer;
  ResRowCnt, ResColCnt: Integer;
  Adr1, Adr2, I: Integer;
begin
  if SourAr = DestAr then DoError(matErrorPast);
  Result := CheckResAr(DestAr);
  if (FirstPastRow < 1) or (FirstPastCol < 1) then DoError(matBadRowCol);
  Id1 := GetSize(SourAr, RowCnt, ColCnt);
  // ���������� ���������� ���������� ������� �������������� �������
  MinDestRowCnt := RowCnt + FirstPastRow - 1;
  MinDestColCnt := ColCnt + FirstPastCol - 1;
  Id2 := Find(DestAr);
  if Id2 <> -1 then
  begin
    GetSize(Id2, ResRowCnt, ResColCnt);
    if (ResRowCnt < MinDestRowCnt) or (ResColCnt < MinDestColCnt) then
      DoError(matArraysNotAgree);
  end else
  begin
    ResRowCnt := MinDestRowCnt;
    ResColCnt := MinDestColCnt;
    Id2 := NewArray(DestAr, ResRowCnt, ResColCnt, True);
  end;
  Adr1 := GetAddress(Id1);
  Adr2 := GetAddress(Id2) +
   ((FirstPastRow - 1) * ResColCnt + FirstPastCol - 1) shl 3;

  ColCnt := ColCnt shl 3;
  ResColCnt := ResColCnt shl 3;
  for I := 1 to RowCnt do
  begin
    Move(Pointer(Adr1)^, Pointer(Adr2)^, ColCnt);
    Inc(Adr1, ColCnt);
    Inc(Adr2, ResColCnt);
  end;
end;

function TWorkspace.ResizeMatrix(const Name: string; Rows, Cols: Integer): Integer;
var
  Temp: string;
  RC, CC, Ind: Integer;
begin
  if (Rows < 1) or (Cols < 1) then DoError(matBadSize);
  Ind := Find(Name);
  if Ind = -1 then begin
    Result := NewArray(Name, Rows, Cols, True);
    Exit;
  end; 
  GetSize(Ind, RC, CC);
  Result := Ind;
  if Int64(Point(RC, CC)) = Int64(Point(Rows, Cols)) then Exit;
  Temp := GenName();
  CopySubmatrix(Name, Temp, 1, Min(Rows, RC), 1, Min(Cols, CC));
  Result := NewArray(Name, Rows, Cols, True);
  PasteSubmatrix(Temp, Name, 1, 1);
  Clear(Temp);
end;

function TWorkspace.RandomAr(const Name: string; Rows, Cols: Integer): string;
var
  Adr, I: Integer;
begin
  if (Rows = 0) or (Cols = 0) then
    Adr := GetAddress(GetSize(Name, Rows, Cols))
  else
    Adr := GetAddress(NewArray(Name, Rows, Cols));
    
  for I := 1 to Rows * Cols do
  begin
    Real(Pointer(Adr)^) := Random;
    Inc(Adr, 8);
  end;
  Result := Name;
end;

function TWorkspace.FillAr(const Name: string; BaseValue: Real; Step: Extended): string;
var
  Rows, Cols, Adr, I: Integer;
  TmpValue: Extended;
begin
  Adr := GetAddress(GetSize(Name, Rows, Cols));
  TmpValue := BaseValue;
  for I := 1 to Rows * Cols do
  begin
    Real(Pointer(Adr)^) := TmpValue;
    TmpValue := TmpValue + Step;
    Inc(Adr, 8);
  end;
  Result := Name;
end;

function TWorkspace.NewFillAr(const Name: string; Rows, Cols: Integer;
  const BaseValue: Real; Step: Extended): string;
begin
  NewArray(Name, Rows, Cols);
  Result := FillAr(Name, BaseValue, Step);
end;

function TWorkspace.MulMatrix(const Matrix1, Matrix2: string; MatResult: string): string;
var
  M1Rows, M2Rows, M1Cols, M2Cols, I, J, K, Adr1, Adr2, AdrRes, IRes: Integer;
  Adr2Temp, M2Cols8, M2Rows8: Integer;
  Tmp: Real;
  TempRes: string;
begin
  Result := CheckResAr(MatResult);
  Adr1 := GetAddress(GetSize(Matrix1, M1Rows, M1Cols));
  Adr2 := GetAddress(GetSize(Matrix2, M2Rows, M2Cols));
  if M1Cols <> M2Rows then DoError(matArraysNotAgree);
  IRes := Find(MatResult);
  if (IRes <> -1) and (MatResult <> Matrix1) and (MatResult <> Matrix2) and
    (GetRows(IRes) = M1Rows) and (GetCols(IRes) = M2Cols) then
    AdrRes := GetAddress(IRes)
  else begin
    TempRes := GenName();
    AdrRes := GetAddress(NewArray(TempRes, M1Rows, M2Cols));
  end;
  M1Cols := M1Cols shl 3;
  M2Cols8 := M2Cols shl 3;
  M2Rows8 := M2Rows shl 3;
  for I := 1 to M1Rows do
  begin
    for J := 1 to M2Cols do
    begin
      Tmp := 0;
      Adr2Temp := Adr2;
      for K := 1 to M2Rows do
      begin
        Tmp := Tmp + Real(Pointer(Adr1)^) * Real(Pointer(Adr2)^);
        Inc(Adr1, 8);
        Inc(Adr2, M2Cols8);
      end;
      Adr2 := Adr2Temp + 8;
      Real(Pointer(AdrRes)^) := Tmp;
      Dec(Adr1, M2Rows8);
      Inc(AdrRes, 8);
    end;
    Inc(Adr1, M1Cols);
    Dec(Adr2, M2Cols8);
  end;
  if TempRes <> '' then RenameArray(TempRes, MatResult);
end;

function TWorkspace.IsEqual(const Array1, Array2: string; ResArray: string = ''):
  Boolean;
var
  I, Adr1, Adr2, Rows1, Rows2, Cols1, Cols2: Integer;
begin
  if ResArray <> '' then
    if not IsTrueName(ResArray) then DoError(matBadName);
  if (ResArray = Array1) or (ResArray = Array2) then DoError(matBadName);
  if ResArray <> '' then NewZeros(ResArray, 1, 1);
  Result := False;
  Adr1 := GetAddress(GetSize(Array1, Rows1, Cols1));
  Adr2 := GetAddress(GetSize(Array2, Rows2, Cols2));
  if not (Int64(Point(Rows1, Cols1)) = Int64(Point(Rows2, Cols2))) then Exit;

  for I := 1 to Rows1 * Cols1 do
  begin
    if Real(Pointer(Adr1)^) <> Real(Pointer(Adr2)^) then Exit;
    Inc(Adr1, 8);
    Inc(Adr2, 8);
  end;

  Result := True;
  if ResArray <> '' then NewOnes(ResArray, 1, 1);;
end;

function TWorkspace.SLoad(const Str: string): string;
begin
  Result := LoadArrayFromString(Str);
end;

function TWorkspace.SLoad(const Name, Values: string): string;
begin
  Result := LoadArrayFromString(Name + '=' + Values);
end;

function TWorkspace.CopyArray(SourWS: TWorkspace; const SourAr,
  DestAr: string): Integer;
var
  Rows, Cols, DestAdr: Integer;
  SourAdr: Pointer;
begin
  // ���������� ������� �������
  if not SourWS.ArrayExists(SourAr) then DoError(matArrayNotFound);
  SourAdr := Pointer(SourWS.GetAddress(SourAr));
  SourWS.GetSize(SourAr, Rows, Cols);   
  // ������� � ������� ������� ������� ������
  Result := NewArray(DestAr, Rows, Cols);
  DestAdr := GetAddress(Result);
  // �������� ������
  Move(SourAdr^, Pointer(DestAdr)^, Rows * Cols shl 3);
end;

procedure TWorkspace.MoveArray(DestWS: TWorkspace; const SourAr, DestAr: string);
var
  Ref: TMatrixData;
  Idx: Integer;
begin
  if SelfWS = DestWS then DoError(matWorkspaceError);
  Idx := GetIndex(SourAr);
  if not IsTrueName(DestAr) then DoError(matBadName);
  if (FRefList.IndexOf(Pointer(Idx)) <> -1) then DoError(matReturnError);
  Ref := FGetRef(SourAr);
  Ref.NameArray := DestAr;
  DestWS.FSetRef(Ref);
  FDelRef(SourAr);
  DestWS.FElemCount := DestWS.FElemCount + Ref.Rows * Ref.Cols;
end;

function TWorkspace.CopyRef(SourWS: TWorkspace; const SourAr,
  DestAr: string): Integer;
var
  Ref: TMatrixData;
begin
  if SelfWS = SourWS then DoError(matWorkspaceError);
  if (not IsTrueName(DestAr)) then DoError(matBadName);
  if not SourWS.ArrayExists(SourAr) then DoError(matArrayNotFound);
  Ref := SourWS.FGetRef(SourAr);
  Ref.NameArray := DestAr;
  FSetRef(Ref);
  Result := GetIndex(DestAr);
  if FRefList.IndexOf(Pointer(Result)) = -1 then
    FRefList.Add(Pointer(Result));
end;

function TWorkspace.LoadArray(const SourAr, DestAr: string;
  ByRef: Boolean = True): Integer;
begin
  if ByRef then
    Result := CopyRef(ParentWS, SourAr, DestAr)
  else
    Result := CopyArray(ParentWS, SourAr, DestAr);
end;

procedure TWorkspace.ReturnArray(const SourAr, DestAr: string);
begin
  MoveArray(ParentWS, SourAr, DestAr);
end;

function TWorkspace.SumRows(SourAr, DestAr: string): string;
var
  sAdr, IdxR, Rows, Cols, I, J: Integer;
  Temp: string;
  R: Extended;
begin
  sAdr := GetAddress(GetSize(SourAr, Rows, Cols));
  Result := CheckResAr(DestAr);
  Temp := GenName();
  IdxR := NewArray(Temp, 1, Cols);
  for I := 1 to Cols do
  begin
    R := 0;
    for J := 1 to Rows do
      R := R + ElemFast[sAdr, J, I, Cols];
    ElemI[IdxR, 1, I] := R;
  end;
  RenameArray(Temp, DestAr);
end;

function TWorkspace.SumCols(SourAr, DestAr: string): string;
var
  IdxR, Rows, Cols, I, J, sAdr: Integer;
  Temp: string;
  R: Extended;
begin
  Result := CheckResAr(DestAr);
  sAdr := GetAddress(GetSize(SourAr, Rows, Cols));
  Temp := GenName();
  IdxR := NewArray(Temp, Rows, 1);
  for I := 1 to Rows do
  begin
    R := 0;
    for J := 1 to Cols do
      R := R + ElemFast[sAdr, I, J, Cols];
    ElemI[IdxR, I, 1] := R;
  end;
  RenameArray(Temp, DestAr);
end;

function TWorkspace.CalcFunc(const SourAr: string; DestAr: string; Func: TRealFunc): string;
var
  ElCount, I, sIdx, dIdx: Integer;
  Rows, Cols: Integer;
  sAdr, dAdr: Integer;
  Temp: string;
begin
  Result := CheckResAr(DestAr);
  sIdx := GetSize(SourAr, Rows, Cols);
  ElCount := Rows * Cols;
  sAdr := GetAddress(sIdx);
  dIdx := Find(DestAr);
  if (dIdx <> -1) and (GetSize(dIdx) = ElCount) then dAdr := GetAddress(dIdx)
  else begin
    Temp := GenName();
    dAdr := GetAddress(NewArray(Temp, Rows, Cols))
  end;

  try
    for I := 1 to ElCount do
    begin
      Real(Pointer(dAdr)^) := Func(Real(Pointer(sAdr)^));
      Inc(dAdr, 8);
      Inc(sAdr, 8);
    end;
  except
    if Temp <> '' then Clear(Temp);
    DoError(matCalcFuncError);
  end;

  if Temp <> '' then RenameArray(Temp, DestAr) else
    if not SizeEqual(sIdx, dIdx) then Resize(DestAr, Rows, Cols);
end;

function TWorkspace.CalcFunc(const SourAr: string; DestAr: string; Func: TExtendFunc): string;
var
  ElCount, I, sIdx, dIdx: Integer;
  Rows, Cols: Integer;
  sAdr, dAdr: Integer;
  Temp: string;
begin
  Result := CheckResAr(DestAr);
  sIdx := GetSize(SourAr, Rows, Cols);
  ElCount := Rows * Cols;
  sAdr := GetAddress(sIdx);
  dIdx := Find(DestAr);
  if (dIdx <> -1) and (GetSize(dIdx) = ElCount) then dAdr := GetAddress(dIdx)
  else begin
    Temp := GenName();
    dAdr := GetAddress(NewArray(Temp, Rows, Cols))
  end;

  try
    for I := 1 to ElCount do
    begin
      Real(Pointer(dAdr)^) := Func(Real(Pointer(sAdr)^));
      Inc(dAdr, 8);
      Inc(sAdr, 8);
    end;
  except
    if Temp <> '' then Clear(Temp);
    DoError(matCalcFuncError);
  end;

  if Temp <> '' then RenameArray(Temp, DestAr) else
    if not SizeEqual(sIdx, dIdx) then Resize(DestAr, Rows, Cols);
end;


function TWorkspace.CalcFunc2(const SourArray1, SourArray2: Variant; DestAr: string;
  Func: TRealFunc2): string;
var
  I, Adr1, Adr2, dAdr, Rows, Cols, ElCount, dIdx, sIdx1, sIdx2, Size2: Integer;
  IsValue1, IsValue2: Boolean;
  Value1, Value2: Real;
  Tmp, SourAr1, SourAr2: string;
begin    
  IsValue1 := False; IsValue2 := False;
  Value1 := 0; Value2 := 0;
  Adr1 := 0; Adr2 := 0;
  Result := CheckResAr(DestAr);      
  
  if VarType(SourArray1) and varTypeMask = varString then
  begin
    SourAr1 := SourArray1;
    sIdx1 := GetIndex(SourAr1);
    Adr1 := GetAddress(GetSize(sIdx1, Rows, Cols));
    if (Rows = 1) and (Cols = 1) then
    begin
      IsValue1 := True;
      Value1 := Real(Pointer(Adr1)^);
    end;
  end else
  begin
    IsValue1 := True;
    Value1 := SourArray1;
  end;

  if VarType(SourArray2) and varTypeMask = varString then
  begin
    SourAr2 := SourArray2;
    sIdx2 := GetIndex(SourAr2);
    Adr2 := GetAddress(sIdx2);
    Size2 := GetSize(sIdx2);
    if Size2 = 1 then
    begin
      IsValue2 := True;
      Value2 := Real(Pointer(Adr2)^);
    end else
    begin
      if not IsValue1 and (Size2 <> Rows * Cols) then
        DoError(matArraysNotAgree);
      GetSize(sIdx2, Rows, Cols);
    end;
  end else
  begin
    IsValue2 := True;
    Value2 := SourArray2;
  end;
  
  try
    if IsValue1 and IsValue2 then
    begin
      NewFillAr(Result, 1, 1, Func(Value1, Value2), 0);
      Exit;
    end;
  except
    DoError(matCalcFuncError);
  end;

  ElCount := Rows * Cols;

  dIdx := Find(DestAr);
  if (dIdx > -1) and (GetSize(dIdx) = ElCount) then
     dAdr := GetAddress(dIdx) else
  begin
    Tmp := GenName();
    dIdx := NewArray(Tmp, Rows, Cols);
    dAdr := GetAddress(dIdx);
  end;

  try
  
    if IsValue1 then
      for I := 1 to ElCount do
      begin
        Real(Pointer(dAdr)^) := Func(Value1, Real(Pointer(Adr2)^));
        Inc(dAdr, 8);
        Inc(Adr2, 8);
      end
    else
    if IsValue2 then
      for I := 1 to ElCount do
      begin
        Real(Pointer(dAdr)^) := Func(Real(Pointer(Adr1)^), Value2);
        Inc(dAdr, 8);
        Inc(Adr1, 8);
      end
    else
      for I := 1 to ElCount do
      begin
        Real(Pointer(dAdr)^) := Func(Real(Pointer(Adr1)^), Real(Pointer(Adr2)^));
        Inc(dAdr, 8);
        Inc(Adr1, 8);
        Inc(Adr2, 8);
      end;

  except
    DoError(matCalcFuncError);
  end;

  if Tmp <> '' then RenameArray(Tmp, DestAr) else
    if (GetRows(dIdx) <> Rows) or (GetCols(dIdx) <> Cols) then
      Resize(DestAr, Rows, Cols);
end;

function TWorkspace.ArrayExists(const Name: string): Boolean;
begin
  Result := not (Find(Name) = -1);
end;

function TWorkspace.NewFillAr(const Name: string; const FirstValue, LastValue: Real;
  ElemCount: Integer): string;
var
  Step: Extended;
  Idx: Integer;
begin
  // ���������� ��� ��������� ���, ����� ���������� ��������� ����� �����
  Step := (LastValue - FirstValue) / (ElemCount - 1);
  Idx := NewArray(Name, 1, ElemCount);
  FillAr(Name, FirstValue, Step);
  // � ���������� ����������� ������������ ����� ��������� �������� ��������� �������
  ElemI[Idx, 1, ElemCount] := LastValue;
  Result := Name;
end;

function TWorkspace.GetArrayCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  if FArrayList.Count = 0 then Exit;
  for I := 0 to FArrayList.Count - 1 do
    if FArrayList[I][1] <> '$' then Inc(Result);
end;

function TWorkspace.GetArrayListSize(): Integer;
begin
  Result := FArrayList.Count;
end;

procedure TWorkspace.GetNameList(List: TStrings);
var
  I: Integer;
begin
  List.Clear;
  if FArrayList.Count = 0 then Exit;
  for I := 0 to FArrayList.Count - 1 do
    if FArrayList[I][1] <> '$' then
      List.Add(FArrayList[I]);
end;

function TWorkspace.GetSize(Idx: Integer; var Rows,
  Cols: Integer): Integer;
begin
  if not FArrayList.ArrayExistsForIndex(Idx) then DoError(matBadName);
  Rows := FArrayList.ItemsRows[Idx];
  Cols := FArrayList.ItemsCols[Idx];
  Result := Idx;
end;

function TWorkspace.ArrayExists(Idx: Integer): Boolean;
begin
  Result := FArrayList.ArrayExistsForIndex(Idx);
end;

function TWorkspace.SLoad(const Name: string; const Value: Real): string;
begin
  Result := NewFillAr(Name, 1, 1, Value, 0);
end;

function TWorkspace.InsertRows(const RowsAr: string; DestAr: string;
  Row: Integer): string;
var
  Rows1, Cols1, Rows2, Cols2, RowsR, ColsR, Adr1, Adr2, AdrR, iTmp: Integer;
  TempR: string;
begin
  Result := CheckResAr(DestAr);
  if (Row < 1) then DoError(matBadRow);
  // ���������� ������� � ����� ������������ �������
  Adr1 := GetAddress(GetSize(RowsAr, Rows1, Cols1));
  if (Find(DestAr) = -1) and (Row = 1) then
  begin
    CopyArray(RowsAr, DestAr);
    Exit;
  end;
  // ���������� ������� � ����� ������� DestAr
  Adr2 := GetAddress(GetSize(DestAr, Rows2, Cols2));
  if Row > Rows2 then DoError(matBadRow);
  if Cols1 <> Cols2 then DoError(matBadCol);  

  RowsR := Rows1 + Rows2;
  ColsR := Cols1;
  // ������� �������������� ������
  TempR := GenName();
  AdrR := GetAddress(NewArray(TempR, RowsR, ColsR, False));

  ColsR := ColsR shl 3; 
  iTmp := ColsR * (Row - 1);

  Move(Pointer(Adr2)^, Pointer(AdrR)^, iTmp);
  Move(Pointer(Adr1)^, Pointer(AdrR + iTmp)^, Rows1 * Cols1 shl 3); 
  Move(Pointer(Adr2 + iTmp)^, Pointer(AdrR + iTmp + Rows1 * ColsR)^, Rows2 * ColsR - iTmp);

  RenameArray(TempR, DestAr);
end;

function TWorkspace.InsertCols(const ColsAr: string; DestAr: string;
  Col: Integer): string;
var
  Rows1, Cols1, Rows2, Cols2, RowsR, ColsR, Adr1, Adr2, AdrR, I: Integer;
  TempR: string;
begin    
  Result := CheckResAr(DestAr);
  if (Col < 1) then DoError(matBadCol);
  // ���������� ������� � ����� ������������ �������
  Adr1 := GetAddress(GetSize(ColsAr, Rows1, Cols1));
  if (Find(DestAr) = -1) and (Col = 1) then
  begin
    CopyArray(ColsAr, DestAr);
    Exit;
  end;
  // ���������� ������� � ����� ������� DestAr
  Adr2 := GetAddress(GetSize(DestAr, Rows2, Cols2));
  if (Col > Cols2) then DoError(matBadRow);
  if Rows1 <> Rows2 then DoError(matBadCol);

  ColsR := Cols1 + Cols2;
  RowsR := Rows1;
  // ������� �������������� ������
  TempR := GenName();
  AdrR := GetAddress(NewArray(TempR, RowsR, ColsR, False));

  Col := (Col - 1) * 8;
  Cols1 := Cols1 * 8;
  Cols2 := Cols2 * 8;
  ColsR := ColsR * 8;
  for I := 1 to RowsR do
  begin
    Move(Pointer(Adr2)^, Pointer(AdrR)^, Col);
    Move(Pointer(Adr1)^, Pointer(AdrR + Col)^, Cols1);
    Move(Pointer(Adr2 + Col)^, Pointer(AdrR + Cols1 + Col)^, Cols2 - Col);
    Inc(Adr2, Cols2);
    Inc(Adr1, Cols1);
    Inc(AdrR, ColsR);
  end;

  RenameArray(TempR, DestAr);
end;


procedure TWorkspace.SendMatlabCommand(Str: string);
begin
  Matlab := CreateOleObject('Matlab.Application');
  Matlab.Execute(Str);
end;      

function TWorkspace.FIsRef(Index: Integer): Boolean;
begin   
  Result := (FRefList.IndexOf(Pointer(Index)) <> -1);
end;

function TWorkspace.SizeEqual(const Array1, Array2: string): Boolean;
var
  R1, C1, R2, C2: Integer;
begin
  GetSize(Array1, R1, C1);
  GetSize(Array2, R2, C2);
  Result := (R1 = R2) and (C1 = C2);
end;

function TWorkspace.SizeEqual(Idx1, Idx2: Integer): Boolean;
var
  R1, C1, R2, C2: Integer;
begin
  GetSize(Idx1, R1, C1);
  GetSize(Idx2, R2, C2);
  Result := (R1 = R2) and (C1 = C2);
end;

function TWorkspace.IsSingle(const Name: String): Boolean;
var
  R, C: Integer;
begin
  GetSize(Name, R, C);
  Result := (R = 1) and (C = 1);
end;

function TWorkspace.IsSingle(Idx: Integer): Boolean;
var
  R, C: Integer;
begin
  GetSize(Idx, R, C);
  Result := (R = 1) and (C = 1);
end;

function TWorkspace.IsSquare(const Name: String): Boolean;
var
  R, C: Integer;
begin
  GetSize(Name, R, C);
  Result := (R = C);
end;

function TWorkspace.IsSquare(Idx: Integer): Boolean;
var
  R, C: Integer;
begin
  GetSize(Idx, R, C);
  Result := (R = C);
end;

function TWorkspace.GetSize(const Name: string): Integer;
var Rows, Cols: Integer;
begin
  GetSize(Name, Rows, Cols);
  Result := Rows * Cols;
end;

function TWorkspace.GetSize(Idx: Integer): Integer;
var Rows, Cols: Integer;
begin
  GetSize(Idx, Rows, Cols);
  Result := Rows * Cols;
end;

procedure TWorkspace.GetMinMax(Name: string; var MinVal, MaxVal: Real);
var
  I, Adr, Rows, Cols: Integer;
  R: Real;
begin
  Adr := GetAddress(GetSize(Name, Rows, Cols));
  // ���������� ��������� �������
  MinVal := ElemFast[Adr, Rows, Cols, Cols];
  MaxVal := MinVal;

  for I := 1 to Rows * Cols - 1 do
  begin
    R := Real(Pointer(Adr)^);
    if R > MaxVal then MaxVal := R else
      if R < MinVal then MinVal := R;
    Inc(Adr, 8);
  end;
end;

function TWorkspace.GetMean(SourAr, DestAr: string;
  Dim: TDim = dimCols): string;
var
  C: Integer;
begin
  Result := CheckResAr(DestAr);    
  if Dim = dimCols then C := GetRows(SourAr) else C := GetCols(SourAr);
  if Dim = dimCols then SumRows(SourAr, DestAr) else SumCols(SourAr, DestAr);
  CalcFunc2(DestAr, C, DestAr, fncDiv);
end;

function TWorkspace.GetMinMax(SourAr, DestAr: string;
  Dim: TDim = dimRows): string;
var
  I, J, Rows, Cols, sAdr, dAdr: Integer;
  R, MinVal, MaxVal: Real;
  Temp: string;
begin
  Result := CheckResAr(DestAr);
  sAdr := GetAddress(GetSize(SourAr, Rows, Cols));
  
  Temp := GenName();
  if Dim = dimRows then
    dAdr := GetAddress(NewArray(Temp, Rows, 2, False))
  else
    dAdr := GetAddress(NewArray(Temp, 2, Cols, False));

  case Dim of
    dimRows:
      for I := 1 to Rows do
      begin
        MinVal := ElemFast[sAdr, I, 1, Cols];
        MaxVal := MinVal;
        for J := 2 to Cols do
        begin
          R := ElemFast[sAdr, I, J, Cols];
          if R > MaxVal then MaxVal := R else
            if R < MinVal then MinVal := R;
        end;
        ElemFast[dAdr, I, 1, 2] := MinVal;
        ElemFast[dAdr, I, 2, 2] := MaxVal;
      end;

      dimCols:
        for I := 1 to Cols do
        begin
          MinVal := ElemFast[sAdr, 1, I, Cols];
          MaxVal := MinVal;
          for J := 2 to Rows do
          begin
            R := ElemFast[sAdr, J, I, Cols];
            if R > MaxVal then MaxVal := R else
              if R < MinVal then MinVal := R;
          end;
          ElemFast[dAdr, 1, I, Cols] := MinVal;
          ElemFast[dAdr, 2, I, Cols] := MaxVal;
        end;
  end; // of Case
  RenameArray(Temp, DestAr);
end;

procedure TWorkspace.GetMin(SourAr, MinElems, Indexes: string;
  Dim: TDim = dimCols);
var
  Rows, Cols, sAdr, eAdr, iAdr, I, J, Idx: Integer;
  R, MinV: Real;
  DoElem, DoIndexes: Boolean;
  TempEl, TempIdx: string;
begin
  eAdr := 0; iAdr := 0;
  sAdr := GetAddress(GetSize(SourAr, Rows, Cols));
  DoElem := MinElems <> '';
  DoIndexes := Indexes <> '';
  if (not DoElem) and (not DoIndexes) then DoError(matBadParams);

  if DoElem then
  begin
    CheckResAr(MinElems, False);
    TempEl := GenName();
  end;

  if DoIndexes then
  begin
    CheckResAr(Indexes,  False);
    TempIdx := GenName;
  end;

  case Dim of

  dimCols:
    begin
      if DoElem then eAdr := GetAddress(NewArray(TempEl, 1, Cols, False));
      if DoIndexes then iAdr := GetAddress(NewArray(TempIdx, 1, Cols, False));
      for J := 1 to Cols do
      begin
        MinV := ElemFast[sAdr, 1, J, Cols];
        Idx := 1;
        for I := Rows downto 2 do
        begin
          R := ElemFast[sAdr, I, J, Cols];
          if R < MinV then
          begin
            MinV := R;
            Idx := I;
          end;
        end;
        if DoElem then ElemFast[eAdr, 1, J, Cols] := MinV;
        if DoIndexes then ElemFast[iAdr, 1, J, Cols] := Idx;
      end;
    end;

  dimRows:
    begin
      if DoElem then eAdr := GetAddress(NewArray(TempEl, Rows, 1, False));
      if DoIndexes then iAdr := GetAddress(NewArray(TempIdx, Rows, 1, False));
      for I := 1 to Rows do
      begin
        MinV := ElemFast[sAdr, I, 1, Cols];
        Idx := 1;
        for J := Cols downto 2 do
        begin
          R := ElemFast[sAdr, I, J, Cols];
          if R < MinV then
          begin
            MinV := R;
            Idx := J;
          end;
        end;
        if DoElem then ElemFast[eAdr, I, 1, 1] := MinV;
        if DoIndexes then ElemFast[iAdr, I, 1, 1] := Idx;
      end;
    end;

  end; // of Case
  if DoElem then RenameArray(TempEl, MinElems);
  if DoIndexes then RenameArray(TempIdx, Indexes);
end;


function TWorkspace.GetElemFast(Adr, Row, Col, ColCount: Integer): Real;
begin
  Result := Real(Pointer((Adr + ((Row - 1) * ColCount + Col - 1) shl 3))^);
end;

procedure TWorkspace.SetElemFast(Adr, Row, Col, ColCount: Integer;
  const Value: Real);
begin
  Real(Pointer((Adr + ((Row - 1) * ColCount + Col - 1) shl 3))^) := Value;
end;

procedure TWorkspace.GetMax(SourAr, MaxElems, Indexes: string;
  Dim: TDim = dimCols);
var
  Rows, Cols, sAdr, eAdr, iAdr, I, J, Idx: Integer;
  R, MaxV: Real;
  DoElem, DoIndexes: Boolean;
  TempEl, TempIdx: string;
begin
  eAdr := 0; iAdr := 0;
  sAdr := GetAddress(GetSize(SourAr, Rows, Cols));
  DoElem := MaxElems <> '';
  DoIndexes := Indexes <> '';
  if (not DoElem) and (not DoIndexes) then DoError(matBadParams);

  if DoElem then
  begin
    CheckResAr(MaxElems, False);
    TempEl := GenName();
  end;

  if DoIndexes then
  begin
    CheckResAr(Indexes,  False);
    TempIdx := GenName;
  end;

  case Dim of
    dimCols:
      begin
        if DoElem then eAdr := GetAddress(NewArray(TempEl, 1, Cols));
        if DoIndexes then iAdr := GetAddress(NewArray(TempIdx, 1, Cols));
        for J := 1 to Cols do
        begin
          MaxV := ElemFast[sAdr, 1, J, Cols];
          Idx := 1;
          for I := Rows downto 2 do
          begin
            R := ElemFast[sAdr, I, J, Cols];
            if R > MaxV then
            begin
              MaxV := R;
              Idx := I;
            end;
          end;
          if DoElem then ElemFast[eAdr, 1, J, Cols] := MaxV;
          if DoIndexes then ElemFast[iAdr, 1, J, Cols] := Idx;
        end;
      end;
    dimRows:
      begin
        if DoElem then eAdr := GetAddress(NewArray(TempEl, Rows, 1));
        if DoIndexes then iAdr := GetAddress(NewArray(TempIdx, Rows, 1));
        for I := 1 to Rows do
        begin
          MaxV := ElemFast[sAdr, I, 1, Cols];
          Idx := 1;
          for J := Cols downto 2 do
          begin
            R := ElemFast[sAdr, I, J, Cols];
            if R > MaxV then
            begin
              MaxV := R;
              Idx := J;
            end;
          end;
          if DoElem then ElemFast[eAdr, I, 1, 1] := MaxV;
          if DoIndexes then ElemFast[iAdr, I, 1, 1] := Idx;
        end;
      end;

  end;  // of Case
  if DoElem then RenameArray(TempEl, MaxElems);
  if DoIndexes then RenameArray(TempIdx, Indexes);
end;

function TWorkspace.GetElemType(const Name: string): TStandartType;
const
 MinOfType: array [1..6] of Int64 =
   (Low (Byte), Low (Shortint), Low (Word), Low (Short), Low (DWord), Low (Integer));
 MaxOfType: array [1..6] of Int64 =
   (High(Byte), High(Shortint), High(Word), High(Short), High(DWord), High(Integer));
var
  I, Rows, Cols, Adr: Integer;
  R, MaxEl, MinEl: Real;
begin
{
  ����������� ��������� ����:
  Real - stReal  (8 ����)
  Byte - stByte  (1 ����, �� 0 �� 255)
  ShortInt - stShortInt  (1 ����, �� -128 �� 127)
  Word - stWord (2 �����, �� 0 �� 65535)
  Short - stShort (2 �����, �� -32768 �� +32767)
  DWord - stDWord (4 �����, �� 0 �� 4 ����)
  Integer - stInteger  (4 �����, �� -2 ����. �� +2 ����)

  ������ ���� �� ������������, ��������� �� �������� ���������� ����������
}
  Result := TStandartType(0);
  Adr := GetAddress(GetSize(Name, Rows, Cols));
  MinEl := Real(Pointer(Adr)^);
  MaxEl := MinEl;
  for I := 1 to Rows * Cols do
  begin
    R := Real(Pointer(Adr)^);
    if Frac(R) <> 0 then Exit;
    if R > MaxEl then MaxEl := R else
      if R < MinEl then MinEl := R;
    Inc(Adr, 8);
  end;

  for I := 1 to 6 do
    if (MinEl >= MinOfType[I]) and (MaxEl <= MaxOfType[I]) then
    begin
      Result := TStandartType(I);
      Break;
    end;
end;

procedure TWorkspace.FSaveArrayToBinFile(const FileName: string;
  ArIdx: Integer; AddToEnd: Boolean);
var
  cHead, cHead1: array[1..30] of Char;
  FS: TFileStream;
  NewFile: Boolean;
  Rang: TPoint;
  WriteDataType, ReadDataType: Word;
  ArName: TNameArray;
  Name, NameAr: string;
  Adr, Rows, Cols, ByteCnt, ByteCnt1, J, ArSize: Integer;
  TByte: Byte;
  TWord: Word;
  TDWord: DWord;
label
  BeginWrite;
begin
  if FMStream = nil then FMStream := TMemoryStream.Create;
  Adr := GetAddress(GetSize(ArIdx, Rows, Cols));
  FArrayList.SetIndex(ArIdx); // ����������� ������, ����� ��� ����� �� ������
  NameAr := GetName(ArIdx);
  
  cHead := matBinaryHeader;

  NewFile := not FileExists(FileName);

  WriteDataType := Byte(GetElemType(NameAr));

  case TStandartType(WriteDataType) of
    stByte, stShortint : ByteCnt := 1;
    stWord, stShort    : ByteCnt := 2;
    stDWord, stInteger : ByteCnt := 4;
    else
      ByteCnt := 8;
  end;
  FS := nil; // �������������� ������ :)

  if NewFile then
  begin // �������� ������ �����
    FS := TFileStream.Create(FileName, fmCreate);
    FS.Write(cHead, 30);  // ����� ���������
    ArName := StrToName(NameAr);
    FS.Write(ArName, 32); // ����� ��� �������
    Rang := Point(Rows, Cols);
    FS.Write(Rang, 8);    // ����� ������� �������         
    FS.Write(WriteDataType, 2);// ����� ��� ���������
  end else if not AddToEnd then
  begin // ����� � ������������ �����
    FS := TFileStream.Create(FileName, fmOpenReadWrite);
    FS.Read(cHead1, 30);  // ������ ���������
    if cHead <> cHead1 then
    begin
      FS.Free;
      DoError(matBadFileFormat);
    end;
    while FS.Position < FS.Size do
    begin
      FS.Read(ArName, 32); // ��������� ��� �������
      Name := ArName;
      while Name[Length(Name)] = #0 do Delete(Name, Length(Name), 1);
      FS.Read(Rang, 8);      // ��������� �������
      FS.Read(ReadDataType, 2); // ��������� ��� ���������
      case TStandartType(ReadDataType) of
        stByte, stShortint : ByteCnt1 := 1;
        stWord, stShort    : ByteCnt1 := 2;
        stDWord, stInteger : ByteCnt1 := 4;
        else ByteCnt1 := 8;
      end;
      if (Name = NameAr) and (Rows * Cols * ByteCnt =
          Rang.X * Rang.Y * ByteCnt1) then goto BeginWrite else
      begin
        // ���� ����� �������, �� ������ ��� ���������� �������
        if Name = NameAr then
        begin
          // ������������ ����� �� 42 �����
          FS.Seek(-42, soFromCurrent);
          // ���������� ������� ����� ������ '$'
          ArName[1] := '$';
          FS.Write(ArName, 32);
          FS.Seek(10, soFromCurrent); // ������������ �� �������� �����
        end;
        // ���������� �������� �������
        FS.Seek(Rang.X * Rang.Y * ByteCnt1, soFromCurrent);
      end;
    end; // of While
    // ���� ������ �� ��� ������, �� ����� ����������� ����������
    ArName := StrToName(NameAr);
    FS.Write(ArName, 32); // ����� ��� �������
    Rang := Point(Rows, Cols);
    FS.Write(Rang, 8);    // ����� ������� �������
    FS.Write(WriteDataType, 2);// ����� ��� ���������
  end; // if NewFile
  
  // ���� ���������� � ����� ������������� �����, ��:
  if not NewFile and AddToEnd then
  begin
    FS := TFileStream.Create(FileName, fmOpenWrite);
    FS.Seek(0, soFromEnd);
    ArName := StrToName(NameAr);
    FS.Write(ArName, 32); // ����� ��� �������
    Rang := Point(Rows, Cols);
    FS.Write(Rang, 8);    // ����� ������� �������
    FS.Write(WriteDataType, 2);// ����� ��� ���������
  end;

  BeginWrite:
  
  //���� ��� Real, �� ����� ���������� ������ � ����
  if TStandartType(WriteDataType) = stReal then
    FS.Write(Pointer(Adr)^, Rows * Cols * 8) else
  begin
    FMStream.SetSize(Rows * Cols * ByteCnt);
    FMStream.Seek(0, soFromBeginning);
    ArSize := Rows * Cols - 1;
    case TStandartType(WriteDataType) of
      stByte, stShortint :
              begin
              for J := 0 to ArSize do
              begin
                TByte := Trunc(Real(Pointer(Adr + (J shl 3))^));
                FMStream.Write(TByte, ByteCnt);
              end;
            end;
      stWord, stShort:
              begin
              for J := 0 to ArSize do
              begin
                TWord := Trunc(Real(Pointer(Adr + (J shl 3))^));
                FMStream.Write(TWord, ByteCnt);
              end;
            end;

      stDWord, stInteger:
              begin
              for J := 0 to ArSize do
              begin
                TDWord := Trunc(Real(Pointer(Adr + (J shl 3))^));
                FMStream.Write(TDWord, ByteCnt);
              end;
            end;

    end; // of case
    // ���������� ����� FMStream � FS
    FS.Write(Pointer(FMStream.Memory)^, Rows * Cols * ByteCnt);
  end;
  FMStream.Clear;
  FS.Free;
end;

function TWorkspace.CalcProd(SourAr, DestAr: string; Dim: TDim): string;
var
  Rows, Cols, I, J, sAdr, dAdr: Integer;
  R: Real;
  Tmp: string;
begin
  Result := CheckResAr(DestAr);
  sAdr := GetAddress(GetSize(SourAr, Rows, Cols)); // ���������� ����� � �������
  Tmp := GenName();
  try
    case Dim of
      dimRows:
              begin
                dAdr := GetAddress(NewArray(Tmp, Rows, 1));
                for I := 1 to Rows do
                begin
                  R := 1;
                  for J := 1 to Cols do
                    R := R * ElemFast[sAdr, I, J, Cols];
                  ElemFast[dAdr, I, 1, 1] := R
                end;
              end;

      dimCols:
              begin
                dAdr := GetAddress(NewArray(Tmp, 1, Cols));
                for J := 1 to Cols do
                begin
                  R := 1;
                  for I := 1 to Rows do
                    R := R * ElemFast[sAdr, I, J, Cols];
                  ElemFast[dAdr, 1, J, Cols] := R
                end;
              end;
    end;  // of Case
  except
    Clear(Tmp);
    DoError('CalcProd ERROR!');
  end;
  RenameArray(Tmp, DestAr);
end;

function TWorkspace.GetMinOrMax(Name: string; Num: Integer; Dim: TDim;
  ReturnMax: Boolean; var Index: Integer): Real;
var
  I, Rows, Cols, Adr: Integer;
begin
  Index := 0;
  if ReturnMax then Result := -MaxDouble else Result := MaxDouble;
  Adr := GetAddress(GetSize(Name, Rows, Cols));

  case Dim of
    dimRows:
      begin
        if (Num < 1) or (Num > Rows) then DoError(matBadRow);
        if ReturnMax then
        begin
          for I := Cols downto 1 do
            if ElemFast[Adr, Num, I, Cols] > Result then
            begin
              Index := I;
              Result := ElemFast[Adr, Num, I, Cols];
            end
        end else
        begin
          for I := Cols downto 1 do
            if ElemFast[Adr, Num, I, Cols] < Result then
            begin
              Index := I;
              Result := ElemFast[Adr, Num, I, Cols];
            end
        end;
      end;

    dimCols:
      begin
        if (Num < 1) or (Num > Cols) then DoError(matBadCol);
        if ReturnMax then
        begin
          for I := Rows downto 1 do
            if ElemFast[Adr, I, Num, Cols] > Result then
            begin
              Index := I;
              Result := ElemFast[Adr, I, Num, Cols];
            end
        end else
        begin
          for I := Rows downto 1 do
            if ElemFast[Adr, I, Num, Cols] < Result then
            begin
              Index := I;
              Result := ElemFast[Adr, I, Num, Cols];
            end
        end; 
      end;
  end; // of Case
end;

function TWorkspace.NewZeros(const Name: string; Rows, Cols: Integer): string;
begin
  NewArray(Name, Rows, Cols, True);
  Result := Name;
end;

function TWorkspace.NewOnes(const Name: string; Rows, Cols: Integer): string;
begin
  Result := NewFillAr(Name, Rows, Cols, 1, 0);
end;

procedure TWorkspace.LoadFromTextFile(const FileName: string;
  ArName: string);
begin
  if ArName = '' then FLoadFromTextFile(FileName) else
    FLoadArrayFromTextFile(FileName, ArName);
end;

procedure TWorkspace.SaveToBinFile(const FileName: string; ArName: string = '');
var
  I: Integer;
begin
  if ArName = '' then
  begin
    if FileExists(FileName) then DeleteFile(FileName);
    if FArrayList.Count > 0 then
      for I := 0 to FArrayList.Count - 1 do
        if IsTrueName(FArrayList[I]) and (GetSize(I) <> 0) then
          FSaveArrayToBinFile(FileName, I);
  end else
    FSaveArrayToBinFile(FileName, GetIndex(ArName), False);
end;

initialization
  Base := TWorkspace.Create(matBaseWorkspace);
finalization
  Base.Free;
end.


