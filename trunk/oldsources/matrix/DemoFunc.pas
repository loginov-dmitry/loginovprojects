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
{ ������ DemoFunc - ������� ���������������� �������� �����-��� �� Matrix     }
{ (�) ������� �.�., 2005-2006                                                 }
{ ����� �����: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{*****************************************************************************}

{���������� ������� � ������ ������ ����� ������������ �������
 mGenBinaryCombinations, ������� ���������� ������� �������� ����������.
 ��� ������� � ���� ����� ������� ������ ����� ������������ �� ����������
 "������ � �������� ������ ����������". ������� �������� �������� �����, �������
 �������� ���� �� �������� �������� ��� ����������}
unit DemoFunc;

interface
uses
  SysUtils, Matrix, Signals;

const
  matGenBinaryCombinations = '��������� ������� �������� ����������';


// ���������� ������� �������� ����������
procedure mGenBinaryCombinations(Ws: TWorkspace; AllCnt, ElCnt: Integer;
  MatName: String);  

implementation

{��������� ������� �������� ����������. �������� � ������ ������ �������,
 ������� ��� ����� ���������� ����� ��� �������}
procedure mGenBinaryCombinations(Ws: TWorkspace; AllCnt, ElCnt: Integer;
  MatName: string);
var
  CurWS: TWorkspace;
  RowCnt, I, Current, Pred: Integer;
  Ind1, Ind2: Integer;

  function GetPrior(Index: Integer): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := Index - 1 downto 1 do
      if CurWS.ElemI[Ind2, 1, I] = 1 then
      begin
        Result := I;
        Exit;
      end;
  end;

  procedure OffSet(Index: Integer);
  var
    I: Integer;
  begin
    for I := Index + 2 to AllCnt do
      if CurWS.ElemI[Ind2, 1, I] = 1 then
      begin
        CurWS.ElemI[Ind2, 1, I] := 0;
        CurWS.ElemI[Ind2, 1, Index + 1] := 1;
        Inc(Index);
      end;
  end;

  function GetCurrent(Index: Integer): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := Index + 1 to AllCnt do
      if CurWS.ElemI[Ind2, 1, I] = 0 then
      begin
        Result := I - 1;
        Exit;
      end;
  end;

  procedure DoExit(ErrorMsg: string = '');
  begin
    if ErrorMsg <> '' then CurWS.DoError(ErrorMsg) else CurWS.Free;
  end;

  function Fac(n: Integer): Extended;
  var
    I: Integer;
  begin
    Result := 1;
    if n < 0 then raise
      Exception.Create('Factorial Error!') else
      if n = 0 then Result := 1 else
        for I := 1 to n do Result := Result * I;
  end;

begin
  CurWS := TWorkspace.Create(matGenBinaryCombinations, Ws);
  with CurWS do begin
    CheckResAr(MatName);
    if (AllCnt < ElCnt) or (AllCnt < 1) then DoExit(matBadInputData);
    // ���������� ����� ����� � �������� ������� A=n!/(k!(n-k)!)
    RowCnt := Round(Fac(AllCnt) / (Fac(ElCnt) * Fac(AllCnt - ElCnt)));
    // ������� ������ �������
    Ind1 := NewArray('X', RowCnt, AllCnt, True);
    // ��������� ������ ������ ������� - ��� �������� �����
    for I := 1 to ElCnt do ElemI[Ind1, 1, I] := 1;
    CopyCutRows('X', 'Vek', 1, 1, False);
    Ind2 := GetIndex('Vek');
    Current := ElCnt;
    // ��������� �������
    for I := 2 to RowCnt do
    begin
     // ���� ����� ��������� ������, �� �������
      if (Current <> AllCnt) and (ElemI[Ind2, 1, Current + 1] <> 1) then
      begin
        ElemI[Ind2, 1, Current] := 0;
        ElemI[Ind2, 1, Current + 1] := 1;
        Inc(Current);
       // �������� ���������� ������ � ������� ������
        PasteSubmatrix('Vek', 'X', I, 1);
        Continue;
      end;
      // ���� ������ ��������� �����. ������, �� ����� ��������� ������ ����������
      // �������, �� ������� ���
      if (Current = AllCnt) or (ElemI[Ind2, 1, Current + 1] = 1) then
        if (Current - 1 > 1) and (ElemI[Ind2, 1, Current - 1] = 0) then
        begin
          Pred := GetPrior(Current);
          // ���� ��� ���, �� �������
          if Pred = 0 then
          begin
            Ws.CopyArray(CurWS, 'X', MatName);
            CurWS.Free;
            Exit;
          end;
          // ������� ��� ������
          ElemI[Ind2, 1, Pred] := 0;
          ElemI[Ind2, 1, Pred + 1] := 1;
          Inc(Pred);
          if ElemI[Ind2, 1, Pred + 1] = 0 then
          begin // �������� �������� ������� �����
            OffSet(Pred);
            Current := GetCurrent(Pred);
            if Current = 0 then Current := Pred + 1;
          end else
            Current := Pred;
          PasteSubmatrix('Vek', 'X', I, 1);
        end;
    end; // for
    ReturnArray('X', MatName);
  end;
  DoExit();
end;

end.

