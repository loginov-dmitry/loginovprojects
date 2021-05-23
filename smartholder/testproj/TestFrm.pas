unit TestFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SmartHolder, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TMyObj = class
  public
    ObjNum: Integer;
    constructor Create;
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  h: TSmartHolder;
  Objs: array of TMyObj;
  I: Integer;
begin
  SetLength(Objs, 100);
  for I := 0 to High(Objs) do
    Objs[I] := h.RegObj(TMyObj.Create) as TMyObj;
  ShowMessage('Object created. Press ok!');
  for I := 0 to High(Objs) do
    if Odd(I) then
      h.FreeObj(Objs[I]);
  ShowMessage('Odd objects destroyed. Press ok!');
  h.Clear;
  ShowMessage('All objects destroyed!');
end;

{ TMyObj }

var
  GlobalObjNum: Integer;

constructor TMyObj.Create;
begin
  Inc(GlobalObjNum);
  ObjNum := GlobalObjNum;
  Form1.Memo1.Lines.Add(Format('Obj #%d - Create', [ObjNum]));
end;

destructor TMyObj.Destroy;
begin
  Form1.Memo1.Lines.Add(Format('Obj #%d - Destroy', [ObjNum]));
  inherited;
end;

end.
