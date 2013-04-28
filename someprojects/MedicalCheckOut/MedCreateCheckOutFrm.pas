{
Copyright (c) 2012, Loginov Dmitry Sergeevich
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

unit MedCreateCheckOutFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MedBaseFrm, ExtCtrls, ActnList, JvAppStorage, JvAppRegistryStorage,
  JvComponentBase, JvFormPlacement, StdCtrls, Buttons, MedGlobalUnit, CheckLst,
  IBCustomDataSet, ibxFBUtils, OleCtrls, SHDocVw, MSHTML, ShellAPI;

type
  TMedCreateCheckOutForm = class(TMedBaseForm)
    panCategs: TPanel;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    panCategPreview: TPanel;
    Panel3: TPanel;
    memPreview: TMemo;
    Panel8: TPanel;
    panElems: TPanel;
    Panel4: TPanel;
    clbElems: TCheckListBox;
    Panel5: TPanel;
    Panel6: TPanel;
    Label1: TLabel;
    edElemText: TEdit;
    Panel7: TPanel;
    panVars: TPanel;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    clbVars: TCheckListBox;
    clbCategs: TCheckListBox;
    btnAddElem: TSpeedButton;
    btnAddVar: TSpeedButton;
    btnEditVarText: TSpeedButton;
    btnEditResultText: TSpeedButton;
    btnEditElemText: TSpeedButton;
    labInputMode: TLabel;
    btnUnEditResultText: TSpeedButton;
    TimerAutoPreview: TTimer;
    acEditVar: TAction;
    wb: TWebBrowser;
    Panel9: TPanel;
    btnMainInfo: TSpeedButton;
    AutoSaveCategTimer: TTimer;
    btnMakeReport: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure clbElemsClick(Sender: TObject);
    procedure clbCategsClick(Sender: TObject);
    procedure btnAddElemClick(Sender: TObject);
    procedure btnAddVarClick(Sender: TObject);
    procedure clbVarsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure clbCategsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure clbElemsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure clbCategsClickCheck(Sender: TObject);
    procedure clbElemsClickCheck(Sender: TObject);
    procedure clbVarsClickCheck(Sender: TObject);
    procedure btnEditElemTextClick(Sender: TObject);
    procedure clbElemsDblClick(Sender: TObject);
    procedure btnEditVarTextClick(Sender: TObject);
    procedure TimerAutoPreviewTimer(Sender: TObject);
    procedure acEditVarExecute(Sender: TObject);
    procedure clbVarsDblClick(Sender: TObject);
    procedure btnMainInfoClick(Sender: TObject);
    procedure btnEditResultTextClick(Sender: TObject);
    procedure wbDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure btnUnEditResultTextClick(Sender: TObject);
    procedure AutoSaveCategTimerTimer(Sender: TObject);
    procedure btnMakeReportClick(Sender: TObject);
  private
    { Private declarations }
    FCategs: TDescCategList;

    ModifyCounter: Integer;

    MainInfo: TMainCheckOutInfo;

    HTMLDisp: IDispatch;
    HTMLEditor: IHTMLDocument2;

    DocDate: TDateTime;

    procedure FillCategList;
    procedure FillElemsList(AGateg: TDescCateg);
    procedure FillVarList(AElem: TDescElem);

    function GetCurCateg: TDescCateg;

    function GetCurElem: TDescElem;

    function GetCurVar: TDescVar;

    procedure UpdateCaption;

    procedure ShowInputMode(IsAuto: Boolean);
  public
    { Public declarations }
  end;

var
  MedCreateCheckOutForm: TMedCreateCheckOutForm;

procedure ShowCreateCheckOutForm;

implementation

uses MedAddEditElemFrm, MedAddEditVarFrm, MedInputVarFrm, MedInputDataFrm;

{$R *.dfm}

procedure ShowCreateCheckOutForm;
begin
  with TMedCreateCheckOutForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMedCreateCheckOutForm.acEditVarExecute(Sender: TObject);
begin
  inherited;
  btnEditVarText.Click;
end;

procedure TMedCreateCheckOutForm.AutoSaveCategTimerTimer(Sender: TObject);
var
  Categ: TDescCateg;
begin
  inherited;
  Categ := GetCurCateg;
  if Assigned(Categ) and (not Categ.FAutoMode) then
  begin
    if HTMLEditor <> nil then
    try
      Categ.FManualText := HTMLEditor.body.innerHTML;
    except
    end;
  end;
end;

procedure TMedCreateCheckOutForm.btnAddElemClick(Sender: TObject);
var
  dsCateg, dsElem: TIBDataSet;
  CategID, ElemID: Integer;
  ACateg: TDescCateg;
  Elem, PrevElem: TDescElem;
begin
  ACateg := GetCurCateg;
  CategID := ACateg.FID;
  dsCateg := fb.CreateAndOpenTable(MedDB, TranR, 'DESCCATEGS', 'ID=:id', '', ['id'], [CategID]);
  try
    dsElem := fb.CreateAndOpenTable(MedDB, TranR, 'DESCELEMS', 'ID=0', '', [], [], dsCateg);
    PrevElem := GetCurElem;

    if ShowAddEditElemForm(True, dsCateg, dsElem, @ElemID) then
    begin
      dsElem := fb.CreateAndOpenTable(MedDB, TranR, 'DESCELEMS', 'ID=:id', '', ['id'], [ElemID], dsCateg);
      Elem := GetCurCateg.AddEmptyElem;
      Elem.ReadDescFromDB(dsElem, ACateg, PrevElem);
      clbElems.Items.AddObject(Elem.FName, Elem);
    end;
  finally
    dsCateg.Free;
  end;
end;

procedure TMedCreateCheckOutForm.btnAddVarClick(Sender: TObject);
var
  dsCateg, dsElem, dsVar: TIBDataSet;
  CategID, ElemID, VarID: Integer;
  Elem: TDescElem;
  AVar: TDescVar;
begin
  CategID := GetCurCateg.FID;
  Elem := GetCurElem;
  ElemID := Elem.FID;
  dsCateg := fb.CreateAndOpenTable(MedDB, TranR, 'DESCCATEGS', 'ID=:id', '', ['id'], [CategID]);
  try
    dsElem := fb.CreateAndOpenTable(MedDB, TranR, 'DESCELEMS', 'ID=:id', '', ['id'], [ElemID], dsCateg);
    dsVar := fb.CreateAndOpenTable(MedDB, TranR, 'DESCVARS', 'ID=0', '', [], [], dsCateg);

    if ShowAddEditVarForm(True, dsCateg, dsElem, dsVar, @VarID) then
    begin
      dsVar := fb.CreateAndOpenTable(MedDB, TranR, 'DESCVARS', 'ID=:id', '', ['id'], [VarID], dsCateg);
      AVar := GetCurElem.AddEmptyVar;
      AVar.ReadDescFromDB(dsVar, Elem);
      clbVars.Items.AddObject(AVar.FName, AVar);
    end;
  finally
    dsCateg.Free;
  end;
end;

procedure TMedCreateCheckOutForm.btnEditElemTextClick(Sender: TObject);
var
  s: string;
  Elem: TDescElem;
begin
  inherited;
  Elem := GetCurElem;
  s := Elem.FResultText;
  if InputQuery('ВВОД ТЕКСТА ЭЛЕМЕНТА', 'Введите новый текст элемента', s) then
  begin
    Elem.FResultText := s;
    Elem.FIsManual := True;
    clbElems.Repaint;
    clbElems.OnClick(nil);
    Inc(ModifyCounter);
  end;
end;

procedure TMedCreateCheckOutForm.btnEditResultTextClick(Sender: TObject);
var
  Categ: TDescCateg;
begin
  Categ := GetCurCateg;
  if Categ.FAutoMode then
  begin
    Categ.FAutoMode := False;
    Categ.FManualText := HTMLEditor.body.innerHTML;
    ((HTMLDisp as IWebBrowser).Document as IHTMLDocument2).designMode := 'On';

    while not Assigned(HTMLEditor.body) do
      Application.ProcessMessages;
      
    HTMLEditor.body.innerHTML := Categ.FManualText;
    
    ShowInputMode(False);

    Application.MessageBox('Ручной ввод включен!', 'ВНИМАНИЕ!', MB_ICONINFORMATION);
  end else
    ShowMessage('Категория уже итак находится в режиме ручного ввода!');
end;

procedure TMedCreateCheckOutForm.btnEditVarTextClick(Sender: TObject);
var
  CurVar: TDescVar;
begin
  inherited;
  CurVar := GetCurVar;
  if CurVar = nil then
    RaiseError('Вариант описания не выбран!');

  if ShowInputVarForm(CurVar.FVarName, CurVar.FVarTypes, CurVar.FVarValues) then
  begin
    Inc(ModifyCounter);
    clbVars.Repaint;
  end;
end;

procedure TMedCreateCheckOutForm.btnMainInfoClick(Sender: TObject);
begin
  inherited;
  if InputMainCheckOutData(MainInfo) then
  begin
    UpdateCaption;
    Inc(ModifyCounter);
  end;
end;

procedure TMedCreateCheckOutForm.btnMakeReportClick(Sender: TObject);
var
  s, sRep, sCategs, sNumber, sDoctor, sFileName: string;
  sAction, sCommand, sParams: string;
  AList: TStringList;
  I: Integer;
  FCateg: TDescCateg;
begin
  inherited;

  AList := TStringList.Create;
  try
    AList.LoadFromFile(HTMLShablonFile);
    sRep := AList.Text;

    ConfigIni.ReadSectionValues('КОНСТАНТЫ', AList);
    for I := 0 to AList.Count - 1 do
      sRep := FastStringReplace(sRep, '{' + AList.Names[I] + '}', AList.ValueFromIndex[I]);

    sRep := FastStringReplace(sRep, '{Данные о пациенте}',
      GetMainCheckOutInfoAsString(MainInfo));

    for I := 0 to FCategs.ItemCount - 1 do
    begin
      FCateg := FCategs.GetCateg(I);
      if FCateg.FSelected then
      begin
        s := Trim(FCateg.GetResultText(MainInfo.PatSex <> 'f'));
        if s <> '' then
        begin
          if FCateg.FElemListStyle = 0 then
            sCategs := sCategs + '<p style="' + sPStyle + '">' + s + '</p>'
          else
            sCategs := sCategs + s; // Для списков не нужны дополнительные абзацы!
        end;
      end;

        //s := ProcessSexSensitiveText(s, MainInfo.PatSex <> 'f');
    end;

    sRep := FastStringReplace(sRep, '{Текст выписки}', sCategs);

    if MainInfo.Number = '' then
      sNumber := '<font color=red>_______</font>'
    else
      sNumber := MainInfo.Number;

    sRep := FastStringReplace(sRep, '{Номер выписки}', sNumber);

    with fb.CreateAndOpenDataSet(MedDB, TranR, 'SELECT NAME FROM DOCTORS WHERE ID=:id',
      ['id'], [MainInfo.DoctorID], nil) do
    try
      sDoctor := Fields[0].AsString;
      if sDoctor = '' then
        sDoctor := '<font color=red>___________________</font>';
      sRep := FastStringReplace(sRep, '{ФИО врача}', sDoctor);
    finally
      Free;
    end;

    AList.Text := sRep;

    if DocDate = 0 then
      DocDate := Now;

    sNumber := GetValidFileName(MainInfo.Number);
    if sNumber <> '' then
      sNumber := '_' + sNumber;

    sFileName := ReadyDocPath + 'CheckOut' + sNumber + '_' + FormatDateTime('yymmdd_hhnnss', DocDate) + '.html';

    AList.SaveToFile(sFileName);

    sAction := ConfigIni.ReadString('ОТКРЫТИЕ HTML', 'Операция', 'open');
    sCommand := ConfigIni.ReadString('ОТКРЫТИЕ HTML', 'Команда', 'winword.exe');
    sParams := ConfigIni.ReadString('ОТКРЫТИЕ HTML', 'Параметры', '{HTMLFile}');

    sCommand := FastStringReplace(sCommand, '{HTMLFile}', sFileName);
    sParams := FastStringReplace(sParams, '{HTMLFile}', sFileName);

    ShellExecute(Handle, PChar(sAction), PChar(sCommand), PChar(sParams), PChar(AppPath), SW_NORMAL);

  finally
    AList.Free;
  end;
end;

procedure TMedCreateCheckOutForm.btnUnEditResultTextClick(Sender: TObject);
begin
  if GetCurCateg.FAutoMode then
  begin
    ShowMessage('Ручной ввод категории итак отключен!');
  end else
  begin
    ((HTMLDisp as IWebBrowser).Document as IHTMLDocument2).designMode := 'Off';
    
    GetCurCateg.FAutoMode := True;
    Inc(ModifyCounter);
    ShowInputMode(True);
    
    Application.MessageBox('Ручной ввод отключен!', 'ВНИМАНИЕ!', MB_ICONINFORMATION);
  end;    
end;

procedure TMedCreateCheckOutForm.clbCategsClick(Sender: TObject);
var
  ACateg: TDescCateg;
begin
  inherited;
  if clbCategs.ItemIndex >= 0 then
  begin
    ACateg := TDescCateg(clbCategs.Items.Objects[clbCategs.ItemIndex]);
    FillElemsList(ACateg);
    Inc(ModifyCounter);

    ShowInputMode(ACateg.FAutoMode);
    if not ACateg.FAutoMode then
      HTMLEditor.body.innerHTML := ACateg.FManualText
    else
      TimerAutoPreviewTimer(nil);
  end;
end;

procedure TMedCreateCheckOutForm.clbCategsClickCheck(Sender: TObject);
begin
  inherited;
  TDescCateg(clbCategs.Items.Objects[clbCategs.ItemIndex]).FSelected := clbCategs.Checked[clbCategs.ItemIndex];
  Inc(ModifyCounter);
end;

procedure TMedCreateCheckOutForm.clbCategsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  c: TCanvas;
  ACateg: TDescCateg;
begin
  c := clbCategs.Canvas;

  if (odFocused in State) and (odSelected in State) then
    c.Brush.Color := clHotLight;

  c.FillRect(Rect);

  if Index >= 0 then
  begin
    ACateg := TDescCateg(clbCategs.Items.Objects[Index]);
    c.TextOut(Rect.Left + 2, Rect.Top, Format('%s (%d/%d)',
      [ACateg.FName, ACateg.GetSelectedCount, ACateg.ItemCount]));
  end;
end;

procedure TMedCreateCheckOutForm.clbElemsClick(Sender: TObject);
var
  AElem: TDescElem;
begin
  inherited;
  if clbElems.ItemIndex >= 0 then
  begin
    AElem := TDescElem(clbElems.Items.Objects[clbElems.ItemIndex]);
    FillVarList(AElem);
  end;
end;

procedure TMedCreateCheckOutForm.clbElemsClickCheck(Sender: TObject);
begin
  inherited;
  TDescElem(clbElems.Items.Objects[clbElems.ItemIndex]).FSelected := clbElems.Checked[clbElems.ItemIndex];
  Inc(ModifyCounter);
  clbCategs.Repaint;
end;

procedure TMedCreateCheckOutForm.clbElemsDblClick(Sender: TObject);
begin
  btnEditElemText.Click;
end;

procedure TMedCreateCheckOutForm.clbElemsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  c: TCanvas;
  Elem: TDescElem;
begin
  c := clbElems.Canvas;

  if (odFocused in State) and (odSelected in State) then
    c.Brush.Color := clHotLight;

  c.FillRect(Rect);

  if Index >= 0 then
  begin
    Elem := TDescElem(clbElems.Items.Objects[Index]);
    c.TextOut(Rect.Left + 2, Rect.Top, Format('%s (%d/%d)',
      [Elem.FName, Elem.GetSelectedCount, Elem.ItemCount]));
  end;
end;

procedure TMedCreateCheckOutForm.clbVarsClickCheck(Sender: TObject);
var
  AVar: TDescVar;
  Elem: TDescElem;
begin
  inherited;
  AVar := TDescVar(clbVars.Items.Objects[clbVars.ItemIndex]);
  Elem := GetCurElem;
  if clbVars.Checked[clbVars.ItemIndex] then
  begin
    if not Elem.CanSelectVar(AVar) then
    begin
      clbVars.Checked[clbVars.ItemIndex] := False;
      RaiseError('Имеются взаимоисключающие варианты описания!');
    end;

    if Pos('{', AVar.FVarName) > 0 then
    begin
      if ShowInputVarForm(AVar.FVarName, AVar.FVarTypes, AVar.FVarValues) then
        clbVars.Repaint;
    end;
  end;

  AVar.FSelected := clbVars.Checked[clbVars.ItemIndex];
  edElemText.Text := GetCurElem.GetElemText;
  Inc(ModifyCounter);
  clbElems.Repaint;
end;

procedure TMedCreateCheckOutForm.clbVarsDblClick(Sender: TObject);
begin
  inherited;
  btnEditVarText.Click;
end;

procedure TMedCreateCheckOutForm.clbVarsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  c: TCanvas;
  AVar: TDescVar;
  s: string;
begin
  c := clbVars.Canvas;

  if (odFocused in State) and (odSelected in State) then
    c.Brush.Color := clHotLight;

  c.FillRect(Rect);

  if Index >= 0 then
  begin
    AVar := TDescVar(clbVars.Items.Objects[Index]);
    c.TextOut(Rect.Left + 2, Rect.Top, AVar.GetResultText);

    s := AVar.FVarName;

    //if Pos('{', s) > 0 then
    //  c.TextOut(Rect.Right - 30, Rect.Top, ' {?}');
  end;
end;

procedure TMedCreateCheckOutForm.FillCategList;
var
  I, Idx: Integer;
  FCateg: TDescCateg;
begin
  clbCategs.Clear;
  for I := 0 to FCategs.ItemCount - 1 do
  begin
    FCateg := FCategs.GetCateg(I);
    Idx := clbCategs.Items.AddObject(FCateg.FName, FCateg);
    FCateg.FSelected := True;
    FCateg.FAutoMode := True;
    clbCategs.Checked[Idx] := FCateg.FSelected;
    if Idx = 0 then
    begin
      clbCategs.ItemIndex := 0;
      FillElemsList(FCateg);
      Inc(ModifyCounter);
    end;
  end;

end;

procedure TMedCreateCheckOutForm.FillElemsList(AGateg: TDescCateg);
var
  I, Idx: Integer;
  FElem: TDescElem;
begin
  if TDescCateg(clbElems.Tag) <> AGateg then
  begin
    clbElems.Clear;
    clbVars.Clear;
    for I := 0 to AGateg.ItemCount - 1 do
    begin
      FElem := AGateg.GetElem(I);
      Idx := clbElems.Items.AddObject(FElem.FName, FElem);
      clbElems.Checked[Idx] := FElem.FSelected;
      if Idx = 0 then
      begin
        clbElems.ItemIndex := 0;
        FillVarList(FElem);
      end;
    end;
    clbElems.Tag := Integer(AGateg);
  end;
end;

procedure TMedCreateCheckOutForm.FillVarList(AElem: TDescElem);
var
  I, Idx: Integer;
  FVar: TDescVar;
begin
  if TDescElem(clbVars.Tag) <> AElem then
  begin
    clbVars.Clear;
    for I := 0 to AElem.ItemCount - 1 do
    begin
      FVar := AElem.GetVar(I);
      Idx := clbVars.Items.AddObject(FVar.FName, FVar);
      clbVars.Checked[Idx] := FVar.FSelected;
      if Idx = 0 then
        clbVars.ItemIndex := 0;
    end;
    clbVars.Tag := Integer(AElem);
  end;
  btnAddVar.Enabled := AElem.FCustomVars;
  edElemText.Text := AElem.GetElemText;
end;

procedure TMedCreateCheckOutForm.FormCreate(Sender: TObject);
var
  B: Boolean;
begin
  inherited;

  clbCategs.ItemHeight := ConfigIni.ReadInteger('ПАРАМЕТРЫ', 'ВЫСОТА_СТРОКИ_ДЛЯ_СОСТАВЛЕНИЯ_ВЫПИСКИ', 20);
  clbElems.ItemHeight := clbCategs.ItemHeight;
  clbVars.ItemHeight := clbCategs.ItemHeight;

  clbCategs.Font.Size := ConfigIni.ReadInteger('ПАРАМЕТРЫ', 'РАЗМЕР_ШРИФТА_ДЛЯ_СОСТАВЛЕНИЯ_ВЫПИСКИ', 10);
  clbElems.Font.Size := clbCategs.Font.Size;
  clbVars.Font.Size := clbCategs.Font.Size;

  FCategs := TDescCategList.Create;
  FCategs.ReadDescFromDB;

  with TStringList.Create do
  try
    Text := Format(ConfigIni.ReadString('ШАБЛОНЫ', 'ШАБЛОН_HTML', ''), ['']);
    SaveToFile(TempHtmlFile);
    B := True;
    wb.Navigate(TempHtmlFile, B);
  finally
    Free;
  end;

  FillCategList;

  if UserID > 0 then
    MainInfo.DoctorID := UserID;
end;

procedure TMedCreateCheckOutForm.FormDestroy(Sender: TObject);
begin
  inherited;
  FCategs.Free;;
end;

function TMedCreateCheckOutForm.GetCurCateg: TDescCateg;
begin
  Result := TDescCateg(clbElems.Tag);
end;

function TMedCreateCheckOutForm.GetCurElem: TDescElem;
begin
  Result := TDescElem(clbVars.Tag);;
end;

function TMedCreateCheckOutForm.GetCurVar: TDescVar;
begin
  Result := nil;
  if clbVars.ItemIndex >= 0 then
  begin
    Result := TDescVar(clbVars.Items.Objects[clbVars.ItemIndex]);
  end;
end;

procedure TMedCreateCheckOutForm.ShowInputMode(IsAuto: Boolean);
begin
  if IsAuto then
    labInputMode.Caption := 'Режим: автоматический'
  else
    labInputMode.Caption := 'Режим: ручной ввод';
end;

procedure TMedCreateCheckOutForm.TimerAutoPreviewTimer(Sender: TObject);
var
  Categ: TDescCateg;
  s: string;
begin
  if TimerAutoPreview.Tag < ModifyCounter then
  begin
    TimerAutoPreview.Tag := ModifyCounter;
    Categ := GetCurCateg;
    if Assigned(Categ) and Categ.FAutoMode then
    begin
      s := Format(ConfigIni.ReadString('ШАБЛОНЫ', 'ШАБЛОН_HTML', ''), [Categ.GetResultText(MainInfo.PatSex <> 'f')]);
      //s := ProcessSexSensitiveText(s, MainInfo.PatSex <> 'f');
      HTMLEditor.body.innerHTML := s;
    end;
  end;
end;

procedure TMedCreateCheckOutForm.UpdateCaption;
var
  s: string;
begin
  s := 'Составление выписки';
  if MainInfo.Number <> '' then
    s := s + ' №' + MainInfo.Number;
  if MainInfo.DateOut <> 0 then
    s := s + ' от ' + DateToStr(MainInfo.DateOut);
  if MainInfo.PatFIO <> '' then
    s := s + ' (' + MainInfo.PatFIO + ')';
  Caption := s;  
end;

procedure TMedCreateCheckOutForm.wbDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  inherited;
  HTMLDisp := pDisp;
  HTMLEditor := (pDisp as IWebBrowser).Document as IHTMLDocument2;
end;

end.
