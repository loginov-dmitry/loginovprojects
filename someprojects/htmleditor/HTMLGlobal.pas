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

unit HTMLGlobal;

interface

uses
  Windows, Messages, Classes, SysUtils, SHDocVw, MSHTML, Graphics, Forms,
  Dialogs, ExtCtrls, Controls;

type
  TElemDesc = record
    edTagName: string; // Оригинальное имя тэга
    edNiceTagName: string; // Имя тэга на родном языке
    edElem: IHTMLElement;
  end;

  TElemDescArray = array of TElemDesc;

  THTMLAttribType = (
    atNone, // Неизвестный
    atColor, //+ Цвет элемента
    atPxSize, //+ Размер в пикселях
    atCount, //+ Количество
    atCount1, //+ Количество с 1-цы
    atCountFromMinus1,// Количество, начиная от -1
    atFontSize, // Размер шрифта. Изменяется от 1 до 7. Также может иметь "+" и "-"
    atFontName, // Имя шрифта
    atLink, // Ссылка
    atLinkTarget, //+ атрибут TARGET
    atText, // Произвольный текст
    atCharSet, //+ Кодировка страницы
    atHAlign, //+ Выравнивание по горизонтали
    atVAlign, //+ Выравнивание по вертикали
    atCSSVAlign, //+ Выравнивание по вертикали с расширенными возможностями CSS
    atImgAlign, //+ Выравнивание картинки
    atULType, //+ TYPE для простого списка
    atOLType, //+ TYPE Для нумерованного списка
    atBoolean, //+ Значения, подразумевающие 2 варианта: ДА/НЕТ (ДА = 65535)
    atTextBoolean, //- Возможные значения: On/Off
    atEncType, //- Параметр формы ENCTYPE
    atMethod, //+ Параметр формы Method
    atInputType, //+ Тип элемента "INPUT" (тип элемента изменять нельзя!)
    atCSSSize, //+ Толщина элемента. Измеряется в пикселя и других единицах px
    atCSSBorderStyle, //+ CSSСтиль рамки
    atCSSFontStyle, //+ Стиль шрифта
    //atCSSFontSize, // Размер шрифта  Может быть как целым, так и дробным.
    atCSSFontWeight, //+ Насыщенность
    atCSSWritingMode, // Направление текста
    atCSSPageBreak, // Разрыв страницы
    atMrqDir, // Направление бегущей строки
    atMrqBehav, // Поведение бегущей строки
    atSize // Размер элемента. Может быть как целым, так и дробным. Может измеряться в px, %, cm и т.д.
    );

  // Информацию об атрибутах HTML-тэга
  THTMLTagAttribs = class
  private

  public
    // Список атрибутов
    AttrList: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AddAttrib(AttrName: string; AttrType: THTMLAttribType);
  end;

  THTMLEditorInfo = class
    Disp: IDispatch;
    Editor: IHTMLDocument2;
    ElemDescArray: TElemDescArray;
    ActiveElement: IHTMLElement;
    ActiveElementColor: Variant;
    CurrentIndex: Integer;
    CurrentCell: IHTMLElement; // Текущая ячейка

    FileName: string;
    CanUseZoom: Boolean;

    panCursor: TPanel;
    EditorControl: TWinControl;
  end;

var
  TagTranslatesList: TStringList;
  AttribTranslatesList: TStringList;
  StyleTranslatesList: TStringList;

  HTMLColorDialog: TColorDialog;

const
  SSelectColor = 'Выбрать...';
  SUserColor = 'Заданный';
  SNoneColor = 'Не задан';
  SNoFont = 'Не известно';
  SNoFontSize = 'Не известно';
  SNoColor = 'no color';
  SErrorColor = 'error';

  SSelectionColor = '#FFFF66';
  SNonBreakableSpace = 'NonBreakableSpace';

procedure ListFillColorNames(Items: TStrings);
procedure ListFillFontNames(Items: TStrings);

function GetStyleType(StyleName: string): THTMLAttribType;

function HTMLColorBoxGetColor(ColBox: TColorBox;
  ColDlg: TColorDialog; var IsCancel: Boolean): TColor;

function ConvertColorToHtml(AColor: TColor): string;

function GetDocRange(Inf: THTMLEditorInfo): IHTMLTxtRange;

implementation

function GetDocRange(Inf: THTMLEditorInfo): IHTMLTxtRange;
var
  SelType: string;
begin
  Result := nil;
  SelType := Inf.editor.selection.type_; // None / Text / Control
  if SelType <> 'Control' then
    Result := (Inf.editor.selection.createRange as IHTMLTxtRange);
end;

function ConvertColorToHtml(AColor: TColor): string;
begin
  Result := Format('#%s%s%s', [IntToHex(GetRValue(AColor), 2),
    IntToHex(GetGValue(AColor), 2), IntToHex(GetBValue(AColor), 2)]);
end;

function HTMLColorBoxGetColor(ColBox: TColorBox;
  ColDlg: TColorDialog; var IsCancel: Boolean): TColor;
var
  Index, ChooseIndex: Integer;
  AColor: TColor;    
begin
  IsCancel := False;

  Result := 0;
  if ColBox.ItemIndex >= 0 then
  begin
    if ColBox.Items[ColBox.ItemIndex] = SSelectColor then
    begin
      ChooseIndex := ColBox.ItemIndex;

      // Устанавливаем последний цвет, заданный пользователем
      ColDlg.Color := TColor(ColBox.Items.Objects[ChooseIndex]);

      if ColDlg.Execute then
      begin
        AColor := ColDlg.Color;
        ColBox.Items.Objects[ChooseIndex] := TObject(AColor);

        // Пытаемся найти выбранный цвет в списке стандартных цветов
        Index := ColBox.Items.IndexOfObject(TObject(AColor));
        if (Index >= 0) and (Index <> ChooseIndex) then
          ColBox.ItemIndex := Index // Такой цвет уже есть
        else
        begin
          // Такого цвета еще нет. Добавляем его
          Index := ColBox.Items.IndexOf(SUserColor);
          if Index < 0 then
            ColBox.Items.Insert(0, SUserColor);

          Index := ColBox.Items.IndexOf(SUserColor);
          if Index >= 0 then
          begin
            ColBox.Items.Objects[Index] := TObject(AColor);
            ColBox.ItemIndex := Index;
          end;
        end;
      end else
        IsCancel := True;
    end;

    Result := TColor(ColBox.Items.Objects[ColBox.ItemIndex]);
  end;
end;

procedure ListFillColorNames(Items: TStrings);
begin
  Items.Clear;

  Items.AddObject('Черный', TObject(clBlack));
  Items.AddObject('Малиновый', TObject(clMaroon));
  Items.AddObject('Зелёный', TObject(clGreen));
  Items.AddObject('Оливковый', TObject(clOlive));
  Items.AddObject('Темно-синий', TObject(clNavy));
  Items.AddObject('Пурпурный', TObject(clPurple));
  Items.AddObject('Бирюзовый', TObject(clTeal));
  Items.AddObject('Серый', TObject(clGray));
  Items.AddObject('Серебряный', TObject(clSilver));
  Items.AddObject('Красный', TObject(clRed));
  Items.AddObject('Лайм', TObject(clLime));
  Items.AddObject('Желтый', TObject(clYellow));
  Items.AddObject('Синий', TObject(clBlue));
  Items.AddObject('Розовый', TObject(clFuchsia));
  Items.AddObject('Морская волна', TObject(clAqua));
  Items.AddObject('Белый', TObject(clWhite));
  Items.AddObject('Цвет денег', TObject(clMoneyGreen));
  Items.AddObject('Цвет неба', TObject(clSkyBlue));
  Items.AddObject('Кремовый', TObject(clCream));
  Items.AddObject('Светло-серый', TObject(clMedGray));

  Items.AddObject(SSelectColor, TObject(clBlack));
end;

procedure ListFillFontNames(Items: TStrings);
begin
  Items.Assign(Screen.Fonts);

  // Размещаем популярный шрифт в начале списка
  Items.Insert(1, 'Times New Roman');
  Items.Add(SNoFont);

end;


{ THTMLTagAttribs }

procedure THTMLTagAttribs.AddAttrib(AttrName: string; AttrType: THTMLAttribType);
begin
  AttrList.Values[AttrName] := IntToStr(Byte(AttrType));
end;

procedure THTMLTagAttribs.Clear;
begin


end;

constructor THTMLTagAttribs.Create;
begin
  AttrList := TStringList.Create;

  AddAttrib('ID',  atText);
  AddAttrib('TITLE',  atText);
end;

destructor THTMLTagAttribs.Destroy;
begin
  AttrList.Free;
  inherited;
end;

function GetStyleType(StyleName: string): THTMLAttribType;
var
  Index: Integer;
begin
  Result := atNone;
  Index := StyleTranslatesList.IndexOfName(StyleName);
  if Index >= 0 then
    Result := THTMLAttribType(StyleTranslatesList.Objects[Index]);
end;

procedure FillStyleTranslatesList;
  procedure Add(AName, ANiceName: string; atype: THTMLAttribType);
  begin
    StyleTranslatesList.AddObject(AName + '=' + ANiceName, TObject(atype))
  end;
begin

  Add('width', 'Ширина', atCSSSize);
  Add('height', 'Высота', atCSSSize);

  Add('borderLeftColor', 'Левая рамка: цвет', atColor);
  Add('borderLeftWidth', 'Левая рамка: толщина', atCSSSize);
  Add('borderLeftStyle', 'Левая рамка: стиль', atCSSBorderStyle);

  Add('borderTopColor', 'Верхняя рамка: цвет', atColor);
  Add('borderTopWidth', 'Верхняя рамка: толщина', atCSSSize);
  Add('borderTopStyle', 'Верхняя рамка: стиль', atCSSBorderStyle);

  Add('borderRightColor', 'Правая рамка: цвет', atColor);
  Add('borderRightWidth', 'Правая рамка: толщина', atCSSSize);
  Add('borderRightStyle', 'Правая рамка: стиль', atCSSBorderStyle);

  Add('borderBottomColor', 'Нижняя рамка: цвет', atColor);
  Add('borderBottomWidth', 'Нижняя рамка: толщина', atCSSSize);
  Add('borderBottomStyle', 'Нижняя рамка: стиль', atCSSBorderStyle);


  Add('paddingLeft', 'Внутреннее поле слева', atCSSSize);
  Add('paddingTop', 'Внутреннее поле сверху', atCSSSize);
  Add('paddingRight', 'Внутреннее поле справа', atCSSSize);
  Add('paddingBottom', 'Внутреннее поле снизу', atCSSSize);

  Add('marginLeft', 'Отступ от элемента слева', atCSSSize);
  Add('marginTop', 'Отступ от элемента сверху', atCSSSize);
  Add('marginRight', 'Отступ от элемента справа', atCSSSize);
  Add('marginBottom', 'Отступ от элемента снизу', atCSSSize);

  Add('lineHeight', 'Межстрочный интервал', atCSSSize);
  Add('textIndent', 'Отступ первой строки абзаца', atCSSSize);
  Add('textAlign', 'Выравнивание по горизонтали', atHAlign);
  Add('verticalAlign', 'Выравнивание по вертикали', atCSSVAlign);

  Add('backgroundColor', 'Цвет фона', atColor);

  Add('color', 'Цвет текста', atColor);

  Add('fontStyle', 'Стиль шрифта', atCSSFontStyle);
  Add('fontWeight', 'Насыщенность шрифта', atCSSFontWeight);
  Add('fontSize', 'Размер шрифта', atCSSSize);
  Add('fontFamily', 'Используемые шрифты', atText);

  Add('writingMode', 'Направление текста', atCSSWritingMode);

  Add('pageBreakAfter', 'Вставить разрыв страницы после', atCSSPageBreak);
  Add('pageBreakBefore', 'Вставить разрыв страницы до', atCSSPageBreak);
end;


procedure FillTagTranslatesList;
var
  attr: THTMLTagAttribs;
begin
  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('SIZE',  atFontSize);
  attr.AddAttrib('COLOR', atColor);
  attr.AddAttrib('FACE',  atFontName);
  TagTranslatesList.AddObject('FONT=Шрифт', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('B=Жирный', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('I=Курсив', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('U=Подчеркнутый', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('STRIKE=Зачеркнутый', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('S=Зачеркнутый', attr);

  //TagTranslatesList.Add('EM=Ударение');

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('EM=Курсив', attr);

  //TagTranslatesList.Add('STRONG=Выделение');

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('STRONG=Жирный', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('CITE=Цитата', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('Q=Цитата', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('DEL=Удаленный', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('INS=Добавленный', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('DFN=Термин', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('TT=Моноширинный', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('BIG=Увеличенный', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('SMALL=Уменьшенный', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('SUP=Верхний', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('SUB=Нижний', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TYPE',  atULType);
  TagTranslatesList.AddObject('UL=Простой список', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TYPE',  atOLType);
  attr.AddAttrib('START',  atCount);
  TagTranslatesList.AddObject('OL=Номерованный список', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('DIR=Папки', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('MENU=Папки', attr);

  attr := THTMLTagAttribs.Create;
  //attr.AddAttrib('TYPE',  atOLType);  // Значения TYPE зависят от контекста
  //attr.AddAttrib('START',  atOLType);
  TagTranslatesList.AddObject('LI=Элемент списка', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TABLECAPTION',  atText);
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('HEIGHT',  atSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  //attr.AddAttrib('VALIGN',  atVAlign); //- не поддерживается!
  attr.AddAttrib('BORDER',  atPxSize);
  attr.AddAttrib('BORDERCOLLAPSE',  atBoolean);
  attr.AddAttrib('CELLPADDING',  atPxSize);
  attr.AddAttrib('CELLSPACING',  atPxSize);

  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('BORDERCOLOR',  atColor);
  attr.AddAttrib('BACKGROUND',  atLink);
  //attr.AddAttrib('NAME',  atText);
  //attr.AddAttrib('CLASS',  atText);
  TagTranslatesList.AddObject('TABLE=Таблица', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  TagTranslatesList.AddObject('CAPTION=Заголовок', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('HEIGHT',  atSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  attr.AddAttrib('COLSPAN',  atCount1);
  attr.AddAttrib('ROWSPAN',  atCount1);
  attr.AddAttrib('BACKGROUND',  atLink);
  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('BORDERCOLOR',  atColor);
  attr.AddAttrib('NOWRAP',  atBoolean);
  TagTranslatesList.AddObject('TD=Ячейка', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('HEIGHT',  atSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  attr.AddAttrib('COLSPAN',  atCount1);
  attr.AddAttrib('ROWSPAN',  atCount1);
  attr.AddAttrib('BACKGROUND',  atLink);
  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('BORDERCOLOR',  atColor);
  attr.AddAttrib('NOWRAP',  atBoolean);
  TagTranslatesList.AddObject('TH=Ячейка-заголовок', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('BORDERCOLOR',  atColor);
  TagTranslatesList.AddObject('TR=Строка', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  attr.AddAttrib('BGCOLOR',  atColor);
  TagTranslatesList.AddObject('TFOOT=Подвал', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  attr.AddAttrib('BGCOLOR',  atColor);
  TagTranslatesList.AddObject('THEAD=Заголовочная часть', attr);

  
  TagTranslatesList.Add('COL=Настройки колонок'); // Выделить нельзя
  TagTranslatesList.Add('COLGROUP=Настройки колонок');

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('DIV=Блок', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('SPAN=Группа', attr);
                                             
  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('NOBR=Не переносить', attr);


  attr := THTMLTagAttribs.Create;
  //attr.AddAttrib('MARGINHEIGHT',  atPxSize); // в IE - не поддерживается
  attr.AddAttrib('TOPMARGIN',  atPxSize);
  //attr.AddAttrib('MARGINWIDTH',  atPxSize);  // в IE - не поддерживается
  attr.AddAttrib('LEFTMARGIN',  atPxSize);
  attr.AddAttrib('BACKGROUND',  atLink);
  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('TEXT',  atColor);
  attr.AddAttrib('LINK',  atColor);
  attr.AddAttrib('ALINK',  atColor);
  attr.AddAttrib('VLINK',  atColor);
  TagTranslatesList.AddObject('BODY=Страница', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('HTML=Документ', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('HREF',  atLink);
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('TARGET',  atLinkTarget);
  TagTranslatesList.AddObject('A=Ссылка', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('P=Абзац', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('CENTER=По центру', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H1=Заголовок 1', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H2=Заголовок 2', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H3=Заголовок 3', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H4=Заголовок 4', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H5=Заголовок 5', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H6=Заголовок 6', attr);

  TagTranslatesList.Add('BR=Разрыв строки'); // Настройка свойств невозможна

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('SIZE',  atPxSize);
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('NOSHADE',  atBoolean);
  TagTranslatesList.AddObject('HR=Гориз. линия', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('PRE=Без форматирования', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('XMP=Исходный текст', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ACTION',  atLink);
  //attr.AddAttrib('AUTOCOMPLETE',  atTextBoolean); // почему-то не поддерживается
  //attr.AddAttrib('ENCTYPE',  atEncType); // почему-то не поддерживается
  attr.AddAttrib('METHOD',  atMethod);
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('TARGET',  atLinkTarget);
  TagTranslatesList.AddObject('FORM=Форма', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('FIELDSET=Группировка', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('LEGEND=Заголовок группы', attr);


  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('COLS',  atCount1);
  attr.AddAttrib('ROWS',  atCount1);
  attr.AddAttrib('DISABLED',  atBoolean);
  attr.AddAttrib('READONLY',  atBoolean);  
  TagTranslatesList.AddObject('TEXTAREA=Многострочный текст', attr);  

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TYPE',  atInputType);
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('VALUE',  atText);
  attr.AddAttrib('SIZE',  atSize);
  attr.AddAttrib('DISABLED',  atBoolean);
  attr.AddAttrib('READONLY',  atBoolean);
  attr.AddAttrib('MAXLENGTH',  atCount);

  // Зачем нужны следующие параметры - непонятно
  attr.AddAttrib('BORDER',  atPxSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('ALT',  atText);
  //attr.AddAttrib('AUTOCOMPLETE',  atTextBoolean); // Не поддерживается в IE
  attr.AddAttrib('SRC',  atLink);
  TagTranslatesList.AddObject('INPUT=Элемент ввода', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('DISABLED',  atBoolean);
  attr.AddAttrib('SIZE',  atSize);
  attr.AddAttrib('MULTIPLE',  atBoolean);
  TagTranslatesList.AddObject('SELECT=Выпадающий список', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('OPTION=Элемент списка', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('NAME',  atText);
  TagTranslatesList.AddObject('BUTTON=Кнопка', attr); // Нестандартный тэг

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('NAME',  atText);
  TagTranslatesList.AddObject('MAP=Карта изображения', attr);

  TagTranslatesList.Add('AREA=Область');                   // Настройка свойств невозможна

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('DIR',  atText);
  TagTranslatesList.AddObject('BDO=Справа-налево', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('BLOCKQUOTE=Цитата', attr);



  TagTranslatesList.Add('EMBED=Объект');
  TagTranslatesList.Add('FRAMESET=Структура фреймов');

  {attr := THTMLTagAttribs.Create;
  attr.AddAttrib('BORDERCOLOR',  atColor);
  attr.AddAttrib('FRAMEBORDER',  atText);
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('NORESIZE',  atBoolean);
  attr.AddAttrib('SCROLLING',  atText);
  attr.AddAttrib('SRC',  atLink);}
  TagTranslatesList.Add('FRAME=Фрейм');                 // Настройка свойств невозможна


  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('HEIGHT',  atSize);
  attr.AddAttrib('DIRECTION',  atMrqDir);
  attr.AddAttrib('BEHAVIOR',  atMrqBehav);
  attr.AddAttrib('BGCOLOR',  atColor);  
  attr.AddAttrib('HSPACE',  atPxSize);
  attr.AddAttrib('VSPACE',  atPxSize);
  attr.AddAttrib('LOOP',  atCountFromMinus1);
  attr.AddAttrib('SCROLLAMOUNT',  atPxSize);
  attr.AddAttrib('SCROLLDELAY',  atCount);
  attr.AddAttrib('TRUESPEED',  atBoolean);
  TagTranslatesList.AddObject('MARQUEE=Бегущая строка', attr);


  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('HEIGHT',  atSize);
  attr.AddAttrib('ALT',  atText);
  attr.AddAttrib('BORDER',  atPxSize);
  attr.AddAttrib('ALIGN',  atImgAlign);
  attr.AddAttrib('HSPACE',  atPxSize);
  attr.AddAttrib('VSPACE',  atPxSize);
  attr.AddAttrib('ISMAP',  atText);
  attr.AddAttrib('SRC',  atLink);
  attr.AddAttrib('USEMAP',  atText);
  TagTranslatesList.AddObject('IMG=Картинка', attr);

  // Тэг для описания новой таблицы
  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TABLECAPTION',  atText);
  attr.AddAttrib('TABCOLS',  atCount1);
  attr.AddAttrib('TABROWS',  atCount1);
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('HEIGHT',  atSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  //attr.AddAttrib('VALIGN',  atVAlign); //- не поддерживается!
  attr.AddAttrib('BORDER',  atPxSize);
  attr.AddAttrib('BORDERCOLLAPSE',  atBoolean); // Сделать рамки одинарными
  attr.AddAttrib('CELLPADDING',  atPxSize);
  attr.AddAttrib('CELLSPACING',  atPxSize);

  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('BORDERCOLOR',  atColor);
  attr.AddAttrib('BACKGROUND',  atLink);

  //-  св-ва ячеек, необходимые при содании таблицы
  attr.AddAttrib('TDWIDTH',  atSize);
  attr.AddAttrib('TDWIDTHROWNUM',  atCount); // Устанавливать ширину только для указанной строки
  attr.AddAttrib('TDHEIGHT',  atSize);
  attr.AddAttrib('TDALIGN',  atHAlign);
  attr.AddAttrib('TDVALIGN',  atVAlign);
  attr.AddAttrib('TDBACKGROUND',  atLink);
  attr.AddAttrib('TDBGCOLOR',  atColor);
  attr.AddAttrib('TDBORDERCOLOR',  atColor);
  attr.AddAttrib('NOWRAP',  atBoolean);
  //-

  TagTranslatesList.AddObject('ADDNEWTABLE=Таблица и ячейки', attr); // Фиктивный тэг
end;


procedure ClearTagTranslatesList;
var
  I: Integer;
begin
  for I := 0 to TagTranslatesList.Count - 1 do
    TagTranslatesList.Objects[I].Free;
end;

procedure FillAttribTranslatesList;
begin
  AttribTranslatesList.Add('SIZE=Размер');
  AttribTranslatesList.Add('COLOR=Цвет');
  AttribTranslatesList.Add('FACE=Шрифт');
  AttribTranslatesList.Add('TITLE=Подсказка');

  AttribTranslatesList.Add('ALIGN=Выравнивание (гориз)');
  AttribTranslatesList.Add('VALIGN=Выравнивание (верт)');
  AttribTranslatesList.Add('BORDER=Толщина рамки');
  AttribTranslatesList.Add('CELLPADDING=Отступ текста');
  AttribTranslatesList.Add('CELLSPACING=Интервал между ячейками');
  AttribTranslatesList.Add('WIDTH=Ширина');
  AttribTranslatesList.Add('HEIGHT=Высота');
  AttribTranslatesList.Add('BGCOLOR=Цвет фона');
  AttribTranslatesList.Add('BORDERCOLOR=Цвет рамки');
  AttribTranslatesList.Add('BACKGROUND=Фоновый рисунок (файл)');

  AttribTranslatesList.Add('MARGINHEIGHT=Ширина верх. и нижн. полей (Netscape)');
  AttribTranslatesList.Add('TOPMARGIN=Ширина верхнего поля');

  AttribTranslatesList.Add('MARGINWIDTH=Ширина лев. и прав. полей (Netscape)');
  AttribTranslatesList.Add('LEFTMARGIN=Ширина левого поля');

  AttribTranslatesList.Add('TEXT=Цвет текста');
  AttribTranslatesList.Add('LINK=Цвет гиперссылок');
  AttribTranslatesList.Add('ALINK=Цвет гиперссылок под курсором');
  AttribTranslatesList.Add('VLINK=Цвет посещенных гиперссылок');

  AttribTranslatesList.Add('HREF=Адрес гиперссылки');
  AttribTranslatesList.Add('NAME=Имя');
  AttribTranslatesList.Add('ID=Идентификатор');
  AttribTranslatesList.Add('CLASS=Класс');
  AttribTranslatesList.Add('TARGET=Поведение при открытии');

  AttribTranslatesList.Add('TYPE=Тип');
  AttribTranslatesList.Add('START=Начать с');

  AttribTranslatesList.Add('NOWRAP=Перенос строк запрещен');

  AttribTranslatesList.Add('COLSPAN=Объединенных ячеек по гориз.');
  AttribTranslatesList.Add('ROWSPAN=Объединенных ячеек по верт.');

  AttribTranslatesList.Add('ACTION=Адрес страницы-обработчика');
  AttribTranslatesList.Add('ENCTYPE=Тип содержимого запроса');
  AttribTranslatesList.Add('METHOD=Метод отправки запроса');

  AttribTranslatesList.Add('FRAMEBORDER=Отображать рамку');
  AttribTranslatesList.Add('NORESIZE=Запретить изменение размеров');
  AttribTranslatesList.Add('SCROLLING=Способ прокрутки');
  AttribTranslatesList.Add('SRC=URL-адрес элемента');

  AttribTranslatesList.Add('BEHAVIOR=Тип движения');
  AttribTranslatesList.Add('DIRECTION=Направление движения');
  AttribTranslatesList.Add('HSPACE=Отступ по горизонтали');
  AttribTranslatesList.Add('VSPACE=Отступ по вертикали');
  AttribTranslatesList.Add('LOOP=Количество проходов');
  AttribTranslatesList.Add('SCROLLAMOUNT=Шаг движения');
  AttribTranslatesList.Add('SCROLLDELAY=Задержка в миллисекундах');
  AttribTranslatesList.Add('TRUESPEED=Не органичивать скорость');

  AttribTranslatesList.Add('ALT=Альтернативный текст');
  AttribTranslatesList.Add('ISMAP=Взаимодействовать с сервером');
  AttribTranslatesList.Add('USEMAP=Имя карты изображения');

  AttribTranslatesList.Add('AUTOCOMPLETE=Автозаполнение');
  AttribTranslatesList.Add('DISABLED=Заблокирован');
  AttribTranslatesList.Add('MAXLENGTH=Максимальная длина');
  AttribTranslatesList.Add('READONLY=Только чтение');
  AttribTranslatesList.Add('VALUE=Значение');

  AttribTranslatesList.Add('COLS=Длина строки');
  AttribTranslatesList.Add('ROWS=Число строк');
  AttribTranslatesList.Add('MULTIPLE=Множественный выбор');

  AttribTranslatesList.Add('NOSHADE=Плоская линия');

  AttribTranslatesList.Add('DOCTITLE=Заголовок страницы');
  AttribTranslatesList.Add('DOCCHARSET=Кодировка страницы');
  AttribTranslatesList.Add('DOCLANG=Язык страницы');

  //AttribTranslatesList.Add('CAPTION=Заголовок таблицы');
  AttribTranslatesList.Add('TABLECAPTION=Заголовок таблицы');
  AttribTranslatesList.Add('TABCOLS=Число столбцов таблицы');
  AttribTranslatesList.Add('TABROWS=Число строк таблицы');
  AttribTranslatesList.Add('BORDERCOLLAPSE=Тонкая граница между ячейками');

  AttribTranslatesList.Add('TDWIDTH=Ширина ячеек');
  AttribTranslatesList.Add('TDWIDTHROWNUM=Уст. ширину только для строки №');
  AttribTranslatesList.Add('TDHEIGHT=Высота ячеек');
  AttribTranslatesList.Add('TDALIGN=Ячейки: выравн. по гориз.');
  AttribTranslatesList.Add('TDVALIGN=Ячейки: выравн. по верт.');
  AttribTranslatesList.Add('TDBACKGROUND=Ячейки: фоновый рисунок (файл)');
  AttribTranslatesList.Add('TDBGCOLOR=Ячейки: цвет фона');
  AttribTranslatesList.Add('TDBORDERCOLOR=Ячейки: цвет рамки');


end;


initialization

  TagTranslatesList := TStringList.Create;
  AttribTranslatesList := TStringList.Create;
  StyleTranslatesList := TStringList.Create;
  FillTagTranslatesList;
  FillAttribTranslatesList;
  FillStyleTranslatesList;


finalization

  ClearTagTranslatesList;
  TagTranslatesList.Free;
  AttribTranslatesList.Free;
  StyleTranslatesList.Free;

end.
