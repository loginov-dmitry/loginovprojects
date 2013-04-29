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


unit FindPath;

interface
uses
Windows, Types, Lists, Matrix;

type
  TFindPathProc = procedure(Row, Col: Integer);
  TFindPath = class(TObject)
  private
    function  GetMapEl(Row, Col: Integer): Boolean;
    procedure SetMapEl(Row, Col: Integer; const Value: Boolean);
    function  GetCMap(Row, Col: Integer): Real;
    procedure SetCMap(Row, Col: Integer; const Value: Real);
    function  GetMMap(Row, Col: Integer): Real;
    procedure SetMMap(Row, Col: Integer; const Value: Real);
  private
    Ws: TWorkspace; // Собственная рабочая область 
    mIdx, aIdx, m2Idx: Integer; // Индексы массивов
    iMapRows, iMapCols: Integer;// Размеры карты
    TempList, ListBegin, ListEnd: TPointList; // Списки

    {Определяет, существует ли прямолинейный путь}
    function  LinePathExists(Row1, Col1, Row2, Col2: Integer): Boolean;

    {Определяет наличие точки}
    function  PointExists(Row, Col: Integer): Boolean;

    {Поиск ключевых точек пути}
    function  FindKey(KeyIndex: Integer; MarkNum1, MarkNum2: Integer): Boolean;

    {Оптимизация найденного пути}
    procedure Optimize;

    {Дополнительный массив}
    property  AMap[Row, Col: Integer]: Real read GetCMap write SetCMap;

    {Карта с маркерными элементами}
    property  MMap[Row, Col: Integer]: Real read GetMMap write SetMMap;
  public
    PathList: TPointList; // После поиска будет хранить точки пути
    SearchTime: DWORD;    // Время поиска в миллисекундах

    {Создание объекта и матрицы карты}
    constructor Create(MapRows, MapCols: Integer); overload;

    destructor  Destroy; override;

    {Создание матрицы карты}
    procedure CreateNewMap(MapRows, MapCols: Integer);

    {Функция ищет точки пути и возвращает True, если путь найден}
    function  Find(bRow, bCol, eRow, eCol: Integer;
      Proc: TFindPathProc=nil): Boolean;

    {Сохранение карты в текстовый файл}
    procedure SaveMapToFile(FileName: String);

    {Загрузка карты из текстового файла}
    procedure LoadMapFromFile(FileName: String);
    
    {Карта с обозначением препятствий}
    property  Map[Row, Col: Integer]: Boolean read GetMapEl write SetMapEl;
    property  MapRows: Integer read iMapRows; // Определение числа строк карты
    property  MapCols: Integer read iMapCols; // Определение числа столбцов
  end;

implementation

uses SysUtils;

{ TFindPath }

constructor TFindPath.Create(MapRows, MapCols: Integer);
begin
  inherited Create;
  Ws:= TWorkspace.Create('MapArrays');
  mIdx := Ws.NewArray('Map', MapRows, MapCols);
  aIdx := Ws.NewArray('AMap', MapRows, MapCols);
  m2Idx := Ws.NewArray('MMap', MapRows, MapCols);
  iMapRows := MapRows;
  iMapCols := MapCols;
  PathList := TPointList.Create;
  TempList := TPointList.Create;
  ListBegin:= TPointList.Create;
  ListEnd  := TPointList.Create;  
end;

procedure TFindPath.CreateNewMap(MapRows, MapCols: Integer);
begin
  mIdx := Ws.NewArray('Map', MapRows, MapCols);
  aIdx := Ws.NewArray('AMap', MapRows, MapCols);
  m2Idx := Ws.NewArray('MMap', MapRows, MapCols);
  iMapRows := MapRows;
  iMapCols := MapCols;
end;

destructor TFindPath.Destroy;
begin
  Ws.Free;
  PathList.Free;
  TempList.Free;
  ListBegin.Free;
  ListEnd.Free;
  inherited Destroy;     
end;


function TFindPath.Find(bRow, bCol, eRow, eCol: Integer;
  Proc: TFindPathProc=nil): Boolean;
var
  I, MarkNum1, MarkNum2, Index: Integer; 
begin
  SearchTime := GetTickCount;
  Result := False;
  Ws.FillAr('AMap', 0, 0);
  Ws.FillAr('MMap', 0, 0);
  PathList.Clear; 
  PathList.Add(Point(bRow, bCol));
  PathList.Add(Point(eRow, eCol));
  MarkNum1   := 1;
  MarkNum2   := 2;
  while True do Begin
  Index := -1;
  for I := 0 to  PathList.Count-2 do
    if (abs(PathList.Items[I+1].X-PathList.Items[I].X)>1)or
       (abs(PathList.Items[I+1].Y-PathList.Items[I].Y)>1)
    then begin
      Index:=I;
      Break;
    end;
  if Index<0 then Break; // Путь уже найден
  if not FindKey(Index,MarkNum1, MarkNum2) then begin
    SearchTime := GetTickCount - SearchTime;
    Exit;
  end;
  Inc(MarkNum1,2);
  Inc(MarkNum2,2);
  end; // while
  Optimize;
  SearchTime := GetTickCount - SearchTime;
  if @Proc <> nil then
  for I := 1 to PathList.Count-2 do
    Proc(PathList.Items[I].X, PathList.Items[I].Y);
  Result := True; 
end;

function TFindPath.FindKey(KeyIndex, MarkNum1, MarkNum2: Integer): Boolean;
var
  I, J: Integer;
  X1,Y1,X2,Y2: Integer;
begin
  Result := False;
    // Если найден кратчайший прямой путь между ключевыми точками, то
    // Вставляем в список ключевых точек найденные точки
  if LinePathExists(PathList.Items[KeyIndex].X,
  PathList.Items[KeyIndex].Y,
  PathList.Items[KeyIndex+1].X,
  PathList.Items[KeyIndex+1].Y)  then begin
    for I := 0 to TempList.Count-1 do
     PathList.Insert(KeyIndex+1+I, TempList.Items[I]);
    Result := True;
    Exit;
  end;   
  ListBegin.Clear;
  ListEnd.Clear;
  ListBegin.Add(PathList.Items[KeyIndex]);
  ListEnd.Add(PathList.Items[KeyIndex+1]);
  while True do begin
    if ListBegin.Count=0 then Exit;
    X1 := ListBegin.Items[0].X;
    Y1 := ListBegin.Items[0].Y;
    ListBegin.Delete(0);
    if  MMap[X1,Y1]=MarkNum2  then begin
      PathList.Insert(KeyIndex+1, Point(X1, Y1));
      Result := True;
      Exit;
    end;
   if ((X1=PathList.Items[KeyIndex].X) AND
       (Y1=PathList.Items[KeyIndex].Y)) OR
      ((X1=PathList.Items[KeyIndex+1].X)AND
      (Y1=PathList.Items[KeyIndex+1].Y))
    then else
    MMap[X1,Y1] := MarkNum1;
      for I := X1 - 1 to X1 + 1  do                  //  1 0 1
      for J := Y1 - 1 to Y1 + 1  do begin            //  0 0 0
        if (I<>X1) AND (J<>Y1) then Continue;        //  1 0 1
        if not PointExists(I, J) then Continue;
        if Map[I, J] then Continue;
        if (MMap[I, J] = MarkNum1) then Continue;
       if (MMap[I, J] = MarkNum2) then begin
         PathList.Insert(KeyIndex+1,Point(I, J));
         Result := True;
         Exit;
       end;
       if  AMap[I, J] = MarkNum1  then  Continue;
        ListBegin.Add(Point(I, J));
        AMap[I, J] := MarkNum1;
      end;
      for I := X1 - 1 to X1 + 1  do                 //  0 1 0
      for J := Y1 - 1 to Y1 + 1  do begin           //  1 0 1
        if (I=X1) or (J=Y1) then Continue;          //  0 1 0
        if not PointExists(I, J) then Continue;
        if Map[I, J] then Continue;
        if (MMap[I, J] = MarkNum1) then Continue;
       if (MMap[I, J] = MarkNum2) then begin
         PathList.Insert(KeyIndex+1,Point(I, J));
         Result := True;
         Exit;
       end;
       if  AMap[I, J] = MarkNum1  then  Continue;
        ListBegin.Add(Point(I, J));
        AMap[I, J] := MarkNum1;
      end;
    if  ListBegin.Count=0 then Exit;
    if ListEnd.Count=0 then Exit;
    X2 := ListEnd.Items[0].X;
    Y2 := ListEnd.Items[0].Y;
    ListEnd.Delete(0);
    if  (MMap[X2,Y2]=MarkNum1)  then begin
      PathList.Insert(KeyIndex+1,Point(X2, Y2));
      Result := True;
      Exit;
    end;
   if ((X2=PathList.Items[KeyIndex].X) AND
       (Y2=PathList.Items[KeyIndex].Y)) OR
      ((X2=PathList.Items[KeyIndex+1].X)AND
      (Y2= PathList.Items[KeyIndex+1].Y))
    then else
    MMap[X2,Y2] := MarkNum2;
      for I := X2 - 1 to X2 + 1  do
      for J := Y2 - 1 to Y2 + 1  do begin
        if (I<>X2) AND (J<>Y2) then Continue;
        if not PointExists(I, J) then Continue;
        if Map[I, J] then Continue;
        if (MMap[I, J] = MarkNum2) then Continue;
       if (MMap[I, J] = MarkNum1) then begin
         PathList.Insert(KeyIndex+1,Point(I, J));
         Result := True;
         Exit;
       end;
       if  AMap[I, J] = MarkNum2  then  Continue;
         ListEnd.Add(Point(I, J));
        AMap[I, J] := MarkNum2;
      end;
      for I := X2 - 1 to X2 + 1  do
      for J := Y2 - 1 to Y2 + 1  do begin
        if (I=X2) or (J=Y2) then Continue;
        if not PointExists(I, J) then Continue;
        if Map[I, J] then Continue;
        if (MMap[I, J] = MarkNum2) then Continue;
       if (MMap[I, J] = MarkNum1) then begin
         PathList.Insert(KeyIndex+1,Point(I, J));
         Result := True;
         Exit;
       end;
       if  AMap[I, J] = MarkNum2  then  Continue;
         ListEnd.Add(Point(I, J));
        AMap[I, J] := MarkNum2;
      end;
      if  ListEnd.Count=0 then Exit;
  end; // while
end;

function TFindPath.GetCMap(Row, Col: Integer): Real;
begin
  Result := Ws.ElemI[aIdx, Row, Col];
end;

function TFindPath.GetMapEl(Row, Col: Integer): Boolean;
begin
  if (Row<1) or (Col<1) or (Row>iMapRows) or (Col>iMapCols) then
  Ws.DoError(matBadCoords);
  Result := (Ws.ElemI[mIdx, Row, Col]=1);
end;


function TFindPath.GetMMap(Row, Col: Integer): Real;
begin
  Result := Ws.ElemI[m2Idx, Row, Col];
end;

function TFindPath.LinePathExists(Row1, Col1, Row2, Col2: Integer): Boolean;
var
  dX, dY: Integer;
  XisLoopDir: Boolean;
  I: Integer;
  X, Y: Integer;
begin
  TempList.Clear;
  Result := False;
  dX := Row2-Row1;
  dY := Col2-Col1;
  if abs(dX)>=abs(dY) then XisLoopDir := True else XisLoopDir := False;
  if  XisLoopDir  then begin  // Если поиск по горизонтали
    if Row2>=Row1  then
    for I := Row1+1 to Row2-1 do begin // Ищем слева направо
      Y := Round((I-Row1)*(dY/abs(dX)))+Col1;
      if not Map[I, Y] then TempList.Add(Point(I,Y ))
      else Exit;
    end else
    for I := Row1-1 downto Row2+1 do begin // Ищем справа налево
      Y := Round((Row1-I)*(dY/abs(dX)))+Col1;
      if not Map[I, Y] then TempList.Add(Point(I,Y ))
      else Exit;
    end;  // if2
  end;  // if1   

  if not  XisLoopDir  then begin  // Если поиск по Вертикали
    if Col2>=Col1  then
    for I := Col1+1 to Col2-1 do begin // Ищем сверху вниз
      X := Round((I-Col1)*(dX/abs(dY)))+Row1;
      if not Map[X, I] then TempList.Add(Point(X,I ))
      else Exit;
    end else
    for I := Col1-1 downto Col2+1 do begin // Ищем снизу вверх
      X := Round((Col1-I)*(dX/abs(dY)))+Row1;
      if not Map[X, I] then TempList.Add(Point(X,I ))
      else Exit;
    end;  // if2
  end;  // if1
  Result := True;
end;

procedure TFindPath.LoadMapFromFile(FileName: String);
begin
  Ws.LoadFromTextFile(FileName);
  mIdx  := Ws.GetSize('Map', iMapRows, iMapCols);
  aIdx  := Ws.NewArray('AMap', iMapRows, iMapCols);
  m2Idx := Ws.NewArray('MMap', iMapRows, iMapCols);
end;

procedure TFindPath.Optimize;
var
  I, C: Integer;
begin     
  C := PathList.Count;
  for I := C-2 downto 1 do
    if (abs(PathList.Items[I+1].X - PathList.Items[I-1].X)<2) and
       (abs(PathList.Items[I+1].Y - PathList.Items[I-1].Y)<2) then
       PathList.Delete(I);  
end;

function TFindPath.PointExists(Row, Col: Integer): Boolean;
begin
  Result := True;
  if (Row<1) or (Col<1) or (Row>iMapRows) or (Col>iMapCols) then Result := False;
end;

procedure TFindPath.SaveMapToFile(FileName: String);
begin
  if FileExists(FileName) then DeleteFile(FileName);
  Ws.SaveToTextFile(FileName, 'Map');
end;

procedure TFindPath.SetCMap(Row, Col: Integer; const Value: Real);
begin
  Ws.ElemI[aIdx, Row, Col] := Value;
end;

procedure TFindPath.SetMapEl(Row, Col: Integer; const Value: Boolean);
begin
  if (Row<1) or (Col<1) or (Row>iMapRows) or (Col>iMapCols) then
  Ws.DoError(matBadCoords);
  Ws.ElemI[mIdx, Row, Col] := Byte(Value);
end;

procedure TFindPath.SetMMap(Row, Col: Integer; const Value: Real);
begin
  Ws.ElemI[m2Idx, Row, Col] := Value;
end;

end.
