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

  // CONFIGPARAMS - таблица для хранения конфигурационных настроек
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


  // DOCTORS - таблица врачей
  ATable := fb.DBStruct.DefDBDesc.AddTable('DOCTORS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '',   NotNull); // Порядковый № записи
    AddField('TABNUM',       'VARCHAR(20)',  '',   CanNull); // Табельный № врача (синхронизация 1)
    AddField('NAME',         'VARCHAR(100)', '',   CanNull); // ФИО врача (синхронизация 2)
    AddField('FULLNAME',     'VARCHAR(200)', '',   CanNull); // Полное имя врача
    AddField('USERPASSW',    'VARCHAR(20)',  '',   CanNull); // Пароль врача
    AddField('ISBOSS',       'T_YESNO',      '',   CanNull); // Является ли учетная запись административной
    AddField('ADDDATE',      'TIMESTAMP',    '',   CanNull); // Время добавления записи
    AddField('ISDELETE',     'T_YESNO',      '',   CanNull); // Признак удаления записи
    AddField('COMMENT',      'VARCHAR(999)', '',   CanNull); // Дополнительная информация
    AddField('COMPNAME',     'VARCHAR(100)', '',   CanNull); // Имя компьютера, где добавлена запись

    // Подключаем триггер для обновления поля MODIFYDATE (поле будет создано автоматически)
    UseModifyDateTrigger := trsActive;

    SetPrimaryKey('DOCTORS_PK', '"ID"'); // Описание первичного ключа

    // Триггер для автоматического заполнения поля ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'DOCTORS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_DOCTORS_ID', 0);
  end;

  // DESCCATEGS - таблица категорий элементов описания
  ATable := fb.DBStruct.DefDBDesc.AddTable('DESCCATEGS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // Порядковый номер категории
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // Время добавления записи
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID доктора, добавившего категорию
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID доктора, изменившего категорию
    AddField('ISDELETE',     'T_YESNO',      '', CanNull); // Признак удаления записи
    AddField('CATEGCODE',    'VARCHAR(100)', '', CanNull); // Код категории (синхронизация 1) - должен совпадать на всех раб. местах
    AddField('NAME',         'VARCHAR(100)', '', CanNull); // Наименование категории (синхронизация 2)
    AddField('CATEGTEXT',    'VARCHAR(500)', '', CanNull); // Текст категории для выписки
    AddField('ELEMLISTSTYLE','INTEGER',      '', CanNull); // Способ представления элементов: 0 - друг за другом в абзаце, 1 - нумерованный список, 2 - маркированный список
    AddField('CATEGDECOR',   'VARCHAR(20)',  '', CanNull); // Символы выделения текста категории (B, I, U)
    AddField('TEMPLCODE',    'VARCHAR(100)', '', CanNull); // Наименование переменной в шаблоне
    AddField('USECATEG',     'T_YESNO',      '', CanNull); // TRUE - можно использовать категорию для выписки
    AddField('COMMENT',      'VARCHAR(999)', '', CanNull); // Подробное описание категории
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // Имя компьютера, где добавлена запись
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // Порядок, в котором должны выводиться категории в окне ввода
    // Подключаем триггер для обновления поля MODIFYDATE (поле будет создано автоматически)
    UseModifyDateTrigger := trsActive;

    SetPrimaryKey('DESCCATEGS_PK', '"ID"'); // Описание первичного ключа

    // Триггер для автоматического заполнения поля ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'DESCCATEGS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_DESCCATEGS_ID', 0);
  end;

  // DESCELEMS - таблица элементов описания
  ATable := fb.DBStruct.DefDBDesc.AddTable('DESCELEMS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // Порядковый номер элемента
    AddField('CATEG_ID',     'INTEGER',      '', NotNull); // ID категории (ссылка на DESCCATEGS)
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // Время добавления записи
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID доктора, добавившего элемент описания
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID доктора, изменившего элемент
    AddField('ISDELETE',     'T_YESNO',      '', CanNull); // Признак удаления записи
    AddField('ELEMCODE',     'VARCHAR(100)', '', CanNull); // Код элемента (синхронизация 1) - должен совпадать на всех раб. местах
    AddField('ELEMNAME',     'VARCHAR(100)', '', CanNull); // Наименование элемента (синхронизация 2)
    AddField('ELEMTEXT',     'VARCHAR(500)', '', CanNull); // Текст элемента для выписки
    AddField('COMMENT',      'VARCHAR(300)', '', CanNull); // Подробное описание категории
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // Имя компьютера, где добавлена запись
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // Порядок, в котором должны выводиться элементы в окне ввода
    //AddField('PRINTTEXT',    'T_YESNO',      '', CanNull); // Должен ли печататься текст категории
    AddField('ISREQUIRED',   'T_YESNO',      '', CanNull); // Является ли элемент обязательным для заполнения
    AddField('VARPOS',       'VARCHAR(1)',   '', CanNull); // Расположение вариантов состояния (L-слева, R-справа)
    AddField('DELIMAFTER',   'VARCHAR(1)',   '', CanNull); // Символ-разделитель после текста элемента (если варианты - справа)
    AddField('ELEMDECOR',    'VARCHAR(20)',  '', CanNull); // Символы выделения текста элемента (B, I, U)
    AddField('CONTINUEPREV', 'T_YESNO',      '', CanNull); // Продолжать предыдущий элемент (размещать в одном предложении)
    AddField('VARSEPARATOR', 'VARCHAR(1)',   '', CanNull); // Символ разделения вариантов
    AddField('REQUIREVARS',  'T_YESNO',      '', CanNull); // Требовать, чтобы был выбран хотя бы один из вариантов
    AddField('CUSTOMVARS',   'T_YESNO',      '', CanNull); // Можно ли вводить вместо варианта произвольный текст (при этом)

    // Подключаем триггер для обновления поля MODIFYDATE (поле будет создано автоматически)
    UseModifyDateTrigger := trsActive;

    SetPrimaryKey('DESCELEMS_PK', '"ID"'); // Описание первичного ключа

    // Триггер для автоматического заполнения поля ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'DESCELEMS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_DESCELEMS_ID', 0);
  end;

  // DESCVARS - таблица вариантов описания
  ATable := fb.DBStruct.DefDBDesc.AddTable('DESCVARS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // Порядковый номер варианта
    AddField('ELEM_ID',      'INTEGER',      '', NotNull); // ID элемента (ссылка на DESCELEMS)
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // Время добавления записи
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID доктора, добавившего элемент описания
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID доктора, изменившего элемент
    AddField('ISDELETE',     'T_YESNO',      '', CanNull); // Признак удаления записи
    AddField('VARCODE',      'VARCHAR(50)',  '', CanNull); // Код варианта (синхронизация 1) - должен совпадать на всех раб. местах
    AddField('VARTEXT',      'VARCHAR(500)', '', CanNull); // Текст варианта (синхронизация 2)
    AddField('VARTYPES',     'VARCHAR(200)', '', CanNull); // Указание типа для каждой подстановочной строки
    AddField('CORRELEM',     'VARCHAR(100)', '', CanNull); // Скорректированный текст элемента
    AddField('COMMENT',      'VARCHAR(300)', '', CanNull); // Подробное описание варианта
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // Имя компьютера, где добавлена запись
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // Порядок расположения относительно других вариантов
    AddField('CANOTHERVARS', 'T_YESNO',      '', CanNull); // Допускает ли одновременное присутствие других вариантов в выписке
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('DESCVARS_PK', '"ID"');

    // Триггер для автоматического заполнения поля ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'DESCVARS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');
    fb.DBStruct.DefDBDesc.AddGenerator('GEN_DESCVARS_ID', 0);
  end;

  // CHECKOUTS - таблица выписок
  ATable := fb.DBStruct.DefDBDesc.AddTable('CHECKOUTS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // Порядковый номер выписки
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // Время добавления записи
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID доктора, добавившего выписку
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID доктора, изменившего выписку
    AddField('ISDELETE',     'T_YESNO',      '', CanNull); // Признак удаления записи
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // Имя компьютера, где добавлена запись
    AddField('ISCLOSED',     'T_YESNO',      '', CanNull); // Признак завершенности выписки (ПРОВЕДЕНА)
    AddField('DATEIN',       'TIMESTAMP',    '', CanNull); // Дата госпитализации пациента
    AddField('DATEOUT',      'TIMESTAMP',    '', CanNull); // Дата выписки пациента
    AddField('NUMBER',       'VARCHAR(100)', '', CanNull); // Номер выписки (вводится вручную)
    //AddField('PATNAME1',     'VARCHAR(100)', '', CanNull); // Фамилия пациента
    //AddField('PATNAME2',     'VARCHAR(100)', '', CanNull); // Имя пациента
    //AddField('PATNAME3',     'VARCHAR(100)', '', CanNull); // Отчество пациента
    AddField('PATPRINTNAME', 'VARCHAR(200)', '', CanNull); // ФИО пациента для выписки
    AddField('PATSEX',       'VARCHAR(1)',   '', CanNull); // Пол пациента (m - мужчина, f - женщина)
    AddField('PATBDAY',      'TIMESTAMP',    '', CanNull); // Дата рождения пациента
    AddField('DIAGNOS',      'VARCHAR(1000)','', CanNull); // Диагноз
    AddField('DOCTOR_ID',    'INTEGER',      '', CanNull); // ID лечащего врача
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('CHECKOUTS_PK', '"ID"');

    // Триггер для автоматического заполнения поля ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'CHECKOUTS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_CHECKOUTS_ID', 0);
  end;

  // COCATEGS - катерогии формируемых выписок
  ATable := fb.DBStruct.DefDBDesc.AddTable('COCATEGS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // Порядковый номер записи
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // Время добавления записи
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID доктора, добавившего запись
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID доктора, изменившего запись
    //AddField('ISDELETE',     'T_YESNO',      '', CanNull); // Признак удаления записи
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // Имя компьютера, где добавлена запись
    AddField('CHECKOUT_ID',  'INTEGER',      '', CanNull); // Ссылка на выписку CHECKOUTS.ID
    AddField('CATEG_ID',     'INTEGER',      '', CanNull); // Ссылка на категорию описания DESCCATEGS
    AddField('FULLTEXT',     'BLOB',         '', CanNull); // Полный текст категории (доступен после проведения выписки)
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // Порядковый № категории (копируется из таблицы DESCCATEGS)
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('COCATEGS_PK', '"ID"');

    // Триггер для автоматического заполнения поля ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'COCATEGS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_COCATEGS_ID', 0);
  end;

  // COELEMS - элементы формируемых выписок
  ATable := fb.DBStruct.DefDBDesc.AddTable('COELEMS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // Порядковый номер записи
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // Время добавления записи
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID доктора, добавившего запись
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID доктора, изменившего запись
    //AddField('ISDELETE',     'T_YESNO',      '', CanNull); // Признак удаления записи
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // Имя компьютера, где добавлена запись
    AddField('COCATEGS_ID',  'INTEGER',      '', CanNull); // Ссылка на категорию COCATEGS.ID
    AddField('ELEM_ID',      'INTEGER',      '', CanNull); // Ссылка на элемент описания DESCELEMS.ID
    AddField('ELEMTEXT',     'VARCHAR(100)', '', CanNull); // Текст элемента описания (в том числе если он введен вручную)
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // Порядковый № элемента (копируется из таблицы DESCELEMS)
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('COELEMS_PK', '"ID"');

    // Триггер для автоматического заполнения поля ADDDATE
    AddTrigger(trBefore, [trInsert], 1, trsActive, 'COELEMS_ADDDATE_BI', '',
      '  IF (NEW.ADDDATE IS NULL) THEN NEW.ADDDATE = CURRENT_TIMESTAMP;');

    fb.DBStruct.DefDBDesc.AddGenerator('GEN_COELEMS_ID', 0);
  end;

  // COVARS - варианты элементов описания формируемых выписок
  ATable := fb.DBStruct.DefDBDesc.AddTable('COVARS');
  with ATable do
  begin
    AddField('ID',           'INTEGER',      '', NotNull); // Порядковый номер записи
    AddField('ADDDATE',      'TIMESTAMP',    '', CanNull); // Время добавления записи
    AddField('ADDDOCTOR',    'INTEGER',      '', CanNull); // ID доктора, добавившего запись
    AddField('MODIFYDOCTOR', 'INTEGER',      '', CanNull); // ID доктора, изменившего запись
    //AddField('ISDELETE',     'T_YESNO',      '', CanNull); // Признак удаления записи
    AddField('COMPNAME',     'VARCHAR(100)', '', CanNull); // Имя компьютера, где добавлена запись
    AddField('COELEM_ID',    'INTEGER',      '', CanNull); // Ссылка на элемент описания COELEMS.ID
    AddField('VAR_ID',       'INTEGER',      '', CanNull); // Ссылка на вариант элемента описания DESCVARS.ID
    AddField('VARTEXT',      'VARCHAR(100)', '', CanNull); // Окончательный текст варианта описания (в том числе если он введен вручную)
    AddField('ORDERNUM',     'INTEGER',      '', CanNull); // Порядковый № варианта (копируется из таблицы DESCVARS)
    UseModifyDateTrigger := trsActive;
    SetPrimaryKey('COVARS_PK', '"ID"');

    // Триггер для автоматического заполнения поля ADDDATE
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
