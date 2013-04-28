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

unit MedInputVarFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MedBaseFrm, ExtCtrls, ActnList, JvAppStorage, JvAppRegistryStorage,
  JvComponentBase, JvFormPlacement, StdCtrls, Buttons, ComCtrls,
  JvErrorIndicator, JvValidators;

type
  TMedInputVarForm = class(TMedBaseForm)
    panVarText: TPanel;
    Label3: TLabel;
    edName: TEdit;
    Label10: TLabel;
    btnEditVarTypes: TSpeedButton;
    edVarTypes: TEdit;
    panShowVarText: TPanel;
    labCanEditVarText: TCheckBox;
    panVarValuesHolder: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    panVarValues: TPanel;
    panCaption: TPanel;
    procedure btnEditVarTypesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure labCanEditVarTextClick(Sender: TObject);
    procedure edNameExit(Sender: TObject);
  private
    { Private declarations }
    procedure ShowVarNamesAndValues(sVarValues: string);

    procedure OnChangeNumber(Sender: TObject);
    procedure OnComboSelect(Sender: TObject);

    // Возвращает список подстановочных строк и их значений
    function GetValueList: string;
  protected
    procedure OnAfterShow; override;  
  public
    { Public declarations }
  end;

var
  MedInputVarForm: TMedInputVarForm;

function ShowInputVarForm(var sVarText: string; var sVarTypes: string; var sVarValues: string): Boolean;

implementation

uses MedGlobalUnit, MedEditVarTypesFrm;

{$R *.dfm}

const
  sInputCustomText = 'Ввести другое значение...';

function ShowInputVarForm(var sVarText: string; var sVarTypes: string; var sVarValues: string): Boolean;
var
  ListTypes: TStringList;
begin
  with TMedInputVarForm.Create(nil) do
  try
    panCaption.Caption := sVarText;
    edName.Text := sVarText;
    edVarTypes.Text := sVarTypes;

    panVarText.Visible := Pos('{', sVarText) = 0;
    panVarValuesHolder.Visible := not panVarText.Visible;
    panShowVarText.Visible := not panVarText.Visible;

    if panVarValuesHolder.Visible then
    begin
      ListTypes := TStringList.Create;
      try
        GetVarNameAndTypes(edName.Text, edVarTypes.Text, ListTypes);
        edVarTypes.Text := FastStringReplace(Trim(ListTypes.Text), sLineBreak, '|');
      finally
        ListTypes.Free;
      end;
      ShowVarNamesAndValues(sVarValues);
    end;

    Result := ShowModal = mrOk;
    if Result then
    begin
      sVarText := edName.Text;
      sVarTypes := edVarTypes.Text;
      sVarValues := GetValueList;
    end;
  finally
    Free;
  end;
end;

{ TMedInputVarForm }

procedure TMedInputVarForm.btnEditVarTypesClick(Sender: TObject);
var
  ListTypes: TStringList;
begin
  ListTypes := TStringList.Create;
  try
    GetVarNameAndTypes(edName.Text, edVarTypes.Text, ListTypes);
    if EditVarTypes(ListTypes) then
    begin
      edVarTypes.Text := FastStringReplace(Trim(ListTypes.Text), sLineBreak, '|');
      ShowVarNamesAndValues(GetValueList);
    end;
  finally
    ListTypes.Free;
  end;
end;

procedure TMedInputVarForm.edNameExit(Sender: TObject);
begin
  inherited;
  panVarValuesHolder.Visible := Pos('{', edName.Text) > 0;
end;

procedure TMedInputVarForm.FormShow(Sender: TObject);
begin
  inherited;
  //ShowVarNamesAndValues
end;

function TMedInputVarForm.GetValueList: string;
var
  I: Integer;
  cntr: TControl;
  AList: TStringList;
  sName, sValue: string;
begin
  AList := TStringList.Create;
  try
    for I := 0 to panVarValues.ControlCount - 1 do
    begin
      cntr := panVarValues.Controls[I];
      if cntr.Tag = 1 then
      begin
        sName := cntr.Hint;
        sValue := '';
        if cntr is TEdit then
          sValue := TEdit(cntr).Text
        else if cntr is TDateTimePicker then
          sValue := DateToStr(TDateTimePicker(cntr).Date)
        else if cntr is TComboBox then
          sValue := TComboBox(cntr).Text;
        AList.Add(sName + '=' + sValue);
      end;
    end;
    Result := FastStringReplace(Trim(AList.Text), sLineBreak, '|');
  finally
    AList.Free;
  end;
end;

procedure TMedInputVarForm.labCanEditVarTextClick(Sender: TObject);
begin
  inherited;
  panVarText.Visible := labCanEditVarText.Checked;
end;

procedure TMedInputVarForm.OnAfterShow;
var
  cntr: TControl;
  I: Integer;
begin
  if panVarText.Visible then
  begin
    edName.SetFocus;
    edName.SelLength := 0;
  end else
  begin
    for I := 0 to panVarValues.ControlCount - 1 do
    begin
      cntr := panVarValues.Controls[I];
      if cntr.Tag = 1 then
      begin
        TWinControl(cntr).SetFocus;
        if cntr is TEdit then
          TEdit(cntr).SelLength := 0;
        Exit;  
      end;
    end;     
  end;
end;

procedure TMedInputVarForm.OnChangeNumber(Sender: TObject);
var
  L: TLabel;
  V: Double;
  s: string;
begin
  if TEdit(Sender).ComponentCount = 1 then
  begin
    L := TLabel(TControl(Sender).Components[0]);
    s := TEdit(Sender).Text;
    s := FastStringReplace(s, '.', DecimalSeparator);
    s := FastStringReplace(s, ',', DecimalSeparator);

    if TryStrToFloat(s, V) then
      L.Visible := False
    else
      L.Visible := True;
  end;
end;

procedure TMedInputVarForm.OnComboSelect(Sender: TObject);
var
  Idx: Integer;
  s: string;
begin
  Idx := TComboBox(Sender).ItemIndex;
  if Idx >= 0 then
  begin
    s := TComboBox(Sender).Items[Idx];
    if s = sInputCustomText then
    begin
      TComboBox(Sender).Style := csDropDown;
      TComboBox(Sender).Items.Delete(Idx);
      TComboBox(Sender).OnSelect := nil;
      TComboBox(Sender).Text := '';
    end;
  end;  
end;

procedure TMedInputVarForm.ShowVarNamesAndValues(sVarValues: string);
const
  hStep = 27;
var
  ListTypes, ValList: TStringList;
  I, h, MaxLabW, Idx: Integer;
  L: TLabel;
  sType, sValue, s: string;
  cntr: TWinControl;
  dt: TDateTime;
begin
  // Уничтожаем все компоненты с панели
  while panVarValues.ControlCount > 0 do
    panVarValues.Controls[0].Free;

  if Trim(edVarTypes.Text) <> '' then
  begin
    // Определяем подстановочные строки и их типы
    ListTypes := TStringList.Create;
    ValList := TStringList.Create;
    try
      GetVarNameAndTypes(edName.Text, edVarTypes.Text, ListTypes);

      ValList.Text := FastStringReplace(Trim(sVarValues), '|', sLineBreak);

      MaxLabW := 0;

      // Заполняем список наименований переменных
      h := 10;
      for I := 0 to ListTypes.Count - 1 do
      begin
        L := TLabel.Create(panVarValues);
        L.Parent := panVarValues;
        L.Left := 10;
        L.Top := h;
        L.Caption := ListTypes.Names[I] + ':';
        if L.Width > MaxLabW then
          MaxLabW := L.Width;
        Inc(h, hStep);
      end;

      // Заполняем список значений переменных
      h := 10;
      for I := 0 to ListTypes.Count - 1 do
      begin
        sType := ListTypes.ValueFromIndex[I];
        sValue := Trim(ValList.Values[ListTypes.Names[I]]);
        if (sType = 'Число') then
        begin
          cntr := TEdit.Create(panVarValues);
          TEdit(cntr).Text := sValue;
          TEdit(cntr).Width := 100;
          TEdit(cntr).OnChange := OnChangeNumber;          

          L := TLabel.Create(cntr);
          L.Parent := panVarValues;
          L.Caption := '- ошибка!';
          L.Font.Color := clRed;
          L.Font.Style := [fsBold];
          L.Left := MaxLabW + 20 + 100 + 10;
          L.Top := h;
          L.Visible := False;

          TEdit(cntr).OnChange(cntr);

        end else if (sType = 'Дата') then
        begin
          cntr := TDateTimePicker.Create(panVarValues);
          TDateTimePicker(cntr).Date := Now;
          TDateTimePicker(cntr).Width := 105;
          if TryStrToDate(sValue, dt) then
            TDateTimePicker(cntr).Date := dt
          else
            TDateTimePicker(cntr).Date := Now;
        end else if Pos('Выбор:', sType) > 0 then
        begin
          // Определяем варианты, доступные для выбора
          s := Copy(sType, Pos('Выбор:', sType) + 6, MaxWord);
          cntr := TComboBox.Create(panVarValues);
          cntr.Parent := panVarValues;
          TComboBox(cntr).Style := csDropDownList;

          TComboBox(cntr).Items.Text := FastStringReplace(s, '/', sLineBreak);
          Idx := -1;
          if sValue <> '' then
          begin
            Idx := TComboBox(cntr).Items.IndexOf(sValue);
            if Idx < 0 then
              Idx := TComboBox(cntr).Items.Add(sValue);
          end;
          TComboBox(cntr).Items.Add(sInputCustomText);
          if Idx < 0 then
            if TComboBox(cntr).Items.Count > 0 then
              Idx := 0;
          
          TComboBox(cntr).ItemIndex := Idx;
          
          TComboBox(cntr).Width := panVarValues.Width - (MaxLabW + 30);
          TComboBox(cntr).OnSelect := OnComboSelect;
        end else
        begin // Иначе отображаем как простой текст
          cntr := TEdit.Create(panVarValues);
          TEdit(cntr).Text := sValue;
          TEdit(cntr).Width := panVarValues.Width - (MaxLabW + 30);
        end;

        cntr.Parent := panVarValues;
        cntr.Left := MaxLabW + 20;
        cntr.Top := h;
        cntr.Tag := 1; // Значит элемент хранит в себе значение
        cntr.Hint := ListTypes.Names[I];

        Inc(h, hStep);
      end;
    finally
      ListTypes.Free;
      ValList.Free;
    end;
  end;
end;

end.
