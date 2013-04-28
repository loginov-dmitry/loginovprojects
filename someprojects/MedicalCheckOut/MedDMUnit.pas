{
Copyright (c) 2012, Loginov Dmitry Sergeevich
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

unit MedDMUnit;

interface

uses
  Windows, SysUtils, Classes, AppEvnts, Forms, LDSLogger, ibxFBUtils, IBDatabase,
  DB, IBCustomDataSet, Dialogs;

type
  TMedDataModule = class(TDataModule)
    ApplicationEvents1: TApplicationEvents;
    FMedDB: TIBDatabase;
    FTranR: TIBTransaction;
    FTranW: TIBTransaction;
    IBDataSet1: TIBDataSet;
    procedure DataModuleCreate(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MedDataModule: TMedDataModule;

implementation


{$R *.dfm}

uses MedDBStruct, MedGlobalUnit, MedLoginFrm;

procedure TMedDataModule.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  ALog.LogStr('Произошла ошибка: ' + E.Message);
  Application.MessageBox(PChar(E.Message), 'ОШИБКА!', MB_ICONERROR);
end;

procedure TMedDataModule.DataModuleCreate(Sender: TObject);
begin
  // Запоминаем ссылки на компоненты с более короткими именами
  MedDB := FMedDB;
  TranR := FTranR;
  TranW := FTranW;

  // Проверка структуры БД
  BuildDBStructure;

  if MedDB.Connected then
  begin
    ShowMessage('ВНИМАНИЕ РАЗРАБОТЧИКУ! Соединение с БД уже установлено!!!');
    fb.DisconnectDB(MedDB);
  end;


  MedDB.Params.Values['user_name'] := FBUser;
  MedDB.Params.Values['password'] := FBPassword;
  MedDB.DatabaseName := Format('%s/%d:%s', [FBServer, FBPort, FBFile]);
{
user_name=sysdba
password=masterkey
lc_ctype=WIN1251
}

  try
    fb.ConnectDB(MedDB);
  except
    on E: Exception do
      raise ReCreateEObject(E, 'Подключение к базе данных');
  end;

  if CheckOnFirstStart then
  begin
    IsAdmin := True;
    UserID := 0;
    UserName := 'Запуск под администратором';
  end
  else
  begin
    if ShowLoginForm then
    begin
      ALog.LogStrFmt('Пользователь %s прошел авторизацию', [UserName], tlpInformation);
      ALog.DefaultPrefix := UserName;
    end else
    begin
      ALog.LogStr('Пользователь отказался от авторизации. Приложение будет закрыто');
      fb.DisconnectDB(MedDB);
    end;
  end;
end;

procedure TMedDataModule.DataModuleDestroy(Sender: TObject);
begin
  fb.DisconnectDB(MedDB);
end;

end.
