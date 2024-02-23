{
Copyright (c) 2007-2024, Loginov Dmitry Sergeevich
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

{$IFDEF FPC}
{$MODE DELPHI}{$H+}{$CODEPAGE UTF8}
{$ENDIF}

{ *************************************************************************** }
{                                                                             }
{                                                                             }
{                                                                             }
{ Модуль LDSLogger - модуль для ведения логов                                 }
{ (c) 2007-2024 Логинов Дмитрий Сергеевич                                     }
{ Последнее обновление: 23.02.2024                                            }
{ Адрес сайта: http://www.loginovprojects.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{Выполняет надежное потокобезопасное логгирование текстовых данных
 с возможностью ограничения LOG-файла как по размеру, так и по времени, и с
 использованием метода переименования старых LOG-файлов. Доступ к файлу лога
 защищен именованным мьютексом, что позволяет организовать одновременную запись
 информации в лог несколькими приложениями и потоками. Логгер обладает высокой
 устойчивостью в ситуациях, когда в любой момент времени файл лога может быть
 открыт посторонними приложениями (в том числе с блокировкой на запись).
 Это достигается с помощью разработанной функции WaitAndCreateLogFileStream().
 Любая ошибка, возникающая при открытии файла, при записи в файл, при обработке
 файла, пишется в лог "%TEMP%\LDSLoggerErrorsWriter.log".
 С помощью свойства NotifyHandle можно зарегистрировать Handle окна, и в этом
 случае после записи в лог с помощью PostMessage окну будет послано сообщение
 LOGGER_NOTIFY_MESSAGE (свойство NotifyMessage позволяет установить любое сообщение).
 Получив данное сообщение, оконная процедура должна загрузить подготовленные логгером
 данные с помощью метода GetListBufferText() и обработать эти данные как
 ей угодно. Строковый буфер при этом хранит по умолчанию до 5000 строк (это
 значение можно изменить с помощью свойства ListBufferMaxCount).
 Логгер позволяет изменить формат даты и времени, вывести в лог ID процесса и
 потока, символы событий и наименования событий, префикс сообщения DefaultPrefix.
 Логгер позволяет запретить либо разрешить вывод любого сообщения в лог с
 помощью свойства UsedLogTypes. Для полного запрета на вывод в лог используйте
 Enabled := False либо UsedLogTypes := [].

 При использовании режима TLDSLogger.UseListBuffer := True можно оперативно
 (по таймеру) отображать информацию в компоненте TMemo с помощью такого кода:
  procedure TForm1.tmUpdateMemoTimer(Sender: TObject);
  begin
    if ALog.WriteListBufferToStrings(memResult.Lines) then
      memResult.Perform(EM_LINESCROLL, 0, memResult.Lines.Count - 1);
  end;
  При вызове Perform с параметром EM_LINESCROLL произойдет автоматическая прокрутка
  содержимого TMemo к последней строке.

 {Перечень изменений
  20.05.2008
   - добавлена поддержка директивы условной компиляции UseResStr

  22.05.2008
   - добавлена функция TranslateLoggerMessages()

  29.08.2008
   - сообщения об ошибке теперь более компактные, и в лог можно записать
     больше полезной информации, чем раньше.
   - закомментирован вызов функции Beep(). Она не давала работать, если пользователь
     умышленно устанавливал логу атрибут ReadOnly. При этом приложение могло
     заметно тормозить. К тому же на новых компьютерах динамик зачастую не ставят.
   - переработана функция WaitAndCreateLogFileStream(). Задержка между повторами
     открытия файла теперь составляет 10 мс вместо 20 мс, и вызывается она теперь
     только в случае, если файл действительно занят другим процессом. При других
     же ошибках сразу выполняется регенерация исключения без всякой задержки.

  30.08.2008
   - реализован механизм контроля файла лога по времени. Добавлено свойство
     DateTimeTrimInterval, определяющее, в течение какого периода данные должны
     храниться в файле. В зависимости от ClearOldLogData выполняется либо
     очистка файла, либо переименование логов.
   - процедуры Lock и UnLock перенесены в секцию Public. Благодаря этому вы
     можете в любой момент выполнить собственную обработку лога не опасаясь
     за возможность одновременного доступа к файлу
   - функция WaitAndCreateLogFileStream вынесена в секцию Interface.
     более полная версия данной функции находится в Matrix32.

  31.08.2008
   - переработана функция ProcessFile(). Избавились от TMemoryStream. Теперь
     дла логгера размер файла значения не имеет. Тестирование выполнялось на
     старом IDE-винчестере с FAT-32. Обработка файла размером 1 Мбайт занимает
     0 мс, 5 МБайт - 16 мс, 10 МБайт - 47 мс, 20 МБайт - 1047 мс, 50 МБайт - 2500 мс.
     (в действительности размер нужно увеличить на треть, т.е. вместо 50 МБайт
     обрабатывался файл 70 МБайт и т.д.)

  22.08.2009
   - добавлена поддержка директивы условной компиляции LDSLoggerMutexExclusive.
     Теперь одновременную запись в лог могут вести приложения, запущенные под
     разными учетными записями. Раньше в таких случаях только первое запущенное
     приложение могло вести запись в лог. При запуске второго приложения под
     другой учетной записью при попытке записи в лог выдавалась ошибка
     создания объекта "мьютекс" (отказано в доступе). Проверено в Windows XP.
   - добавлена переменная LDSCanRaiseMutexError. Она по умолчанию = False, т.е.
     исключение не генерируется при ошибки создания мьютекса.

   21.11.2009
    - модуль адаптирован для работы с Unicode-версиями Delphi (протестирован на D2010).
      Для этого пришлось внести небольшие исправления всего-лишь в двух/трех местах.
      Формат файлов логов не изменился (данные пишутся в однобайтной кодировке Ansi).
      Для обеспечения записи в лог строк Unicode необходимо внести изменения в функции
      CheckLogTime, ProcessFile, LogStr (команда Fs.Write).

   28.09.2010
     - исправлена ошибка в методе ProcessFile. Процесс поиска места для обрезки файла
       мог привести к зависанию программы.

   15.02.2013
     - добавлено свойство LazyWrite, благодаря которому возможна "отложенная" запись
       информации в лог. Добавлена директива компиляции LDSLoggerLazy, разрешающая
       отложенную запись в лог сразу для всех объектов, используемых в проекте.
       ОСТОРОЖНО! Если модуль LDSLogger.pas находится в DLL-библиотеке, то не забывайте
       выгружать данную библиотеку в том случае, если вы её загружали с помощью
       LoadLibrary. В противном случае поток отложенной записи может "неожиданно"
       исчезать.

   13.03.2013
     - добавлен заголовок свободной лицензии BSD 2

   05.10.2016
     - значительно ускорена (более чем в 10 раз) запись в лог-файлы при использовании режима LazyWrite
     - добавлена Call-back функция LDSOnWriteToFile, которая вызывается каждый раз после записи в лог-файл.

   24.12.2021
     - произведена замена названия метода GetStringListBufferText на GetListBufferText
     - добавлено свойство UseListBuffer. Если оно равно True, то при вызове метода LogStr
       строки будут добавляться в буфер FStringListBuffer, из которого можно затем прочитать строки с помощью
       GetListBufferText либо WriteListBufferToStrings (например, по событию TTimer.OnTimer).
       По умолчанию максимальное кол-во строк в буфере равно 5000 (можно менять).
       При интенсивной записи в лог выгоднее считывать строки из буфера по таймеру, а не
       по обработчику, срабатывающему на PostMessage.
     - запись в буфер FStringListBuffer теперь выполняется сразу (при вызове LogStr), а не после фактической
       записи в лог-файл
     - пробелы в начале сообщения теперь не отсекаются (в декаративных целях)
     - повышена надежность уничтожения потока LazyWriteThread в секции finalization

   10.06.2022
     - исправлена ошибка преждевременного завершения потока TLazyWriteThread (при Terminated=True сразу
       происходил выход из цикла без проверки очереди сообщений). В некоторых случаях это могло
       приводить к ошибке Access Violation (при выходе из программы), при этом последние сообщения
       могли не записаться в лог-файл
 }


{Определяет, в каком виде хранить текстовые константы: в resourcestring или String.
 Первый способ позволяет использовать для локализации приложения средство
 Translation Manager. Второй способ позволяет выполнить локализацию иными способами,
 например, с помощью авторской библиотеки LangReader.pas}
{.$DEFINE UseResStr}

{Определяет, должен ли созданный объект "мьютекс" быть эксклюзивным (т.е. работать
 только для одной учетной записи), либо с ним могут работать приложения, запущенные
 одновременно под разными учетными записями пользователей. По умолчанию директива
 отключена, т.е. мьютекс находится в общем доступе. Если ваша операционная система
 по каким-то причинам отказывается создавать объект "мьютекс" в таком режиме, то
 включите директиву LDSLoggerMutexExclusive (можно в опциях проекта) }
{.$DEFINE LDSLoggerMutexExclusive}

unit LDSLogger;

interface

uses
{$IFnDEF FPC}
  Windows, Messages,
{$ELSE}
  {$IFDEF WINDOWS}Windows, {$ENDIF}LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Classes, SyncObjs, DateUtils, IniFiles, WideStrUtils;

type
  TLDSLogType = (tlpNone, tlpInformation, tlpError, tlpCriticalError, tlpWarning,
    tlpEvent, tlpDebug, tlpOther);
    
  TLDSLogTypes = set of TLDSLogType;

  {TODO : пока не ясно что делать с типом "string" для Delphi2009.}

  TLDSLogger = class(TObject)
  private
    FCritSect: TCriticalSection;
    FBufferCS: TCriticalSection;
    {$IFDEF MSWINDOWS}
    FMutexHandle: THandle;
    {$ENDIF}
    FFileName: string;
    FMaxFileSize: Int64;
    FClearOldLogData: Boolean;
    FEnabled: Boolean;
    FDefaultPrefix: string;
    FCanWriteThreadID: Boolean;
    FCanWriteProcessID: Boolean;
    FDateTimeFormat: string;
    FCanWriteLogSymbols: Boolean;
    FCanWriteLogWords: Boolean;
    FUseMutex: Boolean;
    FMaxOldLogFileCount: Integer;
    FRenameFilesMode: Integer;

    FIsErrorWriter: Boolean;
    FUsedLogTypes: TLDSLogTypes;
    FStringListBuffer: TStringList;
    FNotifyHandle: THandle;
    FNotifyMessage: Cardinal;
    FListBufferMaxCount: Integer;
    FDateTimeTrimInterval: TDateTime;
    FLastCheckTime: TDateTime;
    FLazyWrite: Boolean;
    FLazyWriteCounter: Integer; // Количество строк, ожидающих запись в лог 

    FFinalStrings: TStringList; // Подготовленные строки для ускоренной пакетной записи
    FUseListBuffer: Boolean;
    FUseUTF8: Boolean;

    {Генерирует имя мьютекса}
    function GenerateMutexName: string;

    procedure SetFileName(Value: string);

    {Выполняет обработку файла, связанную в превышением допустимых размеров}
    procedure ProcessFile(var fs: TFileStream);

    {Осуществляет переименование файлов лога}
    procedure RenameFiles;

    {Удаляет из лога старые данные. Игнорирует файлы размером меньше 32768 байт}
    procedure CheckLogTime(var fs: TFileStream);

    procedure SetUseMutex(const Value: Boolean);
    procedure SetDateTimeFormat(const Value: string);
    procedure SetDefaultPrefix(const Value: string);
    procedure SetUsedLogTypes(const Value: TLDSLogTypes);
    procedure SetNotifyHandle(const Value: THandle);
    procedure SetNotifyMessage(const Value: Cardinal);
    procedure SetListBufferMaxCount(const Value: Integer);
    procedure SetDateTimeTrimInterval(const Value: TDateTime);

    procedure DoLogStr(MsgText: string; LogType: TLDSLogType; CurDateTime: TDateTime; AThreadID: DWORD; ReadyBuf: TMemoryStream);
    function GetLazyWrite: Boolean;
    function GetFinalLogString(MsgText: string; LogType: TLDSLogType;
      CurDateTime: TDateTime; AThreadID: DWORD): string;
    procedure AddToListBuffer(MsgText: string; LogType: TLDSLogType; CurDateTime: TDateTime; AThreadID: DWORD);
  public
    {Конструктор. AFileName определяет имя лог-файла. Если указывается имя файла
     без пути, то в качестве него подставляется путь к исполняемому файлу. Имя
     файла используется для создания именованного мьютекса, с помощью которого
     реализована блокировка, необходимая для обеспечения безопасной записи в
     один лог сразу несколькими приложениями }
    constructor Create(AFileName: string);

    {Деструктор. Обязательно вызывайте TLDSLogger.Free, если LazyWrite=True!!!}
    destructor Destroy; override;

    {Имя LOG-файла. При использовании мьютексов имя файла определяет имя мьютекса.
     При установке нового имени файла объект мьютекс будет пересоздан}
    property FileName: string read FFileName write SetFileName;

    {Максимальный размер LOG-файла. При превышении размера файла на треть
     относительно MaxFileSize произойдет вызов функции ProcessFile.
     По умолчанию MaxFileSize = 1 МБайт.
     Для отключения контроля размера файла установите MaxFileSize=0}
    property MaxFileSize: Int64 read FMaxFileSize write FMaxFileSize;

    {Определяет за какой период данные должны храниться в файле. Старые данные
     будут автоматически уничтожаться. Анализ лога выполняется не каждый раз, а
     только через интервал времени LDSCheckTimeInterval. По умолчанию
     DateTimeTrimInterval=0, т.е. обрезка лога по времени отключена.
     При обрезке лога всегда учитывается MaxFileSize}
    property DateTimeTrimInterval: TDateTime read FDateTimeTrimInterval write SetDateTimeTrimInterval;

    {Максимальное кол-во переименованных лог-файлов. При переименовании
     заполненного лог-файла ему в конец имени дописывается индекс 000. Все более
     поздние файлы также переименовываются (их индекс увеличивается на единицу).
     Когда количество переименованных лог-файлов превышает MaxOldLogFileCount,
     лишние файлы удаляются}
    property MaxOldLogFileCount: Integer read FMaxOldLogFileCount write FMaxOldLogFileCount;

    {Режим переименования лог-файлов. 0-в старых файлах в конце допивывается ".logXXX",
     1-в старых файлах в конце допивывается ".log.X" }
    property RenameFilesMode: Integer read FRenameFilesMode write FRenameFilesMode;

    {Внимание! Не используйте режим ClearOldLogData=True. Удаление логов должно
     выполняться с помощью удаления старых файлов, а не вырезания данных из файла!
     
     Определяет, что нужно делать в случае, если размер LOG-файла превысит
     MaxFileSize, либо сработает ограничение DateTimeTrimInterval.
     Если ClearOldLogData=True, то старые строки в файле будут
     просто удалены. Если ClearOldLogData=False, то будет создан новый LOG-файл,
     а старый LOG-файл будет просто переименован (например, был MyLogFile.log,
     а станет MyLogFile.log000)}
    property ClearOldLogData: Boolean read FClearOldLogData write FClearOldLogData;

    {Определяет, следует ли использовать мьютекс для защиты операции записи в
     файл. По умолчанию UseMutex=True. Нет никаких причин для изменения данного свойства}
    property UseMutex: Boolean read FUseMutex write SetUseMutex;

    {Записывает строку MsgText в LOG-файл. При этом осуществляется блокировка
     мьютексом и критической секцией, файл открывается, в него дописывается
     информация, проверяется размер файла, по результату проверки может быть вызвана
     процедура ProcessFile() или CheckLogTime(). Если зарегистрирован Handle окна
     (с помощью св-ва NotifyHandle), то заданная строка записывается в буффер
     TStringList, окну посылается сообщение NotifyMessage с помощью PostMessage,
     после чего в оконной процедуре окна можно считать накопленный в буффере
     текст путем вызова метода GetListBufferText}
    procedure LogStr(MsgText: string = ''; LogType: TLDSLogType = tlpNone; EventTime: TDateTime = 0);
    procedure LogStrFmt(MsgText: string; Args: array of const; LogType: TLDSLogType = tlpNone);

    {Управляет возможностью записи данных в LOG-файл}
    property Enabled: Boolean read FEnabled write FEnabled;

    {Типы сообщений, которые следует записывать в лог. Можно отключить запись в
     лог ненужных сообщений, например так:
       UsedLogTypes := UsedLogTypes - [tlpDebug, tlpOther]
     Можно вообще отключить ведение лога:  UsedLogTypes := [] }
    property UsedLogTypes: TLDSLogTypes read FUsedLogTypes write SetUsedLogTypes;

    {Определяет стандартный префикс, с которого должно начинаться текстовое
     сообщение в LOG-файле}
    property DefaultPrefix: string read FDefaultPrefix write SetDefaultPrefix;

    {Определяет, следует ли записывать в лог ID текущего потока}
    property CanWriteThreadID: Boolean read FCanWriteThreadID write FCanWriteThreadID;

    {Определяет, следует ли записывать в лог ID текущего процесса}
    property CanWriteProcessID: Boolean read FCanWriteProcessID write FCanWriteProcessID;

    {Определяет формат представления времени в LOG-файле. По умолчанию используется
     фиксированный формат "dd/mm/yyyy hh:nn:ss.zzz". Для экономии места можно
     исключить запись года и миллисекунд, тогда получим "dd/mm hh:nn:ss". Не нужно
     для одного log-файла использовать одновременно несколько форматов вывода,
     т.к. на анализе данной строки организован механизм ограничения лога по времени,
     и для корректности его работы требуется стабильность формата. Рекомендуется
     вместо символов формата (d, m, h, n, s, z) использовать (dd, mm, hh, nn, ss, zzz),
     иначе могут быть проблемы с анализом дат в логе. Вывод даты, либо вывод времени
     можно исключить, но нельзя выводить время раньше чем дату, т.к. такие строки
     анализу не подлежат}
    property DateTimeFormat: string read FDateTimeFormat write SetDateTimeFormat;

    {Определяет, следует ли в лог писать символы-описатели сообщения}
    property CanWriteLogSymbols: Boolean read FCanWriteLogSymbols write FCanWriteLogSymbols;

    {Определяет, следует ли в лог писать слова-описатели сообщения}
    property CanWriteLogWords: Boolean read FCanWriteLogWords write FCanWriteLogWords;

    {Очищает буффер TStringList}
    procedure ClearListBuffer;

    {Дескриптор окна, которому при каждой записи в лог будет посылаться сообщение
     PostMessage с параметром NotifyMessage. Если NotifyHandle=0 (по умолчанию),
     то сообщение не будет посылаться никому, а список StringListBuffer
     использоваться не будет}
    property NotifyHandle: THandle read FNotifyHandle write SetNotifyHandle;

    {Сообщение, которое отсылается окну NotifyHandle. Окно, получившее данное
     сообщение в оконной процедуре, может считать текст, накопленный в буффере
     путем вызова метода GetListBufferText()}
    property NotifyMessage: Cardinal read FNotifyMessage write SetNotifyMessage;

    {Возвращает текст, накопленный в строковом буффере и очищает буффер}
    function GetListBufferText(ClearBuffer: Boolean = True): string;

    {Записывает строки, накопленные в строковом буффере FStringListBuffer, в OutStrings и очищает буффер}
    function WriteListBufferToStrings(OutStrings: TStrings): Boolean;

    {Максимальное число строк в буффере. Внимание! Если задано большое значение, но
     при этом не вызываются функции GetListBufferText и WriteListBufferToStrings, то
     это может быть причиной значительных тормозов при работе функции LogStr.
     Если же значение слишком маленькое, NotifyHandle не задан, а запись в лог выполняется
     интенсивно, то при заполнении списка ListBuffer старые строки будут удаляться.}
    property ListBufferMaxCount: Integer read FListBufferMaxCount write SetListBufferMaxCount;

    {Определяет, нужно ли записывать строки в дополнительный буфер (помимо записи в файл).
     Если изменяется свойство NotifyHandle либо NotifyMessage, то свойству UseListBuffer
     автоматически присваивается значение True }
    property UseListBuffer: Boolean read FUseListBuffer write FUseListBuffer;

    {Определяет, нужно ли использовать кодировку UTF-8 при записи в лог-файлы}
    property UseUTF8: Boolean read FUseUTF8{ write FUseUTF8};

    {Устанавливает блокировку файла}
    procedure Lock;

    {Снимает блокировку файла}
    procedure UnLock;

    {Позволяет включить режим "ленивой" (отложенной) записи в лог. По умолчанию
     "ленивая" запись отключена (т.е. данные пишутся в лог незамедлительно)}
    property LazyWrite: Boolean read GetLazyWrite write FLazyWrite;

    {Возвращает объект LazyWriteThread}
    class function GetLazyWriteThread: TThread;
  end;

{Выполняет перевод всех  текстовых сообщений модуля LDSLogger. LangFileName -
 имя языкового файла. LoggerSection - имя секции}
procedure TranslateLoggerMessages(const LangFileName: string;
  const LoggerSection: string = 'LoggerSection');

{ Функция открытия файла с заданный временем ожидания. Полная версия функции
  находится в авторском модуле Matrix32.pas. В ней используется дополнительная
  защита кода открытия файла с помощью мьютекса. }
function WaitAndCreateLogFileStream(AFileName: string; AMode: Word; WaitTime: Integer): TFileStream;

{ Уничтожает поток записи в лог-файлы.
  Если модуль используется в DLL, а вызов на очистку объектов DLL исходит из EXE, то можно
  передавать FromDLL = False }
procedure DestroyLazyWriteThread(FromDLL: Boolean);

{$IFDEF UseResStr}
resourcestring
  resSProcessID = '<P:%d>';
  resSThreadID = '<T:%d>';
  resSProcessAndThreadID = '<P:%d;T:%d>';
  resSCreateMutexError = 'Ошибка при создании объекта "мьютекс": %s';
  resSLogErrorsWriterMessage = 'Ошибка при попытке записи (%0:s) в лог "%1:s" строки [%2:s]: %3:s <%4:s>';
  resSLogWriteError = '<Ошибка при записи в лог>';

  resSLogInformation = ' [инфо]';
  resSLogError       = ' [ошиб]';
  resSLogCritError   = ' [сбой]';
  resSLogWarning     = ' [вним]';
  resSLogEvent       = ' [соб.]';
  resSLogDebug       = ' [отл.]';
  resSLogOther       = ' [друг]';
  DATE_TIME_FORMAT = 'dd/mm/yyyy hh:nn:ss.zzz';

{$ELSE}
var
  resSProcessID: string = '<P:%d>';
  resSThreadID: string = '<T:%d>';
  resSProcessAndThreadID: string = '<P:%d;T:%d>';
  resSCreateMutexError: string = 'Ошибка при создании объекта "мьютекс": %s';
  resSLogErrorsWriterMessage: string = 'Ошибка при попытке записи (%0:s) в лог "%1:s" строки [%2:s]: %3:s <%4:s>';
  resSLogWriteError: string = '<Ошибка при записи в лог>';

  resSLogInformation: string = ' [инфо]';
  resSLogError: string       = ' [ошиб]';
  resSLogCritError: string   = ' [сбой]';
  resSLogWarning: string     = ' [вним]';
  resSLogEvent: string       = ' [соб.]';
  resSLogDebug: string       = ' [отл.]';
  resSLogOther: string       = ' [друг]';
  DATE_TIME_FORMAT: string = 'dd/mm/yyyy hh:nn:ss.zzz';
{$ENDIF}

const
  MAX_LOGFILE_SIZE = 1024 * 1024;
  LOGGER_NOTIFY_MESSAGE = WM_USER + 321;
  LIST_BUFFER_MAX_COUNT = 5000;

  {Определяет, нужно ли использовать кодировку UTF-8 при записи в лог-файлы.
   Пока это константа. В дальнейшем можно преобразовать в переменную}
  LDSGlobalUseUTF8 = {$IFDEF FPC}True{$ELSE}False{$ENDIF};

var
  {Логгер, используемый для записи сообщений об ошибках, возникающих при записи
   в лог-файлы. По умолчанию ошибки выводятся в файл %TEMP%\LDSLoggerErrorsWriter.log.
   Ошибки при записи в лог-файлы происходят крайне редко (они могут вообще никогда
   не возникнуть). Основная причина ошибок записи - просмотр лог-файлов с
   помощью файловых менеджеров (они иногда ставят блокировку на запись файла при
   его открытии. Если блокировка длится дольше, чем LDSMaxWaitFileTime, то возникнет
   ошибка доступа к файлу). Кроме того, если сторонним приложением выполняется
   просмотр файла то может выдать ошибку функция контроля размера файла. Также
   может возникнуть ошибка переполнения диска (и т.д. и т.п.)}
  LogErrorsWriter: TLDSLogger;

  {Время ожидания, в течение которого допускаются попытки открытия файла для
   записи. Это необходимо, так как файловые менеджеры часто открывают файлы
   с блокировкой [fmOpenRead or fmShareDenyWrite] для тех или иных целей
   (например, Total Commander при обновлении панелей иногда почему-то так
   поступает. Также открывает файл для чтения с блокировкой записи классическая
   функция Reset().}
  LDSMaxWaitFileTime: Integer = 200;

  {Определяет интервал времени, через который механизм автоочистки лога по дате
   осуществляет анализ лога. Интервал задается в секундах}
  LDSCheckTimeInterval: Integer = 60;

  {Тип сообщения - полная версия}
  LDSLogWords: array[TLDSLogType] of string;

  {Тип сообщения - сокращенная версия. Перечисленные символы записываются в логе
   в начале каждой строке первым байтом. Первоначальная цель - предоставить
   простой механизм подсветки при отображении содержимого лога пользователю, а
   также упростить механизм фильтрации сообщений}
  LDSLogSymbols: array[TLDSLogType] of AnsiChar = ('-', '+', '?', '!', '#', '$', '%', '@');

  {Определяет настройки форматирования даты и времени, выводимых в лог.
   При инициализации модуля устанавливаются DateSeparator и TimeSeparator.
   При необходимости вы можете их изменить требуемым образом.}
  LDSLoggerFormatSettings: TFormatSettings;

  {Определяет, какие настройки для форматирования даты и времени следует
   использовать: текущие, или переменную LDSLoggerFormatSettings. По умолчанию
   используется LDSLoggerFormatSettings (жестко установлены DateSeparator и TimeSeparator)}
  LDSUseSystemLocalSettings: Boolean = False;

  {Определяет, нужно ли генерировать исключение, если не удается создать объект
  "мьютекс". По умолчанию исключение НЕ генерируется. Даже если мьютекс не
  создан, логгер работает весьма надежно.}
  LDSCanRaiseMutexError: Boolean = False;

  {Определяет, должны ли вновь созданные объекты TLDSLogger создавать мьютексы.
   По умолчанию мьютекс создается. Отключать данную директиву имеет смысл
   только в исследовательских целях}
  LDSGlobalUseMutex: Boolean = True;

  {Определяет, должна ли использоваться "отложенная" запись в лог по умолчанию }
  {$IFDEF LDSLoggerLazy}
  LDSLoggerLazyWrite: Boolean = True;
  {$ELSE}
  LDSLoggerLazyWrite: Boolean = False;
  {$ENDIF}

  {Задержка в миллисекундах после пробуждения потока TLazyWriteThread и перед дальнейшими действиями.
   Рекомендуется использовать переменную LDSLoggerSkipWakeUpThread}
  LDSLoggerLazyWriteDelay: Integer = 0; // 2021-08-05 - устарела!

  { Если LDSLoggerSkipWakeUpThread=TRUE, то при вызове LogStr метод WakeUp вызываться не будет.
    В этом случае поток записи проснётся по таймауту (5 сек) и запишет новые данные в логи.
    Благодаря этому существенно уменьшается количество переключений контекста при интенсивной
    записи в лог из нескольких потоков }
  LDSLoggerSkipWakeUpThread: Boolean = False; // 2021-08-05 - добавлена

  { Данная процедура, если она указана, будет вызываться каждый раз, когда поток
    записи TLazyWriteThread завершает итерацию записи в файл }
  LDSOnWriteToFile: procedure;

implementation

type
  TLazyWriteThread = class(TThread)
  private
    FEvent: {$IFDEF MSWINDOWS}THandle{$ELSE}TEvent{$ENDIF};
    FRecList: TList;
    FCritSect: TCriticalSection; // Критическая секция для защиты списка
    LazyThreadID: DWORD;
    SkipDelay: Boolean;
    procedure CheckWriteToLog;
  public
    constructor Create;
    destructor Destroy; override;

    // Добавляет сообщение для записи в лог в очередь
    procedure RegisterLogMsg(ALogObj: TLDSLogger; ALogType: TLDSLogType; ALogMsg: string; EventTime: TDateTime);

    // Позволяет "разбудить" поток, если требуется записать сообщения в лог
    procedure WakeUp(ASkipDelay: Boolean);
  protected
    procedure Execute; override;
  end;

  TLogMessageRec = class
    LogObj: TLDSLogger;
    LogTime: TDateTime;
    LogType: TLDSLogType;
    LogMsg: string;
    LogThreadID: DWORD;
  end;

var
  LazyWriteThread: TLazyWriteThread;

  // TRUE, произошел вход в секцию finalization
  WasFinalization: Boolean = False;

  LazyWriteCreateCS: TCriticalSection;

procedure CheckLazyWriteThread;
begin
  if LazyWriteThread = nil then
  begin
    LazyWriteCreateCS.Enter;
    try
      if LazyWriteThread = nil then
        LazyWriteThread := TLazyWriteThread.Create();
    finally
      LazyWriteCreateCS.Leave;
    end;
  end;
end;

function WaitAndCreateLogFileStream(AFileName: string; AMode: Word; WaitTime: Integer): TFileStream;
const
  SleepTime = 10;
  // Ошибки, означающие, что файл в данный момент кем-то еще занят, и следует
  // дождаться, пока он не освободится
  FriendlyErrors = [{$IFDEF MSWINDOWS}ERROR_SHARING_VIOLATION, ERROR_LOCK_VIOLATION{$ENDIF}];
var
  EndTime: TDateTime;
  ALastError: Integer;
begin
  ALastError := 0;

  if WaitTime < 0 then
    WaitTime := LDSMaxWaitFileTime;

  if WaitTime = 0 then
    Result := TFileStream.Create(AFileName, AMode)
  else
  begin

    EndTime := IncMilliSecond(Now, WaitTime);

    try
      while True do
      try
        Result := TFileStream.Create(AFileName, AMode);
        Exit;
      except
        on E: Exception do
        begin
          // Запоминаем код ошибки - понадобится позже
          ALastError := {$IFDEF MSWINDOWS}GetLastError{$ELSE}GetLastOSError{$ENDIF};

          // Если вышло время ожидания, или произошла ошибка, при которой
          // ожидание не имеет смысла, то генерируем исключение
          if (Now >= EndTime) or (not (ALastError in FriendlyErrors)) then raise;

          // Файл кем-то занят. Ожидаем немного времени, прежде чем повторить попытку
          Sleep(SleepTime);
        end;
      end;
    except
      on E: Exception do
        if ALastError in FriendlyErrors then
          raise Exception.CreateFmt('Log file open timeout: %d ms (%s)',
            [WaitTime, SysErrorMessage(ALastError)])
        else
          raise; // Регенерируем ошибку, возникшую ранее
    end;
  end;
end;

{ Создает мьютекс. Учитывает опцию условной компиляции LDSLoggerMutexExclusive }
{$IFDEF MSWINDOWS}
function LDSLoggerCreateMutex(AName: string): Cardinal;
var
{$IFNDEF LDSLoggerMutexExclusive}
  SD:TSecurityDescriptor;
  SA:TSecurityAttributes;
{$ENDIF}
  pSA: PSecurityAttributes;
begin
{$IFNDEF LDSLoggerMutexExclusive}
  if not InitializeSecurityDescriptor(@SD, SECURITY_DESCRIPTOR_REVISION) then
    raise Exception.CreateFmt('Error InitializeSecurityDescriptor: %s', [SysErrorMessage(GetLastError)]);

  SA.nLength:=SizeOf(TSecurityAttributes);
  SA.lpSecurityDescriptor:=@SD;
  SA.bInheritHandle:=False;

  if not SetSecurityDescriptorDacl(SA.lpSecurityDescriptor, True, nil, False) then
    raise Exception.CreateFmt('Error SetSecurityDescriptorDacl: %s', [SysErrorMessage(GetLastError)]);

  pSA := @SA;
{$ELSE}
  pSA := nil;
{$ENDIF}

  Result := CreateMutex(pSA, False, PChar('Global\' + AName)); // Пытаемся создать с директивой Global
  if Result = 0 then
    Result := CreateMutex(pSA, False, PChar(AName)); // Пытаемся создать без директивы Global


  if Result = 0 then
    if LDSCanRaiseMutexError then
      raise Exception.CreateFmt(resSCreateMutexError, [SysErrorMessage(GetLastError)]);
end;
{$ENDIF}

{ TLDSLogger }

procedure TLDSLogger.AddToListBuffer(MsgText: string; LogType: TLDSLogType;
  CurDateTime: TDateTime; AThreadID: DWORD);
var
  BufferMsgText: string;
begin
  BufferMsgText := GetFinalLogString(MsgText, LogType, CurDateTime, AThreadID);
  FBufferCS.Enter;
  try
    FStringListBuffer.Add(BufferMsgText);
    while FStringListBuffer.Count > ListBufferMaxCount do
      FStringListBuffer.Delete(0); // Данный цикл может являться причиной тормозов!!!
    if (NotifyHandle <> 0) and (NotifyMessage <> 0) then
      PostMessage(NotifyHandle, NotifyMessage, 0, 0);
  finally
    FBufferCS.Leave;
  end;
end;

procedure TLDSLogger.CheckLogTime(var fs: TFileStream);
const
  BufSize = 32768; // Размер буфера чтения
var
  ar: array of AnsiChar;
  I, NextLinePos: Integer;
  S: string;
  TempTime, TempTime2: TDateTime;
  WasFirst: Boolean;
  tempfs: TFileStream;
  tempfname: string;

  function IsEventChar(C: AnsiChar): Boolean;
  var
    I: TLDSLogType;
  begin
    Result := True;
    for I := Low(LDSLogSymbols) to High(LDSLogSymbols) do
      if C = LDSLogSymbols[I] then Exit;
    Result := False;
  end;
begin
  if (DateTimeTrimInterval > 0) and (fs.Size > BufSize) then
  begin
    if FLastCheckTime < IncSecond(Now, -LDSCheckTimeInterval) then
    begin
      // Участок длительной обработки данных. Файл лога может достигать больших размеров
      try
        fs.Seek(0, soFromBeginning);
        WasFirst := False;
        TempTime2 := 0; // Чтобы компилятор не ругался

        S := FormatDateTime(DateTimeFormat, Now); // Выделяем строковый буфер нужной длины

        SetLength(ar, BufSize);

        // Обрабатываем последовательно весь файл (если это необходимо)
        while fs.Position + BufSize < fs.Size do
        begin
          fs.Read(ar[0], BufSize);

          I := 0;

          // Перебираем весь блок, немного не доходя до конца
          // если окажутся необработанными несколько последних байт - ничего
          // страшного, обработаем другие строки
          while I < High(ar) - (Length(S) * 2 + 5) do
          begin
            if ar[I] = #10 then
            begin
              NextLinePos := I + 1; // Запоминаем начало следующей строки
              if IsEventChar(ar[NextLinePos]) and (ar[NextLinePos + 1] = ' ') then
              begin
                SetString(S, PAnsiChar(@ar[NextLinePos + 2]), Length(S)); // В D2010 работает!
                Inc(I, Length(S) + 2);
              end else
              begin
                SetString(S, PAnsiChar(@ar[NextLinePos]), Length(S));
                Inc(I, Length(S));
              end;

              // Если строка начинается с корректной даты, то выполняем ее обработку
              if (LDSUseSystemLocalSettings and TryStrToDateTime(S, TempTime)) or
                 (not LDSUseSystemLocalSettings and TryStrToDateTime(S, TempTime,
                  LDSLoggerFormatSettings)) then
              begin
                // Если в логе не пишется метка даты, то берем сегодняшний день
                if Trunc(TempTime) = 0 then
                  TempTime := Date + TempTime;

                // При чтении самой первой даты делаем выводы, нужно ли продолжать
                if not WasFirst then
                begin
                  WasFirst := True;
                  // Информация в файле актуальная, выходим из обработки
                  if TempTime + (DateTimeTrimInterval + DateTimeTrimInterval / 3) > Now then Exit;
                  TempTime2 := TempTime;
                end else
                begin
                  // Если считанная запись актуальная, а предыдущая - неактуальная,
                  // то осуществляем обработку файла
                  if (TempTime + DateTimeTrimInterval > Now) and
                     (TempTime2 + DateTimeTrimInterval < Now) then
                  begin
                    if ClearOldLogData then
                    begin
                      tempfname := Format('%s_TempLog_%d', [FileName, GetCurrentThreadId]);

                      tempfs := TFileStream.Create(tempfname, fmCreate);
                      try
                        fs.Seek(-BufSize + NextLinePos, soFromCurrent);
                        tempfs.CopyFrom(fs, fs.Size - fs.Position);
                        // Обрезаем рабочий файл. Удалять или переименовывать
                        // файлы нельзя, т.к. лишимся надежности
                        fs.Size := tempfs.Size; // Здесь может возникнуть Exception
                        fs.Seek(0, soFromBeginning);
                        tempfs.Seek(0, soFromBeginning);
                        fs.CopyFrom(tempfs, tempfs.Size);
                        Exit;
                      finally
                        tempfs.Free;
                        DeleteFile(tempfname);
                      end;
                    end else
                    begin
                      // Осуществляем переименование файлов
                      FreeAndNil(fs);
                      RenameFiles;
                      Exit;
                    end;
                  end;
                  TempTime2 := TempTime;
                end;
              end;
            end else
              Inc(I);
          end; // while I
        end; // fs.Position

        // Сюда мы зайти можем только в 2х случаях: если в файле нет ни одной
        // метки времени (TempTime2=0), либо файл на 100% состоит из устаревших
        // данных, и найти границу обрезки не удалось.
        if (TempTime2 > 0) and Assigned(fs) then 
        begin
          if ClearOldLogData then
            fs.Size := 0 
          else
          begin
            FreeAndNil(fs);
            RenameFiles;
          end;
        end;
      finally
        FreeAndNil(fs);
        FLastCheckTime := Now;
      end;
    end;
  end;
end;

procedure TLDSLogger.ClearListBuffer;
begin
  FBufferCS.Enter;
  try
    FStringListBuffer.Clear;
  finally
    FBufferCS.Leave;
  end;
end;

constructor TLDSLogger.Create(AFileName: string);
begin
  FCritSect := TCriticalSection.Create;
  FBufferCS := TCriticalSection.Create;
  FMaxFileSize := MAX_LOGFILE_SIZE;
  FDateTimeFormat := DATE_TIME_FORMAT;
  FUseMutex := LDSGlobalUseMutex;
  FileName := AFileName;
  FEnabled := True;
  FCanWriteLogWords := True;
  //FClearOldLogData := True;
  FClearOldLogData := False;
  //FMaxOldLogFileCount := 10;
  FMaxOldLogFileCount := 2;
  FUseUTF8 := LDSGlobalUseUTF8;
  FUsedLogTypes :=
    [tlpNone, tlpInformation, tlpError, tlpCriticalError, 
     tlpWarning, tlpEvent, tlpDebug, tlpOther];
  FStringListBuffer := TStringList.Create;
  FNotifyMessage := LOGGER_NOTIFY_MESSAGE;
  FListBufferMaxCount := LIST_BUFFER_MAX_COUNT;
  FLazyWrite := LDSLoggerLazyWrite;
  FFinalStrings := TStringList.Create;
end;

destructor TLDSLogger.Destroy;
begin
  if (FLazyWriteCounter > 0) and Assigned(LazyWriteThread) then
  begin // Задерживаем уничтожение объекта, пока не завершится запись в лог
    LazyWriteThread.WakeUp(True);
    while FLazyWriteCounter > 0 do
      Sleep(1);
  end;

  UseMutex := False;   
  FreeAndNil(FCritSect); 
  FreeAndNil(FStringListBuffer);
  FreeAndNil(FBufferCS);
  FreeAndNil(FFinalStrings);
  inherited;
end;

function TLDSLogger.GenerateMutexName: string;
var
  I: Integer;
begin
  Result := AnsiLowerCase(FileName);
  for I := 1 to Length(Result) do
    if AnsiChar(Result[I]) in ['\', '/', ':', '*', '"', '?', '|', '<', '>'] then
      Result[I] := '_';
end;

function TLDSLogger.GetLazyWrite: Boolean;
begin
  Result := FLazyWrite and (not WasFinalization);
end;

class function TLDSLogger.GetLazyWriteThread: TThread;
begin
  Result := LazyWriteThread;
end;

function TLDSLogger.WriteListBufferToStrings(OutStrings: TStrings): Boolean;
var
  I: Integer;
begin
  Result := False;

  FBufferCS.Enter;
  try
    if FStringListBuffer.Count > 0 then
    begin
      OutStrings.BeginUpdate;
      try
        for I := 0 to FStringListBuffer.Count - 1 do
        begin
          OutStrings.Add(FStringListBuffer[I]);
          Result := True;
        end;
        FStringListBuffer.Clear;
      finally
        OutStrings.EndUpdate;
      end;
    end;
  finally
    FBufferCS.Leave;
  end;
end;

function TLDSLogger.GetListBufferText(ClearBuffer: Boolean): string;
begin
  FBufferCS.Enter;
  try
    Result := FStringListBuffer.Text;
    if ClearBuffer then
      FStringListBuffer.Clear;
  finally
    FBufferCS.Leave;
  end;
end;

procedure TLDSLogger.Lock;
begin
  FCritSect.Enter;

  {$IFDEF MSWINDOWS}
  if FMutexHandle <> 0 then
    WaitForSingleObject(FMutexHandle, INFINITE);
  {$ENDIF}
end;

function TLDSLogger.GetFinalLogString(MsgText: string; LogType: TLDSLogType; CurDateTime: TDateTime; AThreadID: DWORD): string;
var
  PID: Int64;
begin
  Result := '';
  MsgText := TrimRight(MsgText);
  if MsgText <> '' then
  begin
    if LDSUseSystemLocalSettings then
      Result := FormatDateTime(DateTimeFormat, CurDateTime)
    else
      Result := FormatDateTime(DateTimeFormat, CurDateTime, LDSLoggerFormatSettings);

    if CanWriteLogSymbols then
      Result := LDSLogSymbols[LogType] + ' ' + Result;
    if CanWriteLogWords then
      Result := Result + LDSLogWords[LogType];

    if DefaultPrefix <> '' then
      Result := Result + ' ' + DefaultPrefix;

    PID := {$IFDEF MSWINDOWS}GetCurrentProcessId{$ELSE}GetProcessID{$ENDIF};

    if CanWriteProcessID and CanWriteThreadID then
      Result := Result + ' ' + Format(resSProcessAndThreadID, [PID, AThreadID])
    else if CanWriteProcessID then
      Result := Result + ' ' + Format(resSProcessID, [PID])
    else if CanWriteThreadID then
      Result := Result + ' ' + Format(resSThreadID, [AThreadID]);

    Result := Result + ' ' + MsgText;
  end;
end;

procedure TLDSLogger.DoLogStr(MsgText: string; LogType: TLDSLogType; CurDateTime: TDateTime; AThreadID: DWORD; ReadyBuf: TMemoryStream);
var
  Fs: TFileStream;
  SFileMode: string;
  BufferMsgText: string;
begin
  if Enabled and (FileName <> '') and Assigned(FCritSect) and (LogType in FUsedLogTypes) then
  begin
    Lock;
    try
      try
        if ReadyBuf = nil then
        begin
          BufferMsgText := GetFinalLogString(MsgText, LogType, CurDateTime, AThreadID);
          MsgText := BufferMsgText + sLineBreak;
        end
        else
        begin
          SetString(BufferMsgText, PChar(ReadyBuf.Memory), ReadyBuf.Size div SizeOf(Char));
          MsgText := BufferMsgText;
        end;

        if FileExists(FileName) then
        begin
          // Проверка FileExists() не гарантирует на 100%, что следующей строкой
          // файл лога не удалят. В этом случае в LDSLoggerErrorsWriter.log будет
          // записано: [Cannot open file "LogName.log". Не удается найти указанный файл]

          // При многопоточном логгировании иногда в LDSLoggerErrorsWriter.log
          // пишется сообщение: [Ошибка при попытке записи (fmCreate) в лог ""
          // строки [....]: Cannot create file "". Системе не удается найти
          // указанный путь]. Сообщение пишется только при выходе из программы.
          // Видимо, на этот момент менеджер памяти уже очистил все динамические
          // динамические строки. Избавляться от этого эффекта не стал, не мешает.
          // Для профилактики этой ошибки следует при выходе из программы дождаться
          // завершения работы всех потоков.

          SFileMode := 'fmOpenReadWrite';
          Fs := WaitAndCreateLogFileStream(FileName, fmOpenReadWrite or fmShareDenyNone, LDSMaxWaitFileTime);

          // Классический способ
           //Fs := TFileStream.Create(FileName, fmOpenWrite or fmShareDenyNone);
        end else
        begin
          SFileMode := 'fmCreate';
          Fs := WaitAndCreateLogFileStream(FileName, fmCreate, LDSMaxWaitFileTime);
          if UseUTF8 then
            Fs.Write(sUTF8BOMString, Length(sUTF8BOMString));
        end;
        SFileMode := SFileMode + '-OK';

        try
          Fs.Seek(0, soFromEnd);
          Fs.Write(AnsiString(MsgText)[1], Length(MsgText) * SizeOf(AnsiChar));

          SFileMode := SFileMode + ';ProcessFile...';

          if (FMaxFileSize > 0) and (Fs.Size > FMaxFileSize + FMaxFileSize div 3) then
            ProcessFile(Fs) // Функция уничтожит файл и обнулит Fs
          else
            CheckLogTime(Fs);
        finally
          Fs.Free;
        end;

      except
        on E: Exception do
        begin
          if not FIsErrorWriter then
          begin
            LogErrorsWriter.LogStrFmt(resSLogErrorsWriterMessage,
              [SFileMode, FileName, TrimRight(MsgText), E.Message, E.ClassName]);
          end;
          //BufferMsgText := BufferMsgText + ' ' + resSLogWriteError;
        end;
      end;
    finally
      UnLock;
    end;
  end;
end;

procedure TLDSLogger.LogStr(MsgText: string; LogType: TLDSLogType; EventTime: TDateTime);
begin
  if Assigned(Self) and Self.Enabled then
  begin
    if EventTime = 0 then
      EventTime := Now;

    if UseListBuffer and (LogType in FUsedLogTypes) then
      AddToListBuffer(MsgText, LogType, EventTime, GetCurrentThreadId);

    if LazyWrite then
      CheckLazyWriteThread;

    if LazyWrite and (GetCurrentThreadId <> LazyWriteThread.LazyThreadID) then
    begin
      if LogType in FUsedLogTypes then
        LazyWriteThread.RegisterLogMsg(Self, LogType, MsgText, EventTime);
    end else
      DoLogStr(MsgText, LogType, EventTime, GetCurrentThreadId, nil);
  end;
end;

procedure TLDSLogger.LogStrFmt(MsgText: string; Args: array of const;
  LogType: TLDSLogType);
begin
  try
    LogStr(Format(MsgText, Args), LogType);
  except
    on E: Exception do
      raise Exception.Create('Error args for string [' + MsgText + ']: ' + E.Message);
  end;
end;

procedure TLDSLogger.ProcessFile(var fs: TFileStream);
const
  BufSize = MaxByte;
var
  Counter, I: Integer;
  ar: array of AnsiChar;
  WasFind: Boolean;
  tempfs: TFileStream;
  tempfname: string;
begin
  if ClearOldLogData then
  begin
    // Удаляем лишние строки с начала файла
    if fs.Size > MaxFileSize + BufSize then
    begin
      fs.Seek(-MaxFileSize, soFromEnd);
      SetLength(ar, BufSize);
      Counter := 0;
      WasFind := False;
      // Не допускаем разрез строки по середине
      while (fs.Position >= BufSize) and (not WasFind) do
      begin
        fs.Seek(-BufSize, soFromCurrent); // Сдвинули указатель влево
        fs.Read(ar[0], BufSize);          // Читаем. При этом указатель сдвинется вправо

        for I := High(ar) downto Low(ar) do
          if ar[I] in [#13, #10] then
          begin
            WasFind := True;
            Break;
          end else
            Inc(Counter);

        if not WasFind then // Если не удалось найти разрыв строки
          fs.Seek(-BufSize, soFromCurrent); // Еще раз сдвигаем указатель влево
      end;

      if not WasFind then
        Counter := 0; // Жесткая обрезка

      fs.Seek(-MaxFileSize - Counter, soFromEnd);

      tempfname := Format('%s_LogFile_%d', [FileName, GetCurrentThreadId]);

      tempfs := TFileStream.Create(tempfname, fmCreate);
      try
        tempfs.CopyFrom(fs, fs.Size - fs.Position);
        // Обрезаем рабочий файл. Удалять или переименовывать
        // файлы нельзя, т.к. лишимся надежности
        fs.Size := tempfs.Size; // Здесь может возникнуть Exception
        fs.Seek(0, soFromBeginning);
        tempfs.Seek(0, soFromBeginning);
        fs.CopyFrom(tempfs, tempfs.Size);
      finally
        tempfs.Free;
        DeleteFile(tempfname);
      end;
    end;
  end else
  begin
    FreeAndNil(fs);
    RenameFiles;
  end;         
end;

function StringListSortCompare(AList: TStringList; Index1, Index2: Integer): Integer;
var
  NumExt1, NumExt2: Integer;
  AFileName: string;
  S: string;
begin
  AFileName := TLDSLogger(AList.Objects[Index1]).FileName;
  S := Copy(AList[Index1], Length(AFileName) + 1,
    Length(AList[Index1]) - Length(AFileName));
  if S[1] = '.' then
    Delete(S, 1, 1);

  NumExt1 := StrToInt(S);

  S := Copy(AList[Index2], Length(AFileName) + 1,
    Length(AList[Index2]) - Length(AFileName));

  if S[1] = '.' then
    Delete(S, 1, 1);
  NumExt2 := StrToInt(S);

  if NumExt1 > NumExt2 then
    Result := 1
  else if NumExt1 < NumExt2 then
    Result := -1
  else
    Result := 0;

end;

procedure TLDSLogger.RenameFiles;
var
  AList: TStringList;
  Index: Integer;
  APos: Integer;
  fName: string;

  { Возвращает список переименованных лог-файлов }
  function GetOldFilesList(List: TStringList): Integer;
  var
    SR: TSearchRec;
    APath: string;
    AFileExt: string;
    //SRExt: string;
    NumExt: string;
  begin
    APath := ExtractFilePath(FileName);
    AFileExt := AnsiLowerCase(ExtractFileExt(FileName));
    fName := ExtractFileName(FileName);
    List.Clear;

    //AZSOffice.log.7
    //AZSWebService.log005

    // Заполняем список переименованных LOG-файлов
    if FindFirst(FileName + '*', faAnyFile, SR) = 0 then
    try
      repeat
        if FileExists(APath + SR.Name) then
        begin
          APos := Pos(AFileExt, AnsiLowerCase(SR.Name));
          if APos > 1 then
          begin
            if Length(SR.Name) > Length(fName) then
            begin
              NumExt := Copy(SR.Name, APos + Length(AFileExt), MAXWORD);
              if NumExt <> '' then
                if NumExt[1] = '.' then
                  Delete(NumExt, 1, 1);
                if StrToIntDef(NumExt, -1) >= 0 then
                  List.AddObject(APath + SR.Name, Self);
            end;
          end;
          {
          SRExt := ExtractFileExt(SR.Name);
          if not AnsiSameText(AFileExt, SRExt) then
          begin
            NumExt := Copy(SRExt, Length(AFileExt) + 1, Length(SRExt) - Length(AFileExt));

            // Добавляем имя файла и Self (Self используется для определения
            // FileName внутри функции StringListSortCompare)
            if StrToIntDef(NumExt, -1) >= 0 then
              List.AddObject(APath + SR.Name, Self);
          end; }
        end;
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;

    // Сортируем список в порядке возрастания номера
    List.CustomSort(@StringListSortCompare);
    Result := List.Count;
  end;

  procedure RenameOldLogFiles(List: TStringList);
  var
    I, NumExt: Integer;
    S: string;
  begin
    for I := List.Count - 1 downto 0 do
    begin
      S := Copy(AList[I], Length(FileName) + 1, Length(AList[I]) - Length(FileName));
      if S[1] = '.' then
        Delete(S, 1, 1);

      NumExt := StrToInt(S);
      S := IntToStr(NumExt + 1);

      if RenameFilesMode = 0 then
      begin
        while Length(S) < 3 do
          S := '0' + S;
      end else
      begin
        S := '.' + S;
      end;
      
      RenameFile(List[I], FileName + S);
    end;
  end;
begin
  AList := TStringList.Create;
  try
    GetOldFilesList(AList);
    // Удаляем старые лог-файлы
    if MaxOldLogFileCount > 0 then
      while AList.Count > MaxOldLogFileCount do
      begin
        Index := AList.Count - 1;
        DeleteFile(AList[Index]);
        AList.Delete(Index);
      end;

    // Переименовываем оставшиеся лог-файлы путем увеличения численного
    // значения расширения на 1-цу
    RenameOldLogFiles(AList);

    // Переименовываем исходный файл (даем ему индекс = 000)
    if RenameFilesMode = 0 then
      RenameFile(FileName, FileName +  '000')
    else
      RenameFile(FileName, FileName +  '.0');
  finally
    AList.Free;
  end;
end;

procedure TLDSLogger.SetDateTimeFormat(const Value: string);
begin
  FCritSect.Enter;
  try
    FDateTimeFormat := Value;
  finally
    FCritSect.Leave;
  end;                
end;

procedure TLDSLogger.SetDateTimeTrimInterval(const Value: TDateTime);
begin
  FCritSect.Enter;
  try
    FDateTimeTrimInterval := Value;
  finally
    FCritSect.Leave;
  end;
end;

procedure TLDSLogger.SetDefaultPrefix(const Value: string);
begin
  FCritSect.Enter;
  try
    FDefaultPrefix := Value;
  finally
    FCritSect.Leave;
  end;
end;

procedure TLDSLogger.SetFileName(Value: string);
begin
  {Защищаем 2 общих ресурса - строковую переменную FFileName и мьютекс}
  FCritSect.Enter;
  try
    if Value = '' then Exit;
    
    // Если задано короткое имя файла, то дополняем его полным именем
    if ExtractFilePath(Value) = '' then
      Value := ExtractFilePath(ParamStr(0)) + Value;

    // Если указано новое имя файла, то пересоздаем объект "мьютекс
    if {$IFDEF MSWINDOWS}  ((FMutexHandle = 0) and UseMutex) or{$ENDIF}
      (AnsiLowerCase(Value) <> AnsiLowerCase(FFileName)) then
    begin
      FFileName := Value;

      {$IFDEF MSWINDOWS}
      // Если мьютекс ранее уже существовал, то удаляем его
      if FMutexHandle <> 0 then
      begin
        CloseHandle(FMutexHandle);
        FMutexHandle := 0;
      end;

      if UseMutex then
        FMutexHandle := LDSLoggerCreateMutex(GenerateMutexName);
      {$ENDIF}
    end;
  finally
    FCritSect.Leave;
  end;
end;

procedure TLDSLogger.SetListBufferMaxCount(const Value: Integer);
begin
  FListBufferMaxCount := Value;
end;

procedure TLDSLogger.SetNotifyHandle(const Value: THandle);
begin
  FNotifyHandle := Value;
  if FNotifyHandle <> 0 then
    FUseListBuffer := True;
end;

procedure TLDSLogger.SetNotifyMessage(const Value: Cardinal);
begin
  FNotifyMessage := Value;
  if FNotifyMessage <> 0 then
    FUseListBuffer := True;
end;

procedure TLDSLogger.SetUsedLogTypes(const Value: TLDSLogTypes);
begin
  FUsedLogTypes := Value;
end;

procedure TLDSLogger.SetUseMutex(const Value: Boolean);
begin
  {$IFDEF MSWINDOWS}
  FCritSect.Enter;
  try
    FUseMutex := Value;
    if not Value and (FMutexHandle <> 0) then
    begin
      CloseHandle(FMutexHandle);
      FMutexHandle := 0;
    end;
  finally
    FCritSect.Leave;
  end;
  {$ENDIF}
end;

procedure TLDSLogger.UnLock;
begin
  {$IFDEF MSWINDOWS}
  if FMutexHandle <> 0 then
    ReleaseMutex(FMutexHandle);
  {$ENDIF}
  FCritSect.Leave;
end;

procedure FillLDSLogWords;
begin
  LDSLogWords[tlpNone] := '';
  LDSLogWords[tlpInformation] := resSLogInformation;
  LDSLogWords[tlpError] := resSLogError;
  LDSLogWords[tlpCriticalError] := resSLogCritError;
  LDSLogWords[tlpWarning] := resSLogWarning;
  LDSLogWords[tlpEvent] := resSLogEvent;
  LDSLogWords[tlpDebug] := resSLogDebug;
  LDSLogWords[tlpOther] := resSLogOther;
end;

procedure TranslateLoggerMessages(const LangFileName: string;
  const LoggerSection: string = 'LoggerSection');
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
    TranslateStr('SProcessID', resSProcessID);
    TranslateStr('SThreadID', resSThreadID);
    TranslateStr('SProcessAndThreadID', resSProcessAndThreadID);
    TranslateStr('SCreateMutexError', resSCreateMutexError);
    TranslateStr('SLogErrorsWriterMessage', resSLogErrorsWriterMessage);
    TranslateStr('SLogWriteError', resSLogWriteError);
    TranslateStr('SLogInformation', resSLogInformation);
    TranslateStr('SLogError', resSLogError);
    TranslateStr('SLogCritError', resSLogCritError);
    TranslateStr('SLogWarning', resSLogWarning);
    TranslateStr('SLogEvent', resSLogEvent);
    TranslateStr('SLogDebug', resSLogDebug);
    TranslateStr('SLogOther', resSLogOther);
    FillLDSLogWords;
    {$ENDIF UseResStr}
  end;
  

begin
  Ini := TIniFile.Create(LangFileName);
  AList := nil;
  try
    AList := TStringList.Create;
    try
      Ini.ReadSectionValues(LoggerSection, AList);
      TranslateMessages;
    except
      on E: Exception do
      begin
        LogErrorsWriter.LogStr('TranslateLoggerMessages -> ' + E.Message, tlpError);
        //Windows.Beep(500, 50);
      end;
    end;
  finally
    AList.Free;
    Ini.Free;
  end;
end;

procedure CreateLogErrorsWriter;
var
  S: string;
begin
  SetLength(S, MAX_PATH);
  {$IFDEF MSWINDOWS}
  GetTempPath(MAX_PATH, PChar(S));
  S := PChar(S);
  {$ELSE}
  S := IncludeTrailingPathDelimiter(GetTempDir);
  {$ENDIF}
  LogErrorsWriter := TLDSLogger.Create(S + 'LDSLoggerErrorsWriter.log');
  LogErrorsWriter.ClearOldLogData := True;
  LogErrorsWriter.FIsErrorWriter := True;
end;

procedure InitFormatSettings;
begin
  {$IfDef MSWINDOWS}
  GetLocaleFormatSettings(0, LDSLoggerFormatSettings);
  {$Else}
  LDSLoggerFormatSettings := DefaultFormatSettings;
  {$EndIf}

  LDSLoggerFormatSettings.LongDateFormat := 'dd/mm/yyyy';
  LDSLoggerFormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  LDSLoggerFormatSettings.LongTimeFormat := 'hh:nn:ss.zzz';
  LDSLoggerFormatSettings.ShortTimeFormat := 'hh:nn:ss.zzz';
  LDSLoggerFormatSettings.DateSeparator := '.';
  LDSLoggerFormatSettings.TimeSeparator := ':';
  LDSLoggerFormatSettings.DecimalSeparator := '.';
end;

{ TLazyWriteThread }

procedure TLazyWriteThread.CheckWriteToLog;
const
  MaxBufSize = 1024 * 1024;
var
  TmpList: TList;
  I, J, RecCnt: Integer;
  ARec: TLogMessageRec;
  LogObjects: TList;
  ALog: TLDSLogger;
  ms: TMemoryStream;
  s: string;
  procedure InitMS();
  begin
    ms.Clear;
    ms.SetSize(MaxBufSize + 1024); // За один раз пишем максимум 1 МБ
    ms.Position := 0;
  end;
begin
  if FRecList.Count > 0 then // Если есть строки, ожидающие добавления в лог
  begin
    TmpList := TList.Create; // Временный список строк
    try
      FCritSect.Enter; // Захватывает кр.секция на очень коротное время
      try
        TmpList.Assign(FRecList);  // Сразу копируем все данные из рабочего списка
        FRecList.Clear;            // Очищаем рабочий список
      finally
        FCritSect.Leave;
      end;

      LogObjects := TList.Create;
      ms := TMemoryStream.Create;
      try
        // Составляем список объектов, которые будут использоваться для пакетной записи
        for I := 0 to TmpList.Count - 1 do
        begin
          ARec := TLogMessageRec(TmpList[I]);
          if LogObjects.IndexOf(ARec.LogObj) < 0 then
          begin
            LogObjects.Add(ARec.LogObj);
            ARec.LogObj.FFinalStrings.Clear;
          end;

          // Добавляем строку в FFinalStrings
          ARec.LogObj.FFinalStrings.Add(ARec.LogObj.GetFinalLogString(ARec.LogMsg, ARec.LogType, ARec.LogTime, ARec.LogThreadID));

          ARec.Free; // Объект ARec больше не требуется
        end;

        for I := 0 to LogObjects.Count - 1 do
        begin
          ALog := LogObjects[I];
          InitMS();

          RecCnt := ALog.FFinalStrings.Count;
          for J := 0 to RecCnt - 1 do
          begin
            s := ALog.FFinalStrings[J] + sLineBreak;

            ms.Write(s[1], Length(s) * SizeOf(Char));

            if (ms.Position > MaxBufSize) or (J = RecCnt - 1) then
            begin
              ms.SetSize(ms.Position);
              ms.Position := 0;
              ALog.DoLogStr('', tlpNone, 0, 0, ms);
              InitMS();
            end;
          end;

          ALog.FFinalStrings.Clear;

          FCritSect.Enter;
          Dec(ALog.FLazyWriteCounter, RecCnt);
          FCritSect.Leave;

          // Дальше не должно быть никаких обращений к ALog
        end;
      finally
        LogObjects.Free;
        ms.Free;
      end;
    finally
      TmpList.Free;
    end;
  end;
end;

constructor TLazyWriteThread.Create;
begin
  inherited Create(False);
  FEvent := {$IFDEF MSWINDOWS}CreateEvent(nil, False, False, nil){$ELSE}TEvent.Create(nil, False, False, ''){$ENDIF};
  FRecList := TList.Create;
  FCritSect := TCriticalSection.Create;
  FreeOnTerminate := True;
end;

destructor TLazyWriteThread.Destroy;
begin
  Terminate;
  {$IFDEF MSWINDOWS}SetEvent(FEvent){$ELSE}FEvent.SetEvent{$ENDIF};
  inherited;
  {$IFDEF MSWINDOWS}CloseHandle(FEvent){$ELSE}FreeAndNil(FEvent){$ENDIF};
  FRecList.Free;
  FCritSect.Free;

  if FreeOnTerminate then
    LazyWriteThread := nil;
end;

procedure TLazyWriteThread.Execute;
var
  wr: {$IFDEF MSWINDOWS}DWORD{$ELSE}TWaitResult{$ENDIF};
  WaitCount: Integer;
begin
  LazyThreadID := GetCurrentThreadId;
  //messagebox(0, pchar('LazyThreadID='+inttostr(LazyThreadID)), '', 0);

  while True do
  begin
    try
      // Ожидаем запись в лог
      wr := {$IFDEF MSWINDOWS}WaitForSingleObject(FEvent, 5000){$ELSE}FEvent.WaitFor(5000){$ENDIF};

      if wr = {$IFDEF MSWINDOWS}WAIT_OBJECT_0{$ELSE}wrSignaled{$ENDIF} then // Кто-то вызвал SetEvent
      begin
        if (LDSLoggerLazyWriteDelay > 0) then
        begin
          if not SkipDelay then
          begin
            WaitCount := 0;
            while WaitCount < LDSLoggerLazyWriteDelay do
            begin
              if Terminated or SkipDelay then Break;
              Sleep(10);
              Inc(WaitCount, 10);
            end;
          end;

          SkipDelay := False;
        end;
      end;

      // Записывает в лог при необходимости
      CheckWriteToLog;

      if Assigned(LDSOnWriteToFile) then
        LDSOnWriteToFile();
    except
      // ошибки игнорируем (пока)
    end;

    if Terminated then
    begin
      CheckWriteToLog;
      if Assigned(LDSOnWriteToFile) then
        LDSOnWriteToFile();
      Exit;
    end;
  end;
end;

procedure TLazyWriteThread.RegisterLogMsg(ALogObj: TLDSLogger;
  ALogType: TLDSLogType; ALogMsg: string; EventTime: TDateTime);
var
  ARec: TLogMessageRec;
begin
  ARec := TLogMessageRec.Create;
  ARec.LogObj  := ALogObj;
  ARec.LogTime := EventTime;
  ARec.LogType := ALogType;
  UniqueString(ALogMsg);
  ARec.LogMsg := ALogMsg;
  ARec.LogThreadID := GetCurrentThreadId;

  FCritSect.Enter;
  try
    FRecList.Add(ARec);
    Inc(ARec.LogObj.FLazyWriteCounter);
  finally
    FCritSect.Leave;
  end;
  if not LDSLoggerSkipWakeUpThread then
    LazyWriteThread.WakeUp(False);
end;

procedure TLazyWriteThread.WakeUp(ASkipDelay: Boolean);
begin
  SkipDelay := ASkipDelay;
  {$IFDEF MSWINDOWS}SetEvent(FEvent){$ELSE}FEvent.SetEvent{$ENDIF};
end;

procedure DestroyLazyWriteThread(FromDLL: Boolean);
var
  Event: {$IFDEF MSWINDOWS}THandle{$ELSE}TEvent{$ENDIF};
begin
  WasFinalization := True;

  if Assigned(LazyWriteThread) then
  begin
    if FromDLL then
    begin
      Event := LazyWriteThread.FEvent;
      if LDSLoggerLazyWriteDelay > 0 then
        LazyWriteThread.SkipDelay := True;
      LazyWriteThread.Terminate;
      {$IFDEF MSWINDOWS}
      SetEvent(Event); // Ничего страшного, если поток успеет вызвать CloseHandle (ОС разрулит. Ошибки не будет)
      {$ELSE}
      Event.SetEvent; // Опасно, т.к. в линуксе Event - это объект
      {$ENDIF}
      while Assigned(LazyWriteThread) do // Код грязный! Но работать должен и внутри DLL-лек
        Sleep(5);
      Sleep(10); // Даём дополнительное время для выгрузки библиотеки
    end else
    begin
      LazyWriteThread.FreeOnTerminate := False;
      LazyWriteThread.Free;
      LazyWriteThread := nil;
    end;
  end;
end;

initialization
  FillLDSLogWords;
  CreateLogErrorsWriter;
  InitFormatSettings;
  LazyWriteCreateCS := TCriticalSection.Create;
finalization
  DestroyLazyWriteThread(ModuleIsLib);
  LazyWriteCreateCS.Free;
  FreeAndNil(LogErrorsWriter);
end.
