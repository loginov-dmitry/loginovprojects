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

unit MedEditVarTypesFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MedBaseFrm, ExtCtrls, ActnList, JvAppStorage, JvAppRegistryStorage,
  JvComponentBase, JvFormPlacement, StdCtrls, Buttons;

type
  TMedEditVarTypesForm = class(TMedBaseForm)
    lbTypesList: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    cbTypesNames: TComboBox;
    edList: TEdit;
    labList: TLabel;
    btnSet: TButton;
    procedure cbTypesNamesSelect(Sender: TObject);
    procedure lbTypesListClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
  private
    { Private declarations }
    DenyAutoSet: Boolean;
  public
    { Public declarations }
  end;

var
  MedEditVarTypesForm: TMedEditVarTypesForm;

function EditVarTypes(ATypes: TStringList): Boolean;

implementation

uses MedGlobalUnit;

{$R *.dfm}

function EditVarTypes(ATypes: TStringList): Boolean;
begin
  with TMedEditVarTypesForm.Create(nil) do
  try
    lbTypesList.Items.Assign(ATypes);
    if lbTypesList.Items.Count > 0 then
    begin
      lbTypesList.ItemIndex := 0;
      lbTypesListClick(nil);
    end;
      
    Result := ShowModal = mrOk;
    if Result then
      ATypes.Assign(lbTypesList.Items);
  finally
    Free;
  end;
end;

procedure TMedEditVarTypesForm.btnSetClick(Sender: TObject);
var
  s: string;
begin
  s := cbTypesNames.Text;
  if edList.Visible then
  begin
    if Trim(edList.Text) = '' then
      RaiseError('Не указано ни одного варианта для выбора');
    s := s + ':' + edList.Text;
  end;
  lbTypesList.Items.ValueFromIndex[lbTypesList.ItemIndex] := s;
end;

procedure TMedEditVarTypesForm.cbTypesNamesSelect(Sender: TObject);
var
  s: string;
  cbText: string;
begin
  inherited;
  cbText := cbTypesNames.Text;
  labList.Visible := cbText = 'Выбор';
  edList.Visible := labList.Visible;

  if cbText <> 'Выбор' then
  begin
    s := lbTypesList.Items.ValueFromIndex[lbTypesList.ItemIndex];
    if Pos('Выбор', s) = 0 then
    begin
      if not DenyAutoSet then
      begin
        lbTypesList.Items.ValueFromIndex[lbTypesList.ItemIndex] := cbText;
      end;
      btnSet.Visible := False;
      Exit;
    end;
  end;

  btnSet.Visible := True;
end;

procedure TMedEditVarTypesForm.lbTypesListClick(Sender: TObject);
var
  s, sList: string;
  APos, Idx: Integer;
begin
  if lbTypesList.ItemIndex >= 0 then
  begin
    s := lbTypesList.Items.ValueFromIndex[lbTypesList.ItemIndex];
    APos := Pos(':', s);
    if APos > 0 then
    begin
      sList := Copy(s, APos + 1, MaxWord);
      s := Copy(s, 1, APos - 1);
    end;
    Idx := cbTypesNames.Items.IndexOf(s);
    if Idx >= 0 then
    begin
      cbTypesNames.ItemIndex := Idx;
      DenyAutoSet := True;
      cbTypesNamesSelect(cbTypesNames);
      DenyAutoSet := False;
      edList.Text := sList;
    end;
  end;
end;

end.
