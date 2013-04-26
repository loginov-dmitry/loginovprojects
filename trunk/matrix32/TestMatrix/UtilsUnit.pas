unit UtilsUnit;

interface

uses
  Windows, Messages, Dialogs, Forms, SysUtils, DateUtils, SafeIniFiles;

var
  AppPath: string;
  IniFileName: string;
  IniObject: TSafeIniFile;

implementation


initialization
  AppPath := ExtractFilePath(Application.ExeName);
  IniFileName := AppPath + 'TestMatrix.ini';
  IniObject := TSafeIniFile.Create(IniFileName);

finalization


end.
