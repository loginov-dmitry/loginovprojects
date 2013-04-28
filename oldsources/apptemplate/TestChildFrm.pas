{
Copyright (c) 2003-2006, Loginov Dmitry Sergeevich
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

unit TestChildFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Hints;

type
  TExWinControl = class(TWinControl);

  TTestChildForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    btbtnOk: TBitBtn;
    btbtnCancel: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure btbtnOkClick(Sender: TObject);
    procedure btbtnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TestChildForm: TTestChildForm;

implementation

{$R *.dfm}

procedure TTestChildForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin         
  Action := caFree;
end;

procedure TTestChildForm.Edit1Exit(Sender: TObject);
begin
  if (Edit1.Text = '') and (not btbtnCancel.Focused) then
    Hints.ShowErrorHintEx(Edit1, 'Вы должны ввести свои ФИО');
end;

procedure TTestChildForm.Edit2Exit(Sender: TObject);
begin
  if ((Edit2.Text='') or not(Edit2.Text[1] in ['М', 'Ж'])) and
    (not btbtnCancel.Focused) then
    Hints.ShowErrorHintEx(Edit2, 'Вы должны ввести свой пол!');
end;

procedure TTestChildForm.Edit3Exit(Sender: TObject);
var
  I: Integer;
begin
  if not TryStrToInt(Edit3.Text, I) and (not btbtnCancel.Focused) then
    Hints.ShowErrorHintEx(Edit3, 'Вы должны указать свой рост!');
end;

procedure TTestChildForm.Edit4Exit(Sender: TObject);
var
  I: Integer;
begin
  if not TryStrToInt(Edit4.Text, I) and (not btbtnCancel.Focused) then
    Hints.ShowErrorHintEx(Edit4, 'Вы должны указать свой вес!');
end;

procedure TTestChildForm.btbtnOkClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TEdit then
      TExWinControl(Components[I]).DoExit;

  btbtnOk.SetFocus;
  Close;
end;

procedure TTestChildForm.btbtnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
