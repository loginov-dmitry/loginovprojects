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
{ ������ ibxFBUtils - ������������ ������ ��� ���������� ������� IBXFBUtils   }
{ (c) 2012-2013 ������� ������� ���������                                     }
{ ������ ���������� �������: 24.03.2012                                       }
{ ��������� ����������: 09.05.2012                                            }
{ �������������� �� D7, D2007, D2010, D-XE2 (32-���������)                    }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{
���������� IBXFBUtils �������� �������, ������������ ������� �����������
������ � ������ ������ Firebird.
���������� �������� �� ����������� Interbase Express (IBE).
����� ��������������� � EXE, ���� � ����� BPL, ���� � DLL.

���������� � DLL (fbUtils.dll) ����� ����� ��� ���������� �������� ���������������
���������� � ��������� ��������� ����� ����� ������������ ���� � ������������
������ � ���������� �������� ���������� IBXFBUtils �� ������ ��������� ������.
��� ������������� fbUtils.dll:
- DLL ������ ���� �������������� � ��� �� ������ Delphi, ��� � EXE
- ������ ���� �������� ����� ���������� FBUTILSDLL (��. ����������� � ������ fbUtilsBase)
- DLL � EXE ������ ���� �������������� � run-time �������� BPL. ibxpress - �����������!
- � EXE (� ������ Uses) ������ ���� ������� ������ fbUtils � fbTypes
- ���������� �� ����� ��������, ���� ���-�� ������� �� ���������. �� ������� ������� ������.

��������! ���� �� ����������� DELPHI 7, �� ����������� �������� ���������� IBX,
����� ������ ����� ���� �� ����������������.
������ ��� ����������: http://ibase.ru/ibx/ibxdp711.zip

��������! �� �� ������ �������� � �� FIREBIRD, ���� ������������ 64-���������
���������� (��������������� ��-�� ����������� IBX)!

� ������ ������ - ������ ������������ �������, ��� ����������.

� ������ ������ ����������� ��������� ����������� ��� ������ �������. ��������
����������� � ��� ������, � ������� ����������� ��������������� �������.

��� ������ ��� ������� ��������� � �������� "fb" ������ TfbUtils.

��� ��������� ��������� (��� ������������) ��������� � ������� resourcestring, �������
��� ����������� ���������� ����������� ����������� �������� ���������� Delphi.

����� �������� � �� Firebird ������ ���� �������� ��-���������. ���� ����� ����
�� ������, �� ���������� fbUtils ������ ����� ��������� � ���� ��������.

����� ������� ������ ������������� ������������ � ������ ibxfbutils.html
}

{$IFDEF WIN64}
���������� IBX �� ����� �������� � �� FIREBIRD � 64-��������� ����������!
{$ENDIF}

unit ibxFBUtils;

interface
uses
  Windows, SysUtils, Classes, IBDatabase, IBCustomDataSet, fbTypes;

type
  TfbPool = class(TObject)
  public
    {��������� ��������� ����������� � ������� � ��������� ������}
    procedure AddConnectionProfile(AProfileName: string; AServerName: string; APort: Integer;
      ADataBase: string; AUserName: string; APassword: string; ACharSet: string);

    {��������� ��������� ����������� � ������� "�� ���������"}
    procedure AddDefaultConnectionProfile(AServerName: string; APort: Integer;
      ADataBase: string; AUserName: string; APassword: string; ACharSet: string);

    {�������� ����������� �� ���� �� ����� �������}
    function GetConnection(AProfileName: string; ReadTran: PIBTransaction = nil; WriteTran: PIBTransaction = nil;
      ReadTranType: TTransactionType = trRCRO; WriteTranType: TTransactionType = trRCRW): TIBDatabase; overload;

    {�������� ����������� �� ���� �� ��������� ����������}
    function GetConnection(AServerName: string; APort: Integer; ADataBase: string;
      AUserName: string; APassword: string; ACharSet: string; ReadTran: PIBTransaction = nil;
      WriteTran: PIBTransaction = nil; ReadTranType: TTransactionType = trRCRO;
      WriteTranType: TTransactionType = trRCRW): TIBDatabase; overload;

    {�������� ����������� �� ���� ��� ������� "�� ���������"}
    function GetDefaultConnection(ReadTran: PIBTransaction = nil; WriteTran: PIBTransaction = nil;
      ReadTranType: TTransactionType = trRCRO; WriteTranType: TTransactionType = trRCRW): TIBDatabase;

    {���������� �������� ����������� ������� � ���}
    procedure ReturnConnection(FDB: TIBDatabase);

    { ���������� ���������� ����������� � ���� }
    function GetPoolSize: Integer;
  end;

  TfbBackupRestore = class(TObject)
  public
    {������������ �������������� ���� ������ ���������� Firebird Service-API}
    procedure BackupDatabaseOnServer(AServerName: string; APort: Integer; ADBName, ABackupFile,
      AUser, APassw: string; ABackupOptions: TFBBackupOptions; AProgressProc: TBackupRestoreProgressProc);

    {������������ �������������� ���� ������ � �������� ���� ��������� ����� � �������
     �� ��������� �������.}
    procedure BackupDatabaseAndCopyFromServer(AServerName: string; APort: Integer; ADBName, ABackupFile,
      AUser, APassw: string; ABackupOptions: TFBBackupOptions; AProgressProc: TBackupRestoreProgressProc;
      ASourBackupFileOnServer, ADestBackupFileOnClient: string; TryDeleteSourBackupFile: Boolean);

    {������������ �������������� ���� ������ ���������� Firebird Service-API}
    procedure RestoreDatabaseOnServer(AServerName: string; APort: Integer; ADBName, ABackupFile,
      AUser, APassw: string; ARestoreOptions: TFBRestoreOptions; AProgressProc: TBackupRestoreProgressProc);

    {�������� ���� ��������� ����� �� ������ � ���������� �������������� ���� ������}
    procedure CopyBackupToServerAndRestoreDatabase(AServerName: string; APort: Integer; ADBName, ABackupFile,
      AUser, APassw: string; ARestoreOptions: TFBRestoreOptions; AProgressProc: TBackupRestoreProgressProc;
      ABackupFileOnClient, ABackupFileOnServer: string; TryDeleteBackupFileOnClient,
      TryDeleteBackupFileOnServer: Boolean);
  end;

  {��������! TFBIniFile - ����������� �����. ������������ ������� ������������ ���� ����� ������ �����
   ������� ��������. �� ��������� ��������� �������.
   ������ ��������� ������ ����� ��������: ini := TFBIniFile.Create(). ������ �����
   ������� ������������ ������: ini := fb.Ini.CreateIni(False)}
  TFBIniFile = class(TObject)
  protected
    { == ����������� ����������� �������. �� ������� ��! == }
    function GetUserName: string; virtual; abstract;
    procedure SetUserName(const Value: string); virtual; abstract;
    function GetComputerName: string; virtual; abstract;
    procedure SetComputerName(const Value: string); virtual; abstract;
    function GetPoolProfileName: string; virtual; abstract;
    procedure SetPoolProfileName(const Value: string); virtual; abstract;

    procedure DoWriteString(AnyComp, AnyUser: Boolean; const Section, Key, Value: String); virtual; abstract;
    procedure DoWriteInteger(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Integer); virtual; abstract;
    procedure DoWriteBool(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Boolean); virtual; abstract;
    procedure DoWriteFloat(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: Double); virtual; abstract;
    procedure DoWriteDateTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: TDateTime); virtual; abstract;
    procedure DoWriteDate(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: TDateTime); virtual; abstract;
    procedure DoWriteTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Value: TDateTime); virtual; abstract;

    function DoReadString(AnyComp, AnyUser: Boolean; const Section, Key, Default: String): string; virtual; abstract;
    function DoReadInteger(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: Integer): Integer; virtual; abstract;
    function DoReadBool(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: Boolean): Boolean; virtual; abstract;
    function DoReadFloat(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: Double): Double; virtual; abstract;
    function DoReadDateTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: TDateTime): TDateTime; virtual; abstract;
    function DoReadDate(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: TDateTime): TDateTime; virtual; abstract;
    function DoReadTime(AnyComp, AnyUser: Boolean; const Section, Key: string; Default: TDateTime): TDateTime; virtual; abstract;

    procedure DoWriteStream(AnyComp, AnyUser: Boolean; const Section, Key: String; AStream: TStream); virtual; abstract;
    function DoReadStream(AnyComp, AnyUser: Boolean; const Section, Key: String; AStream: TStream): Boolean; virtual; abstract;

    procedure DoWriteText(AnyComp, AnyUser: Boolean; const Section, Key: String; Value: string); virtual; abstract;
    function DoReadText(AnyComp, AnyUser: Boolean; const Section, Key: String; Default: String): string; virtual; abstract;

    procedure DoWriteBinaryData(AnyComp, AnyUser: Boolean; const Section, Key: string; const Buffer; BufSize: Integer); virtual; abstract;
    function DoReadBinaryData(AnyComp, AnyUser: Boolean; const Section, Key: string; var Buffer; BufSize: Integer): Integer; virtual; abstract;

    procedure DoReadSection(AnyComp, AnyUser: Boolean; const Section: string; Strings: TStrings); virtual; abstract;
    procedure DoReadSections(AnyComp, AnyUser: Boolean; Strings: TStrings); virtual; abstract;
    procedure DoReadSectionValues(AnyComp, AnyUser: Boolean; const Section: string; Strings: TStrings); virtual; abstract;
    function DoSectionExists(AnyComp, AnyUser: Boolean; const Section: string): Boolean; virtual; abstract;
    function DoValueExists(AnyComp, AnyUser: Boolean; const Section, Key: string): Boolean; virtual; abstract;
    procedure DoEraseSection(AnyComp, AnyUser: Boolean; const Section: string); virtual; abstract;
    procedure DoDeleteKey(AnyComp, AnyUser: Boolean; const Section, Key: String); virtual; abstract;
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
    { ������������� ��������� ����������� � ���� ������. ���� ������� ��� �������
      (�������� PoolProfileName), �� ������������ ��������� �� ����������� }
    procedure SetConnectionParams(AServerName: string; APort: Integer; ADataBase: string;
      AUserName: string; APassword: string; ACharSet: string); virtual; abstract;

    { ������ ������ � �������� (�������� - ��� �������� ������ / ������) }
    procedure BeginWork; virtual; abstract;

    { ��������� ������ � �������� }
    procedure EndWork; virtual; abstract;

    { ��������� ������� ��� ������������ (�� ��������� ������� ��� �������� ������������ Windows) }
    property UserName: string read GetUserName write SetUserName;

    { ��������� ������� ��� ���������� (�� ��������� ������� ��� �������� ����������) }
    property ComputerName: string read GetComputerName write SetComputerName;

    { ��������� ������� ��� ������� �� ���� ����������� (�� ��������� ������� FBDefDB) }
    property PoolProfileName: string read GetPoolProfileName write SetPoolProfileName;
  end;

  { ��������������� ����� ��� �������� �������� TFBIniFile. �������������� ��������
    ���������� ���������� DefIni }
  TfbIniCreator = class(TObject)
  private
    FDefIni: TFBIniFile;
  public
    {���������� ����������. ����� �� �������������� ���������� ������� ��������� CreateDefIni}
    property DefIni: TFBIniFile read FDefIni;

    {������� ������ TFBIniFile � ���������� ������ �� ����.
     ��������! ���� �� ������� ������ � ������� CreateIni, �� ������ ��������������
     ��� ���������� (� ������� FreeIni)}
    function CreateIni(AFileName: string = FBIniDefFileName; PoolProfileName: string = FBDefDB; AlwaysConnected: Boolean = False): TFBIniFile; overload;

    {������� ������ TFBIniFile. ������� ������� ��������� ����������� � ��}
    function CreateIni(AServerName: string; APort: Integer; ADataBase: string; AUserName: string; APassword: string;
      ACharSet: string; AFileName: string = FBIniDefFileName; AlwaysConnected: Boolean = False): TFBIniFile; overload;

    {���������� �������� ������ TFBIniFile}
    procedure FreeIni(Ini: TFBIniFile);

    {������� ���������� ������ DefIni}
    procedure CreateDefIni(AFileName: string = FBIniDefFileName; PoolProfileName: string = FBDefDB; AlwaysConnected: Boolean = False); overload;

    {������� ���������� ������ DefIni. ������� ������� ��������� ����������� � ��}
    procedure CreateDefIni(AServerName: string; APort: Integer; ADataBase: string; AUserName: string; APassword: string;
      ACharSet: string; AFileName: string = FBIniDefFileName; AlwaysConnected: Boolean = False); overload;

    {���������� ������ DefIni}
    procedure FreeDefIni;

    destructor Destroy; override;
  end;

  {����������� ����� �������� ��������� �������}
  TfbTableDesc = class
  private {����������� �������}
    procedure SetUseModifyDate(Value: TFBTriggerState); virtual; abstract;
    function GetUseModifyDate: TFBTriggerState; virtual; abstract;
  public {����������� �������}

    { �������� �������� ���� ���� ������ }
    procedure AddField(AName, AType, ADefault: string; NotNull: TFBNotNull); virtual; abstract;

    { ������������� ��������� ���� ������� }
    procedure SetPrimaryKey(AName, ConstraintFields: string); virtual; abstract;

    { �������� ������}
    procedure AddIndex(AName: string; IsUnique: Boolean;
      ASorting: TFBSorting; ConstraintFields: string); virtual; abstract;

    { �������� ��������� �������� ��� ������� }
    procedure AddCheck(AName: string; ACheck: string); virtual; abstract;

    { �������� �������. � �������� TriggerName ����� �������� ������ ������. �
      ���� ������ ��� �������� ����� ������������ �������������. � �������� TriggerPos
      (������� ������������ ��������) ������������� �������� > 0 }
    procedure AddTrigger(TriggerEventTime: TFBTriggerEventTime; TriggerEvents: TFBTriggerEvents;
      TriggerPos: Integer; TriggerState: TFBTriggerState; TriggerName: string;
      TriggerVarDesc, TriggerBody: string); virtual; abstract;

    { ��������� ������� ��� �������������� }
    procedure AddAutoIncTrigger(ATriggerName, AFieldName, AGenName: string; CreateGenerator: Boolean); virtual; abstract;

    { ����������, ������� �� ������������ MODIFYDATE }
    property UseModifyDateTrigger: TFBTriggerState read GetUseModifyDate write SetUseModifyDate;
  end;

  {����������� ����� �������� ��������� ���� ������}
  TfbDataBaseDesc = class
  public {����������� �������}
    { ����� ������ }
    function GetVersion: Integer; virtual; abstract;

    { ��������� �������� ������ }
    procedure AddDomain(AName, AType, ADefault: string; NotNull: TFBNotNull; ACheck: string); virtual; abstract;

    { ��������� �������� ������� }
    function AddTable(TableName: string): TfbTableDesc; virtual; abstract;

    { ��������� ������� ���� }
    procedure AddForeignKey(AName, TableName, ConstraintFields,
      RefTableName, RefConstraintFields: string); virtual; abstract;

    { ��������� ������� ���������� }
    procedure AddGenerator(AName: string; StartValue: Int64); virtual; abstract;

    { ��������� �������� ��������� }
    procedure AddProcedure(AName, InFieldsDesc, OutFieldsDesc, VarDesc, Body: string); virtual; abstract;

    { ��������� ������ ���������� "ERR" }
    procedure AddDefaultException; virtual; abstract;
  end;

  TfbDBStructCreator = class
  private
    FDefDBDesc: TfbDataBaseDesc;
  public
    constructor Create;
    destructor Destroy; override;
  public
    {�������� ��������� �� �� ��������� (������ ���������� ����� ���� ��� ��������
     ������������: ��� �� ����������� ��������� ����������� ���������� ��� ��� �� �����)}
    property DefDBDesc: TfbDataBaseDesc read FDefDBDesc;

    {������� ������ TfbDataBaseDesc (�������� ��������� ���� ������)}
    function CreateDataBaseDesc: TfbDataBaseDesc;

    {���������� ������ TfbDataBaseDesc}
    procedure FreeDataBaseDesc(dbDesc: TfbDataBaseDesc);

    {������� ������ DefDBDesc}
    procedure ReCreateDefDataBaseDesc;

    {���������� ������ DefDBDesc}
    procedure FreeDefDataBaseDesc;

    {������������ �������� � ����������� ��������� ��������� ���� ������}
    procedure CheckDataBaseStruct(fbDataBaseDesc: TfbDataBaseDesc; AServerName: string;
      APort: Integer; ADataBase: string; AUserName: string; APassword: string;
      ACharSet: string; LogProc: TFBLogEventsProc);

    {������������ �������� � ����������� ��������� ��������� ���� ������ ��� DefDBDesc}
    procedure CheckDefDataBaseStruct(AServerName: string;
      APort: Integer; ADataBase: string; AUserName: string; APassword: string;
      ACharSet: string; LogProc: TFBLogEventsProc);
  end;


  TfbUtils = class(TObject)
  private
    FPool: TfbPool;
    FBackupRestore: TfbBackupRestore;
    FIni: TfbIniCreator;
    FDBStruct: TfbDBStructCreator;
    function GetUserName: string;
    procedure SetUserName(const Value: string);
    function GetPassword: string;
    procedure SetPassword(const Value: string);
    procedure InitFBUtils;
  public
    constructor Create;
    destructor Destroy; override;
  public
    {��� �����������}
    property Pool: TfbPool read FPool;

    {�������������� / ��������������}
    property br: TfbBackupRestore read FBackupRestore;

    {������ � Ini-������}
    property Ini: TfbIniCreator read FIni;

    {��������� ��������� ���� ����� (��������� ��������������)}
    property DBStruct: TfbDBStructCreator read FDBStruct;

    {��� ������������ ��� ����������� � ���� ������}
    property UserName: string read GetUserName write SetUserName;

    {������ ������������ ��� ����������� � ���� ������}
    property Password: string read GetPassword write SetPassword;

    {������� ������ ����������� � ���� ������.
     ��������! �� ����������� ������ ������� TIBDataBase.Free. ����������� fb.FreeConnection()}
    function CreateConnection(AServerName: string; APort: Integer; ADataBase: string;
      AUserName, APassword, ACodePage: string; TranType: TTransactionType = trDef;
      DoOpen: Boolean = True; AOwner: TComponent = nil): TIBDataBase;

    {����������� � ���� ������}
    procedure ConnectDB(FDB: TIBDatabase);

    {���������� �� ���� ������}
    procedure DisconnectDB(FDB: TIBDatabase);

    {�������� ������� �����������}
    procedure FreeConnection(FDB: TIBDatabase);

    {������� ��������� � ������������ � �������� TranType }
    function CreateTransaction(FDB: TIBDataBase; TranType: TTransactionType = trDef;
      AutoStart: Boolean = True; AOwner: TComponent = nil): TIBTransaction;

    {������� ����� ������ TIBDataSet}
    function CreateDataSet(FDB: TIBDatabase; FTran: TIBTransaction; TranAutoStart: Boolean = True;
      AOwner: TComponent = nil): TIBDataSet;

    {������� ����� ������ TIBDataSet � ������������� ��������� ���������� ������}
    function CreateAndOpenDataSet(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
      ParamNames: array of string; ParamValues: array of Variant;
      AOwner: TComponent = nil): TIBDataSet;

    {������� ����� ������ TIBDataSet � ��������� SELECT-������ � ����� �������}
    function CreateAndOpenTable(FDB: TIBDatabase; FTran: TIBTransaction;
      ATable, AFilter, AOrder: string;
      ParamNames: array of string; ParamValues: array of Variant;
      AOwner: TComponent = nil): TIBDataSet;

    {��������� ��������� SQL-������}
    procedure ExecQuery(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
      ParamNames: array of string; ParamValues: array of Variant);

    {��������� ������ � ��������� �������}
    procedure UpdateRecord(FDB: TIBDataBase; FTran: TIBTransaction;
      TableName: string; KeyFields: array of string; KeyValues: array of Variant;
      FieldNames: array of string; AFieldValues: array of Variant);

    {���������� ������ � ��������� �������}
    procedure InsertRecord(FDB: TIBDataBase; FTran: TIBTransaction;
      TableName: string; FieldNames: array of string; AFieldValues: array of Variant);

    {�������� ������ �� ��������� �������}
    procedure DeleteRecord(FDB: TIBDataBase; FTran: TIBTransaction;
      TableName: string; KeyFields: array of string; KeyValues: array of Variant);

    {��������� ��� ��������� ������ � ��������� �������}
    procedure UpdateOrInsertRecord(FDB: TIBDataBase; FTran: TIBTransaction;
      TableName: string; FieldNames: array of string; AFieldValues: array of Variant;
      KeyFields: array of string);

    {�������� ��������� ���������� (������������ EXECUTE BLOCK)}
    procedure RecomputeIndexStatistics(FDB: TIBDatabase);

    {����������� �������� ���������� GeneratorName �� IncValue � ���������� ���������� ��������}
    function GenID(FDB: TIBDatabase; GeneratorName: string; IncValue: Integer = 1): Int64;

    {��������� ������� EXECUTE BLOCK � ���������� ����� ������ � ������ OutFieldsDesc}
    function ExecuteBlock(FDB: TIBDataBase; FTran: TIBTransaction; OutFieldsDesc,
      VarDesc, Body: string): TIBDataSet; overload;

    {���������� function ExecuteBlock, �� �� ���������� �������� ����������}
    procedure ExecuteBlock(FDB: TIBDataBase; FTran: TIBTransaction;
      VarDesc, Body: string); overload;

    {���������� ������� ������� ATableName (��� ������ ������ ������� ������� FTran=NIL)}
    procedure ClearTable(FDB: TIBDataBase; FTran: TIBTransaction; ATableName: string; AWhere: string = '';
      GarbageCollection: Boolean = True);

    {���������� ������ ����������. ��� ���������� ����� ����� ������������ ������
     ���� ��������� ���������� FBUTILS.DLL. ��� ����� �������������}
    function GetUtilsVersion: Integer;

  public {��������� �������������� �������}

    {����������� ����/����� � ������ � ������� "yyyy-mm-dd hh:nn:ss.zzz"}
    function DateTimeToString(Value: TDateTime; UseMilliseconds: Boolean = True): string;

    {����������� ���� � ������ � ������� "yyyy-mm-dd"}
    function DateToString(Value: TDateTime): string;

    {����������� ����� � ������ � ������� "hh:nn:ss.zzz"}
    function TimeToString(Value: TDateTime): string;
  end;



var
  { ���������� ���������� ��� ������ � �� Firebird. ��� �� ��������� ���������
    ���� ����������, ������� ���  TfbUtils.}
  fb: TfbUtils;



implementation

{$IFNDEF FBUTILSDLL}
uses fbUtilsBase, fbUtilsPool, fbUtilsBackupRestore, fbUtilsIniFiles,
  fbUtilsDBStruct, fbUtilsCheckDBStruct;
{$ENDIF}

{$IFDEF FBUTILSDLL}
const
  fbUtilsDLL = 'fbUtils.dll'; // ������� ���� ��� DLL (�������� IBXFBUtils.dll) ��� �������������
{$ENDIF}

resourcestring
  FBStrFBUtilsDLLNotFound = '������ "%s" �� ��������. ' + sLineBreak + '� ������� ���������� ��������!';

  FBStrFBUTILSDLLOptionNotFoundInDLL = '������ "%s" ��������, ������ �� ������������� ��� '+
    '��������� FBUTILSDLL. � ������� ���������� ��������!';

  FBStrDifferentPackages = '������ "%s", ���� ���������� ������ �������������� ��� ������ "ibxpress", '+
    '���� ������������ ������ ������ ���������� IBX. � ������� ���������� ��������!';
var
  {$IFDEF FBUTILSDLL}
  fbUtilsHlib: THandle;
  {$ENDIF}

  FModuleName: string;

  {��������� � �������, ������������� � ������ fbUtilsBase}

  FBCreateConnection: function(AServerName: string; APort: Integer; ADataBase: string;
      AUserName, APassword, ACodePage: string; TranType: TTransactionType;
      DoOpen: Boolean; AOwner: TComponent; AModuleName: string): TIBDataBase;

  FBConnectDB: procedure(FDB: TIBDatabase; AModuleName: string);

  FBDisconnectDB: procedure(FDB: TIBDatabase; AModuleName: string);

  FBFreeConnection: procedure(FDB: TIBDatabase; AModuleName: string);

  FBCreateTransaction: function(FDB: TIBDataBase; TranType: TTransactionType; AutoStart: Boolean;
    AOwner: TComponent; AModuleName: string): TIBTransaction;

  FBCreateDataSet: function(FDB: TIBDatabase; FTran: TIBTransaction; TranAutoStart: Boolean;
    AOwner: TComponent; AModuleName: string): TIBDataSet;

  FBCreateAndOpenDataSet: function(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
    ParamNames: array of string; ParamValues: array of Variant;
    AOwner: TComponent; AModuleName: string): TIBDataSet;

  FBCreateAndOpenTable: function(FDB: TIBDatabase; FTran: TIBTransaction;
    ATable, AFilter, AOrder: string;
    ParamNames: array of string; ParamValues: array of Variant;
    AOwner: TComponent; AModuleName: string): TIBDataSet;

  FBExecQuery: procedure(FDB: TIBDatabase; FTran: TIBTransaction; SQL: string;
    ParamNames: array of string; ParamValues: array of Variant; AModuleName: string);

  FBUpdateRecordBase: procedure(FDB: TIBDataBase; FTran: TIBTransaction;
    TableName: string; KeyFields: array of string; KeyValues: array of Variant;
    FieldNames: array of string; AFieldValues: array of Variant; AModuleName: string);

  FBInsertRecordBase: procedure(FDB: TIBDataBase; FTran: TIBTransaction;
    TableName: string; FieldNames: array of string; AFieldValues: array of Variant;
    AModuleName: string);

  FBDeleteRecordBase: procedure(FDB: TIBDataBase; FTran: TIBTransaction;
    TableName: string; KeyFields: array of string; KeyValues: array of Variant;
    AModuleName: string);

  FBUpdateOrInsertRecordBase: procedure (FDB: TIBDataBase; FTran: TIBTransaction;
    TableName: string; FieldNames: array of string; AFieldValues: array of Variant;
    KeyFields: array of string; AModuleName: string);

  FBUtilsVersion: function : Integer;

  FBSetUserName: procedure (AUserName: string);
  FBGetUserName: function: string;
  FBSetPassword: procedure(APassword: string);
  FBGetPassword: function: string;

  FBRecomputeIndexStatistics: procedure(FDB: TIBDatabase; AModuleName: string);

  FBGenID: function(FDB: TIBDatabase; GeneratorName: string; IncValue: Integer; AModuleName: string): Int64;

  FBExecuteBlockFunc: function(FDB: TIBDataBase; FTran: TIBTransaction; OutFieldsDesc,
    VarDesc, Body: string; AModuleName: string): TIBDataSet;

  FBExecuteBlockProc: procedure(FDB: TIBDataBase; FTran: TIBTransaction;
    VarDesc, Body: string; AModuleName: string);

  FBClearTable: procedure(FDB: TIBDataBase; FTran: TIBTransaction; ATableName, AWhere: string;
    GarbageCollection: Boolean; AModuleName: string);

  {$IFDEF FBUTILSDLL}
  FBPackagesIsCorrect: function(IBDBClass: TClass): Boolean;
  {$ENDIF}

  {��������� � �������, ������������� � ������ fbUtilsPool}

  FBPoolAddConnectionProfile: procedure(AProfileName: string; AServerName: string; APort: Integer;
   ADataBase: string; AUserName: string; APassword: string; ACharSet: string; AModuleName: string);

  FBPoolAddDefaultConnectionProfile: procedure(AServerName: string; APort: Integer;
   ADataBase: string; AUserName: string; APassword: string; ACharSet: string; AModuleName: string);

  FBPoolGetConnectionByProfile: function(AProfileName: string; ReadTran, WriteTran: PIBTransaction;
   ReadTranType, WriteTranType: TTransactionType; AModuleName: string): TIBDatabase;

  FBPoolGetConnectionByParams: function(AServerName: string; APort: Integer; ADataBase: string;
   AUserName: string; APassword: string; ACharSet: string; ReadTran, WriteTran: PIBTransaction;
   ReadTranType, WriteTranType: TTransactionType; AModuleName: string): TIBDatabase;

  FBPoolGetDefaultConnection: function(ReadTran, WriteTran: PIBTransaction;
   ReadTranType, WriteTranType: TTransactionType; AModuleName: string): TIBDatabase;

  FBPoolReturnConnection: procedure(FDB: TIBDatabase; AModuleName: string);

  FBPoolGetSize: function: Integer;

  {��������� � �������, ������������� � ������ fbUtilsBackupRestore}

  FBBackupDatabaseOnServer: procedure(AServerName: string; APort: Integer; ADBName, ABackupFile,
    AUser, APassw: string; ABackupOptions: TFBBackupOptions; AProgressProc: TBackupRestoreProgressProc; AModuleName: string);

  FBBackupDatabaseAndCopyFromServer: procedure(AServerName: string; APort: Integer; ADBName, ABackupFile,
    AUser, APassw: string; ABackupOptions: TFBBackupOptions; AProgressProc: TBackupRestoreProgressProc; ASourBackupFileOnServer,
    ADestBackupFileOnClient: string; TryDeleteSourBackupFile: Boolean; AModuleName: string);

  FBRestoreDatabaseOnServer: procedure(AServerName: string; APort: Integer; ADBName, ABackupFile,
    AUser, APassw: string; ARestoreOptions: TFBRestoreOptions; AProgressProc: TBackupRestoreProgressProc; AModuleName: string);

  FBCopyBackupToServerAndRestoreDatabase: procedure(AServerName: string; APort: Integer; ADBName, ABackupFile,
    AUser, APassw: string; ARestoreOptions: TFBRestoreOptions; AProgressProc: TBackupRestoreProgressProc;
    ABackupFileOnClient, ABackupFileOnServer: string; TryDeleteBackupFileOnClient, TryDeleteBackupFileOnServer: Boolean; AModuleName: string);


  {��������� � �������, ������������� � ������ fbUtilsIniFiles}

  FBCreateIniFile: function(AFileName: string; AlwaysConnected: Boolean): TFBIniFile;

  FBFreeIniFile: procedure(Ini: TFBIniFile);

  {��������� � �������, ������������� � ������ fbUtilsDBStruct}

  FBCreateDataBaseDesc: function: TfbDataBaseDesc;
  FBFreeDataBaseDesc: procedure(dbDesc: TfbDataBaseDesc);

  {��������� � �������, ������������� � ������ fbUtilsCheckDBStruct}
  FBCheckDBStruct: procedure(fbDataBaseDesc: TfbDataBaseDesc; AServerName: string;
    APort: Integer; ADataBase: string; AUserName: string; APassword: string;
    ACharSet: string; LogProc: TFBLogEventsProc; AModuleName: string);

{ TfbUtils }

procedure TfbUtils.ClearTable(FDB: TIBDataBase; FTran: TIBTransaction;
  ATableName, AWhere: string; GarbageCollection: Boolean);
begin
  FBClearTable(FDB, FTran, ATableName, AWhere, GarbageCollection, FModuleName);
end;

procedure TfbUtils.ConnectDB(FDB: TIBDatabase);
begin
  FBConnectDB(FDB, FModuleName);
end;

procedure TfbUtils.InitFBUtils;
begin
  { ���������� ��� ����� ��������� ������ }
  FModuleName := ExtractFileName(GetModuleName(HInstance));

  {$IFDEF FBUTILSDLL}
  fbUtilsHlib := LoadLibrary(PChar(fbUtilsDLL));

  if fbUtilsHlib = 0 then
  begin
    // ����� ����� �������� ��������� � �����-������ ���
    MessageBox(GetActiveWindow, PChar(Format(FBStrFBUtilsDLLNotFound, [fbUtilsDLL])), 'Error!', MB_ICONERROR);
    ExitProcess(0); // ������� �� ����������
  end else
  begin
    {��������� ������ �������, �������������� � fbUtilsBase.pas}
    @FBPackagesIsCorrect    := GetProcAddress(fbUtilsHlib, 'ibxFBPackagesIsCorrect');

    if not Assigned(FBPackagesIsCorrect) then
    begin
      MessageBox(GetActiveWindow, PChar(Format(FBStrFBUTILSDLLOptionNotFoundInDLL, [fbUtilsDLL])), 'Error!', MB_ICONERROR);
      ExitProcess(0); // ������� �� ����������
    end;

    if not FBPackagesIsCorrect(TIBDatabase) then
    begin
      MessageBox(GetActiveWindow, PChar(Format(FBStrDifferentPackages, [fbUtilsDLL])), 'Error!', MB_ICONERROR);
      ExitProcess(0); // ������� �� ����������
    end;

    @FBCreateConnection     := GetProcAddress(fbUtilsHlib, 'ibxFBCreateConnection');
    @FBConnectDB         := GetProcAddress(fbUtilsHlib, 'ibxFBConnectDB');
    @FBDisconnectDB      := GetProcAddress(fbUtilsHlib, 'ibxFBDisconnectDB');
    @FBFreeConnection       := GetProcAddress(fbUtilsHlib, 'ibxFBFreeConnection');
    @FBCreateTransaction := GetProcAddress(fbUtilsHlib, 'ibxFBCreateTransaction');
    @FBCreateDataSet        := GetProcAddress(fbUtilsHlib, 'ibxFBCreateDataSet');
    @FBCreateAndOpenDataSet := GetProcAddress(fbUtilsHlib, 'ibxFBCreateAndOpenDataSet');
    @FBCreateAndOpenTable   := GetProcAddress(fbUtilsHlib, 'ibxFBCreateAndOpenTable');
    @FBExecQuery            := GetProcAddress(fbUtilsHlib, 'ibxFBExecQuery');
    @FBUpdateRecordBase     := GetProcAddress(fbUtilsHlib, 'ibxFBUpdateRecordBase');
    @FBInsertRecordBase     := GetProcAddress(fbUtilsHlib, 'ibxFBInsertRecordBase');
    @FBDeleteRecordBase     := GetProcAddress(fbUtilsHlib, 'ibxFBDeleteRecordBase');
    @FBUpdateOrInsertRecordBase  := GetProcAddress(fbUtilsHlib, 'ibxFBUpdateOrInsertRecordBase');
    @FBUtilsVersion         := GetProcAddress(fbUtilsHlib, 'ibxFBUtilsVersion');
    @FBSetUserName          := GetProcAddress(fbUtilsHlib, 'ibxFBSetUserName');
    @FBGetUserName          := GetProcAddress(fbUtilsHlib, 'ibxFBGetUserName');
    @FBSetPassword          := GetProcAddress(fbUtilsHlib, 'ibxFBSetPassword');
    @FBGetPassword          := GetProcAddress(fbUtilsHlib, 'ibxFBGetPassword');
    @FBRecomputeIndexStatistics := GetProcAddress(fbUtilsHlib, 'ibxFBRecomputeIndexStatistics');
    @FBGenID                := GetProcAddress(fbUtilsHlib, 'ibxFBGenID');
    @FBExecuteBlockFunc     := GetProcAddress(fbUtilsHlib, 'ibxFBExecuteBlockFunc');
    @FBExecuteBlockProc     := GetProcAddress(fbUtilsHlib, 'ibxFBExecuteBlockProc');
    @FBClearTable           := GetProcAddress(fbUtilsHlib, 'ibxFBClearTable');

    {��������� ������ �������, �������������� � fbUtilsPool.pas}
    @FBPoolAddConnectionProfile         := GetProcAddress(fbUtilsHlib, 'ibxFBPoolAddConnectionProfile');
    @FBPoolAddDefaultConnectionProfile  := GetProcAddress(fbUtilsHlib, 'ibxFBPoolAddDefaultConnectionProfile');
    @FBPoolGetConnectionByProfile       := GetProcAddress(fbUtilsHlib, 'ibxFBPoolGetConnectionByProfile');
    @FBPoolGetConnectionByParams        := GetProcAddress(fbUtilsHlib, 'ibxFBPoolGetConnectionByParams');
    @FBPoolGetDefaultConnection         := GetProcAddress(fbUtilsHlib, 'ibxFBPoolGetDefaultConnection');
    @FBPoolReturnConnection             := GetProcAddress(fbUtilsHlib, 'ibxFBPoolReturnConnection');
    @FBPoolGetSize                      := GetProcAddress(fbUtilsHlib, 'ibxFBPoolGetSize');

    {��������� ������ �������, �������������� � fbUtilsBackupRestore.pas}
    @FBBackupDatabaseOnServer                := GetProcAddress(fbUtilsHlib, 'ibxFBBackupDatabaseOnServer');
    @FBBackupDatabaseAndCopyFromServer       := GetProcAddress(fbUtilsHlib, 'ibxFBBackupDatabaseAndCopyFromServer');
    @FBRestoreDatabaseOnServer               := GetProcAddress(fbUtilsHlib, 'ibxFBRestoreDatabaseOnServer');
    @FBCopyBackupToServerAndRestoreDatabase  := GetProcAddress(fbUtilsHlib, 'ibxFBCopyBackupToServerAndRestoreDatabase');

    {��������� ������ �������, �������������� � fbUtilsIniFiles.pas}
    @FBCreateIniFile  := GetProcAddress(fbUtilsHlib, 'ibxFBCreateIniFile');
    @FBFreeIniFile    := GetProcAddress(fbUtilsHlib, 'ibxFBFreeIniFile');

    {��������� ������ �������, �������������� � fbUtilsDBStruct.pas}
    @FBCreateDataBaseDesc := GetProcAddress(fbUtilsHlib, 'ibxFBCreateDataBaseDesc');
    @FBFreeDataBaseDesc   := GetProcAddress(fbUtilsHlib, 'ibxFBFreeDataBaseDesc');

    {��������� ������ �������, �������������� � fbUtilsCheckDBStruct.pas}
    @FBCheckDBStruct := GetProcAddress(fbUtilsHlib, 'ibxFBCheckDBStruct');
  end;

  {$ELSE}
    {��������� ������ �������, ������������� � fbUtilsBase.pas}
    @FBCreateConnection     := @fbUtilsBase.FBCreateConnection;
    @FBConnectDB         := @fbUtilsBase.FBConnectDB;
    @FBDisconnectDB      := @fbUtilsBase.FBDisconnectDB;
    @FBFreeConnection       := @fbUtilsBase.FBFreeConnection;
    @FBCreateTransaction := @fbUtilsBase.FBCreateTransaction;
    @FBCreateDataSet        := @fbUtilsBase.FBCreateDataSet;
    @FBCreateAndOpenDataSet := @fbUtilsBase.FBCreateAndOpenDataSet;
    @FBCreateAndOpenTable   := @fbUtilsBase.FBCreateAndOpenTable;
    @FBExecQuery            := @fbUtilsBase.FBExecQuery;
    @FBUpdateRecordBase     := @fbUtilsBase.FBUpdateRecordBase;
    @FBInsertRecordBase     := @fbUtilsBase.FBInsertRecordBase;
    @FBDeleteRecordBase     := @fbUtilsBase.FBDeleteRecordBase;
    @FBUpdateOrInsertRecordBase := @fbUtilsBase.FBUpdateOrInsertRecordBase;
    @FBUtilsVersion         := @fbUtilsBase.FBUtilsVersion;
    @FBSetUserName          := @fbUtilsBase.FBSetUserName;
    @FBGetUserName          := @fbUtilsBase.FBGetUserName;
    @FBSetPassword          := @fbUtilsBase.FBSetPassword;
    @FBGetPassword          := @fbUtilsBase.FBGetPassword;
    @FBRecomputeIndexStatistics := @fbUtilsBase.FBRecomputeIndexStatistics;
    @FBGenID                := @fbUtilsBase.FBGenID;
    @FBExecuteBlockFunc     := @fbUtilsBase.FBExecuteBlockFunc;
    @FBExecuteBlockProc     := @fbUtilsBase.FBExecuteBlockProc;
    @FBClearTable           := @fbUtilsBase.FBClearTable;

    {��������� ������ �������, ������������� � fbUtilsPool.pas}
    @FBPoolAddConnectionProfile         := @fbUtilsPool.FBPoolAddConnectionProfile;
    @FBPoolAddDefaultConnectionProfile  := @fbUtilsPool.FBPoolAddDefaultConnectionProfile;
    @FBPoolGetConnectionByProfile       := @fbUtilsPool.FBPoolGetConnectionByProfile;
    @FBPoolGetConnectionByParams        := @fbUtilsPool.FBPoolGetConnectionByParams;
    @FBPoolGetDefaultConnection         := @fbUtilsPool.FBPoolGetDefaultConnection;
    @FBPoolReturnConnection             := @fbUtilsPool.FBPoolReturnConnection;
    @FBPoolGetSize                      := @fbUtilsPool.FBPoolGetSize;

    {��������� ������ �������, ������������� � fbUtilsBackupRestore.pas}
    @FBBackupDatabaseOnServer                := @fbUtilsBackupRestore.FBBackupDatabaseOnServer;
    @FBBackupDatabaseAndCopyFromServer       := @fbUtilsBackupRestore.FBBackupDatabaseAndCopyFromServer;
    @FBRestoreDatabaseOnServer               := @fbUtilsBackupRestore.FBRestoreDatabaseOnServer;
    @FBCopyBackupToServerAndRestoreDatabase  := @fbUtilsBackupRestore.FBCopyBackupToServerAndRestoreDatabase;

    {��������� ������ �������, ������������� � fbUtilsIniFiles.pas}
    @FBCreateIniFile  := @fbUtilsIniFiles.FBCreateIniFile;
    @FBFreeIniFile    := @fbUtilsIniFiles.FBFreeIniFile;

    {��������� ������ �������, ������������� � fbUtilsDBStruct.pas}
    @FBCreateDataBaseDesc := @fbUtilsDBStruct.FBCreateDataBaseDesc;
    @FBFreeDataBaseDesc   := @fbUtilsDBStruct.FBFreeDataBaseDesc;

    {��������� ������ �������, ������������� � fbUtilsCheckDBStruct.pas}
    @FBCheckDBStruct := @fbUtilsCheckDBStruct.FBCheckDBStruct;
  {$ENDIF}
end;


constructor TfbUtils.Create;
begin
  inherited; {�� ������ ������}
  InitFBUtils;
  FPool := TfbPool.Create;
  FIni := TfbIniCreator.Create;
  FBackupRestore := TfbBackupRestore.Create;
  FDBStruct := TfbDBStructCreator.Create;
end;

function TfbUtils.CreateAndOpenDataSet(FDB: TIBDatabase; FTran: TIBTransaction;
  SQL: string; ParamNames: array of string; ParamValues: array of Variant;
  AOwner: TComponent): TIBDataSet;
begin
  Result := FBCreateAndOpenDataSet(FDB, FTran, SQL, ParamNames, ParamValues, AOwner, FModuleName);
end;

function TfbUtils.CreateAndOpenTable(FDB: TIBDatabase; FTran: TIBTransaction;
  ATable, AFilter, AOrder: string; ParamNames: array of string;
  ParamValues: array of Variant; AOwner: TComponent): TIBDataSet;
begin
  Result := FBCreateAndOpenTable(FDB, FTran, ATable, AFilter, AOrder,
    ParamNames, ParamValues, AOwner, FModuleName);
end;

function TfbUtils.CreateConnection(AServerName: string; APort: Integer; ADataBase: string;
      AUserName, APassword, ACodePage: string; TranType: TTransactionType;
      DoOpen: Boolean; AOwner: TComponent): TIBDataBase;
begin
  Result := FBCreateConnection(AServerName, APort, ADataBase, AUserName, APassword,
    ACodePage, TranType, DoOpen, AOwner, FModuleName);
end;

function TfbUtils.CreateDataSet(FDB: TIBDatabase; FTran: TIBTransaction;
  TranAutoStart: Boolean; AOwner: TComponent): TIBDataSet;
begin
  Result := FBCreateDataSet(FDB, FTran, TranAutoStart, AOwner, FModuleName);
end;

function TfbUtils.CreateTransaction(FDB: TIBDataBase; TranType: TTransactionType;
  AutoStart: Boolean; AOwner: TComponent): TIBTransaction;
begin
  Result := FBCreateTransaction(FDB, TranType, AutoStart, AOwner, FModuleName);
end;

function TfbUtils.DateTimeToString(Value: TDateTime;
  UseMilliseconds: Boolean): string;
begin
  if UseMilliseconds then
    Result := FormatDateTime('yyyy/mm/dd hh:nn:ss.zzz', Value, FBFormatSettings)
  else
    Result := FormatDateTime('yyyy/mm/dd hh:nn:ss', Value, FBFormatSettings)
end;

function TfbUtils.DateToString(Value: TDateTime): string;
begin
  Result := FormatDateTime('yyyy/mm/dd', Value, FBFormatSettings);
end;

procedure TfbUtils.DeleteRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string; KeyValues: array of Variant);
begin
  FBDeleteRecordBase(FDB, FTran, TableName, KeyFields, KeyValues, FModuleName);
end;

destructor TfbUtils.Destroy;
begin
  Pool.Free;
  FBackupRestore.Free;
  FIni.Free;
  FDBStruct.Free;

  {$IFDEF FBUTILSDLL}
  if fbUtilsHlib <> 0 then
    FreeLibrary(fbUtilsHlib);
  {$ENDIF}

  inherited;
end;

procedure TfbUtils.DisconnectDB(FDB: TIBDatabase);
begin
  FBDisconnectDB(FDB, FModuleName);
end;

procedure TfbUtils.ExecQuery(FDB: TIBDatabase; FTran: TIBTransaction;
  SQL: string; ParamNames: array of string; ParamValues: array of Variant);
begin
  FBExecQuery(FDB, FTran, SQL, ParamNames, ParamValues, FModuleName);
end;

function TfbUtils.ExecuteBlock(FDB: TIBDataBase; FTran: TIBTransaction;
  OutFieldsDesc, VarDesc, Body: string): TIBDataSet;
begin
  Result := FBExecuteBlockFunc(FDB, FTran, OutFieldsDesc, VarDesc, Body, FModuleName);
end;

procedure TfbUtils.ExecuteBlock(FDB: TIBDataBase; FTran: TIBTransaction;
  VarDesc, Body: string);
begin
  FBExecuteBlockProc(FDB, FTran, VarDesc, Body, FModuleName);
end;

procedure TfbUtils.FreeConnection(FDB: TIBDatabase);
begin
  FBFreeConnection(FDB, FModuleName);
end;

function TfbUtils.GenID(FDB: TIBDatabase; GeneratorName: string;
  IncValue: Integer): Int64;
begin
  Result := FBGenID(FDB, GeneratorName, IncValue, FModuleName);
end;

function TfbUtils.GetPassword: string;
begin
  Result := FBGetPassword;
end;

function TfbUtils.GetUserName: string;
begin
  Result := FBGetUserName;
end;

function TfbUtils.GetUtilsVersion: Integer;
begin
  Result := FBUtilsVersion;
end;

procedure TfbUtils.InsertRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; FieldNames: array of string;
  AFieldValues: array of Variant);
begin
  FBInsertRecordBase(FDB, FTran, TableName, FieldNames, AFieldValues, FModuleName)
end;

procedure TfbUtils.RecomputeIndexStatistics(FDB: TIBDatabase);
begin
  FBRecomputeIndexStatistics(FDB, FModuleName);
end;

procedure TfbUtils.SetPassword(const Value: string);
begin
  FBSetPassword(Value);
end;

procedure TfbUtils.SetUserName(const Value: string);
begin
  FBSetUserName(Value);
end;

function TfbUtils.TimeToString(Value: TDateTime): string;
begin
  Result := FormatDateTime('hh:nn:ss.zzz', Value, FBFormatSettings);
end;

procedure TfbUtils.UpdateOrInsertRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; FieldNames: array of string;
  AFieldValues: array of Variant; KeyFields: array of string);
begin
  FBUpdateOrInsertRecordBase(FDB, FTran, TableName,
    FieldNames, AFieldValues, KeyFields, FModuleName);
end;

procedure TfbUtils.UpdateRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string;
  KeyValues: array of Variant; FieldNames: array of string;
  AFieldValues: array of Variant);
begin
  FBUpdateRecordBase(FDB, FTran, TableName, KeyFields,
    KeyValues, FieldNames, AFieldValues, FModuleName);
end;

{ TfbPool }

procedure TfbPool.AddConnectionProfile(AProfileName, AServerName: string;
  APort: Integer; ADataBase, AUserName, APassword, ACharSet: string);
begin
  FBPoolAddConnectionProfile(AProfileName, AServerName,
    APort, ADataBase, AUserName, APassword, ACharSet, FModuleName);
end;

procedure TfbPool.AddDefaultConnectionProfile(AServerName: string;
  APort: Integer; ADataBase, AUserName, APassword, ACharSet: string);
begin
  FBPoolAddDefaultConnectionProfile(AServerName,
    APort, ADataBase, AUserName, APassword, ACharSet, FModuleName);
end;

function TfbPool.GetConnection(AServerName: string; APort: Integer; ADataBase,
  AUserName, APassword, ACharSet: string; ReadTran, WriteTran: PIBTransaction;
  ReadTranType, WriteTranType: TTransactionType): TIBDatabase;
begin
  Result := FBPoolGetConnectionByParams(AServerName, APort, ADataBase,
    AUserName, APassword, ACharSet, ReadTran, WriteTran,
    ReadTranType, WriteTranType, FModuleName);
end;

function TfbPool.GetConnection(AProfileName: string; ReadTran,
  WriteTran: PIBTransaction; ReadTranType,
  WriteTranType: TTransactionType): TIBDatabase;
begin
  Result := FBPoolGetConnectionByProfile(AProfileName, ReadTran,
    WriteTran, ReadTranType, WriteTranType, FModuleName);
end;

function TfbPool.GetDefaultConnection(ReadTran, WriteTran: PIBTransaction;
  ReadTranType, WriteTranType: TTransactionType): TIBDatabase;
begin
  Result := FBPoolGetDefaultConnection(ReadTran, WriteTran,
    ReadTranType, WriteTranType, FModuleName);
end;

function TfbPool.GetPoolSize: Integer;
begin
  Result := FBPoolGetSize;
end;

procedure TfbPool.ReturnConnection(FDB: TIBDatabase);
begin
  FBPoolReturnConnection(FDB, FModuleName);
end;


{ TfbBackupRestore }

procedure TfbBackupRestore.BackupDatabaseAndCopyFromServer(AServerName: string;
  APort: Integer; ADBName, ABackupFile, AUser, APassw: string;
  ABackupOptions: TFBBackupOptions; AProgressProc: TBackupRestoreProgressProc;
  ASourBackupFileOnServer, ADestBackupFileOnClient: string;
  TryDeleteSourBackupFile: Boolean);
begin
  FBBackupDatabaseAndCopyFromServer(AServerName, APort, ADBName, ABackupFile,
    AUser, APassw, ABackupOptions, AProgressProc, ASourBackupFileOnServer,
    ADestBackupFileOnClient, TryDeleteSourBackupFile, FModuleName);
end;

procedure TfbBackupRestore.BackupDatabaseOnServer(AServerName: string;
  APort: Integer; ADBName, ABackupFile, AUser, APassw: string;
  ABackupOptions: TFBBackupOptions; AProgressProc: TBackupRestoreProgressProc);
begin
  FBBackupDatabaseOnServer(AServerName, APort, ADBName, ABackupFile,
    AUser, APassw, ABackupOptions, AProgressProc, FModuleName);
end;

procedure TfbBackupRestore.CopyBackupToServerAndRestoreDatabase(
  AServerName: string; APort: Integer; ADBName, ABackupFile, AUser,
  APassw: string; ARestoreOptions: TFBRestoreOptions;
  AProgressProc: TBackupRestoreProgressProc; ABackupFileOnClient,
  ABackupFileOnServer: string; TryDeleteBackupFileOnClient,
  TryDeleteBackupFileOnServer: Boolean);
begin
  FBCopyBackupToServerAndRestoreDatabase(AServerName, APort, ADBName, ABackupFile,
    AUser, APassw, ARestoreOptions, AProgressProc, ABackupFileOnClient,
    ABackupFileOnServer, TryDeleteBackupFileOnClient, TryDeleteBackupFileOnServer, FModuleName);
end;

procedure TfbBackupRestore.RestoreDatabaseOnServer(AServerName: string;
  APort: Integer; ADBName, ABackupFile, AUser, APassw: string;
  ARestoreOptions: TFBRestoreOptions;
  AProgressProc: TBackupRestoreProgressProc);
begin
  FBRestoreDatabaseOnServer(AServerName, APort, ADBName, ABackupFile,
    AUser, APassw, ARestoreOptions, AProgressProc, FModuleName);
end;

{ TFBIniFile }

function TFBIniFile.ReadBool(const Key: string; Default: Boolean): Boolean;
begin
  Result := ReadBool(FBIniDefSection, Key, Default);
end;

function TFBIniFile.ReadDateTime(const Key: string;
  Default: TDateTime): TDateTime;
begin
  Result := ReadDateTime(FBIniDefSection, Key, Default);
end;

function TFBIniFile.ReadFloat(const Key: string; Default: Double): Double;
begin
  Result := ReadFloat(FBIniDefSection, Key, Default);
end;

function TFBIniFile.ReadInteger(const Key: string; Default: Integer): Integer;
begin
  Result := ReadInteger(FBIniDefSection, Key, Default);
end;

function TFBIniFile.ReadString(const Key, Default: String): string;
begin
  Result := ReadString(FBIniDefSection, Key, Default);
end;

procedure TFBIniFile.WriteBool(const Key: string; Value: Boolean);
begin
  WriteBool(FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.WriteDateTime(const Key: string; Value: TDateTime);
begin
  WriteDateTime(FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.WriteFloat(const Key: string; Value: Double);
begin
  WriteFloat(FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.WriteInteger(const Key: string; Value: Integer);
begin
  WriteInteger(FBIniDefSection, Key, Value);
end;

procedure TFBIniFile.WriteString(const Key, Value: String);
begin
  WriteString(FBIniDefSection, Key, Value);
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

{ TfbIniCreator }

function TfbIniCreator.CreateIni(AFileName: string = FBIniDefFileName; PoolProfileName: string = FBDefDB; AlwaysConnected: Boolean = False): TFBIniFile;
begin
  Result := FBCreateIniFile(AFileName, AlwaysConnected);
  Result.PoolProfileName := PoolProfileName;
end;

procedure TfbIniCreator.CreateDefIni(AServerName: string; APort: Integer; ADataBase,
  AUserName, APassword, ACharSet: string; AFileName: string; AlwaysConnected: Boolean);
begin
  FreeDefIni;
  FDefIni := CreateIni(AServerName, APort, ADataBase, AUserName, APassword, ACharSet, AFileName, AlwaysConnected);
end;

function TfbIniCreator.CreateIni(AServerName: string; APort: Integer; ADataBase,
  AUserName, APassword, ACharSet: string; AFileName: string; AlwaysConnected: Boolean): TFBIniFile;
begin
  Result := FBCreateIniFile(AFileName, AlwaysConnected);
  Result.SetConnectionParams(AServerName, APort, ADataBase, AUserName, APassword, ACharSet);
end;

destructor TfbIniCreator.Destroy;
begin
  FreeDefIni;
  inherited;
end;

procedure TfbIniCreator.FreeDefIni;
begin
  if Assigned(DefIni) then
  begin
    FreeIni(DefIni);
    FDefIni := nil;
  end;
end;

procedure TfbIniCreator.FreeIni(Ini: TFBIniFile);
begin
  FBFreeIniFile(Ini);
end;

procedure TfbIniCreator.CreateDefIni(AFileName: string = FBIniDefFileName; PoolProfileName: string = FBDefDB; AlwaysConnected: Boolean = False);
begin
  FreeDefIni;
  FDefIni := CreateIni(AFileName, PoolProfileName, AlwaysConnected);
end;

{ TfbDBStructCreator }

procedure TfbDBStructCreator.CheckDataBaseStruct(fbDataBaseDesc: TfbDataBaseDesc;
  AServerName: string; APort: Integer; ADataBase, AUserName, APassword,
  ACharSet: string; LogProc: TFBLogEventsProc);
begin
  FBCheckDBStruct(fbDataBaseDesc, AServerName, APort, ADataBase, AUserName, APassword, ACharSet, LogProc, FModuleName);
end;

procedure TfbDBStructCreator.CheckDefDataBaseStruct(AServerName: string;
  APort: Integer; ADataBase, AUserName, APassword, ACharSet: string; LogProc: TFBLogEventsProc);
begin
  CheckDataBaseStruct(FDefDBDesc, AServerName, APort, ADataBase, AUserName, APassword, ACharSet, LogProc);
end;

constructor TfbDBStructCreator.Create;
begin
  ReCreateDefDataBaseDesc;
end;

function TfbDBStructCreator.CreateDataBaseDesc: TfbDataBaseDesc;
begin
  Result := FBCreateDataBaseDesc;
end;

destructor TfbDBStructCreator.Destroy;
begin
  FreeDefDataBaseDesc;
  inherited;
end;

procedure TfbDBStructCreator.ReCreateDefDataBaseDesc;
begin
  FreeDefDataBaseDesc; // �� ������ ������
  FDefDBDesc := CreateDataBaseDesc();
end;

procedure TfbDBStructCreator.FreeDataBaseDesc(dbDesc: TfbDataBaseDesc);
begin
  FBFreeDataBaseDesc(dbDesc);
end;

procedure TfbDBStructCreator.FreeDefDataBaseDesc;
begin
  if Assigned(FDefDBDesc) then
  begin
    FreeDataBaseDesc(FDefDBDesc);
    FDefDBDesc := nil;
  end;
end;

initialization
  fb := TfbUtils.Create;
finalization
  fb.Free;
end.
