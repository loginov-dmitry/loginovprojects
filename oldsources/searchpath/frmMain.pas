{
Copyright (c) 2005-2006, Loginov Dmitry Sergeevich
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


unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, ComCtrls, Buttons, FindPath, Matrix;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    seXCount: TSpinEdit;
    seYCount: TSpinEdit;
    btnSet: TButton;
    Image: TImage;
    sbBegin: TSpeedButton;
    sbEnd: TSpeedButton;
    sbWall: TSpeedButton;
    sbClear: TSpeedButton;
    sbDelete: TSpeedButton;
    Label4: TLabel;
    seQuadSize: TSpinEdit;
    btnGO: TButton;
    btnCardToMemory: TButton;
    Label5: TLabel;
    ScrollBox1: TScrollBox;
    lbCoord: TLabel;
    lbCoord111: TLabel;
    Label8: TLabel;
    lbTime: TLabel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure seQuadSizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnGOClick(Sender: TObject);
    procedure btnCardToMemoryClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DrawGrid(XCount, YCount: Word);
    procedure FillQuadManually(X,Y: DWORD; qColor: TColor);// Коорд. на холсте
    function GetObjTypeFromMap(X,Y: Word): Byte; // Координаты в массиве
  end;
var
  Form1: TForm1;
  DoFind: TFindPath;    
  QuadSize: Byte = 8; // Размер одной клетки
  PointBegin, PointEnd : TPoint;// Координаты т. Н и К
  DrawWall: Boolean = False; // Флаг рисования стены
implementation

uses Types, frmAbout;

{$R *.dfm}

{ TForm1 }
(*=================================================================
Рисуем сетку*)
procedure TForm1.DrawGrid(XCount, YCount: Word);
var I: Word;
begin
  Image.Picture := Nil;
  Image.Width := QuadSize * XCount+1;
  Image.Height :=QuadSize * YCount+1;

  Image.Canvas.Pen.Color := clBlue;
// Рисуем горизонтальные линии
  for I := 0 to Image.Height do
  begin
    if (I=0)or((I div QuadSize)=(I / QuadSize)) then begin
      Image.Canvas.MoveTo(0,I);
      Image.Canvas.LineTo(Image.Width,I);
    end;  // if
  end;
// Рисуем вертикальные линии
  for I := 0 to Image.Width do
  begin
    if (I=0)or((I div QuadSize)=(I / QuadSize))  then begin
      Image.Canvas.MoveTo(I,0);
      Image.Canvas.LineTo(I,Image.Height);
    end;  // if
  end;
end;
(*=================================================================
Рисуем сетку при появлении окна*)
procedure TForm1.FormShow(Sender: TObject);
begin
  DrawGrid(seXCount.Value, seYCount.Value);
end;
(*=================================================================
Рисуем сетку при нажатии на соотв. кнопку*)
procedure TForm1.btnSetClick(Sender: TObject);
begin
  DrawGrid(seXCount.Value, seYCount.Value);
end;
(*=================================================================
Перемещение мыши*)
procedure TForm1.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lbCoord.Caption :=IntToStr(Y div QuadSize+1)+'x'+IntToStr(X div QuadSize+1); 
  if DrawWall then FillQuadManually(X,Y,clGray);
end;
(*=================================================================
Заливка цветом требуемых квадратиков*)
procedure TForm1.FillQuadManually(X,Y: DWORD; qColor: TColor);
var
  Xln, Yln: Word; // Координаты левого нижнего угла
  dColor: TColor; // При чем тут d ?
  R: TRect;       // Для заполненного прямоугольника
begin
// Х и У - истинные координаты
    if ((X/QuadSize)=(X div QuadSize))
      or  ((Y/QuadSize)=(Y div QuadSize)) then    Exit;

// Определяем левый нижний угол
  Xln := (X  div QuadSize)*QuadSize;
  Yln := (Y  div QuadSize)*QuadSize;
  dColor := Image.Canvas.Brush.Color;
  Image.Canvas.Brush.Color := qColor;

  R.Left := Xln+1;
  R.Top :=  Yln+1;
  R.Right :=Xln+QuadSize;
  R.Bottom :=Yln+QuadSize;
  Image.Canvas.FillRect(R);
  Image.Canvas.Brush.Color := dColor;
end;
(*=================================================================
Нажатие на кнопу мыши*)
procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if sbBegin.Down then begin
    if (PointBegin.X<>0) or (PointBegin.Y<>0) then
    FillQuadManually(PointBegin.X*QuadSize-1,
                    PointBegin.Y*QuadSize-1, clWhite);
  FillQuadManually(X,Y, clPurple);
  PointBegin.X := X div QuadSize+1;
  PointBegin.Y := Y div QuadSize+1;
  end;

  if sbEnd.Down then begin
    if (PointEnd.X<>0) or (PointEnd.Y<>0) then
    FillQuadManually(PointEnd.X*QuadSize-1,
                    PointEnd.Y*QuadSize-1, clWhite);
  FillQuadManually(X,Y, clGreen);
  PointEnd.X := X div QuadSize+1;
  PointEnd.Y := Y div QuadSize+1;
  end;

  if sbDelete.Down then
  FillQuadManually(X,Y, clWhite);

  if sbWall.Down then
  begin
  FillQuadManually(X,Y, clGray);
  DrawWall := True;
  end;
end;
(*=================================================================
TSpinEdit имеет глюк, который здесь исправляется*)
procedure TForm1.seQuadSizeChange(Sender: TObject);
begin
  (Sender as TSpinEdit).Value := (Sender as TSpinEdit).Value;
  QuadSize := seQuadSize.Value;
end;
(*=================================================================
Инициализация*)
procedure TForm1.FormCreate(Sender: TObject);
begin
  PointBegin := Point(0,0);
  PointEnd := Point(0,0);
  DoFind:= TFindPath.Create(seYCount.Value, seXCount.Value);
end;
(*=================================================================
Отпускание кнопки мыши*)
procedure TForm1.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DrawWall := False;
end;
(*=================================================================
Вызывается функцией Find объекта TFindPath*)
procedure Draw(Row, Col: Integer);
begin
  Form1.FillQuadManually((Col)*QuadSize-1, (Row)*QuadSize-1, clYellow);
end;
(*=================================================================
Нажатие на кнопку "Выполнить"*)
procedure TForm1.btnGOClick(Sender: TObject);
var
  I, J: Integer;
begin
  for I := 1 to DoFind.MapRows do
    for J := 1 to DoFind.MapCols do begin
      if Image.Canvas.Pixels[J*QuadSize-1,I*QuadSize-1] = clYellow then
         FillQuadManually((J)*QuadSize-1, (I)*QuadSize-1, clWhite);
         if DoFind.Map[I, J] then
           FillQuadManually((J)*QuadSize-1, (I)*QuadSize-1, clGray);
      end;
  FillQuadManually(PointBegin.X*QuadSize-1, PointBegin.Y*QuadSize-1, clPurple);
  FillQuadManually(PointEnd.X*QuadSize-1, PointEnd.Y*QuadSize-1, clGreen);

  lbTime.Caption := '0';
  if not DoFind.Find(PointBegin.Y, PointBegin.X, PointEnd.Y, PointEnd.X, Draw) then
    ShowMessage('Путь не найден');
  lbTime.Caption := Inttostr(DoFind.SearchTime);
end;
(*Функция преобразует цвет указанного квадрата в число от 1 до 4*)
function TForm1.GetObjTypeFromMap(X, Y: Word): Byte;
var
  Col: TColor;
begin
  Col := Image.Canvas.Pixels[X*QuadSize-1,Y*QuadSize-1];
  case Col of
    clWhite, clYellow: Result := 1;
    clGray : Result := 2;
    clPurple : Result := 3;
    clGreen : Result := 4;
    else Result := 0;
  end;
end;

procedure TForm1.btnCardToMemoryClick(Sender: TObject);
var
   ColCount, RowCount: Word; // Количество столбцов и строк
   I,J: Word;
begin
  ColCount := Image.Width div QuadSize; // Число ячеек по горизонтали
  RowCount := Image.Height div QuadSize;// Число ячеек по вертикали

  DoFind.CreateNewMap(RowCount, ColCount);
  for I := 1 to ColCount do
    for J := 1 to RowCount do
      DoFind.Map[J, I] := (GetObjTypeFromMap(I, J)=2);
end;

procedure TForm1.Label5Click(Sender: TObject);
begin
  frmAboutBox.Show;
end;

procedure TForm1.Label6Click(Sender: TObject);
begin
  WinExec('NotePad ReadMe.txt',1);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DoFind.Free;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  DoFind.SaveMapToFile(SaveDialog1.FileName);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  I, J: Integer;
begin
  if not OpenDialog1.Execute then Exit;
  DoFind.LoadMapFromFile(OpenDialog1.FileName);
  seYCount.Value := DoFind.MapRows;
  seXCount.Value := DoFind.MapCols;
  for I := 1 to DoFind.MapRows do
    for J := 1 to DoFind.MapCols do
      if DoFind.Map[I, J] then
        Form1.FillQuadManually((J)*QuadSize-1, (I)*QuadSize-1, clGray);
end;

end.
