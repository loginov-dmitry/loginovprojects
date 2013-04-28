unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TForm3 = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses LangReader;

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
  SetLanguage(nil, LangFileName);
end;

end.
