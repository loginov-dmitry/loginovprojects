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
{ ������ matrixNNet - ������� ������� ��� ������ � ���������� ������ (���)    }
{ (c) 2005 - 2009 ������� ������� ���������                                   }
{ ��������� ����������: 11.06.2009                                            }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{$Include MatrixCommon.inc}
 
unit matrixNNet;

interface

uses
  SysUtils, Classes, Matrix32;

type
  {����������� �����, �� �������� ����������� ������ ������������ ���������}
  TNeuronNetwork = class;

  {���������� �������, ������� ������������ ���������� � �������� ��������
   ��������� ����. ANetwork - ��������� ����. Goal - ��������� ��������,
   ������� ��� �������� ���� ���������� �������. PerfError - ������� ��������
   ������ �������� ����. NetError - ������ ����, ����������� �� ������ ��������
   Epochs - ������������ ���������� ���� ��������.
   CurrentEpoch - ����� ������� ����� �������� (���������� � 1).
   ���� �� ������ ������������ ������ ������� ��� ������, �� �� ��������
   �������� � �������� ������� ��������� ����� 4-������� �������� (��������,
   Pointer), ������ ��� �� ���������� ���������� ������� �������}
  TTrainingProgressFunc = procedure(ANetwork: TNeuronNetwork;
    const Goal, PerfError, NetError: Extended; Epochs, CurrentEpoch: Integer; var Stop: Boolean) of object;

  EMatrixNetworkError = EMatrixError;

  {��������� ����, ���������� �� ������ Matrix32. �������� ����������� ��������
   TMatrix, ������������ ��� ����������� ������ TRecordMatrix. ��������� ���
   ������ ��������� ���� �������� � �������� TMatrix. ��� ������� ��������� ���,
   ������ ������������ ����������� ������ � �������� � �������. ��������� �����
   �� ������ ��������� ��� ��� � ���� ��� �����, � � ������ ������ ��������� ��.
   TNeuronNetwork - ����������� �����. �� ������ ������������ ��� ���������.}
  TNeuronNetwork = class(TRecordMatrix) // abstract!!!
  private
    {��������� ������ �������� ��������� ����:
     Layers: TCellMatrix - ���������� �� ������� ����. ������ ������ ��� ������
           TRecordMatrix. �������� � ����:
             W: TDoubleMatrix - ������ ����� �������� ������� ����
     Trained: TByteMatrix - 1 ���� ���� �������, 0 - ���� �� �������
     Epochs: ������������ ���������� ���� ��������
     Goal: ���� ��������. ����������� �����������, ��� ���������� �������
           ���� ������������� ���� ��������
     TrainInput: TDoubleMatrix - ��������� ������� ����� ������. ������ ������� -
           ��� ���� ��������� ������. ����� ����� - ��� ����� ������ � ���
     TrainTarget: TDoubleMatrix - ��������� ������� ����� ������. ����� �������� � TrainTarget
           ����� ����� �������� � TrainInput. ����� ����� � TrainTarget �����
           ����� ������� ���}

    {��������� ������ �����, ������ ������� �������� �������� ������� ��
     ������ TRecordMatrix, � ������� �������� ��� ����������� ���������� ��
     ���������������� ����. ��� ������� � ������ ���� ������������ ���������
     ������: Layers[Index]}
    FLayers: TCellMatrix;

    FOnProgress: TTrainingProgressFunc;

    function GetIsTrained: Boolean;
    function GetLayersCount: Integer;
    procedure SetLayersCount(const Value: Integer);
    function GetLayers(Index: Integer): TRecordMatrix;
    function GetEpochs: Integer;
    procedure SetEpochs(const Value: Integer);
    function GetGoal: Extended;
    procedure SetGoal(const Value: Extended);
    function GetTrainInput: TMatrix;
    function GetTrainTarget: TMatrix;
  protected
    {��������� ������������� �������. ��� ����������� ������ ������������}
    procedure Init; override;

    {������� �������� ������� � ��������� TMatrix. ���������� �� Init}
    procedure InitNetworkData; virtual;
  public
    {�� ����������� ������� GetAlias, ��� ����, ����� ������������ �� ����
     ������� ������ ������������ ������ TNeuronNetwork}
    //class function GetAlias: TSignature; override;

    {��������� �������� ��������� ����. � �������� ������ ����� ������ �������������
     � ���������� override}
    procedure Train; virtual;

    {������������ ������ ��������� ��������� ����. �� ���� �������� ������ Inputs.
     ��������� ������ ��� ����� ������� � ������ Outputs. � �������� ������ �����
     ������ ������������� � ���������� override.
     ������� Inputs ����� ��������� ��������� ��������. ������� �� ��������
     ����� � ������� Outputs}
    procedure Simulate(Inputs, Outputs: TMatrix); virtual;

    {������ � ������ ���������� ���� ���}
    property Layers[Index: Integer]: TRecordMatrix read GetLayers;

    {������������ ���������� ���� ��������}
    property Epochs: Integer read GetEpochs write SetEpochs;

    {���� (����������� ������) ��������}
    property Goal: Extended read GetGoal write SetGoal;

    {��������� ������� ����� ������}
    property TrainInput: TMatrix read GetTrainInput;

    {��������� ������� ����� ������}
    property TrainTarget: TMatrix read GetTrainTarget;

    {������ ����� ���}
    property LayersArray: TCellMatrix read FLayers;

    {� ������� ����� �������� ����� ������ ��� �������� ����� ����� � ���.
     ����� ��� �� ��������� � ����� ���! }
    property LayersCount: Integer read GetLayersCount write SetLayersCount;

    {����������, ������� �� ��� � ����� ������}
    property IsTrained: Boolean read GetIsTrained;

    {���������� Self. ����� ������������ ������ ����� WITH}
    function ThisNetwork: TNeuronNetwork;

    {������� ���������� ������������ � �������� �������� ��� (����� ������ ����� ��������)}
    property OnProgress: TTrainingProgressFunc read FOnProgress write FOnProgress;
  end;

{��������� ��������� ���������� ����� ������ ���������
 W - ����, P - ����� ��, Z - ���������. �������: z = -sqrt(sum((w-p)^2))
 ������ ������ ������� ����� ��������� ���� ������. �������������� �����
 ��������� � ������ ���� ����� ������ �������, � ��� ������ ���������������
 ����� ����� ������� ������������� ������ �. ������ ������� ������� � ����
 ������������� ������� ������. ����� �������� ����� ���� ���������.}
procedure CalcDist(W, P, Z: TMatrix);

{��������� ������������� ��������� ����������}
procedure CalcNegDist(W, P, Z: TMatrix);

{������� ��������� ������������������ ������. ������������� �������
 TPerformFunction. ��������� XMatrix � PPMatrix ������������}
function CalcMSE(EMatrix: TMatrix;
  XMatrix: TMatrix = nil; PPMatrix: TMatrix = nil): Extended;

{perform - �������. � �������� EMatrix ����� ��������� ��� �������� ������,
 ��� � ������ �����. � �������� XMatrix ����� ��������� ��� �������� ������,
 ��� � ��������� ����. ���� � �������� XMatrix ������ ��������� ����, ��
 �������� PPMatrix ������������
 TODO : ������� CalcMSEReg ��� �� �����������}
function CalcMSEReg(EMatrix: TMatrix;
  XMatrix: TMatrix; PPMatrix: TMatrix = nil): Extended;

{������������ ������. ������������ ������ ������������.}
procedure CalcSoftMax(AMatrix, AResult: TMatrix);

{������������ ������. ��������� � ���� ��������. ���������� �� ������ ��,
 ��� � ��� ���� �������� �� �����}
procedure CalcPurelin(AMatrix, AResult: TMatrix);

{������������ ������. Logarithmic sigmoid transfer function.
 �������: logsig(n) = 1 / (1 + exp(-n))}
procedure CalcLogSig(AMatrix, AResult: TMatrix);

{������������ ������.  Hyperbolic tangent sigmoid transfer function.
 �������: n = 2/(1+exp(-2*n))-1}
procedure CalcTanSig(AMatrix, AResult: TMatrix);

{������������ ������.  ��������� �� �������:
  | 1 ��� Value >= 0
  | 0 ��� Value < 0}
procedure CalcSign(AMatrix, AResult: TMatrix);

const
  {������������ ����� ������ ��}
  MaxInputsCount = 100000;

resourcestring
  matSFuncNotFound = '������� � ������ "%s" �� �������';
  matSWrongInputsCount = '������� �������� ����� ������ ��������� ����';
  matSWrongRangeSize = '������� ����������� �������� ������ �� ����� ������������ �������';


implementation

uses Math;   

procedure CalcDist(W, P, Z: TMatrix);
var
  I, J, K: Integer;
  Buf: Extended;
begin
  try
    if W.Cols <> P.Rows then
      raise Exception.Create(matSArraysNotAgree);

    // �������������� �������� ������ Z, � �������� ����� ����� ������
    // ��������������� ����� �������� (W.Rows), � ����� �������� ������
    // ��������� ���-�� ������� �������� (P.Cols)
    Z.Resize([W.Rows, P.Cols]);

    for I := 0 to W.Rows - 1 do     // ������� ��������
      for K := 0 to P.Cols - 1 do   // ������� ������� ��������
      begin
        Buf := 0;
        for J := 0 to W.Cols - 1 do // ������� ������ ���������������� ����
          Buf := Buf + Sqr(W.Elem[I, J] - P.Elem[J, K]);

        Z.Elem[I, K] := Sqrt(Buf);
      end;    

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcDist'){$ENDIF}
  end;
end;

procedure CalcNegDist(W, P, Z: TMatrix);
begin
  try
    CalcDist(W, P, Z);
    Z.ValueOperation(0, Z, opSub);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcNegDist'){$ENDIF}
  end;
end;

function CalcMSE(EMatrix, XMatrix, PPMatrix: TMatrix): Extended;
var
  I, J: Integer;
  Elements: Integer;
  ACell: TMatrix;
begin
  try
    if not (EMatrix.IsNumeric or EMatrix.IsCell) then
      raise EMatrixWrongElemType.CreateFmt(
        masSIsBadClassForOperation, [EMatrix.ClassName]);

    Result := 0;
    if EMatrix.IsNumeric then
    begin
      for I := 0 to EMatrix.ElemCount - 1 do
        Result := Result + Sqr(EMatrix.VecElem[I]);
      Result := Result / EMatrix.ElemCount;
    end else // IsCell
    begin
      Elements := 0;
      for I := 0 to EMatrix.ElemCount - 1 do
        if EMatrix.VecCells[I] <> nil then
        begin
          ACell := EMatrix.VecCells[I];
          for J := 0 to ACell.ElemCount - 1 do
            Result := Result + Sqr(ACell.VecElem[J]);
          Elements := Elements + ACell.ElemCount;
        end;    
      Result := Result / Elements;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function CalcMSE'){$ENDIF}
  end;
end;

function CalcMSEReg(EMatrix: TMatrix;
  XMatrix: TMatrix; PPMatrix: TMatrix = nil): Extended;
var
  TempPP: TMatrix;
begin
  {� ������� ��� �������� PPMatrix ������� ���������:
   PP - Performance parameter.
     where PP defines one performance parameter,
   PP.ratio - Relative importance of errors vs. weight and bias values.
     and returns the sum of mean squared errors (times PP.ratio) with the
     mean squared weight and bias values (times 1-PP.ratio).}
  try
    Result := 0;
    if XMatrix = nil then
      EMatrixNetworkError.Create(matSBadInputData);

    TempPP := TRecordMatrix.Create();
    try
     { if XMatrix.IsRecord then // ���� ������ ��� ��������� ����
        TempPP.CopyByRef(XMatrix.Fields['performParam'])
      else
        TempPP.CopyByRef(PPMatrix);}
    finally
      TempPP.FreeMatrix;
    end;


  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function CalcMSEReg'){$ENDIF}
  end;
end;


procedure CalcSoftMax(AMatrix, AResult: TMatrix);
var
  Expn, Denom: TMatrix;
  I, J: Integer;
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);
    Expn := TExtendedMatrix.Create();
    Denom := TExtendedMatrix.Create(Expn);
    try
      // ��������� ����������
      Expn.CalcFunction(AMatrix, fncExp);
      // ��������� ������ �������
      Denom.DimOperation(Expn, Expn.DimRows, opSum);

      Denom.ValueOperation(1, Denom, opDiv);

      // ������ ������ ������� Expn ����������� �������� �� Denom
      for I := 0 to Expn.Rows - 1 do
        for J := 0 to Expn.Cols - 1 do
          Expn.Elem[I, J] := Expn.Elem[I, J] * Denom.VecElem[J];

      AResult.MoveFrom(Expn);
    finally
      Expn.FreeMatrix;
    end;     
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcSoftMax'){$ENDIF}
  end;
end;

procedure CalcPurelin(AMatrix, AResult: TMatrix);
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);
    AResult.CopyFrom(AMatrix);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcPurelin'){$ENDIF}
  end;
end;

procedure CalcLogSig(AMatrix, AResult: TMatrix);
var
  TempMatrix: TMatrix;
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);

    TempMatrix := TExtendedMatrix.Create();
    try
      TempMatrix.CalcFunction(AMatrix, fncNeg);
      TempMatrix.CalcFunction(TempMatrix, fncExp);
      TempMatrix.ValueOperation(1, TempMatrix, opSum);
      TempMatrix.ValueOperation(1, TempMatrix, opDiv);

      AResult.MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcLogSig'){$ENDIF}
  end;
end;

procedure CalcTanSig(AMatrix, AResult: TMatrix);
var
  TempMatrix: TMatrix;
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);

    TempMatrix := TExtendedMatrix.Create();
    try
      TempMatrix.ValueOperation(-2, AMatrix, opMul);
      TempMatrix.CalcFunction(TempMatrix, fncExp);
      TempMatrix.ValueOperation(1, TempMatrix, opSum);
      TempMatrix.ValueOperation(2, TempMatrix, opDiv);
      TempMatrix.ValueOperation(TempMatrix, 1, opSub);
      AResult.MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcTanSig'){$ENDIF}
  end;
end;

procedure CalcSign(AMatrix, AResult: TMatrix);
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);
    AResult.CalcFunction(AMatrix, fncSign);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcSign'){$ENDIF}
  end;
end;

{ TNeuronNetwork }

function TNeuronNetwork.ThisNetwork: TNeuronNetwork;
begin
  Result := Self;
end;

function TNeuronNetwork.GetIsTrained: Boolean;
begin
  Result := Fields['Trained'].Value = 1;
end;

function TNeuronNetwork.GetLayers(Index: Integer): TRecordMatrix;
begin
  Result := TRecordMatrix(LayersArray.VecCells[Index]);
end;

function TNeuronNetwork.GetLayersCount: Integer;
begin
  Result := LayersArray.ElemCount;
end;

procedure TNeuronNetwork.Init;
begin
  inherited;
  FMatrixTypes := FMatrixTypes + [mtNetwork];

  InitNetworkData;
end;

procedure TNeuronNetwork.InitNetworkData;
begin
  FLayers := TCellMatrix.Create();
  Fields['Layers'] := FLayers;

  // Trained - ���� �������� ���. 1 - ���� �������. 0 - ���� �� �������
  with TByteMatrix.Create() do
  begin
    ThisNetwork.Fields['Trained'] := ThisMatrix;
    Value := 0;
  end;

  with TIntegerMatrix.Create() do
  begin
    ThisNetwork.Fields['Epochs'] := ThisMatrix;
    Value := 100;
  end;

  with TExtendedMatrix.Create() do
  begin
    ThisNetwork.Fields['Goal'] := ThisMatrix;
    Value := 0;
  end;

  Fields['TrainInput'] := TDoubleMatrix.Create();

  Fields['TrainTarget'] := TDoubleMatrix.Create();
end;

procedure TNeuronNetwork.SetLayersCount(const Value: Integer);
var
  I: Integer;
  Rec: TRecordMatrix;
begin
  // ������������� ��������� ���������� �����
  LayersArray.PreservResize([Value]);

  // �������������� ���� ���
  for I := 0 to LayersArray.ElemCount - 1 do
    if LayersArray.VecCells[I] = nil then
    begin
      Rec := TRecordMatrix.Create();
      LayersArray.VecCells[I] := Rec;

      // ������ ���� ������ ����� ������ ����� W
      Rec.Fields['W'] := TDoubleMatrix.Create();
    end;
end;

function TNeuronNetwork.GetEpochs: Integer;
begin
  Result := Fields['Epochs'].ValueI;
end;

procedure TNeuronNetwork.SetEpochs(const Value: Integer);
begin
  Fields['Epochs'].ValueI := Value;
end;

function TNeuronNetwork.GetGoal: Extended;
begin
  Result := Fields['Goal'].Value;
end;

procedure TNeuronNetwork.SetGoal(const Value: Extended);
begin
  Fields['Goal'].Value := Value;
end;

function TNeuronNetwork.GetTrainInput: TMatrix;
begin
  Result := Fields['TrainInput'];
end;

function TNeuronNetwork.GetTrainTarget: TMatrix;
begin
  Result := Fields['TrainTarget'];
end;

procedure TNeuronNetwork.Train;
begin

end;

procedure TNeuronNetwork.Simulate(Inputs, Outputs: TMatrix);
begin

end;

initialization

finalization

end.
