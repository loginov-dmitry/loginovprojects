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

unit MedInputDataFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, DateUtils, MedGlobalUnit,
  OleCtrls, SHDocVw, MSHTML, ibxFBUtils;

type
  TMedInputDataForm = class(TForm)
    Label1: TLabel;
    edPatFIO: TEdit;
    Label2: TLabel;
    dtpPatBirthDay: TDateTimePicker;
    Panel1: TPanel;
    cbPatIsMan: TRadioButton;
    cbPatIsGirl: TRadioButton;
    Label3: TLabel;
    dtpCheckInDate: TDateTimePicker;
    Panel2: TPanel;
    Label4: TLabel;
    dtpCheckOutDate: TDateTimePicker;
    Label5: TLabel;
    cbDoctorFIO: TComboBox;
    Label6: TLabel;
    memDiagnoz: TMemo;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label7: TLabel;
    Timer1: TTimer;
    Label8: TLabel;
    edNumber: TEdit;
    Panel4: TPanel;
    wb: TWebBrowser;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure wbDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
  private
    { Private declarations }
    FPreviewText: string;
    HTMLDisp: IDispatch;
    HTMLEditor: IHTMLDocument2;


    procedure SetPreviewText(s: string);
    function GetMainInfo: TMainCheckOutInfo;

    procedure FillDoctorList;
  public
    { Public declarations }
  end;

var
  MedInputDataForm: TMedInputDataForm;

function InputMainCheckOutData(var MainInfo: TMainCheckOutInfo): Boolean;

implementation

{$R *.dfm}

function InputMainCheckOutData(var MainInfo: TMainCheckOutInfo): Boolean;
var
  Idx: Integer;
begin
  with TMedInputDataForm.Create(nil) do
  try

    edNumber.Text := MainInfo.Number;
    edPatFIO.Text := MainInfo.PatFIO;
    dtpPatBirthDay.Date := MainInfo.PatBirthDay;
    if MainInfo.PatSex = 'f' then
      cbPatIsGirl.Checked := True
    else
      cbPatIsMan.Checked := True;


    dtpCheckInDate.Date := MainInfo.DateIn;

    dtpCheckOutDate.Date := MainInfo.DateOut;

    memDiagnoz.Text := MainInfo.Diagnos;

    Idx := cbDoctorFIO.Items.IndexOfObject(TObject(MainInfo.DoctorID));
    cbDoctorFIO.ItemIndex := Idx;

    Result := ShowModal = mrOk;
    if Result then
    begin
      MainInfo := GetMainInfo;

      {
      MainInfo.Number := Trim(edNumber.Text);
      MainInfo.PatFIO := Trim(edPatFIO.Text);
      MainInfo.PatBirthDay := Trunc(dtpPatBirthDay.Date);
      if cbPatIsMan.Checked then
        MainInfo.PatSex := 'm'
      else
        MainInfo.PatSex := 'f';
      MainInfo.DateIn := Trunc(dtpCheckInDate.Date);
      MainInfo.DateOut := Trunc(dtpCheckOutDate.Date);
      MainInfo.Diagnos := Trim(memDiagnoz.Text);

      if cbDoctorFIO.ItemIndex >= 0 then
        MainInfo.DoctorID := Integer(cbDoctorFIO.Items.Objects[cbDoctorFIO.ItemIndex])
      else
        MainInfo.DoctorID := 0;
      }
    end;

  finally
    Free;
  end;
end;

procedure TMedInputDataForm.FillDoctorList;
begin
  with fb.CreateAndOpenTable(MedDB, TranR, 'DOCTORS', 'ISDELETE=0', 'ISBOSS, NAME', [], [], nil) do
  try
    while not Eof do
    begin
      cbDoctorFIO.Items.AddObject(FieldByName('FULLNAME').AsString,
                                  TObject(FieldByName('ID').AsInteger));
      Next;
    end;
  finally
    Free;
  end;

end;

procedure TMedInputDataForm.FormCreate(Sender: TObject);
var
  B: Boolean;
begin
  FillDoctorList;
  B := True;
  wb.Navigate(TempHtmlFile, B);
end;

function TMedInputDataForm.GetMainInfo: TMainCheckOutInfo;
begin
  Result.Number := Trim(edNumber.Text);
  Result.PatFIO := Trim(edPatFIO.Text);
  Result.PatBirthDay := Trunc(dtpPatBirthDay.Date);
  if cbPatIsMan.Checked then
    Result.PatSex := 'm'
  else
    Result.PatSex := 'f';
  Result.DateIn := Trunc(dtpCheckInDate.Date);
  Result.DateOut := Trunc(dtpCheckOutDate.Date);
  Result.Diagnos := Trim(memDiagnoz.Text);

  if cbDoctorFIO.ItemIndex >= 0 then
    Result.DoctorID := Integer(cbDoctorFIO.Items.Objects[cbDoctorFIO.ItemIndex])
  else
    Result.DoctorID := 0;
end;

procedure TMedInputDataForm.SetPreviewText(s: string);
begin
  if (s <> FPreviewText) and Assigned(HTMLEditor) and Assigned(HTMLEditor.body) then
  begin
    FPreviewText := s;
    HTMLEditor.body.innerHTML := s;
  end;
end;

procedure TMedInputDataForm.Timer1Timer(Sender: TObject);
begin
  SetPreviewText(GetMainCheckOutInfoAsString(GetMainInfo));
end;

procedure TMedInputDataForm.wbDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  HTMLDisp := pDisp;
  HTMLEditor := (pDisp as IWebBrowser).Document as IHTMLDocument2;
end;

end.
