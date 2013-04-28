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
  TTransferFunction = (tfNone, tfLogsig, tfTansig, tfPurelin, tfHardlim, tfRadbas, tfTanh);

  TTrainProgress = procedure(Epoch, Epochs: Integer; Error, Goal: Real) of Object;

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
  private
    FWorkspace: TWorkspace; // ������� ������� ��������� ����

    FLayers: TLayers; // ���� ��������� ����

    FLayCount: Integer; // ���������� ����� (�� ���������)

    FIsTraining: Boolean;
    FMaxTrainTime: Cardinal;
    FEpochs: Integer;
    FGoal: Real; // ����������, ��������� �� � ������ ������ ���������

    FStopReason: string;
    FCurrentEpoch: Integer;
    FStartTime: TDateTime;
    FOnTrainProgress: TTrainProgress;
    FStopTraining: Boolean;

    procedure Error(Msg: string; Args: array of const);
    procedure SetEpochs(const Value: Integer);
    procedure SetGoal(const Value: Real);
    procedure SetMaxTrainTime(const Value: Cardinal);
    procedure SetOnTrainProgress(const Value: TTrainProgress);

    // ��������� ������-������ ArName, ����� ��������� �������� ����� BatchSize
    // ������ ��� BatchSize = 5: [3     5     2     1     4]
    procedure RandPerm(ArName: TResultArray; BatchSize: Integer);    
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

    procedure Train(); virtual; abstract;

    destructor Destroy; override;

    {��������� �� ��������� ������� ������� ������ ��������� ��������
     TrainData � ������ ������� �������� TargetData}
    procedure SetTrainAndTargetData(Ws: TWorkspace; TrainData, TargetData: string);

    {������������ ����� ��� �������� ������ ��. ���� �� �� ������ ��������� ��
     ��� �����, �� ������� �������� ���������. ����� �������� � �������������}
    property MaxTrainTime: Cardinal read FMaxTrainTime write SetMaxTrainTime;

    {������������ ���-�� �������� ��������. ������� �������� ���������, ���
     ������ ����� ������� �������� �������� �������� Epochs}
    property Epochs: Integer read FEpochs write SetEpochs;

    {��������� �������� �������� ��. ��� ������ MSE ��������� Goal,
     �������� ����������}
    property Goal: Real read FGoal write SetGoal;

    property StopReason: string read FStopReason;

    property Workspace: TWorkspace read FWorkspace;

    property OnTrainProgress: TTrainProgress read FOnTrainProgress write SetOnTrainProgress;

    procedure StopTraining;
  end;

  TNetLVQ = class(TNeuroNet)   
  private
    function CheckForStopCriteria: Boolean;
  public
    // ��� �� LVQ �������������� ���� �������������� � �������������� ����.
    procedure InitWeights(); override;

    // ��������� ��������� ������ ��������� ����. �� ���� �������� ������� ������
    // � ���������� ������������ ������ DestArray.
    procedure Simulate(Ws: TWorkspace; SourArray: TInputArray; DestArray: TResultArray);

    // ��������� ��������� ��������� ���� � �������� ����.
    procedure SaveToFile(FileName: string);

    // ��������� ��������� ��������� ���� �� ��������� �����.
    procedure LoadFromFile(FileName: string);

    procedure SetPercentages(Ws: TWorkspace; PC: TInputArray);

    procedure Train(); override;
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


implementation

uses DateUtils;

// ����������� ������� ���������
function fncLogsig(const R: Real): Real;
begin
  Result := 1 / (1 + Power(matrixExp, -R))
end;

// ���������� ������� ���������
function fncTanh(const R: Real): Real;
begin
  Result := Tanh(R);
end;

function fncPurelin(const R: Real): Real;
begin
  Result := R;
end;

function fncTansig(const R: Real): Real;
begin
  Result := 2 / (1 + Power(matrixExp, -2 * R)) - 1
end;

function fncHardlim(const R: Real): Real;
begin
  if R >= 0 then Result := 1 else Result := 0;
end;

function fncRadbas(const R: Real): Real;
begin
  Result := Power(matrixExp, -Sqr(R));
end;

function CalcDist(Ws: TWorkspace; W, P, Z: string): string;
begin
  with Ws do
  begin
    Result := CalcNegDist(Ws, W, P, Z);
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
  with Ws do
  begin
    wAdr := GetAddress(GetSize(W, wRows, wCols));
    pAdr := GetAddress(GetSize(P, pRows, pCols));
    if wCols <> pRows then DoError('Matrix sizes do not match');
    CheckResAr(Z);
    Tmp := GenName();
    zAdr := GetAddress(NewArray(Tmp, wRows, pCols));
    for I := 1 to wRows do
      for K := 1 to pCols do
      begin
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
  with TWorkspace.Create('LineScale', Ws) do
  begin
    CheckResAr(DestAr);
    LoadArray(SourAr, 'A');
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
      AddCols('DestAr', 'Column', 'DestAr');
    end;
    ReturnArray('DestAr', DestAr);
    Free();
  end;
end;

function CalcLogScale(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray): TResultArray;
var
  I, C, aIdx, bIdx, Rows, Cols: Integer;
  R, M: Real;
begin
  with TWorkspace.Create('LogScale', Ws) do
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
    ReturnArray('B', DestAr);
    Free();
  end;
end;

function CalcSoftMax(Ws: TWorkspace; SourAr: TInputArray; DestAr: TResultArray): TResultArray;
var
  I, J, Rows, Cols, aIdx, eIdx, sIdx: Integer;
begin
  with TWorkspace.Create('SoftMax', Ws) do
  begin
    LoadArray(SourAr, 'n');
    CheckResAr(DestAr);
    Result := DestAr;

    eIdx := GetIndex(CalcFunc('n', 'expn', fncExp));
    sIdx := GetIndex(SumRows('expn', 'sum'));
    aIdx := CopyArray('expn', 'a');
    GetSize(aIdx, Rows, Cols);

    for I := 1 to Cols do
      for J := 1 to Rows do
        ElemI[aIdx, J, I] := ElemI[eIdx, J, I] / ElemI[sIdx, 1, I];  

    ReturnArray('a', DestAr);
    Free();
  end;
end;

function CalcMSE(Ws: TWorkspace; ArName: string): Real;
var
  Rows, Cols, Adr, I, J: Integer;
begin
  with Ws do
  begin
    Adr := GetAddress(GetSize(ArName, Rows, Cols));
    Result := 0;
    for I := 1 to Rows do
      for J := 1 to Cols do
        Result := Result + sqr(ElemFast[Adr, I, J, Cols]);
    Result := Result / (Rows * Cols);
  end;
end;               

{ TNeuroNet }
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

procedure TNeuroNet.RandPerm(ArName: TResultArray; BatchSize: Integer);
var
  S: string;
  I, J, Idx: Integer;
  Value: Real;
begin
  if BatchSize < 1 then
    Error('������ ��� ���������� ������� RandPerm', []);

  with Workspace do
  begin
    S := GenName;
    NewOnes(ArName, 1, BatchSize);
    RandomAr(S, 1, BatchSize);  

    // ���� ����������� �������
    for J := 1 to GetCols(S) do
    begin
      Value := 2;
      Idx := 0;
      for I := 1 to GetCols(S) do
      begin
        if Elem[S, 1, I] < Value then
        begin
          Value := Elem[S, 1, I];
          Idx := I;
        end;
      end;
      if Idx > 0 then
      begin
        Elem[S, 1, Idx] := 3;
        Elem[ArName, 1, J] := Idx;
      end;
    end;
    Clear(S);
  end;
end;

procedure TNeuroNet.SetEpochs(const Value: Integer);
begin
  FEpochs := Value;
end;

procedure TNeuroNet.SetGoal(const Value: Real);
begin
  FGoal := Value;
end;

procedure TNeuroNet.SetMaxTrainTime(const Value: Cardinal);
begin
  FMaxTrainTime := Value;
end;

procedure TNeuroNet.SetNeuronsAndTransFuncs(Neurons: array of Integer;
  TransFuncs: array of TTransferFunction);
var
  I: Integer;
begin
  if Length(Neurons) < 1 then Error('��������� ���� ������ ����� ������ ���� ����', []);
  if Length(Neurons) <> Length(TransFuncs) then
    Error('����� ����� ���������� �� ����� ������� ���������!', []);

  // ������� ������� �������
  //Workspace.Clear;

  FLayCount := Length(Neurons);
  SetLength(FLayers, Length(Neurons));

  // ��������� ����������� ������
  with FWorkspace do
    for I := 0 to Length(Neurons) - 1 do begin
      Layers[I].NeuronCnt := Neurons[I];
      Layers[I].TransFnc := TransFuncs[I];

      Clear(Layers[I].Weights);
      // ����������� ����� ����� �����
      Layers[I].Weights := Format('Weights_%d', [I]);
      //Clear(FLayers[I].Delta);
      //Clear(FLayers[I].Summa);
      
      //FLayers[I].Weights := GenName();
      //FLayers[I].Delta := GenName();
      //FLayers[I].Summa := GenName();
    end;
end;

procedure TNeuroNet.SetOnTrainProgress(const Value: TTrainProgress);
begin
  FOnTrainProgress := Value;
end;

procedure TNeuroNet.SetTrainAndTargetData(Ws: TWorkspace; TrainData,
  TargetData: string);
begin
  with FWorkspace do begin
    // �� ������ ������ ������ �������
    Clear('TrainData');
    Clear('TargetData');

    CopyArray(Ws, TrainData, 'TrainData');   // �������� ����. �������
    CopyArray(Ws, TargetData, 'TargetData'); // �������� ������� �������

    if Layers[Length(Layers) - 1].NeuronCnt <> GetRows('TargetData') then
      DoError('������� �������� ������� ������ �������!');

    if GetCols('TargetData') <> GetCols('TrainData') then
      DoError('������� ��������� � ������� ������� �� ������������!');
  end;
end;

procedure TNeuroNet.StopTraining;
begin
  FStopTraining := True;
end;

{ TNetLVQ }

function TNetLVQ.CheckForStopCriteria: Boolean;
var
  S: string;
begin
  if  (Epochs > 0) and (FCurrentEpoch = Epochs) then
    S := '� ���� �������� ���� ���������� �������� ����� ��������!';

  if (Goal > 0) and (Workspace.Elem['MseValue_', 1, 1] <= Goal) then
    S := '� ���� �������� ���� ���������� �������� ��������!';

  if (FMaxTrainTime > 0) and (Now >= IncMilliSecond(FStartTime, FMaxTrainTime)) then
    S := '�������� ��������� ��-�� ����������� �� �������!';

  if S <> '' then
    begin
      FStopReason := S;
      Result := True
    end
  else
    Result := False;
end;

procedure TNetLVQ.InitWeights;
var
  Tmp: string;
  I, J, wIdx: Integer;
  Value: Real;
begin
  inherited;

  with Workspace do
  begin
    // ���� ������� ���� ���������������� ������. ��� ������ ������ ������� ���������
    // ������� ��������� ������������ � ����������� �������, � ������������ ��
    // ������� ��������������.
    if (not ArrayExists('TrainData')) or (not ArrayExists('TargetData')) then
      Error('��������� ��� ������� ������� �� ������!', []);

    Tmp := GetMean('TrainData', GenName(), dimRows);
    // ������� ������� ����� ����������� ��������
    wIdx := NewArray(Layers[0].Weights, Layers[0].NeuronCnt, GetRows('TrainData'));
    for I := 1 to GetCols(wIdx) do
    begin
      Value := Elem[Tmp, I, 1];
      for J := 1 to GetRows(wIdx) do
        ElemI[wIdx, J, I] := Value;
    end;
    Clear(Tmp);

    // ���� ������� "Percentages" �� ����������, �� ������� ���:
    if not ArrayExists('Percentages') then
      NewFillAr('Percentages', 1, Layers[1].NeuronCnt, 1/Layers[1].NeuronCnt, 0);

    // �������������� ���� ������� ����. �������� ���-�-���� ��� � �������.
    // � ������ ������� ������� ����� �� ����� ����� �������
    // ���������� �������� ���������:
    // 1 1 1 0 0 0 0 0 0
    // 0 0 0 1 1 1 0 0 0
    // 0 0 0 0 0 0 1 1 1

    // cumsum - ��������� ������
    NewZeros('cumsum', 1, GetCols('Percentages') + 1);
    Value := 0;
    for I := 1 to GetCols('Percentages') do
    begin
      Value := Value + Elem['Percentages', 1, I];
      Elem['cumsum', 1, I + 1] := Value;
    end;
    // �������� 'cumsum' �� ����� �������� 1-�� ����
    CalcFunc2('cumsum', Layers[0].NeuronCnt, 'cumsum', fncMul);

    // ������� ������ ����� ��������� ����
    wIdx := NewArray(Layers[1].Weights, Layers[1].NeuronCnt, Layers[0].NeuronCnt, True);   

    // ������������� ���� ��������� ����
    for I := 1 to GetCols('cumsum') - 1 do
      for J := Trunc(Elem['cumsum', 1, I]) + 1 to Trunc(Elem['cumsum', 1, I + 1]) do
        ElemI[wIdx, I, J] := 1;

    // ����������� �� ���������� �������    
    Clear('cumsum');
  end;
end;

procedure TNetLVQ.LoadFromFile(FileName: string);
begin
  Error('������� ��� �� �����������!', []);
end;

procedure TNetLVQ.SaveToFile(FileName: string);
begin
  Error('������� ��� �� �����������!', []);
end;

procedure TNetLVQ.SetPercentages(Ws: TWorkspace; PC: TInputArray);
begin
  with Workspace do
  begin
    if ArrayExists(Layers[1].Weights) then
      Error('������ "Percentages" ����� �������� �� �������������!', []);

    if Ws.GetCols(PC) <> Layers[1].NeuronCnt then
      Error('������ "Percentages" ������ ����� �����, ������ %d', [Layers[1].NeuronCnt]);

    Clear('Percentages');
    CopyArray(Ws, PC, 'Percentages');
  end;
end;

{������� ��������� ������ ��������� ����. ��� ����� �������������� ��� �������������,
 ��� � � ���� �������� ��������, ������������ �������� Train. � ���� ������
 ������ ��������, �������� � ����������, ������������ ��� � ��������� �������:
 - MseValue_ - �������������������� ������ ����� ������� � ������������ ��������
 - Out1_ - ��������� ������� 1-�� ����
 - Differ_ - ������ �������
 ��� ������� - ���������. ��� ��������� � ����� ��������

 DestArray - ��������� ������� ��������� ����}
procedure TNetLVQ.Simulate(Ws: TWorkspace; SourArray: TInputArray; DestArray: TResultArray);
var
  I: Integer;
begin
  with TWorkspace.Create('��������� ��������� ���� LVQ', Workspace) do
  begin
    // ��������� ������� �����
    LoadArray(Layers[0].Weights, 'Weights1');
    LoadArray(Layers[1].Weights, 'Weights2');
    // ��������� ������� ������
    CopyRef(Ws, SourArray, 'TrainData');
    // ��������� � ������ �������� ������� ������
    if FIsTraining then LoadArray('TargetData', 'TargetData');
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
    // ���������� ��������� ������� 1-�� ����
    if FIsTraining then ReturnArray('Ac1', 'Out1_');
    // ���������� ������� ����� ������� �������� � �������� OutArray
    if FIsTraining then
    begin
      CalcFunc2('TargetData', 'OutArray', 'Differ', fncSub);  
      // ���������� ������������������ ����������
      NewFillAr('Mse', 1, 1, CalcMSE(SelfWS, 'Differ'), 0);
      // ���������� ������ �������
      ReturnArray('Differ', 'Differ_');
      // ���������� ������������������ ����������
      ReturnArray('Mse', 'MseValue_');
    end;
    // ���������� �������� ������
    if IsTrueName(DestArray) then MoveArray(Ws, 'OutArray', DestArray);       
    Free;
  end;
end;

procedure TNetLVQ.Train;
var
  Epoch, I, Batch: Integer;

label
  EndTrain;
begin
  inherited;
  FIsTraining := True;

  FStopReason := '�������� �� ���������!';
  FStartTime := Now;
  FStopTraining := False;

  Randomize;

  with Workspace do
  begin
    // ��������� ������ ��������� ����. ���� ����� ��� ��� �������...
    Simulate(SelfWS, 'TrainData', '');

    for Epoch := 0 to Epochs do
    begin
      // ���������� �������� ������� ��������
      FCurrentEpoch := Epoch;
      // ��������� �������� ������
      if CheckForStopCriteria then goto EndTrain;
      // �������� ������� ����������� ������������
      if Assigned(FOnTrainProgress) then
        FOnTrainProgress(Epoch, Epochs, 0, Goal);
      // ������������ ����� �� ������� ������������
      if FStopTraining then goto EndTrain;

      // ������� ������ ��������� ��������������� ������������������,
      // � ������� ���� ��� ����� ����� �� 1 �� N
      RandPerm('RandPerm', GetCols('TrainData'));
     // showmessage(SaveArrayToString('RandPerm'));
      for I := 1 to GetCols('RandPerm') do
      begin
        // ���������� ������ ��������� ��������� �������
        Batch := Trunc(Elem['RandPerm', 1, I]);

        // ******************************
        // ������ ������������ ������ for q=randperm(Q)
      end;

    end;
   //
  end;

  // ����� ��������� ��������
  EndTrain:

  // ������� ��� �������� �������
  with Workspace do
  begin
    Clear('RandPerm');
    Clear('MseValue_');
    Clear('Out1_');
    Clear('Differ_');
  end; 
  
  FIsTraining := False;
end;

end.

