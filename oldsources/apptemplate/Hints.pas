unit Hints;

{
  В данном модуле реализованы собственные всплывающие подсказки.
  Автор модуля - Сергей Королев.

  Я взял данный модуль к себе в помощь, и исправил ошибки,
  связанные с неправильным вызовом FOldMessageEvent
  (раньше функция OnMessage могла рекурсивно вызывать сама себя, из-за чего
  стэк сразу переполнялся)

  Как можно использовать данный модуль:
    вы можете выполнять проверку введенных пользователем данных (напр., в TEdit)
    в обработчике события OnExit. Если введены ошибочные данные, то не
    нужно вызывать назойливое окно об ошибке, а достаточно вызвать функцию
    ShowErrorHint(Edit1, 'Вы ввели некорректные данные!');
    В результате фокус автоматически установится на проблемном компоненте,
    и появится всплывающая подсказка с указанным вами текстом. Она будет висет
    до тех пор, пока вы не нажмете какую либо клавишу на клавиатуре или мышке.
    При этом все остальные элементы управления будут заблокированы (ведь каждый
    вызывается обработчик события OnExit)
    Изменить шрифты можно, только если влезть в методы Create или Paint
}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls;

type
  EHintError = class(Exception);

  TCustomHintWindow = class(THintWindow)
  protected
    FOldMessageEvent : TMessageEvent;
    procedure OnMessage(var Msg: TMsg; var Handled: Boolean);
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
  public
    procedure CancelHint;
    function IsHintMsg(var Msg: TMsg): Boolean; override;
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
  end;

  TErrorHintWindow = class(TCustomHintWindow)
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  THelperHintWindow = class(TCustomHintWindow)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  ErrorHintWindow : TErrorHintWindow;
  HelperHintWindow : THelperHintWindow;

procedure ShowErrorHintEx(AControl: TWinControl; const Hint: String);
procedure ShowErrorHint(AControl: TWinControl; const Hint: String);
procedure ShowHelperHint(P : TPoint; const Hint: String);

implementation

const
  sGeneralError = 'Хитрая ошибка в модулe Hints';
  MaxWidth = 300;

procedure ShowHelperHint(P : TPoint; const Hint: String);
var
  WinRect: TRect;
  CHint: array [0..255] of Char;
begin
  WinRect := Bounds(P.X, P.Y, MaxWidth, 0);
  DrawText(HelperHintWindow.Canvas.Handle, StrPCopy(CHint, Hint), -1,
    WinRect, DT_CALCRECT or DT_LEFT or DT_WORDBREAK or DT_NOPREFIX);
  Inc(WinRect.Right, 6);
  Inc(WinRect.Bottom, 4);
  HelperHintWindow.ActivateHint(WinRect, Hint);
end;

procedure ShowErrorHintEx(AControl: TWinControl; const Hint: String);
begin
  ShowErrorHint(AControl, Hint);
  raise EAbort.Create('');
end;

procedure ShowErrorHint(AControl: TWinControl; const Hint: String);
var
  WinRect: TRect;
  CHint: array [0..255] of Char;
begin
  if not Assigned(AControl) then raise EHintError.Create(sGeneralError);
  if AControl.Showing then AControl.SetFocus;
  WinRect := Bounds(6, AControl.Height + 1, MaxWidth - 2, 0);
  ErrorHintWindow.HandleNeeded;
// ErrorHintWindow.Canvas.Font.Style := [fsBold];
  // Уточняются размеры области вывода текста (WinRect)
  DrawText(ErrorHintWindow.Canvas.Handle, StrPCopy(CHint, Hint), -1,
    WinRect, DT_CALCRECT or DT_LEFT or DT_WORDBREAK or DT_NOPREFIX);
  Inc(WinRect.Right, 6);
  Inc(WinRect.Bottom, 4);
  WinRect.TopLeft := AControl.ClientToScreen(WinRect.TopLeft);
  WinRect.BottomRight := AControl.ClientToScreen(WinRect.BottomRight);
  ErrorHintWindow.ActivateHint(WinRect, Hint);
end;

constructor THelperHintWindow.Create(AOwner: TComponent);
begin
  inherited;
  Color := clLime;
end;

constructor TErrorHintWindow.Create(AOwner: TComponent);
begin
  inherited;
  Color := clRed;
end;

procedure TErrorHintWindow.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  Canvas.Font.Color := clWhite;
  // Canvas.Font.Style := [fsBold];
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
    DT_WORDBREAK);
end;

procedure TCustomHintWindow.WMNCPaint(var Message: TMessage);
begin
  Canvas.Handle := GetWindowDC(Handle);
  with Canvas do
  try
    Pen.Style := psSolid;
    Pen.Color := clMaroon;
    Rectangle(0, 0, Width, Height);
  finally
    Canvas.Handle := 0;
  end;
end;

procedure TCustomHintWindow.ActivateHint(Rect: TRect; const AHint: string);
begin
  Height := Rect.Bottom - Rect.Top + 1;
  Width := Rect.Right - Rect.Left + 1;
  inherited ActivateHint(Rect, AHint);
  FOldMessageEvent := Application.OnMessage;
  Application.OnMessage := OnMessage;
end;

procedure TCustomHintWindow.CancelHint;
begin
  Application.OnMessage := FOldMessageEvent;
  Visible := False;
  if HandleAllocated then ShowWindow(Handle, SW_HIDE);
end;

function TCustomHintWindow.IsHintMsg(var Msg: TMsg): Boolean;
begin
  with Msg do
  begin
    Result := ((Message >= WM_KEYFIRST) and (Message <= WM_KEYLAST)) or
      (Message = CM_ACTIVATE) or (Message = CM_DEACTIVATE) or (Message = CM_APPKEYDOWN) or
      (Message = CM_APPSYSCOMMAND) or (Message = WM_COMMAND) or
      ((Message > WM_MOUSEMOVE) and (Message <= WM_MOUSELAST)) or
      ((Message > WM_NCMOUSEMOVE) and (Message <= WM_NCMBUTTONDBLCLK));
    if Result then Result := (Message <> WM_KEYUP) and (Message <> WM_SYSKEYUP) and
      (Message <> WM_NCLBUTTONUP) and (Message <> WM_NCRBUTTONUP) and
      (Message <> WM_NCMBUTTONUP) and (Message <> WM_LBUTTONUP) and
      (Message <> WM_RBUTTONUP) and (Message <> WM_MBUTTONUP);
  end;
end;

procedure TCustomHintWindow.OnMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if IsHintMsg(Msg) then CancelHint;  
  if Assigned(FOldMessageEvent) and (@Application.OnMessage <> @FOldMessageEvent) then
    FOldMessageEvent(Msg, Handled);
end;

initialization
  ErrorHintWindow := TErrorHintWindow.Create(nil);
  HelperHintWindow := THelperHintWindow.Create(nil);
finalization
  HelperHintWindow.Free;
  ErrorHintWindow.Free;
end.
