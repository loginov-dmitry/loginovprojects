{
Copyright (c) 2010, Loginov Dmitry Sergeevich
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
{ Модуль LDSSecurityUnit - модуль для определения параметров безопасности     }
{ различных объектов операционной системы. Функции из данного модуля являются }
{ удобными "обертками" соответствующих функций ОС Windows. Учтены             }
{ многочисленные ошибки объявления типов в стандартном модуле AclAPI          }
{ Учтены проблемы, возникающие из-за неправильного объявления  SE_OBJECT_TYPE }
{ Работа проверена в D7, D2007, D2010                                         }
{ (c) 2010 Логинов Дмитрий Сергеевич                                          }
{ Последнее обновление: 29.05.2010                                            }
{                                                                             }
{ *************************************************************************** }

{
Немного теории:
  В ОС WINDOWS есть ряд объектов, доступ к которым контроллируется. К таким
  объектам относятся:
  - Файлы
  - Директории
  - Ключи реестра
  - Именованные каналы
  - Мьютексы
  - Эвенты
  - и другие.

  В каждым из этих объектов связан ОПИСАТЕЛЬ БЕЗОПАСНОСТИ SecurityDescriptor

  Когда программа пытается получить доступ (т.е. в момент вызова функций
  CreateXXX, OpenXXX, где XXX - тип защищенного объекта) к объекту (например к файлу)
  с какой-то целью (например для записи или чтения), система проверяет, есть
  ли у программы необходимые права для выполнения указанной операции.
  Если прав на указанную операцию у программы нет, то функции CreateXXX / OpenXXX
  вернут ошибочный результат (этот результат в дальнейшем можно определить с
  помощью GetLastError).
  Контроль доступа к защищаемому объекту выполняется следующим образом:
  система проверяет, есть ли у пользователя (или его группы), запустившего
  программу, права на требуемые операции с объектом. Дело в том, что в
  ОПИСАТЕЛЕ БЕЗОПАСНОСТИ защищаемого объекта указано, какому пользователю
  (или группе пользователей) разрешен (или запрещен) доступ к объекту и для
  выполнения каких именно операций. Эта информация хранится в таблице описателя
  безопасности, которая называется DACL (discretionary access control list).
  Эта таблица характеризуется одним общим параметром: НАСЛЕДОВАНИЕ. Данный
  параметр определяет, наследуются ли записи списка DACL для ДАННОГО
  защищаемого объекта от списка DACL родительского объекта. По умолчанию у
  большинства объектов WINDOWS наследование включено. Т.е. изменение
  разрешений / запретов РОДИТЕЛЬСКОГО объекта влияет на таблицу DACL ДАННОГО
  защищаемого объекта. Внимание! Важно! Для системного каталога Windows\
  наследование по умолчанию ОТКЛЮЧЕНО.
  Кроме того, таблица DACL состоит из записей ACE (access control entries).
  Каждая запись ACE - это либо РАЗРЕШЕНИЕ, либо ЗАПРЕТ для некоторого
  пользователя или группы пользователей для выполнения некоторого набора операций
  с объектом. Каждая запись ACE характеризуется следующими параметрами:
  - тип записи (это либо РАЗРЕШЕНИЕ, либо ЗАПРЕТ)
  - пользователь (это идентификатор безопасности (SID) пользователя или группы,
    к которому данная запись ACE относится)
  - признак унаследования (запись может быть либо задана явно, либо унаследована
    от родительского объекта)
  - правила "распространения". В случае, если права настраиваются для объекта,
    который является контейнером (например, директория) и содержит в себе другие
    объекты (например, другие директории и файлы), то права могут:
    - применяться ТОЛЬКО для ДАННОГО объекта
    - применяться для данного объекта и для вложенных директорий
    - применяться для данного объекта и для вложенных файлов
    - применяться для данного объекта и для вложенных директорий И файлов
    - и др.
  - права доступа (набор флагов, каждый из которых отвечает за ту или иную операцию,
    доступ к которой регулируется данной ACE. Эти операции имеют 3 основных
    типа: ЧТЕНИЕ, ЗАПИСЬ, ВЫПОЛНЕНИЕ. Каждому их этих типов может соответствовать
    несколько флагов. Например для чтения могут соответствоват следующие
    флаги: чтение атрибутов, чтение параметров защиты, чтение содержимого и т.п.).    

  Записи ACE в таблице DACL следуют в определенном порядке: во первых, сначала
  идут ЯВНО заданные ограничения, а за ними идут УНАСЛЕДОВАННЫЕ. Затем эти две
  группы ограничений (явные и унаследованные) сортируются то типу ограничения,
  т.е. сначала идут ЗАПРЕТЫ, а затем идут РАЗРЕШЕНИЯ. Т.е. запрещающие ACE имеют
  более высокий приоритет, чем разрешающие. Хотя программным путем данный порядок
  можно изменить, но это может привести к неправильной работе.

  Пример записей ACE в таблице DACL:

  ЗАПРЕТ     | ИВАНОВ И.И. | ЗАПИСЬ
  ЗАПРЕТ     | ВСЕ         | УДАЛЕНИЕ
  РАЗРЕШЕНИЕ | ИВАНОВ И.И. | ПОЛНЫЙ ДОСТУП

  В этом случае для пользователя "ИВАНОВ И.И." есть 2 записи ACE: разрешение на
  полный доступ и запрет записи. Поскольку ACE запрета записи стоит выше, чем
  разрешение полного доступа, то пользователю "ИВАНОВ И.И." запись ЗАПРЕЩЕНА.
  Однако если бы разрешение на полный доступ стояло выше запрета записи, то
  пользователю "ИВАНОВ И.И." запись была бы РАЗРЕШЕНА. Кроме того, пользователю
  "ИВАНОВ И.И." запрещено удаление, т.к. пользователь "ИВАНОВ И.И." относится
  к группе "ВСЕ", для которой установлен запрет удаления. Группа "ВСЕ" - это
  WELL KNOWN GROUP (хорошо известная группа), к которой относятся любые пользователи.

Примеры:
  Для того, чтобы считать DACL в строковом виде для указанного файла (тип объекта
  определяется вторым параметром при вызове конструктора, в данном случае
  это SE_FILE_OBJECT), воспользуйтесь следующим кодом (файл должен существовать):

  with TLDSSecurity.Create('c:\MyFile.txt', SE_FILE_OBJECT) do
  try
    S := ObjectGetSecurityDescriptorAsString(DACL_SECURITY_INFORMATION);
    ShowMessage(S);
  finally
    Free;
  end;

  Для того, чтобы обеспечить полный доступ всех пользователей к указанному
  файлу или директории, воспользуйтесь следующим кодом:

  with TLDSSecurity.Create('c:\MyFile.txt', SE_FILE_OBJECT) do
  try
    ObjectSetSecurityDescriptorFromString('D:PAI(A;OICI;GA;;;WD)', DACL_SECURITY_INFORMATION);
    // Либо ObjectSetAllowAllForEveryOne;
  finally
    Free;
  end;

  В данном примере в качестве первого параметра передается строка описания
  ОПИСАТЕЛЯ БЕЗОПАСНОСТИ в формате Security Descriptor String Format.
  В качестве второго параметра указывается, какую именно
  часть ОПИСАТЕЛЯ БЕЗОПАСНОСТИ необходимо заменить (таблица DACL).
  Формат данной строки подробно рассмотрен в разделах msdn:
  Security Descriptor String Format: http://msdn.microsoft.com/en-us/library/aa379570%28v=VS.85%29.aspx
  ACE Strings:                       http://msdn.microsoft.com/en-us/library/aa374928%28v=VS.85%29.aspx

  В данном примере задана строка 'D:PAI(A;OICI;GA;;;WD)'. Вот что означают ее параметры:
  "D:" - будет заменена таблица DACL
  "P" - Protected - отключено наследование ACE от родительской DACL. Если система
        не может применить этот флаг, то он игнорируется. Судя по всему, изменять
        данный флаг с помощью указанной функции нельзя, видимо для этого следует
        использовать отдельное API.
  "AI" - включено наследование прав для всех дочерних объектов (оно всегда включено)
  "A" - данная ACE будет иметь разрешающий тип. Для запрещения вы можете использовать "D"
  OICI - данная ACE имеет тип "Явно задана", (т.е. НЕ унаследована от родительского объекта),
         т.к. НЕ содержит "ID". "CI" - настройки будут применены к папке и ее подпапкам;
         "OI" - настройки будут применены к папке и ее файлам. Если вы не хотите,
         чтобы настраиваемые права распространялись на более глубокий уровень,
         то укажите "NP" (NO PROPAGATE)
  "GA" - GENERIC_ALL - будут установлены разрешение на ПОЛНЫЙ ДОСТУП (независимо
         от типа объекта). Кроме того вы можете использовать флаги "GR" - доступ
         на чтение, "GW" - доступ на запись, "GX" - доступ на выполнение. Всего
         таких флагов в MSDN описано около 30, и их можно комбинировать.
  <Отсутствует> - какой-то GUID (см. MSDN)
  <Отсутствует> - какой-то GUID (см. MSDN)
  "WD" - WORLD (EVERYONE) - SID группы пользователей "ВСЕ"

  Другие "хорошо известные" SID:
  BA - локальные администраторы
  BU - локальные пользователи
  SY - LOCAL SYSTEM
  DU - пользователи домена
  PU - опытные пользователи
  CO - создатель-владелец
  и т.д.

  Для того, чтобы обеспечить полный доступ к заданному ключу реестра,
  воспользуйтесь следующим кодом:

  with TLDSSecurity.Create('MACHINE\SOFTWARE\Test', SE_REGISTRY_KEY) do
  try
    ObjectSetSecurityDescriptorFromString('D:PAI(A;OICI;GA;;;WD)', DACL_SECURITY_INFORMATION);
    // Либо ObjectSetAllowAllForEveryOne;
  finally
    Free;
  end;

  Кроме корневого ключа "MACHINE" (синоним HKEY_LOCAL_MACHINE) вы может
  использовать следующие ключи:
  - CURRENT_USER
  - CLASSES_ROOT
  - USERS


  Для того, чтобы выяснить информацию о владельце объекта, воспользуйтесь следующим кодом:

  var
    ADomainName, AccountName, StrSid, S: string;
    eUse: SID_NAME_USE;
    
  with TLDSSecurity.Create('c:\MyFile.txt', SE_FILE_OBJECT) do
  try
    ObjectGetOwner(ADomainName, AccountName, StrSid, eUse);
  finally
    Free;
  end;

  // Определение типа пользователя:
  StreUse := TLDSSecurity.SIDNameUseToString(eUse);

  Результат может быть следующим:
  ADomainName = BUILTIN
  AccountName = Администраторы
  StrSid      = S-1-5-32-544
  StreUse     = ALIAS  


}



unit LDSSecurityUnit;

interface

uses
  Windows, Messages, Classes, SysUtils, AccCtrl, AclAPI;

{$IF RTLVersion >= 20.00}
  {$DEFINE USEUNICODE}
{$IFEND}

const
  OWNER_SECURITY_INFORMATION =  $00000001;
  GROUP_SECURITY_INFORMATION =  $00000002;
  DACL_SECURITY_INFORMATION  =  $00000004;
  SACL_SECURITY_INFORMATION  =  $00000008;
  LABEL_SECURITY_INFORMATION =  $00000010;

  // Вся возможная информация. Параметр SACL_SECURITY_INFORMATION требует
  // дополнительных прав доступа, которыми должно обладать приложение.
  ALL_SECURITY_INFORMATION = OWNER_SECURITY_INFORMATION or GROUP_SECURITY_INFORMATION or
    DACL_SECURITY_INFORMATION or {SACL_SECURITY_INFORMATION or} LABEL_SECURITY_INFORMATION;

type
  PSID_NAME_USE = ^SID_NAME_USE;
  PPACL = ^PACL;

  TLDSSecurity = class(TObject)
  private
    FObjName: string;
    FObjType: SE_OBJECT_TYPE;

  public
    { Создает объект TLDSSecurity.
      Тип SE_OBJECT_TYPE объявлен в модуле AccCtrl }
    constructor Create(AObjName: string; AObjType: SE_OBJECT_TYPE);

    { Возвращает имя владельца объекта. Если файловая система FAT32, то
      в качестве владельца функция возвращает WELL_KNOWN_GROUP "Все" или
      "EveryOne" или "WORLD".
      Параметр SIDNameType - не обязательный.
      Используйте class-функцию SIDNameUseToString для того, чтобы преобразовать
      SIDNameType в строковый вид. }
    procedure ObjectGetOwner(var ADomainName, AccountName: string;
      var StrSid: string; var SIDNameType: SID_NAME_USE);

    { Функция для преобразования SIDNameType в строковый вид }
    class function SIDNameUseToString(SIDNameType: SID_NAME_USE): string;

    { Функция преобразует двоичное значение SID в строковый вид в формате S-R-I-S-S…
      Пример значения: S-1-5-21-1214440339-1078145449-1202660629-5648}
    class function ConvertSidToStringSid(Sid: PSID): string;

    { Возвращает описание SecurityDescriptor в текстовом виде }
    class function ConvertSecurityDescriptorToStringSecurityDescriptor(
      SecurityDescriptor: PSECURITY_DESCRIPTOR;
      SecurityInformation: SECURITY_INFORMATION = ALL_SECURITY_INFORMATION): string;

    { Преобразует текстовое описание SecurityDescriptor в рабочий вид.
      Возвращает указатель на созданную структуру SECURITY_DESCRIPTOR.
      После использования указателя память необходимо освободить
      в помощью функции LocalFree() }
    class function ConvertStringSecurityDescriptorToSecurityDescriptor(
      SDString: string): PSECURITY_DESCRIPTOR;

    { Для объекта, указанного при создании экземпляра данного класса (FObjName, FObjType)
      возвращает описание атрибутов безопасности в текстовом виде. Параметр
      SecurityInformation определяет тип запрашиваемых данных. По умолчанию
      запрашиваются только элементы списка DACL}
    function ObjectGetSecurityDescriptorAsString(
      SecurityInformation: SECURITY_INFORMATION = DACL_SECURITY_INFORMATION): string;

    { Для объекта, указанного при создании экземпляра данного класса (FObjName, FObjType)
      УСТАНАВЛИВАЕТ описание атрибутов безопасности, заданные в строке SDString. Параметр
      SecurityInformation определяет тип запрашиваемых данных. При установке
      разрешающих прав для каталога и вложенных папок и файлов ДОСТАТОЧНО указать
      разрешение для корневого каталога с использованием строки 'D:PAI(A;OICI;GA;;;WD)'
      Если же этого недостаточно, то вызовите данную функцию рекурсивно для каждого
      вложенного каталога и файла}
    procedure ObjectSetSecurityDescriptorFromString(SDString: string;
      SecurityInformation: SECURITY_INFORMATION = DACL_SECURITY_INFORMATION);

    { Для объекта, указанного при создании экземпляра данного класса (FObjName, FObjType)
      УСТАНАВЛИВАЕТ полный доступ для всех пользователей }
    procedure ObjectSetAllowAllForEveryOne;

    { Функция GetNamedSecurityInfo. Вызывает соответствующую функцию WINAPI.
      Учитывает проблемы, возникающие из-за неправильного объявления типа SE_OBJECT_TYPE.
      Тип объявлен как 1-байтовый, хотя на самом деле в функцию GetNamedSecurityInfo
      следует передавать 4-байтное значение. Из-за неправильного объявления возникают
      ошибки при работе программы, скомпилированной в D7 }
    class function GetNamedSecurityInfo(pObjectName: PChar;
      ObjectType: SE_OBJECT_TYPE; SecurityInfo: SECURITY_INFORMATION;
      psidOwner, psidGroup: PPSID; pDacl, pSacl: PPACL;
      ppSecurityDescriptor: PPSECURITY_DESCRIPTOR): DWORD;

    { Функция SetNamedSecurityInfo. Вызывает соответствующую функцию WINAPI. }
    class function SetNamedSecurityInfo(pObjectName: PChar;
      ObjectType: SE_OBJECT_TYPE; SecurityInfo: SECURITY_INFORMATION;
      psidOwner, psidGroup: PSID; pDacl, pSacl: PACL): DWORD;
  end;

const
  SID_NAME_USE_USER =               1;
  SID_NAME_USE_GROUP =              2;
  SID_NAME_USE_DOMAIN =             3;
  SID_NAME_USE_ALIAS =              4;
  SID_NAME_USE_WELL_KNOWN_GROUP =   5;
  SID_NAME_USE_DELETED_ACCOUNT =    6;
  SID_NAME_USE_INVALID =            7;
  SID_NAME_USE_UNKNOWN =            8;
  SID_NAME_USE_COMPUTER =           9;
  SID_NAME_USE_LABEL =             10;

  SDDL_REVISION_1 =                 1;

implementation

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

function ConvertSidToStringSid_(Sid: PSID; StrSid: PPChar): Boolean; stdcall;
  external 'ADVAPI32.DLL' name {$IFDEF USEUNICODE}'ConvertSidToStringSidW'{$ELSE}'ConvertSidToStringSidA'{$ENDIF};

function ConvertSecurityDescriptorToStringSecurityDescriptor_(
  SecurityDescriptor: PSECURITY_DESCRIPTOR;
  RequestedStringSDRevision: DWORD;
  SecurityInformation: SECURITY_INFORMATION;
  StringSecurityDescriptor: PPChar;
  StringSecurityDescriptorLen: PCardinal
): Boolean; stdcall; external 'ADVAPI32.DLL' name {$IFDEF USEUNICODE}'ConvertSecurityDescriptorToStringSecurityDescriptorW'{$ELSE}'ConvertSecurityDescriptorToStringSecurityDescriptorA'{$ENDIF};


function ConvertStringSecurityDescriptorToSecurityDescriptor_(
  StringSecurityDescriptor: PChar;
  StringSDRevision: DWORD;
  SecurityDescriptor: PPSECURITY_DESCRIPTOR;
  SecurityDescriptorSize: PCardinal
): Boolean; stdcall; external 'ADVAPI32.DLL' name {$IFDEF USEUNICODE}'ConvertStringSecurityDescriptorToSecurityDescriptorW'{$ELSE}'ConvertStringSecurityDescriptorToSecurityDescriptorA'{$ENDIF};


function GetNamedSecurityInfo_(
  pObjectName: PChar;
  //ObjectType: SE_OBJECT_TYPE; // Это НЕПРАВИЛЬНОЕ объявление!
  ObjectType: DWORD; // На самом деле WinAPI-функция GetNamedSecurityInfo ожидает 4-байтное значение
  SecurityInfo: SECURITY_INFORMATION;
  psidOwner: PPSID;
  psidGroup: PPSID;
  pDacl: PPACL;
  pSacl: PPACL;
  ppSecurityDescriptor: PPSECURITY_DESCRIPTOR
): DWORD; stdcall; external 'ADVAPI32.DLL' name {$IFDEF USEUNICODE}'GetNamedSecurityInfoW'{$ELSE}'GetNamedSecurityInfoA'{$ENDIF};


function SetNamedSecurityInfo_(
  pObjectName: PChar;
  //ObjectType: SE_OBJECT_TYPE; // Это НЕПРАВИЛЬНОЕ объявление!
  ObjectType: DWORD; // На самом деле WinAPI-функция SetNamedSecurityInfo ожидает 4-байтное значение
  SecurityInfo: SECURITY_INFORMATION;
  psidOwner: PSID;
  psidGroup: PSID;
  pDacl: PACL;
  pSacl: PACL
): DWORD; stdcall; external 'ADVAPI32.DLL' name {$IFDEF USEUNICODE}'SetNamedSecurityInfoW'{$ELSE}'SetNamedSecurityInfoA'{$ENDIF};


{ TLDSSecurity }

class function TLDSSecurity.ConvertSecurityDescriptorToStringSecurityDescriptor(
  SecurityDescriptor: PSECURITY_DESCRIPTOR;
  SecurityInformation: SECURITY_INFORMATION): string;
var
  StrSecDesc: PChar;
  SecLen: Cardinal;
begin
  SecLen := 0;
  StrSecDesc := nil;

  if not ConvertSecurityDescriptorToStringSecurityDescriptor_(SecurityDescriptor,
    SDDL_REVISION_1, SecurityInformation, @StrSecDesc, @SecLen) then
    raise Exception.Create('ConvertSecurityDescriptorToStringSecurityDescriptor -> ' + SysErrorMessage(GetLastError));

  SetString(Result, StrSecDesc, SecLen);

  if Assigned(StrSecDesc) then
    LocalFree(Cardinal(StrSecDesc));
end;

class function TLDSSecurity.ConvertSidToStringSid(Sid: PSID): string;
var
  psSID: PChar;
begin
  if not ConvertSidToStringSid_(Sid, @psSID) then
    raise Exception.Create('ConvertSidToStringSid -> ' + SysErrorMessage(GetLastError));
  Result := psSID;
  if Assigned(psSID) then
    LocalFree(Cardinal(psSID));
end;

class function TLDSSecurity.ConvertStringSecurityDescriptorToSecurityDescriptor(
  SDString: string): PSECURITY_DESCRIPTOR;
begin
  Result := nil;
  if not ConvertStringSecurityDescriptorToSecurityDescriptor_(
    PChar(SDString), SDDL_REVISION_1, @Result, nil) then
    raise Exception.Create('ConvertStringSecurityDescriptorToSecurityDescriptor -> ' + SysErrorMessage(GetLastError));
end;

constructor TLDSSecurity.Create(AObjName: string; AObjType: SE_OBJECT_TYPE);
begin
  FObjName := AObjName;
  FObjType := AObjType;
end;

procedure TLDSSecurity.ObjectGetOwner(var ADomainName, AccountName: string;
  var StrSid: string; var SIDNameType: SID_NAME_USE);
var
  pSD: PSECURITY_DESCRIPTOR;
  pSidOwner: PSID;
  dwRes: DWORD;
  dwAcctName, dwDomainName: Cardinal;
  AcctName, DomainName: array[0..255] of Char;
  bRtnBool: Boolean;
begin
  try
    pSidOwner := nil;
    pSD := nil;

    dwRes := GetNamedSecurityInfo(PChar(FObjName), FObjType, OWNER_SECURITY_INFORMATION, @pSidOwner, nil, nil, nil, @pSD);
    if dwRes <> ERROR_SUCCESS then
      raise Exception.Create('GetNamedSecurityInfo -> ' + SysErrorMessage(dwRes));

    try
      dwAcctName := 0;
      dwDomainName := 0;

      // Значения dwAcctName и dwDomainName слишком малы, поэтому функция вернет размер
      LookupAccountSid(nil, pSidOwner, AcctName, dwAcctName, DomainName, dwDomainName, SIDNameType);

      bRtnBool := LookupAccountSid(nil, pSidOwner, AcctName, dwAcctName, DomainName, dwDomainName, SIDNameType);

      if not bRtnBool then
        raise Exception.Create('LookupAccountSid -> ' + SysErrorMessage(GetLastError));


      ADomainName := string(DomainName);
      AccountName := string(AcctName);

      StrSid := ConvertSidToStringSid(pSidOwner);

    finally
      if Assigned(pSD) then
        LocalFree(Cardinal(pSD));
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ObjectGetOwner');
  end;
end;

function TLDSSecurity.ObjectGetSecurityDescriptorAsString(
  SecurityInformation: SECURITY_INFORMATION): string;
var
  pSD: PSECURITY_DESCRIPTOR;
  dwRes: DWORD;
begin
  try
    pSD := nil;
    dwRes := GetNamedSecurityInfo(PChar(FObjName), FObjType, SecurityInformation, nil, nil, nil, nil, @pSD);
    if dwRes <> ERROR_SUCCESS then
      raise Exception.Create('GetNamedSecurityInfo -> ' + SysErrorMessage(dwRes));

    try
      Result := ConvertSecurityDescriptorToStringSecurityDescriptor(pSD, SecurityInformation);
    finally
      if Assigned(pSD) then
        LocalFree(Cardinal(pSD));
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ObjectGetSecurityDescriptorAsString');
  end;
end;

procedure TLDSSecurity.ObjectSetAllowAllForEveryOne;
begin
  try
    ObjectSetSecurityDescriptorFromString('D:PAI(A;OICI;GA;;;WD)', DACL_SECURITY_INFORMATION);
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ObjectSetAllowAllForEveryOne');
  end;
end;

procedure TLDSSecurity.ObjectSetSecurityDescriptorFromString(SDString: string;
  SecurityInformation: SECURITY_INFORMATION);
var
  pSD: PSECURITY_DESCRIPTOR;

  psidOwner: PSID;
  psidGroup: PSID;
  pDacl: PACL;
  pSacl: PACL;

  lpbDaclPresent: BOOL;
  lpbDaclDefaulted: BOOL;
  lpbSaclPresent: BOOL;
  lpbSaclDefaulted: BOOL;

  lpbOwnerDefaulted: BOOL;
  lpbGroupDefaulted: BOOL;    

  dwRes: DWORD;
begin
  try
    psidOwner := nil;
    psidGroup := nil;
    pDacl := nil;
    pSacl := nil;

    pSD := ConvertStringSecurityDescriptorToSecurityDescriptor(SDString);
    try
      if SecurityInformation and DACL_SECURITY_INFORMATION = DACL_SECURITY_INFORMATION then
        if not GetSecurityDescriptorDacl(pSD, lpbDaclPresent, pDacl, lpbDaclDefaulted) then
          raise Exception.Create('GetSecurityDescriptorDacl -> ' + SysErrorMessage(GetLastError));

      if SecurityInformation and OWNER_SECURITY_INFORMATION = OWNER_SECURITY_INFORMATION then
        if not GetSecurityDescriptorOwner(pSD, psidOwner, lpbOwnerDefaulted) then
          raise Exception.Create('GetSecurityDescriptorOwner -> ' + SysErrorMessage(GetLastError));

      if SecurityInformation and GROUP_SECURITY_INFORMATION = GROUP_SECURITY_INFORMATION then
        if not GetSecurityDescriptorGroup(pSD, psidGroup, lpbGroupDefaulted) then
          raise Exception.Create('GetSecurityDescriptorGroup -> ' + SysErrorMessage(GetLastError));

      if SecurityInformation and SACL_SECURITY_INFORMATION = SACL_SECURITY_INFORMATION then
        if not GetSecurityDescriptorSacl(pSD, lpbSaclPresent, pSacl, lpbSaclDefaulted) then
          raise Exception.Create('GetSecurityDescriptorSacl -> ' + SysErrorMessage(GetLastError));

      dwRes := SetNamedSecurityInfo(PChar(FObjName), FObjType, SecurityInformation, psidOwner, psidGroup, pDacl, pSacl);

      if dwRes <> ERROR_SUCCESS then
        raise Exception.Create('SetNamedSecurityInfo -> ' + SysErrorMessage(dwRes));
    finally
      LocalFree(Cardinal(pSD));
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'ObjectSetSecurityDescriptorFromString');
  end;
end;

class function TLDSSecurity.SIDNameUseToString(SIDNameType: SID_NAME_USE): string;
begin
  case SIDNameType of
    SID_NAME_USE_USER:               Result := 'USER';
    SID_NAME_USE_GROUP:              Result := 'GROUP';
    SID_NAME_USE_DOMAIN:             Result := 'DOMAIN';
    SID_NAME_USE_ALIAS:              Result := 'ALIAS';
    SID_NAME_USE_WELL_KNOWN_GROUP:   Result := 'WELL KNOWN GROUP';
    SID_NAME_USE_DELETED_ACCOUNT:    Result := 'DELETED ACCOUNT';
    SID_NAME_USE_INVALID:            Result := 'INVALID';
    SID_NAME_USE_UNKNOWN:            Result := 'UNKNOWN';
    SID_NAME_USE_COMPUTER:           Result := 'COMPUTER';
    SID_NAME_USE_LABEL:              Result := 'SID_NAME_USE_LABEL';
  else
    Result := 'SID NAME IS UNSUPPORTED!';
  end;
end;

class function TLDSSecurity.GetNamedSecurityInfo(pObjectName: PChar;
  ObjectType: SE_OBJECT_TYPE;
  SecurityInfo: SECURITY_INFORMATION;
  psidOwner: PPSID;
  psidGroup: PPSID;
  pDacl: PPACL;
  pSacl: PPACL;
  ppSecurityDescriptor: PPSECURITY_DESCRIPTOR): DWORD;
begin
  Result := GetNamedSecurityInfo_(pObjectName, DWORD(ObjectType), SecurityInfo, psidOwner, psidGroup, pDacl, pSacl, ppSecurityDescriptor);
end;

class function TLDSSecurity.SetNamedSecurityInfo(
  pObjectName: PChar;
  ObjectType: SE_OBJECT_TYPE;
  SecurityInfo: SECURITY_INFORMATION;
  psidOwner: PSID;
  psidGroup: PSID;
  pDacl: PACL;
  pSacl: PACL
): DWORD;
begin
  Result := SetNamedSecurityInfo_(pObjectName, DWORD(ObjectType), SecurityInfo, psidOwner, psidGroup, pDacl, pSacl);
end;

end.
