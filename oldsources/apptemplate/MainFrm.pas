{
Copyright (c) 2003-2006, Loginov Dmitry Sergeevich
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

unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, ExtCtrls, LDSPanel, Menus, StdCtrls,
  ActnList, ImgList, ActnCtrls, StdActns, AppEvnts, ShellAPI,
  Buttons, JvFormPlacement, JvComponentBase, JvAppStorage, JvAppRegistryStorage;

type
  TTlbrFloatingForm = class(TCustomDockForm)
  protected
    procedure WM_CLOSE(var Msg: TMessage); message WM_CLOSE;   
    procedure DoShow; override;
  end;

  TMainForm = class(TForm)
    panLeftDock: TLDSPanel;
    cbrTop: TControlBar;
    tlbrStandart: TToolBar;
    panRightDock: TLDSPanel;
    mmMain: TMainMenu;
    mmiFile: TMenuItem;
    mmiHelp: TMenuItem;
    mmiQuit: TMenuItem;
    mmiAbout: TMenuItem;
    ToolButton1: TToolButton;
    imglstIcons: TImageList;
    mmiWindows: TMenuItem;
    mmiMDICascade: TMenuItem;
    mmiMDIHTitle: TMenuItem;
    mmiMDIVTitle: TMenuItem;
    mmiMDIClose: TMenuItem;
    mmiMDIMinimizeAll: TMenuItem;
    mmiMDIArrange: TMenuItem;
    ActionList1: TActionList;
    FileExit1: TFileExit;
    WindowClose1: TWindowClose;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowArrange1: TWindowArrange;
    tlbrWindows: TToolBar;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    stsbrStatusBar: TStatusBar;
    actnStandartTlbr: TAction;
    actnWindowsTlbr: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    actnStatusBar: TAction;
    N5: TMenuItem;
    tmrDateTimeUpdate: TTimer;
    aplevntMain: TApplicationEvents;
    actnShowAbout: TAction;
    spltrLeft: TSplitter;
    panTreeView: TLDSPanel;
    TreeView1: TTreeView;
    spltrRight: TSplitter;
    actnObservTree: TAction;
    N6: TMenuItem;
    ToolButton5: TToolButton;
    cbrBottom: TControlBar;
    Button1: TButton;
    actnNewChild: TAction;
    N7: TMenuItem;
    N8: TMenuItem;
    Button2: TButton;
    Button3: TButton;
    JvAppRegistryStorage1: TJvAppRegistryStorage;
    FormStorage: TJvFormStorage;
    procedure mmiQuitClick(Sender: TObject);
    procedure cbrTopGetSiteInfo(Sender: TObject; DockClient: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure panLeftDockGetSiteInfo(Sender: TObject; DockClient: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
    procedure actnStandartTlbrExecute(Sender: TObject);
    procedure actnWindowsTlbrExecute(Sender: TObject);
    procedure actnStatusBarExecute(Sender: TObject);
    procedure stsbrStatusBarResize(Sender: TObject);
    procedure tmrDateTimeUpdateTimer(Sender: TObject);
    procedure aplevntMainHint(Sender: TObject);
    procedure actnShowAboutExecute(Sender: TObject);
    procedure actnObservTreeExecute(Sender: TObject);
    procedure panLeftDockHideClient(Sender: TObject);
    procedure spltrRightMoved(Sender: TObject);
    procedure cbrBottomResize(Sender: TObject);
    procedure FormStorageRestorePlacement(Sender: TObject);
    procedure FormStorageSavePlacement(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure actnNewChildExecute(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure aplevntMainMessage(var Msg: tagMSG; var Handled: Boolean);
  private
    { Private declarations }
    function GetVisibleControlCount(AControl: TWinControl): Integer;

    // Возвращает имя текущей раскладки. Вызывается в таймете, хотя можно
    // отлавливать сообщение переключения раскладки в
    // Application.OnMessage
    function GetKeyLanguageName: string;

    // Сохраняет позицию контрола с именем AControlName
    procedure SaveWinControlPos(AControl: TWinControl);
    // Загружает позицию контрола с именем AControlName
    procedure LoadWinControlPos(AControl: TWinControl);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses TestChildFrm, GlobalsUnit, ProgressViewer;

{$R *.dfm}

const
  SBPANEL_HINT = 0;
  SBPANEL_DATE = 1;
  SBPANEL_TIME = 2;
  SBPANEL_LANG = 3;

{ TMyFloatingForm }

procedure TTlbrFloatingForm.DoShow;
begin
  inherited;
  // Блокируем все попытки пользователя изменить размеры окошка
  AutoSize := True;
end;

procedure TTlbrFloatingForm.WM_CLOSE(var Msg: TMessage);
begin
  // Информируем главную форму, что соответствующая панелька закрылась.
  with MainForm do
  begin
    if Self.Controls[0] = tlbrStandart then actnStandartTlbr.Checked := False;
    if Self.Controls[0] = tlbrWindows then actnWindowsTlbr.Checked := False; 
  end;
  
  // Закрываем саму форму
  inherited;
end;

procedure TMainForm.mmiQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.cbrTopGetSiteInfo(Sender: TObject;
  DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
  var CanDock: Boolean);
begin
  // Разрешаем причаливать только инструментальные панельки
  CanDock := DockClient is TToolBar;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  // Заменяем класс окна. Это окно информирует нас в случае закрытия
  // инструментальной панельки
  tlbrStandart.FloatingDockSiteClass := TTlbrFloatingForm;
  tlbrWindows.FloatingDockSiteClass := TTlbrFloatingForm;

  // Обновляем текущие дату и время
  tmrDateTimeUpdateTimer(nil);

  stsbrStatusBar.Panels[SBPANEL_LANG].Text := GetKeyLanguageName;
  // Показываем копирайт в строке состояния
  stsbrStatusBar.Panels[SBPANEL_HINT].Text := SShortCopyRight;

  // Настраиваем местоположение компонентов
  panTreeView.ManualDock(panLeftDock, nil, alClient);

  try
    FormStorage.RestoreFormPlacement;
  except
  end;
end;

procedure TMainForm.panLeftDockGetSiteInfo(Sender: TObject;
  DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
  var CanDock: Boolean);
begin
  CanDock := DockClient is TPanel;
end;

procedure TMainForm.actnStandartTlbrExecute(Sender: TObject);
begin
  with (Sender as TAction) do
  begin
    Checked := not Checked;
    tlbrStandart.Visible := Checked;
  end;
end;

procedure TMainForm.actnWindowsTlbrExecute(Sender: TObject);
begin
  with (Sender as TAction) do
  begin
    Checked := not Checked;
    tlbrWindows.Visible := Checked;
  end;
end;

procedure TMainForm.actnStatusBarExecute(Sender: TObject);
begin
  with (Sender as TAction) do
  begin
    Checked := not Checked;
    stsbrStatusBar.Visible := Checked;
    cbrBottomResize(nil)
  end;
end;

// Корректируем размеры панели состояния
procedure TMainForm.stsbrStatusBarResize(Sender: TObject);
begin
  with stsbrStatusBar do
  begin
    Panels[SBPANEL_HINT].Width := Width - 210;
    Panels[SBPANEL_LANG].Width := 60;
    Panels[SBPANEL_DATE].Width := 80;
    Panels[SBPANEL_TIME].Width := 80;
  end;
end;

// Обновляем текущую дату и время
procedure TMainForm.tmrDateTimeUpdateTimer(Sender: TObject);
begin
  with stsbrStatusBar do
  begin
    Panels[SBPANEL_DATE].Text := DateToStr(Date);
    Panels[SBPANEL_TIME].Text := TimeToStr(Time);
  end;
end;

// Обрабатываем появление подсказок
procedure TMainForm.aplevntMainHint(Sender: TObject);
begin
  if Trim(Application.Hint) <> '' then
    stsbrStatusBar.Panels[SBPANEL_HINT].Text := Application.Hint
  else
    stsbrStatusBar.Panels[SBPANEL_HINT].Text := SShortCopyRight;
end;

// Показывает окно "О Программе"
procedure TMainForm.actnShowAboutExecute(Sender: TObject);
begin
  ShellAbout(Application.Handle, SShortProgramName, SShortCopyRight, Application.Icon.Handle);
end;

procedure TMainForm.actnObservTreeExecute(Sender: TObject);
begin
  with Sender as TAction do
  begin
    Checked := not Checked;
    panTreeView.Visible := Checked;
  end;
end;

procedure TMainForm.panLeftDockHideClient(Sender: TObject);
begin
  actnObservTree.Checked := False;
end;

// Следующие 2 процедуры в дальнейшем можно будет вынести в компонент!!!
function TMainForm.GetVisibleControlCount(AControl: TWinControl): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to AControl.ControlCount - 1 do
    if AControl.Controls[I].Visible then Inc(Result);
end;

procedure TMainForm.spltrRightMoved(Sender: TObject);
var
  Cur: TPoint;
  BorderWidth: Integer;
begin
  // При данном условии сплиттер не работает, поэтому мы должны ему помочь
  if GetVisibleControlCount(cbrTop) = 0 then
  begin
    Cur := ScreenToClient(Mouse.CursorPos);
    BorderWidth := (Width - ClientWidth) div 2;
    if Cur.X < BorderWidth + 5 then Cur.X := BorderWidth + 5;
    if Cur.X > Width - BorderWidth - 7 then Cur.X := Width - BorderWidth - 7;
    panRightDock.Width := ClientWidth - Cur.X - BorderWidth div 2;
  end;
end;
// Предыдущие 2 процедуры в дальнейшем можно будет вынести в компонент!!!

procedure TMainForm.cbrBottomResize(Sender: TObject);
begin
  cbrBottom.Top := stsbrStatusBar.Top - cbrBottom.Height;   
end;

function TMainForm.GetKeyLanguageName: string;
var
  S: string;
begin
  SetLength(S, 8);
  GetKeyboardLayoutName(PChar(S));
  if S = '00000419' then
    Result := 'RU'
  else
    Result := 'EN';
    
 // if S = '00000409' then // В win 98 такое сравнение не работает
 //   Result := 'EN'


end;

procedure TMainForm.FormStorageRestorePlacement(Sender: TObject);
begin
  if SaveControlsPosToIni then
  begin
    LoadWinControlPos(panTreeView);
    LoadWinControlPos(tlbrStandart);
    LoadWinControlPos(tlbrWindows);

    with FormStorage do
    begin
      actnObservTree.Checked := StrToBool(ReadString('actnObservTree_Checked', '1'));
      actnStandartTlbr.Checked := StrToBool(ReadString('actnStandartTlbr_Checked', '1'));
      actnStatusBar.Checked := StrToBool(ReadString('actnStatusBar_Checked', '1'));
      actnWindowsTlbr.Checked := StrToBool(ReadString('actnWindowsTlbr_Checked', '1'));
      stsbrStatusBar.Visible := StrToBool(ReadString('stsbrStatusBar_Visible', '1'));
    end;
    
  end;
end;

procedure TMainForm.FormStorageSavePlacement(Sender: TObject);
begin
  if SaveControlsPosToIni then
  begin
    SaveWinControlPos(panTreeView);
    SaveWinControlPos(tlbrStandart);
    SaveWinControlPos(tlbrWindows);

    with FormStorage do
    begin
      WriteString('actnObservTree_Checked', BoolToStr(actnObservTree.Checked));
      WriteString('actnStandartTlbr_Checked', BoolToStr(actnStandartTlbr.Checked));
      WriteString('actnStatusBar_Checked', BoolToStr(actnStatusBar.Checked));
      WriteString('actnWindowsTlbr_Checked', BoolToStr(actnWindowsTlbr.Checked));
      WriteString('stsbrStatusBar_Visible', BoolToStr(stsbrStatusBar.Visible));
    end;
    
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    FormStorage.SaveFormPlacement;
  except
  end;
end;

procedure TMainForm.LoadWinControlPos(AControl: TWinControl);
var
  S, AControlName: string;
begin

  with FormStorage do
  begin
    AControlName := AControl.Name;
    S := ReadString(AControlName + '_ParentName', AControl.Parent.Name);
    AControl.ManualDock(TWinControl(Self.FindComponent(S)), nil, alClient);
    if S = '' then
    begin
      AControl.Parent.Left   := ReadInteger(AControlName + '_DockLeft', AControl.Parent.Left);
      AControl.Parent.Top    := ReadInteger(AControlName + '_DockTop', AControl.Parent.Top);
      AControl.Parent.Height := ReadInteger(AControlName + '_DockHeight', AControl.Parent.Height);
      AControl.Parent.Width  := ReadInteger(AControlName + '_DockWidth', AControl.Parent.Width);
    end else
    begin
      AControl.Left   := ReadInteger(AControlName + '_Left', AControl.Left);
      AControl.Top    := ReadInteger(AControlName + '_Top', AControl.Top);

      // Следующие 2 свойства обычно эффекта не имеют, хотя, кто знает...
      AControl.Height := ReadInteger(AControlName + '_Height', AControl.Height);
      AControl.Width  := ReadInteger(AControlName + '_Width', AControl.Width);
    end;
    AControl.Visible := StrToBool(ReadString(AControlName + '_Visible', '1'));
  end;

end;

procedure TMainForm.SaveWinControlPos(AControl: TWinControl);
var
  AControlName: string;
begin

  with FormStorage do
  begin
    AControlName := AControl.Name;
    // Запоминаем имя родителя
    WriteString(AControlName + '_ParentName', AControl.Parent.Name);
    // Запоминаем видимость
    WriteString(AControlName + '_Visible', BoolToStr(AControl.Visible));
    if AControl.Parent.Name = '' then
    begin
      WriteInteger(AControlName + '_DockLeft', AControl.Parent.Left);
      WriteInteger(AControlName + '_DockTop', AControl.Parent.Top);
      WriteInteger(AControlName + '_DockHeight', AControl.Parent.Height);
      WriteInteger(AControlName + '_DockWidth', AControl.Parent.Width);
    end else
    begin
      WriteInteger(AControlName + '_Left', AControl.Left);
      WriteInteger(AControlName + '_Top', AControl.Top);
      WriteInteger(AControlName + '_Height', AControl.Height);
      WriteInteger(AControlName + '_Width', AControl.Width);
    end;
  end;

end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  raise Exception.Create('Текст ошибки!');
end;

procedure TMainForm.actnNewChildExecute(Sender: TObject);
begin
  TTestChildForm.Create(Self);
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  R: Real;
begin
  with TProgressViewer.Create('Визуализация без процентов', False) do
  try
    R := 0;
    while R < 1000000000 do
      R := R + 1;  

  finally
    Terminate;
  end;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  R: Double;
  Counter: Integer;
begin
  with TProgressViewer.Create('Визуализация с процентами', True) do
  try
    R := 0;
    Counter := 0;
    while R < 1000000000 do
    begin
      Inc(Counter);
      if Counter mod 1000 = 0 then
        CurrentValue := R / 10000000;
      R := R + 1;
    end;

  finally
    Terminate;
  end;
end;

procedure TMainForm.aplevntMainMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if Msg.message = WM_INPUTLANGCHANGEREQUEST then
  begin
    ActivateKeyboardLayout(Msg.lParam, HKL_NEXT);
    stsbrStatusBar.Panels[SBPANEL_LANG].Text := GetKeyLanguageName;
  end;

end;

end.
