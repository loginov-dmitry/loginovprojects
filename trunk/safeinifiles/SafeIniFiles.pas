{
Copyright (c) 2008-2013, Loginov Dmitry Sergeevich
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
{ ������ SafeIniFiles - ������ ��� ������ � ini-�������                       }
{ (c) 2008-2010 ������� ������� ���������                                     }
{ ��������� ����������: 09.12.2010                                            }
{ ����� �����: http://www.loginovprojects.ru/                                 }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{$DEFINE UseResStr}

{$DEFINE UseGraphics}

{$OVERFLOWCHECKS OFF}

unit SafeIniFiles;

interface

uses
  Windows, SysUtils, Classes, IniFiles, Math,
  DateUtils{$IFDEF UseGraphics}, Graphics{$ENDIF};

{��������� D2009PLUS ����������, ��� ������� ������ Delphi: 2009 ��� ����}
{$IF RTLVersion >= 20.00}
   {$DEFINE D2009PLUS}
{$IFEND}

type
  {RXLib:}
  TReadObjectEvent = function(Sender: TObject; const Section,
    Item, Value: string): TObject of object;
  TWriteObjectEvent = procedure(Sender: TObject; const Section, Item: string;
    Obj: TObject) of object;

  {������������������� ����� ��� ������ � ini-�������. ��� �����������, ���������
   � TIniFile, ��������. ��������� �����. ������ ���������:
   ** 19.06.2008 **
   - ��������� ������ ��������� � ini-����� � ������� ��������. ��� ������� ���
     ����� �������� ������������� ������ � ini-������. � ��������� �������
     �� Windows ���� ������������ �������������, �� �� ����� �� ��� ����������,
     �.�. ���������� �������� ������, ����� Windows ����� � ��� �� ������
     �� ������ ����������� ����� ���� �� �������.

   - ������������ � ��������������� ��������� ����� ������� ������������
     (��������, ��������� �����������). ��������� � ������� SafeIniMaxWriteTime ��
     �������� �������� ������ � ����, ����� ���� ���������� ���������� � ���������
     ������� ������.

   - ������ ���� �� ����������� ������ ��� ����������, �� ������������
     ��������������� ����������, � �� "Access violation in module ntdll.dll"

   - ������������ ������ ����� ��������� ������ �������� ������. � ���� ������
     �� ���������� �� ������������������ ��������, �������� � resSIniLineDelimiter.

   - ����� ����������� �� 2047 ��������, ������������� � TIniFile.ReadString.

   - �������������� ������ � ������ ����� ����� �����. ������� WinAPI ��� ������
     � ini-������� ������������ ������ � ������ �� ����� 65534 �����. ���� �����
     ������������ ������ ��������� ��� ��������, �� ��� ������� �� ���������
     ����� ������ �� ����� 65534 �������. ����������� �������� � ��������
     ���������� ���������� SafeIniTrimLongStrings � SafeIniCheckHash.

   - ������� WriteString ������������� ��������� ������ <"> � ������
     � � ����� ������ ��� �������������. ������ �� ����� ����������� � ����������
     �������� � ���� �������� � ���-�����.

   - ������� WriteFloat, WriteDate, WriteDateTime, WriteTime ������ ����� �
     ini-���� ������ � ������������� �������, ������� �� ������� �� ��������
     ������������ �������. ����� ������������ � ��������� ����������� (���
     ������ ������� ����������� �������������). ������ ������ ����������� � ���
     �� ������������� �������.

   - ��������� ������ WriteQuotedString � ReadQuotedString, ����������� ���������
     ������ � �������� ������� (�� ���������: ������� ������� <">). ����� �������
     ���������� ������������ ������ '`', ������������� �� ������� "�", �.�. ���
     ������ �������� �� ����������� �� ������������. � TSafeIniFile ����� WriteString
     ��������� ������ <"> ������������� (��� �������������).

   - ��������� ������ WriteHexString � ReadHexString, ����������� ����������
     ����� � ���-�������������. ������ ����������� ��������, ����������� �������������
     �� ����������� ������. ��, ��� ��������� � ini, �� � ����� �� ���� �������
     ����-�-���� � ����������.

   - ��������� ������ WriteBinaryData � ReadBinaryData, ����������� ������� �
     ini-����� ������������ �������� ������.

   - ��������� ������ WriteColor, ReadColor, WriteFont, ReadFont, WriteRect,
     ReadRect, WritePoint, ReadPoint, ������ �� RXLib.

   - ��������� ������ WriteList, ReadList, ReadClearList � �������� ListItemName,
     OnReadObject, OnWriteObject, ������ �� RXLib

   - ����������� ���� ��������� � ����� ��������������.

   ** 22.08.2009 **
   - ��������� ��������� ���������� SafeIniMutexExclusive
   - ��������� ���������� ���������� SafeIniCanRaiseMutexError

   ** 21.11.2009 **
    - ������ ����������� ��� ������ � Unicode-�������� Delphi (������������� �� D2010).
      (�������� ���������� �� PByteArray � ������ PChar)
    - ��������� ��������� $OVERFLOWCHECKS OFF

   ** 09.12.2010 **
    - ���������� ������� HexToString, StringToHex. ��� �������� ����������� ��� ��������� Delphi
    - ��������� ��������� ����������� D2009PLUS. ��������� ������� CharInSet (��� ������ Delphi)
    - � ������� WriteBinaryData � ReadBinaryData ������� ������ ���������� ���������
      Buffer. ������ ���� "var Buffer", ������ "Buffer: Pointer". ������� ���������:
      ��������� ���������� �������� Matrix � INI-����. ����� ����, ��� �������
      ������ �������� � D2009PLUS

    - ��������� ������ WriteWideString � ReadWideString, ����������� ��������
      Unicode-������ � INI-���� � ������� �� �� �����.
      ����� �������, ������ TSafeIniFile ����� �������� � ��������, �.�. � ������
      ������� � ������������� Windows. � ������ ������� Delphi ��� ������ �����
      �������� � ���������� ������������ (�������� TNT). ���� �� ����� ������������
      ��� ��������, ������� ������ ��������� ��������, ������ �������������� ����
      � ������, ���� � ����� ������ Delphi. � ��������� ������� Delphi
      ��� ������ ����� ������������ �� ���� �������, ����� ���������� �������� �����.
      ������������ ������ � ��������� �������� � ������� Ansi.
      ������� ��������, ��� �� �������� ������ Unicode-������� ���������
      4 HEX-�������
     }

{����������, ������ �� ��������� ������ "�������" ���� ������������ (�.�. ��������
 ������ ��� ����� ������� ������), ���� � ��� ����� �������� ����������, ����������
 ������������ ��� ������� �������� �������� �������������. �� ��������� ���������
 ���������, �.�. ������� ��������� � ����� �������. ���� ���� ������������ �������
 �� �����-�� �������� ������������ ��������� ������ "�������" � ����� ������, ��
 �������� ��������� SafeIniMutexExclusive (����� � ������ �������) }
{.$DEFINE SafeIniMutexExclusive}

  TSafeIniFile = class(TIniFile)
  private
    FSafeMutex: THandle;
    FAutoSave: Boolean;
    FTrimLongStrings: Boolean;
    FOnReadObject: TReadObjectEvent;
    FOnWriteObject: TWriteObjectEvent;
    FListItemName: string;

    procedure DoDeleteKey(const Section, Ident: String; ClearIdent: Boolean);
    procedure SetTrimLongStrings(const Value: Boolean);
    function GetItemName: string;
    procedure SetItemName(const Value: string);
  protected
    procedure WriteObject(const Section, Item: string; Index: Integer;
      Obj: TObject); dynamic;
    function ReadObject(const Section, Item, Value: string): TObject; dynamic;
  public
    {������� ������ ����������, ����� ���� ��������� ini-����}
    procedure Lock;

    {������� ���������� ini-�����}
    procedure UnLock;
    constructor Create(const FileName: string; AutoSave: Boolean = True);
    destructor Destroy; override;

    {��������� ������ �� ini-�����. ��� ������ �� ����� ��������� ������� ����������,
     ������ ������ ����� �������������� ������, ���� ������ ����� � ���� �����
     ����� ���������� ������ � ini-����.
     ����� ��������� ������ ������ �� ReadBufferSize ��������}
    function ReadString(const Section, Ident, Default: string): string; override;

    {��������� ������ ���������� � ini-����. ������� ��������� � ���������������
     ��������� ����� ������� ������������.
     ��������� �������� ��������� ��� ���������� ������ ������, ����
     ��� ����������� ����������� ��������� ��������� ���� �� ����� �������� �����.
     ������������ TIniFile � ����� ������ ���������� ���������� "Unable to write to...".
     TSafeIniFile �������� ������������ ����� � ������������ �������� ������.
     ���� � ������� SafeIniMaxWriteTime �� ������� ��������� ������ � ����, ��
     ����� ������������� ����������. ������� ������, ����� ������������ �����
     ������ �� ��������� 65534 �������� (���-����� ������ ������� ������� ������)}
    procedure WriteString(const Section, Ident, Value: String); override;

    {��������� �������� Unicode-������ � ini-����. ���� ������� ������ Ansi, ��
     ��� ������������� � Unicode. ������������ ������ � ��������� ������������
     � INI-���� ��� Ansi}
    procedure WriteWideString(const Section, Ident: string; Value: WideString);

    {��������� Unicode-������ �� ini-�����}
    function ReadWideString(const Section, Ident: string; Default: WideString): WideString;

    {��������� ������������ ���������� � ��������� ������}
    procedure ReadSection(const Section: string; Strings: TStrings); override;

    {��������� ������������ ������ � ini-�����}
    procedure ReadSections(Strings: TStrings); override;

    {��������� ���������� ��������� ������ (������ � ������� <����������>=<��������>)}
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;

    {������� ������ �� ini-�����}
    procedure EraseSection(const Section: string); override;

    {������� �������� ���������� �� ������ Section ini-�����}
    procedure DeleteKey(const Section, Ident: String); override;

    {���������� ������ ��������� �� ����}
    procedure UpdateFile; override;

    {������������ ������ ������ � ini-����, �������� �� ����� � ������ ��������
     ��������. ���� QuotedChar �� ���������, ���� ������ ������ #0, �� ��� �����
     ��������� �������� SafeIniQuotedChar. ������� �� ��������� ������� QuotedChar,
     ������������� � ������. ��� �� ���������, �������� �� ����� ��� ��������
     QuotedChar. � ����� ����������� ������������ ������� WriteQuotedString()
     ������ ���. ��� ������������� � �������� ��� ��������� ������ ����������, �
     ������� ��� ���������� ������������� ������ QuotedChar}
    procedure WriteQuotedString(const Section, Ident, Value: String; QuotedChar: Char = #0); overload;

    {������������ ������ ������, ����������� ����� � ������ �������� QuotedChar.
     ������������� ��� ��������� ������ ����������, � ������� ��� ����������
     ������������� ������ QuotedChar}
    function ReadQuotedString(const Section, Ident, Default: string; QuotedChar: Char = #0): string; overload;

    {���������� ������ � ���-����, ���������� �� � HEX-������}
    procedure WriteHexString(const Section, Ident, Value: String);

    {��������� ������ �� ���-�����, ���������� � ��� � HEX-�������}
    function ReadHexString(const Section, Ident, Default: string): string;

    {������ ����� � ��������� ������}
    procedure WriteFloat(const Section, Name: string; Value: Double); override;
    {������ ����� � ��������� ������}
    function ReadFloat(const Section, Name: string; Default: Double): Double; override;

    {������ ����}
    procedure WriteDate(const Section, Name: string; Value: TDateTime); override;
    {������ ����}
    function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime; override;

    {������ ���� � �������}
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime); override;
    {������ ���� � �������}
    function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime; override;

    {������ �������}
    procedure WriteTime(const Section, Name: string; Value: TDateTime); override;
    {������ �������}
    function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime; override;

    {���������� ���������� ������ Buffer � ini-����. ��� ����� ���������� WriteHexString.
     ��� SafeIniTrimLongStrings=False ����� ������������, ��������, ��� ������
     �������� ������������ ��������}
    procedure WriteBinaryData(const Section, Name: string; Buffer: Pointer; BufSize: Integer);

    {��������� �������� ������ �� ini-����� � ����� Buffer. ���� � ini-�����
     ���������� Name ���, �� ������������ Result=0, �� ���������� ������ ��
     ����������. ���� ������ ���� �������, �� � �������� Result ������������
     ����������� �� ���� �������� (������ ������ � ����� ������). ���� Result
     ������ ������� ������, �� ������� ����� � ������ ����������. ��������� �����
     �����, � �������, �������� � ini-���� �������� Byte (1 ����), � ������� ��� �
     ���������� Integer (4 �����) ��� ��������� ����������. �� ��������� ��������
     �������� � 2 ���� ���������, ��� ������� ������ WriteBinaryData}
    function ReadBinaryData(const Section, Name: string; Buffer: Pointer; BufSize: Integer): Integer;

{$IFDEF UseGraphics}
    {RXLib: ���������� ������������ ��� HEX-��� ��������� ����� � ini-����}
    procedure WriteColor(const Section, Ident: string; Value: TColor);

    {RXLib: ��������� �������� ����� �� ini-�����}
    function ReadColor(const Section, Ident: string; Default: TColor): TColor;

    {RXLib: ���������� ��������� ������ � ini-����}
    procedure WriteFont(const Section, Ident: string; Font: TFont);

    {RXLib: ��������� ��������� ������ �� ini-�����}
    function ReadFont(const Section, Ident: string; Font: TFont): TFont;
{$ENDIF}

    {RXLib: ���������� TRect � ini-����}
    procedure WriteRect(const Section, Ident: string; const Value: TRect);

    {RXLib: ��������� TRect �� ini-�����}
    function ReadRect(const Section, Ident: string; const Default: TRect): TRect;

    {RXLib: ���������� TPoint � ini-����}
    procedure WritePoint(const Section, Ident: string; const Value: TPoint);

    {RXLib: ��������� TPoint �� ini-�����}
    function ReadPoint(const Section, Ident: string; const Default: TPoint): TPoint;

    {RXLib: ���������� ������ ����� � ini-����. ��������� ��� ������� ������������
     �������� � ini-���� ��������� ���������� ������� TObject � ��������� �������������}
    procedure WriteList(const Section: string; List: TStrings);

    {RXLib: ��������� ������ ����� �� ini-�����. ��������� ������������ ���������
     �� ini-����� (��� ������-�� ���) ��������� �������� ��� ������ ������ ������.}
    function ReadList(const Section: string; List: TStrings): TStrings;

    {RXLib: ������ ReadList. ��� Append=False ��������� ���������������
     ������� ������}
    function ReadListParam(const Section: string; Append: Boolean;
      List: TStrings): TStrings;

    {���������� ������ �� ������ ������. ������� ��� ������������� � ��������� WITH}
    function ThisIniFile: TSafeIniFile;

    {�� ��, ��� � SafeIniTrimLongStrings, �� �������� ������ ��� ����������� �������}
    property TrimLongStrings: Boolean read FTrimLongStrings write SetTrimLongStrings;

    {��������� ����� AText �� ������ � ���������� �� � AList. �������� ������
     �������� ������. ��������� ��������� � �������� ������ <">, ���� ����
     ��������� ������ ��� ��������� �������.}
    procedure PutTextToList(const AText: string;
      AList: TStringList);

    {RXLib:}
    property ListItemName: string read GetItemName write SetItemName; 
    property OnReadObject: TReadObjectEvent read FOnReadObject write FOnReadObject;
    property OnWriteObject: TWriteObjectEvent read FOnWriteObject write FOnWriteObject;
  end;

{���������� ��� �������� ��� ��������� ����� ��� ����� ����������� ��� ����������}
function GenerateFileMutexName(const MutexPrefix, AFileName: string): string;

{���������� ��� ������ �� ��������� ROT13}
function GenerateStringHashROT13(const S: string): Cardinal;

{������������ ������ HEX � ������ ANSI. ���� � ������ S ����������� �� HEX �������,
 �� ��� ��� ������������ "?". ���� ����� ���������� ������� ��������,
 �� �� ������������. ��������! ������ Unicode ����������� � Ansi!}
function HexToString(const S: string): string;

{������������ ������ � 16-������ ������ (������� ������� ANSI �����. 2 ������� HEX)}
function StringToHex(const S: string): string;

{���������, �������� �� ������ ������ ������� ���}
function IsTrueHexString(const S: string): Boolean;

{$IFDEF UseGraphics}
{RXLib: ��������� �������������� ����� ������ � ������}
function FontStylesToString(Styles: TFontStyles): string;

{RXLib: ��������� �������������� ������ � ������}
function FontToString(Font: TFont): string;

{RXLib: ��������� �������������� ������ � �����}
procedure StringToFont(const Str: string; Font: TFont);

{RXLib: ��������� �������������� ������ � ����� ������}
function StringToFontStyles(const Styles: string): TFontStyles;

{$ENDIF UseGraphics}

{RXLib:}
function RectToStr(Rect: TRect): string;

{RXLib:}
function StrToRect(const Str: string; const Def: TRect): TRect;

{RXLib:}
function PointToStr(P: TPoint): string;

{RXLib:}
function StrToPoint(const Str: string; const Def: TPoint): TPoint;

{��������� ������� ����  ��������� ��������� ������ SafeIniFiles. LangFileName -
 ��� ��������� �����. SafeIniSection - ��� ������}
procedure TranslateSafeIniMessages(const LangFileName: string;
  const SafeIniSection: string = 'SafeIniSection');

{$IFDEF UseResStr}
resourcestring
  resSIniEmptySection = '�� ������� �������� ������. ��� �����: %s';
  resSIniVariableNotSpecified = '�� ������� �������� ����������. ��� �����: %s';
  resSIniCanNotSaveChanges = '�� ������� �������� ��������� � ���� %s';
  resSIniDateFormat = 'dd.mm.yyyy';
  resSIniTimeFormat = 'hh:nn:ss.zzzz';
  resSIniDateSeparator = '.';
  resSIniTimeSeparator = ':';
  resSIniDecimalSeparator = '.';
  resSIniLineDelimiter = '<' + '@\n@' + '>';
  resSIniQuotedChar = '"';
  resSIniListItemName = 'Item';
  resSIniListItemsCount = 'Count';
{$ELSE}
var
  resSIniEmptySection: string = '�� ������� �������� ������. ��� �����: %s';
  resSIniVariableNotSpecified: string = '�� ������� �������� ����������. ��� �����: %s';
  resSIniCanNotSaveChanges: string = '�� ������� �������� ��������� � ���� "%s"';
  resSIniDateFormat: string = 'dd.mm.yyyy';
  resSIniTimeFormat: string = 'hh:nn:ss.zzzz';
  resSIniDateSeparator: string = '.';
  resSIniTimeSeparator: string = ':';
  resSIniDecimalSeparator: string = '.';
  resSIniLineDelimiter: string = '<' + '@\n@' + '>';
  resSIniQuotedChar: string = '"';
  resSIniListItemName: string = 'Item';
  resSIniListItemsCount: string = 'Count';
{$ENDIF}

var
  SafeIniFormatSettings: TFormatSettings;

  // �����, � ������� ������� ��������� ������� ������ � ini-���� (��).
  SafeIniMaxWriteTime: Integer = 1000;

  // ���������� ����� ������ � ������ ������� �����. ���� ����� True, �� ���
  // ������ ������� ������ ��� ������ ���������� �� 65534 ��������.
  // ���� ����� False, �� ������� ������ ������� �� ��������� �������� �����.
  // ����������� ���������� IdentName__$Count, IdentName__$Line2,
  // IdentName__$Line3...IdentName__$LineN � IdentName__$Hash.
  // ���� �� ���������� ������� � ini-������ ����� ������������ �����, ��
  // ���������� ������ �������� � False, ���� ���������� � False ��������
  // TSafeIniFile.TrimLongStrings ����� �������� ������� TSafeIniFile.
  // � ���� ������ ������������������ ����� ������������� ���������. 
  SafeIniTrimLongStrings: Boolean = False;

  // ����������, ������� �� ��������� ��� ��� ������ ������, �������� ��
  // ��������� �����. ��� ������������� ��������� ������ (��������) ������ �����
  // �������������� ������� (���� �������� �������� Default), � ���������
  // ������ ����� ������� ������ ���� ������ ������ ������������� ������ ����
  SafeIniCheckHash: Boolean = True;

  {����������, ����� �� ������������ ����������, ���� �� ������� ������� ������
  "�������". �� ��������� ���������� �� ������������. }
  SafeIniCanRaiseMutexError: Boolean = False;

implementation

{$IFNDEF D2009PLUS}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;
{$ENDIF}

function ReCreateEObject(E: Exception; const FuncName: string): Exception;
var
  S: string;
begin
  S := Format('%s -> %s', [FuncName, E.Message]);
  Result := ExceptClass(E.ClassType).Create(S);
end;

{ ������� �������. ��������� ����� �������� ���������� SafeIniMutexExclusive }
function SafeIniCreateMutex(AName: string): Cardinal;
var
{$IFNDEF SafeIniMutexExclusive}
  SD:TSecurityDescriptor;
  SA:TSecurityAttributes;
{$ENDIF}
  pSA: PSecurityAttributes;
begin
{$IFNDEF SafeIniMutexExclusive}
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

  Result := CreateMutex(pSA, False, PChar('Global\' + AName)); // �������� ������� � ���������� Global
  if Result = 0 then
    Result := CreateMutex(pSA, False, PChar(AName)); // �������� ������� ��� ��������� Global

  if Result = 0 then
    if SafeIniCanRaiseMutexError then
      raise Exception.CreateFmt('Error CreateMutex: %s', [SysErrorMessage(GetLastError)]);
end;

{ TSafeIniFile }

constructor TSafeIniFile.Create(const FileName: string; AutoSave: Boolean = True);
var
  SMutex: string;
begin
  SMutex := GenerateFileMutexName('ini file lock mutex', FileName);

  FSafeMutex := SafeIniCreateMutex(SMutex);

  FTrimLongStrings := SafeIniTrimLongStrings;  

  FListItemName := resSIniListItemName;

  inherited Create(FileName);
end;

procedure TSafeIniFile.DeleteKey(const Section, Ident: String);
begin
  try
    if Section = '' then
      raise EIniFileException.CreateFmt(resSIniEmptySection, [FileName]);

    if Ident = '' then
      raise EIniFileException.CreateFmt(resSIniVariableNotSpecified, [FileName]);

    Lock;
    try
      if FTrimLongStrings then
        inherited DeleteKey(Section, Ident) // ������� ���� ��������
      else
        DoDeleteKey(Section, Ident, True); // ������� ��� �������������� ���������

      if FAutoSave then
        UpdateFile;
    finally
      UnLock;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.DeleteKey');
  end;
end;

destructor TSafeIniFile.Destroy;
begin
  Lock;
  try
    // ���������� ��������� ����� TIniFile �� �����������!
    inherited;
  finally
    UnLock;        
    CloseHandle(FSafeMutex);
  end;
end;

procedure TSafeIniFile.DoDeleteKey(const Section, Ident: String;
  ClearIdent: Boolean);
var
  C: Integer;
begin
  Lock;
  try
    // ������� �� ini-����� ��� ������ (���������� �� FTrimLongStrings)
    C := ReadInteger(Section, Ident + '__$Count', -High(Word));

    // ���� ������ ������� �� �����, �� ��������� ��� �����
    if C <> -High(Word) then
    begin
      // ������� ������
      inherited DeleteKey(Section, Ident + '__$Count');
      inherited DeleteKey(Section, Ident + '__$Hash');
      while C > 1 do
      begin
        inherited DeleteKey(Section, Ident + '__$Line' + IntToStr(C));
        Dec(C);
      end;
    end;

    // ������� ���� ������
    if ClearIdent then
      inherited DeleteKey(Section, Ident);
  finally
    UnLock;
  end;
end;

procedure TSafeIniFile.EraseSection(const Section: string);
begin
  try
    if Section = '' then
      raise EIniFileException.CreateFmt(resSIniEmptySection, [FileName]);

    Lock;
    try
      inherited;
      if FAutoSave then
        UpdateFile;
    finally
      UnLock;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.EraseSection');
  end;
end;

procedure TSafeIniFile.Lock;
begin
  if FSafeMutex <> 0 then
    WaitForSingleObject(FSafeMutex, INFINITE);
end;

function TSafeIniFile.ReadBinaryData(const Section, Name: string;
  Buffer: Pointer; BufSize: Integer): Integer;
var
  S: AnsiString;
  SourBufAddr: PByte;
begin
  try
    Result := 0;
    S := AnsiString(ReadHexString(Section, Name, ''));
    if S <> '' then
    begin
      Result := Min(BufSize, Length(S));
      SourBufAddr := PByte(PAnsiChar(S));
      MoveMemory(Buffer, SourBufAddr, Result);

      // �������� ������������� ����� ������
      if Result < BufSize then
        FillChar(PByte(Integer(@Buffer) + Result)^, BufSize - Result, 0);
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.ReadBinaryData');
  end;
end;

function TSafeIniFile.ReadDate(const Section, Name: string;
  Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDate(DateStr, SafeIniFormatSettings);
  except
    on E: Exception do
    begin
      if not (E is EConvertError) then
        raise ReCreateEObject(E, 'TSafeIniFile.ReadDate');
    end;
  end;
end;

function TSafeIniFile.ReadDateTime(const Section, Name: string;
  Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDateTime(DateStr, SafeIniFormatSettings);
  except
    on E: Exception do
    begin
      if not (E is EConvertError) then
        raise ReCreateEObject(E, 'TSafeIniFile.ReadDateTime');
    end;
  end;
end;

function TSafeIniFile.ReadFloat(const Section, Name: string;
  Default: Double): Double;
var
  FloatStr: string;
begin
  FloatStr := ReadString(Section, Name, '');

  Result := Default;
  if FloatStr <> '' then
  try
    Result := StrToFloat(FloatStr, SafeIniFormatSettings);
  except
    on E: Exception do
    begin
      if not (E is EConvertError) then
        raise ReCreateEObject(E, 'TSafeIniFile.ReadFloat');
    end;
  end;
end;

function TSafeIniFile.ReadHexString(const Section, Ident,
  Default: string): string;
begin
  try
    Result := HexToString(ReadString(Section, Ident, StringToHex(Default)));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.ReadHexString');
  end;
end;

function TSafeIniFile.ReadQuotedString(const Section, Ident,
  Default: string; QuotedChar: Char): string;
begin
  try
    if QuotedChar = #0 then
      if resSIniQuotedChar = '' then
        QuotedChar := '"'
      else
        QuotedChar := resSIniQuotedChar[1];

    Result := ReadString(Section, Ident, Default);
    if Result <> '' then
      if (Result[1] = QuotedChar) and (Result[Length(Result)] = QuotedChar) then
        Result := Copy(Result, 2, Length(Result) - 2);
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.ReadQuotedString');
  end;
end;

procedure TSafeIniFile.ReadSection(const Section: string; Strings: TStrings);
begin
  try
    if Section = '' then
      raise EIniFileException.CreateFmt(resSIniEmptySection, [FileName]);

    Lock;
    try
      inherited;
    finally
      UnLock;
    end;

  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.ReadSection');
  end;
end;

procedure TSafeIniFile.ReadSections(Strings: TStrings);
begin
  Lock;
  try
    inherited;
  finally
    UnLock;
  end;
end;

procedure TSafeIniFile.ReadSectionValues(const Section: string;
  Strings: TStrings);
begin
  try
    if Section = '' then
      raise EIniFileException.CreateFmt(resSIniEmptySection, [FileName]);

    Lock;
    try
      inherited;
    finally
      UnLock;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.ReadSectionValues');
  end;
end;

function TSafeIniFile.ReadString(const Section, Ident, Default: string): string;

  function DoReadString(const Section, Ident, Default: string; Hash: PInteger = nil): string;
  var
    I, C, J: Integer;
    BArray, SArray: PChar;
    S: string;
    Breaked: Boolean;
  begin
    SetLength(Result, High(Word));
    GetPrivateProfileString(PChar(Section),
      PChar(Ident), PChar(Default), PChar(Result), Length(Result), PChar(FileName));
      
    if Assigned(Hash) then
    begin
      S := PChar(Result);
      Hash^ := Integer(GenerateStringHashROT13(S));
    end;

    if resSIniLineDelimiter = '' then
      Result := PChar(Result)
    else        
    begin
      BArray := PChar(Result);
      if Length(resSIniLineDelimiter) = 1 then
        SetLength(S, High(Word) * 2)
      else
        SetLength(S, High(Word));

      SArray := PChar(S);
      // �������� resSIniLineDelimiter �� sLineBreak
      C := 0;
      I := 0;
      while I < High(Word) + 1 do
      begin
        if BArray[I] = #0 then
          Break;
        // ��������� �� ���������� � resSIniLineDelimiter
        if BArray[I] = resSIniLineDelimiter[1] then
        begin
          // �������� ���� ����� �������� ������� �������
          Breaked := False;
          for J := 2 to Length(resSIniLineDelimiter) do
            if (I + J - 1 > 65535) or (BArray[I + J - 1] <> resSIniLineDelimiter[J]) then
            begin
              Breaked := True;
              Break;
            end;

          if Breaked then
          begin
            SArray[C] := BArray[I];
            Inc(I);
            Inc(C);
          end else
          begin
            for J := 1 to Length(sLineBreak) do
              SArray[C + J - 1] := Char(sLineBreak[J]);
            Inc(C, Length(sLineBreak));
            Inc(I, Length(resSIniLineDelimiter));
          end;
        end else
        begin
          SArray[C] := BArray[I];
          Inc(I);
          Inc(C);
        end;
      end;

      Result := Copy(S, 1, C);
    end;
  end;

var
  I, C, Hash, Hash1: Integer;
begin
  try
    if Section = '' then
      raise EIniFileException.CreateFmt(resSIniEmptySection, [FileName]);

    if Ident = '' then
      raise EIniFileException.CreateFmt(resSIniVariableNotSpecified, [FileName]);

    Lock;
    try
      if FTrimLongStrings then
        Result := DoReadString(Section, Ident, Default)
      else
      begin
        C := StrToIntDef(DoReadString(Section, Ident + '__$Count', ''), -High(Word));

        if SafeIniCheckHash then
          Result := DoReadString(Section, Ident, Default, @Hash1)
        else
        begin
          Result := DoReadString(Section, Ident, Default, nil);
          Hash1 := 0;
        end;

        if C > 1 then // ���� ���� ��� ������
        begin
          if TryStrToInt(DoReadString(Section, Ident + '__$Hash', ''), Hash) then
          begin
            if not SafeIniCheckHash then
              Hash := 0;
              
            if Hash = Hash1 then
            begin
              for I := 2 to C do
                Insert(DoReadString(Section, Ident + '__$Line' + IntToStr(I), ''),
                  Result, Length(Result) + 1);
            end;
          end;
        end;
      end;
    finally
      UnLock;
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.ReadString');
  end;
end;

function TSafeIniFile.ReadTime(const Section, Name: string;
  Default: TDateTime): TDateTime;
var
  TimeStr: string;
begin
  TimeStr := ReadString(Section, Name, '');
  Result := Default;
  if TimeStr <> '' then
  try
    Result := StrToTime(TimeStr, SafeIniFormatSettings);
  except
    on E: Exception do
    begin
      if not (E is EConvertError) then
        raise ReCreateEObject(E, 'TSafeIniFile.ReadTime');
    end;
  end;
end;

function TSafeIniFile.ReadWideString(const Section, Ident: string;
  Default: WideString): WideString;
const
  EmptyStr = '_$EmptyString$_';
var
  S: AnsiString;
  SourBufAddr, DestBufAddr: PByte;
begin
  try
    // ���������, ���� �� ����� ������ � ini-�����
    S := AnsiString(ReadString(Section, Ident, EmptyStr));
    if S = EmptyStr then // ���� ���������� � INI-����� ���, �� �������
    begin
      Result := Default;
      Exit;
    end;

    Result := '';

    S := AnsiString(ReadHexString(Section, Ident, ''));
    if S <> '' then
    begin
      SetLength(Result, Length(S) div 2);
      SourBufAddr := PByte(PAnsiChar(S));
      DestBufAddr := PByte(PWideChar(Result));
      MoveMemory(DestBufAddr, SourBufAddr, Length(S));
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.ReadBinaryData');
  end;
end;

procedure TSafeIniFile.SetTrimLongStrings(const Value: Boolean);
begin
  FTrimLongStrings := Value;
end;

procedure TSafeIniFile.WriteObject(const Section, Item: string; Index: Integer;
  Obj: TObject);
begin
  if Assigned(FOnWriteObject) then FOnWriteObject(Self, Section, Item, Obj);
end;

function TSafeIniFile.ReadObject(const Section, Item, Value: string): TObject;
begin
  Result := nil;
  if Assigned(FOnReadObject) then Result := FOnReadObject(Self, Section, Item, Value);
end;

function TSafeIniFile.ThisIniFile: TSafeIniFile;
begin
  Result := Self;
end;

procedure TSafeIniFile.UnLock;
begin
  if FSafeMutex <> 0 then
    ReleaseMutex(FSafeMutex);
end;

procedure TSafeIniFile.UpdateFile;
begin
  Lock;
  try
    inherited;
  finally
    UnLock;
  end;
end;

procedure TSafeIniFile.WriteBinaryData(const Section, Name: string;
  Buffer: Pointer; BufSize: Integer);
var
  S: string;
begin
  try
    SetString(S, PAnsiChar(Buffer), BufSize);
    WriteHexString(Section, Name, S);
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteBinaryData');
  end;
end;

procedure TSafeIniFile.WriteDate(const Section, Name: string;
  Value: TDateTime);
begin
  try
    WriteString(Section, Name, DateToStr(Value, SafeIniFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteDate');
  end;
end;

procedure TSafeIniFile.WriteDateTime(const Section, Name: string;
  Value: TDateTime);
begin
  try
    WriteString(Section, Name, DateTimeToStr(Value, SafeIniFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteDateTime');
  end;
end;

procedure TSafeIniFile.WriteFloat(const Section, Name: string;
  Value: Double);
begin
  try
    WriteString(Section, Name, FloatToStr(Value, SafeIniFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteFloat');
  end;
end;

procedure TSafeIniFile.WriteHexString(const Section, Ident, Value: String);
begin
  try
    WriteString(Section, Ident, StringToHex(Value));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteHexString');
  end;
end;

procedure TSafeIniFile.WriteQuotedString(const Section, Ident, Value: String; QuotedChar: Char);
begin
  try
    if QuotedChar = #0 then
      if resSIniQuotedChar = '' then
        QuotedChar := '"'
      else
        QuotedChar := resSIniQuotedChar[1];

    WriteString(Section, Ident, QuotedChar + Value + QuotedChar);
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteQuotedString');
  end;
end;

procedure TSafeIniFile.PutTextToList(const AText: string; AList: TStringList);
var
  I, J, C: Integer;
  S: string;
 // BArray, SArray: PByteArray;
  BArray, SArray: PChar;
  FirstString: string;

  procedure AddToList();
  var
    S1: string;
  begin
    S1 := Copy(S, 1, C);
    if FirstString = '' then
      FirstString := S1;
    if S1 <> '' then
      if (S1[1] <= ' ') or (S1[1] = '"') or (S1[Length(S1)] <= ' ') or
       (S1[Length(S1)] = '"') then
      S1 := '"' + S1 + '"';
    AList.Add(S1);
  end;

begin
  AList.Clear;

  if AText <> '' then
  begin
    //BArray := PByteArray(AText);
    BArray := PChar(AText);
    // �������� ������ ��� �����
    SetLength(S, High(Word));
    //SArray := PByteArray(S);
    SArray := PChar(S);
    C := 0;
    for I := 0 to Length(AText) - 1 do // ���������� ��� ������� � �������� ������
    begin
      // ���� ������ ��� ��������� ���������, �� ��������� �� � AList
      if C = 65532 then
      begin
        AddToList();
        if FTrimLongStrings then Exit;
        C := 0;
      end;

      if BArray[I] = #10 then
      begin
        // ���� � ���������� �������� ��������� ������� ������� ������, ��
        // ������������ �� �������
        if C + Length(resSIniLineDelimiter) > 65532 then
        begin
          AddToList();
          if FTrimLongStrings then Exit;
          C := 0;
        end;
        // �������� ������� ��������� ������
        for J := 1 to Length(resSIniLineDelimiter) do
        begin
          SArray[C] := resSIniLineDelimiter[J];
          Inc(C);
        end;
      end else if BArray[I] <> #13 then
      begin
        SArray[C] := BArray[I];
        Inc(C);
      end;
      // ����� Inc(C) ������� ������!
    end;

    if C > 0 then
      AddToList();

    if AList.Count > 1 then
      AList.Objects[0] := TObject(GenerateStringHashROT13(FirstString));
  end;               
end;

procedure TSafeIniFile.WriteString(const Section, Ident, Value: String);
const
  SleepTime = 20;
  FileErrors = [ERROR_PATH_NOT_FOUND, ERROR_BUFFER_OVERFLOW,
    ERROR_DISK_FULL, ERROR_INVALID_NAME];
var
  NoExcept: Boolean;
  EndTime: TDateTime;
  I: Integer;
  AList: TStringList;

  procedure DoWriteString(const Section, Ident, Value: string);
  begin
    // ���������� ������
    EndTime := IncMilliSecond(Now, SafeIniMaxWriteTime);
    repeat
      try
        inherited WriteString(Section, Ident, Value);
        NoExcept := True;
      except
        on E: Exception do
        begin
          NoExcept := False;
          if (Now >= EndTime) or (GetLastError in FileErrors) then
            raise ReCreateEObject(E, SysErrorMessage(GetLastError))
          else
            Sleep(SleepTime);
        end;
      end;
    until NoExcept = True;
  end;
begin
  try
    if Section = '' then
      raise EIniFileException.CreateFmt(resSIniEmptySection, [FileName]);

    if Ident = '' then
      raise EIniFileException.CreateFmt(resSIniVariableNotSpecified, [FileName]);

    AList := TStringList.Create;
    try
      PutTextToList(Value, AList);

      NoExcept := False;

      Lock;

      try
        // ������� ��� ������ �� ini-�����, ����� ������ Ident
        if not FTrimLongStrings then
          DoDeleteKey(Section, Ident, False); // � ���� ����� ������� ������� �� �������� �������

        if AList.Count = 0 then
        begin
          DoWriteString(Section, Ident, '');
        end else
        begin
          // ���������� �������� ������
          DoWriteString(Section, Ident, AList[0]);
          if (AList.Count > 1) and (not FTrimLongStrings) then
          begin
            // ���������� ���-�� �����
            DoWriteString(Section, Ident + '__$Count', IntToStr(AList.Count));

            // ���������� ��� ������ AList[0]
            DoWriteString(Section, Ident + '__$Hash', IntToStr(Integer(AList.Objects[0])));

            // ���������� ��������� �����
            for I := 1 to AList.Count - 1 do
              DoWriteString(Section, Ident + '__$Line' + IntToStr(I + 1), AList[I]);
          end;
        end;

        // ���������� ��������� � ����
        if FAutoSave then
        begin
          EndTime := IncMilliSecond(Now, SafeIniMaxWriteTime);
          repeat
            try
              if not WritePrivateProfileString(nil, nil, nil, PChar(FileName)) then
                raise EIniFileException.CreateFmt(resSIniCanNotSaveChanges, [FileName]);
              NoExcept := True;
            except
              on E: Exception do
              begin
                NoExcept := False;
                if (Now >= EndTime) or (GetLastError in FileErrors) then
                  raise ReCreateEObject(E, SysErrorMessage(GetLastError))
                else
                  Sleep(SleepTime);
              end;
            end;
          until NoExcept = True;
        end;
      finally
        UnLock;
      end;
    finally
      AList.Free;
    end;

  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteString');
  end;
end;

procedure TSafeIniFile.WriteTime(const Section, Name: string;
  Value: TDateTime);
begin
  try
    WriteString(Section, Name, TimeToStr(Value, SafeIniFormatSettings));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteTime');
  end;
end;

procedure TSafeIniFile.WriteWideString(const Section, Ident: string;
  Value: WideString);
begin
  if Value = '' then
    WriteString(Section, Ident, '') // ���������� ������ ������
  else
    WriteBinaryData(Section, Ident, PWideChar(Value), Length(Value) * SizeOf(WideChar));
end;

{$IFDEF UseGraphics}

procedure TSafeIniFile.WriteColor(const Section, Ident: string;
  Value: TColor);
begin
  WriteString(Section, Ident, ColorToString(Value));
end;

function TSafeIniFile.ReadColor(const Section, Ident: string;
  Default: TColor): TColor;
begin
  try
    Result := StringToColor(ReadString(Section, Ident,
      ColorToString(Default)));
  except
    Result := Default;
  end;
end;

procedure TSafeIniFile.WriteFont(const Section, Ident: string;
  Font: TFont);
begin
  try
    WriteString(Section, Ident, FontToString(Font));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteFont');
  end;
end;

function TSafeIniFile.ReadFont(const Section, Ident: string; Font: TFont): TFont;
begin
  Result := Font;
  try
    StringToFont(ReadString(Section, Ident, FontToString(Font)), Result);
  except
    { do nothing, ignore any exceptions }
  end;
end;

{$ENDIF UseGraphics}

procedure TSafeIniFile.WriteRect(const Section, Ident: string; const Value: TRect);
begin
  try
    WriteString(Section, Ident, RectToStr(Value));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteRect');
  end;
end;

function TSafeIniFile.ReadRect(const Section, Ident: string; const Default: TRect): TRect;
begin
  Result := StrToRect(ReadString(Section, Ident, RectToStr(Default)), Default);
end;

procedure TSafeIniFile.WritePoint(const Section, Ident: string; const Value: TPoint);
begin
  try
    WriteString(Section, Ident, PointToStr(Value));
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WritePoint');
  end;
end;

function TSafeIniFile.ReadPoint(const Section, Ident: string; const Default: TPoint): TPoint;
begin
  Result := StrToPoint(ReadString(Section, Ident, PointToStr(Default)), Default);
end;

procedure TSafeIniFile.WriteList(const Section: string; List: TStrings);
var
  I: Integer;
begin
  try
    EraseSection(Section);
    WriteInteger(Section, resSIniListItemsCount, List.Count);
    for I := 0 to List.Count - 1 do begin
      WriteString(Section, ListItemName + IntToStr(I), List[I]);
      WriteObject(Section, ListItemName + IntToStr(I), I, List.Objects[I]);
    end;
  except
    on E: Exception do
      raise ReCreateEObject(E, 'TSafeIniFile.WriteList');
  end;
end;

function TSafeIniFile.ReadList(const Section: string; List: TStrings): TStrings;
begin
  Result := ReadListParam(Section, True, List);
end;
function TSafeIniFile.GetItemName: string;
begin
  Result := FListItemName;
end;

procedure TSafeIniFile.SetItemName(const Value: string);
begin
  FListItemName := Value;
end;

function TSafeIniFile.ReadListParam(const Section: string; Append: Boolean;
  List: TStrings): TStrings;
var
  I, IniCount: Integer;
  AssString: string;
begin
  Result := List;
  IniCount := ReadInteger(Section, resSIniListItemsCount, -1);
  if IniCount >= 0 then begin
    if not Append then List.Clear;
    for I := 0 to IniCount - 1 do begin
      AssString := ReadString(Section, ListItemName + IntToStr(I), '<@default@>');
      if AssString <> '<@default@>' then
        List.AddObject(AssString, ReadObject(Section, ListItemName +
          IntToStr(I), AssString));
    end;
  end;
end;

function GenerateFileMutexName(const MutexPrefix, AFileName: string): string;
var
  I: Integer;
begin
  Result := MutexPrefix + AnsiLowerCase(AFileName);

  // ������� ��� ������� ������� backslash
  while Pos('\\', Result) > 0 do
    Result := StringReplace(Result, '\\', '\', [rfReplaceAll]);
  

  for I := 1 to Length(Result) do
    if CharInSet(Result[I], ['\', '/', ':', '*', '"', '?', '|', '<', '>']) then
      Result[I] := '_';
end;

function IsTrueHexString(const S: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(S) do
    if not CharInSet(S[I], ['0'..'9', 'A'..'F', 'a'..'f']) then
      Exit;
  Result := True;
end;

function StringToHex(const S: string): string;
var
  I: Integer;
  S1: string;
  CharCode: Integer;
  AnsiSt: AnsiString;
begin
  AnsiSt := AnsiString(S);
  SetLength(Result, Length(AnsiSt) * 2);
  for I := 1 to Length(AnsiSt) do
  begin
    CharCode := Ord(AnsiSt[I]);
    S1 := IntToHex(CharCode, 2);
    Result[I * 2 - 1] := S1[1];
    Result[I * 2] := S1[2];
  end;
end;

function HexToString(const S: string): string;
var
  I: Integer;
  S1: string;
  AnsiSt: AnsiString;
begin
  SetLength(AnsiSt, Length(S) div 2);
  for I := 1 to Length(S) div 2 do
  begin
    S1 := Copy(S, I * 2 - 1, 2);
    AnsiSt[I] := AnsiChar(StrToIntDef('$' + S1, Ord('?')));
  end;
  Result := string(AnsiSt);
end;

{$IFDEF UseGraphics}

function FontStylesToString(Styles: TFontStyles): string;
begin
  Result := '';
  if fsBold in Styles then Result := Result + 'B';
  if fsItalic in Styles then Result := Result + 'I';
  if fsUnderline in Styles then Result := Result + 'U';
  if fsStrikeOut in Styles then Result := Result + 'S';
end;

function FontToString(Font: TFont): string;
begin
  with Font do
    Result := Format('%s,%d,%s,%d,%s,%d', [Name, Size,
      FontStylesToString(Style), Ord(Pitch), ColorToString(Color), Charset]);
end;

type
  TCharSet = set of AnsiChar;

function ExtractSubstr(const S: string; var Pos: Integer;
  const Delims: TCharSet): string;
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and not CharInSet(S[I], Delims) do Inc(I);
  Result := Copy(S, Pos, I - Pos);
  if (I <= Length(S)) and CharInSet(S[I], Delims) then Inc(I);
  Pos := I;
end;

type
  THackFont = class(TFont);

procedure StringToFont(const Str: string; Font: TFont);
const
  Delims = [',', ';'];
var
  FontChange: TNotifyEvent;
  Pos: Integer;
  I: Byte;
  S: string;
begin
  FontChange := Font.OnChange;
  Font.OnChange := nil;
  try
    Pos := 1;
    I := 0;
    while Pos <= Length(Str) do begin
      Inc(I);
      S := Trim(ExtractSubstr(Str, Pos, Delims));
      case I of
        1: Font.Name := S;
        2: Font.Size := StrToIntDef(S, Font.Size);
        3: Font.Style := StringToFontStyles(S);
        4: Font.Pitch := TFontPitch(StrToIntDef(S, Ord(Font.Pitch)));
        5: Font.Color := StringToColor(S);
        6: Font.Charset := TFontCharset(StrToIntDef(S, Font.Charset));
      end;
    end;
  finally
    Font.OnChange := FontChange;
    THackFont(Font).Changed;
  end;
end;

function StringToFontStyles(const Styles: string): TFontStyles;
begin
  Result := [];
  if Pos('B', UpperCase(Styles)) > 0 then Include(Result, fsBold);
  if Pos('I', UpperCase(Styles)) > 0 then Include(Result, fsItalic);
  if Pos('U', UpperCase(Styles)) > 0 then Include(Result, fsUnderline);
  if Pos('S', UpperCase(Styles)) > 0 then Include(Result, fsStrikeOut);
end;

{$ENDIF UseGraphics}

function RectToStr(Rect: TRect): string;
begin
  with Rect do
    Result := Format('[%d,%d,%d,%d]', [Left, Top, Right, Bottom]);
end;

function StrToRect(const Str: string; const Def: TRect): TRect;
const
  Lefts  = ['[', '{', '('];
  Rights = [']', '}', ')'];
var
  S: string;
  Temp: string;
  I: Integer;
begin
  Result := Def;
  S := Str;
  if CharInSet(S[1], Lefts) and CharInSet(S[Length(S)], Rights) then
  begin
    Delete(S, 1, 1);
    SetLength(S, Length(S) - 1);
  end;
  I := Pos(',', S);
  if I > 0 then
  begin
    Temp := Trim(Copy(S, 1, I - 1));
    Result.Left := StrToIntDef(Temp, Def.Left);
    Delete(S, 1, I);
    I := Pos(',', S);
    if I > 0 then
    begin
      Temp := Trim(Copy(S, 1, I - 1));
      Result.Top := StrToIntDef(Temp, Def.Top);
      Delete(S, 1, I);
      I := Pos(',', S);
      if I > 0 then
      begin
        Temp := Trim(Copy(S, 1, I - 1));
        Result.Right := StrToIntDef(Temp, Def.Right);
        Delete(S, 1, I);
        Temp := Trim(S);
        Result.Bottom := StrToIntDef(Temp, Def.Bottom);
      end;
    end;
  end;
end;

function PointToStr(P: TPoint): string;
begin
  with P do Result := Format('[%d,%d]', [X, Y]);
end;

function StrToPoint(const Str: string; const Def: TPoint): TPoint;
const
  Lefts  = ['[', '{', '('];
  Rights = [']', '}', ')'];
var
  S: string;
  Temp: string;
  I: Integer;
begin
  Result := Def;
  S := Str;
  if CharInSet(S[1], Lefts) and CharInSet(S[Length(Str)], Rights) then
  begin
    Delete(S, 1, 1);
    SetLength(S, Length(S) - 1);
  end;
  I := Pos(',', S);
  if I > 0 then
  begin
    Temp := Trim(Copy(S, 1, I - 1));
    Result.X := StrToIntDef(Temp, Def.X);
    Delete(S, 1, I);
    Temp := Trim(S);
    Result.Y := StrToIntDef(Temp, Def.Y);
  end;
end;

function GenerateStringHashROT13(const S: string): Cardinal;
var
  Hash: Cardinal;
  I: Integer;
begin
  Hash := 0;
  for I := 1 to Length(S) do
  begin
    Hash := Hash + Ord(S[I]);
    Hash := Hash - ((Hash shl 13) or (Hash shr 19));
  end;
  Result := Cardinal(Hash);
end;

procedure UpdateIniFormatSettings;
begin
  GetLocaleFormatSettings(0, SafeIniFormatSettings);
  SafeIniFormatSettings.LongDateFormat := resSIniDateFormat;
  SafeIniFormatSettings.ShortDateFormat := resSIniDateFormat;
  SafeIniFormatSettings.LongTimeFormat := resSIniTimeFormat;
  SafeIniFormatSettings.ShortTimeFormat := resSIniTimeFormat;
  if resSIniDateSeparator <> '' then
    SafeIniFormatSettings.DateSeparator := resSIniDateSeparator[1];
  if resSIniTimeSeparator <> '' then
    SafeIniFormatSettings.TimeSeparator := resSIniTimeSeparator[1];
  if resSIniDecimalSeparator <> '' then
    SafeIniFormatSettings.DecimalSeparator := resSIniDecimalSeparator[1];
end;

procedure TranslateSafeIniMessages(const LangFileName: string;
  const SafeIniSection: string = 'SafeIniSection');
var
  AList: TStringList;

  procedure TranslateStr(const AName: string; var AValue: string);
  var
    S: string;
  begin
    S := AnsiDequotedStr(AList.Values[AName], '"');

    // AValue ������ ������ � ��� ������, ���� � S ���� �����-�� �����
    if S <> '' then
      AValue := S;
  end;
  
  procedure TranslateMessages;
  begin
    {$IFNDEF UseResStr}
    TranslateStr('SIniEmptySection', resSIniEmptySection);
    TranslateStr('SIniVariableNotSpecified', resSIniVariableNotSpecified);
    TranslateStr('SIniCanNotSaveChanges', resSIniCanNotSaveChanges);
    TranslateStr('SIniDateFormat', resSIniDateFormat);
    TranslateStr('SIniTimeFormat', resSIniTimeFormat);
    TranslateStr('SIniDateSeparator', resSIniDateSeparator);
    TranslateStr('SIniTimeSeparator', resSIniTimeSeparator);
    TranslateStr('SIniDecimalSeparator', resSIniDecimalSeparator);
    TranslateStr('SIniLineDelimiter', resSIniLineDelimiter);
    TranslateStr('SIniQuotedChar', resSIniQuotedChar);
    UpdateIniFormatSettings;
    {$ENDIF UseResStr}
  end;

begin
  with TSafeIniFile.Create(LangFileName) do
  try
    AList := TStringList.Create;
    try
      // ��������� ������ ini-�����
      ReadSectionValues(SafeIniSection, AList);

      // ��������� �����������
      TranslateMessages;
    finally
      AList.Free;
    end;
  finally
    Free;
  end;
end;             

initialization
  UpdateIniFormatSettings();
end.
