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
{ ������ MatrixCommon - ������ ����� ��� ������ ������� ��������� ����������  }
{ ��������� ����������: 03.03.2007                                            }
{ ����� �����: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{������� . ���� �� ������, ����� Matrix32 �������� �������� ������� ���������
 �������� �������. ��� ����� �������� � ����� ��������� ������ �������, ������
 ������� ����� �������������������� ������. ��� ���������� ��������� �����
 ����� �������� ������ �������� ������/������ ��������� �������.
 ����������� ���������� ���������� Matrix32 � ������ ���������� �� ����� ����������.
 �� �������� ��������� ��� ����� ��� ���������� ��������� ������ ����� ��������}
{.$DEFINE MatrixCheckRange}

{������� . ���� �� ������, ����� ��� ������ �������� TMatrix ����������������
 � ������ ������� MatrixClassList. ��������� �����, �������� �� ������ � ��������
 � ������� ������������� ������� ������� �������� ������� ��� �������� ��������
 �� ������� ��� ������}
{$DEFINE RegisterMatrixClasses}

{������� . ���� �� ������, ����� ������ ������ except...end, ��������� �� ������
 �������� Matrix32, ������������� ��� ������������ ������� ���������� � �����
 ��������� � ����� ���������� �������������� ���������� ���������� (����������
 ���������� ���������� � ������� ������� AddDebugInfoToExceptObject, �������
 ��������� � ������ Matrix32).
 ����� ����, ��������� ���������� � ��������� ����������
 �� ������ ������ � ��� ���� �����, ���� ������ ������������ ���������������
 �������� ������� (��������, ���������� JEDI (http://sourceforge.net/projects/jcl)}
{$DEFINE RecreateEObj}

{��� ���������� ����� UseResStr ��� ��������� �� ������� �����������
 � ���������� resourcestring. ��� ����������� ����� ��������� �����������
 ��� ������� ��������� ���������� (�.�. ����� var). �� ������ ������ �����
 ���������� ���� ������ �������� ���������. ������ MatrixTranslate.pas ����������
 ������, ��� ������� ��������� ��������� �������� � ini-������. ��� ��������
 ������ � ������� �������� ��������� ������ ���������� LangReader}
{$DEFINE UseResStr}

{����� BLASLoadLibOnInit ������������ � ������ matrixBLAS.pas. ���� ����� ��������,
 �� � ����� ������������� ������ matrixBLAS ����� ������� ��� �������� ����������
 matrixatlas.dll. ���� ����� ���������, �� �������� ���������� ��������� ���������
 ������� � ������� ������� LoadBLASLibrary}
{$DEFINE BLASLoadLibOnInit}

{����� LapackLoadLibOnInit ������������ � ������ matrixLapack.pas. ���� ����� ��������,
 �� � ����� ������������� ������ matrixLapack ����� ������� ��� �������� ����������
 matrixlapack.dll. ���� ����� ���������, �� �������� ���������� ��������� ���������
 ������� � ������� ������� LoadLapackLibrary}
{$DEFINE LapackLoadLibOnInit}
