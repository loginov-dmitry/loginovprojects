{ *************************************************************************** }
{   Unit name: Matrix32Messages.inc                                           }
{   Autor: Loginov Dmitry <loginov_d@inbox.ru>                                }
{   http://matrix.kladovka.net.ru/                                            }
{   Last update: 04.02.2008                                                   }
{ *************************************************************************** }

{$IFDEF UseResStr}
resourcestring
  matSBaseWorkspace = 'Base workspace';
  matSWrongCoords = 'Mistake of access to an element of array. Inadmissible coordinates of an element are specified. ';
  matSTryAccessToElem = 'Attempt to address to an element with coordinates (%s)';
  matSBadInputData = 'The inadmissible input data';
  matSErrorCreateArray = 'It is impossible to create array with the specified sizes';
  matSInvalidFloat = '''%s'' is not floating point number';
  matSInvalidComplex = '''%s'' is not complex number';
  matSInvalidNumericSymbol = 'Symbol ''%s'' is not allowable for numerical sequence';
  matSOutOfMemory = 'Not enough memory for performance of operation. Need memory: %.0f byte. Available memory: %.0f byte';
  matSBadName = 'Was specified bad array name: "%s"';
  matSArraysNotAgree = 'Arrays dimensions not agree';
  matSIsNotSquareArray = 'Array should be a square matrix';
  matSBinaryHeader = 'Matrix32 binaries version 2.0...'; // 32 bytes
  matSBadBINFile = 'The file does not correspond to a format of system Matrix32';
  matSCanNotRenameFile = 'Can''t rename file "%s" to "%s"';
  matSBadNameForBinFile =
    'It is impossible to load or keep object in a file as the name of object is not specified';
  matSArrayNotFound = 'Array "%s" is not found';
  matSMatrixRangeOutOfStream =
    'It is impossible to read the data from stream TStream as the index '+
    'specifies the end of object for limits of a stream';
  matSDimensionError = 'Inadmissible value of dimension of array is set';
  matSNoDimension = 'The specified dimension does not exist';
  matSAbstractError = 'Attempt of the reference to the method forbidden for object';
  matSWorkspace = 'Workspace';
  matSIsNotMatrix = 'Operation is applicable only for 2-dimensional arrays';
  matSDifferentDimCount = 'Arrays have different dimensions';
  matSMustHaveSameType = 'Arrays should have one class';
  matSNotObjectType = 'Operation is applicable only for object matrix';
  matSNotNumericType = 'Operation is applicable only for numerical arrays';
  matSNotCellType = 'Operation is applicable only for arrays of cells';
  matSNotRecordType = 'Operation is applicable only for arrays of records';
  matSNotDynamicType = 'Operation is applicable only for dynamic arrays';
  masSIsBadClassForOperation = 'The object of a class "%s" is not allowable for performance of operation';
  matSUnknownType = 'The type of object is not supported';
  matSFunctionError = 'At work of function there was error';
  matSIsCopyByRef = 'It is impossible to change structure of array transferred by the reference';
  matSCanNotWriteCell = 'It is impossible to change an element of cells array transferred by the reference';
  matSCanNotChangeSize = 'It is impossible to change the sizes of array';
  matSArrayIsEmpty = 'Array is empty';
  matSDimNotValid = 'Inadmissible dimension of array';
  matSElemWriteError = 'Element write error';
  matSElemReadError = 'Element read error';
  matSIsRefToSelf = 'Attempt to establish the reference on itself';
  matSRefIsNotMatrix = 'Reference "0x%p" is not correspond TMatrix object';
  matSDimIntervError = 'The specified interval is beyond value of dimension';
  matSMatrixListIsSmall = 'Few elements are specified in array list';
  matSClassNotFound = 'Class "%s" is not registered';
  matSAliasError = 'The inadmissible pseudonym of array class is set';
  matSIsRefToWorkspace = 'Attempt to assign reference on object "Workspace"';
  matSRecordFieldIsNil = 'Field with name "%s" not exists!';
  matSRecordIndexNotExists = 'Field with index "%d" not exists!';

  matSBCDErrorString = 'Строка "%s" не содержит корректного двоично-десятичного значения';
  matSBCDTooBigNumber = 'Двоично-десятичное число "%s" слишком большое';
  matSBCDOverFlow = 'Двоично-десятичное число не вместилось в разрядную сетку';
  
  matSOriginalErrorMsg = 'Error message:';
  matSExceptionClass = 'Exception class: ';
  matSMatrixObjectInformation = 'Information on object TMatrix:';
  matSMatrixName = 'Object name: ';
  matSMatrixClassName = 'Object class: %s = class(%s)';
  matSMatrixUsedMemory = 'Occupied memory: %d bytes';
  matSMatrixElemSize = 'Element size: %d bytes';
  matSMatrixElemCount = 'Amount of elements of array: %d';
  matSMatrixDimensions = 'Array sizes (%d-D): %s';
  matSMatrixFieldsCount = 'Record fields count: %d';
  matSMatrixChildrenCount = 'Number of child objects: %d';
  matSCatchStack = 'Error stack trace:';
  
  matSLibraryNotLoaded = 'Library "%s" not loaded!';
  matSProcNotFoundInLibrary = 'Procedure "%s" is not found in the library "%s"';
{$ELSE}  

var
  matSBaseWorkspace: string = 'Base workspace';
  matSWrongCoords: string = 'Mistake of access to an element of array. Inadmissible coordinates of an element are specified. ';
  matSTryAccessToElem: string = 'Attempt to address to an element with coordinates (%s)';
  matSBadInputData: string = 'The inadmissible input data';
  matSErrorCreateArray: string = 'It is impossible to create array with the specified sizes';
  matSInvalidFloat: string = '''%s'' is not floating point number';
  matSInvalidComplex: string = '''%s'' is not complex number';
  matSInvalidNumericSymbol: string = 'Symbol ''%s'' is not allowable for numerical sequence';
  matSOutOfMemory: string = 'Not enough memory for performance of operation. Need memory: %.0f byte. Available memory: %.0f byte';
  matSBadName: string = 'Was specified bad array name: "%s"';
  matSArraysNotAgree: string = 'Arrays dimensions not agree';
  matSIsNotSquareArray: string = 'Array should be a square matrix';
  matSBinaryHeader: string = 'Matrix32 binaries version 2.0...'; // 32 bytes
  matSBadBINFile: string = 'The file does not correspond to a format of system Matrix32';
  matSCanNotRenameFile: string = 'Can''t rename file "%s" to "%s"';
  matSBadNameForBinFile: string =
    'It is impossible to load or keep object in a file as the name of object is not specified';
  matSArrayNotFound: string = 'Array "%s" is not found';
  matSMatrixRangeOutOfStream: string =
    'It is impossible to read the data from stream TStream as the index '+
    'specifies the end of object for limits of a stream';
  matSDimensionError: string = 'Inadmissible value of dimension of array is set';
  matSNoDimension: string = 'The specified dimension does not exist';
  matSAbstractError: string = 'Attempt of the reference to the method forbidden for object';
  matSWorkspace: string = 'Workspace';
  matSIsNotMatrix: string = 'Operation is applicable only for 2-dimensional arrays';
  matSDifferentDimCount: string = 'Arrays have different dimensions';
  matSMustHaveSameType: string = 'Arrays should have one class';
  matSNotObjectType: string = 'Operation is applicable only for object matrix';
  matSNotNumericType: string = 'Operation is applicable only for numerical arrays';
  matSNotCellType: string = 'Operation is applicable only for arrays of cells';
  matSNotRecordType: string = 'Operation is applicable only for arrays of records';
  matSNotDynamicType: string = 'Operation is applicable only for dynamic arrays';
  masSIsBadClassForOperation: string = 'The object of a class "%s" is not allowable for performance of operation';
  matSUnknownType: string = 'The type of object is not supported';
  matSFunctionError: string = 'At work of function there was error';
  matSIsCopyByRef: string = 'It is impossible to change structure of array transferred by the reference';
  matSCanNotWriteCell: string = 'It is impossible to change an element of cells array transferred by the reference';
  matSCanNotChangeSize: string = 'It is impossible to change the sizes of array';
  matSArrayIsEmpty: string = 'Array is empty';
  matSDimNotValid: string = 'Inadmissible dimension of array';
  matSElemWriteError: string = 'Element write error';
  matSElemReadError: string = 'Element read error';
  matSIsRefToSelf: string = 'Attempt to establish the reference on itself';
  matSRefIsNotMatrix: string = 'Reference "0x%p" is not correspond TMatrix object';
  matSDimIntervError: string = 'The specified interval is beyond value of dimension';
  matSMatrixListIsSmall: string = 'Few elements are specified in array list';
  matSClassNotFound: string = 'Class "%s" is not registered';
  matSAliasError: string = 'The inadmissible pseudonym of array class is set';
  matSIsRefToWorkspace: string = 'Attempt to assign reference on object "Workspace"';
  matSRecordFieldIsNil: string = 'Field with name "%s" not exists!';
  matSRecordIndexNotExists: string = 'Field with index "%d" not exists!';

  matSBCDErrorString: string = 'Строка "%s" не содержит корректного двоично-десятичного значения';
  matSBCDTooBigNumber: string = 'Двоично-десятичное число "%s" слишком большое';
  matSBCDOverFlow: string = 'Двоично-десятичное число не вместилось в разрядную сетку';
  
  matSOriginalErrorMsg: string = 'Error message:';
  matSExceptionClass: string = 'Exception class: ';
  matSMatrixObjectInformation: string = 'Information on object TMatrix:';
  matSMatrixName: string = 'Object name: ';
  matSMatrixClassName: string = 'Object class: %s = class(%s)';
  matSMatrixUsedMemory: string = 'Occupied memory: %d bytes';
  matSMatrixElemSize: string = 'Element size: %d bytes';
  matSMatrixElemCount: string = 'Amount of elements of array: %d';
  matSMatrixDimensions: string = 'Array sizes (%d-D): %s';
  matSMatrixFieldsCount: string = 'Record fields count: %d';
  matSMatrixChildrenCount: string = 'Number of child objects: %d';
  matSCatchStack: string = 'Error stack trace:';  
  
  matSLibraryNotLoaded: string = 'Library "%s" not loaded!';
  matSProcNotFoundInLibrary: string = 'Procedure "%s" is not found in the library "%s"';
{$ENDIF}