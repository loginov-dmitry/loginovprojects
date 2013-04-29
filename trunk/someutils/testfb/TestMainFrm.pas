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

unit TestMainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls, Buttons, ExtCtrls, SyncObjs, LDSLogger, IniFiles,
  FileCtrl, IBDatabase, IBCustomDataSet, DB, ComCtrls, DateUtils, ShellAPI;

type

  TCheckActivityThread = class(TThread)
  private
    FEvent: THandle;
  protected
    procedure Execute; override;
  public
    destructor Destroy; override;
  end;

  TThreadDBConnect = class(TThread)
  private
  public
    IBDB: TIBDatabase;
  protected
    procedure Execute; override;
  end;

  TTestMainForm = class(TForm)
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    btnTestMaxConnections: TButton;
    Label20: TLabel;
    lbMaxConnCount: TLabel;
    Label21: TLabel;
    lbCurDisconnect: TLabel;
    Label22: TLabel;
    edMaxConnLimit: TEdit;
    Label23: TLabel;
    edMaxConnPause: TEdit;
    cbMaxConnDoSelect: TCheckBox;
    edSimpleQuery: TEdit;
    Label25: TLabel;
    lbMaxConnAvgTime: TLabel;
    Label26: TLabel;
    lbMaxConnMaxTime: TLabel;
    tmSetLastActive: TTimer;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    SpeedButton2: TSpeedButton;
    Label3: TLabel;
    lbCurClientLib: TLabel;
    Label4: TLabel;
    SpeedButton3: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbFBPath: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    btnTestConnect: TSpeedButton;
    Label14: TLabel;
    edDBFileName: TEdit;
    edClientLib: TEdit;
    edFBPath: TEdit;
    cbLocalConnect: TCheckBox;
    panRemoteConn: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    edServerName: TEdit;
    edFBPort: TEdit;
    edUserName: TEdit;
    edPassword: TEdit;
    edDBRole: TEdit;
    edCharset: TEdit;
    Label24: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    GroupBox1: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    edNewThreadConnectCount: TEdit;
    btnTestThreadConnect: TButton;
    btnCreateThreads: TButton;
    Label31: TLabel;
    labThreadDBConnectCount: TLabel;
    cbMustSync: TCheckBox;
    Label30: TLabel;
    labThreadErrorCount: TLabel;
    labAvgThreadCreateTime: TLabel;
    Label38: TLabel;
    Label37: TLabel;
    Label39: TLabel;
    labMaxThreadCreateTime: TLabel;
    labTestResult: TLabel;
    Label40: TLabel;
    labThreadConnectCount: TLabel;
    Label41: TLabel;
    labAllThreadConnCnt: TLabel;
    Label43: TLabel;
    labAllThreadDisconnCnt: TLabel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbLocalConnectClick(Sender: TObject);
    procedure btnTestConnectClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure btnTestMaxConnectionsClick(Sender: TObject);
    procedure tmSetLastActiveTimer(Sender: TObject);
    procedure Label29Click(Sender: TObject);
    procedure btnCreateThreadsClick(Sender: TObject);
    procedure btnTestThreadConnectClick(Sender: TObject);
  private
    { Private declarations }
    InTestMaxConnections: Boolean;

    InTestThreadConnections: Boolean;

    CheckActivityThread: TCheckActivityThread;
  public
    { Public declarations }
    function GetConnectString: string;

    procedure CheckThreadStart;

    procedure CheckThreadErrorCount;
  end;

const
  IniSect = 'TestFB';

var
  TestMainForm: TTestMainForm;


  ALog: TLDSLogger;
  Ini: TIniFile;
  AppPath: string;

  LastActiveTime: TDateTime;

  ThreadsCount, ThreadOrderNum, ThreadConnectCount: Integer; // Количество созданных параллельных потоков

  AllThreadConnCnt, AllThreadDisconnCnt: Integer; // Кол-во выполненных коннектов и дисконнектов

  CSStartConnect: TCriticalSection;
  CSStartConnectIsEnter: Boolean;

  MustSync: Boolean;

  ThreadErrorCount: Integer;
  ThreadLastError: string;

implementation

uses FBUtilsUnit;

{$R *.dfm}

procedure TTestMainForm.btnTestMaxConnectionsClick(Sender: TObject);
var
  I, ConnLimit, MaxConnPause: Integer;
  ConnList: TStringList;
  IBDB: TIBDatabase;
  ConnStr, AUser, APassword, ARole, ACharset, ASimpleQuery: string;
  MaxConnDoSelect: Boolean;

  AllConnTime, MaxConnTime, Tc: Cardinal;
begin
  try
    if InTestMaxConnections then // Следует остановить цикл подключений
    begin
      InTestMaxConnections := False;
    end else
    begin // Следует начать цикл подключений
      ConnStr := GetConnectString;
      AUser := edUserName.Text;
      APassword := edPassword.Text;
      ARole := edDBRole.Text;
      ACharset := edCharset.Text;
      ConnLimit := StrToIntDef(edMaxConnLimit.Text, 1);
      MaxConnPause := StrToIntDef(edMaxConnPause.Text, 50);
      MaxConnDoSelect := cbMaxConnDoSelect.Checked;
      ASimpleQuery := edSimpleQuery.Text;

      btnTestMaxConnections.Caption := 'Стоп';
      lbMaxConnCount.Caption := '0';
      lbMaxConnAvgTime.Caption := '?';
      lbMaxConnMaxTime.Caption := '?';
      AllConnTime := 0;
      MaxConnTime := 0;
      InTestMaxConnections := True;
      ConnList := TStringList.Create;
      try

        try
          I := 0;
          while InTestMaxConnections and (I < ConnLimit) do
          begin
            IBDB := FBCreateIBDataBase(ConnStr, AUser, APassword, ARole, ACharset, '', False);
            ConnList.AddObject('', IBDB);

            Tc := GetTickCount;
            FBConnectDB(IBDB);
            Tc := GetTickCount - Tc;


            if MaxConnDoSelect then
            begin
              with FBCreateDataSetForRead(IBDB, True, nil, '') do
              try
                SelectSQL.Text := ASimpleQuery;
                Open; // При ошибке в запросе D2010 не очень адекватно реагирует. Лучше не допускать ошибок!
                FetchAll;
              finally
                Free;
              end;
            end;

            Inc(I);

            AllConnTime := AllConnTime + Tc;
            if Tc > MaxConnTime then MaxConnTime := Tc;
            lbMaxConnAvgTime.Caption := FormatFloat('0.0', AllConnTime / I);
            lbMaxConnMaxTime.Caption := IntToStr(MaxConnTime);

            lbMaxConnCount.Caption := IntToStr(I);
            Application.ProcessMessages;

            Sleep(MaxConnPause);
          end;

          ShowMessage(
            'Заданный лимит числа подключений достигнут!'#13#10+
            'Сейчас программа выполнит закрытие подключений!');

        finally
          btnTestMaxConnections.Caption := 'Отключение...';
          // Уничтожаем подключения
          for I := 0 to ConnList.Count - 1 do
          try // Глушим возможные ошибки
            FBFreeIBDataBase(TIBDatabase(ConnList.Objects[I]));
            lbCurDisconnect.Caption := Format('%d из %d', [I + 1, ConnList.Count]);
            Application.ProcessMessages;

            Sleep(MaxConnPause);
          except
            on E: Exception do
              ALog.LogStr('MAX CONN TEST -> ' + E.Message, tlpError);
          end;
        end;

        ShowMessage('ТЕСТ ЗАВЕРШЕН!');

      finally
        btnTestMaxConnections.Caption := 'Старт';
        lbCurDisconnect.Caption := '0';
        InTestMaxConnections := False;
        ConnList.Free;
      end;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TEST MAX CONNECTIONS');
  end;
end;

procedure TTestMainForm.btnTestThreadConnectClick(Sender: TObject);
begin
  if ThreadsCount = 0 then
    raise Exception.Create('Сначала необходимо создать потоки!');

  with TStringList.Create do
  try
    Text := IntToStr(Byte(cbMustSync.Checked));
    SaveToFile(AppPath + 'startFBTest.start');
  finally
    Free;
  end;

end;

procedure TTestMainForm.cbLocalConnectClick(Sender: TObject);
begin
  panRemoteConn.Visible := not cbLocalConnect.Checked;
end;

procedure TTestMainForm.CheckThreadErrorCount;
var
  S: string;
begin

  if InTestThreadConnections and (ThreadsCount = 0) and (ThreadErrorCount = 0) then
  begin
    InTestThreadConnections := False;
    labTestResult.Visible := True;
  end;

  if (ThreadsCount = 0) and (ThreadErrorCount > 0) then
  begin
    S := 'В ходе тестирования параллельных подключений'#13#10+
         'к FireBird произошло ' + IntToStr(ThreadErrorCount) + ' ошибок.'#13#10+
         'Подробную информацию смотрите в логе:'#13#10+
         AppPath + 'TestFB.log'#13#10#13#10+
         'Последняя ошибка:'#13#10 + ThreadLastError;
    ThreadErrorCount := 0;
    InTestThreadConnections := False;
    Application.MessageBox(PChar(S), 'Внимание!', MB_ICONWARNING);
  end;

  if not InTestThreadConnections then
    btnTestThreadConnect.Caption := 'ТЕСТ';

end;

procedure TTestMainForm.CheckThreadStart;
begin
  if FileExists(AppPath + 'startFBTest.start') then
  begin
    with TStringList.Create do
    try
      LoadFromFile(AppPath + 'startFBTest.start');
      MustSync := Trim(Text) = '1';
    finally
      Free;
    end;

    AllThreadConnCnt := 0;
    AllThreadDisconnCnt := 0;
    ThreadConnectCount := 0;

    ThreadErrorCount := 0;
    labThreadErrorCount.Caption := IntToStr(ThreadErrorCount);

    if CSStartConnectIsEnter then
    begin
      CSStartConnect.Leave; // Возобновляем работу потоков
      CSStartConnectIsEnter := False;
    end;

    InTestThreadConnections := True;
    labTestResult.Visible := False;
    btnTestThreadConnect.Caption := 'Выполняется...';

    Sleep(500); // Остальные программы также должны успеть обнаружить этот файл
    DeleteFile('startFBTest.start');
  end;
end;

procedure TTestMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Ini.WriteString(IniSect, 'ClientLib', edClientLib.Text);

  Ini.WriteString(IniSect, 'ENV_FIREBIRD', edFBPath.Text);

  Ini.WriteString(IniSect, 'DBFileName', edDBFileName.Text);

  Ini.WriteString(IniSect, 'ServerName', edServerName.Text);

  Ini.WriteInteger(IniSect, 'FBPort', StrToIntDef(edFBPort.Text, 3050));

  Ini.WriteInteger(IniSect, 'MaxConnLimit', StrToIntDef(edMaxConnLimit.Text, 1000));

  Ini.WriteInteger(IniSect, 'MaxConnPause', StrToIntDef(edMaxConnPause.Text, 5));

  Ini.WriteBool(IniSect, 'LocalConnect', cbLocalConnect.Checked);

  Ini.WriteString(IniSect, 'UserName', edUserName.Text);

  Ini.WriteString(IniSect, 'Password', edPassword.Text);

  Ini.WriteString(IniSect, 'DBRole', edDBRole.Text);

  Ini.WriteString(IniSect, 'Charset', edCharset.Text);

  CheckActivityThread.Free;
end;

procedure TTestMainForm.FormCreate(Sender: TObject);
begin

  edClientLib.Text := Ini.ReadString(IniSect, 'ClientLib', edClientLib.Text);

  edFBPath.Text := Ini.ReadString(IniSect, 'ENV_FIREBIRD', edFBPath.Text);

  edDBFileName.Text := Ini.ReadString(IniSect, 'DBFileName', edDBFileName.Text);

  edFBPort.Text := IntToStr(Ini.ReadInteger(IniSect, 'FBPort', 3050));

  edServerName.Text := Ini.ReadString(IniSect, 'ServerName', edServerName.Text);

  edUserName.Text := Ini.ReadString(IniSect, 'UserName', edUserName.Text);

  edPassword.Text := Ini.ReadString(IniSect, 'Password', edPassword.Text);

  edDBRole.Text := Ini.ReadString(IniSect, 'DBRole', edDBRole.Text);

  edCharset.Text := Ini.ReadString(IniSect, 'Charset', edCharset.Text);

  cbLocalConnect.Checked := Ini.ReadBool(IniSect, 'LocalConnect', cbLocalConnect.Checked);

  edMaxConnLimit.Text := IntToStr(Ini.ReadInteger(IniSect, 'MaxConnLimit', 1000));

  edMaxConnPause.Text := IntToStr(Ini.ReadInteger(IniSect, 'MaxConnPause', 5));

  lbFBPath.Caption := GetEnvironmentVariable('FIREBIRD');

  lbCurClientLib.Caption := GetModuleName(GetModuleHandle('gds32.dll'));

  PageControl1.ActivePageIndex := 0;

  CheckActivityThread := TCheckActivityThread.Create(False);
end;

function TTestMainForm.GetConnectString: string;
begin
  if cbLocalConnect.Checked then
    Result := edDBFileName.Text
  else
  begin
    Result := Trim(edServerName.Text);
    if Result = '' then
      Result := 'localhost';

    Result := Result + '/' + IntToStr(StrToIntDef(edFBPort.Text, 3050)) + ':';
    Result := Result + edDBFileName.Text;
  end;
end;

procedure TTestMainForm.Label29Click(Sender: TObject);
var
  S: string;
begin
  S := AppPath + 'threadsafedb.html';
  if FileExists(S) then
  begin
    ShellExecute(Handle, 'open', PChar(S), nil, PChar(AppPath), SW_SHOW);
  end else
    raise Exception.CreateFmt('Файл "%s" не найден!', [S]);
end;

procedure TTestMainForm.SpeedButton1Click(Sender: TObject);
begin
  OpenDialog1.FilterIndex := 1;
  OpenDialog1.InitialDir := ExtractFilePath(edDBFileName.Text);
  OpenDialog1.FileName := edDBFileName.Text;
  if OpenDialog1.Execute then
    edDBFileName.Text := OpenDialog1.FileName;
end;

procedure TTestMainForm.SpeedButton2Click(Sender: TObject);
begin
  OpenDialog1.FilterIndex := 2;
  OpenDialog1.InitialDir := ExtractFilePath(edClientLib.Text);
  OpenDialog1.FileName := edClientLib.Text;
  if OpenDialog1.Execute then
    edClientLib.Text := OpenDialog1.FileName;
end;

procedure TTestMainForm.SpeedButton3Click(Sender: TObject);
var
  Dir: string;
begin
  Dir := edFBPath.Text;
  if SelectDirectory('Выберите каталог', '', Dir) then
    edFBPath.Text := Dir;
//
end;



procedure TTestMainForm.tmSetLastActiveTimer(Sender: TObject);
begin
  LastActiveTime := Now;

  labThreadDBConnectCount.Caption := IntToStr(ThreadsCount);

  labAllThreadConnCnt.Caption := IntToStr(AllThreadConnCnt);
  labAllThreadDisconnCnt.Caption := IntToStr(AllThreadDisconnCnt);

  if ThreadErrorCount > 0 then
  begin
    labThreadErrorCount.Font.Color := clRed;
    labThreadErrorCount.Caption := IntToStr(ThreadErrorCount);
  end else
    labThreadErrorCount.Font.Color := clBlack;

  labThreadConnectCount.Caption := IntToStr(ThreadConnectCount);

  CheckThreadStart;

  CheckThreadErrorCount;
end;

procedure TTestMainForm.btnCreateThreadsClick(Sender: TObject);
var
  I: Integer;
  Tc, AllTime, MaxTime: DWORD;
  AThread: TThreadDBConnect;
  IBDB: TIBDatabase;
begin
  if not CSStartConnectIsEnter then
  begin
    CSStartConnect.Enter;
    CSStartConnectIsEnter := True;
  end;

  //labAvgThreadCreateTime
  AllTime := 0;
  MaxTime := 0;

  // Создаем необходимое кол-во потоков. Подключение не будет выполнено, пока
  // пользователь не нажмет кнопку "ТЕСТ"
  for I := 1 to StrToInt(edNewThreadConnectCount.Text) do
  begin
    Tc := GetTickCount;

    // Создаем объект подключения
    IBDB := FBCreateIBDataBase(GetConnectString, edUserName.Text, edPassword.Text, edDBRole.Text, edCharset.Text, '', True);

    // Создаем поток. После запуска поток не будет обращаться к IBDB то тех пор,
    // пока не будет нажата кнопка "ТЕСТ".
    // Создание дополнительного потока - наиболее ресурсоемкая операция, поэтому
    // именно она будет определять итоговое время. Особенно если запускать из-под отладчика
    AThread := TThreadDBConnect.Create(False);

    AThread.IBDB := IBDB; // Присваивание безопасно

    Tc := GetTickCount - Tc;
    if Tc > MaxTime then
      MaxTime := Tc;
    AllTime := AllTime + Tc;
    labAvgThreadCreateTime.Caption := IntToStr(Trunc(AllTime / I));
    labMaxThreadCreateTime.Caption := IntToStr(MaxTime);
    Application.ProcessMessages;
  end;

end;

procedure TTestMainForm.btnTestConnectClick(Sender: TObject);
var
  IBDB: TIBDatabase;
begin
  IBDB := FBCreateIBDataBase(GetConnectString, edUserName.Text, edPassword.Text, edDBRole.Text, edCharset.Text, '', True);
  try
    FBConnectDB(IBDB);

    ShowMessage('ПОДКЛЮЧЕНИЕ УСПЕШНО УСТАНОВЛЕНО!'#13#10+IBDB.DatabaseName);
  finally
    FBFreeIBDataBase(IBDB);
  end;
end;

var
  HClientLib: THandle = 0;

procedure DoInit;
var
  S: string;
begin


  AppPath := ExtractFilePath(Application.ExeName);

  ALog := TLDSLogger.Create(AppPath + 'TestFB.log');
  ALog.CanWriteThreadID := True;
  ALog.CanWriteProcessID := True;
  ALog.MaxFileSize := ALog.MaxFileSize * 5;
  ALog.MaxOldLogFileCount := 2;
  ALog.LogStr('');
  ALog.LogStr('ПРИЛОЖЕНИЕ ЗАПУЩЕНО');


  Ini := TIniFile.Create(AppPath + 'TestFB.conf');

  S := Ini.ReadString(IniSect, 'ENV_FIREBIRD', '');
  if DirectoryExists(S) then
    SetEnvironmentVariable('FIREBIRD', PChar(S));

  S := Ini.ReadString(IniSect, 'ClientLib', '');

  // Загружаем библиотеку gds32.dll ДО ТОГО, как она будет загружена компонентами IBX
  if LowerCase(ExtractFileName(S)) = 'gds32.dll' then
    HClientLib := LoadLibrary(PChar(S));

  CSStartConnect := TCriticalSection.Create;
end;

procedure DoClear;
begin
  // Необходимо дождаться завершения потока...

  if HClientLib <> 0 then
    FreeLibrary(HClientLib);

  Ini.Free;


  ALog.LogStr('ПРИЛОЖЕНИЕ ЗАКРЫТО');
  ALog.Free;

  CSStartConnect.Free;
end;

{ TCheckActivityThread }

destructor TCheckActivityThread.Destroy;
begin
  Terminate;
  SetEvent(FEvent);
  inherited;
  CloseHandle(FEvent);
end;

procedure TCheckActivityThread.Execute;
begin
  FEvent := CreateEvent(nil, False, False, nil);

  while not Terminated do
  begin
    if WaitForSingleObject(FEvent, 10000) = WAIT_TIMEOUT then
    begin
      if SecondsBetween(Now, LastActiveTime) > 30 then
      begin
        if MessageBox(GetActiveWindow,
          'Видимо приложение зависло!'#13#10+
          'Возможные причины зависания:'#13#10+
          '- ошибка в коде данной программы;'#13#10+
          '- ошибка в коде компонентов IBX;'#13#10+
          '- ошибка в коде библиотеки GDS32.DLL;'#13#10+
          '- ошибка в коде сервера FireBird'#13#10#13#10+
          'Хотите аварийно завершить работу программы?',
          'ВНИМАНИЕ!', MB_ICONWARNING or MB_YESNO) = IDYES then
          TerminateProcess(DWORD(-1), 0);
      end;
    end;
  end;

end;

{ TThreadDBConnect }

procedure TThreadDBConnect.Execute;
var
  SConnect: string;
  FThreadNum: Integer;

begin
  FreeOnTerminate := True; // Освобождаем свой код от заботы по удалению потока
  try
    InterlockedIncrement(ThreadsCount); // Увеличиваем счетчик потоков
    try
      FThreadNum := InterlockedIncrement(ThreadOrderNum); // Получаем порядковый номер потока
      SConnect := 'Thread №' + inttostr(FThreadNum)+': ';

      CSStartConnect.Enter; // Ожидаем, пока пользователь не нажмет кнопку "СТАРТ"
      CSStartConnect.Leave;

      try
        FBConnectDB(IBDB, MustSync);
        InterlockedIncrement(ThreadConnectCount);
        InterlockedIncrement(AllThreadConnCnt);
        ALog.LogStr(SConnect + 'CONNECTED', tlpInformation);
      except
        on E: Exception do
        begin
          InterlockedIncrement(ThreadErrorCount);
          ThreadLastError := SConnect + 'CONNECT ERROR: ' + E.Message;
          ALog.LogStr(ThreadLastError, tlpError);
        end;
      end;

      Sleep(2000); // Эмулируем полезную деятельность (в идеале дисконнекты не должны начинаться раньше коннектов)

      try
        FBDisconnectDB(IBDB, MustSync);
        InterlockedDecrement(ThreadConnectCount);
        InterlockedIncrement(AllThreadDisconnCnt);
        ALog.LogStr(SConnect + 'DISCONNECTED', tlpInformation);
      except
        on E: Exception do
        begin
          InterlockedIncrement(ThreadErrorCount);
          ThreadLastError := SConnect + 'DISCONNECT ERROR: ' + E.Message;
          ALog.LogStr(ThreadLastError, tlpError);
        end;
      end;

    finally
      InterlockedDecrement(ThreadsCount); // Уменьшаем счетчик потоков
      FBFreeIBDataBase(IBDB);
    end;
  except
    on E: Exception do
    begin
      InterlockedIncrement(ThreadErrorCount);
      ThreadLastError := SConnect + 'THREAD ERROR: ' + E.Message;
      ALog.LogStr(ThreadLastError, tlpError);
    end;
  end;

end;

initialization
  DoInit;
finalization
  DoClear;
end.
