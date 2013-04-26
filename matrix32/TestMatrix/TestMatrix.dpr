program TestMatrix;

uses
  Forms,
  AddMatrixFrm in 'AddMatrixFrm.pas' {AddMatrixForm},
  EditFormatFrm in 'EditFormatFrm.pas' {EditFormatForm},
  MainFrm in 'MainFrm.pas' {MainForm},
  MoveToCellFrm in 'MoveToCellFrm.pas' {MoveToCellForm},
  UtilsUnit in 'UtilsUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
