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
{ ������ fbUtilsDBStruct - ������ �������� ��������� ��                       }
{ (c) 2012 ������� ������� ���������                                          }
{ ��������� ����������: 09.05.2012                                            }
{ �������������� �� D7, D2007, D2010, D-XE2                                   }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{
������ ��������� ������� ���� ��������� ������� ���� ������. ��� �������������
������������ ��� ���������� ���������� ����������, ��� ��������� ���� ������
�������� ������������ �������.
}

unit fbUtilsDBStruct;

interface

uses
  SysUtils, Classes, fbTypes, fbSomeFuncs;

type
  {�������� ����}
  TfbFieldDesc = class
    { ��� ����. ������������ ��� ������. ���� ��� ������ ��� ���� � ��������
      ������� �� �������, �� ���� ��������� }
    FName: string;

    { ��� / ����� ���� }
    FType: string;

    { �������� �� ���������. ���� ���� �� ������ ����� �������� ��
      ���������, ���������� ������ ������ }
    FDefault: string;

    { ������� True, ���� �������� ����������� }
    FNotNull: TFBNotNull;
  end;

  {�������� ������}
  TfbDomainDesc = class
    FName: string;         // ��� ������
    FType: string;         // �������� ������
    FDefault: string;      // �������� �� ���������
    FNotNull: TFBNotNull;  // NOT NULL
    FCheck: string;        // ��������� �������� CHECK
  end;

  {�������� ���������� �����}
  TfbPrimaryKeyDesc = record
    FName: string;

    { �������� �����, �������� � ��������� ���� }
    FConstraintFields: string;
  end;

  {�������� �������� �����}
  TfbForeignKeyDesc = class
    { ������������ �������� ����� }
    FName: string;

    { ��� �������, � ������� ������ ���� ��������� }
    FTableName: string;

    { �������� �����, �������� �� ������� ���� }
    FConstraintFields: string;

    { ��� �������, �� ������� ���� ��������� }
    FRefTableName: string;

    { ����� ����� ������� FRefTableName, �� ������� ���������� ���� FConstraintFields}
    FRefConstraintFields: string;
  end;

  {�������� �������}
  TfbIndexDesc = class
    { ������������ ������� }
    FName: string;

    { �������� ������ ���� ����������� }
    FIsUnique: Boolean;

    { ������� ���������� }
    FSorting: TFBSorting;

    { �������� �����, �������� � ������ }
    FConstraintFields: string;
  end;

  {�������� ��������}
  TfbTriggerDesc = class
    { ������������ �������� }
    FName: string;

    { ��� ������� }
    FTableName: string;

    { ������ ������������ �������� }
    FEventTime: TFBTriggerEventTime;

    { �������, �� ������� ������ ����������� ������� }
    FEvents: TFBTriggerEvents;

    { ����� �� ������ ������� ��������  }
    FState: TFBTriggerState;

    { ������� ������������ �������� }
    FPos: Integer;

    { ��������� ���������� �������� }
    FVarDesc: string;

    { �������� ��� (���� ��������) }
    FBody: string;

    { ��� ��������� ������ �������� (�� ���� �������� �������� ����� - ��� ��������) }
    FHash: Cardinal;
  end;

  {�������� �������� ���������}
  TfbProcedureDesc = class
    { ������������ ��������� }
    FName: string;

    {�������� ������� �����}
    FInFieldsDesc: string;

    {�������� �������� �����}
    FOutFieldsDesc: string;

    {�������� ����������}
    FVarDesc: string;

    {���� ���������}
    FBody: string;

    { ��� ��������� ������ ��������� }
    FHash: Cardinal;
  end;

  {�������� �������}
  TfbTableDesc = class
  private
    FFieldList: TList;
    FPrimaryKey: TfbPrimaryKeyDesc; // ��������� ���� �������
    FName: string;
    FIndexList: TList;
    FTriggerList: TList;
    FChecksList: TStringList;
    FUseModifyDate: TFBTriggerState; // ������������ ��� ��� ���� MODIFYDATE
    FDBDesc: TObject; // ������ �� ������ TfbDataBaseDesc
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    property TableName: string read FName;
    property FieldList: TList read FFieldList;
    property IndexList: TList read FIndexList;
    property ChecksList: TStringList read FChecksList;
    property PrimaryKey: TfbPrimaryKeyDesc read FPrimaryKey;
    property TriggerList: TList read FTriggerList;

  private {����������� �������}

    procedure SetUseModifyDate(Value: TFBTriggerState); virtual;
    function GetUseModifyDate: TFBTriggerState; virtual;
  public {����������� �������}

    { ��������� �������� ���� ���� ������ }
    procedure AddField(AName, AType, ADefault: string; NotNull: TFBNotNull); virtual;

    { ������������� ��������� ���� ������� }
    procedure SetPrimaryKey(AName, ConstraintFields: string); virtual;

    { ��������� ������}
    procedure AddIndex(AName: string; IsUnique: Boolean;
      ASorting: TFBSorting; ConstraintFields: string); virtual;

    { ��������� ��������� �������� ��� ������� }
    procedure AddCheck(AName: string; ACheck: string); virtual;

    { ��������� �������. � �������� TriggerName ����� �������� ������ ������. �
      ���� ������ ��� �������� ����� ������������ �������������. � �������� TriggerPos
      (������� ������������ ��������) ������������� �������� > 0 }
    procedure AddTrigger(TriggerEventTime: TFBTriggerEventTime; TriggerEvents: TFBTriggerEvents;
      TriggerPos: Integer; TriggerState: TFBTriggerState; TriggerName: string;
      TriggerVarDesc, TriggerBody: string); virtual;

    { ��������� ������� ��� ��������� ��������������. ���� CreateGenerator=TRUE,
      �� ������� ��������� � ������ AGenName ������������� }
    procedure AddAutoIncTrigger(ATriggerName, AFieldName, AGenName: string; CreateGenerator: Boolean); virtual;

    { ����������, ������� �� ������������ MODIFYDATE }
    property UseModifyDateTrigger: TFBTriggerState read GetUseModifyDate write SetUseModifyDate;
  end;

  {�������� ���� ������}
  TfbDataBaseDesc = class
  private
    procedure Clear;
  public

    FTableList: TList;           // ������ ������
    FDomainList: TList;          // ������ �������
    FForeignKeyList: TList;      // ������ ������� ������
    FGeneratorList: TStringList; // ������ �����������
    FProcedureList: TList;       // ������ �������� ��������
    FAddErrException: Boolean;   // ����������, ����� �� ��������� ������ ����������

    constructor Create;
    destructor Destroy; override;

  public {����������� �������}

    { ����� ������ }
    function GetVersion: Integer; virtual;

    { ��������� �������� ������ }
    procedure AddDomain(AName, AType, ADefault: string; NotNull: TFBNotNull; ACheck: string); virtual;

    { ��������� �������� ������� }
    function AddTable(TableName: string): TfbTableDesc; virtual;

    { ��������� ������� ���� }
    procedure AddForeignKey(AName, TableName, ConstraintFields,
      RefTableName, RefConstraintFields: string); virtual;

    { ��������� ������� ���������� }
    procedure AddGenerator(AName: string; StartValue: Int64); virtual;

    { ��������� �������� ��������� }
    procedure AddProcedure(AName, InFieldsDesc, OutFieldsDesc, VarDesc, Body: string); virtual;

    { ��������� ������ ���������� "ERR" }
    procedure AddDefaultException; virtual;
  end;


function FBCreateDataBaseDesc: TfbDataBaseDesc;
procedure FBFreeDataBaseDesc(dbDesc: TfbDataBaseDesc);

{$IFDEF FBUTILSDLL} // ��������� �� ��������� �������� � ������ fbUtilsBase.pas
exports
  FBCreateDataBaseDesc name 'ibxFBCreateDataBaseDesc',
  FBFreeDataBaseDesc name 'ibxFBFreeDataBaseDesc';
{$ENDIF}

implementation


function FBCreateDataBaseDesc: TfbDataBaseDesc;
begin
  Result := TfbDataBaseDesc.Create;
end;

procedure FBFreeDataBaseDesc(dbDesc: TfbDataBaseDesc);
begin
  dbDesc.Free;
end;

{ TfbTable }

procedure TfbTableDesc.AddField(AName, AType, ADefault: string; NotNull: TFBNotNull);
var
  AField: TfbFieldDesc;
begin
  AField := TfbFieldDesc.Create;
  AField.FName := AnsiUpperCase(AName);
  AField.FType := AType;
  AField.FDefault := ADefault;

  AField.FNotNull := NotNull;

  FFieldList.Add(AField);
end;

procedure TfbTableDesc.AddIndex(AName: string; IsUnique: Boolean;
  ASorting: TFBSorting; ConstraintFields: string);
var
  Ind: TfbIndexDesc;
begin
  Ind := TfbIndexDesc.Create;
  Ind.FName := AnsiUpperCase(AName);
  Ind.FIsUnique := IsUnique;
  Ind.FSorting := ASorting;
  Ind.FConstraintFields := AnsiUpperCase(ConstraintFields);

  FIndexList.Add(Ind);
end;

procedure TfbTableDesc.AddTrigger(TriggerEventTime: TFBTriggerEventTime;
  TriggerEvents: TFBTriggerEvents; TriggerPos: Integer;
  TriggerState: TFBTriggerState; TriggerName: string; TriggerVarDesc, TriggerBody: string);
var
  Trig: TfbTriggerDesc;
  ActStr, S: string;
begin
  if TriggerEventTime = trBefore then
    ActStr := 'B'
  else
    ActStr := 'A';

  if trInsert in TriggerEvents then
    ActStr := ActStr + 'I';
  if trUpdate in TriggerEvents then
    ActStr := ActStr + 'U';
  if trDelete in TriggerEvents then
    ActStr := ActStr + 'D';
  ActStr := ActStr + IntToStr(TriggerPos);

  // ��� ������������� ��������� TriggerName
  if TriggerName = '' then
    TriggerName := FName + '_' + ActStr;

  if TriggerState = trsActive then // ��������� ��� ���������� ����
    S := '_A'
  else
    S := '_I';

  Trig := TfbTriggerDesc.Create;
  try
    Trig.FName := AnsiUpperCase(TriggerName);
    Trig.FTableName := FName;
    Trig.FEventTime := TriggerEventTime;
    Trig.FEvents := TriggerEvents;
    Trig.FState := TriggerState;
    Trig.FPos := TriggerPos;
    Trig.FVarDesc := TriggerVarDesc;
    Trig.FBody := TriggerBody;
    Trig.FHash := GenerateStringHashLY(ActStr + S + '_' + TriggerVarDesc + '_' + TriggerBody);
  except
    Trig.Free;
    raise;
  end;

  FTriggerList.Add(Trig);

end;

procedure TfbTableDesc.AddAutoIncTrigger(ATriggerName, AFieldName, AGenName: string; CreateGenerator: Boolean);
begin
  AFieldName := AnsiUpperCase(AFieldName);
  AGenName := AnsiUpperCase(AGenName);

  if CreateGenerator then
    TfbDataBaseDesc(FDBDesc).AddGenerator(AGenName, 0);

  if ATriggerName = '' then
    ATriggerName := FName + '_AUTOINC';

  AddTrigger(trBefore, [trInsert], 0, trsActive,
    ATriggerName,
    '', // ��������� ���������� - �����������
    Format('IF (NEW."%0:s" IS NULL) THEN NEW."%0:s"=GEN_ID("%1:s", 1);',
      [AFieldName, AGenName]));
end;

procedure TfbTableDesc.AddCheck(AName: string; ACheck: string);
begin
  FChecksList.Values[AnsiUpperCase(AName)] := ACheck;
end;


procedure TfbTableDesc.Clear;
var
  I: Integer;
begin
  for I := 0 to FFieldList.Count - 1 do
    TfbFieldDesc(FFieldList[I]).Free;
  FFieldList.Clear;

  for I := 0 to FIndexList.Count - 1 do
    TfbIndexDesc(FIndexList[I]).Free;
  FIndexList.Clear;

  for I := 0 to FTriggerList.Count - 1 do
    TfbTriggerDesc(FTriggerList[I]).Free;
  FTriggerList.Clear;
end;

constructor TfbTableDesc.Create;
begin
  inherited;
  FFieldList := TList.Create;
  FIndexList := TList.Create;
  FTriggerList := TList.Create;
  FChecksList := TStringList.Create;
end;

destructor TfbTableDesc.Destroy;
begin
  Clear;
  FFieldList.Free;
  FIndexList.Free;
  FTriggerList.Free;
  FChecksList.Free;
  inherited;
end;

function TfbTableDesc.GetUseModifyDate: TFBTriggerState;
begin
  Result := FUseModifyDate;
end;

procedure TfbTableDesc.SetPrimaryKey(AName, ConstraintFields: string);
begin
  FPrimaryKey.FName := AnsiUpperCase(AName);
  FPrimaryKey.FConstraintFields := AnsiUpperCase(ConstraintFields);
end;

procedure TfbTableDesc.SetUseModifyDate(Value: TFBTriggerState);
const
  TrCode =
    '  IF ((NEW.MODIFYDATE IS NULL) AND (OLD.MODIFYDATE IS NOT NULL)) THEN EXIT;'#13#10+ // ��������� ���������� �������� � NULL
    '  IF ((OLD.MODIFYDATE IS NULL) AND (NEW.MODIFYDATE IS NOT NULL)) THEN EXIT;'#13#10+ // ��������� ������������� ������������ �������� (������ � ������ ���)
    '  NEW.MODIFYDATE = CURRENT_TIMESTAMP;'; // ����������� ������� ������ �������
begin
  FUseModifyDate := Value;

  if FUseModifyDate <> trsNone then
  begin
    // ��������� ���� MODIFYDATE
    AddField('MODIFYDATE', 'TIMESTAMP', '', CanNull);

    // ��������� ������
    AddIndex(FName + '_MDIDX', False, Ascending, '"MODIFYDATE"');

    // ��������� �������
    AddTrigger(trBefore, [trInsert, trUpdate], 10, Value, FName + '_MDBIU', '', TrCode);
  end;
end;

{ TfbDataBase }

procedure TfbDataBaseDesc.AddDomain(AName, AType, ADefault: string;
  NotNull: TFBNotNull; ACheck: string);
var
  ADomain: TfbDomainDesc;
begin
  ADomain := TfbDomainDesc.Create;

  ADomain.FName := AnsiUpperCase(AName);
  ADomain.FType := AType;
  ADomain.FDefault := ADefault;

  ADomain.FNotNull := NotNull;
  ADomain.FCheck := ACheck;

  FDomainList.Add(ADomain);
end;

procedure TfbDataBaseDesc.AddDefaultException;
begin
  FAddErrException := True;
end;

procedure TfbDataBaseDesc.AddForeignKey(AName, TableName, ConstraintFields,
  RefTableName, RefConstraintFields: string);
var
  AForeignKey: TfbForeignKeyDesc;
begin
  AForeignKey := TfbForeignKeyDesc.Create;
  AForeignKey.FName := AnsiUpperCase(AName);
  AForeignKey.FTableName := AnsiUpperCase(TableName);
  AForeignKey.FConstraintFields := AnsiUpperCase(ConstraintFields);
  AForeignKey.FRefTableName := AnsiUpperCase(RefTableName);
  AForeignKey.FRefConstraintFields := AnsiUpperCase(RefConstraintFields);

  FForeignKeyList.Add(AForeignKey);
end;

procedure TfbDataBaseDesc.AddGenerator(AName: string; StartValue: Int64);
begin
  FGeneratorList.Values[AnsiUpperCase(AName)] := IntToStr(StartValue);
end;

procedure TfbDataBaseDesc.AddProcedure(AName, InFieldsDesc, OutFieldsDesc, VarDesc, Body: string);
var
  AProc: TfbProcedureDesc;
begin
  AName := AnsiUpperCase(AName);

  AProc := TfbProcedureDesc.Create;
  AProc.FName := AName;
  AProc.FInFieldsDesc := InFieldsDesc;
  AProc.FOutFieldsDesc := OutFieldsDesc;
  AProc.FVarDesc := VarDesc;
  AProc.FBody := Body;
  AProc.FHash := GenerateStringHashLY(AName + '_' + InFieldsDesc + '_' +
    OutFieldsDesc + '_' + VarDesc + '_' + Body);

  FProcedureList.Add(AProc);
end;

function TfbDataBaseDesc.AddTable(TableName: string): TfbTableDesc;
begin
  Result := TfbTableDesc.Create;
  Result.FName := AnsiUpperCase(TableName);
  Result.FDBDesc := Self;

  FTableList.Add(Result);
end;

procedure TfbDataBaseDesc.Clear;
var
  I: Integer;
begin
  for I := 0 to FTableList.Count - 1 do
    TfbTableDesc(FTableList[I]).Free;
  FTableList.Clear;

  for I := 0 to FDomainList.Count - 1 do
    TObject(FDomainList[I]).Free;
  FDomainList.Clear;

  for I := 0 to FForeignKeyList.Count - 1 do
    TObject(FForeignKeyList[I]).Free;
  FForeignKeyList.Clear;

  for I := 0 to FProcedureList.Count - 1 do
    TObject(FProcedureList[I]).Free;
  FProcedureList.Clear;
end;

constructor TfbDataBaseDesc.Create;
begin
  inherited;
  FTableList := TList.Create;
  FDomainList := TList.Create;
  FForeignKeyList := TList.Create;
  FGeneratorList := TStringList.Create;
  FProcedureList := TList.Create;
end;

destructor TfbDataBaseDesc.Destroy;
begin
  Clear;
  FTableList.Free;
  FDomainList.Free;
  FForeignKeyList.Free;
  FGeneratorList.Free;
  FProcedureList.Free;
  inherited;
end;

function TfbDataBaseDesc.GetVersion: Integer;
begin
  Result := 1;
end;

end.
