{
Copyright (c) 2010, Loginov Dmitry Sergeevich
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
  Dialogs, StdCtrls, FileCtrl, Grids;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ProcessDFM(AFile: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  SDir: string;
begin
  if SelectDirectory('Выберите каталог с проектом Delphi', '', SDir) then
    Edit1.Text := SDir;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  sr: TSearchRec;
  SDir: string;
  AFileList: TStringList;
  I: Integer;
begin
  AFileList := TStringList.Create;
  try
    SDir := IncludeTrailingPathDelimiter(Edit1.Text);
    if FindFirst(SDir + '*.dfm', faAnyFile, sr) = 0 then
    repeat
      if Pos('.dfm', LowerCase(sr.Name)) > 0 then
        AFileList.Add(SDir + sr.Name);
    until FindNext(sr) <> 0;

    if AFileList.Count > 0 then
    begin
      for I := 0 to AFileList.Count - 1 do
        ProcessDFM(AFileList[I]);
      ShowMessage('Завершено');
      //ShowMessage(AFileList.Text);
    end else
      ShowMessage('Не найдено файлов для обработки!');

  finally
    AFileList.Free;
  end;
end;

function FastStringReplace(const S: string; OldPattern: string;
  const NewPattern: string; Flags: TReplaceFlags = [rfReplaceAll]): string;
var
  I, J, Idx: Integer;
  IsEqual: Boolean;
  UpperFindStr: string;
  pS: PChar; // Указатель на массив для сравнения символов
  CanReplace: Boolean;
begin
  if OldPattern = '' then
  begin
    Result := S;
    Exit;
  end;

  Result := '';
  if S = '' then Exit;

  if rfIgnoreCase in Flags then
  begin
    OldPattern := AnsiUpperCase(OldPattern);

    // Для режима "не учитывать регистр" потребуется дополнительная строка
    UpperFindStr := AnsiUpperCase(S);

    pS := PChar(UpperFindStr);
  end else
    pS := PChar(S);

  // Если новая подстрока не превышает старой, то...
  if Length(OldPattern) >= Length(NewPattern) then
  begin
    SetLength(Result, Length(S));
  end else // Точный размер буфера не известен...
    SetLength(Result, (Length(S) + Length(OldPattern) + Length(NewPattern)) * 2);

  I := 1;
  Idx := 0;
  CanReplace := True;
  while I <= Length(S) do
  begin
    IsEqual := False;

    if CanReplace then // Если замена разрешена
    begin
      // Если I-й символ совпадает с OldPattern[1]
      if pS[I - 1] = OldPattern[1] then // Запускаем цикл поиска
      begin
        IsEqual := True;
        for J := 2 to Length(OldPattern) do
        begin
          if pS[I + J - 2] <> OldPattern[J] then
          begin
            IsEqual := False;
            Break; // Прерываем внутренний цикл
          end;
        end;

        // Совпадение найдено! Выполняем замену
        if IsEqual then
        begin
          for J := 1 to Length(NewPattern) do
          begin
            Inc(Idx);

            // Расширяем строку Result при необходимости
            if Idx > Length(Result) then
              SetLength(Result, Length(Result) * 2);

            Result[Idx] := NewPattern[J];
          end;

          // Пропускаем байты в исходной строке
          Inc(I, Length(OldPattern));

          if not (rfReplaceAll in Flags) then
            CanReplace := False; // Запрещаем дальнейшую замену
        end;
      end;
    end;

    // Если подстрока не найдена, то просто копируем символ
    if not IsEqual then
    begin
      Inc(Idx);

      // Расширяем строку Result при необходимости
      if Idx > Length(Result) then
        SetLength(Result, Length(Result) * 2);

      Result[Idx] := S[I];
      Inc(I);
    end;
  end; // while I <= Length(S) do

  // Ограничиваем длину строки-результата
  SetLength(Result, Idx);
end;

procedure TForm1.ProcessDFM(AFile: string);
var
  AList: TStringList;
  I, J: Integer;
begin
  AList := TStringList.Create;
  try
    AList.LoadFromFile(AFile);
    for I := AList.Count - 1 downto 0 do
    begin
      
      if Pos(' Explicit', AList[I]) > 0 then
      begin // Удаляем строки, в которых встретится Explicit
        AList.Delete(I);
      end else if (Pos('goFixedColClick', AList[I]) > 0) or (Pos('goFixedRowClick', AList[I]) > 0) then
      begin
        AList[I] := FastStringReplace(AList[I], 'goFixedColClick', '');
        AList[I] := FastStringReplace(AList[I], 'goFixedRowClick', '');
        AList[I] := FastStringReplace(AList[I], ', ,', ',');
        AList[I] := FastStringReplace(AList[I], ', ]', ']');
      end else if (Pos(' Marks.Arrow', AList[I]) > 0) or (Pos(' Marks.Callout', AList[I]) > 0) then
      begin
        AList.Delete(I);
      end;
    end;
          //goFixedColClick, goFixedRowClick
    // Ищем строку "DesignSize = ("
    for I := AList.Count - 1 downto 0 do
    begin
      // Удаляем строки, в которых встретится Explicit
      if Pos('DesignSize = (', AList[I]) > 0 then
      begin
        // Теперь нужно отыскать закрывающую скобку
        J := 1;
        while Pos(')', AList[I + J]) < 1 do
          Inc(J);
        Inc(J);

        while J > 0 do
        begin
          AList.Delete(I);
          Dec(J);
        end;
      end;
    end;

   // AList.SaveToFile(AFile + '_');
   RenameFile(AFile, ChangeFileExt(AFile, '.old_dfm'));
   AList.SaveToFile(AFile);
  finally
    AList.Free;
  end;


end;

end.
