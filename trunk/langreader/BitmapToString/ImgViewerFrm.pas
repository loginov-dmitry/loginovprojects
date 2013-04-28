unit ImgViewerFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Placemnt;

type
  TImgViewerForm = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    FormPlacement1: TFormPlacement;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImgViewerForm: TImgViewerForm;

implementation

{$R *.dfm}

end.
