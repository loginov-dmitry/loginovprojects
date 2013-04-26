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
{ ������ fbUtilsCheckDBStruct - ������ ��������� ��������� ��                 }
{ (c) 2012 ������� ������� ���������                                          }
{ ��������� ����������: 09.05.2012                                            }
{ �������������� �� D7, D2007, D2010, D-XE2                                   }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

unit fbUtilsCheckDBStruct;

interface
uses
  Windows, Messages, SysUtils, Classes, IBDatabase, Variants, IniFiles,
  IBCustomDataSet, DB, fbUtilsDBStruct, fbTypes, fbSomeFuncs, fbUtilsBase;

type
  TDatabaseChecker = class(TBaseObject)
  private
    FConnParams: TFBConnectionParams;
    fbDataBaseDesc: TfbDataBaseDesc;
    FDB: TIBDatabase;
    FTran: TIBTransaction;
    Query1: TIBDataSet;
    TableList: THashedStringList;
    FieldList: THashedStringList;
    IndexList: THashedStringList;
    GenList: THashedStringList;
    TriggerList: THashedStringList;
    ProcedureList: THashedStringList;
    CheckList: THashedStringList;
    DefaultFields: THashedStringList;

    FLogProc: TFBLogEventsProc;

    function BuildCreateTableScript(ATable: TfbTableDesc): string;
    procedure CheckDomains;
    procedure FillTableList; // ��������� ������ ������
    procedure FillFieldsList; // ��������� ������ �����
    procedure FillIndexList; // ��������� ������ ��������
    procedure FillGeneratorsList; // ��������� ������ �����������
    procedure FillTriggerList; // ��������� ������ ���������
    procedure FillProcedureList; // ��������� ������ �������� ��������
    procedure FillCheckList; // ��������� ������ ���� �������� CHECK
    procedure CheckTable(ATable: TfbTableDesc); // ������������ �������� ����� �������
    procedure CheckForeignKeys; // ��������� ������� �����
    procedure CheckGenerators; // ��������� ������� �����������
    procedure CheckDefaultValues; // ������������� �������� �� ���������
    procedure CheckDefaultException; // ��������� ������� ���������� "ERR"
    procedure CheckTrigger(ATrigger: TfbTriggerDesc); // ��������� ������� �������� � ���� ������
    procedure CheckTriggers; // ��������� ������� ���������
    procedure CheckProcedure(AProc: TfbProcedureDesc); // ��������� ������� �������� ���������
    procedure Log(Msg: string; LogEvent: TFBLogEvent);
    procedure LogFmt(Msg: string; Args: array of const; LogEvent: TFBLogEvent);

  public
    constructor Create(dbStruct: TfbDataBaseDesc; AServerName: string; APort: Integer;
      ADataBase: string; AUserName: string; APassword: string; ACharSet: string; LogProc: TFBLogEventsProc);
    destructor Destroy; override;


    { ��������� ������� �������� ��������� ���� ������ }
    procedure StartCheck;
  end;

{ ������������ �������� � ����������� ��������� ��������� ���� ������ }
procedure FBCheckDBStruct(fbDataBaseDesc: TfbDataBaseDesc; AServerName: string;
  APort: Integer; ADataBase: string; AUserName: string; APassword: string;
  ACharSet: string; LogProc: TFBLogEventsProc; AModuleName: string);

{$IFDEF FBUTILSDLL} // ��������� �� ��������� �������� � ������ fbUtilsBase.pas
exports
  FBCheckDBStruct name 'ibxFBCheckDBStruct';
{$ENDIF}

resourcestring
  FBStrCheckDBStruct = '�������� ��������� ���� ������';

  FBStrCreatingErrObj = '����� ������ ������ ���������� ERR!';
  FBStrErrObjIsCreated = '�������� ������� ���������� ERR ���������!';
  FBStrErrObjCreating = '�������� ������� ���������� ERR';

  FBStrSettingDefValues = '���� "%s" ����� �������� �� ���������. ����� �������� ��� ������ ������� "%s"';
  FBStrDefValuesIsSet = '��������� �������� �� ��������� ���������!';
  FBStrDefValuesErr = '������ ��������� �������� �� ���������: ';
  FBStrDefValuesSetting = '��������� �������� �� ���������';

  FBStrDomainCreating = '����� ������ �����: ';
  FBStrDomainIsCreated = '�������� ������ ���������';
  FBStrCreateDomainProc = '�������� ������';

  FBStrFKCreating = '� ������� "%s" ����� �������� ������� ���� "%s"';
  FBStrFKIsCreated = '������� ���� ��������';
  FBStrCreateFKProc = '���������� �������� �����';

  FBStrGenCreating = '����� �������� ��������� "%s"';
  FBStrGenIsCreated = '��������� "%s" ��������';
  FBStrCreateGenProc = '���������� ����������';

  FBStrProcCreating = '����� ��������� �������� ��������� "%s"';
  FBStrProcIsCreated = '�������� ��������� ���������';
  FBStrCreateProcProc = '���������� �������� ���������';

  FBStrTableCreating = '����� ������� �������: ';
  FBStrTableIsCreated = '�������� ������� ���������';
  FBStrCreateTableProc = '�������� �������';

  FBStrFieldCreating = '� ������� "%s" ����� ��������� ���� "%s"';
  FBStrFieldIsCreated = '���� ������� ���������';
  FBStrCreateFieldProc = '���������� ����';

  FBStrFieldIncreasing = '� ������� "%s" ����� �������� ������ ���� "%s".'+
                         '������ ������: %d. ����� ������: %d.';
  FBStrFieldIsIncreased = '������ ���� ������� �������';
  FBStrFieldIncreaseProc = '��������� ������� ����';

  FBStrPKCreating = '� ������� "%s" ����� �������� ��������� ���� "%s"';
  FBStrPKIsCreated = '��������� ���� ��������';
  FBStrCreatePKProc = '���������� ���������� �����';

  FBStrIndexCreating = '� ������� "%s" ����� �������� ������ "%s"';
  FBStrIndexIsCreated = '������ ��������';
  FBStrCreateIndexProc = '���������� �������';

  FBStrCheckCreating   = '� ������� "%s" ����� ��������� �������� "%s"';
  FBStrCheckIsCreated  = '�������� ���������';
  FBStrCreateCheckProc = '���������� ��������';

  FBStrTriggerCreating   = '��� ������� "%s" ����� �������� ������� "%s": %s';
  FBStrTriggerIsCreated  = '������� ��������';
  FBStrCreateTriggerProc = '���������� ��������';

  FBStrDBCheckBegin = '������ �������� ���� ������ "%s".';
  FBStrDBCheckEnd = '�������� �� ��������� �� %s ���. ';
  FBStrDBCheckErr = '������ ��� �������� ��: %s (���: %d)';

  FBStrCreateDB = '������� ���� ������';


implementation

procedure FBCheckDBStruct(fbDataBaseDesc: TfbDataBaseDesc; AServerName: string;
  APort: Integer; ADataBase: string; AUserName: string; APassword: string;
  ACharSet: string; LogProc: TFBLogEventsProc; AModuleName: string);
begin
  try
    with TDatabaseChecker.Create(fbDataBaseDesc, AServerName, APort, ADataBase,
      AUserName, APassword, ACharSet, LogProc) do
    try
      StartCheck;
    finally
      Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrCheckDBStruct);
  end;
end;


{ TDatabaseChecker }

function TDatabaseChecker.BuildCreateTableScript(ATable: TfbTableDesc): string;
var
  I: Integer;
  S: string;
  AField: TfbFieldDesc;
begin
  with TStringList.Create do
  try
    Add(Format('CREATE TABLE "%s" (', [ATable.TableName]));
    for I := 0 to ATable.FieldList.Count - 1 do
    begin
      // �������� ����
      AField := TfbFieldDesc(ATable.FieldList[I]);
      S := Format('  "%s"  %s ', [AField.FName, AField.FType]);
      if AField.FDefault <> '' then
        S := S + Format('DEFAULT %s ', [AField.FDefault]);
      if AField.FNotNull = NotNull then
        S := S + 'NOT NULL ';

      S := S + ',';

      Add(S);
    end;

    // �������� ��������� ����
    if ATable.PrimaryKey.FName <> '' then
      Add(Format('CONSTRAINT "%s" PRIMARY KEY (%s)',
        [ATable.PrimaryKey.FName, ATable.PrimaryKey.FConstraintFields]));

    S := Trim(Text);
    if S[Length(S)] = ',' then
      SetLength(S, Length(S) - 1);
    Result := S + ')';
  finally
    Free;
  end;
end;

procedure TDatabaseChecker.CheckDefaultException;
var
  ERRExists: Boolean;
begin
  if fbDataBaseDesc.FAddErrException then
  begin
    Query1.SelectSQL.Text := 'SELECT * FROM RDB$EXCEPTIONS WHERE RDB$EXCEPTION_NAME=''ERR''';
    Query1.Open;
    ERRExists := not Query1.Eof;
    Query1.Close;

    if not ERRExists then
    begin
      Log(FBStrCreatingErrObj, tlpEvent);
      Query1.SelectSQL.Text := 'CREATE EXCEPTION ERR ''FireBird DataBase Error!''';
      try
        Query1.ExecSQL;
        Log(FBStrErrObjIsCreated, tlpEvent);
      except
        on E: Exception do
          raise ReCreateEObject(E, FBStrErrObjCreating, False);
      end;
    end;
  end;
end;

procedure TDatabaseChecker.CheckDefaultValues;
var
  I: Integer;
  TempList: TStringList;
begin
  if DefaultFields.Count > 0 then
  begin
    TempList := TStringList.Create;

    FBConnectDB(FDB);
    try
      FTran.StartTransaction;
      try
        for I := 0 to DefaultFields.Count - 1 do
        begin
          TempList.Text := StringReplace(DefaultFields[I],
            '<$@$>', sLineBreak, [rfReplaceAll]);
          if TempList.Count = 3 then
          begin
            Query1.SelectSQL.Text := Format('UPDATE "%s" SET "%s" = %s',
                [TempList[0], TempList[1], TempList[2]]);
            LogFmt(FBStrSettingDefValues, [TempList[1], TempList[0]], tlpEvent);
            try
              Query1.ExecSQL;
              Log(FBStrDefValuesIsSet, tlpEvent);
            except
              on E: Exception do
              begin
                Log(FBStrDefValuesErr + E.Message, tlpError); // ���. 2011-04-28
                raise ReCreateEObject(E, FBStrDefValuesSetting, False);
              end;
            end;
          end;
        end;

        if FTran.InTransaction then
          FTran.Commit;
      except
        // ��� �������� �� ��������� ��������������� � ������ ����� ����������.
        // ���� ���������� ����� �������� ��-�� ������, �� ���������� ��������� ���� ��������
        if FTran.InTransaction then
          FTran.Rollback;
      end;
    finally
      TempList.Free;
      FBDisconnectDB(FDB);
    end;
  end;
end;

procedure TDatabaseChecker.CheckDomains;
var
  AList: TStringList;
  S: string;
  I: Integer;
  ADomain: TfbDomainDesc;
begin
  AList := TStringList.Create;
  try
    Query1.SelectSQL.Text := 'SELECT RDB$FIELD_NAME FROM RDB$FIELDS WHERE NOT (RDB$FIELD_NAME LIKE ''RDB$%'')';
    Query1.Open;
    while not Query1.Eof do
    begin
      AList.Add(Trim(Query1.FieldByName('RDB$FIELD_NAME').AsString));
      Query1.Next;
    end;
    Query1.Close;

    for I := 0 to fbDataBaseDesc.FDomainList.Count - 1 do
    begin
      ADomain := TfbDomainDesc(fbDataBaseDesc.FDomainList[I]);
      if AList.IndexOf(ADomain.FName) < 0 then
      begin
        Log(FBStrDomainCreating + ADomain.FName, tlpEvent);

        // ��������� ����� �����
        S := Format('CREATE DOMAIN "%s" AS %s ', [ADomain.FName, ADomain.FType]);
        if ADomain.FDefault <> '' then
          S := S + 'DEFAULT ' + ADomain.FDefault + ' ';
        if ADomain.FNotNull = NotNull then
          S := S + 'NOT NULL ';
        if ADomain.FCheck <> '' then
          S := S + 'CHECK (' + ADomain.FCheck + ')';

        Query1.SelectSQL.Text := S;
        try
          Query1.ExecSQL;
          Log(FBStrDomainIsCreated, tlpEvent);
        except
          on E: Exception do
            raise ReCreateEObject(E, FBStrCreateDomainProc, False);
        end;
      end;
    end;
  finally
    AList.Free;
  end;
end;

procedure TDatabaseChecker.CheckForeignKeys;
var
  I: Integer;
  AKey: TfbForeignKeyDesc;
  S: string;
begin
  for I := 0 to fbDataBaseDesc.FForeignKeyList.Count - 1 do
  begin
    AKey := TfbForeignKeyDesc(fbDataBaseDesc.FForeignKeyList[I]);

    if (AKey.FName <> '') and (IndexList.IndexOf(AKey.FName) < 0) then
    begin
      LogFmt(FBStrFKCreating, [AKey.FTableName, AKey.FName], tlpEvent);

      S := Format('ALTER TABLE "%s" ADD CONSTRAINT "%s" FOREIGN KEY (%s) REFERENCES "%s" (%s)',
        [AKey.FTableName, AKey.FName, AKey.FConstraintFields,
         AKey.FRefTableName, AKey.FRefConstraintFields]);

      Query1.SelectSQL.Text := S;
      try
        Query1.ExecSQL;
      except
        on E: Exception do
          raise ReCreateEObject(E, FBStrCreateFKProc, False);
      end;
      Log(FBStrFKIsCreated, tlpEvent);
    end;
  end;
end;

procedure TDatabaseChecker.CheckGenerators;
var
  I: Integer;
  GenName, StartValue: string;
begin
  for I := 0 to fbDataBaseDesc.FGeneratorList.Count - 1 do
  begin
    GenName := fbDataBaseDesc.FGeneratorList.Names[I];
    StartValue := fbDataBaseDesc.FGeneratorList.ValueFromIndex[I];
    if GenList.IndexOf(GenName) < 0 then
    begin
      LogFmt(FBStrGenCreating, [GenName], tlpEvent);

      try
        Query1.SelectSQL.Text := Format('CREATE GENERATOR "%s"', [GenName]);
        Query1.ExecSQL;

        Query1.SelectSQL.Text := Format('SET GENERATOR "%s" TO %s', [GenName, StartValue]);
        Query1.ExecSQL;
      except
        on E: Exception do
          raise ReCreateEObject(E, FBStrCreateGenProc, False);
      end;
      LogFmt(FBStrGenIsCreated, [GenName], tlpEvent);
    end;
  end;
end;

procedure TDatabaseChecker.CheckProcedure(AProc: TfbProcedureDesc);
var
  MustCreateProc: Boolean;
  AHash: Cardinal;
  Idx: Integer;
  S: string;

  function GetProcCode(AName, InFieldsDesc, OutFieldsDesc, VarDesc, Body: string): string;
  var
    PSQL: string;
  begin
    PSQL := Format('CREATE OR ALTER PROCEDURE "%s" ', [AName]);

    InFieldsDesc := Trim(InFieldsDesc);
    if InFieldsDesc <> '' then
      PSQL := PSQL + sLineBreak + '(' + InFieldsDesc + ') ' + sLineBreak;

    OutFieldsDesc := Trim(OutFieldsDesc);
    if OutFieldsDesc <> '' then
      PSQL := PSQL + ' RETURNS ' + '(' + OutFieldsDesc + ') ' + sLineBreak;

    PSQL := PSQL + 'AS' + sLineBreak + FBCorrectDeclareVarSection(VarDesc);

    if Pos('BEGIN', Trim(UpperCase(Body))) <> 1 then
      Body := 'BEGIN' + sLineBreak + Body + sLineBreak + 'END;';

    PSQL := PSQL + Body;
    Result := PSQL;
  end;

begin
  Idx := ProcedureList.IndexOf(AProc.FName);
  MustCreateProc := Idx < 0;
  if Idx >= 0 then // ���� ����� ��������� � ���� �������...
  begin
    AHash := Cardinal(ProcedureList.Objects[Idx]);
    if AHash <> AProc.FHash then // ���� ���� �������� �� ���������...
      MustCreateProc := True;
  end;

  if MustCreateProc then // ������� ���������
  begin
    LogFmt(FBStrProcCreating, [AProc.FName], tlpEvent);

    Query1.ParamCheck := False;
    try
      Query1.SelectSQL.Text := GetProcCode(AProc.FName, AProc.FInFieldsDesc,
        AProc.FOutFieldsDesc, AProc.FVarDesc, AProc.FBody);
      try
        Query1.ExecSQL;
      except
        on E: Exception do
          raise ReCreateEObject(E, FBStrCreateProcProc, False);
      end;
    finally
      Query1.ParamCheck := True;
    end;


    // ��������� ���
    S := Format('UPDATE RDB$PROCEDURES SET RDB$DESCRIPTION=%s WHERE RDB$PROCEDURE_NAME=%s',
                [QuotedStr('Hash=' + IntToStr(Integer(AProc.FHash))), QuotedStr(AProc.FName)]);
    Query1.SelectSQL.Text := S;
    try
      Query1.ExecSQL;
    except
      on E: Exception do
        raise ReCreateEObject(E, 'Proc hash setting', False);
    end;

    Log(FBStrProcIsCreated, tlpEvent);
  end;
end;

procedure TDatabaseChecker.CheckTable(ATable: TfbTableDesc);
var
  script: string;
  I, FldIndex, APos, OldLen, NewLen: Integer;
  AField: TfbFieldDesc;
  S: string;
  AIndex: TfbIndexDesc;

begin
  // ���� ����� ������� ��� � ������ TableList, �� ������� ��
  if TableList.IndexOf(ATable.TableName) < 0 then
  begin
    Log(FBStrTableCreating + ATable.TableName, tlpEvent);
    script := BuildCreateTableScript(ATable);
    Query1.SelectSQL.Text := script;
    try   
      Query1.ExecSQL;
      Log(FBStrTableIsCreated, tlpEvent);
    except
      on E: Exception do
        raise ReCreateEObject(E, FBStrCreateTableProc, False);
    end;
  end else
  begin // ������� ����������. ��������� ����, ��������� ����� � �.�.

    // ���������, ��� �� ���� ���� � ������ �������
    for I := 0 to ATable.FieldList.Count - 1 do
    begin
      AField := TfbFieldDesc(ATable.FieldList[I]);

      FldIndex := FieldList.IndexOf(ATable.TableName + '=' + AField.FName);

      // ���� � ������� ������� ���� ���, �� ��������� ���
      if FldIndex < 0 then
      begin
        LogFmt(FBStrFieldCreating, [ATable.TableName, AField.FName], tlpEvent);

        S := Format('ALTER TABLE "%s" ADD "%s" %s ',
          [ATable.TableName, AField.FName, AField.FType]);
        if AField.FDefault <> '' then
          S := S + Format('DEFAULT %s ', [AField.FDefault]);
        if AField.FNotNull = NotNull then
          S := S + 'NOT NULL ';
        //if AField.FCheck <> '' then
        //  S := S + Format('CHECK(%s)', [AField.FCheck]);
        Query1.SelectSQL.Text := S;
        try
          Query1.ExecSQL;
        except
          on E: Exception do
            raise ReCreateEObject(E, FBStrCreateFieldProc, False);
        end;
        Log(FBStrFieldIsCreated, tlpEvent);

        // ��������� ������ ����������� � �� �������� �� ���������
        // � ���������� ����� ����� �������� �� ���� ������� � ����������
        // ������ �������� ��� ������ ������
        if AField.FDefault <> '' then
        begin
          DefaultFields.Add(Format('%s<$@$>%s<$@$>%s',
            [ATable.TableName, AField.FName, AField.FDefault]));
        end;

      end else
      begin
        // ������ ���� ����. ���� ��� ��������� ��� VARCHAR(X), �� ����������
        // ����� ������ ���� � ���� ������ � ����� ������ ���� � AField.FType
        S := UpperCase(AField.FType);
        APos := Pos('VARCHAR', S);
        if APos > 0 then
        begin
          S := Trim(Copy(S, APos + 7, MaxByte));
          APos := Pos('(', S);
          if APos > 0 then
          begin
             S := Trim(Copy(S, APos + 1, MaxByte));
             APos := Pos(')', S);
             if APos > 0 then
             begin
               S := Trim(Copy(S, 1, APos - 1));
               OldLen := Integer(FieldList.Objects[FldIndex]);
               NewLen := StrToIntDef(S, 0);
               if NewLen > OldLen then
               begin
                 LogFmt(FBStrFieldIncreasing, [ATable.TableName, AField.FName, OldLen, NewLen], tlpEvent);

                 // ������ SQL ��� ��������� ������� ����
                 S :=
                    'update RDB$FIELDS set' + sLineBreak +
                    'RDB$FIELD_LENGTH = ' + IntToStr(NewLen) + ',' + sLineBreak +
                    'RDB$CHARACTER_LENGTH = ' + IntToStr(NewLen) + sLineBreak +
                    'where RDB$FIELD_NAME =' + sLineBreak +
                    '    (SELECT RDB$FIELD_SOURCE' + sLineBreak +
                    '    FROM RDB$RELATION_FIELDS' + sLineBreak +
                    '    WHERE Trim(RDB$RELATION_NAME) = ' + QuotedStr(ATable.TableName) +
                    ' AND Trim(RDB$FIELD_NAME) = ' + QuotedStr(AField.FName) +')';

                 Query1.SelectSQL.Text := S;
                 try
                   Query1.ExecSQL;
                 except
                   on E: Exception do
                     raise ReCreateEObject(E, FBStrFieldIncreaseProc, False);
                 end;
                 Log(FBStrFieldIsIncreased, tlpEvent);
               end;
             end;
          end;
        end;
      end;
    end; // for

    // ���������, ���� �� ��������� ����
    if ATable.PrimaryKey.FName <> '' then
      if IndexList.IndexOf(ATable.PrimaryKey.FName) < 0 then
      begin
        LogFmt(FBStrPKCreating, [ATable.TableName, ATable.PrimaryKey.FName], tlpEvent);

        S := Format('ALTER TABLE "%s" ADD CONSTRAINT "%s" PRIMARY KEY (%s)',
          [ATable.TableName, ATable.PrimaryKey.FName, ATable.PrimaryKey.FConstraintFields]);

        Query1.SelectSQL.Text := S;
        try
          Query1.ExecSQL;
        except
          on E: Exception do
            raise ReCreateEObject(E, FBStrCreatePKProc, False);
        end;
        Log(FBStrPKIsCreated, tlpEvent);
      end;
  end;

  // ��������� ����������� �������
  for I := 0 to ATable.IndexList.Count - 1 do
  begin
    AIndex := TfbIndexDesc(ATable.IndexList[I]);
    if (AIndex.FName <> '') and (IndexList.IndexOf(AIndex.FName) < 0) then
    begin
      LogFmt(FBStrIndexCreating, [ATable.TableName, AIndex.FName], tlpEvent);

      S := 'CREATE ';
      if AIndex.FIsUnique then
        S := S + 'UNIQUE ';
      if AIndex.FSorting = Descending then
        S := S + 'DESCENDING ';
      S := S + Format('INDEX "%s" ON "%s" (%s)',
        [AIndex.FName, ATable.TableName, AIndex.FConstraintFields]);

      Query1.SelectSQL.Text := S;
      try
        Query1.ExecSQL;
      except
        on E: Exception do
          raise ReCreateEObject(E, FBStrCreateIndexProc, False);
      end;
      Log(FBStrIndexIsCreated, tlpEvent);
    end;
  end;

  // ��������� ����������� �������� CHECK
  for I := 0 to ATable.ChecksList.Count - 1 do
  begin
    if CheckList.IndexOf(ATable.ChecksList.Names[I]) < 0 then
    begin
      LogFmt(FBStrCheckCreating,
        [ATable.TableName, ATable.ChecksList.Names[I]], tlpEvent);

      S := Format('ALTER TABLE "%s" ADD CONSTRAINT "%s" CHECK(%s)',
        [ATable.TableName, ATable.ChecksList.Names[I],
          ATable.ChecksList.ValueFromIndex[I]]);

      Query1.SelectSQL.Text := S;
      try
        Query1.ExecSQL;
      except
        on E: Exception do
          raise ReCreateEObject(E, FBStrCreateCheckProc, False);
      end;

      Log(FBStrCheckIsCreated, tlpEvent);
    end;
  end;
end;

procedure TDatabaseChecker.CheckTrigger(ATrigger: TfbTriggerDesc);
var
  MustCreateTrigger: Boolean;
  AHash: Cardinal;
  Idx: Integer;
  S, SState, SEventTime, SEvents, Body, SPrefix, PSQL: string;
begin
  Idx := TriggerList.IndexOf(ATrigger.FName);
  MustCreateTrigger := Idx < 0;
  if Idx >= 0 then // ���� ����� ������� � ���� �������...
  begin
    AHash := Cardinal(TriggerList.Objects[Idx]);
    if AHash <> ATrigger.FHash then // ���� ���� ��������� �� ���������...
      MustCreateTrigger := True;
  end;

  if MustCreateTrigger then // ������� �������
  begin
    if ATrigger.FState = trsActive then
      SState := 'ACTIVE'
    else
      SState := 'INACTIVE';

    if ATrigger.FEventTime = trBefore then
      SEventTime := 'BEFORE'
    else
      SEventTime := 'AFTER';

    if trInsert in ATrigger.FEvents then
      SEvents := 'INSERT OR ';
    if trUpdate in ATrigger.FEvents then
      SEvents := SEvents + 'UPDATE OR ';
    if trDelete in ATrigger.FEvents then
      SEvents := SEvents + 'DELETE OR ';
    if SEvents <> '' then
      SetLength(SEvents, Length(SEvents) - 3);

    SPrefix := Format(
      'CREATE OR ALTER TRIGGER "%s" FOR "%s" %s %s %s POSITION %d',
      [ATrigger.FName, ATrigger.FTableName, SState, SEventTime, SEvents, ATrigger.FPos]);

    LogFmt(FBStrTriggerCreating, [ATrigger.FTableName, ATrigger.FName, SPrefix], tlpEvent);

    PSQL := SPrefix + sLineBreak + ' AS ' + sLineBreak + FBCorrectDeclareVarSection(ATrigger.FVarDesc);

    Body := Trim(ATrigger.FBody);
    if Pos('BEGIN', Trim(UpperCase(Body))) <> 1 then
      Body := 'BEGIN' + sLineBreak + Body + sLineBreak + 'END;';

    PSQL := PSQL + Body;

    // ������� �������
    Query1.ParamCheck := False;
    try
      Query1.SelectSQL.Text := PSQL;
      try
        Query1.ExecSQL;
      except
        on E: Exception do
          raise ReCreateEObject(E, FBStrCreateTriggerProc, False);
      end;
    finally
      Query1.ParamCheck := True;
    end;

    // ��������� ���
    S := Format('UPDATE RDB$TRIGGERS SET RDB$DESCRIPTION=%s WHERE RDB$TRIGGER_NAME=%s',
                [QuotedStr('Hash=' + IntToStr(Integer(ATrigger.FHash))), QuotedStr(ATrigger.FName)]);
    Query1.SelectSQL.Text := S;
    try
      Query1.ExecSQL;
    except
      on E: Exception do
        raise ReCreateEObject(E, 'Trigger hash setting', False);
    end;

    Log(FBStrTriggerIsCreated, tlpEvent);
  end;
end;

procedure TDatabaseChecker.CheckTriggers;
var
  I, J: Integer;
  ATable: TfbTableDesc;
begin
  for I := 0 to fbDataBaseDesc.FTableList.Count - 1 do
  begin
    ATable := TfbTableDesc(fbDataBaseDesc.FTableList[I]);

    // ��������� ��������
    for J := 0 to ATable.TriggerList.Count - 1 do
      CheckTrigger(TfbTriggerDesc(ATable.TriggerList[J]));
  end;
end;

constructor TDatabaseChecker.Create(dbStruct: TfbDataBaseDesc; AServerName: string; APort: Integer;
      ADataBase: string; AUserName: string; APassword: string; ACharSet: string; LogProc: TFBLogEventsProc);
begin
  inherited Create;
  FDB := TIBDatabase.Create(nil);
  FTran := FBCreateTransaction(FDB, trRCRW, False, nil, '');

  fbDataBaseDesc := dbStruct;

  FConnParams.cpServerName := AServerName;
  FConnParams.cpPort := APort;
  FConnParams.cpDataBase := ADataBase;
  FConnParams.cpUserName := AUserName;
  FConnParams.cpPassword := APassword;
  FConnParams.cpCharSet := ACharSet;

  FDB.DatabaseName := FBGetFullDatabaseName(FConnParams.cpServerName, FConnParams.cpPort, FConnParams.cpDataBase);
  FDB.LoginPrompt := False;

  FLogProc := LogProc;

  RegObj(Query1, TIBDataSet.Create(nil));
  TableList     := CreateHashedStringList;
  FieldList     := CreateHashedStringList;
  IndexList     := CreateHashedStringList;
  GenList       := CreateHashedStringList;
  CheckList     := CreateHashedStringList;
  DefaultFields := CreateHashedStringList;
  TriggerList   := CreateHashedStringList;
  ProcedureList := CreateHashedStringList;
end;

destructor TDatabaseChecker.Destroy;
begin
  FDB.Free;
  FTran.Free;
  inherited;
end;

procedure TDatabaseChecker.FillFieldsList;
begin
  Query1.SelectSQL.Text :=
    'SELECT Trim(rf.RDB$RELATION_NAME) || ''='' || Trim(rf.RDB$FIELD_NAME) AS ANAME,' + sLineBreak +
    '    f.RDB$FIELD_LENGTH AS FLEN' + sLineBreak +
    ' FROM RDB$RELATION_FIELDS rf' + sLineBreak +
    ' LEFT JOIN RDB$FIELDS f ON f.RDB$FIELD_NAME = rf.RDB$FIELD_SOURCE' + sLineBreak +
    ' WHERE NOT ((rf.RDB$RELATION_NAME LIKE ''RDB$%'') OR (rf.RDB$RELATION_NAME LIKE ''MON$%''))';

  Query1.Open;
  try
    while not Query1.Eof do
    begin
      // ���������� ��� ���� � ����� ����
      FieldList.AddObject(Trim(Query1.Fields[0].AsString), TObject(Query1.Fields[1].AsInteger));
      Query1.Next;
    end;
  finally
    Query1.Close;
  end;
end;

procedure TDatabaseChecker.FillIndexList;
begin
  Query1.SelectSQL.Text :=
    'SELECT Trim(RDB$INDEX_NAME) FROM RDB$INDICES' + sLineBreak +
    'WHERE NOT (RDB$INDEX_NAME LIKE ''RDB$%'')';

  Query1.Open;
  try
    while not Query1.Eof do
    begin
      IndexList.Add(Trim(Query1.Fields[0].AsString));
      Query1.Next;
    end;
  finally
    Query1.Close;
  end;
end;

procedure TDatabaseChecker.FillProcedureList;
var
  AList: TStringList;
  DBHash: Integer;
begin
  Query1.SelectSQL.Text :=
    'SELECT Trim(RDB$PROCEDURE_NAME), RDB$DESCRIPTION FROM RDB$PROCEDURES' + sLineBreak +
    'WHERE NOT (RDB$PROCEDURE_NAME LIKE ''RDB$%'')';

  AList := nil;
  Query1.Open;
  try
    AList := TStringList.Create;
    while not Query1.Eof do
    begin
      // ���������� ����������� ��� ���������
      AList.Text := FastStringReplace(Trim(Query1.Fields[1].AsString), ';', sLineBreak);
      DBHash := StrToIntDef(AList.Values['Hash'], 0);

      ProcedureList.AddObject(Trim(Query1.Fields[0].AsString), TObject(DBHash));
      Query1.Next;
    end;
  finally
    AList.Free;
    Query1.Close;
  end;
end;

procedure TDatabaseChecker.FillTableList;
begin
  Query1.SelectSQL.Text :=
    'Select RDB$RELATION_NAME from RDB$RELATIONS ' + {do not localize}
    ' where RDB$VIEW_BLR is NULL and RDB$SYSTEM_FLAG = 0 ' + {do not localize}
    'ORDER BY RDB$RELATION_NAME'; {do not localize}

  Query1.Open;
  try
    while not Query1.Eof do
    begin
      // ���������� ��� �������
      TableList.Add(Trim(Query1.Fields[0].AsString));
      Query1.Next;
    end;
  finally
    Query1.Close;
  end;
end;

procedure TDatabaseChecker.FillTriggerList;
var
  AList: TStringList;
  DBHash: Integer;
begin
  Query1.SelectSQL.Text :=
    'SELECT Trim(RDB$TRIGGER_NAME), RDB$DESCRIPTION FROM RDB$TRIGGERS' + sLineBreak +
    'WHERE NOT (RDB$TRIGGER_NAME LIKE ''RDB$%'')';

  AList := nil;
  Query1.Open;
  try
    AList := TStringList.Create;
    while not Query1.Eof do
    begin
      // ���������� ����������� ��� ��������
      AList.Text := FastStringReplace(Trim(Query1.Fields[1].AsString), ';', sLineBreak);
      DBHash := StrToIntDef(AList.Values['Hash'], 0);

      TriggerList.AddObject(Trim(Query1.Fields[0].AsString), TObject(DBHash));
      Query1.Next;
    end;
  finally
    AList.Free;
    Query1.Close;
  end;
end;

procedure TDatabaseChecker.Log(Msg: string; LogEvent: TFBLogEvent);
begin
  if Assigned(FLogProc) then
    FLogProc(Msg, LogEvent);
end;

procedure TDatabaseChecker.LogFmt(Msg: string; Args: array of const;
  LogEvent: TFBLogEvent);
begin
  Log(Format(Msg, Args), LogEvent);
end;

procedure TDatabaseChecker.FillGeneratorsList;
begin
  Query1.SelectSQL.Text :=
    'SELECT Trim(RDB$GENERATOR_NAME) FROM RDB$GENERATORS' + sLineBreak +
    'WHERE NOT (RDB$GENERATOR_NAME LIKE ''RDB$%'')';

  Query1.Open;
  try
    while not Query1.Eof do
    begin
      GenList.Add(Trim(Query1.Fields[0].AsString));
      Query1.Next;
    end;
  finally
    Query1.Close;
  end;
end;

procedure TDatabaseChecker.FillCheckList;
begin
  Query1.SelectSQL.Text :=
    'SELECT DISTINCT Trim(RDB$CONSTRAINT_NAME) FROM RDB$CHECK_CONSTRAINTS';

  Query1.Open;
  try
    while not Query1.Eof do
    begin
      CheckList.Add(Trim(Query1.Fields[0].AsString));
      Query1.Next;
    end;
  finally
    Query1.Close;
  end;
end;

procedure TDatabaseChecker.StartCheck;
var
  I: Integer;
  CanTryCreateDatabase: Boolean;
  CheckTime: TDateTime;
  tc: DWORD;
  tmGetTabs, tmGetFlds, tmGetIxs, tmGetGens, tmGetChecks: DWORD;
  tmCheckDoms, tmCheckTabs, tmCheckFKs, tmCheckGens, tmCheckErr, tmCheckDefs: DWORD;
  tmCheckProc, tmCheckTrig: DWORD;
  tmConn, tmCommit, tmDisconn: DWORD;
  STimes: string;
  Err: Integer;
begin
  Err := 0;
  Log('', tlpNone);
  CheckTime := Now;
  try
    LogFmt(FBStrDBCheckBegin, [FDB.DatabaseName], tlpEvent);

    // ���� ���� ���� ������ ����������, � ������ ������ localhost ��� 127.0.0.1,
    // �� �� ����� ��������� ���� ������ (��� ��� ����� �������� ���� � Exception)

    if ((UpperCase(FConnParams.cpServerName) = 'LOCALHOST') or
       (FConnParams.cpServerName = '127.0.0.1')) and FileExists(FConnParams.cpDataBase) then
      CanTryCreateDatabase := False
    else
      CanTryCreateDatabase := True;

    Err := 10;

    if CanTryCreateDatabase then
    begin
      // �������� ������� ���� ������. ���� ���� ��� ����, �� ����� ������
      // ��������� �� ������ "database or file exists"

      FDB.Params.Clear;

      if FConnParams.cpUserName <> '' then
        FDB.Params.Add(Format('USER %s', [QuotedStr(FConnParams.cpUserName)]));

      if FConnParams.cpPassword <> '' then
        FDB.Params.Add(Format('PASSWORD %s', [QuotedStr(FConnParams.cpPassword)]));

      FDB.Params.Add(Format('PAGE_SIZE %d', [FBDefPageSize]));

      if FConnParams.cpCharSet <> '' then
        FDB.Params.Add('DEFAULT CHARACTER SET ' + FConnParams.cpCharSet + ';');

      try
        FDB.CreateDatabase;
        FBDisconnectDB(FDB);
      except
        on E: Exception do
        begin
          if Pos('database or file exists', E.Message) = 0 then
            raise ReCreateEObject(E, FBStrCreateDB, False);
        end;
      end;

      FBDisconnectDB(FDB);
    end;

    Err := 20;

    // ���� ������ �������! ������ ��������� ������� ����������� ������
    FDB.Params.Clear;
    if FConnParams.cpUserName <> '' then
      FDB.Params.Values['user_name'] := FConnParams.cpUserName;

    if FConnParams.cpPassword <> '' then
      FDB.Params.Values['password'] := FConnParams.cpPassword;

    if FConnParams.cpCharSet <> '' then
      FDB.Params.Values['lc_ctype'] := FConnParams.cpCharSet;

    Query1.Transaction := FTran;

    Err := 30;

    // ������������ � ���� ������
    tc := GetTickCount;
    FBConnectDB(FDB);
    Err := 40;

    tmConn := GetTickCount - tc;
    FTran.StartTransaction;
    Err := 50;

    try

      // ��������� ������ ������
      tc := GetTickCount;
      FillTableList;
      tmGetTabs := GetTickCount - tc;

      Err := 60;

      // �������� ��� ������ ������� ������ �����
      tc := GetTickCount;
      FillFieldsList;
      tmGetFlds := GetTickCount - tc;
      Err := 70;

      // �������� ������ ��������
      tc := GetTickCount;
      FillIndexList;
      tmGetIxs := GetTickCount - tc;
      Err := 80;

      // �������� ������ �����������
      tc := GetTickCount;
      FillGeneratorsList;
      tmGetGens := GetTickCount - tc;
      Err := 90;

      // �������� ������ �������� CHECK
      tc := GetTickCount;
      FillCheckList;
      tmGetChecks := GetTickCount - tc;
      Err := 100;

      // �������� ������ ���������
      FillTriggerList;
      Err := 110;

      // �������� ������ �������� ��������
      FillProcedureList;
      Err := 115;

      // ��������� ������
      tc := GetTickCount;
      CheckDomains;
      tmCheckDoms := GetTickCount - tc;
      Err := 120;

      // ��������� �������
      tc := GetTickCount;
      for I := 0 to fbDataBaseDesc.FTableList.Count - 1 do
        CheckTable(TfbTableDesc(fbDataBaseDesc.FTableList[I]));
      tmCheckTabs := GetTickCount - tc;
      Err := 130;

      // ��������� ������� �����
      tc := GetTickCount;
      CheckForeignKeys();
      tmCheckFKs := GetTickCount - tc;
      Err := 140;

      // ��������� ����������
      tc := GetTickCount;
      CheckGenerators();
      tmCheckGens := GetTickCount - tc;
      Err := 150;

      // ���������, ���� �� ���������� ERR
      tc := GetTickCount;
      CheckDefaultException;
      tmCheckErr := GetTickCount - tc;
      Err := 160;

      // ��������� �������� ���������
      tc := GetTickCount;
      for I := 0 to fbDataBaseDesc.FProcedureList.Count - 1 do
        CheckProcedure(TfbProcedureDesc(fbDataBaseDesc.FProcedureList[I]));
      tmCheckProc := GetTickCount - tc;
      Err := 164;

      // ��������� ��������
      tc := GetTickCount;
      CheckTriggers();
      tmCheckTrig := GetTickCount - tc;
      Err := 168;

      tc := GetTickCount;
      if FTran.InTransaction then
        FTran.Commit;
      tmCommit := GetTickCount - tc;
      Err := 170;

    finally
      FTran.Active := False;
      tc := GetTickCount;
      FBDisconnectDB(FDB);
      tmDisconn := GetTickCount - tc;
    end;

    // ��������� �������� �� ���������
    Err := 180;
    tc := GetTickCount;
    CheckDefaultValues();
    tmCheckDefs := GetTickCount - tc;
    Err := 190;


    CheckTime := Now - CheckTime;

    STimes := Format(
      '(Conn:%d, GetTabs:%d, GetFlds:%d, GetIxs:%d, GetGens:%d, GetChecks:%d, '+
      'CheckDoms:%d, CheckTabs:%d, CheckFKs:%d, CheckGens:%d, CheckErr:%d, '+
      'CheckProcs:%d, CheckTrig:%d, CheckDefs:%d, '+
      'Commit:%d, Disconn:%d)',
      [tmConn, tmGetTabs, tmGetFlds, tmGetIxs, tmGetGens, tmGetChecks,
       tmCheckDoms, tmCheckTabs, tmCheckFKs, tmCheckGens, tmCheckErr,
       tmCheckProc, tmCheckTrig, tmCheckDefs,
       tmCommit, tmDisconn]);

    Err := 200;
    LogFmt(FBStrDBCheckEnd + STimes, [FormatDateTime('s.zzz', CheckTime)], tlpEvent);
  except
    on E: Exception do
    begin
      LogFmt(FBStrDBCheckErr, [E.Message, Err], tlpError);
      raise;
    end;
  end;
end;

end.
