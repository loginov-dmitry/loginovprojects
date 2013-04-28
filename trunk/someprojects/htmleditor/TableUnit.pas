{
Copyright (c) 2010, Loginov Dmitry Sergeevich
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

unit TableUnit;

interface

uses
  Windows, Messages, Classes, SysUtils, HTMLGlobal, SHDocVw, MSHTML, Math;

type
  TTableMask = record
    Num: Integer;
    Cell: IHTMLTableCell;
    IsCellStart: Boolean;
  end;

  TTableMaskArray = array of array of TTableMask;

  TTableClass = class
    HTMLInfo: THTMLEditorInfo;

    // Отыскивает таблицу. В качестве Index передается ячейка / строка / таблица
    function GetCurrentTable(var Index: Integer): IHTMLTable;

    // Отыскивает строку. В качестве Index передается таблица / строка
    function GetCurrentTableRow(var Index: Integer): IHTMLTableRow;

    // Отыскивает ячейку. В качестве Index передается таблица / строка / ячейка
    function GetCurrentTableCell(var Index: Integer): IHTMLTableCell;

    procedure CopyCellProp(ACell, NewCell: IHTMLTableCell);

    // Осуществляет разбиение указанной ячейки
    procedure DoCellDeSpan(Tab: IHTMLTable; ARow: IHTMLTableRow; ACell: IHTMLTableCell);

    // Возвращает структуру таблицы в массиве TTableMaskArray
    function GetTableMask(Tab: IHTMLTable; RowCount, AllColCount: Integer): TTableMaskArray;

    // Возвращает настоящее кол-во столбцов в таблице
    function GetTableRealColCount(Tab: IHTMLTable): Integer;

    // Добавляем строку в таблицу
    procedure DoTableAddRow(ToBottom: Boolean);

    procedure DoTableAddCol(ToLeft: Boolean);

    procedure DoTableMergeCell(ToRight: Boolean);

    procedure DoDelAttribSize(Width: Boolean);

    procedure DoTabDelColumn();

    procedure DoTabDelRow();

    procedure AddNewTable();

    // T - Все явно включены; F - Все явно выключены; D - стиль сброшен
    procedure ResetAllCellBorders(Value: Char);

    procedure ResetOneCellBorder(Side: Char; Value: Char);
  private
    function DocRange: IHTMLTxtRange;
  end;

implementation

uses PropertyFrm;



{ TTableClass }

procedure TTableClass.AddNewTable;
var
  TextRange: IHTMLTxtRange;
  AList, TableList: TStringList;
  AttrIdx, I, J, Cnt: Integer;
  attr: THTMLTagAttribs;
  S, S1, CellSpString, CellPadString, SCollapse, STabStyle, SCaption: string;
  SWidth, SHeight, SAlign, SBGColor, SBorderColor, SBorder: string;
  SBackGround, Stdwidth, Stdheight, Stdalign, Stdvalign, Stdbackground: string;
  Stdbgcolor, Stdbordercolor, Snowrap: string;
  Rows, Cols, Border: Integer;
  WidthRowNum: Integer;
  atrValue: THTMLAttribType;
begin
  TextRange := DocRange;
  if Assigned(TextRange) then
  begin
    AList := TStringList.Create;
    TableList := TStringList.Create;
    try
      AttrIdx := TagTranslatesList.IndexOfName('ADDNEWTABLE');
      attr := THTMLTagAttribs(TagTranslatesList.Objects[AttrIdx]);

      // Заполняем список
      for I := 0 to attr.AttrList.Count - 1 do
      begin
        S := attr.AttrList.Names[I];
        atrValue := THTMLAttribType(StrToInt(attr.AttrList.ValueFromIndex[I]));

        S1 := '';
        if S = 'TABROWS' then
          S1 := '3'
        else if S = 'TABCOLS' then
          S1 := '3'
        else if S = 'BORDER' then
          S1 := '1'
        else if S = 'WIDTH' then
          S1 := '70%'
        else if S = 'CELLSPACING' then
          S1 := '0';
          
        AList.AddObject(S + '=' + S1, TObject(atrValue));
      end;

      if ShowPropertyForm(AList, nil, 'Новая таблица') then
      begin
        Rows := StrToIntDef(AList.Values['TABROWS'], 1);
        Cols := StrToIntDef(AList.Values['TABCOLS'], 1);
        Border := StrToIntDef(AList.Values['BORDER'], 1);

        if Border > 0 then
          SBorder := ' BORDER=' + IntToStr(Border);

        S := AList.Values['CELLSPACING'];
        if StrToIntDef(S, -1) >= 0 then
          CellSpString := ' CELLSPACING=' + S;
        S := AList.Values['CELLPADDING'];
        if StrToIntDef(S, -1) >= 0 then
          CellPadString := ' CELLPADDING=' + S;

        if AList.Values['BORDERCOLLAPSE'] = '1' then
          SCollapse := 'border-collapse: collapse;';

        if SCollapse <> '' then
          STabStyle := ' style="' + SCollapse + '"';

        SCaption := AList.Values['TABLECAPTION'];
        if SCaption <> '' then
          SCaption := '<CAPTION>' + SCaption + '</CAPTION>';

        SWidth := AList.Values['WIDTH'];
        if SWidth <> '' then
          SWidth := ' WIDTH="' + SWidth + '"';

        SHeight := AList.Values['HEIGHT'];
        if SHeight <> '' then
          SHeight := ' HEIGHT="' + SHeight + '"';

        SAlign := AList.Values['ALIGN'];
        if SAlign <> '' then
          SAlign := ' ALIGN=' + SAlign;

        SBGColor := AList.Values['BGCOLOR'];
        if SBGColor <> '' then
          SBGColor := ' BGCOLOR=' + SBGColor;

        SBorderColor := AList.Values['BORDERCOLOR'];
        if SBorderColor <> '' then
          SBorderColor := ' BORDERCOLOR=' + SBorderColor;

        SBackGround := AList.Values['BACKGROUND'];
        if SBackGround <> '' then
          SBackGround := ' BACKGROUND="' + SBackGround + '"';

        // Свойства ячейки  
        Stdwidth := AList.Values['TDWIDTH'];
        if Stdwidth <> '' then
          Stdwidth := ' WIDTH="' + Stdwidth + '"';

        Stdheight := AList.Values['TDHEIGHT'];
        if Stdheight <> '' then
          Stdheight := ' HEIGHT="' + Stdheight + '"';

        Stdalign := AList.Values['TDALIGN'];
        if Stdalign <> '' then
          Stdalign := ' ALIGN=' + Stdalign;

        Stdvalign := AList.Values['TDVALIGN'];
        if Stdvalign <> '' then
          Stdvalign := ' VALIGN=' + Stdvalign;

        Stdbackground := AList.Values['TDBACKGROUND'];
        if Stdbackground <> '' then
          Stdbackground := ' BACKGROUND="' + Stdbackground + '"';

        Stdbgcolor := AList.Values['TDBGCOLOR'];
        if Stdbgcolor <> '' then
          Stdbgcolor := ' BGCOLOR=' + Stdbgcolor;

        Stdbordercolor := AList.Values['TDBORDERCOLOR'];
        if Stdbordercolor <> '' then
          Stdbordercolor := ' BORDERCOLOR=' + Stdbordercolor;

        if AList.Values['NOWRAP'] = '1' then
          Snowrap := ' nowrap';

        WidthRowNum := StrToIntDef(AList.Values['TDWIDTHROWNUM'], 0);

        Cnt := 0;
        S := Format('<TABLE%s%s%s%s%s%s%s%s%s%s>',
          [SWidth, SHeight, SBorder, CellSpString, CellPadString, STabStyle,
           SAlign, SBGColor, SBorderColor, SBackGround]);
        TableList.Add(S);
        if SCaption <> '' then
          TableList.Add(SCaption);
        for I := 1 to Rows do
        begin
          TableList.Add('<TR>');
          for J := 1 to Cols do
          begin
            Inc(Cnt);
            S1 := Stdwidth;
            if (WidthRowNum > 0) and (WidthRowNum <> I) then S1 := '';

            S := Format('%s%s%s%s%s%s%s%s', [S1, Stdheight, Stdalign, Stdvalign,
              Stdbackground, Stdbgcolor, Stdbordercolor, Snowrap]);
            S := Format('<TD%s>%d</TD>', [S, Cnt]);
            TableList.Add(S);
          end;
          TableList.Add('</TR>');
        end;

        TableList.Add('</TABLE>');

        TextRange.pasteHTML(TableList.Text);
      end;
    finally
      AList.Free;
      TableList.Free;
    end;
  end;
end;

procedure TTableClass.CopyCellProp(ACell, NewCell: IHTMLTableCell);
begin
  NewCell.rowSpan := ACell.rowSpan;
  NewCell.align := ACell.align;
  NewCell.vAlign := ACell.vAlign;
  NewCell.bgColor := ACell.bgColor;
  NewCell.noWrap := ACell.noWrap;

  if ACell.background <> '' then
    NewCell.background := ACell.background;

  NewCell.borderColor := ACell.borderColor;
  //NewCell.height := ACell.height;

  (NewCell as IHTMLElement).style.cssText := (ACell as IHTMLElement).style.cssText
end;

procedure TTableClass.DoCellDeSpan(Tab: IHTMLTable; ARow: IHTMLTableRow;
  ACell: IHTMLTableCell);
var
  HSpanCnt, VSpanCnt, I, J, ACellIndex, RowSpanCellIndex, RowIndex, CellNumber: Integer;
  TmpCounter: Integer;
  NewCell, TmpCell: IHTMLTableCell;
  TmpRow: IHTMLTableRow;
begin
  if Assigned(ACell) then
  begin
    HSpanCnt := ACell.colSpan;
    VSpanCnt := ACell.rowSpan;
    ACellIndex := ACell.cellIndex;
    RowIndex := ARow.rowIndex;
    CellNumber := 0;

    // Определяем порядковый номер ячейки
    for I := 0 to ACellIndex - 1 do
    begin
      TmpCell := ARow.cells.item(I, 0) as IHTMLTableCell;
      if TmpCell.rowSpan = 1 then
        CellNumber := CellNumber + TmpCell.colSpan;
    end;

    // Именно ячейка с №CellNumber будет первой из разъединенных

    // Сначало разбиваем ячейки по горизонтали
    if HSpanCnt > 1 then
    begin
      ACell.colSpan := 1;
      // Добавляем необходимое кол-во новых ячеек
      for I := 2 to HSpanCnt do
      begin
        NewCell := ARow.insertCell(ACellIndex + 1) as IHTMLTableCell;
        CopyCellProp(ACell, NewCell);
      end;
    end;

    // Разбиваем ячейки по вертикали
    if VSpanCnt > 1 then
    begin
      for J := RowIndex + 1 to (RowIndex + VSpanCnt - 1) do
      begin
        TmpRow := (Tab.rows.item(J, 0) as IHTMLTableRow);
        TmpCounter := 0;
        RowSpanCellIndex := 0;
        // Определяем, какая ячейка в TmpRow соответствует CellNumber
        if CellNumber = 0 then
          RowSpanCellIndex := -1
        else
        for I := 0 to TmpRow.cells.length - 1 do
        begin
          TmpCell := TmpRow.cells.item(I, 0) as IHTMLTableCell;
          TmpCounter := TmpCounter + TmpCell.colSpan;
          if TmpCounter >= CellNumber then
          begin
            RowSpanCellIndex := I; // Запоминаем номер ячейки для копирования
            Break;
          end;
        end;


        // Вставляем оставшиеся ячейки
        for I := 1 to HSpanCnt do
        begin
          TmpCell := ARow.cells.item(ACellIndex + I - 1, 0) as IHTMLTableCell;
          TmpCell.rowSpan := 1;

          // Вставляем начальную ячейку
          NewCell := TmpRow.insertCell(RowSpanCellIndex + 1) as IHTMLTableCell;
          CopyCellProp(ACell, NewCell);
        end;
      end;
    end;

  end;
end;

procedure TTableClass.DoDelAttribSize(Width: Boolean);
var
  Index: Integer;
  Tab: IHTMLTable;
  ARow: IHTMLTableRow;
  ACell: IHTMLTableCell;
  ATagName: string;

  procedure DelCellAttrib(ACell: IHTMLTableCell);
  begin
    if Width then
    begin
      ACell.width := '';
      (ACell as IHTMLElement).style.width := '';
    end else
    begin
      ACell.height := '';
      (ACell as IHTMLElement).style.height := '';
    end
  end;

  procedure DelRowAttrib(ARow: IHTMLTableRow);
  var
    I: Integer;
  begin
    if Width then
      (ARow as IHTMLElement).style.width := ''
    else
      (ARow as IHTMLElement).style.height := '';


    for I := 0 to ARow.cells.length - 1 do
      DelCellAttrib(ARow.cells.item(I, 0) as IHTMLTableCell);
  end;

  procedure DelTableAttrib(Tab: IHTMLTable);
  var
    I: Integer;
  begin
    if Width then
      Tab.width := ''
    else
      Tab.height := '';
      
    (Tab as IHTMLElement).style.width := '';
    for I := 0 to Tab.rows.length - 1 do
      DelRowAttrib(Tab.rows.item(I, 0) as IHTMLTableRow);
  end;

begin
  Index := HTMLInfo.CurrentIndex;
  Tab := GetCurrentTable(Index);
  ARow := GetCurrentTableRow(Index);
  ACell := GetCurrentTableCell(Index);

  ATagName := HTMLInfo.ElemDescArray[HTMLInfo.CurrentIndex].edTagName;
  if (ATagName = 'TD') or (ATagName = 'TH') then
    DelCellAttrib(ACell)
  else if ATagName = 'TR' then
    DelRowAttrib(ARow)
  else if ATagName = 'TABLE' then
    DelTableAttrib(Tab);
end;

procedure TTableClass.DoTabDelColumn;
var
  Index, I, J, ARowIndex, ACellIndex, DelMaskCol, DelCellCount: Integer;
  Tab: IHTMLTable;
  ARow, TmpRow: IHTMLTableRow;
  ACell, TmpCell: IHTMLTableCell;
  AllColCount, RowCount, TmpInt: Integer;
  TableMask: TTableMaskArray;
begin
  Index := HTMLInfo.CurrentIndex;
  Tab := GetCurrentTable(Index);
  ARow := GetCurrentTableRow(Index);
  ACell := GetCurrentTableCell(Index);

  if ACell = nil then
    raise Exception.Create('Столбец таблицы не выбран!');

  RowCount := Tab.rows.length;
  AllColCount := GetTableRealColCount(Tab);
  ARowIndex := ARow.rowIndex;
  ACellIndex := ACell.cellIndex;
  TableMask := GetTableMask(Tab, RowCount, AllColCount);


  DelCellCount := ACell.colSpan;

  // Определяем номер столбца в TableMask, который должен быть удален
  DelMaskCol := -1;
  TmpInt := -1;
  for I := 0 to AllColCount - 1 do
  begin
    if (TableMask[ARowIndex, I].Num = -1) and (TableMask[ARowIndex, I].IsCellStart) then
      Inc(TmpInt);
    if TmpInt = ACellIndex then
    begin
      DelMaskCol := I;
      Break;
    end;
  end;

  // Удаляем столбцы снизу вверх, т.к. при таком подходе мы имеем информацию
  // по верхним ячейкам, от которых распространяется span
  for I := RowCount - 1 downto 0 do
  begin
    TmpRow := tab.rows.item(I, 0) as IHTMLTableRow;

    for J := DelMaskCol + DelCellCount - 1 downto DelMaskCol do
    begin
      if TableMask[I, J].Num = -1 then
      begin
        TmpCell := TableMask[I, J].Cell;
        if Assigned(TmpCell) then
        begin
          if TmpCell.colSpan > 1 then
            TmpCell.colSpan := TmpCell.colSpan - 1
          else
          begin
            TmpRow.deleteCell(TmpCell.cellIndex);
          end;
        end;
      end;
    end;
  end;

end;

procedure TTableClass.DoTabDelRow;
var
  Index, I, J: Integer;
  Tab: IHTMLTable;
  ARow, TmpRow: IHTMLTableRow;
  CurRowIndex: Integer;
  ACell, TmpCell: IHTMLTableCell;

  function GetRowSpacedCell: IHTMLTableCell;
  var
    I: Integer;
  begin
    for I := 0 to ARow.cells.length - 1 do
    begin
      Result := ARow.cells.item(I, 0) as IHTMLTableCell;
      if Result.rowSpan > 1 then Exit;
    end;
    Result := nil;
  end;
begin
  Index := HTMLInfo.CurrentIndex;
  Tab := GetCurrentTable(Index);

  if Tab = nil then
    raise Exception.Create('Тэг TABLE не найден!');  

  if Tab.rows.length = 1 then
  begin
    (Tab as IHTMLElement).outerHTML := '';
    Exit;
  end;

  ARow := GetCurrentTableRow(Index);
  if ARow = nil then
    ARow := Tab.rows.item(Tab.rows.length - 1, 0) as IHTMLTableRow;

  // Сперва выполняем разбиение ячеек В ДАННОЙ СТРОКЕ, у которых выставлено rowSpace
  ACell := GetRowSpacedCell;
  while Assigned(ACell) do
  begin
    DoCellDeSpan(Tab, ARow, ACell);

    ACell := GetRowSpacedCell;
  end;

  CurRowIndex := ARow.rowIndex;

  // Ищем во всех верхних строках ячейки, которые могут распространяться на эту
  // строку. Уменьшаем во всех найденных ячейках св-во rowSpan
  for I := 0 to CurRowIndex - 1 do
  begin
    TmpRow := Tab.rows.item(I, 0) as IHTMLTableRow;
    for J := 0 to TmpRow.cells.length - 1 do
    begin
      TmpCell := TmpRow.cells.item(J, 0) as IHTMLTableCell;
      if TmpCell.rowSpan > (CurRowIndex - TmpRow.rowIndex) then
        TmpCell.rowSpan := TmpCell.rowSpan - 1;
    end;
  end;                                         
  
  Tab.deleteRow(CurRowIndex);
end;

procedure TTableClass.DoTableAddCol(ToLeft: Boolean);
var
  Index, I, J, ARowIndex, ACellIndex, AddMaskCol, AddCellCount: Integer;
  Tab: IHTMLTable;
  ARow, TmpRow: IHTMLTableRow;
  ACell, TmpCell, OldCell: IHTMLTableCell;
  AllColCount, RowCount, TmpInt, VisCells: Integer;
  TableMask: TTableMaskArray;

  function IsClearRow(ARowIndex: Integer): Boolean;
  var
    I: Integer;
    ACell: IHTMLTableCell;
  begin
    Result := False;
    ACell := TableMask[ARowIndex, 0].Cell;
    if ACell.colSpan < 5 then Exit;
    
    for I := 1 to AllColCount - 1 do
      if Pointer(TableMask[ARowIndex, I].Cell) <> Pointer(ACell) then Exit;

    Result := True;
  end;
begin
  Index := HTMLInfo.CurrentIndex;
  Tab := GetCurrentTable(Index);
  ARow := GetCurrentTableRow(Index);

  ACell := GetCurrentTableCell(Index);

  if ACell = nil then
    raise Exception.Create('Столбец таблицы не выбран!');

  RowCount := Tab.rows.length;
  AllColCount := GetTableRealColCount(Tab);
  ARowIndex := ARow.rowIndex;
  ACellIndex := ACell.cellIndex;
  TableMask := GetTableMask(Tab, RowCount, AllColCount);

  if Assigned(HTMLInfo.ActiveElement) then
    HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;

  AddCellCount := ACell.colSpan;

  // Определяем номер столбца в TableMask, с которое следует начать добавление
  AddMaskCol := -1;
  TmpInt := -1;
  for I := 0 to AllColCount - 1 do
  begin
    if (TableMask[ARowIndex, I].Num = -1) and (TableMask[ARowIndex, I].IsCellStart) then
      Inc(TmpInt);
    if TmpInt = ACellIndex then
    begin
      AddMaskCol := I;
      Break;
    end;
  end;

  for I := RowCount - 1 downto 0 do
  begin
    TmpRow := tab.rows.item(I, 0) as IHTMLTableRow;

    if IsClearRow(I) then // Если это одна пустая строка...
    begin
      TableMask[I, 0].Cell.colSpan := TableMask[I, 0].Cell.colSpan + AddCellCount
    end else
    begin
      //AddCounter := AddCellCount;

      // Определяем количество видимых ячеек для требуемого диапазона
      TmpCell := nil;
      VisCells := 0;
      for J := AddMaskCol to AddMaskCol + AddCellCount - 1 do
      begin
        if TableMask[I, J].Num = -1 then
        begin
          if Pointer(TableMask[I, J].Cell) <> Pointer(TmpCell) then
          begin
            Inc(VisCells);
            TmpCell := TableMask[I, J].Cell;
          end;
        end;
      end;

      OldCell := nil;
      TmpCell := nil;
      if ToLeft then
      begin
        for J := AddMaskCol + AddCellCount - 1 downto AddMaskCol do
        begin
          if TableMask[I, J].Num = -1 then
          begin
            if Pointer(TableMask[I, J].Cell) = Pointer(OldCell) then
              TmpCell.colSpan := TmpCell.colSpan + 1
            else
            begin
              TmpCell := TmpRow.insertCell(TableMask[I, J].Cell.cellIndex - VisCells + 1) as IHTMLTableCell;

              CopyCellProp(TableMask[I, J].Cell, TmpCell);
              (TmpCell as IHTMLElement).innerText := '???';
            end;
            OldCell := TableMask[I, J].Cell;
          end;
        end;
      end else
      begin
        for J := AddMaskCol to AddMaskCol + AddCellCount - 1 do
        begin
          if TableMask[I, J].Num = -1 then
          begin
            if Pointer(TableMask[I, J].Cell) = Pointer(OldCell) then
              TmpCell.colSpan := TmpCell.colSpan + 1
            else
            begin
              TmpCell := TmpRow.insertCell(TableMask[I, J].Cell.cellIndex + VisCells) as IHTMLTableCell;

              CopyCellProp(TableMask[I, J].Cell, TmpCell);
              (TmpCell as IHTMLElement).innerText := '???';
            end;
            OldCell := TableMask[I, J].Cell;
          end;
        end;
      end;

    end;
  end;
end;

procedure TTableClass.DoTableAddRow(ToBottom: Boolean);
var
  Index, I, J, ARowIndex: Integer;
  Tab: IHTMLTable;
  ARow, NewRow: IHTMLTableRow;
  NewCell, TmpCell: IHTMLTableCell;
  AllColCount, RowCount, CellCounter: Integer;
  TableMask: TTableMaskArray;

  function CanReplaceSpan(ARowIndex: Integer; MaskValue: TTableMask): Boolean;
  begin
    Result := False;
    if (MaskValue.Num >= 0) and Assigned(MaskValue.Cell) then
    begin
      Result := (ARowIndex + 1) >= (MaskValue.Num + MaskValue.Cell.rowSpan);
    end;
  end;
begin
  if Assigned(HTMLInfo.ActiveElement) then
    HTMLInfo.ActiveElement.style.backgroundColor := HTMLInfo.ActiveElementColor;
    
  Index := HTMLInfo.CurrentIndex;
  Tab := GetCurrentTable(Index);
  ARow := GetCurrentTableRow(Index);
  if ARow = nil then // Берем последнюю строку
    ARow := Tab.rows.item(Tab.rows.length - 1, 0) as IHTMLTableRow;

  RowCount := Tab.rows.length;
  AllColCount := GetTableRealColCount(Tab);
  ARowIndex := ARow.rowIndex;
  TableMask := GetTableMask(Tab, RowCount, AllColCount);

  if ToBottom then // Вставить вниз
    NewRow := Tab.insertRow(ARowIndex + 1) as IHTMLTableRow
  else // Вставить вверх
    NewRow := Tab.insertRow(ARowIndex) as IHTMLTableRow;

  CellCounter := 0;
  for I := 0 to AllColCount - 1 do
  begin
    TmpCell := TableMask[ARowIndex, I].Cell;
    if Assigned(TmpCell) then
    begin
      if (TableMask[ARowIndex, I].Num = -1) then // Если собственная ячейка
      begin
        if TableMask[ARowIndex, I].IsCellStart then // Если это-начало ячейки
        begin
          if (TmpCell.rowSpan = 1) or (not ToBottom) then // Если не распространяется вниз
          begin
            NewCell := NewRow.insertCell(CellCounter) as IHTMLTableCell;
            Inc(CellCounter);
            CopyCellProp(TmpCell, NewCell);
            NewCell.rowSpan := 1;
            NewCell.colSpan := TmpCell.colSpan;
          end else
          begin
            // Иначе просто увеличиваем rowSpan для предыдущего ряда
            TmpCell.rowSpan := TmpCell.rowSpan + 1;
          end;
        end;
      end
      else if TableMask[ARowIndex, I].Num >= 0 then
      begin // Если ячейка распространена сверху, но достигла предела..
        if ToBottom and CanReplaceSpan(ARowIndex, TableMask[ARowIndex, I]) then
        begin
          NewCell := NewRow.insertCell(CellCounter) as IHTMLTableCell;
          Inc(CellCounter);
          CopyCellProp(TmpCell, NewCell);
          NewCell.rowSpan := 1;
          NewCell.colSpan := TmpCell.colSpan;
        end else
          TmpCell.rowSpan := TmpCell.rowSpan + 1;
        // Обнуляем ссылки на такие же ячейки
        for J := 0 to AllColCount - 1 do
          if Pointer(TableMask[ARowIndex, J].Cell) = Pointer(TmpCell) then
            TableMask[ARowIndex, J].Cell := nil;
      end;
    end;
  end;
end;

procedure TTableClass.DoTableMergeCell(ToRight: Boolean);
var
  Index, I, J, ARowIndex, ACellIndex, MergeMaskCol, MergeCellCount, MergeRowCount: Integer;
  Tab: IHTMLTable;
  ARow: IHTMLTableRow;
  ACell, TmpCell, OldCell: IHTMLTableCell;
  AllColCount, RowCount, TmpInt, ACounter: Integer;
  TableMask: TTableMaskArray;
  CanDelRow: Boolean;
begin
  Index := HTMLInfo.CurrentIndex;
  Tab := GetCurrentTable(Index);

  if Tab = nil then
    raise Exception.Create('Таблица не выбрана!');  

  ARow := GetCurrentTableRow(Index);
  ACell := GetCurrentTableCell(Index);

  if ACell = nil then
    raise Exception.Create('Столбец таблицы не выбран!');

  RowCount := Tab.rows.length;
  AllColCount := GetTableRealColCount(Tab);
  ARowIndex := ARow.rowIndex;
  ACellIndex := ACell.cellIndex;


  if ToRight and (ACellIndex = ARow.cells.length - 1) then
    Exit;

  TableMask := GetTableMask(Tab, RowCount, AllColCount);

  MergeCellCount := ACell.colSpan; // Число столбцов в первоначальной ячейке
  MergeRowCount := ACell.rowSpan; // Число строк в первоначальной ячейке


  if (not ToRight) and (ARowIndex + MergeRowCount = Tab.rows.length) then
    Exit;

  // Определяем номер столбца в TableMask, с которого должно начаться объединение
  MergeMaskCol := -1;
  TmpInt := -1;
  for I := 0 to AllColCount - 1 do
  begin
    if (TableMask[ARowIndex, I].Num = -1) and (TableMask[ARowIndex, I].IsCellStart) then
      Inc(TmpInt);
    if TmpInt = ACellIndex then
    begin
      MergeMaskCol := I;
      Break;
    end;
  end;

  if ToRight then
  begin

    // Проверяем для первой строки
    if TableMask[ARowIndex, MergeMaskCol + MergeCellCount].Num <> -1 then
      raise Exception.Create('Ячейка справа уже является объединенной! Воспользуйтесь сначала '+
        'командой разбиения!');

    // Запоминаем ячейку из верхней строки    
    TmpCell := TableMask[ARowIndex, MergeMaskCol + MergeCellCount].Cell;

    if TmpCell.rowSpan > MergeRowCount then
      raise Exception.Create('Ячейка справа имеет слишком много строк! Воспользуйтесь сначала '+
        'командой разбиения!');

    ACounter := TmpCell.rowSpan;;

    // При необходимости объединяем ячейки справа
    for I := ARowIndex + 1 to ARowIndex + MergeRowCount - 1 do
    begin
      if TableMask[I, MergeMaskCol + MergeCellCount].Cell.colSpan <> TmpCell.colSpan then
        raise Exception.Create('Невозможно объединить с правыми ячейками, т.к. они имеют разную ширину!');

      if TableMask[I, MergeMaskCol + MergeCellCount].Num = -1 then
        ACounter := ACounter + TableMask[I, MergeMaskCol + MergeCellCount].Cell.rowSpan;
    end;

    if ACounter <> MergeRowCount then
      raise Exception.Create('Невозможно объединить с правой ячейкой! Воспользуйтесь сначала '+
        'разбиением или вертикальным объединением правой ячейки!');

    // Объединяем строки в правом столбце
    for I := ARowIndex + MergeRowCount - 1 downto ARowIndex + 1 do
    begin
      if TableMask[I, MergeMaskCol + MergeCellCount].Num = -1 then
      begin
        OldCell := TableMask[I, MergeMaskCol + MergeCellCount].Cell;
        if Pointer(OldCell) <> Pointer(TmpCell) then
        begin
          TmpCell.rowSpan := TmpCell.rowSpan + OldCell.rowSpan;
          (TmpCell as IHTMLElement).innerHTML := (TmpCell as IHTMLElement).innerHTML +
            (OldCell as IHTMLElement).innerHTML;
          (Tab.rows.item(I, 0) as IHTMLTableRow).deleteCell(OldCell.cellIndex);
          TableMask[I, MergeMaskCol + MergeCellCount].Num := -2;
          TableMask[I, MergeMaskCol + MergeCellCount].Cell := nil;


          if (Tab.rows.item(I, 0) as IHTMLTableRow).cells.length = 0 then
          begin
            if ACell.rowSpan > 1 then
              ACell.rowSpan := ACell.rowSpan - 1;

            for J := 0 to AllColCount - 1 do
              if TableMask[I, J].Num >= 0 then
                if TableMask[I, J].Cell.rowSpan > 1 then
                  TableMask[I, J].Cell.rowSpan := TableMask[I, J].Cell.rowSpan - 1;

            Tab.deleteRow(I);
          end;
        end;
      end;
    end;


    ACell.colSpan := ACell.colSpan + TmpCell.colSpan;
    (ACell as IHTMLElement).innerHTML := (ACell as IHTMLElement).innerHTML +
      (TmpCell as IHTMLElement).innerHTML;

    ARow.deleteCell(TmpCell.cellIndex);
    TableMask[ARowIndex, MergeMaskCol + MergeCellCount].Num := -2;


  end else
  begin
    if (TableMask[ARowIndex + MergeRowCount, MergeMaskCol].Num <> -1) or
       (not TableMask[ARowIndex + MergeRowCount, MergeMaskCol].IsCellStart) then
      raise Exception.Create('Ячейка снизу уже является объединенной! Воспользуйтесь сначала '+
        'командой разбиения!');


    TmpCell := TableMask[ARowIndex + MergeRowCount, MergeMaskCol].Cell;

    ACounter := TmpCell.colSpan;

    for I := MergeMaskCol + 1 to MergeMaskCol + MergeCellCount - 1 do
    begin
      if TableMask[ARowIndex + MergeRowCount, I].Cell.rowSpan <> TmpCell.rowSpan then
        raise Exception.Create('Невозможно объединить с нижними ячейками, т.к. они имеют разную высоту!');
      if TableMask[ARowIndex + MergeRowCount, I].IsCellStart and
        (TableMask[ARowIndex + MergeRowCount, I].Num = -1) then
        ACounter := ACounter + TableMask[ARowIndex + MergeRowCount, I].Cell.colSpan;
    end;

    if ACounter <> MergeCellCount then
      raise Exception.Create('Невозможно объединить с нижней ячейкой! Воспользуйтесь сначала '+
        'разбиением или горизонтальным объединением нижней ячейки!');

    // Объединяем столбцы в нижней ячейке
    for I := MergeMaskCol + MergeCellCount - 1 downto MergeMaskCol + 1 do
    begin
      if TableMask[ARowIndex + MergeRowCount, I].IsCellStart then
      begin
        OldCell := TableMask[ARowIndex + MergeRowCount, I].Cell;
        if Pointer(OldCell) <> Pointer(TmpCell) then
        begin
          TmpCell.colSpan := TmpCell.colSpan + OldCell.colSpan;
          (TmpCell as IHTMLElement).innerHTML := (TmpCell as IHTMLElement).innerHTML +
            (OldCell as IHTMLElement).innerHTML;
          (Tab.rows.item(ARowIndex + MergeRowCount, 0) as IHTMLTableRow).deleteCell(
            OldCell.cellIndex);
          TableMask[ARowIndex + MergeRowCount, I].Num := -2;
          TableMask[ARowIndex + MergeRowCount, I].Cell := nil;
        end;
      end;
    end;

    ACell.rowSpan := ACell.rowSpan + TmpCell.rowSpan;
    (ACell as IHTMLElement).innerHTML := (ACell as IHTMLElement).innerHTML +
      (TmpCell as IHTMLElement).innerHTML;

    (Tab.rows.item(ARowIndex + MergeRowCount, 0) as IHTMLTableRow).deleteCell(TmpCell.cellIndex);
    TableMask[ARowIndex + MergeRowCount, MergeMaskCol].Num := -2;
    TableMask[ARowIndex + MergeRowCount, MergeMaskCol].Cell := nil;

    if (Tab.rows.item(ARowIndex + MergeRowCount, 0) as IHTMLTableRow).cells.length = 0 then
    begin
      if ACell.rowSpan > 1 then
        ACell.rowSpan := ACell.rowSpan - 1;

      for J := 0 to AllColCount - 1 do
        if Assigned(TableMask[ARowIndex + MergeRowCount, J].Cell) and
          (TableMask[ARowIndex + MergeRowCount, J].Num >= 0) then
          if TableMask[TableMask[ARowIndex + MergeRowCount, J].Num, J].IsCellStart then
            if TableMask[ARowIndex + MergeRowCount, J].Cell.rowSpan > 1 then
              TableMask[ARowIndex + MergeRowCount, J].Cell.rowSpan :=
                TableMask[ARowIndex + MergeRowCount, J].Cell.rowSpan - 1;

      Tab.deleteRow(ARowIndex + MergeRowCount);
    end;
  end;
end;

function TTableClass.GetCurrentTable(var Index: Integer): IHTMLTable;
var
  I: Integer;
begin
  Result := nil;

  if HTMLInfo.ElemDescArray[Index].edTagName <> 'TABLE' then
  begin
    for I := Index + 1 to High(HTMLInfo.ElemDescArray) do
      if HTMLInfo.ElemDescArray[I].edTagName = 'TABLE' then
      begin
        Index := I;
        Break;
      end;
  end;

  if HTMLInfo.ElemDescArray[Index].edTagName = 'TABLE' then
    Result := HTMLInfo.ElemDescArray[Index].edElem as IHTMLTable;
end;

function TTableClass.GetCurrentTableCell(var Index: Integer): IHTMLTableCell;
var
  I: Integer;

  function IsCell(S: string): Boolean;
  begin
    Result := (S = 'TD') or (S = 'TH');
  end;
begin
  Result := nil;

  if not IsCell(HTMLInfo.ElemDescArray[Index].edTagName) then
  begin
    for I := Index - 1 downto 0 do
      if IsCell(HTMLInfo.ElemDescArray[I].edTagName) then
      begin
        Index := I;
        Break;
      end;
  end;

  if IsCell(HTMLInfo.ElemDescArray[Index].edTagName) then
    Result := HTMLInfo.ElemDescArray[Index].edElem as IHTMLTableCell;
end;

function TTableClass.GetCurrentTableRow(var Index: Integer): IHTMLTableRow;
var
  I: Integer;
begin
  Result := nil;

  if HTMLInfo.ElemDescArray[Index].edTagName <> 'TR' then
  begin
    for I := Index - 1 downto 0 do
      if HTMLInfo.ElemDescArray[I].edTagName = 'TR' then
      begin
        Index := I;
        Break;
      end;
  end;

  if HTMLInfo.ElemDescArray[Index].edTagName = 'TR' then
    Result := HTMLInfo.ElemDescArray[Index].edElem as IHTMLTableRow;
end;

function TTableClass.GetTableMask(Tab: IHTMLTable; RowCount,
  AllColCount: Integer): TTableMaskArray;
var
  I, J, K, L, M, CSpan, RSpan: Integer;
  ARow: IHTMLTableRow;
  TmpCell: IHTMLTableCell;

  LastI, LastJ, LastK, LastL, LastM: Integer;
begin
  // Инициализируем массив. Забиваем его значениями -2
  SetLength(Result, RowCount, AllColCount);
  for I := 0 to RowCount - 1 do
    for J := 0 to AllColCount - 1 do
    begin
      Result[I, J].Num := -2;
      Result[I, J].Cell := nil;
      Result[I, J].IsCellStart := False;
    end;

  LastI := -1;
  LastJ := -1;
  LastK := -1;
  LastL := -1;
  LastM := -1;

  try
    for I := 0 to RowCount - 1 do
    begin
      LastI := I;

      ARow := Tab.rows.item(I, 0) as IHTMLTableRow;
      for J := 0 to ARow.cells.length - 1 do
      begin
        LastJ := J;

        TmpCell := ARow.cells.item(J, 0) as IHTMLTableCell;
        CSpan := TmpCell.colSpan;
        RSpan := TmpCell.rowSpan;

        // Отыскиваем в массиве первую ячейку с -2.

        for K := 0 to AllColCount - 1 do
        begin
          LastK := K;

          if Result[I, K].Num = -2 then
          begin
            // Записываем значения "-1" (т.е. здесь - реальные ячейки строки)
            for L := K to Min(K + CSpan - 1, AllColCount - 1) do
            begin
              LastL := L;

              Result[I, L].Num := -1;
              if L = K then
                Result[I, L].IsCellStart := True;

              Result[I, L].Cell := TmpCell;

              // Заполняем элементы ниже (для RSpan)
              for M := I + 1 to I + RSpan - 1 do
              begin
                LastM := M;

                Result[M, L].Num := I; // Действует rowSpan от I-й строки
                Result[M, L].Cell := TmpCell; // Сохраняем действующую ячейку
              end;
            end;
            Break;
          end;
        end;

      end;
    end;
  except
  //LastI, LastJ, LastK, LastL, LastM
    on E: Exception do
      raise Exception.CreateFmt('LastI=%d, LastJ=%d, LastK=%d, LastL=%d, LastM=%d. ' + E.Message,
      [LastI, LastJ, LastK, LastL, LastM]);
  end;

end;

function TTableClass.GetTableRealColCount(Tab: IHTMLTable): Integer;
var
  I: Integer;
  ARow: IHTMLTableRow;
begin
  Result := 0;
  // Считаем, что первый ряд описывает кол-во столбцов в таблице
  ARow := Tab.rows.item(0, 0) as IHTMLTableRow;
  for I := 0 to ARow.cells.length - 1 do
    Result := Result + (ARow.cells.item(I, 0) as IHTMLTableCell).colSpan;
end;

procedure TTableClass.ResetAllCellBorders(Value: Char);
var
  Index: Integer;
  ACell: IHTMLTableCell;
  Param: string;
begin
  Index := HTMLInfo.CurrentIndex;
  ACell := GetCurrentTableCell(Index);
  if ACell <> nil then
  begin
    case Value of
      'T': Param := 'solid';
      'F': Param := 'none';
    else
      Param := '';
    end;

    (ACell as IHTMLElement).style.borderLeftStyle := Param;
    (ACell as IHTMLElement).style.borderTopStyle := Param;
    (ACell as IHTMLElement).style.borderRightStyle := Param;
    (ACell as IHTMLElement).style.borderBottomStyle := Param;
  end;
end;

procedure TTableClass.ResetOneCellBorder(Side, Value: Char);
var
  Index: Integer;
  ACell: IHTMLTableCell;
  Param: string;
begin
  Index := HTMLInfo.CurrentIndex;
  ACell := GetCurrentTableCell(Index);
  if ACell <> nil then
  begin
    case Value of
      'T': Param := 'solid';
      'F': Param := 'none';
    else
      Param := '';
    end;

    case Side of
      'L': (ACell as IHTMLElement).style.borderLeftStyle := Param;
      'T': (ACell as IHTMLElement).style.borderTopStyle := Param;
      'R': (ACell as IHTMLElement).style.borderRightStyle := Param;
      'B': (ACell as IHTMLElement).style.borderBottomStyle := Param;
    end;      
  end;
end;

function TTableClass.DocRange: IHTMLTxtRange;
var
  SelType: string;
begin
  Result := nil;
  SelType := HTMLInfo.editor.selection.type_; // None / Text / Control
  if SelType <> 'Control' then
    Result := (HTMLInfo.editor.selection.createRange as IHTMLTxtRange);
end;


end.
