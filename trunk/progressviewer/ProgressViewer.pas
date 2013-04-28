{
Copyright (c) 2005-2008, Loginov Dmitry Sergeevich
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
{ ������ ProgressViewer - ������ ������������ ���������� ��������             }
{ (c) 2005 - 2008 ������� ������� ���������                                   }
{ ��������� ����������: 27.01.2008                                            }
{ ����� �����: http://www.loginovprojects.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ ���� ����������� �� ��������� ������ ��������� �� ��������� �����������     }
{ ����, ���� ������ � �������� ����� �����. ����� ��������� � ������ ������   }
{ ���� ����������� � ��� �������.                                             }
{                                                                             }
{ *************************************************************************** }

unit ProgressViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, SyncObjs;

{
  �����-����� TProgressViewer ��������� ������������ ���� ���������� �����������
  ��������, ����������� � ������ (� ��������� � ��������) ������.
  � ������ ��������� Execute �� API ��������� ����� ������, � ������� ����������
  � ����������� ����������� ��������� (������������ ����� TBitmap).
  ��� ���������� ������ �������� ������� ������������ ����� Terminate.

  ������� �������������
  1) ��� ������������ ���� �������� �������������� ������������:
  with TProgressViewer.Create('������������ ��� ���������', False) do
  try
    Sleep(10000); // ����� ����������� ���������� ��������
  finally
    Terminate;
  end;

  2) ��� ������������ ���� �������� � ���������� �������� ����������:
  with TProgressViewer.Create('������������ � ����������', True) do
  try
    for I := 1 to 1000 do
    begin
      CurrentValue := I / 10;
      if CancelByUser then Break;
      //CheckCancelByUser;
      Sleep(1); // ��������, ����� ���� �� ������� ����� ��
    end;
  finally
    Terminate;
  end;
}

{

  16.12.2007
    - ���������� ������, ��������� � ������ ��������� ���� �������
  ����������, ���� �� ����� ������������ ���� ��������� ���������� ����������
  ����� VCL-�����. �������� �������� ������ LockCanvas � UnlockCanvas,
  ������� �������������� ��������� � ������������ ����� ��� ���� ������������
  � �������������� ������ �������� TBitmap. ���������� ����� � ��������������
  ������ ���������� ������ ��� ��������� ����� �� �������. ������ ������
  GDI-�������� �� ���������.
    - ��������� ������ "������" � ��������� ������� "Escape". ��. ����� CancelByUser

    - ������� �������� ������ ����� ��������� ���������� � ���� ���������. ���
  ����� ������� ������������ ������� AddStringInfo(). ��� ��� ����������� ����� ������,
  ������������ ������� ������ ��������� ���������, ����� ���������, � �����
  �������������� ���������, � ������� ������� ����� �������� ����� ��������
  ������. �� ��������� ��������� � ������� -1 ���������� �������� �����������,
  � ��������� � ������� 0 - ��� ������� ��������.

  17.12.2007
    - �������� ����� SetWndWidth, ����������� �������� ������ ���� ������������.
  �������� � ����������� ������, �.�. �� �������� ��������� �� ��������� ��������,
  � ���������� �������� ���� ������ � ���, ��� ��� ��������� ��������
  ��������� �������� ������ ����.

  25.12.2007
    - ��������� ������� RegisterProgressWndClass, ����������� ����������� ������
  ���� ��� ������ ���������.
    - ��������� ����� SetCancelBtnVisible. ������ � ��� ��� ������� SendMessage,
  � ������-�������� ��������������� ���� FNewBtnVisible, ������� ����������� �
  ������� CheckWidthAndVisible. � ����� �� ������ ������������ �� ������� ���������
  ������, ��������� ����������� �� ��� � ���� ����� �����������.
    - ������ ��� ��������� ����������� ������ WM_PAINT ���������� ����������������
  ��������� WM_DOPAINT. ������� ��� �������, ���� ��� ������ ����� ������ �������������.
    - �������� � �������� �������� TBitmap ���������� ����, ��� � �������� -
  � ����������� � ����������.

  26.12.2007
    - �������� ����� ChangeStringInfo(), ����������� �������� ������������
  �������� ��������� ������.

  27.12.2007
    - ��������� ���������� ProgressWaitLabel1 � ProgressWaitLabel2, ������������
  ��������� ���������, ������� ������ ��������� ��� ������� ���������. ������
  ��� ������ ����� ��������� ���� �������� ����� �� ��������. �� �������:
  1001 � 1002 ��������������.
    - ������ � ����� ����������� ����� �������� ����� �����.
    - ��������� �� ������� ���������� � ������ RESOURCESTRING
    - �������� ������������� ����� AddStringInfo(), � ������� ������ ������
  ���������� ���������� ������ TStringInfo.

  27.01.2008
    - ��������� ����������� ������� �������� �� ��������� ��� ������ (����, ������,
  ���, �����) (�� ������� ���� �������� ���������������, �������� � �������
  ��������� CanUseDefaultFontStyle.).
    - ���������� ������, ��������� � ������������ ����������� ������. �������
  �������������� �������� � ����� �� 10 �������� 2 ���� ������ ������. � ����������
  ����� ��� ���������� (���� ��� �������� �����).
    - �������� ���� ����� ���������� - EProgressException
    - �������� ����� CheckCancelByUser, ������������ ���������� EProgressCancelByUser
  � ������ ������ �������� �������������. � ���� ���������� ���������� ��������
  ���������� ������������ �������� ������ ����� � �� ������� ��� �������������
  �������� ��������� ��������� ����������.
  }


  { ��������� ��������� ���������� � �������� ������� ������ ����. ��-���������
    ���������. �������� �� ����������, �� ���� ����� �������, �� � �� ������}
  {.$DEFINE CanRaiseException}

  { ��������� ������������ ����� ������ �� ���������. ���� ��� ������ �������
    AddStringInfo() �������� AFontStyle �� �����������, ��� �����
    [fsBold, fsItalic, fsUnderline, fsStrikeOut], �� ������� �������� �� ���������,
    �.�. FDefaultFontStyle ��� GlobalDefaultFontStyle. � ������ ��, ���� ������
    ����� ���������, �� ��������, ��� ����������� ��� ������ �������
    AddStringInfo(), ����� �������������� }
  {$DEFINE CanUseDefaultFontStyle}

const
  {$IFDEF CanUseDefaultFontStyle}
  FontStyleNone = [fsBold, fsItalic, fsUnderline, fsStrikeOut];
  {$ELSE}
  FontStyleNone = [];
  {$ENDIF}

type
  TProgressViewer = class;
  TAdditionalThread = class;

  EProgressException = class(Exception);
  EProgressCancelByUser = class(EProgressException);

  TProgressMethod = procedure(AThread: TProgressViewer) of Object;

  TStringInfo = record
    sLineNumber: Integer; // ����� ������
    sText: string; // ����� ������
    sAlignment: TAlignment; // ������������
    sLineBreak: Boolean; // ������� �����
    sFontName: TFontName; // ��� ������
    sFontSize: Integer; // ������ ������
    sFontStyle: TFontStyles; // ����� ������
    sFontColor: TColor; // ���� ������
    sLineHeight: Integer; // ������ ������. ��������� ����
  end;

  TStringInfoParams = (sipText, sipAlignment, sipLineBreak, sipFontName,
    sipFontSize, sipFontStyles, sipFontColor);

  TProgressViewer = class(TThread)
  private
    FCurrentValue: Double;  
    FShowAsPercentBar: Boolean;
    FFormLeftTop: TPoint;
    FBitmap: TBitmap;
    FFonBitmap: TBitmap;
    FTextBitmap: TBitmap;
    FBMPLine: TBitmap;

    FhWindow: HWND;
    FhButton: HWND;
    FForegroundWindow: HWND;

    FStartTime: TDateTime;
    FAdditionalThread: TAdditionalThread;

    FStringInfoCS: TCriticalSection;
    FDataCS: TCriticalSection;

    FStringInfo: array of TStringInfo;

    FBufferIsReady: Boolean;

    FWndWidth: Integer;
    FWndHeight: Integer;

    FNewWidth: Integer; // ����� �������� ������ ������
    FNewBtnVisible: Boolean;

    FCancelByUser: Boolean;
    FCancelBtnVisible: Boolean;

    FBGColor: TColor;
    FText: string;
    FOnCancelByUser: TNotifyEvent;
    FDefaultFontColor: TColor;
    FDefaultFontSize: Integer;
    FDefaultFontStyle: TFontStyles;
    FDefaultFontName: string;

    procedure DrawProgress;

    { ������� API-���� ������ � ��������� }
    procedure CreateNewWnd;

    { ���������� ������ �������� � ������� FStringInfo �� sLineNumber }
    function GetLineNumberIndex(LineNumber: Integer): Integer;

    procedure SetText(const Value: string);

    { ��������� ����� ���� ������������ �������� TBitmap }
    procedure LockCanvas;

    { ������� ���������� ����� ���� ������������ �������� TBitmap }    
    procedure UnLockCanvas;

    { ������������ ��������� ���� � ����� � ������ }
    procedure RegisterWnd;

    { ������� ���������� � ������ � ���� �� ������ ����������� }
    procedure UnRegisterWnd;
    
    procedure SetCancelBtnVisible(const Value: Boolean);

    { ������������� ����� ������� ���� ������������. }
    procedure SetWndSize(NewWidth: Integer; NewHeight: Integer = -1);

    { ��������� ���������� ������� FStringInfo }
    procedure SortStringInfoArray;
    procedure SetOnCancelByUser(const Value: TNotifyEvent);

    procedure DoCancelByUser;
  public     
    { ������� ������ ������������.
      - AText - ��� ����������� ��������
      - ShowAsPercentBar - ����� ��������� ������ ���������
      - CancelBtnVisible - ����������, ������� �� ���������� ������ "������"
      - ProgressMethod - ��������� ��������� ��������� ������ � ���. ������ }  
    constructor Create(AText: string; ShowAsPercentBar: Boolean = False;
      CancelBtnVisible: Boolean = False; ProgressMethod: TProgressMethod = nil);

    { ������� �������, ��������� � ������������. �� ��������� ����� Free ���
      Destroy ��������. ������� ������� ������� ����� Terminate � �� ����������,
      ����� ������ ����������� ���������. }
    destructor Destroy; override;

    { ��������� �������� � �������, ���� �� ����������� ���� ������������.
      ����� ����� ���������� ActiveWindow }
    procedure TerminateProgress;

    { ������� �������� ���������. ���� � ������������ ShowAsPercentBar=True,
      �� ������ ��������� ���������� ������� ��������. � ��������� ������
      � ��� �����-������� ���������� ������������ ������������� }
    property CurrentValue: Double read FCurrentValue write FCurrentValue;

    { �������� ����� ���� ������������. �.�. ��������, ������� �����������
      � ������ ������ }
    property Text: string read FText write SetText;

    { ������ ���� ������ �� ��������� }
    property DefaultFontColor: TColor read FDefaultFontColor write FDefaultFontColor;

    { ������ ������ �� ��������� }
    property DefaultFontSize: Integer read FDefaultFontSize write FDefaultFontSize;

    { ����� ������ �� ��������� }
    property DefaultFontStyle: TFontStyles read FDefaultFontStyle write FDefaultFontStyle;

    { ��� ������ �� ��������� }
    property DefaultFontName: string read FDefaultFontName write FDefaultFontName;

    { ��������� ��������� ������ � ��������� �������. ������ � ��������
      0 � -1 ��������������� � ����������� ������������� ��� �������� ������� }
    procedure AddStringInfo(LineNumber: Integer; AText: string;
      TextAlignment: TAlignment = taRightJustify; ALineBreak: Boolean = False;
      AFontColor: TColor = clDefault; AFontStyle: TFontStyles = FontStyleNone;
      AFontSize: Integer = -1; AFontName: string = ''); overload;
    
    procedure AddStringInfo(LineNumber: Integer; StringInfo: TStringInfo); overload;

    { ��������� �������� ���������� � ������ � �������� ������� }
    function GetStringInfo(LineNumber: Integer): TStringInfo;

    { ��������� �������� ������������ �������� ��������� ��������� ������.
      ������ ���������� � ������ �������� ������ ����������� ���������.
      ��� �������� ����� ������ ���������� ��� ������ ������������� � ���� �
      ������� ������� FontStylesToInt(). ���� ��� ������ � ��������� �������,
      �� ����� ������������� ����������. }
    procedure ChangeStringInfo(LineNumber: Integer;
      StringParams: array of TStringInfoParams; Values: array of Variant);

    { ������� �� FStringInfo ������� � ������� LineNumber }
    procedure DeleteStringInfo(LineNumber: Integer);

    { ��� ������� �� ������ "������" ��� ������� "Escape" ��� ����������
      ��������������� � True. ���� ��������� ������������ ���������
      ������ ����, � ���� �� = True, �� ���� ����������� � ���������� Terminate}
    property CancelByUser: Boolean read FCancelByUser write FCancelByUser;

    { ���������� ���������� "�������� �������������", ���� ��������� ���� FCancelByUser }
    procedure CheckCancelByUser;

    { �������� ��� ��������� ��������� ������ "������". ��������� �������
      "Escape" �������� � ����� ������, ���� ���� ������ "������" ��������}
    property CancelBtnVisible: Boolean read FCancelBtnVisible write SetCancelBtnVisible;

    { ���� ���� ���� ��������� }
    property BGColor: TColor read FBGColor write FBGColor;

    { ��������� �������� ������ ���� ������������. �������� � ����������� ������,
      �.�. �� �������� ��������� �� ��������� ��������, � ���������� ��������
      ���� ������ � ���, ��� ��� ��������� �������� ��������� �������� ������ ���� }
    procedure SetWndWidth(NewWidth: Integer);

    { ������ ���������� ���������� ��� ������� ������������� ������ "������" ��� "Esc".
      �������, ��� ������ ����� ���������� �� ��������������� ������!}
    property OnCancelByUser: TNotifyEvent read FOnCancelByUser write SetOnCancelByUser;
  protected
    procedure Execute; override;
  end;

  TAdditionalThread = class(TThread)
  private
    FOwnerThread: TProgressViewer;
    FProgressMethod: TProgressMethod;
  protected
    procedure Execute; override;
  end;

  { ������������ ����� ������ � Integer ��� ����������� ������������� �
    ������� ChangeStringParams }
  function FontStylesToInt(AFontStyles: TFontStyles): Integer;

var
  SProductName: string = '���� ����������';
  DrawPercentLabel: Boolean = True;
  SleepTime: Integer = 50;
  DrawTimeLabel: Boolean = True;
  ProgressColor: TColor = clAqua;
  CancelButtonText: string = '������ (Esc)';
  CancelByUserMessage: string = '�������� �������������!';

  ProgressWaitLabel1: string = '����������� ���������� ��������. ��� �����';
  ProgressWaitLabel2: string = '���������� ��������� �����. ����������, ���������!';
  ProgressCommonTime: string = '����� �����: %s';
  GlobalDefaultFontName: string = 'MS Sans Serif'; // ��� ������ �� ���������
  GlobalDefaultFontColor: TColor = clBlack; // ���� ������ �� ���������
  GlobalDefaultFontSize: Integer = 8; // ������ ������ �� ���������
  GlobalDefaultFontStyle: TFontStyles = []; // ����� ������ �� ���������

const
  { ������ ������, �� �������� ������������ �������� Text }
  TEXT_INDEX = 0;
  WAIT_TEXT_INDEX = 1000;

implementation

const
  ProgressWindowClassName = 'ProgressViewerFormClass';
  DefWndWidth = 450;
  DefWndHeight = 70; // ����������� ������ ���� (��� ������ ��������� ������)
  DefBGColor = clBtnFace;
  WM_DOPAINT = WM_USER + 1;

resourcestring
  ErrorRegWndMsg = '����� ���� ������������ "' + ProgressWindowClassName + '" �� ���������������!';
  ErrorStringNotFound = '������ � ������� %d �� �������!';
  ErrorWrongDimension = '���������� ���������� � ��������������� �� �������� �� ���������!';
                 
var
  { ���������� ������, ����������� �� Handle ���� ���������� ����������
    ��� ������ TProgressViewer }
  WndHandleList: TThreadList;
  ThreadsList: TList;
  ClearStringInfo: TStringInfo; // ������ � �������� ������
  WndClassIsReg: Boolean;

function FontStylesToInt(AFontStyles: TFontStyles): Integer;
begin
  Result := Byte(AFontStyles);
end;

{ ��� ���������� ���� ���������� ���������� ��� ����� }
function FindProgressViewerForWindow(AWndHandle: HWND): TProgressViewer;
var
  Index: Integer;
begin
  Result := nil;

  with WndHandleList.LockList do
  try
    Index := IndexOf(Pointer(AWndHandle));
    if Index >= 0 then
      Result := ThreadsList[Index];
  finally
    WndHandleList.UnlockList;
  end;
end;  

function MainWndProc(hWindow: HWND; Msg: UINT; wParam: wParam;
   lParam: lParam): LRESULT; stdcall;
var
  ps: TPaintStruct;
  pw: TProgressViewer;
begin
  Result := 0;

  pw := nil;
  if (Msg = WM_DOPAINT) or (Msg = WM_COMMAND) or (Msg = WM_KEYDOWN) then
    pw := FindProgressViewerForWindow(hWindow);
    
  case Msg of

    WM_DOPAINT:
      // � ��������� wParam ������ ���������� ������ �� ������ TBitmap,
      // � ������� ��� �������� �������������� �����������
      if wParam <> 0 then
      begin
        BeginPaint(hWindow, ps);
        with TCanvas.Create do
        try
          Lock;
          Handle := GetDC(hWindow);
          Draw(0, 0, TProgressViewer(wParam).FBitmap); // ������ ����� ���������� ������ ����� (���� ����-��)
        finally
          ReleaseDC(hWindow, Handle);
          UnLock; 
          Free;
          EndPaint(hWindow, ps);
        end;
      end else
        Result := DefWindowProc(hWindow, Msg, wParam, lParam);

    WM_COMMAND:
      if lParam <> 0 then
        if pw <> nil then
          pw.DoCancelByUser;     

    WM_KEYDOWN:
      if wParam = VK_ESCAPE then
        if pw <> nil then
          pw.DoCancelByUser;

    WM_DESTROY: PostQuitMessage(0);
    WM_CLOSE:; // ��������� �������� ���� ������������ �� Alt+F4

  else
    Result := DefWindowProc(hWindow, Msg, wParam, lParam);
  end;
end;

{ TProgressViewer }

procedure TProgressViewer.AddStringInfo(LineNumber: Integer; AText: string;
  TextAlignment: TAlignment = taRightJustify; ALineBreak: Boolean = False;
  AFontColor: TColor = clDefault; AFontStyle: TFontStyles = FontStyleNone;
  AFontSize: Integer = -1; AFontName: string = '');
var
  Index: Integer;
begin
  FStringInfoCS.Enter;
  try
    Index := GetLineNumberIndex(LineNumber);
    if Index < 0 then
    begin
      Index := Length(FStringInfo);
      SetLength(FStringInfo, Index + 1);
    end;

    if AFontColor = clDefault then
      if FDefaultFontColor = clDefault then
        AFontColor := GlobalDefaultFontColor
      else
        AFontColor := FDefaultFontColor;

    if AFontSize = -1 then
      if FDefaultFontSize = -1 then
        AFontSize := GlobalDefaultFontSize
      else
        AFontSize := FDefaultFontSize;

    {$IFDEF CanUseDefaultFontStyle}
    if AFontStyle = FontStyleNone then
      if FDefaultFontStyle = FontStyleNone then
        AFontStyle := GlobalDefaultFontStyle
      else
        AFontStyle := FDefaultFontStyle;
    {$ENDIF}

    if AFontName = '' then
      if FDefaultFontName = '' then
        AFontName := GlobalDefaultFontName
      else
        AFontName := FDefaultFontName;

    with FStringInfo[Index] do
    begin
      sLineNumber := LineNumber;
      sText := AText;
      sAlignment := TextAlignment;
      sLineBreak := ALineBreak;
      sFontName := AFontName;
      sFontSize := AFontSize;
      sFontStyle := AFontStyle;
      sFontColor := AFontColor;
    end;

    // ������������ ���������� �������
    SortStringInfoArray;

    FBufferIsReady := False;
  finally
    FStringInfoCS.Leave;
  end;
end;

procedure TProgressViewer.AddStringInfo(LineNumber: Integer;
  StringInfo: TStringInfo);
begin
  AddStringInfo(LineNumber, StringInfo.sText, StringInfo.sAlignment,
    StringInfo.sLineBreak, StringInfo.sFontColor, StringInfo.sFontStyle,
    StringInfo.sFontSize, StringInfo.sFontName);
end;

procedure TProgressViewer.ChangeStringInfo(LineNumber: Integer;
  StringParams: array of TStringInfoParams; Values: array of Variant);
var
  I, Index: Integer;
  StringInfo: TStringInfo;
begin
  FStringInfoCS.Enter;
  try
    try
      Index := GetLineNumberIndex(LineNumber);
      if Index < 0 then
        raise EProgressException.CreateFmt(ErrorStringNotFound, [Index])
      else
        StringInfo := FStringInfo[Index];

      if Length(StringParams) <> Length(Values) then
        raise EProgressException.Create(ErrorWrongDimension);

      for I := 0 to High(StringParams) do
        case StringParams[I] of
          sipText: StringInfo.sText := Values[I];
          sipAlignment: StringInfo.sAlignment := Values[I];
          sipLineBreak: StringInfo.sLineBreak := Values[I];
          sipFontName: StringInfo.sFontName := Values[I];
          sipFontSize: StringInfo.sFontSize := Values[I];
          sipFontStyles: StringInfo.sFontStyle := TFontStyles(Byte(Values[I]));
          sipFontColor: StringInfo.sFontColor := Values[I];
        end;

      FStringInfo[Index] := StringInfo;
    except
      on E: Exception do
        raise EProgressException.Create('TProgressViewer.ChangeStringParams -> ' + E.Message);
    end;
    FBufferIsReady := False;
  finally
    FStringInfoCS.Leave;
  end;
end;

procedure TProgressViewer.CheckCancelByUser;
begin
  if FCancelByUser then
    raise EProgressCancelByUser.Create(CancelByUserMessage);
end;

constructor TProgressViewer.Create(AText: string; ShowAsPercentBar: Boolean = False;
      CancelBtnVisible: Boolean = False; ProgressMethod: TProgressMethod = nil);
var
  ScreenRect: TRect;
begin
  if not WndClassIsReg then
    raise EProgressException.Create(ErrorRegWndMsg);

  inherited Create(False);

  FForegroundWindow := GetForegroundWindow;
  FStringInfoCS := TCriticalSection.Create;
  FDataCS := TCriticalSection.Create;
  FBitmap := TBitmap.Create;
  FFonBitmap := TBitmap.Create;
  FTextBitmap := TBitmap.Create;
  FBMPLine := TBitmap.Create;
  
  FShowAsPercentBar := ShowAsPercentBar;
  FWndWidth := DefWndWidth;
  FNewWidth := DefWndWidth;
  FWndHeight := DefWndHeight;
  FCancelBtnVisible := CancelBtnVisible;
  FNewBtnVisible := CancelBtnVisible;
  FBGColor := DefBGColor;
  FreeOnTerminate := True;

  SystemParametersInfo(SPI_GETWORKAREA, 0, @ScreenRect, 0);
  FFormLeftTop.X := (ScreenRect.Right - ScreenRect.Left - FWndWidth) div 2;
  FFormLeftTop.Y := ScreenRect.Bottom - FWndHeight - 100;

  FDefaultFontColor := clDefault;
  FDefaultFontSize := -1;
  FDefaultFontStyle := FontStyleNone;

  if AText = '' then AText := ' ';
  Text := AText;

  { �������� �������� ����������� }
  AddStringInfo(-1, SProductName, taCenter, False, clBlack, [fsBold], 12, GlobalDefaultFontName);

  { �������� ����� � ������� "����������, ���������!" }
  AddStringInfo(WAIT_TEXT_INDEX, ' ', taCenter, False, clBlack, [fsBold], 8);
  AddStringInfo(WAIT_TEXT_INDEX + 1, ProgressWaitLabel1, taCenter, False, clBlack, [fsBold], 10, GlobalDefaultFontName);
  AddStringInfo(WAIT_TEXT_INDEX + 2, ProgressWaitLabel2, taCenter, False, clBlack, [fsBold], 10, GlobalDefaultFontName);
  
  if Assigned(ProgressMethod) then
  begin
    FAdditionalThread := TAdditionalThread.Create(True);
    FAdditionalThread.FProgressMethod := ProgressMethod;
    FAdditionalThread.FOwnerThread := Self;
    FAdditionalThread.FreeOnTerminate := True;
  end;
end;

procedure TProgressViewer.CreateNewWnd;
var
  WndHandle: HWND;
begin        
  WndHandle := CreateWindowEx(
    WS_EX_TOOLWINDOW or WS_EX_TOPMOST, // ����� �� ���� ������ �� ������ �����
    ProgressWindowClassName,
    'ProgressWnd',
    WS_VISIBLE or WS_POPUP,
    FFormLeftTop.X, FFormLeftTop.Y,
    FWndWidth, FWndHeight,
    0,
    0,
    hInstance, // ����� ������, ���������������� ������� �������
    nil);

  // ���������� �������� ������� ��������� ������ ��� �������� �������� ����
  // ���� �� �����-�� ������� ���� ������� �� �������, �� ���������� ���-�����
  // �� �������� - ������ �� ����� ������� ���������.

  if WndHandle <> 0 then
  begin
    // ����� ���� �� ������
    ShowWindow(WndHandle, SW_SHOW);

    FhWindow := WndHandle; // ���������� ���������� ���������� ����
    RegisterWnd; // ������������ ��������� ����

    // ������� ������ "������"
    FhButton := CreateWindow ('BUTTON', PChar(CancelButtonText), WS_CHILD,
      FWndWidth - 120, FWndHeight - 30, 100, 25, WndHandle, 0, hInstance, nil );

    if FhButton <> 0 then
    begin
      if FCancelBtnVisible then
      begin
        ShowWindow(FhButton, SW_SHOW);
        UpdateWindow(FhButton);
      end; 
    end;
  end;        
end;

procedure TProgressViewer.DeleteStringInfo(LineNumber: Integer);
var
  Index, I: Integer;
begin
  FStringInfoCS.Enter;
  try
    Index := GetLineNumberIndex(LineNumber);
    if Index >= 0 then
    begin
      if Index < High(FStringInfo) then
        for I := Index + 1 to High(FStringInfo) do
          FStringInfo[I - 1] := FStringInfo[I];

      SetLength(FStringInfo, High(FStringInfo));

      FBufferIsReady := False;
    end;
  finally
    FStringInfoCS.Leave;
  end;
end;

destructor TProgressViewer.Destroy;
begin
  FreeOnTerminate := False;
  inherited Destroy;
  FStringInfoCS.Free;
  FBitmap.Free;
  FFonBitmap.Free;
  FTextBitmap.Free;
  FBMPLine.Free;
  FDataCS.Free;  
end;

procedure TProgressViewer.DoCancelByUser;
begin
  FCancelByUser := True;
  if Assigned(FOnCancelByUser) then
  try
    FOnCancelByUser(Self);
  except
    {$IFDEF CanRaiseException}raise;{$ENDIF}
  end;
end;

procedure TProgressViewer.DrawProgress;
var
  S: string;
  TxtWidth: Integer;
begin
  LockCanvas;
  try
    FBitmap.Assign(FFonBitmap); 

    FBMPLine.FreeImage;
    FBMPLine.Width := FBitmap.Width - 40;
    FBMPLine.Height := 20;

    FBMPLine.Canvas.Brush.Style := bsSolid;
    FBMPLine.Canvas.Brush.Color := clWhite;

    FBMPLine.Canvas.Rectangle(FBMPLine.Canvas.ClipRect);

    FBMPLine.Canvas.Brush.Color := ProgressColor;

    if not FShowAsPercentBar then
    begin
      FCurrentValue := FCurrentValue + 10;
      
      if FCurrentValue > FBMPLine.Width then
        FCurrentValue := -40;

      FBMPLine.Canvas.Rectangle(Trunc(FCurrentValue), 2,
        Trunc(FCurrentValue) + 40, FBMPLine.Height - 2);
    end else
    begin
      if FCurrentValue > 100 then FCurrentValue := 100 else
      if FCurrentValue < 0 then FCurrentValue := 0;

      FBMPLine.Canvas.Rectangle(2, 2, 2 + Trunc(FCurrentValue *
        (FBMPLine.Width - 4) / 100), FBMPLine.Height - 2);

      // ������� ��������
      if DrawPercentLabel then
      begin
        S := IntToStr(Trunc(FCurrentValue)) + ' %';
        TxtWidth := FBMPLine.Canvas.TextWidth(S);
        FBMPLine.Canvas.Brush.Style := bsClear;
        FBMPLine.Canvas.Font.Style := [fsBold];
        FBMPLine.Canvas.TextOut((FBMPLine.Width - TxtWidth) div 2, 4, S);
      end;
    end;

    if DrawTimeLabel then
    begin
      S := Format(ProgressCommonTime, [TimeToStr(Time - FStartTime)]);
      FBitmap.Canvas.Font.Style := [];
      FBitmap.Canvas.Brush.Style := bsClear;
      TxtWidth := FBitmap.Canvas.TextWidth(S);

      if FCancelBtnVisible then
        FBitmap.Canvas.TextOut(20, FWndHeight - 25, S)
      else
        FBitmap.Canvas.TextOut(FWndWidth - TxtWidth - 20, FWndHeight - 25, S);
    end;

    Windows.BitBlt(FBitmap.Canvas.Handle, 20, FWndHeight - 60, FBMPLine.Width, FBMPLine.Height,
      FBMPLine.Canvas.Handle, 0, 0, SRCCOPY);

  finally
    SendMessage(FhWindow, WM_DOPAINT, Integer(Self), 0);
    UnLockCanvas;
  end;    
end;

procedure TProgressViewer.Execute;
var
  Msg: TMsg;

  procedure DrawText;
  begin
    LockCanvas;
    try
      FBitmap.FreeImage;
      FFonBitmap.FreeImage;

      FBitmap.Width := FWndWidth;
      FBitmap.Height := FWndHeight;

      FBitmap.Canvas.Brush.Color := clBtnFace;

      FBitmap.Canvas.Rectangle(FBitmap.Canvas.ClipRect);

      FFonBitmap.Assign(FBitmap);

      if FTextBitmap.Height > 0 then
        FFonBitmap.Canvas.Draw(10, 2, FTextBitmap);
    finally
      UnLockCanvas;
    end;
  end;

  // ������ ����� �� ������� FStringInfo � ������ FTextBitmap
  procedure PrepareTextRegion;
  var
    tbWidth, tbHeight, I, tmp: Integer;
    ARect: TRect;
    AlignValue: Cardinal;
    WordBreak: Cardinal;
  begin
    LockCanvas;
    FStringInfoCS.Enter;
    try
      tbWidth := FWndWidth - 20;

      // ���������� ������ ����� ��������� ��������
      tbHeight := 0;
      FTextBitmap.Height := 0;
      for I := 0 to High(FStringInfo) do
      begin
        with FTextBitmap.Canvas, FStringInfo[I] do
        begin
          Font.Name := sFontName;
          Font.Size := sFontSize;
          Font.Style := sFontStyle;

          ARect.Left := 0;
          ARect.Top := 0;
          ARect.Right := tbWidth;
          ARect.Bottom := 0;

          if sLineBreak then
            WordBreak := DT_WORDBREAK
          else
            WordBreak := 0;

          Windows.DrawText(Handle, PChar(sText), Length(sText), ARect,
            DT_CALCRECT or WordBreak);
          tmp := TextWidth(sText);
          inttostr(tmp);
          sLineHeight := ARect.Bottom;
          tbHeight := tbHeight + sLineHeight;
        end;
      end;
      FTextBitmap.Width := tbWidth;
      FTextBitmap.Height := tbHeight;
      FTextBitmap.Canvas.Brush.Color := FBGColor;
      FTextBitmap.Canvas.FillRect(FTextBitmap.Canvas.ClipRect);

      // ��������� ��������� �� FTextBitmap
      tbHeight := 0;
      for I := 0 to High(FStringInfo) do
      begin
        with FTextBitmap.Canvas, FStringInfo[I] do
        begin
          Font.Name := sFontName;
          Font.Size := sFontSize;
          Font.Style := sFontStyle;
          Font.Color := sFontColor;

          ARect.Left := 0;
          ARect.Top := tbHeight;
          ARect.Right := tbWidth;
          ARect.Bottom := tbHeight + sLineHeight;
          case sAlignment of
            taLeftJustify: AlignValue := DT_LEFT;
            taRightJustify: AlignValue := DT_RIGHT;
          else
            AlignValue := DT_CENTER;
          end;

          if sLineBreak then
            WordBreak := DT_WORDBREAK
          else
            WordBreak := 0;
          Windows.DrawText(Handle, PChar(sText), Length(sText), ARect,
            AlignValue or WordBreak);
          tbHeight := tbHeight + sLineHeight;
          if sLineNumber = 0 then
            tbHeight := tbHeight;
        end;
      end;

      // ������������ �� FBitmap
      if FTextBitmap.Height > 0 then
        SetWndSize(-1, DefWndHeight + FTextBitmap.Height);
    finally
      UnLockCanvas;
      FStringInfoCS.Leave;
    end;
  end;

  procedure PrepareImageForWindow;
  begin
    PrepareTextRegion;
    DrawText;
  end;

  procedure ProcessMessages;
  begin
    if FhWindow <> 0 then
      while PeekMessage(Msg, FhWindow, 0, 0, PM_REMOVE) do
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
  end;

  procedure UpdateButton;
  begin
    if FhButton <> 0 then
    begin
      InvalidateRect(FhButton, nil, False);
      ProcessMessages;
    end;
  end;

  procedure CheckWidthAndVisible;
  begin
    FDataCS.Enter;
    try
      if FNewWidth <> FWndWidth then
        SetWndSize(FNewWidth, -1);

      // ������� ��������� ��������� ������ "������"
      if FNewBtnVisible <> FCancelBtnVisible then
      begin
        if FhButton <> 0 then
        begin
          if FCancelBtnVisible then
            ShowWindow(FhButton, SW_SHOW)
          else
            ShowWindow(FhButton, SW_HIDE);
        end;
        FCancelBtnVisible := FNewBtnVisible;
      end;
    finally
      FDataCS.Leave;
    end;            
  end;
begin  
  // ������������ ������, ����� ����� ��������� ���� ������������ �����
  // ������� ����� SetWndWidth
  CheckWidthAndVisible;

  // �������� � ������ ������ ����� ������, � ������� � ����� ��������� ���������
  CreateNewWnd;

  // ���������� ����� ������
  FStartTime := Time;

  if Assigned(FAdditionalThread) then
    ResumeThread(FAdditionalThread.Handle); // ������ TThread.Resume (��� "���������" � D2010)

  while not Terminated do
  begin
    // ���� ������������ ������� �������� ������ ���� ��� ��������� ������
    // "������", �� ������������ ���
    CheckWidthAndVisible;

    // ��������� �� ��������� ����� ������ ����
    ProcessMessages;

    // �������������� �����������
    FStringInfoCS.Enter;
    try
      if not FBufferIsReady then
      begin
        try
          PrepareImageForWindow;
        except
          {$IFDEF CanRaiseException}raise;{$ENDIF}
        end;
        FBufferIsReady := True;
      end;
    finally
      FStringInfoCS.Leave;
    end;

    if FhWindow <> 0 then
      try
        DrawProgress;
      except
        {$IFDEF CanRaiseException}raise;{$ENDIF}
      end;

    // ��������� ����������� ������
    UpdateButton;

    Sleep(SleepTime);
  end;

  if Assigned(FAdditionalThread) then
    FAdditionalThread.Terminate;

  // ������ ������, ����� ���� �������� ���
  if FhWindow <> 0 then
  begin
    ShowWindow(FhWindow, SW_HIDE);
    SendMessage(FhWindow, WM_DESTROY, 0, 0);
    UnRegisterWnd;
    //if FForegroundWindow <> 0 then
    //  SetForegroundWindow(FForegroundWindow);
    //FForegroundWindow := 0;
    FhWindow := 0;
  end;
end;

function TProgressViewer.GetLineNumberIndex(LineNumber: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(FStringInfo) do
    if FStringInfo[I].sLineNumber = LineNumber then
    begin
      Result := I;
      Exit;
    end;
end;

function TProgressViewer.GetStringInfo(LineNumber: Integer): TStringInfo;
var
  Index: Integer;
begin
  FStringInfoCS.Enter;
  try
    Result := ClearStringInfo;
    Index := GetLineNumberIndex(LineNumber);
    if Index >= 0 then
      Result := FStringInfo[Index];
  finally
    FStringInfoCS.Leave;
  end;
end;

procedure TProgressViewer.LockCanvas;
begin
  FBitmap.Canvas.Lock;
  FFonBitmap.Canvas.Lock;
  FTextBitmap.Canvas.Lock;
  FBMPLine.Canvas.Lock;
end;

procedure TProgressViewer.RegisterWnd;
begin
  if FhWindow <> 0 then
    with WndHandleList.LockList do
    try
      if IndexOf(Pointer(FhWindow)) < 0 then
      begin
        Add(Pointer(FhWindow));
        ThreadsList.Add(Self);
      end;
    finally
      WndHandleList.UnlockList;
    end;
end;

procedure TProgressViewer.SetCancelBtnVisible(const Value: Boolean);
begin
  FDataCS.Enter;
  FNewBtnVisible := Value;
  FDataCS.Leave;      
end;

procedure TProgressViewer.SetOnCancelByUser(const Value: TNotifyEvent);
begin
  FOnCancelByUser := Value;
end;

procedure TProgressViewer.SetText(const Value: string);
begin
  FText := Value;
  if GetLineNumberIndex(TEXT_INDEX) < 0 then
    AddStringInfo(TEXT_INDEX, Value, taCenter, False, clBlack, [fsBold], 14)
  else
    ChangeStringInfo(TEXT_INDEX, [sipText], [Value]);
end;

procedure TProgressViewer.SetWndSize(NewWidth, NewHeight: Integer);
var
  ScreenRect: TRect;
begin
  if NewHeight = -1 then NewHeight := FWndHeight;
  if NewWidth = -1 then NewWidth := FWndWidth;
  if NewHeight < DefWndHeight then
    NewHeight := DefWndHeight;
  if NewWidth < DefWndWidth div 2 then
    NewWidth :=  DefWndWidth div 2;

  if (FWndHeight <> NewHeight) or (FWndWidth <> NewWidth) then
  begin  

    SystemParametersInfo(SPI_GETWORKAREA, 0, @ScreenRect, 0);
    FWndHeight := NewHeight;
    FWndWidth := NewWidth;
    FFormLeftTop.X := (ScreenRect.Right - ScreenRect.Left - FWndWidth) div 2;
    FFormLeftTop.Y := ScreenRect.Bottom - FWndHeight - 100;  

    if FhWindow <> 0 then
      SetWindowPos(FhWindow, HWND_TOPMOST, FFormLeftTop.X, FFormLeftTop.Y, FWndWidth,
        FWndHeight, SWP_SHOWWINDOW);

    if FhButton <> 0 then
    begin
      SetWindowPos(FhButton, HWND_TOP, FWndWidth - 120, FWndHeight - 30,
        100, 25, SWP_HIDEWINDOW);
      if FCancelBtnVisible then
      begin
        ShowWindow(FhButton, SW_SHOW);
        UpdateWindow(FhButton);
      end;
    end;
    FBufferIsReady := False;
  end;
end;

procedure TProgressViewer.SetWndWidth(NewWidth: Integer);
begin
  if NewWidth < DefWndWidth div 2 then
    NewWidth := DefWndWidth div 2;

  FDataCS.Enter;
  FNewWidth := NewWidth;
  FDataCS.Leave;
end;

procedure TProgressViewer.SortStringInfoArray;
var
  I, J: Integer;
  AStringInfo: TStringInfo;
begin
  for I := 0 to High(FStringInfo) - 1 do
    for J := High(FStringInfo) downto I + 1 do
      if FStringInfo[I].sLineNumber > FStringInfo[J].sLineNumber then
      begin
        AStringInfo := FStringInfo[I];
        FStringInfo[I] := FStringInfo[J];
        FStringInfo[J] := AStringInfo;
      end;
end;

procedure TProgressViewer.TerminateProgress;
begin
  Free;
  if FForegroundWindow <> 0 then
    SetForegroundWindow(FForegroundWindow);
end;

procedure TProgressViewer.UnLockCanvas;
begin
  FBitmap.Canvas.Unlock;
  FFonBitmap.Canvas.Unlock;
  FTextBitmap.Canvas.Unlock;
  FBMPLine.Canvas.Unlock;
end;

procedure TProgressViewer.UnRegisterWnd;
var
  Index: Integer;
begin
  with WndHandleList.LockList do
  try
    Index := IndexOf(Pointer(FhWindow));
    if Index >= 0 then
    begin
      Delete(Index);
      ThreadsList.Delete(Index);
    end;
  finally
    WndHandleList.UnlockList;
  end;
end;

{ TAdditionalThread }

procedure TAdditionalThread.Execute;
begin
  FProgressMethod(FOwnerThread);

  while not Terminated do
    Sleep(50);
end;

procedure RegisterProgressWndClass;
var
  WndClass: TWndClass;
begin
  WndClass.lpszClassName := ProgressWindowClassName;
  WndClass.lpfnWndProc   := @MainWndProc;
  WndClass.Style         := CS_VREDRAW or CS_HREDRAW;

  {����� ������ (EXE ��� DLL), � ������� ��������� MainWndProc. � ����������
   ������� CreateWindowEx � ������ ������� � ���������� ������ ProgressWindowClassName
   ��������� hInstance ������ ����� ��������� ����� ���� }
  WndClass.hInstance     := hInstance;
  WndClass.hIcon         := LoadIcon(0, IDI_APPLICATION);
  WndClass.hCursor       := LoadCursor(0, IDC_ARROW);
  WndClass.hbrBackground := (COLOR_WINDOW + 1);
  WndClass.lpszMenuName  := nil;
  WndClass.cbClsExtra    := 0;
  WndClass.cbWndExtra    := 0;

  WndClassIsReg := Windows.RegisterClass(WndClass) <> 0;
  
  if not WndClassIsReg then
    WndClassIsReg := GetLastError = ERROR_CLASS_ALREADY_EXISTS;
end;

initialization
  WndHandleList := TThreadList.Create;
  ThreadsList := TList.Create;
  RegisterProgressWndClass;
finalization
  WndHandleList.Free;
  ThreadsList.Free;
end.
