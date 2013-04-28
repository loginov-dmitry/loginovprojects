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

unit MedAddEditElemFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MedBaseFrm, ActnList, JvAppStorage, JvAppRegistryStorage,
  JvComponentBase, JvFormPlacement, StdCtrls, Buttons, ExtCtrls, IBCustomDataSet,
  ibxFBUtils;

type
  TMedAddEditElemForm = class(TMedBaseForm)
    Label1: TLabel;
    labCateg: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edName: TEdit;
    edText: TEdit;
    edCode: TEdit;
    Label5: TLabel;
    cbBold: TCheckBox;
    cbItalic: TCheckBox;
    cbUnderline: TCheckBox;
    cbIsReqiured: TCheckBox;
    cbContinuePrev: TCheckBox;
    cbCustomVars: TCheckBox;
    cbRequireVars: TCheckBox;
    Label6: TLabel;
    rbLeft: TRadioButton;
    rbRight: TRadioButton;
    Label7: TLabel;
    cbDelimAfter: TComboBox;
    Label8: TLabel;
    cbVarSeparator: TComboBox;
    Label9: TLabel;
    memComment: TMemo;
    procedure btnOKClick(Sender: TObject);
    procedure edNameExit(Sender: TObject);
  private
    { Private declarations }
    FAdd: Boolean;
    FID: Integer;
    FCategID: Integer;

    procedure ReadData(ID: Integer);
  protected
    procedure OnAfterShow; override;      
  public
    { Public declarations }
  end;

var
  MedAddEditElemForm: TMedAddEditElemForm;

function ShowAddEditElemForm(DoAdd: Boolean; dsCategs, dsElems: TIBDataSet; pID: PInteger = nil): Boolean;

implementation

uses MedGlobalUnit;

{$R *.dfm}

function ShowAddEditElemForm(DoAdd: Boolean; dsCategs, dsElems: TIBDataSet; pID: PInteger = nil): Boolean;
var
  OrderNum: Integer;
  sVarPos, sDelimAfter, sDecor, sVarSep: string;
begin
  if dsCategs.FieldByName('ID').AsInteger = 0 then
    RaiseError('Не выбрана категория описания');

  with TMedAddEditElemForm.Create(nil) do
  try
    FAdd := DoAdd;

    FCategID := dsCategs.FieldByName('ID').AsInteger;
    labCateg.Caption := dsCategs.FieldByName('NAME').AsString;

    if DoAdd then
    begin
      FID := 0;
    end else
    begin
      FID := dsElems.FieldByName('ID').AsInteger;
      ReadData(FID);
    end;

    Result := ShowModal = mrOk;
    if Result then
    begin
      if rbLeft.Checked then
        sVarPos := 'L'
      else
        sVarPos := 'R';
      sDelimAfter := cbDelimAfter.Text;
      sDelimAfter := FastStringReplace(sDelimAfter, 'Пробел', 'S');

      sVarSep := cbVarSeparator.Text;
      sVarSep := FastStringReplace(sVarSep, 'Пробел', 'S');


      if cbBold.Checked then
        sDecor := 'B;';
      if cbItalic.Checked then
        sDecor := sDecor + 'I;';
      if cbUnderline.Checked then
        sDecor := sDecor + 'U;';

      if DoAdd then
      begin
        FID := fb.GenID(MedDB, 'GEN_DESCELEMS_ID');
        //OrderNum
        with fb.CreateAndOpenDataSet(MedDB, TranR,
          'SELECT MAX(ORDERNUM) FROM DESCELEMS WHERE ISDELETE=0 AND CATEG_ID=' +
          IntToStr(FCategID), [], []) do
        try
          OrderNum := Fields[0].AsInteger + 1;
        finally
          Free;
        end;

        FBInsertRecord(MedDB, TranW, 'DESCELEMS',
          ['ID', 'CATEG_ID', 'ADDDATE', 'ADDDOCTOR', 'MODIFYDOCTOR',
           'ISDELETE', 'ELEMCODE', 'ELEMNAME', 'ELEMTEXT', 'COMMENT',
           'COMPNAME', 'ORDERNUM', 'ISREQUIRED', 'VARPOS',
           'DELIMAFTER', 'ELEMDECOR', 'CONTINUEPREV', 'VARSEPARATOR',
           'REQUIREVARS', 'CUSTOMVARS'],
          [FID, FCategID, Now, UserID, UserID,
           0, Trim(edCode.Text), Trim(edName.Text), Trim(edText.Text), Trim(memComment.Text),
           ComputerName, OrderNum, Byte(cbIsReqiured.Checked), sVarPos,
           sDelimAfter, sDecor, Byte(cbContinuePrev.Checked), sVarSep,
           Byte(cbRequireVars.Checked), Byte(cbCustomVars.Checked)], [dsElems]);
      end else
      begin
        FBUpdateRecord(MedDB, TranW, 'DESCELEMS', ['ID'], [FID],
          ['MODIFYDOCTOR', 'ELEMCODE', 'ELEMNAME', 'ELEMTEXT',
           'COMMENT', 'ISREQUIRED', 'VARPOS',
           'DELIMAFTER', 'ELEMDECOR', 'CONTINUEPREV', 'VARSEPARATOR',
           'REQUIREVARS', 'CUSTOMVARS'],
          [UserID, Trim(edCode.Text), Trim(edName.Text), Trim(edText.Text),
          Trim(memComment.Text), Byte(cbIsReqiured.Checked), sVarPos,
           sDelimAfter, sDecor, Byte(cbContinuePrev.Checked), sVarSep,
           Byte(cbRequireVars.Checked), Byte(cbCustomVars.Checked)], [dsElems]);
      end;
      if Assigned(pID) then
        pID^ := FID;
    end;

  finally
    Free;
  end;
end;

{ TMedAddEditElemForm }

procedure TMedAddEditElemForm.btnOKClick(Sender: TObject);
var
  ds: TIBDataSet;
begin
  inherited;
  ModalResult := mrNone;

  if edName.Focused then
    edNameExit(nil);

  if Trim(edName.Text) = '' then
    RaiseError('Необходимо ввести наименование элемента');

  // Проверяем, есть ли в БД элемент с таким же кодом синхронизации
  if Trim(edCode.Text) <> '' then
  begin
    ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCELEMS',
      'UPPER(ELEMCODE)=:e AND CATEG_ID=:c AND ID <> :id AND ISDELETE=0', '',
      ['e', 'c', 'id'], [AnsiUpperCase(Trim(edCode.Text)), FCategID, FID]);
    try
      if ds.RecordCount > 0 then
        RaiseError('Уже есть элемент с такой же строкой синхронизации!');
    finally
      ds.Free;
    end;
  end;

  // Проверяем, есть ли в БД элемент с таким же наименованием
  if Trim(edName.Text) <> '' then
  begin
    ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCELEMS',
      'UPPER(ELEMNAME)=:n AND CATEG_ID=:c AND ID <> :id AND ISDELETE=0', '',
      ['n', 'c', 'id'], [AnsiUpperCase(Trim(edName.Text)), FCategID, FID]);
    try
      if ds.RecordCount > 0 then
        RaiseError('Уже есть элемент с таким же наименованием!');
    finally
      ds.Free;
    end;
  end;

  ModalResult := mrOk;
end;

procedure TMedAddEditElemForm.edNameExit(Sender: TObject);
begin
  inherited;
  if FAdd then
    if edText.Text = '' then
      edText.Text := edName.Text;
end;

procedure TMedAddEditElemForm.OnAfterShow;
begin
  inherited;
  edName.SelLength := 0;
end;

procedure TMedAddEditElemForm.ReadData(ID: Integer);
var
  dsElems: TIBDataSet;
  s: string;
begin
  dsElems := fb.CreateAndOpenTable(MedDB, TranR, 'DESCELEMS', 'ID=' + IntToStr(ID), '', [], []);
  try
    edName.Text := dsElems.FieldByName('ELEMNAME').AsString;
    edText.Text := dsElems.FieldByName('ELEMTEXT').AsString;
    edCode.Text := dsElems.FieldByName('ELEMCODE').AsString;
    s := dsElems.FieldByName('ELEMDECOR').AsString;
    cbBold.Checked := Pos('B', s) > 0;
    cbItalic.Checked := Pos('I', s) > 0;
    cbUnderline.Checked := Pos('U', s) > 0;
    cbIsReqiured.Checked := dsElems.FieldByName('ISREQUIRED').AsInteger = 1;
    cbContinuePrev.Checked := dsElems.FieldByName('CONTINUEPREV').AsInteger = 1;
    cbCustomVars.Checked := dsElems.FieldByName('CUSTOMVARS').AsInteger = 1;
    cbRequireVars.Checked := dsElems.FieldByName('REQUIREVARS').AsInteger = 1;
    rbLeft.Checked := dsElems.FieldByName('VARPOS').AsString = 'L';
    s := dsElems.FieldByName('DELIMAFTER').AsString;
    if s = 'S' then // S - пробел
      cbDelimAfter.ItemIndex := 0
    else
      cbDelimAfter.Text := s;
    s := dsElems.FieldByName('VARSEPARATOR').AsString;
    if s = 'S' then // S - пробел
      cbVarSeparator.ItemIndex := 0
    else
      cbVarSeparator.Text := s;
    memComment.Text := dsElems.FieldByName('COMMENT').AsString;
  finally
    dsElems.Free;
  end;
end;

end.
