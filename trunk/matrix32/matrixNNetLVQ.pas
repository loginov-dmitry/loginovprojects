{
Copyright (c) 2005-2013, Loginov Dmitry Sergeevich
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

{ *************************************************************************** }
{                                                                             }
{                                                                             }
{                                                                             }
{ ������ matrixNNetLVQ - ���������� ��������� ���� LVQ                        }
{ (c) 2005 - 2010 ������� ������� ���������                                   }
{ ��������� ����������: 15.12.2010                                            }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{$Include MatrixCommon.inc}

unit matrixNNetLVQ;

interface

uses
  SysUtils, Classes, Matrix32, matrixNNet, Math, DateUtils;

type
  TNNetLVQ = class(TNeuronNetwork)
  private
    {��������� �������� �������� ��� �������� ����������}
    procedure CreateStatArrays;
  protected
    procedure InitNetworkData; override;
  public
    {�������� ��������� ���� LVQ �� ������������ ���������, ����������� �������
     ��������� ���������� �������������� ������������ - ������ �������� ����������.
     ���������������� �������� ��� ���������� ������ �.�. � �������� �.�.
     ����������� � ������� "��������������� � �� ����������" � 6, 2008�.}
    procedure Train; override;

    {��������� ������������ ������ ��������� ��� LVQ}
    procedure Simulate(Inputs, Outputs: TMatrix); override;
    
    class function GetAlias: TSignature; override;

    {������������� ��������� ��� LVQ
    InputsCount - ���������� ������ ���
    HiddenLayerSize - ����� �������� � ������� ���� (���� ��������).
      ���� �������� ������������� ������������� �������� 1 / sqrt(InputsCount)
    OutLayerParts - ����������, ����� ����� �������� �������� ���� �����
      �������������� �� ������� ��������� ����. ���������� ��������� ��������
      ������� � �������� ����� �������� ��������� ����. ����� ��������� ��������
      ������ ���� ������ 1. ������� SetLVQParams ������������� ��������������
      ���� �������� ��������� ���� }
    procedure SetLVQParams(InputsCount, HiddenLayerSize: Integer; OutLayerParts: array of Double); overload;

    procedure SetLVQParams(InputsCount, HiddenLayerSize: Integer; OutLayerParts: TMatrix); overload;
  end;

resourcestring
  matSLVQOutErrorSum = '����� ��������, ������������ �������� ��������� ���� ���� LVQ, ������ ���� ������ 1';
  matSLVQWrongTrainDataSize = '�������� ����������� ���������� ������ ������';

implementation

{ TNNetLVQ }

procedure TNNetLVQ.CreateStatArrays;
var
  Stat: TRecordMatrix;
begin
  Stat := TRecordMatrix.Create();

  // ��� ���������� ��� �������� �������� ����
  Layers[0].Fields['Stat'] := Stat;

  // ������� �������������� �������� ������ ��������������� � ������ ��������
  // ��� ���� ������� ������ ������������������ ������� ����������

  // ���������� ������ ��������� (Correction) �������� ��� ������ ����� ��������
  // ����� ����� = ����� ���� ��������
  // ����� �������� = ����� ��������
  Stat.Fields['CorFull'] := TIntegerMatrix.Create();

  // ���� �����, ��� � Corr, ������ �������������. ����� ���� ������.
  // ����� �������� = ����� ��������
  Stat.Fields['CorFullAll'] := TIntegerMatrix.Create();

  // ���������� ��������� ��������� �������� ��� ������ ����� ��������
  // ����� ����� = ����� ���� ��������
  // ����� �������� = ����� ��������
  Stat.Fields['Cor'] := TIntegerMatrix.Create();

  // ���� �����, ��� � Corr, ������ �������������. ����� ���� ������.
  // ����� �������� = ����� ��������
  Stat.Fields['CorAll'] := TIntegerMatrix.Create();

  // ���������� ������������ (Repulsion) �������� ��� ������ ����� ��������
  // ����� ����� = ����� ���� ��������
  // ����� �������� = ����� ��������
  Stat.Fields['Rep'] := TIntegerMatrix.Create();

  Stat.Fields['RepAll'] := TIntegerMatrix.Create();

  // ���������� "����������" ����� ��� ������ ����� ��������
  Stat.Fields['WinTrue'] := TIntegerMatrix.Create();

  // ����� ���������� "����������" ����� ��� ������� �������
  Stat.Fields['WinTrueAll'] := TIntegerMatrix.Create();

  // ���������� "������" ����� ��� ������ ����� ��������
  Stat.Fields['WinFalse'] := TIntegerMatrix.Create();
end;

class function TNNetLVQ.GetAlias: TSignature;
begin
  Result := 'netlvq';
end;

procedure TNNetLVQ.InitNetworkData;
begin
  inherited;

  // ��� LVQ ������� �� 2-� �����: �������� � ���������
  LayersCount := 2;

  // ������� ������� �������������� ������
  CreateStatArrays;
end;

procedure TNNetLVQ.SetLVQParams(InputsCount, HiddenLayerSize: Integer;
  OutLayerParts: array of Double);
var
  Sum: Double;
  I: Integer;
  Part, CurElem, CurRow, J, HighLimit: Integer;
  W: TMatrix;
begin
  try
    Sum := 0;
    for I := 0 to High(OutLayerParts) do
    begin
      if OutLayerParts[I] >= 0 then
        Sum := Sum + OutLayerParts[I]
      else
        raise EMatrixBadParams.CreateFmt('Error value OutLayerParts[%d]=%.2f', [I, OutLayerParts[I]]);
    end;

    if Math.SameValue(Sum, 1) then
    begin
      Layers[0].Fields['W'].Resize([HiddenLayerSize, InputsCount]);

      //�������������� ������ ����� ���������� 1 / sqrt(InputsCount)
      Layers[0].Fields['W'].FillByValue(1 / sqrt(InputsCount));

      W := Layers[1].Fields['W']; // ������ �� ������ ����� ��������� ����

      // ������������� ������ ������� ����� ��������� ����
      W.Resize([Length(OutLayerParts), HiddenLayerSize]);
      W.Zeros; // �������� ��� ��������

      CurElem := 0; // ������� �������
      CurRow := 0; // ������� ������ ������� Layers[1].Fields['W']

      // ���������� ������� �������� ���� �� �������� ���� �������� ���������,
      // �������� � ������� OutLayerParts
      for I := 0 to High(OutLayerParts) do
      begin
        // ����������, ��� ������� ��������� ��������� ���� �� ������ ���������� �������� 1
        Part := Round(HiddenLayerSize * OutLayerParts[I]);

        if CurRow = W.Rows - 1 then // ��� ��������� ������ ����� ��������� 1 ���� ���������� ���������
          HighLimit := W.Cols - 1
        else
          HighLimit := CurElem + Part - 1;

        for J := CurElem to HighLimit do
        begin
          // ���������� �� ������ ������ �� ������� �������
          // ���� �� ������� ����������� �����-������ ������, �� ������ ���������.
          // ��� �� ��������� ��������, ��� ������� AV.
          if (J < W.Cols) and (CurRow < W.Rows) then
            W.ElemI[CurRow, J] := 1;
        end;

        Inc(CurRow);
        Inc(CurElem, Part);
      end;

    end else
    begin
      raise EMatrixBadParams.Create(matSLVQOutErrorSum);
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetLVQParams'){$ENDIF}
  end;
end;

procedure TNNetLVQ.SetLVQParams(InputsCount, HiddenLayerSize: Integer;
  OutLayerParts: TMatrix);
var
  Ar: array of Double;
  I: Integer;
begin
  try
    SetLength(Ar, OutLayerParts.ElemCount);
    for I := 0 to High(Ar) do
      Ar[I] := OutLayerParts.VecElem[I];
    SetLVQParams(InputsCount, HiddenLayerSize, Ar);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'SetLVQParams2'){$ENDIF}
  end;
end;

procedure TNNetLVQ.Simulate(Inputs, Outputs: TMatrix);
var
  MRes, W1, W2, Z, MinIndexes: TMatrix;
  I, J, Ind: Integer;
begin
  try
    CheckForMatrixTypes([Inputs, Outputs], [mtNumeric]);

    W1 := Layers[0].Fields['W'];
    W2 := Layers[1].Fields['W'];

    // ����� ����� ������� Inputs ������ ��������� � ������ �������� ������� ����� W
    if Inputs.Rows <> W1.Cols then
      raise EMatrixBadParams(matSLVQWrongTrainDataSize);

    MRes := Outputs.CreateInstance();
    try
      MRes.Resize([W2.Rows, Inputs.Cols]);
      MRes.Zeros; // �������� ��� �������� �������

      // ���� ����� ������� ��������� ������ ������� CalcDist
      Z := TDoubleMatrix.Create(MRes);

      CalcDist(W1, Inputs, Z);

      MinIndexes := TIntegerMatrix.Create(MRes);

      // ��� ������� ������� ������� Z ���� ���������� ��������. ��� ����� ��� ������
      Z.GetMinMaxMean(Z.DimRows, nil, nil, nil, nil, MinIndexes, nil);

      // ������ ���� ������ �������� ���������� ���������. MinIndexes �����
      // 1 ������ � ������� �� ��������, ��� � � �������� ������� Inputs
      // ������������� ������ �������� ������� MRes � "1"
      for I := 0 to MinIndexes.ElemCount - 1 do
      begin
        Ind := MinIndexes.VecElemI[I]; // ����� �������

        // �������� ���� ������� �� W2
        for J := 0 to W2.Rows - 1 do
          MRes.ElemI[J, I] := W2.ElemI[J, Ind];
      end;

      Outputs.MoveFrom(MRes); // ���������� � ������� Outputs � ����� �����
    finally
      MRes.FreeMatrix;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Simulate'){$ENDIF}
  end;
end;

procedure TNNetLVQ.Train;
var
  W1, W2, Xh, MOut, TrainErrors, QuantErrors: TMatrix;
  N, VecCnt, CurrentEpoch, h, I, Index1, Index2, Xout: Integer;
  betta, e, etta, CurrentError, Eq: Double;
  Stop, FallIntoWindow, W1IsTrue, W2IsTrue, CanRepulsion: Boolean;
  Stat: TRecordMatrix;
  BegTrainTime: TDateTime;
  TmpValue: Extended;
  PenaltyThreshold: Integer;

  procedure CalcLVQErrorAndPerfomance(W1, W2, X, T: TMatrix; var Eq, Perf: Double);
  var
    d, MinVal, MinIdx, W2Vec: TMatrix;
    h, i, NetOut, p, p1, WinNum: Integer;
  begin
    Eq := 0;

    // ���������� ���-�� ������������� �������� � X
    p := X.Cols;

    // ��������. � ������ ������ ������������� ����� �����������
    p1 := p;

    d := TDoubleMatrix.Create();
    try
      MinVal := TDoubleMatrix.Create(d);
      MinIdx := TIntegerMatrix.Create(d);
      W2Vec := TIntegerMatrix.Create(d);

      W2Vec.Resize([W2.Rows]);

      //��������� ��������� ���������� ����� W1 � ��������� � X
      CalcDist(W1, X, d);

      // ���������� ����������� ��������� ���������� � ������ ��������-�����������
      d.GetMinMaxMean(d.DimRows, MinVal, nil, nil, nil, MinIdx);

      for h := 0 to p - 1 do
      begin

        // ���������� ����� ������� - ����������
        WinNum := MinIdx.VecElemI[h];

        // �������� ������� WinNum �� ������� W2
        for i := 0 to W2Vec.ElemCount - 1 do
          W2Vec.VecElemI[i] := W2.ElemI[i, WinNum];

        // ���������� �����, � �������� ��������� ������-����������
        W2Vec.GetMinMaxValues(nil, nil, nil, @NetOut);

        // ���� ��������� �� ��������� �������� ������� T, �� ���������� � Eq
        // ��������� ���������� �� h-�� ������� �� ������� ����������
        if T.ElemI[NetOut, h] = 1 then
          Eq := Eq + MinVal.VecElem[h]
        else // ����� ��������� �� 1 �������� �������� p1
          p1 := p1 - 1
      end;
    finally
      d.FreeMatrix;
    end;

    if p1 < 1 then p1 := 1;
    Eq := Eq / p1;
    Perf := 1 - p1 / p;
  end;

  procedure CalcCurrentError;
  begin
    CalcLVQErrorAndPerfomance(W1, W2, TrainInput, TrainTarget, Eq, CurrentError);
  end;

  procedure PrepareStatArrays;
  begin
    Stat.Fields['CorFull'].Resize([Epochs, W1.Rows]);
    Stat.Fields['CorFull'].Zeros;

    Stat.Fields['CorFullAll'].Resize([1, W1.Rows]);
    Stat.Fields['CorFullAll'].Zeros;

    Stat.Fields['Cor'].Resize([Epochs, W1.Rows]);
    Stat.Fields['Cor'].Zeros;

    Stat.Fields['CorAll'].Resize([1, W1.Rows]);
    Stat.Fields['CorAll'].Zeros;

    Stat.Fields['Rep'].Resize([Epochs, W1.Rows]);
    Stat.Fields['Rep'].Zeros;

    Stat.Fields['RepAll'].Resize([1, W1.Rows]);
    Stat.Fields['RepAll'].Zeros;

    Stat.Fields['WinTrue'].Resize([Epochs, W1.Rows]);
    Stat.Fields['WinTrue'].Zeros;

    Stat.Fields['WinFalse'].Resize([Epochs, W1.Rows]);
    Stat.Fields['WinFalse'].Zeros;

    Stat.Fields['WinTrueAll'].Resize([1, W1.Rows]);
    Stat.Fields['WinTrueAll'].Zeros;

  end;

  // IsCorrection = True | False (��������� | ������������)
  // IsFull = True | False (������ | ���������)
  procedure WriteToStatArrays(IsCorrection, IsFull: Boolean; Index, CurrEpoch: Integer);
  var
    S1, S2: string;
    M: TMatrix;
  begin
    if IsCorrection then
    begin
      if IsFull then  // ������ ���������
      begin
        S1 := 'CorFull';
        S2 := 'CorFullAll';
      end else
      begin           // ��������� ���������
        S1 := 'Cor';
        S2 := 'CorAll';
      end;
    end else
    begin             // ��������� ������������
      S1 := 'Rep';
      S2 := 'RepAll';
    end;

    M := Stat.Fields[S1];
    M.ElemI[CurrEpoch, Index] := M.ElemI[CurrEpoch, Index] + 1;

    M := Stat.Fields[S2];
    M.ElemI[0, Index] := M.ElemI[0, Index] + 1;
  end;

  procedure SaveWinNeuronInfo(Value: Boolean; Index: Integer);
    function GetStatTrueFalseMatrix(Value: Boolean): TMatrix;
    begin
      if Value then
        Result := Stat.Fields['WinTrue']
      else
        Result := Stat.Fields['WinFalse'];
    end;
  var
    M: TMatrix;
  begin
    M := GetStatTrueFalseMatrix(Value);
    M.ElemI[CurrentEpoch - 1, Index] := M.ElemI[CurrentEpoch - 1, Index] + 1;

    if Value then // ���� ������ ������� "���������"
    begin         // ��������� ����� ���������� �����
      M := Stat.Fields['WinTrueAll'];
      M.ElemI[0, Index] := M.ElemI[0, Index] + 1;
    end;
  end;

  // ���������� 2 ������� �� W1, �������� ������� � Xh. ���������� �� �������
  // Index1 � Index2. ���������� �� �������������� � ���������� ������� W1IsTrue � W2IsTrue
  // ���������� Result - ��������� ��������� � �������� ���� "e"
  function FindClosestNeuronsAndClasses(W1, W2, MOut, Xh: TMatrix; e: Double;
    CurrentEpoch, VecCnt: Integer; var Index1, Index2: Integer;
    var W1IsTrue, W2IsTrue: Boolean): Boolean;
  var
    I: Integer;
    Dm, WinTrueAll: TMatrix;
    Dm1, Dm2, WinMin: Extended;
  begin
    Dm := TDoubleMatrix.Create(Xh);
    try
      // ����������� ���������� ����� Xh � ������ �������� �� W1
      // � ���������� ��������� ������ Dm � ������ ��������� = W1Cnt
      CalcDist(W1, Xh, Dm);

      // ������������ ������ ������ � ������������ � ����������� ����� �������� � �������
      // ������� "����������" ������, ���� �� ������� ����� ���������
      WinTrueAll := Stat.Fields['WinTrueAll'];

      // ���������� ������ � ����������� ����������� �����
      WinTrueAll.GetMinMaxValues(@WinMin, nil);

      // �������� �������, ����� ����� ������� ����������� ��������� ����������
      // ����� ������ "��������" �������. ����� ������� ���� ���� "�������" ��������.
      // ����������� ����� ����������� PenaltyThreshold. ���� �������� ������� ���������,
      // �� ������� ����� ���������� ��-�������, � ������ �������� �� �����.
      // ���� �������� ������� �������, �� ������� �� ����������� ����� � �� ����.
      for I := 0 to Dm.ElemCount - 1 do
        if WinTrueAll.VecElem[I] > (WinMin + Dm.ElemCount * PenaltyThreshold) then
          Dm.VecElem[I] := Dm.VecElem[I] * Max(WinTrueAll.VecElem[I], 1);


      // ���������� 2 ����������� �������� � Dm � �� �������
      Dm.GetMinMaxValues(@Dm1, nil, @Index1, nil);

      // ������������� ���������� �������� �������� ������� ��������
      Dm.VecElem[Index1] := 10000000;

      Dm.GetMinMaxValues(@Dm2, nil, @Index2, nil);

      // ������� ���� ��������� �������� ����������!


      // ���������, ������ �� ��������� ���� � ���������� �����
      // - ��������� ��� Index1. ���������� ����� ������ ��� ��������
      // ���������� ������� (�.�. ����� ������ � TrainTarget � ��������� = "1")
      MOut.GetMinMaxValues(nil, nil, nil, @XOut);
      // ������ ��� ��������, � ����� ������ ������� W2 ������ ���� "1"
      // ���� ��� ������������� "1", ������ ������ �� W1 ������
      // � ���������� �����.
      W1IsTrue := W2.ElemI[Xout, Index1] = 1;

      // ��������� ���������� � ������ ������� �������
      SaveWinNeuronInfo(W1IsTrue, Index1);


      // ��������� �� �� ����� ��� Index2
      W2IsTrue := W2.ElemI[Xout, Index2] = 1;

      // ��������� ���������� � ������ ������� �������
      SaveWinNeuronInfo(W2IsTrue, Index2);



      if CurrentEpoch = 1 then // ��� ������ ����� ������� ���� �� �����
        Result := True
      else
      begin
        // ��� ����������� ���� ��������� ������� ������ ��������� � ������ �������

        //Result := W1IsTrue <> W2IsTrue;

        // ��������! ������ ������� �� �������� �������� ��������!???????????
        // ������ �������� ������� �������� ���� ���� "�������", �� ����� ����������
        // ���-����� ��������������.


        // ������������� ��������� ��������� � �������� ����

        // ��������� Dm1 � Dm2 ��������� � �������� ���������, �� �������������
        // �� ��������� ����.
        if SameValue(Dm1, 0) then
          Dm1 := 0.0000000001;
        if SameValue(Dm2, 0) then
          Dm2 := 0.0000000001;

        //if W1IsTrue <> W2IsTrue

        // ���������, ����������� �� �������
        Result := min(Dm1 / Dm2, Dm2 / Dm1) > ((1 - e) / (1 + e));
                                               // 0.6666666666     //0.53?
        // ������� �������: ������� �����������, ���� ������� ����� Dm1 � Dm2
        // ������������ (����� ��� � 2 ����)
        // ������� �� ������ �� �������� ��������, ������ ��� ������ ������ ��
        // �������� �������� (� 10-�� � 100-�� ���).

      end;
    finally
      Dm.FreeMatrix;
    end;
  end;

  procedure DoAttraction(W1, Xh: TMatrix; N, Index, CurrentEpoch: Integer; etta: Double; IsFull: Boolean);
  var
    I: Integer;
    TmpValue: Extended;
  begin
    for I := 0 to N - 1 do
    begin
      TmpValue := W1.Elem[Index, I];
      // ���� ���������� ������ - ��������� �� ������ ��������� ���������
      if IsFull then // ������ ������ ���������
        W1.Elem[Index, I] := TmpValue + etta * (Xh.VecElem[I] - TmpValue)
      else // ����� ������ ��������� ���������
        W1.Elem[Index, I] := TmpValue + etta * (Xh.VecElem[I] - TmpValue) * 0.1
    end;

    // ��������� �������������� ������ ���������
    WriteToStatArrays(True, IsFull, Index, CurrentEpoch - 1);
  end;

  procedure DoRepulsion(W1, Xh: TMatrix; N, Index, CurrentEpoch: Integer; etta: Double);
  var
    I: Integer;
    TmpValue: Extended;
  begin
    for I := 0 to N - 1 do
    begin
      TmpValue := W1.Elem[Index, I];

      // ������ ������� "������������" �� ������������� ������� ��������,
      // ������ ��� ����� ������� ���������� - �������������
      W1.Elem[Index, I] := TmpValue - etta * (Xh.VecElem[I] + TmpValue) * 0.2;
    end;

    // ��������� �������������� ������ ������������
    WriteToStatArrays(False, True, Index, CurrentEpoch - 1);
  end;

begin
  try
    Stop := False;

    // ���������� ����� ������ ��������
    BegTrainTime := Now;

    Fields['Trained'].Value := 0;

    TrainErrors := TDoubleMatrix.Create();
    Fields['TrainErrors'] := TrainErrors; // ������ ��������

    QuantErrors := TDoubleMatrix.Create();
    Fields['QuantErrors'] := QuantErrors; // ������ �����������

    // ���������� ����� �����������
    PenaltyThreshold := Fields['TrainDataInfo'].Fields['PenaltyThreshold'].ValueI;

    // ���� �������� �������� ����
    // W1.Cols = ����� ������ ������� �������
    // W1.Rows = ����� �������� �������� ����
    W1 := Layers[0].Fields['W'];

    // ���� �������� ��������� ����
    W2 := Layers[1].Fields['W'];

    // ������ �������������� ������
    Stat := TRecordMatrix(Layers[0].Fields['Stat']);

    // �������������� �������������� ������� ��� �������� �������� ����
    PrepareStatArrays;

    // ��������� ������������ �������, ���������� �� 0 �� 1 �� ���� ��������
    // �� ������ ����� ������������� �� �������� = 1/epochs
    betta := 0;

    // ���������, ���������� �� ��������� �� 0.2 �� 0.3
    e := 0.2;

    // ��������� ��������� �������, ���������� �� 1 �� 0.2 �� ���� ��������
    // �� ������ ����� ����������� �� �������� = (1 - 0.2)/epochs
    etta := 1;

    // ����� ������ ��
    N := TrainInput.Rows;

    // ���������, ��������� �� ����� ��������� ����� ������
    if (N <> W1.Cols) or (W2.Rows <> TrainTarget.Rows) then
      raise EMatrixBadParams.Create(matSLVQWrongTrainDataSize);

    // ���-�� ��������� ��������
    VecCnt := TrainInput.Cols;

    // ����������� ���� ����� ���� �������� ���������� ��������
    // W1(:,:) = 1 / sqrt(N); - �� �����! ��� ���� ������� ��� �������� ��� LVQ

    CurrentEpoch := 0;


    Xh := TDoubleMatrix.Create(); // ����� ������� ������� ������-�������
    try
      Xh.Resize([N, 1]);

      MOut := TDoubleMatrix.Create(Xh); // ������. ������ h-� ������� ������� TrainTarget

      MOut.Resize([TrainTarget.Rows, 1]);

      TrainErrors.Resize([Epochs]); // ������ ������ ��������
      TrainErrors.Zeros;

      QuantErrors.Resize([Epochs]); // ������ ������ �����������
      QuantErrors.Zeros;

      CalcCurrentError; // ��������� ������ ��������

      // ������������ ����� ������� OnProgress - �������� � ������ ��������
      if Assigned(OnProgress) then
        OnProgress(Self, Goal, CurrentError, Eq, Epochs, 0, Stop);

      // ��������� ���������� ��������� �������� �� ���������� ������������
      // ��� ���������� ��������, ������� �� ����� ������������ ������� ����������
      if Stop then Exit;

      // ���� �� ������. ����� �������� = Epochs
      while CurrentEpoch < Epochs do
      begin
        Inc(CurrentEpoch);

        betta := betta + 1/epochs;

        // �������� ��������� ������ Xh �� ��������� �������
        for h := 0 to VecCnt - 1 do
        begin
          // �������� �������� ���������� ���������� ������� � Xh ������������ �
          // ��������������� ��������� �������� ������ ��������� ����������
          // Convex Combination
          for I := 0 to N - 1 do
          begin
            TmpValue := TrainInput.Elem[I, h];
            Xh.VecElem[I] := betta * TmpValue + (1 - betta) / sqrt(N);
          end;

          // ���������� ��������������� h-� ������� ������
          for I := 0 to TrainTarget.Rows - 1 do
            MOut.VecElem[I] := TrainTarget.Elem[I, h];

          // ������������ �� ������ ����� �����������
          CanRepulsion := CurrentEpoch > 1;

          // ���������� ������� �������� ������� �������� � �� ��������������
          // � ��������������� �������
          FallIntoWindow := FindClosestNeuronsAndClasses(
            W1, W2, MOut, Xh, e, CurrentEpoch, VecCnt, // ������� ���������
            Index1, Index2, W1IsTrue, W2IsTrue);       // �������� ���������

          // ���� �������� � �������� ����...
          if FallIntoWindow then
          begin

            // ���� ������ � ��������� �����, �� ��������� ������ ���������
            if W1IsTrue then
            begin
              DoAttraction(W1, Xh, N, Index1, CurrentEpoch, etta, True);
            end else // ����� ��������� ������������ (Repulsion)
            begin
              if CanRepulsion then // �� ��������� ���������� �� ������ �����
              begin
                DoRepulsion(W1, Xh, N, Index2, CurrentEpoch, etta);
              end;
            end;

            // ���� ������ � ��������� �����, �� ��������� ��������� (������ ��� ���������)
            if W2IsTrue then
            begin
              DoAttraction(W1, Xh, N, Index2, CurrentEpoch, etta, not W1IsTrue);
            end else
            begin // ����� ��������� ������������ (Repulsion)
              if CanRepulsion then
              begin
                DoRepulsion(W1, Xh, N, Index2, CurrentEpoch, etta);
              end;
            end;
          end; // if FallIntoWindow
        end; // for h := 1 to VecCnt do

        // ��� ��������� ������� ���������. ��������� ����� �������� ���������
        // ������ ����� ��������� ����������� ��������


        // ����������� ������ �������� (������ �����������)
        // � ���������� ������ - ����������� ���������� ������� ��������, �������
        // ���� ���������������� � �������.
        CalcCurrentError;

        // ���������� ������� ������ ��������
        TrainErrors.VecElem[CurrentEpoch - 1] := CurrentError;

        // ���������� ������� ������ �����������
        QuantErrors.VecElem[CurrentEpoch - 1] := Eq;

        // ������������� ���������� etta
        etta := etta - (1 - 0.2) / epochs;

        if Assigned(OnProgress) then
          OnProgress(Self, Goal, CurrentError, Eq, Epochs, CurrentEpoch, Stop);

        if Stop then Exit;
      end; // for CurrentEpoch

      // ��������, ��� �� ��������� �������
      Fields['Trained'].Value := 1;

      with TCharMatrix.Create() do
      begin
        AsString := DateTimeToStr(Now);
        ThisNetwork.Fields['EndTrainTime'] := ThisMatrix;
      end;

      with TIntegerMatrix.Create() do
      begin
        Value := SecondsBetween(Now, BegTrainTime);
        ThisNetwork.Fields['TrainSecondCount'] := ThisMatrix;
      end;

      with TDoubleMatrix.Create() do
      begin
        Value := CurrentError;
        ThisNetwork.Fields['TrainError'] := ThisMatrix;
      end;

      with TDoubleMatrix.Create() do
      begin
        Value := Eq;
        ThisNetwork.Fields['QuantError'] := ThisMatrix;
      end;


    finally
      try
        CalcCurrentError;
        if Assigned(OnProgress) then
          OnProgress(Self, Goal, CurrentError, Eq, Epochs, CurrentEpoch, Stop);
      finally
        // ���������� Xh � ��� ��������� �������
        Xh.FreeMatrix;
      end;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}ReCreateExceptObject(E, 'Train'){$ENDIF}
  end;
end;

end.
