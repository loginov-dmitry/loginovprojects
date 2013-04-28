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

unit PolyFuncs;

interface

uses Matrix;

const 
  matGaluaErrorValue = 'Степень поля Галуа задана неверно';
  matGaluaTableNotFound = 'Таблица Галуа не найдена';
  matGaluaBadElem = 'Элементы поля Галуа заданы неверно';


{Генерация поля сложения или умножения}
procedure GenerateGaluaTable(Ws: TWorkspace; TableName: string;
  Value: Integer; TabSum: Boolean = True);

{Деление полиномов. Поддерживаются вычисления в конечных полях Галуа}
procedure DivPolinoms(Ws: TWorkspace; DelimName, DelitName, ChastnName,
  OstatName: string; GaluaValue: Integer = 0; ClearGalua: Boolean = True);

{Суммирование полиномов (можно в поле Галуа)}
procedure SumPolinoms(Ws: TWorkspace; Pol1, Pol2, PolResult: string;
  GaluaValue: Integer = 0; ClearGalua: Boolean = True);

{Умножение полиномов (можно в поле Галуа)}
procedure MulPolinoms(Ws: TWorkspace; Pol1, Pol2, PolResult: string;
  GaluaValue: Integer = 0; ClearGalua: Boolean = True);

{Простой сдвиг строк массива вправо или влево}
function Shift(Ws: TWorkspace; SourAr, DestAr: string; Value: Integer;
  Rigth: Boolean = True): string;

{Циклический сдвиг строк массива вправо или влево}
function CirShift(Ws: TWorkspace; SourAr, DestAr: string; Value: Integer;
  Rigth: Boolean = True): string;

implementation

procedure GenerateGaluaTable(Ws: TWorkspace; TableName: string;
  Value: Integer; TabSum: Boolean = True);
var
  Rows, Cols, I: Integer;
  TempRow: string;
begin
  with Ws do
  begin
    if Value <= 1 then DoError(matGaluaErrorValue);
    CheckResAr(TableName);
    TempRow := GenName();
    Rows := Value;
    Cols := Value;
    NewArray(TableName, Rows, Cols, True);
    if TabSum then
      NewArray(TempRow, 0, Value - 1, 1) 
    else
      NewArray(TempRow, 1, Value - 1, 1);
    if TabSum then
      for I := 1 to Rows do 
      begin
        PasteSubmatrix(TempRow, TableName, I, 1);
        CirShift(Ws, TempRow, TempRow, 1, False);
      end else
      for I := 2 to Rows do 
      begin
        PasteSubmatrix(TempRow, TableName, I, 2);
        CirShift(Ws, TempRow, TempRow, 1, False);
      end;
    Clear(TempRow);
  end;
end;

function GetGaluaVal(Ws: TWorkspace; TableName: string; Val1, Val2: Real): Real;
var
  Galua, Cols, Rows, Value1, Value2: Integer;
begin
  with Ws do
  begin
    if TableName = '+' then 
      Result := Val1 + Val2 
    else
      if TableName = '*' then 
        Result := Val1 * Val2 
      else
      begin
        if Find(TableName) = -1 then 
          DoError(matGaluaTableNotFound);
        Value1 := Round(Val1);
        Value2 := Round(Val2);
        GetSize(TableName, Rows, Cols);
        if Cols <> Rows then 
          DoError(matGaluaTableNotFound);
        Galua := Cols;
        if (Value1 < 0) or (Value1 >= Galua) or (Value2 < 0) or (Value2 >= Galua)
          then DoError(matGaluaBadElem);
        Result := Elem[TableName, Value1 + 1, Value2 + 1];
      end;
  end;
end;

procedure DivPolinoms(Ws: TWorkspace; DelimName, DelitName, ChastnName,
  OstatName: string; GaluaValue: Integer = 0; ClearGalua: Boolean = True);
var
  J: Integer;
  StDelim, StDelit, StChastn, PosOstat: Integer;
  KoefChastn, NeedValue: Real;
  Delimoe, Delitel, SumTable, MulTable: string;
  iDelimoe, iDelitel, iChastnName, iOstatName: Integer;

  function Stepen(VektorName: string): Integer;
  var
    I, Cols, Ind: Integer;
  begin
    with Ws do
    begin
      Ind := GetIndex(VektorName);
      Cols := GetCols(Ind);
      Result := -1;
      for I := Cols downto 1 do
        if ElemI[Ind, 1, I] <> 0 then begin
          Result := I - 1;
          Exit;
        end;
    end;
  end; //  function Stepen

  function FindGalua(TableName: string; Index, Value: Real): Real;
  var
    I, Cols: Integer;
  begin
    with Ws do
    begin
      Cols := GetCols(TableName);
      if GetRows(TableName) <> Cols then DoError(matGaluaTableNotFound);
      Result := -1;
      for I := 1 to Cols do
        if Round(Elem[TableName, I, Round(Index) + 1]) = Round(Value) then begin
          Result := I - 1;
          Exit;
        end;
    end;
  end; // function FindGalua

begin
  with Ws do
  begin
    CheckResAr(ChastnName, False);
    CheckResAr(OstatName, False);
    Delimoe := GenName();
    Delitel := GenName();
    SumTable := GenName('SumTable');
    MulTable := GenName('MulTable');

    if (GetRows(DelimName) > 1) or (GetRows(DelitName) > 1) then
      DoError(matIsNotVektor);

    if (GaluaValue = 1) or (GaluaValue < 0) then DoError(matGaluaErrorValue);

    if Stepen(DelimName) <> -1 then
      if Stepen(DelitName) > Stepen(DelimName) then
      begin
        CopyArray(DelimName, OstatName);
        NewArray(ChastnName, 1, 1, True);
        CopySubmatrix(OstatName, OstatName, 1, 1, 1, Stepen(OstatName) + 1);
        Exit;
      end;

    if Stepen(DelitName) = -1 then DoError(matDivsionByZero) else
      if Stepen(DelimName) = -1 then
      begin
        Resize(ChastnName, 1, 1);
        Elem[ChastnName, 1, 1] := 0;
        Resize(OstatName, 1, 1);
        Elem[OstatName, 1, 1] := 0;
      end else
      begin
        //Генерируем таблицы Галуа
        if GaluaValue > 1 then
        begin
          if (Find(SumTable) = -1) or (GetCols(SumTable) <> GaluaValue) or
            (GetRows(SumTable) <> GaluaValue) then
            GenerateGaluaTable(Ws, SumTable, GaluaValue, True); // Таблица сложения
          if (Find(MulTable) = -1) or (GetCols(MulTable) <> GaluaValue) or
            (GetRows(MulTable) <> GaluaValue) then
            GenerateGaluaTable(Ws, MulTable, GaluaValue, False); // Таблица умножения
        end;
        // Копируем делимое во временную переменную
        CopySubmatrix(DelimName, Delimoe, 1, 1, 1, Stepen(DelimName) + 1);
        IDelimoe := GetIndex(Delimoe);
        // Копируем делитель во временную переменную
        CopySubmatrix(DelitName, Delitel, 1, 1, 1, Stepen(DelitName) + 1);
        iDelitel := GetIndex(Delitel);
        // Создаем массив частного
        IChastnName := NewArray(ChastnName, 1, Stepen(DelimName) -
          Stepen(DelitName) + 1, True);
        // Начинаем цикл деления
        while true do
        begin
          StDelim := Stepen(Delimoe);
          StDelit := Stepen(Delitel);
          if StDelit > StDelim then
            DoError('Степень делителя оказалась больше, чем степень делимого');
          StChastn := StDelim - StDelit;
          // Определяем, какое число нужно в вычитании, чтобы получить ноль
          if GaluaValue > 1 then
          begin
            NeedValue := FindGalua(SumTable, ElemI[IDelimoe, 1, StDelim + 1], 0);
            KoefChastn := FindGalua(MulTable, ElemI[IDelitel, 1, StDelit + 1], NeedValue);
          end else
            KoefChastn := ElemI[IDelimoe, 1, StDelim + 1] / ElemI[IDelitel, 1, StDelit + 1];
          // Помещаем найденное значение в массив частного
          ElemI[IChastnName, 1, StChastn + 1] := KoefChastn;
          // Создаем нулевой массив OstatName
          IOstatName := NewArray(OstatName, 1, StDelim + 1, True);
          // Заполняем этот массив
          for J := 1 to StDelit + 1 do
          begin
            PosOstat := StChastn + J;
            if GaluaValue > 1 then ElemI[IOstatName, 1, PosOstat] :=
              GetGaluaVal(Ws, MulTable, KoefChastn, ElemI[IDelitel, 1, J])  else
              ElemI[IOstatName, 1, PosOstat] := KoefChastn * ElemI[IDelitel, 1, J];
          end;
          // Производим вычитание
          for J := 1 to StDelim + 1 do 
          begin
            if GaluaValue > 1 then ElemI[IOstatName, 1, J] :=
              GetGaluaVal(Ws, SumTable, ElemI[IDelimoe, 1, J], ElemI[IOstatName, 1, J])
            else
              ElemI[IOstatName, 1, J] :=
                ElemI[IDelimoe, 1, J] - ElemI[IOstatName, 1, J];
          end;
          if Stepen(OstatName) < 0 then NewArray(OstatName, 1, 1, True) else
            Resize(OstatName, 1, Stepen(OstatName) + 1);
          // Формируем делимое из остатка
          // Если степень остатка меньше степени частного, то выход
          if Stepen(OstatName) < Stepen(Delitel) then Break;
          CopySubmatrix(OstatName, Delimoe, 1, 1, 1, Stepen(OstatName) + 1);
        end;
      end;
    Clear(Delimoe);
    Clear(Delitel);
    if ClearGalua then
    begin
      Clear(SumTable);
      Clear(MulTable);
    end;
  end;
end; // procedure DivPolinoms

procedure SumPolinoms(Ws: TWorkspace; Pol1, Pol2, PolResult: string;
  GaluaValue: Integer = 0; ClearGalua: Boolean = True);
var
  Len, I, MinLen, St: Integer;
  MaxPol, SumTable, TempRes: string;
  Ind1, Ind2, IndRes: Integer;
begin
  with Ws do
  begin
    CheckResAr(PolResult);
    SumTable := GenName('SumTable');
    TempRes := GenName();
    Ind1 := GetIndex(Pol1);
    Ind2 := GetIndex(Pol2);
    if (GetRows(Ind1) > 1) or (GetRows(Ind2) > 1) then DoError(matIsNotVektor);
    if (GaluaValue = 1) or (GaluaValue < 0) then DoError(matGaluaErrorValue);
    if GaluaValue > 1 then
      if (Find(SumTable) = -1) or (GetCols(SumTable) <> GaluaValue) or
        (GetRows(SumTable) <> GaluaValue) then
        GenerateGaluaTable(Ws, SumTable, GaluaValue, True); // Таблица сложения
    Len := GetCols(Ind1);
    MinLen := GetCols(Ind2);
    MaxPol := Pol1;
    if GetCols(Ind2) > GetCols(Ind1) then
    begin
      Len := MinLen;
      MinLen := GetCols(Ind1);
      MaxPol := Pol2;
    end;
    // Создаем временный результирующий массив
    IndRes := NewArray(TempRes, 1, Len, True);
    if GaluaValue = 0 then
    begin
      for I := 1 to MinLen do
        ElemI[IndRes, 1, I] := ElemI[Ind1, 1, I] + ElemI[Ind2, 1, I];
      for I := MinLen + 1 to Len do
        ElemI[IndRes, 1, I] := Elem[MaxPol, 1, I];
    end else
    begin
      for I := 1 to MinLen do
        ElemI[IndRes, 1, I] := GetGaluaVal(Ws, SumTable, ElemI[Ind1, 1, I], ElemI[Ind2, 1, I]);
      for I := MinLen + 1 to Len do
        ElemI[IndRes, 1, I] := GetGaluaVal(Ws, SumTable, Elem[MaxPol, 1, I], 0);
    end;
    // Определяем степень полученного многочлена
    St := 0;
    for I := Len downto 1 do
      if ElemI[IndRes, 1, I] <> 0 then
      begin
        St := I;
        Break;
      end;
    if St > 0 then CopySubmatrix(TempRes, TempRes, 1, 1, 1, St) else
      NewArray(TempRes, 1, 1, True);
    RenameArray(TempRes, PolResult);
    if ClearGalua then Clear(SumTable);
  end;
end;

procedure MulPolinoms(Ws: TWorkspace; Pol1, Pol2, PolResult: string;
  GaluaValue: Integer = 0; ClearGalua: Boolean = True);
var
  I, J, Cols1, Cols2, ColsRes, St: Integer;
  Tmp1, Tmp2: Real;
  SumTable, MulTable, TempRes: string;
  IndRes, Ind1, Ind2: Integer;
begin
  with Ws do
  begin
    CheckResAr(PolResult);
    TempRes := GenName;
    SumTable := GenName('SumTable');
    MulTable := GenName('MulTable');
    Ind1 := GetIndex(Pol1);
    Ind2 := GetIndex(Pol2);
    if (GetRows(Ind1) > 1) or (GetRows(Ind2) > 1) then DoError(matIsNotVektor);
    if (GaluaValue = 1) or (GaluaValue < 0) then DoError(matGaluaErrorValue);
    if GaluaValue > 1 then
    begin
      if (Find(SumTable) = -1) or (GetCols(SumTable) <> GaluaValue) or
        (GetRows(SumTable) <> GaluaValue) then
        GenerateGaluaTable(Ws, SumTable, GaluaValue, True); // Таблица сложения
      if (Find(MulTable) = -1) or (GetCols(MulTable) <> GaluaValue) or
        (GetRows(MulTable) <> GaluaValue) then
        GenerateGaluaTable(Ws, MulTable, GaluaValue, False); // Таблица сложения
    end;
    Cols1 := GetCols(Ind1);
    Cols2 := GetCols(Ind2);
    // Определяем число элементов рез. вектора
    ColsRes := Cols1 + Cols2 - 1;
    IndRes := NewArray(TempRes, 1, ColsRes, True);

    if GaluaValue = 0 then
      for I := Cols2 downto 1 do
      begin
        Tmp2 := ElemI[Ind2, 1, I];
        for J := Cols1 downto 1 do
        begin
          Tmp1 := ElemI[Ind1, 1, J];
          if (Tmp2 <> 0) and (Tmp1 <> 0) then
            ElemI[IndRes, 1, I + J - 1] := ElemI[IndRes, 1, I + J - 1] + Tmp1 * Tmp2;
        end;
      end;

    if GaluaValue > 1 then
      for I := Cols2 downto 1 do
      begin
        Tmp2 := ElemI[Ind2, 1, I];
        for J := Cols1 downto 1 do
        begin
          Tmp1 := ElemI[Ind1, 1, J];
          if (Tmp2 <> 0) and (Tmp1 <> 0) then ElemI[IndRes, 1, I + J - 1] :=
            GetGaluaVal(Ws, SumTable, ElemI[IndRes, 1, I + J - 1],
              GetGaluaVal(Ws, MulTable, Tmp1, Tmp2));
        end;
      end;
    // Обрезаем лишние нули
    St := 0;
    for I := ColsRes downto 1 do
      if ElemI[IndRes, 1, I] <> 0 then
      begin
        St := I;
        Break;
      end;
    if St > 0 then CopySubmatrix(TempRes, TempRes, 1, 1, 1, St) else
      NewArray(TempRes, 1, 1, True);
    RenameArray(TempRes, PolResult);
    if ClearGalua then
    begin
      Clear(SumTable);
      Clear(MulTable);
    end;
  end;
end;

function Shift(Ws: TWorkspace; SourAr, DestAr: string; Value: Integer;
  Rigth: Boolean = True): string;
var
  Rows, Cols, CopyColCnt: Integer;
  Submatrix, TempRes: string;
begin
  with Ws do
  begin
    Result := CheckResAr(DestAr);
    GetSize(SourAr, Rows, Cols);
    Submatrix := GenName();
    TempRes := GenName();
    Value := abs(Value);
    CopyColCnt := Cols - Value;
    if CopyColCnt < 1 then NewArray(TempRes, Rows, Cols, True) else
      if Rigth then
      begin
        CopySubmatrix(SourAr, Submatrix, 1, Rows, 1, CopyColCnt);
        Clear(DestAr);
        PasteSubmatrix(Submatrix, TempRes, 1, Value + 1);
      end else
      begin
        CopySubmatrix(SourAr, Submatrix, 1, Rows, Value + 1, CopyColCnt);
        NewArray(TempRes, Rows, Cols, True);
        PasteSubmatrix(Submatrix, TempRes, 1, 1);
      end;
    RenameArray(TempRes, DestAr);
    Clear(Submatrix);
  end;
end;

function CirShift(Ws: TWorkspace; SourAr, DestAr: string; Value: Integer;
  Rigth: Boolean = True): string;
var
  I, ShiftCount: Integer;
  Rows, Cols: Integer;
  Submatrix1, Submatrix2, TempRes: string;
begin
  with Ws do
  begin
    Result := CheckResAr(DestAr);
    GetSize(SourAr, Rows, Cols);
    Submatrix1 := GenName;
    Submatrix2 := GenName;
    TempRes := GenName;
    CopyArray(SourAr, TempRes);
    Value := abs(Value);
    ShiftCount := Value mod Cols;
    if not Rigth then ShiftCount := Cols - ShiftCount;
    if (Cols > 1) then
      for I := 1 to ShiftCount do
      begin
        Clear(Submatrix1);
        CopySubmatrix(TempRes, Submatrix1, 1, Rows, 1, Cols - 1);
        Clear(Submatrix2);
        CopySubmatrix(TempRes, Submatrix2, 1, Rows, Cols, 1);
        PasteSubmatrix(Submatrix2, TempRes, 1, 1);
        PasteSubmatrix(Submatrix1, TempRes, 1, 2);
      end;
    RenameArray(TempRes, DestAr);
    Clear(Submatrix1);
    Clear(Submatrix2);
  end;
end;

end.
