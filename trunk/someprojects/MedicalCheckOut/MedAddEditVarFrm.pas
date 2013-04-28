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

unit MedAddEditVarFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MedBaseFrm, StdCtrls, ActnList, JvAppStorage, JvAppRegistryStorage,
  JvComponentBase, JvFormPlacement, Buttons, ExtCtrls, IBCustomDataSet,
  ibxFBUtils;

type
  TMedAddEditVarForm = class(TMedBaseForm)
    Label1: TLabel;
    Label2: TLabel;
    labCateg: TLabel;
    labElem: TLabel;
    Label3: TLabel;
    edName: TEdit;
    edCode: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edCorrElem: TEdit;
    Label9: TLabel;
    memComment: TMemo;
    cbCanOtherVars: TCheckBox;
    Label6: TLabel;
    Label7: TLabel;
    Timer1: TTimer;
    Label8: TLabel;
    Label10: TLabel;
    edVarTypes: TEdit;
    btnEditVarTypes: TSpeedButton;
    procedure btnOKClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnEditVarTypesClick(Sender: TObject);
  private
    { Private declarations }
    FAdd: Boolean;
    FID: Integer;
    FElemID: Integer;
    procedure ReadData(ID: Integer);
  protected
    procedure OnAfterShow; override;    
  public
    { Public declarations }
  end;

var
  MedAddEditVarForm: TMedAddEditVarForm;

function ShowAddEditVarForm(DoAdd: Boolean; dsCategs, dsElems, dsVars: TIBDataSet; pID: PInteger = nil): Boolean;

implementation

uses MedGlobalUnit, MedEditVarTypesFrm;

{$R *.dfm}

function ShowAddEditVarForm(DoAdd: Boolean; dsCategs, dsElems, dsVars: TIBDataSet; pID: PInteger = nil): Boolean;
var
  OrderNum: Integer;
begin
  if dsCategs.FieldByName('ID').AsInteger = 0 then
    RaiseError('Не выбрана категория описания');
  if dsElems.FieldByName('ID').AsInteger = 0 then
    RaiseError('Не выбран элемент описания');

  with TMedAddEditVarForm.Create(nil) do
  try
    FAdd := DoAdd;

    labCateg.Caption := dsCategs.FieldByName('NAME').AsString;
    labElem.Caption := dsElems.FieldByName('ELEMNAME').AsString;
    FElemID := dsElems.FieldByName('ID').AsInteger;
    if DoAdd then
    begin

    end else
    begin
      FID := dsVars.FieldByName('ID').AsInteger;
      ReadData(FID);
    end;

    Result := ShowModal = mrOk;
    if Result then
    begin
      if DoAdd then
      begin
        FID := fb.GenID(MedDB, 'GEN_DESCVARS_ID');

        with fb.CreateAndOpenDataSet(MedDB, TranR,
          'SELECT MAX(ORDERNUM) FROM DESCVARS WHERE ISDELETE=0 AND ELEM_ID=' +
          IntToStr(FElemID), [], []) do
        try
          OrderNum := Fields[0].AsInteger + 1;
        finally
          Free;
        end;
        FBInsertRecord(MedDB, TranW, 'DESCVARS',
          ['ID', 'ELEM_ID', 'ADDDATE', 'ADDDOCTOR', 'MODIFYDOCTOR',
           'ISDELETE', 'VARCODE', 'VARTEXT', 'CORRELEM', 'COMMENT',
           'COMPNAME', 'ORDERNUM', 'CANOTHERVARS', 'VARTYPES'],
          [FID, FElemID, Now, UserID, UserID,
           0, Trim(edCode.Text), Trim(edName.Text), Trim(edCorrElem.Text), Trim(memComment.Text),
           ComputerName, OrderNum, Byte(cbCanOtherVars.Checked), Trim(edVarTypes.Text)],
          [dsVars]);
      end else
      begin
        FBUpdateRecord(MedDB, TranW, 'DESCVARS', ['ID'], [FID],
          ['MODIFYDOCTOR', 'VARCODE', 'VARTEXT', 'CORRELEM',
           'COMMENT', 'CANOTHERVARS', 'VARTYPES'],
          [UserID, Trim(edCode.Text), Trim(edName.Text), Trim(edCorrElem.Text),
           Trim(memComment.Text), Byte(cbCanOtherVars.Checked), Trim(edVarTypes.Text)],
          [dsVars]);
      end;
      if Assigned(pID) then
        pID^ := FID;
    end;
  finally
    Free;
  end;
end;

{ TMedAddEditVarForm }

procedure TMedAddEditVarForm.btnEditVarTypesClick(Sender: TObject);
var
  ListTypes: TStringList;
begin

  ListTypes := TStringList.Create;
  try
    GetVarNameAndTypes(edName.Text, edVarTypes.Text, ListTypes);
    if EditVarTypes(ListTypes) then
      edVarTypes.Text := FastStringReplace(Trim(ListTypes.Text), sLineBreak, '|');
  finally
    ListTypes.Free;
  end;
end;

procedure TMedAddEditVarForm.btnOKClick(Sender: TObject);
var
  ds: TIBDataSet;
begin
  inherited;

  ModalResult := mrNone;

  if Trim(edName.Text) = '' then
    RaiseError('Необходимо ввести наименование варианта описания');

  // Проверяем, есть ли в БД вариант с таким же кодом синхронизации
  if Trim(edCode.Text) <> '' then
  begin
    ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCVARS',
      'UPPER(VARCODE)=:v AND ELEM_ID=:e AND ID <> :id AND ISDELETE=0', '',
      ['v', 'e', 'id'], [AnsiUpperCase(Trim(edCode.Text)), FElemID, FID]);
    try
      if ds.RecordCount > 0 then
        RaiseError('Уже есть вариант с такой же строкой синхронизации!');
    finally
      ds.Free;
    end;
  end;

  // Проверяем, есть ли в БД вариант с таким же наименованием
  if Trim(edName.Text) <> '' then
  begin
    ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCVARS',
      'UPPER(VARTEXT)=:v AND ELEM_ID=:e AND ID <> :id AND ISDELETE=0', '',
      ['v', 'e', 'id'], [AnsiUpperCase(Trim(edName.Text)), FElemID, FID]);
    try
      if ds.RecordCount > 0 then
        RaiseError('Уже есть вариант с таким же текстом!');
    finally
      ds.Free;
    end;
  end;

  // Проверяем, правильно ли задана подстановочная строка
  GetVarNameAndTypes(edName.Text, edVarTypes.Text, nil);

  ModalResult := mrOk;
end;

procedure TMedAddEditVarForm.OnAfterShow;
begin
  inherited;
  edName.SelLength := 0;
end;

procedure TMedAddEditVarForm.ReadData(ID: Integer);
var
  ds: TIBDataSet;
begin
  ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCVARS', 'ID=' + IntToStr(ID), '', [], [], Self);

  edName.Text := ds.FieldByName('VARTEXT').AsString;
  edCode.Text := ds.FieldByName('VARCODE').AsString;
  edCorrElem.Text := ds.FieldByName('CORRELEM').AsString;
  cbCanOtherVars.Checked := ds.FieldByName('CANOTHERVARS').AsInteger = 1;
  edVarTypes.Text := ds.FieldByName('VARTYPES').AsString;
  memComment.Text := ds.FieldByName('COMMENT').AsString;

  ds.Free;
end;

procedure TMedAddEditVarForm.Timer1Timer(Sender: TObject);
begin
  inherited;
  Timer1.Enabled := False;

end;

end.
