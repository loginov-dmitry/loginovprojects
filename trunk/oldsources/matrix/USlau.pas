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

unit USlau;

interface

uses Matrix, dialogs;

const
  matSlauBadRang = 'Ошибка решения СЛАУ: входная матрица должна быть квадратной';
  matSlauNotSolutions = 'СЛАУ не имеет решений';
  matSlauLU = 'Решение СЛАУ методом Холецкого';

{Решение СЛАУ методом Гаусса}
function SLAU(Ws: TWorkspace; MatrixName, VektorName, ResultName: string): string;

{Решение СЛАУ методом обратных корней (метод Холецкого). Код не самый понятный,
 так как писался для старой версии Матрикс и конвертировался из Матлаба}
procedure SlauLU(Ws: TWorkspace; A, B, X: string);

implementation

function SLAU(Ws: TWorkspace; MatrixName, VektorName, ResultName: string): string;
var
  Rows, Mat, Res, M1Rows, M1Cols, M2Rows, M2Cols: Integer;
  k, l, l1, l2, m, j, i, n: integer;
  s: real;
  p, r: real;
  MatExt: string;
begin
  with Ws do
  begin
    Result := CheckResAr(ResultName);
    GetSize(MatrixName, M1Rows, M1Cols);
    GetSize(VektorName, M2Rows, M2Cols);
    Rows := M1Rows;
    if M1Rows <> M1Cols then DoError(matSlauBadRang);
    if (M1Rows <> M2Rows) or (M2Cols > 1) then DoError(matSlauBadRang);

    // Создаем расширенную входную матрицу Mat
    MatExt := GenName();
    Mat := GetIndex(AddCols(MatrixName, VektorName, MatExt));

    n := Rows;
    // Перестановка строк матрицы
    for k := 1 to n do
    begin
      p := ElemI[Mat, k, k];
      l1 := k;
      for l := k + 1 to n do
      begin
        r := ElemI[Mat, l, k];
        if abs(r) > abs(p) then
        begin
          p := r;
          l1 := l;
        end;
      end;
      if l1 <> k then
        for l2 := 1 to n + 1 do
        begin
          r := ElemI[Mat, k, l2];
          ElemI[Mat, k, l2] := ElemI[Mat, l1, l2];
          ElemI[Mat, l1, l2] := r;
        end;
    end;
      if ElemI[Mat, 1, 1] = 0 then
      begin
        Clear(MatExt);
        DoError(matSlauNotSolutions);
      end;


    // Прямой шаг
    for j := 2 to n + 1 do
      ElemI[Mat, 1, j] := ElemI[Mat, 1, j] / ElemI[Mat, 1, 1];
    for l := 2 to n do
    begin
      for i := l to n do
      begin
        s := 0;
        for k := 1 to l - 1 do
          s := s + ElemI[Mat, i, k] * ElemI[Mat, k, l];
        ElemI[Mat, i, l] := ElemI[Mat, i, l] - s;
      end;
      for j := l + 1 to n + 1 do
      begin
        s := 0;
        for k := 1 to l - 1 do
          s := s + ElemI[Mat, l, k] * ElemI[Mat, k, j];

        ElemI[Mat, l, j] := (ElemI[Mat, l, j] - s) / ElemI[Mat, l, l];
      end;
    end;

    //ShowMessage(SaveArrayToString(MatExt));

    // Обратный шаг
    Res := NewArray(ResultName, 1, n);

    ElemI[Res, 1, n] := ElemI[Mat, n, n + 1];
    for m := 1 to n - 1 do
    begin
      i := n - m;
      s := 0;
      for j := i + 1 to n do
        s := s + Ws.ElemI[Mat, i, j] * Ws.ElemI[Res, 1, j];
      Ws.ElemI[Res, 1, i] := Ws.ElemI[Mat, i, n + 1] - s;
    end;

    ShowMessage(SaveArrayToString(ResultName));

    Transpose(ResultName, ResultName);
    if MatExt <> '' then Clear(MatExt);
  end;
end;

{Решение СЛАУ методом обратных корней (метод Холецкого). Код не самый понятный,
 так как писался для старой версии Матрикс и конвертировался из Матлаба}
procedure SlauLU(Ws: TWorkspace; A, B, X: string);
var 
  size_a, sh1, i, j, sh, betta, m, kol: Integer;
  sum, summa, sm: Real;
  iA, iB, iTempX, iL, iAN, iy: Integer;
begin
  with TWorkspace.Create(matSlauLU) do
  begin
    // Проверяем имя выходного массива
    CheckResAr(X);
    // Поддержка константного ввода массивов
    iA := LoadArray(A, 'A');
    iB := LoadArray(B, 'B');

    size_a := GetRows('A');
    sh1 := 0; // Обнуляем значение счетчика
    //цикл проверки правильноcти А и вычиcления ширины диагональной матрицы...
    for i := 1 to size_a do
    begin
      sh := 0;
      // cчетчик : обнуляетcя для каждой cтроки, увеличиваетcя, еcли A(i,j) ненулевой
      for j := 1 to size_a do
      begin // % ищет ненулевые эл-ты cтроки
        if ElemI[iA, j, j] = 0 then DoError(matSlauNotSolutions);
        if ElemI[iA, i, j] <> ElemI[iA, j, i] then DoError(matSlauNotSolutions);
        if ElemI[iA, i, j] <> 0 then sh := sh + 1;
      end;
      if sh > sh1 then sh1 := sh;
    end;
    betta := sh1 - 1; // полуширина матрицы
    iAN := NewArray('AN', size_a, sh1, True);
    // cборка диагональной матрицы AN...
    for i := 1 to size_a do
      for j := 1 to sh1 do
      begin
        // предотвращение присвоения отрицательного индекcа номеру cтолбца
        if j + i - betta - 1 <= 0 then continue;
        ElemI[iAN, i, j] := ElemI[iA, i, j + i - betta - 1];
      end;

    m := size_a; // m-размер  матрицы А
    iL := NewArray('L', m, m, True); // cоздание нулевой матрицы L
    // вычиcление элементов нижней треугольной матрицы L...
    for i := 1 to m do
    begin
      sum := ElemI[iAN, i, sh1]; // иначе, sum=A(i,i):начальное значение cуммы
      if i <> 1 then // блок нахождения диагонального эл-та L
        for j := 1 to i - 1 do sum := sum - ElemI[iL, i, j] * ElemI[iL, i, j];
      ElemI[iL, i, i] := sqrt(sum);
      for j := i + 1 to m do
      begin //  блок нахождения недиагонального эл-та L
        if i - j + betta + 1 <= 0 then summa := 0 else
          summa := ElemI[iAN, j, i - j + betta + 1];
        for kol := 1 to i - 1 do // цикл cуммирования
          summa := summa - ElemI[iL, j, kol] * ElemI[iL, i, kol];
        ElemI[iL, j, i] := summa / ElemI[iL, i, i];
      end;
    end; // вычиcление элементов нижней треугольной матрицы L закончено
    // решение уравнения вида L*y=B...
    iy := NewArray('y', m, 1, True); // cоздание нулевого вектора у
    for i := 1 to m do
    begin
      sm := ElemI[iB, i, 1]; // начальное значение cуммы
      for j := 1 to m do
      begin
        if j = i then break;
        sm := sm - ElemI[iL, i, j] * ElemI[iy, j, 1];
      end; // цикл прерван, j=i
      ElemI[iy, j, 1] := sm / ElemI[iL, i, j];
    end; // вектор у получен
    // решение уравнения вида L'*X=y...
    iTempX := NewArray('X', m, 1, True); // cоздание нулевого вектора Х
    Transpose('L', 'L'); // транcпонирование матрицы L
    for i := m downto 1 do
    begin
      sm := ElemI[iy, i, 1]; // начальное значение cуммы
      for j := m downto 1 do
      begin
        if j = i then break;
        sm := sm - ElemI[iL, i, j] * ElemI[iTempX, j, 1]; // cуммирование
      end;
      ElemI[iTempX, j, 1] := sm / ElemI[iL, i, j];
    end; // вектор Х получен
    ReturnArray('X', X); // Возвращаем результат
    Free();
  end; // with
end;

end.
