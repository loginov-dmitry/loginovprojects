{
Copyright (c) 2003-2006, Loginov Dmitry Sergeevich
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

{
  В этом модуле хранятся все общие переменные и константы
}

unit GlobalsUnit;

interface
uses
  Windows, Messages, SysUtils;

const
  SShortCopyRight = 'Разработка пользовательского интерфейса, 2003 - 2006';
  SShortProgramName = 'Демо-приложение';
  SStartMutexName = '{CC5A50F3-F964-440A-80E1-F1860C89CD98}';

var
  Path: string; // Директория с запущенной программой
  IniFileName: string; // Имя файла настроек
  
  // Определяет, следует ли сохранять положение панелей в ини-файле
  SaveControlsPosToIni: Boolean = True;

implementation

initialization
  Path := ExtractFilePath(ParamStr(0));
  IniFileName := ChangeFileExt(ParamStr(0), '.ini');

end.
