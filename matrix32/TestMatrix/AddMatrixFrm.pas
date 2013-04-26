unit AddMatrixFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Matrix32;

type
  TAddMatrixForm = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Label4: TLabel;
    edNewMatrixName: TEdit;
    Label3: TLabel;
    ComboBox1: TComboBox;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FNode: TTreeNode;
  public
    { Public declarations }
  end;

var
  AddMatrixForm: TAddMatrixForm;

function ShowAddMatrixForm(ANode: TTreeNode): Boolean;


implementation

{$R *.dfm}

function ShowAddMatrixForm(ANode: TTreeNode): Boolean;
begin
  with TAddMatrixForm.Create(nil) do
  try
    FNode := ANode;
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TAddMatrixForm.btnOKClick(Sender: TObject);
var
  Index: Integer;
  AClass: TMatrixClass;
  M: TMatrix;
  SelObj, Tmp: TMatrix;
  IsExists: Boolean;
begin
  ModalResult := mrNone;

  if Trim(edNewMatrixName.Text) = '' then
    raise Exception.Create('Имя объекта не задано!');

  SelObj := nil;


  if FNode <> nil then
  begin
    Tmp := TMatrix(FNode.Data);
    if Tmp.IsLiving and Tmp.IsRecord then
      SelObj := Tmp;
  end;

  if SelObj = nil then
    SelObj := Base;

  IsExists := False;
  if SelObj.IsWorkspace then
  begin
    IsExists := Assigned(SelObj.FindMatrix(edNewMatrixName.Text));
  end else if SelObj.IsRecord then
  begin
    IsExists := Assigned(SelObj.FindField(edNewMatrixName.Text));
  end;

  if IsExists then
    if Application.MessageBox(
      'Массив с таким именем уже есть в выбранном контейнере!'#13#10+
      'Если вы создадите новый массив, то предыдущий будет'#13#10+
      'уничтожен. Вы действительно хотите создать массив?',
      'Внимание!', MB_ICONQUESTION or MB_OKCANCEL or MB_DEFBUTTON2) = IDCANCEL then Exit;

  Index := MatrixClassList.IndexOf(ComboBox1.Text);
  if Index >= 0 then
  begin
    AClass := TMatrixClass(MatrixClassList.Objects[Index]);
    M := AClass.Create(nil, edNewMatrixName.Text);
    if SelObj.IsWorkspace then
      M.OwnerMatrix := SelObj
    else if SelObj.IsRecord then
      SelObj.Fields[edNewMatrixName.Text] := M;
    if M.IsNumeric then
      M.Value := 0;
  end;

  ModalResult := mrOk;
end;

end.
