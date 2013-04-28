{$Include MatrixCommon.inc}

unit matrixProcessSignal;

interface

uses
  Windows, Messages, Classes, SysUtils, Math, Matrix32;


type
  TDim2 = (dimRows, dimCols);

{ Fast3PointInterp()
 ������� 3-�������� (��������������) ������������ � �������
 ���������������� ��������� �������.
  Values - �������� ��������
  OldSteps - �������� ��������� �, ��������������� ��������� Values
  NewSteps - �����, � ������� ����� ��������� ������������ ��������
  AResult - ����� (������������) �������� � ������ NewSteps
  Faster - ��������� ����������� �������� ����������, ���� ����� NewSteps ��������
    ����������. ������������ ��� ������ ������� ��������������� StretchRows() 

 ������ ������ ��� ���������� ���������� ���������������� �������� ����������
 ��������� ��������:

 P(E) = Y0 + (Y1 - Y0) * E + (Y2 - 2 * Y1 + Y0) / 2 * E * (E - 1), ��� �
 ������������� �� �������
 E = (X - X0) / (X1 - X0)

 ������� ������������ ������ � ��������� ����� ������������}
procedure Fast3PointInterp(Values, OldSteps, NewSteps, AResult: TMatrix; Faster: Boolean = False);

{������������ ��������� ����� ����� ������� AMatrix � ������������ � NewLength.
 ��� �������� ����������� ����������� �������������� ������������.
 ������� ������������ ������ � ��������� ����� ������������}
procedure StretchRows(AMatrix, AResult: TMatrix; NewLength: Integer);

implementation

const
  SigNames: array[1..12] of string = (
    'I', 'II', 'III', 'aVR', 'aVL', 'aVF', 'V1', 'V2', 'V3', 'V4', 'V5', 'V6');

procedure Fast3PointInterp(Values, OldSteps, NewSteps, AResult: TMatrix; Faster: Boolean);
var
  TempMatrix, ValuesRef: TMatrix;
  ColNum, I, J, K: Integer;
  OldDimValues: TDynIntArray;
  Tmp: Extended;
const
  SFuncName = 'procedure Fast3PointInterp';

  function CalcElem(X0, X1, Y0, Y1, Y2, X: Double): Double;
  var E: Real;
  begin
    E := (X - X0) / (X1 - X0);
    if (E < 0) or (E > 2) then
      raise MatrixCreateExceptObj(EMatrixError, 'CalcElem Error', 'function CalcElem');
    Result := Y0 + (Y1 - Y0) * E + (Y2 - 2 * Y1 + Y0) / 2 * E * (E - 1);
  end;
begin
  try

    if not IsSameMatrixTypes([Values, OldSteps, NewSteps, AResult], [mtNumeric]) then
      raise EMatrixWrongElemType.Create(matSNotNumericType);

    if (OldSteps.Rows > 1) or (Values.Cols <> OldSteps.Cols) or (OldSteps.Rows > 1) then
      raise EMatrixDimensionsError.Create(matSArraysNotAgree);

    if Values.ElemCount = 0 then
      raise EMatrixError.Create(matSArrayIsEmpty);

    // ������� ������ �� �������� ������. ��� ����� ����� �������������
    // �������� ������ � �������. ������ �� ������� ����� ������ ���
    // �������� Values. ����� �� ������������ � ������������� ����������.
    ValuesRef := Values.CreateReference;

    // ������� ��������� ������
    TempMatrix := AResult.CreateInstance;  

    try

      // ���������� ������� �������
      SetLength(OldDimValues, 0);
      OldDimValues := Values.GetDimensions;

      // �������� ������ ����� ���� �����������. ���������� ��� � �������
      ValuesRef.Reshape(ValuesRef.CalcMatrixDimensions);

      // ������������� ��������� ������� �������
      TempMatrix.Resize([ValuesRef.Rows, NewSteps.Cols]);

      // ���������� ����� ��-�
      ColNum := OldSteps.Cols;


      for I := NewSteps.Cols - 1 downto 0 do
      begin
        // ���������� ��������� �����
        Tmp := NewSteps.VecElem[I];

        // ���� ����� � ������� �������� ��������
        for J := ColNum - 1 downto 0 do
        begin
          if Tmp >= OldSteps.VecElem[J] then
          begin
            for K := 0 to ValuesRef.Rows - 1 do
            begin
              if J = OldSteps.Cols - 1 then
                TempMatrix.Elem[K, I] := ValuesRef.Elem[K, J]
              else if J = OldSteps.Cols - 2 then
                TempMatrix.Elem[K, I] :=
                  CalcElem(
                    OldSteps.VecElem[OldSteps.Cols - 3],
                    OldSteps.VecElem[OldSteps.Cols - 2],
                    ValuesRef.Elem[K, OldSteps.Cols - 3],
                    ValuesRef.Elem[K, OldSteps.Cols - 2],
                    ValuesRef.Elem[K, OldSteps.Cols - 1],
                    NewSteps.VecElem[I])
              else
                TempMatrix.Elem[K, I] :=
                  CalcElem(
                    OldSteps.VecElem[J],
                    OldSteps.VecElem[J + 1],
                    ValuesRef.Elem[K, J],
                    ValuesRef.Elem[K, J + 1],
                    ValuesRef.Elem[K, J + 2],
                    NewSteps.VecElem[I]);
            end;
            if Faster then
              ColNum := J + 1;
            Break;
          end;
        end;

      end; // for I

      // ������������� ��� ������� TempMatrix ���������� �������
      OldDimValues[Length(OldDimValues) - 1] := TempMatrix.Cols;
      TempMatrix.Reshape(OldDimValues);

      // ���������� �������� � AResult
      AResult.MoveFrom(TempMatrix);
    finally
      TempMatrix.Free;
      ValuesRef.Free;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, SFuncName){$ENDIF}
  end;
end;

procedure DoIncRows(AMatrix, AResult: TMatrix; NewLength: Integer);
var
  TempMatrix, OldSteps, NewSteps: TMatrix;
begin

  TempMatrix := AResult.CreateInstance;

  // ������� ������� ��������
  OldSteps := TIntegerMatrix.Create;
  NewSteps := TSingleMatrix.Create;

  try
    OldSteps.Resize([AMatrix.Cols]);
    OldSteps.FillByOrder;

    NewSteps.Resize([NewLength]);
    NewSteps.FillByStep2(0, AMatrix.Cols - 1);

    Fast3PointInterp(AMatrix, OldSteps, NewSteps, TempMatrix, True);

    AResult.MoveFrom(TempMatrix);

  finally
    TempMatrix.Free;
    OldSteps.Free;
    NewSteps.Free;
  end;
end;

procedure DoDecRows(AMatrix, AResult: TMatrix; NewLength: Integer);
var
  TempMatrix, TempMatrix2, MatrixRef: TMatrix;
  Interval, Num, I, J, Column: Integer;
  OldDimValues: TDynIntArray;
begin

  MatrixRef := AMatrix.CreateReference;
  TempMatrix := AResult.CreateInstance;
  TempMatrix2 := AResult.CreateInstance;

  try

    Interval := AMatrix.Cols div (NewLength - 1) + 1;
    Num := Interval * (NewLength - 1) + 1;

    // ���������� ������� AMatrix
    OldDimValues := AMatrix.GetDimensions;


    // ������ MatrixRef 2-������ ��������
    MatrixRef.Reshape(MatrixRef.CalcMatrixDimensions);

    DoIncRows(MatrixRef, TempMatrix2, Num);

    TempMatrix.Resize([MatrixRef.Rows, NewLength]);

    Column := -1;
    for J := 1 to Num do
    begin
      if (J mod Interval) <> 1 then Continue;
      Inc(Column);
      for I := 0 to MatrixRef.Rows - 1 do
        TempMatrix.Elem[I, Column] := TempMatrix2.Elem[I, J - 1];
    end;

    // ������������ ������� TempMatrix
    OldDimValues[Length(OldDimValues) - 1] := NewLength;
    TempMatrix.Reshape(OldDimValues); 

    AResult.MoveFrom(TempMatrix);

  finally
    TempMatrix.Free;
    TempMatrix2.Free;
    MatrixRef.Free;
  end;
end;

procedure StretchRows(AMatrix, AResult: TMatrix; NewLength: Integer);
const
  SFuncName = 'procedure StretchRows';
resourcestring  
  SMustBeLessOne = '�������� ����� ������� ������ ���� ������ �������!';
begin
  try
    if NewLength < 2 then
      RaiseMatrixError(EMatrixBadParams, SMustBeLessOne);

    if NewLength > AMatrix.Cols then
    begin
      DoIncRows(AMatrix, AResult, NewLength);
    end else if NewLength < AMatrix.Cols then
      DoDecRows(AMatrix, AResult, NewLength)
    else
      AResult.CopyFrom(AMatrix);

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, SFuncName){$ENDIF}
  end;
end;

end.
