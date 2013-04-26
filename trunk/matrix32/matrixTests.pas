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
{ Модуль matrixTests - тестирование основных возможностей Matrix32            }
{ (c) 2005 - 2007 Логинов Дмитрий Сергеевич                                   }
{ Адрес сайта: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{Данный модуль решено было разработать по той причине, что Matrix32 - динамично
 развивающаяся вычислительная система, и в любой момент при добавлении новых
 возможностей или при исправлении старых можно что-либо сломать. Данный модуль
 позволяет избежать подобных ситуаций}

unit matrixTests;

interface

uses
  Matrix32, SysUtils;

{Запускает на выполнение друг за другом все остальные тесты}
procedure RunTests;

{Проверяет правильность работы конструктора и деструктора при работе
 со всеми видами объектов}
procedure CheckCreateDestroy;

{Matrix32 позволяет задавать рабочим областям любые имена длиной до 255 символов.
 Для других объектов выполняется проверка правильности имен. Родительский
 объект должен следить, чтобы в нем не было нескольких объектов с одним и тем же
 именем (старые объекты с тем же именем, что и новые, удаляются автоматически)}
procedure CheckSetMatrixName;

{Для любого объекта в Matrix32 можно поменять владельца. Владелец - это объект,
 который автоматически удаляет все дочерние объекты при своем уничтожении.}
procedure CheckChangeOwner;

implementation

procedure CheckCreateDestroy;
const
  SFuncName = 'procedure CheckCreateDestroy';
var
  ATempClass: TMatrixClass;
begin
  try
    with TWorkspace.Create() do
    try

      // Проверяем, вызоватся ли перекрытый конструктор
      // Если он не вызовется, то обращение к FieldCount выдаст ошибку
      ATempClass := TRecordMatrix;
      ATempClass.Create(ThisWorkspace).FieldCount;     

      TWorkspace.Create(ThisWorkspace);
      TByteMatrix.Create(ThisWorkspace);
      TCharMatrix.Create(ThisWorkspace);
      TShortIntMatrix.Create(ThisWorkspace);
      TShortMatrix.Create(ThisWorkspace);
      TWordMatrix.Create(ThisWorkspace);
      TIntegerMatrix.Create(ThisWorkspace);
      TCardinalMatrix.Create(ThisWorkspace);
      TInt64Matrix.Create(ThisWorkspace);

      TSingleMatrix.Create(ThisWorkspace);
      TDoubleMatrix.Create(ThisWorkspace);
      TExtendedMatrix.Create(ThisWorkspace);
      TCompMatrix.Create(ThisWorkspace);
      TCurrencyMatrix.Create(ThisWorkspace);

      TSingleComplexMatrix.Create(ThisWorkspace);
      TDoubleComplexMatrix.Create(ThisWorkspace);
      TExtendedComplexMatrix.Create(ThisWorkspace);

      TCellMatrix.Create(ThisWorkspace);
      TRecordMatrix.Create(ThisWorkspace);
    finally
      Free;
    end;
  except
    on E: Exception do ReRaiseMatrixError(E, SFuncName);
  end;
end;

procedure CheckSetMatrixName;
begin
  with TWorkspace.Create(nil, 'Имя рабочей области') do
  try
    TSingleMatrix.Create(ThisWorkspace, 'Name1');
    TDoubleMatrix.Create(ThisWorkspace, 'Name2');
    TExtendedMatrix.Create(ThisWorkspace, '');
    TCompMatrix.Create(ThisWorkspace, '');
    TCurrencyMatrix.Create(ThisWorkspace, 'Name2');

    TCellMatrix.Create(ThisWorkspace, 'Name3');
    MatrixByName['Name3'].MatrixName := 'Name2';

    {Должны остаться:
     - 1 массив с именем 'Name1'
     - 2 массива без имени
     - 1 массив с именем 'Name2'}

    if (MatrixCount <> 4) or not (MatrixExists('Name1') and (MatrixExists('Name2')))
      or MatrixExists('Name3')
    then
      raise Exception.Create('Функция CheckSetMatrixName тест не прошла');
  finally
    Free;
  end;
end;

procedure CheckChangeOwner;
const
  SFuncName = 'procedure CheckChangeOwner';
  SErrorMsg = 'Функция CheckChangeOwner тест не прошла';
var
  Temp1, Temp2, Temp3: TMatrix;
begin
  try
    with TWorkspace.Create() do
    try
      Temp1 := TIntegerMatrix.Create(nil, 'Name');
      Temp1.OwnerMatrix := ThisWorkspace;

      Temp2 := TIntegerMatrix.Create(Temp1, 'Name');
      Temp3 := TIntegerMatrix.Create(Temp1, 'Name');

      if Temp1.MatrixCount <> 1 then
        raise Exception.Create(SErrorMsg);

      // Объект Temp2 уничтожен. Объект Temp3 существует. 
      if Temp2 <> Temp3 then
        if Temp2.IsLiving or not Temp3.IsLiving then
          raise Exception.Create(SErrorMsg);

      Temp3.OwnerMatrix := ThisWorkspace;
      
      // В результате этого объект Temp1 должен уничтожится, так как у него тоже самое имя
      if Temp1.IsLiving then
        raise Exception.Create(SErrorMsg);
      
    finally
      Free;
    end;
  except
    on E: Exception do ReRaiseMatrixError(E, SFuncName);
  end;
end;

procedure RunTests;
begin
  CheckCreateDestroy();
  CheckSetMatrixName();
  CheckChangeOwner();
end;

end.
