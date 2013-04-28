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
    raise Exception.Create('Сперва необходимо открыть файл с изображением');
    
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
