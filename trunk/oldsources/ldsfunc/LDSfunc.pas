{
Copyright (c) 2005, Loginov Dmitry Sergeevich
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
{ Модуль LDSfunc содержит разнообразные функции, которые могут быть полезными }
{ при разработке приложений. В частности к ним относятся функции по копирован-}
{ ию и перемещению файлов и папок - здесь реализована возможность удобной     }
{ визуализации хода копирования (как к TotalCommander). Также в этом модуле   }
{ есть функция для поиска информации (текстовой, 16-ричной) в любых файлах    }
{ Вы имеете полное право скопировать в свое приложение любой участок кода.    }
{ Некоторые примеры были взяты из книжки Флёнова М. "Делфи глазами хакера"    }
{                                                                             }
{ (c) Логинов Д.С., 2004-2005                                                 }
{ http://matrix.kladovka.net.ru                                               }
{ e-mail: loginov_d@inbox.ru                                                  }
{*****************************************************************************}

unit LDSfunc;

interface
uses
  Windows,
  SysUtils, // Нужен для осуществления файловых операций
  Classes,  // Также нужен для операций над файлами  
  ShlObj, ShellAPI, Graphics, Registry,
  ActiveX, ComObj,  // Нужны для ярлыков
  WinSock;  // Для определения IP-имени

{ ********************  Как пользоваться константами *************************}
{ Все числовые константы начинаются с префикса (например PATH_DESKTOP содержит
  префикс PATH_). Некоторые функции модуля в качестве одного из аргументов
  имеют переменую, обозначающую тип возвращаемой информации. Ее название тоже
  может имееть префикс. Например, если эта переменная называется PATH_TYPE, то
  вместо нее можно подставить любую константу, имеющую такой же префикс       }

Const
  // Переменные окружения Windows
  // нужны для извлечения системных путей
  PATH_DESKTOP                       = $0000;  // Рабочий стол
  PATH_INTERNET                      = $0001;
  PATH_PROGRAMS                      = $0002;  // "Все программы"
  PATH_CONTROLS                      = $0003;  // ХЗ
  PATH_PRINTERS                      = $0004;
  PATH_PERSONAL                      = $0005;  // Мои документы
  PATH_FAVORITES                     = $0006;  // Избранное
  PATH_STARTUP                       = $0007;  // Автозагрузка
  PATH_RECENT                        = $0008;  // Ярлыки на недавние документы
  PATH_SENDTO                        = $0009;
  PATH_BITBUCKET                     = $000a;
  PATH_STARTMENU                     = $000b;  // Меню "Пуск"
  PATH_DESKTOPDIRECTORY              = $0010;  // Рабочий стол
  PATH_DRIVES                        = $0011;
  PATH_NETWORK                       = $0012;
  PATH_NETHOOD                       = $0013;
  PATH_FONTS                         = $0014;
  PATH_TEMPLATES                     = $0015;
  PATH_COMMON_STARTMENU              = $0016;
  PATH_COMMON_PROGRAMS               = $0017;
  PATH_COMMON_STARTUP                = $0018;
  PATH_COMMON_DESKTOPDIRECTORY       = $0019;
  PATH_APPDATA                       = $001a;
  PATH_PRINTHOOD                     = $001b;
  PATH_ALTSTARTUP                    = $001d;
  PATH_COMMON_ALTSTARTUP             = $001e;
  PATH_COMMON_FAVORITES              = $001f;
  PATH_INTERNET_CACHE                = $0020;
  PATH_COOKIES                       = $0021;
  PATH_HISTORY                       = $0022;
  PATH_TEMP                          = $0023; // My
  PATH_MYMUSIC_XP                    = $000d;
  PATH_MYGRAPHICS_XP                 = $0027;
  PATH_WINDOWS                       = $0024; // My
  PATH_SYSTEM                        = $0025; // My
  PATH_PROGRAMFILES                  = $0026; // My
  PATH_COMMONFILES                   = $002b; // My
  PATH_RESOURCES_XP                  = $0038;
  PATH_CURRENTUSER_XP                = $0028;

  // Константы для извлечения информации о процессоре
  CP_SPEED                           = $0001; // скорость
  CP_Identifier                      = $0002; // Стандартное название
  CP_NameString                      = $0003; // Понятное название
  CP_Usage                           = $0004; // Загрузка (adCpuUsage.pas)
  CP_VendorIdentifier                = $0005; // Производитель
  CP_MMXIdentifier                   = $0006; // Инф. о сопроцессоре
  CP_Count                           = $0007; // Кол-во процессоров (adCpuUsage)

  // Константы для извлечения информации о ОС
  OS_Version                         = $0001;
  OS_Platform                        = $0002;
  OS_Name                            = $0003;
  OS_Organization                    = $0004;
  OS_Owner                           = $0005;
  OS_SerNumber                       = $0006;
  OS_WinPath                         = $0007;
  OS_SysPath                         = $0008;
  OS_TempPath                        = $0009;
  OS_ProgramFilesPath                = $000a;
  OS_IPName                          = $000b;

  // Константы для извлечения информации о памяти
  MEM_TotalPhys                           = $0001;   // Всего физ. памяти
  MEM_AvailPhys                           = $0002;   // Свободно физ. памяти
  MEM_NotAvailPhys                        = $0003;   // Занять физ. памяти
  MEM_TotalPageFile                       = $0004;   // Файл подкачки
  MEM_AvailPageFile                       = $0005;
  MEM_NotAvailPageFile                    = $0006;
  MEM_TotalVirtual                        = $0007;   // Виртуальная память
  MEM_AvailVirtual                        = $0008;
  MEM_NotAvailVirtual                     = $0009;

  // Константы для извлечения информации о диске
  DI_TomLabel                             = $0001;
  DI_SerNumber                            = $0002;
  DI_FileSystem                           = $0003;
  DI_SectorsInClaster                     = $0004;
  DI_BytesInSector                        = $0005;
  DI_DiskSize                             = $0006;
  DI_DiskFreeSize                         = $0007;
  DI_DiskUsageSize                        = $0008;
  DI_MaximumLength                        = $0009; // Максимальная длина пути
  DI_TotalClasters                        = $000a;
  DI_FreeClasters                         = $000b;

  // Константы для извлечения информации о дисплее
  DS_BitsOnPixel                          = $0001;  // Разрядность цвета
  DS_HorPixelSize                         = $0002;  // Разреш. по горизонтали
  DS_VerPixelSize                         = $0003;  // Разреш. по вертикали
  DS_Frequency                            = $0004;  // Частота мерцаний (XP)
  DS_HorMMSize                            = $0005;  // Ширина в миллиметрах
  DS_VerMMSize                            = $0006;  // Высота в миллиметрах
  DS_PixelsOnInch_Hor                     = $0007;  // Пикселей на дюйм
  DS_PixelsOnInch_Ver                     = $0008;  // Пикселей на дюйм
  DS_ColorsInSysPalette                   = $0009;  // Цветов в сис. палитре

  // Константы для загрузки параметров окна из ини-файла
  WP_WindowState                         = $0001;
  WP_Top                                 = $0002;
  WP_Left                                = $0003;
  WP_Width                               = $0004;
  WP_Height                              = $0005;  
  

type

  { Вы можете объявить например следующую функцию:
    function DrawCopyProgress(Sour, Dest: String; CopyBytes, Size: DWORD;
    Speed: Real; FileNum, Files: Integer): Boolean;
    
    Аргументы следующие:
    - Sour - файл-источник,
    - Dest - файл-приемник,
    - CopyBytes - число скопированных байтов
    - Size - размер исходного файла,
    - Speed - скорость копирования,
    - FileNum - порядковый номер копируемого файла,
    - Files - общее число копируемых файлов
    
    Функция должна возвращать значение True. Если она вернет False, то 
    процесс копирования будет прерван. В дальнейшем функцию DrawCopyProgress
    нужно указывать в качестве необязательного параметра к функциям
    копирования или перемещения файлов и папок}
  TCopyFileProgress = function(Sour, Dest: String; CopyBytes, Size: DWORD;
    Speed: Real; FileNum, Files: Integer): Boolean;
    
  { Работает аналогично TCopyFileProgress, но передает число просмотренных 
    байт и размер файла. Используется при визуализации поиска в файле}
  TFindProgress = function(ByteNum, Bytes: Int64): Boolean;

  TLDSfunc = class(TObject)
  private
    LastSpeed: Real;
    function FileSetAttr(const FileName: string; Attr: Integer): Integer;
    function FileGetAttr(const FileName: string): Integer;
    function _GetDirList(DirName: String; var List: TStringList): DWORD;
    function _MixLists(var MasterList, DetailList: TStringList): DWORD;
    function _GetFileList(DirName: String; var List: TStringList): DWORD;
    function _GetFilesInfo(DirName: String; var CommonSize: Real): Integer;
    function _DelEmptyPath(DirName, LastDir: String): Boolean;
    procedure DoError(Msg: String);
  public
  
    (* Определяет размер файла в байтах *)
    function  FileSize(FileName: String): Integer;

    (* Копирует файл с поддержкой визуализации копирования. Необязательные
       параметры менять не нужно - они используются другими функциями *)
    function  FileCopy(Sour, Dest: String; VisProc: TCopyFileProgress = nil;
      FileNum: Integer = 1; Files: Integer = 1): Boolean;

    (* Перемещает файл с поддержкой визуализации копирования. Необязательные
       параметры менять не нужно - они используются другими функциями *)
    function  FileMove(Sour, Dest: String; VisProc: TCopyFileProgress = nil;
      FileNum: Integer = 1; Files: Integer = 1): Boolean;

    (* Осуществляет поиск информации в файле FileName вы можете в качестве
       строки поиска задать HEX-последовательность или текст, например:
       'aa bb ff'. TypeFind определяет тип поиска. При значении 1 ищется
       HEX-последовательность, при 2 ищется текст с учетом регистра, при 3
       ищется текст без учета регистра. Возвращает адес начала искомой
       информации. Поддерживает визуализацию процесса поиска  *)
    function  FindHexStringInFile(
      FileName: String;   // Имя файла
      HexString: String;  // Строка поиска (HEX-последовательность или текст)
      StartByte: DWORD;   // Откуда начинать поиск
      TypeFind: Byte;     // Тип поиска
      Func: TFindProgress = nil): DWORD;

    (* Создает полный путь FullPath. Будут созданы все необходимые каталоги *)
    function  CreateDir(FullPath: String; DirAttrib: DWORD = 0): Boolean;

    (* Копирование директории. Поддерживается визуализация процесса копирования *)
    function  DirCopy(DirSour, DirDest: String; LogFileName: String;
      VisProc: TCopyFileProgress = nil): Boolean;

    (* Перемещение директории. Поддерживается визуализация процесса копирования *)
    function  DirMove(DirSour, DirDest: String; LogFileName: String;
      VisProc: TCopyFileProgress = nil): Boolean;

    (* Удаление директории. Удаляются также все вложенные папки и файлы *)
    function  DirDelete(DirName: String; LogFileName: String = ''): Boolean;

    (* Возвращает системный путь *)
    function  GetSystemPath(Handle: THandle; PATH_type: WORD): String;

    (* Возвращает информацию о диске *)
    function  GetDiskInfo(DiskName: String; DI_typeinfo: Byte): String;

    (* Возвращает информацию о состоянии памяти *)
    function  GetMemoryInfo(MEM_typeinfo: Byte): DWORD;

    (* Возвращает информацию об операционной системы *)
    function  GetOSInfo(OS_typeinfo: Byte; Default: String): String;

    (* Определяет реальную частоту процессора *)
    function  GetCPUSpeed: Double;

    (* Возвращает информацию о процессоре *)
    function  GetProcessorInfo(CP_typeinfo: Byte;
      CP_NUM: Byte; Default: String): String;

    (* Возвращает информацию о мониторе *)
    function  GetDisplaySettings(DS_typeinfo: Byte): Integer;

    (* Меняет настройки монитора. Указывается нужный режим *)
    function  ChangeDisplayMode(ModeNum: Integer): Boolean;

    (* Определяет номер режим дисплея с указанными параметрами. Если
      AutoFind=True то можно указать только интересующие параметры,
      а остальные задать нулевыми (они не изменятся) *)
    function  GetDisplayModeNum(
      BitsColor: Byte;             // Разрядность пискелей (4,8,16,32)
      Dis_Width, Dis_Height: Word; // Ширина и высота
      Dis_Freq: Word; // Частота
      AutoFind: Boolean
      ): Integer;

    (* Определяет размер свободного места на диске *)
    function  GetFreeDiskSize(Root: String): Real;

    (* Определяет общий размер диска *)
    function  GetTotalDiskSize(Root: String): Real;

    (* Универсальная процедура по созданию ярлыка *)
    procedure CreateShotCut(SourceFile, ShortCutName,
      SourceParams: String);

    (* Создает ярлык в папке ПРОГРАММЫ меню ПУСК *)
    procedure CreateShotCut_InPrograms(RelationPath, FullExeName,
      SourceParams: String; Handle: THandle);

    (* Создает ярлык на рабочем столе *)
    procedure CreateShotCut_OnDesktop(FullExeName,
      SourceParams: String; Handle: THandle);

    (* Изменяет форму любого визуального компонента, имеющего св-во Handle
       в соответствии с указанным bmp-файлом *)
    function  CreateRgnFromBitmap(Handle: THandle; BmpFileName: TFileName): HRGN;

    (* Запуск файла на выполнение *)
    function  ExecuteFile
      (WND: HWND;
       const FileName,    // Имя запускаемого файла (с возможным путем доступа)
       Params,            // Передаваемые параметры
       DefaultDir: string;// Текущая директория для запускаемой программы
       ShowCmd: Integer   // Способ отображения окна запущенного файла
                ): THandle;

    (* Определение IP-имени данного компьютера *)
    function  GetIPName: String;

    (* Генерация ХЭШ-кода текста по алгоритму МД-5 *)
    function  md5(s: string):string;

    (* Правка HEX-строки *)
    function  StringToHex(HexStr: String): String;

    (* Исключение замыкающего Backslash (чтобы Делфи не ругался) *)
    function  ExcludeTrailingBackslash(const S: string): string;
  end;

var
  LDSf: TLDSfunc;

implementation

{ TLDSfunc }

function TLDSfunc.CreateDir(FullPath: String; DirAttrib: DWORD = 0): Boolean;
var
  List: TStringList;
  I, J, K, C: Integer;
begin
  K := 0;
  C := 0;
  Result := False;
  if not DirectoryExists(FullPath[1] + ':\') then Exit;
                                           
  if Length(FullPath)<4 then Exit;
  if not(((FullPath[1]>='A') and (FullPath[1]<='Z')) or
     ((FullPath[1]>='a') and (FullPath[1]<='z')))  then Exit;
  if (FullPath[2]<>':') or (FullPath[3]<>'\') then Exit;

  FullPath := ExcludeTrailingBackslash(FullPath) + '\';

  for I := 5 to Length(FullPath) do
    if FullPath[I] = '\' then Inc(C);
  // Теперь С хранить возможное количество путей для создания

  // Создаем список путей
  List :=TStringList.Create;
  for I:=0 to C-1 do  // Перебор возможных путей
  begin
    List.Append('');
    for J:=1 to Length(FullPath)   do // Формируем путь
    begin
      if (FullPath[J] = '\') and (J>4) and (J>K) then
      begin
        K := J;
        Break;
      end;
      List.Strings[I] := List.Strings[I]+ FullPath[J];
    end;
  end;      // Все пути сформированы

  //Теперь в цикле создаем директории
  for I := 0 to C-1 do
    if not DirectoryExists(List.Strings[I])  then
    try
      MkDir(List.Strings[I]);
    except
      MessageBox(GetActiveWindow,PChar('Невозможно создать директорию "'+
                 List.Strings[I]+'"'+#13#10+
         'Проверьте наличие устройства "'+AnsiUpperCase(FullPath[1])+':\"'),
         'Ошибка ввода/вывода',MB_OK or  MB_ICONSTOP or MB_TOPMOST);
      Exit;
    end;

  List.Free;     // Освобождаем память из-под объекта
  // Устанавливаем атрибуты конечной папки
  SetFileAttributes(PChar(FullPath), DirAttrib);

  Result := True;
end;

function TLDSfunc.DirCopy(DirSour, DirDest: String; LogFileName: String;
      VisProc: TCopyFileProgress = nil): Boolean;
var
  DirList,               //Хранит список всех возможных каталогов
  TempList: TStringList;
  C, K: DWORD;
  S: String;
  I, Files, FileNum: Integer;
  tf: TextFile;
  tk: DWORD;
  CommSize, Tmp: Real;
begin
  Result := False;
  if not DirectoryExists(DirSour)  then DoError('Директория-источник не найдена');
  if not DirectoryExists(DirDest[1]+':\')  then DoError('Накопитель-приемник не найдена');

  tk := GetTickCount;
  // Записываем в ЛОГ-файл информацию о начале сессии
  if LogFileName <> '' then
  begin
    if not FileExists(LogFileName) then
    begin
      AssignFile(tf, LogFileName);
      ReWrite(tf);
      CloseFile(tf);
    end;
    try
      AssignFile(tf, LogFileName);
      Append(tf);
      Writeln(tf,'' );
      Writeln(tf,'' );
      Writeln(tf,'**** НАЧАЛО СЕССИИ КОПИРОВАНИЯ: '+DateTimeToStr(Now)+' ****');
      Writeln(tf,'' );
    except
      DoError('Ошибка при создании файла отчета');
    end;
  end;

  DirList := TStringList.Create;
  TempList :=  TStringList.Create;

  if DirSour[Length(DirSour)] <> '\' then DirSour := DirSour+'\';
  if DirDest[Length(DirDest)] <> '\' then DirDest := DirDest+'\';

  // Создаем корневой каталог-приемник
  if not CreateDir(DirDest,0) then begin
    if LogFileName <> '' then CloseFile(tf);
    DoError('Не смог создать приемную директорию');
  end;

  C:= _GetDirList(DirSour,DirList); // Получаем первый список каталогов

  I:=0;
  If C > 0 then
  While true do
  begin
    TempList.Clear;
    _GetDirList(DirList.Strings[I],TempList);
    _MixLists(DirList,TempList);
    If I = DirList.Count-1 then Break;
    Inc(I);
  end;    // While

  DirList.Sort;
  FileNum := 0;
  Files := 0;
  CommSize := 0;
  if DirList.Count > 0 then
    for I := 0 to DirList.Count-1 do begin
      Files := Files + _GetFilesInfo(DirList[I], Tmp);
      CommSize := CommSize + Tmp;
    end;
  Files := Files + _GetFilesInfo(DirSour, Tmp);
  CommSize := CommSize + Tmp;
  if CommSize > GetFreeDiskSize(DirDest[1]) then begin
    if LogFileName <> '' then CloseFile(tf);
    DoError('Не хватает дисковой памяти для копирования директории');
  end;

  // Создаем каталоги из списка на получателе
  if  DirList.Count>0 then
  for I := 0 to DirList.Count-1 do
  begin
     S := Copy(DirList.Strings[I], Length(DirSour)+1,
          Length(DirList.Strings[I])-Length(DirSour)+1);
     // Cоздает нужный каталог
     if not
     CreateDir(DirDest+S,GetFileAttributes(PChar(DirList.Strings[I])))
     then begin
       if LogFileName <> '' then CloseFile(tf);
       DoError('Не смог создать приемную директорию');
     end;
  end;

  // Копируем файлы
  if  DirList.Count>0 then
  for I := 0 to DirList.Count-1 do
  begin
    TempList.Clear;
    C:= _GetFileList(DirList.Strings[I],TempList);
    if C>0 then
    for K:=0 to C-1 do
    begin
      S := Copy(DirList.Strings[I], Length(DirSour)+1,
          Length(DirList.Strings[I])-Length(DirSour)+1);
      if LogFileName <> '' then
      Write(tf,TimeToStr(Time)+' --Copy-- '+
      DirList.Strings[I]+'\'+TempList.Strings[K]+' --> '+
      DirDest+S+'\'+TempList.Strings[K]);
      Inc(FileNum);
      try
        if not FileCopy(DirList.Strings[I]+'\'+TempList.Strings[K],
          DirDest+S+'\'+TempList.Strings[K], VisProc, FileNum, Files) then begin
           if LogFileName <> '' then CloseFile(tf);
           Exit;
          end;
      except
        if MessageBox(GetActiveWindow,'Произошла ошибка при работе с файлами'+
        #13#10+'Продолжить со следующего файла?', 'Предупреждение',
        MB_YESNO or MB_ICONEXCLAMATION) = IDNO	then begin
          if LogFileName <> '' then CloseFile(tf);
          Exit;
        end;
      end;
      if LogFileName <> '' then
      WriteLn(tf,' --OK-- ');
    end;
  end;

  // Теперь делаем, чтобы копировались файлы из самой выбранной папки
  C:= _GetFileList(DirSour,TempList);

  if C > 0 then
  for I := 0 to C-1 do
  begin
    S := DirDest+TempList.Strings[I];  // Куда копируем
    if LogFileName <> '' then
    Write(tf,TimeToStr(Time)+' --Copy-- '+
       DirSour+TempList.Strings[I]+' --> '+
       S);
    Inc(FileNum);
    try
     if not FileCopy(DirSour+TempList.Strings[I],S, VisProc, FileNum, Files) then begin
       if LogFileName <> '' then CloseFile(tf);
       Exit;
     end;
    except
        if MessageBox(GetActiveWindow,'Произошла ошибка при работе с файлами'+
        #13#10+'Продолжить со следующего файла?', 'Предупреждение',
        MB_YESNO or MB_ICONEXCLAMATION) = IDNO	then begin
          if LogFileName <> '' then CloseFile(tf);
          Exit;
        end;
     end;
    if LogFileName <> '' then
    WriteLn(tf,' --OK-- ');
  end;
  DirList.Free;
  TempList.Free;
  if LogFileName <> '' then
  begin
    WriteLn(tf,'');
    WriteLn(tf,'**** Время сессии: '+TimeToStr((Gettickcount-tk)*
    StrToTime('00:00:01')/1000)+ ' ****');
    WriteLn(tf,'');
    CloseFile(tf);
  end;
  Result := True;
end;

procedure TLDSfunc.DoError(Msg: String);
begin
  raise Exception.Create(Msg);
end;

function TLDSfunc.ExcludeTrailingBackslash(const S: string): string;
begin
  Result := ExcludeTrailingPathDelimiter(S);
end;

function TLDSfunc.FileCopy(Sour, Dest: String; VisProc: TCopyFileProgress = nil;
      FileNum: Integer = 1; Files: Integer = 1): Boolean;
var
  ArrayRead: Array[1..8192] Of Byte;
  FP_Read,FP_Write : TFileStream;
  fSize, I: Integer;
  sfHandle: HFile;
  fTime, CurIter: Integer;
  PartTime, Speed: Real;
  Tc, Delta: Cardinal;
begin
  Result := False;
  if not DirectoryExists(ExtractFileDir(Dest)) then DoError('Директории не существует');
  if not FileExists(Sour) then DoError('Файл не найден');
  if Dest = Sour then begin  Result := True;  Exit; end;
 
  if FileExists(Dest) then
  begin
    FileSetAttr(Dest, 0); // Сбрасываем все атрибуты, чтобы можно было удалить
    DeleteFile(Dest);
  end;

  try
    FP_Read := TFileStream.Create(Sour,fmOpenRead);
    fSize := FP_Read.Size;
    FP_Write := TFileStream.Create(Dest,fmCreate);
  except
    DoError('Невозможно получить доступ к файлу.'+
            ' Возможно он используется другим приложением'); Exit;
  end;

  CurIter := 0;
  Tc := GetTickCount;
  while FP_Read.Position < FSize do
  begin
   Inc(CurIter);
   //  код для обработки сообщений  закончен
   I := FSize-FP_Read.Position;
   if  I >= 8192  then
   begin
     FP_Read.Read(ArrayRead,8192);
     FP_Write.Write(ArrayRead,8192);
   end else
   begin
     FP_Read.Read(ArrayRead,I);
     FP_Write.Write(ArrayRead,I);
   end;

  // Через каждые пол секунды выполняем визуализацию
  if (@VisProc <> nil) and ((GetTickCount - Tc > 500) or
    (FP_Read.Position = fSize)) then
    begin
      Delta := GetTickCount - Tc;
      PartTime := Delta / 1000;
      if Delta < 50 then Speed := LastSpeed else
        Speed := CurIter * 8192 / PartTime;
      LastSpeed := Speed;
      Tc := GetTickCount;
      CurIter := 0;
      if VisProc(Sour, Dest, FP_Read.Position, fSize, Speed, FileNum,
        Files) = False then begin
          FP_Read.Free;
          FP_Write.Free;
          if FileExists(Dest) then DeleteFile(Dest);
          Exit;
      end;
    end;
  end;
  FP_Read.Free;
  FP_Write.Free;
  // Устанавливает атрибуты
  sfHandle:=_lopen(PChar(Sour), OF_READ);
  fTime:=FileGetDate(sfHandle);
  _lclose(sfHandle);
  FileSetDate(Dest,fTime);
  FileSetAttr(Dest, FileGetAttr(Sour));
  Result := True;
end;

function TLDSfunc.FileGetAttr(const FileName: string): Integer;
begin
  Result := GetFileAttributes(PChar(FileName));
end;

function TLDSfunc.FileMove(Sour, Dest: String; VisProc: TCopyFileProgress = nil;
      FileNum: Integer = 1; Files: Integer = 1): Boolean;
var
  FullDest: String;
begin
  Result := True;
  FullDest:= ExpandFileName(Dest);
  if Sour = FullDest then Exit;
  if not DirectoryExists(FullDest[1]+':\') then DoError('Имя приемника задано неверно');
  if not FileExists(Sour) then DoError('Исходный файл не был найден');
  // Если диск один, то можно переименовать старый файл
  if not RenameFile(Sour, FullDest) then
  begin
    FileCopy(Sour, FullDest, VisProc, FileNum, Files);
    FileSetAttr(Sour,0);
    DeleteFile(Sour);
  end;
end;

function TLDSfunc.FileSetAttr(const FileName: string;
  Attr: Integer): Integer;
begin
  Result := 0;
  if not SetFileAttributes(PChar(FileName), Attr) then
    Result := GetLastError;
end;

function TLDSfunc.FileSize(FileName: String): Integer;
var
   F: HFile;      // Для расчета размера
begin
  Result := 0;
  if not FileExists(FileName) then Exit;
  F:=_lopen(PChar(FileName), OF_READ);
  Result :=_llseek(F,0, FILE_END);   
  _lclose(F);
end;

function TLDSfunc._GetDirList(DirName: String;
  var List: TStringList): DWORD;
var
  FS: TSearchRec;
  Path: String;
begin
  if DirName[Length(DirName)]<>'\' then DirName := DirName+'\';
  Path := DirName+'*.*';
  List.Clear;
  List.Sort;
  if FindFirst(Path, faAnyFile, FS)=0 then
  begin
    if (DirectoryExists(DirName+FS.Name))
    and ((FS.Name<>'.') and (FS.Name<>'..')) then
    List.Append(DirName+FS.Name);
    while FindNext(FS)=0 do
    begin
      if (DirectoryExists(DirName+FS.Name))
       and ((FS.Name<>'.') and (FS.Name<>'..'))
        then
      List.Append(DirName+FS.Name);
    end;
    FindClose(FS);
  end;
  Result := List.Count;
end;

function TLDSfunc._GetFilesInfo(DirName: String; var CommonSize: Real): Integer;
var
  FS: TSearchRec;
  Path: String;
begin
  if DirName[Length(DirName)]<>'\' then DirName := DirName+'\';
  Path := DirName+'*.*';
  Result := 0;
  CommonSize := 0;
  if FindFirst(Path, $00000020, FS)=0 then
  begin
    Inc(Result);
    CommonSize := CommonSize + FS.Size;
    while FindNext(FS)=0 do begin
      CommonSize := CommonSize + FS.Size;
      Inc(Result);
    end;
    FindClose(FS);
  end; 
end;

function TLDSfunc._GetFileList(DirName: String;
  var List: TStringList): DWORD;
var
  FS: TSearchRec;
  Path: String;
begin
  if DirName[Length(DirName)]<>'\' then DirName := DirName+'\';
  Path := DirName+'*.*'; 
  List.Clear;
  if FindFirst(Path, $00000020, FS)=0 then
  begin
    List.Append(FS.Name);
    while FindNext(FS)=0 do
    begin 
      List.Append(FS.Name);
    end;
    FindClose(FS);
  end;
  Result := List.Count;    
end;

function TLDSfunc._MixLists(var MasterList,
  DetailList: TStringList): DWORD;
var D, C: DWORD;
begin
  C :=DetailList.Count;
  if C<>0 then
  for D := 0 to C-1 do
    MasterList.Append(DetailList.Strings[D]);

  Result := MasterList.Count;
end;

function TLDSfunc.GetDiskInfo(DiskName: String; DI_typeinfo: Byte): String;
var
  lpRootPathName:  PChar;
  lpVolumeNameBuffer: PChar;
  nVolumeNameSize: DWORD;
  lpVolumeSerialNumber: DWORD;
  lpMaximumComponentLength: DWORD;
  lpFileSystemFlags: DWORD;
  lpFileSystemNameBuffer: PChar;
  nFileSystemNameSize: DWORD;
  FSectorsPerCluster: DWORD;
  FBytesPerSector   : DWORD;
  FFreeClusters     : DWORD;
  FTotalClusters    : DWORD;

begin
  DiskName := DiskName[1];
  if not DirectoryExists(DiskName+':\') then
  begin
    Result := '0';
    Exit;
  end;
  lpVolumeSerialNumber    := 0;
  lpMaximumComponentLength:= 0;
  lpFileSystemFlags       := 0;
  GetMem(lpVolumeNameBuffer, MAX_PATH + 1);
  GetMem(lpFileSystemNameBuffer, MAX_PATH + 1);
  nVolumeNameSize := MAX_PATH + 1;
  nFileSystemNameSize := MAX_PATH + 1;
  lpRootPathName := PChar(DiskName+':\');
  if  GetVolumeInformation( lpRootPathName, lpVolumeNameBuffer,
      nVolumeNameSize, @lpVolumeSerialNumber, lpMaximumComponentLength,
      lpFileSystemFlags, lpFileSystemNameBuffer, nFileSystemNameSize ) then
  begin
    GetDiskFreeSpace( PChar(DiskName+':\'),
      FSectorsPerCluster, FBytesPerSector,  FFreeClusters, FTotalClusters);
  case DI_typeinfo of
    DI_SerNumber: Result:=IntToHex(HIWord(lpVolumeSerialNumber), 4) + '-' +
       IntToHex(LOWord(lpVolumeSerialNumber), 4);
    DI_TomLabel: Result := lpVolumeNameBuffer;
    DI_FileSystem:Result := lpFileSystemNameBuffer;
    DI_SectorsInClaster:Result := IntToStr(FSectorsPerCluster);
    DI_BytesInSector: Result := IntToStr(FBytesPerSector);
    DI_MaximumLength: Result := IntToStr(lpMaximumComponentLength);
    DI_DiskFreeSize: Result := FloatToStr(GetFreeDiskSize(DiskName));
    DI_DiskSize: Result := FloatToStr(GetTotalDiskSize(DiskName));
    DI_DiskUsageSize: Result := FloatToStr(GetTotalDiskSize(DiskName)-
       GetFreeDiskSize(DiskName));
    DI_TotalClasters: Result := IntToStr(FTotalClusters);
    DI_FreeClasters: Result := IntToStr(FFreeClusters);
  end;   // Case
  end;   // If
  FreeMem(lpVolumeNameBuffer);
  FreeMem(lpFileSystemNameBuffer);
end;

function TLDSfunc.GetFreeDiskSize(Root: String): Real;
begin
  Result := 0;
  if not DirectoryExists(Root[1]+':\') then Exit;
  Root := UpperCase(Root);
  Result := DiskFree(Ord(Root[1]) - 64 );
end;

function TLDSfunc.GetTotalDiskSize(Root: String): Real;
begin
  Result := 0;
  if not DirectoryExists(Root[1]+':\') then Exit;
  Root := UpperCase(Root);
  Result := DiskSize(Ord(Root[1]) - 64 ); 
end;

function TLDSfunc.DirMove(DirSour, DirDest, LogFileName: String;
  VisProc: TCopyFileProgress): Boolean;
begin
  Result := False;
  if not DirectoryExists(DirSour)  then Exit;
  if not DirectoryExists(DirDest[1]+':\')  then Exit;
  if  DirSour = DirDest  then
  begin
    Result := True;
    Exit;
  end;
  if not CreateDir(DirDest,0) then Exit; // Создаем полный путь
  if not RemoveDir(DirDest) then Exit;        // Удаляем последний каталог

  // Если указан существующий каталог, то функция пытается переместить файлы
  // в него, однако если в нем уже есть к.-л. файлы, то работа функции
  // прерывается (возвращается False)

  // Если источник и приемник находятся на одном диске,
  // то попытаемся переименовать источник в приемник

  if not RenameFile(DirSour, DirDest) then
  begin
    DirCopy(DirSour, DirDest,LogFileName, VisProc);
    DirDelete(DirSour, LogFileName);
  end;
  Result:=True;
end;

function TLDSfunc.DirDelete(DirName: String; LogFileName: String = ''): Boolean;
var
  tf: TextFile;
  tk: DWORD;
  DirList,               //Хранит список всех возможных каталогов
  TempList: TStringList;
  C, K: DWORD;
  I: Integer;
begin
  Result := True;
  if not DirectoryExists(DirName)  then Exit;
  tk := GetTickCount;
   // Записываем в ЛОГ-файл информацию о начале сессии
  if LogFileName <> '' then
  begin
    if not FileExists(LogFileName) then
    begin
      AssignFile(tf, LogFileName);
      ReWrite(tf);
      CloseFile(tf);
    end;
    AssignFile(tf, LogFileName);
    Append(tf);
    Writeln(tf,'' );
    Writeln(tf,'' );
    Writeln(tf,'**** НАЧАЛО СЕССИИ УДАЛЕНИЯ: '+DateTimeToStr(Now)+' ****');
    Writeln(tf,'' );
  end;  // if
  DirList := TStringList.Create;
  TempList :=  TStringList.Create;
  if DirName[Length(DirName)] <> '\' then DirName := DirName+'\';
  C:= _GetDirList(DirName,DirList); // Получаем первый список каталогов
  I:=0;
  If C > 0 then
  While true do
  begin
    TempList.Clear;
    _GetDirList(DirList.Strings[I],TempList);
    _MixLists(DirList,TempList);
    If I=DirList.Count-1 then Break;
    Inc(I);
  end;    // While
    // Теперь нам известны все пути  для удаления
  DirList.Sort;
  DirList.Append(ExcludeTrailingBackslash(DirName)); // Добавляем  корневой каталог в конец списка
  // Начинаем удаление файлов из всех каталогов
  if DirList.Count>0 then
  for I := 0 to DirList.Count - 1 do
  begin
    // Получаем список файлов для текущего каталога
    C := _GetFileList(DirList.Strings[I], TempList);
    if C > 0 then
    for K := 0 to C-1 do
    begin
      if LogFileName <> '' then
      Write(tf,TimeToStr(Time)+' --Delete-- '+
        DirList.Strings[I]+'\'+TempList.Strings[K]);
      SetFileAttributes(PChar(DirList.Strings[I]+'\'+TempList.Strings[K]),0);

      if DeleteFile(PChar(DirList.Strings[I]+'\'+TempList.Strings[K])) then
        if LogFileName <> '' then
          WriteLn(tf,' --OK--') else WriteLn(tf,' --NO--');
    end;
  end;    
  // Теперь удаляем сами каталоги
  if DirList.Count >0 then
  for I := 0 to DirList.Count-1 do
  begin
    // Здесь возникает проблема из-за того, что удалять каталоги
    // нужно по порядку - от дочернего к родительскому
    _DelEmptyPath(DirList.Strings[I], DirName) ;
  end;
  if LogFileName <> '' then
  begin
     WriteLn(tf,'');
     WriteLn(tf,'**** Время сессии: '+TimeToStr((Gettickcount-tk)*
     StrToTime('00:00:01')/1000)+ ' ****');
     WriteLn(tf,'');
     CloseFile(tf);
  end;
  if DirectoryExists(DirName) then Result := False else Result := True;
  DirList.Free;
  TempList.Free;
end;

function TLDSfunc._DelEmptyPath(DirName, LastDir: String): Boolean;
var
  DirList, TempList: TStringList;
  I: DWORD;
begin
  Result := False;
  if not DirectoryExists(DirName) then Exit;
  DirName:=ExcludeTrailingBackslash(DirName)+'\';
  LastDir:=ExcludeTrailingBackslash(LastDir)+'\';
  DirList:= TStringList.Create;
  TempList:= TStringList.Create;
  if Length(DirName)<5 then Exit;
  if Length(LastDir)>Length(DirName) then Exit;
  for I := Length(DirName) downto Length(LastDir)+1 do
  begin
    if DirName[I]='\' then
    DirList.Append(Copy(DirName,1,I-1));
  end;
  // Добавляем последнюю директорию
  DirList.Append(ExcludeTrailingBackslash(LastDir));
  if DirList.Count > 0 then
  for I := 0 to  DirList.Count  - 1 do  
     if _GetDirList(DirList.Strings[I], TempList) = 0 then
     begin
        FileSetAttr(DirList.Strings[I],0);
        RemoveDir(DirList.Strings[I]);
     end;
  Result := True;
  DirList.Free;
  TempList.Free;
end;

function TLDSfunc.GetMemoryInfo(MEM_typeinfo: Byte): DWORD;
var
 MemInfo : TMemoryStatus;
begin
  Result := 0;
  MemInfo.dwLength := Sizeof (MemInfo);
  GlobalMemoryStatus (MemInfo);
  Case MEM_typeinfo of
    MEM_TotalPhys: Result := MemInfo.dwTotalPhys;
    MEM_AvailPhys : Result := MemInfo.dwAvailPhys;
    MEM_NotAvailPhys : Result := MemInfo.dwTotalPhys-MemInfo.dwAvailPhys;
    MEM_TotalPageFile: Result := MemInfo.dwTotalPageFile;
    MEM_AvailPageFile : Result := MemInfo.dwAvailPageFile;
    MEM_NotAvailPageFile : Result := MemInfo.dwTotalPageFile-MemInfo.dwAvailPageFile;
    MEM_TotalVirtual: Result := MemInfo.dwTotalVirtual;
    MEM_AvailVirtual: Result := MemInfo.dwAvailVirtual;
    MEM_NotAvailVirtual : Result := MemInfo.dwTotalVirtual-MemInfo.dwAvailVirtual;
  end;                                                                               
end;

function TLDSfunc.GetDisplaySettings(DS_typeinfo: Byte): Integer;
var
  DC: HDC;
begin
  Result := 0;
  DC := GetDC(0); // Канва Десктопа всегда 0
  Case DS_typeinfo of
    DS_BitsOnPixel  : Result := GetDeviceCaps(DC, BITSPIXEL);
    DS_HorPixelSize : Result := GetDeviceCaps(DC, HORZRES);
    DS_VerPixelSize : Result := GetDeviceCaps(DC, VERTRES);
    DS_Frequency    : Result := GetDeviceCaps(DC, VREFRESH);
    DS_HorMMSize    : Result := GetDeviceCaps(DC, HORZSIZE);
    DS_VerMMSize    : Result := GetDeviceCaps(DC, VERTSIZE);
    DS_PixelsOnInch_Hor:Result  := GetDeviceCaps(DC, LOGPIXELSX);
    DS_PixelsOnInch_Ver:Result  := GetDeviceCaps(DC, LOGPIXELSY);
    DS_ColorsInSysPalette:Result:= GetDeviceCaps(DC, SIZEPALETTE);
  end;
end;

function TLDSfunc.ChangeDisplayMode(ModeNum: Integer): Boolean;
var
  Mode:  TDevMode;
begin
  Result := False;
  if EnumDisplaySettings(nil, ModeNum, Mode) then begin
  Mode.dmFields := DM_BITSPERPEL or
    DM_PELSWIDTH or DM_PELSHEIGHT or DM_DISPLAYFLAGS
    or DM_DISPLAYFREQUENCY;
  ChangeDisplaySettings(Mode, CDS_UPDATEREGISTRY);
  Result := True;
  end;
end; 

function TLDSfunc.GetDisplayModeNum(BitsColor: Byte; Dis_Width, Dis_Height,
  Dis_Freq: Word; AutoFind: Boolean): Integer;
var
  modes: array[0..255] of TDevMode;
  I: Integer;
begin
  Result := -1;
  if not AutoFind then
    if (BitsColor=0)or (Dis_Width=0)or(Dis_Height=0) or (Dis_Freq=0) then Exit;
  if AutoFind then
  begin
    if BitsColor = 0  then BitsColor:=GetDisplaySettings(DS_BitsOnPixel);
    if Dis_Width = 0  then Dis_Width:=GetDisplaySettings(DS_HorPixelSize);
    if Dis_Height = 0 then Dis_Height:=GetDisplaySettings(DS_VerPixelSize);
  end;
  I:=0;
  while EnumDisplaySettings(nil, I, Modes[I]) do
  begin  
    if (BitsColor=modes[I].dmBitsPerPel) AND
      (Dis_Width=modes[I].dmPelsWidth)  AND
      (Dis_Height=modes[I].dmPelsHeight) then
       if (AutoFind AND (Dis_Freq = 0)) or (Dis_Freq=modes[I].dmDisplayFrequency) 
         then Result := I; 
    Inc(I);
  end;
end;

function TLDSfunc.md5(s: string): string;
var
  a:array[0..15] of byte;
  i:integer;
  LenHi, LenLo: longword;
  Index: DWord;
  HashBuffer: array[0..63] of byte;
  CurrentHash: array[0..3] of DWord;

  procedure Burn;
  begin
    LenHi:= 0; LenLo:= 0;
    Index:= 0;
    FillChar(HashBuffer,Sizeof(HashBuffer),0);
    FillChar(CurrentHash,Sizeof(CurrentHash),0);
  end;

  procedure Init;
  begin
    Burn;
    CurrentHash[0]:= $67452301;
    CurrentHash[1]:= $efcdab89;
    CurrentHash[2]:= $98badcfe;
    CurrentHash[3]:= $10325476;
  end;

  function LRot32(a, b: longword): longword;
  begin
    Result:= (a shl b) or (a shr (32-b));
  end;

 procedure Compress;
 var
   Data: array[0..15] of dword;
   A, B, C, D: dword;
 begin
   Move(HashBuffer,Data,Sizeof(Data));
   A:= CurrentHash[0];
   B:= CurrentHash[1];
   C:= CurrentHash[2];
   D:= CurrentHash[3];

   A:= B + LRot32(A + (D xor (B and (C xor D))) + Data[ 0] + $d76aa478,7);
   D:= A + LRot32(D + (C xor (A and (B xor C))) + Data[ 1] + $e8c7b756,12);
   C:= D + LRot32(C + (B xor (D and (A xor B))) + Data[ 2] + $242070db,17);
   B:= C + LRot32(B + (A xor (C and (D xor A))) + Data[ 3] + $c1bdceee,22);
   A:= B + LRot32(A + (D xor (B and (C xor D))) + Data[ 4] + $f57c0faf,7);
   D:= A + LRot32(D + (C xor (A and (B xor C))) + Data[ 5] + $4787c62a,12);
   C:= D + LRot32(C + (B xor (D and (A xor B))) + Data[ 6] + $a8304613,17);
   B:= C + LRot32(B + (A xor (C and (D xor A))) + Data[ 7] + $fd469501,22);
   A:= B + LRot32(A + (D xor (B and (C xor D))) + Data[ 8] + $698098d8,7);
   D:= A + LRot32(D + (C xor (A and (B xor C))) + Data[ 9] + $8b44f7af,12);
   C:= D + LRot32(C + (B xor (D and (A xor B))) + Data[10] + $ffff5bb1,17);
   B:= C + LRot32(B + (A xor (C and (D xor A))) + Data[11] + $895cd7be,22);
   A:= B + LRot32(A + (D xor (B and (C xor D))) + Data[12] + $6b901122,7);
   D:= A + LRot32(D + (C xor (A and (B xor C))) + Data[13] + $fd987193,12);
   C:= D + LRot32(C + (B xor (D and (A xor B))) + Data[14] + $a679438e,17);
   B:= C + LRot32(B + (A xor (C and (D xor A))) + Data[15] + $49b40821,22);

   A:= B + LRot32(A + (C xor (D and (B xor C))) + Data[ 1] + $f61e2562,5);
   D:= A + LRot32(D + (B xor (C and (A xor B))) + Data[ 6] + $c040b340,9);
   C:= D + LRot32(C + (A xor (B and (D xor A))) + Data[11] + $265e5a51,14);
   B:= C + LRot32(B + (D xor (A and (C xor D))) + Data[ 0] + $e9b6c7aa,20);
   A:= B + LRot32(A + (C xor (D and (B xor C))) + Data[ 5] + $d62f105d,5);
   D:= A + LRot32(D + (B xor (C and (A xor B))) + Data[10] + $02441453,9);
   C:= D + LRot32(C + (A xor (B and (D xor A))) + Data[15] + $d8a1e681,14);
   B:= C + LRot32(B + (D xor (A and (C xor D))) + Data[ 4] + $e7d3fbc8,20);
   A:= B + LRot32(A + (C xor (D and (B xor C))) + Data[ 9] + $21e1cde6,5);
   D:= A + LRot32(D + (B xor (C and (A xor B))) + Data[14] + $c33707d6,9);
   C:= D + LRot32(C + (A xor (B and (D xor A))) + Data[ 3] + $f4d50d87,14);
   B:= C + LRot32(B + (D xor (A and (C xor D))) + Data[ 8] + $455a14ed,20);
   A:= B + LRot32(A + (C xor (D and (B xor C))) + Data[13] + $a9e3e905,5);
   D:= A + LRot32(D + (B xor (C and (A xor B))) + Data[ 2] + $fcefa3f8,9);
   C:= D + LRot32(C + (A xor (B and (D xor A))) + Data[ 7] + $676f02d9,14);
   B:= C + LRot32(B + (D xor (A and (C xor D))) + Data[12] + $8d2a4c8a,20);

   A:= B + LRot32(A + (B xor C xor D) + Data[ 5] + $fffa3942,4);
   D:= A + LRot32(D + (A xor B xor C) + Data[ 8] + $8771f681,11);
   C:= D + LRot32(C + (D xor A xor B) + Data[11] + $6d9d6122,16);
   B:= C + LRot32(B + (C xor D xor A) + Data[14] + $fde5380c,23);
   A:= B + LRot32(A + (B xor C xor D) + Data[ 1] + $a4beea44,4);
   D:= A + LRot32(D + (A xor B xor C) + Data[ 4] + $4bdecfa9,11);
   C:= D + LRot32(C + (D xor A xor B) + Data[ 7] + $f6bb4b60,16);
   B:= C + LRot32(B + (C xor D xor A) + Data[10] + $bebfbc70,23);
   A:= B + LRot32(A + (B xor C xor D) + Data[13] + $289b7ec6,4);
   D:= A + LRot32(D + (A xor B xor C) + Data[ 0] + $eaa127fa,11);
   C:= D + LRot32(C + (D xor A xor B) + Data[ 3] + $d4ef3085,16);
   B:= C + LRot32(B + (C xor D xor A) + Data[ 6] + $04881d05,23);
   A:= B + LRot32(A + (B xor C xor D) + Data[ 9] + $d9d4d039,4);
   D:= A + LRot32(D + (A xor B xor C) + Data[12] + $e6db99e5,11);
   C:= D + LRot32(C + (D xor A xor B) + Data[15] + $1fa27cf8,16);
   B:= C + LRot32(B + (C xor D xor A) + Data[ 2] + $c4ac5665,23);

   A:= B + LRot32(A + (C xor (B or (not D))) + Data[ 0] + $f4292244,6);
   D:= A + LRot32(D + (B xor (A or (not C))) + Data[ 7] + $432aff97,10);
   C:= D + LRot32(C + (A xor (D or (not B))) + Data[14] + $ab9423a7,15);
   B:= C + LRot32(B + (D xor (C or (not A))) + Data[ 5] + $fc93a039,21);
   A:= B + LRot32(A + (C xor (B or (not D))) + Data[12] + $655b59c3,6);
   D:= A + LRot32(D + (B xor (A or (not C))) + Data[ 3] + $8f0ccc92,10);
   C:= D + LRot32(C + (A xor (D or (not B))) + Data[10] + $ffeff47d,15);
   B:= C + LRot32(B + (D xor (C or (not A))) + Data[ 1] + $85845dd1,21);
   A:= B + LRot32(A + (C xor (B or (not D))) + Data[ 8] + $6fa87e4f,6);
   D:= A + LRot32(D + (B xor (A or (not C))) + Data[15] + $fe2ce6e0,10);
   C:= D + LRot32(C + (A xor (D or (not B))) + Data[ 6] + $a3014314,15);
   B:= C + LRot32(B + (D xor (C or (not A))) + Data[13] + $4e0811a1,21);
   A:= B + LRot32(A + (C xor (B or (not D))) + Data[ 4] + $f7537e82,6);
   D:= A + LRot32(D + (B xor (A or (not C))) + Data[11] + $bd3af235,10);
   C:= D + LRot32(C + (A xor (D or (not B))) + Data[ 2] + $2ad7d2bb,15);
   B:= C + LRot32(B + (D xor (C or (not A))) + Data[ 9] + $eb86d391,21);

   Inc(CurrentHash[0],A);
   Inc(CurrentHash[1],B);
   Inc(CurrentHash[2],C);
   Inc(CurrentHash[3],D);
   Index:= 0;
   FillChar(HashBuffer,Sizeof(HashBuffer),0);
 end;


 procedure Update(const Buffer; Size: longword);
 var
  PBuf: ^byte;
 begin
   Inc(LenHi,Size shr 29);
   Inc(LenLo,Size*8);
   if LenLo< (Size*8) then
     Inc(LenHi);

   PBuf:= @Buffer;
   while Size> 0 do
   begin
    if (Sizeof(HashBuffer)-Index)<= DWord(Size) then
    begin
      Move(PBuf^,HashBuffer[Index],Sizeof(HashBuffer)-Index);
      Dec(Size,Sizeof(HashBuffer)-Index);
      Inc(PBuf,Sizeof(HashBuffer)-Index);
      Compress;
    end
    else
    begin
      Move(PBuf^,HashBuffer[Index],Size);
      Inc(Index,Size);
      Size:= 0;
    end;
   end;
 end;

 procedure Final(var Digest);
 begin
   HashBuffer[Index]:= $80;
   if Index>= 56 then Compress;
   PDWord(@HashBuffer[56])^:= LenLo;
   PDWord(@HashBuffer[60])^:= LenHi;
   Compress;
   Move(CurrentHash,Digest,Sizeof(CurrentHash));
   Burn;
 end;

begin
  Init;
  Update(s[1],Length(s));
  Final(a);
  result:='';
  for i:=0 to 15 do
    result:=result+IntToHex(a[i],2);
  Burn;
end;   

procedure TLDSfunc.CreateShotCut(SourceFile, ShortCutName,
  SourceParams: String);
var
  IUnk: IUnknown;
  ShellLink: IShellLink;
  ShellFile: IPersistFile;
  tmpShortCutName: string;
  WideStr: WideString;
  i: Integer;
begin
  IUnk := CreateComObject(CLSID_ShellLink);
  ShellLink := IUnk as IShellLink;
  ShellFile  := IUnk as IPersistFile;

  ShellLink.SetPath(PChar(SourceFile));
  ShellLink.SetArguments(PChar(SourceParams));
  ShellLink.SetWorkingDirectory(PChar(ExtractFilePath(SourceFile)));

  ShortCutName := ChangeFileExt(ShortCutName,'.lnk');
  if fileexists(ShortCutName) then
  begin
    ShortCutName := copy(ShortCutName,1,length(ShortCutName)-4);
    i := 1;
    repeat
      tmpShortCutName := ShortCutName +'(' + inttostr(i)+ ').lnk';
      inc(i);
    until not fileexists(tmpShortCutName);
    WideStr := tmpShortCutName;
  end
  else
    WideStr := ShortCutName;
  ShellFile.Save(PWChar(WideStr),False);
end;

procedure TLDSfunc.CreateShotCut_InPrograms(RelationPath, FullExeName,
  SourceParams: String; Handle: THandle);
var
 WorkTable, LinkName:String;
 P:PItemIDList;
 C:array [0..1000] of char;
begin
  if SHGetSpecialFolderLocation(Handle,CSIDL_PROGRAMS,p)=NOERROR then
  begin
   SHGetPathFromIDList(P,C);
   WorkTable:=StrPas(C)+'\'+RelationPath;
  end;     
  if not DirectoryExists(WorkTable) then
    CreateDir(WorkTable,0);
  LinkName := ExtractFileName(FullExeName);
  LinkName := Copy(LinkName, 1, Length(LinkName)-Length(ExtractFileExt(LinkName)));
  LinkName := LinkName+'.lnk';
  if FileExists(WorkTable+'\'+ExtractFileName(LinkName)) then
    DeleteFile(WorkTable+'\'+ExtractFileName(LinkName));
  CreateShotCut(FullExeName, WorkTable+'\'+ExtractFileName(FullExeName),
    SourceParams);
end;

procedure TLDSfunc.CreateShotCut_OnDesktop(FullExeName,
  SourceParams: String; Handle: THandle);
var
 WorkTable, LinkName:String;
 P:PItemIDList;
 C:array [0..1000] of char;
begin
  if SHGetSpecialFolderLocation(Handle,CSIDL_DESKTOP,p)=NOERROR then
  begin
   SHGetPathFromIDList(P,C);
   WorkTable:=StrPas(C);
  end;
  LinkName := ExtractFileName(FullExeName);
  LinkName := Copy(LinkName, 1, Length(LinkName)-Length(ExtractFileExt(LinkName)));
  LinkName := LinkName+'.lnk';
  if FileExists(WorkTable+'\'+ExtractFileName(LinkName)) then
    DeleteFile(WorkTable+'\'+ExtractFileName(LinkName));
  CreateShotCut(FullExeName, WorkTable+'\'+ExtractFileName(FullExeName),
    SourceParams);
end;

function TLDSfunc.ExecuteFile(WND: HWND; const FileName, Params,
  DefaultDir: string; ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(WND,nil,
  StrPCopy(zFileName, FileName),StrPCopy(zParams, Params),
  StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function TLDSfunc.CreateRgnFromBitmap(Handle: THandle;
  BmpFileName: TFileName): HRGN;
var
  TransColor: TColor;
  i, j: Integer;
  i_width, i_height: Integer;
  i_left, i_right: Integer;
  rectRgn: HRGN;
  rgnBitmap: TBitmap;
begin
  Result := 0;
  rgnBitmap:=TBitmap.Create;
  rgnBitmap.LoadFromFile(BmpFileName);
  i_width := rgnBitmap.Width;
  i_height := rgnBitmap.Height;
  transColor := rgnBitmap.Canvas.Pixels[0, 0];
  for i := 0 to i_height - 1 do
  begin
    i_left := -1;
    for j := 0 to i_width - 1 do
    begin
      if i_left < 0 then
      begin
        if rgnBitmap.Canvas.Pixels[j, i] <> transColor then
          i_left := j;
      end
      else
      if rgnBitmap.Canvas.Pixels[j, i] = transColor then
      begin
        i_right := j;
        rectRgn := CreateRectRgn(i_left, i, i_right, i + 1);
        if Result = 0 then
         Result := rectRgn
        else
        begin
          CombineRgn(Result, Result, rectRgn, RGN_OR);
          DeleteObject(rectRgn);
        end;
        i_left := -1;
      end;
    end;
    if i_left >= 0 then
    begin
      rectRgn := CreateRectRgn(i_left, i, i_width, i + 1);
      if Result = 0 then
        Result := rectRgn
      else
      begin
        CombineRgn(Result, Result, rectRgn, RGN_OR);
        DeleteObject(rectRgn);
      end;
    end;
  end;
  rgnBitmap.Free;
  SetWindowRgn(Handle, Result, True);
end;

function TLDSfunc.GetOSInfo(OS_typeinfo: Byte; Default: String): String;
var
   OSVersion: TOSVersionInfo;
   RegFile: TRegIniFile;
begin
  Result := Default;
  RegFile:=TRegIniFile.Create('Software');
  OSVersion.dwOSVersionInfoSize:=SIZEOF(OSVersion);

  if GetVersionEx(OSVersion) then
  begin
    if OS_typeinfo=OS_Version then  // Получаем версию
      Result:= Format('%d.%d (%d.%s)',[OSVersion.dwMajorVersion,
        OSVersion.dwMinorVersion,(OSVersion.dwBuildNumber and $FFFF),
        OSVersion.szCSDVersion]);

    if OS_typeinfo=OS_Platform then  // Получаем название платформы
    case OSVersion.dwPlatformID of
      VER_PLATFORM_WIN32s:        Result := 'Windows 3.1';
      VER_PLATFORM_WIN32_WINDOWS: Result := 'Windows 95';{для 98-го то-же самое}
      VER_PLATFORM_WIN32_NT:      Result := 'Windows NT';
      else                        Result := '';
    end;
  end;

  RegFile.RootKey := HKEY_LOCAL_MACHINE;
  RegFile.OpenKey('SOFTWARE', false);
  RegFile.OpenKey('Microsoft', false);
  RegFile.OpenKey('Windows', false);
  case OS_typeinfo of
    OS_Name: Result:= RegFile.ReadString('CurrentVersion','ProductName',Default);

    OS_Organization: Result:= RegFile.ReadString('CurrentVersion',
                      'RegisteredOrganization',Default);
    OS_Owner: Result:=RegFile.ReadString('CurrentVersion','RegisteredOwner',Default);
    OS_SerNumber: Result :=RegFile.ReadString('CurrentVersion','ProductId',Default);
    OS_WinPath: Result:=GetSystemPath(0, PATH_WINDOWS);
    OS_SysPath: Result:=GetSystemPath(0, PATH_SYSTEM);
    OS_TempPath: Result:=GetSystemPath(0, PATH_TEMP);
    OS_ProgramFilesPath: Result:=GetSystemPath(0, PATH_PROGRAMFILES);
    OS_IPName: Result := GetIPName;
  end;
  RegFile.CloseKey;
  RegFile.Free;
end;

function TLDSfunc.GetSystemPath(Handle: THandle; PATH_type: WORD): String;
var
  P:PItemIDList;
  C:array [0..1000] of char;
  PathArray:array [0..255] of char;
begin
  if PATH_type = PATH_TEMP then
  begin
    FillChar(PathArray,SizeOf(PathArray),0);
    ExpandEnvironmentStrings('%TEMP%', PathArray, 255);
    Result := Format('%s',[PathArray])+'\';
    Exit;
  end;

  if PATH_type = PATH_WINDOWS then
  begin
    FillChar(PathArray,SizeOf(PathArray),0);
    GetWindowsDirectory(PathArray,255);
    Result := Format('%s',[PathArray])+'\';
    Exit;
  end;

  if PATH_type = PATH_SYSTEM then
  begin
    FillChar(PathArray,SizeOf(PathArray),0);
    GetSystemDirectory(PathArray,255);
    Result := Format('%s',[PathArray])+'\';
    Exit;
  end;

  if (PATH_type = PATH_PROGRAMFILES) or(PATH_type = PATH_COMMONFILES) then
  begin
    FillChar(PathArray,SizeOf(PathArray),0);
    ExpandEnvironmentStrings('%ProgramFiles%', PathArray, 255);
    Result := Format('%s',[PathArray])+'\';
    if Result[1] = '%' then
    begin
      FillChar(PathArray,SizeOf(PathArray),0);
      GetSystemDirectory(PathArray,255);
      Result := Format('%s',[PathArray]);
      Result := Result[1]+':\Program Files\';
    end;
    if (PATH_type = PATH_COMMONFILES) then Result := Result+'Common Files\';
    Exit;
  end;

  if SHGetSpecialFolderLocation(Handle,PATH_type,p)=NOERROR then
  begin
    SHGetPathFromIDList(P,C);
    if   StrPas(C)<>'' then
      Result := StrPas(C)+'\' else  Result:='';
  end;
end;

function TLDSfunc.FindHexStringInFile(FileName, HexString: String;
  StartByte: DWORD; TypeFind: Byte; Func: TFindProgress = nil): DWORD;
var
  FS: TFileStream;
  PosInFile: DWORD;
  BufferArray: Array[1..8192] of Byte;
  InputArray: Array[1..1000] of Byte;
  InputArrayAdd: Array[1..1000] of Byte;
  ReadSize: WORD;
  InputArrayLength: WORD;
  fSize, CurByte, I: DWORD;
  ToEnd: DWORD;
  StartByteToRead: DWORD;
  C: WORD;
  S1,S2: String;
begin
  // Если TypeFind = 1, то будет HEX-последовательность
  // Если TypeFind = 2, то будет искать текст по точному совпадению
  // Если TypeFind = 3, то будет искать текст без учета регистра
  Result := $FFFFFFFF;  // Такой будет результат в случае неудачи
  InputArrayLength := 0; 
  if (FileName = '')  or (TypeFind < 1) or (TypeFind > 3) then Exit;
  if not FileExists(FileName) then Exit;

  // Если ищем HEX-последовательность
  if TypeFind = 1 then  begin
    HexString := StringToHex(HexString);
    if Length(HexString) mod 2 <> 0 then
      Delete(HexString,Length(HexString),1);
    if HexString='' then Exit;
    InputArrayLength := Length(HexString) div 2;
    for I := 1 to  InputArrayLength  do
     InputArray[I]:=StrToInt('$'+Copy(HexString, I * 2 - 1, 2));
  end;

  // Если ищем текст с учетом регистра
  if (TypeFind = 2) then  begin
    if HexString='' then Exit;
    InputArrayLength:=Length(HexString);
    for I:=1 to InputArrayLength  do
      InputArray[I] := Ord(HexString[I]);
  end;

  // Если ищем текст без учета регистра
  if (TypeFind = 3) then  begin
    if HexString='' then Exit;
    InputArrayLength:=Length(HexString);
    for I:=1 to InputArrayLength  do  begin
      S1 := AnsiUpperCase(HexString[I]);
      S2 := AnsiLowerCase(HexString[I]);
      InputArray[I] := Ord(S1[1]);
      InputArrayAdd[I] := Ord(S2[1]);
    end;
  end;

  // Мы перевели входящие данные в массив данных, что облегчит дальнейшую
  // обработку
  fSize:=FileSize(FileName);
  if fSize=0 then Exit;
  PosInFile := StartByte;
  C:=0;

  // Открывает указанный файл для чтения
  FS := TFileStream.Create(FileName, fmOpenRead,fmShareDenyWrite);
  FS.Seek(StartByte, soFromBeginning);
  while FS.Position < fSize do begin
    if (FS.Position - InputArrayLength > PosInFile) then begin
      StartByteToRead := FS.Position - InputArrayLength;
      FS.Seek(StartByteToRead, soFromBeginning);
    end;
    ToEnd := fSize-FS.Position;
    if ToEnd >= 8192 then ReadSize := 8192 else ReadSize := ToEnd;
    PosInFile := FS.Position;
    FS.Read(BufferArray, ReadSize);
    Inc(C);
    if C > 100 then begin
      C := 0;
      if @Func <> nil then
        if not Func(FS.Position, FS.Size) then Break; 
    end;

    CurByte := 0;
    if TypeFind in [1, 2] then
    while CurByte < ReadSize do begin
      Inc(CurByte);
      if (BufferArray[CurByte] = InputArray[1])

      then begin
        if InputArrayLength = 1 then begin
          Result := FS.Position - (ReadSize - CurByte) - 1;
          FS.Free;
          Exit;
        end;   
        for I := 2 to InputArrayLength do begin
           if BufferArray[CurByte + I - 1] <> InputArray[I] then Break;
           if I=InputArrayLength then begin
             Result := FS.Position - (ReadSize - CurByte) - 1;
             FS.Free;
             Exit;
           end;
        end;
      end;
    end;

  if TypeFind = 3 then
    while CurByte < ReadSize do begin
      Inc(CurByte);
      if (BufferArray[CurByte] = InputArray[1])  or
         (BufferArray[CurByte] = InputArrayAdd[1])
      then begin
        if InputArrayLength = 1 then begin
          Result := FS.Position-(ReadSize-CurByte)-1;
          FS.Free;
          Exit;
        end;
        for I := 2 to InputArrayLength do begin
          if (BufferArray[CurByte+I-1]<>InputArray[I]) and
             (BufferArray[CurByte+I-1]<>InputArrayAdd[I])
             then Break;
           if I=InputArrayLength then begin
             Result := FS.Position - (ReadSize - CurByte) - 1;
             FS.Free;
             Exit;
           end;
        end;
      end;
    end;
  end;
  FS.Free;
end;

function TLDSfunc.StringToHex(HexStr: String): String;
var
  I: WORD;
  HexSet: Set of '0'..'f' ;
begin
  HexSet := ['0'..'9','a'..'f','A'..'F'];      
  if HexStr = '' then Exit;
  // Отфильтровываем все знаки, оставляем только 16-ричные знаки
  for I:=1 to Length(HexStr) do
    if HexStr[I] in  HexSet   then Result := Result + HexStr[I];    
end;

function TLDSfunc.GetProcessorInfo(CP_typeinfo, CP_NUM: Byte;
  Default: String): String;
var
  RegFile: TRegIniFile;
begin
  Result := Default;
  if  CP_typeinfo = CP_SPEED then
  begin
    Result := IntToStr(Round(GetCPUSpeed));
    Exit;
  end;   
  RegFile:=TRegIniFile.Create('Software');
  RegFile.RootKey := HKEY_LOCAL_MACHINE;
  RegFile.OpenKey('hardware', false);
  RegFile.OpenKey('DESCRIPTION', false);
  RegFile.OpenKey('System', false);
  RegFile.OpenKey('CentralProcessor', false);
  case CP_typeinfo of
    CP_Identifier        :Result := RegFile.ReadString(IntToStr(CP_NUM),
                          'Identifier', Default);
    CP_NameString        :Result := RegFile.ReadString(IntToStr(CP_NUM),
                          'ProcessorNameString', Default);
    CP_VendorIdentifier  :Result := RegFile.ReadString(IntToStr(CP_NUM),
                          'VendorIdentifier', Default);
    CP_MMXIdentifier     :Result := RegFile.ReadString(IntToStr(CP_NUM),
                          'MMXIdentifier', Default);
    else Exit;
  end;
  RegFile.CloseKey;
  RegFile.Free;
end;

function TLDSfunc.GetCPUSpeed: Double;
const
  DelayTime = 500;
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
    dw 310Fh
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    dw 310Fh
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Result := TimerLo / (1000.0 * DelayTime);
end;

function TLDSfunc.GetIPName: String;
var
  szHostName: array [0..255] of Char;
  wsdata : TWSAData;
begin
  WSAStartup ($0101, wsdata);
  gethostname(szHostName, sizeof(szHostName));
  Result := szHostName; 
  WSACleanup;
end;


initialization
  LDSf := TLDSfunc.Create;
finalization
  LDSf.Free;
end.
