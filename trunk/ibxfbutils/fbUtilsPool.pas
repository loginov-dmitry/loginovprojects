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
{ ������ fbUtilsPool - �������� ��� ����������� ��� ���������� fbUtils        }
{ (c) 2012 ������� ������� ���������                                          }
{ ��������� ����������: 30.04.2012                                            }
{ �������������� �� D7, D2007, D2010, D-XE2                                   }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

unit fbUtilsPool;

interface

uses
  Windows, SysUtils, Classes, SyncObjs, DateUtils, fbUtilsBase, fbSomeFuncs, IBDatabase, IBCustomDataSet, fbTypes;

type

  TFBConnectionPool = class(TBaseObject)
  private
    DBPoolList: TList; // ��� ����������� � ���� ������
    DBPoolCS: TCriticalSection;
    FProfileList: TStringList; // ������ ������������������ ��������

    procedure ClearPool;

    {������� ������ ��������}
    procedure ClearConnectionProfiles;

    {������� �� ���� ������ �����������}
    procedure DeleteOldConnections;

  public { ����������� � ���������� }

    constructor Create;
    destructor Destroy; override;

  public { ��������� �������� � ����������� ����������� � �� }

    {��������� ����� ������� �����������, �.�. ����� ���������� �������� ����������
     � ������������ ��������� ���. ������ ������:
     AddConnectionProfile(FBDefDB, FBDefServer, FBDefPort, 'C:\DB\MyDB.FDB', FBDefUser, FBDefPassword, FBRusCharSet);
     ������ FBDefDB ����� ��������� ����� ������ ��� �������. }
    procedure AddConnectionProfile(AProfileName: string; AServerName: string; APort: Integer;
      ADataBase: string; AUserName: string; APassword: string; ACharSet: string);

    {�������� ����� AddConnectionProfile � �������� FBDefDB}
    procedure AddDefaultConnectionProfile(AServerName: string; APort: Integer;
      ADataBase: string; AUserName: string; APassword: string; ACharSet: string);

  public { ����������� � �� � ����������. ������ � �����. }

    {���������� �����������, ��������� �������� ����� ���� ��������� � ������� AProfileName. ������:
     FDB := GetConnection('MyDB', ReadTran, WriteTran, trRCRO, trRCRW) }
    function GetConnection(AProfileName: string; ReadTran, WriteTran: PIBTransaction;
      ReadTranType, WriteTranType: TTransactionType): TIBDatabase; overload;

    {���������� ����������� � ������������ � ��������� �����������. ������:
     FDB := GetConnection(FBDefServer, FBDefPort, 'C:\DB\MyDB.FDB', FBDefUser, FBDefPassword,
       FBRusCharSet, ReadTran, WriteTran, trRCRO, trRCRW)}
    function GetConnection(AServerName: string; APort: Integer; ADataBase: string;
      AUserName: string; APassword: string; ACharSet: string; ReadTran, WriteTran: PIBTransaction;
      ReadTranType, WriteTranType: TTransactionType): TIBDatabase; overload;

    { ���������� ����������� ��� ���� ������, ��� ������� ��� �������� ������� FBDefDB
      ������������ ���� ����������: trRCRO � trRCRW }
    function GetDefaultConnection(ReadTran, WriteTran: PIBTransaction; ReadTranType, WriteTranType: TTransactionType): TIBDatabase;

    { ������ ����������� ������� � ��� }
    procedure ReturnConnection(FDB: TIBDatabase);

    { ���������� ���������� ����������� � ���� }
    function GetPoolSize: Integer;
  end;

procedure FBPoolAddConnectionProfile(AProfileName: string; AServerName: string; APort: Integer;
  ADataBase: string; AUserName: string; APassword: string; ACharSet: string; AModuleName: string);

procedure FBPoolAddDefaultConnectionProfile(AServerName: string; APort: Integer;
  ADataBase: string; AUserName: string; APassword: string; ACharSet: string; AModuleName: string);

function FBPoolGetConnectionByProfile(AProfileName: string; ReadTran, WriteTran: PIBTransaction;
  ReadTranType, WriteTranType: TTransactionType; AModuleName: string): TIBDatabase;

function FBPoolGetConnectionByParams(AServerName: string; APort: Integer; ADataBase: string;
  AUserName: string; APassword: string; ACharSet: string; ReadTran, WriteTran: PIBTransaction;
  ReadTranType, WriteTranType: TTransactionType; AModuleName: string): TIBDatabase;

function FBPoolGetDefaultConnection(ReadTran, WriteTran: PIBTransaction;
  ReadTranType, WriteTranType: TTransactionType; AModuleName: string): TIBDatabase;

procedure FBPoolReturnConnection(FDB: TIBDatabase; AModuleName: string);

function FBPoolGetSize: Integer;

{$IFDEF FBUTILSDLL} // ��������� �� ��������� �������� � ������ fbUtilsBase.pas
exports
  FBPoolAddConnectionProfile name 'ibxFBPoolAddConnectionProfile',
  FBPoolAddDefaultConnectionProfile name 'ibxFBPoolAddDefaultConnectionProfile',
  FBPoolGetConnectionByProfile name 'ibxFBPoolGetConnectionByProfile',
  FBPoolGetConnectionByParams name 'ibxFBPoolGetConnectionByParams',
  FBPoolGetDefaultConnection name 'ibxFBPoolGetDefaultConnection',
  FBPoolReturnConnection name 'ibxFBPoolReturnConnection',
  FBPoolGetSize name 'ibxFBPoolGetSize';
{$ENDIF}

resourcestring
  FBStrProfileNotFound = '������� "%s" � ����������� ����������� � �� �� ������';
  FBStrPoolGetConnection = '�������� ����������� �� ����';
  FBStrPoolReturnConnection = '������� ����������� ������� � ���';
implementation

var
  {��� �����������. ��������� � ������ initialization}
  FBPool: TFBConnectionPool;

procedure FBPoolAddConnectionProfile(AProfileName: string; AServerName: string; APort: Integer;
      ADataBase: string; AUserName: string; APassword: string; ACharSet: string; AModuleName: string);
begin
  FBPool.AddConnectionProfile(AProfileName, AServerName, APort, ADataBase, AUserName, APassword, ACharSet);
end;

procedure FBPoolAddDefaultConnectionProfile(AServerName: string; APort: Integer;
  ADataBase: string; AUserName: string; APassword: string; ACharSet: string; AModuleName: string);
begin
  FBPool.AddDefaultConnectionProfile(AServerName, APort, ADataBase, AUserName, APassword, ACharSet);
end;

function FBPoolGetConnectionByProfile(AProfileName: string; ReadTran, WriteTran: PIBTransaction;
  ReadTranType, WriteTranType: TTransactionType; AModuleName: string): TIBDatabase; overload;
begin
  Result := FBPool.GetConnection(AProfileName, ReadTran, WriteTran, ReadTranType, WriteTranType);
end;

function FBPoolGetConnectionByParams(AServerName: string; APort: Integer; ADataBase: string;
  AUserName: string; APassword: string; ACharSet: string; ReadTran, WriteTran: PIBTransaction;
  ReadTranType, WriteTranType: TTransactionType; AModuleName: string): TIBDatabase;
begin
  Result := FBPool.GetConnection(AServerName, APort, ADataBase, AUserName, APassword,
    ACharSet, ReadTran, WriteTran, ReadTranType, WriteTranType);
end;

function FBPoolGetDefaultConnection(ReadTran, WriteTran: PIBTransaction;
  ReadTranType, WriteTranType: TTransactionType; AModuleName: string): TIBDatabase;
begin
  Result := FBPool.GetDefaultConnection(ReadTran, WriteTran, ReadTranType, WriteTranType);
end;

procedure FBPoolReturnConnection(FDB: TIBDatabase; AModuleName: string);
begin
  FBPool.ReturnConnection(FDB);
end;

function FBPoolGetSize: Integer;
begin
  Result := FBPool.GetPoolSize;
end;

type

{ TFBConnectionPool }

  {�������, �������� ��������� ����������� � ���� ������}
  TConnectionProfile = class
    cpServerName: string; // ��� �������, �� ������� �������� ���� Firebird (��� ��� IP-�����)
    cpPort: Integer;      // ����, �� ������� ��������� ���� Firebird. �� ��������� = 3050
    cpDataBase: string;   // ������ ��� ����� �� (������������ ���������� ����������) ��� ��� �����
    cpUserName: string;   // ��� ������������ ��� ����������� � ��. �� ��������� =  SYSDBA
    cpPassword: string;   // ������ ��� ����������� � ��. �� ��������� =  masterkey
    cpCharSet: string;    // ������� ��������, ������������ ��� ����������� � ��.
                          // ������������� ��������� �� �� ����� ��������, � �������
                          // ������� ���� ������� ���� ������. ������: WIN1251
  end;

  TDBPool = class
    dpConnProfile: TConnectionProfile; // ������������ �������
    dpUsed: Boolean;                   // ����������� ������������
    dpCloseTime: TDateTime;            // ������ �������, � �������� ����� �� ���������� ������ �����������
    dpConnect: TIBDatabase;            // ���� ����������� � ���� ������
    dpReadTran: TIBTransaction;        // ���������� ��� ������
    dpWriteTran: TIBTransaction;       // ���������� ��� ������ (� ������)
  end;

function TFBConnectionPool.GetConnection(AProfileName: string; ReadTran, WriteTran: PIBTransaction;
  ReadTranType, WriteTranType: TTransactionType): TIBDatabase;
var
  pPool: TDBPool;
  cp: TConnectionProfile;
  I, Idx: Integer;
begin
  Result := nil;
  pPool := nil;

  if WriteTran = nil then
    WriteTranType := trNone;

  if WriteTranType <> trNone then
    if ReadTran = nil then
      ReadTranType := trNone;

  try
    DeleteOldConnections; // ������� ������ �����������

    DBPoolCS.Enter; // � ������ ����. ������ ������ ����������� ������ ����� ������� ��������
    try
      // ���������� ��������� ����������� ��� ��������� �������
      Idx := FProfileList.IndexOf(AProfileName);
      if Idx < 0 then
        raise Exception.CreateFmt(FBStrProfileNotFound, [AProfileName]);
      cp := TConnectionProfile(FProfileList.Objects[Idx]);

      // ������� ����� ������� ����������� � ����
      for I := 0 to DBPoolList.Count - 1 do
      begin
        pPool := TDBPool(DBPoolList[I]);

        // ���� � ���� ������ �������������� �������...
        if (pPool.dpConnProfile = cp) and (not pPool.dpUsed) then
        begin
          Result := pPool.dpConnect;
          pPool.dpUsed := True;    // ������ �������, ��� ������ ������������
          pPool.dpCloseTime := 0;
          Break;
        end;
      end; // for I

      if Result = nil then // ����������� � ���� �� ���� �������.
      begin
        // ������� ����� �����������
        Result := FBCreateConnection(cp.cpServerName, cp.cpPort, cp.cpDataBase,
          cp.cpUserName, cp.cpPassword, cp.cpCharSet, trNone, False, nil, '');

        // ��������� ������ � ��� �����������
        pPool := TDBPool.Create;
        DBPoolList.Add(pPool);
        pPool.dpConnProfile := cp;
        pPool.dpUsed := True;      // ������ �������, ��� ������ ������������
        pPool.dpCloseTime := 0;
        pPool.dpConnect := Result;
      end;
    finally
      DBPoolCS.Leave;
    end;

    // ��������� ����������� � ���� ������
    if Assigned(Result) then
    begin
      if not Result.TestConnected then // ���� ����������� � �� �� �����������
      begin
        Result.Connected := False; // �� ������ ������
        try
          FBConnectDB(Result, ''); // ��������� ����������� � ��
        except
          pPool.dpCloseTime := Now - OneHour;
          pPool.dpUsed := False;    // ���������� �������, ��� ������ ������������
          raise;
        end;
      end;

      if ReadTranType > trNone then // ������� ���������� ��� ������
      begin
        pPool.dpReadTran := FBCreateTransaction(Result, ReadTranType, False, Result, '');
        Result.DefaultTransaction := pPool.dpReadTran;
      end;

      if WriteTranType > trNone then // ������� ���������� ��� ������
      begin
        pPool.dpWriteTran := FBCreateTransaction(Result, WriteTranType, False, Result, '');
        if Result.DefaultTransaction = nil then
          Result.DefaultTransaction := pPool.dpWriteTran;
      end;

      // ���� ���������� �� �������, �� ��������� ��
      if Assigned(Result.DefaultTransaction) then
        if not Result.DefaultTransaction.InTransaction then
          Result.DefaultTransaction.StartTransaction;

      if Assigned(ReadTran) then
        ReadTran^ := pPool.dpReadTran;
      if Assigned(WriteTran) then
        WriteTran^ := pPool.dpWriteTran;
    end else
      raise Exception.Create('Result=nil');

  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrPoolGetConnection);
  end;
end;

function TFBConnectionPool.GetConnection(AServerName: string; APort: Integer;
  ADataBase, AUserName, APassword, ACharSet: string; ReadTran,
  WriteTran: PIBTransaction; ReadTranType,
  WriteTranType: TTransactionType): TIBDatabase;
var
  AProfileName: string; // ��� �������
begin
  // ���������� ��� �������
  AProfileName := Format('%s_%d_%s_%s_%s', [AServerName, APort, ADataBase, AUserName, ACharSet]);
  // ������������ ����� �������
  AddConnectionProfile(AProfileName, AServerName, APort, ADataBase, AUserName, APassword, ACharSet);
  // ������������ � ��
  Result := GetConnection(AProfileName, ReadTran, WriteTran, ReadTranType, WriteTranType);
end;

function TFBConnectionPool.GetDefaultConnection(ReadTran,
  WriteTran: PIBTransaction; ReadTranType, WriteTranType: TTransactionType): TIBDatabase;
begin
  try
    Result := GetConnection(FBDefDB, ReadTran, WriteTran, ReadTranType, WriteTranType);
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TFBConnectionPool.GetDefaultConnection');
  end;
end;

function TFBConnectionPool.GetPoolSize: Integer;
begin
  DBPoolCS.Enter;
  try
    Result := DBPoolList.Count;
  finally
    DBPoolCS.Leave;
  end;
end;

procedure PoolFreeTransactions(pPool: TDBPool);
var
  DefTran: TIBTransaction;
begin
  DefTran := pPool.dpConnect.DefaultTransaction;
  if Assigned(DefTran) then
  begin
    if (DefTran = pPool.dpReadTran) or (DefTran = pPool.dpWriteTran) then
      pPool.dpConnect.DefaultTransaction := nil
    else
    begin
      if DefTran.InTransaction then
        DefTran.Rollback;
    end;
  end;

  if Assigned(pPool.dpReadTran) then
  begin
    pPool.dpReadTran.Free;
    pPool.dpReadTran := nil;
  end;

  if Assigned(pPool.dpWriteTran) then
  begin
    pPool.dpWriteTran.Free;
    pPool.dpWriteTran := nil;
  end;
end;

procedure TFBConnectionPool.ReturnConnection(FDB: TIBDatabase);
var
  pPool: TDBPool;
  I: Integer;
begin
  try
    DBPoolCS.Enter;
    try
      for I := 0 to DBPoolList.Count - 1 do
      begin
        pPool := TDBPool(DBPoolList[I]);
        if pPool.dpConnect = FDB then
        begin
          pPool.dpUsed := False;
          pPool.dpCloseTime := Now;
          pPool.dpConnect.CloseDataSets; // ��������� ��� �������� ������ ������
          PoolFreeTransactions(pPool); // ��������� ����������
          Break;
        end;
      end;
    finally
      DBPoolCS.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, FBStrPoolReturnConnection);
  end;
end;

// ������������ ������� ���� ����������
procedure TFBConnectionPool.AddConnectionProfile(AProfileName,
  AServerName: string; APort: Integer; ADataBase, AUserName, APassword,
  ACharSet: string);
var
  cp: TConnectionProfile;
  Idx: Integer;
begin
  if AProfileName = '' then
    raise Exception.Create('AddConnectionProfile -> Profile name not found');
  if ADataBase = '' then
    raise Exception.Create('AddConnectionProfile -> Database name not found');

  DBPoolCS.Enter;
  try
    Idx := FProfileList.IndexOf(AProfileName);
    if Idx >= 0 then
      cp := TConnectionProfile(FProfileList.Objects[Idx])
    else
    begin
      cp := TConnectionProfile.Create;
      FProfileList.AddObject(AProfileName, cp);
    end;
    cp.cpServerName := AServerName;
    cp.cpPort := APort;
    cp.cpDataBase := ADataBase;
    cp.cpUserName := AUserName;
    cp.cpPassword := APassword;
    cp.cpCharSet := ACharSet;
  finally
    DBPoolCS.Leave;
  end;
end;

procedure TFBConnectionPool.AddDefaultConnectionProfile(AServerName: string;
  APort: Integer; ADataBase, AUserName, APassword, ACharSet: string);
begin
  AddConnectionProfile(FBDefDB, AServerName, APort, ADataBase, AUserName, APassword, ACharSet);
end;

procedure TFBConnectionPool.ClearConnectionProfiles;
var
  I: Integer;
begin
  try
    DBPoolCS.Enter;
    try
      for I := 0 to FProfileList.Count - 1 do
        FProfileList.Objects[I].Free;

      FProfileList.Clear;
    finally
      DBPoolCS.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ClearConnectionProfiles');
  end;
end;

procedure TFBConnectionPool.ClearPool();
var
  pPool: TDBPool;
  I: Integer;
  FDB: TIBDatabase;
begin
  try
    if GetModuleHandle('GDS32.dll') = 0 then
      raise Exception.Create('GetModuleHandle(GDS32.dll)=NULL');

    DBPoolCS.Enter;
    try
      for I := 0 to DBPoolList.Count - 1 do
      begin
        pPool := TDBPool(DBPoolList[I]);
        PoolFreeTransactions(pPool);
        FDB := pPool.dpConnect;
        pPool.Free;
        FBFreeConnection(FDB, '');
      end;
      DBPoolList.Clear;
    finally
      DBPoolCS.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ClearPool');
  end;
end;

constructor TFBConnectionPool.Create;
begin
  inherited Create;

  RegObj(DBPoolList, TList.Create);
  RegObj(DBPoolCS, TCriticalSection.Create);
  FProfileList := CreateStringList;
end;

procedure TFBConnectionPool.DeleteOldConnections;
var
  pPool: TDBPool;
  I: Integer;
  AList: TList;
begin
  try
    AList := TList.Create;
    try
      DBPoolCS.Enter;
      try
        // ��������� ��� �������������� �����������, ������� ����� 5 �����
        for I := DBPoolList.Count - 1 downto 0 do
        begin
          pPool := TDBPool(DBPoolList[I]);
          if not pPool.dpUsed then
            if SecondsBetween(Now, pPool.dpCloseTime) > FBPoolConnectionMaxTime then
            begin
              DBPoolList.Delete(I);
              AList.Add(pPool.dpConnect);

              // ��������� ����������. �� �� ����� ������ �����������, �����
              // ������ �� ���������
              PoolFreeTransactions(pPool);
              pPool.Free;
            end;
        end;

      finally
        DBPoolCS.Leave;
      end;

      // ������� �������� �������� ����������� �� ������� ����������� ������
      for I := 0 to AList.Count - 1 do
      try
        FBFreeConnection(TIBDatabase(AList[I]), '');
      except
        //raise; // �� �������! ��������, ���� ����� ������������� ������ ���������� ��� ������
      end;
    finally
      AList.Free;
    end;

  except
    on E: Exception do
      raise ReCreateEObject(E, 'TFBConnectionPool.DeleteOldConnections');
  end;
end;

destructor TFBConnectionPool.Destroy;
begin
  ClearPool(); // ������� ��� ����������
  ClearConnectionProfiles(); // ������� ������ ��������
  // �������, ��������� � ������������ � ������������������ � ������� RegObj,
  // ����� ������� �������������
  inherited;
end;

initialization
  FBPool := TFBConnectionPool.Create;
finalization
  //MessageBox(0, 'POOL finalization - BEGIN', '', 0);
  FBPool.Free;
  //MessageBox(0, 'POOL finalization - END', '', 0);
end.
