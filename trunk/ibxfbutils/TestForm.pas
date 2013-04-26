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

unit TestForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, IB, IBDatabase, IBCustomDataSet, StdCtrls, IniFiles,
  ExtCtrls, FileCtrl, fbTypes, ibxFBUtils, fbSomeFuncs;

type
  TForm1 = class(TForm)
    IBTransaction1: TIBTransaction;
    Memo1: TMemo;
    Memo2: TMemo;
    Button2: TButton;
    GroupBox1: TGroupBox;
    edServerName: TEdit;
    edPort: TEdit;
    edFileName: TEdit;
    btnChooseDB: TButton;
    odChooseDB: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edUserName: TEdit;
    Label5: TLabel;
    edPassword: TEdit;
    edCharSet: TEdit;
    Label6: TLabel;
    btnTestConnection: TButton;
    rgSelectTest: TRadioGroup;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    labConnCount: TLabel;
    Timer1: TTimer;
    Label8: TLabel;
    labErrCount: TLabel;
    labThreadCount: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    edSharedPath: TEdit;
    Label11: TLabel;
    btnChooseSharedPath: TButton;
    Label12: TLabel;
    edSharedPathOnServer: TEdit;
    btnChooseSharedPathOnServer: TButton;
    Label13: TLabel;
    labInsCount: TLabel;
    Label15: TLabel;
    Label14: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure btnChooseDBClick(Sender: TObject);
    procedure btnTestConnectionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnChooseSharedPathClick(Sender: TObject);
    procedure btnChooseSharedPathOnServerClick(Sender: TObject);
  private
    { Private declarations }
    ini: TIniFile;
    brtestname: string;
    procedure Log(S: string);

    procedure BackupRestoreProgressProc(ALastMsg: string; var Stop: Boolean);

    procedure AddDefaultConnectionProfile;
  public
    { Public declarations }
    procedure TestFBIniFiles;

    procedure TestRecomputeIndexes;

    {��������� ���������� �� ������������� ��������� ��}
    procedure TestDBCorrectStruct;

    procedure TestBaseFunctions; // ���� ������� �������

    procedure TestWorkingWithPool; // ������������ ������ � ����� �����������

    procedure TestBackupRestore;
  end;

  TTestThread = class(TThread)
  protected
    procedure Execute; override;
  end;

var
  Form1: TForm1;

procedure LogEventsProc(Msg: string; LogEvent: TFBLogEvent);

implementation

{$R *.dfm}

var
  StopThreads: Boolean;
  ErrorCounter: Integer;
  ThreadCounter: Integer;
  InsCounter: Integer;

  sErrInThread: string;

procedure LogEventsProc(Msg: string; LogEvent: TFBLogEvent);
begin
  if Msg <> '' then
    Msg := DateTimeToStr(Now) + ' - ' + Msg;
  Form1.Memo2.Lines.Add(Msg);
end;

procedure TForm1.AddDefaultConnectionProfile;
begin
  fb.Pool.AddDefaultConnectionProfile(edServerName.Text, StrToInt(edPort.Text), edFileName.Text,
    edUserName.Text, edPassword.Text, edCharSet.Text);
end;

procedure TForm1.BackupRestoreProgressProc(ALastMsg: string; var Stop: Boolean);
begin
  Memo2.Lines.Add(brtestname + ':' + ALastMsg);
end;

procedure TForm1.btnChooseDBClick(Sender: TObject);
begin
  odChooseDB.FileName := edFileName.Text;
  if odChooseDB.Execute then
    edFileName.Text := odChooseDB.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  // ���������� ��������� ����������� � ������� �� ���������
  AddDefaultConnectionProfile;

  case rgSelectTest.ItemIndex of
    0: ShowMessage('������ ����� �� ����������!');
    1: TestDBCorrectStruct;
    2: TestFBIniFiles;
    3: TestRecomputeIndexes;
    4: TestBaseFunctions;
    5: TestWorkingWithPool;
    6: TestBackupRestore;
  end;


end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ThreadCounter > 0 then
  begin
    CanClose := False;
    ShowMessage('������� ���������� ���. ������');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  edServerName.Text := ini.ReadString('DB', 'ServerName', 'LOCALHOST');
  edPort.Text := ini.ReadString('DB', 'Port', '3050');
  edFileName.Text := ini.ReadString('DB', 'FileName', 'C:\DB\MyDB.fdb');
  edUserName.Text := ini.ReadString('DB', 'UserName', 'SYSDBA');
  edPassword.Text := ini.ReadString('DB', 'Password', 'masterkey');
  edCharSet.Text := ini.ReadString('DB', 'CharSet', 'WIN1251');

  edSharedPath.Text := ini.ReadString('DB', 'SharedPath', '\\VBOXSVR\Shared\TEMP\');
  edSharedPathOnServer.Text := ini.ReadString('DB', 'SharedPathOnServer', 'f:\�����\TEMP\');

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ini.WriteString('DB', 'ServerName', edServerName.Text);
  ini.WriteString('DB', 'Port', edPort.Text);
  ini.WriteString('DB', 'FileName', edFileName.Text);
  ini.WriteString('DB', 'UserName', edUserName.Text);
  ini.WriteString('DB', 'Password', edPassword.Text);
  ini.WriteString('DB', 'CharSet', edCharSet.Text);

  ini.WriteString('DB', 'SharedPath', edSharedPath.Text);
  ini.WriteString('DB', 'SharedPathOnServer', edSharedPathOnServer.Text);

  ini.Free;
end;

procedure TForm1.btnChooseSharedPathClick(Sender: TObject);
var
  S: string;
begin
  S := edSharedPath.Text;
  if SelectDirectory('�������� �������', '', S) then
    edSharedPath.Text := S;
end;

procedure TForm1.btnChooseSharedPathOnServerClick(Sender: TObject);
var
  S: string;
begin
  S := edSharedPathOnServer.Text;
  if SelectDirectory('�������� �������', '', S) then
    edSharedPathOnServer.Text := S;
end;

procedure TForm1.btnTestConnectionClick(Sender: TObject);
var
  fdb: TIBDatabase;
begin
  fdb := fb.CreateConnection(edServerName.Text, StrToInt(edPort.Text), edFileName.Text,
    edUserName.Text, edPassword.Text, edCharSet.Text, trNone, True, nil);
  fb.FreeConnection(fdb);

  ShowMessage('����������� � �� �������� �������!');

end;

procedure TForm1.TestBackupRestore;
var
  tc: DWORD;
begin
  Log('������ ����� ������/�������...');

  // �������������� �� �������
  try
    brtestname := 'b1';
    tc := GetTickCount;
    fb.br.BackupDatabaseOnServer(edServerName.Text, StrToInt(edPort.Text), edFileName.Text,
      IncludeTrailingPathDelimiter(edSharedPathOnServer.Text) + 'mytestdbbackup.fbk',
      edUserName.Text, edPassword.Text, FBDefBackupOptions, BackupRestoreProgressProc);
    Log('BackupDatabaseOnServer: OK. time='+IntToStr(GetTickCount-tc));
  except
    on E: Exception do
      Log('BackupDatabaseOnServer: ERROR: ' + E.Message);
  end;

  // �������������� �� �������
  try
    brtestname := 'r1';
    tc := GetTickCount;
    fb.br.RestoreDatabaseOnServer(edServerName.Text, StrToInt(edPort.Text),
      edFileName.Text + '_base_copy', // ��� �������������� �� ������ ������ ��������� ����� ����
      IncludeTrailingPathDelimiter(edSharedPathOnServer.Text) + 'mytestdbbackup.fbk',
      edUserName.Text, edPassword.Text, FBDefRestoreOptions + [Replace], BackupRestoreProgressProc);
    Log('RestoreDatabaseOnServer: OK. time='+IntToStr(GetTickCount-tc));
  except
    on E: Exception do
      Log('RestoreDatabaseOnServer: ERROR: ' + E.Message);
  end;

  // �������������� � ������������ ����� ���. ����� �� ���������� ���������
  try
    brtestname := 'b2';
    tc := GetTickCount;
    fb.br.BackupDatabaseAndCopyFromServer(edServerName.Text, StrToInt(edPort.Text), edFileName.Text,
      IncludeTrailingPathDelimiter(edSharedPathOnServer.Text) + 'mytestdbbackup.fbk', // ���� ������ ������������ �������
      edUserName.Text, edPassword.Text, FBDefBackupOptions, BackupRestoreProgressProc,
      IncludeTrailingPathDelimiter(edSharedPath.Text) + 'mytestdbbackup.fbk',  // ���� ������ ������������ �������
      GetTempPath + 'mytestdbbackup.fbk', // ����� ����� ������ �� ���������� ����������
      True); // ������� ���� ������ � �������
    Log('BackupDatabaseAndCopyFromServer: OK. time='+IntToStr(GetTickCount-tc));
  except
    on E: Exception do
      Log('BackupDatabaseAndCopyFromServer: ERROR: ' + E.Message);
  end;

  // �������������� � ������������ ����� ���. ����� � ����������� ���������� �� ������
  try
    brtestname := 'r2';
    tc := GetTickCount;
    fb.br.CopyBackupToServerAndRestoreDatabase(edServerName.Text, StrToInt(edPort.Text),
      edFileName.Text + '_base_copy',
      IncludeTrailingPathDelimiter(edSharedPathOnServer.Text) + 'mytestdbbackup.fbk', // ���� ������ ������������ �������
      edUserName.Text, edPassword.Text, FBDefRestoreOptions + [Replace], BackupRestoreProgressProc,
      GetTempPath + 'mytestdbbackup.fbk', // ����� ����� ������ �� ���������� ����������
      IncludeTrailingPathDelimiter(edSharedPath.Text) + 'mytestdbbackup.fbk',  // ���� ������ �� ������� ������������ �������
      True,  // ������� ���� ������ � �������
      True); // ������� ���� ������ � �������
    Log('CopyBackupToServerAndRestoreDatabase: OK. time='+IntToStr(GetTickCount-tc));
  except
    on E: Exception do
      Log('CopyBackupToServerAndRestoreDatabase: ERROR: ' + E.Message);
  end;

  Log('���� ������/������� ��������');
end;

procedure TForm1.TestBaseFunctions;
var
  fdb: TIBDatabase;
  ftran: TIBTransaction;
  ds: TIBDataSet;
  tc: DWORD;
  ID: Integer;
begin
  Log('������ ����� ������� �������...');
  tc := GetTickCount;

  fdb := fb.CreateConnection(edServerName.Text, StrToInt(edPort.Text), edFileName.Text,
    edUserName.Text, edPassword.Text, edCharSet.Text, trNone, True, nil);
  Log('CreateConnection: OK');

  ftran := fb.CreateTransaction(fdb, trRCRW);
  Log('CreateTransaction: OK');


  ds := fb.CreateDataSet(fdb, ftran);
  Log('CreateDataSet: OK');

  ds.SelectSQL.Text := 'SELECT * FROM RDB$DATABASE';
  ds.Open;
  if ds.Eof then
    Log('Open DataSet: ERROR')
  else
    Log('Open DataSet: OK');

  ds.Free;

  ds := fb.CreateAndOpenDataSet(fdb, ftran, 'SELECT * FROM RDB$DATABASE', [], []);
  if ds.Eof then
    Log('CreateAndOpenDataSet: ERROR')
  else
    Log('CreateAndOpenDataSet: OK');
  ds.Free;

  ID := fb.GenID(fdb, 'GEN_TESTTABLE_ID');
  if ID > 0 then
    Log('GenID: OK: ID=' + IntToStr(ID))
  else
    Log('GenID: ERROR');

  fb.InsertRecord(fdb, ftran,
    'TESTTABLE',                              // ��� �������
    ['ID', 'NAME', 'RECDATE'],                // ����� ����� �������
    [ID, 'FBUTILS-SUPER!', Now]);             // �������� �����
  Log('InsertRecord: OK');

  fb.UpdateRecord(fdb, ftran,
    'TESTTABLE',                              // ��� �������
    ['ID'],                                   // �������� ����
    [ID],                                     // ������� �������� �����
    ['SUMMA', 'RECTYPE'],                     // ����� ����� �������
    [1000000, 5]);                            // �������� �����
  Log('UpdateRecord: OK');

  fb.DeleteRecord(fdb, ftran,
    'TESTTABLE',                              // ��� �������
    ['ID'],                                   // �������� ����
    [ID+1000]);                               // ������� �������� �����
  Log('DeleteRecord: OK');

  try
    fb.UpdateOrInsertRecord(fdb, ftran,
      'TESTTABLE',                              // ��� �������
      ['ID', 'NAME', 'RECDATE', 'SUMMA'],       // ����� ����� �������
      [1, 'FB-SUPER!!!', Now, Random(1000000)], // �������� �����
      ['ID']);                                  // �������� ���� (��� ������ ����������)
    Log('UpdateOrInsertRecord: OK');
  except
    on E: Exception do
      Log('UpdateOrInsertRecord: ERROR: ' + FastStringReplace(E.Message, sLineBreak, ' '));
  end;


  ID := fb.GenID(fdb, 'GEN_TESTTABLE_ID');
  fb.ExecQuery(fdb, ftran, 'INSERT INTO TESTTABLE (ID, NAME, SUMMA) VALUES (:pID, :pName, :pSumma)',
    ['pID', 'pName', 'pSumma'], [ID, 'THE BEST!', 2000000]);
  Log('ExecQuery: OK');

  ds := fb.CreateAndOpenTable(fdb, ftran, 'TESTTABLE', 'ID > 0', 'ID', [], []);
  if ds.Eof then
    Log('CreateAndOpenTable: ERROR')
  else
    Log('CreateAndOpenTable: OK. Records=' + IntToStr(ds.RecordCount));
  ds.Free;

  fb.ExecQuery(fdb, ftran, 'INSERT INTO TESTTABLE (NAME, SUMMA) VALUES (:pName, :pSumma)',
    ['pName', 'pSumma'], ['THE BEST!', 2000000]);
  Log('ExecQuery (AutoInc): OK');

  // ������� SQL-������ (����� �������� EXECUTE BLOCK)
  fb.ExecuteBlock(fdb, ftran, '', 'INSERT INTO TESTTABLE (ID, SUMMA) VALUES (GEN_ID(GEN_TESTTABLE_ID,1), 123456);');
  Log('ExecuteBlock 1: OK');

  // ���� ���������
  fb.ExecuteBlock(fdb, ftran, 'I INTEGER',                      // ��������� ����������
    ' I = GEN_ID(GEN_TESTTABLE_ID,1); '+                        // �������� �������� ����������
    ' INSERT INTO TESTTABLE (ID, SUMMA) VALUES (:I, 123456); ');// ��������� ����� ������
  Log('ExecuteBlock 2: OK');

  // ����  ExecuteBlock � FOR SELECT INTO
  fb.ExecuteBlock(fdb, ftran,
    'vID INTEGER, vName VARCHAR(100)',        // ��������� ����������
    ' FOR SELECT ID, NAME FROM TESTTABLE '+   // ��� ������ ������ �������
    '     WHERE NAME IS NULL ORDER BY 1 '+    // � �������� �������� � �����������
    ' INTO :vID, :vName '+                    // ��������� ID � NAME � ����������
    ' DO '+                                   // ���������...
    ' BEGIN '+
    '   UPDATE TESTTABLE SET SUMMA=SUMMA+1, NAME=:vName WHERE ID=:vID; '+ // ���������� ������ �������
    ' END ');
  Log('ExecuteBlock 3: OK');

  // ���� ExecuteBlock c �������� (���������� ���-�� ������� � ������� �����
  ds := fb.ExecuteBlock(fdb, ftran,
    'CNT INTEGER, AvgSum DOUBLE PRECISION',         // ���� ��������������� ������ ������
    '',
    'SELECT COUNT(ID), AVG(SUMMA) FROM TESTTABLE '+ // ��������� ������������ ������
    'INTO :CNT, :AvgSum; '+                         // ��������� ��������� ������� � ����������
    'SUSPEND;');                                    // ������������� ���������� � ���, ��� "������" �������
  Log('ExecuteBlock 4: OK: CNT=' + ds.FieldByName('CNT').AsString + ' AVG=' + ds.FieldByName('AvgSum').AsString);
  ds.Free;

  // ���� ExecuteBlock � ���������� ������
  try
    fb.ExecuteBlock(fdb, ftran, '', '', 'EXCEPTION ERR ''� �������� ��������� ��������� �����-�� ������!'';');
  except
    on E: EIBInterBaseError do
      if E.SQLCode = -836 then
        Log('ExecuteBlock 5 (EXCEPTION ERR): OK: ' + FastStringReplace(E.Message, sLineBreak, ' '))
      else
        Log('ExecuteBlock 5 (EXCEPTION ERR): ERROR: ' + FastStringReplace(E.Message, sLineBreak, ' ') +
          ' SQLCode=' + IntToStr(E.SQLCode) + ' IBErrorCode=' + IntToStr(E.IBErrorCode));
  end;

  // ��������� ����� �������� ���������, ������������ ����� ������
  ds := fb.CreateAndOpenDataSet(fdb, ftran, 'SELECT * FROM PROCPOWER(3,3)', [], []);
  if ds.Fields[0].AsInteger = 27 then
    Log('Call stored proc: OK')
  else
    Log('Call stored proc: ERROR');
  ds.Free;

  // ��������� ����� �������� ���������, �� ������������ ����� ������
  fb.ExecQuery(fdb, ftran, 'EXECUTE PROCEDURE PROCADDSUMMA(:A)', ['A'], [5]);
  Log('Execute procedure: OK');

  fb.ClearTable(fdb, ftran, 'TESTTABLE', 'ID BETWEEN 500 AND 700', False);
  Log('ClearTable 1: OK (��������, ��� ������ ������)');

  ftran.Commit;

  fb.ClearTable(fdb, nil, 'TESTTABLE', 'ID BETWEEN 800 AND 1000', True);
  Log('ClearTable 2: OK (��������, �� ������� ������)');


  fb.ClearTable(fdb, nil, 'TESTTABLE');
  Log('ClearTable 3: OK (���������, �� ������� ������)');


  ftran.Free;
  fb.FreeConnection(fdb);

  tc := GetTickCount - tc;
  Log('���� ������� ������� �������� �� ' + IntToStr(Tc) + ' ��');
end;

procedure TForm1.TestDBCorrectStruct;
var
  ATable: TfbTableDesc;
begin
  fb.DBStruct.ReCreateDefDataBaseDesc();

  // ===========================
  // ��������� �������� �������
  // ===========================
  fb.DBStruct.DefDBDesc.AddDomain('T_YESNO',  'INTEGER',       '0', CanNull, '(VALUE IS NULL) OR (VALUE IN (0,1))');
  fb.DBStruct.DefDBDesc.AddDomain('T_NUMBER', 'NUMERIC(15,4)', '', CanNull, '');

  // ===========================
  // ��������� �������� ������
  // ===========================
  ATable := fb.DBStruct.DefDBDesc.AddTable('TESTTABLE');
  with ATable do
  begin
    // ��������� �������� �����
    AddField('ID',           'INTEGER',     '',   NotNull);
    AddField('RECTYPE',      'SMALLINT',    '',   CanNull);
    AddField('NAME',         'VARCHAR(20)', '',   CanNull);
    AddField('RECDATE',      'TIMESTAMP',   '',   CanNull);
    AddField('SUMMA',        'T_NUMBER',    '0',  CanNull);

    AddField('f234567890123456789012345678901',        'T_NUMBER',    '0',  CanNull);

    // �������� ���������� �����
    SetPrimaryKey('TESTTABLE_PK', '"ID"');

    // �������� ��������
    AddIndex('TESTTABLE_IDX1', False, Ascending, '"RECDATE"'); // �� �����������
    AddIndex('TESTTABLE_IDX2', False, Descending, '"ID"');     // �� ��������

    // ���������� ������� ��� ���������� ���� MODIFYDATE (���� ����� ������� �������������)
    UseModifyDateTrigger := trsActive;

    // ������� ��������� (�������� ���������� ����� ���� � ����� �����. ����� ��� ��� �����������)
    //fb.DBStruct.DefDBDesc.AddGenerator('GEN_TESTTABLE_ID', 0);

    // ������� ��� �������� �������������� �� ���� ID (������������ ��������� GEN_TESTTABLE_ID)
    {
    AddTrigger(trBefore, [trInsert], 0, trsActive,
      '', // ��� �������� - ����� ������������� �������������
      '', // ��������� ���������� - �����������
      'IF (NEW.ID IS NULL) THEN NEW.ID=GEN_ID(GEN_TESTTABLE_ID, 1);');
    }

    // ������� ��� �������� �������������� �� ���� ID
    // ��������� GEN_TESTTABLE_ID ����� ������ �������������
    // ��� �������� ����� ������������� �������������
    AddAutoIncTrigger('', 'ID', 'GEN_TESTTABLE_ID', True);

    // ������� ��� ��������������� ���������� ���� RECTYPE
    // �������� ����� �������� ��������� PROCGETRECTYPE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'TRIG_CORRECTRECTYPE_BI',
      'A INTEGER',
      '  IF (NEW.RECTYPE IS NULL) THEN' + sLineBreak +
      '  BEGIN' + sLineBreak +
      '    SELECT ATYPE FROM PROCGETRECTYPE INTO :A;' + sLineBreak +
      '    NEW.RECTYPE = A;' + sLineBreak +
      '  END'
    );
  end;


  // ������� ������� CONFIGPARAMS ��� ������ � INI
  ATable := fb.DBStruct.DefDBDesc.AddTable('CONFIGPARAMS');
  with ATable do
  begin
    AddField('FILENAME',      'VARCHAR(100)',   '', NotNull);
    AddField('COMPUTERNAME',  'VARCHAR(100)',   '', NotNull);
    AddField('USERNAME',      'VARCHAR(100)',   '', NotNull);
    AddField('SECTIONNAME',   'VARCHAR(100)',   '', NotNull);
    AddField('PARAMNAME',     'VARCHAR(100)',   '', NotNull);
    AddField('PARAMVALUE',    'VARCHAR(10000)', '', CanNull);
    AddField('PARAMBLOB',     'BLOB',           '', CanNull);
    AddField('PARAMBLOBHASH', 'VARCHAR(50)',    '', CanNull);
    AddField('MODIFYDATE',    'TIMESTAMP',      '', CanNull);
    AddField('MODIFYUSER',    'VARCHAR(100)',   '', CanNull);

    SetPrimaryKey('CONFIGPARAMS_PK', 'FILENAME, COMPUTERNAME, USERNAME, SECTIONNAME, PARAMNAME');
  end;


  // ������� �������� ��������� (��� ���������� ����� � �������� ����� ������������� �������)
  fb.DBStruct.DefDBDesc.AddProcedure(
    'PROCPOWER',             // ��� ���������
    'X INTEGER, P INTEGER',  // ������� ��������� (���������� ����� � �������)
    'Y INTEGER',             // �������� ���������
    'I INTEGER',             // ��������� ���������� (I - ������� �����)

    // ���� �������� ���������...
    '  Y = 1;'           + sLineBreak +
    '  I = P;'           + sLineBreak +
    '  WHILE (I > 0) DO' + sLineBreak +
    '  BEGIN'            + sLineBreak +
    '    Y = Y * X;'     + sLineBreak +
    '    I = I - 1;'     + sLineBreak +
    '  END'              + sLineBreak +
    '  SUSPEND;' // �������� ���������� �������
  );

  // ������� �������� ���������, �� ������������ ���������
  fb.DBStruct.DefDBDesc.AddProcedure(
    'PROCADDSUMMA', // ��������� PROCADDSUMMA - ����������� �������� ���� SUMMA �� ��������� �����
    'A INTEGER',    // ������� �������� (�������� ���������� ��� ���� SUMMA)
    '', '',         // �������� ��������� � ��������� ���������� - �����������
    '  UPDATE TESTTABLE SET SUMMA = SUMMA + :A;' // SQL - ������ �� ���������� ���� SUMMA
  );

  // ������� �������� ���������, ������� ����� ���������� �� ��������
  fb.DBStruct.DefDBDesc.AddProcedure(
    'PROCGETRECTYPE',   // ��� ���������
    '',                 // ������� ��������� - �����������
    'ATYPE INTEGER',    // �������� �������� - ��� ������
    '',                 // ��������� ���������� - �����������
    '  ATYPE = 12345;' + sLineBreak +
    '  SUSPEND;'
  );

  // ������� ������ ���������� ERR. ��������� ����� � ��.���������� �����
  // ������������ ����������: EXCEPTION ERR '��������� �����-�� ������'
  fb.DBStruct.DefDBDesc.AddDefaultException;

  fb.DBStruct.CheckDefDataBaseStruct(edServerName.Text, StrToInt(edPort.Text), edFileName.Text,
    edUserName.Text, edPassword.Text, edCharSet.Text, LogEventsProc);
  Log('CheckDefDataBaseStruct: OK');

end;

procedure TForm1.Log(S: string);
begin
  Memo1.Lines.Add(S);
end;

procedure TForm1.TestFBIniFiles;
var
  S: string;
  B: Boolean;
  F: Double;
  dt: TDateTime;
  I: Integer;
  Ar1, Ar2: array[0..100] of Byte;
  AList: TStringList;
  tc: DWORD;
begin
  tc := GetTickCount;
  fb.Ini.CreateDefIni(FBIniDefFileName, FBDefDB, False);

  Log('������ ������ ������ � TFBIniFile');

  fb.Ini.DefIni.BeginWork;
  try
    S := '���� TFBIniFile';
    fb.Ini.DefIni.WriteString('String', S);
    if fb.Ini.DefIni.ReadString('String', '') = S then
      Log('WriteString/ReadString: OK')
    else
      Log('WriteString/ReadString: ERROR');

    B := True;
    fb.Ini.DefIni.WriteBool('Boolean', B);
    if fb.Ini.DefIni.ReadBool('Boolean', False) = B then
      Log('WriteBool/ReadBool: OK')
    else
      Log('WriteBool/ReadBool: ERROR');

    F := 12345.50;
    fb.Ini.DefIni.WriteFloat('Float', F);
    if fb.Ini.DefIni.ReadFloat('Float', 0) = F then // ������ ���������� �� ������ ������
      Log('WriteFloat/ReadFloat: OK')
    else
      Log('WriteFloat/ReadFloat: ERROR');

    dt := Now;
    fb.Ini.DefIni.WriteDateTime('DateTime', dt);
    if fb.Ini.DefIni.ReadDateTime('DateTime', 0) = dt then // �������� (�������� �� "����������� �����������...")
      Log('WriteDateTime/ReadDateTime: OK')
    else
      Log('WriteDateTime/ReadDateTime: ERROR');

    I := 12345678;
    fb.Ini.DefIni.WriteInteger('Integer', I);
    if fb.Ini.DefIni.ReadInteger('Integer', 0) = I then
      Log('WriteInteger/ReadInteger: OK')
    else
      Log('WriteInteger/ReadInteger: ERROR');

    dt := Date;
    fb.Ini.DefIni.WriteDate('Date', dt);
    if fb.Ini.DefIni.ReadDate('Date', 0) = dt then
      Log('WriteDate/ReadDate: OK')
    else
      Log('WriteDate/ReadDate: ERROR');

    dt := Time;
    fb.Ini.DefIni.WriteTime('Time', dt);
    if fb.Ini.DefIni.ReadTime('Time', 0) = dt then
      Log('WriteTime/ReadTime: OK')
    else
      Log('WriteTime/ReadTime: ERROR');

    for I := Low(Ar1) to High(Ar1) do Ar1[I] := I;
    Ar2 := Ar1;

    fb.Ini.DefIni.WriteBinaryData('Binary', Ar1, SizeOf(Ar1));
    for I := Low(Ar1) to High(Ar1) do Ar1[I] := 0; // �������� ������
    I := fb.Ini.DefIni.ReadBinaryData('Binary', Ar1, SizeOf(Ar1));
    if (I = SizeOf(Ar1)) and CompareMem(@Ar1, @Ar2, SizeOf(Ar1)) then
      Log('WriteBinaryData/ReadBinaryData (WriteStream/ReadStream): OK')
    else
      Log('WriteBinaryData/ReadBinaryData (WriteStream/ReadStream): ERROR');

    S := Memo1.Text;
    fb.Ini.DefIni.WriteText('Text', S);
    if fb.Ini.DefIni.ReadText('Text', '') = S then
      Log('WriteText/ReadText: OK')
    else
      Log('WriteText/ReadText: ERROR');

    fb.Ini.DefIni.WriteText(False, False, 'MySection', 'Text', S);
    if fb.Ini.DefIni.ReadText(False, False, 'MySection', 'Text', '') = S then
      Log('CurComp+CurUser: OK')
    else
      Log('CurComp+CurUser: ERROR');

    if fb.Ini.DefIni.ValueExists(False, False, 'MySection', 'Text') then
      Log('ValueExists: OK')
    else
      Log('ValueExists: ERROR');

    fb.Ini.DefIni.WriteInteger(False, False, 'MySection', 'INTEGER', 123);
    fb.Ini.DefIni.DeleteKey(False, False, 'MySection', 'INTEGER');
    if fb.Ini.DefIni.ValueExists(False, False, 'MySection', 'INTEGER') then
      Log('DeleteKey: ERROR')
    else
      Log('DeleteKey: OK');

    if fb.Ini.DefIni.SectionExists(False, False, 'MySection') then
      Log('SectionExists: OK')
    else
      Log('SectionExists: ERROR');

    fb.Ini.DefIni.EraseSection(False, False, 'MySection');

    if fb.Ini.DefIni.SectionExists(False, False, 'MySection') then
      Log('EraseSection: ERROR')
    else
      Log('EraseSection: OK');

    AList := TStringList.Create;
    fb.Ini.DefIni.ReadSection(AList);
    if AList.Count > 0 then
      Log('ReadSection: OK')
    else
      Log('ReadSection: ERROR');

    fb.Ini.DefIni.ReadSections(AList);
    if AList.Count > 0 then
      Log('ReadSections: OK')
    else
      Log('ReadSections: ERROR');

    fb.Ini.DefIni.ReadSectionValues(AList);
    if AList.Count > 0 then
      Log('ReadSectionValues: OK')
    else
      Log('ReadSectionValues: ERROR');
  finally
    fb.Ini.DefIni.EndWork;
  end;




  AList.Free;

  tc := GetTickCount - tc;
  Log('����� ��������� �� ' + IntToStr(tc) + ' ��. ���������, ��� ����� "��"!');
end;

procedure TForm1.TestRecomputeIndexes;
var
  FDB: TIBDatabase;
  tc: DWORD;
begin
  Log('������ ����� ��������� ����������...');
  FDB := fb.Pool.GetDefaultConnection;
  try
    tc := GetTickCount;
    fb.RecomputeIndexStatistics(FDB);
    Log('RecomputeIndexStatistics: OK');
    tc := GetTickCount - tc;
    Log('�������� ���������� �������� �� ' + IntToStr(Tc) + ' ��');
  finally
    fb.Pool.ReturnConnection(FDB);
  end;
end;

procedure TForm1.TestWorkingWithPool;
var
  I: Integer;
begin
  StopThreads := False;
  ErrorCounter := 0;

  // ������� ������ ��� ������ � INI
  fb.Ini.CreateDefIni(FBIniDefFileName, FBDefDB, False);

  // ������� 100 ������� ��� ������ � �� Firebird
  for I := 1 to 100 do
    TTestThread.Create(False);

  ShowMessage(
    '���� �������.'+sLineBreak+
    '��� 100 ������� ����������'+sLineBreak+
    '����� ��������� �����������'+ sLineBreak+
    '������� �� ��� ���������.');

  StopThreads := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  labConnCount.Caption := IntToStr(fb.Pool.GetPoolSize);
  labErrCount.Caption := IntToStr(ErrorCounter);
  labThreadCount.Caption := IntToStr(ThreadCounter);
  labInsCount.Caption := IntToStr(InsCounter);

  if sErrInThread <> '' then
  begin
    Memo2.Lines.Add(sErrInThread);
    sErrInThread := '';
  end;
end;

{ TTestThread }

procedure TTestThread.Execute;
var
  fdb: TIBDatabase;
  tran: TIBTransaction;
  Val, ID: Integer;
  ds: TIBDataSet;
  AvgSumma: Double;
begin
  FreeOnTerminate := True;
  Sleep(Random(1000)); // �������� ����� ������ ������ �������
  InterlockedIncrement(ThreadCounter);
  try
    while not StopThreads do
    begin
      try
        // ��������� ������������� ������ � INI
        Val := fb.Ini.DefIni.ReadInteger('THREADS', IntToStr(GetCurrentThreadId), 0);
        Val := Val + 1;
        fb.Ini.DefIni.WriteInteger('THREADS', IntToStr(GetCurrentThreadId), Val);

        // ��������� ���
        fdb := fb.Pool.GetDefaultConnection(nil, @tran);
        try
          // ���������� ������� �������� �����
          ds := fb.CreateAndOpenDataSet(fdb, tran, 'SELECT AVG(SUMMA) FROM TESTTABLE', [], []);
          AvgSumma := ds.Fields[0].AsFloat;
          ds.Free;

          // ��������� ������ � TESTTABLE
          ID := fb.GenID(fdb, 'GEN_TESTTABLE_ID');
          fb.InsertRecord(fdb, tran, 'TESTTABLE', ['ID', 'NAME', 'RECDATE', 'SUMMA'], [ID, 'TEST', Now, AvgSumma]);
          tran.Commit;
          InterlockedIncrement(InsCounter);
        finally
          fb.Pool.ReturnConnection(fdb);
        end;
      except
        on E: Exception do
        begin
          sErrInThread := DateTimeToStr(Now) + Format(': ������ � ������ %d: %s', [GetCurrentThreadId, E.Message]);
          InterlockedIncrement(ErrorCounter);
        end;

      end;
      Sleep(1000);
    end;
  finally
    InterlockedDecrement(ThreadCounter);
  end;


end;

end.
