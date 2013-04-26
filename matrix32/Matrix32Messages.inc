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
{   Unit name: Matrix32Messages.inc                                           }
{   Autor: Loginov Dmitry <loginov_d@inbox.ru>                                }
{   Адрес сайта: http://loginovprojects.ru/                                   }
{   Last update: 04.02.2008                                                   }
{ *************************************************************************** }

{$IFDEF UseResStr}
resourcestring
  matSBaseWorkspace = 'Основная рабочая область';
  matSWrongCoords = 'Ошибка доступа к элементу массива. Указаны недопустимые координаты элемента. ';
  matSTryAccessToElem = 'Попытка обратиться к элементу с координатами (%s)';
  matSBadInputData = 'Недопустимые входные данные';
  matSErrorCreateArray = 'Невозможно создать массив с указанными размерами';
  matSInvalidFloat = '''%s'' не является числом с плавающей точкой';
  matSInvalidComplex = '''%s'' не является комплексным числом';
  matSInvalidNumericSymbol = 'Символ ''%s'' не допустим для числовой последовательности';
  matSOutOfMemory = 'Недостаточно памяти для выполнения операции. Требуется: %.0f байт. В наличии: %.0f байт.';
  matSBadName = 'Указано недопустимое имя массива "%s"';
  matSArraysNotAgree = 'Размеры массивов не согласованы';
  matSIsNotSquareArray = 'Массив должен быть квадратной матрицей';
  matSBinaryHeader = 'Matrix32 binaries version 2.0...'; // 32 байта
  matSBadBINFile = 'Файл не соответствует формату системы Matrix32';
  matSCanNotRenameFile = 'Не удалось переименовать файл "%s" в "%s"';
  matSBadNameForBinFile =
    'Невозможно загрузить или сохранить объект в файл, так как имя объекта не указано';
  matSArrayNotFound = 'Не удалось найти массив с именем "%s"';
  matSMatrixRangeOutOfStream =
    'Невозможно прочитать данные из потока TStream, так как указатель ' +
    'на конец объекта указывает за пределы потока';
  matSDimensionError = 'Задано недопустимое значение размерности массива';
  matSNoDimension = 'Указанной размерности не существует';
  matSAbstractError = 'Попытка обращения к запрещенному для объекта методу';
  matSWorkspace = 'Рабочая область';
  matSIsNotMatrix = 'Операция применима только для 2-мерных массивов';
  matSDifferentDimCount = 'Массивы имеют разные размерности';
  matSMustHaveSameType = 'Массивы должны быть однотипными';
  matSNotObjectType = 'Операция применима только для объектных массивов';
  matSNotNumericType = 'Операция применима только для числовых массивов';
  matSNotCellType = 'Операция применима только для массивов ячеек';
  matSNotRecordType = 'Операция применима только для массивов записей';
  matSNotDynamicType = 'Операция применима только для динамических массивов';
  masSIsBadClassForOperation = 'Объект класса "%s" не допустим для выполнения операции';
  matSUnknownType = 'Тип объекта не поддерживается';
  matSFunctionError = 'При работе функции произошла ошибка';
  matSIsCopyByRef = 'Нельзя изменять структуру массива, переданного по ссылке';
  matSCanNotWriteCell = 'Невозможно изменить элемент массива ячеек, переданного по ссылке';
  matSCanNotChangeSize = 'Невозможно изменить размеры массива';
  matSArrayIsEmpty = 'Массив пуст';
  matSDimNotValid = 'Недопустимая размерность массива';
  matSElemWriteError = 'Ошибка записи элемента массива';
  matSElemReadError = 'Ошибка чтения элемента массива';
  matSIsRefToSelf = 'Попытка установить указатель на себя';
  matSRefIsNotMatrix = 'Ссылка "0x%p" не соответствует существующему объекту TMatrix';
  matSDimIntervError = 'Указанный интервал выходит за рамки значения размерности';
  matSMatrixListIsSmall = 'В списке массивов указано слишком мало элементов';
  matSClassNotFound = 'Класс "%s" не зарегистрирован';
  matSAliasError = 'Задан недопустимый псевдоним класса массива';
  matSIsRefToWorkspace = 'Попытка присвоить ссылку на объект "Рабочая область"';
  matSRecordFieldIsNil = 'Поля с именем "%s" не существует!';
  matSRecordIndexNotExists = 'Поля с индексом "%d" не существует!';

  matSBCDErrorString = 'Строка "%s" не содержит корректного двоично-десятичного значения';
  matSBCDTooBigNumber = 'Двоично-десятичное число "%s" слишком большое';
  matSBCDOverFlow = 'Двоично-десятичное число не вместилось в разрядную сетку';
  
  matSOriginalErrorMsg = 'Сообщение об ошибке:';
  matSExceptionClass = 'Класс исключения: ';
  matSMatrixObjectInformation = 'Информация об объекте TMatrix:';
  matSMatrixName = 'Имя объекта: ';
  matSMatrixClassName = 'Класс объекта: %s = class(%s)';
  matSMatrixUsedMemory = 'Занимаемая память: %d байт(а)';
  matSMatrixElemSize = 'Размер элемента: %d байт(а)';
  matSMatrixElemCount = 'Количество элементов массива: %d';
  matSMatrixDimensions = 'Размеры массива (%d-D): %s';
  matSMatrixFieldsCount = 'Число полей записи: %d';
  matSMatrixChildrenCount = 'Число дочерних объектов: %d';
  matSCatchStack = 'Цепь распространения ошибки:';
  
  matSLibraryNotLoaded = 'Библиотека "%s" не загружена!';
  matSProcNotFoundInLibrary = 'Процедура "%s" не найдена в библиотеке "%s"';
{$ELSE}

var
  matSBaseWorkspace: string = 'Основная рабочая область';
  matSWrongCoords: string = 'Ошибка доступа к элементу массива. Указаны недопустимые координаты элемента. ';
  matSTryAccessToElem: string = 'Попытка обратиться к элементу с координатами (%s)';
  matSBadInputData: string = 'Недопустимые входные данные';
  matSErrorCreateArray: string = 'Невозможно создать массив с указанными размерами';
  matSInvalidFloat: string = '''%s'' не является числом с плавающей точкой';
  matSInvalidComplex: string = '''%s'' не является комплексным числом';
  matSInvalidNumericSymbol: string = 'Символ ''%s'' не допустим для числовой последовательности';
  matSOutOfMemory: string = 'Недостаточно памяти для выполнения операции. Требуется: %.0f байт. В наличии: %.0f байт.';
  matSBadName: string = 'Указано недопустимое имя массива "%s"';
  matSArraysNotAgree: string = 'Размеры массивов не согласованы';
  matSIsNotSquareArray: string = 'Массив должен быть квадратной матрицей';
  matSBinaryHeader: string = 'Matrix32 binaries version 2.0...'; // 32 байта
  matSBadBINFile: string = 'Файл не соответствует формату системы Matrix32';
  matSCanNotRenameFile: string = 'Не удалось переименовать файл "%s" в "%s"';
  matSBadNameForBinFile: string =
    'Невозможно загрузить или сохранить объект в файл, так как имя объекта не указано';
  matSArrayNotFound: string = 'Не удалось найти массив с именем "%s"';
  matSMatrixRangeOutOfStream: string =
    'Невозможно прочитать данные из потока TStream, так как указатель ' +
    'на конец объекта указывает за пределы потока';
  matSDimensionError: string = 'Задано недопустимое значение размерности массива';
  matSNoDimension: string = 'Указанной размерности не существует';
  matSAbstractError: string = 'Попытка обращения к запрещенному для объекта методу';
  matSWorkspace: string = 'Рабочая область';
  matSIsNotMatrix: string = 'Операция применима только для 2-мерных массивов';
  matSDifferentDimCount: string = 'Массивы имеют разные размерности';
  matSMustHaveSameType: string = 'Массивы должны быть однотипными';
  matSNotObjectType: string = 'Операция применима только для объектных массивов';
  matSNotNumericType: string = 'Операция применима только для числовых массивов';
  matSNotCellType: string = 'Операция применима только для массивов ячеек';
  matSNotRecordType: string = 'Операция применима только для массивов записей';
  matSNotDynamicType: string = 'Операция применима только для динамических массивов';
  masSIsBadClassForOperation: string = 'Объект класса "%s" не допустим для выполнения операции';
  matSUnknownType: string = 'Тип объекта не поддерживается';
  matSFunctionError: string = 'При работе функции произошла ошибка';
  matSIsCopyByRef: string = 'Нельзя изменять структуру массива, переданного по ссылке';
  matSCanNotWriteCell: string = 'Невозможно изменить элемент массива ячеек, переданного по ссылке';
  matSCanNotChangeSize: string = 'Невозможно изменить размеры массива';
  matSArrayIsEmpty: string = 'Массив пуст';
  matSDimNotValid: string = 'Недопустимая размерность массива';
  matSElemWriteError: string = 'Ошибка записи элемента массива';
  matSElemReadError: string = 'Ошибка чтения элемента массива';
  matSIsRefToSelf: string = 'Попытка установить указатель на себя';
  matSRefIsNotMatrix: string = 'Ссылка "0x%p" не соответствует существующему объекту TMatrix';
  matSDimIntervError: string = 'Указанный интервал выходит за рамки значения размерности';
  matSMatrixListIsSmall: string = 'В списке массивов указано слишком мало элементов';
  matSClassNotFound: string = 'Класс "%s" не зарегистрирован';
  matSAliasError: string = 'Задан недопустимый псевдоним класса массива';
  matSIsRefToWorkspace: string = 'Попытка присвоить ссылку на объект "Рабочая область"';
  matSRecordFieldIsNil: string = 'Поля с именем "%s" не существует!';
  matSRecordIndexNotExists: string = 'Поля с индексом "%d" не существует!';

  matSBCDErrorString: string = 'Строка "%s" не содержит корректного двоично-десятичного значения';
  matSBCDTooBigNumber: string = 'Двоично-десятичное число "%s" слишком большое';
  matSBCDOverFlow: string = 'Двоично-десятичное число не вместилось в разрядную сетку';

  matSOriginalErrorMsg: string = 'Сообщение об ошибке:';
  matSExceptionClass: string = 'Класс исключения: ';
  matSMatrixObjectInformation: string = 'Информация об объекте TMatrix:';
  matSMatrixName: string = 'Имя объекта: ';
  matSMatrixClassName: string = 'Класс объекта: %s = class(%s)';
  matSMatrixUsedMemory: string = 'Занимаемая память: %d байт(а)';
  matSMatrixElemSize: string = 'Размер элемента: %d байт(а)';
  matSMatrixElemCount: string = 'Количество элементов массива: %d';
  matSMatrixDimensions: string = 'Размеры массива (%d-D): %s';
  matSMatrixFieldsCount: string = 'Число полей записи: %d';
  matSMatrixChildrenCount: string = 'Число дочерних объектов: %d';
  matSCatchStack: string = 'Цепь распространения ошибки:';
  
  matSLibraryNotLoaded: string = 'Библиотека "%s" не загружена!';
  matSProcNotFoundInLibrary: string = 'Процедура "%s" не найдена в библиотеке "%s"';
{$ENDIF}