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

unit RepVarsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, IniFiles, HTMLGlobal, MSHTML,
  ComCtrls;

type
  TRepVarsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOK: TButton;
    Button2: TButton;
    cbRepList: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    labRepName: TLabel;
    labRepFile: TLabel;
    Label4: TLabel;
    cbProgramList: TComboBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    sg: TStringGrid;
    TrackBar1: TTrackBar;
    Label5: TLabel;
    sg1: TStringGrid;
    sg2: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure cbRepListSelect(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure sgDblClick(Sender: TObject);
    procedure sgKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbProgramListSelect(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }

    HTMLInfo: THTMLEditorInfo;

    procedure FillRepList;

    procedure ShowVarList;

    procedure AdjustWidth;

    procedure FillCommands;
  end;

var
  RepVarsForm: TRepVarsForm;

procedure ShowRepVarsForm(AHTMLInfo: THTMLEditorInfo);

implementation



{$R *.dfm}

procedure ShowRepVarsForm(AHTMLInfo: THTMLEditorInfo);
begin
  if RepVarsForm = nil then
    RepVarsForm := TRepVarsForm.Create(Application);

  RepVarsForm.HTMLInfo := AHTMLInfo;
  
  RepVarsForm.Show;

end;

var
  MemGSM: TMemIniFile;
  MemTovar: TMemIniFile;
  MemKMAZS: TMemIniFile;
  MemPC: TMemIniFile;

procedure FillMemIni;
begin

end; 

procedure TRepVarsForm.AdjustWidth;

  procedure AdjustWidthGrid(sg: TStringGrid);
  begin
    sg.ColWidths[0] := 150;
    sg.ColWidths[1] := sg.Width - 170;
  end;
begin
  AdjustWidthGrid(sg);
  AdjustWidthGrid(sg1);
  AdjustWidthGrid(sg2);
end;

procedure TRepVarsForm.btnOKClick(Sender: TObject);
var
  S: string;
  TextRange: IHTMLTxtRange;
  g: TStringGrid;
begin
  TextRange := GetDocRange(HTMLInfo);

  if Assigned(TextRange) then
  begin
    case PageControl1.ActivePageIndex of
      1: g := sg1;
      2: g := sg2;
    else
      g := sg;
    end;

    S := g.Cells[0, g.Row];
    if S <> '' then
      TextRange.pasteHTML('&lt;#' + S + '&gt;');

  end else
    raise Exception.Create('Невозможно вставить текст в текущую позицию!');   
end;

procedure TRepVarsForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TRepVarsForm.cbRepListSelect(Sender: TObject);
begin
  ShowVarList;
end;

procedure TRepVarsForm.cbProgramListSelect(Sender: TObject);
begin
  FillRepList;
end;

procedure TRepVarsForm.FillCommands;
var
  C: Integer;
begin
  C := 1;

  sg2.Cells[0, C] := 'Group';
  sg2.Cells[1, C] := 'Начало группы';
  Inc(C);

  sg2.Cells[0, C] := 'EndGroup';
  sg2.Cells[1, C] := 'Завершение группы';
  Inc(C);

  sg2.Cells[0, C] := 'Repeat';
  sg2.Cells[1, C] := 'Начало табличной (расширяемой) части';
  Inc(C);

  sg2.Cells[0, C] := 'EndRepeat';
  sg2.Cells[1, C] := 'Окончание табличной (расширяемой) части';
  Inc(C);

  sg2.Cells[0, C] := 'Itog';
  sg2.Cells[1, C] := 'Начало итогов группы';
  Inc(C);

  sg2.Cells[0, C] := 'EndItog';
  sg2.Cells[1, C] := 'Завершение итогов группы';
  Inc(C);

  sg2.Cells[0, C] := 'AllItog';
  sg2.Cells[1, C] := 'Начало итогов таблицы';
  Inc(C);

  sg2.Cells[0, C] := 'EndAllItog';
  sg2.Cells[1, C] := 'Завершение итогов таблицы';
  Inc(C);

  sg2.Cells[0, C] := 'paramrep Параметр=Значение';
  sg2.Cells[1, C] := 'Способ задания параметров в отчете';
  Inc(C);

  sg2.RowCount := C;
end;

procedure TRepVarsForm.FillRepList;
var
  I: Integer;
  Sn: string;
  Ini: TMemIniFile;
begin
  cbRepList.Clear;

  Ini := TMemIniFile(cbProgramList.Items.Objects[cbProgramList.ItemIndex]);

  for I := 1 to Ini.ReadInteger('main', 'RepCount', 0) do
  begin
    Sn := 'RepDesc' + IntToStr(I);
    cbRepList.Items.AddObject(Ini.ReadString(Sn, 'RepName', ''), TObject(I));
  end;

  cbRepList.ItemIndex := 0;
  cbRepListSelect(cbRepList);
end;

procedure TRepVarsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  HTMLInfo.panCursor.Visible := False;

  //HTMLInfo.EditorControl.SetFocus;
end;

procedure TRepVarsForm.FormCreate(Sender: TObject);
begin
  FillMemIni;

  cbProgramList.Clear;
  cbProgramList.Items.AddObject('ПТК АЗС: ГСМ', MemGSM);
  cbProgramList.Items.AddObject('ПТК АЗС: Магазин', MemTovar);
  cbProgramList.Items.AddObject('КМАЗС', MemKMAZS);
  cbProgramList.Items.AddObject('ПроЦентКарт', MemPC);
  cbProgramList.ItemIndex := 0;

  //FillRepList;

  cbProgramListSelect(cbProgramList);

  AdjustWidth;

  sg.Cells[0, 0] := 'Переменная';
  sg.Cells[1, 0] := 'Описание переменной';

  sg1.Cells[0, 0] := 'Переменная';
  sg1.Cells[1, 0] := 'Описание переменной';


  sg2.Cells[0, 0] := 'Команда';
  sg2.Cells[1, 0] := 'Описание команды';

  FillCommands;

  PageControl1.ActivePageIndex := 0;
end;

procedure TRepVarsForm.FormResize(Sender: TObject);
begin
  AdjustWidth;
end;

procedure TRepVarsForm.sgDblClick(Sender: TObject);
begin
  btnOK.Click;
end;

procedure TRepVarsForm.sgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    btnOK.Click;
    Key := 0;
  end;
end;

procedure TRepVarsForm.ShowVarList;
var
  Ini: TMemIniFile;
  I, RepIndex: Integer;
  S, Sn, Sn1: string;

  procedure FillGrid(sg: TStringGrid; Sn: string; Ini: TMemIniFile);
  var
    I: Integer;
    VarName, VarDesc: string;
  begin
    sg.RowCount := 2;
    sg.Cells[0, 1] := '';
    sg.Cells[1, 1] := '';

    for I := 1 to Ini.ReadInteger(Sn, 'VarCnt', 0) do
    begin
      VarName := Ini.ReadString(Sn, 'v' + IntToStr(I), '');
      if VarName <> '' then
      begin
        VarDesc := Ini.ReadString(Sn, 'd' + IntToStr(I), '');
        sg.Cells[0, sg.RowCount - 1] := VarName;
        sg.Cells[1, sg.RowCount - 1] := VarDesc;

        sg.RowCount := sg.RowCount + 1;
      end;
    end;

    sg.RowCount := sg.RowCount - 1;
  end;
begin
  Ini := TMemIniFile(cbProgramList.Items.Objects[cbProgramList.ItemIndex]);
  I := cbRepList.ItemIndex;

  if I >= 0 then
  begin
    S := cbRepList.Items[I];
    RepIndex := Integer(cbRepList.Items.Objects[I]);
    Sn := 'RepDesc' + IntToStr(RepIndex);
  end;

  if Assigned(Ini) then
  begin
    Sn1 := 'CommonVars';
    TabSheet2.TabVisible := Ini.ReadInteger(Sn1, 'VarCnt', 0) > 0;
    if TabSheet2.TabVisible then
    begin
      FillGrid(sg1, Sn1, Ini);
    end;

    labRepName.Caption := Ini.ReadString(Sn, 'RepName', '');
    labRepFile.Caption := Ini.ReadString(Sn, 'RepFileName', '');

    FillGrid(sg, Sn, Ini);
  end;
end;

procedure TRepVarsForm.TrackBar1Change(Sender: TObject);
begin
  AlphaBlend := TrackBar1.Position <> 255;
  AlphaBlendValue := TrackBar1.Position;
end;

initialization

finalization
  MemGSM.Free;
  MemTovar.Free;
  MemKMAZS.Free;
  MemPC.Free;

end.
