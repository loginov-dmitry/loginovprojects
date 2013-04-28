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

program MedicalCheckOut;

uses
  Forms,
  MainFrm in '..\MainFrm.pas' {MedMainFrm},
  MedInputDataFrm in '..\MedInputDataFrm.pas' {MedInputDataForm},
  MedGlobalUnit in '..\MedGlobalUnit.pas',
  MedDBStruct in '..\MedDBStruct.pas',
  MedDMUnit in '..\MedDMUnit.pas' {MedDataModule: TDataModule},
  MedLoginFrm in '..\MedLoginFrm.pas' {LoginForm},
  MedBaseFrm in '..\MedBaseFrm.pas' {MedBaseForm},
  MedDoctorsFrm in '..\MedDoctorsFrm.pas' {MedDoctorsForm},
  MedAddEditDoctorFrm in '..\MedAddEditDoctorFrm.pas' {MedAddEditDoctorForm},
  MedAddEditCategFrm in '..\MedAddEditCategFrm.pas' {MedAddEditCategForm},
  MedEditElemBaseFrm in '..\MedEditElemBaseFrm.pas' {MedEditElemBaseForm},
  MedAddEditElemFrm in '..\MedAddEditElemFrm.pas' {MedAddEditElemForm},
  MedAddEditVarFrm in '..\MedAddEditVarFrm.pas' {MedAddEditVarForm},
  MedCreateCheckOutFrm in '..\MedCreateCheckOutFrm.pas' {MedCreateCheckOutForm},
  MedEditVarTypesFrm in '..\MedEditVarTypesFrm.pas' {MedEditVarTypesForm},
  MedInputVarFrm in '..\MedInputVarFrm.pas' {MedInputVarForm};

{$R *.res}

begin
  Application.Initialize;

  Application.CreateForm(TMedDataModule, MedDataModule);
  if not MedDB.Connected then
  begin
    MedDataModule.Free;
    Exit; // ��� ������ ���������� �������� � ����������!
  end;
  Application.CreateForm(TMedMainFrm, MedMainFrm);

  Application.Run;
end.
