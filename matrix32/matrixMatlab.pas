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
{ Модуль matrixMatlab - Модуль взаимодействия Matrix32 с Матлабом             }
{ (c) 2005 - 2007 Логинов Дмитрий Сергеевич                                   }
{ Последнее изменение: 05.05.2007                                             }
{ Адрес сайта: http://loginovprojects.ru/                                     }
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
  {Класс реализует методы, необходимые для работы с Матлабом. Вы не должны
   создавать объекты данного класа. Глобальный объект MatlabDCOM создается
   в секции инициализации и разрушается в секции финализации. Его-то вы
   и должны использовать. Сервер Matlab (по крайней мере версии 6.0) способен
   функционировать только в режиме "один сервер для всех клиентов", т.е., если
   в системе услугами сервера Matlab хотят воспользоваться сразу несколько
   клиентов, то разделения данных не произойдет, т.е. все клиенты будут работать
   с одной рабочей областью, а значит - с одними и теми же данными (поэтому
   один клиент запросто может испортить данные, с которыми в данный момент
   работает другой клиент)}
  TMatlab = class(TObject)
  private

    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);

    procedure DoPutMatrix(AMatrix: TMatrix; AName: WideString = '');
  public

    {Выполняет запуск DCOM-сервера Матлаб. Нет необходимости вызывать данную
     процедуру вручную, так как там где нужно она будет вызвана автоматически.
     В случае, если сервер уже был запущен ранее, и после этого его закрыли,
     функция выполнит перезапуск сервера}
    procedure StartServer;

    {Останавливает работу DCOM-сервера MatlabDCOM.}
    procedure StopServer;

    {Управляет свойством Visible запущенного сервера Matlab}
    property Visible: Boolean read GetVisible write SetVisible;

    {Минимизирует окно команд сервера Matlab}
    procedure MinimizeCommandWindow;

    {Восстанавливает положение окна команд сервера Matlab. Показывает окно,
     если до этого у него было Visible=True}
    procedure RestoreCommandWindow;

    {Возвращает True, если сервер Matlab запущен}
    function IsRunning: Boolean;

    {Посылает Матлабу команду ACommand. Командой может быть любая строка или набор
     строк, которые можно набрать непосредственно в окне Матлаба. Функция в
     качестве результата работы возвращает текст, который выдает матлаб как
     реакция на выполненную команду. Если при обработке команды в Матлабе
     возникнут ошибки, то при установленном DoRaiseException
     функция сгенерирует соответствующее исключение.
     !!!Внимание!!! Если вы задаете команду, которая может вывести результат,
     следите, чтобы эта команда не привела к зависанию программы. Например для
     больших массивов команда 'a=b', где b - большой массив, может запросто привести
     к зависанию. Чтобы зависания не возникло, ставьте в конце команды символ ';'}
    function Execute(ACommand: WideString; DoRaiseException: Boolean = True): string;

    function ExecuteFmt(AFmtCommand: string;
      Values: array of const; DoRaiseException: Boolean = True): string;

    {Копирует объект AMatrix в рабочую область "Base" Матлаба под именем AName.
     В качестве AMatrix может быть 2-мерный массив действительный или мнимых
     чисел, а также массив ячеек и массив записей.
     Матлаб по какой-то причине накладывает ограничения на размерность передаваемого
     массива (не более 2-х измерений). Обходить их я пока не стал.
     Поддерживает передачу в Матлаб данных любых типов.}
    procedure PutMatrix(AMatrix: TMatrix; AName: WideString = '');

    {Загружает объект AName из рабочей области Base Матлаба. Если указанного
     массива не существует, или при загрузке возникнут ошибки, то будет
     сгенерировано исключение. Загружаемый объект может быть весьма сложным.
     Например, функция успешно справляется с загрузкой нейронной сети, в которой
     можно изменить какие-либо параметры, и передать обратно в матлаб с помощью
     процедуры PutMatrix(). Данная функция в результате создает новый объект.
     Тип создаваемого объект зависит от типа объекта в Матлабе. Вы должны сами
     следить за своевременным уничтожением объектов}
    function GetMatrix(MatlabObjectName: string; MatrixObjectName: string = StrSameName): TMatrix;

    {Возвращает True, если в рабочей области Base есть объект с именем MatrixName.
     Если задано составное имя (a.b.c), то вернет False}
    function Exists(MatrixName: TMatrixName): Boolean;

    {Возвращает класс указанного массива в строковом формате}
    function MatrixClass(MatrixName: TMatrixName): string;

    {Выполняет простую команду, результатом которой является строка или число,
     размещаемые на одной строке. Функция удаляет из результата
     граничные символы пробелов и перевода строки}
    function SimpleCommand(ACommand: string): string;
    
    function SimpleCommandFmt(AFmtCommand: string; Values: array of const): string;

    {Возвращает список полей структуры StructName}
    procedure GetFieldNames(StructName: string; AList: TStrings);
  end;

var

  {Через этот объект вы будете работать с матлабом. Не пытайтесь создать или
   разрушить объект вручную - ни к чему хорошему это не приведет.}
  Matlab: TMatlab;

resourcestring
  SCellDimensionMoreThen2 = 'Размерность массива ячеек не должна превышать 3.';
  SMatlabObjectNameIsEmpty = 'Наименование объекта из Matlab не указано';

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

    {У Матлаба в качестве разделителя строк используется символ #10
     В ОС Windows разделитель строк другой. Изменяем разделитель строк в
     зависимости от ОС.}
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

    // Правильность имени проверять не будет, т.к. оно и не будет правильным
    // алгоритм допускает указание составных имен, например net1.layers.IW{1,2}
    if SClass = 'cell' then
    begin
      // Создаем объект: массив ячеек
      Result := TCellMatrix.Create(nil, MatrixObjectName);

      // Определяем размерности массива ячеек
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
      // Создаем объект: массив записей
      Result := TRecordMatrix.Create(nil, MatrixObjectName);

      AList := TStringList.Create;
      try
        // Генерируем УНИКАЛЬНОЕ имя структуры. Наименование MATRIX__TEMP здесь
        // нельзя использовать, т.к. внутри структуры может быть много массивов
        TempStructName := 'STRUCT_' + GenMatrixName;

        // Копируем структуру под другим именем
        ExecuteFmt('%s=struct(%s);', [TempStructName, MatlabObjectName]);
        try
          // Получаем список полей записи
          GetFieldNames(TempStructName, AList);

          // Заполняем поля записи
          for I := 0 to AList.Count - 1 do
            Result.Fields[AList[I]] := GetMatrix(TempStructName + '.' + AList[I], '');
        finally
          // Удаляем наименование структуры
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
      begin // Комплексные массивы редкость, поэтому храним в double
        Result := TDoubleComplexMatrix.Create(nil, MatrixObjectName);
      end;

      Result.Resize(DimValues);
      if Result.ElemCount = 0 then Exit;

      // Формируем вариантные массивы требуемых размерностей
      SetLength(VDimValues, Length(DimValues) * 2);
      for I := 0 to Length(DimValues) - 1 do
      begin
        VDimValues[I * 2] := 1;
        VDimValues[I * 2 + 1] := DimValues[I];
      end;

      RealArray := VarArrayCreate(VDimValues, varDouble);
      ImagArray := VarArrayCreate(VDimValues, varDouble);

      // Копируем массив под другим именем
      ExecuteFmt('%s=double(%s);', [TempMatrixName, MatlabObjectName]);
      try
        // Считывает массив из Матлаба
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
      // Создаем символьный массив с указанием имени функции, перед которым идет "@"
      // Или в указанием названия COM-объекта
      Result := TCharMatrix.Create(nil, MatrixObjectName);
      Result.AsString := SimpleCommandFmt('%s', [MatlabObjectName]);
    end else
    begin // При необходимости добавить правильную реакцию и на другие классы объектов
      raise EMatrixWrongElemType.CreateFmt('%s (ObjectType: %s; ObjectName: %s)',
        [matSUnknownType, SimpleCommandFmt('class(%s)', [MatlabObjectName]), MatlabObjectName]);
    end;

  except     
    on E: Exception do
    begin
      // Удаляем Result, иначе он будет висеть до конча работы программы
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
  {Видимо, в матлабе функция MaximizeCommandWindow названа несколько
   неудачно, так как при ее вызове происходит не максимизация окна,
   а восстановление (Restore)}
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
  // Особым образом обрабатываем передачу структур
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
    // Если задана рабочая область, то передаем все ее массивы в Matlab
    if AMatrix.IsWorkspace then
    begin
      for I := 0 to AMatrix.MatrixCount - 1 do
        if AMatrix.Matrices[I].IsLiving and
           not (AMatrix.Matrices[I].IsWorkspace)
        then
        begin
          // Обеспечиваем очистку одноименных массивов в Матлабе
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

      {Матлаб не предназначен для работы с многомерными массивами. Даже если
       ухитриться передать такой массив в Матлаб, то как работать с ним в дальнейшем
       не ясно.}
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

        // Копируем данные во временный массив
        MatlabDCOM.PutFullMatrix(TempMatrixName, 'base', VarArrayRef(RealArray),
          VarArrayRef(ImagArray));

        try
          // Преобразовываем массив к требуемому типу
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
    // Следующая строка вызовет исключение, если сервер не запущен

    // Внимание! Нельзя вызывать просто "MatlabDCOM.Visible". Если так
    // вызвать, то код работает по разному в D7 и D2010. В D7 осуществляется
    // запрос значения (и все работает), а в D2010 - установка значения, и на
    // этом происходит ошибка.
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
