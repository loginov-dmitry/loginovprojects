{
Copyright (c) 2011, Loginov Dmitry Sergeevich
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

unit FBUtilsUnit;

interface
uses
  SysUtils, Classes, SyncObjs, IBDatabase, IBCustomDataSet, DB;

type
  // Параметры транзакции
  TTranParam = (
    tpReadCommitedReadWrite, // видит подтвержд. изменения. Чтение и запись. Приводит к созданию версий
    tpReadCommitedReadOnly, // видит подтвержд. изменения. Только чтение. Не приводит к созданию версий
    tpSnapShotReadWrite, // видит все подтв. изм. на момент своего старта. Видим собственные изменения. Для чтения/записи
    tpNone3, tpNone4, tpNone5);



function FBCreateIBDataBase(ConnStr: string; AUser, APassw, ARole, ACharSet,
  AName: string; CreateTrans: Boolean): TIBDataBase;

procedure FBConnectDB(IBDB: TIBDataBase; UseCS: Boolean = True);

procedure FBDisconnectDB(IBDB: TIBDataBase; UseCS: Boolean = True);

procedure FBFreeIBDataBase(IBDB: TIBDatabase);

function FBCreateTransaction(DefaultDB: TIBDatabase = nil;
  TranParam: TTranParam = tpReadCommitedReadWrite;
  AOwner: TComponent = nil): TIBTransaction;

function FBCreateDataSetForRead(FDB: TIBDatabase;
  AutoStartTransaction: Boolean; ATransaction: TIBTransaction; AName: string): TIBDataSet;

function ReCreateEObject(E: Exception; FuncName: string;
  WriteExceptClass: Boolean = True): Exception;

implementation

var
  ConnCS: TCriticalSection;

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
  Result := ExceptClass(E.ClassType).Create(S);
end;

function FBCreateTransaction(DefaultDB: TIBDatabase = nil;
  TranParam: TTranParam = tpReadCommitedReadWrite;
  AOwner: TComponent = nil): TIBTransaction;
begin
  try
    Result := TIBTransaction.Create(AOwner);
    try
      Result.DefaultDatabase := DefaultDB;
      Result.DefaultAction := TARollback;

      case TranParam of
        tpReadCommitedReadWrite:
          Result.Params.Text := 'read_committed'#13#10'rec_version'#13#10'nowait';

        tpReadCommitedReadOnly:
          Result.Params.Text := 'read_committed'#13#10'rec_version'#13#10'nowait'#13#10'read';

        tpSnapShotReadWrite:
          Result.Params.Text := 'concurrency'#13#10'nowait';
      else
        raise Exception.Create('Заданный тип транзакции не поддерживается!');
      end;

    except
      Result.Free;
      raise;
    end;

  except
    on E: Exception do
      raise ReCreateEObject(E, 'CREATE TRANSACTION')
  end;
end;

function FBCreateIBDataBase(ConnStr: string; AUser, APassw, ARole, ACharSet,
  AName: string; CreateTrans: Boolean): TIBDataBase;
begin
  Result := TIBDatabase.Create(nil);
  try
    if AName <> '' then
      Result.Name := AName;
    Result.DatabaseName := ConnStr;
    Result.Params.Values['user_name'] := AUser;
    Result.Params.Values['password'] := APassw;
    if ARole <> '' then
      Result.Params.Values['sql_role_name'] := ARole;
    if ACharSet <> '' then
      Result.Params.Values['lc_ctype'] := ACharSet;

    Result.LoginPrompt := False;

    if CreateTrans then
      Result.DefaultTransaction := FBCreateTransaction(Result, tpReadCommitedReadWrite, Result);

  except
    on E: Exception do
    begin
      Result.Free;
      raise ReCreateEObject(E, 'CREATE CONNECTION')
    end;
  end;
end;

procedure FBConnectDB(IBDB: TIBDataBase; UseCS: Boolean = True);
begin
  if UseCS then ConnCS.Enter;
  try
    try
      IBDB.Connected := True;
    except
      on E: Exception do
        raise ReCreateEObject(E, 'DB CONNECT (' + IBDB.DatabaseName + ')');
    end;
  finally
    if UseCS then ConnCS.Leave;
  end;
end;

procedure FBDisconnectDB(IBDB: TIBDataBase; UseCS: Boolean = True);
begin
  if UseCS then ConnCS.Enter;
  try
    try
      IBDB.Connected := False;
    except
      on E: Exception do
        raise ReCreateEObject(E, 'DB DISCONNECT (' + IBDB.DatabaseName + ')');
    end;
  finally
    if UseCS then ConnCS.Leave;
  end;
end;

procedure FBFreeIBDataBase(IBDB: TIBDatabase);
begin
  try
    if Assigned(IBDB) then
    try
      if IBDB.Connected then
        FBDisconnectDB(IBDB);
    finally
      IBDB.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'FREE CONNECTION');
  end;
end;

function FBCreateDataSetForRead(FDB: TIBDatabase;
  AutoStartTransaction: Boolean; ATransaction: TIBTransaction; AName: string): TIBDataSet;
begin
  Result := TIBDataSet.Create(nil);
  try
    if AName <> '' then
      Result.Name := AName;

    Result.Database := FDB;

    if ATransaction = nil then
    begin
      // Если не установлена транзакция по умолчанию, либо транзакция по умолчанию
      // разрешает и чтение и запись, то создаем отдельную транзакцию
      if (Result.Transaction = nil) or (Result.Transaction.Params.IndexOf('read') < 0) then
        Result.Transaction := FBCreateTransaction(FDB, tpReadCommitedReadOnly, Result);
    end else
      Result.Transaction := ATransaction;

    if AutoStartTransaction then
      if not Result.Transaction.InTransaction then
        Result.Transaction.StartTransaction;
  except
    on E: Exception do
    begin
      Result.Free;
      raise ReCreateEObject(E, 'CREATE TABLE RO');
    end;
  end;
end;

initialization
  ConnCS := TCriticalSection.Create;
finalization
  ConnCS.Free;
end.
