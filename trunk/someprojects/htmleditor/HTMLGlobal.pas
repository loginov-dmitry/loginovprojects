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
    edTagName: string; // ������������ ��� ����
    edNiceTagName: string; // ��� ���� �� ������ �����
    edElem: IHTMLElement;
  end;

  TElemDescArray = array of TElemDesc;

  THTMLAttribType = (
    atNone, // �����������
    atColor, //+ ���� ��������
    atPxSize, //+ ������ � ��������
    atCount, //+ ����������
    atCount1, //+ ���������� � 1-��
    atCountFromMinus1,// ����������, ������� �� -1
    atFontSize, // ������ ������. ���������� �� 1 �� 7. ����� ����� ����� "+" � "-"
    atFontName, // ��� ������
    atLink, // ������
    atLinkTarget, //+ ������� TARGET
    atText, // ������������ �����
    atCharSet, //+ ��������� ��������
    atHAlign, //+ ������������ �� �����������
    atVAlign, //+ ������������ �� ���������
    atCSSVAlign, //+ ������������ �� ��������� � ������������ ������������� CSS
    atImgAlign, //+ ������������ ��������
    atULType, //+ TYPE ��� �������� ������
    atOLType, //+ TYPE ��� ������������� ������
    atBoolean, //+ ��������, ��������������� 2 ��������: ��/��� (�� = 65535)
    atTextBoolean, //- ��������� ��������: On/Off
    atEncType, //- �������� ����� ENCTYPE
    atMethod, //+ �������� ����� Method
    atInputType, //+ ��� �������� "INPUT" (��� �������� �������� ������!)
    atCSSSize, //+ ������� ��������. ���������� � ������� � ������ �������� px
    atCSSBorderStyle, //+ CSS����� �����
    atCSSFontStyle, //+ ����� ������
    //atCSSFontSize, // ������ ������  ����� ���� ��� �����, ��� � �������.
    atCSSFontWeight, //+ ������������
    atCSSWritingMode, // ����������� ������
    atCSSPageBreak, // ������ ��������
    atMrqDir, // ����������� ������� ������
    atMrqBehav, // ��������� ������� ������
    atSize // ������ ��������. ����� ���� ��� �����, ��� � �������. ����� ���������� � px, %, cm � �.�.
    );

  // ���������� �� ��������� HTML-����
  THTMLTagAttribs = class
  private

  public
    // ������ ���������
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
    CurrentCell: IHTMLElement; // ������� ������

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
  SSelectColor = '�������...';
  SUserColor = '��������';
  SNoneColor = '�� �����';
  SNoFont = '�� ��������';
  SNoFontSize = '�� ��������';
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

      // ������������� ��������� ����, �������� �������������
      ColDlg.Color := TColor(ColBox.Items.Objects[ChooseIndex]);

      if ColDlg.Execute then
      begin
        AColor := ColDlg.Color;
        ColBox.Items.Objects[ChooseIndex] := TObject(AColor);

        // �������� ����� ��������� ���� � ������ ����������� ������
        Index := ColBox.Items.IndexOfObject(TObject(AColor));
        if (Index >= 0) and (Index <> ChooseIndex) then
          ColBox.ItemIndex := Index // ����� ���� ��� ����
        else
        begin
          // ������ ����� ��� ���. ��������� ���
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

  Items.AddObject('������', TObject(clBlack));
  Items.AddObject('���������', TObject(clMaroon));
  Items.AddObject('������', TObject(clGreen));
  Items.AddObject('���������', TObject(clOlive));
  Items.AddObject('�����-�����', TObject(clNavy));
  Items.AddObject('���������', TObject(clPurple));
  Items.AddObject('���������', TObject(clTeal));
  Items.AddObject('�����', TObject(clGray));
  Items.AddObject('����������', TObject(clSilver));
  Items.AddObject('�������', TObject(clRed));
  Items.AddObject('����', TObject(clLime));
  Items.AddObject('������', TObject(clYellow));
  Items.AddObject('�����', TObject(clBlue));
  Items.AddObject('�������', TObject(clFuchsia));
  Items.AddObject('������� �����', TObject(clAqua));
  Items.AddObject('�����', TObject(clWhite));
  Items.AddObject('���� �����', TObject(clMoneyGreen));
  Items.AddObject('���� ����', TObject(clSkyBlue));
  Items.AddObject('��������', TObject(clCream));
  Items.AddObject('������-�����', TObject(clMedGray));

  Items.AddObject(SSelectColor, TObject(clBlack));
end;

procedure ListFillFontNames(Items: TStrings);
begin
  Items.Assign(Screen.Fonts);

  // ��������� ���������� ����� � ������ ������
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

  Add('width', '������', atCSSSize);
  Add('height', '������', atCSSSize);

  Add('borderLeftColor', '����� �����: ����', atColor);
  Add('borderLeftWidth', '����� �����: �������', atCSSSize);
  Add('borderLeftStyle', '����� �����: �����', atCSSBorderStyle);

  Add('borderTopColor', '������� �����: ����', atColor);
  Add('borderTopWidth', '������� �����: �������', atCSSSize);
  Add('borderTopStyle', '������� �����: �����', atCSSBorderStyle);

  Add('borderRightColor', '������ �����: ����', atColor);
  Add('borderRightWidth', '������ �����: �������', atCSSSize);
  Add('borderRightStyle', '������ �����: �����', atCSSBorderStyle);

  Add('borderBottomColor', '������ �����: ����', atColor);
  Add('borderBottomWidth', '������ �����: �������', atCSSSize);
  Add('borderBottomStyle', '������ �����: �����', atCSSBorderStyle);


  Add('paddingLeft', '���������� ���� �����', atCSSSize);
  Add('paddingTop', '���������� ���� ������', atCSSSize);
  Add('paddingRight', '���������� ���� ������', atCSSSize);
  Add('paddingBottom', '���������� ���� �����', atCSSSize);

  Add('marginLeft', '������ �� �������� �����', atCSSSize);
  Add('marginTop', '������ �� �������� ������', atCSSSize);
  Add('marginRight', '������ �� �������� ������', atCSSSize);
  Add('marginBottom', '������ �� �������� �����', atCSSSize);

  Add('lineHeight', '����������� ��������', atCSSSize);
  Add('textIndent', '������ ������ ������ ������', atCSSSize);
  Add('textAlign', '������������ �� �����������', atHAlign);
  Add('verticalAlign', '������������ �� ���������', atCSSVAlign);

  Add('backgroundColor', '���� ����', atColor);

  Add('color', '���� ������', atColor);

  Add('fontStyle', '����� ������', atCSSFontStyle);
  Add('fontWeight', '������������ ������', atCSSFontWeight);
  Add('fontSize', '������ ������', atCSSSize);
  Add('fontFamily', '������������ ������', atText);

  Add('writingMode', '����������� ������', atCSSWritingMode);

  Add('pageBreakAfter', '�������� ������ �������� �����', atCSSPageBreak);
  Add('pageBreakBefore', '�������� ������ �������� ��', atCSSPageBreak);
end;


procedure FillTagTranslatesList;
var
  attr: THTMLTagAttribs;
begin
  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('SIZE',  atFontSize);
  attr.AddAttrib('COLOR', atColor);
  attr.AddAttrib('FACE',  atFontName);
  TagTranslatesList.AddObject('FONT=�����', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('B=������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('I=������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('U=������������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('STRIKE=�����������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('S=�����������', attr);

  //TagTranslatesList.Add('EM=��������');

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('EM=������', attr);

  //TagTranslatesList.Add('STRONG=���������');

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('STRONG=������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('CITE=������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('Q=������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('DEL=���������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('INS=�����������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('DFN=������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('TT=������������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('BIG=�����������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('SMALL=�����������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('SUP=�������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('SUB=������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TYPE',  atULType);
  TagTranslatesList.AddObject('UL=������� ������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TYPE',  atOLType);
  attr.AddAttrib('START',  atCount);
  TagTranslatesList.AddObject('OL=������������ ������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('DIR=�����', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('MENU=�����', attr);

  attr := THTMLTagAttribs.Create;
  //attr.AddAttrib('TYPE',  atOLType);  // �������� TYPE ������� �� ���������
  //attr.AddAttrib('START',  atOLType);
  TagTranslatesList.AddObject('LI=������� ������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TABLECAPTION',  atText);
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('HEIGHT',  atSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  //attr.AddAttrib('VALIGN',  atVAlign); //- �� ��������������!
  attr.AddAttrib('BORDER',  atPxSize);
  attr.AddAttrib('BORDERCOLLAPSE',  atBoolean);
  attr.AddAttrib('CELLPADDING',  atPxSize);
  attr.AddAttrib('CELLSPACING',  atPxSize);

  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('BORDERCOLOR',  atColor);
  attr.AddAttrib('BACKGROUND',  atLink);
  //attr.AddAttrib('NAME',  atText);
  //attr.AddAttrib('CLASS',  atText);
  TagTranslatesList.AddObject('TABLE=�������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  TagTranslatesList.AddObject('CAPTION=���������', attr);

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
  TagTranslatesList.AddObject('TD=������', attr);

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
  TagTranslatesList.AddObject('TH=������-���������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('BORDERCOLOR',  atColor);
  TagTranslatesList.AddObject('TR=������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  attr.AddAttrib('BGCOLOR',  atColor);
  TagTranslatesList.AddObject('TFOOT=������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('VALIGN',  atVAlign);
  attr.AddAttrib('BGCOLOR',  atColor);
  TagTranslatesList.AddObject('THEAD=������������ �����', attr);

  
  TagTranslatesList.Add('COL=��������� �������'); // �������� ������
  TagTranslatesList.Add('COLGROUP=��������� �������');

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('DIV=����', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('SPAN=������', attr);
                                             
  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('NOBR=�� ����������', attr);


  attr := THTMLTagAttribs.Create;
  //attr.AddAttrib('MARGINHEIGHT',  atPxSize); // � IE - �� ��������������
  attr.AddAttrib('TOPMARGIN',  atPxSize);
  //attr.AddAttrib('MARGINWIDTH',  atPxSize);  // � IE - �� ��������������
  attr.AddAttrib('LEFTMARGIN',  atPxSize);
  attr.AddAttrib('BACKGROUND',  atLink);
  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('TEXT',  atColor);
  attr.AddAttrib('LINK',  atColor);
  attr.AddAttrib('ALINK',  atColor);
  attr.AddAttrib('VLINK',  atColor);
  TagTranslatesList.AddObject('BODY=��������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('HTML=��������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('HREF',  atLink);
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('TARGET',  atLinkTarget);
  TagTranslatesList.AddObject('A=������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('P=�����', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('CENTER=�� ������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H1=��������� 1', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H2=��������� 2', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H3=��������� 3', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H4=��������� 4', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H5=��������� 5', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('H6=��������� 6', attr);

  TagTranslatesList.Add('BR=������ ������'); // ��������� ������� ����������

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('SIZE',  atPxSize);
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('NOSHADE',  atBoolean);
  TagTranslatesList.AddObject('HR=�����. �����', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('PRE=��� ��������������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('XMP=�������� �����', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ACTION',  atLink);
  //attr.AddAttrib('AUTOCOMPLETE',  atTextBoolean); // ������-�� �� ��������������
  //attr.AddAttrib('ENCTYPE',  atEncType); // ������-�� �� ��������������
  attr.AddAttrib('METHOD',  atMethod);
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('TARGET',  atLinkTarget);
  TagTranslatesList.AddObject('FORM=�����', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('FIELDSET=�����������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('ALIGN',  atHAlign);
  TagTranslatesList.AddObject('LEGEND=��������� ������', attr);


  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('COLS',  atCount1);
  attr.AddAttrib('ROWS',  atCount1);
  attr.AddAttrib('DISABLED',  atBoolean);
  attr.AddAttrib('READONLY',  atBoolean);  
  TagTranslatesList.AddObject('TEXTAREA=������������� �����', attr);  

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TYPE',  atInputType);
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('VALUE',  atText);
  attr.AddAttrib('SIZE',  atSize);
  attr.AddAttrib('DISABLED',  atBoolean);
  attr.AddAttrib('READONLY',  atBoolean);
  attr.AddAttrib('MAXLENGTH',  atCount);

  // ����� ����� ��������� ��������� - ���������
  attr.AddAttrib('BORDER',  atPxSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  attr.AddAttrib('ALT',  atText);
  //attr.AddAttrib('AUTOCOMPLETE',  atTextBoolean); // �� �������������� � IE
  attr.AddAttrib('SRC',  atLink);
  TagTranslatesList.AddObject('INPUT=������� �����', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('DISABLED',  atBoolean);
  attr.AddAttrib('SIZE',  atSize);
  attr.AddAttrib('MULTIPLE',  atBoolean);
  TagTranslatesList.AddObject('SELECT=���������� ������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('OPTION=������� ������', attr);

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('NAME',  atText);
  TagTranslatesList.AddObject('BUTTON=������', attr); // ������������� ���

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('NAME',  atText);
  TagTranslatesList.AddObject('MAP=����� �����������', attr);

  TagTranslatesList.Add('AREA=�������');                   // ��������� ������� ����������

  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('DIR',  atText);
  TagTranslatesList.AddObject('BDO=������-������', attr);

  attr := THTMLTagAttribs.Create;
  TagTranslatesList.AddObject('BLOCKQUOTE=������', attr);



  TagTranslatesList.Add('EMBED=������');
  TagTranslatesList.Add('FRAMESET=��������� �������');

  {attr := THTMLTagAttribs.Create;
  attr.AddAttrib('BORDERCOLOR',  atColor);
  attr.AddAttrib('FRAMEBORDER',  atText);
  attr.AddAttrib('NAME',  atText);
  attr.AddAttrib('NORESIZE',  atBoolean);
  attr.AddAttrib('SCROLLING',  atText);
  attr.AddAttrib('SRC',  atLink);}
  TagTranslatesList.Add('FRAME=�����');                 // ��������� ������� ����������


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
  TagTranslatesList.AddObject('MARQUEE=������� ������', attr);


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
  TagTranslatesList.AddObject('IMG=��������', attr);

  // ��� ��� �������� ����� �������
  attr := THTMLTagAttribs.Create;
  attr.AddAttrib('TABLECAPTION',  atText);
  attr.AddAttrib('TABCOLS',  atCount1);
  attr.AddAttrib('TABROWS',  atCount1);
  attr.AddAttrib('WIDTH',  atSize);
  attr.AddAttrib('HEIGHT',  atSize);
  attr.AddAttrib('ALIGN',  atHAlign);
  //attr.AddAttrib('VALIGN',  atVAlign); //- �� ��������������!
  attr.AddAttrib('BORDER',  atPxSize);
  attr.AddAttrib('BORDERCOLLAPSE',  atBoolean); // ������� ����� ����������
  attr.AddAttrib('CELLPADDING',  atPxSize);
  attr.AddAttrib('CELLSPACING',  atPxSize);

  attr.AddAttrib('BGCOLOR',  atColor);
  attr.AddAttrib('BORDERCOLOR',  atColor);
  attr.AddAttrib('BACKGROUND',  atLink);

  //-  ��-�� �����, ����������� ��� ������� �������
  attr.AddAttrib('TDWIDTH',  atSize);
  attr.AddAttrib('TDWIDTHROWNUM',  atCount); // ������������� ������ ������ ��� ��������� ������
  attr.AddAttrib('TDHEIGHT',  atSize);
  attr.AddAttrib('TDALIGN',  atHAlign);
  attr.AddAttrib('TDVALIGN',  atVAlign);
  attr.AddAttrib('TDBACKGROUND',  atLink);
  attr.AddAttrib('TDBGCOLOR',  atColor);
  attr.AddAttrib('TDBORDERCOLOR',  atColor);
  attr.AddAttrib('NOWRAP',  atBoolean);
  //-

  TagTranslatesList.AddObject('ADDNEWTABLE=������� � ������', attr); // ��������� ���
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
  AttribTranslatesList.Add('SIZE=������');
  AttribTranslatesList.Add('COLOR=����');
  AttribTranslatesList.Add('FACE=�����');
  AttribTranslatesList.Add('TITLE=���������');

  AttribTranslatesList.Add('ALIGN=������������ (�����)');
  AttribTranslatesList.Add('VALIGN=������������ (����)');
  AttribTranslatesList.Add('BORDER=������� �����');
  AttribTranslatesList.Add('CELLPADDING=������ ������');
  AttribTranslatesList.Add('CELLSPACING=�������� ����� ��������');
  AttribTranslatesList.Add('WIDTH=������');
  AttribTranslatesList.Add('HEIGHT=������');
  AttribTranslatesList.Add('BGCOLOR=���� ����');
  AttribTranslatesList.Add('BORDERCOLOR=���� �����');
  AttribTranslatesList.Add('BACKGROUND=������� ������� (����)');

  AttribTranslatesList.Add('MARGINHEIGHT=������ ����. � ����. ����� (Netscape)');
  AttribTranslatesList.Add('TOPMARGIN=������ �������� ����');

  AttribTranslatesList.Add('MARGINWIDTH=������ ���. � ����. ����� (Netscape)');
  AttribTranslatesList.Add('LEFTMARGIN=������ ������ ����');

  AttribTranslatesList.Add('TEXT=���� ������');
  AttribTranslatesList.Add('LINK=���� �����������');
  AttribTranslatesList.Add('ALINK=���� ����������� ��� ��������');
  AttribTranslatesList.Add('VLINK=���� ���������� �����������');

  AttribTranslatesList.Add('HREF=����� �����������');
  AttribTranslatesList.Add('NAME=���');
  AttribTranslatesList.Add('ID=�������������');
  AttribTranslatesList.Add('CLASS=�����');
  AttribTranslatesList.Add('TARGET=��������� ��� ��������');

  AttribTranslatesList.Add('TYPE=���');
  AttribTranslatesList.Add('START=������ �');

  AttribTranslatesList.Add('NOWRAP=������� ����� ��������');

  AttribTranslatesList.Add('COLSPAN=������������ ����� �� �����.');
  AttribTranslatesList.Add('ROWSPAN=������������ ����� �� ����.');

  AttribTranslatesList.Add('ACTION=����� ��������-�����������');
  AttribTranslatesList.Add('ENCTYPE=��� ����������� �������');
  AttribTranslatesList.Add('METHOD=����� �������� �������');

  AttribTranslatesList.Add('FRAMEBORDER=���������� �����');
  AttribTranslatesList.Add('NORESIZE=��������� ��������� ��������');
  AttribTranslatesList.Add('SCROLLING=������ ���������');
  AttribTranslatesList.Add('SRC=URL-����� ��������');

  AttribTranslatesList.Add('BEHAVIOR=��� ��������');
  AttribTranslatesList.Add('DIRECTION=����������� ��������');
  AttribTranslatesList.Add('HSPACE=������ �� �����������');
  AttribTranslatesList.Add('VSPACE=������ �� ���������');
  AttribTranslatesList.Add('LOOP=���������� ��������');
  AttribTranslatesList.Add('SCROLLAMOUNT=��� ��������');
  AttribTranslatesList.Add('SCROLLDELAY=�������� � �������������');
  AttribTranslatesList.Add('TRUESPEED=�� ������������ ��������');

  AttribTranslatesList.Add('ALT=�������������� �����');
  AttribTranslatesList.Add('ISMAP=����������������� � ��������');
  AttribTranslatesList.Add('USEMAP=��� ����� �����������');

  AttribTranslatesList.Add('AUTOCOMPLETE=��������������');
  AttribTranslatesList.Add('DISABLED=������������');
  AttribTranslatesList.Add('MAXLENGTH=������������ �����');
  AttribTranslatesList.Add('READONLY=������ ������');
  AttribTranslatesList.Add('VALUE=��������');

  AttribTranslatesList.Add('COLS=����� ������');
  AttribTranslatesList.Add('ROWS=����� �����');
  AttribTranslatesList.Add('MULTIPLE=������������� �����');

  AttribTranslatesList.Add('NOSHADE=������� �����');

  AttribTranslatesList.Add('DOCTITLE=��������� ��������');
  AttribTranslatesList.Add('DOCCHARSET=��������� ��������');
  AttribTranslatesList.Add('DOCLANG=���� ��������');

  //AttribTranslatesList.Add('CAPTION=��������� �������');
  AttribTranslatesList.Add('TABLECAPTION=��������� �������');
  AttribTranslatesList.Add('TABCOLS=����� �������� �������');
  AttribTranslatesList.Add('TABROWS=����� ����� �������');
  AttribTranslatesList.Add('BORDERCOLLAPSE=������ ������� ����� ��������');

  AttribTranslatesList.Add('TDWIDTH=������ �����');
  AttribTranslatesList.Add('TDWIDTHROWNUM=���. ������ ������ ��� ������ �');
  AttribTranslatesList.Add('TDHEIGHT=������ �����');
  AttribTranslatesList.Add('TDALIGN=������: ������. �� �����.');
  AttribTranslatesList.Add('TDVALIGN=������: ������. �� ����.');
  AttribTranslatesList.Add('TDBACKGROUND=������: ������� ������� (����)');
  AttribTranslatesList.Add('TDBGCOLOR=������: ���� ����');
  AttribTranslatesList.Add('TDBORDERCOLOR=������: ���� �����');


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
