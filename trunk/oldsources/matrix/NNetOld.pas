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
{ ������ NNet - �������� � ������ ��������� ����� � ������� ������� Matrix    }
{ (�) ������� �.�., 2005-2006                                                 }
{ ����� �����: http://matrix.kladovka.net.ru/                                 }
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

  // �������� ������������ ������������ �������. �������� tfNone ������������
  // � ����� ������ �������� ���������, �������� LVQ
  TTransferFunction = (tfNone, tfLogsig, tfTansig, tfPurelin);

  TTrainProgress = procedure(epoch: Integer; err, ideal: Real);

  TLayer = record    // ���� ��������� ����

    {���������� �������� � ������ ����}
    NeuronCnt: Integer;

    {������������ ������� ����. ����������, �� ������ ��������� ��������������
     ������, ����������� ���������� ����������.}
    TransFnc: TTransferFunction;

    {������� �����. ������ ������ ��������� ���� ������ �������. ����� �����
     ����� ����� ��������. ������ ������� ������ ������ - ��������}
    Weights: string;

    {������� ������. ����������� ��� ������� ��������� ���������. ������
     ������� �� ��, ��� � ����� ����������� ���������}
    Delta: string;

    {�����, ���������� �� ������ ����������� ���������}
    Summa: string;
    
  end;

  TLayers = array of TLayer;

  {����� TNeuroNet �������� �������� �������, ������������ ����� �����������
   ��������! ������ �������� �� � �������, � � ��������}
  TNeuroNet = class(TObject)

    FWorkspace: TWorkspace; // ������� ������� ��������� ����

    FTrainData: string; // ��������� �������

    FTargetData: string; // ������� �������

    FLayers: TLayers; // ���� ��������� ����

    FLayCount: Integer; // ���������� ����� (�� ���������)

    procedure Error(Msg: string; Args: array of const);

  private

  public
    {�������� ��������� ����. Neurons - ������ ����� �������� ��� ������� ����.
     ��� ����� ������ ���: [2, 5, 1], ��� ����� �������� ���������� ��������
     � ��������������� ����, � ���������� ����� ������������� ����� �����.
     TransFuncs - ������������ ������� ������� ����. ����� ������ ���������
     �������: ['logsig', 'logsig', 'purelin']}
    constructor Create(Neurons: array of Integer;
      TransFuncs: array of TTransferFunction);

    {������� ���������� �� ������������, ������ �� ����� ������� � �����
     ������, ���� ����� �������� ��������� ��������� ����}
    procedure SetNeuronsAndTransFuncs(Neurons: array of Integer;
      TransFuncs: array of TTransferFunction);

    property Layers: TLayers read FLayers;

    {������� ������� ����� � �������������� ��}
    procedure InitWeights(); virtual; abstract;

    {��������� ��������� ����. � ���������� ��������� �������������
     ��������� Summa}
    //function SimNet(ResultAr: string): string;

    destructor Destroy; override;

    {��������� �� ��������� ������� ������� ������ ��������� ��������
     TrainData � ������ ������� �������� TargetData}
    procedure SetTrainAndTargetData(Ws: TWorkspace; TrainData, TargetData: string);

    {��������� ����������� ��������� ������� ���������}
    //function CalcProizvActFnc(Summa, Proizv: string; FncType:
    //  string = 'logsig'): string;


   // function CalcDelta();  

    {��������� Delta ��� ��������� ����}
    //function CalcOutputDelta(Y, T, Summa: string): string;

    {��������� Delta ��� �������� ����}
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

// ������� ��������� ������������������ ������
function CalcMSE(Ws: TWorkspace; ArName: string): Real;

// ������ ������������. �������� ���� �� �������
function CalcSoftMax(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray): TResultArray;

// �������� ������������. �������� ���� �� �������
function CalcLineScale(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray;
  MinRang: Real = -1; MaxRang: Real = 1): TResultArray;

// ��������������� ������������. �������� ���� �� �������
function CalcLogScale(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray): TResultArray;

// ��������� ���������� ����� ������ ���������
function CalcDist(Ws: TWorkspace; W, P, Z: string): string;

// ������������� ��������� ���������� ����� ������ ���������
// W - ����, P - ����� ��, Z - ���������
function CalcNegDist(Ws: TWorkspace; W, P, Z: string): string;




//////////////////////////////////////////////
// ������ � ����������� ����������� ������� //
//////////////////////////////////////////////

// ��������� ���������� � ������� ��� ������� ���������
procedure mSimNetWithMatlab(Ws: TWorkspace; NetPath, NetName, InputArray,
  ResultArray: string);

// ��������� ��������� �� �������
procedure mLoadNNFromMatlab(Ws: TWorkspace; NNName: string);

// ��������� ��������� � �������� ����
procedure mSaveNNToBinFile(Ws: TWorkspace; NNName, FileName: string;
   NewFile: Boolean = True);

// ��������� ��������� �� ��������� �����
procedure mLoadNNFromBinFile(Ws: TWorkspace; NNName, FileName: string);

// ������� ��� ������� ��������� ����
procedure mClearNetwork(Ws: TWorkspace; NNName: string);

// ����������� ��������� ���� � ������������ ����� �������� �
// ������������� ����� � �������� �������� ���������
// ����������� ��� ����, ��� ������������ ������� � ��� ��������� �������
// ��������� ���������� ����� ������� ����������� �������������
// � ��������� � ������ �������� (���������� ����������)
procedure mCalcKohon(Ws: TWorkspace; NNName, TestVek, ResVek: string;
  var Per: Real; Euklid: string = '');

{ �������� ������ �����������
X - ������ ��������� �������� (��������� �������),
D - ��������� �������� �� ������
epoch - ������������ ���-�� ��������
err - ��������� ����������� ��������
W - ������ ����� (��������� ��������) ���� ������ ��������� 1 ������
E - ������ � ����� ��������
T - ����� ��������
ProcProgress - ������� ��� ������������ ���� �������� - �� �����������}
procedure mTrainPerceptron(Ws: TWorkspace; X, D: string; epoch: Cardinal;
  err: Real; W: string; E: string; T: string;
  ProcProgress: TTrainProgress = nil);

///////////////////////////////////////////////
///////////////////////////////////////////////

implementation

// ����������� ������� ���������

function nnLogsig(const R: Real): Real;
begin
  Result := 1 / (1 + Power(matrixExp, -R))
end;

// ���������� ������� ���������

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
  { ������������� ��������� ���������� ����������� �� ��������� �������:
     z = -sqrt(sum((w-p)^2)), ���
     w - ������ ������� �����, p - ������� ������� ������ }
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
      // �������� i-�� �������
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
   // ���������� ����� �����
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
  I, LCnt: Integer; // ����� �����
  sI: string;
begin
  // ���������� ���-�� �����
  WS.SendMatlabCommand(NNName + '_LCnt=' + NNName + '.numLayers');
  Ws.LoadArrayFromMatlab(NNName + '_LCnt');
  WS.SendMatlabCommand('clear ' + NNName + '_LCnt');
  // ���������� �������������� �������� ����
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
  // ������� ��� ���������� �� �������
  WS.SendMatlabCommand('clear ' + NNName + '_Lay1');
  WS.SendMatlabCommand('clear ' + NNName + '_B1');
  WS.SendMatlabCommand('clear ' + NNName + '_Fnc1');
  LCnt := Round(Ws.Elem[NNName + '_LCnt', 1, 1]);
  // ���������� �������������� ��������� �����
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
    // ��������� ������� �������������� ���� � ���������� ����������
    AddRows(NewFillAr(GenName(), 1, Xcols, 1, 0), 'X', 'X');
    Inc(Xrows);
    // ������� ������ �����
    NewArray('W', Xrows, 1, True);

    // ���������� ��������� ������ (��� ���������� �� �������)
    ER := 0;
    for J := 1 to Xcols do begin
      CopyCutCols('X', 'TrVek', J, 1); // ��������� ������
      y := nnHardlim(Elem[SumRows(CalcFunc2('TrVek', 'W', 'SumVek', fncMul),
          'SumVek'), 1, 1]); // ������ ���������
      ER := ER + sqr(y - Elem['D', 1, J]);
    end;
    if @ProcProgress <> nil then
      ProcProgress(0, ER, err); // �������� ��������� �����������


    // ��������� ���� ��������
    for I := 1 to epoch do begin
      for J := 1 to Xcols do begin // ����� ��������� ��������� ������
        CopyCutCols('X', 'TrVek', J, 1);
        for K := 1 to 100 do begin
          y := nnHardlim(Elem[SumRows(CalcFunc2('TrVek', 'W', 'SumVek', fncMul),
              'SumVek'), 1, 1]);
          if Round(y) = Round(Elem['D', 1, J]) then Break;
          CalcFunc2(CalcFunc2('TrVek', NewFillAr('SubVek', 1, 1,
            Elem['D', 1, J] - y, 0), 'Wcol', fncMul), 'W', 'W', fncSum);
        end; // while
      end; // j
      // ��������� ������
      ER := 0;
      // ��� ������� ���������� ������� ��������� ������ ��������� �
      // ��������� � �������� ������
      for J := 1 to Xcols do begin
        CopyCutCols('X', 'TrVek', J, 1); // ��������� ������
        y := nnHardlim(Elem[SumRows(CalcFunc2('TrVek', 'W', 'SumVek', fncMul),
            'SumVek'), 1, 1]); // ������ ���������
        ER := ER + sqr(y - Elem['D', 1, J]); //- �� ��������� �����
      end;
      if @ProcProgress <> nil then
        ProcProgress(I, ER, err); // �������� ��������� �����������
      // ����������, ����� �� ��������� ��������� ���� ��������
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
    // ���������� ������ ���������� ���������� ����� ������ � ������
    CalcNegdist(SelfWS, 'L1', 'X', 'Out');

    // ���������� ������������ � ����������� ����� � Out
    Transpose('Out', 'Out1');
    GetMinMax('Out1', MinR, MaxR);
    H := MaxR - MinR;
    Per := 0;
    NewFillAr('MinP', 1, 1, MinR, 0);
    AddCols('MinP', 'Out1', 'Out1');
    AddCols('Out1', 'MinP', 'Out1');
    // ���� ����� ����������, ������� ��� ������, ����������� �� 10 % ����,
    // ��� Max
    mScaleSignals(SelfWS, 'Out1', 'Out1', 1000);
    if mFindMaxPoints(SelfWS, 'Out1', 'Points', MaxR - H / 10) then
      Per := 100 / GetCols('Points');
    // ���������� ������ ������������� �������� � Out
    GetMax('Out', '', 'Max', dimCols);
    // �������� ������� � ���������� �������� �� L2 - ��� ���� ���������
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
      // ��������� �������� �������
      CalcFunc(Summa, Y, nnLogsig);
      // ��������� �����������
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
  FWorkspace := TWorkspace.Create('��������� ����');
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
    // ��� ������ ����� ����� ����� ����� ����� ��������, � �����
    // �������� ����� ����� ������. ����� ������ ���� �� - ���� �����������,
    // ������� ����� 1
    // ��� ������� ����:
    NewArray(FLayers[1].Weights, FLayers[1].NeuronCnt, GetRows(FTrainData), True);

    for I := 2 to FLayCount do begin
      NewArray(FLayers[I].Weights, FLayers[I].NeuronCnt,
        FLayers[I - 1].NeuronCnt + 1, True);
      // ����� " + 1" ������������� ����� �����������
    end;
  end;
end;}


procedure TNeuroNet.SetNeuronsAndTransFuncs(Neurons: array of Integer;
  TransFuncs: array of TTransferFunction);
var
  I: Integer;
begin
  if Length(Neurons) < 1 then Error('��������� ���� ������ ����� ������ ���� ����', []);
  if Length(Neurons) <> Length(TransFuncs) then
    Error('����� ����� ���������� �� ����� ������� ���������!', []);

  FLayCount := Length(Neurons);
  SetLength(FLayers, Length(Neurons));

  // ��������� ����������� ������
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
    // �� ������ ������ ������ �������
    Clear(FTrainData);
    Clear(FTargetData);

    FTrainData  := GenName();
    FTargetData := GenName();
    CopyArray(Ws, TrainData, FTrainData);   // �������� ����. �������
    CopyArray(Ws, TargetData, FTargetData); // �������� ������� �������

    if Layers[Length(Layers) - 1].NeuronCnt <> GetRows(FTargetData) then
      DoError('������� �������� ������� ������ �������!');

    if GetCols(FTargetData) <> GetCols(FTrainData) then
      DoError('������� ��������� � ������� ������� �� ������������!');
  end;
end;

{function TNeuroNet.SimNet(ResultAr: string): string;
var
  I, J: Integer;
  F, S, Vek: string;
begin
  with FWorkspace do begin
    // ������������ ������ ����

    F    := GenName;
    S    := GenName;
    Vek  := GenName;

    CopyArray(FTrainData, F);

    for I := 1 to FLayCount do begin
      MulMatrix(F, FLayers[I].Weights, S);
      NewArray(Vek, 1, GetCols(S), True);
      AddRows(Vek, S, FLayers[I].Summa);
      // ��������� ������������ �������
      if FLayers[I].TransFnc = 'logsig' then
        CalcFunc(FLayers[I].Summa, F, nnLogsig);
      if FLayers[I].TransFnc = 'purelin' then
        CopyArray(FLayers[I].Summa, F);
      // ������ ������ ��������� ���������
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
  with TWorkspace.Create('��������� ��������� ���� LVQ', Workspace) do
  begin
    LoadArray(Layers[0].Weights, 'Weights1');
    LoadArray(Layers[1].Weights, 'Weights2');
    LoadArray(FTrainData, 'TrainData');
    LoadArray(FTargetData, 'TargetData');
    // ����������� ��������� �����
    CalcNegDist(SelfWS, 'Weights1', 'TrainData', 'IWZ');
    // ��� ������� ������� ���������� ������ ������������� ��������
    GetMax('IWZ', '', 'Indexes', dimCols);
    // ������� ������, ����� ����� �������� ������������� ����� �������� 1-�� ����
    NewZeros('Ac1', Layers[0].NeuronCnt, GetCols('Indexes'));
    // ��������� � ���� ������ ������� ���, ���� ��������� �������� Indexes
    for I := 1 to GetCols('Indexes') do
      Elem['Ac1', Trunc(Elem['Indexes', 1, I]), I] := 1;
    // �������� ���� ������� ���� �� ���������� ������
    MulMatrix('Weights2', 'Ac1', 'OutArray');
    // ���������� ������� ����� ������� �������� � �������� OutArray
    CalcFunc2('TargetData', 'OutArray', 'Differ', fncSub);
    // ���������� ������ MSE
    Result := CalcMSE(SelfWS, 'Differ'); // ��������� ��� ��, ��� � � �������
    Free;
  end; 
end;

end.

