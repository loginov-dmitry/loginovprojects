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
{ ������ fbUtilsBackupRestore - �������� ������� ��� �������������� �         }
{ �������������� ��� ������ Firebird                                          }
{ (c) 2012 ������� ������� ���������                                          }
{ ��������� ����������: 30.04.2012                                            }
{ �������������� �� D7, D2007, D2010, D-XE2                                   }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }
unit fbUtilsBackupRestore;

interface
uses
  Windows, SysUtils, Classes, IBDatabase, IBServices, fbSomeFuncs, fbUtilsBase, fbTypes;

{$IF RTLVersion >= 23.00}
   {$DEFINE DXE2PLUS}
{$IFEND}

{������������ �������������� ���� ������ ���������� Firebird Service-API.
 ���� ������� �������������� �������������� �� ������� (AServerName). ����
 ������ ABackupFile ������� �������� ������������ �������, �� ������� ������
 ����������� ��������������.}
procedure FBBackupDatabaseOnServer(AServerName: string; APort: Integer; ADBName, ABackupFile,
  AUser, APassw: string; ABackupOptions: TFBBackupOptions; AProgressProc: TBackupRestoreProgressProc; AModuleName: string);

{������������ �������������� ���� ������ � �������� ���� ��������� ����� � �������
 �� ��������� �������.
 ASourBackupFileOnServer: ��� ����� ��������� �����, ��������� ��� ���������� ���������
 ADestBackupFileOnClient: ��� �����, ��� ������� ���. ����� ����� ��������� �� ���������� ����������}
procedure FBBackupDatabaseAndCopyFromServer(AServerName: string; APort: Integer; ADBName, ABackupFile,
  AUser, APassw: string; ABackupOptions: TFBBackupOptions; AProgressProc: TBackupRestoreProgressProc;
  ASourBackupFileOnServer, ADestBackupFileOnClient: string; TryDeleteSourBackupFile: Boolean; AModuleName: string);

{������������ �������������� ���� ������ ���������� Firebird Service-API.
 ���� ������� �������������� �������������� �� ������� (AServerName). ����
 ������ ABackupFile ������� �������� ������������ �������, �� ������� ������
 ����������� ���������������.}
procedure FBRestoreDatabaseOnServer(AServerName: string; APort: Integer; ADBName, ABackupFile,
  AUser, APassw: string; ARestoreOptions: TFBRestoreOptions; AProgressProc: TBackupRestoreProgressProc; AModuleName: string);

{�������� ���� ��������� ����� �� ������ � ���������� �������������� ���� ������}
procedure FBCopyBackupToServerAndRestoreDatabase(AServerName: string; APort: Integer; ADBName, ABackupFile,
  AUser, APassw: string; ARestoreOptions: TFBRestoreOptions; AProgressProc: TBackupRestoreProgressProc;
  ABackupFileOnClient, ABackupFileOnServer: string; TryDeleteBackupFileOnClient,
  TryDeleteBackupFileOnServer: Boolean; AModuleName: string);

{$IFDEF FBUTILSDLL} // ��������� �� ��������� �������� � ������ fbUtilsBase.pas
exports
  FBBackupDatabaseOnServer name 'ibxFBBackupDatabaseOnServer',      
  FBBackupDatabaseAndCopyFromServer name 'ibxFBBackupDatabaseAndCopyFromServer',
  FBRestoreDatabaseOnServer name 'ibxFBRestoreDatabaseOnServer',
  FBCopyBackupToServerAndRestoreDatabase name 'ibxFBCopyBackupToServerAndRestoreDatabase';
{$ENDIF}

resourcestring
  FBStrOperationAborted       = '�������� �������� ��������'; // Operation was aborted by client
  FBStrBackupOnServerNotFound = '���� ������ "%s" �� ������� "%s" �� ������ ��� ��� �������';
  FBStrFileNotFound           = '���� "%s" �� ������';
  FBStrCanNotDeleteFile       = '���������� ������� ���� "%s". �������: %s';
  FBStrCanNotCopyFile         = '���������� ����������� ���� "%s" � "%s". �������: %s';

implementation

procedure FBBackupDatabaseOnServer(AServerName: string; APort: Integer; ADBName, ABackupFile,
  AUser, APassw: string; ABackupOptions: TFBBackupOptions;
  AProgressProc: TBackupRestoreProgressProc; AModuleName: string);
var
  bs: TIBBackupService;
  LastMsg: string;
  Stop: Boolean;
begin
  try
    bs := TIBBackupService.Create(nil);
    try
    {$IFDEF DXE2PLUS}
      { � ����� ������� IBX ����-�� ��������... }
      bs.ServerType := 'IBServer';
    {$ENDIF}

      bs.Params.Text :=
        Format('user_name=%s%spassword=%s',
          [AUser, sLineBreak, APassw]);

      bs.DatabaseName := ADBName;

      bs.BackupFile.Text := ABackupFile;

      if AServerName = '' then
      begin
        bs.Protocol := Local;
      end else
      begin
        bs.ServerName := AServerName + '/' + IntToStr(APort);
        bs.Protocol := TCP;
      end;

      bs.LoginPrompt := False;
      bs.Verbose := True; // �������� ��������� ��������� � ���� ��������������

      bs.Options := TBackupOptions(ABackupOptions); // ����� ��������������

      try
        bs.Active := True; // ������������ � Firebird
      except
        on E: Exception do
          if E is EAccessViolation then
            raise ReCreateEObject(E, 'Attach Error. IBX Bug.')
          else
            raise;
      end;
      try
        bs.ServiceStart; // ��������� ��������������
        while not bs.Eof do
        begin
          LastMsg := bs.GetNextLine;
          if Assigned(AProgressProc) then
          begin
            Stop := False;
            AProgressProc(LastMsg, Stop);
            if Stop then
              raise Exception.Create(FBStrOperationAborted);
          end;
        end;
      finally
        bs.Active := False; // ����������� �� Firebird
      end;
    finally
      bs.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'FBBackupDatabaseOnServer');
  end;
end;

procedure FBBackupDatabaseAndCopyFromServer(AServerName: string; APort: Integer; ADBName, ABackupFile,
  AUser, APassw: string; ABackupOptions: TFBBackupOptions; AProgressProc: TBackupRestoreProgressProc; ASourBackupFileOnServer,
  ADestBackupFileOnClient: string; TryDeleteSourBackupFile: Boolean; AModuleName: string);
begin
  try
    FBBackupDatabaseOnServer(AServerName, APort, ADBName, ABackupFile, AUser, APassw, ABackupOptions, AProgressProc, AModuleName);

    if not FileExists(ASourBackupFileOnServer) then
      raise Exception.CreateFmt(FBStrBackupOnServerNotFound, [ASourBackupFileOnServer, AServerName]);

    if FileExists(ADestBackupFileOnClient) then
      if not DeleteFile(ADestBackupFileOnClient) then
        raise Exception.CreateFmt(FBStrCanNotDeleteFile, [ADestBackupFileOnClient, SysErrorMessage(GetLastError)]);

    if not CopyFile(PChar(ASourBackupFileOnServer), PChar(ADestBackupFileOnClient), True) then
      raise Exception.CreateFmt(FBStrCanNotCopyFile,
        [ASourBackupFileOnServer, ADestBackupFileOnClient, SysErrorMessage(GetLastError)]);

    if TryDeleteSourBackupFile then
      DeleteFile(ASourBackupFileOnServer); // � ������ ������� ������ �� ��������!
  except
    on E: Exception do
      raise ReCreateEObject(E, 'FBBackupDatabaseAndCopyFromServer');
  end;
end;

procedure FBRestoreDatabaseOnServer(AServerName: string; APort: Integer; ADBName, ABackupFile,
  AUser, APassw: string; ARestoreOptions: TFBRestoreOptions;
  AProgressProc: TBackupRestoreProgressProc; AModuleName: string);
var
  rs: TIBRestoreService;
  LastMsg: string;
  Stop: Boolean;
begin
  try
    rs := TIBRestoreService.Create(nil);
    try
    {$IFDEF DXE2PLUS}
      { � ����� ������� IBX ����-�� ��������... }
      rs.ServerType := 'IBServer';
    {$ENDIF}

      rs.Params.Text :=
        Format('user_name=%s%spassword=%s',
          [AUser, sLineBreak, APassw]);

      rs.DatabaseName.Text := ADBName;

      rs.BackupFile.Text := ABackupFile;

      if AServerName = '' then
      begin
        rs.Protocol := Local;
      end else
      begin
        rs.ServerName := AServerName + '/' + IntToStr(APort);
        rs.Protocol := TCP;
      end;

      rs.LoginPrompt := False;
      rs.Verbose := True; // �������� ��������� ��������� � ���� ��������������

      rs.Options := TRestoreOptions(ARestoreOptions); // ����� ��������������

      rs.Active := True; // ������������ � Firebird
      try
        rs.ServiceStart; // ��������� ��������������
        while not rs.Eof do
        begin
          LastMsg := rs.GetNextLine;
          if Assigned(AProgressProc) then
          begin
            Stop := False;
            AProgressProc(LastMsg, Stop);
            if Stop then
              raise Exception.Create(FBStrOperationAborted);
          end;
        end;
      finally
        rs.Active := False; // ����������� �� Firebird
      end;
    finally
      rs.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'FBRestoreDatabaseOnServer');
  end;
end;

procedure FBCopyBackupToServerAndRestoreDatabase(AServerName: string; APort: Integer; ADBName, ABackupFile,
  AUser, APassw: string; ARestoreOptions: TFBRestoreOptions; AProgressProc: TBackupRestoreProgressProc;
  ABackupFileOnClient, ABackupFileOnServer: string; TryDeleteBackupFileOnClient,
  TryDeleteBackupFileOnServer: Boolean; AModuleName: string);
begin
  try
    if not FileExists(ABackupFileOnClient) then
      raise Exception.CreateFmt(FBStrFileNotFound, [ABackupFileOnClient]);

    if FileExists(ABackupFileOnServer) then
      if not DeleteFile(ABackupFileOnServer) then
        raise Exception.CreateFmt(FBStrCanNotDeleteFile, [ABackupFileOnServer, SysErrorMessage(GetLastError)]);

    // �������� ���� ������ �� ������
    if not CopyFile(PChar(ABackupFileOnClient), PChar(ABackupFileOnServer), True) then
      raise Exception.CreateFmt(FBStrCanNotCopyFile,
        [ABackupFileOnClient, ABackupFileOnServer, SysErrorMessage(GetLastError)]);

    // ������������ �������������� �� �� ��������� �����
    FBRestoreDatabaseOnServer(AServerName, APort, ADBName, ABackupFile,
      AUser, APassw, ARestoreOptions, AProgressProc, AModuleName);

    // ������� ����� ��������� ����� ��� �������������
    if TryDeleteBackupFileOnServer then
      DeleteFile(ABackupFileOnServer);
    if TryDeleteBackupFileOnClient then
      DeleteFile(ABackupFileOnClient);

  except
    on E: Exception do
      raise ReCreateEObject(E, 'FBCopyBackupToServerAndRestoreDatabase');
  end;
end;


end.
