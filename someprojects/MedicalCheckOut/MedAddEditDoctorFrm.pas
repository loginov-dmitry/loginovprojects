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

unit MedAddEditDoctorFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MedBaseFrm, JvAppStorage, JvAppRegistryStorage, JvComponentBase,
  JvFormPlacement, StdCtrls, Buttons, ExtCtrls, IBCustomDataSet, ibxFBUtils,
  ActnList;

type
  TMedAddEditDoctorForm = class(TMedBaseForm)
    Label1: TLabel;
    edFullName: TEdit;
    Label2: TLabel;
    edName: TEdit;
    edTabNum: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edPassword: TEdit;
    cbIsBoss: TCheckBox;
    Label5: TLabel;
    memComment: TMemo;
    procedure btnOKClick(Sender: TObject);
    procedure edFullNameExit(Sender: TObject);
  private
    { Private declarations }
    FID: Integer;
    FAdd: Boolean;
  protected
    procedure ApplyRights(IsAdmin: Boolean); override;      
  public
    { Public declarations }
  end;

procedure AddEditDoctor(DoAdd: Boolean; dsDoctors: TIBDataSet);

implementation

uses MedGlobalUnit;

{$R *.dfm}

procedure AddEditDoctor(DoAdd: Boolean; dsDoctors: TIBDataSet);
begin
  with TMedAddEditDoctorForm.Create(nil) do
  try
    FAdd := DoAdd;
    if DoAdd then
    begin
      FID := 0;
      if (UserID = 0) and IsAdmin then // Если добавляется самый первый пользователь
        cbIsBoss.Checked := True;
    end else
    begin
      FID := dsDoctors.FieldByName('ID').AsInteger;
      edFullName.Text := dsDoctors.FieldByName('FULLNAME').AsString;
      edName.Text := dsDoctors.FieldByName('NAME').AsString;
      edTabNum.Text := dsDoctors.FieldByName('TABNUM').AsString;
      edPassword.Text := dsDoctors.FieldByName('USERPASSW').AsString;
      memComment.Text := dsDoctors.FieldByName('COMMENT').AsString;
      cbIsBoss.Checked := dsDoctors.FieldByName('ISBOSS').AsInteger = 1;

      if not IsAdmin then
        btnOK.Enabled := FID = UserID;
    end;

    if ShowModal = mrOk then
    begin
      if DoAdd then
      begin
        FID := fb.GenID(MedDB, 'GEN_DOCTORS_ID');
        FBInsertRecord(MedDB, TranW, 'DOCTORS',
          ['ID', 'TABNUM', 'NAME', 'FULLNAME', 'USERPASSW', 'ISBOSS', 'ADDDATE', 'ISDELETE', 'COMMENT', 'COMPNAME'],
          [FID, Trim(edTabNum.Text), Trim(edName.Text), Trim(edFullName.Text),
          edPassword.Text, Byte(cbIsBoss.Checked), Now, 0, Trim(memComment.Text), ComputerName],
          [dsDoctors]);
      end else
      begin
        FBUpdateRecord(MedDB, TranW, 'DOCTORS', ['ID'], [FID],
          ['TABNUM', 'NAME', 'FULLNAME', 'USERPASSW', 'ISBOSS', 'COMMENT'],
          [Trim(edTabNum.Text), Trim(edName.Text), Trim(edFullName.Text),
          edPassword.Text, Byte(cbIsBoss.Checked), Trim(memComment.Text)],
          [dsDoctors]);
      end;
    end;
  finally
    Free;
  end;
end;

{ TMedAddEditDoctorForm }

procedure TMedAddEditDoctorForm.ApplyRights(IsAdmin: Boolean);
begin
  inherited;
  cbIsBoss.Enabled := IsAdmin;
end;

procedure TMedAddEditDoctorForm.btnOKClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrNone;

  if Trim(edFullName.Text) = '' then
    RaiseError('Не указано полное имя врача');


  if Trim(edName.Text) = '' then
    RaiseError('Не указано ФИО врача');

  ModalResult := mrOk;
end;

procedure TMedAddEditDoctorForm.edFullNameExit(Sender: TObject);
var
  AList: TStringList;
  sFull: string;
  I: Integer;
begin
  inherited;
  
  if Trim(edName.Text) = '' then
  begin
    sFull := edFullName.Text;
    while Pos('  ', sFull) > 0 do
      sFull := FastStringReplace(sFull, '  ', ' ');
    
    AList := TStringList.Create;
    try
      AList.Text := FastStringReplace(sFull, ' ', sLineBreak);
      for I := 0 to AList.Count - 1 do
        if (I > 0) and (Length(AList[I]) > 1) then
          AList[I] := AList[I][1] + '.';
      edName.Text := FastStringReplace(Trim(AList.Text), sLineBreak, ' ');
    finally
      AList.Free;
    end;
  end;  
end;

end.
