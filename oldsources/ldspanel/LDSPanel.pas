{
Copyright (c) 2006, Loginov Dmitry Sergeevich
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

unit LDSPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics, Forms,
  Dialogs, ComCtrls;

type
  TAutoUnDock = (audNone, audToNil, audToParent);

  TLDSPanel = class;

  TMyFloatingForm = class(TCustomDockForm)
  protected
    // Вызывает метод OnClose дочерней панельки
    procedure WM_CLOSE(var Msg: TMessage); message WM_CLOSE;

    // Изменяем Caption на Hint дочерней панели
    procedure DoShow; override;
  end;

  TLDSPanel = class(TPanel)
  private
    FOnClose: TNotifyEvent;
    FOnHideClient: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnPaint: TNotifyEvent;
    FDockBorderSize: Integer;
    FAutoDockSize: Boolean;
    FDockAlign: TAlign;
    FAutoUnDoc: TAutoUnDock;
    FSplitter: TSplitter;
    procedure SetOnClose(const Value: TNotifyEvent);
    procedure SetOnHideClient(const Value: TNotifyEvent);
    procedure SetOnMouseEnter(const Value: TNotifyEvent);
    procedure SetOnMouseLeave(const Value: TNotifyEvent);
    procedure SetOnPaint(const Value: TNotifyEvent);
    procedure SetDockBorderSize(const Value: Integer);
    procedure SetAutoDockSize(const Value: Boolean);

    // Коррертирует размеры дока, т.е. скрывает его, если на нем не осталось ни
    // одного контролла
    procedure DecreaseSize(IsHide: Boolean);
    // Определяет кол-во видимых компонентов на доке
    function GetVisibleControlsCount: Integer;
    procedure SetDockAlign(const Value: TAlign);

    procedure SetAlign(Value: TAlign);
    function GetAlign: TAlign;
    procedure SetAutoUnDoc(const Value: TAutoUnDock);
    procedure SetSplitter(const Value: TSplitter);
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
    procedure SetSizeByAlign(const Value: Integer);
    // Возвращаем размер панельки с учетом выравнивания
    function GetSizeByAlign: Integer;

    procedure CMDockNotification(var Message: TCMDockNotification); message CM_DOCKNOTIFICATION;
    procedure CMMouseEnter(var Message: TMessage); message CM_MouseEnter;
    procedure CMMouseLeave(var Message: TMessage); message CM_MouseLeave;
    procedure WMPaint(var Message: TMessage); message WM_PAINT;
    procedure CMUnDockClient(var  Message: TMessage); message CM_UNDOCKCLIENT;

  protected

    procedure DoDockOver(Source: TDragDockObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    // Ограничим возможности свойства AutoSize (свойство AutoDockSize имеет
    // больший приоритет)
    procedure SetAutoSize(Value: Boolean); override;
    // При изменении Parent можно вызвать SetAutoUnDoc
    procedure SetParent(AParent: TWinControl); override;
    // Вызывается при изменении размеров панели
    procedure Resize; override;
  public
    // На всякий случай сделаем доступным и это свойство
    property Canvas;

    // Это свойство сюда вынесено только, чтобы компилятор не матерился
    procedure DockDrop(Source: TDragDockObject; X, Y: Integer); override;

    constructor Create(AOwner: TComponent); override;
    // Размер панели с учетом выравнивания
    property SizeByAlign: Integer read GetSizeByAlign write SetSizeByAlign;
  published
    // Это событие может наступить только если панель уже отстыкована от дока
    property OnClose: TNotifyEvent read FOnClose write SetOnClose;
    // Это событие может наступить, если нажали на крестик любой панели, которая
    // находится на данном доке
    property OnHideClient: TNotifyEvent read FOnHideClient write SetOnHideClient;   
    // Возникает при внесении курсора мыши в область панели
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write SetOnMouseEnter;
    // Возникает при удалении курсора мыши из области панели
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write SetOnMouseLeave;
    // Вызывается при необходимости перерисовки панели
    property OnPaint: TNotifyEvent read FOnPaint write SetOnPaint;
    // Определяет, каким размером должна рисоваться рамка при причаливании
    // другой панели, если размер данной панели меньше, чем DockBorderSize
    // Кроме того, панель может менять свои размеры при причаливании в
    // соответствии с заданным свойством DockBorderSize
    property DockBorderSize: Integer read FDockBorderSize write SetDockBorderSize default 0;
    // Определяет, следует ли автоматически изменять размеры дока, в соответствии
    // с заданным свойством DockBorderSize. Для того, чтобы это свойство срабатывало,
    // следует устанавливать выравнивание Align
    property AutoDockSize: Boolean read FAutoDockSize write SetAutoDockSize default False;
    // Определяет, как будет отрисовываться рамка причаливания. Особенно актуально
    // для панелей, у которых Align не задано
    property DockAlign: TAlign read FDockAlign write SetDockAlign default alNone;
    // Выравнивание самого компонента. Автоматически устанавливает DockAlign, если
    // Align in [alLeft, alTop, alBottom, alRight]
    property Align: TAlign read GetAlign write SetAlign default alNone;
    // Определяет, куда выполнять причаливание при создании панельки
    property AutoUnDoc: TAutoUnDock read FAutoUnDoc write SetAutoUnDoc default audNone;
    // Определяет соответствующий Splitter. Он будет вовремя прятаться или
    // показываться при изменении размера панели
    property Splitter: TSplitter read FSplitter write SetSplitter;
    // Управляем видимостью панели
    property Visible: Boolean read GetVisible write SetVisible default True;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('loginOFF', [TLDSPanel]);
end;                

{ TMyFloatingForm }

procedure TMyFloatingForm.DoShow;
begin
  inherited;
  if (ControlCount > 0) then
  begin
    if (Controls[0] is TLDSPanel) then Caption := Controls[0].Hint;
    if (Controls[0] is TToolBar) then AutoSize := True;
  end;       
end;

procedure TMyFloatingForm.WM_CLOSE(var Msg: TMessage);
var
  pan: TLDSPanel;
begin
  pan := nil;
  if ControlCount > 0 then pan := TLDSPanel(Controls[0]);
  inherited;
  if (pan is TLDSPanel) and Assigned(pan.FOnClose) then pan.FOnClose(pan);
end;

{ TMyPanel }  

procedure TLDSPanel.CMDockNotification(var Message: TCMDockNotification);
begin
  inherited;
  with Message.NotifyRec^ do
    if (ClientMsg = CM_VISIBLECHANGED) and not Boolean(MsgWParam) then
    begin
      if Assigned(FOnHideClient) then FOnHideClient(Self);
      DecreaseSize(True);
    end;                 
end;

procedure TLDSPanel.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TLDSPanel.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TLDSPanel.CMUnDockClient(var Message: TMessage);
begin
  inherited;
  DecreaseSize(False);
end;

constructor TLDSPanel.Create(AOwner: TComponent);
begin
  inherited;
  FloatingDockSiteClass := TMyFloatingForm;
end;

procedure TLDSPanel.DecreaseSize(IsHide: Boolean);
begin
  if not AutoDockSize then Exit;
  if (IsHide and (GetVisibleControlsCount = 0)) or
     (not IsHide and (GetVisibleControlsCount = 1)) then
     begin
       case Align of
         alLeft, alRight: Width := 0;
         alTop, alBottom: Height := 0;
       end;
     end;
end;

procedure TLDSPanel.DockDrop(Source: TDragDockObject; X, Y: Integer);
begin
  inherited;

  if not AutoDockSize then Exit;
  if not (Align in [alLeft, alTop, alBottom, alRight]) then Exit;
  if (Align in [alLeft, alRight]) and (Width >= DockBorderSize) then Exit;
  if (Align in [alTop, alBottom]) and (Height >= DockBorderSize) then Exit;

  case Align of
    alLeft, alRight: Width := DockBorderSize;
    alTop, alBottom: Height := DockBorderSize;
  end;
end;

procedure TLDSPanel.DoDockOver(Source: TDragDockObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  Rct: TRect;
begin
  inherited;

  if not (DockAlign in [alLeft, alTop, alBottom, alRight]) or not Accept
    or (DockBorderSize < 10) then Exit;

  if (DockAlign in [alLeft, alRight]) and (Width > DockBorderSize) then Exit;
  if (DockAlign in [alTop, alBottom]) and (Height > DockBorderSize) then Exit;

  case DockAlign of
    alLeft:
      begin
        Rct.TopLeft := ClientToScreen(Point(0, 0));
        Rct.BottomRight := ClientToScreen(Point(DockBorderSize, Height));
      end;

    alTop:
      begin
        Rct.TopLeft := ClientToScreen(Point(0, 0));
        Rct.BottomRight := ClientToScreen(Point(Width, DockBorderSize));
      end;

    alBottom:
      begin
        Rct.TopLeft := ClientToScreen(Point(0, Height - DockBorderSize));
        Rct.BottomRight := ClientToScreen(Point(Width, Height));
      end;
      
    alRight:
      begin
        Rct.TopLeft := ClientToScreen(Point(Width - DockBorderSize, 0));
        Rct.BottomRight := ClientToScreen(Point(Width, Height));
      end;
  end;
  Source.DockRect := Rct;
end;

procedure TLDSPanel.SetAutoDockSize(const Value: Boolean);
begin
  FAutoDockSize := Value;
  if Value then AutoSize := False;
end;

procedure TLDSPanel.SetDockBorderSize(const Value: Integer);
begin
  FDockBorderSize := Value;
end;

procedure TLDSPanel.SetOnClose(const Value: TNotifyEvent);
begin
  FOnClose := Value;
end;

procedure TLDSPanel.SetOnHideClient(const Value: TNotifyEvent);
begin
  FOnHideClient := Value;
end;

procedure TLDSPanel.SetOnMouseEnter(const Value: TNotifyEvent);
begin
  FOnMouseEnter := Value;
end;

procedure TLDSPanel.SetOnMouseLeave(const Value: TNotifyEvent);
begin
  FOnMouseLeave := Value;
end;

procedure TLDSPanel.SetOnPaint(const Value: TNotifyEvent);
begin
  FOnPaint := Value;
end;

function TLDSPanel.GetVisibleControlsCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ControlCount - 1 do
    if Controls[I].Visible then Inc(Result);    
end;

procedure TLDSPanel.WMPaint(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

procedure TLDSPanel.SetAutoSize(Value: Boolean);
begin
  if AutoDockSize then inherited SetAutoSize(False) else inherited;
end;

procedure TLDSPanel.SetDockAlign(const Value: TAlign);
begin
  FDockAlign := Value;
end;

procedure TLDSPanel.SetAlign(Value: TAlign);
begin
  inherited Align := Value;
  if Value in [alLeft, alTop, alBottom, alRight] then DockAlign := Value;
end;

function TLDSPanel.GetAlign: TAlign;
begin
  Result := inherited Align;
end;

procedure TLDSPanel.SetAutoUnDoc(const Value: TAutoUnDock);
begin
  FAutoUnDoc := Value;
  if not (csDesigning	in ComponentState) and (Parent <> nil) then
  begin
    if AutoUnDoc = audToNil then ManualDock(nil)
    else if AutoUnDoc = audToParent then ManualDock(Parent, nil, alClient);
  end;         
end;

procedure TLDSPanel.SetParent(AParent: TWinControl);
begin
  inherited;
  if AutoUnDoc = audToParent then AutoUnDoc := AutoUnDoc;
end;

procedure TLDSPanel.SetSplitter(const Value: TSplitter);
begin
  FSplitter := Value;
  if Assigned(FSplitter) then
  begin
    FSplitter.AutoSnap := False;
    FSplitter.MinSize := 1;
    if Align in [alLeft, alTop, alBottom, alRight] then FSplitter.Align := Align;
  end;    
end;

procedure TLDSPanel.Resize;
begin
  inherited;

  if Assigned(FSplitter) and (Align in [alLeft, alTop, alBottom, alRight]) then
  begin
    FSplitter.Align := Align;
    if GetSizeByAlign <= 0 then
      FSplitter.Visible := False
    else
      if not FSplitter.Visible then
      begin
        case Align of
          alLeft: FSplitter.Left := Width + 5;
          alTop: FSplitter.Top := Height + 5;
          alBottom: FSplitter.Top := Top - 5;
          alRight: FSplitter.Left := Left - 5;
        end;
        FSplitter.Visible := True;
      end;
  end;   
end;

function TLDSPanel.GetSizeByAlign: Integer;
begin
  if Align in [alLeft, alRight] then Result := Width else
    if Align in [alTop, alBottom] then Result := Height else
      Result := 0;
end;

procedure TLDSPanel.SetSizeByAlign(const Value: Integer);
begin
  if Align in [alLeft, alRight] then Width := Value else
    if Align in [alTop, alBottom] then Height := Value;
end;

function TLDSPanel.GetVisible: Boolean;
begin
  Result := inherited Visible;
end;

procedure TLDSPanel.SetVisible(const Value: Boolean);
begin
  if Value and (Parent is TLDSPanel) and (TLDSPanel(Parent).SizeByAlign <= 0) then
    TLDSPanel(Parent).SizeByAlign := TLDSPanel(Parent).DockBorderSize;

  inherited Visible := Value;
end;


end.
