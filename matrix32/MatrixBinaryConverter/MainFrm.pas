unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, ToolEdit, Matrix, Matrix32;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    FilenameEdit1: TFilenameEdit;
    FilenameEdit2: TFilenameEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  AList: TStringList;
  I: Integer;
  ARows, ACols, Idx: Integer;
  SaverClass, MatrixClass: TMatrixClass;
begin
  if not FileExists(FilenameEdit1.Text) then
    raise EMatrixFileStreamError.CreateFmt('Файл "%s" не найден!', [FilenameEdit1.Text]);

  if FilenameEdit1.Text = FilenameEdit2.Text then
    if Application.MessageBox(
      'Вы хотите сохранить файл в себя же. Это рискованная операция, так как' + sLineBreak +
      'вы можете потерять исходный файл, не получив желаемого результата. Хотите продолжить?',
      'Подтверждение',
      MB_ICONWARNING or MB_OKCANCEL) = IDCANCEL
    then
      Exit;

  // Загружаем файл старой версии
  Matrix.Base.LoadFromBinFile(FilenameEdit1.Text);

  // Получаем список массивов
  AList := TStringList.Create;
  try
    Matrix.Base.GetNameList(AList);

    DeleteFile(FilenameEdit2.Text);
    
    for I := 0 to AList.Count - 1 do
    begin
      Idx := Matrix.Base.GetSize(AList[I], ARows, ACols);
      case Matrix.Base.GetElemType(AList[I]) of

        stByte: SaverClass := TByteMatrix;
        stShortInt: SaverClass := TShortIntMatrix;
        stWord: SaverClass := TWordMatrix;
        stShort: SaverClass := TShortMatrix;
        stDWord: SaverClass := TCardinalMatrix;
        stInteger: SaverClass := TIntegerMatrix;

        else SaverClass := TDoubleMatrix;

      end;

      if CheckBox1.Checked then
        MatrixClass := SaverClass
      else
        MatrixClass := TDoubleMatrix;

      with MatrixClass.Create() do
      try
        CopyFrom(Matrix.Base.GetRowAddress(Idx), [ARows, ACols], TDoubleMatrix);

        SaveToBinaryFile(FilenameEdit2.Text, AList[I], SaverClass);
      finally
        Free;
      end;
    end;
  finally
    AList.Free;
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
