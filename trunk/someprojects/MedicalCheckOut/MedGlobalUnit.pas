{
Copyright (c) 2012, Loginov Dmitry Sergeevich
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

unit MedGlobalUnit;

interface

uses
  Windows, SysUtils, Classes, IniFiles, fbTypes, LDSLogger, IBDatabase,
  IBCustomDataSet, ibxFBUtils, Forms, DateUtils;

type
  { Базовый класс, упрощающий управление временем жизни объектов. Благодаря
    данному классу можно минимизировать количество операторов TRY..FINALLY
    и тем самым улучшить читабельность кода.
    ОН НЕ ДОЛЖЕН СОДЕРЖАТЬ НИЧЕГО ЛИШНЕГО! }
  TBaseObject = class(TObject)
  private
    FRefList: TList;

    { Очищает список ссылок FRefList }
    procedure ClearRefList;

    { Регистрирует объект в списоке для автоматического удаления.
      Внимание!!! Если объект зарегистрирован в списке, то его удалять в
      других местах нельзя.
      Пример кода создания объекта:
      AList := RegObj(TStringList.Create) as TStringList; }
    function DoRegObj(Obj: TObject): TObject;

  protected
    { Выполняет уничтожение объекта. Можно перекрыть. }
    procedure ClearObjectRef(ARef: TObject); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    { Создает объкт, регистрирует его в списке FRefList и записывает в параметр Ref }
    procedure RegObj(var Ref; Obj: TObject); overload;

    { Удаляет объект Obj из списка и уничтожает его }
    procedure FreeObj(Obj: TObject);

    { Создает список TList, удаляемый автоматически }
    function CreateList: TList;

    { Создает список строк TStringList, удаляемый автоматически }
    function CreateStringList: TStringList;

    function CreateHashedStringList: THashedStringList;

    function CreateMemoryStream: TMemoryStream;
  end;

  { Тот же TBaseObject, но с другим названием. Для того, чтобы логически выделить
    его назначение: простой список ссылок на объекты. Тот же TObjectList, но
    гораздо удобнее }
  TObjHolder = class(TBaseObject);

  TBaseDescList = class;

  TBaseDescListClass = class of TBaseDescList;

  TBaseDescList = class
  protected
    FItems: TList;
    function GetItem(Idx: Integer): TBaseDescList;
    function AddItem(Item: TBaseDescList): Integer;
    function AddEmptyItem(AClass: TBaseDescListClass): TBaseDescList;
  public
    FName: string;       // Наименование элемента / категории / варианта
    FCode: string;       // Код синхронизации
    FID: Integer;        // Идентификатор
    //FParentID: Integer;  // ID записи в главной таблице
    FComment: string;    // Дополнительная информация
    FSelected: Boolean;  // Элемент выбран, он будет включен в выписку
    FResultText: string; // Результат ввода данных
    FIsManual: Boolean;  // Текст введен вручную
    FParent: TBaseDescList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function ItemCount: Integer;
    function GetSelectedCount: Integer; // Возвращает количество отмеченных элементов
  end;

  TDescVar = class(TBaseDescList)
  public
    FCorrElem: string;       // Скорректированный текст элемента
    FVarName: string;        // Рабочее название варианта
    FCanOtherVars: Boolean;  // Допускает ли одновременное присутствие других вариантов в выписке
    FVarTypes: string;       // Указание типа для каждой подстановочной строки
    FVarValues: string;      // Указание значений для каждой подстановочной строки
  public
    function GetResultText: string; // Возвращает результирующий текст варианта
    procedure ReadDescFromDB(dsVar: TIBDataSet; AParent: TBaseDescList);
  end;

  TDescElem = class(TBaseDescList)
  public
    FElemText: string;      // Текст элемента
    FIsRequired: Boolean;   // Является ли элемент обязательным для заполнения
    FVarPos: Char;          // Расположение вариантов состояния (L-слева, R-справа)
    FDelimAfter: Char;      // Символ-разделитель после текста элемента (если варианты - справа)
    FElemDecor: string;     // Символы выделения текста элемента (B, I, U)
    FContinuePrev: Boolean; // Продолжать предыдущий элемент (размещать в одном предложении)
    FVarSeparator: Char;    // Символ разделения вариантов
    FRequireVars: Boolean;  // Требовать, чтобы был выбран хотя бы один из элементов
    FCustomVars: Boolean;   // Можно ли добавлять новые варианты / произвольный текст

    FPrevElem: TDescElem;   // Предыдущий элемент описания
  public
    function AddVar(Elem: TDescVar): Integer;
    function AddEmptyVar: TDescVar;
    function GetVar(Idx: Integer): TDescVar;
    function GetVarSelCount: Integer; // Возвращает кол-во выбранных вариантов
    function GetElemText: string; // Возвращает текст элемента (с учетом его коррекции)

    function GetResultText(IsMan: Boolean): string; // Возвращает результирующий текст элемента (с учетом вариантов и всех настроек)

    procedure ReadDescFromDB(dsElem: TIBDataSet; AParent: TBaseDescList; PrevElem: TDescElem);
    function CanSelectVar(AVar: TDescVar): Boolean; // Проверяет, можно ли выбрать вариант
  end;

  TDescCateg = class(TBaseDescList)
  public
    FTemplCode: string;             // Название переменной в шаблоне
    FCategText: string;             // Текст категории
    FCategDecor: string;            // Символы выделения текста категории (B, I, U)
    FElemListStyle: Integer;        // Способ представления элементов: 0 - друг за другом в абзаце, 1 - нумерованный список, 2 - маркированный список

    FAutoMode: Boolean;             // Режим автоматического формирования результата
    FManualText: string;            // Текст, введенный в режиме ручного ввода
  public
    function AddElem(Elem: TDescElem): Integer;
    function AddEmptyElem: TDescElem;
    function GetElem(Idx: Integer): TDescElem;

    function GetResultText(IsMan: Boolean): string; // Возвращает результирующий текст категории

    procedure ReadDescFromDB(dsCateg: TIBDataSet);
  end;

  TDescCategList = class(TBaseDescList)
  public
    function AddCateg(Elem: TDescCateg): Integer;
    function AddEmptyCateg: TDescCateg;
    function GetCateg(Idx: Integer): TDescCateg;


    { Считывает информацию из базы данных (из DESC-таблиц) }
    procedure ReadDescFromDB;
  end;

  PMainCheckOutInfo = ^TMainCheckOutInfo;
  TMainCheckOutInfo = record
    Number: string;           // № выписки
    PatFIO: string;           // Фио пациента  (PATPRINTNAME)
    PatBirthDay: TDateTime;
    PatSex: Char;             // Пол пациента (m - мужчина, f - женщина)
    DateIn: TDateTime;        // Дата госпитализации пациента
    DateOut: TDateTime;       // Дата выписки пациента
    Diagnos: string;          // Диагноз
    DoctorID: Integer;        // ID врача
  end;

function GetMainCheckOutInfoAsString(const Info: TMainCheckOutInfo): string;

{Возвращает корректное имя файла}
function GetValidFileName(const AFileName: string): string;

{Обрабатываем текст, отображаемый по-разному для мужчин и женщин}
function ProcessSexSensitiveText(s: string; PatIsMan: Boolean): string;
function ProcessHTMLText(s: string; IsMan: Boolean): string;

function FastStringReplace(const S: string; OldPattern: string;
  const NewPattern: string; Flags: TReplaceFlags = [rfReplaceAll]): string;

{Пересоздает объект исключения, дописывая в его текст имя функции, в
 которой произошло данное исключение}
function ReCreateEObject(E: Exception; FuncName: string; WriteExceptClass: Boolean = True): Exception;

procedure LogEventsProc(Msg: string; LogEvent: TFBLogEvent);

{ Процедура проверки на первый запуск }
function CheckOnFirstStart: Boolean;

procedure FBDeleteRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string; KeyValues: array of Variant;
  ReopenDataSets: array of TIBDataSet);

procedure FBUpdateRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string;
  KeyValues: array of Variant; FieldNames: array of string;
  AFieldValues: array of Variant; ReopenDataSets: array of TIBDataSet);

procedure FBInsertRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; FieldNames: array of string;
  AFieldValues: array of Variant; ReopenDataSets: array of TIBDataSet);

procedure FBReopenDataSets(ReopenDataSets: array of TIBDataSet);

procedure RaiseError(Msg: string);

// Обрабаатывает текст варианта и типы подстановочных строк.
// Возвращает для каждой подст. строки правильный тип
procedure GetVarNameAndTypes(sVarText, sVarTypes: string; ListTypes: TStringList);

var
  ConfigIni: TMemIniFile;
  AppPath: string;
  LogPath: string;
  ReadyDocPath: string;
  TempHtmlFile: string;
  TempHtmlFile2: string;
  HTMLShablonFile: string;

  FBUser: string;
  FBPassword: string;
  FBPort: Integer;
  FBServer: string;
  FBFile: string;
  ALog: TLDSLogger;

  IsAdmin: Boolean; // TRUE - зав отделением, FALSE - обычный врач
  CanWork: Boolean; // TRUE - работать с выписками можно. FALSE - нельзя
  UserID: Integer; // ID врача, выполнившего авторизацию
  UserName: string; // ФИО пользоователя
  ComputerName: string = 'COMP';

  MedDB: TIBDatabase;
  TranR: TIBTransaction;
  TranW: TIBTransaction;

  sPStyle, sListStyle: string;

//const
  //sLStyle = ' style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px"';
  //sLStyle = ' style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; MARGIN-LEFT: 0px; TEXT-INDENT: 10px"';
  //sPStyle= ' style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; TEXT-INDENT: 40px"';

implementation

procedure RaiseError(Msg: string);
begin
  raise Exception.Create(Msg);
end;

procedure GetVarNameAndTypes(sVarText, sVarTypes: string; ListTypes: TStringList);
var
  ListNames: TStringList;
  s, sCut, sName: string;
  PosBeg, PosEnd, I: Integer;
begin
  if Assigned(ListTypes) then
    ListTypes.Clear;
  ListNames := TStringList.Create;
  try
    s := sVarText;
    PosBeg := Pos('{', s);
    while PosBeg > 0 do
    begin
      PosEnd := Pos('}', s);
      if PosEnd < PosBeg then
        RaiseError('Несоответствие символов "{" и "}" в тексте варианта!');
      sCut := Copy(s, PosBeg + 1, PosEnd - PosBeg - 1);
      if Trim(sCut) = '' then
        RaiseError('Обнаружена пустая строка подстановки!');
      Delete(s, PosBeg, PosEnd - PosBeg + 1);
      ListNames.Add(sCut);
      PosBeg := Pos('{', s);
    end;

    if Assigned(ListTypes) then
    begin
      if ListNames.Count = 0 then
        RaiseError('Строка подстановки в тексте варианта не обранужена!');

      ListTypes.Text := FastStringReplace(sVarTypes, '|', sLineBreak);

      // Удаляем из ListTypes лишние элементы
      for I := ListTypes.Count - 1 downto 0 do
        if ListNames.IndexOf(ListTypes.Names[I]) < 0 then
          ListTypes.Delete(I);

      // Добавляем к ListTypes отсутствующие элементы
      for I := 0 to ListNames.Count - 1 do
      begin
        sName := ListNames[I];
        if ListTypes.IndexOfName(sName) < 0 then
        begin
          if (Pos('число', AnsiLowerCase(sName)) > 0) or
             (Pos('кол', AnsiLowerCase(sName)) > 0) or
             (Pos('№', AnsiLowerCase(sName)) > 0) or
             (Pos('номер', AnsiLowerCase(sName)) > 0) or
             (Pos('скор', AnsiLowerCase(sName)) > 0) then
            ListTypes.Add(sName + '=Число')
          else if (Pos('дата', AnsiLowerCase(sName)) > 0) or
                  (Pos('время', AnsiLowerCase(sName)) > 0) then
            ListTypes.Add(sName + '=Дата')
          else if (Pos('цвет', AnsiLowerCase(sName)) > 0) then
            ListTypes.Add(sName + '=Выбор:белый/бледно-розовый/серый')
          else
            ListTypes.Add(sName + '=Текст');
        end;
      end;
    end;
  finally
    ListNames.Free;
  end;
end;

procedure FBReopenDataSets(ReopenDataSets: array of TIBDataSet);
var
  I: Integer;
  ID: Integer;
  ds: TIBDataSet;
begin
  for I := 0 to High(ReopenDataSets) do
  begin
    // Запоминаем текущую запись
    ds := ReopenDataSets[I];
    ID := 0;
    if Assigned(ds.FindField('ID')) then
      ID := ds.FindField('ID').AsInteger;
    ds.DisableControls;
    try
      ds.Close;
      ds.Open;
      if Assigned(ds.FindField('ID')) then
        ds.Locate('ID', ID, []);
    finally
      ds.EnableControls
    end;
  end;
end;

procedure FBDeleteRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string; KeyValues: array of Variant;
  ReopenDataSets: array of TIBDataSet);
begin
  FTran.Active := True;
  try
    fb.DeleteRecord(FDB, FTran, TableName, KeyFields, KeyValues);
    FTran.Commit;
  finally
    FTran.Active := False;
  end;

  FBReopenDataSets(ReopenDataSets);
end;

procedure FBUpdateRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; KeyFields: array of string;
  KeyValues: array of Variant; FieldNames: array of string;
  AFieldValues: array of Variant; ReopenDataSets: array of TIBDataSet);
begin
  FTran.Active := True;
  try
    fb.UpdateRecord(FDB, FTran, TableName, KeyFields, KeyValues, FieldNames, AFieldValues);
    FTran.Commit;
  finally
    FTran.Active := False;
  end;

  FBReopenDataSets(ReopenDataSets);
end;

procedure FBInsertRecord(FDB: TIBDataBase; FTran: TIBTransaction;
  TableName: string; FieldNames: array of string;
  AFieldValues: array of Variant; ReopenDataSets: array of TIBDataSet);
begin
  FTran.Active := True;
  try
    fb.InsertRecord(FDB, FTran, TableName, FieldNames, AFieldValues);
    FTran.Commit;
  finally
    FTran.Active := False;
  end;

  FBReopenDataSets(ReopenDataSets);
end; 


function ReCreateEObject(E: Exception; FuncName: string;
  WriteExceptClass: Boolean = True): Exception;
var
  S: string;
begin
  S := Format('%s -> %s', [FuncName, E.Message]);

  if WriteExceptClass then
  begin
    if Pos(' <# ', S) = 0 then
      S := S + ' <# ' + E.ClassName + ' #>';
  end;
  Result := ExceptClass(E.ClassType).Create(S);
end;

function FastStringReplace(const S: string; OldPattern: string;
  const NewPattern: string; Flags: TReplaceFlags = [rfReplaceAll]): string;
var
  I, J, Idx: Integer;
  IsEqual: Boolean;
  UpperFindStr: string;
  pS: PChar; // Указатель на массив для сравнения символов
  CanReplace: Boolean;
begin
  if OldPattern = '' then
  begin
    Result := S;
    Exit;
  end;

  Result := '';
  if S = '' then Exit;

  if rfIgnoreCase in Flags then
  begin
    OldPattern := AnsiUpperCase(OldPattern);

    // Для режима "не учитывать регистр"
    // потребуется дополнительная строка
    UpperFindStr := AnsiUpperCase(S);

    pS := PChar(UpperFindStr);
  end else
    pS := PChar(S);

  // Если новая подстрока не превышает старой, то...
  if Length(OldPattern) >= Length(NewPattern) then
  begin
    SetLength(Result, Length(S));
  end else // Точный размер буфера не известен...
    SetLength(Result, (Length(S) + Length(OldPattern) +
      Length(NewPattern)) * 2);

  I := 1;
  Idx := 0;
  CanReplace := True;
  while I <= Length(S) do
  begin
    IsEqual := False;

    if CanReplace then // Если замена разрешена
    begin
      // Если I-й символ совпадает с OldPattern[1]
      if pS[I - 1] = OldPattern[1] then // Запускаем цикл поиска
      begin
        IsEqual := True;
        for J := 2 to Length(OldPattern) do
        begin
          if pS[I + J - 2] <> OldPattern[J] then
          begin
            IsEqual := False;
            Break; // Прерываем внутренний цикл
          end;
        end;

        // Совпадение найдено! Выполняем замену
        if IsEqual then
        begin
          for J := 1 to Length(NewPattern) do
          begin
            Inc(Idx);

            // Расширяем строку Result при необходимости
            if Idx > Length(Result) then
              SetLength(Result, Length(Result) * 2);

            Result[Idx] := NewPattern[J];
          end;

          // Пропускаем байты в исходной строке
          Inc(I, Length(OldPattern));

          if not (rfReplaceAll in Flags) then
            CanReplace := False; // Запрещаем дальнейшую замену
        end;
      end;
    end;

    // Если подстрока не найдена, то просто копируем символ
    if not IsEqual then
    begin
      Inc(Idx);

      // Расширяем строку Result при необходимости
      if Idx > Length(Result) then
        SetLength(Result, Length(Result) * 2);

      Result[Idx] := S[I];
      Inc(I);
    end;
  end; // while I <= Length(S) do

  // Ограничиваем длину строки-результата
  SetLength(Result, Idx);
end;

function CheckOnFirstStart: Boolean;
var
  ds: TIBDataSet;
begin
  Result := False;
  ds := fb.CreateAndOpenDataSet(MedDB, nil, 'SELECT * FROM DOCTORS WHERE ISBOSS=1', [], []);
  try
    if ds.Eof then
    begin
      Application.MessageBox(
        'Не найдена учетная запись зав. отделением!' + sLineBreak +
        'Программа запущена с административными правами!' + sLineBreak +
        'Добавьте учетную запись зав. отделением!', 'ВНИМАНИЕ!', MB_ICONWARNING);
      Result := True;
    end;
  finally
    ds.Free;
  end;
  // Определяем, есть ли в БД учетная запись зав. отделения
end;

procedure ReadDBParams;
var
  s: string;
begin
  s := ConfigIni.ReadString('БАЗА', 'ПОЛЬЗОВАТЕЛЬБД', '[по умолчанию]');
  if AnsiSameText(s, '[по умолчанию]') then
    s := FBDefUser;
  FBUser := s;

  s := ConfigIni.ReadString('БАЗА', 'ПАРОЛЬБД', '[по умолчанию]');
  if AnsiSameText(s, '[по умолчанию]') then
    s := FBDefPassword;
  FBPassword := s;

  s := ConfigIni.ReadString('БАЗА', 'ПОРТ', '[по умолчанию]');
  if AnsiSameText(s, '[по умолчанию]') then
    s := IntToStr(FBDefPort);
  FBPort := StrToInt(s);

  s := ConfigIni.ReadString('БАЗА', 'СЕРВЕР', '[этот компьютер]');
  if AnsiSameText(s, '[этот компьютер]') then
    s := FBDefServer;
  FBServer := s;

  s := ConfigIni.ReadString('БАЗА', 'ФАЙЛ', '%КаталогПриложения%\DB\Medical.FDB');
  s := FastStringReplace(s, '%КаталогПриложения%', ExcludeTrailingPathDelimiter(AppPath));
  FBFile := s;

  if FBServer = FBDefServer then
    ForceDirectories(ExtractFilePath(FBFile));
end;


{ TBaseObject }

procedure TBaseObject.ClearObjectRef(ARef: TObject);
begin
  ARef.Free;
end;

procedure TBaseObject.ClearRefList;
var
  I: Integer;
  Obj: TObject;
begin
  if Assigned(FRefList) then
  begin
    for I := 0 to FRefList.Count - 1 do
    begin
      Obj := FRefList[I];
      ClearObjectRef(Obj);
    end;
    FRefList.Clear;
  end;
end;

constructor TBaseObject.Create;
begin
  FRefList := TList.Create;
end;

function TBaseObject.CreateHashedStringList: THashedStringList;
begin
  RegObj(Result, THashedStringList.Create);
end;

function TBaseObject.CreateList: TList;
begin
  RegObj(Result, TList.Create);
end;

function TBaseObject.CreateStringList: TStringList;
begin
  RegObj(Result, TStringList.Create);
end;

function TBaseObject.CreateMemoryStream: TMemoryStream;
begin
  RegObj(Result, TMemoryStream.Create);
end;

destructor TBaseObject.Destroy;
begin
  if Assigned(FRefList) then
  begin
    ClearRefList; // Будут уничтожены все объекты, находящиеся в списке
    FRefList.Free;
  end
  else
    raise Exception.Create('TBaseObject.Destroy -> Не был вызван конструктор класса TBaseObject!');
  inherited;
end;


procedure TBaseObject.RegObj(var Ref; Obj: TObject);
begin
  Pointer(Ref) := DoRegObj(Obj);
end;

function TBaseObject.DoRegObj(Obj: TObject): TObject;
begin
  if Assigned(FRefList) then
  begin
    FRefList.Add(Obj);
    Result := Obj;
  end
  else
    raise Exception.Create('TBaseObject.RegObj -> Не был вызван конструктор класса TBaseObject!');

end;

procedure TBaseObject.FreeObj(Obj: TObject);
var
  Idx: Integer;
begin
  Idx := FRefList.IndexOf(Obj);
  if Idx >= 0 then
    FRefList.Delete(Idx);
  ClearObjectRef(Obj);
end;

procedure LogEventsProc(Msg: string; LogEvent: TFBLogEvent);
begin
  ALog.LogStr(Msg, TLDSLogType(LogEvent));
end;

procedure CreateLogger;
begin
  ForceDirectories(LogPath);
  ALog := TLDSLogger.Create(LogPath + 'Medical.log');
  ALog.LogStr('');
  ALog.LogStr('Программа запущена');
end;

procedure FreeLogger;
begin
  ALog.LogStr('Программа остановлена');
  FreeAndNil(ALog);
end;

{ TDescCateg }

function TDescCateg.AddElem(Elem: TDescElem): Integer;
begin
  Result := AddItem(Elem);
end;

function TDescCateg.AddEmptyElem: TDescElem;
begin
  Result := AddEmptyItem(TDescElem) as TDescElem;
end;

function TDescCateg.GetElem(Idx: Integer): TDescElem;
begin
  Result := GetItem(Idx) as TDescElem;
end;

function TDescCateg.GetResultText(IsMan: Boolean): string;
var
  I, Cnt: Integer;
  Elem: TDescElem;
  ElemText, sCategText, sDecor, sElems: string;
begin
  if not FAutoMode then
    Result := FManualText
  else
  begin
    Result := '';

    sCategText := FCategText;
    if sCategText <> '' then
      sCategText[1] := AnsiUpperCase(sCategText[1])[1];
    if (sCategText <> '') and (FCategDecor <> '') then // Если заданы символы декорирования
    begin
      sDecor := FastStringReplace(FCategDecor, ';', '');
      for I := 1 to Length(sDecor) do
        sCategText := Format('<%s>%s</%s>', [sDecor[I], sCategText, sDecor[I]]);
    end;

    if sCategText <> '' then
    begin
      Result := sCategText + ': ';
      if FElemListStyle in [1,2] then
        Result := '<p style="' + sPStyle + '">' + Result + '</p>';
    end;

    Cnt := 0;

    for I := 0 to ItemCount - 1 do
    begin
      Elem := GetElem(I);
      if Elem.FSelected then
      begin
        Inc(Cnt);
        ElemText := Elem.GetResultText(IsMan);

        case FElemListStyle of
          // Нумерованный список
          1: ElemText := '<p style="' + sListStyle + '">' + IntToStr(Cnt) + '.&nbsp;' + ElemText + '</p>';
          // Маркированный список
          2: ElemText := '<p style="' + sListStyle + '">' + '-&nbsp;' + ElemText + '</p>';
        end;

        if (FElemListStyle = 0) and (sElems <> '') then
        begin
          if Elem.FContinuePrev then
          begin
            if sElems[Length(sElems)] = '.' then
              sElems[Length(sElems)] := ';';
          end;
          sElems := sElems + ' ';
        end;

        sElems := sElems + ElemText;
      end;
    end;

    if Trim(sElems) <> '' then
      Result := Result + sElems;

    Result := ProcessHTMLText(Result, IsMan);
  end;
end;

procedure TDescCateg.ReadDescFromDB(dsCateg: TIBDataSet);
var
  ds: TIBDataSet;
  NewElem, PrevElem: TDescElem;
begin
  FName := dsCateg.FieldByName('NAME').AsString;
  FCode := dsCateg.FieldByName('CATEGCODE').AsString;
  FID := dsCateg.FieldByName('ID').AsInteger;
  FComment := dsCateg.FieldByName('COMMENT').AsString;

  FCategText := dsCateg.FieldByName('CATEGTEXT').AsString;
  FCategDecor := dsCateg.FieldByName('CATEGDECOR').AsString;
  FElemListStyle := dsCateg.FieldByName('ELEMLISTSTYLE').AsInteger;

  FSelected := False;
  FResultText := '';
  FTemplCode := dsCateg.FieldByName('TEMPLCODE').AsString;

  // Считываем элементы категории
  ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCELEMS', 'CATEG_ID=:c AND ISDELETE=0', 'ORDERNUM', ['c'], [FID]);
  try
    PrevElem := nil;
    while not ds.Eof do
    begin
      NewElem := AddEmptyElem;
      NewElem.ReadDescFromDB(ds, Self, PrevElem);

      PrevElem := NewElem;
      ds.Next;
    end;
  finally
    ds.Free;
  end;
end;

{ TDescCategList }

function TDescCategList.AddCateg(Elem: TDescCateg): Integer;
begin
  Result := AddItem(Elem);
end;

function TDescCategList.AddEmptyCateg: TDescCateg;
begin
  Result := AddEmptyItem(TDescCateg) as TDescCateg;
end;

function TDescCategList.GetCateg(Idx: Integer): TDescCateg;
begin
  Result := GetItem(Idx) as TDescCateg;
end;

procedure TDescCategList.ReadDescFromDB;
var
  ds: TIBDataSet;
begin
  ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCCATEGS', 'ISDELETE=0 AND USECATEG=1', 'ORDERNUM', [], []);
  try
    while not ds.Eof do
    begin
      AddEmptyCateg.ReadDescFromDB(ds);
      ds.Next;
    end;
  finally
    ds.Free;
  end;
end;

{ TDescElem }

function TDescElem.AddEmptyVar: TDescVar;
begin
  Result := AddEmptyItem(TDescVar) as TDescVar;
end;

function TDescElem.AddVar(Elem: TDescVar): Integer;
begin
  Result := AddItem(Elem);
end;

function TDescElem.CanSelectVar(AVar: TDescVar): Boolean;
var
  CurVar: TDescVar;
  I: Integer;
begin
  Result := True;
  for I := 0 to ItemCount - 1 do
  begin
    CurVar := GetVar(I);

    if CurVar <> AVar then
      if CurVar.FSelected and (not CurVar.FCanOtherVars or not AVar.FCanOtherVars) then
      begin
        Result := False;
        Exit;
      end;
  end;
end;

function TDescElem.GetElemText: string;
var
  I: Integer;
  AVar: TDescVar;
begin
  if FIsManual then
  begin
    Result := FResultText;
    Exit;
  end
  else
    Result := FElemText;

  for I := 0 to ItemCount - 1 do
  begin
    AVar := GetVar(I);
    if AVar.FSelected and (AVar.FCorrElem <> '') then
    begin
      Result := AVar.FCorrElem;
      Exit;
    end;
  end;
end;

function TDescElem.GetResultText(IsMan: Boolean): string;
var
  I, VarSelCount, Cnt: Integer;
  AVar: TDescVar;
  sDecor, sElemText: string;
begin
  Result := '';
  VarSelCount := GetVarSelCount;

  sElemText := GetElemText;
  if (sElemText <> '') and (FElemDecor <> '') then // Если заданы символы декорирования
  begin
    sDecor := FastStringReplace(FElemDecor, ';', '');
    for I := 1 to Length(sDecor) do
      sElemText := Format('<%s>%s</%s>', [sDecor[I], sElemText, sDecor[I]]);
  end;

  if (FVarPos = 'R') then
  begin
    Result := sElemText;

    if (sElemText <> '') and (VarSelCount > 0)  then
      Result := Result + Trim(FDelimAfter) + ' ';
  end;

  if VarSelCount > 0 then
  begin
    Cnt := 0;
    for I := 0 to ItemCount - 1 do
    begin
      AVar := GetVar(I);
      if AVar.FSelected then
      begin
        Inc(Cnt);
        Result := Result + AVar.GetResultText;
        if Cnt < VarSelCount then
          Result := Result + Trim(FVarSeparator) + ' ';
      end;
    end;
  end;

  if (FVarPos = 'L') and (sElemText <> '') then
  begin
    if Result <> '' then
      Result := Trim(Result) + ' ';
    Result := Result + AnsiLowerCase(sElemText);
  end;

  

  if Length(Result) > 1 then
  begin
    Result := ProcessHTMLText(Result, IsMan);

    if FContinuePrev and Assigned(FPrevElem) and FPrevElem.FSelected and (TDescCateg(FParent).FElemListStyle = 0) then
    begin
      if (Result[1] <> AnsiLowerCase(Result[1])) and (Result[2] = AnsiLowerCase(Result[2])) then
        Result[1] := AnsiLowerCase(Result[1])[1];
    end else
    begin
      // Маленькую букву делаем большой, без лишних проверок
      Result[1] := AnsiUpperCase(Result[1])[1];
    end;
  end;

  // В конце элемента ставим точку
  if Result <> '' then
    if Result[Length(Result)] <> '.' then
      Result := Result + '.';
end;

function TDescElem.GetVar(Idx: Integer): TDescVar;
begin
  Result := GetItem(Idx) as TDescVar;
end;

function TDescElem.GetVarSelCount: Integer;
var
  I: Integer;
  AVar: TDescVar;
begin
  Result := 0;
  for I := 0 to ItemCount - 1 do
  begin
    AVar := GetVar(I);
    if AVar.FSelected then
      Inc(Result);
  end;
end;

procedure TDescElem.ReadDescFromDB(dsElem: TIBDataSet; AParent: TBaseDescList; PrevElem: TDescElem);
var
  s: string;
  ds: TIBDataSet;
begin
  FID := dsElem.FieldByName('ID').AsInteger;
  //FParentID := ParentID;
  FParent := AParent;
  FPrevElem := PrevElem;
  FName := dsElem.FieldByName('ELEMNAME').AsString;
  FCode := dsElem.FieldByName('ELEMCODE').AsString;
  FComment := dsElem.FieldByName('COMMENT').AsString;
  FSelected := False;
  FResultText := '';

  FElemText := dsElem.FieldByName('ELEMTEXT').AsString;
  FIsRequired := dsElem.FieldByName('ISREQUIRED').AsInteger = 1;
  s := dsElem.FieldByName('VARPOS').AsString;
  if s = '' then s := 'R';
  FVarPos := s[1];

  s := dsElem.FieldByName('DELIMAFTER').AsString;
  if (s = '') or (s = 'S') then s := ' ';
  FDelimAfter := s[1];
  FElemDecor := dsElem.FieldByName('ELEMDECOR').AsString;
  FContinuePrev := dsElem.FieldByName('CONTINUEPREV').AsInteger = 1;

  s := dsElem.FieldByName('VARSEPARATOR').AsString;
  if (s = '') or (s = 'S') then s := ' ';
  FVarSeparator := s[1];

  FRequireVars := dsElem.FieldByName('REQUIREVARS').AsInteger = 1;
  FCustomVars := dsElem.FieldByName('CUSTOMVARS').AsInteger = 1; 

  // Считываем варианты описания для данного элемента
  ds := fb.CreateAndOpenTable(MedDB, TranR, 'DESCVARS', 'ELEM_ID=:e AND ISDELETE=0', 'ORDERNUM', ['e'], [FID]);
  try
    while not ds.Eof do
    begin                
      AddEmptyVar.ReadDescFromDB(ds, Self);
      ds.Next;
    end;
  finally
    ds.Free;
  end;
end;

{ TBaseDescList }

function TBaseDescList.AddEmptyItem(AClass: TBaseDescListClass): TBaseDescList;
begin
  Result := AClass.Create;
  FItems.Add(Result);
end;

function TBaseDescList.AddItem(Item: TBaseDescList): Integer;
begin
  Result := FItems.Add(Item);
end;

procedure TBaseDescList.Clear;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    TObject(FItems[I]).Free;
  FItems.Clear;
end;

constructor TBaseDescList.Create;
begin
  FItems := TList.Create;
end;

destructor TBaseDescList.Destroy;
begin
  if Assigned(FItems) then
  begin
    Clear;
    FItems.Free;
  end;
  inherited;
end;

function TBaseDescList.GetItem(Idx: Integer): TBaseDescList;
begin
  Result := TBaseDescList(FItems[Idx]);
end;

function TBaseDescList.GetSelectedCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ItemCount - 1 do
    if GetItem(I).FSelected then
      Inc(Result);
end;

function TBaseDescList.ItemCount: Integer;
begin
  Result := FItems.Count;
end;


{ TDescVar }

function TDescVar.GetResultText: string;
var
  AList: TStringList;
  I: Integer;
begin
  Result := FVarName;
  //if Length(Result) > 1 then
  //begin
    // Если первая буква большая, а вторая маленькая, то делаем и первую
    // букву большой
  //  if (Result[1] <> AnsiLowerCase(Result[1])) and (Result[2] = AnsiLowerCase(Result[2])) then
  //    Result[1] := AnsiLowerCase(Result[1])[1];
  //end;

  // Подставляем заданные переменные
  AList := TStringList.Create;
  try
    AList.Text := FastStringReplace(FVarValues, '|', sLineBreak);
    for I := 0 to AList.Count - 1 do
      Result := FastStringReplace(Result, '{' + AList.Names[I] + '}', AList.ValueFromIndex[I]);
  finally
    AList.Free
  end;
end;

procedure TDescVar.ReadDescFromDB(dsVar: TIBDataSet; AParent: TBaseDescList);
begin
  FID := dsVar.FieldByName('ID').AsInteger;
  //FParentID := ParentID;
  FParent := AParent;
  FName := dsVar.FieldByName('VARTEXT').AsString;    // Название варианта из базы данных (чтоб не потерялось)
  FVarName := FName;                                 // Рабочее название вариента
  FCode := dsVar.FieldByName('VARCODE').AsString;
  FComment := dsVar.FieldByName('COMMENT').AsString;
  FSelected := False;
  FResultText := '';

  FCorrElem := dsVar.FieldByName('CORRELEM').AsString;
  FCanOtherVars := dsVar.FieldByName('CANOTHERVARS').AsInteger = 1;
  FVarTypes := dsVar.FieldByName('VARTYPES').AsString;
end;

function ProcessSexSensitiveText(s: string; PatIsMan: Boolean): string;
var
  AList: TStringList;
  I: Integer;
begin
  AList := TStringList.Create;
  try
    if PatIsMan then
      ConfigIni.ReadSectionValues('ПОДСТАНОВОЧНЫЕ СТРОКИ - МУЖЧИНА', AList)
    else
      ConfigIni.ReadSectionValues('ПОДСТАНОВОЧНЫЕ СТРОКИ - ЖЕНЩИНА', AList);

    for I := 0 to AList.Count - 1 do
      s := FastStringReplace(s, '{' + AList.Names[I] + '}', AList.ValueFromIndex[I]);

    Result := Trim(s);
  finally
    AList.Free;
  end;
end;

function ProcessHTMLText(s: string; IsMan: Boolean): string;
var
  Pos1, I: Integer;
  sSub, sNew: string;
begin

  Pos1 := Pos('^', s);
  while Pos1 > 0 do
  begin
    sSub := '';
    sNew := '';
    for I := Pos1 + 1 to Length(s) do
      if s[I] in ['0'..'9'] then
        sSub := sSub + s[I]
      else
        Break;

    if sSub <> '' then
      sNew := '<sup>' + sSub + '</sup>';

    s := FastStringReplace(s, '^' + sSub, sNew, []);

    Pos1 := Pos('^', s);
  end;

  s := ProcessSexSensitiveText(s, IsMan);

  Result := s;
end;

function GetMainCheckOutInfoAsString(const Info: TMainCheckOutInfo): string;
var
  s, sYear, sDate, sFIO: string;
  Year: Word;
begin
  s := ConfigIni.ReadString('ШАБЛОНЫ', 'ИНФОРМАЦИЯ_О_ПАЦИЕНТЕ', '');

  if Info.PatFIO = '' then
    sFIO := '<font color=red>_____________________________</font>'
  else
    sFIO := Info.PatFIO;
  s := FastStringReplace(s, '{ФИОБольного}', sFIO);

  if Info.PatBirthDay = 0 then
    sYear := '<font color=red>_____</font>'
  else
  begin
    Year := YearOf(Info.PatBirthDay);
    if Year < 2000 then
      Year := Year - 1900;
    sYear := IntToStr(Year);
  end;
  s := FastStringReplace(s, '{ГодРожденияБольного}', sYear);

  if Info.DateIn = 0 then
    sDate := '<font color=red>_________</font>'
  else
    sDate := FormatDateTime('dd.mm.yy', Info.DateIn);
  s := FastStringReplace(s, '{ДатаГоспитализации}', sDate);

  if Info.DateOut = 0 then
    sDate := '<font color=red>_________</font>'
  else
    sDate := FormatDateTime('dd.mm.yy', Info.DateOut);
  s := FastStringReplace(s, '{ДатаВыписки}', sDate);
  s := FastStringReplace(s, '{ПредварительныйДиагноз}', Info.Diagnos);

  Result := ProcessSexSensitiveText(s, Info.PatSex <> 'f');

  // Первую букву делаем заглавной
  if Result <> '' then
  begin
    Result[1] := AnsiUpperCase(Result[1])[1];

    // Ставим в конце точку
    if not (Result[Length(Result)] in ['.', ',', ':', ';']) then
      Result := Result + '.';
  end;
end;

function GetValidFileName(const AFileName: string): string;
var
  I: Integer;
begin
  Result := AnsiLowerCase(AFileName);

  // Удаляем все двойные символы backslash
  while Pos('\\', Result) > 0 do
    Result := StringReplace(Result, '\\', '\', [rfReplaceAll]);


  for I := 1 to Length(Result) do
    if Result[I] in ['\', '/', ':', '*', '"', '?', '|', '<', '>'] then
      Result[I] := '_';
end;

initialization
  AppPath := ExtractFilePath(ParamStr(0));
  LogPath := AppPath + 'LogFiles\';
  ForceDirectories(LogPath);
  ReadyDocPath := AppPath + 'ReadyDocPath\';
  ForceDirectories(ReadyDocPath);
  ConfigIni := TMemIniFile.Create(AppPath + 'Config.ini');
  sPStyle := ConfigIni.ReadString('СТИЛИ HTML', 'Стиль абзаца', '');
  sListStyle := ConfigIni.ReadString('СТИЛИ HTML', 'Стиль списка', '');
  TempHtmlFile := AppPath + 'LogFiles\TempHtmlFile.html';
  TempHtmlFile2 := AppPath + 'LogFiles\TempHtmlFile2.html';
  HTMLShablonFile := AppPath + 'Shablon.html';
  CreateLogger;
  ReadDBParams;
finalization
  ConfigIni.Free;
  FreeLogger;
end.
