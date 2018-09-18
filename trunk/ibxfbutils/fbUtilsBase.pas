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
  Windows, SysUtils, Classes, IB, IBDatabase, IBCustomDataSet, Variants, fbTypes, fbSomeFuncs,
  IniFiles, StrUtils;

type
  TFBDatasetList = class(TComponent)
  private
    FList: THashedStringList; // ������ ���������
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

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

{������� ����� ������ TIBDataSet � ������������� ��������� �������� ������. ������:
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

{���������� ����� ������ TIBDataSet �� SQL-�������. ���� ������ TIBDataSet �� ��� ������,
 �� ������ ���. ������� TIBDataSet ����� ���������� ������������� ��� �������� ����������, �.�.
 ������� ������ TIBDataSet �� �����������! }
function FBGetDataSet(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string; AModuleName: string): TIBDataSet;

{ �������� ����� ������ (� ������� ������� FBGetDataSet), ���������� ��������� � ��������� ������ }
function FBGetAndOpenDataSet(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
  ParamNames: array of string; ParamValues: array of Variant; AModuleName: string): TIBDataSet;

{��������� ��������� SQL-������.
 ��������! ���������� �� �����������!}
procedure FBExecQuery(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
  ParamNames: array of string; ParamValues: array of Variant; AModuleName: string);

{ ���������� ������ �������� �������� ����� ��������� ������� ��� ������ ��������� ������ }
function FBGetTableFieldValues(FDB: TIBDataBase; FTran: TIBTransaction; TableName: string; FieldNames: array of string;
  KeyFields: array of string; KeyValues: array of Variant; DefValues: array of Variant; AModuleName: string): OleVariant;

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

function FBGenIDEx(FDB: TIBDatabase; TranW: TIBTransaction; GeneratorName: string; IncValue: Integer; AModuleName: string): Int64;

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
  FBGetTableFieldValues name 'ibxFBGetTableFieldValues',
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
  FBGenIDEx name 'ibxFBGenIDEx',
  FBExecuteBlockFunc name 'ibxFBExecuteBlockFunc',
  FBExecuteBlockProc name 'ibxFBExecuteBlockProc',
  FBClearTable name 'ibxFBClearTable',
  FBGetDataSet name 'ibxFBGetDataSet',
  FBGetAndOpenDataSet name 'ibxFBGetAndOpenDataSet';
{$ENDIF}

resourcestring
  FBStrCreateConnection = '�������� ����������� � ���� ������';
  FBStrConnectToDB = '����������� � ���� ������';
  FBStrDisconnectDB = '���������� �� ���� ������';
  FBStrFreeConnection = '�������� ����������� � ���� ������';
  FBStrCreateTransaction = '�������� ����������';
  FBStrCreateDataSet = '�������� ������ ������';
  FBStrGetDataSet = '��������� ������ ������';
  FBStrCreateAndOpenDataSet = '�������� � �������� ������ ������';
  FBStrGetAndOpenDataSet = '��������� � �������� ������ ������';
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
  if APort = 0 then
    Result := ADBName
  else
  begin
    Result := AServerName;
    if (Result <> '') and (APort > 0) then
      Result := Result +  '/' + IntToStr(APort);
    if Result <> '' then
      Result := Result + ':';
    Result := Result + ADBName;
  end;
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
    if FDB = nil then
      raise Exception.Create('FBDisconnectDB -> FDB = nil');
    if not (FDB is TIBDatabase) then
      raise Exception.Create('FBDisconnectDB -> FDB is not TIBDatabase');

    if WaitForSingleObject(FBConnectMutex, INFINITE) = WAIT_OBJECT_0 then
    try
      try
        FDB.Connected := False;
      except
        // �� ������� ����������� ����������, �.�. ������ � �� ���������.
        // ��-����� �� �� ������ ���������� ����� ����������!
      end;
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

function FBGetDataSet(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string; AModuleName: string): TIBDataSet;
var
  I, Idx: Integer;
  DSList: TFBDatasetList;
  ds: TIBDataSet;
begin
  try
    FBCheckDBAndTransObjects(FDB, FTran);
    if FTran = nil then
      raise Exception.Create('transaction is not assigned');
    if SQL = '' then
      raise Exception.Create('SQL is empty');

    // ���� � ������ �������� �������� ���������� ������ TFBDatasetList
    DSList := nil;
    for I := 0 to FTran.ComponentCount - 1 do
      if FTran.Components[I] is TFBDatasetList then
      begin
        DSList := FTran.Components[I] as TFBDatasetList;
        Break;
      end;
    if DSList = nil then
      DSList := TFBDatasetList.Create(FTran);

    // �������� ����� ������� �� SQL-�������
    Idx := DSList.FList.IndexOf(SQL);
    if Idx = -1 then
    begin
      ds := FBCreateDataSet(FDB, FTran, True, DSList, AModuleName);
      ds.SelectSQL.Text := SQL;
      Idx := DSList.FList.AddObject(SQL, ds);
    end;

    Result := DSList.FList.Objects[Idx] as TIBDataSet;
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrGetDataSet);
  end;
end;

function FBGetAndOpenDataSet(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
  ParamNames: array of string; ParamValues: array of Variant; AModuleName: string): TIBDataSet;
var
  I: Integer;
begin
  try
    if Length(ParamNames) <> Length(ParamValues) then
      raise Exception.Create('Params and values have different size');
      
    Result := FBGetDataSet(FDB, FTran, SQL, AModuleName);
    Result.Active := False;
    for I := 0 to High(ParamNames) do
      if VarIsNull(ParamValues[I]) then
        Result.ParamByName(ParamNames[I]).Clear
      else
        Result.ParamByName(ParamNames[I]).Value := ParamValues[I];

    Result.Open;
    Result.FetchAll;
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrGetAndOpenDataSet);
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
        if VarIsNull(ParamValues[I]) then
          Result.ParamByName(ParamNames[I]).Clear
        else
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
        if VarIsNull(ParamValues[I]) then
          ds.ParamByName(ParamNames[I]).Clear
        else
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

function FBGetTableFieldValues(FDB: TIBDataBase; FTran: TIBTransaction; TableName: string; FieldNames: array of string;
  KeyFields: array of string; KeyValues: array of Variant; DefValues: array of Variant; AModuleName: string): OleVariant;
var
  ds: TIBDataSet;
  SQL: TStringList;
  DenyQuote: Boolean;
  SWhere, sFields, s, sf: string;
  I: Integer;
begin
  try
    if Length(KeyFields) <> Length(KeyValues) then
      raise Exception.Create('Key fields and key values arrays have different size');

    if Length(FieldNames) = 0 then
      raise Exception.Create('FieldNames array is empty');

    SQL := TStringList.Create;
    try
      for I := 0 to High(FieldNames) do
      begin
        if sFields <> '' then
          sFields := sFields + ', ';

        DenyQuote := (Pos(' AS ', UpperCase(FieldNames[I])) > 0) or (Pos('(', FieldNames[I]) > 0);
        s  := IfThen(DenyQuote, '', '"');
        sf := IfThen(DenyQuote, FieldNames[I], UpperCase(FieldNames[I]));
        sFields := sFields + s + sf + s;
      end;

      SQL.Add(Format('SELECT FIRST 1 %s FROM "%s"', [sFields, UpperCase(TableName)]));
      for I := 0 to High(KeyFields) do
        SWhere := Format('%s ("%s" = :%1:s) AND', [SWhere, UpperCase(KeyFields[I])]);
      if SWhere <> '' then
      begin
        SetLength(SWhere, Length(SWhere) - 4);
        SQL.Add('WHERE ' + SWhere);
      end;

      ds := FBGetAndOpenDataSet(FDB, FTran, SQL.Text, KeyFields, KeyValues, AModuleName);
      try
        Result := VarArrayCreate([0, ds.Fields.Count - 1], varVariant);
        for I := 0 to ds.Fields.Count - 1 do
        begin
          if ds.Fields[I].IsNull then
          begin
            if Length(DefValues) > I then
              Result[I] := DefValues[I]
            else
              Result[I] := Null;
          end else
          begin
            Result[I] := ds.Fields[I].Value;
          end;
        end;
      finally
        ds.Close;
      end;

    finally
      //ds.Free;
      SQL.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'FBGetTableFieldValue')
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
          SWhere := Format('%s ("%s" = :FBPARAM_%1:s) AND', [SWhere, UpperCase(KeyFields[I])]);
        if SWhere <> '' then
        begin
          SetLength(SWhere, Length(SWhere) - 4);
          SQL.Add('WHERE ' + SWhere);
        end;
      end;

      ds := FBGetDataSet(FDB, FTran, SQL.Text, AModuleName);

      for I := 0 to High(FieldNames) do
        if VarIsNull(AFieldValues[I]) then
          ds.ParamByName(FieldNames[I]).Clear
        else
          ds.ParamByName(FieldNames[I]).Value := AFieldValues[I];

      for I := 0 to High(KeyFields) do
        if VarIsNull(KeyValues[I]) then
          ds.ParamByName('FBPARAM_' + KeyFields[I]).Clear
        else
          ds.ParamByName('FBPARAM_' + KeyFields[I]).Value := KeyValues[I];

      ds.ExecSQL;
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
  ds: TIBDataSet;
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

      ds := FBGetDataSet(FDB, FTran, SQL.Text, AModuleName);
      for I := 0 to High(FieldNames) do
      begin
        if VarIsNull(AFieldValues[I]) then
          ds.ParamByName(FieldNames[I]).Clear
        else
          ds.ParamByName(FieldNames[I]).Value := AFieldValues[I];

        ErrStr := Format('%s %s=%s;', [ErrStr, FieldNames[I], VarToStr(AFieldValues[I])]);
      end;
      ds.ExecSQL;
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
  ds: TIBDataSet;
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

      ds := FBGetDataSet(FDB, FTran, SQL.Text, AModuleName);
      for I := 0 to High(FieldNames) do
      begin
        if VarIsNull(AFieldValues[I]) then
          ds.ParamByName(FieldNames[I]).Clear
        else
          ds.ParamByName(FieldNames[I]).Value := AFieldValues[I];

        ErrStr := Format('%s %s=%s;', [ErrStr, FieldNames[I], VarToStr(AFieldValues[I])]);
      end;
      ds.ExecSQL;

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
  ds: TIBDataSet;
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

      ds := FBGetDataSet(FDB, FTran, SQL.Text, AModuleName);
      for I := 0 to High(KeyFields) do
        if VarIsNull(KeyValues[I]) then
          ds.ParamByName(KeyFields[I]).Clear
        else
          ds.ParamByName(KeyFields[I]).Value := KeyValues[I];
      ds.ExecSQL;

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
  Result := 4;
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

function FBGenIDEx(FDB: TIBDatabase; TranW: TIBTransaction; GeneratorName: string; IncValue: Integer; AModuleName: string): Int64;
var
  TranExists: Boolean;
  ds: TIBDataSet;
  sql: string;
begin
  TranExists := Assigned(TranW);
  if not TranExists then
    TranW := FBCreateTransaction(FDB, trRCRW, True, nil, AModuleName);
  try
    sql := Format('SELECT GEN_ID(%s, CAST(:v AS INTEGER)) AS ID FROM RDB$DATABASE', [GeneratorName]);
    ds := FBGetAndOpenDataSet(FDB, TranW, sql, ['v'], [IncValue], AModuleName);
    Result := Round(ds.Fields[0].AsFloat); // AsInt64 ����������� � Delphi7
    ds.Close;
  finally
    if not TranExists then   
      TranW.Free;
  end;  
end;

function FBGenID(FDB: TIBDatabase; GeneratorName: string; IncValue: Integer; AModuleName: string): Int64;
begin
  Result := FBGenIDEx(FDB, nil, GeneratorName, IncValue, AModuleName);
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

{ TFBDatasetList }

constructor TFBDatasetList.Create(AOwner: TComponent);
begin
  inherited;
  FList := THashedStringList.Create;
end;

destructor TFBDatasetList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TFBDatasetList.Notification(AComponent: TComponent; Operation: TOperation);
var
  Idx: Integer;
begin
  inherited;
  if Assigned(FList) and (Operation = opRemove) then
  begin
    Idx := FList.IndexOfObject(AComponent);
    if Idx >= 0 then
      FList.Delete(Idx);
  end;
end;

initialization
  FBConnectMutex := CreateMutexShared(GenerateFileMutexName('FBUtilsMutex', ParamStr(0)));

finalization
  CloseHandle(FBConnectMutex);
  FBConnectMutex := 0;

end.
