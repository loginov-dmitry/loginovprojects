{
Copyright (c) 2012-2013,  Loginov Dmitry Sergeevich
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
{ ������ fbTypes - �������� ���������� ����� � �������� ��� ���������� fbUtils}
{ (c) 2012 ������� ������� ���������                                          }
{ ��������� ����������: 30.04.2012                                            }
{ �������������� �� D7, D2007, D2010, D-XE2                                   }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

unit fbTypes;

interface

uses
  SysUtils, Classes, IBDatabase;

type
  PIBTransaction = ^TIBTransaction;

  { ���� ����������. ����������� ������ �������� ����� ������������ ����
    ����������. ���� ����� ������� ������������ trDef (������������� trRCRW).
    ��� ���������� ������� ������������� ������������ trSSRW, ��������� �������������,
    ��� � ����� �� ������� ������� ����� ������, ������� ����� ��������� � ��
    ����� ������ ����������. ��� ������������� �� ������ �������� ��������������
    ���� ����������. }
  TTransactionType = (
    trNone,  // ���������� �����������
    trDef,   // "�������" ����������, �� ��, ��� � trRCRW
    trRCRO,  // READ COMMITED READ ONLY
    trRCRW,  // READ COMMITED READ WRITE (NO WAIT)
    trRCRWW, // READ COMMITED READ WRITE, WAIT
    trSSRW); // SNAP SHOT READ WRITE

  {callback-��������� ��� ���������� ��������� ��������������/�������������� ��}
  TBackupRestoreProgressProc = procedure(ALastMsg: string; var Stop: Boolean) of object;

  {����� �������������� �� Firebird}
  TFBBackupOption = (IgnoreChecksums, IgnoreLimbo, MetadataOnly, NoGarbageCollection,
    OldMetadataDesc, NonTransportable, ConvertExtTables);
  TFBBackupOptions = set of TFBBackupOption;

  {����� �������������� �� Firebird}
  TFBRestoreOption = (DeactivateIndexes, NoShadow, NoValidityCheck, OneRelationAtATime,
    Replace, CreateNewDB, UseAllSpace, ValidationCheck);
  TFBRestoreOptions = set of TFBRestoreOption;

  TFBConnectionParams = record
    cpServerName: string; // ��� �������, �� ������� �������� ���� Firebird (��� ��� IP-�����)
    cpPort: Integer;      // ����, �� ������� ��������� ���� Firebird. �� ��������� = 3050
    cpDataBase: string;   // ������ ��� ����� �� (������������ ���������� ����������) ��� ��� �����
    cpUserName: string;   // ��� ������������ ��� ����������� � ��. �� ��������� =  SYSDBA
    cpPassword: string;   // ������ ��� ����������� � ��. �� ��������� =  masterkey
    cpCharSet: string;    // ������� ��������, ������������ ��� ����������� � ��.
                          // ������������� ��������� �� �� ����� ��������, � �������
                          // ������� ���� ������� ���� ������. ������: WIN1251
  end;

  {��������� ��� ������ fbUtilsDBStruct.pas}
  TFBNotNull = (CanNull, NotNull);                     // ���������, ������������, �������� �� NOT NULL ��� ���
  TFBSorting = (Ascending, Descending);                // ���������� ��� ��������: �� �����������, �� ��������
  TFBTriggerEventTime = (trBefore, trAfter);           // ������ ������������ ��������: �� ����������� / ����� �����������
  TFBTriggerEvent = (trInsert, trUpdate, trDelete);    // �������, �� ������� ����������� �������
  TFBTriggerEvents = set of TFBTriggerEvent;           // ��������� �������, �� ������� ������ ����������� �������
  TFBTriggerState = (trsNone, trsActive, trsInactive); // ��������� ��������: ����������� / �������� / ����������

  { ������� ��� ������ � ���. ���������� � TLDSLogger }
  TFBLogEvent = (tlpNone, tlpInformation, tlpError, tlpCriticalError,
                 tlpWarning, tlpEvent, tlpDebug, tlpOther);

  { callback-��������� ��� ������������ ������� }
  TFBLogEventsProc = procedure(Msg: string; LogEvent: TFBLogEvent);

const
  FBDefDB  = 'Default Database Profile'; // ��� ������� ��� ���� ������ �� ���������
  FBDefServer   = 'LOCALHOST'; // ������ �� ���������
  FBLocalServer = '';          // ��� LOCAL-����������� ��� ������� �� �����������
  FBDefPort     =  3050;       // ���� �� ���������
  FBLocalPort   = 0;           // ��� LOCAL-����������� ���� �� �����������
  FBDefUser     = 'SYSDBA';    // ��� ������������ Firebird �� ���������
  FBDefPassword = 'masterkey'; // ������ ������������ Firebird �� ���������

  FBTrustUser   = '';          // ��� ������������ ��� ������������� ���������� Windows
  FBTrustPassword = '';

  FBDefCharSet  = '';          // ��������� �� ��������� (�� ��������� - �� ������)
  FBRusCharSet  = 'WIN1251';   // ��������� ��� ������� ������� ��������
  FBDefPageSize = 8192;        // ������ �������� �� �� ���������

  FBDefParamCheck = True;      // �� ��������� �������� ���������� - �������� (��� ���������� ����� �� ��������)

  FBPoolConnectionMaxTime = 60; // ������������ ����� ����� �������������� ����������� � ����, ���

  FBDefBackupOptions: TFBBackupOptions = [];              // ����� �������������� �� �� ���������
  FBDefRestoreOptions: TFBRestoreOptions = [CreateNewDB]; // ����� �������������� �� �� ���������

  {��������� ��� ������ fbUtilsIniFiles}
  FBIniTableConfigParams = 'CONFIGPARAMS'; // ������� � ���������������� �����������
  FBIniFieldFileName     = 'FILENAME';     // ��� INI-����� ����� (�� ��������� - CONF)
  FBIniDefFileName       = 'CONF';         // ��� ����� �� ���������
  FBIniFieldComputerName = 'COMPUTERNAME'; // ��� ����������, �� ������� ������ ���������� ��������
  FBIniFieldUserName     = 'USERNAME';     // ��� ������������, ��� �������� ������������ ������ ��������
  FBIniFieldSectionName  = 'SECTIONNAME';  // ������������ ������ (���������� ���-������)
  FBIniDefSection        = 'PARAMS';       // �������� ��� ���� "������������ ������" �� ���������

  FBIniFieldParamName    = 'PARAMNAME';    // ������������ ���������
  FBIniFieldParamValue   = 'PARAMVALUE';   // �������� ���������
  FBIniFieldParamBlob    = 'PARAMBLOB';    // BLOB-�������� ��������� (��� ������� �������� ��������)
  FBIniFieldParamBlobHash = 'PARAMBLOBHASH'; // ��������� ���� ��� �������� ���� ��������� ������� (hash1$hash2)
  FBIniFieldModifyDate   = 'MODIFYDATE';   // ���� � ����� ��������� ������
  FBIniFieldModifyUser   = 'MODIFYUSER';   // ��� ������������, ������� ���� ���������
  FBIniCheckBlobHash     = True;           // ����������, ������� �� ��������� ��� ��� BLOB-�����



var
  { ��������� �������������� ����/������� � ������������ ����� }
  FBFormatSettings: TFormatSettings;
  TransactionParams: array[TTransactionType] of string =
    ('',
     'read_committed'#13#10'rec_version'#13#10'nowait',  // READ COMMITED READ WRITE (NO WAIT)
     'read_committed'#13#10'rec_version'#13#10'nowait'#13#10'read', // READ COMMITED READ ONLY
     'read_committed'#13#10'rec_version'#13#10'nowait',  // READ COMMITED READ WRITE (NO WAIT)
     'read_committed'#13#10'rec_version'#13#10'wait',    // READ COMMITED READ WRITE, WAIT
     'concurrency'#13#10'nowait');                       // SNAP SHOT READ WRITE

implementation

procedure FBUpdateFormatSettings;
begin
  GetLocaleFormatSettings(0, FBFormatSettings);
  FBFormatSettings.LongDateFormat := 'yyyy/mm/dd';
  FBFormatSettings.ShortDateFormat := 'yyyy/mm/dd';
  FBFormatSettings.LongTimeFormat := 'hh:nn:ss.zzz';
  FBFormatSettings.ShortTimeFormat := 'hh:nn:ss.zzz';
  FBFormatSettings.DateSeparator := '-';
  FBFormatSettings.TimeSeparator := ':';
  FBFormatSettings.DecimalSeparator := '.';
end;

initialization
  FBUpdateFormatSettings;
finalization

end.
