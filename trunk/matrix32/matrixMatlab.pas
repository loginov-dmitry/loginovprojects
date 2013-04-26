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
{ ������ matrixMatlab - ������ �������������� Matrix32 � ��������             }
{ (c) 2005 - 2007 ������� ������� ���������                                   }
{ ��������� ���������: 05.05.2007                                             }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{$Include MatrixCommon.inc}

unit matrixMatlab;

interface

uses
  Windows, Messages, Matrix32, ComObj, SysUtils, Variants, Classes, Math;

const
  StrSameName = '#SameName#';

type
  {����� ��������� ������, ����������� ��� ������ � ��������. �� �� ������
   ��������� ������� ������� �����. ���������� ������ MatlabDCOM ���������
   � ������ ������������� � ����������� � ������ �����������. ���-�� ��
   � ������ ������������. ������ Matlab (�� ������� ���� ������ 6.0) ��������
   ��������������� ������ � ������ "���� ������ ��� ���� ��������", �.�., ����
   � ������� �������� ������� Matlab ����� ��������������� ����� ���������
   ��������, �� ���������� ������ �� ����������, �.�. ��� ������� ����� ��������
   � ����� ������� ��������, � ������ - � ������ � ���� �� ������� (�������
   ���� ������ �������� ����� ��������� ������, � �������� � ������ ������
   �������� ������ ������)}
  TMatlab = class(TObject)
  private

    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);

    procedure DoPutMatrix(AMatrix: TMatrix; AName: WideString = '');
  public

    {��������� ������ DCOM-������� ������. ��� ������������� �������� ������
     ��������� �������, ��� ��� ��� ��� ����� ��� ����� ������� �������������.
     � ������, ���� ������ ��� ��� ������� �����, � ����� ����� ��� �������,
     ������� �������� ���������� �������}
    procedure StartServer;

    {������������� ������ DCOM-������� MatlabDCOM.}
    procedure StopServer;

    {��������� ��������� Visible ����������� ������� Matlab}
    property Visible: Boolean read GetVisible write SetVisible;

    {������������ ���� ������ ������� Matlab}
    procedure MinimizeCommandWindow;

    {��������������� ��������� ���� ������ ������� Matlab. ���������� ����,
     ���� �� ����� � ���� ���� Visible=True}
    procedure RestoreCommandWindow;

    {���������� True, ���� ������ Matlab �������}
    function IsRunning: Boolean;

    {�������� ������� ������� ACommand. �������� ����� ���� ����� ������ ��� �����
     �����, ������� ����� ������� ��������������� � ���� �������. ������� �
     �������� ���������� ������ ���������� �����, ������� ������ ������ ���
     ������� �� ����������� �������. ���� ��� ��������� ������� � �������
     ��������� ������, �� ��� ������������� DoRaiseException
     ������� ����������� ��������������� ����������.
     !!!��������!!! ���� �� ������� �������, ������� ����� ������� ���������,
     �������, ����� ��� ������� �� ������� � ��������� ���������. �������� ���
     ������� �������� ������� 'a=b', ��� b - ������� ������, ����� �������� ��������
     � ���������. ����� ��������� �� ��������, ������� � ����� ������� ������ ';'}
    function Execute(ACommand: WideString; DoRaiseException: Boolean = True): string;

    function ExecuteFmt(AFmtCommand: string;
      Values: array of const; DoRaiseException: Boolean = True): string;

    {�������� ������ AMatrix � ������� ������� "Base" ������� ��� ������ AName.
     � �������� AMatrix ����� ���� 2-������ ������ �������������� ��� ������
     �����, � ����� ������ ����� � ������ �������.
     ������ �� �����-�� ������� ����������� ����������� �� ����������� �������������
     ������� (�� ����� 2-� ���������). �������� �� � ���� �� ����.
     ������������ �������� � ������ ������ ����� �����.}
    procedure PutMatrix(AMatrix: TMatrix; AName: WideString = '');

    {��������� ������ AName �� ������� ������� Base �������. ���� ����������
     ������� �� ����������, ��� ��� �������� ��������� ������, �� �����
     ������������� ����������. ����������� ������ ����� ���� ������ �������.
     ��������, ������� ������� ����������� � ��������� ��������� ����, � �������
     ����� �������� �����-���� ���������, � �������� ������� � ������ � �������
     ��������� PutMatrix(). ������ ������� � ���������� ������� ����� ������.
     ��� ������������ ������ ������� �� ���� ������� � �������. �� ������ ����
     ������� �� ������������� ������������ ��������}
    function GetMatrix(MatlabObjectName: string; MatrixObjectName: string = StrSameName): TMatrix;

    {���������� True, ���� � ������� ������� Base ���� ������ � ������ MatrixName.
     ���� ������ ��������� ��� (a.b.c), �� ������ False}
    function Exists(MatrixName: TMatrixName): Boolean;

    {���������� ����� ���������� ������� � ��������� �������}
    function MatrixClass(MatrixName: TMatrixName): string;

    {��������� ������� �������, ����������� ������� �������� ������ ��� �����,
     ����������� �� ����� ������. ������� ������� �� ����������
     ��������� ������� �������� � �������� ������}
    function SimpleCommand(ACommand: string): string;
    
    function SimpleCommandFmt(AFmtCommand: string; Values: array of const): string;

    {���������� ������ ����� ��������� StructName}
    procedure GetFieldNames(StructName: string; AList: TStrings);
  end;

var

  {����� ���� ������ �� ������ �������� � ��������. �� ��������� ������� ���
   ��������� ������ ������� - �� � ���� �������� ��� �� ��������.}
  Matlab: TMatlab;

resourcestring
  SCellDimensionMoreThen2 = '����������� ������� ����� �� ������ ��������� 3.';
  SMatlabObjectNameIsEmpty = '������������ ������� �� Matlab �� �������';

implementation

var
  MatlabDCOM: OleVariant;

const
  TempMatrixName = 'MATRIX__TEMP';

{ TMatlab }

function TMatlab.Execute(ACommand: WideString; DoRaiseException: Boolean = True): string;
var
  I, J: Integer;
  S: string;
begin
  try

    StartServer;

    Result := MatlabDCOM.Execute(ACommand);

    {� ������� � �������� ����������� ����� ������������ ������ #10
     � �� Windows ����������� ����� ������. �������� ����������� ����� �
     ����������� �� ��.}
    if sLineBreak <> #10 then
      Result := FastStringReplace(Result, #10, sLineBreak);

    if DoRaiseException then
    begin
      with TStringList.Create do
      try
        Text := Result;
        for I := 0 to Count - 1 do
          if Pos('??? ', Strings[I]) = 1 then
          begin
            for J := I to Count - 1 do
              S := S + Strings[J] + sLineBreak;

            raise EMatrixMatlabError.CreateFmt('Matlab message:%s"%s"%sOriginal Command:%s"%s"',
              [sLineBreak, Trim(S), sLineBreak, sLineBreak, Trim(ACommand)]);
          end;
            
      finally
        Free;
      end;
    end; // if DoRaiseException then

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function TMatlab.Execute'){$ENDIF}
  end;
end;

function TMatlab.ExecuteFmt(AFmtCommand: string;
  Values: array of const; DoRaiseException: Boolean = True): string;
begin
  try
    Result := Execute(Format(AFmtCommand, Values), DoRaiseException);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function TMatlab.ExecuteFmt'){$ENDIF}
  end;
end;

function TMatlab.Exists(MatrixName: TMatrixName): Boolean;
begin
  try
    Result := SimpleCommandFmt('exist ''%s''', [MatrixName]) = '1';
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function TMatlab.Exists'){$ENDIF}
  end;   
end;

procedure TMatlab.GetFieldNames(StructName: string; AList: TStrings);
var
  I: Integer;
begin
  try
    AList.Clear;

    AList.Text := ExecuteFmt('fieldnames(%s)', [StructName]);
    for I := AList.Count - 1 downto 0 do
    begin
      AList.Strings[I] := Trim(AList.Strings[I]);
      if (Length(AList.Strings[I]) > 2) and (AList.Strings[I][1] = '''') then
        AList.Strings[I] := Copy(AList.Strings[I], 2, Length(AList.Strings[I]) - 2)
      else
        AList.Delete(I);
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(
        E, 'procedure TMatlab.GetFieldNames'){$ENDIF}
  end;
end;

function TMatlab.GetMatrix(MatlabObjectName: string; MatrixObjectName: string = StrSameName): TMatrix;
var
  I, J, K, ARows, ALayers: Integer;
  AList: TStringList;
  S, SClass: string;
  MClass: TMatrixClass;
  DimValues, VDimValues: TDynIntArray;
  RealArray, ImagArray: OleVariant;
  TempMatrix: TMatrix;
  TempStructName: string;
begin
  Result := nil;
  try

    if Trim(MatlabObjectName) = '' then
      raise EMatrixBadName.Create(SMatlabObjectNameIsEmpty);

    if MatrixObjectName = StrSameName then
    begin
      if MatrixNameIsValid(MatlabObjectName) then
        MatrixObjectName := MatlabObjectName
      else
        MatrixObjectName := GenMatrixName;
    end else if MatrixObjectName <> '' then
    begin
      if not MatrixNameIsValid(MatrixObjectName) then
        raise EMatrixBadName.CreateFmt(matSBadName, [MatrixObjectName]);
    end;

    SClass := SimpleCommandFmt('class(%s)', [MatlabObjectName]);

    // ������������ ����� ��������� �� �����, �.�. ��� � �� ����� ����������
    // �������� ��������� �������� ��������� ����, �������� net1.layers.IW{1,2}
    if SClass = 'cell' then
    begin
      // ������� ������: ������ �����
      Result := TCellMatrix.Create(nil, MatrixObjectName);

      // ���������� ����������� ������� �����
      S := Trim(SimpleCommandFmt('size(%s)', [MatlabObjectName]));
      while Pos('  ', S) > 0 do
        S := FastStringReplace(S, '  ', ' ');

      with TStringList.Create do
      try
        Delimiter := ',';
        DelimitedText := FastStringReplace(S, ' ', ',');

        if Count > 3 then
          raise EMatrixDimensionsError.Create(SCellDimensionMoreThen2);

        SetLength(DimValues, Count);
        for I := 0 to Count - 1 do
          DimValues[I] := StrToInt(Strings[I]);
      finally
        Free;
      end;

      Result.Resize(DimValues);

      ARows := Max(Result.Rows, 1);
      ALayers := Max(Result.Dimension[Result.DimensionCount - 3], 1);
      for K := 0 to ALayers - 1 do
        for I := 0 to ARows - 1 do
          for J := 0 to Result.Cols - 1 do
          begin
            if Result.DimensionCount = 3 then
            begin
              Result.SetCell([K, I, J], GetMatrix(Format('%s{%d,%d,%d}',
                [MatlabObjectName, K + 1, I + 1, J + 1]), ''));
            end else if Result.DimensionCount = 2 then
            begin
              Result.Cells[I, J] := GetMatrix(Format('%s{%d,%d}', [MatlabObjectName, I + 1, J + 1]), '');
            end else
              Result.VecCells[J] := GetMatrix(Format('%s{%d}', [MatlabObjectName, J + 1]), '');
          end;

    end else
    if (SClass = 'struct') or (SClass = 'network') then
    begin
      // ������� ������: ������ �������
      Result := TRecordMatrix.Create(nil, MatrixObjectName);

      AList := TStringList.Create;
      try
        // ���������� ���������� ��� ���������. ������������ MATRIX__TEMP �����
        // ������ ������������, �.�. ������ ��������� ����� ���� ����� ��������
        TempStructName := 'STRUCT_' + GenMatrixName;

        // �������� ��������� ��� ������ ������
        ExecuteFmt('%s=struct(%s);', [TempStructName, MatlabObjectName]);
        try
          // �������� ������ ����� ������
          GetFieldNames(TempStructName, AList);

          // ��������� ���� ������
          for I := 0 to AList.Count - 1 do
            Result.Fields[AList[I]] := GetMatrix(TempStructName + '.' + AList[I], '');
        finally
          // ������� ������������ ���������
          ExecuteFmt('clear %s', [TempStructName]);
        end;
      finally
        AList.Free;
      end;
    end else
    if (SimpleCommandFmt('isnumeric(%s)', [MatlabObjectName]) = '1') or
       (SimpleCommandFmt('islogical(%s)', [MatlabObjectName]) = '1') or
       (SimpleCommandFmt('ischar(%s)', [MatlabObjectName]) = '1') then
    begin

      DimValues := StringToDimValues(SimpleCommandFmt('size(%s)', [MatlabObjectName]));
      if Length(DimValues) > 2 then
        raise EMatrixDimensionsError.Create(matSIsNotMatrix);

      if SimpleCommandFmt('islogical(%s)', [MatlabObjectName]) = '1' then
        Result := TByteMatrix.Create(nil, MatrixObjectName)
      else if SimpleCommandFmt('ischar(%s)', [MatlabObjectName]) = '1' then
        Result := TCharMatrix.Create(nil, MatrixObjectName)
      else if SimpleCommandFmt('isreal(%s)', [MatlabObjectName]) = '1' then
      begin
        SClass := SimpleCommandFmt('class(%s)', [MatlabObjectName]);
        if SClass = 'double' then
          MClass := TDoubleMatrix
        else if SClass = 'single' then
          MClass := TSingleMatrix
        else if SClass = 'int8' then
          MClass := TShortIntMatrix
        else if SClass = 'uint8' then
          MClass := TByteMatrix
        else if SClass = 'int16' then
          MClass := TShortMatrix
        else if SClass = 'uint16' then
          MClass := TWordMatrix
        else if SClass = 'int32' then
          MClass := TIntegerMatrix
        else if SClass = 'uint32' then
          MClass := TCardinalMatrix
        else if SClass = 'int64' then
          MClass := TInt64Matrix
        else if SClass = 'uint64' then
          MClass := TExtendedMatrix
        else
          MClass := TDoubleMatrix;

        Result := MClass.Create(nil, MatrixObjectName)
      end else
      begin // ����������� ������� ��������, ������� ������ � double
        Result := TDoubleComplexMatrix.Create(nil, MatrixObjectName);
      end;

      Result.Resize(DimValues);
      if Result.ElemCount = 0 then Exit;

      // ��������� ���������� ������� ��������� ������������
      SetLength(VDimValues, Length(DimValues) * 2);
      for I := 0 to Length(DimValues) - 1 do
      begin
        VDimValues[I * 2] := 1;
        VDimValues[I * 2 + 1] := DimValues[I];
      end;

      RealArray := VarArrayCreate(VDimValues, varDouble);
      ImagArray := VarArrayCreate(VDimValues, varDouble);

      // �������� ������ ��� ������ ������
      ExecuteFmt('%s=double(%s);', [TempMatrixName, MatlabObjectName]);
      try
        // ��������� ������ �� �������
        MatlabDCOM.GetFullMatrix(TempMatrixName, 'base', VarArrayRef(RealArray),
            VarArrayRef(ImagArray));
      finally
        ExecuteFmt('clear %s', [TempMatrixName]);
      end;

      Result.LoadFromVariantArray(RealArray);

      if Result.IsComplex then
      begin
        TempMatrix := TDoubleMatrix.Create();
        try
          TempMatrix.LoadFromVariantArray(ImagArray);
          Result.CalcOperation([Result, TempMatrix], opCmplxCopyRealParts);
        finally
          TempMatrix.Free;
        end;
      end;

    end else if (SClass = 'function_handle') or (Pos('COM.', SClass) = 1) then
    begin
      // ������� ���������� ������ � ��������� ����� �������, ����� ������� ���� "@"
      // ��� � ��������� �������� COM-�������
      Result := TCharMatrix.Create(nil, MatrixObjectName);
      Result.AsString := SimpleCommandFmt('%s', [MatlabObjectName]);
    end else
    begin // ��� ������������� �������� ���������� ������� � �� ������ ������ ��������
      raise EMatrixWrongElemType.CreateFmt('%s (ObjectType: %s; ObjectName: %s)',
        [matSUnknownType, SimpleCommandFmt('class(%s)', [MatlabObjectName]), MatlabObjectName]);
    end;

  except     
    on E: Exception do
    begin
      // ������� Result, ����� �� ����� ������ �� ����� ������ ���������
      Result.FreeMatrix;
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure TMatlab.GetMatrix'){$ENDIF}
    end;
  end;
end;

function TMatlab.GetVisible: Boolean;
begin
  StartServer;
  Result := MatlabDCOM.Visible;
end;

function TMatlab.MatrixClass(MatrixName: TMatrixName): string;
begin
  try
    Result := SimpleCommandFmt('class(%s)', [MatrixName]);
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'function TMatlab.MatrixClass'){$ENDIF}
  end;
end;

procedure TMatlab.RestoreCommandWindow;
begin
  {������, � ������� ������� MaximizeCommandWindow ������� ���������
   ��������, ��� ��� ��� �� ������ ���������� �� ������������ ����,
   � �������������� (Restore)}
  StartServer; 
  MatlabDCOM.MaximizeCommandWindow;
end;

procedure TMatlab.MinimizeCommandWindow;
begin
  StartServer;
  MatlabDCOM.MinimizeCommandWindow;
end;

procedure TMatlab.PutMatrix(AMatrix: TMatrix; AName: WideString);
begin
  // ������ ������� ������������ �������� ��������
  if AMatrix.IsRecord then
  begin
    if AName = '' then
      AName := AMatrix.MatrixName;

    if MatrixNameIsValid(AName) then
      ExecuteFmt('clear %s', [AName]);
  end;

  DoPutMatrix(AMatrix, AName);
end;

procedure TMatlab.DoPutMatrix(AMatrix: TMatrix; AName: WideString);
var
  RealMatrix, ImagMatrix, RefMatrix, CellElem: TMatrix;
  RealArray, ImagArray: OleVariant;
  I, J, K, ARows, ALayers: Integer;
  S: string;
begin
  try
    // ���� ������ ������� �������, �� �������� ��� �� ������� � Matlab
    if AMatrix.IsWorkspace then
    begin
      for I := 0 to AMatrix.MatrixCount - 1 do
        if AMatrix.Matrices[I].IsLiving and
           not (AMatrix.Matrices[I].IsWorkspace)
        then
        begin
          // ������������ ������� ����������� �������� � �������
          AName := AMatrix.Matrices[I].MatrixName;
          if MatrixNameIsValid(AName) then
            ExecuteFmt('clear %s', [AName]);
          PutMatrix(AMatrix.Matrices[I]);
        end;
      Exit;
    end;

    if AName = '' then
      AName := AMatrix.MatrixName;

    StartServer;

    if AMatrix.IsEmpty then
    begin
      ExecuteFmt('%s = []', [AName]);
      if AMatrix.IsChar then
        ExecuteFmt('%s = char(%s);', [AName, AName]);
      Exit;
    end;

    if AMatrix.IsRecord then
    begin
      for I := 0 to AMatrix.FieldCount - 1 do
        PutMatrix(AMatrix.FieldByIndex(I), AName  + '.' + AMatrix.FieldName(I));
    end else if AMatrix.IsCell then
    begin
      ARows := Max(AMatrix.Rows, 1);
      ALayers := Max(AMatrix.Dimension[AMatrix.DimensionCount - 3], 1);
      for K := 0 to ALayers - 1 do
        for I := 0 to ARows - 1 do
          for J := 0 to AMatrix.Cols - 1 do
          begin
            if AMatrix.DimensionCount = 3 then
            begin
              CellElem := AMatrix.GetCell([K, I, J]);
              S := Format('%s{%d,%d,%d}', [AName, K + 1, I + 1, J + 1]);
              //PutMatrix(AMatrix.GetCell([K, I, J]), Format('%s{%d,%d,%d}', [AName, K + 1, I + 1, J + 1]))
            end else if AMatrix.DimensionCount = 2 then
            begin
              CellElem := AMatrix.Cells[I, J];
              S := Format('%s{%d,%d}', [AName, I + 1, J + 1]);
              //PutMatrix(AMatrix.Cells[I, J], Format('%s{%d,%d}', [AName, I + 1, J + 1]))
            end else
            begin
              CellElem := AMatrix.VecCells[J];
              S := Format('%s{%d}', [AName, J + 1]);
              //PutMatrix(AMatrix.VecCells[J], Format('%s{%d}', [AName, J + 1]));
            end;

            if Assigned(CellElem) then
              PutMatrix(CellElem, S);
          end;
    end else
    begin 

      if not AMatrix.IsNumeric then
        raise EMatrixWrongElemType.Create(matSNotNumericType);

      {������ �� ������������ ��� ������ � ������������ ���������. ���� ����
       ���������� �������� ����� ������ � ������, �� ��� �������� � ��� � ����������
       �� ����.}
      if AMatrix.DimensionCount > 2 then
        raise EMatrixDimensionsError.Create(matSIsNotMatrix);

      if AMatrix.IsChar then
        RealMatrix := TCharMatrix.Create()
      else
        RealMatrix := TDoubleMatrix.Create();
      try
        ImagMatrix := RealMatrix.CreateInstance(RealMatrix);

        RefMatrix := AMatrix.CreateReference(RealMatrix);
        if RefMatrix.DimensionCount = 1 then
          RefMatrix.Reshape([1, RefMatrix.ElemCount]);

        RealMatrix.CalcFunction(RefMatrix, fncCmplxReal);
        RealArray := RealMatrix.AsVariantArray(varDouble);

        ImagMatrix.CalcFunction(RefMatrix, fncCmplxImagToReal);
        ImagArray := ImagMatrix.AsVariantArray(varDouble);

        // �������� ������ �� ��������� ������
        MatlabDCOM.PutFullMatrix(TempMatrixName, 'base', VarArrayRef(RealArray),
          VarArrayRef(ImagArray));

        try
          // ��������������� ������ � ���������� ����
          if not AMatrix.IsComplex then
            ExecuteFmt('%s = real(%s);', [TempMatrixName, TempMatrixName]);

          if AMatrix.IsChar then
            ExecuteFmt('%s = char(%s);', [TempMatrixName, TempMatrixName]);

          ExecuteFmt('%s=%s;', [AName, TempMatrixName]);
          
        finally
          ExecuteFmt('clear %s', [TempMatrixName]);
        end;
      finally
        RealMatrix.Free;
      end;
    end;

  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure TMatlab.PutMatrix'){$ENDIF}
  end;
end;

procedure TMatlab.SetVisible(const Value: Boolean);
begin
  StartServer;
  MatlabDCOM.Visible := Value;
end;

function TMatlab.SimpleCommand(ACommand: string): string;
begin
  Result := '';
  try
    with TStringList.Create do
    try
      Text := Trim(Execute(ACommand));
      if Count > 0 then
        Result := Trim(Strings[Count - 1]);
    finally
      Free;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(
        E, 'function TMatlab.SimpleCommand'){$ENDIF}
  end;
end;

function TMatlab.SimpleCommandFmt(AFmtCommand: string; Values: array of const): string;
begin
  try
    Result := SimpleCommand(Format(AFmtCommand, Values));
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(
        E, 'function TMatlab.SimpleCommandFmt'){$ENDIF}
  end;
end;

procedure TMatlab.StartServer;
  procedure DoStart;
  begin
    MatlabDCOM := CreateOleObject('Matlab.Application')
  end;
begin
  if VarIsNull(MatlabDCOM) then DoStart
  else  
  try
    // ��������� ������ ������� ����������, ���� ������ �� �������

    // ��������! ������ �������� ������ "MatlabDCOM.Visible". ���� ���
    // �������, �� ��� �������� �� ������� � D7 � D2010. � D7 ��������������
    // ������ �������� (� ��� ��������), � � D2010 - ��������� ��������, � ��
    // ���� ���������� ������.
    if MatlabDCOM.Visible then;
  except
    DoStart;
  end;
end;

procedure TMatlab.StopServer;
begin
  MatlabDCOM := Null;
end;

function TMatlab.IsRunning: Boolean;
begin
  Result := not VarIsNull(MatlabDCOM);
  if Result then
  try
    MatlabDCOM.Visible;
  except
    Result := False;
  end;
end;

initialization
  MatlabDCOM := Null;
  Matlab := TMatlab.Create;

finalization
  Matlab.Free;
  Matlab := nil;

end.
