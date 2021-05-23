{
Copyright (c) 2021, Loginov Dmitry Sergeevich
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

{
Butler fundamentals url: https://github.com/fundamentalslib/fundamentals5
}

unit SmartHolder;

interface

uses
  SysUtils, Classes, Contnrs, IniFiles {$IFDEF UseButlerDict}, flcDataStructs {$ENDIF UseButlerDict};

{.$RANGECHECKS OFF}

type
  ISmartHolder = interface
    function RegObj(Obj: TObject): TObject;
    procedure FreeObj(Obj: TObject);
  end;

  TImplementSmartHolder = class(TInterfacedObject, ISmartHolder)
  private
    Objs: array of TObject;
  public
    function RegObj(Obj: TObject): TObject;
    procedure FreeObj(Obj: TObject);
    destructor Destroy; override;
  end;

  {Using example:
   procedure MyProc;
   var
     AList: TList;
     h: TSmartHolder;
   begin
     AList := h.CreateList();
     // or universal way:  AList := h.RegObj(TList.Create) as TList;
     AList.Add('Hello!');
     // object "AList" will be destroyed automatically
     // you shouldn't use fry..finally or call destructor to destroy an object
   end;
  }
  TSmartHolder = record
  private
    ObjsHolder: ISmartHolder;
    procedure CheckObjsHolder;
  public
    function RegObj(Obj: TObject): TObject; overload;
    procedure FreeObj(Obj: TObject);
    procedure FreeAndNilObj(var Obj: TObject);
    procedure Clear;

    // to simplify the creation of standard objects 
    function CreateList: TList;
    function CreateStringList: TStringList;
    function CreateStringListWithText(AText, DelimChar: string): TStringList;
    function CreateHashedStringList: THashedStringList;
    function CreateMemoryStream: TMemoryStream;
    function CreateObjectList: TObjectList;

    {$IFDEF UseButlerDict}
    function CreateDoubleDictionary: TDoubleDictionary;
    function CreateIntegerDictionary: TIntegerDictionary;
    function CreateObjectDictionary(IsItemOwner: Boolean): TObjectDictionary;
    {$ENDIF UseButlerDict}
  end;


implementation

// comments: http://loginovprojects.ru/index.php?page=faststringreplace
function FastStringReplace(const S: string; OldPattern: string;
  const NewPattern: string;
  Flags: TReplaceFlags = [rfReplaceAll]): string;
var
  I, J, Idx: Integer;
  IsEqual: Boolean;
  UpperFindStr: string;
  pS: PChar;
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

    UpperFindStr := AnsiUpperCase(S);

    pS := PChar(UpperFindStr);
  end else
    pS := PChar(S);

  if Length(OldPattern) >= Length(NewPattern) then
  begin
    SetLength(Result, Length(S));
  end else
    SetLength(Result, (Length(S) + Length(OldPattern) +
      Length(NewPattern)) * 2);

  I := 1;
  Idx := 0;
  CanReplace := True;
  while I <= Length(S) do
  begin
    IsEqual := False;

    if CanReplace then
    begin
      if pS[I - 1] = OldPattern[1] then
      begin
        IsEqual := True;
        for J := 2 to Length(OldPattern) do
        begin
          if pS[I + J - 2] <> OldPattern[J] then
          begin
            IsEqual := False;
            Break;
          end;
        end;

        if IsEqual then
        begin
          for J := 1 to Length(NewPattern) do
          begin
            Inc(Idx);

            if Idx > Length(Result) then
              SetLength(Result, Length(Result) * 2);

            Result[Idx] := NewPattern[J];
          end;

          Inc(I, Length(OldPattern));

          if not (rfReplaceAll in Flags) then
            CanReplace := False;
        end;
      end;
    end;

    if not IsEqual then
    begin
      Inc(Idx);
      if Idx > Length(Result) then
        SetLength(Result, Length(Result) * 2);

      Result[Idx] := S[I];
      Inc(I);
    end;
  end; // while I <= Length(S) do
  SetLength(Result, Idx);
end;

{ TImplementSmartHolder }

destructor TImplementSmartHolder.Destroy;
var
  I: Integer;
begin
  for I := 0 to High(Objs) do
    Objs[I].Free;
  inherited;
end;

procedure TImplementSmartHolder.FreeObj(Obj: TObject);
var
  I: Integer;
begin
  Obj.Free;
  for I := 0 to High(Objs) do
    if Objs[I] = Obj then
    begin
      Objs[I] := nil;
      Exit;
    end;
end;

function TImplementSmartHolder.RegObj(Obj: TObject): TObject;
var
  I, Len: Integer;
begin
  Result := Obj;
  Len := Length(Objs);
  for I := 0 to Len - 1 do
  begin
    if Objs[I] = nil then
    begin
      Objs[I] := Obj;
      Exit;
    end;
  end;
  SetLength(Objs, Len + 1);
  Objs[Len] := Obj;
end;

{ TSmartHolder }

procedure TSmartHolder.CheckObjsHolder;
begin
  if ObjsHolder = nil then
    ObjsHolder := TImplementSmartHolder.Create();
end;

procedure TSmartHolder.Clear;
begin
  ObjsHolder := nil;
end;

{$IFDEF UseButlerDict}

function TSmartHolder.CreateDoubleDictionary: TDoubleDictionary;
begin
  Result := RegObj(TDoubleDictionary.Create) as TDoubleDictionary;
end;

function TSmartHolder.CreateIntegerDictionary: TIntegerDictionary;
begin
  Result := RegObj(TIntegerDictionary.Create) as TIntegerDictionary;
end;

function TSmartHolder.CreateObjectDictionary(
  IsItemOwner: Boolean): TObjectDictionary;
begin
  Result := RegObj(TObjectDictionary.CreateEx(nil, nil, IsItemOwner)) as TObjectDictionary;
end;

{$ENDIF UseButlerDict}

function TSmartHolder.CreateHashedStringList: THashedStringList;
begin
  Result := RegObj(THashedStringList.Create) as THashedStringList;
end;

function TSmartHolder.CreateList: TList;
begin
  Result := RegObj(TList.Create) as TList;
end;

function TSmartHolder.CreateMemoryStream: TMemoryStream;
begin
  Result := RegObj(TMemoryStream.Create) as TMemoryStream;
end;



function TSmartHolder.CreateObjectList: TObjectList;
begin
  Result := RegObj(TObjectList.Create) as TObjectList;
end;

function TSmartHolder.CreateStringList: TStringList;
begin
  Result := RegObj(TStringList.Create) as TStringList;
end;

function TSmartHolder.CreateStringListWithText(AText,
  DelimChar: string): TStringList;
begin
  Result := CreateStringList();
  if DelimChar = '' then
    Result.Text := AText
  else
    Result.Text := FastStringReplace(AText, DelimChar, sLineBreak);
end;

procedure TSmartHolder.FreeAndNilObj(var Obj: TObject);
begin
  FreeObj(Obj);
  Obj := nil;
end;

procedure TSmartHolder.FreeObj(Obj: TObject);
begin
  if Assigned(ObjsHolder) then
    ObjsHolder.FreeObj(Obj)
  else
    Obj.Free;
end;

function TSmartHolder.RegObj(Obj: TObject): TObject;
begin
  CheckObjsHolder();
  Result := ObjsHolder.RegObj(Obj);
end;

end.
