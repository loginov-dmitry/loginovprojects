unit LangReader;

{(c) 2006-2009 - Loginov Dmitry

 http://matrix.kladovka.net.ru/
 e-mail: loginov_d@inbox.ru
 last update: 12.12.2009

 Description

 ������ ������������ ��� ��������� ����������� ����������, ����������� �
 Delphi � �������������� VCL, �� ��������� ����������� �����, ������� ��������
 ������� ��������� ��������� ASCII (�������, ����������, �������� � �.�., �.�.
 ����������� ����� �����, �� ������������ ����������).
 ������ ������ ������ ����� � �������������.
 ���������� ����������� �������� ����, �������� English.lng. �� ������ ����
 � ������� ini-�����, ��� ��� ������ � ��� ����������� ���������� ����������
 ������ TIniFile (������, TMemIniFile). ������� ������:

 [TMainForm]
 Caption=MainForm caption
 Width=400
 Heigth=300
 Panel1.Color = $000000FF
 LabeledEdit1.EditLabel.Caption=Must die!
 Memo1.Lines = "������ 1\n������ 2"
 RadioGroup1.Items ="������� 1\n������� 2"
 NewButton.Anchors = [akLeft,akTop,akRight,akBottom]
 Image1.Picture=C:\Delphi\Projects\LangReader\mainicon.ico

 ��� ������, ��� ������ ���������� ������������ � �������� ������.
 ���������� �������� ������������ ����������� ��� ��, ��� � � ����. ������� ��
 ���� ��������� �����������:
 - �� �� ������ �������� ���: Panel1.Color = clRed, ��� ��� �������������
   � ������� ������ � ������������� ��� ������������� �� �������������
   (�� ���������, ��� � ������� ��� ����� �����������)
 - �� �� ������ �������� ���: Memo1.Lines.Text = "������ 1\n������ 2", ���
   ��� (� ������ ������ :) � ��������� �������� Text �� ������������. ���
   RadioGroup1.Items ��������� �� �� ����� �����������. ��� ���� ���������� -
   �������� � ��������.   

 � �����, �������� ���� ������� ����� ������������� ��� ���� �������� (dfm-����),
 ���������� �������� ����� ���������� �� ����� ������ ���������. ������������
 ��������� �������� ����������� ����� ��������. ������ ��� ��� ����� - ������
 �� ���. �� ������ ��������� ������������ �������� ����������� ��������. ��� �����
 ���������� ��������� ���������� UseOnlyStringProperties �������� True

 �������� ������� ����������� ����������� � ������� ��������� SetLanguage(),
 � ������� ������ ������������ ������ �� ���������, ���������� �����������
 (������, ��� ����� ����������� ����� ���� �� ������ �����, �� � ����� ������
 ��������), � ����� ��� ��������� �����. ���� � �������� ������ �� ���������
 ��������� NIL, �� ����������� ����������� �� ��� ����� � ������ ������
 ����������, ������ �� ������� �������� � Screen.
 
 ����������� ����������� ����� ��������� ����� ���������:
 1 - �������� Image.Picture ������ ��� ������������ �����.
   ���� ������ �������� ���, ��� ��� ����������� ����� ���������� ����������
   �������� ��� ������� �����. � ������ ����� ���� ����� �����.
 2 - ��������������� �������� bmp2str.exe, ������� �������� �������� �����������
   � LNG-���� � ������� HEX. � ���� ������ ��� ����������� ����� ������� � �����-
   ������������ LNG-�����. � ������, ������������ �� ������ "���������"
   �����������, �.�. �� ����� ������� ��� ������ ��� ���������� ���������.
   ������, ��� ��������� ������������� ������ TMemIniFile �� ����� ����� �
   ������ LNG-����� �� ��������� ������� �����������, ������������ TIniFile.

 ��-��������� ������ �������� � ������ ����������� LNG-������. ���� ����� �����
 ���������, ��������� KeepLngFiles � False. � ������ ����������� ��� LNG-�����
 �������� � ������ ��������� ����� ���� ��� - ��� �� ������ �������������. �
 ���������� LNG-����� ���������� �� ������������.

 ����� ������� SetLanguage() ����� ��������� � ����������� ����� /
 ������ ������ / ������. � ���� ������, ����� ������ ��� �� ���������� ���
 �������� ����������, ������ ���������� ������� ������ SELF.

 ����������� ���������� ���������� ��� ����������� ���������� ��������� ���������.
 ��� �������� ��������� ����� ������������ ��� �� ����� ini-���� (English.lng)
 ��� ��������� ���������, ������������ � ���������, ����� ������� � ���������
 ������. ������:

 [Messages]
 SConfirmClose=Do you want close this program?
 SConfirm=Confirm

 ��� ������ � ����������� ���������� ������� ��������� ������ TTextMessages �
 ��������� ���������� ��������� ������ �� ini-����� � ������� �������
 TTextMessages.LoadFromFile(). ��������� ����� ���������, ��������� � �������� �
 ������� default-�������� SMsg. ������������� ��� ���������, ���������� ��
 ���������, �������� � ����� ������ ������ ���������. ������ ����������:

   Messages['SConfirmClose'] := '�� ������������� ������ ��������� ������ � ����������?';
   Messages['SConfirm'] := '�������������';

 � ��������� ������ ��������� ����� ��������� ������ ��������������, ���� � ���
 ������� ����� ���������.  

 ������ ������������� ��������� � ������� MessageBox:

 CanClose := Application.MessageBox(
               Messages.PMsg['SConfirmClose'],
               Messages.PMsg['SConfirm'],
               MB_ICONQUESTION or MB_OKCANCEL) = IDOK;

 ����-�����, ������������ ����� ����������� ���������� - �� ������������.
 Delphi ���������� ���� ������ ������� ��������� - � ������� �����������
 Translation Manager. ����� ����� ��������� ����� ������, ������ ��� ��������
 �������� ������� �� ���������� �������� ����� ��������, ������� � ������
 ������������� �� ��������� � ������� �������� ��������.

 ��� ����������� ��� ����������� ����� ����� � ���������, � ��������� ��
 ����� (� ����������� ���� ����������) torry.net.
 ����� �� �������� ������� ������ �������� ���������� TsiLang. ���
 ������������� ������� ������ ������������ � ��� ���� �������� �������.

 �������������� �� ��������� ������ Delphi: 7, 2006, 2007, 2009, 2010

 ���������:
 20.05.2008
  - �������� ����� TFastMessageList, ����������� ����������� ��������� ����� ��������
    ������ �� ���� ����������� ������� ��������� �����.

 12.12.2009
  - ��� �������� �� ������������� � UnicodeString. ����������� ������� � ����������
    tkUString � ������� SetControlProperty (��� D2009 � ����).
    �������� ����� ����� �������� � ��������� ANSI, ���� ������������������ �
    UTF8 ��� Unicode (��� ���� ������� ����������� ������� � ��������� �����
    ���������, �.�. ������ 3 ����� ������� ��������).

 09.12.2010
  - ������ �������� ���������� ������� � ��������� �������������� � ������� CharInSet
  }

{UseGraphics. ���������� ������ �����, ����� ���� ��������� ����������� ����������
 �����������, ���������� � LNG-����� � ������� ���}
{$DEFINE UseGraphics}

{$IFDEF UseGraphics}
  {.$DEFINE UseJPEG}
{$ENDIF UseGraphics}


interface
uses
  Windows, SysUtils, Classes, Controls, Forms, TypInfo, IniFiles, SyncObjs,
  Graphics {$IFDEF UseJPEG}, JPEG {$ENDIF};

{ ��������� D2009PLUS ����������, ��� ������� ������ Delphi: 2009 ��� ����}
{$IF RTLVersion >= 20.00}
   {$DEFINE D2009PLUS}
{$IFEND}

type
  {����������� �����, ��������������� ������ Lock � UnLock, �����������
   ���������� � ������� ����������� ������.}
  TLockClass = class(TObject)
  private
    FCriticalSection: TCriticalSection;
  protected
    {���������� �������� ������/������}
    procedure Lock;

    {������ ���������� �������� ������/������}
    procedure UnLock;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  {����� ���������� ���������� �����������. ��� �������� ��������� �� ���-�����
   ����������� ����� LoadFromFile(). ��� ������/������/���������� ���������
   ����������� default-�������� SMsg}
  TTextMessages = class(TLockClass)
  private
    FMessageList: TObject;

    function GetPMsg(const MsgName: string): PChar;
    function GetSMsg(const MsgName: string): string;
    procedure SetSMsg(const MsgName, Value: string);

  public
    constructor Create; override;
    destructor Destroy; override;

    property SMsg[const MsgName: string]: string read GetSMsg write SetSMsg; default;
    property PMsg[const MsgName: string]: PChar read GetPMsg;

    {��������� ������ �� ������ Section ����� FileName}
    procedure LoadFromFile(const FileName, Section: string);

    {��������� ������ �� ������ Strings}
    procedure LoadFromStrings(Strings: TStringList);

    {������� �������}
    procedure Clear;

    {���������� ���������� ��������� ���������}
    function Count: Integer;
  end;

{��������� ���� ���������� �� ���������� ini-�����. ���� AControl = nil,
 �� ��������� �������� ���� ���� � ������� ������ ����������, ����� - ������ ���
 ���������� �������� (����� ������� ����� �������, �������� - �����, ������
 �����, �����, ������� ��������� � �.�. � ����� ������ ��������� ���������� �����
 ��� ���� ������, ��� ��� ��������� � ������ ������ ��������, � ��� ������
 ��������� ��������� ������)

 �� ��� ��������� ��������� ���������� ����� ��������, ������ ����
 ������ ��������� � ���-�����. �������� ��� �������� ������ � ����� ��������
 ������ �������������� ��� (� �������, �� �����������, � �������� ���
 ���� ������� TStrings (� ������ ����������)). ������ �������� ����� ������,
 ���������� � TImageList (���������� ��� ������ ReadData � WriteData, � �� �������,
 ������ ���).
 ������� ���-������ ����� ����� � ����� � ����������}
procedure SetLanguage(AControl: TComponent; const LangFileName: string);

{��������� ����� � ������. ������ ���� ������ �������������� ����� HEX-���������}
function BufferToStr(Buffer: Pointer; BufSize: Integer): string;

{��������� ����� � ������}
function StreamToStr(AStream: TMemoryStream): string;

{��������� ������ � �����. ������� �������������� ��� �����������
 ������ � �������� �������������}
procedure StrToStream(const Str: string; AStream: TMemoryStream);

{$IFDEF UseGraphics}
{���������, ��������������� �� ����� AClass � ������}
function IsRegistredGraphicFormat(AClass: TClass): Boolean;
{$ENDIF UseGraphics}

{���������� ��� ������ �� ��������� ROT13 (��� �������� ���������)}
function GenerateStringHashROT13(const S: string): Cardinal;

var
  {������ ��������� ����������. �� ������ � ��� ������� ��� ��������� �����
   � ������ �� ������ ����� �� ������������. � ������ ������ ��� �� ������������
   ������� � ������������� ������ ��� ��� �� �����}
  LangFileName: string;

  {��������� ������� � ������ ���������� ����������� LNG-������ ��� �����
   ������ ���������. ��� ��������� ��������� ������� �������� �����������
   ���� ��� ������� �������� LNG-������. ������������� ������� ������� �������
   � ���, ��� ������ ����� ��� ���������� ��������� ���������� ���-���� �
   ����� ���������� ���������. � ��������, �� ������ ������� � ����� ���������
   ���-������ ����� ��������� "����������� ������ �����������"}
  KeepLngFiles: Boolean = True;

  {���������� ������ ���������� � True, ���� �� �� ������, ����� ��� ������
   ������� ����� �� ���-����� �������� ��� (� ��� ����� � �����������) ��������}
  UseOnlyStringProperties: Boolean;

{$IFDEF UseGraphics}
  {������������� ������, � ������� ������� ����� ������ ����������� ClassType.
   � ������ ������ �������������� ������ ����������� ������ �����������.
   ����������� TJPEGImage � ������ ����������� �� ������ ��������� ��������������.
   ��� ����� ���������� GraphicFormats ��������� ��� ����������}
  GraphicFormats: TStringList;
{$ENDIF UseGraphics}

implementation

type
  PTextMessageItem = ^TTextMessageItem;
  TTextMessageItem = record
    tmiKey: string; // ������������� (�������� � ������� ��������)
    tmiValue: string; // ��������� ���������
    tmiHash: Cardinal; // ��� �������������� (��� ��������� ������)
  end;

  {������, �������� ��������� ��������� ��� TTextMessages. �������� �� ���������
   �������� �������, ��� TStringList, �.�. ������ �������������� ������� IndexOfKey.
   ��� ��������������� ��������� ������������ ���������� ���� ������� ������. �
   ��������� ������� ��� �������� ������� �������� ��������� �����, �� � �����
   ������ - �� ���������. ���-������� �������� �� ��������� ROT13, ���
   ������ �������� ���������.}
  TFastMessageList = class(TObject)
  private
    FList: array of PTextMessageItem; // ������ ���������
    FCount: Integer; // ���������� ��������� � ������
    FCapacity: Integer; // ���������� ��������� � ������� TFastMessageList

    // ������������� ���-�� ��������� � ������
    procedure SetCapacity(NewCapacity: Integer);

    // ����������� ����� ��������� � ������� (������ �� 1/3)
    procedure Grow;
  public
    destructor Destroy; override;

    // ���������� ������ ��������������. ���������� -1, ���� ������� �� ������
    // Key ������ ������������ � ������� ��������
    function IndexOfKey(const Key: string): Integer;

    // ��������� ����� ������� � ������. ���������� ������ ������������ ��������
    // Key ������ ������������ � ������� ��������
    function Add(const Key, Value: string): Integer;

    // ���������� ���-�� ��������� � ������
    property Count: Integer read FCount;

    // ���������� ��������� ��������� �� ��������� ��������������
    function GetValueByKey(const Key: string): PChar;

    // ���������� ��������� ��������� �� ��� �������
    function GetValueByIndex(Index: Integer): PChar;

    // ���������� ������������� �� ��� �������
    function GetKeyByIndex(Index: Integer): PChar;

    // ������� ��� ������ �� �������
    procedure Clear;
  end;

  TLngFilesManager = class(TLockClass)
  private
    {������������� ������ LNG-������}
    FFileList: TStringList;

    function CreateMemIniFile(const FileName: string): Integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Clear;
    {���������� ������ ������ TMemIniFile. ���� ����� ��������� ����� FileName
     ������, �� ��������������� ������ ��� ������ - � ���� ������ ������� ������
     ������ �� ����. � ��������� ������ ������ ����� ������.}
    function GetMemIniFile(const FileName: string): TMemIniFile;
  end;

var
  LngManager: TLngFilesManager;


{$IFNDEF D2009PLUS}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;
{$ENDIF}

{ TTextMessages }

procedure TTextMessages.Clear;
begin
  Lock;
  try
    TFastMessageList(FMessageList).Clear;
  finally
    UnLock;
  end;
end;

function TTextMessages.Count: Integer;
begin
  Result := TFastMessageList(FMessageList).Count;
end;

constructor TTextMessages.Create;
begin
  inherited;
  FMessageList := TFastMessageList.Create;
end;

destructor TTextMessages.Destroy;
begin
  FreeAndNil(FMessageList);
  inherited;
end;

function TTextMessages.GetPMsg(const MsgName: string): PChar;
var
  I: Integer;
begin
  Lock;
  try
    Result := nil;
    // ���������� ������ ��������������
    I := TFastMessageList(FMessageList).IndexOfKey(AnsiUpperCase(Trim(MsgName)));
    
    if I >= 0 then
      Result := TFastMessageList(FMessageList).GetValueByIndex(I);
  finally
    UnLock;
  end;
end;

function TTextMessages.GetSMsg(const MsgName: string): string;
begin
  Result := PMsg[MsgName];
end;

procedure TTextMessages.LoadFromFile(const FileName, Section: string);
var
  AList: TStringList;
  MemIni: TMemIniFile;
begin
  Lock;
  AList := TStringList.Create;
  try
    if KeepLngFiles then
      MemIni := LngManager.GetMemIniFile(FileName)
    else
    begin
      LngManager.Clear;
      MemIni := TMemIniFile.Create(FileName);
    end;       
      
    try
      MemIni.ReadSectionValues(Section, AList);
      LoadFromStrings(AList);
    finally
      if not KeepLngFiles then
        MemIni.Free;
    end;
  finally
    AList.Free;
    UnLock;
  end;  
end;

procedure TTextMessages.LoadFromStrings(Strings: TStringList);
var
  I, EqPos: Integer;
  S: string;
  AName, AValue: string;
begin
  for I := 0 to Strings.Count - 1 do
  begin
    {���� ���� ������ ������� ValueFromIndex ��� ��������� Delphi6}
    S := Strings[I];
    EqPos := Pos('=', S);
    if EqPos > 1 then
    begin
      AName := Trim(Copy(S, 1, EqPos - 1));
      if AName <> '' then
      begin
        AValue := AnsiDequotedStr(Copy(S, EqPos + 1, MaxInt), '"');
        SMsg[AName] := AValue;
      end;
    end;
  end;
    
end;

procedure TTextMessages.SetSMsg(const MsgName, Value: string);
begin
  if Trim(MsgName) = '' then Exit;
  
  Lock;
  try
    TFastMessageList(FMessageList).Add(AnsiUpperCase(Trim(MsgName)),
      StringReplace(Value, '\n', sLineBreak, [rfReplaceAll, rfIgnoreCase]))
  finally
    UnLock;
  end;
end;

procedure ParseString(S: string; APropList: TStrings; var AText: string);
var
  I: Integer;
begin
  APropList.Clear;
  AText := '';

  S := Trim(S);
  if S = '' then Exit;

  with TStringList.Create do
  try
    Text := S;
    AText := StringReplace(AnsiDequotedStr(Values[Names[0]], '"'), '\n',
      sLineBreak, [rfReplaceAll, rfIgnoreCase]);

   // if Trim(AText) = '' then Exit; �� �����!

    Delimiter := '.';
    DelimitedText := Names[0];
    for I := 0 to Count - 1 do
      Strings[I] := Trim(Strings[I]);

    APropList.Text := Text;
  finally
    Free;
  end;
end;

procedure SetControlProperty(AControl: TComponent; PropName: string; Value: Variant);
var
  PropInfo: PPropInfo;
  ObjClass: TClass;

  procedure SetStringList;
  var
    AList: TStringList;
  begin
    AList := TStringList.Create;
    try
      AList.Text := string(Value);
      TypInfo.SetObjectProp(AControl, PropName, AList);
    finally
      AList.Free;
    end;
  end;

  {$IFDEF UseGraphics}
  procedure SetPicture;
  var
    MS: TMemoryStream;
    CName: string[63];
    gr: TGraphic;
    gClass: TGraphicClass;
    Pict: TPicture;
    I: Integer;
  begin
    if (Length(Value) <= MAX_PATH) and FileExists(Value) then
    begin
      Pict := TPicture.Create;
      try
        Pict.LoadFromFile(Value);
        TypInfo.SetObjectProp(AControl, PropName, Pict);
      finally
        Pict.Free;
      end;
    end else
    begin
      MS := TMemoryStream.Create;
      try
        StrToStream(Value, MS);

        // ��������� ��� ������
        MS.Read(CName[0], 1);
        MS.Read(CName[1], Integer(CName[0]));
        I := GraphicFormats.IndexOf(string(CName));
        if I >= 0 then
        begin
          gClass := TGraphicClass(GraphicFormats.Objects[I]);
          Pict := TPicture.Create;
          try
            gr := gClass.Create;
            try
              gr.LoadFromStream(MS);
              Pict.Graphic := gr;
              TypInfo.SetObjectProp(AControl, PropName, Pict);
            finally
              gr.Free;
            end;
          finally
            Pict.Free;
          end;
        end;
      finally
        MS.Free;
      end;
    end;
  end;

  procedure SetGraphic;
  var
    gr: TGraphic;
    MS: TMemoryStream;
  begin
    gr := TGraphicClass(ObjClass).Create;
    try
      MS := TMemoryStream.Create;
      try
        if (Length(Value) <= MAX_PATH) and FileExists(Value) then
          gr.LoadFromFile(Value)
        else
        begin
          StrToStream(Value, MS);
          gr.LoadFromStream(MS);
        end;

        TypInfo.SetObjectProp(AControl, PropName, gr);
      finally
        MS.Free;
      end;
    finally
      gr.Free;       
    end; 
  end;
  {$ENDIF UseGraphics}

begin
  PropInfo := GetPropInfo(AControl, PropName);
  if PropInfo <> nil then
  begin
    case PropType(AControl, PropName) of
      tkLString, tkString, tkWString{$IF RTLVersion >= 20.00}, tkUString{$IFEND}:
        SetStrProp(AControl, PropName, string(Value));


      tkInteger:
        if not UseOnlyStringProperties then
          SetOrdProp(AControl, PropName, Integer(Value));
      tkFloat:
        if not UseOnlyStringProperties then
          SetFloatProp(AControl, PropName, Extended(Value));
      tkEnumeration:
        if not UseOnlyStringProperties then
          SetEnumProp(AControl, PropName, string(Value));
      tkSet:
        if not UseOnlyStringProperties then
          SetSetProp(AControl, PropName, string(Value));

      tkClass:
        begin
          // ����������, � ������ ������ ��������� ��������
          ObjClass := GetObjectPropClass(AControl, PropName);

          // ���� �������� ��������� � ������ �����, ��...
          if ObjClass = TStrings then
            SetStringList;

          {$IFDEF UseGraphics}
          if ObjClass = TPicture then
            SetPicture;

          if IsRegistredGraphicFormat(ObjClass) then
            SetGraphic;
          {$ENDIF UseGraphics}
        end;
    end; // of case
  end;
end;

procedure SetFormLanguage(AForm: TComponent; LangFileName: string; IniFile: TMemIniFile);
var
  I, J: Integer;
  AList: TStringList;
  S: string;
  Vrnt: Variant;
  AControl, AChildControl: TComponent;
  TranslateList: TStringList;
  PropInfo: PPropInfo;
begin
  TranslateList := TStringList.Create;
  AList := nil;
  try
    AList := TStringList.Create;
    // ��������� ���������� ������
    IniFile.ReadSectionValues(AForm.ClassName, TranslateList);

    for I := 0 to TranslateList.Count - 1 do
    begin
      ParseString(TranslateList[I], AList, S);

      if AList.Count = 0 then Continue;
      Vrnt := S;

      AControl := AForm;
      for J := 0 to AList.Count - 2 do
      begin
        if AControl = nil then Break;
        AChildControl := AControl.FindComponent(AList[J]);

        if AChildControl = nil then
        begin
          // ���� ������-��������� �� ������, ��
          // �������� �� �������� published-���������
          PropInfo := GetPropInfo(AControl, AList[J]);
          if (PropInfo <> nil) and (PropType(AControl, AList[J]) = tkClass) then
            AChildControl := TComponent(GetObjectProp(AControl, AList[J]));

          // ���� ������ �� ������ ���� ��� ��������, �� ���� ��� ���� �������-
          // �� ����� ���� ������������ ���������������, �� �������� ���������
          if (AChildControl = nil) and (AControl is TControl) then
            AChildControl := TWinControl(AControl).FindChildControl(AList[J]);

          // ���� ������ ������ �� ������� �����, �� ������������� ����� �������
          // ��������� ��� ��������
          if (AChildControl = nil) and (PropInfo = nil) then
            AControl := nil;
        end;

        if AChildControl = nil then Break;
        AControl := AChildControl;
      end;
      if (AControl <> nil) then
      try
        SetControlProperty(AControl, AList[AList.Count - 1], Vrnt);
      except
        on E: Exception do
          Application.MessageBox(
            PChar('Error loading file ' + LangFileName + sLineBreak +
            'Can''t set property: ' + AForm.Name + '.' + TranslateList[I] + sLineBreak +
            'Error reason: ' + E.Message),
            'Error', MB_ICONERROR);
      end
    end;

  finally
    TranslateList.Free;
    AList.Free;
  end;
end;

procedure SetLanguage(AControl: TComponent; const LangFileName: string);
var
  I: Integer;
  IniFile: TMemIniFile;
begin
  if KeepLngFiles then
    IniFile := LngManager.GetMemIniFile(LangFileName)
  else
  begin
    LngManager.Clear;
    IniFile := TMemIniFile.Create(LangFileName);
  end;      

  try
    if AControl <> nil then
      SetFormLanguage(AControl, LangFileName, IniFile)
    else
    begin
      // ������ �������� ���� ����
      for I := 0 to Screen.FormCount - 1 do
        SetFormLanguage(Screen.Forms[I], LangFileName, IniFile);

      // ������ �������� ���� ������� ������
      for I := 0 to Screen.DataModuleCount - 1 do
        SetFormLanguage(Screen.DataModules[I], LangFileName, IniFile);
    end;

  finally
    if not KeepLngFiles then
      IniFile.Free;
  end;
end;

function BufferToStr(Buffer: Pointer; BufSize: Integer): string;
var
  Bytes: PByteArray;
  I: Integer;
  S: string;
begin
  Result := '';
  if Assigned(Buffer) and (BufSize > 0) then
  begin
    SetLength(Result, BufSize * 2);
    Bytes := Buffer;
    for I := 0 to BufSize - 1 do
    begin
      S := IntToHex(Bytes[I], 2);
      Result[I * 2 + 1] := S[1];
      Result[I * 2 + 2] := S[2];
    end;
  end;
end;

function StreamToStr(AStream: TMemoryStream): string;
begin
  Result := BufferToStr(AStream.Memory, AStream.Size);
end;

procedure StrToStream(const Str: string; AStream: TMemoryStream);
var
  I: Integer;
  Bytes: PByteArray;

  function CharToByte(const AChar: Char): Byte;
  begin
    if CharInSet(AChar, ['0'..'9']) then
      Result := Ord(AChar) - Ord('0')
    else
      Result := Ord(AChar) - Ord('A') + 10;
  end;
begin
  AStream.Size := Length(Str) div 2;
  Bytes := AStream.Memory;
  for I := 1 to Length(Str) div 2 do
  begin
    Bytes[I - 1] := CharToByte(Str[I * 2 - 1]) shl 4;
    Bytes[I - 1] := Bytes[I - 1] or CharToByte(Str[I * 2]);
  end;
end;

function IsRegistredGraphicFormat(AClass: TClass): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to GraphicFormats.Count - 1 do
    if GraphicFormats.Objects[I] = TObject(AClass) then Exit;
  Result := False;
end;

{ TLockClass }

constructor TLockClass.Create;
begin
  FCriticalSection := TCriticalSection.Create;
end;

destructor TLockClass.Destroy;
begin
  FreeAndNil(FCriticalSection);
  inherited;
end;

procedure TLockClass.Lock;
begin
  FCriticalSection.Enter;
end;

procedure TLockClass.UnLock;
begin
  FCriticalSection.Leave;
end;

{ TLngFilesManager }

procedure TLngFilesManager.Clear;
var
  I: Integer;
begin
  for I := 0 to FFileList.Count - 1 do
    FFileList.Objects[I].Free;
  FFileList.Clear;
end;

constructor TLngFilesManager.Create;
begin
  inherited;
  FFileList := TStringList.Create;
end;

function TLngFilesManager.CreateMemIniFile(
  const FileName: string): Integer;
var
  MemIni: TMemIniFile;
begin
  Result := FFileList.IndexOf(FileName);
  if Result >= 0 then Exit
  else
  begin
    MemIni := TMemIniFile.Create(FileName);
    Result := FFileList.AddObject(FileName, MemIni);
  end;
end;

destructor TLngFilesManager.Destroy;
begin
  Clear;
  FFileList.Free;
  inherited;
end;

function TLngFilesManager.GetMemIniFile(const FileName: string): TMemIniFile;
var
  I: Integer;
begin
  Lock;
  try
    Result := nil;
    I := CreateMemIniFile(FileName);
    if I >= 0 then
      Result := TMemIniFile(FFileList.Objects[I]);
  finally
    UnLock;
  end; 
end;

function GenerateStringHashROT13(const S: string): Cardinal;
var
  Hash: Cardinal;
  I: Integer;
begin
  Hash := 0;

  for I := 1 to Length(S) do
  begin
    Hash := Hash + Ord(S[I]);
    Hash := Hash - ((Hash shl 13) or (Hash shr 19));
  end;

  Result := Cardinal(Hash);
end;

{ TFastMessageList }

function TFastMessageList.Add(const Key, Value: string): Integer;
var
  AHash: Cardinal;
  I: Integer;

  Item: PTextMessageItem;
begin
  AHash := GenerateStringHashROT13(Key);
  Result := -1;
  for I := 0 to Count - 1 do
    if (FList[I].tmiHash = AHash) and (Key = FList[I].tmiKey) then
    begin
      Result := I;
      Break;
    end;

  if Result < 0 then
  begin
    // ��������� ������� � ������
    if FCount = FCapacity then
      Grow;

    Result := FCount;
    Inc(FCount);
    New(Item);
    Item.tmiKey := Key;
    Item.tmiHash := AHash;
    FList[Result] := Item;
  end;

  FList[Result].tmiValue := Value;
end;

procedure TFastMessageList.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Dispose(FList[I]);
  FList := nil;
  FCount := 0;
  FCapacity := 0;
end;

destructor TFastMessageList.Destroy;
begin
  Clear;
  inherited;
end;

function TFastMessageList.GetKeyByIndex(Index: Integer): PChar;
begin
  if (Index < 0) or (Index >= Count) then
    raise Exception.Create('Wrong index');
  Result := PChar(FList[Index].tmiKey);
end;

function TFastMessageList.GetValueByIndex(Index: Integer): PChar;
begin
  if (Index < 0) or (Index >= Count) then
    raise Exception.Create('Wrong index');
  Result := PChar(FList[Index].tmiValue);
end;

function TFastMessageList.GetValueByKey(const Key: string): PChar;
var
  Index: Integer;
begin
  Result := '';
  Index := IndexOfKey(Key);
  if Index >= 0 then
    Result := PChar(FList[Index].tmiValue);
end;

procedure TFastMessageList.Grow;
begin
  if FCapacity < 50 then
    SetCapacity(50)
  else
    SetCapacity(FCapacity + FCapacity div 3);
end;

function TFastMessageList.IndexOfKey(const Key: string): Integer;
var
  AHash: Cardinal;
  I: Integer;
begin
  AHash := GenerateStringHashROT13(Key);
  for I := 0 to Count - 1 do
    if (FList[I].tmiHash = AHash) and (Key = FList[I].tmiKey) then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

procedure TFastMessageList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) then
    raise Exception.Create('Wrong capacity');
  if NewCapacity <> FCapacity then
  begin
    SetLength(FList, NewCapacity);
    FCapacity := NewCapacity;
  end;
end;

initialization
{$IFDEF UseGraphics}
  GraphicFormats := TStringList.Create;
  GraphicFormats.AddObject('TMetafile', TObject(TMetafile));
  GraphicFormats.AddObject('TIcon', TObject(TIcon));
  GraphicFormats.AddObject('TBitmap', TObject(TBitmap));
  {$IFDEF UseJPEG}
  GraphicFormats.AddObject('TJPEGImage', TObject(TJPEGImage));
  {$ENDIF UseJPEG}
{$ENDIF UseGraphics}

  LngManager := TLngFilesManager.Create;
finalization
{$IFDEF UseGraphics}
  GraphicFormats.Free;
{$ENDIF UseGraphics}
  FreeAndNil(LngManager);
end.
