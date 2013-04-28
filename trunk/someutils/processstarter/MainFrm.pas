{
Copyright (c) 2008, Loginov Dmitry Sergeevich
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
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    edProcName: TEdit;
    Label3: TLabel;
    edFileName: TEdit;
    Label4: TLabel;
    edDirName: TEdit;
    Label5: TLabel;
    edParams: TEdit;
    btnAdd: TButton;
    Button2: TButton;
    btnRewrite: TButton;
    ScrollBox1: TScrollBox;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnRewriteClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    cbList: TList;

    procedure ReadProcessListFromIni;

    function ReadMaskFromCheckBox: Cardinal;

    procedure SetCheckBoxState(AMask: Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  IniFileName: string;

implementation

uses IniFiles;

{$R *.dfm}

function MyQuotedStr(S: string): string;
begin
  Result := '';
  if S <> '' then
    Result := AnsiQuotedStr(S, '`');
end;

function MyDequotedStr(S: string): string;
begin
  Result := AnsiDequotedStr(S, '`');
  if Result = '''''' then
    Result := '';
end;

function GetCPUCount(AMask: Cardinal): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to 31 do
    if Odd(AMask shr I) then
      Result := I + 1;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Mask1, Mask2: Cardinal;
  I: Integer;
  CheckBox: TCheckBox;
begin
  IniFileName := ExtractFilePath(ParamStr(0)) + 'Config.ini';

  // Определяем число процессоров на данной машине
  GetProcessAffinityMask(GetCurrentProcess, Mask1, Mask2);

  cbList := TList.Create;

  for I := 0 to GetCPUCount(Mask1) - 1 do
  begin
    CheckBox := TCheckBox.Create(Self);
    CheckBox.Parent := ScrollBox1;
    CheckBox.Left := 10 + I * 60;
    CheckBox.Top := 10;
    CheckBox.Caption := 'CPU' + IntToStr(I);
    cbList.Add(CheckBox);
  end;

  SetCheckBoxState(Mask1);

  ReadProcessListFromIni;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cbList.Free;
end;

procedure TForm1.ReadProcessListFromIni;
var
  I, ItemCount: Integer;
begin
  ListBox1.Clear;

  with TIniFile.Create(IniFileName) do
  try
    ItemCount := ReadInteger('ProcessInfo', 'ItemCount', 0);
    for I := 0 to ItemCount - 1 do
      ListBox1.Items.AddObject(MyDequotedStr(ReadString('ProcessInfo',
        'Process' + IntToStr(I) + '_Name', 'n/a')), TObject(I));
  finally
    Free;
  end;

  if ItemCount > 0 then
    ListBox1.ItemIndex := 0;
  ListBox1Click(nil);
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  Prefix: string;
begin
  if ListBox1.ItemIndex >= 0 then
    with TIniFile.Create(IniFileName) do
    try
      Prefix := 'Process' + IntToStr(Integer(ListBox1.Items.Objects[ListBox1.ItemIndex]));
      edProcName.Text := MyDequotedStr(ReadString('ProcessInfo', Prefix + '_Name', 'n/a'));
      edFileName.Text := MyDequotedStr(ReadString('ProcessInfo', Prefix + '_File', 'n/a'));
      edDirName.Text := MyDequotedStr(ReadString('ProcessInfo', Prefix + '_WorkDir', 'n/a'));
      edParams.Text := MyDequotedStr(ReadString('ProcessInfo', Prefix + '_Params', 'n/a'));
      SetCheckBoxState(ReadInteger('ProcessInfo', Prefix + '_CPUMask', 0));
    finally
      Free;
    end;
end;

procedure TForm1.btnAddClick(Sender: TObject);
var
  NewIndex: Integer;
  Prefix: string;
begin
  if ListBox1.Items.IndexOf(edProcName.Text) >= 0 then
    raise Exception.Create('Данный пункт уже есть!');

  if Trim(edProcName.Text) = '' then
    raise Exception.Create('Имя программы задано неверно!');

  with TIniFile.Create(IniFileName) do
  try
    NewIndex := ReadInteger('ProcessInfo', 'ItemCount', 0);
    WriteInteger('ProcessInfo', 'ItemCount', NewIndex + 1);
    Prefix := 'Process' + IntToStr(NewIndex);
    WriteString('ProcessInfo', Prefix + '_Name', MyQuotedStr(edProcName.Text));
    WriteString('ProcessInfo', Prefix + '_File', MyQuotedStr(edFileName.Text));
    WriteString('ProcessInfo', Prefix + '_WorkDir', MyQuotedStr(edDirName.Text));
    WriteString('ProcessInfo', Prefix + '_Params', MyQuotedStr(edParams.Text));
    WriteInteger('ProcessInfo', Prefix + '_CPUMask', ReadMaskFromCheckBox);
    ListBox1.ItemIndex := ListBox1.Items.AddObject(edProcName.Text, TObject(NewIndex));
  finally
    Free;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFileDir(edFileName.Text);

  if OpenDialog1.Execute then
  begin
    if not FileExists(OpenDialog1.FileName) then
      raise Exception.CreateFmt('Файл "%s" не найден!', [OpenDialog1.FileName]);

    edFileName.Text := OpenDialog1.FileName;

    if ExtractFileDir(edFileName.Text) <> edDirName.Text then
      if Application.MessageBox(PChar(Format(
        'Хотите установить "%s" в качестве рабочей папки приложения?',
        [ExtractFileDir(edFileName.Text)])),
        'Внимание!', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then
        edDirName.Text := ExtractFileDir(edFileName.Text);
  end;
    
end;

procedure TForm1.btnRewriteClick(Sender: TObject);
var
  Index: Integer;
  Prefix: string;

  function ItemExists(ItemName: string): Boolean;
  var
    I: Integer;
  begin
    Result := True;
    for I := 0 to ListBox1.Items.Count - 1 do
      if (I <> ListBox1.ItemIndex) and (ListBox1.Items[I] = ItemName) then Exit;
    Result := False;
  end;
begin
  if Trim(edProcName.Text) = '' then
    raise Exception.Create('Имя программы задано неверно!');

  if ListBox1.ItemIndex < 0 then
    raise Exception.Create('Необходимо сначала выбрать программу из списка!');

  if ItemExists(edProcName.Text) then
    raise Exception.Create('Программа с таким именем уже есть в списке!');

  with TIniFile.Create(IniFileName) do
  try
    Index := Integer(ListBox1.Items.Objects[ListBox1.ItemIndex]);
    Prefix := 'Process' + IntToStr(Index);
    WriteString('ProcessInfo', Prefix + '_Name', MyQuotedStr(edProcName.Text));
    WriteString('ProcessInfo', Prefix + '_File', MyQuotedStr(edFileName.Text));
    WriteString('ProcessInfo', Prefix + '_WorkDir', MyQuotedStr(edDirName.Text));
    WriteString('ProcessInfo', Prefix + '_Params', MyQuotedStr(edParams.Text));
    WriteInteger('ProcessInfo', Prefix + '_CPUMask', ReadMaskFromCheckBox);
    ListBox1.Items[ListBox1.ItemIndex] := edProcName.Text;
  finally
    Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then Exit;

  if ListBox1.ItemIndex <> ListBox1.Items.Count - 1 then
    raise Exception.Create('Удалить можно только последний элемент списка!');

  with TIniFile.Create(IniFileName) do
  try
    WriteInteger('ProcessInfo', 'ItemCount',
      Integer(ListBox1.Items.Objects[ListBox1.ItemIndex]));

    ReadProcessListFromIni;
  finally
    Free;
  end;
end;

function TForm1.ReadMaskFromCheckBox: Cardinal;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to cbList.Count - 1 do
    if TCheckBox(cbList[I]).Checked then
      Result := Result or (1 shl I);
end;

procedure TForm1.SetCheckBoxState(AMask: Integer);
var
  I: Integer;
begin
  for I := 0 to cbList.Count - 1 do
    TCheckBox(cbList[I]).Checked := (AMask and (1 shl I)) > 0;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  AProcessInfo: TProcessInformation;
  AStartupInfo: TStartupInfo;
begin
  if ReadMaskFromCheckBox = 0 then
    raise Exception.Create('Невозможно запустить приложение, т.к. не указано ни одного процессора!');

  FillChar(AProcessInfo, SizeOf(AProcessInfo), 0);
  FillChar(AStartupInfo, SizeOf(TStartupInfo), 0);

  // Устанавливаем каталог по умолчанию
  SetCurrentDir(edDirName.Text);

  if not CreateProcess(nil, PChar('"' + edFileName.Text + '" ' + edParams.Text), nil, nil, False,
    0, nil, nil, AStartupInfo, AProcessInfo) then
    RaiseLastOSError;

  if not SetProcessAffinityMask(AProcessInfo.hProcess, ReadMaskFromCheckBox) then
    RaiseLastOSError;
end;

end.
