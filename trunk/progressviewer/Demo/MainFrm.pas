unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ProgressViewer, StdCtrls;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Button1Click(Sender: TObject);
begin
  with TProgressViewer.Create('Визуализация без процентов', False) do
  try
    AddStringInfo(1, 'Нажатие клавиши Escape ни к чему не приведет! '+
      'Полезно в случаях, когда мы не знаем, сколько времени уйдет на завершение '+
      'операции. Пример - выполнение сложного SELECT-запроса.', taRightJustify,
      True, clBlue, [fsBold], 10);
    Sleep(10000); // Здесь выполняется длительная операция
  finally
    Terminate;
  end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  with TProgressViewer.Create('Визуализация с процентами', True) do
  try
    AddStringInfo(1, 'Нажатие клавишу Escape для отмены'+
      ' выполняемой в данный момент операции!', taRightJustify,
      True, clGreen, [fsBold], 10);
    for I := 1 to 1000 do
    begin
      CurrentValue := I / 10;
      if CancelByUser then Break;
      Sleep(1); // Задержка, чтобы окно не исчезло сразу же
    end;
  finally
    Terminate;
  end;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  I: Integer;
begin
  with TProgressViewer.Create('Визуализация с процентами', True, True) do
  try
    AddStringInfo(1, 'Нажатие клавишу Escape или кнопку "Отмена" для отмены'+
      ' выполняемой в данный момент операции!', taRightJustify,
      True, clGreen, [fsBold], 10);
      
    ChangeStringInfo(1, [sipAlignment, sipFontStyles, sipFontSize, sipFontName],
      [taLeftJustify, FontStylesToInt([fsBold, fsItalic]), 16, 'Courier']);   

    for I := 1 to 1000 do
    begin
      CurrentValue := I / 10;
      //if CancelByUser then Break;
      CheckCancelByUser;
      Sleep(1); // Задержка, чтобы окно не исчезло сразу же
    end;
  finally
    Terminate;
  end;

end;

end.
