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

unit HTMLEditorUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, OleCtrls, SHDocVw, MSHTML, StdCtrls, ExtActns, StdActns,
  ActnList, ImgList, ExtCtrls, ComCtrls, ToolWin, ActiveX, Math, Menus,
  HTMLGlobal, TableUnit, Spin;

type           

  TEditorForm = class(TForm)
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    ImageList1: TImageList;
    ToolBar2: TToolBar;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ActionList1: TActionList;
    acCopy: TAction;
    acCut: TAction;
    acPast: TAction;
    acUndo: TAction;
    acBold: TAction;
    acItalic: TAction;
    acStrike: TAction;
    acUnderLine: TAction;
    acLeft: TAction;
    acCenter: TAction;
    acRight: TAction;
    acUList: TAction;
    cbFontBgColor: TColorBox;
    ColorDialog1: TColorDialog;
    Label1: TLabel;
    Label2: TLabel;
    cbFontColor: TColorBox;
    Label3: TLabel;
    cbFont: TComboBox;
    Label4: TLabel;
    cbFontSize: TComboBox;
    tmParamsReader: TTimer;
    Panel2: TPanel;
    ToolButton1: TToolButton;
    acOList: TAction;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    acIdentLeft: TAction;
    acIdentRight: TAction;
    acSubScript: TAction;
    acSuperScript: TAction;
    ToolButton2: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    acDelFormat: TAction;
    acJustifyFull: TAction;
    ToolButton8: TToolButton;
    acHorLine: TAction;
    acHLink: TAction;
    acImage: TAction;
    acRedo: TAction;
    acSelectAll: TAction;
    acSaveAs: TAction;
    acFind: TAction;
    Panel4: TPanel;
    sbTags: TScrollBox;
    panTags: TPanel;
    pmTags: TPopupMenu;
    pmiTagProp: TMenuItem;
    N6: TMenuItem;
    HTML1: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    pmiDeleteOuter: TMenuItem;
    pmiDeleteTagOnly: TMenuItem;
    pmiDeleteInner: TMenuItem;
    N8: TMenuItem;
    pmiChangeOuter: TMenuItem;
    pmiChangeInner: TMenuItem;
    N10: TMenuItem;
    N4: TMenuItem;
    Label7: TLabel;
    cbParFormat: TComboBox;
    acBR: TAction;
    ToolButton13: TToolButton;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    acNBSP: TAction;
    acReplaceToNBSP: TAction;
    N2: TMenuItem;
    acAddRunString: TAction;
    acAddRunString1: TMenuItem;
    N3: TMenuItem;
    acHorLine1: TMenuItem;
    acImage1: TMenuItem;
    acBR1: TMenuItem;
    acAddInputText: TAction;
    N9: TMenuItem;
    acAddInputButton: TAction;
    N11: TMenuItem;
    acAddInputFile: TAction;
    N12: TMenuItem;
    acAddInputImage: TAction;
    N13: TMenuItem;
    acAddInputPassword: TAction;
    N14: TMenuItem;
    acAddInputReset: TAction;
    N15: TMenuItem;
    acAddInputSubmit: TAction;
    N16: TMenuItem;
    acAddInputCheckbox: TAction;
    N17: TMenuItem;
    acAddInputRadio: TAction;
    N18: TMenuItem;
    acAddFormInFrame: TAction;
    N19: TMenuItem;
    acAddForm: TAction;
    N20: TMenuItem;
    acAddTEXTAREA: TAction;
    N21: TMenuItem;
    acAddSelect: TAction;
    N22: TMenuItem;
    acNOBRString: TAction;
    N23: TMenuItem;
    ToolButton14: TToolButton;
    acAddTable: TAction;
    acAddCustomHTML: TAction;
    N25: TMenuItem;
    pmiTableActions: TMenuItem;
    acTabDelRow: TAction;
    N26: TMenuItem;
    acCellDeSpan: TAction;
    N27: TMenuItem;
    acTabDelColumn: TAction;
    N28: TMenuItem;
    acAddRowBelow: TAction;
    N29: TMenuItem;
    acAddRowTop: TAction;
    N30: TMenuItem;
    acDelAttribWidth: TAction;
    N31: TMenuItem;
    acDelAttribHeight: TAction;
    N32: TMenuItem;
    acAddColRight: TAction;
    N33: TMenuItem;
    acAddColLeft: TAction;
    N34: TMenuItem;
    acMergeCellRight: TAction;
    N35: TMenuItem;
    acMergeCellBottom: TAction;
    N36: TMenuItem;
    N110: TMenuItem;
    N210: TMenuItem;
    N37: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    N101: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N111: TMenuItem;
    N211: TMenuItem;
    N310: TMenuItem;
    N42: TMenuItem;
    N52: TMenuItem;
    N62: TMenuItem;
    N72: TMenuItem;
    N82: TMenuItem;
    N92: TMenuItem;
    N102: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton37: TToolButton;
    ToolButton38: TToolButton;
    ToolButton39: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton42: TToolButton;
    acCellBorderL: TAction;
    acCellBorderT: TAction;
    acCellBorderR: TAction;
    acCellBorderB: TAction;
    acCellBorderAll: TAction;
    ToolButton43: TToolButton;
    ToolButton44: TToolButton;
    ToolButton45: TToolButton;
    ToolButton46: TToolButton;
    ToolButton47: TToolButton;
    acCellBorderReset: TAction;
    ToolButton48: TToolButton;
    acSaveToFile: TAction;
    ToolBar3: TToolBar;
    ToolButton49: TToolButton;
    ToolButton50: TToolButton;
    ToolButton51: TToolButton;
    ToolButton52: TToolButton;
    ToolButton53: TToolButton;
    ToolButton54: TToolButton;
    ToolBar4: TToolBar;
    ToolButton12: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    acFileOpen: TAction;
    OpenDialog1: TOpenDialog;
    ToolButton11: TToolButton;
    acNewPage: TAction;
    ToolButton15: TToolButton;
    SaveDialog1: TSaveDialog;
    acHTMLEdit: TAction;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    N40: TMenuItem;
    N43: TMenuItem;
    HTML2: TMenuItem;
    acExit: TAction;
    N44: TMenuItem;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    N48: TMenuItem;
    N49: TMenuItem;
    N50: TMenuItem;
    N53: TMenuItem;
    N54: TMenuItem;
    N55: TMenuItem;
    N56: TMenuItem;
    N57: TMenuItem;
    N58: TMenuItem;
    N59: TMenuItem;
    acUndo1: TMenuItem;
    acRedo1: TMenuItem;
    acCopy1: TMenuItem;
    acCut1: TMenuItem;
    acPast1: TMenuItem;
    N60: TMenuItem;
    N63: TMenuItem;
    acZoom1: TAction;
    acZoomInc: TAction;
    acZoomDec: TAction;
    N64: TMenuItem;
    N1001: TMenuItem;
    N65: TMenuItem;
    N66: TMenuItem;
    N67: TMenuItem;
    N68: TMenuItem;
    N69: TMenuItem;
    mmiFontSize: TMenuItem;
    N73: TMenuItem;
    N74: TMenuItem;
    acPreview: TAction;
    ToolButton21: TToolButton;
    N70: TMenuItem;
    N75: TMenuItem;
    N76: TMenuItem;
    Panel3: TPanel;
    Label6: TLabel;
    ToolButton32: TToolButton;
    PopupMenu1: TPopupMenu;
    N77: TMenuItem;
    N78: TMenuItem;
    N79: TMenuItem;
    N80: TMenuItem;
    N83: TMenuItem;
    N84: TMenuItem;
    N85: TMenuItem;
    pmiElementProperty: TMenuItem;
    N87: TMenuItem;
    N24: TMenuItem;
    panCursor: TPanel;
    tmMoveCaret: TTimer;
    ToolButton55: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure acEditModeExecute(Sender: TObject);
    procedure acBoldExecute(Sender: TObject);
    procedure acItalicExecute(Sender: TObject);
    procedure acUnderLineExecute(Sender: TObject);
    procedure acStrikeExecute(Sender: TObject);
    procedure acUndoExecute(Sender: TObject);
    procedure acCenterExecute(Sender: TObject);
    procedure acRightExecute(Sender: TObject);
    procedure acLeftExecute(Sender: TObject);
    procedure acCopyExecute(Sender: TObject);
    procedure acCutExecute(Sender: TObject);
    procedure acPastExecute(Sender: TObject);
    procedure cbFontBgColorGetColors(Sender: TCustomColorBox; Items: TStrings);
    procedure cbFontBgColorSelect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbFontColorSelect(Sender: TObject);
    procedure cbFontDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbFontSelect(Sender: TObject);
    procedure cbFontSizeSelect(Sender: TObject);
    procedure cbFontSizeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmParamsReaderTimer(Sender: TObject);
    procedure acUListExecute(Sender: TObject);
    procedure acOListExecute(Sender: TObject);
    procedure acIdentLeftExecute(Sender: TObject);
    procedure acIdentRightExecute(Sender: TObject);
    procedure acSubScriptExecute(Sender: TObject);
    procedure acSuperScriptExecute(Sender: TObject);
    procedure acDelFormatExecute(Sender: TObject);
    procedure acJustifyFullExecute(Sender: TObject);
    procedure acHorLineExecute(Sender: TObject);
    procedure acHLinkExecute(Sender: TObject);
    procedure acImageExecute(Sender: TObject);
    procedure acRedoExecute(Sender: TObject);
    procedure acSelectAllExecute(Sender: TObject);
    procedure acFindExecute(Sender: TObject);
    procedure HTML1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure pmiDeleteOuterClick(Sender: TObject);
    procedure pmiDeleteTagOnlyClick(Sender: TObject);
    procedure pmiDeleteInnerClick(Sender: TObject);
    procedure pmiChangeOuterClick(Sender: TObject);
    procedure pmiChangeInnerClick(Sender: TObject);
    procedure pmiTagPropClick(Sender: TObject);
    procedure cbParFormatSelect(Sender: TObject);
    procedure acBRExecute(Sender: TObject);
    procedure acNBSPExecute(Sender: TObject);
    procedure acReplaceToNBSPExecute(Sender: TObject);
    procedure acAddRunStringExecute(Sender: TObject);
    procedure acAddInputTextExecute(Sender: TObject);
    procedure acAddInputButtonExecute(Sender: TObject);
    procedure acAddInputFileExecute(Sender: TObject);
    procedure acAddInputImageExecute(Sender: TObject);
    procedure acAddInputPasswordExecute(Sender: TObject);
    procedure acAddInputResetExecute(Sender: TObject);
    procedure acAddInputSubmitExecute(Sender: TObject);
    procedure acAddInputCheckboxExecute(Sender: TObject);
    procedure acAddInputRadioExecute(Sender: TObject);
    procedure acAddFormInFrameExecute(Sender: TObject);
    procedure acAddFormExecute(Sender: TObject);
    procedure acAddTEXTAREAExecute(Sender: TObject);
    procedure acAddSelectExecute(Sender: TObject);
    procedure acNOBRStringExecute(Sender: TObject);
    procedure acAddTableExecute(Sender: TObject);
    procedure acAddCustomHTMLExecute(Sender: TObject);
    procedure acTabDelRowExecute(Sender: TObject);
    procedure acCellDeSpanExecute(Sender: TObject);
    procedure acTabDelColumnExecute(Sender: TObject);
    procedure acAddRowBelowExecute(Sender: TObject);
    procedure acAddRowTopExecute(Sender: TObject);
    procedure acDelAttribWidthExecute(Sender: TObject);
    procedure acDelAttribHeightExecute(Sender: TObject);
    procedure acAddColRightExecute(Sender: TObject);
    procedure acAddColLeftExecute(Sender: TObject);
    procedure acMergeCellRightExecute(Sender: TObject);
    procedure acMergeCellBottomExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acCellBorderLExecute(Sender: TObject);
    procedure acCellBorderAllExecute(Sender: TObject);
    procedure acCellBorderResetExecute(Sender: TObject);
    procedure acSaveToFileExecute(Sender: TObject);
    procedure acFileOpenExecute(Sender: TObject);
    procedure acNewPageExecute(Sender: TObject);
    procedure acSaveAsExecute(Sender: TObject);
    procedure acHTMLEditExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acZoom1Execute(Sender: TObject);
    procedure acZoomIncExecute(Sender: TObject);
    procedure mmiFontSizeClick(Sender: TObject);
    procedure acPreviewExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N76Click(Sender: TObject);
    procedure pmiElementPropertyClick(Sender: TObject);
    procedure N86Click(Sender: TObject);
    procedure tmMoveCaretTimer(Sender: TObject);
    procedure panCursorClick(Sender: TObject);
    procedure ToolButton55Click(Sender: TObject);
  private
    procedure DoSaveToFile;
    function GetHTMLPageCode: string;

    procedure WMMouseActivate(var Msg: TMessage); message WM_MOUSEACTIVATE;

    { Private declarations }
  public
    { Public declarations }

    HTMLInfo: THTMLEditorInfo;
    Tabs: TTableClass;

    TempHTMLFileName: WideString;

    EvtMethod: IDispatch;

    OldVisible: Boolean;

    FDesignMode: Boolean;

    ShowSaveButton: Boolean;

    // Индекс кнопки, соответствующий тэгу "HTML" в массиве ElemDescArray
    //DocumPropIndex: Integer;

    function ColorBoxGetColor(ColBox: TColorBox; ColDlg: TColorDialog; var IsCancel: Boolean): TColor;

    procedure FillFontList();

    function DocRange: IHTMLTxtRange;
    function GetControlRange: IHTMLControlRange;

    function SelectedIsBold(TextRange: IHTMLTxtRange): Boolean;
    function SelectedIsItalic(TextRange: IHTMLTxtRange): Boolean;
    function SelectedIsStrike(TextRange: IHTMLTxtRange): Boolean;
    function SelectedIsUnderline(TextRange: IHTMLTxtRange): Boolean;
    function SelectedIsJustifyRight(TextRange: IHTMLTxtRange): Boolean;
    function SelectedIsJustifyLeft(TextRange: IHTMLTxtRange): Boolean;
    function SelectedIsJustifyCenter(TextRange: IHTMLTxtRange): Boolean;
    function SelectedIsJustifyFull(TextRange: IHTMLTxtRange): Boolean;

    function SelectedFontName(TextRange: IHTMLTxtRange): string;

    function SelectedFontColor(TextRange: IHTMLTxtRange): string;
    function SelectedFontBgColor(TextRange: IHTMLTxtRange): string;
    function SelectedFontSize(TextRange: IHTMLTxtRange): string;

    function SelectedIsOrderedList(TextRange: IHTMLTxtRange): Boolean;
    function SelectedIsUnOrderedList(TextRange: IHTMLTxtRange): Boolean;

    function SelectedIsSubscript(TextRange: IHTMLTxtRange): Boolean;
    function SelectedIsSuperscript(TextRange: IHTMLTxtRange): Boolean;

    procedure LocateToColor(ColBox: TColorBox; S: string);

    procedure ShowTagsPath;

    procedure CheckEditingPossible(ATag: string; var CanEditInnerText, CanEditOuterText: Boolean);

    procedure SetParFormat(TextRange: IHTMLTxtRange);

    procedure CollectStyles(AList: TStringList; Elem: IHTMLElement);
    procedure UpdateStyles(AList: TStringList; Elem: IHTMLElement);

    procedure OnButtonTagClick(Sender: TObject);

    procedure OnButtonTagMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure TableActionsSetEnabled(Value: Boolean; ACell: IHTMLElement);

    procedure TableActionsSetChecked(ACell: IHTMLElement);

    procedure LoadPageFromFile(AFileName: string);

    function GetTempHTMLFileName: string;
    procedure SaveToTempFile;

    function CanUndo: Boolean;
    function CanSave: Boolean;
    function CanRedo: Boolean;
    function CanCopy: Boolean;
    function CanCut: Boolean;
    function CanPaste: Boolean;

    procedure SetPanCursorPos;
    procedure HideOriginalCursor(AHide: Boolean);
  end;

  TEventMethod = class(TInterfacedObject, IDispatch)
  public
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  end;

  THashPanel = class(TPanel)
  public
    property Canvas;
  end;

var
  EditorForm: TEditorForm;



implementation

uses EditHTMLFrm, PropertyFrm, ABOUT, RepVarsFrm;

{$R *.dfm}

const
  SDefaultCaption = 'HTML-редактор';

procedure TEditorForm.acAddFormExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<FORM>Добавьте '+
      'необходимый текст и элементы ввода<br><input type="submit"></FORM>');
  end;
end;

procedure TEditorForm.acAddFormInFrameExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<FORM><fieldset><legend>Форма ввода</legend>Добавьте '+
      'необходимый текст и элементы ввода<br><input type="submit"></fieldset></FORM>');
  end;
end;

procedure TEditorForm.acAddInputButtonExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<INPUT TYPE="button" VALUE="Кнопка">');
  end;
end;

procedure TEditorForm.acAddInputCheckboxExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<INPUT TYPE="checkbox"> Флажок');
  end;
end;

procedure TEditorForm.acAddInputFileExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('Выберите файл: <INPUT TYPE="file">');
  end;
end;

procedure TEditorForm.acAddInputImageExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<INPUT TYPE="image" VALUE="Поле с изображением">');
  end;
end;

procedure TEditorForm.acAddInputTextExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<INPUT TYPE="text" VALUE="Строка ввода">');
  end;
end;

procedure TEditorForm.acAddRowBelowExecute(Sender: TObject);
begin
  Tabs.DoTableAddRow(True);
  ShowTagsPath;
end;

procedure TEditorForm.acAddRowTopExecute(Sender: TObject);
begin
  Tabs.DoTableAddRow(False);
  ShowTagsPath;
end;

procedure TEditorForm.acAddRunStringExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<MARQUEE>Бегущая строка</MARQUEE>');
  end;
end;

procedure TEditorForm.acAddSelectExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<SELECT><OPTION selected>Элемент 1</OPTION><OPTION>Элемент 2</OPTION><OPTION>Элемент 3</OPTION></SELECT>');
  end;
end;

procedure TEditorForm.acAddTableExecute(Sender: TObject);
begin
  Tabs.AddNewTable;
end;

procedure TEditorForm.acAddTEXTAREAExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<TEXTAREA>Многострочный текст</TEXTAREA>');
  end;
end;

procedure TEditorForm.acBoldExecute(Sender: TObject);
begin
  DocRange.execCommand('bold', false, emptyparam);
  TAction(Sender).Checked := SelectedIsBold(DocRange);

  SetPanCursorPos;
end;

procedure TEditorForm.acBRExecute(Sender: TObject);
begin
  DocRange.pasteHTML('<BR>');

  SetPanCursorPos;
end;

procedure TEditorForm.acCellBorderAllExecute(Sender: TObject);
begin
  if acCellBorderAll.Checked then
    Tabs.ResetAllCellBorders('F')
  else
    Tabs.ResetAllCellBorders('T');

  TableActionsSetChecked(HTMLInfo.CurrentCell);
end;

procedure TEditorForm.acCellBorderLExecute(Sender: TObject);
var
  Value, Side: Char;
begin
  case TAction(Sender).Tag of
    1: Side := 'L';
    2: Side := 'T';
    3: Side := 'R';
  else
    Side := 'B';
  end;

  case TAction(Sender).Checked of
    True: Value := 'F';
  else
    Value := 'T';
  end;

  Tabs.ResetOneCellBorder(Side, Value);

  TableActionsSetChecked(HTMLInfo.CurrentCell);
end;

procedure TEditorForm.acCellBorderResetExecute(Sender: TObject);
begin
  Tabs.ResetAllCellBorders('D');
  
  TableActionsSetChecked(HTMLInfo.CurrentCell);
end;

procedure TEditorForm.acCellDeSpanExecute(Sender: TObject);
var
  ACell: IHTMLTableCell;
  Tab: IHTMLTable;
  ARow: IHTMLTableRow;
  Index: Integer;


begin
  Index := HTMLInfo.CurrentIndex;

  if Assigned(HTMLInfo.ActiveElement) then
    HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;

  Tab := Tabs.GetCurrentTable(Index);
  ARow := Tabs.GetCurrentTableRow(Index);
  ACell := Tabs.GetCurrentTableCell(Index);

  Tabs.DoCellDeSpan(Tab, ARow, ACell);

  ShowTagsPath;
end;

procedure TEditorForm.acCenterExecute(Sender: TObject);
begin
  if SelectedIsJustifyCenter(DocRange) then
    DocRange.execCommand('JustifyNone', false, emptyparam)
  else
    DocRange.execCommand('JustifyCenter', false, emptyparam);

  TAction(Sender).Checked := SelectedIsJustifyCenter(DocRange);

  SetPanCursorPos;
end;

procedure TEditorForm.acCopyExecute(Sender: TObject);
begin
  // Не работает без OleInitialize
  //DocRange.execCommand('Copy', false, emptyparam);

  WebBrowser1.ExecWB(OLECMDID_COPY, OLECMDEXECOPT_DONTPROMPTUSER);
end;

procedure TEditorForm.acCutExecute(Sender: TObject);
begin
  // Не работает без OleInitialize
  //DocRange.execCommand('Cut', false, emptyparam);

  WebBrowser1.ExecWB(OLECMDID_CUT, OLECMDEXECOPT_DONTPROMPTUSER);

  SetPanCursorPos;
end;

procedure TEditorForm.acDelAttribHeightExecute(Sender: TObject);
begin
  Tabs.DoDelAttribSize(False);
end;

procedure TEditorForm.acDelAttribWidthExecute(Sender: TObject);
begin
  Tabs.DoDelAttribSize(True);
end;

procedure TEditorForm.acDelFormatExecute(Sender: TObject);
begin
  DocRange.execCommand('RemoveFormat', false, emptyparam);

  SetPanCursorPos;
end;

procedure TEditorForm.acEditModeExecute(Sender: TObject);
begin
//
end;

procedure TEditorForm.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TEditorForm.acFileOpenExecute(Sender: TObject);
begin
  if CanSave then
    if Application.MessageBox(
      'Были внесены изменения. При открытии документа'#13#10+
      'изменения будут потеряны! Вы действительно'#13#10+
      'хотите открыть другой документ?', 'Подтверждение',
      MB_OKCANCEL or MB_ICONQUESTION) = IDCANCEL then Exit;

  if OpenDialog1.Execute then
    LoadPageFromFile(OpenDialog1.FileName);
end;

const
  HTMLID_FIND       = 1;       

procedure TEditorForm.acFindExecute(Sender: TObject);
const
  CGID_WebBrowser: TGUID = '{ED016940-BD5B-11cf-BA4E-00C04FD70816}';
var
  CmdTarget : IOleCommandTarget;
  vaIn, vaOut: OleVariant;
  PtrGUID: PGUID;
begin
  New(PtrGUID);
  PtrGUID^ := CGID_WebBrowser;
  if WebBrowser1.Document <> nil then
    try
      WebBrowser1.Document.QueryInterface(IOleCommandTarget, CmdTarget);
      if CmdTarget <> nil then
        try
          CmdTarget.Exec( PtrGUID, HTMLID_FIND, 0, vaIn, vaOut);
        finally
          CmdTarget._Release;
        end;
    except
      // nothing
    end;
  Dispose(PtrGUID);

end;

procedure TEditorForm.acHLinkExecute(Sender: TObject);
begin
  DocRange.execCommand('CreateLink', True, emptyparam);
end;

procedure TEditorForm.acHorLineExecute(Sender: TObject);
begin
  DocRange.execCommand('InsertHorizontalRule', false, emptyparam);
end;

procedure TEditorForm.acHTMLEditExecute(Sender: TObject);
var
  CurrentWB: IWebBrowser;
  S: string;
begin
  acHTMLEdit.Checked := not acHTMLEdit.Checked;

  CurrentWB := HTMLInfo.Disp as IWebBrowser;
  HTMLInfo.editor := (CurrentWB.Document as IHTMLDocument2);

  //htmlinfo.Editor.ondblclick := EvtMethod;

  try
    S := (HTMLInfo.Editor.body.style as IHTMLStyle3).zoom;
    HTMLInfo.CanUseZoom := True;
  except
    HTMLInfo.CanUseZoom := False;
  end;

  FDesignMode := acHTMLEdit.Checked;

  if FDesignMode then
    HTMLInfo.editor.DesignMode := 'On'
  else
    HTMLInfo.editor.DesignMode := 'Off';


  {var
  CurrentWB: IWebBrowser;
begin
  CurrentWB := HTMLInfo.Disp as IWebBrowser;
  HTMLInfo.editor := (CurrentWB.Document as IHTMLDocument2);

  if btnEditMode.Down then
    HTMLInfo.editor.DesignMode := 'On'
  else
    HTMLInfo.editor.DesignMode := 'Off';
}
end;

procedure TEditorForm.acIdentLeftExecute(Sender: TObject);
begin
  DocRange.execCommand('Outdent', false, emptyparam);

  SetPanCursorPos;
end;

procedure TEditorForm.acIdentRightExecute(Sender: TObject);
begin
  DocRange.execCommand('Indent', false, emptyparam);

  SetPanCursorPos;
end;

procedure TEditorForm.acImageExecute(Sender: TObject);
begin
  DocRange.execCommand('InsertImage', true, emptyparam);
end;

procedure TEditorForm.acItalicExecute(Sender: TObject);
begin
  DocRange.execCommand('italic', false, emptyparam);
  TAction(Sender).Checked := SelectedIsItalic(DocRange);

  SetPanCursorPos;
end;

procedure TEditorForm.acJustifyFullExecute(Sender: TObject);
begin
  if SelectedIsJustifyFull(DocRange) then
    DocRange.execCommand('JustifyNone', false, emptyparam)
  else
    DocRange.execCommand('JustifyFull', false, emptyparam);

  TAction(Sender).Checked := SelectedIsJustifyFull(DocRange);

  SetPanCursorPos;
end;

procedure TEditorForm.acLeftExecute(Sender: TObject);
begin
  if SelectedIsJustifyLeft(DocRange) then
    DocRange.execCommand('JustifyNone', false, emptyparam)
  else
    DocRange.execCommand('JustifyLeft', false, emptyparam);

  TAction(Sender).Checked := SelectedIsJustifyLeft(DocRange);

  SetPanCursorPos;
end;

procedure TEditorForm.acMergeCellBottomExecute(Sender: TObject);
var
  I, Cnt: Integer;
  S: string;
begin
  Cnt := TComponent(Sender).Tag;

  if Cnt = 0 then
  begin
    S := '1';
    if InputQuery('Объединение с ячейками снизу',
      'Укажите количество ячеек снизу', S) then
    begin
      Cnt := StrToIntDef(S, 0);
    end;
  end;

  if Cnt < 1 then
    raise Exception.Create('Необходимо указать количество ячеек снизу');

  for I := 1 to Cnt do
    Tabs.DoTableMergeCell(False);
end;

procedure TEditorForm.acMergeCellRightExecute(Sender: TObject);
var
  I, Cnt: Integer;
  S: string;
begin
  Cnt := TComponent(Sender).Tag;

  if Cnt = 0 then
  begin
    S := '1';
    if InputQuery('Объединение с ячейками справа',
      'Укажите количество ячеек справа', S) then
    begin
      Cnt := StrToIntDef(S, 0);
    end;
  end;

  if Cnt < 1 then
    raise Exception.Create('Необходимо указать количество ячеек справа');

  for I := 1 to Cnt do
    Tabs.DoTableMergeCell(True);
end;

procedure TEditorForm.acNBSPExecute(Sender: TObject);
var
  S: string;
  Elem: IHTMLElement;
  I, K: Integer;
begin
  S := '1';
  if InputQuery('Ввод количества пробелов',
    'Введите число неразрывных пробелов', S) then
  begin
    K := StrToIntDef(S, 0);
    if (K < 0) or (K > 1000) then
      raise Exception.Create('Недопустимое количество пробелов!');

    //ShowMessage(DocRange.htmlText);
    S := '';
    for I := 1 to K do
      S := S + SNonBreakableSpace;

    DocRange.pasteHTML(S);

    Elem := DocRange.parentElement;
    S := Elem.innerHTML;
    S := StringReplace(S, SNonBreakableSpace, '&nbsp;', [rfReplaceAll]);
    Elem.innerHTML := S;   
  end;

  SetPanCursorPos;
end;

procedure TEditorForm.acNewPageExecute(Sender: TObject);
var
  B: Boolean;
begin
  if CanSave then
    if Application.MessageBox(
      'Были внесены изменения. При создании нового документа'#13#10+
      'все изменения будут потеряны! Вы действительно'#13#10+
      'хотите создать новый документ?', 'Подтверждение',
      MB_OKCANCEL or MB_ICONQUESTION) = IDCANCEL then Exit;

  SaveToTempFile;

  HTMLInfo.FileName := '';

  with TStringList.Create do
  try
    Text := '<html><head><META http-equiv=Content-Type content="text/html; '+
    'charset=windows-1251">'+
    '<META content="HTML Editor" name=EDITORORG>'+
    '</head><body text=#000000 bgColor=#ffffff>' +
    SDefaultCaption + '</body></html>';

    SaveToFile(TempHTMLFileName);
  finally
    Free;
  end;
  B := True;

  WebBrowser1.Navigate(TempHTMLFileName, B);

  Caption := SDefaultCaption;
end;

procedure TEditorForm.acNOBRStringExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
  S: string;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    S := TextRange.htmlText;
    if acNOBRString.Checked then
    begin
      raise Exception.Create('Текст уже является неразрывным. Если вы хотите '+
        'сделать текст обычным, то удалите тэг "Не переносить"');
    end else
    begin
      if Trim(TextRange.text) = '' then
        S := 'Н е р а з р ы в н а я  С т о к а';
      TextRange.pasteHTML('<NOBR>' + S + '</NOBR>');
    end;
  end;

  SetPanCursorPos;
end;

procedure TEditorForm.acOListExecute(Sender: TObject);
begin
  DocRange.execCommand('InsertOrderedList', false, emptyparam);
  TAction(Sender).Checked := SelectedIsOrderedList(DocRange);

  SetPanCursorPos;
end;

procedure TEditorForm.acPastExecute(Sender: TObject);
begin
  //DocRange.execCommand('Paste', false, emptyparam);
  WebBrowser1.ExecWB(OLECMDID_PASTE, OLECMDEXECOPT_DONTPROMPTUSER);
  SetPanCursorPos;
end;

procedure TEditorForm.acPreviewExecute(Sender: TObject);
begin
  WebBrowser1.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER);
end;

procedure TEditorForm.acRedoExecute(Sender: TObject);
begin
  //HTMLInfo.Editor.execCommand('Redo', false, emptyparam);
  WebBrowser1.ExecWB(OLECMDID_REDO, OLECMDEXECOPT_DONTPROMPTUSER);

  SetPanCursorPos;
end;

procedure TEditorForm.acReplaceToNBSPExecute(Sender: TObject);
var
  S, S1: string;
  Elem: IHTMLElement;
  I: Integer;
  Fl: Boolean;
  C: Char;
begin
  Elem := DocRange.parentElement;
  S := DocRange.htmlText;
  //S := StringReplace(S, ' '#13#10, ' ', [rfReplaceAll]);
  //S := StringReplace(S, #13#10, ' ', [rfReplaceAll]);
  if S <> '' then
  begin
    Fl := True;
    S1 := '';
    for I := 1 to Length(S) do
    begin
      C := S[I];
      if C = '<' then
        Fl := False;

      if C = '>' then
        Fl := True;

      if (C = ' ') and Fl then
        S1 := S1 + SNonBreakableSpace
      else
        S1 := S1 + C;
    end;
    DocRange.pasteHTML(S1);

    
    S := Elem.innerHTML;
    S := StringReplace(S, SNonBreakableSpace, '&nbsp;', [rfReplaceAll]);
    Elem.innerHTML := S;
  end;

  SetPanCursorPos;
end;

procedure TEditorForm.acRightExecute(Sender: TObject);
begin
  if SelectedIsJustifyRight(DocRange) then
    DocRange.execCommand('JustifyNone', false, emptyparam)
  else
    DocRange.execCommand('JustifyRight', false, emptyparam);

  TAction(Sender).Checked := SelectedIsJustifyRight(DocRange);

  SetPanCursorPos;
end;

procedure TEditorForm.DoSaveToFile();
var
  S: string;    
begin
  S := GetHTMLPageCode;
  if S = '' then
    raise Exception.Create('GetHTMLPageCode: HTML-код отсутствует!');  

  with TStringList.Create do
  try
    Text := S;
    SaveToFile(HTMLInfo.FileName);
    SaveToTempFile;
    ShowSaveButton := False;
  finally
    Free;
  end;
  
  Caption := SDefaultCaption + ': ' + HTMLInfo.FileName;
end;

procedure TEditorForm.acSaveAsExecute(Sender: TObject);
begin
  //HTMLInfo.Editor.execCommand('SaveAs', True, Null);

  SaveDialog1.FileName := HTMLInfo.FileName;
  if SaveDialog1.Execute then
  begin
    HTMLInfo.FileName := SaveDialog1.FileName;
  end else
    Exit;

  DoSaveToFile;
end;

procedure TEditorForm.acSaveToFileExecute(Sender: TObject);

begin
  if HTMLInfo.FileName = '' then
  begin
    SaveDialog1.FileName := 'Новая страница';
    if SaveDialog1.Execute then
    begin
      HTMLInfo.FileName := SaveDialog1.FileName;
    end else
      Exit;
    //HTMLInfo.Editor.execCommand('SaveAs', True, Null);
  end;

  DoSaveToFile;
end;

procedure TEditorForm.acSelectAllExecute(Sender: TObject);
begin
  HTMLInfo.Editor.execCommand('SelectAll', false, emptyparam);
end;

procedure TEditorForm.acStrikeExecute(Sender: TObject);
begin
  DocRange.execCommand('StrikeThrough', false, emptyparam);
  TAction(Sender).Checked := SelectedIsStrike(DocRange);
end;

procedure TEditorForm.acSubScriptExecute(Sender: TObject);
begin
  // При необходимости сбрасываем параметры
  if SelectedIsSuperscript(DocRange) then
    DocRange.execCommand('Superscript', false, emptyparam);

  DocRange.execCommand('Subscript', false, emptyparam);

  SetPanCursorPos;
end;

procedure TEditorForm.acSuperScriptExecute(Sender: TObject);
begin
  // При необходимости сбрасываем параметры
  if SelectedIsSubscript(DocRange) then
    DocRange.execCommand('Subscript', false, emptyparam);

  DocRange.execCommand('Superscript', false, emptyparam);

  SetPanCursorPos;
end;

procedure TEditorForm.acTabDelColumnExecute(Sender: TObject);
begin
  Tabs.DoTabDelColumn;
  ShowTagsPath;
end;

procedure TEditorForm.acTabDelRowExecute(Sender: TObject);
begin
  Tabs.DoTabDelRow;
  ShowTagsPath;
end;

procedure TEditorForm.acUListExecute(Sender: TObject);
begin
  DocRange.execCommand('InsertUnorderedList', false, emptyparam);
  TAction(Sender).Checked := SelectedIsUnOrderedList(DocRange);

  SetPanCursorPos;
end;

procedure TEditorForm.acUnderLineExecute(Sender: TObject);
begin
  DocRange.execCommand('Underline', false, emptyparam);
  TAction(Sender).Checked := SelectedIsUnderline(DocRange);
end;

procedure TEditorForm.acUndoExecute(Sender: TObject);
begin
  //HTMLInfo.Editor.execCommand('Undo', false, emptyparam);
  //DocRange.execCommand('Undo', false, emptyparam);// - не работает!
  WebBrowser1.ExecWB(OLECMDID_UNDO, OLECMDEXECOPT_DONTPROMPTUSER);

  SetPanCursorPos;
end;

procedure TEditorForm.acZoom1Execute(Sender: TObject);
begin
  if HTMLInfo.CanUseZoom then
  begin
    (HTMLInfo.Editor.body.style as IHTMLStyle3).zoom := '';
  end;

  SetPanCursorPos;
end;

procedure TEditorForm.acZoomIncExecute(Sender: TObject);
var
  SZoom: string;
  D: Double;
begin
    if HTMLInfo.CanUseZoom then
    begin
      SZoom := (HTMLInfo.Editor.body.style as IHTMLStyle3).zoom;
      if SZoom = '' then SZoom := '1';
      SZoom := StringReplace(SZoom, '.', DecimalSeparator, []);
      D := StrToFloatDef(SZoom, 1);
      D := D + TAction(Sender).Tag / 10;
      SZoom := FloatToStr(D);
      SZoom := StringReplace(SZoom, DecimalSeparator, '.', []);

      (HTMLInfo.Editor.body.style as IHTMLStyle3).zoom := SZoom;
    end;

    SetPanCursorPos;
end;

function TEditorForm.CanCopy: Boolean;
begin
  Result := WebBrowser1.QueryStatusWB(OLECMDID_COPY) <> 1;
end;

function TEditorForm.CanCut: Boolean;
begin
  Result := WebBrowser1.QueryStatusWB(OLECMDID_CUT) <> 1;
end;

function TEditorForm.CanPaste: Boolean;
begin
  Result := WebBrowser1.QueryStatusWB(OLECMDID_PASTE) <> 1;
end;

function TEditorForm.CanRedo: Boolean;
begin
  Result := WebBrowser1.QueryStatusWB(OLECMDID_REDO) <> 1;
end;

function TEditorForm.CanSave: Boolean;
begin
  if ShowSaveButton then
  begin
    Result := True;
    Exit;
  end;

  Result := False;

  // Если окно только что открыли и не внесли изменений, то сохранять не нужно
  if (HTMLInfo.FileName = '') and (not CanUndo) then Exit;

  if FileExists(HTMLInfo.FileName) then 
  begin
    // Если нечего отменять, то выходим
    if not CanUndo then Exit;
  end else
  begin
    // Если файл удалили, то нужно сохранить!
    Result := True;
    Exit;
  end;

  // Проверяем текст на совпадение
  with TStringList.Create do
  try
    LoadFromFile(HTMLInfo.FileName);

    Result := Trim(Text) <> Trim(GetHTMLPageCode);
  finally
    Free;
  end;
end;

function TEditorForm.CanUndo: Boolean;
var
  I: OLECMDF;
begin
  I := WebBrowser1.QueryStatusWB(OLECMDID_UNDO);
  Result := not (I in [0, 1]);
end;

procedure TEditorForm.acAddColLeftExecute(Sender: TObject);
begin
  Tabs.DoTableAddCol(True);
  ShowTagsPath;
end;

procedure TEditorForm.acAddColRightExecute(Sender: TObject);
begin
  Tabs.DoTableAddCol(False);
  ShowTagsPath;
end;

procedure TEditorForm.acAddCustomHTMLExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
  S: string;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    if Trim(TextRange.text) <> '' then
      S := TextRange.htmlText;
    if ShowEditHTMLForm(S, True) then
      TextRange.pasteHTML(S);
  end;

  SetPanCursorPos;
end;

procedure TEditorForm.acAddInputPasswordExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('Введите пароль: <INPUT TYPE="password">');
  end;
end;

procedure TEditorForm.acAddInputRadioExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<INPUT TYPE="radio"> Переключатель');
  end;
end;

procedure TEditorForm.acAddInputResetExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<INPUT TYPE="reset" VALUE="Отмена">');
  end;
end;

procedure TEditorForm.acAddInputSubmitExecute(Sender: TObject);
var
  TextRange: IHTMLTxtRange;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    TextRange.pasteHTML('<INPUT TYPE="submit" VALUE="Принять">');
  end;
end;

procedure TEditorForm.OnButtonTagMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HTMLInfo.CurrentIndex := TButton(Sender).Tag;

  if HTMLInfo.ActiveElement <> nil then
    HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;

  HTMLInfo.ActiveElement := HTMLInfo.ElemDescArray[HTMLInfo.CurrentIndex].edElem;
  HTMLInfo.ActiveElementColor := HTMLInfo.ActiveElement.style.backgroundColor;

  HTMLInfo.ActiveElement.style.backgroundColor := SSelectionColor;


  if Button = mbRight then
    pmiTagPropClick(nil)
  else if Button = mbMiddle then
  begin
    if FileExists(ChangeFileExt(ParamStr(0), '.CanDeleteOnMiddleButton')) then
      pmiDeleteTagOnlyClick(nil);
  end;   
end;

procedure TEditorForm.cbFontBgColorGetColors(Sender: TCustomColorBox; Items: TStrings);
begin
  ListFillColorNames(Items);
end;

procedure TEditorForm.cbFontBgColorSelect(Sender: TObject);
var
  AColor: TColor;
  V: OleVariant;
  IsCancel: Boolean;
begin
  AColor := ColorBoxGetColor(cbFontBgColor, ColorDialog1, IsCancel);
  if not IsCancel then
  begin
    V := ConvertColorToHtml(AColor);
    try
      DocRange.execCommand('BackColor', false, V);
    except
    end;
  end;


end;

procedure TEditorForm.cbFontColorSelect(Sender: TObject);
var
  AColor: TColor;
  V: OleVariant;
  IsCancel: Boolean;
begin
  AColor := ColorBoxGetColor(cbFontColor, ColorDialog1, IsCancel);
  if not IsCancel then
  begin
    V := ConvertColorToHtml(AColor);
    try
      DocRange.execCommand('ForeColor', false, V);
    except
    end;
  end;
end;

procedure TEditorForm.CheckEditingPossible(ATag: string; var CanEditInnerText,
  CanEditOuterText: Boolean);
begin
  CanEditInnerText := True;
  CanEditOuterText := True;
  if ATag = 'HTML' then
  begin
    CanEditInnerText := False;
    CanEditOuterText := False;
  end else
  if ATag = 'BODY' then
  begin
    CanEditInnerText := True;
    CanEditOuterText := False;
  end else
  if ATag = 'TABLE' then
  begin
    CanEditInnerText := False;
    CanEditOuterText := True;
  end else
  if ATag = 'TR' then
  begin
    CanEditInnerText := False;
    CanEditOuterText := False;
  end else
  if ATag = 'TD' then
  begin
    CanEditInnerText := True;
    CanEditOuterText := False;
  end else
  if ATag = 'XMP' then
  begin
    CanEditInnerText := False;
    CanEditOuterText := True;
  end else
  if ATag = 'CAPTION' then
  begin
    CanEditInnerText := True;
    CanEditOuterText := False;
  end else
  if ATag = 'THEAD' then
  begin
    CanEditInnerText := False;
    CanEditOuterText := False;
  end else

 ;
end;

procedure TEditorForm.CollectStyles(AList: TStringList; Elem: IHTMLElement);
begin
  AList.Clear;


  {AList.Add('borderLeft=' + Elem.style.borderLeft);      // Левая рамка
  AList.Add('borderTop=' + Elem.style.borderTop);        // Верхняя рамка
  AList.Add('borderRight=' + Elem.style.borderRight);        // Правая рамка
  AList.Add('borderBottom=' + Elem.style.borderBottom);  // Нижняя рамка
  }

  AList.Add('width=' + Elem.style.width);  // Ширина
  AList.Add('height=' + Elem.style.height);  // Высота
  AList.Add('color=' + Elem.style.color);
  AList.Add('backgroundColor=' + Elem.style.backgroundColor);
  
  AList.Add('fontSize=' + Elem.style.fontSize);
  AList.Add('fontFamily=' + Elem.style.fontFamily);
  AList.Add('fontStyle=' + Elem.style.fontStyle);
  AList.Add('fontWeight=' + Elem.style.fontWeight);
  AList.Add('textAlign=' + Elem.style.textAlign);
  AList.Add('verticalAlign=' + Elem.style.verticalAlign);
  AList.Add('lineHeight=' + Elem.style.lineHeight);
  AList.Add('textIndent=' + Elem.style.textIndent);



  AList.Add('borderLeftStyle=' + Elem.style.borderLeftStyle); // Левая рамка: стиль
  AList.Add('borderLeftColor=' + Elem.style.borderLeftColor);      // Левая рамка: цвет
  AList.Add('borderLeftWidth=' + Elem.style.borderLeftWidth); // Левая рамка: толщина

  AList.Add('borderTopStyle=' + Elem.style.borderTopStyle); // Верхняя рамка: стиль
  AList.Add('borderTopColor=' + Elem.style.borderTopColor);        // Верхняя рамка: цвет
  AList.Add('borderTopWidth=' + Elem.style.borderTopWidth); //  Верхняя рамка: толщина

  AList.Add('borderRightStyle=' + Elem.style.borderRightStyle); // Правая рамка: стиль
  AList.Add('borderRightColor=' + Elem.style.borderRightColor);    // Правая рамка: цвет
  AList.Add('borderRightWidth=' + Elem.style.borderRightWidth); // Правая рамка: толщина

  AList.Add('borderBottomStyle=' + Elem.style.borderBottomStyle); // Нижняя рамка: стиль
  AList.Add('borderBottomColor=' + Elem.style.borderBottomColor);  // Нижняя рамка: цвет
  AList.Add('borderBottomWidth=' + Elem.style.borderBottomWidth); // Нижняя рамка: толщина

  AList.Add('paddingLeft=' + Elem.style.paddingLeft);
  AList.Add('paddingTop=' + Elem.style.paddingTop);
  AList.Add('paddingRight=' + Elem.style.paddingRight);
  AList.Add('paddingBottom=' + Elem.style.paddingBottom);


  AList.Add('marginLeft=' + Elem.style.marginLeft);
  AList.Add('marginTop=' + Elem.style.marginTop);
  AList.Add('marginRight=' + Elem.style.marginRight);
  AList.Add('marginBottom=' + Elem.style.marginBottom);


  AList.Add('writingMode=' + (Elem.style as IHTMLStyle3).writingMode);
  
  AList.Add('pageBreakBefore=' + Elem.style.pageBreakBefore);
  AList.Add('pageBreakAfter=' + Elem.style.pageBreakAfter);



  //AList.Add('visibility=' + Elem.style.visibility);  // Видимость - это лишнее!!!
{

  Add('line-height', 'Межстрочный интервал', atCSSSize);
}
end;

function TEditorForm.ColorBoxGetColor(ColBox: TColorBox;
  ColDlg: TColorDialog; var IsCancel: Boolean): TColor;
var
  Index, ChooseIndex: Integer;
  AColor: TColor;
  ne: TNotifyEvent;
begin
  IsCancel := False;
  ne := tmParamsReader.OnTimer;
  tmParamsReader.OnTimer := nil;
  try
    Result := 0;
    if ColBox.ItemIndex >= 0 then
    begin
      if ColBox.Items[ColBox.ItemIndex] = SSelectColor then
      begin
        ChooseIndex := ColBox.ItemIndex;

        // Устанавливаем последний цвет, заданный пользователем
        ColDlg.Color := TColor(ColBox.Items.Objects[ChooseIndex]);

        if ColDlg.Execute then
        begin
          AColor := ColDlg.Color;
          ColBox.Items.Objects[ChooseIndex] := TObject(AColor);

          // Пытаемся найти выбранный цвет в списке стандартных цветов
          Index := ColBox.Items.IndexOfObject(TObject(AColor));
          if (Index >= 0) and (Index <> ChooseIndex) then
            ColBox.ItemIndex := Index // Такой цвет уже есть
          else
          begin
            // Такого цвета еще нет. Добавляем его
            Index := ColBox.Items.IndexOf(SUserColor);
            if Index < 0 then
              ColBox.Items.Insert(0, SUserColor);

            Index := ColBox.Items.IndexOf(SUserColor);
            if Index >= 0 then
            begin
              ColBox.Items.Objects[Index] := TObject(AColor);
              ColBox.ItemIndex := Index;
            end;
          end;
        end else
          IsCancel := True;
      end;

      Result := TColor(ColBox.Items.Objects[ColBox.ItemIndex]);
    end;
  finally
    tmParamsReader.OnTimer := ne;
  end;


end;

procedure TEditorForm.cbFontDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with TComboBox(Control).Canvas do
  begin
    // Стираем старое изображение
    Pen.Color := clWhite;
    Brush.Color := clWhite;
    Rectangle(Rect);

    Pen.Color := clBlack;
    Brush.Style := bsClear;
    if odSelected in State then Pen.Style := psDot else Pen.Style := psClear;
    Rectangle(Rect);
    Font.Color := clBlack;
    Font.Name := TComboBox(Control).Items[Index];
    Font.Size := 10;
    TextOut(Rect.Left + 1, Rect.Top, TComboBox(Control).Items[Index]);
    Pen.Style := psSolid;
  end;
end;

procedure TEditorForm.cbFontSelect(Sender: TObject);
var
  V: OleVariant;
begin
  with TComboBox(Sender) do
  begin
    if ItemIndex >= 0 then
    begin
      V := Items[ItemIndex];
      try
        DocRange.execCommand('FontName', false, V);
        //DocRange.execCommand('FontName', false, 'MSSerif');
        SetPanCursorPos;
      except
      end;
    end;
  end;
end;

procedure TEditorForm.cbFontSizeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    TComboBox(Sender).OnSelect(Sender);
end;

procedure TEditorForm.cbFontSizeSelect(Sender: TObject);
var
  V: OleVariant;
  Index: Integer;
begin
  Index := TComboBox(Sender).ItemIndex + 1;
  if Index > 7 then
    V := 'error'
  else
    V := IntToStr(Index);
  try
    DocRange.execCommand('FontSize', false, V);
    SetPanCursorPos;
  except
  end;
end;

procedure TEditorForm.cbParFormatSelect(Sender: TObject);
var
  Elem: IHTMLElement;
  S, ATag, AText: string;
  Index: Integer;
begin
  if DocRange <> nil then
    Elem := DocRange.parentElement
  else if GetControlRange <> nil then
    Elem := GetControlRange.commonParentElement
  else
    Exit;

  while Elem <> nil do
  begin
    ATag := UpperCase(Elem.tagName);
    if (ATag = 'TD') or (ATag = 'TR') or (ATag = 'TH') or (ATag = 'TABLE') then
      Break; // Прекращаем удаление тэгов
    if (ATag = 'P') or (ATag = 'PRE') or ((Length(ATag) = 2) and
      (ATag[1] = 'H') and (ATag[2] in ['1'..'6'])) then
      Elem.outerHTML := Elem.innerHTML;
    Elem := Elem.parentElement;
  end;

  if DocRange <> nil then
    Elem := DocRange.parentElement
  else if GetControlRange <> nil then
    Elem := GetControlRange.commonParentElement
  else
    Exit;

  Index := cbParFormat.ItemIndex;
  case Index of
    0:
      begin

      end;
    1:
      begin
        ATag := 'P';
        AText := 'НовыйАбзац';
      end;

    2..7:
      begin
        ATag := 'H' + IntToStr(Index - 1);
        AText := 'НовыйЗаголовок' + IntToStr(Index - 1);
      end;

    8:
      begin
        ATag := 'PRE';
        AText := 'БезФорматирования';
      end;
  end;

  if Index > 0 then
  begin
    if DocRange <> nil then
      S := DocRange.Text
    else
      S := '';

    // Если текст не выделен...
    if (Trim(S) = '') or (ATag = 'P') then
    begin
      if (Trim(Elem.innerText) <> '') then
        S := Elem.innerHTML
      else
        S := AText;

      if DocRange <> nil then
        Elem.innerHTML := '<'+ATag+'>' + S + '</'+ATag+'>'
      else  // Не работает!!!!!!!
        Elem.parentElement.innerHTML := '<'+ATag+'>' + Elem.parentElement.innerHTML + '</'+ATag+'>'
    end else // Заменяем выделенный текст (с этим много проблем!!!)
    begin
      DocRange.pasteHTML('<'+ATag+'>' + DocRange.htmlText + '</'+ATag+'>');
    end;
  end;

  WebBrowser1.SetFocus;
  SetPanCursorPos;
end;

function TEditorForm.DocRange: IHTMLTxtRange;
var
  SelType: string;
begin
  Result := nil;
  SelType := HTMLInfo.editor.selection.type_; // None / Text / Control
  if SelType <> 'Control' then
    Result := (HTMLInfo.editor.selection.createRange as IHTMLTxtRange);
end;

procedure TEditorForm.FillFontList;
begin
  ListFillFontNames(cbFont.Items);
  cbFont.ItemIndex := 0;
end;

procedure TEditorForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if CanSave then
    CanClose := Application.MessageBox(
      'Были внесены изменения. При выходе из программы'#13#10+
      'изменения будут потеряны! Вы действительно'#13#10+
      'хотите выйти из программы?', 'Подтверждение выхода из программы',
      MB_OKCANCEL or MB_ICONQUESTION) = IDOK;
end;

procedure TEditorForm.FormCreate(Sender: TObject);
var
  S: string;
begin
  HTMLInfo := THTMLEditorInfo.Create;
  Tabs := TTableClass.Create;
  Tabs.HTMLInfo := HTMLInfo;

  EvtMethod := TEventMethod.Create;
  //TEventMethod(EvtMethod).HTMLInfo := HTMLInfo;
  //TEventMethod(EvtMethod).AForm := Self;

  //WebBrowser1.Navigate('about:<html><body></body></html>');

  TempHTMLFileName := GetTempHTMLFileName;

  if ParamCount > 0 then
    S := ParamStr(1);

  //ShowMessageFmt('%d', [ParamCount]);

  if (S <> '') and FileExists(S) then
  begin
    OpenDialog1.InitialDir := ExtractFileDir(S);
    SaveDialog1.InitialDir := ExtractFileDir(S);  
    LoadPageFromFile(S);
  end
  else
    acNewPageExecute(acNewPage);
  //LoadPageFromFile('C:\Dexe\FORMS\WEBREP\Финансовый отчет.html');


  HTMLColorDialog := ColorDialog1;
         
  HTMLInfo.panCursor := panCursor;

  //web
  HTMLInfo.EditorControl := WebBrowser1;

// WebBrowser1.Navigate('C:\Dexe\FORMS\WEBREP\ТТН1.html', B);
 //  WebBrowser1.Navigate('C:\Dexe\FORMS\TradePatterns\MoveTovar.html', B);
 // WebBrowser1.Navigate('C:\Dexe\FORMS\WEBREP\Информация по перезагрузкам.html', B);

 //WebBrowser1.Navigate('C:\Dexe\FORMS\TradePatterns\Torg-12.html', B);
end;

procedure TEditorForm.FormDestroy(Sender: TObject);
begin
  //TEventMethod(EvtMethod).Free;
  HTMLInfo.Free;
  Tabs.Free;
end;

procedure TEditorForm.FormShow(Sender: TObject);
begin    
  cbFontBgColor.Selected := clBlack;
  cbFontColor.Selected := clBlack;

  FillFontList;
end;

function TEditorForm.GetControlRange: IHTMLControlRange;
var
  SelType: string;
begin
  Result := nil;
  SelType := HTMLInfo.editor.selection.type_; // None / Text / Control
  if SelType = 'Control' then
    Result := (HTMLInfo.editor.selection.createRange as IHTMLControlRange);
end;

function TEditorForm.GetHTMLPageCode: string;
var
  SZoom: string;
  I: Integer;
begin
  Result := '';

  I := High(HTMLInfo.ElemDescArray);
  if I >= 0 then
  begin
    if HTMLInfo.CanUseZoom then
    begin
      SZoom := (HTMLInfo.Editor.body.style as IHTMLStyle3).zoom;
      (HTMLInfo.Editor.body.style as IHTMLStyle3).zoom := '';
    end;

    Result := HTMLInfo.ElemDescArray[I].edElem.outerHTML;

    if HTMLInfo.CanUseZoom then
    begin
      (HTMLInfo.Editor.body.style as IHTMLStyle3).zoom := SZoom;
    end;

    // IE по ошибке выставляет атрибуты align=middle и valign=center
    // а должно быть наоборот. Исправим это
    Result := StringReplace(Result, ' align=middle', ' align=center', []);
    Result := StringReplace(Result, ' valign=center', ' valign=middle', []);
  end;
end;

function TEditorForm.GetTempHTMLFileName: string;
var
  Ar: array[0..MAX_PATH] of Char;
begin
  Windows.GetTempPath(MAX_PATH, Ar);
  Result := Ar;

  Result := Result + 'Temp_File_Name_HTML_Editor.html';
end;

procedure TEditorForm.HideOriginalCursor(AHide: Boolean);
var
  ids: IDisplayServices;
  ic: IHTMLCaret;
begin
  if Assigned(HTMLInfo.Editor) then
  try
    ids := HTMLInfo.Editor as IDisplayServices;
    ids.GetCaret(ic);

    if AHide then
      ic.Hide
    else
      ic.Show(0);
  except
  end;
end;

procedure TEditorForm.HTML1Click(Sender: TObject);
var
  S: string;
begin
  // Возвращает нормальный цвет
  HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;

  S := HTMLInfo.ElemDescArray[HTMLInfo.CurrentIndex].edElem.outerHTML;

  // Устанавливаем цвет выделения
  HTMLInfo.ActiveElement.style.backgroundColor := SSelectionColor;

  ShowEditHTMLForm(S, False);
end;

procedure TEditorForm.LoadPageFromFile(AFileName: string);
var
  B: Boolean;
  AList: TStringList;
  S: string;
  TmpFile: string;
  APos: Integer;
begin
  if not FileExists(AFileName) then
    raise Exception.Create('Файл не найден: ' + AFileName);

  SaveToTempFile;

  TmpFile := AFileName;

  // Проверяем, есть ли тэг кодировки
  AList := TStringList.Create;
  try
    AList.LoadFromFile(AFileName);
    S := StringReplace(AList.Text, ' ', '', []);
    S := StringReplace(S, '"', '', []);
    S := StringReplace(S, '''', '', []);
    S := StringReplace(S, #13#10, '', []);

    S := LowerCase(S);

    if (Pos('<html>', S) = 0) or (Pos('<body', S) = 0) then
      raise Exception.Create('Выбранный файл не является правильной HTML-страницей!');

    if Pos('content=text/html;charset=', S) = 0 then
    begin
      if Application.MessageBox(
        'Кодировка HTML-страницы не указана! Хотите открыть данную страницу'#13#10+
        'в русской кодировке "windows-1251"?',
        'Внимание!', MB_OKCANCEL) = IDOK then
      begin
        S := AList.Text;

        // Проверяем наличие тэга HEAD
        APos := Pos('<head>', LowerCase(S));
        if APos = 0 then
        begin
          APos := Pos('<html>', LowerCase(S)) + 6;
          Insert('<head></head>', S, APos);
        end;

        APos := Pos('<head>', LowerCase(S)) + 6;
        Insert('<META http-equiv=Content-Type content="text/html; charset=windows-1251">' + #13#10+
               '<META content="HTML Editor" name=EDITORORG>',
               S, APos);

        AList.Text := S;

        TmpFile := TempHTMLFileName;
        AList.SaveToFile(TmpFile);
        ShowSaveButton := True;
      end;
    end else
    begin
      ShowSaveButton := False;
    end;
  finally
    AList.Free;
  end;

  B := True;
  WebBrowser1.Navigate(TmpFile, B);
  HTMLInfo.FileName := AFileName;

  Caption := SDefaultCaption + ': ' + AFileName;
end;

procedure TEditorForm.LocateToColor(ColBox: TColorBox; S: string);
var
  AColor: TColor;
  Index: Integer;
begin
  if S = SNoColor then Exit;

  if not ColBox.Focused then
  begin
    if S = 'error' then
    begin
      ColBox.Enabled := False;
    end else
    begin
      ColBox.Enabled := True;
      AColor := StrToIntDef(S, 0);
      Index := ColBox.Items.IndexOfObject(TObject(AColor));
      if Index >= 0 then
        ColBox.ItemIndex := Index
      else
      begin
        Index := ColBox.Items.IndexOf(SSelectColor);
        if Index >= 0 then
          ColBox.Items.Objects[Index] := TObject(AColor);
      end;
    end;
  end;
end;

procedure TEditorForm.mmiFontSizeClick(Sender: TObject);
var
  Param: OleVariant;
begin
  Param := TMenuItem(Sender).Tag;
  WebBrowser1.ExecWB(OLECMDID_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, Param);
end;

procedure TEditorForm.N5Click(Sender: TObject);
var
  S: string;
begin
  S := HTMLInfo.ElemDescArray[HTMLInfo.CurrentIndex].edElem.outerText;
  ShowEditHTMLForm(S, False);
end;

procedure TEditorForm.N76Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TEditorForm.N86Click(Sender: TObject);
begin
  //ShowRepVarsForm(HTMLInfo);
end;

procedure TEditorForm.pmiElementPropertyClick(Sender: TObject);
begin
  HTMLInfo.CurrentIndex := 0;
  
  if HTMLInfo.ActiveElement <> nil then
    HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;

  HTMLInfo.ActiveElement := HTMLInfo.ElemDescArray[HTMLInfo.CurrentIndex].edElem;
  HTMLInfo.ActiveElementColor := HTMLInfo.ActiveElement.style.backgroundColor;

  HTMLInfo.ActiveElement.style.backgroundColor := SSelectionColor;


  //if Button = mbRight then
  
    pmiTagPropClick(nil);

  //HTMLInfo.CurrentIndex := High(HTMLInfo.ElemDescArray);

  //if HTMLInfo.ActiveElement = nil then
 //   raise Exception.Create('');
  //pmiTagPropClick(pmiTagProp);
end;

procedure TEditorForm.OnButtonTagClick(Sender: TObject);
var
  ATag: Integer;
  Cur: TPoint;

  ne: TNotifyEvent;

  CanEditInnerText: Boolean;
  CanEditOuterText: Boolean;
  TagName: string;
begin
  ne := tmParamsReader.OnTimer;
  tmParamsReader.OnTimer := nil;
  try
    ATag := TButton(Sender).Tag;
    TagName := HTMLInfo.ElemDescArray[ATag].edTagName;

    if HTMLInfo.ActiveElement <> nil then
      HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;

    HTMLInfo.ActiveElement := HTMLInfo.ElemDescArray[ATag].edElem;
    HTMLInfo.ActiveElementColor := HTMLInfo.ActiveElement.style.backgroundColor;

    HTMLInfo.ActiveElement.style.backgroundColor := SSelectionColor;
    try
      //ElemDescArray[ATag].edElem.s
      //DocRange.select;
      //DocRange.moveToElementText(ElemDescArray[ATag].edElem);
      //DocRange.select;

      CheckEditingPossible(TagName, CanEditInnerText, CanEditOuterText);

      pmiDeleteInner.Enabled := CanEditInnerText;
      pmiDeleteOuter.Enabled := CanEditOuterText;
      pmiDeleteTagOnly.Enabled := CanEditOuterText;

      pmiChangeInner.Enabled := CanEditInnerText;
      pmiChangeOuter.Enabled := CanEditOuterText;

      HTMLInfo.CurrentIndex := ATag;

      pmiTagProp.Caption := Format('Свойства элемента "%s"...', [HTMLInfo.ElemDescArray[ATag].edNiceTagName]);

      pmiTableActions.Visible := (TagName = 'TABLE') or (TagName = 'TR') or
        (TagName = 'TD') or (TagName = 'TH');

      GetCursorPos(Cur);
      pmTags.Popup(Cur.X, Cur.Y);

      //ShowMessage('Popup');
    finally
      //ElemDescArray[ATag].edElem.style.backgroundColor := OldColor;
    end;


  finally
    tmParamsReader.OnTimer := ne;
  end;
end;

procedure TEditorForm.panCursorClick(Sender: TObject);
var
  cur: TPoint;
begin
  cur := Mouse.CursorPos;

  if panCursor.Width = 1 then
    SetCursorPos(cur.X + 2, cur.Y)
  else if panCursor.Height = 1 then
    SetCursorPos(cur.X, cur.Y + 2);

end;

procedure TEditorForm.pmiChangeInnerClick(Sender: TObject);
var
  Index: Integer;
  Elem: IHTMLElement;
  S: string;
begin
  Index := HTMLInfo.CurrentIndex;
  Elem := HTMLInfo.ElemDescArray[Index].edElem;
  S := Elem.innerHTML;
  try
    if ShowEditHTMLForm(S, True) then
      Elem.innerHTML := S;
  except
    on E: Exception do
      raise Exception.Create('Нелья изменить внутреннее содержимое элемента: ' + E.Message);
  end;
end;

procedure TEditorForm.pmiChangeOuterClick(Sender: TObject);
var
  Index: Integer;
  Elem: IHTMLElement;
  S: string;
begin
  Index := HTMLInfo.CurrentIndex;
  Elem := HTMLInfo.ElemDescArray[Index].edElem;
  // Возвращает нормальный цвет
  HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;
  S := Elem.outerHTML;
  HTMLInfo.ActiveElement.style.backgroundColor := SSelectionColor;
  try
    if ShowEditHTMLForm(S, True) then
      Elem.outerHTML := S;
  except
    on E: Exception do
      raise Exception.Create('Нелья изменить внутреннее содержимое элемента: ' + E.Message);
  end;
end;

procedure TEditorForm.pmiDeleteInnerClick(Sender: TObject);
var
  Index: Integer;
  Elem: IHTMLElement;
begin
  Index := HTMLInfo.CurrentIndex;
  Elem := HTMLInfo.ElemDescArray[Index].edElem;
  try
    Elem.innerHTML := '';
  except
    on E: Exception do
      raise Exception.Create('Нелья удалить содержимое данного тэга: ' + E.Message);
  end;
end;

procedure TEditorForm.pmiDeleteOuterClick(Sender: TObject);
var
  Elem: IHTMLElement;
  S: string;
begin
  Elem := HTMLInfo.ElemDescArray[HTMLInfo.CurrentIndex].edElem;
  S := Elem.innerHTML;
  try
    Elem.outerHTML := '';
  except
    on E: Exception do
      raise Exception.Create('Нелья удалить этот тэг и его содержимое:'  + E.Message);
  end;
end;

procedure TEditorForm.pmiDeleteTagOnlyClick(Sender: TObject);
var
  Elem: IHTMLElement;
  S: string;
begin
  Elem := HTMLInfo.ElemDescArray[HTMLInfo.CurrentIndex].edElem;
  S := Elem.innerHTML;
  try
    Elem.outerHTML := S;
  except
    on E: Exception do
      raise Exception.Create('Нелья удалить этот тэг без удаления содержимого: ' + E.Message);
  end;
end;

procedure TEditorForm.pmiTagPropClick(Sender: TObject);
var
  Index, AttrIdx, I: Integer;
  Elem: IHTMLElement;
  S, S1: string;
  atrValue: THTMLAttribType;
  attr: THTMLTagAttribs;
  AList, StyleList: TStringList;
  V: Variant;
  tabcapt: IHTMLTableCaption;
begin
  Index := HTMLInfo.CurrentIndex;
  Elem := HTMLInfo.ElemDescArray[Index].edElem;

  HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;
  AttrIdx := TagTranslatesList.IndexOfName(HTMLInfo.ElemDescArray[Index].edTagName);
  if AttrIdx >= 0 then
  begin
    AList := TStringList.Create;
    StyleList := TStringList.Create;
    try
      attr := THTMLTagAttribs(TagTranslatesList.Objects[AttrIdx]);
      if Assigned(attr) then
      begin
        if Index = High(HTMLInfo.ElemDescArray) then
        begin
          AList.AddObject('DOCTITLE' + '=' + HTMLInfo.editor.title, TObject(atText));
          AList.AddObject('DOCCHARSET' + '=' + HTMLInfo.editor.charset, TObject(atCharSet));
        end else
        begin
          for I := 0 to attr.AttrList.Count - 1 do
          begin
            S := attr.AttrList.Names[I];
            atrValue := THTMLAttribType(StrToInt(attr.AttrList.ValueFromIndex[I]));

            // Сначала обрабатываем атрибуты, изменяющиеся через стили
            if S = 'BORDERCOLLAPSE' then
            begin
              if LowerCase((Elem.style as IHTMLStyle2).borderCollapse) = 'collapse' then
                V := '1'
              else
                V := '';

            end else if S = 'TABLECAPTION' then
            begin
              tabcapt := (Elem as IHTMLTable).caption;
              if tabcapt <> nil then
                V := (tabcapt as IHTMLElement).innerHTML
              else
                V := '';
            end else
              V := Elem.getAttribute(S, 2);

            if VarIsNull(V) then
            begin
              ShowMessageFmt('Тэг "%s" не поддерживает атрибут "%s"', [Elem.tagName, S]);
            end else
            begin
              S1 := V;
              AList.AddObject(S + '=' + S1, TObject(atrValue));
            end;
          end;

          CollectStyles(StyleList, Elem);
        end;


      end;

      HTMLInfo.ActiveElement.style.backgroundColor := SSelectionColor;
      if ShowPropertyForm(AList, StyleList, HTMLInfo.ElemDescArray[Index].edNiceTagName) then
      begin
        for I := 0 to AList.Count - 1 do
        begin
          S := AList.Names[I];
          S1 :=  AList.ValueFromIndex[I];
          try
            if Index = High(HTMLInfo.ElemDescArray) then
            begin
              if (S = 'DOCTITLE') then
                HTMLInfo.Editor.title := S1;

              if (S = 'DOCCHARSET') then
                HTMLInfo.Editor.charset := S1;
            end else
            begin
              // Сначала обрабатываем атрибуты, изменяющиеся через стили
              if S = 'BORDERCOLLAPSE' then
              begin
                if S1 = '1' then
                  S1 := 'collapse'
                else
                  S1 := '';

                (Elem.style as IHTMLStyle2).borderCollapse := S1;
              end else if S = 'TABLECAPTION' then
              begin
                tabcapt := (Elem as IHTMLTable).caption;
                if (tabcapt = nil) and (Trim(S1) <> '') then
                  tabcapt := (Elem as IHTMLTable).createCaption;

                if Assigned(tabcapt) then
                begin
                  if Trim(S1) = '' then
                    (Elem as IHTMLTable).deleteCaption
                  else
                    (tabcapt as IHTMLElement).innerHTML := S1;
                end;
              end else
              begin
                if Trim(S1) = '' then
                  Elem.removeAttribute(S, 0)
                else
                  Elem.setAttribute(S, S1, 0);
              end;
            end;


          except
            on E: Exception do
            begin
              ShowMessageFmt('Ошибка установки атрибуту "%s" значения "%s": %s',
                [S, S1, E.Message]);
            end;
          end;
        end;

        UpdateStyles(StyleList, Elem);
      end;

      tmParamsReaderTimer(tmParamsReader);
      
    finally
      AList.Free;
      StyleList.Free;
    end;

  end;
end;

procedure TEditorForm.SaveToTempFile;
var
  oPF: IPersistFile;
begin
  DeleteFile(TempHTMLFileName);
  
  try
    if Assigned(HTMLInfo.Editor) then
    begin
      oPF := (WebBrowser1.Document as IPersistFile);
      oPF.Save(PWideChar(TempHTMLFileName), True);
      DeleteFile(TempHTMLFileName);
    end;
  except
  end;
end;


function TEditorForm.SelectedFontBgColor(TextRange: IHTMLTxtRange): string;
var
  V: Variant;
begin
  Result := SErrorColor;
  if Assigned(TextRange) then
  try
    V := DocRange.queryCommandValue('BackColor');;
    if VarIsNull(V) then
      Result := SNoColor
    else
      Result := V;
  except
  end;
end;

function TEditorForm.SelectedFontColor(TextRange: IHTMLTxtRange): string;
var
  V: Variant;
begin
  Result := SErrorColor;
  if Assigned(TextRange) then
  try
    V := DocRange.queryCommandValue('ForeColor');
    if VarIsNull(V) then
      Result := SNoColor
    else
      Result := V;
  except
  end;
end;

function TEditorForm.SelectedFontName(TextRange: IHTMLTxtRange): string;
var
  V: Variant;
begin
  try
    V := DocRange.queryCommandValue('FontName');
    if VarIsNull(V) then
      Result := SNoFont
    else
      Result := V;
  except
    result := 'error';
  end;
end;

function TEditorForm.SelectedFontSize(TextRange: IHTMLTxtRange): string;
var
  V: Variant;
begin
  Result := 'error';
  if Assigned(TextRange) then
  try
    V := DocRange.queryCommandValue('FontSize');
    if VarIsNull(V) then
      Result := SNoFontSize
    else
      Result := V;
  except
  end;
end;

function TEditorForm.SelectedIsBold(TextRange: IHTMLTxtRange): Boolean;
var
  V: Variant;
begin
  Result := False;

  if Assigned(TextRange) then
  try
    V := TextRange.queryCommandValue('bold');
    Result := V = True;
  except
  end;
end;

function TEditorForm.SelectedIsItalic(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;

  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('Italic') = True;
  except     
  end;
end;

function TEditorForm.SelectedIsJustifyCenter(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;
  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('JustifyCenter') = True;
  except
  end;
end;

function TEditorForm.SelectedIsJustifyFull(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;
  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('JustifyFull') = True;
  except
  end;
end;

function TEditorForm.SelectedIsJustifyLeft(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;
  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('JustifyLeft') = True;
  except
  end;
end;

function TEditorForm.SelectedIsJustifyRight(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;
  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('JustifyRight') = True;
  except
  end;
end;

function TEditorForm.SelectedIsOrderedList(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;
  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('InsertOrderedList') = True;
  except
  end;
end;

function TEditorForm.SelectedIsStrike(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;

  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('StrikeThrough') = True;
  except
  end;
end;

function TEditorForm.SelectedIsSubscript(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;
  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('Subscript') = True;
  except
  end;
end;

function TEditorForm.SelectedIsSuperscript(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;
  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('Superscript') = True;
  except
  end;
end;

function TEditorForm.SelectedIsUnderline(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;

  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('Underline') = True;
  except       
  end;
end;

function TEditorForm.SelectedIsUnOrderedList(TextRange: IHTMLTxtRange): Boolean;
begin
  Result := False;
  if Assigned(TextRange) then
  try
    Result := DocRange.queryCommandValue('InsertUnorderedList') = True;
  except
  end;
end;

procedure TEditorForm.SetPanCursorPos;
var
  TxtRange: IHTMLTxtRange;
  X, Y: Integer;
  H, W: Integer;
  AColor: TColor;
  S: string;
  R, G, B: Byte;
begin 

  tmMoveCaret.Enabled := False;
  tmMoveCaret.Enabled := True;

  TxtRange := GetDocRange(HTMLInfo);

  if Assigned(TxtRange) and FDesignMode then
  begin

    W := (TxtRange as IHTMLTextRangeMetrics).boundingWidth + 1;
    H := (TxtRange as IHTMLTextRangeMetrics).boundingHeight + 1;

    if (W = 1) or (H = 1) then
    begin
      X := (TxtRange as IHTMLTextRangeMetrics).offsetLeft + 1;
      Y := (TxtRange as IHTMLTextRangeMetrics).offsetTop + 1;

      HideOriginalCursor(True);
      OldVisible := not OldVisible;

      if not OldVisible then // Чтобы пользователь не видел ненужный процесс перемещения
        HTMLInfo.panCursor.Visible := False;

      if OldVisible then
      begin
        // Обрабатываем цвета
        S := SelectedFontBgColor(TxtRange);
        AColor := StrToIntDef(S, clNone);
        if AColor <> clNone then
        begin
          R := 255 - GetRValue(AColor);
          G := 255 - GetGValue(AColor);
          B := 255 - GetBValue(AColor);
          AColor := RGB(R, G, B);
          HTMLInfo.panCursor.Color := AColor;
        end;

        HTMLInfo.panCursor.SetBounds(X, Y, W, H);
        HTMLInfo.panCursor.Visible := OldVisible;
      end;
    end else
    begin
      HTMLInfo.panCursor.Visible := False;
    end;
  end else
  begin
    HTMLInfo.panCursor.Visible := False;
  end;
end;

procedure TEditorForm.SetParFormat(TextRange: IHTMLTxtRange);
var
  Elem: IHTMLElement;
  Index: Integer;
  ATag: string;
  IsNoBr: Boolean;
begin
  if cbParFormat.Focused then Exit;

  try
    Index := 0;
    IsNoBr := False;

    Elem := TextRange.parentElement;

    while Elem <> nil do
    begin
      ATag := UpperCase(Elem.tagName);

      if ATag = 'NOBR' then
      begin
        IsNoBr := True;
      end else
      if ATag = 'P' then
        Index := 1
      else if ((Length(ATag) = 2) and
        (ATag[1] = 'H') and (ATag[2] in ['1'..'6'])) then 
        Index := StrToInt(ATag[2]) + 1
      else if ATag = 'PRE' then
        Index := 8
      else if ATag = 'BODY' then
        Break;


      Elem := Elem.parentElement;
    end;


    acNOBRString.Checked := IsNoBr;
    cbParFormat.ItemIndex := Index;

  except
  end;
end;

procedure TEditorForm.ShowTagsPath;
var
  TextRange: IHTMLTxtRange;
  CtrlRange: IHTMLControlRange;
  Elem: IHTMLElement;
  I: Integer;
  Btn: TSpeedButton;
  ALabel: TLabel;
  LeftPos: Integer;
  ATagName, NiceTagName: string;
  TmpElemDescArray: TElemDescArray;
  IsEqual: Boolean;
begin
  HTMLInfo.CurrentCell := nil;
  TmpElemDescArray := nil;

  try
    TextRange := DocRange;
    if Assigned(TextRange) then
      Elem := TextRange.parentElement
    else
    begin
      CtrlRange := GetControlRange;
      //CtrlRange.item(0)
      if Assigned(CtrlRange) then
        Elem := CtrlRange.commonParentElement
        //Elem := CtrlRange.item(0)
      else
        Exit;
    end;
  except
    Exit;
  end;
  
  while Elem <> nil do
  begin
    ATagName := UpperCase(Elem.tagName);
    NiceTagName := TagTranslatesList.Values[ATagName];

    if NiceTagName <> '' then
    begin
      SetLength(TmpElemDescArray, Length(TmpElemDescArray) + 1);
      TmpElemDescArray[Length(TmpElemDescArray) - 1].edElem := Elem;
      TmpElemDescArray[Length(TmpElemDescArray) - 1].edNiceTagName := NiceTagName;
      TmpElemDescArray[Length(TmpElemDescArray) - 1].edTagName := ATagName;

      if HTMLInfo.CurrentCell = nil then
        if (ATagName = 'TD') or (ATagName = 'TH') then
        begin
          HTMLInfo.CurrentCell := Elem;
          TableActionsSetChecked(Elem);
        end;
    end;

    Elem := Elem.parentElement;
  end;

  LeftPos := 2;

  // Проверяем, совпадают ли массивы
  IsEqual := Length(HTMLInfo.ElemDescArray) = Length(TmpElemDescArray);

  if IsEqual then
  begin
    for I := Length(HTMLInfo.ElemDescArray) - 1 downto 0 do
      if (HTMLInfo.ElemDescArray[I].edTagName <> TmpElemDescArray[I].edTagName) then
      begin
        IsEqual := False;
        Break;
      end;
  end;

  HTMLInfo.ElemDescArray := TmpElemDescArray;

  // При необходимости обновляем текст на кнопках
  if not IsEqual then
  begin
    TableActionsSetEnabled(False, nil);
    //TableIsProcess := False;

    for I := panTags.ComponentCount - 1 downto 0 do
      panTags.Components[I].Free;

    for I := Length(HTMLInfo.ElemDescArray) - 1 downto 0 do
    begin


       ALabel := nil;

       Btn := TSpeedButton.Create(panTags);
       Btn.Top := 2;
       Btn.Parent := panTags;
       Btn.Caption := HTMLInfo.ElemDescArray[I].edNiceTagName;

      if I = 0 then
      begin
        pmiElementProperty.Caption := Format('Свойства элемента "%s"',
          [HTMLInfo.ElemDescArray[I].edNiceTagName]);
      end;

       //if not TableIsProcess then
       //begin
         if (HTMLInfo.ElemDescArray[I].edTagName = 'TD') or
           (HTMLInfo.ElemDescArray[I].edTagName = 'TH') then
         begin
           HTMLInfo.CurrentIndex := I;
           TableActionsSetEnabled(True, HTMLInfo.ElemDescArray[I].edElem);
         end;
       //end;

       //panTags.
       if I = 0 then
       begin
         Btn.Font.Style := [fsBold, fsUnderline];
       end else
       begin
         ALabel := TLabel.Create(panTags);
         ALabel.Top := 4;
         ALabel.Parent := panTags;
         ALabel.Caption := '>';
       end;

       Btn.Tag := I; // В тэге хранится номер элемента в списке
       Btn.OnClick := OnButtonTagClick;
       Btn.OnMouseDown := OnButtonTagMouseDown;

       THashPanel(panTags).Canvas.Font.Style := Btn.Font.Style;

       Btn.Width := THashPanel(panTags).Canvas.TextWidth(Btn.Caption + 'W');
       //Btn.Width := Max(Length(Btn.Caption) * 10, 30);

       Btn.Left := LeftPos;
       Inc(LeftPos, Btn.Width + 2);

       if ALabel <> nil then
       begin
         ALabel.Left := LeftPos;
         Inc(LeftPos, ALabel.Width);
       end;
    end;
    sbTags.HorzScrollBar.Position := sbTags.HorzScrollBar.Range;
  end;
end;


procedure TEditorForm.TableActionsSetChecked(ACell: IHTMLElement);
begin
  if Assigned(ACell) then
  begin
    acCellBorderL.Checked := ACell.style.borderLeftStyle <> 'none';
    acCellBorderT.Checked := ACell.style.borderTopStyle <> 'none';
    acCellBorderR.Checked := ACell.style.borderRightStyle <> 'none';
    acCellBorderB.Checked := ACell.style.borderBottomStyle <> 'none';

    acCellBorderAll.Checked := acCellBorderL.Checked and acCellBorderT.Checked and
      acCellBorderR.Checked and acCellBorderB.Checked;
  end;
end;

procedure TEditorForm.TableActionsSetEnabled(Value: Boolean; ACell: IHTMLElement);
begin
  acAddColLeft.Enabled := Value;
  acAddColRight.Enabled := Value;
  acAddRowBelow.Enabled := Value;
  acAddRowTop.Enabled := Value;
  acTabDelColumn.Enabled := Value;
  acTabDelRow.Enabled := Value;
  acMergeCellRight.Enabled := Value;
  acMergeCellBottom.Enabled := Value;
  acCellDeSpan.Enabled := Value;

  acCellBorderL.Enabled := Value;
  acCellBorderT.Enabled := Value;
  acCellBorderR.Enabled := Value;
  acCellBorderB.Enabled := Value;
  acCellBorderAll.Enabled := Value;
  acCellBorderReset.Enabled := Value;
end;

procedure TEditorForm.tmMoveCaretTimer(Sender: TObject);
begin
  SetPanCursorPos;
end;

procedure TEditorForm.tmParamsReaderTimer(Sender: TObject);
var
  Index: Integer;
  S: string;
  TextRange: IHTMLTxtRange;
begin
  // Первое срабатывание происходит сразу же после OnComplete.
  // Следующие срабатывания нужны не чаще раза в секунду. Они нужны лишь для
  // подстраховки на случай, если перестанут срабатывать обратные вызовы от COM
  if tmParamsReader.Interval = 1 then
    tmParamsReader.Interval := 1000;

  if Application.ModalLevel = 0 then
  begin
    if HTMLInfo.ActiveElement <> nil then
    try
      HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;
      HTMLInfo.ActiveElement := nil;
    except
    end;

    TextRange := DocRange;

    cbParFormat.Enabled := Assigned(TextRange);
    acBold.Enabled := Assigned(TextRange);
    acItalic.Enabled := Assigned(TextRange);
    acStrike.Enabled := Assigned(TextRange);
    acUnderLine.Enabled := Assigned(TextRange);
    acRight.Enabled := Assigned(TextRange);
    acLeft.Enabled := Assigned(TextRange);
    acCenter.Enabled := Assigned(TextRange);
    acJustifyFull.Enabled := Assigned(TextRange);
    acUList.Enabled := Assigned(TextRange);
    acOList.Enabled := Assigned(TextRange);
    acIdentLeft.Enabled := Assigned(TextRange);
    acIdentRight.Enabled := Assigned(TextRange);
    acSubScript.Enabled := Assigned(TextRange);
    acSuperScript.Enabled := Assigned(TextRange);
    acHorLine.Enabled := Assigned(TextRange);
    acHLink.Enabled := Assigned(TextRange);
    acImage.Enabled := Assigned(TextRange);
    acBR.Enabled := Assigned(TextRange);
    acDelFormat.Enabled := Assigned(TextRange);
    acAddRunString.Enabled := Assigned(TextRange);
    acNBSP.Enabled := Assigned(TextRange);
    acNOBRString.Enabled := Assigned(TextRange);
    acAddCustomHTML.Enabled := Assigned(TextRange);

    acAddInputText.Enabled := Assigned(TextRange);
    acAddInputButton.Enabled := Assigned(TextRange);
    acAddInputFile.Enabled := Assigned(TextRange);
    acAddInputImage.Enabled := Assigned(TextRange);
    acAddInputPassword.Enabled := Assigned(TextRange);
    acAddInputReset.Enabled := Assigned(TextRange);
    acAddInputSubmit.Enabled := Assigned(TextRange);
    acAddInputCheckbox.Enabled := Assigned(TextRange);
    acAddInputRadio.Enabled := Assigned(TextRange);
    acAddTEXTAREA.Enabled := Assigned(TextRange);
    acAddSelect.Enabled := Assigned(TextRange);

    acAddForm.Enabled := Assigned(TextRange);
    acAddFormInFrame.Enabled := Assigned(TextRange);

    acAddTable.Enabled := Assigned(TextRange);
   

    cbFont.Enabled := Assigned(TextRange);
    cbFontColor.Enabled := Assigned(TextRange);
    cbFontBgColor.Enabled := Assigned(TextRange);
    cbFontSize.Enabled := Assigned(TextRange);

    acUndo.Enabled := CanUndo;

    if HTMLInfo.FileName = '' then
      acSaveToFile.Enabled := True
    else
      acSaveToFile.Enabled := (acUndo.Enabled or ShowSaveButton);
      
    //if not acUndo.Enabled
    acRedo.Enabled := CanRedo;
    acCopy.Enabled := CanCopy;
    acCut.Enabled := CanCut;
    acPast.Enabled := CanPaste;


    if Assigned(TextRange) then
    begin

      SetParFormat(TextRange);

      acBold.Checked := SelectedIsBold(TextRange);
      acItalic.Checked := SelectedIsItalic(TextRange);
      acStrike.Checked := SelectedIsStrike(TextRange);
      acUnderLine.Checked := SelectedIsUnderline(TextRange);

      acRight.Checked := SelectedIsJustifyRight(TextRange);
      acLeft.Checked := SelectedIsJustifyLeft(TextRange);
      acCenter.Checked := SelectedIsJustifyCenter(TextRange);
      acJustifyFull.Checked := SelectedIsJustifyFull(TextRange);

      acUList.Checked := SelectedIsUnOrderedList(TextRange);
      acOList.Checked := SelectedIsOrderedList(TextRange);

      acSubScript.Checked := SelectedIsSubscript(TextRange);
      acSuperScript.Checked := SelectedIsSuperscript(TextRange);


      //Label5.Caption := SelectedFontName;

      if not cbFont.Focused then
      begin
        S := SelectedFontName(TextRange);
        Index := cbFont.Items.IndexOf(S);
        if Index >= 0 then
        begin
          cbFont.Enabled := True;
          cbFont.ItemIndex := Index;
        end else
        begin
          cbFont.Enabled := False;
        end;
      end;

      LocateToColor(cbFontColor, SelectedFontColor(TextRange));
      LocateToColor(cbFontBgColor, SelectedFontBgColor(TextRange));

      if not cbFontSize.Focused then
      begin
        S := SelectedFontSize(TextRange);
        Index := StrToIntDef(S, 0);
        //Index := cbFontSize.Items.IndexOf(S);
        if Index > 0 then
        begin
          cbFontSize.Enabled := True;
          cbFontSize.ItemIndex := Index - 1;
        end else
        begin
          cbFontSize.Enabled := False;
        end;
      end;
    end;

    ShowTagsPath;
  end;
end;     

procedure TEditorForm.ToolButton55Click(Sender: TObject);
begin
  (HTMLInfo.Editor.body as IHTMLElement2).focus;

end;

procedure TEditorForm.UpdateStyles(AList: TStringList; Elem: IHTMLElement);
begin
  Elem.style.borderLeftColor := AList.Values['borderLeftColor'];
  Elem.style.borderLeftWidth := AList.Values['borderLeftWidth'];
  Elem.style.borderLeftStyle := AList.Values['borderLeftStyle'];

  Elem.style.borderTopColor := AList.Values['borderTopColor'];
  Elem.style.borderTopWidth := AList.Values['borderTopWidth'];
  Elem.style.borderTopStyle := AList.Values['borderTopStyle'];

  Elem.style.borderRightColor := AList.Values['borderRightColor'];
  Elem.style.borderRightWidth := AList.Values['borderRightWidth'];
  Elem.style.borderRightStyle := AList.Values['borderRightStyle'];

  Elem.style.borderBottomColor := AList.Values['borderBottomColor'];
  Elem.style.borderBottomWidth := AList.Values['borderBottomWidth'];
  Elem.style.borderBottomStyle := AList.Values['borderBottomStyle'];

  Elem.style.width := AList.Values['width'];
  Elem.style.height := AList.Values['height'];

  Elem.style.paddingLeft := AList.Values['paddingLeft'];
  Elem.style.paddingTop := AList.Values['paddingTop'];
  Elem.style.paddingRight := AList.Values['paddingRight'];
  Elem.style.paddingBottom := AList.Values['paddingBottom'];

  Elem.style.marginLeft := AList.Values['marginLeft'];
  Elem.style.marginTop := AList.Values['marginTop'];
  Elem.style.marginRight := AList.Values['marginRight'];
  Elem.style.marginBottom := AList.Values['marginBottom'];

  Elem.style.lineHeight := AList.Values['lineHeight'];
  Elem.style.textIndent := AList.Values['textIndent'];
  Elem.style.textAlign := AList.Values['textAlign'];
  Elem.style.verticalAlign := AList.Values['verticalAlign'];
  Elem.style.backgroundColor := AList.Values['backgroundColor'];
  HTMLInfo.ActiveElementColor := Elem.style.backgroundColor;

  Elem.style.color := AList.Values['color'];
  Elem.style.fontStyle := AList.Values['fontStyle'];
  Elem.style.fontWeight := AList.Values['fontWeight'];
  Elem.style.fontSize := AList.Values['fontSize'];

  Elem.style.pageBreakAfter := AList.Values['pageBreakAfter'];
  Elem.style.pageBreakBefore := AList.Values['pageBreakBefore'];

  if Trim(AList.Values['fontFamily']) = '' then
  begin
    if Elem.style.fontFamily <> '' then
      Elem.style.fontFamily := '' 
  end else
    Elem.style.fontFamily := AList.Values['fontFamily'];

  (Elem.style as IHTMLStyle3).writingMode := AList.Values['writingMode'];
end;

procedure TEditorForm.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  HTMLInfo.Disp := pDisp;

  acHTMLEdit.Checked := False;

  acHTMLEditExecute(acHTMLEdit);

  //((pDisp as IWebBrowser).Document as IHTMLDocument2).designMode := 'On';

 // btnEditMode.Down := True;
 // btnEditMode.Click;



  //htmlinfo.Editor.ondblclick := EvtMethod;
  htmlinfo.Editor.onmousedown := EvtMethod;
  htmlinfo.Editor.onmouseup := EvtMethod;
  htmlinfo.Editor.onkeydown := EvtMethod;
  htmlinfo.Editor.onkeyup := EvtMethod;
  htmlinfo.Editor.onkeypress := EvtMethod;


  tmParamsReader.Enabled := True;
  tmMoveCaret.Enabled := True;
  OldVisible := False;
  //tmParamsReaderTimer(tmParamsReader);
end;


procedure TEditorForm.WMMouseActivate(var Msg: TMessage);
var
  ARect: TRect;
  Cur: TPoint;
begin
  try
    inherited;

    if Msg.LParamHi = 516 then
    begin
      ARect := WebBrowser1.BoundsRect;
      ARect.TopLeft := WebBrowser1.ClientToScreen(ARect.TopLeft);
      ARect.BottomRight := WebBrowser1.ClientToScreen(ARect.BottomRight);
      ARect.Right := ARect.Right - 20;
      ARect.Bottom := ARect.Bottom - 20;

      Cur := Mouse.CursorPos;
      if (Cur.X >= ARect.Left) and (Cur.X <= ARect.Right) and
         (Cur.Y >= ARect.Top) and (Cur.Y <= ARect.Bottom) then
      begin
          Msg.Result:= MA_NOACTIVATEANDEAT;
          PopupMenu1.Popup(Cur.x, Cur.y);
      end;
    end;

  except
  end;
end;

{ TEventMethod }

function TEventMethod.GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount,
  LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := 0;
end;

function TEventMethod.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Result := 0;
end;

function TEventMethod.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := 0;
end;

function TEventMethod.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
begin
  Result := 0;
  try
    EditorForm.OldVisible := False;
    EditorForm.tmParamsReaderTimer(EditorForm.tmParamsReader);
    EditorForm.SetPanCursorPos;
  except
  end;
end;

initialization
  OleInitialize(nil);  
finalization
  OleUnInitialize;
end.
