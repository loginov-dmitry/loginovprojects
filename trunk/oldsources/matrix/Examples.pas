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
{ ������ Examples - ������� �������� �� ������ � Matrix                       }
{ (�) ������� �.�., 2005                                                      }
{ ����� �����: http://matrix.kladovka.net.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{*****************************************************************************}
unit Examples;
interface

uses Matrix, SysUtils;

procedure first;
procedure iter();
procedure ExternalFunc(Ws: TWorkspace; A, B, C, D: string);

implementation

uses Signals;

procedure first;
var C: Integer;
begin
  Base.SLoad('D=1');
  for C := 1 to 10000 do begin
    Base.SLoad('A=[1 2 3 4 5]');
    Base.SLoad('B=[6 7 8 9 10; 11 12 13 14 15]');
    Base.AddRows('A', 'B', 'C');
    Base.Transpose('C', 'C');
    Base.CalcFunc2(Base.CalcFunc(Base.CalcFunc2(Base.CalcFunc('C', 'Temp1', fncSin),
      Base.CalcFunc('C', 'Temp2', fncCos), 'Temp1', fncSum), 'Temp1', fncTrunc), 2,
        'C', fncDiv);
    Base.Clear('Temp1');
    Base.Clear('Temp2');
    Base.CalcFunc2('D', 'C', 'D', fncSum);
  end;
end;

procedure iter();
var
  i, aIdx, r, c, bIdx: Integer;
begin
  Base.Clear();
  for i := 1 to 20000 do
    Base.SetEl('A', sqrt(i) * sin(i), 1, i, True, True);
  aIdx := Base.GetSize('A', r, c);
  bIdx := Base.NewArray('B', r, c);
  Base.ElemI[bIdx, 1, 1] := 5;
  for i := 2 to c do
    Base.ElemI[bIdx, 1, i] := Base.ElemI[bIdx, 1, i - 1] + Base.ElemI[aIdx, 1, i];
end;


procedure ExternalFunc(Ws: TWorkspace; A, B, C, D: string);
begin
  with TWorkspace.Create('ExternalFunc', Ws) do begin // �������� ������� �������
    CheckResAr(D); // �������� ������������ ����� ��������� �������
    LoadArray(A, 'A'); // �������� ������ �� ������ �
    LoadArray(B, 'B'); // �������� ������ �� ������ �
    LoadArray(C, 'C'); // �������� ������ �� ������ �
    CalcFunc2('A', 'B', 'Tmp', fncSum);   // A + B = Tmp
    CalcFunc2('Tmp', 'C', 'D', fncMul);   // Tmp * C = D

    // ���������� ��� ������ ����� �������� � ����, ��� �������� ����:
    // ElWiseOp(ElWiseOp('A', 'B', 'Tmp', '+'), 'C', 'D', '*');

    ReturnArray('D', D);      // �������� D � ������� ������� �������
    Free;                             // ����������� ������� �������
  end;
end;

procedure ExternalFunc1(Ws: TWorkspace; A, B, C, D: string);
var
  Tmp: string;
begin
  with Ws do begin
    // ���������� ���������� ��� ���������� ������ �� ��������
    if (not ArrayExists(A)) or (not ArrayExists(B)) or
      (not ArrayExists(C)) then DoError(matArrayNotFound);
    CheckResAr(D);  // ��������� ��� ��������� �������
    Tmp := GenName(); // ���������� ��� ���������� �������
    CalcFunc2(CalcFunc2('A', 'B', Tmp, fncSum), 'C', Tmp, fncMul);
    RenameArray(Tmp, D); // ��������������� ��������� ������
  end;
end;

end.

