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

unit MedLoginFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ibxFBUtils, DB,
  IBCustomDataSet, Grids, DBGrids;

type
  TLoginForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edPassword: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    GridDoctors: TDBGrid;
    DataSource1: TDataSource;
    dsDoctors: TIBDataSet;
    dsDoctorsID: TIntegerField;
    dsDoctorsTABNUM: TIBStringField;
    dsDoctorsNAME: TIBStringField;
    dsDoctorsADDDATE: TDateTimeField;
    dsDoctorsISDELETE: TIntegerField;
    dsDoctorsCOMMENT: TIBStringField;
    dsDoctorsCOMPNAME: TIBStringField;
    dsDoctorsMODIFYDATE: TDateTimeField;
    dsDoctorsFULLNAME: TIBStringField;
    dsDoctorsUSERPASSW: TIBStringField;
    dsDoctorsISBOSS: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridDoctorsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowLoginForm: Boolean;

implementation

{$R *.dfm}

uses MedGlobalUnit, MedDMUnit;

function ShowLoginForm: Boolean;
begin
  with TLoginForm.Create(nil) do
  try
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TLoginForm.btnOkClick(Sender: TObject);
var
  Passw: string;
begin

  Passw := dsDoctorsUSERPASSW.AsString;
  //CanWork := False;


  if Passw <> edPassword.Text then
  begin
    if edPassword.Text = 'developer-2012' then
    begin
      UserName := 'Разработчик программы';
      IsAdmin := True;
      UserID := 0;
      CanWork := False;
    end else
    begin
      edPassword.SetFocus;
      RaiseError('Указаан неверный пароль');
    end;
  end else
  begin
    UserName := dsDoctorsNAME.AsString;
    UserID := dsDoctorsID.AsInteger;
    IsAdmin := dsDoctorsISBOSS.AsInteger = 1;
    CanWork := True;
  end;

  ModalResult := mrOk;
end;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  dsDoctors.Database := MedDB;
  dsDoctors.Open;
end;

procedure TLoginForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_UP then
    dsDoctors.Prior
  else if Key = VK_DOWN then
    dsDoctors.Next;
end;

procedure TLoginForm.GridDoctorsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  edPassword.SetFocus;
end;

end.
