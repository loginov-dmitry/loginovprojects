{
Copyright (c) 2005, Loginov Dmitry Sergeevich
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


{******************************************************************************}
{                                                                              }
{������ ��� ������ �� �������� Lists                                           }
{��������� ��������� ������ ����� ��������, ������� � ��������� ��������� �����}
{������ � ���������� ��������� ������� �������                                 }
{������ ��������� ������� ��������� ��������� ���������� ������, ������        }
{�� ������ � ����� ������ �������� ��� �������� � ������ ����� ������� ���     }
{������� ������������.                                                         }
{� Delphi ��� ���� ����� TStringList, ����������� ��������� ������ �����,      }
{������ ������� ��������� ������ ����� � ���� ����� ���. ������ ������         }
{������� ��������� ���� ����������                                             }
{(c) ������� ������� ���������, 2005                                           }
{                                                                              }
{����������! � ���� ������ ��� ������ ����������� �� ������ TList, �������     }
{�������� �� ��� ������� ���������, ����� �� ������� ������� �������������,    }
{������� ���������� ��������� ����������� ������������������ ������            }
{******************************************************************************}

{
������ Lists �������� ��������� ������:
TByteList - ������ ������. ����� ����� ������� ������ ���� Shortint,
TWordList - ������ ����. ����� ����� ������� ������ ���� Smallint,
TIntList - ������ 4-�������� ����� �����.
           ����� ����� ������� ������ ���� DWORD,
TSingleList - ������ ������������ �����: 1.5 x 10^-45 .. 3.4 x 10^38
TRealList - ������ ������������ �����: 5.0 x 10^-324 .. 1.7 x 10^308
TExtendedList - ������ ������������ �����: 3.6 x 10^-4951 .. 1.1 x 10^4932

TPointList - ������ �����
TLinesList - ������ ������ � ����� ����� (ObjLine)

��� ������������ ��� ����
~~~~~~~~~~~~~~~~~~~~~~~~~~~

������:

var
  WL: TWordList;
  I: Integer;

begin
  WL := TWordList.Create; // �������� �������
  for I := 1 to 100 do WL.Add(Random(20000)); // ���������� ������
  WL.Items[10] := 50; // ��������� �������� ������
  WL.Delete(5); // �������� �������� ������
  ShowMessage(IntToStr(WL.Count)); // ���������� ��������� ������
  WL.Clear; // ������� ������
  WL.Free;  // ����������� �������
end;
}


unit Lists;
interface
uses Classes, Windows, SysUtils;
// ��� �������� ������ ������ �� ������ ��������� ��������� ��������:

// 1) ���� ����������, �� �������� ���� ��� ������

// 2) ���������� ��������� ����� TByteList � ����� ������
//    � �������� ��� ����-������ (����� � �����) � ������� ����������� �������

// 3) �������� �������� TByteList �� ���� ����� (�������� TMyList) �
//    �������� ���!!! �����  Byte �� ���� ��� (��������, ObjLine)

// 4) ������� ���� �� ������ ���������� ���� ������� ������ TByteList, ����������
//    ����� ������� � ����� ������ � �������� � ����� ������

// 5) ��������� ����� 3) ��� ������������� �������

// 6) ������������� ������������� ������

{����� ����������� ���� ������}
type
  TColor = -$7FFFFFFF - 1..$7FFFFFFF;
  ObjLine = packed record
    PBegin, PEnd: TPoint; // ���. � ���. �����
    Width: Byte; // ������ �����
    Color: TColor; // ���� �����
    ID: DWord; // �������������
    Layer: Integer; // ����� ����
  end; 

type TIntList = class(TList)
  private
    VPointer: ^Integer;
    function Get(Index: Integer): Integer; virtual;
    procedure Put(Index: Integer; Item: Integer); virtual;
    function Checker(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function Add(Value: Integer): Integer; virtual;
    procedure Insert(Index: Integer; Value: Integer); virtual;
    procedure Clear; override;
    procedure Delete(Index: Integer); virtual;
    property Items[Index: Integer]: Integer read Get write Put;
  end;

type TByteList = class(TList)
  private
    VPointer: ^Byte;
    function Get(Index: Integer): Byte; virtual;
    procedure Put(Index: Integer; Item: Byte); virtual;
    function Checker(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function Add(Value: Byte): Integer; virtual;
    procedure Insert(Index: Integer; Value: Byte); virtual;
    procedure Clear; override;
    procedure Delete(Index: Integer); virtual;
    property Items[Index: Integer]: Byte read Get write Put;
  end;

type TWordList = class(TList)
  private
    VPointer: ^Word;
    function Get(Index: Integer): Word; virtual;
    procedure Put(Index: Integer; Item: Word); virtual;
    function Checker(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function Add(Value: Word): Integer; virtual;
    procedure Insert(Index: Integer; Value: Word); virtual;
    procedure Clear; override;
    procedure Delete(Index: Integer); virtual;
    property Items[Index: Integer]: Word read Get write Put;
  end;

type TPointList = class(TList)
  private
    VPointer: ^TPoint;
    function Get(Index: Integer): TPoint; virtual;
    procedure Put(Index: Integer; Item: TPoint); virtual;
    function Checker(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function Add(Value: TPoint): Integer; virtual;
    procedure Insert(Index: Integer; Value: TPoint); virtual;
    procedure Clear; override;
    procedure Delete(Index: Integer); virtual;
    property Items[Index: Integer]: TPoint read Get write Put;
  end;

type TLinesList = class(TList)
  private
    VPointer: ^ObjLine;
    function Get(Index: Integer): ObjLine; virtual;
    procedure Put(Index: Integer; Item: ObjLine); virtual;
    function Checker(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function Add(Value: ObjLine): Integer; virtual;
    procedure Insert(Index: Integer; Value: ObjLine); virtual;
    procedure Clear; override;
    procedure Delete(Index: Integer); virtual;
    property Items[Index: Integer]: ObjLine read Get write Put;
  end;

type TRealList = class(TList)
  private
    VPointer: ^Real;
    function Get(Index: Integer): Real; virtual;
    procedure Put(Index: Integer; Item: Real); virtual;
    function Checker(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function Add(Value: Real): Integer; virtual;
    procedure Insert(Index: Integer; Value: Real); virtual;
    procedure Clear; override;
    procedure Delete(Index: Integer); virtual;
    property Items[Index: Integer]: Real read Get write Put;
  end;

type TSingleList = class(TList)
  private
    VPointer: ^Single;
    function Get(Index: Integer): Single; virtual;
    procedure Put(Index: Integer; Item: Single); virtual;
    function Checker(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function Add(Value: Single): Integer; virtual;
    procedure Insert(Index: Integer; Value: Single); virtual;
    procedure Clear; override;
    procedure Delete(Index: Integer); virtual;
    property Items[Index: Integer]: Single read Get write Put;
  end;

type TExtendedList = class(TList)
  private
    VPointer: ^Extended;
    function Get(Index: Integer): Extended; virtual;
    procedure Put(Index: Integer; Item: Extended); virtual;
    function Checker(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function Add(Value: Extended): Integer; virtual;
    procedure Insert(Index: Integer; Value: Extended); virtual;
    procedure Clear; override;
    procedure Delete(Index: Integer); virtual;
    property Items[Index: Integer]: Extended read Get write Put;
  end;

type TObjectList = class(TList)
  private
    VPointer: ^TObject;
    function Get(Index: Integer): TObject; virtual;
    procedure Put(Index: Integer; Item: TObject); virtual;
    function Checker(Index: Integer): Boolean;
  public
    destructor Destroy; override;
    function Add(Value: TObject): Integer; virtual;
    procedure Insert(Index: Integer; Value: TObject); virtual;
    procedure Clear; override;
    procedure Delete(Index: Integer); virtual;
    property Items[Index: Integer]: TObject read Get write Put;
  end;

implementation
const
  listBadIndex = '������! ������������� ������';
  listNotData = '������! � ������ ��� ������';
  listOutOfRang = '������! ����� �� ������� ������';

procedure DoError(EText: string); overload;
begin
  raise Exception.Create(EText);
end;

{ TIntList }

function TIntList.Add(Value: Integer): Integer;
begin
  New(VPointer);
  VPointer^ := Value;
  Result := inherited Add(VPointer);
end;

function TIntList.Checker(Index: Integer): Boolean;
begin
  if Index < 0 then DoError(listBadIndex);
  if Count = 0 then DoError(listNotData);
  if Index >= Count then DoError(listOutOfRang);
  Result := True;
end;

procedure TIntList.Clear;
var I: Integer;
begin
  if Count = 0 then Exit;
  for I := 0 to Count - 1 do begin
    VPointer := List[I];
    Dispose(VPointer);
  end;
  inherited Clear;
end;

procedure TIntList.Delete(Index: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Dispose(VPointer);
  inherited Delete(Index);
end;

destructor TIntList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TIntList.Get(Index: Integer): Integer;
begin
  Result := 0;
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Result := VPointer^;
end;

procedure TIntList.Insert(Index: Integer; Value: Integer);
begin
  New(VPointer);
  VPointer^ := Value;
  inherited Insert(Index, VPointer);
end;

procedure TIntList.Put(Index: Integer; Item: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  VPointer^ := Item;
end;
{/////////////////////////////////////////////////////////////////
=========����� TIntList ��������=================================}

function TByteList.Add(Value: Byte): Integer;
begin
  New(VPointer);
  VPointer^ := Value;
  Result := inherited Add(VPointer);
end;

function TByteList.Checker(Index: Integer): Boolean;
begin
  if Index < 0 then DoError(listBadIndex);
  if Count = 0 then DoError(listNotData);
  if Index >= Count then DoError(listOutOfRang);
  Result := True;
end;

procedure TByteList.Clear;
var I: Integer;
begin
  if Count = 0 then Exit;
  for I := 0 to Count - 1 do begin
    VPointer := List[I];
    Dispose(VPointer);
  end;
  inherited Clear;
end;

procedure TByteList.Delete(Index: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Dispose(VPointer);
  inherited Delete(Index);
end;

destructor TByteList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TByteList.Get(Index: Integer): Byte;
begin
  Result := 0;
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Result := VPointer^;
end;

procedure TByteList.Insert(Index: Integer; Value: Byte);
begin
  New(VPointer);
  VPointer^ := Value;
  inherited Insert(Index, VPointer);
end;

procedure TByteList.Put(Index: Integer; Item: Byte);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  VPointer^ := Item;
end;
{/////////////////////////////////////////////////////////////////
=========����� TByteList ��������=================================}

function TWordList.Add(Value: Word): Integer;
begin
  New(VPointer);
  VPointer^ := Value;
  Result := inherited Add(VPointer);
end;

function TWordList.Checker(Index: Integer): Boolean;
begin
  if Index < 0 then DoError(listBadIndex);
  if Count = 0 then DoError(listNotData);
  if Index >= Count then DoError(listOutOfRang);
  Result := True;
end;

procedure TWordList.Clear;
var I: Integer;
begin
  if Count = 0 then Exit;
  for I := 0 to Count - 1 do begin
    VPointer := List[I];
    Dispose(VPointer);
  end;
  inherited Clear;
end;

procedure TWordList.Delete(Index: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Dispose(VPointer);
  inherited Delete(Index);
end;

destructor TWordList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TWordList.Get(Index: Integer): Word;
begin
  Result := 0;
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Result := VPointer^;
end;

procedure TWordList.Insert(Index: Integer; Value: Word);
begin
  New(VPointer);
  VPointer^ := Value;
  inherited Insert(Index, VPointer);
end;

procedure TWordList.Put(Index: Integer; Item: Word);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  VPointer^ := Item;
end;
{/////////////////////////////////////////////////////////////////
=========����� TWordList ��������=================================}

function TPointList.Add(Value: TPoint): Integer;
begin
  New(VPointer);
  VPointer^ := Value;
  Result := inherited Add(VPointer);
end;

function TPointList.Checker(Index: Integer): Boolean;
begin
  if Index < 0 then DoError(listBadIndex);
  if Count = 0 then DoError(listNotData);
  if Index >= Count then DoError(listOutOfRang);
  Result := True;
end;

procedure TPointList.Clear;
var I: Integer;
begin
  if Count = 0 then Exit;
  for I := 0 to Count - 1 do begin
    VPointer := List[I];
    Dispose(VPointer);
  end;
  inherited Clear;
end;

procedure TPointList.Delete(Index: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Dispose(VPointer);
  inherited Delete(Index);
end;

destructor TPointList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TPointList.Get(Index: Integer): TPoint;
begin
  Result := Point(0, 0);
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Result := VPointer^;
end;

procedure TPointList.Insert(Index: Integer; Value: TPoint);
begin
  New(VPointer);
  VPointer^ := Value;
  inherited Insert(Index, VPointer);
end;

procedure TPointList.Put(Index: Integer; Item: TPoint);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  VPointer^ := Item;
end;
{/////////////////////////////////////////////////////////////////
=========����� TPointList ��������=================================}

function TLinesList.Add(Value: ObjLine): Integer;
begin
  New(VPointer);
  VPointer^ := Value;
  Result := inherited Add(VPointer);
end;

function TLinesList.Checker(Index: Integer): Boolean;
begin
  if Index < 0 then DoError(listBadIndex);
  if Count = 0 then DoError(listNotData);
  if Index >= Count then DoError(listOutOfRang);
  Result := True;
end;

procedure TLinesList.Clear;
var I: Integer;
begin
  if Count = 0 then Exit;
  for I := 0 to Count - 1 do begin
    VPointer := List[I];
    Dispose(VPointer);
  end;
  inherited Clear;
end;

procedure TLinesList.Delete(Index: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Dispose(VPointer);
  inherited Delete(Index);
end;

destructor TLinesList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TLinesList.Get(Index: Integer): ObjLine;
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Result := VPointer^;
end;

procedure TLinesList.Insert(Index: Integer; Value: ObjLine);
begin
  New(VPointer);
  VPointer^ := Value;
  inherited Insert(Index, VPointer);
end;

procedure TLinesList.Put(Index: Integer; Item: ObjLine);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  VPointer^ := Item;
end;
{/////////////////////////////////////////////////////////////////
=========����� TLinesList ��������=================================}

function TRealList.Add(Value: Real): Integer;
begin
  New(VPointer);
  VPointer^ := Value;
  Result := inherited Add(VPointer);
end;

function TRealList.Checker(Index: Integer): Boolean;
begin
  if Index < 0 then DoError(listBadIndex);
  if Count = 0 then DoError(listNotData);
  if Index >= Count then DoError(listOutOfRang);
  Result := True;
end;

procedure TRealList.Clear;
var I: Integer;
begin
  if Count = 0 then Exit;
  for I := 0 to Count - 1 do begin
    VPointer := List[I];
    Dispose(VPointer);
  end;
  inherited Clear;
end;

procedure TRealList.Delete(Index: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Dispose(VPointer);
  inherited Delete(Index);
end;

destructor TRealList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TRealList.Get(Index: Integer): Real;
begin
  Result := 0;
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Result := VPointer^;
end;

procedure TRealList.Insert(Index: Integer; Value: Real);
begin
  New(VPointer);
  VPointer^ := Value;
  inherited Insert(Index, VPointer);
end;

procedure TRealList.Put(Index: Integer; Item: Real);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  VPointer^ := Item;
end;
{/////////////////////////////////////////////////////////////////
=========����� TRealList ��������=================================}

function TSingleList.Add(Value: Single): Integer;
begin
  New(VPointer);
  VPointer^ := Value;
  Result := inherited Add(VPointer);
end;

function TSingleList.Checker(Index: Integer): Boolean;
begin
  if Index < 0 then DoError(listBadIndex);
  if Count = 0 then DoError(listNotData);
  if Index >= Count then DoError(listOutOfRang);
  Result := True;
end;

procedure TSingleList.Clear;
var I: Integer;
begin
  if Count = 0 then Exit;
  for I := 0 to Count - 1 do begin
    VPointer := List[I];
    Dispose(VPointer);
  end;
  inherited Clear;
end;

procedure TSingleList.Delete(Index: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Dispose(VPointer);
  inherited Delete(Index);
end;

destructor TSingleList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TSingleList.Get(Index: Integer): Single;
begin
  Result := 0;
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Result := VPointer^;
end;

procedure TSingleList.Insert(Index: Integer; Value: Single);
begin
  New(VPointer);
  VPointer^ := Value;
  inherited Insert(Index, VPointer);
end;

procedure TSingleList.Put(Index: Integer; Item: Single);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  VPointer^ := Item;
end;
{/////////////////////////////////////////////////////////////////
=========����� TSingleList ��������=================================}

function TExtendedList.Add(Value: Extended): Integer;
begin
  New(VPointer);
  VPointer^ := Value;
  Result := inherited Add(VPointer);
end;

function TExtendedList.Checker(Index: Integer): Boolean;
begin
  if Index < 0 then DoError(listBadIndex);
  if Count = 0 then DoError(listNotData);
  if Index >= Count then DoError(listOutOfRang);
  Result := True;
end;

procedure TExtendedList.Clear;
var I: Integer;
begin
  if Count = 0 then Exit;
  for I := 0 to Count - 1 do begin
    VPointer := List[I];
    Dispose(VPointer);
  end;
  inherited Clear;
end;

procedure TExtendedList.Delete(Index: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Dispose(VPointer);
  inherited Delete(Index);
end;

destructor TExtendedList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TExtendedList.Get(Index: Integer): Extended;
begin
  Result := 0;
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Result := VPointer^;
end;

procedure TExtendedList.Insert(Index: Integer; Value: Extended);
begin
  New(VPointer);
  VPointer^ := Value;
  inherited Insert(Index, VPointer);
end;

procedure TExtendedList.Put(Index: Integer; Item: Extended);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  VPointer^ := Item;
end;
{/////////////////////////////////////////////////////////////////
=========����� TExtendedList ��������=============================}
{ TObjectList }

function TObjectList.Add(Value: TObject): Integer;
begin
  New(VPointer);
  VPointer^ := Value;
  Result := inherited Add(VPointer);
end;

function TObjectList.Checker(Index: Integer): Boolean;
begin
  if Index < 0 then DoError(listBadIndex);
  if Count = 0 then DoError(listNotData);
  if Index >= Count then DoError(listOutOfRang);
  Result := True;
end;

procedure TObjectList.Clear;
var I: Integer;
begin
  if Count = 0 then Exit;
  for I := 0 to Count - 1 do begin
    VPointer := List[I];
    Dispose(VPointer);
  end;
  inherited Clear;
end;

procedure TObjectList.Delete(Index: Integer);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Dispose(VPointer);
  inherited Delete(Index);
end;

destructor TObjectList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TObjectList.Get(Index: Integer): TObject;
begin
  Result := nil;
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  Result := VPointer^;
end;

procedure TObjectList.Insert(Index: Integer; Value: TObject);
begin
  New(VPointer);
  VPointer^ := Value;
  inherited Insert(Index, VPointer);
end;

procedure TObjectList.Put(Index: Integer; Item: TObject);
begin
  if not Checker(Index) then Exit;
  VPointer := inherited Items[Index];
  VPointer^ := Item;
end;

end.

