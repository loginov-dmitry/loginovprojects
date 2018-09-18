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
{ ������ fbUtilsIniFiles - �������� �������, ����������� �������� � �����     }
{ ������ ��� ��, ��� � � INI-������                                           }
{ (c) 2012 ������� ������� ���������                                          }
{ ��������� ����������: 30.04.2012                                            }
{ �������������� �� D7, D2007, D2010, D-XE2                                   }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{
������ ������ �������� ���������� ����������, ������ ������������� � ��� ��������
����� ����������, ������������� � ������ fbUtils.pas

����� �������������� ������� TFBIniFile ��� ���������� ������� � ���� ������
��������� �������:

      CREATE TABLE CONFIGPARAMS(
        FILENAME     VARCHAR(100) NOT NULL, -- ������������ INI-����� (�� ���������: CONF)
        COMPUTERNAME VARCHAR(100) NOT NULL, -- ������������ ����������. * - ����� ���������
        USERNAME     VARCHAR(100) NOT NULL, -- ��� ������������. * - ��� ������������.
        SECTIONNAME  VARCHAR(100) NOT NULL, -- ������������ ������
        PARAMNAME    VARCHAR(100) NOT NULL, -- ��� ���������
        PARAMVALUE   VARCHAR(10000),        -- ��������� �������� ���������
        PARAMBLOB    BLOB,                  -- ��� �������� ������� �������� �������� (� ��� ����� ��������� ����������)
        PARAMBLOBHASH VARCHAR(50),          -- ��� �������� ���� ��������� �������
        MODIFYDATE   TIMESTAMP,             -- ���� � ����� ��������� ������
        MODIFYUSER   VARCHAR(100),          -- ��� ������������, ������� ���� ���������
        PRIMARY KEY (FILENAME, COMPUTERNAME, USERNAME, SECTIONNAME, PARAMNAME)) -- ��������� ���� (5 �����)

����� ����� ����� ���� �������, �� ��� ���� ��� �������� ���������� ������ fbTypes.
����� ����� �� ������ ����� �� ���� ����������. ����� ���� ������������� ��������.
���� PARAMBLOB ������ �����  SUB_TYPE 0 (Binary) (�����, ���� ��� Text, �� �������
������ �������� �����������, ��������� ������ �����).
��� ������� �� ������ ������� ������������� ���������������� ��������� ����, � ���������
����� (� PRIMARY KEY) ���� �������� � ���� ����������� �������
}

unit fbUtilsIniFiles;

interface

uses
  Windows, SysUtils, Classes, IBDatabase, IBCustomDataSet, SyncObjs, DB, Math,
  fbUtilsBase, fbUtilsPool, fbSomeFuncs, fbTypes;

type
  {��������! �� ������� ����������� ������� �������! ��� ����� ������������� �
   ��� �� ������������������, ��� � � fbUtils.pas}
  TFBIniFile = class(TObject)
  private
    FAlwaysConnected: Boolean;// ����������, ������ �� ����������� ���� ������������ �� ���������� ���� ������ ���������
    FPoolProfileName: string; // ��� ������� �� ���� �����������
    FConnParams: TFBConnectionParams; // ��������� ����������� � Firebird
    FComputerName: string;    // ��� ���������� (�� ��������� - �������)
    FUserName: string;        // ��� ������������ (�� ��������� - ������� ������������ Windows)
    FFileName: string;        // ��� ����� (�� �������� � INI-�������)

    FDB: TIBDatabase;         // ����������� � �� (�� ����)
    FTranW: TIBTransaction;   // ���������� �� ������
    FTranR: TIBTransaction;   // ���������� �� ������

    dsRead: TIBDataSet;       // ����� ������ �� ������ ��������� ���������
    dsIns: TIBDataSet;        // ����� ������ �� ������� ������ ���������
    dsUpd: TIBDataSet;        // ����� ������ �� ��������� ������������� ���������
    dsCustom: TIBDataSet;     // ����� ������ ��� ���������� ������ ��������
    //dsInsOrUpd: TIBDataSet; - �� �����������, �.�. ������ ����������� �� ���� � ������ ������� Firebird

    FObjs: TObjHolder;

    FCritSect: TCriticalSection; // ����������� ������ ��� �������������� �������������� ������� � ������� �� ������ �������

    FWasBeginWorkCall: Boolean; // TRUE, ���� ���� ������� ������� BeginWork

    procedure CheckParams(const Section, Key: string; CheckKey: Boolean = True);
    function InternalValueExists(AnyComp, AnyUser: Boolean; const Section, Key: string; var Value: string; ReadHash: Boolean): Boolean;
    procedure SetParams(ds: TIBDataSet; AnyComp, AnyUser: Boolean; const Section, Key: string);

    procedure ConnectDB(Internal: Boolean);
    procedure DisconnectDB(Internal: Boolean);

  protected
    function GetUserName: string; virtual;
    procedure SetUserName(const Value: string); virtual;
    function GetComputerName: string; virtual;
    procedure SetComputerName(const Value: string); virtual;
    function GetPoolProfileName: string; virtual;
    procedure SetPoolProfileName(const Value: string); virtual;

    {�������� ������� ReadXXX � WriteXXX, ���������� � ��������� ����� � ���� ������}
    procedure DoWriteString(AnyComp, AnyUser: Boolean; const Section, Key, Value: String); virtual;
    procedure DoWriteInteger(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Integer); virtual;
    procedure DoWriteBool(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Boolean); virtual;
    procedure DoWriteFloat(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Double); virtual;
    procedure DoWriteDateTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: TDateTime); virtual;
    procedure DoWriteDate(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: TDateTime); virtual;
    procedure DoWriteTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: TDateTime); virtual;

    function DoReadString(AnyComp, AnyUser: Boolean; const Section, Key, Default: String): string; virtual;
    function DoReadInteger(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: Integer): Integer; virtual;
    function DoReadBool(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: Boolean): Boolean; virtual;
    function DoReadFloat(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: Double): Double; virtual;
    function DoReadDateTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: TDateTime): TDateTime; virtual;
    function DoReadDate(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: TDateTime): TDateTime; virtual;
    function DoReadTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: TDateTime): TDateTime; virtual;

    {������� ReadXXX � WriteXXX, ���������� � BLOB-����� � ���� ������}
    procedure DoWriteStream(AnyComp, AnyUser: Boolean; const Section, Key: String; AStream: TStream); virtual;
    function DoReadStream(AnyComp, AnyUser: Boolean; const Section, Key: String; AStream: TStream): Boolean; virtual;

    {���������� �������� ����� � BLOB-����. ����� � BLOB-���� �������� � ��������� UNICODE}
    procedure DoWriteText(AnyComp, AnyUser: Boolean; const Section, Key: String; Value: string); virtual;

    {��������� ����� �� BLOB-����}
    function DoReadText(AnyComp, AnyUser: Boolean; const Section, Key: String; Default: String): string; virtual;

    {���������� ������������ �������� ������ � BLOB-����}
    procedure DoWriteBinaryData(AnyComp, AnyUser: Boolean; const Section, Key: string; const Buffer; BufSize: Integer); virtual;

    {��������� �������� ������ �� BLOB-����}
    function DoReadBinaryData(AnyComp, AnyUser: Boolean; const Section, Key: string; var Buffer; BufSize: Integer): Integer; virtual;

    {�������� ������� ��� ������ � ��������}

    {��������� ������ ������������ ����������}
    procedure DoReadSection(AnyComp, AnyUser: Boolean; const Section: string; Strings: TStrings); virtual;

    {��������� ����� ������}
    procedure DoReadSections(AnyComp, AnyUser: Boolean; Strings: TStrings); virtual;

    {��� ��������� ������ ��������� ������������ ���������� � �� ��������}
    procedure DoReadSectionValues(AnyComp, AnyUser: Boolean; const Section: string; Strings: TStrings); virtual;

    {���������, ���������� �� �������� ������}
    function DoSectionExists(AnyComp, AnyUser: Boolean; const Section: string): Boolean; virtual;

    {���������, ���������� �� �������� ��������}
    function DoValueExists(AnyComp, AnyUser: Boolean; const Section, Key: string): Boolean; virtual;

    {������� ��������� ������}
    procedure DoEraseSection(AnyComp, AnyUser: Boolean; const Section: string); virtual;

    {������� �������� �������� � ��� ��������}
    procedure DoDeleteKey(AnyComp, AnyUser: Boolean; const Section, Key: String); virtual;
  public

    {��������! ��� ������ ������� ������������ 3 �������� ������:
     1 - "���������": ����������� ��� ������ � ��� ���������, ��� � ��� ������ � TIniFile.
         ��������, ���������� ����� ��������, ����� �������� � ������ ���������� �
         ��� ������ ������������. ������������ ��� ����������, ������������� ����������
     2 - "���������": ��������� ������ ������������� 2 ���������: AnyComp � AnyUser.
         ���� AnyComp (���. "����� ���������") ����� False, �� �������� ����� ��������
         ������ � ����� �� ����������. ���� AnyUser (���. "����� ������������") ����� False,
         �� �������� ����� �������� ������ ��� ������� ������������. ��� �������������
         ��������� AnyComp � AnyUser ����� �������������. ��������, ���� AnyComp=True � AnyUser=False,
         �� �������� ����� �������� ��� ������� ������������, ���������� �� ����,
         �� ����� ����������� �� ��������.
     3 - "����������": ����������� ������� ��������, ������ ��� ������ ��������� ��
         ��������� (������������ ������ FBIniDefSection (PARAMS))}

    {== ������� ��� ������ � INI ==}

    {������ ������}
    procedure WriteString(const Section, Key, Value: String); overload;
    procedure WriteString(AnyComp, AnyUser: Boolean; const Section, Key, Value: String); overload;
    procedure WriteString(const Key, Value: String); overload;

    {������ ����������� ��������}
    procedure WriteBool(const Section, Key: string; Value: Boolean); overload;
    procedure WriteBool(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Boolean); overload;
    procedure WriteBool(const Key: string; Value: Boolean); overload;

    {������ ������������� ����� Double}
    procedure WriteFloat(const Section, Key: string; Value: Double); overload;
    procedure WriteFloat(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Double); overload;
    procedure WriteFloat(const Key: string; Value: Double); overload;

    {������ ���� � �������}
    procedure WriteDateTime(const Section, Key: string; Value: TDateTime); overload;
    procedure WriteDateTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: TDateTime); overload;
    procedure WriteDateTime(const Key: string; Value: TDateTime); overload;

    {������ �������������� ��������}
    procedure WriteInteger(const Section, Key: string; Value: Integer); overload;
    procedure WriteInteger(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Integer); overload;
    procedure WriteInteger(const Key: string; Value: Integer); overload;

    {������ ����}
    procedure WriteDate(const Section, Key: string; Value: TDateTime); overload;
    procedure WriteDate(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: TDateTime); overload;
    procedure WriteDate(Key: string; Value: TDateTime); overload;

    {������ �������}
    procedure WriteTime(const Section, Key: string; Value: TDateTime); overload;
    procedure WriteTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: TDateTime); overload;
    procedure WriteTime(Key: string; Value: TDateTime); overload;

    {== ������� ��� ������ � INI �������� �������� (� ���� BLOB) ==}

    {������ ������ TStream}
    procedure WriteStream(const Section, Key: String; AStream: TStream); overload;
    procedure WriteStream(AnyComp, AnyUser: Boolean; const Section, Key: String; AStream: TStream); overload;
    procedure WriteStream(Key: String; AStream: TStream); overload;

    {������ ������ (������ ������; �������� � ������� Unicode)}
    procedure WriteText(const Section, Key: String; Value: string); overload;
    procedure WriteText(AnyComp, AnyUser: Boolean; const Section, Key: String; Value: string); overload;
    procedure WriteText(Key: String; Value: string); overload;

    {������ ������������� ��������� ������ (��������, �������)}
    procedure WriteBinaryData(const Section, Key: string; const Buffer; BufSize: Integer); overload;
    procedure WriteBinaryData(AnyComp, AnyUser: Boolean; const Section, Key: string; const Buffer; BufSize: Integer); overload;
    procedure WriteBinaryData(Key: string; const Buffer; BufSize: Integer); overload;

    {== ������� ��� ������ � INI ==}

    {������ ������}
    function ReadString(const Section, Key, Default: String): string; overload;
    function ReadString(AnyComp, AnyUser: Boolean; const Section, Key, Default: String): string; overload;
    function ReadString(const Key, Default: String): string; overload;

    {������ �������������� ��������}
    function ReadInteger(const Section, Key: string; Default: Integer): Integer; overload;
    function ReadInteger(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: Integer): Integer; overload;
    function ReadInteger(const Key: string; Default: Integer): Integer; overload;

    {������ ����������� ��������}
    function ReadBool(const Section, Key: string; Default: Boolean): Boolean; overload;
    function ReadBool(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: Boolean): Boolean; overload;
    function ReadBool(const Key: string; Default: Boolean): Boolean; overload;

    {������ ������������� �������� (Double)}
    function ReadFloat(const Section, Key: string; Default: Double): Double; overload;
    function ReadFloat(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: Double): Double; overload;
    function ReadFloat(const Key: string; Default: Double): Double; overload;

    {������ ���� � �������}
    function ReadDateTime(const Section, Key: string; Default: TDateTime): TDateTime; overload;
    function ReadDateTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: TDateTime): TDateTime; overload;
    function ReadDateTime(const Key: string; Default: TDateTime): TDateTime; overload;

    {������ ����}
    function ReadDate(const Section, Key: string; Default: TDateTime): TDateTime; overload;
    function ReadDate(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: TDateTime): TDateTime; overload;
    function ReadDate(Key: string; Default: TDateTime): TDateTime; overload;

    {������ �������}
    function ReadTime(const Section, Key: string; Default: TDateTime): TDateTime; overload;
    function ReadTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: TDateTime): TDateTime; overload;
    function ReadTime(Key: string; Default: TDateTime): TDateTime; overload;

    {== ������� ��� ������ �� INI �������� �������� (�� ���� BLOB) ==}

    {������ � ����� TStream}
    function ReadStream(AnyComp, AnyUser: Boolean; const Section, Key: String; AStream: TStream): Boolean; overload;
    function ReadStream(const Section, Key: String; AStream: TStream): Boolean; overload;
    function ReadStream(Key: String; AStream: TStream): Boolean; overload;

    {������ ������}
    function ReadText(AnyComp, AnyUser: Boolean; const Section, Key: String; Default: String): string; overload;
    function ReadText(const Section, Key: String; Default: String): string; overload;
    function ReadText(Key: String; Default: String): string; overload;

    {������ � �������� �����}
    function ReadBinaryData(AnyComp, AnyUser: Boolean; const Section, Key: string; var Buffer; BufSize: Integer): Integer; overload;
    function ReadBinaryData(const Section, Key: string; var Buffer; BufSize: Integer): Integer; overload;
    function ReadBinaryData(Key: string; var Buffer; BufSize: Integer): Integer; overload;


    {== ������� ��� ������ � �������� ==}

    {==ReadSection - ��������� ������ ������������ ���������� ��� �������� ������}
    procedure ReadSection(const Section: string; Strings: TStrings); overload;
    procedure ReadSection(AnyComp, AnyUser: Boolean; const Section: string; Strings: TStrings); overload;
    procedure ReadSection(Strings: TStrings); overload;

    {==ReadSections - ��������� ������������ ������}
    procedure ReadSections(Strings: TStrings); overload;
    procedure ReadSections(AnyComp, AnyUser: Boolean; Strings: TStrings); overload;

    {==ReadSectionValues - ��� ��������� ������ ��������� ������������ ���������� � �� ��������}
    procedure ReadSectionValues(const Section: string; Strings: TStrings); overload;
    procedure ReadSectionValues(AnyComp, AnyUser: Boolean; const Section: string; Strings: TStrings); overload;
    procedure ReadSectionValues(Strings: TStrings); overload;

    {== SectionExists - ���������, ���������� �� �������� ������}
    function SectionExists(const Section: string): Boolean; overload;
    function SectionExists(AnyComp, AnyUser: Boolean; const Section: string): Boolean; overload;
    function SectionExists: Boolean; overload;

    {== ValueExists - ���������, ���������� �� �������� ��������}
    function ValueExists(const Section, Key: string): Boolean; overload;
    function ValueExists(AnyComp, AnyUser: Boolean; const Section, Key: string): Boolean; overload;
    function ValueExists(Key: string): Boolean; overload;

    {== EraseSection - ������� ��������� ������}
    procedure EraseSection(const Section: string); overload;
    procedure EraseSection(AnyComp, AnyUser: Boolean; const Section: string); overload;
    procedure EraseSection; overload;

    {== DeleteKey - ������� �������� �������� � ��� ��������}
    procedure DeleteKey(const Section, Key: String); overload;
    procedure DeleteKey(AnyComp, AnyUser: Boolean; const Section, Key: String); overload;
    procedure DeleteKey(const Key: String); overload;
  public
    { ������������� ��������� ����������� � ���� ������. ���� ������� ��� �������,
      �� ������������ ��������� �� �����������! ��������� ������� ��������� �� ������
      ������ � ��������� ReadXXX ��� WriteXXX }
    procedure SetConnectionParams(AServerName: string; APort: Integer; ADataBase: string;
      AUserName: string; APassword: string; ACharSet: string); virtual;

    { ������ ������ � ��������. ������������� �������� ��� ������/������ ��������
      ���������� ����������. ��� �������� ������, ���� ������������ ��������
      ������ � ����� ����������� }
    procedure BeginWork; virtual;

    { ��������� ������ � ��������. �������������� ������ ���� ������ ����� BeginWork }
    procedure EndWork; virtual;

    { ��������� ������� ��� ������������ (�� ��������� ������� ��� �������� ������������ Windows) }
    property UserName: string read GetUserName write SetUserName;

    { ��������� ������� ��� ���������� (�� ��������� ������� ��� �������� ����������) }
    property ComputerName: string read GetComputerName write SetComputerName;

    { ��������� ������� ��� ������� �� ���� ����������� (�� ��������� ������� FBDefDB) }
    property PoolProfileName: string read GetPoolProfileName write SetPoolProfileName;

  public
    {�����������. �������� ������ ����: AlwaysConnected. ���� �� = TRUE, �� �����������
     � ���� ������ ��������������� ���� ��� (������� �� ����) � �������� �� ����
     ���������� ������ ���������. ���� �� = FALSE, �� ����������� ������� �� ����
     ������ �� ������ ���������� �������� ReadXXX � WriteXXX)}
    { ��������� ������� ��� ����� (�������� ���������� INI-������). �� ���������: CONF
      ���� ������ ���� ���������� �������� � ���������� INI-������, �� �� ������
      ��� �������� ������� ������� ��� INI-�����. ���������� ��������� ������� ���������. }
    constructor Create(AFileName: string; AlwaysConnected: Boolean);

    {����������}
    destructor Destroy; override;
  end;

{������� ������ TFBIniFile}
function FBCreateIniFile(AFileName: string; AlwaysConnected: Boolean): TFBIniFile;

{���������� �������� ������ TFBIniFile}
procedure FBFreeIniFile(Ini: TFBIniFile);

{$IFDEF FBUTILSDLL} // ��������� �� ��������� �������� � ������ fbUtilsBase.pas
exports
  FBCreateIniFile name 'ibxFBCreateIniFile',
  FBFreeIniFile name 'ibxFBFreeIniFile';
{$ENDIF}

implementation

const
  SAnyComp = '*'; // ����� ���������
  SAnyUser = '*'; // ��� ������������

function FBCreateIniFile(AFileName: string; AlwaysConnected: Boolean): TFBIniFile;
begin
  Result := TFBIniFile.Create(AFileName, AlwaysConnected);
end;

procedure FBFreeIniFile(Ini: TFBIniFile);
begin
  Ini.Free;
end;

{ TFBIniFile }

procedure TFBIniFile.BeginWork;
begin
  FCritSect.Enter;
  try
    if FWasBeginWorkCall then
      raise Exception.Create('Call of TFBIniFile.EndWork was skipped!'); // ���-�� �� ��� ������ ����� TFBIniFile.EndWork
    FWasBeginWorkCall := True;
    ConnectDB(False);
  except
    on E: Exception do
    begin
      FWasBeginWorkCall := False;
      FCritSect.Leave;
      raise ReCreateEObject(E, 'TFBIniFile.BeginWork');
    end;
  end;
end;

procedure TFBIniFile.CheckParams(const Section, Key: string; CheckKey: Boolean = True);
begin
  if Section = '' then
    raise Exception.Create('Section name is empty!'); //��� ������ �� �������

  if CheckKey then
    if Key = '' then
      raise Exception.Create('Parameter name is empty!'); // ��� ��������� �� �������
end;

procedure TFBIniFile.ConnectDB(Internal: Boolean);
begin
  if FDB = nil then // ���� ������ ����������� � �� ��� �� ������...
  begin
    if FConnParams.cpDataBase <> '' then
      FDB := FBPoolGetConnectionByParams(FConnParams.cpServerName, FConnParams.cpPort,
        FConnParams.cpDataBase, FConnParams.cpUserName, FConnParams.cpPassword, FConnParams.cpCharSet,
        @FTranR, @FTranW, trRCRO, trRCRWW, '')
    else
      FDB := FBPoolGetConnectionByProfile(FPoolProfileName, @FTranR, @FTranW, trRCRO, trRCRWW, '');

    dsRead.Database := FDB;
    dsRead.Transaction := FTranR;
    dsIns.Database := FDB;
    dsIns.Transaction := FTranW;
    dsUpd.Database := FDB;
    dsUpd.Transaction := FTranW;
    dsCustom.Database := FDB;
    dsCustom.Transaction := FTranW;
  end;

  if not FTranR.Active then
    FTranR.Active := True;
end;

constructor TFBIniFile.Create(AFileName: string; AlwaysConnected: Boolean);
begin
  inherited Create;
  FAlwaysConnected := AlwaysConnected;
  FComputerName := GetCurrentComputerName;
  FUserName := GetCurrentUserName;
  FFileName := AFileName;
  FPoolProfileName := FBDefDB; // ��� ������� ���������� ����������� � ���� �� ���������
  FObjs := TObjHolder.Create;

  FObjs.RegObj(FCritSect, TCriticalSection.Create);

  FObjs.RegObj(dsRead, TIBDataSet.Create(nil));
  dsRead.SelectSQL.Text := Format(
    'SELECT %s, %s, %s FROM %s '+
    'WHERE %s=:FILENAME AND %s=:COMPUTERNAME AND %s=:USERNAME AND %s=:SECTIONNAME AND %s=:PARAMNAME',
    [FBIniFieldParamValue, FBIniFieldParamBlob, FBIniFieldParamBlobHash, FBIniTableConfigParams,
     FBIniFieldFileName, FBIniFieldComputerName, FBIniFieldUserName, FBIniFieldSectionName, FBIniFieldParamName]);

  FObjs.RegObj(dsIns, TIBDataSet.Create(nil));
  dsIns.SelectSQL.Text := Format(
    ' INSERT INTO %s '+
    ' (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s) VALUES '+
    ' (:FILENAME, :COMPUTERNAME, :USERNAME, :SECTIONNAME, :PARAMNAME, :PARAMVALUE, :PARAMBLOB, :PARAMBLOBHASH, CURRENT_TIMESTAMP, :MODIFYUSER)',
    [FBIniTableConfigParams, FBIniFieldFileName, FBIniFieldComputerName, FBIniFieldUserName, FBIniFieldSectionName,
     FBIniFieldParamName, FBIniFieldParamValue, FBIniFieldParamBlob, FBIniFieldParamBlobHash,
     FBIniFieldModifyDate, FBIniFieldModifyUser]);

  FObjs.RegObj(dsUpd, TIBDataSet.Create(nil));
  dsUpd.SelectSQL.Text := Format(
    ' UPDATE %s SET %s = :PARAMVALUE, %s = :PARAMBLOB, %s=:PARAMBLOBHASH, %s=CURRENT_TIMESTAMP, %s=:MODIFYUSER '+
    ' WHERE (%s=:FILENAME) AND (%s=:COMPUTERNAME) AND (%s=:USERNAME) AND '+
    '       (%s=:SECTIONNAME) AND (%s=:PARAMNAME) ',
    [FBIniTableConfigParams, FBIniFieldParamValue, FBIniFieldParamBlob, FBIniFieldParamBlobHash,
     FBIniFieldModifyDate, FBIniFieldModifyUser,
     FBIniFieldFileName, FBIniFieldComputerName, FBIniFieldUserName, FBIniFieldSectionName, FBIniFieldParamName]);

  FObjs.RegObj(dsCustom, TIBDataSet.Create(nil));
end;

destructor TFBIniFile.Destroy;
begin
  FAlwaysConnected := False; // ��������� ����� "���������� �����������"
  DisconnectDB(True);        // ����������� �� ���� ������
  FObjs.Free;
  inherited;
end;

procedure TFBIniFile.DisconnectDB(Internal: Boolean);
begin
  if not FAlwaysConnected then
  begin
    if FWasBeginWorkCall then // ���� ������ ����� BeginWork
      if Internal then        // � ���� ��� ���������� �����
        Exit;                 // �� ����������� �� ���������

    if Assigned(FDB) then
    begin
      try
        FBPoolReturnConnection(FDB, '');
      finally
        FDB := nil;
        FTranW := nil;
        FTranR := nil;
      end;
    end;
  end;
end;

procedure TFBIniFile.EndWork;
begin
  try
    if not FWasBeginWorkCall then
      raise Exception.Create('Call of TFBIniFile.BeginWork was skipped'); // ��� �������� ����� TFBIniFile.BeginWork

    try
      DisconnectDB(False);
    finally
      FWasBeginWorkCall := False;
      FCritSect.Leave;
    end;

  except
    on E: Exception do
      raise ReCreateEObject(E, 'TFBIniFile.EndWork');
  end;

end;

function TFBIniFile.GetComputerName: string;
begin
  Result := FComputerName;
end;

function TFBIniFile.GetPoolProfileName: string;
begin
  Result := FPoolProfileName;
end;

function TFBIniFile.GetUserName: string;
begin
  Result := FUserName;
end;

procedure TFBIniFile.DoDeleteKey(AnyComp, AnyUser: Boolean; const Section,
  Key: String);
begin
  try
    FCritSect.Enter;
    try
      ConnectDB(True);
      try
        CheckParams(Section, Key, False);
        FTranW.Active := True;
        try
          dsCustom.SelectSQL.Text := Format(
            'DELETE FROM %s '+
            'WHERE %s=:FILENAME AND %s=:COMPUTERNAME AND %s=:USERNAME AND %s=:SECTIONNAME AND %s=:PARAMNAME ',
            [FBIniTableConfigParams, FBIniFieldFileName, FBIniFieldComputerName, FBIniFieldUserName,
             FBIniFieldSectionName, FBIniFieldParamName]);
          SetParams(dsCustom, AnyComp, AnyUser, Section, Key);

          dsCustom.ExecSQL;
          FTranW.Commit;

        finally
          FTranW.Active := False;
        end;
      finally
        DisconnectDB(True);
      end;
    finally
      FCritSect.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'EraseSection');
  end;
end;

procedure TFBIniFile.DoEraseSection(AnyComp, AnyUser: Boolean;
  const Section: string);
begin
  try
    FCritSect.Enter;
    try
      ConnectDB(True);
      try
        CheckParams(Section, '', False);
        FTranW.Active := True;
        try
          dsCustom.SelectSQL.Text := Format(
            'DELETE FROM %s '+
            'WHERE %s=:FILENAME AND %s=:COMPUTERNAME AND %s=:USERNAME AND %s=:SECTIONNAME ',
            [FBIniTableConfigParams, FBIniFieldFileName, FBIniFieldComputerName, FBIniFieldUserName, FBIniFieldSectionName]);
          SetParams(dsCustom, AnyComp, AnyUser, Section, '');

          dsCustom.ExecSQL;
          FTranW.Commit;

        finally
          FTranW.Active := False;
        end;
      finally
        DisconnectDB(True);
      end;
    finally
      FCritSect.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'EraseSection');
  end;
end;

function TFBIniFile.DoReadBinaryData(AnyComp, AnyUser: Boolean; const Section, Key: string;
  var Buffer; BufSize: Integer): Integer;
var
  ms: TMemoryStream;
  Ar: PByteArray;
  I: Integer;
begin
  try
    ms := TMemoryStream.Create;
    try
      Result := 0;
      if DoReadStream(AnyComp, AnyUser, Section, Key, ms) then
      begin
        Result := Min(BufSize, ms.Size);
        if Result > 0 then
        begin
          ms.Position := 0;
          ms.Read(Buffer, Result);
          if Result < BufSize then
          begin // �������� ���������� ����� ������
            Ar := @Buffer;
            for I := Result to BufSize - 1 do
              Ar[I] := 0;
          end;
        end;
      end;
    finally
      ms.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadBinaryData');
  end;
end;

function TFBIniFile.DoReadBool(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: Boolean): Boolean;
begin
  Result := ReadInteger(AnyComp, AnyUser, Section, Key, Byte(Default)) = 1;
end;

function TFBIniFile.ReadBool(const Key: string; Default: Boolean): Boolean;
begin
  Result := ReadBool(FBIniDefSection, Key, Default);
end;

function TFBIniFile.ReadDateTime(const Key: string;
  Default: TDateTime): TDateTime;
begin
  Result := ReadDateTime(FBIniDefSection, Key, Default);
end;

function TFBIniFile.DoReadDate(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: TDateTime): TDateTime;
var
  S: string;
begin
  try
    S := ReadString(AnyComp, AnyUser, Section, Key, DateToStr(Default, FBFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadDate');
  end;

  try
    Result := StrToDate(S, FBFormatSettings);
  except
    Result := Default;
  end;
end;

function TFBIniFile.DoReadDateTime(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: TDateTime): TDateTime;
var
  S: string;
begin
  try
    S := ReadString(AnyComp, AnyUser, Section, Key, DateTimeToStr(Default, FBFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadDateTime');
  end;

  try
    Result := StrToDateTime(S, FBFormatSettings);
  except
    Result := Default;
  end;
end;

function TFBIniFile.ReadFloat(const Key: string; Default: Double): Double;
begin
  Result := ReadFloat(FBIniDefSection, Key, Default);
end;

function TFBIniFile.DoReadFloat(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: Double): Double;
var
  S: string;
begin
  try
    S := ReadString(AnyComp, AnyUser, Section, Key, FloatToStr(Default, FBFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadFloat');
  end;

  try
    Result := StrToFloat(S, FBFormatSettings);
  except
    Result := Default;
  end;
end;

function TFBIniFile.ReadInteger(const Key: string; Default: Integer): Integer;
begin
  Result := ReadInteger(FBIniDefSection, Key, Default);
end;

function TFBIniFile.DoReadInteger(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: Integer): Integer;
var
  S: string;
begin
  try
    S := ReadString(AnyComp, AnyUser, Section, Key, IntToStr(Default));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadInteger');
  end;

  try
    Result := StrToInt(S);
  except
    Result := Default;
  end;
end;

function TFBIniFile.ReadString(const Key, Default: String): string;
begin
  Result := ReadString(FBIniDefSection, Key, Default);
end;

procedure TFBIniFile.DoReadSection(AnyComp, AnyUser: Boolean;
  const Section: string; Strings: TStrings);
begin
  try
    FCritSect.Enter;
    try
      ConnectDB(True);
      try
        CheckParams(Section, '', False);
        FTranW.Active := True;
        try
          dsCustom.SelectSQL.Text := Format(
            'SELECT %s FROM %s '+
            'WHERE %s=:FILENAME AND %s=:COMPUTERNAME AND %s=:USERNAME AND %s=:SECTIONNAME '+
            'ORDER BY 1',
            [FBIniFieldParamName, FBIniTableConfigParams, FBIniFieldFileName,
             FBIniFieldComputerName, FBIniFieldUserName, FBIniFieldSectionName]);
          SetParams(dsCustom, AnyComp, AnyUser, Section, '');

          dsCustom.Open;
          Strings.BeginUpdate;
          try
            Strings.Clear;
            while not dsCustom.Eof do
            begin
              Strings.Add(dsCustom.Fields[0].AsString);
              dsCustom.Next;
            end;
          finally
            Strings.EndUpdate;
          end;
          dsCustom.Close;

        finally
          FTranW.Active := False;
        end;
      finally
        DisconnectDB(True);
      end;
    finally
      FCritSect.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadSection');
  end;

end;

procedure TFBIniFile.DoReadSections(AnyComp, AnyUser: Boolean; Strings: TStrings);
begin
  try
    FCritSect.Enter;
    try
      ConnectDB(True);
      try
        FTranW.Active := True;
        try
          dsCustom.SelectSQL.Text := Format(
            'SELECT DISTINCT %s FROM %s '+
            'WHERE %s=:FILENAME AND %s=:COMPUTERNAME AND %s=:USERNAME '+
            'ORDER BY 1',
            [FBIniFieldSectionName, FBIniTableConfigParams, FBIniFieldFileName, FBIniFieldComputerName, FBIniFieldUserName]);
          SetParams(dsCustom, AnyComp, AnyUser, '', '');

          dsCustom.Open;
          Strings.BeginUpdate;
          try
            Strings.Clear;
            while not dsCustom.Eof do
            begin
              Strings.Add(dsCustom.Fields[0].AsString);
              dsCustom.Next;
            end;
          finally
            Strings.EndUpdate;
          end;
          dsCustom.Close;

        finally
          FTranW.Active := False;
        end;
      finally
        DisconnectDB(True);
      end;
    finally
      FCritSect.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadSections');
  end;

end;

procedure TFBIniFile.DoReadSectionValues(AnyComp, AnyUser: Boolean;
  const Section: string; Strings: TStrings);
begin
  try
    FCritSect.Enter;
    try
      ConnectDB(True);
      try
        CheckParams(Section, '', False);
        FTranW.Active := True;
        try
          dsCustom.SelectSQL.Text := Format(
            'SELECT %s, %s FROM %s '+
            'WHERE %s=:FILENAME AND %s=:COMPUTERNAME AND %s=:USERNAME AND %s=:SECTIONNAME '+
            'ORDER BY 1',
            [FBIniFieldParamName, FBIniFieldParamValue, FBIniTableConfigParams, FBIniFieldFileName,
             FBIniFieldComputerName, FBIniFieldUserName, FBIniFieldSectionName]);
          SetParams(dsCustom, AnyComp, AnyUser, Section, '');

          dsCustom.Open;
          Strings.BeginUpdate;
          try
            Strings.Clear;
            while not dsCustom.Eof do
            begin
              Strings.Add(dsCustom.Fields[0].AsString + '=' + dsCustom.Fields[1].AsString);
              dsCustom.Next;
            end;
          finally
            Strings.EndUpdate;
          end;
          dsCustom.Close;

        finally
          FTranW.Active := False;
        end;
      finally
        DisconnectDB(True);
      end;
    finally
      FCritSect.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadSectionValues');
  end;
end;

function TFBIniFile.DoReadStream(AnyComp, AnyUser: Boolean; const Section,
  Key: String; AStream: TStream): Boolean;
begin
  AStream.Size := 0;
  try
    FCritSect.Enter;
    try
      ConnectDB(True);
      try
        CheckParams(Section, Key);
        SetParams(dsRead, AnyComp, AnyUser, Section, Key);

        dsRead.Open;
        Result := not dsRead.Eof;
        if Result then
          TBlobField(dsRead.Fields[1]).SaveToStream(AStream);
        dsRead.Close;
      finally
        DisconnectDB(True);
      end;
    finally
      FCritSect.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadStream');
  end;
end;

function TFBIniFile.DoReadString(AnyComp, AnyUser: Boolean; const Section, Key,
  Default: String): string;
begin
  Result := Default;
  try
    FCritSect.Enter;
    try
      ConnectDB(True);
      try
        CheckParams(Section, Key);
        SetParams(dsRead, AnyComp, AnyUser, Section, Key);

        dsRead.Open;
        if not dsRead.Eof then
          Result := dsRead.Fields[0].AsString;
        dsRead.Close;
      finally
        DisconnectDB(True);
      end;
    finally
      FCritSect.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadString');
  end;
end;

function TFBIniFile.DoReadText(AnyComp, AnyUser: Boolean; const Section,
  Key: String; Default: String): string;
var
  ms: TMemoryStream;
  ws: WideString;
begin
  ms := TMemoryStream.Create;
  try
    if DoReadStream(AnyComp, AnyUser, Section, Key, ms) then
    begin
      ms.Position := 0;
      if ms.Size < 2 then
        ws := ''
      else
      begin
        SetLength(ws, ms.Size div SizeOf(WideChar));
        ms.Read(ws[1], Length(ws) * SizeOf(WideChar));
      end;
      Result := ws;
    end else
      Result := Default;
  finally
    ms.Free;
  end;
end;

function TFBIniFile.DoReadTime(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: TDateTime): TDateTime;
var
  S: string;
begin
  try
    S := ReadString(AnyComp, AnyUser, Section, Key, TimeToStr(Default, FBFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ReadTime');
  end;

  try
    Result := StrToTime(S, FBFormatSettings);
  except
    Result := Default;
  end;
end;

function TFBIniFile.DoSectionExists(AnyComp, AnyUser: Boolean;
  const Section: string): Boolean;
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    DoReadSections(AnyComp, AnyUser, AList); // ��������� ����� ���� ������
    Result := AList.IndexOf(Section) >= 0;   // ���������, ���� �� ����� ��� ������� ������
  finally
    AList.Free;
  end;
end;

function TFBIniFile.DoValueExists(AnyComp, AnyUser: Boolean; const Section,
  Key: string): Boolean;
const
  SNotExists = '<#@_not_exists_@#>';
var
  S: string;
begin
  S := DoReadString(AnyComp, AnyUser, Section, Key, SNotExists);
  Result := S <> SNotExists;
end;

procedure TFBIniFile.SetComputerName(const Value: string);
begin
  if Trim(Value) = '' then
    raise Exception.Create('Computer name is empty');
  FCritSect.Enter; // �� ������ ������ �������� ���������� � ������� ����. ������
  FComputerName := Value;
  FCritSect.Leave;
end;

procedure TFBIniFile.SetConnectionParams(AServerName: string; APort: Integer;
  ADataBase, AUserName, APassword, ACharSet: string);
begin
  with FConnParams do
  begin
    cpServerName := AServerName;
    cpPort := APort;
    cpDataBase := ADataBase; // ��� ���� ������ ��� ��� ����������, ����� �� ������������ FConnParams
    cpUserName := AUserName;
    cpPassword := APassword;
    cpCharSet := ACharSet;
  end;
end;

procedure TFBIniFile.SetParams(ds: TIBDataSet; AnyComp, AnyUser: Boolean;
  const Section, Key: string);
var
  UserName, ComputerName: string;
begin
  if AnyUser then
    UserName := SAnyUser
  else
    UserName := FUserName;

  if AnyComp then
    ComputerName := SAnyComp
  else
    ComputerName := FComputerName;

  ds.ParamByName('FILENAME').AsString := AnsiUpperCase(FFileName);
  ds.ParamByName('COMPUTERNAME').AsString := AnsiUpperCase(ComputerName);
  ds.ParamByName('USERNAME').AsString     := AnsiUpperCase(UserName);


  if Section <> '' then
    ds.ParamByName('SECTIONNAME').AsString  := AnsiUpperCase(Section);
  if Key <> '' then
    ds.ParamByName('PARAMNAME').AsString    := AnsiUpperCase(Key);
end;

procedure TFBIniFile.SetPoolProfileName(const Value: string);
begin
  FCritSect.Enter; // �� ������ ������ �������� ���������� � ������� ����. ������
  FPoolProfileName := Value;
  FCritSect.Leave;
end;

procedure TFBIniFile.SetUserName(const Value: string);
begin
  if Trim(Value) = '' then
    raise Exception.Create('User name is empty');
  FCritSect.Enter;
  FUserName := Value;
  FCritSect.Leave;
end;

function TFBIniFile.InternalValueExists(AnyComp, AnyUser: Boolean; const Section, Key: string; var Value: string; ReadHash: Boolean): Boolean;
begin
  Value := '';
  CheckParams(Section, Key);
  SetParams(dsRead, AnyComp, AnyUser, Section, Key);
  dsRead.Open;
  Result := not dsRead.Eof;
  if Result then
  begin
    if ReadHash then
      Value := dsRead.Fields[2].AsString
    else
      Value := dsRead.Fields[0].AsString;
  end;
  dsRead.Close;
end;

procedure TFBIniFile.DoWriteBinaryData(AnyComp, AnyUser: Boolean; const Section, Key: string;
  const Buffer; BufSize: Integer);
var
  ms: TMemoryStream;
begin
  try
    ms := TMemoryStream.Create;
    try
      if BufSize > 0 then
        ms.WriteBuffer(Buffer, BufSize);
      DoWriteStream(AnyComp, AnyUser, Section, Key, ms);
    finally
      ms.Free;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'WriteBinaryData');
  end;
end;

procedure TFBIniFile.DoWriteBool(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Boolean);
begin
  try
    WriteInteger(AnyComp, AnyUser, Section, Key, Byte(Value));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'WriteBool');
  end;
end;

procedure TFBIniFile.WriteBool(const Key: string; Value: Boolean);
begin
  WriteBool(FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.WriteDateTime(const Key: string; Value: TDateTime);
begin
  WriteDateTime(FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.DoWriteDate(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: TDateTime);
begin
  try
    WriteString(AnyComp, AnyUser, Section, Key, DateToStr(Value, FBFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'WriteDate');
  end;
end;

procedure TFBIniFile.DoWriteDateTime(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: TDateTime);
begin
  try
    WriteString(AnyComp, AnyUser, Section, Key, DateTimeToStr(Value, FBFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'WriteDateTime');
  end;
end;

procedure TFBIniFile.WriteFloat(const Key: string; Value: Double);
begin
  WriteFloat(FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.DoWriteFloat(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: Double);
begin
  try
    WriteString(AnyComp, AnyUser, Section, Key, FloatToStr(Value, FBFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'WriteFloat');
  end;
end;

procedure TFBIniFile.WriteInteger(const Key: string; Value: Integer);
begin
  WriteInteger(FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.DoWriteInteger(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: Integer);
begin
  try
    WriteString(AnyComp, AnyUser, Section, Key, IntToStr(Value));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'WriteInteger');
  end;
end;

procedure TFBIniFile.WriteString(const Key, Value: String);
begin
  WriteString(FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.DoWriteStream(AnyComp, AnyUser: Boolean; const Section,
  Key: String; AStream: TStream);
var
  ds: TIBDataSet;
  OldHash, NewHash: string;
begin
  try
    FCritSect.Enter;
    try
      ConnectDB(True);
      try
        AStream.Position := 0;
        // ��������� ���
        NewHash := CalcStreamHash(AStream);

        if InternalValueExists(AnyComp, AnyUser, Section, Key, OldHash, True) then
        begin
          if FBIniCheckBlobHash then
            if NewHash = OldHash then Exit; // ���� �� �� ����� ��������, �� �������
          ds := dsUpd;
        end
        else
          ds := dsIns;

        FTranW.Active := True;
        try
          SetParams(ds, AnyComp, AnyUser, Section, Key);
          ds.ParamByName('PARAMVALUE').Clear;
          ds.ParamByName('PARAMBLOB').LoadFromStream(AStream);
          ds.ParamByName('PARAMBLOBHASH').AsString := NewHash;
          ds.ParamByName('MODIFYUSER').AsString := FUserName; // ��� AnsiUpperCase
          ds.ExecSQL;

          FTranW.Commit;
        except
          FTranW.Rollback;
          raise;
        end;
      finally
        DisconnectDB(True);
      end;
    finally
      FCritSect.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'WriteStream');
  end;
end;

procedure TFBIniFile.DoWriteString(AnyComp, AnyUser: Boolean; const Section, Key, Value: String);
var
  ds: TIBDataSet;
  OldValue: string;
begin
  try
    FCritSect.Enter;
    try
      ConnectDB(True);
      try
        if InternalValueExists(AnyComp, AnyUser, Section, Key, OldValue, False) then
        begin
          if OldValue = Value then Exit; // ���� �� �� ����� ��������, �� �������
          ds := dsUpd;
        end
        else
          ds := dsIns;

        FTranW.Active := True;
        try
          SetParams(ds, AnyComp, AnyUser, Section, Key);
          ds.ParamByName('PARAMVALUE').AsString := Value;
          ds.ParamByName('PARAMBLOB').Clear;
          ds.ParamByName('PARAMBLOBHASH').Clear;
          ds.ParamByName('MODIFYUSER').AsString := FUserName; // ��� AnsiUpperCase
          ds.ExecSQL;

          FTranW.Commit;
        except
          FTranW.Rollback;
          raise;
        end;
      finally
        DisconnectDB(True);
      end;
    finally
      FCritSect.Leave;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'WriteString');
  end;
end;

procedure TFBIniFile.DoWriteText(AnyComp, AnyUser: Boolean; const Section,
  Key: String; Value: string);
var
  ws: WideString;
  ms: TMemoryStream;
begin
  ws := Value; {��� ��-��������� ������ ���������� �������������� �������������}
  ms := TMemoryStream.Create;
  try
    if ws <> '' then
      ms.Write(ws[1], Length(ws) * SizeOf(WideChar));
    DoWriteStream(AnyComp, AnyUser, Section, Key, ms);
  finally
    ms.Free;
  end;
end;

procedure TFBIniFile.DoWriteTime(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: TDateTime);
begin
  try
    WriteString(AnyComp, AnyUser, Section, Key, TimeToStr(Value, FBFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'WriteTime');
  end;
end;

procedure TFBIniFile.WriteBool(const Section, Key: string; Value: Boolean);
begin
  WriteBool(True, True, Section, Key, Value);
end;

procedure TFBIniFile.WriteDateTime(const Section, Key: string;
  Value: TDateTime);
begin
  WriteDateTime(True, True, Section, Key, Value);
end;

procedure TFBIniFile.WriteFloat(const Section, Key: string; Value: Double);
begin
  WriteFloat(True, True, Section, Key, Value);
end;

procedure TFBIniFile.WriteInteger(const Section, Key: string; Value: Integer);
begin
  WriteInteger(True, True, Section, Key, Value);
end;

procedure TFBIniFile.WriteString(const Section, Key, Value: String);
begin
  WriteString(True, True, Section, Key, Value);
end;

function TFBIniFile.ReadBool(const Section, Key: string;
  Default: Boolean): Boolean;
begin
  Result := ReadBool(True, True, Section, Key, Default);
end;

function TFBIniFile.ReadDateTime(const Section, Key: string;
  Default: TDateTime): TDateTime;
begin
  Result := ReadDateTime(True, True, Section, Key, Default);
end;

function TFBIniFile.ReadFloat(const Section, Key: string;
  Default: Double): Double;
begin
  Result := ReadFloat(True, True, Section, Key, Default);
end;

function TFBIniFile.ReadInteger(const Section, Key: string;
  Default: Integer): Integer;
begin
  Result := ReadInteger(True, True, Section, Key, Default);
end;

function TFBIniFile.ReadString(const Section, Key, Default: String): string;
begin
  Result := ReadString(True, True, Section, Key, Default);
end;

function TFBIniFile.ReadBool(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: Boolean): Boolean;
begin
  Result := DoReadBool(AnyComp, AnyUser, Section, Key, Default);
end;

function TFBIniFile.ReadDateTime(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: TDateTime): TDateTime;
begin
  Result := DoReadDateTime(AnyComp, AnyUser, Section, Key, Default);
end;

function TFBIniFile.ReadFloat(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: Double): Double;
begin
  Result := DoReadFloat(AnyComp, AnyUser, Section, Key, Default);
end;

function TFBIniFile.ReadInteger(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: Integer): Integer;
begin
  Result := DoReadInteger(AnyComp, AnyUser, Section, Key, Default);
end;

function TFBIniFile.ReadString(AnyComp, AnyUser: Boolean; const Section, Key,
  Default: String): string;
begin
  Result := DoReadString(AnyComp, AnyUser, Section, Key, Default);
end;

procedure TFBIniFile.WriteBool(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: Boolean);
begin
  DoWriteBool(AnyComp, AnyUser, Section, Key, Value);
end;

procedure TFBIniFile.WriteDateTime(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: TDateTime);
begin
  DoWriteDateTime(AnyComp, AnyUser, Section, Key, Value);
end;

procedure TFBIniFile.WriteFloat(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: Double);
begin
  DoWriteFloat(AnyComp, AnyUser, Section, Key, Value);
end;

procedure TFBIniFile.WriteInteger(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: Integer);
begin
  DoWriteInteger(AnyComp, AnyUser, Section, Key, Value);
end;

procedure TFBIniFile.WriteString(AnyComp, AnyUser: Boolean; const Section, Key,
  Value: String);
begin
  DoWriteString(AnyComp, AnyUser, Section, Key, Value);
end;


procedure TFBIniFile.ReadSection(AnyComp, AnyUser: Boolean;
  const Section: string; Strings: TStrings);
begin
  DoReadSection(AnyComp, AnyUser, Section, Strings);
end;

procedure TFBIniFile.ReadSection(const Section: string; Strings: TStrings);
begin
  DoReadSection(True, True, Section, Strings);
end;

procedure TFBIniFile.ReadSection(Strings: TStrings);
begin
  DoReadSection(True, True, FBIniDefSection, Strings);
end;

procedure TFBIniFile.ReadSections(Strings: TStrings);
begin
  DoReadSections(True, True, Strings);
end;

procedure TFBIniFile.ReadSections(AnyComp, AnyUser: Boolean; Strings: TStrings);
begin
  DoReadSections(AnyComp, AnyUser, Strings);
end;

procedure TFBIniFile.ReadSectionValues(Strings: TStrings);
begin
  DoReadSectionValues(True, True, FBIniDefSection, Strings);
end;

procedure TFBIniFile.ReadSectionValues(const Section: string;
  Strings: TStrings);
begin
  DoReadSectionValues(True, True, Section, Strings);
end;

procedure TFBIniFile.ReadSectionValues(AnyComp, AnyUser: Boolean;
  const Section: string; Strings: TStrings);
begin
  DoReadSectionValues(AnyComp, AnyUser, Section, Strings);
end;


procedure TFBIniFile.EraseSection;
begin
  DoEraseSection(True, True, FBIniDefSection);
end;

procedure TFBIniFile.EraseSection(const Section: string);
begin
  DoEraseSection(True, True, Section);
end;

procedure TFBIniFile.EraseSection(AnyComp, AnyUser: Boolean;
  const Section: string);
begin
  DoEraseSection(AnyComp, AnyUser, Section);
end;

procedure TFBIniFile.DeleteKey(const Key: String);
begin
  DoDeleteKey(True, True, FBIniDefSection, Key);
end;

procedure TFBIniFile.DeleteKey(const Section, Key: String);
begin
  DoDeleteKey(True, True, Section, Key);
end;

procedure TFBIniFile.DeleteKey(AnyComp, AnyUser: Boolean; const Section,
  Key: String);
begin
  DoDeleteKey(AnyComp, AnyUser, Section, Key);
end;


procedure TFBIniFile.WriteStream(AnyComp, AnyUser: Boolean; const Section,
  Key: String; AStream: TStream);
begin
  DoWriteStream(AnyComp, AnyUser, Section, Key, AStream);
end;

procedure TFBIniFile.WriteStream(const Section, Key: String; AStream: TStream);
begin
  DoWriteStream(True, True, Section, Key, AStream);
end;

procedure TFBIniFile.WriteStream(Key: String; AStream: TStream);
begin
  DoWriteStream(True, True, FBIniDefSection, Key, AStream);
end;

function TFBIniFile.ReadStream(AnyComp, AnyUser: Boolean; const Section,
  Key: String; AStream: TStream): Boolean;
begin
  Result := DoReadStream(AnyComp, AnyUser, Section, Key, AStream);
end;

function TFBIniFile.ReadStream(const Section, Key: String; AStream: TStream): Boolean;
begin
  Result := DoReadStream(True, True, Section, Key, AStream);
end;

function TFBIniFile.ReadStream(Key: String; AStream: TStream): Boolean;
begin
  Result := DoReadStream(True, True, FBIniDefSection, Key, AStream);
end;


procedure TFBIniFile.WriteText(AnyComp, AnyUser: Boolean; const Section,
  Key: String; Value: string);
begin
  DoWriteText(AnyComp, AnyUser, Section, Key, Value);
end;

procedure TFBIniFile.WriteText(const Section, Key: String; Value: string);
begin
  DoWriteText(True, True, Section, Key, Value);
end;

procedure TFBIniFile.WriteText(Key, Value: string);
begin
  DoWriteText(True, True, FBIniDefSection, Key, Value);
end;

function TFBIniFile.ReadText(AnyComp, AnyUser: Boolean; const Section,
  Key: String; Default: String): string;
begin
  Result := DoReadText(AnyComp, AnyUser, Section, Key, Default);
end;

function TFBIniFile.ReadText(const Section, Key: String;
  Default: String): string;
begin
  Result := DoReadText(True, True, Section, Key, Default);
end;

function TFBIniFile.ReadText(Key, Default: String): string;
begin
  Result := DoReadText(True, True, FBIniDefSection, Key, Default);
end;

procedure TFBIniFile.WriteBinaryData(AnyComp, AnyUser: Boolean; const Section,
  Key: string; const Buffer; BufSize: Integer);
begin
  DoWriteBinaryData(AnyComp, AnyUser, Section, Key, Buffer, BufSize);
end;

procedure TFBIniFile.WriteBinaryData(const Section, Key: string; const Buffer;
  BufSize: Integer);
begin
  DoWriteBinaryData(True, True, Section, Key, Buffer, BufSize);
end;

procedure TFBIniFile.WriteBinaryData(Key: string; const Buffer;
  BufSize: Integer);
begin
  DoWriteBinaryData(True, True, FBIniDefSection, Key, Buffer, BufSize);
end;

function TFBIniFile.ReadBinaryData(AnyComp, AnyUser: Boolean; const Section,
  Key: string; var Buffer; BufSize: Integer): Integer;
begin
  Result := DoReadBinaryData(AnyComp, AnyUser, Section, Key, Buffer, BufSize);
end;

function TFBIniFile.ReadBinaryData(const Section, Key: string; var Buffer;
  BufSize: Integer): Integer;
begin
  Result := DoReadBinaryData(True, True, Section, Key, Buffer, BufSize);
end;

function TFBIniFile.ReadBinaryData(Key: string; var Buffer;
  BufSize: Integer): Integer;
begin
  Result := DoReadBinaryData(True, True, FBIniDefSection, Key, Buffer, BufSize);
end;


function TFBIniFile.SectionExists(AnyComp, AnyUser: Boolean;
  const Section: string): Boolean;
begin
  Result := DoSectionExists(AnyComp, AnyUser, Section);
end;

function TFBIniFile.SectionExists(const Section: string): Boolean;
begin
  Result := DoSectionExists(True, True, Section);
end;

function TFBIniFile.SectionExists: Boolean;
begin
  Result := DoSectionExists(True, True, FBIniDefSection);
end;

function TFBIniFile.ValueExists(AnyComp, AnyUser: Boolean; const Section,
  Key: string): Boolean;
begin
  Result := DoValueExists(AnyComp, AnyUser, Section, Key);
end;

function TFBIniFile.ValueExists(const Section, Key: string): Boolean;
begin
  Result := DoValueExists(True, True, Section, Key);
end;

function TFBIniFile.ValueExists(Key: string): Boolean;
begin
  Result := DoValueExists(True, True, FBIniDefSection, Key);
end;

procedure TFBIniFile.WriteDate(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: TDateTime);
begin
  DoWriteDate(AnyComp, AnyUser, Section, Key, Value);
end;

procedure TFBIniFile.WriteDate(const Section, Key: string; Value: TDateTime);
begin
  DoWriteDate(True, True, Section, Key, Value);
end;

procedure TFBIniFile.WriteDate(Key: string; Value: TDateTime);
begin
  DoWriteDate(True, True, FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.WriteTime(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Value: TDateTime);
begin
  DoWriteTime(AnyComp, AnyUser, Section, Key, Value);
end;

procedure TFBIniFile.WriteTime(const Section, Key: string; Value: TDateTime);
begin
  DoWriteTime(True, True, Section, Key, Value);
end;

procedure TFBIniFile.WriteTime(Key: string; Value: TDateTime);
begin
  DoWriteTime(True, True, FBIniDefSection, Key, Value);
end;


function TFBIniFile.ReadDate(Key: string; Default: TDateTime): TDateTime;
begin
  Result := DoReadDate(True, True, FBIniDefSection, Key, Default);
end;

function TFBIniFile.ReadDate(const Section, Key: string;
  Default: TDateTime): TDateTime;
begin
  Result := DoReadDate(True, True, Section, Key, Default);
end;

function TFBIniFile.ReadDate(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: TDateTime): TDateTime;
begin
  Result := DoReadDate(AnyComp, AnyUser, Section, Key, Default);
end;

function TFBIniFile.ReadTime(Key: string; Default: TDateTime): TDateTime;
begin
  Result := DoReadTime(True, True, FBIniDefSection, Key, Default);
end;

function TFBIniFile.ReadTime(const Section, Key: string;
  Default: TDateTime): TDateTime;
begin
  Result := DoReadTime(True, True, Section, Key, Default);
end;

function TFBIniFile.ReadTime(AnyComp, AnyUser: Boolean; const Section,
  Key: string; Default: TDateTime): TDateTime;
begin
  Result := DoReadTime(AnyComp, AnyUser, Section, Key, Default);
end;

end.
