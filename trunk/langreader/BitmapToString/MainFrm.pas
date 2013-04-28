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

unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtDlgs, ExtCtrls, ClipBrd, ComCtrls, JPEG, LangReader,
  Placemnt, Mask, ToolEdit, IniFiles;

type
  TForm1 = class(TForm)
    Button2: TButton;
    opDialog1: TOpenPictureDialog;
    GroupBox1: TGroupBox;
    FormStorage1: TFormStorage;
    FilenameEdit1: TFilenameEdit;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    ComboBox1: TComboBox;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Button5: TButton;
    Button6: TButton;
    Edit3: TEdit;
    Label4: TLabel;
    Button7: TButton;
    Button8: TButton;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ImgViewerFrm;

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
  if opDialog1.Execute then
    Image1.Picture.LoadFromFile(opDialog1.FileName);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  MS: TMemoryStream;
  CName: string[63];
  S: string;
begin
  if Image1.Picture.Graphic = nil then
    raise Exception.Create('������ ���������� ������� ���� � ������������');
    
  MS := TMemoryStream.Create;
  try
    if ComboBox1.ItemIndex = 0 then
    begin
      CName := Image1.Picture.Graphic.ClassName;
      MS.Write(CName, Length(CName) + 1);
    end;
    Image1.Picture.Graphic.SaveToStream(MS);
    S := StreamToStr(MS);
    with TMemIniFile.Create(FilenameEdit1.Text) do
    try
      WriteString(Edit1.Text, Edit2.Text, S);
      UpdateFile;
    finally
      Free;
    end;
  finally
    MS.Free;
  end; 
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  with TMemIniFile.Create(FilenameEdit1.Text) do
  try
    DeleteKey(Edit1.Text, Edit2.Text);
    UpdateFile;
  finally
    Free;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  with TMemIniFile.Create(FilenameEdit1.Text) do
  try
    WriteString(Edit1.Text, Edit2.Text, Edit3.Text);
    UpdateFile;
  finally
    Free;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  with TMemIniFile.Create(FilenameEdit1.Text) do
  try
    Edit3.Text := ReadString(Edit1.Text, Edit2.Text, '');
  finally
    Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  S: string;
begin
  with TMemIniFile.Create(FilenameEdit1.Text) do
  try
    S := ReadString(Edit1.Text, Edit2.Text, '');
  finally
    Free;
  end;

  with TMemIniFile.Create(ChangeFileExt(ParamStr(0), '.img')) do
  try
    WriteString('TImgViewerForm', 'Image1.Picture', S);
    UpdateFile;
  finally
    Free;
  end;

  SetLanguage(ImgViewerForm, ChangeFileExt(ParamStr(0), '.img'));
  ImgViewerForm.Show;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  KeepLngFiles := False;
  GraphicFormats.AddObject('TJPEGImage', TObject(TJPEGImage));
end;                    

end.
