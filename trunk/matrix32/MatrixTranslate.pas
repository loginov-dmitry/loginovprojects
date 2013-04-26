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
{ Модуль MatrixTranslate - модуль перевода сообщений системы Matrix32         }
{ (c) 2005 - 2007 Логинов Дмитрий Сергеевич                                   }
{ Последнее обновление: 10.08.2007                                            }
{ Адрес сайта: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{В данном модуле есть перевод только тех сообщений, которые присутствуют в
 модуле Matrix32.pas. Переводы других модулей вы можете выполнять сами. Можете
 добавить их прямо сюда. Модуль работает с переводами, хранящимися в ini-файлах.
 В дистрибутиве системы вы можете найти файлы Russian.lng и English.lng.
 Перевод в них находится внутри секции [MatrixMessages]. Это сделано в основном
 для нужд программистов, использующих возможности модуля LangReader для
 локализации своих приложений}
unit MatrixTranslate;

{$Include MatrixCommon.inc}

interface

uses
  Classes, SysUtils, Matrix32, IniFiles;

{Выполняет перевод всех заданных в теле процедуры текстовых сообщений системы
 Matrix32. LangFileName - имя языкового файла. MatrixSection - имя секции}
procedure TranslateMatrixMessages(const LangFileName: string;
  const MatrixSection: string = 'MatrixMessages');

implementation

procedure TranslateMatrixMessages(const LangFileName: string;
  const MatrixSection: string = 'MatrixMessages');
var
  AList: TStringList;
  Ini: TIniFile;

  procedure TranslateStr(const AName: string; var AValue: string);
  var
    S: string;
  begin
    S := AnsiDequotedStr(AList.Values[AName], '"');
    if S <> '' then
      AValue := S;
  end;
  
  procedure TranslateMessages;
  begin
    {$IFNDEF UseResStr}
    TranslateStr('SBaseWorkspace', matSBaseWorkspace);
    TranslateStr('SWrongCoords', matSWrongCoords);
    TranslateStr('STryAccessToElem', matSTryAccessToElem);
    TranslateStr('SBadInputData', matSBadInputData);
    TranslateStr('SErrorCreateArray', matSErrorCreateArray);
    TranslateStr('SInvalidFloat', matSInvalidFloat);
    TranslateStr('SInvalidComplex', matSInvalidComplex);
    TranslateStr('SInvalidNumericSymbol', matSInvalidNumericSymbol);
    TranslateStr('SOutOfMemory', matSOutOfMemory);
    TranslateStr('SBadName', matSBadName);
    TranslateStr('SArraysNotAgree', matSArraysNotAgree);
    TranslateStr('SIsNotSquareArray', matSIsNotSquareArray);
    TranslateStr('SBadBINFile', matSBadBINFile);
    TranslateStr('CanNotRenameFile', matSCanNotRenameFile);
    TranslateStr('BadNameForBinFile', matSBadNameForBinFile);
    TranslateStr('ArrayNotFound', matSArrayNotFound);
    TranslateStr('MatrixRangeOutOfStream', matSMatrixRangeOutOfStream);
    TranslateStr('DimensionError', matSDimensionError);
    TranslateStr('NoDimension', matSNoDimension);
    TranslateStr('AbstractError', matSAbstractError);
    TranslateStr('Workspace', matSWorkspace);
    TranslateStr('IsNotMatrix', matSIsNotMatrix);
    TranslateStr('DifferentDimCount', matSDifferentDimCount);
    TranslateStr('MustHaveSameType', matSMustHaveSameType);
    TranslateStr('NotObjectType', matSNotObjectType);
    TranslateStr('NotNumericType', matSNotNumericType);
    TranslateStr('NotCellType', matSNotCellType);
    TranslateStr('NotRecordType', matSNotRecordType);
    TranslateStr('NotDynamicType', matSNotDynamicType);
    TranslateStr('IsBadClassForOperation', masSIsBadClassForOperation);
    TranslateStr('UnknownType', matSUnknownType);
    TranslateStr('FunctionError', matSFunctionError);
    TranslateStr('IsCopyByRef', matSIsCopyByRef);
    TranslateStr('CanNotWriteCell', matSCanNotWriteCell);
    TranslateStr('CanNotChangeSize', matSCanNotChangeSize);
    TranslateStr('ArrayIsEmpty', matSArrayIsEmpty);
    TranslateStr('DimNotValid', matSDimNotValid);
    TranslateStr('ElemWriteError', matSElemWriteError);
    TranslateStr('ElemReadError', matSElemReadError);
    TranslateStr('IsRefToSelf', matSIsRefToSelf);
    TranslateStr('RefIsNotMatrix', matSRefIsNotMatrix);
    TranslateStr('DimIntervError', matSDimIntervError);
    TranslateStr('MatrixListIsSmall', matSMatrixListIsSmall);
    TranslateStr('ClassNotFound', matSClassNotFound);
    TranslateStr('AliasError', matSAliasError);
    TranslateStr('IsRefToWorkspace', matSIsRefToWorkspace);
    TranslateStr('RecordFieldIsNil', matSRecordFieldIsNil);
    TranslateStr('RecordIndexNotExists', matSRecordIndexNotExists);
    TranslateStr('BCDErrorString', matSBCDErrorString);
    TranslateStr('BCDTooBigNumber', matSBCDTooBigNumber);
    TranslateStr('BCDOverFlow', matSBCDOverFlow);
    TranslateStr('OriginalErrorMsg', matSOriginalErrorMsg);
    TranslateStr('ExceptionClass', matSExceptionClass);
    TranslateStr('MatrixObjectInformation', matSMatrixObjectInformation);
    TranslateStr('MatrixName', matSMatrixName);
    TranslateStr('MatrixClassName', matSMatrixClassName);
    TranslateStr('MatrixUsedMemory', matSMatrixUsedMemory); 
    TranslateStr('MatrixElemSize', matSMatrixElemSize);
    TranslateStr('MatrixElemCount', matSMatrixElemCount);
    TranslateStr('MatrixDimensions', matSMatrixDimensions);
    TranslateStr('MatrixFieldsCount', matSMatrixFieldsCount);
    TranslateStr('MatrixChildrenCount', matSMatrixChildrenCount);
    TranslateStr('CatchStack', matSCatchStack);
    {$ENDIF UseResStr}
  end;
  

begin
  Ini := TIniFile.Create(LangFileName);
  AList := TStringList.Create;
  try
    Ini.ReadSectionValues(MatrixSection, AList);
    TranslateMessages;
  finally
    AList.Free;
    Ini.Free;
  end;
end;


end.
