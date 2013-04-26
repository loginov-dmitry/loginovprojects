unit MoveToCellFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, Matrix32;

type
  TMoveToCellForm = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    labRowNum: TLabel;
    seRow: TSpinEdit;
    labColNum: TLabel;
    seCol: TSpinEdit;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FSourMatrix: TMatrix;
    FCellMatrix: TMatrix;
  public
    { Public declarations }
  end;

var
  MoveToCellForm: TMoveToCellForm;

function ShowMoveToCellForm(SourMatrix: TMatrix; CellMatrix: TMatrix): Boolean;

implementation

{$R *.dfm}

function ShowMoveToCellForm(SourMatrix: TMatrix; CellMatrix: TMatrix): Boolean;
begin
  if CellMatrix.DimensionCount > 2 then
  begin
    Result := False;
    ShowMessage('Данная возможность для многомерного массива ячеек не реализована!');
    Exit;
  end;

  with TMoveToCellForm.Create(nil) do
  try
    FSourMatrix := SourMatrix;
    FCellMatrix := CellMatrix;
    if FCellMatrix.DimensionCount = 1 then
    begin
      labRowNum.Visible := False;
      seRow.Visible := False;

      labColNum.Caption := 'Номер элемента';
    end;
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TMoveToCellForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrNone;

  if FCellMatrix.DimensionCount = 1 then
  begin
    if seCol.Value > FCellMatrix.Cols then
      FCellMatrix.PreservResize([seCol.Value]);
    FCellMatrix.VecCells[seCol.Value - 1] := FSourMatrix;
  end else
  begin
    if seRow.Value > FCellMatrix.Rows then
      FCellMatrix.PreservResize([seRow.Value, FCellMatrix.Cols]);
    if seCol.Value > FCellMatrix.Cols then
      FCellMatrix.PreservResize([FCellMatrix.Rows, seCol.Value]);
    FCellMatrix.Cells[seRow.Value - 1, seCol.Value - 1] := FSourMatrix;
  end;

  ModalResult := mrOk;
end;

end.
