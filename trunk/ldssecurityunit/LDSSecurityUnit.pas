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
{ ������ LDSSecurityUnit - ������ ��� ����������� ���������� ������������     }
{ ��������� �������� ������������ �������. ������� �� ������� ������ �������� }
{ �������� "���������" ��������������� ������� �� Windows. ������             }
{ �������������� ������ ���������� ����� � ����������� ������ AclAPI          }
{ ������ ��������, ����������� ��-�� ������������� ����������  SE_OBJECT_TYPE }
{ ������ ��������� � D7, D2007, D2010                                         }
{ (c) 2010 ������� ������� ���������                                          }
{ ��������� ����������: 29.05.2010                                            }
{                                                                             }
{ *************************************************************************** }

{
������� ������:
  � �� WINDOWS ���� ��� ��������, ������ � ������� ���������������. � �����
  �������� ���������:
  - �����
  - ����������
  - ����� �������
  - ����������� ������
  - ��������
  - ������
  - � ������.

  � ������ �� ���� �������� ������ ��������� ������������ SecurityDescriptor

  ����� ��������� �������� �������� ������ (�.�. � ������ ������ �������
  CreateXXX, OpenXXX, ��� XXX - ��� ����������� �������) � ������� (�������� � �����)
  � �����-�� ����� (�������� ��� ������ ��� ������), ������� ���������, ����
  �� � ��������� ����������� ����� ��� ���������� ��������� ��������.
  ���� ���� �� ��������� �������� � ��������� ���, �� ������� CreateXXX / OpenXXX
  ������ ��������� ��������� (���� ��������� � ���������� ����� ���������� �
  ������� GetLastError).
  �������� ������� � ����������� ������� ����������� ��������� �������:
  ������� ���������, ���� �� � ������������ (��� ��� ������), ������������
  ���������, ����� �� ��������� �������� � ��������. ���� � ���, ��� �
  ��������� ������������ ����������� ������� �������, ������ ������������
  (��� ������ �������������) �������� (��� ��������) ������ � ������� � ���
  ���������� ����� ������ ��������. ��� ���������� �������� � ������� ���������
  ������������, ������� ���������� DACL (discretionary access control list).
  ��� ������� ��������������� ����� ����� ����������: ������������. ������
  �������� ����������, ����������� �� ������ ������ DACL ��� �������
  ����������� ������� �� ������ DACL ������������� �������. �� ��������� �
  ����������� �������� WINDOWS ������������ ��������. �.�. ���������
  ���������� / �������� ������������� ������� ������ �� ������� DACL �������
  ����������� �������. ��������! �����! ��� ���������� �������� Windows\
  ������������ �� ��������� ���������.
  ����� ����, ������� DACL ������� �� ������� ACE (access control entries).
  ������ ������ ACE - ��� ���� ����������, ���� ������ ��� ����������
  ������������ ��� ������ ������������� ��� ���������� ���������� ������ ��������
  � ��������. ������ ������ ACE ��������������� ���������� �����������:
  - ��� ������ (��� ���� ����������, ���� ������)
  - ������������ (��� ������������� ������������ (SID) ������������ ��� ������,
    � �������� ������ ������ ACE ���������)
  - ������� ������������� (������ ����� ���� ���� ������ ����, ���� ������������
    �� ������������� �������)
  - ������� "���������������". � ������, ���� ����� ������������� ��� �������,
    ������� �������� ����������� (��������, ����������) � �������� � ���� ������
    ������� (��������, ������ ���������� � �����), �� ����� �����:
    - ����������� ������ ��� ������� �������
    - ����������� ��� ������� ������� � ��� ��������� ����������
    - ����������� ��� ������� ������� � ��� ��������� ������
    - ����������� ��� ������� ������� � ��� ��������� ���������� � ������
    - � ��.
  - ����� ������� (����� ������, ������ �� ������� �������� �� �� ��� ���� ��������,
    ������ � ������� ������������ ������ ACE. ��� �������� ����� 3 ��������
    ����: ������, ������, ����������. ������� �� ���� ����� ����� ���������������
    ��������� ������. �������� ��� ������ ����� �������������� ���������
    �����: ������ ���������, ������ ���������� ������, ������ ����������� � �.�.).    

  ������ ACE � ������� DACL ������� � ������������ �������: �� ������, �������
  ���� ���� �������� �����������, � �� ���� ���� ��������������. ����� ��� ���
  ������ ����������� (����� � ��������������) ����������� �� ���� �����������,
  �.�. ������� ���� �������, � ����� ���� ����������. �.�. ����������� ACE �����
  ����� ������� ���������, ��� �����������. ���� ����������� ����� ������ �������
  ����� ��������, �� ��� ����� �������� � ������������ ������.

  ������ ������� ACE � ������� DACL:

  ������     | ������ �.�. | ������
  ������     | ���         | ��������
  ���������� | ������ �.�. | ������ ������

  � ���� ������ ��� ������������ "������ �.�." ���� 2 ������ ACE: ���������� ��
  ������ ������ � ������ ������. ��������� ACE ������� ������ ����� ����, ���
  ���������� ������� �������, �� ������������ "������ �.�." ������ ���������.
  ������ ���� �� ���������� �� ������ ������ ������ ���� ������� ������, ��
  ������������ "������ �.�." ������ ���� �� ���������. ����� ����, ������������
  "������ �.�." ��������� ��������, �.�. ������������ "������ �.�." ���������
  � ������ "���", ��� ������� ���������� ������ ��������. ������ "���" - ���
  WELL KNOWN GROUP (������ ��������� ������), � ������� ��������� ����� ������������.

�������:
  ��� ����, ����� ������� DACL � ��������� ���� ��� ���������� ����� (��� �������
  ������������ ������ ���������� ��� ������ ������������, � ������ ������
  ��� SE_FILE_OBJECT), �������������� ��������� ����� (���� ������ ������������):

  with TLDSSecurity.Create('c:\MyFile.txt', SE_FILE_OBJECT) do
  try
    S := ObjectGetSecurityDescriptorAsString(DACL_SECURITY_INFORMATION);
    ShowMessage(S);
  finally
    Free;
  end;

  ��� ����, ����� ���������� ������ ������ ���� ������������� � ����������
  ����� ��� ����������, �������������� ��������� �����:

  with TLDSSecurity.Create('c:\MyFile.txt', SE_FILE_OBJECT) do
  try
    ObjectSetSecurityDescriptorFromString('D:PAI(A;OICI;GA;;;WD)', DACL_SECURITY_INFORMATION);
    // ���� ObjectSetAllowAllForEveryOne;
  finally
    Free;
  end;

  � ������ ������� � �������� ������� ��������� ���������� ������ ��������
  ��������� ������������ � ������� Security Descriptor String Format.
  � �������� ������� ��������� �����������, ����� ������
  ����� ��������� ������������ ���������� �������� (������� DACL).
  ������ ������ ������ �������� ���������� � �������� msdn:
  Security Descriptor String Format: http://msdn.microsoft.com/en-us/library/aa379570%28v=VS.85%29.aspx
  ACE Strings:                       http://msdn.microsoft.com/en-us/library/aa374928%28v=VS.85%29.aspx

  � ������ ������� ������ ������ 'D:PAI(A;OICI;GA;;;WD)'. ��� ��� �������� �� ���������:
  "D:" - ����� �������� ������� DACL
  "P" - Protected - ��������� ������������ ACE �� ������������ DACL. ���� �������
        �� ����� ��������� ���� ����, �� �� ������������. ���� �� �����, ��������
        ������ ���� � ������� ��������� ������� ������, ������ ��� ����� �������
        ������������ ��������� API.
  "AI" - �������� ������������ ���� ��� ���� �������� �������� (��� ������ ��������)
  "A" - ������ ACE ����� ����� ����������� ���. ��� ���������� �� ������ ������������ "D"
  OICI - ������ ACE ����� ��� "���� ������", (�.�. �� ������������ �� ������������� �������),
         �.�. �� �������� "ID". "CI" - ��������� ����� ��������� � ����� � �� ���������;
         "OI" - ��������� ����� ��������� � ����� � �� ������. ���� �� �� ������,
         ����� ������������� ����� ���������������� �� ����� �������� �������,
         �� ������� "NP" (NO PROPAGATE)
  "GA" - GENERIC_ALL - ����� ����������� ���������� �� ������ ������ (����������
         �� ���� �������). ����� ���� �� ������ ������������ ����� "GR" - ������
         �� ������, "GW" - ������ �� ������, "GX" - ������ �� ����������. �����
         ����� ������ � MSDN ������� ����� 30, � �� ����� �������������.
  <�����������> - �����-�� GUID (��. MSDN)
  <�����������> - �����-�� GUID (��. MSDN)
  "WD" - WORLD (EVERYONE) - SID ������ ������������� "���"

  ������ "������ ���������" SID:
  BA - ��������� ��������������
  BU - ��������� ������������
  SY - LOCAL SYSTEM
  DU - ������������ ������
  PU - ������� ������������
  CO - ���������-��������
  � �.�.

  ��� ����, ����� ���������� ������ ������ � ��������� ����� �������,
  �������������� ��������� �����:

  with TLDSSecurity.Create('MACHINE\SOFTWARE\Test', SE_REGISTRY_KEY) do
  try
    ObjectSetSecurityDescriptorFromString('D:PAI(A;OICI;GA;;;WD)', DACL_SECURITY_INFORMATION);
    // ���� ObjectSetAllowAllForEveryOne;
  finally
    Free;
  end;

  ����� ��������� ����� "MACHINE" (������� HKEY_LOCAL_MACHINE) �� �����
  ������������ ��������� �����:
  - CURRENT_USER
  - CLASSES_ROOT
  - USERS


  ��� ����, ����� �������� ���������� � ��������� �������, �������������� ��������� �����:

  var
    ADomainName, AccountName, StrSid, S: string;
    eUse: SID_NAME_USE;
    
  with TLDSSecurity.Create('c:\MyFile.txt', SE_FILE_OBJECT) do
  try
    ObjectGetOwner(ADomainName, AccountName, StrSid, eUse);
  finally
    Free;
  end;

  // ����������� ���� ������������:
  StreUse := TLDSSecurity.SIDNameUseToString(eUse);

  ��������� ����� ���� ���������:
  ADomainName = BUILTIN
  AccountName = ��������������
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

  // ��� ��������� ����������. �������� SACL_SECURITY_INFORMATION �������
  // �������������� ���� �������, �������� ������ �������� ����������.
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
    { ������� ������ TLDSSecurity.
      ��� SE_OBJECT_TYPE �������� � ������ AccCtrl }
    constructor Create(AObjName: string; AObjType: SE_OBJECT_TYPE);

    { ���������� ��� ��������� �������. ���� �������� ������� FAT32, ��
      � �������� ��������� ������� ���������� WELL_KNOWN_GROUP "���" ���
      "EveryOne" ��� "WORLD".
      �������� SIDNameType - �� ������������.
      ����������� class-������� SIDNameUseToString ��� ����, ����� �������������
      SIDNameType � ��������� ���. }
    procedure ObjectGetOwner(var ADomainName, AccountName: string;
      var StrSid: string; var SIDNameType: SID_NAME_USE);

    { ������� ��� �������������� SIDNameType � ��������� ��� }
    class function SIDNameUseToString(SIDNameType: SID_NAME_USE): string;

    { ������� ����������� �������� �������� SID � ��������� ��� � ������� S-R-I-S-S�
      ������ ��������: S-1-5-21-1214440339-1078145449-1202660629-5648}
    class function ConvertSidToStringSid(Sid: PSID): string;

    { ���������� �������� SecurityDescriptor � ��������� ���� }
    class function ConvertSecurityDescriptorToStringSecurityDescriptor(
      SecurityDescriptor: PSECURITY_DESCRIPTOR;
      SecurityInformation: SECURITY_INFORMATION = ALL_SECURITY_INFORMATION): string;

    { ����������� ��������� �������� SecurityDescriptor � ������� ���.
      ���������� ��������� �� ��������� ��������� SECURITY_DESCRIPTOR.
      ����� ������������� ��������� ������ ���������� ����������
      � ������� ������� LocalFree() }
    class function ConvertStringSecurityDescriptorToSecurityDescriptor(
      SDString: string): PSECURITY_DESCRIPTOR;

    { ��� �������, ���������� ��� �������� ���������� ������� ������ (FObjName, FObjType)
      ���������� �������� ��������� ������������ � ��������� ����. ��������
      SecurityInformation ���������� ��� ������������� ������. �� ���������
      ������������� ������ �������� ������ DACL}
    function ObjectGetSecurityDescriptorAsString(
      SecurityInformation: SECURITY_INFORMATION = DACL_SECURITY_INFORMATION): string;

    { ��� �������, ���������� ��� �������� ���������� ������� ������ (FObjName, FObjType)
      ������������� �������� ��������� ������������, �������� � ������ SDString. ��������
      SecurityInformation ���������� ��� ������������� ������. ��� ���������
      ����������� ���� ��� �������� � ��������� ����� � ������ ���������� �������
      ���������� ��� ��������� �������� � �������������� ������ 'D:PAI(A;OICI;GA;;;WD)'
      ���� �� ����� ������������, �� �������� ������ ������� ���������� ��� �������
      ���������� �������� � �����}
    procedure ObjectSetSecurityDescriptorFromString(SDString: string;
      SecurityInformation: SECURITY_INFORMATION = DACL_SECURITY_INFORMATION);

    { ��� �������, ���������� ��� �������� ���������� ������� ������ (FObjName, FObjType)
      ������������� ������ ������ ��� ���� ������������� }
    procedure ObjectSetAllowAllForEveryOne;

    { ������� GetNamedSecurityInfo. �������� ��������������� ������� WINAPI.
      ��������� ��������, ����������� ��-�� ������������� ���������� ���� SE_OBJECT_TYPE.
      ��� �������� ��� 1-��������, ���� �� ����� ���� � ������� GetNamedSecurityInfo
      ������� ���������� 4-������� ��������. ��-�� ������������� ���������� ���������
      ������ ��� ������ ���������, ���������������� � D7 }
    class function GetNamedSecurityInfo(pObjectName: PChar;
      ObjectType: SE_OBJECT_TYPE; SecurityInfo: SECURITY_INFORMATION;
      psidOwner, psidGroup: PPSID; pDacl, pSacl: PPACL;
      ppSecurityDescriptor: PPSECURITY_DESCRIPTOR): DWORD;

    { ������� SetNamedSecurityInfo. �������� ��������������� ������� WINAPI. }
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
  //ObjectType: SE_OBJECT_TYPE; // ��� ������������ ����������!
  ObjectType: DWORD; // �� ����� ���� WinAPI-������� GetNamedSecurityInfo ������� 4-������� ��������
  SecurityInfo: SECURITY_INFORMATION;
  psidOwner: PPSID;
  psidGroup: PPSID;
  pDacl: PPACL;
  pSacl: PPACL;
  ppSecurityDescriptor: PPSECURITY_DESCRIPTOR
): DWORD; stdcall; external 'ADVAPI32.DLL' name {$IFDEF USEUNICODE}'GetNamedSecurityInfoW'{$ELSE}'GetNamedSecurityInfoA'{$ENDIF};


function SetNamedSecurityInfo_(
  pObjectName: PChar;
  //ObjectType: SE_OBJECT_TYPE; // ��� ������������ ����������!
  ObjectType: DWORD; // �� ����� ���� WinAPI-������� SetNamedSecurityInfo ������� 4-������� ��������
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

      // �������� dwAcctName � dwDomainName ������� ����, ������� ������� ������ ������
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
