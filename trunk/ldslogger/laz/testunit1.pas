unit TestUnit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LDSLogger;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

  { TMyThread }

  TMyThread = class(TThread)
  protected
    procedure Execute; override;
  end;

var
  Form1: TForm1;
  Log: TLDSLogger;

implementation

{ TMyThread }

procedure TMyThread.Execute;
begin

end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
  //Log.LogStr('Строка');
  //LDSLoggerMaxLazyBufSize := 50000;
  for i := 1 to 100000 do
  begin
    Log.LogStr('Строка №' + IntToStr(i));
    if i mod 1000 = 0 then
    begin
      caption := IntToStr(i);
      Application.ProcessMessages;
    end;
  end;

end;

initialization
  Log := TLDSLogger.Create(ExtractFilePath(Application.ExeName) + '???\' + 'TestLog.log');
  //Log := TLDSLogger.Create('TestLog.log');
  //Log.LazyWrite := True;
finalization
  Log.Free;
end.

