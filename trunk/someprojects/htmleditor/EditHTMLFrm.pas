{
Copyright (c) 2010, Loginov Dmitry Sergeevich
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

unit EditHTMLFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList;

type
  TEditHTMLForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    ActionList1: TActionList;
    acClose: TAction;
    acCancel: TAction;
    procedure acCloseExecute(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditHTMLForm: TEditHTMLForm;

function ShowEditHTMLForm(var HTMLText: string; CanEdit: Boolean): Boolean;

implementation

{$R *.dfm}

function ShowEditHTMLForm(var HTMLText: string; CanEdit: Boolean): Boolean;
begin
 { with TEditHTMLForm.Create(nil) do
  try
    //memHTML.Text := HTMLText;
    SynEdit1.Text := HTMLText;

    if not CanEdit then
    begin
      Caption := 'Просмотр HTML-текста';
      btnOk.ModalResult := mrNone;
      btnOk.Visible := False;
      btnCancel.Caption := 'Закрыть';
    end;

    Result := ShowModal = mrOk;
    if Result then
       //HTMLText := memHTML.Text;
       HTMLText := SynEdit1.Text;
  finally
    Free;
  end;   }
end;

procedure TEditHTMLForm.acCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TEditHTMLForm.acCloseExecute(Sender: TObject);
begin
  btnOk.Click;
end;

end.
