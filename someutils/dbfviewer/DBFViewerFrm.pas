{
Copyright (c) 2009-2013, Loginov Dmitry Sergeevich
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

unit DBFViewerFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, StdCtrls, Mask,  
  Math, DB, MemDBFTable, JvExMask, JvToolEdit, JvAppStorage,
  JvAppRegistryStorage, JvComponentBase, JvFormPlacement;

type
  TDBFViewerForm = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    lbDBFList: TListBox;
    Label1: TLabel;
    deDBFDir: TJvDirectoryEdit;
    gbSortType: TRadioGroup;
    gbSortDirection: TRadioGroup;
    Panel7: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    labDBFSize: TLabel;
    Label3: TLabel;
    labDBFDate: TLabel;
    Label5: TLabel;
    labDBFRecCount: TLabel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Label4: TLabel;
    rbPage866: TRadioButton;
    rbPage1251: TRadioButton;
    GroupBox2: TGroupBox;
    cbSortFields: TComboBox;
    btnSort: TButton;
    rbSortASC: TRadioButton;
    rbSortDESC: TRadioButton;
    GroupBox3: TGroupBox;
    edFilter: TEdit;
    Button1: TButton;
    gbFind: TGroupBox;
    cbFindFields: TComboBox;
    Button2: TButton;
    Label6: TLabel;
    edFindValue: TEdit;
    cbCaseInsensitive: TCheckBox;
    cbPartialKey: TCheckBox;
    timFind: TTimer;
    cbFilterCaseInsensitive: TCheckBox;
    cbFilterPartialKey: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    SaveDialog1: TSaveDialog;
    Button5: TButton;
    btnClear: TButton;
    JvFormStorage1: TJvFormStorage;
    JvAppRegistryStorage1: TJvAppRegistryStorage;
    procedure deDBFDirAfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure gbSortTypeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbDBFListClick(Sender: TObject);
    procedure rbPage866Click(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure timFindTimer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
    DBF: TMemDBFTable;
  public
    { Public declarations }
    procedure ReadDBF(Dir: string; List: TStrings);
  end;

  PDBFInfo = ^TDBFInfo;
  TDBFInfo = record
    dbfDate: TDateTime;
    dbfSize: Int64;
  end;

var
  DBFViewerForm: TDBFViewerForm;

implementation

{$R *.dfm}

procedure TDBFViewerForm.deDBFDirAfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  ReadDBF(Name, lbDBFList.Items);
end;


var
  { Внимание! Глобальные переменные! }
  vSortType: Integer;
  vSortDirectional: Integer;

function DoSort(List: TStringList; Index1, Index2: Integer): Integer;
var
  Obj1, Obj2: PDBFInfo;
begin
  Result := 0;
  Obj1 := PDBFInfo(List.Objects[Index1]);
  Obj2 := PDBFInfo(List.Objects[Index2]);
  if vSortDirectional = 0 then
  begin // По возрастанию
    case vSortType of
      0: Result := AnsiCompareText(List[Index1], List[Index2]);
      1: Result := Math.CompareValue(Obj1.dbfDate, Obj2.dbfDate);
      2: Result := Math.CompareValue(Obj1.dbfSize, Obj2.dbfSize);
    end;
  end else
  begin // По убыванию
    case vSortType of
      0: Result := AnsiCompareText(List[Index1], List[Index2]) * -1;
      1: Result := Math.CompareValue(Obj1.dbfDate, Obj2.dbfDate) * -1;
      2: Result := Math.CompareValue(Obj1.dbfSize, Obj2.dbfSize) * -1;
    end;
  end;
end;

procedure TDBFViewerForm.ReadDBF(Dir: string; List: TStrings);
var
  sr: TSearchRec;
  Info: PDBFInfo;
  AList: TStringList;
  I: Integer;
begin
  vSortType := gbSortType.ItemIndex;
  vSortDirectional := gbSortDirection.ItemIndex;

  AList := TStringList.Create;
  try
    Dir := IncludeTrailingPathDelimiter(Dir);
    if FindFirst(Dir + '*.DBF', faAnyFile, sr) = 0 then
    try
      repeat
        New(Info);
        Info.dbfDate := FileDateToDateTime(sr.Time);
        Info.dbfSize := sr.Size;
        AList.AddObject(sr.Name, TObject(Info));
      until FindNext(sr) <> 0;
    finally
      FindClose(sr);
    end;

    AList.CustomSort(@DoSort);
    List.Text := AList.Text;

    // Уничтожаем объекты
    for I := 0 to AList.Count - 1 do
      Dispose(PDBFInfo(AList.Objects[I]));
  finally
    AList.Free;
  end;
end;

procedure TDBFViewerForm.gbSortTypeClick(Sender: TObject);
begin
  ReadDBF(deDBFDir.Text, lbDBFList.Items);
end;

procedure TDBFViewerForm.FormShow(Sender: TObject);
begin
  gbSortTypeClick(nil);
end;

procedure TDBFViewerForm.FormCreate(Sender: TObject);
begin
  DBF := TMemDBFTable.Create(Self);
  DataSource1.DataSet := DBF;
end;

procedure TDBFViewerForm.lbDBFListClick(Sender: TObject);
var
  AFile, s: string;
  sr: TSearchRec;
  I: Integer;
begin
  if lbDBFList.ItemIndex >= 0 then
  begin
    DBF.Close;
    AFile := IncludeTrailingPathDelimiter(deDBFDir.Text) + lbDBFList.Items[lbDBFList.ItemIndex];
    if FileExists(AFile) then
    begin
      // Обновляем информацию по файлу
      if FindFirst(AFile, faAnyFile, sr) = 0 then
      begin
        labDBFSize.Caption := Format('%.n байт', [sr.Size / 1]);
        labDBFDate.Caption := DateTimeToStr(FileDateToDateTime(sr.Time));
        FindClose(sr);
      end;
      //getfi

      DBF.FileName := AFile;
      DBF.OEM := rbPage866.Checked;
      DBF.Open;
      labDBFRecCount.Caption := Format('%.n', [DBF.RecordCount / 1]);


      // Заполняем список полей сортировки
      cbSortFields.Clear;
      for I := 0 to DBF.FieldDefs.Count - 1 do
        cbSortFields.Items.Add(DBF.FieldDefs[I].Name);

      s := cbFindFields.Text;
      cbFindFields.Clear;
      for I := 0 to DBF.FieldDefs.Count - 1 do
        cbFindFields.Items.Add(DBF.FieldDefs[I].Name);
      if cbFindFields.Items.IndexOf(s) >= 0 then
        cbFindFields.Text := s;
    end else
      Application.MessageBox(PChar('Не могу найти файл: ' + AFile), 'Внимание!', MB_ICONWARNING);    
  end;
end;

procedure TDBFViewerForm.rbPage866Click(Sender: TObject);
begin
  DBF.OEM := rbPage866.Checked;
  DBF.Resync([]);
end;

procedure TDBFViewerForm.btnSortClick(Sender: TObject);
begin
  if DBF.IsEmpty then
    raise Exception.Create('Нет данных!');
  DBF.Sort(cbSortFields.Text, rbSortASC.Checked);
end;

procedure TDBFViewerForm.Button1Click(Sender: TObject);
var
  fo: TFilterOptions;
begin
  if DBF.IsEmpty then
    raise Exception.Create('Нет данных!');
  fo := [];
  if not cbFilterCaseInsensitive.Checked then
    fo := [foCaseInsensitive];

  if not cbFilterPartialKey.Checked then
    fo := fo + [foNoPartialCompare];

  DBF.FilterOptions := fo;
  DBF.Filter := edFilter.Text;
  DBF.Filtered := True;
end;

procedure TDBFViewerForm.Button2Click(Sender: TObject);
var
  Op: TLocateOptions;
begin
  if DBF.IsEmpty then
    raise Exception.Create('Нет данных!');
  Op := [];
  if cbCaseInsensitive.Checked then
    Op := Op + [loCaseInsensitive];
  if cbPartialKey.Checked then
    Op := Op + [loPartialKey];

  if not DBF.Locate(cbFindFields.Text, edFindValue.Text, Op) then
  begin
    gbFind.Caption := 'ЗАПИСЬ НЕ НАЙДЕНА';
    timFind.Enabled := True;
  end;
    //Application.MessageBox('Запись не найдена!', 'Внимание!', MB_ICONWARNING);
end;

procedure TDBFViewerForm.timFindTimer(Sender: TObject);
begin
  gbFind.Caption := 'Найти';
  timFind.Enabled := False;
end;

procedure TDBFViewerForm.Button4Click(Sender: TObject);
begin
  Close;
end;

procedure TDBFViewerForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := Application.MessageBox(
    'Вы действительно хотите завершить просмотр DBF?',
    'Подтверждение', MB_ICONQUESTION or MB_OKCANCEL) = IDOK
end;

procedure TDBFViewerForm.Button3Click(Sender: TObject);
begin
  if DBF.IsEmpty then
    raise Exception.Create('Нет данных!');
    
  if Application.MessageBox(
    'Будут сохранены все последние изменения. Если вы изменяли'#13#10+
    'порядок сортировки, то этот же порядок будет и в DBF-файле.'#13#10+
    'После нажатия кнопки "ОК" будет предложено выбрать имя для'#13#10+
    'DBF-файла.',
    'Сохранение', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then
  begin   
    SaveDialog1.FileName := IncludeTrailingPathDelimiter(deDBFDir.Text) + lbDBFList.Items[lbDBFList.ItemIndex];
    if SaveDialog1.Execute then
      DBF.Save(SaveDialog1.FileName);
  end;
end;

procedure TDBFViewerForm.Button5Click(Sender: TObject);
begin
  if DBF.IsEmpty then
    raise Exception.Create('Нет данных!');

  if Application.MessageBox(
    'Перед тем, как изменить кодировку символов, убедитесь, что ВСЕ символы'#13#10+
    'в данный момент отображаются ПРАВИЛЬНО. Если это не так, то выберите'#13#10+
    'правильную кодировку с помощью переключателей 866/1251. После переконвертирования'#13#10+
    'изменится кодировка, однако визуально никакой разницы быть не должно.'#13#10+
    'Разница будет видна после сохранения DBF-файла и дальнейшего его открытия'#13#10+
    'с помощью другой программы.',
    'Переконвертирование', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then
  begin
    DBF.ChangeCharsCode;
    if rbPage866.Checked then
      rbPage1251.Checked := True
    else
      rbPage866.Checked := True;
  end;

end;

procedure TDBFViewerForm.btnClearClick(Sender: TObject);
begin
  if DBF.IsEmpty then
    raise Exception.Create('Нет данных!');

  DBF.DisableControls;
  try  
    DBF.First;
    while not DBF.Eof do
      DBF.Delete;
  finally
    DBF.EnableControls;
  end;


end;

end.
