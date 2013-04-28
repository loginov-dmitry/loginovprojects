{
Copyright (c) 2010, Loginov Dmitry Sergeevich
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

unit AttribControls;

interface

uses
  Windows, Messages, Classes, SysUtils, SHDocVw, MSHTML, Graphics, Controls,
  Forms, Grids, StdCtrls, ExtCtrls, HTMLGlobal, Spin;

type
  TBaseAttribControl = class(TComponent)
  protected
    FControl: TControl;

    function GetAsText: string; virtual;
    procedure SetAsText(const Value: string); virtual;

    procedure DoDrawOnCell(Sender: TStringGrid; Rect: TRect; State: TGridDrawState); virtual;


  public
    property AsText: string read GetAsText write SetAsText;

    procedure ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer); virtual;

    procedure DrawOnCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure HideControl; virtual;
  end;

  TTextComboBox = class(TBaseAttribControl)
  private
  protected
    function GetAsText: string; override;
    procedure SetAsText(const Value: string); override;
    procedure DoDrawOnCell(Sender: TStringGrid; Rect: TRect; State: TGridDrawState); override;

    procedure ControlOnExit(Sender: TObject);
  public
    FTranslateList: TStringList;
    FComboBox: TComboBox;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetTranslateStr(S: string);
    procedure ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer); override;
  end;

  THTMLColorComboBox = class(TBaseAttribControl)
  private
    FColorBox: TColorBox;
    FNoneColor: TColor;

    procedure ControlOnExit(Sender: TObject);

    procedure OnColorSelect(Sender: TObject);
  protected
    function GetAsText: string; override;
    procedure SetAsText(const Value: string); override;
    procedure DoDrawOnCell(Sender: TStringGrid; Rect: TRect; State: TGridDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer); override;
  end;

  THTMLTextEditor = class(TBaseAttribControl)
  private
    FEditor: TEdit;
    procedure ControlOnExit(Sender: TObject);
  protected
    function GetAsText: string; override;
    procedure SetAsText(const Value: string); override;
    procedure DoDrawOnCell(Sender: TStringGrid; Rect: TRect; State: TGridDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer); override;
  end;

  THTMLSizeEditor = class(TBaseAttribControl)
  private
    FEditor: TEdit;
    
    procedure ControlOnExit(Sender: TObject);
  protected
    function GetAsText: string; override;
    procedure SetAsText(const Value: string); override;
    procedure DoDrawOnCell(Sender: TStringGrid; Rect: TRect; State: TGridDrawState); override;
  public
    FComboBox: TComboBox;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer); override;

    procedure HideControl; override;
  end;

  THTMLIntValueEditor = class(TBaseAttribControl)
  private
    procedure ControlOnExit(Sender: TObject);
    procedure OnSpinKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    function GetAsText: string; override;
    procedure SetAsText(const Value: string); override;
    procedure DoDrawOnCell(Sender: TStringGrid; Rect: TRect; State: TGridDrawState); override;
  public
    FEditor: TSpinEdit;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer); override;
  end;

procedure RegisterAttrControl(ARow: Integer; AControl: TBaseAttribControl);
function GetControlForCell(ARow: Integer; AGrid: TComponent): TBaseAttribControl;

procedure HideAllControls;

procedure ClearControlList;

function CreateAttribControl(AOwner: TComponent; AStyle: THTMLAttribType; ARow: Integer; AText: string): TBaseAttribControl;

implementation

var
  FControlList: TStringList;

function CreateAttribControl(AOwner: TComponent; AStyle: THTMLAttribType; ARow: Integer; AText: string): TBaseAttribControl;
var
  AList: TStringList;
  I: Integer;
  S: string;
begin
  case AStyle of
    atHAlign:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('left=Влево;center=По центру;'+
          'right=Вправо;justify=По ширине');
      end;

    atImgAlign:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('bottom=По низу строку;'+
          'left=По левому краю;middle=По середине строки;right=По правому краю;'+
          'top=По верху строки');
      end;

    atCSSVAlign:    //atVAlign
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('top=Верх;middle=Середина;bottom=Низ;'+
          'baseline=Базовая линия;sub=Подстрочный;super=Надстрочный;'+
          'text-top=По верху строки;text-bottom=По низу строки');
      end;

    atVAlign:    
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('top=Верх;middle=Середина;bottom=Низ;'+
          'baseline=Базовая линия');
      end;

    atULType:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('disc=Круг;circle=Окружность;square=Кдадрат');
      end;

    atOLType:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).FTranslateList.CaseSensitive := True;
        TTextComboBox(Result).SetTranslateStr('A=Латинская заглавная буква;a=Латинская строчная буква;'+
          'I=Римская заглавная буква;i=Римская строчная буква;1=Арабские цифры');
      end;

    atCSSFontStyle:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('normal=Обычное;italic=Курсив;oblique=Наклонный');
      end;

    atCSSFontWeight:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('bold=Полужирный;bolder=Жирный;'+
          'lighter=Светлый;normal=Нормальный;100=100 ед.;200=200 ед.;'+
          '300=300 ед.;400=400 ед.;500=500 ед.;600=600 ед.;700=700 ед.;800=800 ед.;900=900 ед.');
      end;

    atCSSBorderStyle:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('none=Нет;dotted=Точечная;'+
          'dashed=Пунктирная;solid=Сплошная;double=Двойная;groove=Вдавленная;'+
          'ridge=Рельефная;inset=Трехмерная 1;outset=Трехмерная 2');
      end;

    atLinkTarget:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('_blank=В новом окне;_self=В этом же окне;'+
          '_parent=В родительском фрейме;_top=Без фрейма');
      end;

    atCharSet:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('windows-1251=Русская (1251);utf-8=UTF-8');
      end;

    atInputType:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('button=Кнопка;checkbox=Флажок;file=Файл;'+
          'hidden=Скрытый;image=Кнопка с изображением;password=Поле с паролем;'+
          'radio=Переключатель;reset=Кнопка сброса;submit=Кнопка "Отправить";'+
          'text=Поле для ввода текста');
      end;

    atMethod:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('GET=GET;POST=POST');
      end;

    atMrqDir:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('down=Сверху вниз;left=Справа налево;'+
          'right=Слева направо;up=Снизу вверх');
      end;

    atMrqBehav:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('alternate=Туда-сюда;scroll=По кругу;slide=Один раз');
      end;

    atCSSWritingMode:
      begin
        Result := TTextComboBox.Create(AOwner);
        // В IE поддерживается только один вариант данного стиля (tb-rl). Остальные не поддерживаются!
        // В FireFox стиль tb-rl не действует!
        TTextComboBox(Result).SetTranslateStr('tb-rl=ВЕРХ->НИЗ / ПРАВ->ЛЕВ');
      end;

    atCSSPageBreak:
      begin
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('always=Обычный разрыв;left=Сделать левой;right=Сделать правой;auto=По умолчанию');
      end;

    atFontName:
      begin
        Result := TTextComboBox.Create(AOwner);
        AList := TStringList.Create;
        try
          AList.Assign(Screen.Fonts);
          AList.Insert(0, 'Times New Roman');
          for I := 0 to AList.Count - 1 do
            AList[I] := AList[I] + '=' + AList[I];
          S := StringReplace(AList.Text, #13#10, ';', [rfReplaceAll]);
          TTextComboBox(Result).SetTranslateStr(S);
        finally
          AList.Free;
        end;

      end;


    atColor:
      begin
        Result := THTMLColorComboBox.Create(AOwner);
      end;

    atBoolean:
      begin
        if (AText = '') or (AText = '0') then
          AText := ''
        else
          AText := '1';
        Result := TTextComboBox.Create(AOwner);
        TTextComboBox(Result).SetTranslateStr('1=Да');
      end;

    atCount, atPxSize:
      begin
        Result := THTMLIntValueEditor.Create(AOwner);
        THTMLIntValueEditor(Result).FEditor.MinValue := 0;
      end;

    atCount1:
      begin
        Result := THTMLIntValueEditor.Create(AOwner);
        THTMLIntValueEditor(Result).FEditor.MinValue := 1;
      end;

    atCountFromMinus1:
      begin
        Result := THTMLIntValueEditor.Create(AOwner);
        THTMLIntValueEditor(Result).FEditor.MinValue := -1;
      end;

    atCSSSize:
      begin
        Result := THTMLSizeEditor.Create(AOwner);
      end;

    atSize:
      begin
        Result := THTMLSizeEditor.Create(AOwner);
        THTMLSizeEditor(Result).FComboBox.Clear;
        THTMLSizeEditor(Result).FComboBox.Items.Add('');
        THTMLSizeEditor(Result).FComboBox.Items.Add('px');
        THTMLSizeEditor(Result).FComboBox.Items.Add('%');

        if Trim(AText) <> '' then
          if Pos('%', AText) = 0 then
            AText := AText + 'px';
      end;
  else
    begin
      Result := THTMLTextEditor.Create(AOwner);
    end;

  end;

  RegisterAttrControl(ARow, Result);
  Result.AsText := AText;
end; 

procedure RegisterAttrControl(ARow: Integer; AControl: TBaseAttribControl);
begin
  if Assigned(AControl) then
    FControlList.AddObject(AControl.Owner.Name + '_' + IntToStr(ARow), AControl);
end;

function GetControlForCell(ARow: Integer; AGrid: TComponent): TBaseAttribControl;
var
  Index: Integer;
begin
  Result := nil;
  Index := FControlList.IndexOf(AGrid.Name + '_' + IntToStr(ARow));
  if Index >= 0 then
    Result := TBaseAttribControl(FControlList.Objects[Index]);
end;

procedure HideAllControls;
var
  I: Integer;
  cntrl: TBaseAttribControl;
begin
  for I := 0 to FControlList.Count - 1 do
  begin
    cntrl := TBaseAttribControl(FControlList.Objects[I]);
    cntrl.HideControl;
  end;
end;

procedure ClearControlList;
var
  I: Integer;
  cntrl: TBaseAttribControl;
begin
  for I := 0 to FControlList.Count - 1 do
  begin
    cntrl := TBaseAttribControl(FControlList.Objects[I]);
    cntrl.Free;
  end;
  FControlList.Clear;
end;

{ TBaseAttribControl }

constructor TBaseAttribControl.Create(AOwner: TComponent);
begin
  inherited;
  FControl.Visible := False;

  FControl.Parent := TWinControl(AOwner).Parent;
end;

destructor TBaseAttribControl.Destroy;
begin
  FControl.Free;
  inherited;
end;

procedure TBaseAttribControl.SetAsText(const Value: string);
begin

end;

procedure TBaseAttribControl.DoDrawOnCell(Sender: TStringGrid;
  Rect: TRect; State: TGridDrawState);
begin

end;

procedure TBaseAttribControl.DrawOnCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  DoDrawOnCell(TStringGrid(Sender), Rect, State);
end;

function TBaseAttribControl.GetAsText: string;
begin

end;

procedure TBaseAttribControl.HideControl;
begin
  FControl.Hide;
end;

procedure TBaseAttribControl.ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer);
var
  ARect: TRect;
begin
  ARect := AGrid.CellRect(ACol, ARow);
  with ARect do
  begin
    Inc(Left);
    Inc(Top);
    Inc(Right, 2);
  end;

  FControl.BoundsRect := ARect;
  FControl.Visible := True;
end;

{ TTextComboBox }

procedure TTextComboBox.ControlOnExit(Sender: TObject);
begin
  FComboBox.Visible := False
end;

constructor TTextComboBox.Create(AOwner: TComponent);
begin
  FComboBox := TComboBox.Create(AOwner);
  FControl := FComboBox;
  inherited;
  FComboBox.Style := csDropDownList;
  FComboBox.OnExit := ControlOnExit;

  FTranslateList := TStringList.Create;
end;

destructor TTextComboBox.Destroy;
begin
  FTranslateList.Free;
  inherited;
end;

procedure TTextComboBox.DoDrawOnCell(Sender: TStringGrid; Rect: TRect;
  State: TGridDrawState);
var
  S: string;
begin
  Sender.Canvas.FillRect(Rect);
  S := FComboBox.Text;
  Sender.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
end;

procedure TTextComboBox.SetAsText(const Value: string);
var
  Index: Integer;
  S: string;
begin
  if Trim(Value) = '' then
    Index := 0
  else
  begin
    S := FTranslateList.Values[Value];
    Index := FComboBox.Items.IndexOf(S);
  end;

  FComboBox.ItemIndex := Index;
end;

function TTextComboBox.GetAsText: string;
var
  I: Integer;
  S: string;
begin
  S := FComboBox.Text;
  Result := '';

  for I := 0 to FTranslateList.Count - 1 do
    if FTranslateList.ValueFromIndex[I] = S then
    begin
      Result := FTranslateList.Names[I];
      Exit;
    end;
end;

procedure TTextComboBox.SetTranslateStr(S: string);
var
  I: Integer;
begin
  FTranslateList.Text := StringReplace(S, ';', #13#10, [rfReplaceAll]);

  FComboBox.Clear;
  FComboBox.Items.Add(' ');

  for I := 0 to FTranslateList.Count - 1 do
    FComboBox.Items.Add(FTranslateList.ValueFromIndex[I]);
end;

procedure TTextComboBox.ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer);
begin
  inherited;
  FComboBox.SetFocus;
end;

{ THTMLColorComboBox }

procedure THTMLColorComboBox.ControlOnExit(Sender: TObject);
begin
  FColorBox.Hide;
end;

constructor THTMLColorComboBox.Create(AOwner: TComponent);
begin
  FColorBox := TColorBox.Create(AOwner);
  FControl := FColorBox;
  inherited;

  FColorBox.OnExit := ControlOnExit;
  FColorBox.OnSelect := OnColorSelect;
  FColorBox.Style := [cbCustomColors];

  FNoneColor := RGB(254, 255, 255);


  ListFillColorNames(FColorBox.Items);
  FColorBox.Items.InsertObject(0, SNoneColor, TObject(FNoneColor));

  //procedure cbFontBgColorGetColors(Sender: TCustomColorBox; Items: TStrings);
  //FComboBox.Style := csDropDownList;
  //FComboBox.OnExit := ControlOnExit;
end;

destructor THTMLColorComboBox.Destroy;
begin

  inherited;
end;

procedure THTMLColorComboBox.DoDrawOnCell(Sender: TStringGrid; Rect: TRect;
  State: TGridDrawState);
var
  S: string;
begin
  if FColorBox.ItemIndex >= 0 then
  begin
    Sender.Canvas.FillRect(Rect);

    Sender.Canvas.Brush.Color := FColorBox.Selected;
    Sender.Canvas.FillRect(Classes.Rect(Rect.Left + 2, Rect.Top + 2, Rect.Left + 15, Rect.Top + 15));

    Sender.Canvas.Brush.Style := bsClear;

    S := FColorBox.Items[FColorBox.ItemIndex];
    if S <> SNoneColor then
      Sender.Canvas.TextOut(Rect.Left + 20, Rect.Top + 2, S);
  end;
end;

function THTMLColorComboBox.GetAsText: string;
begin
  if (FColorBox.ItemIndex < 0) or (FColorBox.Selected = FNoneColor) then
    Result := ''
  else
    Result := ConvertColorToHtml(FColorBox.Selected);
end;

procedure THTMLColorComboBox.OnColorSelect(Sender: TObject);
var
  IsCancel: Boolean;
begin
  HTMLColorBoxGetColor(FColorBox, HTMLColorDialog, IsCancel);
end;

procedure THTMLColorComboBox.SetAsText(const Value: string);
var
  IColor, Index: Integer;
  SValue: string;

  function IsDigital(S: string): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    if S = '' then Exit;

    for I := 1 to Length(S) do
      if not(S[I] in ['0'..'9', '-']) then Exit;

    Result := True;
  end;

  function IsHex(S: string): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    if S = '' then Exit;
    for I := 1 to Length(S) do
      if not(S[I] in ['0'..'9', 'A'..'F']) then Exit;

    Result := True;
  end;
begin
  inherited;
  SValue := UpperCase(Value);
  IColor := FNoneColor;
  if SValue = 'BLACK' then
    IColor := clBlack
  else if SValue = 'GRAY' then
    IColor := clGray
  else if SValue = 'SILVER' then
    IColor := clSilver
  else if SValue = 'WHITE' then
    IColor := clWhite
  else if SValue = 'MAROON' then
    IColor := clMaroon
  else if SValue = 'RED' then
    IColor := clRed
  else if SValue = 'ORANGE' then
    IColor := TColor($00A5FF)
  else if SValue = 'YELLOW' then
    IColor := clYellow
  else if SValue = 'OLIVE' then
    IColor := clOlive
  else if SValue = 'LIME' then
    IColor := clLime
  else if SValue = 'TEAL' then
    IColor := clTeal
  else if SValue = 'AQUA' then
    IColor := clAqua
  else if SValue = 'BLUE' then
    IColor := clBlue
  else if SValue = 'NAVY' then
    IColor := clNavy
  else if SValue = 'PURPLE' then
    IColor := clPurple
  else if SValue = 'FUСHSIA' then
    IColor := clFuchsia
  else if SValue = 'THISTLE' then
    IColor := TColor($D8BFD8)
  else if IsDigital(SValue) then
  begin
    IColor := StrToInt(SValue)
  end else
  if Pos('#', SValue) > 0 then
  begin
    SValue := StringReplace(SValue, '#', '', []);
    if IsHex(SValue) then
    begin
      if Length(SValue) = 3 then
        SValue := SValue[1] + SValue[1] + SValue[2] + SValue[2] + SValue[3] + SValue[3];
      if Length(SValue) = 6 then
      begin
        IColor := Windows.RGB(StrToInt('$' + SValue[1] + SValue[2]), StrToInt('$' + SValue[3] + SValue[4]),
          StrToInt('$' + SValue[5] + SValue[6]));
        //IColor := StrToIntDef('$' + SValue, FNoneColor);
      end;
    end;    
  end else if Pos('RGB', SValue) > 0 then
  begin
    SValue := StringReplace(SValue, 'RGB', '', [rfReplaceAll]);
    SValue := StringReplace(SValue, '(', '', [rfReplaceAll]);
    SValue := StringReplace(SValue, ')', '', [rfReplaceAll]);
    while Pos(' ', SValue) > 0 do
      SValue := StringReplace(SValue, ' ', '', [rfReplaceAll]);

    with TStringList.Create do
    try
      Text := StringReplace(SValue, ',', #13#10, [rfReplaceAll]);
      if Count > 2 then
      begin
        try
          IColor := Windows.RGB(StrToInt(Strings[0]), StrToInt(Strings[1]),
            StrToInt(Strings[0]));
        except
          IColor := FNoneColor;
        end;
      end;
    finally
      Free;
    end;
  end;

  Index := FColorBox.Items.IndexOfObject(TObject(IColor));
  if Index >= 0 then
    FColorBox.ItemIndex := Index
  else
  begin
    Index := FColorBox.Items.IndexOf(SSelectColor);
    if Index >= 0 then
    begin
      FColorBox.Items.Objects[Index] := TObject(IColor);
      FColorBox.ItemIndex := Index;
    end;
  end;
  
{      ColBox.Enabled := True;
      AColor := StrToIntDef(S, 0);
      Index := ColBox.Items.IndexOfObject(TObject(AColor));
      if Index >= 0 then
        ColBox.ItemIndex := Index
      else
      begin
        Index := ColBox.Items.IndexOf(SSelectColor);
        if Index >= 0 then
          ColBox.Items.Objects[Index] := TObject(AColor);
      end;}
end;

procedure THTMLColorComboBox.ShowOnGrid(AGrid: TStringGrid; ACol,
  ARow: Integer);
begin
  inherited;
  //GetParentForm(FColorBox).ActiveControl := FColorBox;

  FColorBox.SetFocus;
end;

{ THTMLTextEditor }

procedure THTMLTextEditor.ControlOnExit(Sender: TObject);
begin
  FEditor.Hide;
end;

constructor THTMLTextEditor.Create(AOwner: TComponent);
begin
  FEditor := TEdit.Create(AOwner);
  FControl := FEditor;
  inherited;
  FEditor.OnExit := ControlOnExit;
end;

destructor THTMLTextEditor.Destroy;
begin

  inherited;
end;

procedure THTMLTextEditor.DoDrawOnCell(Sender: TStringGrid; Rect: TRect;
  State: TGridDrawState);
var
  S: string;
begin
  Sender.Canvas.FillRect(Rect);
  S := FEditor.Text;
  Sender.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
end;

function THTMLTextEditor.GetAsText: string;
begin
  Result := FEditor.Text;
end;

procedure THTMLTextEditor.SetAsText(const Value: string);
begin
  inherited;
  FEditor.Text := Value;
end;

procedure THTMLTextEditor.ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer);
begin
  inherited;
  FEditor.SetFocus;
end;

{ THTMLIntValueEditor }

procedure THTMLIntValueEditor.ControlOnExit(Sender: TObject);
begin
  FEditor.Hide;
end;

constructor THTMLIntValueEditor.Create(AOwner: TComponent);
begin
  FEditor := TSpinEdit.Create(AOwner);
  FControl := FEditor;
  inherited;
  FEditor.OnExit := ControlOnExit;
  FEditor.OnKeyDown := OnSpinKeyDown;
  FEditor.MinValue := -1;
  FEditor.MaxValue := MaxWord;
  
end;

destructor THTMLIntValueEditor.Destroy;
begin

  inherited;
end;

procedure THTMLIntValueEditor.DoDrawOnCell(Sender: TStringGrid; Rect: TRect;
  State: TGridDrawState);
var
  S: string;
begin
  Sender.Canvas.FillRect(Rect);
  S := FEditor.Text;
  Sender.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
end;

function THTMLIntValueEditor.GetAsText: string;
begin
  {if (StrToIntDef(FEditor.Text, -2) < FEditor.MinValue) or  then
    Result := 1
  else   }
  if FEditor.Text = '' then
    Result := ''
  else
    Result := IntToStr(FEditor.Value)
  //Result := FEditor.Text;
end;

procedure THTMLIntValueEditor.OnSpinKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  AForm: TCustomForm;
  Btn: TButton;
begin
  if Key = VK_RETURN then
  begin
    HideControl;

    AForm := Forms.GetParentForm(TControl(Sender));
    if Assigned(AForm) then
    begin
      Btn := TButton(AForm.FindComponent('btnOK'));
      if Assigned(Btn) then
        Btn.Click;
    end;
  end;
end;

procedure THTMLIntValueEditor.SetAsText(const Value: string);
begin
  inherited;
  FEditor.Text := Value;
end;

procedure THTMLIntValueEditor.ShowOnGrid(AGrid: TStringGrid; ACol,
  ARow: Integer);
begin
  inherited;
  FEditor.SetFocus;
end;

{ THTMLSizeEditor }

procedure THTMLSizeEditor.ControlOnExit(Sender: TObject);
begin
  if (Sender = FEditor) and FComboBox.Focused then Exit;
  if (Sender = FComboBox) and FEditor.Focused then Exit;

  FEditor.Hide;
  FComboBox.Hide;
end;

constructor THTMLSizeEditor.Create(AOwner: TComponent);
begin
  FEditor := TEdit.Create(AOwner);
  FComboBox := TComboBox.Create(AOwner);
  FComboBox.Parent := TWinControl(AOwner).Parent;
  FComboBox.Visible := False;
  FComboBox.Style := csDropDownList;

  FComboBox.Items.Add('');
  FComboBox.Items.Add('px');
  FComboBox.Items.Add('%');
  FComboBox.Items.Add('cm');
  FComboBox.Items.Add('em');
  FComboBox.Items.Add('pt');

  FControl := FEditor;
  inherited;
  FEditor.OnExit := ControlOnExit;
  FComboBox.OnExit := ControlOnExit;
end;

destructor THTMLSizeEditor.Destroy;
begin
  FComboBox.Free;
  inherited;
end;

procedure THTMLSizeEditor.DoDrawOnCell(Sender: TStringGrid; Rect: TRect;
  State: TGridDrawState);
var
  S: string;
begin
  Sender.Canvas.FillRect(Rect);
  if Trim(FEditor.Text) <> '' then
    S := FEditor.Text + FComboBox.Text;
  Sender.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
end;

function THTMLSizeEditor.GetAsText: string;
var
  S, SCh: string;
  V: Extended;
begin
  Result := '';
  SCh := StringReplace(Trim(FEditor.Text), ',', DecimalSeparator, [rfReplaceAll]);
  SCh := StringReplace(SCh, '.', DecimalSeparator, [rfReplaceAll]);

  if TryStrToFloat(SCh, V) then
  begin
    if (V >= 0) and (V < MaxWord) then
    begin
      S := FloatToStr(V);
      S := StringReplace(S, ',', '.', [rfReplaceAll]);
      Result := S + FComboBox.Text;
    end;
  end;
end;

procedure THTMLSizeEditor.HideControl;
begin
  inherited;
  FComboBox.Hide;
end;

procedure THTMLSizeEditor.SetAsText(const Value: string);
var
  I, Index: Integer;
  S, S1, S2: string;
begin
  inherited;
  S1 := Trim(LowerCase(Value));
  S1 := StringReplace(S1, ' ', '', [rfReplaceAll]);
  for I := 1 to Length(S1) do
    if S1[I] in ['0'..'9', '.'] then
      S := S + S1[I]
    else
      Break;

  if Pos('cm', S1) > 0 then
    S2 := 'cm'
  else if Pos('em', S1) > 0 then
    S2 := 'em'
  else if Pos('pt', S1) > 0 then
    S2 := 'pt'
  else if Pos('%', S1) > 0 then
    S2 := '%'
  else if Pos('px', S1) > 0 then
    S2 := 'px';

  FEditor.Text := S;
  Index := FComboBox.Items.IndexOf(S2);
  if Index >= 0 then
    FComboBox.ItemIndex := Index;
end;

procedure THTMLSizeEditor.ShowOnGrid(AGrid: TStringGrid; ACol, ARow: Integer);
var
  ARect: TRect;
begin
  ARect := AGrid.CellRect(ACol, ARow);
  with ARect do
  begin
    Inc(Left);
    Inc(Top);
    Right := Right - 50;
  end;

  FEditor.BoundsRect := ARect;
  FEditor.Visible := True;

  with ARect do
  begin
    Left := Right + 2;
    Right := Left + 50;
  end;

  FComboBox.BoundsRect := ARect;
  FComboBox.Visible := True;

  FEditor.SetFocus;
  
end;

initialization
  FControlList := TStringList.Create;

finalization
  FControlList.Free;
end.
