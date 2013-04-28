{
Copyright (c) 2006, Loginov Dmitry Sergeevich
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

unit MenuReader;

interface
uses
  Windows, SysUtils, Classes, Graphics, Menus, ExtCtrls, ShellAPI, MSXML_TLB;

{
Внимание! В комплект Delphi не входит модуль MSXML_TLB. Вы должны сгенерировать
его вручную. Для этого выберите пункт меню Project -> Import Type Library ...
Далее найдите в списке пункт "Microsoft XML, Version 2.0 (Version 2.0)"
(этот пункт должен ссылаться на файл msxml.dll) и нажмите кнопку "Create Unit".
В результате будет создан модуль MSXML_TLB.
}


type
  // Переменную данного типа нужно будет передавать в процедуру AddItemsToMenu
  TMenuClick = procedure(Sender: TObject; FileName, Params: string;
                         AddParamCount: Integer);



// С помощью данной процедуры вы можете добавить к пункту MenuItem пункты
// меню, описанные в xml-файле XMLFileName. Если файл не найден, или в нем
// содержатся какие-либо ошибки, то процедура молча завершит свою работу.
// В качестве обработчика выбора пункта меню по умолчанию устанавливается
// процедура MenuClickPerformer(), объявленная ниже
procedure AddItemsToMenu(MenuItem: TMenuItem; XMLFileName: string;
  ClickPerformer: TMenuClick = nil);

// Внимание! Вы можете объявить свою статичную процедуру с такими же параметрами
// и указать ее в качестве ClickPerformer при вызове функции AddItemsToMenu
// Название пункта меню вы сможете извлечь с помощью такого кода:
// S := StripHotkey(TMenuItem(Sender).Caption);
// Данная функция по умолчанию вызывает функцию ShellExecute()
procedure MenuClickPerformer(Sender: TObject; Command, Params: string;
                             ParamId: Integer);

implementation
type
  // Delphi требует, чтобы все обработчики находились в классах, поэтому
  // создадим простенький класс с одной единственной процедурой
  TEventOperate = class
    procedure MenuItemClick(Sender: TObject);
  end;

  TMenuItemRec = packed record
    Caption,             // Название пункта меню
    Command,             // Имя запускаемого файла
    IconFile,            // Имя файла с иконкой
    Params: string;      // Передаваемые параметры
    ParamId,             // Номер набора параметров
    IconIndex: Integer;  // Индекс иконки
  end;

var
  recList: TList; // Список указателей
  ClickPerf: TMenuClick = MenuClickPerformer; // Обработчик по умолчанию
  EvOp: TEventOperate; // Переменная класса TEventOperate
  PMenuItem: ^TMenuItemRec;

procedure MenuClickPerformer(Sender: TObject; Command, Params: string;
                             ParamId: Integer);
  function GetDir: string;
  begin
    if Pos(PathDelim, Command) = 0 then Result := '' else
      Result := ExtractFilePath(ExpandFileName(Command));
  end;
begin
  ShellExecute(GetActiveWindow, 'open', PChar(ExtractFileName(Command)),
    PChar(Params), PChar(GetDir), SW_SHOWNORMAL);
end;

procedure AddItemsToMenu(MenuItem: TMenuItem; XMLFileName: string; ClickPerformer: TMenuClick);
var
  Doc: IXMLDOMDocument;

  procedure GetChildNodes(vNode: IXMLDOMNode; vMItem: TMenuItem);
  var
    I: Integer;
    Node1: IXMLDOMNode;
    Mi1: TMenuItem;
    Caption: string;
    mir: ^TMenuItemRec;
    Ic: TIcon;

    procedure ReadData();
    begin
      if Caption <> '' then
      begin
        New(mir);
        FillChar(mir^, SizeOf(TMenuItemRec), 0);
        mir^.Caption := Caption;
        recList.Add(mir);
        Mi1.Tag := Integer(mir);

        // Определяем команду
        if Node1.selectSingleNode('command') <> nil then
          mir^.Command := Node1.selectSingleNode('command').text;


        // Определяем файл и индекс иконки
        if Node1.selectSingleNode('icon') <> nil then
        begin
          mir^.IconFile := Node1.selectSingleNode('icon').text;
          if Node1.selectSingleNode('icon').attributes.length > 0 then
            mir^.IconIndex := StrToInt(Node1.selectSingleNode('icon').attributes[0].Text);
        end;

        // Определяем набор параметров и его номер
        if Node1.selectSingleNode('params') <> nil then
        begin
          mir^.Params := Node1.selectSingleNode('params').text;
          if Node1.selectSingleNode('params').attributes.length > 0 then
            mir^.ParamId := StrToInt(Node1.selectSingleNode('params').attributes[0].Text);
        end;

        if mir^.Command <> '' then
          Mi1.OnClick := EvOp.MenuItemClick;

        if mir^.IconFile <> '' then
        begin
          Ic := TIcon.Create;
          Ic.Handle := ExtractIcon(HInstance, PChar(mir^.IconFile), mir^.IconIndex);
          if Ic.Handle <> 0 then
          with TImage.Create(nil) do begin
            Width := Ic.Width;
            Height := Ic.Height;
            Canvas.Draw(0, 0, Ic);
            Mi1.Bitmap.Assign(Picture.Bitmap);
            Free;
          end;
          Ic.Free;
        end; // Icon
      end;
    end;

  begin
    for I := 0 to vNode.childNodes.length - 1 do
    begin
      Node1 := vNode.childNodes.item[I];
      if Node1.nodeName = 'item' then
      begin
        Caption := Node1.attributes.item[0].text;
        if Caption = '' then Continue;

        if (Caption <> '-') and (vMItem.Find(Caption) <> nil) then
        begin
          if Node1.childNodes.length > 0 then
            GetChildNodes(Node1, vMItem.Find(Caption));
        end else
        begin
          Mi1 := TMenuItem.Create(vMItem);
          Mi1.Caption := Caption;

          ReadData();

          // Считываем дочерние пункты
          if (Caption <> '-') and (Node1.childNodes.length > 0) then
            GetChildNodes(Node1, Mi1);
          vMItem.Add(Mi1);
        end;
      end;
    end; // of for I
  end;

begin
  if @ClickPerformer <> nil then ClickPerf := ClickPerformer;
  Doc := CoDOMDocument.Create;
  Doc.load(XMLFileName);
  if (Doc.documentElement <> nil) and (MenuItem <> nil) then
    GetChildNodes(Doc.documentElement, MenuItem);
end;

{ TEventOperate }

procedure TEventOperate.MenuItemClick(Sender: TObject);
begin
  PMenuItem := Pointer(TMenuItem(Sender).Tag);
  ClickPerf(Sender, PMenuItem^.Command, PMenuItem^.Params, PMenuItem^.ParamId);
end;

procedure FreeRecList;
var
  I: Integer;
  mir: ^TMenuItemRec;
begin
  for I := 0 to recList.Count - 1 do
  begin
    mir := recList.Items[I];
    Dispose(mir);
  end;
  recList.Free;
end;

initialization
  recList := TList.Create;
  EvOp := TEventOperate.Create;
finalization
  FreeRecList();
  EvOp.Free;
end.
