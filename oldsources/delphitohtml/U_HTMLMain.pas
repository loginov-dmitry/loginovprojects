{
Copyright (c) 2005-2007, Loginov Dmitry Sergeevich
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

unit U_HTMLMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DelphiToHTML, Buttons;

type
  TfmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel4: TPanel;
    Panel5: TPanel;
    Splitter1: TSplitter;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    CheckBox1: TCheckBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure Button7Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses U_Dialog;

{$R *.dfm}

procedure TfmMain.Button7Click(Sender: TObject);
begin
  Memo1.PasteFromClipboard();
end;

procedure TfmMain.Button4Click(Sender: TObject);
begin
  Memo2.CopyToClipboard();
end;

procedure TfmMain.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfmMain.Button5Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Memo2.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfmMain.Button6Click(Sender: TObject);
begin
  Close();
end;

procedure TfmMain.Button3Click(Sender: TObject);
begin
  with TDelphiToHTML.Create, fmFontDialog do
  begin
    Bcom := Edit7.Text;
    ECom := Edit8.Text;
    Bres := Edit5.Text;
    Eres := Edit6.Text;
    Bnum := Edit1.Text;
    Enum := Edit2.Text;
    Bstr := Edit3.Text;
    Estr := Edit4.Text;
    Bdir := Edit9.Text;
    Edir := Edit10.Text;
    Memo2.Text := Convert(Memo1.Text, fmMain.CheckBox1.Checked);
  end;
end;

procedure TfmMain.Button2Click(Sender: TObject);
begin
  fmFontDialog.ShowModal;
end;

procedure TfmMain.Button8Click(Sender: TObject);
var
  Dir: string;
begin
  Dir := ExtractFilePath(ParamStr(0));
  Memo2.Lines.SaveToFile('Tempfile.html');
  WinExec('explorer Tempfile.html', 1);
end;

procedure TfmMain.SpeedButton1Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TfmMain.SpeedButton2Click(Sender: TObject);
begin
  Memo2.Clear;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 112 then
    Memo1.Clear;
  if Key = 113 then
    Memo2.Clear;
end;

end.

