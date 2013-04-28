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

unit U_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, ExtDlgs, FractalCompression, ComCtrls;

type
  TForm1 = class(TForm)
    ImPreview: TImage;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Button2: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    lbSize: TLabel;
    CheckBox1: TCheckBox;
    ProgressBar1: TProgressBar;
    Button4: TButton;
    Button5: TButton;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Edit3: TEdit;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Button6: TButton;
    Label6: TLabel;
    Edit4: TEdit;
    Button7: TButton;
    Button8: TButton;
    Label7: TLabel;
    Bevel1: TBevel;
    CheckBox2: TCheckBox;
    Label3: TLabel;
    Bevel2: TBevel;
    Label8: TLabel;
    Edit5: TEdit;
    Label9: TLabel;
    lbTime: TLabel;
    Button9: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ImageExists: Boolean;
    procedure ProgressProc(Percent: Integer; TimeRemain: Cardinal);
  end;

var
  Form1: TForm1;
  FractalComp: TFractal;
  FractalDeComp: TFractal;

implementation

uses U_ShowImage;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    try
      ImPreview.Picture.LoadFromFile(OpenPictureDialog1.FileName);
      if (ImPreview.Picture.Width > 512) or (ImPreview.Picture.Height > 512) then Abort;
      lbSize.Caption := Format('%d x %d', [ImPreview.Picture.Width, ImPreview.Picture.Height]);
      ImageExists := True;

      // Загружаем изображение в объект исключительно в целях реализации
      // операции предпросмотра

      FractalComp.RegionSize := StrToInt(Edit3.Text);
      FractalComp.LoadImage(ImPreview.Picture.Bitmap);
      Edit1.Text := OpenPictureDialog1.FileName;
    except
      on E: Exception do
      begin
        ImPreview.Picture := nil;
        ImPreview.Canvas.TextOut(5, 10, 'Ошибка');
        ImPreview.Canvas.TextOut(5, 30, 'загрузки');
        Edit1.Text := 'Изображение не выбрано!';
        lbSize.Caption := '';
        ImageExists := False;
        ShowMessage(E.Message);
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ImPreview.Canvas.TextOut(5, 10, 'Изображение');
  ImPreview.Canvas.TextOut(5, 30, 'отсутствует');

  FractalComp := TFractal.Create(Application);
  FractalDeComp := TFractal.Create(Application);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  // Показывает изображение на экране полностью.
  if ImageExists then
  begin
    Application.CreateForm(TfmShowImage, fmShowImage);
    if CheckBox1.Checked then
      FractalComp.DrawImage(fmShowImage.Image1.Picture.Bitmap, False)
    else
      fmShowImage.Image1.Picture := ImPreview.Picture;

    with fmShowImage do
    begin
      AutoSize := True;
      Position := poScreenCenter;

      Caption := Format('%d x %d', [fmShowImage.Image1.Picture.Bitmap.Width,
        fmShowImage.Image1.Picture.Bitmap.Height]);
      ShowModal;
    end;

    FreeAndNil(fmShowImage);
  end;
end;

procedure TForm1.ProgressProc(Percent: Integer; TimeRemain: Cardinal);
begin
  ProgressBar1.Position := Percent;
  lbTime.Caption := IntToStr(TimeRemain);
  Application.ProcessMessages;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if ImageExists then
  begin
    FractalComp.RegionSize := StrToInt(Edit3.Text);
    FractalComp.DomainOffset := StrToInt(Edit2.Text);

    FractalComp.LoadImage(ImPreview.Picture.Bitmap);
    FractalComp.Compress(CheckBox2.Checked, ProgressProc);

    ProgressBar1.Position := 0;
    lbTime.Caption := '';
  end;     
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  OpenDialog1.Title := 'Сохранение IFS-данных';
  if OpenDialog1.Execute then
    FractalComp.SaveToFile(OpenDialog1.FileName);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  OpenDialog1.Title := 'Загрузка IFS-данных';
  if OpenDialog1.Execute then
    FractalDeComp.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  FractalDeComp.Decompress(StrToInt(Edit4.Text), StrToInt(Edit5.Text));
  // Показывает изображение на экране полностью.

  Application.CreateForm(TfmShowImage, fmShowImage);
  FractalDeComp.DrawImage(fmShowImage.Image1.Picture.Bitmap);


  with fmShowImage do
  begin
    AutoSize := True;
    Position := poScreenCenter;
    ShowModal;
  end;

  FreeAndNil(fmShowImage);

end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  FractalComp.BuildImageWithDomains;

  Application.CreateForm(TfmShowImage, fmShowImage);
  FractalComp.DrawImage(fmShowImage.Image1.Picture.Bitmap);


  with fmShowImage do
  begin
    AutoSize := True;
    Position := poScreenCenter;
    ShowModal;
  end;

  FreeAndNil(fmShowImage);  
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  FractalComp.Stop;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  ShowMessage('Приблизительно: ' + IntToStr(FractalComp.GetIFSFileSize) + ' байт');
end;

end.
