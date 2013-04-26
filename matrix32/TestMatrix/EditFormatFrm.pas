unit EditFormatFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, Buttons, SafeIniFiles;

type
  TEditFormatForm = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    sg: TStringGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure sgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditFormatForm: TEditFormatForm;

function ShowEditFormatForm: Boolean;

procedure FillFormatList(StrList: TStrings);

implementation

uses UtilsUnit;

{$R *.dfm}

function ShowEditFormatForm: Boolean;
var
  I: Integer;
begin
  with TEditFormatForm.Create(nil) do
  try
    Result := ShowModal = mrOK;
    if Result then
    begin
      IniObject.WriteInteger('VALUEFORMAT', 'Rows', sg.RowCount - 1);
      for I := 1 to sg.RowCount - 1 do
        IniObject.WriteWideString('VALUEFORMAT', 'Row'+IntToStr(I), sg.Rows[I].Text);

      IniObject.WriteInteger('VALUEFORMAT', 'SelIndex', sg.Row - 1);
    end;
  finally
    Free;
  end;
end;

procedure FillFormatList(StrList: TStrings);
var
  I: Integer;
  AList: TStringList;
begin
  if IniObject.ReadInteger('VALUEFORMAT', 'Rows', 0) > 1 then
  begin
    StrList.Clear;

    AList := TStringList.Create;
    try
      for I := 1 to IniObject.ReadInteger('VALUEFORMAT', 'Rows', 0) do
      begin
        AList.Text := IniObject.ReadWideString('VALUEFORMAT', 'Row'+IntToStr(I), '');
        if AList.Count > 2 then
        begin
          StrList.Add(AList[1] + ' (' + AList[0] + ')');
        end;
      end;
    finally
      AList.Free;
    end;
  end;
end;

procedure TEditFormatForm.FormCreate(Sender: TObject);
var
  S: string;
begin
  S := FloatToStr(12345.12345);

  sg.ColWidths[0] := 150;
  sg.ColWidths[2] := 200;
  sg.Cells[0, 0] := 'Наименование';
  sg.Cells[1, 0] := 'Шаблон';
  sg.Cells[2, 0] := 'Пример';

  sg.Cells[0, 1] := 'Обычный';
  sg.Cells[1, 1] := '%g';
  sg.Cells[2, 1] := S;

  sg.Cells[0, 2] := 'Дробный';
  sg.Cells[1, 2] := '%f';
  sg.Cells[2, 2] := S;

  sg.Cells[0, 3] := 'Числовой';
  sg.Cells[1, 3] := '%n';
  sg.Cells[2, 3] := S;

  sg.Cells[0, 4] := 'Точный';
  sg.Cells[1, 4] := '%.10f';
  sg.Cells[2, 4] := S;

  sg.Cells[0, 5] := 'Научный';
  sg.Cells[1, 5] := '%e';
  sg.Cells[2, 5] := S;
end;

procedure TEditFormatForm.FormShow(Sender: TObject);
var
  I: Integer;
begin
  if IniObject.ReadInteger('VALUEFORMAT', 'Rows', 0) > 1 then
  begin
    sg.RowCount := 2;
    sg.Rows[1].Clear;

    sg.RowCount := IniObject.ReadInteger('VALUEFORMAT', 'Rows', 2) + 1;
    for I := 1 to sg.RowCount - 1 do
      sg.Rows[I].Text := IniObject.ReadWideString('VALUEFORMAT', 'Row'+IntToStr(I), '');
  end;
end;

procedure TEditFormatForm.sgDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  F: Extended;
  S: string;
  MaskOk: Boolean;
begin
  if (ACol = 2) and (ARow > 0) then
  begin
    if TryStrToFloat(sg.Cells[ACol, ARow], F) then
    begin
      MaskOk := False;
      try
        S := Format(sg.Cells[1, ARow], [0.0]);
        MaskOk := True;
      except
        S := 'Шаблон не правильный!';
      end;

      if MaskOk then
      begin
        try
          S := '"' + Format(sg.Cells[1, ARow], [F]) + '"';
        except
          on E: Exception do
            S := E.Message;
        end;
      end;
    end
    else if sg.Cells[ACol, ARow] = '' then
      S := ''
    else
      S := 'Это не число!';

    Rect.Left := Rect.Left + 1;
    sg.Canvas.FillRect(Rect);
    sg.Canvas.TextOut(Rect.Left, Rect.Top, S);
  end;
end;

procedure TEditFormatForm.sgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  sg.Repaint;
end;

procedure TEditFormatForm.SpeedButton1Click(Sender: TObject);
begin
  sg.RowCount := sg.RowCount + 1;
  sg.Row := sg.RowCount - 1;
  sg.Rows[sg.Row].Clear;
end;

procedure TEditFormatForm.SpeedButton2Click(Sender: TObject);
var
  I, J: Integer;
begin
  if sg.Row > 0 then
  begin
    if sg.RowCount > 2 then
    begin
      for I := sg.Row + 1 to sg.RowCount - 1 do
        for J := 0 to sg.ColCount - 1 do
          sg.Cells[J, I - 1] := sg.Cells[J, I];
    end;

    // Очищаем последнюю строку
    sg.Rows[sg.RowCount - 1].Clear;

    if sg.RowCount > 2 then
      sg.RowCount := sg.RowCount - 1;
  end;
end;

procedure TEditFormatForm.SpeedButton3Click(Sender: TObject);
var
  List: TStringList;
begin
  if sg.Row > 1 then
  begin
    List := TStringList.Create;
    try
      List.Assign(sg.Rows[sg.Row - 1]);
      sg.Rows[sg.Row - 1] := sg.Rows[sg.Row];
      sg.Rows[sg.Row] := List;
      sg.Row := sg.Row - 1;
    finally
      List.Free;
    end;
  end;
end;

procedure TEditFormatForm.SpeedButton4Click(Sender: TObject);
var
  List: TStringList;
begin
  if sg.Row < sg.RowCount - 1 then
  begin
    List := TStringList.Create;
    try
      List.Assign(sg.Rows[sg.Row + 1]);
      sg.Rows[sg.Row + 1] := sg.Rows[sg.Row];
      sg.Rows[sg.Row] := List;
      sg.Row := sg.Row + 1;
    finally
      List.Free;
    end;
  end;
end;

end.
