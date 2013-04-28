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

unit MedDBStruct;

interface

uses
  ibxFBUtils, fbTypes, MedGlobalUnit, SysUtils, Classes;

procedure BuildDBStructure;

implementation

procedure BuildDBStructure;
var
  ATable: TfbTableDesc;
begin
  fb.DBStruct.ReCreateDefDataBaseDesc();

  try
  fb.DBStruct.DefDBDesc.AddDomain('T_YESNO',  'INTEGER', '0', CanNull, '(VALUE IS NULL) OR (VALUE IN (0,1))');

  // CONFIGPARAMS - ������� ��� �������� ���������������� ��������
  ATable := fb.DBStruct.DefDBDesc.AddTable('CONFIGPARAMS');
  with ATable do
  begin
    AddField('FILENAME',      'VARCHAR(100)',   '', NotNull);
    AddField('COMPUTERNAME',  'VARCHAR(100)',   '', NotNull);
    AddField('USERNAME',      'VARCHAR(100)',   '', NotNull);
    AddField('SECTIONNAME',   'VARCHAR(100)',   '', NotNull);
    AddField('PARAMNAME',     'VARCHAR(100)',   '', NotNull);
    AddField('PARAMVALUE',    'VARCHAR(10000)', '', CanNull);
    AddField('PARAMBLOB',     'BLOB',           '', CanNull);
    AddField('PARAMBLOBHASH', 'VARCHAR(50)',    '', CanNull);
    AddField('MODIFYDATE',    'TIMESTAMP',      '', CanNull);
    AddField('MODIFYUSER',    'VARCHAR(100)',   '', CanNull);

    SetPrimaryKey('CONFIGPARAMS_PK', 'FILENAME, COMPUTERNAME, USERNAME, SECTIONNAME, PARAMNAME');
  end;


  // DOCTORS - ������� ������
  ATable := fb.DBStruct.DefDBDesc.AddTable('DOCTORS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '',   NotNull); // ���������� � ������
    AddField('TABNUM',       'VARCHAR(20)',  '',   CanNull); // ��������� � ����� (������������� 1)
    AddField('NAME',         'VARCHAR(100)', '',   CanNull); // ��� ����� (������������� 2)
    AddField('FULLNAME',     'VARCHAR(200)', '',   CanNull); // ������ ��� �����
    AddField('USERPASSW',    'VARCHAR(20)',  '',   CanNull); // ������ �����
    AddField('ISBOSS',       'T_YESNO',      '',   CanNull); // �������� �� ������� ������ ����������������
    AddField('ADDDATE',      'TIMESTAMP',    '',   CanNull); // ����� ���������� ������
    AddField('ISDELETE',     'T_YESNO',      '',   CanNull); // ������� �������� ������
    AddField('COMMENT',      'VARCHAR(999)', '',   CanNull); // �������������� ����������
    AddField('COMPNAME',     'VARCHAR(100)', '',   CanNull); // ��� ����������, ��� ��������� ������

    // ���������� ������� ��� ���������� ���� MODIFYDATE (���� ����� ������� �������������)
    UseModifyDateTrigger := trsActive;

    SetPrimaryKey('DOCTORS_PK', '"ID"'); // �������� ���������� �����

    // ������� ��� ��������������� ���������� ���� ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'DOCTORS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_DOCTORS_ID', 0);
  end;

  // DESCCATEGS - ������� ��������� ��������� ��������
  ATable := fb.DBStruct.DefDBDesc.AddTable('DESCCATEGS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // ���������� ����� ���������
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // ����� ���������� ������
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID �������, ����������� ���������
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID �������, ����������� ���������
    AddField('ISDELETE',     'T_YESNO',      '', CanNull); // ������� �������� ������
    AddField('CATEGCODE',    'VARCHAR(100)', '', CanNull); // ��� ��������� (������������� 1) - ������ ��������� �� ���� ���. ������
    AddField('NAME',         'VARCHAR(100)', '', CanNull); // ������������ ��������� (������������� 2)
    AddField('CATEGTEXT',    'VARCHAR(500)', '', CanNull); // ����� ��������� ��� �������
    AddField('ELEMLISTSTYLE','INTEGER',      '', CanNull); // ������ ������������� ���������: 0 - ���� �� ������ � ������, 1 - ������������ ������, 2 - ������������� ������
    AddField('CATEGDECOR',   'VARCHAR(20)',  '', CanNull); // ������� ��������� ������ ��������� (B, I, U)
    AddField('TEMPLCODE',    'VARCHAR(100)', '', CanNull); // ������������ ���������� � �������
    AddField('USECATEG',     'T_YESNO',      '', CanNull); // TRUE - ����� ������������ ��������� ��� �������
    AddField('COMMENT',      'VARCHAR(999)', '', CanNull); // ��������� �������� ���������
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // ��� ����������, ��� ��������� ������
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // �������, � ������� ������ ���������� ��������� � ���� �����
    // ���������� ������� ��� ���������� ���� MODIFYDATE (���� ����� ������� �������������)
    UseModifyDateTrigger := trsActive;

    SetPrimaryKey('DESCCATEGS_PK', '"ID"'); // �������� ���������� �����

    // ������� ��� ��������������� ���������� ���� ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'DESCCATEGS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_DESCCATEGS_ID', 0);
  end;

  // DESCELEMS - ������� ��������� ��������
  ATable := fb.DBStruct.DefDBDesc.AddTable('DESCELEMS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // ���������� ����� ��������
    AddField('CATEG_ID',     'INTEGER',      '', NotNull); // ID ��������� (������ �� DESCCATEGS)
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // ����� ���������� ������
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID �������, ����������� ������� ��������
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID �������, ����������� �������
    AddField('ISDELETE',     'T_YESNO',      '', CanNull); // ������� �������� ������
    AddField('ELEMCODE',     'VARCHAR(100)', '', CanNull); // ��� �������� (������������� 1) - ������ ��������� �� ���� ���. ������
    AddField('ELEMNAME',     'VARCHAR(100)', '', CanNull); // ������������ �������� (������������� 2)
    AddField('ELEMTEXT',     'VARCHAR(500)', '', CanNull); // ����� �������� ��� �������
    AddField('COMMENT',      'VARCHAR(300)', '', CanNull); // ��������� �������� ���������
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // ��� ����������, ��� ��������� ������
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // �������, � ������� ������ ���������� �������� � ���� �����
    //AddField('PRINTTEXT',    'T_YESNO',      '', CanNull); // ������ �� ���������� ����� ���������
    AddField('ISREQUIRED',   'T_YESNO',      '', CanNull); // �������� �� ������� ������������ ��� ����������
    AddField('VARPOS',       'VARCHAR(1)',   '', CanNull); // ������������ ��������� ��������� (L-�����, R-������)
    AddField('DELIMAFTER',   'VARCHAR(1)',   '', CanNull); // ������-����������� ����� ������ �������� (���� �������� - ������)
    AddField('ELEMDECOR',    'VARCHAR(20)',  '', CanNull); // ������� ��������� ������ �������� (B, I, U)
    AddField('CONTINUEPREV', 'T_YESNO',      '', CanNull); // ���������� ���������� ������� (��������� � ����� �����������)
    AddField('VARSEPARATOR', 'VARCHAR(1)',   '', CanNull); // ������ ���������� ���������
    AddField('REQUIREVARS',  'T_YESNO',      '', CanNull); // ���������, ����� ��� ������ ���� �� ���� �� ���������
    AddField('CUSTOMVARS',   'T_YESNO',      '', CanNull); // ����� �� ������� ������ �������� ������������ ����� (��� ����)

    // ���������� ������� ��� ���������� ���� MODIFYDATE (���� ����� ������� �������������)
    UseModifyDateTrigger := trsActive;

    SetPrimaryKey('DESCELEMS_PK', '"ID"'); // �������� ���������� �����

    // ������� ��� ��������������� ���������� ���� ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'DESCELEMS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_DESCELEMS_ID', 0);
  end;

  // DESCVARS - ������� ��������� ��������
  ATable := fb.DBStruct.DefDBDesc.AddTable('DESCVARS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // ���������� ����� ��������
    AddField('ELEM_ID',      'INTEGER',      '', NotNull); // ID �������� (������ �� DESCELEMS)
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // ����� ���������� ������
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID �������, ����������� ������� ��������
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID �������, ����������� �������
    AddField('ISDELETE',     'T_YESNO',      '', CanNull); // ������� �������� ������
    AddField('VARCODE',      'VARCHAR(50)',  '', CanNull); // ��� �������� (������������� 1) - ������ ��������� �� ���� ���. ������
    AddField('VARTEXT',      'VARCHAR(500)', '', CanNull); // ����� �������� (������������� 2)
    AddField('VARTYPES',     'VARCHAR(200)', '', CanNull); // �������� ���� ��� ������ �������������� ������
    AddField('CORRELEM',     'VARCHAR(100)', '', CanNull); // ����������������� ����� ��������
    AddField('COMMENT',      'VARCHAR(300)', '', CanNull); // ��������� �������� ��������
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // ��� ����������, ��� ��������� ������
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // ������� ������������ ������������ ������ ���������
    AddField('CANOTHERVARS', 'T_YESNO',      '', CanNull); // ��������� �� ������������� ����������� ������ ��������� � �������
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('DESCVARS_PK', '"ID"');

    // ������� ��� ��������������� ���������� ���� ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'DESCVARS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');
    fb.DBStruct.DefDBDesc.AddGenerator('GEN_DESCVARS_ID', 0);
  end;

  // CHECKOUTS - ������� �������
  ATable := fb.DBStruct.DefDBDesc.AddTable('CHECKOUTS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // ���������� ����� �������
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // ����� ���������� ������
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID �������, ����������� �������
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID �������, ����������� �������
    AddField('ISDELETE',     'T_YESNO',      '', CanNull); // ������� �������� ������
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // ��� ����������, ��� ��������� ������
    AddField('ISCLOSED',     'T_YESNO',      '', CanNull); // ������� ������������� ������� (���������)
    AddField('DATEIN',       'TIMESTAMP',    '', CanNull); // ���� �������������� ��������
    AddField('DATEOUT',      'TIMESTAMP',    '', CanNull); // ���� ������� ��������
    AddField('NUMBER',       'VARCHAR(100)', '', CanNull); // ����� ������� (�������� �������)
    //AddField('PATNAME1',     'VARCHAR(100)', '', CanNull); // ������� ��������
    //AddField('PATNAME2',     'VARCHAR(100)', '', CanNull); // ��� ��������
    //AddField('PATNAME3',     'VARCHAR(100)', '', CanNull); // �������� ��������
    AddField('PATPRINTNAME', 'VARCHAR(200)', '', CanNull); // ��� �������� ��� �������
    AddField('PATSEX',       'VARCHAR(1)',   '', CanNull); // ��� �������� (m - �������, f - �������)
    AddField('PATBDAY',      'TIMESTAMP',    '', CanNull); // ���� �������� ��������
    AddField('DIAGNOS',      'VARCHAR(1000)','', CanNull); // �������
    AddField('DOCTOR_ID',    'INTEGER',      '', CanNull); // ID �������� �����
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('CHECKOUTS_PK', '"ID"');

    // ������� ��� ��������������� ���������� ���� ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'CHECKOUTS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_CHECKOUTS_ID', 0);
  end;

  // COCATEGS - ��������� ����������� �������
  ATable := fb.DBStruct.DefDBDesc.AddTable('COCATEGS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // ���������� ����� ������
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // ����� ���������� ������
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID �������, ����������� ������
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID �������, ����������� ������
    //AddField('ISDELETE',     'T_YESNO',      '', CanNull); // ������� �������� ������
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // ��� ����������, ��� ��������� ������
    AddField('CHECKOUT_ID',  'INTEGER',      '', CanNull); // ������ �� ������� CHECKOUTS.ID
    AddField('CATEG_ID',     'INTEGER',      '', CanNull); // ������ �� ��������� �������� DESCCATEGS
    AddField('FULLTEXT',     'BLOB',         '', CanNull); // ������ ����� ��������� (�������� ����� ���������� �������)
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // ���������� � ��������� (���������� �� ������� DESCCATEGS)
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('COCATEGS_PK', '"ID"');

    // ������� ��� ��������������� ���������� ���� ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'COCATEGS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_COCATEGS_ID', 0);
  end;

  // COELEMS - �������� ����������� �������
  ATable := fb.DBStruct.DefDBDesc.AddTable('COELEMS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // ���������� ����� ������
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // ����� ���������� ������
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID �������, ����������� ������
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID �������, ����������� ������
    //AddField('ISDELETE',     'T_YESNO',      '', CanNull); // ������� �������� ������
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // ��� ����������, ��� ��������� ������
    AddField('COCATEGS_ID',  'INTEGER',      '', CanNull); // ������ �� ��������� COCATEGS.ID
    AddField('ELEM_ID',      'INTEGER',      '', CanNull); // ������ �� ������� �������� DESCELEMS.ID
    AddField('ELEMTEXT',     'VARCHAR(100)', '', CanNull); // ����� �������� �������� (� ��� ����� ���� �� ������ �������)
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // ���������� � �������� (���������� �� ������� DESCELEMS)
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('COELEMS_PK', '"ID"');

    // ������� ��� ��������������� ���������� ���� ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'COELEMS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_COELEMS_ID', 0);
  end;

  // COVARS - �������� ��������� �������� ����������� �������
  ATable := fb.DBStruct.DefDBDesc.AddTable('COVARS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // ���������� ����� ������
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // ����� ���������� ������
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID �������, ����������� ������
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID �������, ����������� ������
    //AddField('ISDELETE',     'T_YESNO',      '', CanNull); // ������� �������� ������
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // ��� ����������, ��� ��������� ������
    AddField('COELEM_ID',    'INTEGER',      '', CanNull); // ������ �� ������� �������� COELEMS.ID
    AddField('VAR_ID',       'INTEGER',      '', CanNull); // ������ �� ������� �������� �������� DESCVARS.ID
    AddField('VARTEXT',      'VARCHAR(100)', '', CanNull); // ������������� ����� �������� �������� (� ��� ����� ���� �� ������ �������)
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // ���������� � �������� (���������� �� ������� DESCVARS)
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('COVARS_PK', '"ID"');

    // ������� ��� ��������������� ���������� ���� ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'COVARS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_COVARS_ID', 0);
  end;

//exit;
  finally
  fb.DBStruct.CheckDefDataBaseStruct(FBServer, FBPort, FBFile,
    FBUser, FBPassword, FBRusCharSet, LogEventsProc);
  end;

end;

end.
