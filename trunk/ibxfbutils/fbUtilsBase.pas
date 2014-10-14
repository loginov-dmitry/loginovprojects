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
{ ������ fbUtilsBase - �������� ������� ������� ��� ������ � fbUtils          }
{ (c) 2012 ������� ������� ���������                                          }
{ ��������� ����������: 09.05.2012                                            }
{ �������������� �� D7, D2007, D2010, D-XE2                                   }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{
���� ������ �� ���������� ������� �� ������ fbUtils.pas.

������ ������ ������ ������������� � ���������� ������� ������ ����������.
���� ����� ������������� ��������, �� ������ ������ ���� ������������� �
��������� DLL-���������� ��� BPL-�����

������������ � ����� �������� �� ����� ������������ ������ ������ ��������.
}

unit fbUtilsBase;

interface

uses
  Windows, SysUtils, Classes, IB, IBDatabase, IBCustomDataSet, Variants, fbTypes, fbSomeFuncs;

{������� ������ ���������� � ����� ������. ������������� ��������� �������
 ���������� (���� TranType>trNone), � ����� ������� ���������� � ����� ������.
 �������� �������� ����� �� ��� �����������, ������������� � ������ fbUtilsPool.pas}
function FBCreateConnection(AServerName: string; APort: Integer; ADataBase: string;
      AUserName, APassword, ACodePage: string; TranType: TTransactionType;
      DoOpen: Boolean; AOwner: TComponent; AModuleName: string): TIBDataBase;

{���������� ������ � ������ ������ ���� ������, ������� (��� �������������) ��� ������� � TCP-����.
 ���� ��� ������� �� �������, �� ������������ ��� ����������� LOCAL}
function FBGetFullDatabaseName(AServerName: string; APort: Integer; ADBName: string): string;

{����������� � ���� ������}
procedure FBConnectDB(FDB: TIBDatabase; AModuleName: string = '');

{���������� �� ���� ������}
procedure FBDisconnectDB(FDB: TIBDatabase; AModuleName: string = '');

{�������� ������� ����������� � ���� ������}
procedure FBFreeConnection(FDB: TIBDatabase; AModuleName: string);

{������� ��������� � ������������ � �������� TranType }
function FBCreateTransaction(FDB: TIBDataBase; TranType: TTransactionType; AutoStart: Boolean;
  AOwner: TComponent; AModuleName: string): TIBTransaction;

{������� ����� ������ TIBDataSet.
 �� ��������� ParamCheck=True. ��� ��������� � ����������� �������.
 ��������! � Delphi XE2 ��������� ������ ��� �������� � �������� AOwner ��������
 TIBDataBase ��� TIBTransaction}
function FBCreateDataSet(FDB: TIBDatabase; FTran: TIBTransaction; TranAutoStart: Boolean;
  AOwner: TComponent; AModuleName: string): TIBDataSet;

{������� ����� ������ TIBDataSet � ������������� ��������� ���������� ������. ������:
 ds := FBCreateAndOpenDataSet(MyDB, MyTran, 'SELECT * FROM MYTABLE', [], [], nil, '')
 FetchAll ���������� �������������}
function FBCreateAndOpenDataSet(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
  ParamNames: array of string; ParamValues: array of Variant;
  AOwner: TComponent; AModuleName: string): TIBDataSet;

{������� ����� ������ TIBDataSet � ��������� SELECT-������ � ����� �������}  
function FBCreateAndOpenTable(FDB: TIBDatabase; FTran: TIBTransaction; 
  ATable, AFilter, AOrder: string;
  ParamNames: array of string; ParamValues: array of Variant;
  AOwner: TComponent; AModuleName: string): TIBDataSet;

{��������� ��������� SQL-������.
 ��������! ���������� �� �����������!}
procedure FBExecQuery(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
  ParamNames: array of string; ParamValues: array of Variant; AModuleName: string);

{��������� ������. � FieldNames ������ ���� ��� ����, � ��� ����� � ��������.
 �������� ���� ������������� � ������ WHERE}
procedure FBUpdateRecordBase(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string; KeyValues: array of Variant;
  FieldNames: array of string; AFieldValues: array of Variant; AModuleName: string);

{��������� ������ � ������� ������������ ���� ������ }
procedure FBInsertRecordBase(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; FieldNames: array of string; AFieldValues: array of Variant; AModuleName: string);

{�������� ����� �� ������� TableName ���� ������ IBdb. ���� ������ KeyFields ������,
 �� ����������� ������ ������� �������}
procedure FBDeleteRecordBase(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string; KeyValues: array of Variant; AModuleName: string);

{��������� ��� ��������� ������ (��������� � FB v.2.1)}
procedure FBUpdateOrInsertRecordBase(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; FieldNames: array of string; AFieldValues: array of Variant; 
  KeyFields: array of string; AModuleName: string);

{���������� ������ ����������. ��� ���������� ����� ����� ������������ ������
 ���� ��������� ���������� FBUTILS.DLL. ��� ����� �������������}
function FBUtilsVersion: Integer;

{��������� 4 ������� ��������� ��������� ��� � ������ ������������ � ����������
 FBUserName � FBPassword � ��������� ��. ���������� FBUtils �� ���������� ������
 ���������� ��� �����-���� �����. ��� ����� ��� �������� ������������� ����������.
 � ��� ������, ���� ������������ FBUTILS.DLL, ���������� ����� ������ ��� ����
 �������. ������������� �������� ���������� ������� ������ �� ������ �����}
procedure FBSetUserName(AUserName: string);
function FBGetUserName: string;
procedure FBSetPassword(APassword: string);
function FBGetPassword: string;

{������������ �������� ��������� ���������� (�������� ����� ������ ���������� �����).
 ���������� ���������� �� �������� � ���� ������ � �������� ����� ������������ ����������.
 ������� �� ������������� ��������, ���� ����������� ����������� ������ � ����� ������.
 ������ ��������� ���������� ������������� ������������ ������ Backup/Restore}
procedure FBRecomputeIndexStatistics(FDB: TIBDatabase; AModuleName: string);

{����������� �������� ���������� GeneratorName �� IncValue � ���������� ���������� ��������.
 ���������� ������� ������� � ����� ����������, ���� � ���� ���� �������������}
function FBGenID(FDB: TIBDatabase; GeneratorName: string; IncValue: Integer; AModuleName: string): Int64;

{��������� ������� EXECUTE BLOCK (������ �������� ���������).
 ��������! �� ��������� ��� ������� SUSPEND, ����� �� ������ �� ����� ������
 OutFieldsDesc - �������� ����. ���� ������ ������, �� ������� ��������� �������
   � ���������� NIL
 VarDesc - �������� ����������
 Body - ���� �������� ���������. ��������� � �������� BEGIN..END ������������� �������������  }
function FBExecuteBlockFunc(FDB: TIBDataBase; FTran: TIBTransaction; OutFieldsDesc,
  VarDesc, Body: string; AModuleName: string): TIBDataSet;

{���������� FBExecuteBlockFunc, �� �� ���������� �������� ����������}
procedure FBExecuteBlockProc(FDB: TIBDataBase; FTran: TIBTransaction;
  VarDesc, Body: string; AModuleName: string);

{���������� ������� ������� ATableName. ���������� ������� AWhere, ���� ��� ������.
 ���� GarbageCollection=True, �� ��������� ������������� ������ ������. ������ ������
 �������� ������ ��� FTran=NIL}
procedure FBClearTable(FDB: TIBDataBase; FTran: TIBTransaction; ATableName, AWhere: string;
  GarbageCollection: Boolean; AModuleName: string);

{���������, �������� �� ������� TIBDataBase � TIBTransaction. ���� ���, �� ��������
 �������� ����������� ������ � ������ �������-���������}
procedure FBCheckDBAndTransObjects(var FDB: TIBDataBase; var FTran: TIBTransaction);

{������������ ��������� ���������� �������� ��������� / �������� / EXECUTE BLOCK}
function FBCorrectDeclareVarSection(VarDesc: string): string;

{���������, ���������� �� ������ ����������� IBX ������������ ����� � � ������ �������}
function FBPackagesIsCorrect(IBDBClass: TClass): Boolean;

var
  {������� ��� ������ ����������� � �� Firebird. ��������, ��� ��� �������
   �������������� ����������� � �� Firebird �� ������������ ������� �����
   ��������� ������. ����� ��� �������� ������.}
  FBConnectMutex: THandle;

  // ������� ������� ��� ����������� � ��
  FBConnectDBFunc: procedure(FDB: TIBDatabase; AModuleName: string);

  // ������� ������� ��� ���������� �� ��
  FBDisconnectDBFunc: procedure(FDB: TIBDatabase; AModuleName: string);


{$IFDEF FBUTILSDLL} // ��� ����� ��������� � ������� FBUTILS.DPR. ���� �� ��� ���,
                    // �� �������� ��������� FBUTILSDLL � ����� ������� �������.
                    // ���� ������������ FBUTILS.DLL �� ����� FBUTILSDLL �������
                    // ����� ��������� �� ���� ��������, � ������� ���� fbUtils.pas
exports
  FBPackagesIsCorrect name 'ibxFBPackagesIsCorrect',
  FBCreateConnection name 'ibxFBCreateConnection',
  FBConnectDB name 'ibxFBConnectDB',
  FBDisconnectDB name 'ibxFBDisconnectDB',
  FBFreeConnection name 'ibxFBFreeConnection',
  FBCreateTransaction name 'ibxFBCreateTransaction',
  FBCreateDataSet name 'ibxFBCreateDataSet',
  FBCreateAndOpenDataSet name 'ibxFBCreateAndOpenDataSet',
  FBCreateAndOpenTable name 'ibxFBCreateAndOpenTable',
  FBExecQuery name 'ibxFBExecQuery',
  FBUpdateRecordBase name 'ibxFBUpdateRecordBase',
  FBInsertRecordBase name 'ibxFBInsertRecordBase',
  FBDeleteRecordBase name 'ibxFBDeleteRecordBase',
  FBUpdateOrInsertRecordBase name 'ibxFBUpdateOrInsertRecordBase',
  FBUtilsVersion name 'ibxFBUtilsVersion',
  FBSetUserName name 'ibxFBSetUserName',
  FBGetUserName name 'ibxFBGetUserName',
  FBSetPassword name 'ibxFBSetPassword',
  FBGetPassword name 'ibxFBGetPassword',
  FBRecomputeIndexStatistics name 'ibxFBRecomputeIndexStatistics',
  FBGenID name 'ibxFBGenID',
  FBExecuteBlockFunc name 'ibxFBExecuteBlockFunc',
  FBExecuteBlockProc name 'ibxFBExecuteBlockProc',
  FBClearTable name 'ibxFBClearTable';
{$ENDIF}

resourcestring
  FBStrCreateConnection = '�������� ����������� � ���� ������';
  FBStrConnectToDB = '����������� � ���� ������';
  FBStrDisconnectDB = '���������� �� ���� ������';
  FBStrFreeConnection = '�������� ����������� � ���� ������';
  FBStrCreateTransaction = '�������� ����������';
  FBStrCreateDataSet = '�������� ������ ������';
  FBStrCreateAndOpenDataSet = '�������� � �������� ������ ������';
  FBStrCreateAndOpenTable = '�������� �������';
  FBStrExecQuery = '��������� ������';
  FBStrUpdateRec = '��������� ������ � "%s"';
  FBStrInsertRec = '������� ������ � "%s" (%s)';
  FBStrUpdateOrInsertRec = '���������� ��� ���������� ������ � "%s" (%s)';
  FBStrDeleteRec = '�������� ������ �� "%s"';
implementation

var
  {������� ��� ������������ ��� ����������� � ��}
  FBUserName: string = FBDefUser; {�� ��������� ����� FBDefUser}

  {������ ������������ ��� ����������� � ��}
  FBPassword: string = FBDefPassword; {�� ��������� ����� FBDefPassword}
  
function FBGetFullDatabaseName(AServerName: string; APort: Integer; ADBName: string): string;
begin
  Result := AServerName;
  if (Result <> '') and (APort > 0) then
    Result := Result +  '/' + IntToStr(APort);
  if Result <> '' then
    Result := Result + ':';
  Result := Result + ADBName;
end;

function FBCreateConnection(AServerName: string; APort: Integer; ADataBase: string;
      AUserName, APassword, ACodePage: string; TranType: TTransactionType;
      DoOpen: Boolean; AOwner: TComponent; AModuleName: string): TIBDataBase;
begin
  try
    Result := TIBDatabase.Create(AOwner);
    try
      if AUserName <> '' then
        Result.Params.Values['user_name'] := AUserName;

      if APassword <> '' then
        Result.Params.Values['password'] := APassword;

      if ACodePage <> '' then
        Result.Params.Values['lc_ctype'] := ACodePage;

      Result.DatabaseName := FBGetFullDatabaseName(AServerName, APort, ADataBase);
      Result.LoginPrompt := False;

      if TranType > trNone then
        Result.DefaultTransaction := FBCreateTransaction(Result, TranType, False, Result, AModuleName);

      if DoOpen then
        FBConnectDB(Result, AModuleName);

    except 
      Result.Free;
      raise;
    end;  
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrCreateConnection); // TODO: ������ AModuleName
  end;
end;

procedure FBConnectDB(FDB: TIBDatabase; AModuleName: string);
begin
  try
    if not FDB.TestConnected then // ���� ����������� ��� �� �����������
    begin
      if WaitForSingleObject(FBConnectMutex, INFINITE) = WAIT_OBJECT_0 then
      try
        FDB.Connected := False; // ������������� ���������� �� ������ ������ � False
        FDB.Connected := True;  // ������������� ����������� � ���� �����
      finally
        ReleaseMutex(FBConnectMutex);
      end
      else
        RaiseLastOSError;      
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrConnectToDB); // TODO: ������ AModuleName
  end;
end;

procedure FBDisconnectDB(FDB: TIBDatabase; AModuleName: string);
begin
  try
    if WaitForSingleObject(FBConnectMutex, INFINITE) = WAIT_OBJECT_0 then
    try
      FDB.Connected := False;
    finally
      ReleaseMutex(FBConnectMutex);
    end
    else
      RaiseLastOSError;
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrDisconnectDB); // TODO: ������ AModuleName
  end;
end;

procedure FBFreeConnection(FDB: TIBDatabase; AModuleName: string);
begin
  try
    if Assigned(FDB) then
    try
      if FDB.Connected then
        FBDisconnectDB(FDB, AModuleName);
    finally
      FDB.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrFreeConnection); // TODO: ������ AModuleName
  end;
end;

function FBCreateTransaction(FDB: TIBDataBase; TranType: TTransactionType; AutoStart: Boolean;
  AOwner: TComponent; AModuleName: string): TIBTransaction;
begin
  try
    Result := TIBTransaction.Create(AOwner);
    try
      Result.Params.Text := TransactionParams[TranType];
      Result.DefaultDatabase := FDB;
      Result.DefaultAction := TARollback;
      if AutoStart then
        Result.StartTransaction;
    except
      Result.Free;
      raise;
    end;  
  except
    on E: Exception do 
      raise ReCreateEObject(E, FBStrCreateTransaction); // TODO: ������ AModuleName
  end;
end;

procedure FBCheckDBAndTransObjects(var FDB: TIBDataBase; var FTran: TIBTransaction);
begin
  try
    if FTran = nil then
    begin
      if Assigned(FDB) then
        FTran := FDB.DefaultTransaction;
    end else if FDB = nil then
    begin
      if Assigned(FTran) then
        FDB := FTran.DefaultDatabase;
    end;
    
    if FDB = nil then
      raise Exception.Create('Information about TIBDataBase not found');
    if FTran = nil then
      raise Exception.Create('Information about TIBTransaction not found');      
    
  except
    on E: Exception do
      raise ReCreateEObject(E, 'FBCheckDBAndTransObjects'); // TODO: ������ AModuleName
  end;

end;

function FBCreateDataSet(FDB: TIBDatabase; FTran: TIBTransaction; TranAutoStart: Boolean;
  AOwner: TComponent; AModuleName: string): TIBDataSet;
var
  OwnerIsDBorTran: Boolean;
begin  
  try
    FBCheckDBAndTransObjects(FDB, FTran);
    
    OwnerIsDBorTran := Assigned(AOwner) and ((AOwner is TIBDatabase) or (AOwner is TIBTransaction));
    try
      Result := TIBDataSet.Create(AOwner);
    except
      on E: Exception do
      begin
        if OwnerIsDBorTran then
          raise ReCreateEObject(E, 'IBX bug!') // �� ����, ��� ��� ��������� ������...
        else
          raise;
      end;
    end;  
    
    try
      Result.Database := FDB;
      Result.Transaction := FTran;
      Result.ParamCheck := FBDefParamCheck;

      if TranAutoStart then
        if not Result.Transaction.InTransaction then
          Result.Transaction.StartTransaction;    
    except
      Result.Free;
      raise;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrCreateDataSet); // TODO: ������ AModuleName
  end;
end;

function FBCreateAndOpenDataSet(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
  ParamNames: array of string; ParamValues: array of Variant;
  AOwner: TComponent; AModuleName: string): TIBDataSet;
var
  I: Integer;
begin
  try
    Result := FBCreateDataSet(FDB, FTran, True, AOwner, AModuleName);
    try
      if Length(ParamNames) <> Length(ParamValues) then
        raise Exception.Create('Params and values have different size');

      Result.SelectSQL.Text := SQL;

      for I := 0 to High(ParamNames) do
        Result.ParamByName(ParamNames[I]).Value := ParamValues[I];

      Result.Open;
      Result.FetchAll;
    except
      Result.Free;
      raise;
    end;  
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrCreateAndOpenDataSet); // TODO: ������ AModuleName
  end;
end;

function FBCreateAndOpenTable(FDB: TIBDatabase; FTran: TIBTransaction; 
  ATable, AFilter, AOrder: string;
  ParamNames: array of string; ParamValues: array of Variant;
  AOwner: TComponent; AModuleName: string): TIBDataSet;
var
  SQL: string;
begin
  try
    SQL := Format('SELECT * FROM "%s" ', [AnsiUpperCase(ATable)]);
    if AFilter <> '' then
    begin
      if Pos('WHERE', UpperCase(AFilter)) = 0 then
        AFilter := 'WHERE ' + AFilter;
      SQL := SQL + AFilter + ' ';  
    end;
    if AOrder <> '' then
    begin
      if Pos('ORDER BY', UpperCase(AOrder)) = 0 then
        AOrder := 'ORDER BY ' + AOrder; 
      SQL := SQL + AOrder;    
    end;

    Result := FBCreateAndOpenDataSet(FDB, FTran, SQL, ParamNames, ParamValues, AOwner, AModuleName);
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrCreateAndOpenTable); // TODO: ������ AModuleName
  end;  
end;

procedure FBExecQuery(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
  ParamNames: array of string; ParamValues: array of Variant; AModuleName: string);
var
  I: Integer;
  ds: TIBDataSet;
begin

  try
    if Length(ParamNames) <> Length(ParamValues) then
      raise Exception.Create('Params and values have different size');

    ds := FBCreateDataSet(FDB, FTran, True, nil, AModuleName);
    try
      ds.SelectSQL.Text := SQL;

      for I := 0 to High(ParamNames) do
        ds.ParamByName(ParamNames[I]).Value := ParamValues[I];

      ds.ExecSQL;
    finally
      ds.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrExecQuery); // TODO: ������ AModuleName
  end;
end;

procedure FBUpdateRecordBase(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string; KeyValues: array of Variant;
  FieldNames: array of string; AFieldValues: array of Variant; AModuleName: string);
var
  SQL: TStringList;
  SWhere: string;
  I, LastIndex: Integer;
  ds: TIBDataSet;
begin
  try
    SQL := TStringList.Create;
    try
      if Length(FieldNames) <> Length(AFieldValues) then
        raise Exception.Create('Fields and values have different size');
      LastIndex := -1;
      SQL.Add(Format('UPDATE "%s" SET', [UpperCase(TableName)]));
      for I := 0 to High(FieldNames) do
        LastIndex := SQL.Add(Format('  "%s" = :%0:s,',
          [UpperCase(FieldNames[I])]));

      if LastIndex >= 0 then
        SQL[LastIndex] := Copy(SQL[LastIndex], 1, Length(SQL[LastIndex]) - 1);

      if Length(KeyFields) > 0 then
      begin
        for I := 0 to High(KeyFields) do
          SWhere := Format('%s ("%s" = :%1:s) AND', [SWhere, UpperCase(KeyFields[I])]);
        if SWhere <> '' then
        begin
          SetLength(SWhere, Length(SWhere) - 4);
          SQL.Add('WHERE ' + SWhere);
        end;
      end;

      ds := FBCreateDataSet(FDB, FTran, True, nil, AModuleName);
      try
        ds.SelectSQL.Assign(SQL);
        for I := 0 to High(FieldNames) do
          ds.ParamByName(FieldNames[I]).Value := AFieldValues[I];

        for I := 0 to High(KeyFields) do
          ds.ParamByName(KeyFields[I]).Value := KeyValues[I];

        ds.ExecSQL;
      finally
        ds.Free;
      end;
    finally
      SQL.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, Format(FBStrUpdateRec, [TableName]));  // TODO: ������ AModuleName
  end;
end;

procedure FBInsertRecordBase(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; FieldNames: array of string; AFieldValues: array of Variant; AModuleName: string);
var
  I: Integer;
  SQL: TStringList;
  Fields, Params, ErrStr: string;
begin
  try
    SQL := TStringList.Create;
    try
      if Length(FieldNames) <> Length(AFieldValues) then
        raise Exception.Create('Fields and values have different size');
      SQL.Add(Format('INSERT INTO "%s"', [UpperCase(TableName)]));
      for I := 0 to High(FieldNames) do
      begin
        Fields := Format('%s "%s",', [Fields, UpperCase(FieldNames[I])]);
        Params := Format('%s :%s,', [Params, UpperCase(FieldNames[I])]);
      end;
      if Fields <> '' then
        SetLength(Fields, Length(Fields) - 1);
      if Params <> '' then
        SetLength(Params, Length(Params) - 1);
      SQL.Add(Format('(%s)', [Fields]));
      SQL.Add(Format('VALUES (%s)', [Params]));

      with FBCreateDataSet(FDB, FTran, True, nil, AModuleName) do
      try
        SelectSQL.Assign(SQL);
        for I := 0 to High(FieldNames) do
        begin
          ParamByName(FieldNames[I]).Value := AFieldValues[I];
          ErrStr := Format('%s %s=%s;', [ErrStr, FieldNames[I], VarToStr(AFieldValues[I])]);
        end;
        ExecSQL;
      finally
        Free;
      end;
    finally
      SQL.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, Format(FBStrInsertRec, [TableName, ErrStr])); // TODO: ������ AModuleName
  end;
end;

procedure FBUpdateOrInsertRecordBase(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; FieldNames: array of string; AFieldValues: array of Variant; 
  KeyFields: array of string; AModuleName: string);
var
  I: Integer;
  SQL: TStringList;
  Fields, Params, ErrStr, Keys: string;
begin
  try
    SQL := TStringList.Create;
    try
      if Length(FieldNames) <> Length(AFieldValues) then
        raise Exception.Create('Fields and values have different size');
      if Length(KeyFields) = 0 then
        raise Exception.Create('Key fields not presented');
      SQL.Add(Format('UPDATE OR INSERT INTO "%s"', [UpperCase(TableName)]));
      for I := 0 to High(FieldNames) do
      begin
        Fields := Format('%s "%s",', [Fields, UpperCase(FieldNames[I])]);
        Params := Format('%s :%s,', [Params, UpperCase(FieldNames[I])]);
      end;
      if Fields <> '' then
        SetLength(Fields, Length(Fields) - 1);
      if Params <> '' then
        SetLength(Params, Length(Params) - 1);
      SQL.Add(Format('(%s)', [Fields]));
      SQL.Add(Format('VALUES (%s)', [Params]));

       Keys := '';
       for I := 0 to High(KeyFields) do
       begin
         if Keys <> '' then Keys := Keys + ',';
         Keys := Keys + '"' + UpperCase(KeyFields[I]) + '"';
       end;
       SQL.Add('MATCHING (' + Keys + ')');

      with FBCreateDataSet(FDB, FTran, True, nil, AModuleName) do
      try
        SelectSQL.Assign(SQL);
        for I := 0 to High(FieldNames) do
        begin
          ParamByName(FieldNames[I]).Value := AFieldValues[I];
          ErrStr := Format('%s %s=%s;', [ErrStr, FieldNames[I], VarToStr(AFieldValues[I])]);
        end;
        ExecSQL;
      finally
        Free;
      end;
    finally
      SQL.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, Format(FBStrUpdateOrInsertRec, [TableName, ErrStr])); // TODO: ������ AModuleName
  end;
end;

procedure FBDeleteRecordBase(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string; KeyValues: array of Variant; AModuleName: string);
var
  SQL: TStringList;
  SWhere: string;
  I: Integer;
begin
  try
    SQL := TStringList.Create;
    try

      SQL.Add(Format('DELETE FROM "%s"', [UpperCase(TableName)]));

      if Length(KeyFields) > 0 then
      begin
        for I := 0 to High(KeyFields) do
          SWhere := Format('%s ("%s" = :%1:s) AND', [SWhere, UpperCase(KeyFields[I])]);
        if SWhere <> '' then
        begin
          SetLength(SWhere, Length(SWhere) - 4);
          SQL.Add('WHERE ' + SWhere);
        end;
      end;

      with FBCreateDataSet(FDB, FTran, True, nil, AModuleName) do
      try
        SelectSQL.Assign(SQL);

        for I := 0 to High(KeyFields) do
          ParamByName(KeyFields[I]).Value := KeyValues[I];

        ExecSQL;
      finally
        Free;
      end;
    finally
      SQL.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, Format(FBStrDeleteRec, [TableName])); // TODO: ������ AModuleName
  end;
end;

function FBUtilsVersion: Integer;
begin
  Result := 1;
end;

procedure FBSetUserName(AUserName: string);
begin
  FBUserName := AUserName;
end;

function FBGetUserName: string;
begin
  Result := FBUserName;
end;

procedure FBSetPassword(APassword: string);
begin
  FBPassword := APassword;
end;

function FBGetPassword: string;
begin
  Result := FBPassword;
end;

procedure FBRecomputeIndexStatistics(FDB: TIBDatabase; AModuleName: string);
var
  tran: TIBTransaction;
begin
  try
    tran := FBCreateTransaction(FDB, trRCRW, True, nil, AModuleName);
    try
      FBExecuteBlockProc(FDB, tran,
        'vl_index_name varchar(31)',

        '  for select i.rdb$index_name'#13#10+
        '      from rdb$indices i'#13#10+
        '      where (i.rdb$system_flag = 0)'#13#10+
        '  into :vl_index_name'#13#10+
        '  do'#13#10+
        '    execute statement ''set statistics index '' || :vl_index_name;',

        AModuleName);
      tran.Commit;
    finally
      tran.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'FBRecomputeIndexStatistics'); // TODO: ������ AModuleName
  end;
end;

function FBGenID(FDB: TIBDatabase; GeneratorName: string; IncValue: Integer; AModuleName: string): Int64;
var
  ds: TIBDataSet;
  tran: TIBTransaction;
begin
  try
    ds := nil;
    tran := FBCreateTransaction(FDB, trRCRW, True, nil, AModuleName);
    try
      ds := FBCreateAndOpenDataSet(FDB, tran,
         Format('SELECT GEN_ID(%s, %d) AS ID FROM RDB$DATABASE',[GeneratorName, IncValue]),
         [], [], nil, AModuleName);
      Result := Round(ds.Fields[0].AsFloat); // AsInt64 ����������� � Delphi7
    finally
      ds.Free;
      tran.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'FBGenID'); // TODO: ������ AModuleName
  end;
end;

function FBCorrectDeclareVarSection(VarDesc: string): string;
var
  AList: TStringList;
  I: Integer;
begin
  VarDesc := Trim(VarDesc);
  if VarDesc <> '' then
  begin
    AList := TStringList.Create;
    try
      while Pos('  ', VarDesc) > 0 do // ����������� �� ������� ��������
        VarDesc := FastStringReplace(VarDesc, '  ', ' ');
      VarDesc := FastStringReplace(VarDesc, ',', ';');
      AList.Text := FastStringReplace(VarDesc, ';', sLineBreak);
      for I := 0 to AList.Count - 1 do // ��������� DECLARE VARIABLE
        if Pos('DECLARE VARIABLE', UpperCase(AList[I])) = 0 then
          AList[I] := 'DECLARE VARIABLE ' + AList[I];
      VarDesc := FastStringReplace(Trim(AList.Text), sLineBreak, ';');
      if VarDesc[Length(VarDesc)] <> ';' then
        VarDesc := VarDesc + ';';
      if VarDesc <> '' then
        VarDesc := VarDesc + sLineBreak;
    finally
      AList.Free;
    end;      
  end;
  Result := VarDesc;
end;

function FBExecuteBlockFunc(FDB: TIBDataBase; FTran: TIBTransaction; OutFieldsDesc,
  VarDesc, Body: string; AModuleName: string): TIBDataSet;
var
  ds: TIBDataSet;
  PSQL: string;
begin
  Result := nil;
  try
    ds := FBCreateDataSet(FDB, FTran, True, nil, AModuleName);
    try
      // ��������� �������� ����������, �.�. ���������� � PSQL ����������� � �������� ":"
      ds.ParamCheck := False;

      PSQL := 'EXECUTE BLOCK ';

      OutFieldsDesc := Trim(OutFieldsDesc);
      if OutFieldsDesc <> '' then
        PSQL := PSQL + 'RETURNS (' + OutFieldsDesc + ') ';
        
      PSQL := PSQL + 'AS' + sLineBreak + FBCorrectDeclareVarSection(VarDesc);

      if Pos('BEGIN', Trim(UpperCase(Body))) <> 1 then
        Body := 'BEGIN' + sLineBreak + Body + sLineBreak + 'END;';
      
      PSQL := PSQL + Body;

      ds.SelectSQL.Text := PSQL;

      if OutFieldsDesc = '' then
        ds.ExecSQL
      else
      begin
        ds.Open;
        ds.FetchAll;
      end;
    except
      ds.Free;
      raise;
    end;

    if OutFieldsDesc = '' then
      ds.Free
    else
      Result := ds;  
  except
    on E: Exception do
      raise ReCreateEObject(E, 'FBExecuteBlockFunc');
  end;
end;

procedure FBExecuteBlockProc(FDB: TIBDataBase; FTran: TIBTransaction;
  VarDesc, Body: string; AModuleName: string);
begin
  FBExecuteBlockFunc(FDB, FTran, '', VarDesc, Body, AModuleName);
end;

procedure FBClearTable(FDB: TIBDataBase; FTran: TIBTransaction; ATableName, AWhere: string;
  GarbageCollection: Boolean; AModuleName: string);
var
  TranCreated: Boolean;
  SQL: string;
begin
  if FTran = nil then
  begin
    FTran := FBCreateTransaction(FDB, trRCRW, True, nil, AModuleName);
    TranCreated := True;
  end else
    TranCreated := False;

  try
    SQL := 'DELETE FROM "' + UpperCase(ATableName) + '"';
    if AWhere <> '' then
    begin
      if Pos('WHERE', UpperCase(AWhere)) = 0 then
        AWhere := 'WHERE ' + AWhere;
      SQL := SQL + ' ' + AWhere;
    end;
    FBExecQuery(FDB, FTran, SQL, [], [], AModuleName);
    if TranCreated then
    begin
      FTran.Commit;
      if GarbageCollection then
      begin // ��������� ������ ������
        FTran.StartTransaction;
        SQL := 'SELECT COUNT(*) FROM "' + UpperCase(ATableName) + '" ' + AWhere;
        FBCreateAndOpenDataSet(FDB, FTran, SQL, [], [], nil, AModuleName).Free;
      end;
    end;
  finally
    if TranCreated then
      FTran.Free;
  end;
end;

function FBPackagesIsCorrect(IBDBClass: TClass): Boolean;
begin
  Result := IBDBClass = TIBDatabase;
end;

initialization
  FBConnectMutex := CreateMutexShared(GenerateFileMutexName('FBUtilsMutex', ParamStr(0)));

finalization
  CloseHandle(FBConnectMutex);
  FBConnectMutex := 0;

end.
