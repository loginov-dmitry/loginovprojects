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

unit MedAddEditCategFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, MedBaseFrm, StdCtrls, ActnList,
  JvAppStorage, JvAppRegistryStorage, JvComponentBase, JvFormPlacement,
  Buttons, ExtCtrls, IBCustomDataSet, ibxFBUtils, MedGlobalUnit;

type
  TMedAddEditCategForm = class(TMedBaseForm)
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edTempl: TEdit;
    edCode: TEdit;
    Label3: TLabel;
    cbShowCateg: TCheckBox;
    Label4: TLabel;
    memComment: TMemo;
    Label5: TLabel;
    edCategText: TEdit;
    Label6: TLabel;
    cbBold: TCheckBox;
    cbItalic: TCheckBox;
    cbUnderline: TCheckBox;
    Label7: TLabel;
    cbElemListStyle: TComboBox;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FAdd: Boolean;
    FID: Integer;
  protected
    procedure OnAfterShow; override;     
  public
    { Public declarations }
    procedure ReadData(ID: Integer);
  end;

procedure ShowAddEditCategForm(DoAdd: Boolean; dsCategs: TIBDataSet);

implementation

{$R *.dfm}

procedure ShowAddEditCategForm(DoAdd: Boolean; dsCategs: TIBDataSet);
var
  OrderNum: Integer;
  sDecor: string;
begin
  with TMedAddEditCategForm.Create(nil) do
  try
    FAdd := DoAdd;
    if DoAdd then
    begin
      FID := 0;
      cbShowCateg.Checked := True;
    end
    else
    begin
      FID := dsCategs.FieldByName('ID').AsInteger;
      ReadData(FID);
    end;

    if ShowModal = mrOk then
    begin

      if cbBold.Checked then
        sDecor := 'B;';
      if cbItalic.Checked then
        sDecor := sDecor + 'I;';
      if cbUnderline.Checked then
        sDecor := sDecor + 'U;';

      if DoAdd then
      begin
        FID := fb.GenID(MedDB, 'GEN_DESCCATEGS_ID');
        with fb.CreateAndOpenDataSet(MedDB, TranR, 'SELECT MAX(ORDERNUM) FROM DESCCATEGS WHERE ISDELETE=0', [], []) do
        try
          OrderNum := Fields[0].AsInteger + 1;
        finally
          Free;
        end;
        FBInsertRecord(MedDB, TranW, 'DESCCATEGS',
          ['ID', 'ADDDATE', 'ADDDOCTOR', 'MODIFYDOCTOR', 'ISDELETE', 'CATEGCODE', 'NAME',
           'TEMPLCODE', 'USECATEG', 'COMMENT', 'COMPNAME', 'ORDERNUM',
           'CATEGTEXT', 'ELEMLISTSTYLE', 'CATEGDECOR'],
          [FID, Now, UserID, UserID, 0, Trim(edCode.Text), Trim(edName.Text),
           Trim(edTempl.Text), Byte(cbShowCateg.Checked), Trim(memComment.Text), ComputerName, OrderNum,
           Trim(edCategText.Text), cbElemListStyle.ItemIndex, sDecor],
           [dsCategs]);
        dsCategs.Locate('ID', FID, []);
      end else
      begin
        FBUpdateRecord(MedDB, TranW, 'DESCCATEGS', ['ID'], [FID],
          ['MODIFYDOCTOR', 'CATEGCODE', 'NAME', 'TEMPLCODE', 'USECATEG', 'COMMENT',
           'CATEGTEXT', 'ELEMLISTSTYLE', 'CATEGDECOR'],
          [UserID, Trim(edCode.Text), Trim(edName.Text), Trim(edTempl.Text),
           Byte(cbShowCateg.Checked), Trim(memComment.Text),
           Trim(edCategText.Text), cbElemListStyle.ItemIndex, sDecor],
           [dsCategs]);
      end;
    end;
  finally
    Free;
  end;
end;

{ TMedAddEditCategForm }

procedure TMedAddEditCategForm.btnOKClick(Sender: TObject);
var
  ds: TIBDataSet;
begin
  inherited;
  //
  ModalResult := mrNone;
  if Trim(edName.Text) = '' then
    RaiseError('Наименование категории не задано');

  // Проверяем, есть ли в БД категория с таким же кодом синхронизации
  if Trim(edCode.Text) <> '' then
  begin
    ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCCATEGS',
      'UPPER(CATEGCODE)=:c AND ID <> :id AND ISDELETE=0', '',
      ['c', 'id'], [AnsiUpperCase(Trim(edCode.Text)), FID]);
    try
      if ds.RecordCount > 0 then
        RaiseError('Уже есть категория с такой же строкой синхронизации!');
    finally
      ds.Free;
    end;
  end;

  // Проверяем, есть ли в БД категория с таким же наименованием
  if Trim(edName.Text) <> '' then
  begin
    ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCCATEGS',
      'UPPER(NAME)=:n AND ID <> :id AND ISDELETE=0', '',
      ['n', 'id'], [AnsiUpperCase(Trim(edName.Text)), FID]);
    try
      if ds.RecordCount > 0 then
        RaiseError('Уже есть категория с таким же наименованием!');
    finally
      ds.Free;
    end;
  end;

  ModalResult := mrOk;
end;

procedure TMedAddEditCategForm.OnAfterShow;
begin
  inherited;
  edName.SelLength := 0;
end;

procedure TMedAddEditCategForm.ReadData(ID: Integer);
var
  ds: TIBDataSet;
  s: string;
begin
  ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCCATEGS', 'ID=' + IntToStr(ID), '', [], [], Self);
  edName.Text := ds.FieldByName('NAME').AsString;

  edCategText.Text := ds.FieldByName('CATEGTEXT').AsString;
  s := ds.FieldByName('CATEGDECOR').AsString;
  cbBold.Checked := Pos('B', s) > 0;
  cbItalic.Checked := Pos('I', s) > 0;
  cbUnderline.Checked := Pos('U', s) > 0;
  cbElemListStyle.ItemIndex := ds.FieldByName('ELEMLISTSTYLE').AsInteger;

  edTempl.Text := ds.FieldByName('TEMPLCODE').AsString;
  edCode.Text := ds.FieldByName('CATEGCODE').AsString;
  cbShowCateg.Checked := ds.FieldByName('USECATEG').AsInteger = 1;
  memComment.Text := ds.FieldByName('COMMENT').AsString;



  ds.Free;
end;

end.
