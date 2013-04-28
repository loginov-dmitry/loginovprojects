unit ErrorMsgFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, AppEvnts;

type
  TErrorMsgForm = class(TForm)
    memoErrorText: TMemo;
    btnAppQuit: TBitBtn;
    btnCancel: TBitBtn;
    ApplicationEvents1: TApplicationEvents;
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure memoErrorTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ErrorMsgForm: TErrorMsgForm;

implementation

{$R *.dfm}

procedure TErrorMsgForm.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  with ErrorMsgForm do
  try
    memoErrorText.Lines.Text :=
      'Произошла ошибка времени выполнения с текстом'#13#10 +
      '<' + E.Message + '>'#13#10 +
      'Хотите завершить работу программы немедленно?';
    ActiveControl := btnCancel;
    Position := poScreenCenter;
    MessageBeep(MB_ICONERROR);
    if ShowModal = mrOK then Application.MainForm.Close;
  except
  end;
end;

procedure TErrorMsgForm.memoErrorTextKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN: btnAppQuit.Click;
    VK_ESCAPE: btnCancel.Click;
  end;       
end;

end.
