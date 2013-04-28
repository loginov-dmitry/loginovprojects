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

unit MedDoctorsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, MedBaseFrm, JvAppStorage,
  JvAppRegistryStorage, JvComponentBase, JvFormPlacement, StdCtrls,
  Buttons, ExtCtrls, DB, IBCustomDataSet, Grids, DBGrids, ibxFBUtils, ActnList;

type
  TMedDoctorsForm = class(TMedBaseForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    btnAddRec: TBitBtn;
    btnEditRec: TBitBtn;
    btnDelRec: TBitBtn;
    DataSource1: TDataSource;
    dsDoctors: TIBDataSet;
    dsDoctorsID: TIntegerField;
    dsDoctorsTABNUM: TIBStringField;
    dsDoctorsNAME: TIBStringField;
    dsDoctorsFULLNAME: TIBStringField;
    dsDoctorsUSERPASSW: TIBStringField;
    dsDoctorsISBOSS: TIntegerField;
    dsDoctorsADDDATE: TDateTimeField;
    dsDoctorsISDELETE: TIntegerField;
    dsDoctorsCOMMENT: TIBStringField;
    dsDoctorsCOMPNAME: TIBStringField;
    dsDoctorsMODIFYDATE: TDateTimeField;
    procedure FormCreate(Sender: TObject);
    procedure btnEditRecClick(Sender: TObject);
    procedure btnDelRecClick(Sender: TObject);
    procedure btnAddRecClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ApplyRights(IsAdmin: Boolean); override;
  public
    { Public declarations }
  end;

procedure ShowMedDoctorsForm;

implementation

uses MedGlobalUnit, MedAddEditDoctorFrm, MedDMUnit;

{$R *.dfm}

procedure ShowMedDoctorsForm;
begin
  with TMedDoctorsForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMedDoctorsForm.ApplyRights(IsAdmin: Boolean);
begin
  btnAddRec.Enabled := IsAdmin;
  btnDelRec.Enabled := IsAdmin;
end;

procedure TMedDoctorsForm.btnAddRecClick(Sender: TObject);
begin
  inherited;
  AddEditDoctor(True, dsDoctors);
end;

procedure TMedDoctorsForm.btnDelRecClick(Sender: TObject);
begin
  if dsDoctors.IsEmpty then
    raise Exception.Create('Таблица пустая!');

  if Application.MessageBox('Вы действительно хотите удалить ' + sLineBreak +
    'выбранную учетную запись врача?', 'ВНИМАНИЕ!', MB_ICONQUESTION or MB_OKCANCEL) = IDOK then
  begin
    //FBDeleteRecord(MedDB, TranW, 'DOCTORS', ['ID'], [dsDoctors.FieldByName('ID').AsInteger], [dsDoctors]);
    FBUpdateRecord(MedDB, TranW, 'DOCTORS', ['ID'], [dsDoctors.FieldByName('ID').AsInteger],
      ['ISDELETE'], [1], [dsDoctors]);
  end;
end;

procedure TMedDoctorsForm.btnEditRecClick(Sender: TObject);
begin
  if dsDoctors.IsEmpty then
    raise Exception.Create('Таблица пустая!');
  AddEditDoctor(False, dsDoctors);
end;

procedure TMedDoctorsForm.FormCreate(Sender: TObject);
begin
  inherited;
  dsDoctors.Database := MedDB;
  dsDoctors.Open;
end;

end.
