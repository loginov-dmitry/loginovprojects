{
Copyright (c) 2006-2009, Loginov Dmitry Sergeevich
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

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Menus, LangReader, Buttons, ImgList,
  ComCtrls, ToolWin, JPEG;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    Button3: TButton;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    LabeledEdit1: TLabeledEdit;
    Button1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
    Messages: TTextMessages;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  
implementation

uses Unit2, Unit3;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Messages := TTextMessages.Create;
  // Заполняем строковые переменные значениями по умолчанию
  Messages['SFileNotFound'] := 'Файл не найден';
  Messages['SBnt1Click'] := 'Вы нажали кнопку 1';
  Messages['SBnt2Click'] := 'Вы нажали кнопку 2';

  LangFileName := ExtractFilePath(ParamStr(0)) + 'Russian.lng';
  SetLanguage(Self, LangFileName);
  Messages.LoadFromFile(LangFileName, 'Messages');

  with TButton.Create(Application) do
  begin
    Name := 'NewButton';
    Caption := 'Дочерняя кнопка';
    Width := 100;
    Parent := Self;
  end;


end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  with TForm2.Create(Application) do
  try
    ListBox1.ItemIndex := 0;
    if (ShowModal = mrOK) and (ListBox1.ItemIndex >= 0) then
    begin
      LangFileName := ExtractFilePath(ParamStr(0)) +
        ListBox1.Items[ListBox1.ItemIndex];

      SetLanguage(nil, LangFileName);
      Messages.LoadFromFile(LangFileName, 'Messages');
    end;
  finally
    Free;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Application.MessageBox(
    Messages.PMsg['SBnt1Click'],
    'Test',
    MB_ICONINFORMATION);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Application.MessageBox(
    Messages.PMsg['SBnt2Click'],
    'Test',
    MB_ICONINFORMATION);
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  Application.MessageBox(
    Messages.PMsg['SFileNotFound'],
    'Test',
    MB_ICONINFORMATION);
end;

initialization
  GraphicFormats.AddObject('TJPEGImage', TObject(TJPEGImage));

end.
