program bmp2str;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {Form1},
  ImgViewerFrm in 'ImgViewerFrm.pas' {ImgViewerForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TImgViewerForm, ImgViewerForm);
  Application.Run;
end.
