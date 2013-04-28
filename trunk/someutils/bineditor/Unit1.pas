{
Copyright (c) 2005, Loginov Dmitry Sergeevich
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

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin;

type
  TfrmBEdit = class(TForm)
    Memo: TMemo;
    OpenDialog1: TOpenDialog;
    ScrollBar1: TScrollBar;
    Panel1: TPanel;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    butPatch: TButton;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    LabeledEditHEX: TLabeledEdit;
    LabeledEditCHAR: TLabeledEdit;
    labTable: TLabel;
    ToolButton6: TToolButton;
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure butPatchClick(Sender: TObject);
    procedure LabeledEditCHARChange(Sender: TObject);
    procedure LabeledEditHEXChange(Sender: TObject);
    procedure LabeledEditCHARKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MemoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ToolButton6Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AfterOpen(Sender: TObject);
    function GetCursorPosEx(Shift: TShiftState): TPoint;
    function GetFileByte(Address: DWORD; var Res: Byte): Boolean;
    { Public declarations }
  end;



var
  frmBEdit: TfrmBEdit;
  fSize: Integer;
  MaxLineCount: Integer; // Число строк, которые нужну загружать в TMemo
  MemSelStart: Integer;

implementation

uses Unit2, Unit3;

{$R *.dfm}
{Процедура определяет номер строки и номер символа в стороке Memo}

function TfrmBEdit.GetCursorPosEx(Shift: TShiftState): TPoint;
var lAdr: Char;
  I: Byte;
begin
  // Определяем, в какой строке находится курсор
  Result.X := Memo.SelStart div 78;
  StatusBar1.Panels[0].Text := 'Строка: ' + Inttostr(Result.X + 1);

  // Определяем номер символа
  Result.Y := Memo.SelStart mod 78;
  StatusBar1.Panels[1].Text := 'Символ: ' + Inttostr(Result.Y + 1);
  lAdr := #0;
  case Result.Y + 1 of
    11, 12, 13, 61: lAdr := '0';
    14, 15, 16, 62: lAdr := '1';
    17, 18, 19, 63: lAdr := '2';
    20, 21, 22, 64: lAdr := '3';
    23, 24, 25, 65: lAdr := '4';
    26, 27, 28, 66: lAdr := '5';
    29, 30, 31, 67: lAdr := '6';
    32, 33, 34, 68: lAdr := '7';
    35, 36, 37, 69: lAdr := '8';
    38, 39, 40, 70: lAdr := '9';
    41, 42, 43, 71: lAdr := 'A';
    44, 45, 46, 72: lAdr := 'B';
    47, 48, 49, 73: lAdr := 'C';
    50, 51, 52, 74: lAdr := 'D';
    53, 54, 55, 75: lAdr := 'E';
    56, 57, 58, 76: lAdr := 'F';
  end;

  StatusBar1.Panels[2].Text := 'Адрес: ' + Copy(Memo.Lines[Result.X], 1, 7) +
    lAdr;
  StatusBar1.Tag := StrToInt('$' + Copy(Memo.Lines[Result.X], 1, 7) + lAdr);

  if lAdr = '' then begin
    LabeledEditHEX.Enabled := False;
    LabeledEditCHAR.Enabled := False;
    Exit;
  end else begin
    LabeledEditHEX.Enabled := True;
    LabeledEditCHAR.Enabled := True;
  end;

  LabeledEditHEX.Text := '';
  LabeledEditCHAR.Text := '';


  if not GetFileByte(StatusBar1.Tag, I)
    then Exit;


  LabeledEditHEX.Text := Inttohex(I, 2);

  if (i = 0) or (i = $09) or (i = $0D) then
    LabeledEditCHAR.Text := Chr($10) else
    LabeledEditCHAR.Text := Chr(I);

  if ssShift in Shift then begin
    LabeledEditCHAR.SetFocus;
    LabeledEditCHAR.SelectAll
  end;
end;

procedure TfrmBEdit.ScrollBar1Change(Sender: TObject);
var
  Fs: TFileStream;
  StartByte: Integer;
  BytesCount, MaxBytesCount: Integer;
  Ar: array[1..1000] of Byte;
  S, STxt: string;
  I: Integer;
  C: Byte;
  Pos: Integer;
  LastAdr: Integer;
begin
  // По позиции ползунка определяем, с какой строки надо начать
  // считывание инфы из файла

  if ScrollBar1.Max = 1 then StartByte := 0 else
    StartByte := ScrollBar1.Position * 16 - 16;
  MaxBytesCount := MaxLineCount * 16;
  if fSize - StartByte >= MaxBytesCount then BytesCount := MaxBytesCount else
    BytesCount := fSize - StartByte;

  MemSelStart := Memo.SelStart;
  Memo.Clear;
  Fs := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
  Fs.Seek(StartByte, soFromBeginning);
  Pos := Fs.Position;
  Fs.Read(Ar, BytesCount);
  Fs.Free;

  C := 0;
  LastAdr := 0;

  // Цикл заполнения окна Memo
  for I := 1 to BytesCount do begin
    Inc(C);
    S := S + IntToHex(Ar[I], 2) + ' ';
    if (Ar[I] = 0) or (Ar[I] = $09) or (Ar[I] = $0D) or (Chr(Ar[I]) = '')
      then STxt := STxt + Chr($10) else
      STxt := STxt + Chr(Ar[I]);

    if C = 8 then S[Length(S)] := '|';

    if (C = 16) then begin
      Inc(Pos, C);
      Memo.Lines.Append(IntToHex(Pos - 16, 8) + ': ' + S + '| ' + STxt);
      S := '';
      STxt := '';
      C := 0;
      LastAdr := Pos;
    end;

    if (I = BytesCount) and (C > 0) then begin
      while Length(S) < 48 do S := S + ' ';
      Memo.Lines.Append(IntToHex(LastAdr, 8) + ': ' + S + '| ' + STxt);
      Break;
    end; // if
  end; // for
  if MemSelStart > Length(Memo.Text) - 80 then
    MemSelStart := Length(Memo.Text) - 80;
  Memo.SelStart := MemSelStart;
end;

procedure TfrmBEdit.FormCreate(Sender: TObject);
begin
  ScrollBar1.Enabled := False;
end;

procedure TfrmBEdit.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Memo.Text = '' then Exit;
  if Key = 16 then GetCursorPosEx([ssShift]);

  if Key = 38 {Вперед} then begin
    if Memo.SelStart > 76 then Exit;
    if ScrollBar1.Position > 1 then ScrollBar1.Position :=
      ScrollBar1.Position - 1;
  end;
  if Key = 40 {назад} then begin
    if Memo.SelStart < Length(Memo.Text) - 78 then Exit;
    if ScrollBar1.Position < ScrollBar1.Max then ScrollBar1.Position :=
      ScrollBar1.Position + 1;
  end;

  if Key = 36 {Home} then ScrollBar1.Position := 1;
  if Key = 35 {End} then ScrollBar1.Position := ScrollBar1.Max;


  if Key = 33 {PgUp} then
    if ScrollBar1.Position > MaxLineCount then ScrollBar1.Position :=
      ScrollBar1.Position - MaxLineCount;


  if Key = 34 {PgDown} then
    if ScrollBar1.Position < ScrollBar1.Max then ScrollBar1.Position :=
      ScrollBar1.Position + MaxLineCount;
end;

procedure TfrmBEdit.ToolButton3Click(Sender: TObject);
begin
  WinExec('Calc.exe', 1);
end;

procedure TfrmBEdit.AfterOpen(Sender: TObject);
begin
  {Если файл очень большой, то его бессмысленно сразу весь загружать в прогу,
  т.к. может даже не хватить памяти для этого. Будем загружать его по кусочкам}
  Caption := 'Редактор двоичных файлов - ' + OpenDialog1.FileName;
  MaxLineCount := (Memo.Height div Memo.Font.Size) * 60 div 100 - 1;
  fSize := FileSize(OpenDialog1.FileName); // Определяем размер файла

  ScrollBar1.Enabled := True;
  ScrollBar1.PageSize := 1;
  ScrollBar1.LargeChange := 1;
  ScrollBar1.Max := 100;
   // Вычисляем характеристики ScrollBar
  if (fSize div 16 - (MaxLineCount - 2)) > 1 then begin
    ScrollBar1.Max := fSize div 16 - (MaxLineCount - 2);
    ScrollBar1.PageSize := MaxLineCount div ScrollBar1.Max;
    ScrollBar1.LargeChange := MaxLineCount - 1;
  end else begin
    ScrollBar1.Max := 1;
    ScrollBar1.PageSize := 1;
    ScrollBar1.LargeChange := 1;
    ScrollBar1.Enabled := False;
  end;
  ScrollBar1.Position := 0;
  ScrollBar1Change(Sender);
end;

procedure TfrmBEdit.ToolButton1Click(Sender: TObject);
begin
  if not OpenDialog1.Execute then Exit;
  AfterOpen(Sender);
end;

procedure TfrmBEdit.ToolButton5Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TfrmBEdit.ToolButton2Click(Sender: TObject);
begin
  frmFind.Show;
end;

function TfrmBEdit.GetFileByte(Address: DWORD; var Res: Byte): Boolean;
var
  FS: TFileStream;
begin
  Result := True;
  FS := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
  if Address > FS.Size then begin
    FS.Free;
    Result := False;
    Exit;
  end;
  FS.Seek(Address, soFromBeginning);
  FS.Read(Res, 1);
  FS.Free;
end;

procedure TfrmBEdit.butPatchClick(Sender: TObject);
var
  FS: TFileStream;
  B: Byte;
begin
  if LabeledEditHEX.Text = '' then Exit;
  B := Strtoint('$' + LabeledEditHEX.Text);
  FS := TFileStream.Create(OpenDialog1.FileName, fmOpenWrite);
  FS.Seek(StatusBar1.Tag, soFromBeginning);
  FS.Write(B, 1);
  FS.Free;
  ScrollBar1Change(Sender);
end;

procedure TfrmBEdit.LabeledEditCHARChange(Sender: TObject);
begin
  if LabeledEditCHAR.Text = '' then exit;
  LabeledEditHEX.Text := IntToHex(Ord(LabeledEditCHAR.Text[1]), 2);
end;

procedure TfrmBEdit.LabeledEditHEXChange(Sender: TObject);
var
  b: Byte;
begin
  if LabeledEditHEX.Text = '' then exit;
  try
    b := StrToInt('$' + LabeledEditHEX.Text);
  except
    ShowMessage('Введено не 16-ричное число');
    Exit;
  end;

  if (b = 0) or (b = $09) or (b = $0D) then
    LabeledEditCHAR.Text := Chr($10) else
    LabeledEditCHAR.Text := Chr(b);


end;

procedure TfrmBEdit.LabeledEditCHARKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then butPatch.Click;
  if Key = 27 then Memo.SetFocus;
end;

procedure TfrmBEdit.MemoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Memo.Text = '' then Exit;
  try
    GetCursorPosEx(Shift);
  except
    ShowMessage('Ошибочка вышла!!!');
  end;
end;

procedure TfrmBEdit.ToolButton6Click(Sender: TObject);
begin
  WinExec(PChar('notepad ' + ExtractFilePath(ParamStr(0)) + 'readme.txt'), 1);
end;

end.

