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

{*****************************************************************************}
{                                                                             }
{                                                                             }
{                                                                             }
{ Модуль Signals - содержит функции для обработки сигналов                    }
{ (с) Логинов Д.С., 2005-2006                                                 }
{ Адрес сайта: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{*****************************************************************************}

{Данный модуль использовался автором в его разработках. Вы не обязаны использовать
 его в своих проектах, и 100-процентная функциональность всех функций в нем
 не гарантируется. Модуль прилагается лишь в демонстрационных целях. Здесь вы
 сможете увидеть, как пишутся сборники подпрограмм, основанные на ядре MatriX.
 Более подробные сведения по написанию подпрограмм находятся в документации}

unit Signals;

interface
uses
  Windows, Matrix, Math;

const
  matFastInterp = 'Быстрая интерполяция';
  matIncSizeRows = 'Растяжение сигнала';
  matDecSizeRows = 'Сжатие сигнала';
  matNormAmplitude = 'Нормирование амплитуды';
  matSmoothSignals = 'Сглаживание сигнала';
  matFindIzoline = 'Поиск изолинии';
  matFindMaxPoints = 'Поиск точек экстремума';

{Функции быстрой интерполяции}
procedure mFastInterp(Ws: TWorkspace; Xvek, Yvek, X1vek, RESvek: string;
  Faster: Boolean = False);
//procedure mIncSizeRows(Ws: TWorkspace; SourAr, DestAr: string; NumPoints: Integer);
//procedure mDecSizeRows(Ws: TWorkspace; SourAr, DestAr: string; NumPoints: Integer);

{Осуществляет сжатие или растяжение сигналов в строках массива}
procedure mScaleSignals(Ws: TWorkspace; SourAr, DestAr: string; DestLen: Integer);

{Сглаживание сигналов}
procedure mSmoothSignals(Ws: TWorkspace; SourAr, DestAr: string; Iter: Integer);

{Нормализация амплитуды сигналов}
procedure mNormAmplitude(Ws: TWorkspace; SourAr, DestAr: string; MaxValue: Real);

{Поиск изолинии}
function mFindIzoline(Ws: TWorkspace; MatName: string; Row: Integer;
  Koef: Integer = 20): Real;

{Поиск точек экстремума}
function mFindMaxPoints(Ws: TWorkspace; SourAr, DestAr: string; Line: Real;
  FindMax: Boolean = True): Boolean;

implementation

procedure mFastInterp(Ws: TWorkspace; Xvek, Yvek, X1vek, RESvek: string;
  Faster: Boolean = False);
var
  I, J, K, Xrows, Xcols, Yrows, Ycols, X1rows, X1cols, ColNum: Integer;
  Xid, Yid, X1id, Rid: Integer;
  Tmp: Real;

  function CalcElem(X0, X1, Y0, Y1, Y2, X: Real): Real;
  var E: Real;
  begin
    E := (X - X0) / (X1 - X0);
    if (E < 0) or (E > 2) then Ws.DoError('Intepr Error: calc elem');
    Result := Y0 + (Y1 - Y0) * E + (Y2 - 2 * Y1 + Y0) / 2 * E * (E - 1);
  end;   
begin
  with TWorkspace.Create(matFastInterp, Ws) do
  begin
    CheckResAr(RESvek);
    Xid := GetSize(LoadArray(Xvek, 'X'), Xrows, Xcols);
    Yid := GetSize(LoadArray(Yvek, 'Y'), Yrows, Ycols);
    X1id := GetSize(LoadArray(X1vek, 'X1'), X1rows, X1cols);

    if (Xrows > 1) or (Xcols <> Ycols) or (X1rows > 1) then
      DoError(matArraysNotAgree);

    Rid := NewArray('R', Yrows, X1cols);
    ColNum := Xcols;
    for I := X1cols downto 1 do
    begin
      Tmp := ElemI[X1id, 1, I];
      // Ищем точку в массиве исходных отсчетов
      for J := ColNum downto 1 do
        if Tmp >= ElemI[Xid, 1, J] then
        begin
          for K := 1 to Yrows do
          begin
            if J = Xcols then ElemI[Rid, K, I] := ElemI[Yid, K, J] else
              if J = Xcols - 1 then
                ElemI[Rid, K, I] :=
                  CalcElem(ElemI[Xid, 1, Xcols - 2], ElemI[Xid, 1, Xcols - 1],
                  ElemI[Yid, K, Xcols - 2], ElemI[Yid, K, Xcols - 1], ElemI[Yid,
                  K, Xcols], ElemI[X1id, 1, I])
            else
              ElemI[Rid, K, I] :=
                CalcElem(ElemI[Xid, 1, J], ElemI[Xid, 1, J + 1],
                ElemI[Yid, K, J], ElemI[Yid, K, J + 1], ElemI[Yid, K, J + 2],
                ElemI[X1id, 1, I]);
          end;
          if Faster then ColNum := J;
          Break;
        end;

    end; // for I
    ReturnArray('R', RESvek);
    Free();
  end;  
end;

procedure mIncSizeRows(Ws: TWorkspace; SourAr, DestAr: string; NumPoints: Integer);
var
  Cols: Integer;
begin      
  with TWorkspace.Create(matIncSizeRows, Ws) do
  begin
    Cols := GetCols(LoadArray(SourAr, 'Sour'));
    if NumPoints < Cols then DoError(matBadInputData);
    NewArray('X', 1, Cols, 1); // Создаем массив отсчетов
    NewFillAr('X1', 1, Cols, NumPoints);
    mFastInterp(SelfWS, 'X', 'Sour', 'X1', 'Y', True);
    ReturnArray('Y', DestAr);
    Free();
  end;
end;

procedure mDecSizeRows(Ws: TWorkspace; SourAr, DestAr: string; NumPoints: Integer);
var 
  Interv, Num, yIdx, tIdx, I, J, Rows, C, Cols: Integer;
begin
  with TWorkspace.Create(matDecSizeRows, Ws) do
  begin
    CheckResAr(DestAr);
    GetSize(LoadArray(SourAr, 'Sour'), Rows, Cols);
    if NumPoints > Cols then DoError(matBadInputData);
    // Создаем массив с увеличенным числом столбцов
    Interv := Cols div (NumPoints - 1) + 1;
    Num := Interv * (NumPoints - 1) + 1;
    mIncSizeRows(SelfWS, 'Sour', 'Temp', Num);
    tIdx := GetIndex('Temp');
    yIdx := NewArray('Y', Rows, NumPoints);
    C := 0;
    for J := 1 to Num do
    begin
      if (J mod Interv) <> 1 then Continue;
      Inc(C);
      for I := 1 to Rows do ElemI[yIdx, I, C] := ElemI[tIdx, I, J];
    end;
    ReturnArray('Y', DestAr);
    Free();
  end;       
end;

procedure mScaleSignals(Ws: TWorkspace; SourAr, DestAr: string; DestLen: Integer);
begin
  Ws.CheckResAr(DestAr);
  if DestLen < Ws.GetCols(SourAr) then
    mDecSizeRows(WS, SourAr, DestAr, DestLen) else
    mIncSizeRows(WS, SourAr, DestAr, DestLen);
end;

procedure mNormAmplitude(Ws: TWorkspace; SourAr, DestAr: string; MaxValue: Real);
var
  sIdx, tIdx, Rows, Cols, I, J: Integer;
  Koef: Real;
begin
  with TWorkspace.Create(matNormAmplitude, Ws) do
  begin
    CheckResAr(DestAr); 
    sIdx := GetSize(LoadArray(SourAr, 'A', False), Rows, Cols);
    GetMinMax('A', 'Temp'); // Опред. min и max для каждой строки
    CalcFunc('Temp', 'Temp', fncAbs); // Меняем минусы на плюсы
    GetMax('Temp', 'Temp', '', dimRows); // Определяем max элементы
    // Теперь в векторе Temp хранятся максимальные элементы для каждой строки
    tIdx := GetIndex('Temp');
    for I := 1 to Rows do
    begin
      Koef := MaxValue / ElemI[tIdx, I, 1]; // Коэффициент шкалирования
      for J := 1 to Cols do
        ElemI[sIdx, I, J] := ElemI[sIdx, I, J] * Koef;
    end;
    ReturnArray('A', DestAr); // Передаем результат
    Free();
  end; 
end;


procedure mSmoothSignals(Ws: TWorkspace; SourAr, DestAr: string; Iter: Integer);
var 
  RowCnt, ColCnt, A, rv: Integer;
  I, Z, II: Integer;
  q, w, k: extended;
begin  
  with TWorkspace.Create(matSmoothSignals, Ws) do
  begin
    CheckResAr(DestAr); // Проверка имени результата
    A := GetSize(LoadArray(SourAr, 'A', False), RowCnt, ColCnt);
    // создаем переменную для временного хранения результата
    rv := NewArray('rv', RowCnt, ColCnt);
    I := 0;
    for z := 1 to iter do
    begin
      for II := 1 to RowCnt do
      begin
        I := 1;
        while I <> ColCnt do
        begin
          q := ElemI[A, II, I];
          w := ElemI[A, II, I + 1];
          k := (q - w) / 4;
          ElemI[rv, II, I] := (q + w) / 2 + k;
          ElemI[rv, II, I + 1] := (q + w) / 2 - k;
          Inc(I);
        end;
      end;
      A := CopyArray('rv', 'A');
      for II := 1 to RowCnt do
      begin
        while i <> 1 do
        begin
          q := ElemI[A, II, I];
          w := ElemI[A, II, I - 1];
          k := (w - q) / 4;
          ElemI[rv, II, I] := (q + w) / 2 - k;
          ElemI[rv, II, I - 1] := (q + w) / 2 + k;
          I := I - 1;
        end;
      end;
      A := CopyArray('rv', 'A');
    end;
    ReturnArray('A', DestAr);
    Free();
  end;  
end;

{Специализированная функция, применяемая для обработки сигналов ЭКГ}
function mFindIzoline(Ws: TWorkspace; MatName: string; Row: Integer;
  Koef: Integer = 20): Real;
var
  Cols, I, J, Leng: Integer;
  AbsMax, AbsMin, MaxEl, MinEl: Real;
  Tmp, C: Integer;
begin 
  with TWorkspace.Create(matFindIzoline, Ws) do
  begin
    LoadArray(MatName, MatName); // Копирование ссылки
    C := 0;
    Cols := GetCols(MatName);
    CopyCutRows(MatName, 'Temp1', Row, 1);
    CopyArray('Temp1', 'SomeArray');
   
    mNormAmplitude(SelfWS, 'Temp1', 'Temp1', Koef);
    CalcFunc('Temp1', 'Temp1', fncRound);
    GetMinMax('Temp1', MinEl, MaxEl);
    Leng := Round(MaxEl) - Round(MinEl) + 1;

    GetMinMax('SomeArray', AbsMin, AbsMax);
    AbsMax := Max(abs(AbsMin), abs(AbsMax));

    NewArray('Temp2', 2, Leng, True);
    for I := 1 to Cols do
    begin
      Tmp := Round(Elem['Temp1', 1, I]);
      if Tmp = 10000000 then Continue;
      Inc(C);
      for J := I to Cols do
      begin
        if Round(Elem['Temp1', 1, J]) = Tmp then
        begin
          Elem['Temp2', 1, C] := Elem['Temp2', 1, C] + 1;
          Elem['Temp2', 2, C] := Tmp;
          Elem['Temp1', 1, J] := 10000000;
        end;
      end;
    end;
    GetMinOrMax('Temp2', 1, dimRows, True, I); 
    Result := Elem['Temp2', 2, I] * AbsMax / Koef;
    Free();
  end;   
end;

{Функция нахождения экстремумов. Писалась в старой версии Матрикса, поэтому
 код такой сложный}
function mFindMaxPoints(Ws: TWorkspace; SourAr, DestAr: string; Line: Real;
  FindMax: Boolean = True): Boolean;
var 
  I, J, CC: Integer;
  El1, El2, MaxEl: Real;
  MaxInd: Integer;
  sIdx, kIdx, IResArray: Integer;
begin
  with TWorkspace.Create(matFindMaxPoints, Ws) do
  begin
    CheckResAr(DestAr);
    sIdx := LoadArray(SourAr, 'A');
    kIdx := 0;
    Result := False;
    if GetRows(sIdx) <> 1 then DoError(matIsNotVektor);
    CC := GetCols(sIdx);
     // В цикле перебираем все элементы входного массива
    for I := 1 to CC - 1 do
    begin
      El1 := ElemI[sIdx, 1, I];
      El2 := ElemI[sIdx, 1, I + 1];
       // Если Line лежит в пределах [El1; El2]
      if ((Line >= El1) and (Line < El2)) or ((Line > El2) and (Line <= El1)) then
      begin
        if not ArrayExists('B') then
          kIdx := NewArray('B', 1, 1) else
          Resize('B', 1, GetCols(kIdx) + 1);
        ElemI[kIdx, 1, GetCols(kIdx)] := I
      end;
    end;
    if (not ArrayExists('B')) or (GetCols(kIdx) < 2) then
    begin
      Free;
      Exit;
    end;
    // Определяем позицию первого элемента
    I := Round(ElemI[kIdx, 1, 1]);
    if (I > 1) and FindMax and (ElemI[sIdx, 1, I - 1] > ElemI[sIdx, 1, I]) then
      CopyCutCols('B', '', 1, 1, True);
    if (not ArrayExists('B')) or (GetCols(kIdx) < 2) then
    begin
      Free;
      Exit;
    end;
    if (I > 1) and (not FindMax) and (ElemI[sIdx, 1, I - 1] < ElemI[sIdx, 1, I]) then
      CopyCutCols('B', '', 1, 1, True);
    if (Find('B') = -1) or (GetCols(kIdx) < 2) then
    begin
      Free;
      Exit;
    end;
    if (GetCols(kIdx) mod 2) <> 0 then // Удал. посл. эл
      CopyCutCols('B', '', GetCols(kIdx) - 1, 1, True);
    // Создаем выходной массив
    CC := GetCols(kIdx);
    IResArray := NewArray('X', 1, CC div 2);
    for I := 1 to (CC div 2) do
    begin
      El1 := ElemI[kIdx, 1, I * 2 - 1];
      El2 := ElemI[kIdx, 1, I * 2];
      if FindMax then
        MaxEl := -MaxDouble else
        MaxEl := MaxDouble;
      MaxInd := 0;
      for J := Round(El1) to Round(El2) do
      begin
        if ((ElemI[sIdx, 1, J] > MaxEl) and FindMax) or
          ((ElemI[sIdx, 1, J] < MaxEl) and (not FindMax)) then
        begin
          MaxEl := ElemI[sIdx, 1, J];
          MaxInd := J;
        end;
      end;
      ElemI[IResArray, 1, I] := MaxInd;
    end;
    if Find('X') = -1 then
    begin
      Free;
      Exit;
    end;
    ReturnArray('X', DestAr);
    Result := True;
    Free();
  end;
end;

end.

