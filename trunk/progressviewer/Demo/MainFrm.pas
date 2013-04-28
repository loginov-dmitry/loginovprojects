{
Copyright (c) 2005-2008, Loginov Dmitry Sergeevich
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
