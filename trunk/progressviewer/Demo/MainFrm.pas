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
  with TProgressViewer.Create('������������ ��� ���������', False) do
  try
    AddStringInfo(1, '������� ������� Escape �� � ���� �� ��������! '+
      '������� � �������, ����� �� �� �����, ������� ������� ����� �� ���������� '+
      '��������. ������ - ���������� �������� SELECT-�������.', taRightJustify,
      True, clBlue, [fsBold], 10);
    Sleep(10000); // ����� ����������� ���������� ��������
  finally
    Terminate;
  end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  with TProgressViewer.Create('������������ � ����������', True) do
  try
    AddStringInfo(1, '������� ������� Escape ��� ������'+
      ' ����������� � ������ ������ ��������!', taRightJustify,
      True, clGreen, [fsBold], 10);
    for I := 1 to 1000 do
    begin
      CurrentValue := I / 10;
      if CancelByUser then Break;
      Sleep(1); // ��������, ����� ���� �� ������� ����� ��
    end;
  finally
    Terminate;
  end;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  I: Integer;
begin
  with TProgressViewer.Create('������������ � ����������', True, True) do
  try
    AddStringInfo(1, '������� ������� Escape ��� ������ "������" ��� ������'+
      ' ����������� � ������ ������ ��������!', taRightJustify,
      True, clGreen, [fsBold], 10);
      
    ChangeStringInfo(1, [sipAlignment, sipFontStyles, sipFontSize, sipFontName],
      [taLeftJustify, FontStylesToInt([fsBold, fsItalic]), 16, 'Courier']);   

    for I := 1 to 1000 do
    begin
      CurrentValue := I / 10;
      //if CancelByUser then Break;
      CheckCancelByUser;
      Sleep(1); // ��������, ����� ���� �� ������� ����� ��
    end;
  finally
    Terminate;
  end;

end;

end.
