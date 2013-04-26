{
Copyright (c) 2012-2013, Loginov Dmitry Sergeevich
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
{ ������ fbSomeFuncs - �������� ��������� ��������������� ������� ��� fbUtils }
{ (c) 2012 ������� ������� ���������                                          }
{ ��������� ����������: 09.05.2012                                            }
{ �������������� �� D7, D2007, D2010, D-XE2                                   }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{
�������, �������������� � ������ ������, �� ����� �������� ��������� � �����
������ Firebird, ����� �� ����� ����� ���������� � ��������� ����� ��������.
��� ��� �������������� ������.
����� ��������� ������ �� �������, ������� ������������ � fbUtils
}



unit fbSomeFuncs;

interface

uses
  Windows, SysUtils, Classes, IniFiles, IB;

{��������� D2009PLUS ����������, ��� ������� ������ Delphi: 2009 ��� ����}
{$IF RTLVersion >= 20.00}
   {$DEFINE D2009PLUS}
{$IFEND}

{$OVERFLOWCHECKS OFF}

type
  { ������� �����, ���������� ���������� �������� ����� ��������. ���������
    ������� ������ ����� �������������� ���������� ���������� TRY..FINALLY
    � ��� ����� �������� ������������� ����.
    �� �� ������ ��������� ������ �������! }
  TBaseObject = class(TObject)
  private
    FRefList: TList;

    { ������� ������ ������ FRefList }
    procedure ClearRefList;

    { ������������ ������ � ������� ��� ��������������� ��������.
      ��������!!! ���� ������ ��������������� � ������, �� ��� ������� �
      ������ ������ ������.
      ������ ���� �������� �������:
      AList := RegObj(TStringList.Create) as TStringList; }
    function DoRegObj(Obj: TObject): TObject;

  protected
    { ��������� ����������� �������. ����� ���������. }
    procedure ClearObjectRef(ARef: TObject); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    { ������� �����, ������������ ��� � ������ FRefList � ���������� � �������� Ref }
    procedure RegObj(var Ref; Obj: TObject); overload;

    { ������� ������ Obj �� ������ � ���������� ��� }
    procedure FreeObj(Obj: TObject);

    { ������� ������ �����, ��������� ������������� }
    function CreateStringList: TStringList;

    function CreateMemoryStream: TMemoryStream;

    function CreateHashedStringList: THashedStringList;

  end;

  { ��� �� TBaseObject, �� � ������ ���������. ��� ����, ����� ��������� ��������
    ��� ����������: ������� ������ ������ �� �������. ��� �� TObjectList, ��
    ������� ������� }
  TObjHolder = class(TBaseObject);

{����������� ������ ����������, ��������� � ��� ����� ��� �������, �
 ������� ��������� ������ ����������}
function ReCreateEObject(E: Exception; FuncName: string; WriteExceptClass: Boolean = True): Exception;

{������ �� �� �����, ��� � ����������� ������� StringReplace, ������ � ����� ��� �������}
function FastStringReplace(const S: string; OldPattern: string; const NewPattern: string;
  Flags: TReplaceFlags = [rfReplaceAll]): string;

{���������� ��� �������� ��� ��������� ����� ��� ����� ����������� ��� ����������}
function GenerateFileMutexName(const MutexPrefix, AFileName: string): string;

{ ������� ������������� ������� � ������  AName. ������� ����� ������������
  ������������ ��� ������� ��������������. ������� ��������� "���������".
  ��� ����, ����� ������ �������, ����������� WaitForSingleObject().
  ��� ������������ �������� ����������� ReleaseMutex().
  ���� �� �����-�� �������� �� ������� ������� �������, �� ������������ Exception}
function CreateMutexShared(AName: string; LastError: PCardinal = nil): THandle;

{ ������� ������������� ������ FileMapping}
function CreateFileMappingShared(hFile: THandle; flProtect, dwMaximumSizeHigh,
  dwMaximumSizeLow: DWORD; lpName: string; LastError: PCardinal = nil): THandle;

{ ���������� ��� ������� ���������� }
function GetCurrentComputerName: string;

{ ���������� ��� ������������ }
function GetCurrentUserName: string;

{ ���������� ��������� ������� }
function GetTempPath: string;

{ ��������� ��� ��� TStream (������������ ��������� ���������� ���������� ����) }
function CalcStreamHash(S: TStream): string;

{ ��������� ��� ������ HashLY }
function GenerateStringHashLY(S: string): Cardinal;

{$IFNDEF D2009PLUS}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
{$ENDIF}

implementation

type
  IBExceptClass = class of EIBError;

function ReCreateEObject(E: Exception; FuncName: string;
  WriteExceptClass: Boolean = True): Exception;
var
  S: string;
begin
  S := Format('%s -> %s', [FuncName, E.Message]);

  if WriteExceptClass then
  begin
    if Pos(' <# ', S) = 0 then
      S := S + ' <# ' + E.ClassName + ' #>';
  end;

  if E is EIBError then
    Result := IBExceptClass(E.ClassType).Create(EIBError(E).SQLCode, EIBError(E).IBErrorCode, S)
  else
    Result := ExceptClass(E.ClassType).Create(S);
end;

{$IFNDEF D2009PLUS}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;
{$ENDIF}

function FastStringReplace(const S: string; OldPattern: string;
  const NewPattern: string;
  Flags: TReplaceFlags = [rfReplaceAll]): string;
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

    // ��� ������ "�� ��������� �������"
    // ����������� �������������� ������
    UpperFindStr := AnsiUpperCase(S);

    pS := PChar(UpperFindStr);
  end else
    pS := PChar(S);

  // ���� ����� ��������� �� ��������� ������, ��...
  if Length(OldPattern) >= Length(NewPattern) then
  begin
    SetLength(Result, Length(S));
  end else // ������ ������ ������ �� ��������...
    SetLength(Result, (Length(S) + Length(OldPattern) +
      Length(NewPattern)) * 2);

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


function GenerateFileMutexName(const MutexPrefix, AFileName: string): string;
var
  I: Integer;
begin
  Result := MutexPrefix + AnsiLowerCase(AFileName);

  // ������� ��� ������� ������� backslash
  while Pos('\\', Result) > 0 do
    Result := StringReplace(Result, '\\', '\', [rfReplaceAll]);

  for I := 1 to Length(Result) do
    if CharInSet(Result[I], ['\', '/', ':', '*', '"', '?', '|', '<', '>']) then
      Result[I] := '_';
end;

function CreateMutexShared(AName: string; LastError: PCardinal = nil): THandle;
var
  SD:TSecurityDescriptor;
  SA:TSecurityAttributes;
  pSA: PSecurityAttributes;
begin
  try
    if not InitializeSecurityDescriptor(@SD, SECURITY_DESCRIPTOR_REVISION) then
      raise Exception.CreateFmt('Error InitializeSecurityDescriptor: %s', [SysErrorMessage(GetLastError)]);

    SA.nLength:=SizeOf(TSecurityAttributes);
    SA.lpSecurityDescriptor:=@SD;
    SA.bInheritHandle:=False;

    if not SetSecurityDescriptorDacl(SA.lpSecurityDescriptor, True, nil, False) then
      raise Exception.CreateFmt('Error SetSecurityDescriptorDacl: %s', [SysErrorMessage(GetLastError)]);

    pSA := @SA;

    Result := CreateMutex(pSA, False, PChar('Global\' + AName)); // �������� ������� � ���������� Global
    if Result = 0 then
      Result := CreateMutex(pSA, False, PChar(AName)); // �������� ������� ��� ��������� Global

    if Assigned(LastError) then
      LastError^ := GetLastError;

    if Result = 0 then
      raise Exception.CreateFmt('Error creating object "Mutex": %s', [SysErrorMessage(GetLastError)]);
  except
    on E: Exception do
      raise ReCreateEObject(E, 'CreateMutexShared');
  end;
end;

function CreateFileMappingShared(hFile: THandle; flProtect, dwMaximumSizeHigh, dwMaximumSizeLow: DWORD; lpName: string; LastError: PCardinal = nil): THandle;
var
  SD:TSecurityDescriptor;
  SA:TSecurityAttributes;
  pSA: PSecurityAttributes;
begin
  try
    if not InitializeSecurityDescriptor(@SD, SECURITY_DESCRIPTOR_REVISION) then
      raise Exception.CreateFmt('Error InitializeSecurityDescriptor: %s', [SysErrorMessage(GetLastError)]);

    SA.nLength:=SizeOf(TSecurityAttributes);
    SA.lpSecurityDescriptor:=@SD;
    SA.bInheritHandle:=False;

    if not SetSecurityDescriptorDacl(SA.lpSecurityDescriptor, True, nil, False) then
      raise Exception.CreateFmt('Error SetSecurityDescriptorDacl: %s', [SysErrorMessage(GetLastError)]);

    pSA := @SA;

    Result := CreateFileMapping(hFile, pSA, flProtect, dwMaximumSizeHigh, dwMaximumSizeLow, PChar('Global\' + lpName)); // �������� ������� � ���������� Global
    if Result = 0 then
      Result := CreateFileMapping(hFile, pSA, flProtect, dwMaximumSizeHigh, dwMaximumSizeLow, PChar(lpName)); // �������� ������� ��� ��������� Global

    if Assigned(LastError) then
      LastError^ := GetLastError;

    if Result = 0 then
      raise Exception.CreateFmt('Error creating object "FileMapping": %s', [SysErrorMessage(GetLastError)]);
  except
    on E: Exception do
      raise ReCreateEObject(E, 'CreateFileMappingShared');
  end;
end;

function GetCurrentComputerName: string;
var
  AComputerName: string;
  ASize: Cardinal;
begin
  SetLength(AComputerName, MAX_COMPUTERNAME_LENGTH + 1);
  ASize := MAX_COMPUTERNAME_LENGTH + 1;
  GetComputerName(PChar(AComputerName), ASize);
  Result := PChar(AComputerName);
end;

function GetCurrentUserName: string;
var
  AUserName: string;
  ASize: Cardinal;
begin
  SetLength(AUserName, 100);
  ASize := 100;
  GetUserName(PChar(AUserName), ASize);
  Result := PChar(AUserName);
end;


function CalcStreamHash(S: TStream): string;
var
  HashLY, HashRot13: Cardinal;
  I: Integer;
  Ar: PByteArray;
  WasGetMem: Boolean;
begin
  HashLY := 0; // ������ �����������
  HashRot13 := 0;
  if S.Size > 0 then
  begin
    WasGetMem := False;
    Ar := nil;
    try
      if S is TMemoryStream then
        Ar := TMemoryStream(S).Memory
      else
      begin
        GetMem(Ar, S.Size);
        WasGetMem := True;
        S.Position := 0;
        S.Read(Ar[0], S.Size);
      end;

      // ��������� HashLY
      for I := 0 to S.Size - 1 do
      begin
        HashLY := HashLY * 1664525 + Ar[I] + 1013904223;
      end;

      if HashLY = 0 then
        HashRot13 := $ABCDABCD
      else
        HashRot13 := HashLY; // ����� �� ������ ����� ����������� ��� HashLY

      // ��������� ROT13
      for I := 0 to S.Size - 1 do
      begin
        HashRot13 := HashRot13 + Ar[I];
        HashRot13 := HashRot13 - ((HashRot13 shl 13) or (HashRot13 shr 19));
      end;

      if (HashLY = 0) and (HashRot13 = 0) then
      begin
        // �������� �������������.
        HashRot13 := $ABCDEFAB;
      end;

    finally
      if WasGetMem then
        FreeMem(Ar);
    end;
  end;

  Result := IntToStr(HashLY) + '$' + IntToStr(HashRot13);
end;

function GenerateStringHashLY(S: string): Cardinal;
var
  Hash: Cardinal;
  I: Integer;
  aStr: AnsiString;
begin
  Hash := 0;
  aStr := AnsiString(S); // ��� ��������� ������: ����������� � Ansi-������

  for I := 1 to Length(aStr) do
  begin
    Hash := Hash * 1664525 + Ord(aStr[I]) + 1013904223
  end;

  Result := Cardinal(Hash);
end;

function GetTempPath: string;
var
  I: Integer;
begin
  SetLength(Result, MAX_PATH);
  I := Windows.GetTempPath(MAX_PATH, PChar(Result));
  SetLength(Result, I);
end;

{ TBaseObject }

procedure TBaseObject.ClearObjectRef(ARef: TObject);
begin
  ARef.Free;
end;

procedure TBaseObject.ClearRefList;
var
  I: Integer;
  Obj: TObject;
begin
  if Assigned(FRefList) then
  begin
    for I := 0 to FRefList.Count - 1 do
    begin
      Obj := FRefList[I];
      ClearObjectRef(Obj);
    end;
    FRefList.Clear;
  end;
end;

constructor TBaseObject.Create;
begin
  FRefList := TList.Create;
end;

function TBaseObject.CreateHashedStringList: THashedStringList;
begin
  RegObj(Result, THashedStringList.Create);
end;

function TBaseObject.CreateStringList: TStringList;
begin
  RegObj(Result, TStringList.Create);
end;

function TBaseObject.CreateMemoryStream: TMemoryStream;
begin
  RegObj(Result, TMemoryStream.Create);
end;

destructor TBaseObject.Destroy;
begin
  if Assigned(FRefList) then
  begin
    ClearRefList; // ����� ���������� ��� �������, ����������� � ������
    FRefList.Free;
  end
  else
    raise Exception.Create('TBaseObject.Destroy -> Call of constructor for TBaseObject was skipped!');
  inherited;
end;


procedure TBaseObject.RegObj(var Ref; Obj: TObject);
begin
  Pointer(Ref) := DoRegObj(Obj);
end;

function TBaseObject.DoRegObj(Obj: TObject): TObject;
begin
  if Assigned(FRefList) then
  begin
    FRefList.Add(Obj);
    Result := Obj;
  end
  else
    raise Exception.Create('TBaseObject.RegObj -> Call of constructor for TBaseObject was skipped!');

end;

procedure TBaseObject.FreeObj(Obj: TObject);
var
  Idx: Integer;
begin
  Idx := FRefList.IndexOf(Obj);
  if Idx >= 0 then
    FRefList.Delete(Idx);
  ClearObjectRef(Obj);
end;

end.
