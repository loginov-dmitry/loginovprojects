{
Copyright (c) 2012, Loginov Dmitry Sergeevich
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

unit MedEditElemBaseFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, MedBaseFrm, ActnList, JvAppStorage,
  JvAppRegistryStorage, JvComponentBase, JvFormPlacement, StdCtrls,
  Buttons, ExtCtrls, ImgList, ComCtrls, ToolWin, Grids,
  DBGrids, DB, IBCustomDataSet, ibxFBUtils;

type
  TMedEditElemBaseForm = class(TMedBaseForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel5: TPanel;
    Panel6: TPanel;
    ToolBar1: TToolBar;
    btnAddCateg: TToolButton;
    ImageList1: TImageList;
    btnEditCateg: TToolButton;
    btnDelCateg: TToolButton;
    btnDownCateg: TToolButton;
    btnUpCateg: TToolButton;
    ToolBar2: TToolBar;
    btnAddElem: TToolButton;
    btnEditElem: TToolButton;
    btnDelElem: TToolButton;
    btnDownElem: TToolButton;
    btnUpElem: TToolButton;
    ToolBar3: TToolBar;
    btnAddVar: TToolButton;
    btnEditVar: TToolButton;
    btnDelVar: TToolButton;
    btnDownVar: TToolButton;
    btnUpVar: TToolButton;
    DataSourceCategs: TDataSource;
    DataSourceElems: TDataSource;
    DataSourceVars: TDataSource;
    dsCategs: TIBDataSet;
    dsElems: TIBDataSet;
    dsVars: TIBDataSet;
    DBGridCategs: TDBGrid;
    DBGridElems: TDBGrid;
    DBGridVars: TDBGrid;
    dsCategsID: TIntegerField;
    dsCategsNAME: TIBStringField;
    dsElemsID: TIntegerField;
    dsElemsELEMNAME: TIBStringField;
    dsVarsID: TIntegerField;
    dsVarsVARTEXT: TIBStringField;
    dsCategsORDERNUM: TIntegerField;
    dsElemsORDERNUM: TIntegerField;
    dsVarsORDERNUM: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure btnAddCategClick(Sender: TObject);
    procedure btnEditCategClick(Sender: TObject);
    procedure btnDelCategClick(Sender: TObject);
    procedure btnUpCategClick(Sender: TObject);
    procedure btnDownCategClick(Sender: TObject);
    procedure dsCategsAfterOpen(DataSet: TDataSet);
    procedure btnAddElemClick(Sender: TObject);
    procedure btnEditElemClick(Sender: TObject);
    procedure btnDelElemClick(Sender: TObject);
    procedure btnDownElemClick(Sender: TObject);
    procedure btnUpElemClick(Sender: TObject);
    procedure DBGridCategsDblClick(Sender: TObject);
    procedure DBGridElemsDblClick(Sender: TObject);
    procedure btnAddVarClick(Sender: TObject);
    procedure btnEditVarClick(Sender: TObject);
    procedure btnDelVarClick(Sender: TObject);
    procedure DBGridVarsDblClick(Sender: TObject);
    procedure btnUpVarClick(Sender: TObject);
    procedure btnDownVarClick(Sender: TObject);
  private
    { Private declarations }
    procedure MoveRecord(ds: TIBDataSet; TableName: string; Up: Boolean);
  protected
    procedure ApplyRights(IsAdmin: Boolean); override; 
  public
    { Public declarations }
  end;

procedure EditElemBase;

implementation

{$R *.dfm}

uses MedDMUnit, MedGlobalUnit, MedAddEditCategFrm, MedAddEditElemFrm,
  MedAddEditVarFrm;

procedure EditElemBase;
begin
  with TMedEditElemBaseForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMedEditElemBaseForm.ApplyRights(IsAdmin: Boolean);
begin
  inherited;
  btnDelCateg.Enabled := IsAdmin;
  //btnDelElem.Enabled := IsAdmin;
end;

procedure TMedEditElemBaseForm.btnAddCategClick(Sender: TObject);
begin
  inherited;

  ShowAddEditCategForm(True, dsCategs);
end;

procedure TMedEditElemBaseForm.btnAddElemClick(Sender: TObject);
var
  ID: Integer;
begin
  if dsCategs.FieldByName('ID').AsInteger = 0 then
    RaiseError('Не выбрана категория описания!');
  if ShowAddEditElemForm(True, dsCategs, dsElems, @ID) then
    dsElems.Locate('ID', ID, [])
end;

procedure TMedEditElemBaseForm.btnAddVarClick(Sender: TObject);
var
  ID: Integer;
begin
  inherited;
  if ShowAddEditVarForm(True, dsCategs, dsElems, dsVars, @ID) then
    dsVars.Locate('ID', ID, []);
end;

procedure TMedEditElemBaseForm.btnDelCategClick(Sender: TObject);
begin
  inherited;
  if dsCategs.IsEmpty then
    RaiseError('Нет категории описания!');

  if Application.MessageBox('Вы действительно хотите удалить категорию?',
    'ВНИМАНИЕ!', MB_OKCANCEL or MB_ICONQUESTION) = IDOK then
  begin
    FBUpdateRecord(MedDB, TranW, 'DESCCATEGS', ['ID'], [dsCategs.FieldByName('ID').AsInteger],
      ['ISDELETE'], [1], dsCategs);
  end;  
end;

procedure TMedEditElemBaseForm.btnDelElemClick(Sender: TObject);
begin
  inherited;
  if dsElems.IsEmpty then
    RaiseError('Нет элемента описания!');

  if Application.MessageBox('Вы действительно хотите удалить элемент?',
    'ВНИМАНИЕ!', MB_OKCANCEL or MB_ICONQUESTION) = IDOK then
  begin
    FBUpdateRecord(MedDB, TranW, 'DESCELEMS',
      ['ID'], [dsElems.FieldByName('ID').AsInteger],
      ['ISDELETE'], [1], dsElems);
  end;
end;

procedure TMedEditElemBaseForm.btnDelVarClick(Sender: TObject);
begin
  inherited;
  if dsVars.IsEmpty then
    RaiseError('Нет варианта описания!');

  if Application.MessageBox('Вы действительно хотите удалить вариант?',
    'ВНИМАНИЕ!', MB_OKCANCEL or MB_ICONQUESTION) = IDOK then
  begin
    FBUpdateRecord(MedDB, TranW, 'DESCVARS',
      ['ID'], [dsVars.FieldByName('ID').AsInteger],
      ['ISDELETE'], [1], dsVars);
  end;
end;

procedure TMedEditElemBaseForm.btnDownCategClick(Sender: TObject);
begin
  inherited;
  MoveRecord(dsCategs, 'DESCCATEGS', False);
end;

procedure TMedEditElemBaseForm.btnDownElemClick(Sender: TObject);
begin
  inherited;
  MoveRecord(dsElems, 'DESCELEMS', False);
end;

procedure TMedEditElemBaseForm.btnDownVarClick(Sender: TObject);
begin
  inherited;
  MoveRecord(dsVars, 'DESCVARS', False);
end;

procedure TMedEditElemBaseForm.btnEditCategClick(Sender: TObject);
begin
  inherited;
  if dsCategs.FieldByName('ID').AsInteger = 0 then
    RaiseError('Не выбрана категория описания!');
  ShowAddEditCategForm(False, dsCategs);
end;

procedure TMedEditElemBaseForm.btnEditElemClick(Sender: TObject);
begin
  if dsElems.IsEmpty then
    RaiseError('Список элементов описания пуст!');
  ShowAddEditElemForm(False, dsCategs, dsElems);
end;

procedure TMedEditElemBaseForm.btnEditVarClick(Sender: TObject);
begin
  inherited;
  ShowAddEditVarForm(False, dsCategs, dsElems, dsVars);
end;

procedure TMedEditElemBaseForm.btnUpCategClick(Sender: TObject);
begin
  inherited;
  MoveRecord(dsCategs, 'DESCCATEGS', True);
end;

procedure TMedEditElemBaseForm.btnUpElemClick(Sender: TObject);
begin
  inherited;
  MoveRecord(dsElems, 'DESCELEMS', True);
end;

procedure TMedEditElemBaseForm.btnUpVarClick(Sender: TObject);
begin
  inherited;
  MoveRecord(dsVars, 'DESCVARS', True);
end;

procedure TMedEditElemBaseForm.DBGridCategsDblClick(Sender: TObject);
begin
  inherited;
  if dsCategs.IsEmpty then
    btnAddCateg.Click
  else
    btnEditCateg.Click;
end;

procedure TMedEditElemBaseForm.DBGridElemsDblClick(Sender: TObject);
begin
  inherited;
  if dsElems.IsEmpty then
    btnAddElem.Click
  else
    btnEditElem.Click;
end;

procedure TMedEditElemBaseForm.DBGridVarsDblClick(Sender: TObject);
begin
  inherited;
  if dsVars.IsEmpty then
    btnAddVar.Click
  else
    btnEditVar.Click;
end;

procedure TMedEditElemBaseForm.dsCategsAfterOpen(DataSet: TDataSet);
begin
  inherited;
  TIBDataSet(DataSet).FetchAll;
end;

procedure TMedEditElemBaseForm.FormCreate(Sender: TObject);
begin
  inherited;
  dsCategs.Database := MedDB;
  dsElems.Database := MedDB;
  dsVars.Database := MedDB;
  dsCategs.Open;
  dsElems.Open;
  dsVars.Open;
end;

procedure TMedEditElemBaseForm.MoveRecord(ds: TIBDataSet; TableName: string; Up: Boolean);
var
  CurOrder, CurID: Integer;
  Order2, ID2: Integer;
begin
  if (Up and (ds.RecNo > 1)) or ((not Up) and (ds.RecNo < ds.RecordCount)) then
  begin
    CurID := ds.FieldByName('ID').AsInteger;
    CurOrder := ds.FieldByName('ORDERNUM').AsInteger;

    if Up then
      ds.Prior
    else
      ds.Next;

    ID2 := ds.FieldByName('ID').AsInteger;
    Order2 := ds.FieldByName('ORDERNUM').AsInteger;

    TranW.Active := True;
    try
      fb.UpdateRecord(MedDB, TranW, TableName, ['ID'], [CurID], ['ORDERNUM'], [Order2]);
      fb.UpdateRecord(MedDB, TranW, TableName, ['ID'], [ID2], ['ORDERNUM'], [CurOrder]);
      TranW.Commit;

      FBReopenDataSets([ds]);
      ds.Locate('ID', CurID, []);
    finally
      TranW.Active := False;
    end;
  end;
end;

end.
