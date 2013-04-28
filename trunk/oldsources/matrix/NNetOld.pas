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
{ Модуль NNet - обучение и расчет нейронных сетей с помощью средств Matrix    }
{ (с) Логинов Д.С., 2005-2006                                                 }
{ Адрес сайта: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{*****************************************************************************}
unit NNet;

interface
uses
  Windows, SysUtils, Matrix, Math, Signals, dialogs;

type
  TInputArray = string;
  TResultArray = string;

  // Перечень используемый передаточных функций. Значение tfNone используется
  // в сетях жестко заданной структуры, например LVQ
  TTransferFunction = (tfNone, tfLogsig, tfTansig, tfPurelin);

  TTrainProgress = procedure(epoch: Integer; err, ideal: Real);

  TLayer = record    // Слой нейронной сети

    {Количество нейронов в данном слое}
    NeuronCnt: Integer;

    {Передаточная функция слоя. Определяет, по какому алгоримту обрабатываются
     данные, вычисленные адаптивным сумматором.}
    TransFnc: TTransferFunction;

    {Матрица весов. Каждая строка описывает веса одного нейрона. Число строк
     равно числу нейронов. Первый элемент каждой строки - смещение}
    Weights: string;

    {Матрица Дельта. Применяется для расчета обратного распростр. ошибки
     Размеры те же, что и после адаптивного сумматора}
    Delta: string;

    {Сумма, полученная на выходе адаптивного сумматора}
    Summa: string;
    
  end;

  TLayers = array of TLayer;

  {Класс TNeuroNet содержит основные функции, используемые всеми нейросетями
   Внимание! Данные хранятся не в строках, а в столбцах}
  TNeuroNet = class(TObject)

    FWorkspace: TWorkspace; // Рабочая область нейронной сети

    FTrainData: string; // Обучающие вектора

    FTargetData: string; // Целевые вектора

    FLayers: TLayers; // Слои нейронной сети

    FLayCount: Integer; // Количество слоев (не фиктивных)

    procedure Error(Msg: string; Args: array of const);

  private

  public
    {Создание нейронной сети. Neurons - массив числа нейронов для каждого слоя.
     Его можно задать так: [2, 5, 1], где числа означают количество нейронов
     в соответствующем слое, а количество чисел соответствуем числу слоев.
     TransFuncs - передаточные функции каждого слоя. Можно задать следующим
     образом: ['logsig', 'logsig', 'purelin']}
    constructor Create(Neurons: array of Integer;
      TransFuncs: array of TTransferFunction);

    {Функция вызывается из конструктора, однако ее можно вызвать в любой
     момент, если нужно изменить параметры нейронной сети}
    procedure SetNeuronsAndTransFuncs(Neurons: array of Integer;
      TransFuncs: array of TTransferFunction);

    property Layers: TLayers read FLayers;

    {Создает матрицы весов и инициализирует их}
    procedure InitWeights(); virtual; abstract;

    {Симуляция нейронной сети. В результате симуляции расчитываются
     параметры Summa}
    //function SimNet(ResultAr: string): string;

    destructor Destroy; override;

    {Загружает из указанной рабочей области массив обучающих векторов
     TrainData и массив целевых векторов TargetData}
    procedure SetTrainAndTargetData(Ws: TWorkspace; TrainData, TargetData: string);

    {Вычисляет производную указанной функции активации}
    //function CalcProizvActFnc(Summa, Proizv: string; FncType:
    //  string = 'logsig'): string;


   // function CalcDelta();  

    {Вычисляет Delta для выходного слоя}
    //function CalcOutputDelta(Y, T, Summa: string): string;

    {Вычисляет Delta для скрытого слоя}
    //function CalcHiddenDelta(Ws: TWorkspace; nextW, nextDelta, Proizv,
    //   Delta: string): string;

    property Workspace: TWorkspace read FWorkspace;
  end;

  TNetLVQ = class(TNeuroNet)

  private

  public
    function Simulate(): Real;
    procedure InitWeights(); override;
  end;

// Функция вычисляет среднеквадратичную ошибку
function CalcMSE(Ws: TWorkspace; ArName: string): Real;

// Мягкое шкалирование. Алгоритм взят из матлаба
function CalcSoftMax(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray): TResultArray;

// Линейное шкалирование. Алгоритм взят из матлаба
function CalcLineScale(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray;
  MinRang: Real = -1; MaxRang: Real = 1): TResultArray;

// Логарифмическое шкалирование. Алгоритм взят из матлаба
function CalcLogScale(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray): TResultArray;

// Евклидово расстояние между весами нейросети
function CalcDist(Ws: TWorkspace; W, P, Z: string): string;

// отрицательное Евклидово расстояние между весами нейросети
// W - веса, P - входы НС, Z - результат
function CalcNegDist(Ws: TWorkspace; W, P, Z: string): string;




//////////////////////////////////////////////
// Старые и практически бесполезные функции //
//////////////////////////////////////////////

// Процедура обращается к матлабу для расчета нейросети
procedure mSimNetWithMatlab(Ws: TWorkspace; NetPath, NetName, InputArray,
  ResultArray: string);

// Загружает нейросеть из матлаба
procedure mLoadNNFromMatlab(Ws: TWorkspace; NNName: string);

// Сохраняет нейросеть в двоичный файл
procedure mSaveNNToBinFile(Ws: TWorkspace; NNName, FileName: string;
   NewFile: Boolean = True);

// Загружает нейросеть из двоичного файла
procedure mLoadNNFromBinFile(Ws: TWorkspace; NNName, FileName: string);

// Удаляет все массивы нейронной сети
procedure mClearNetwork(Ws: TWorkspace; NNName: string);

// Расчитывает гибридную сеть с конкурентным слоем Кохонена и
// сигмаидальным слоем с линейной функцией активации
// Указывается имя сети, имя тестируемого вектора и имя выходного вектора
// Процедура возвращает также степень уверенности распознавания
// в процентах и вектор близости (евклидовых расстояний)
procedure mCalcKohon(Ws: TWorkspace; NNName, TestVek, ResVek: string;
  var Per: Real; Euklid: string = '');

{ Обучение одного персептрона
X - массив обучающих векторов (обучающая выборка),
D - требуемые значения на выходе
epoch - максимальное кол-во итераций
err - требуемая пограшность обучения
W - массив весов (результат обучения) одна строка описывает 1 нейрон
E - ошибка в конце обучения
T - время обучения
ProcProgress - функция для визуализации хода обучения - не обязательно}
procedure mTrainPerceptron(Ws: TWorkspace; X, D: string; epoch: Cardinal;
  err: Real; W: string; E: string; T: string;
  ProcProgress: TTrainProgress = nil);

///////////////////////////////////////////////
///////////////////////////////////////////////

implementation

// Униполярная функция активации

function nnLogsig(const R: Real): Real;
begin
  Result := 1 / (1 + Power(matrixExp, -R))
end;

// Биполярная функция активации

function nnTanh(const R: Real): Real;
begin
  Result := Tanh(R);
end;

function nnPurelin(const R: Real): Real;
begin
  Result := R;
end;

function nnTansig(const R: Real): Real;
begin
  Result := 2 / (1 + Power(matrixExp, -2 * R)) - 1
end;

function nnHardlim(const R: Real): Real;
begin
  if R >= 0 then Result := 1 else Result := 0;
end;

function nnRadbas(const R: Real): Real;
begin
  Result := Power(matrixExp, -Sqr(R));
end;

function CalcDist(Ws: TWorkspace; w, p, z: string): string;
begin
  with Ws do begin
    Result := CalcNegDist(Ws, w, p, z);
    CalcFunc2(0, Result, Result, fncSub);
  end;
end;

function CalcNegDist(Ws: TWorkspace; W, P, Z: string): string;
var
  wRows, wCols, pRows, pCols, wAdr, pAdr, zAdr, I, J, K: Integer;
  Tmp: string;
  R: Real;
begin
  { Отрицательное Эвклидово расстояние вычисляется по следующей формуле:
     z = -sqrt(sum((w-p)^2)), где
     w - строки матрицы весов, p - столбцы матрицы входов }
  with Ws do begin
    wAdr := GetAddress(GetSize(W, wRows, wCols));
    pAdr := GetAddress(GetSize(P, pRows, pCols));
    if wCols <> pRows then DoError('Matrix sizes do not match');
    CheckResAr(Z);
    Tmp := GenName();
    zAdr := GetAddress(NewArray(Tmp, wRows, pCols));
    for I := 1 to wRows do
      for K := 1 to pCols do begin
        R := 0;
        for J := 1 to wCols do
          R := R + sqr((ElemFast[wAdr, I, J, wCols] - ElemFast[pAdr, J, K, pCols]));
        R := -sqrt(R);
        ElemFast[zAdr, I, K, pCols] := R
      end;       
    RenameArray(Tmp, Z);
    Result := Z;
  end;
end;

function CalcLineScale(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray;
  MinRang: Real = -1; MaxRang: Real = 1): TResultArray;
var
  I, J, cIdx: Integer;
  Max, MinEl, Min_Max, R: Real;
begin
  with TWorkspace.Create('LineScale') do
  begin
    CheckResAr(DestAr);
    CopyRef(Ws, SourAr, 'A');
    R := MaxRang - MinRang;
    for I := GetCols('A') downto 1 do
    begin
      // Копируем i-ый столбец
      CopyCutCols('A', 'Column', I, 1);
      GetMinMax('Column', MinEl, Max);
      Min_Max := (Max - MinEl) / R;
      cIdx := GetIndex('Column');
      for J := GetRows('Column') downto 1 do
        ElemI[cIdx, J, 1] := (ElemI[cIdx, J, 1] - MinEl) / Min_Max + MinRang;
      AddCols(DestAr, 'Column', DestAr);
    end;
    MoveArray(Ws, DestAr, DestAr);
    Free();
  end;
end;

function CalcLogScale(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray): TResultArray;
var
  I, C, aIdx, bIdx, Rows, Cols: Integer;
  R, M: Real;
begin
  with TWorkspace.Create('LogScale') do
  begin
    aIdx := GetSize(CopyRef(Ws, SourAr, 'A'), Rows, Cols);
    bIdx := NewArray('B', Rows, Cols);
    GetMean('A', 'GetMean');
    GetMinMax('A', 'GetMinMax', dimCols);
    CalcFunc('GetMinMax', 'GetMinMax', fncLog10);

    for C := 1 to Cols do
    begin
      R := (Elem['GetMinMax', 2, C]) - (Elem['GetMinMax', 1, C]);
      M := Log10(Elem['GetMean', 1, C]);
      for I := 1 to Rows do
        ElemI[bIdx, I, C] := (Log10(ElemI[aIdx, I, C]) - M) / R;
    end;
    MoveArray(Ws, 'B', DestAr);
    Free();
  end;
end;

function CalcSoftMax(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray): TResultArray;
var
  I, J, Rows, Cols, aIdx, eIdx, sIdx: Integer;
begin
  with TWorkspace.Create('SoftMax') do begin
    CopyRef(Ws, SourAr, 'n');
    CheckResAr(DestAr);
    Result := DestAr;

    eIdx := GetIndex(CalcFunc('n', 'expn', fncExp));
    sIdx := GetIndex(SumRows('expn', 'sum'));
    aIdx := CopyArray('expn', 'a');
    GetSize(aIdx, Rows, Cols);

    for I := 1 to Cols do
      for J := 1 to Rows do
        ElemI[aIdx, J, I] := ElemI[eIdx, J, I] / ElemI[sIdx, 1, I];  

    MoveArray(Ws, 'a', DestAr);
    Free();
  end;
end;

function CalcMSE(Ws: TWorkspace; ArName: string): Real;
var
  Rows, Cols, Adr, I, J: Integer;
begin
  with Ws do begin
    Adr := GetAddress(GetSize(ArName, Rows, Cols));
    Result := 0;
    for I := 1 to Rows do
      for J := 1 to Cols do
        Result := Result + sqr(ElemFast[Adr, I, J, Cols]);
    Result := Result / (Rows * Cols);
  end;
end;

procedure mSimNetWithMatlab(Ws: TWorkspace; NetPath, NetName, InputArray,
  ResultArray: string);
var
  Txt: string;
begin
  if (Ws.Find(InputArray) = -1) then Ws.DoError(matArrayNotFound);
  if (Ws.GetCols(InputArray) > 1) then Ws.DoError('Can not calc network');
  if not FileExists(NetPath + NetName + '.mat') then
    Ws.DoError('network not found');
  WS.SendMatlabCommand('chdir (''' + NetPath + ''')');
  WS.SendMatlabCommand('load ' + NetName + '.mat');
  Ws.PutArrayToMatlab(InputArray);
  Txt := ResultArray + '=sim(' + NetName + ',' + InputArray + ')';
  WS.SendMatlabCommand(Txt);
  Ws.LoadArrayFromMatlab(ResultArray);
end;

procedure mLoadNNFromBinFile(Ws: TWorkspace; NNName, FileName: string);
var
  I, LCnt: Integer;
  sI: string;
begin
  Ws.LoadFromBinFile(FileName, NNName + '_LCnt');
  if Ws.Find(NNName + '_LCnt') = -1 then Ws.DoError('network not found');
   // Определяем число слоев
  LCnt := Round(Ws.Elem[NNName + '_LCnt', 1, 1]);
  for I := 1 to LCnt do begin
    sI := Inttostr(I);
    Ws.LoadFromBinFile(FileName, NNName + '_Lay' + sI);
    Ws.LoadFromBinFile(FileName, NNName + '_B' + sI);
    Ws.LoadFromBinFile(FileName, NNName + '_Fnc' + sI);
  end;
end;

procedure mLoadNNFromMatlab(Ws: TWorkspace; NNName: string);
var
  Com: string;
  I, LCnt: Integer; // Число слоев
  sI: string;
begin
  // Определяем кол-во слоев
  WS.SendMatlabCommand(NNName + '_LCnt=' + NNName + '.numLayers');
  Ws.LoadArrayFromMatlab(NNName + '_LCnt');
  WS.SendMatlabCommand('clear ' + NNName + '_LCnt');
  // Определяем характеристики входного слоя
  Com := NNName + '_Lay1=' + NNName + '.IW{1}';
  Com := Com + #13#10 + NNName + '_B1=' + NNName + '.b{1}';
  Com := Com + #13#10 + NNName + '_Fnc1=' + NNName + '.layers{1}.transferFcn';
  WS.SendMatlabCommand(Com);
  Com := 'if ' + NNName + '_Fnc1' + '==''logsig'''#13#10 +
    NNName + '_Fnc1=1'#13#10'end'; WS.SendMatlabCommand(Com);
  Com := 'if ' + NNName + '_Fnc1' + '==''purelin'''#13#10 +
    NNName + '_Fnc1=2'#13#10'end'; WS.SendMatlabCommand(Com);
  Com := 'if ' + NNName + '_Fnc1' + '==''tansig'''#13#10 +
    NNName + '_Fnc1=3'#13#10'end'; WS.SendMatlabCommand(Com);
  Com := 'if ' + NNName + '_Fnc1' + '==''hardlim'''#13#10 +
    NNName + '_Fnc1=4'#13#10'end'; WS.SendMatlabCommand(Com);
  Com := 'if ' + NNName + '_Fnc1' + '==''radbas'''#13#10 +
    NNName + '_Fnc1=5'#13#10'end'; WS.SendMatlabCommand(Com);
  Com := 'if ' + NNName + '_Fnc1' + '==''compet'''#13#10 +
    NNName + '_Fnc1=6'#13#10'end'; WS.SendMatlabCommand(Com);
  Com := 'if isstr(' + NNName + '_Fnc1)'#13#10 +
    NNName + '_Fnc1=10'#13#10'end'; WS.SendMatlabCommand(Com);
  Ws.LoadArrayFromMatlab(NNName + '_Lay1');

  if not Ws.LoadArrayFromMatlab(NNName + '_B1') then
    Ws.NewArray(NNName + '_B1', Ws.GetRows(NNName + '_Lay1'), 1, True);

  Ws.LoadArrayFromMatlab(NNName + '_Fnc1');
  // Удаляем эти переменные из матлаба
  WS.SendMatlabCommand('clear ' + NNName + '_Lay1');
  WS.SendMatlabCommand('clear ' + NNName + '_B1');
  WS.SendMatlabCommand('clear ' + NNName + '_Fnc1');
  LCnt := Round(Ws.Elem[NNName + '_LCnt', 1, 1]);
  // Определяем характеристики остальных слоев
  for I := 2 to LCnt do begin
    sI := Inttostr(I);
    Com := NNName + '_Lay' + sI + '=' + NNName + '.LW{' + sI + ',' + Inttostr(I
      - 1) + '}';
    Com := Com + #13#10 + NNName + '_B' + sI + '=' + NNName + '.b{' + sI + '}';
    Com := Com + #13#10 + NNName + '_Fnc' + sI + '=' + NNName + '.layers{' + sI +
      '}.transferFcn';
    WS.SendMatlabCommand(Com);
    Com := 'if ' + NNName + '_Fnc' + sI + '==''logsig'''#13#10 +
      NNName + '_Fnc' + sI + '=1'#13#10'end'; WS.SendMatlabCommand(Com);
    Com := 'if ' + NNName + '_Fnc' + sI + '==''purelin'''#13#10 +
      NNName + '_Fnc' + sI + '=2'#13#10'end'; WS.SendMatlabCommand(Com);
    Com := 'if ' + NNName + '_Fnc' + sI + '==''tansig'''#13#10 +
      NNName + '_Fnc' + sI + '=3'#13#10'end'; WS.SendMatlabCommand(Com);
    Com := 'if ' + NNName + '_Fnc' + sI + '==''hardlim'''#13#10 +
      NNName + '_Fnc' + sI + '=4'#13#10'end'; WS.SendMatlabCommand(Com);
    Com := 'if ' + NNName + '_Fnc' + sI + '==''radbas'''#13#10 +
      NNName + '_Fnc' + sI + '=5'#13#10'end'; WS.SendMatlabCommand(Com);
    Com := 'if ' + NNName + '_Fnc' + sI + '==''compet'''#13#10 +
      NNName + '_Fnc' + sI + '=6'#13#10'end'; WS.SendMatlabCommand(Com);
    Com := 'if isstr(' + NNName + '_Fnc' + sI + ')'#13#10 +
      NNName + '_Fnc' + sI + '=10'#13#10'end'; WS.SendMatlabCommand(Com);
    Ws.LoadArrayFromMatlab(NNName + '_Lay' + sI);

    if not Ws.LoadArrayFromMatlab(NNName + '_B' + sI) then
      Ws.NewArray(NNName + '_B' + sI, Ws.GetRows(NNName + '_Lay' + sI), 1, True);

    Ws.LoadArrayFromMatlab(NNName + '_Fnc' + sI);
    WS.SendMatlabCommand('clear ' + NNName + '_Lay' + sI);
    WS.SendMatlabCommand('clear ' + NNName + '_B' + sI);
    WS.SendMatlabCommand('clear ' + NNName + '_Fnc' + sI);
  end;
end;

procedure mSaveNNToBinFile(Ws: TWorkspace; NNName, FileName: string;
  NewFile: Boolean = True);
var
  I, LCnt: Integer;
  sI: string;
begin
  if Ws.Find(NNName + '_LCnt') = -1 then Ws.DoError('network not found');
  LCnt := Round(Ws.Elem[NNName + '_LCnt', 1, 1]);
  if NewFile then
    if FileExists(FileName) then DeleteFile(FileName);
  for I := 1 to LCnt do begin
    sI := Inttostr(I);
    Ws.SaveToBinFile(FileName, NNName + '_Lay' + sI);
    Ws.SaveToBinFile(FileName, NNName + '_B' + sI);
    Ws.SaveToBinFile(FileName, NNName + '_Fnc' + sI);
  end;
  Ws.SaveToBinFile(FileName, NNName + '_LCnt');
end;

procedure mTrainPerceptron(Ws: TWorkspace; X, D: string; epoch: Cardinal; err: Real;
  W: string; E: string; T: string; ProcProgress: TTrainProgress = nil);
var
  Xrows, Xcols, Drows, Dcols, I, J, K: Integer;
  y, ER: Real;
  Tc: DWord;
begin
  Tc := GetTickCount;
  with TWorkspace.Create('mTrainPerceptron') do begin
    if (E <> '') and (not IsTrueName(E)) then DoError(matBadName);
    if (T <> '') and (not IsTrueName(T)) then DoError(matBadName);
    CheckResAr(W);
    CopyRef(Ws, X, 'X');
    CopyRef(Ws, D, 'D');
    GetSize('X', Xrows, Xcols);
    GetSize('D', Drows, Dcols);
    if Xcols <> Dcols then DoError(matArraysNotAgree);
    if Drows <> 1 then DoError(matIsNotVektor);
    // Добавляем нулевой поляризованный вход с едниичными элементами
    AddRows(NewFillAr(GenName(), 1, Xcols, 1, 0), 'X', 'X');
    Inc(Xrows);
    // Создаем вектор весов
    NewArray('W', Xrows, 1, True);

    // Определяем начальную ошибку (что показывать на графике)
    ER := 0;
    for J := 1 to Xcols do begin
      CopyCutCols('X', 'TrVek', J, 1); // обучающий вектор
      y := nnHardlim(Elem[SumRows(CalcFunc2('TrVek', 'W', 'SumVek', fncMul),
          'SumVek'), 1, 1]); // расчет нейросети
      ER := ER + sqr(y - Elem['D', 1, J]);
    end;
    if @ProcProgress <> nil then
      ProcProgress(0, ER, err); // Вызываем процедуру отображения


    // Выполняем цикл обучения
    for I := 1 to epoch do begin
      for J := 1 to Xcols do begin // берем очередной обучающий вектор
        CopyCutCols('X', 'TrVek', J, 1);
        for K := 1 to 100 do begin
          y := nnHardlim(Elem[SumRows(CalcFunc2('TrVek', 'W', 'SumVek', fncMul),
              'SumVek'), 1, 1]);
          if Round(y) = Round(Elem['D', 1, J]) then Break;
          CalcFunc2(CalcFunc2('TrVek', NewFillAr('SubVek', 1, 1,
            Elem['D', 1, J] - y, 0), 'Wcol', fncMul), 'W', 'W', fncSum);
        end; // while
      end; // j
      // Вычисляем ошибку
      ER := 0;
      // Для каждого обучающего вектора выполняем расчет нейросети и
      // добавляем к значению ошибки
      for J := 1 to Xcols do begin
        CopyCutCols('X', 'TrVek', J, 1); // обучающий вектор
        y := nnHardlim(Elem[SumRows(CalcFunc2('TrVek', 'W', 'SumVek', fncMul),
            'SumVek'), 1, 1]); // расчет нейросети
        ER := ER + sqr(y - Elem['D', 1, J]); //- по окончании эпохи
      end;
      if @ProcProgress <> nil then
        ProcProgress(I, ER, err); // Вызываем процедуру отображения
      // Определяем, нужно ли проходить следующий цикл обучения
      if ER <= err then Break;
    end; // i
    Tc := GetTickCount - Tc;
    if E <> '' then MoveArray(Ws, NewFillAr(GenName, 1, 1, ER, 0), E);
    if T <> '' then MoveArray(Ws, NewFillAr(GenName, 1, 1, Tc, 0), T);
    MoveArray(Ws, 'W', W);
    Free();
  end;
end;

procedure mCalcKohon(Ws: TWorkspace; NNName, TestVek, ResVek: string; var Per: Real;
  Euklid: string = '');
var
  H: Real;
  MaxR, MinR: Real;
begin
  with TWorkspace.Create('mCalcKohon') do begin
    CheckResAr(ResVek);
    CopyRef(Ws, NNName + '_Lay1', 'L1');
    CopyRef(Ws, NNName + '_Lay2', 'L2');
    CopyRef(Ws, TestVek, 'X');
    if (GetCols('X') > 1) and (GetRows('X') = 1) then Transpose('X', 'X');
    // Определяем вектор евклидовых расстояний между весами и входом
    CalcNegdist(SelfWS, 'L1', 'X', 'Out');

    // Определяем максимальную и минимальную точку в Out
    Transpose('Out', 'Out1');
    GetMinMax('Out1', MinR, MaxR);
    H := MaxR - MinR;
    Per := 0;
    NewFillAr('MinP', 1, 1, MinR, 0);
    AddCols('MinP', 'Out1', 'Out1');
    AddCols('Out1', 'MinP', 'Out1');
    // Ищем точки экстремума, лежащие над линией, проведенной на 10 % ниже,
    // чем Max
    mScaleSignals(SelfWS, 'Out1', 'Out1', 1000);
    if mFindMaxPoints(SelfWS, 'Out1', 'Points', MaxR - H / 10) then
      Per := 100 / GetCols('Points');
    // Определяем индекс максимального элемента в Out
    GetMax('Out', '', 'Max', dimCols);
    // Копируем столбец с полученным индексом из L2 - это есть результат
    CopyCutCols('L2', 'Y', Round(Elem['Max', 1, 1]), 1);
    MoveArray(Ws, 'Y', ResVek);
    if IsTrueName(Euklid) then begin
      CalcFunc2(0, 'Out', 'Out', fncSub);
      MoveArray(Ws, 'Out', Euklid);
    end;
    Free();
  end;
end;

procedure mClearNetwork(Ws: TWorkspace; NNName: string);
var
  I, LCnt: Integer;
  sI: string;
begin
  if not Ws.ArrayExists(NNName + '_LCnt') then Exit;
  LCnt := Round(Ws.Elem[NNName + '_LCnt', 1, 1]);
  for I := 1 to LCnt do begin
    sI := Inttostr(I);
    Ws.Clear(NNName + '_Lay' + sI);
    Ws.Clear(NNName + '_B' + sI);
    Ws.Clear(NNName + '_Fnc' + sI);
  end;
  Ws.Clear(NNName + '_LCnt');
end;


{ TNeuroNet }

{function TNeuroNet.CalcHiddenDelta(Ws: TWorkspace; nextW, nextDelta, Proizv,
  Delta: string): string;
var
  Temp1: string;
begin
  with Ws do begin
    CheckResAr(Delta);
    Temp1 := GenName();
    Transpose(nextW, Temp1);
    MulMatrix(Temp1, nextDelta, Temp1);
    CalcFunc2(Temp1, Proizv, Delta, fncMul);
  end;
end;}

{function TNeuroNet.CalcOutputDelta(Y, T, Summa: string): string;
var
  Temp1, Temp2: string;
begin
  with FWorkspace do begin
    Result := FLayers[Length(FLayers)].Delta;
    Temp1 := GenName();
    CalcFunc2(Y, T, Temp1, fncSub);
    Temp2 := GenName();
    CalcProizvActFnc(Summa, Temp2, 'purelin');
    CalcFunc2(Temp1, Temp2, Result, fncMul);

    Clear(Temp1);
    Clear(Temp2);
  end;
end;}

{function TNeuroNet.CalcProizvActFnc(Summa, Proizv, FncType: string): string;
var
  Y: string;
begin
  with FWorkspace do begin
    CheckResAr(Proizv);
    Result := Proizv;
    Y := GenName();
    
    if FncType = 'logsig' then begin
      // Вычисляем значение функции
      CalcFunc(Summa, Y, nnLogsig);
      // Вычисляем производную
      CalcFunc2('1', Y, Proizv, fncSub);
      CalcFunc2(Y, Proizv, Proizv, fncMul);
    end;

    if FncType = 'purelin' then begin
      CopyArray(Summa, Proizv);
      FillAr(Proizv, 1, 0);
    end;

    Clear(Y);
  end;
end;}

constructor TNeuroNet.Create(Neurons: array of Integer;
  TransFuncs: array of TTransferFunction);
begin
  inherited Create;
  FWorkspace := TWorkspace.Create('Нейронная сеть');
  SetNeuronsAndTransFuncs(Neurons, TransFuncs);
end;

destructor TNeuroNet.Destroy;
begin
  FWorkspace.Free;
  FLayers := nil;
  inherited;
end;

procedure TNeuroNet.Error(Msg: string; Args: array of const);
begin
  raise Exception.CreateFmt(Msg, Args);
end;

{procedure TNeuroNet.InitWeights;
var
  I: Integer;
begin
  with FWorkspace do begin
    // Для матриц весов число строк равно числу нейронов, а число
    // столбцов равно числу входов. Самый первый вход НС - вход поляризации,
    // который равен 1
    // Для первого слоя:
    NewArray(FLayers[1].Weights, FLayers[1].NeuronCnt, GetRows(FTrainData), True);

    for I := 2 to FLayCount do begin
      NewArray(FLayers[I].Weights, FLayers[I].NeuronCnt,
        FLayers[I - 1].NeuronCnt + 1, True);
      // Здесь " + 1" соответствует входу поляризации
    end;
  end;
end;}


procedure TNeuroNet.SetNeuronsAndTransFuncs(Neurons: array of Integer;
  TransFuncs: array of TTransferFunction);
var
  I: Integer;
begin
  if Length(Neurons) < 1 then Error('Нейронная сеть должна иметь хотябы один слой', []);
  if Length(Neurons) <> Length(TransFuncs) then
    Error('Число слоев отличается от числа функций активации!', []);

  FLayCount := Length(Neurons);
  SetLength(FLayers, Length(Neurons));

  // Сохраняем необходимые данные
  with FWorkspace do
    for I := 0 to Length(Neurons) - 1 do begin
      Layers[I].NeuronCnt := Neurons[I];
      Layers[I].TransFnc := TransFuncs[I];

      Clear(Layers[I].Weights);
      //Clear(FLayers[I].Delta);
      //Clear(FLayers[I].Summa);
      
      FLayers[I].Weights := GenName();
      //FLayers[I].Delta := GenName();
      //FLayers[I].Summa := GenName();
    end;
end;

procedure TNeuroNet.SetTrainAndTargetData(Ws: TWorkspace; TrainData,
  TargetData: string);
//var
//  Vek: string;
begin
  with FWorkspace do begin
    // На всякий случай удалим массивы
    Clear(FTrainData);
    Clear(FTargetData);

    FTrainData  := GenName();
    FTargetData := GenName();
    CopyArray(Ws, TrainData, FTrainData);   // Копируем обуч. выборку
    CopyArray(Ws, TargetData, FTargetData); // Копируем целевую выборку

    if Layers[Length(Layers) - 1].NeuronCnt <> GetRows(FTargetData) then
      DoError('Размеры целевого вектора заданы неверно!');

    if GetCols(FTargetData) <> GetCols(FTrainData) then
      DoError('Размеры обучающей и целевой выборки не согласованны!');
  end;
end;

{function TNeuroNet.SimNet(ResultAr: string): string;
var
  I, J: Integer;
  F, S, Vek: string;
begin
  with FWorkspace do begin
    // Рассчитываем первый слой

    F    := GenName;
    S    := GenName;
    Vek  := GenName;

    CopyArray(FTrainData, F);

    for I := 1 to FLayCount do begin
      MulMatrix(F, FLayers[I].Weights, S);
      NewArray(Vek, 1, GetCols(S), True);
      AddRows(Vek, S, FLayers[I].Summa);
      // Применяем передаточную функцию
      if FLayers[I].TransFnc = 'logsig' then
        CalcFunc(FLayers[I].Summa, F, nnLogsig);
      if FLayers[I].TransFnc = 'purelin' then
        CopyArray(FLayers[I].Summa, F);
      // Первую строку заполняем единицами
      for J := GetCols(F) downto 1 do Elem[F, 1, J] := 1;
    end;

    RenameArray(F, ResultAr);

    Clear(S);
    Clear(Vek);
    
    SaveToBinFile(wsName);
  end;
  
end;}


{ TNetLVQ }

procedure TNetLVQ.InitWeights;
begin
  inherited;
  Workspace.SLoad(Layers[0].Weights, '3 5 4.5 5.5; 3 5 4.5 5.5');
  Workspace.SLoad(Layers[1].Weights, '0 0; 1 0; 0 1');
end;

function TNetLVQ.Simulate: Real;
var
  I: Integer;
begin
  with TWorkspace.Create('Симуляция нейронной сети LVQ', Workspace) do
  begin
    LoadArray(Layers[0].Weights, 'Weights1');
    LoadArray(Layers[1].Weights, 'Weights2');
    LoadArray(FTrainData, 'TrainData');
    LoadArray(FTargetData, 'TargetData');
    // Расчитываем евклидову норму
    CalcNegDist(SelfWS, 'Weights1', 'TrainData', 'IWZ');
    // Для каждого столбца определяем индекс максимального элемента
    GetMax('IWZ', '', 'Indexes', dimCols);
    // Создаем массив, число строк которого соответствует числу нейронов 1-го слоя
    NewZeros('Ac1', Layers[0].NeuronCnt, GetCols('Indexes'));
    // Вставляем в этот массив единицы там, куда указывают элементы Indexes
    for I := 1 to GetCols('Indexes') do
      Elem['Ac1', Trunc(Elem['Indexes', 1, I]), I] := 1;
    // Умножаем веса второго слоя на полученный массив
    MulMatrix('Weights2', 'Ac1', 'OutArray');
    // Определяем разницу между целевой матрицей и матрицей OutArray
    CalcFunc2('TargetData', 'OutArray', 'Differ', fncSub);
    // Определяем ошибку MSE
    Result := CalcMSE(SelfWS, 'Differ'); // Результат тот же, что и в Матлабе
    Free;
  end; 
end;

end.

