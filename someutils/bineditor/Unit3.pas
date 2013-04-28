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

unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmFind = class(TForm)
    EdFindTxt: TEdit;
    GroupBox1: TGroupBox;
    rbText: TRadioButton;
    rbAddress: TRadioButton;
    rbHex: TRadioButton;
    GroupBox2: TGroupBox;
    rbDown: TRadioButton;
    rbUp: TRadioButton;
    btnFind: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure EdFindTxtKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFindClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function AddressToScrollPos(Adr: DWord): Integer;
    //function FindByteArray:Integer;
  end;

var
  frmFind: TfrmFind;
  ByteArHex: array[1..255] of Byte;
  ArLength: 0..255;
  Clos: Boolean = False;
  StopFind: Boolean = False;

  
function FileSize(FileName: string): Integer;
implementation

uses Unit1;




{$R *.dfm}

function FileSize(FileName: string): Integer;
var
  F: HFile; // Для расчета размера
begin
  Result := 0;
  if not FileExists(FileName) then Exit;
  F := _lopen(PChar(FileName), OF_READ);
  Result := _llseek(F, 0, FILE_END);
  _lclose(F);
end;

function StringToHex(HexStr: string): string;
var
  I: WORD;
  HexSet: set of '0'..'f';
begin
  HexSet := ['0'..'9', 'a'..'f', 'A'..'F'];
  if HexStr = '' then Exit;
  // Отфильтровываем все знаки, оставляем только 16-ричные знаки
  for I := 1 to Length(HexStr) do
    if HexStr[I] in HexSet then Result := Result + HexStr[I];
end;

function FindHexStringInFile(
  FileName: string; // Имя файла
  HexString: string; // Строка
  StartByte: DWORD; // Откуда начинать поиск
  TypeFind: Byte // Тип поиска
  ): DWORD;
var
  FS: TFileStream;
  I: Integer;
  PosInFile: DWORD;
  BufferArray: array[1..8192] of Byte; //8192-самое "быстрое" число
  InputArray: array[1..1000] of Byte;
  InputArrayAdd: array[1..1000] of Byte; // Дополнительный массив
  ReadSize: WORD; // Сколько байтов считано в массив
  InputArrayLength: WORD;
  fSize, CurByte: DWORD;
  ToEnd: DWORD; // Сколько байтов осталось до конца файла
  StartByteToRead: DWORD;
  C: WORD;
  S1, S2: string;
begin
// Если TypeFind = 1, то будет искать 16-ричное число
// Если TypeFind = 2, то будет искать текст по точному совпадению
// Если TypeFind = 3, то будет искать текст по "смыслу", т.е. не учитывая
  Result := $FFFFFFFF; // Врядли мы наткнемся на файл такого размера
  InputArrayLength := 0;
  StopFind := False;
  if (FileName = '') or (TypeFind < 1) or (TypeFind > 3) then Exit;
  if not FileExists(FileName) then Exit;
  if TypeFind = 1 then begin
    HexString := StringToHex(HexString);
    if Length(HexString) mod 2 <> 0 then
      Delete(HexString, Length(HexString), 1);
    if HexString = '' then Exit;
    InputArrayLength := Length(HexString) div 2;
    for I := 1 to InputArrayLength do
      InputArray[I] := StrToInt('$' + Copy(HexString, I * 2 - 1, 2));
  end;

  if (TypeFind = 2) then begin
    if HexString = '' then Exit;
    InputArrayLength := Length(HexString);
    for I := 1 to InputArrayLength do
      InputArray[I] := Ord(HexString[I]);
  end;

  if (TypeFind = 3) then begin
    if HexString = '' then Exit;
    InputArrayLength := Length(HexString);
    for I := 1 to InputArrayLength do begin
      S1 := AnsiUpperCase(HexString[I]);
      S2 := AnsiLowerCase(HexString[I]);
      InputArray[I] := Ord(S1[1]);
      InputArrayAdd[I] := Ord(S2[1]);
    end;
  end;
  // Мы перевели входящие данные в массив данных, что облегчит дальнейшую
  // обработку

  fSize := FileSize(FileName); if fSize = 0 then Exit;

  PosInFile := StartByte;
  C := 0;
  FS := TFileStream.Create(FileName, fmOpenRead, fmShareDenyWrite);
  FS.Seek(StartByte, soFromBeginning);


  while FS.Position < fSize do begin
    if (FS.Position - InputArrayLength > PosInFile) then begin
      StartByteToRead := FS.Position - InputArrayLength;
      FS.Seek(StartByteToRead, soFromBeginning);
    end;
    ToEnd := fSize - FS.Position;
    if ToEnd >= 8192 then ReadSize := 8192 else ReadSize := ToEnd;
    PosInFile := FS.Position;
    FS.Read(BufferArray, ReadSize);
    Inc(C);

    // ВНИМАНИЕ - ВИЗУАЛИЗАЦИЯ
    if C > 100 then begin
      C := 0;
      Application.ProcessMessages;
        // В случае чего поиск можно будет остановить нажатием на
        // определенную кнопку
      if StopFind then Break;
    end; // if
    //***
    CurByte := 0;
    if TypeFind in [1, 2] then
      while CurByte < ReadSize do begin
        Inc(CurByte);
        if (BufferArray[CurByte] = InputArray[1])

        then begin
          if InputArrayLength = 1 then begin
            Result := FS.Position - (ReadSize - CurByte) - 1;
            FS.Free;
            Exit;
          end;
          for I := 2 to InputArrayLength do begin
            if BufferArray[CurByte + I - 1] <> InputArray[I] then Break;
            if I = InputArrayLength then begin
              Result := FS.Position - (ReadSize - CurByte) - 1;
              FS.Free;
              Exit;
            end; // if
          end; // for
        end; // if
      end; // while21

    if TypeFind in [3] then
      while CurByte < ReadSize do begin
        Inc(CurByte);
      //if BufferArray[CurByte] in [InputArray[1],InputArrayAdd[1]]
      // В данном случае работа со множествами происходит дольше, чем
      // Простое сравнение, поэтому мы его закомментировали
        if (BufferArray[CurByte] = InputArray[1]) or
          (BufferArray[CurByte] = InputArrayAdd[1])
          then begin
          if InputArrayLength = 1 then begin
            Result := FS.Position - (ReadSize - CurByte) - 1;
            FS.Free;
            Exit;
          end;
          for I := 2 to InputArrayLength do begin
            if (BufferArray[CurByte + I - 1] <> InputArray[I]) and
              (BufferArray[CurByte + I - 1] <> InputArrayAdd[I])
              then Break;
            if I = InputArrayLength then begin
              Result := FS.Position - (ReadSize - CurByte) - 1;
              FS.Free;
              Exit;
            end; // if
          end; // for
        end; // if
      end; // while22
  end; // while
  FS.Free;
end;

procedure TfrmFind.Button1Click(Sender: TObject);
begin
  StopFind := True;
end;

procedure TfrmFind.EdFindTxtKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Escape then Close;
end;

procedure TfrmFind.btnFindClick(Sender: TObject);
var
  SAdr: string;
  Adr: DWord;
  SPos: Integer;
  ByteString: string;
  Iloop: Integer;
  FAdr: DWORD;
  Flag: Byte;
begin
  if rbHex.Checked or rbText.Checked then begin
    frmBEdit.ToolBar1.Enabled := False;
    frmBEdit.ScrollBar1.Enabled := False;
    frmBEdit.Memo.Enabled := False;
    Button2.Enabled := False;
    StopFind := False;
    if rbHex.Checked then Flag := 1;
    if rbText.Checked then Flag := 3;
    FAdr := FindHexStringInFile(frmBEdit.OpenDialog1.FileName, EdFindTxt.Text,
      frmBEdit.ScrollBar1.Position * 16 + 16, Flag);
    Adr := AddressToScrollPos(FAdr);
    Button2.Enabled := True;
    frmBEdit.Memo.Enabled := True;
    frmBEdit.ScrollBar1.Enabled := True;
    frmBEdit.ToolBar1.Enabled := True;
    if FAdr = $FFFFFFFF then Exit;
    frmBEdit.ScrollBar1.Position := Adr;

    SAdr := IntToHex(FAdr, 8);
    SAdr[Length(SAdr)] := '0';
    SPos := Pos(SAdr, frmBEdit.Memo.Text);
    frmBEdit.Memo.SelStart := SPos - 1;
    frmBEdit.Memo.SelLength := 8;
    frmBEdit.Memo.SetFocus;
    Exit;
  end;

  if rbAddress.Checked then begin
    try
      StrToInt('$' + EdFindTxt.Text);
    except Exit end;
    Adr := AddressToScrollPos
      (StrToInt('$' + EdFindTxt.Text));
    frmBEdit.ScrollBar1.Position := Adr;
    SAdr := IntToHex(StrToInt('$' + EdFindTxt.Text), 8);
    SAdr[Length(SAdr)] := '0';
    SPos := Pos(SAdr, frmBEdit.Memo.Text);
    frmBEdit.Memo.SelStart := SPos - 1;
    frmBEdit.Memo.SelLength := 8;
    frmBEdit.Memo.SetFocus;
    Exit;
  end;

end;

function TfrmFind.AddressToScrollPos(Adr: DWord): Integer;
begin
//
  Result := Adr div 16;
end;



procedure TfrmFind.FormShow(Sender: TObject);
begin
  Clos := False;
end;

procedure TfrmFind.Button2Click(Sender: TObject);
begin
  Close;
end;

end.

