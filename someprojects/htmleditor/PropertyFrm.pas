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

unit PropertyFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, ComCtrls;

type
  TPropertyForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    sgAttr: TStringGrid;
    sgStyle: TStringGrid;
    Label5: TLabel;
    TrackBar1: TTrackBar;
    procedure sgStyleDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure sgStyleEnter(Sender: TObject);
    procedure sgStyleSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PropertyForm: TPropertyForm;

function ShowPropertyForm(AttrList, StyleList: TStringList; TagName: string): Boolean;

implementation

uses HTMLGlobal, AttribControls;


{$R *.dfm}

function ShowPropertyForm(AttrList, StyleList: TStringList; TagName: string): Boolean;
var
  I: Integer;
  S, S1: string;
  AttrType: THTMLAttribType;
  cntrl: TBaseAttribControl;

  function GetNameByValue(AList: TStringList; AValue: string): string;
  var
    I: Integer;
    S: string;
  begin
    Result := '';
    for I := 0 to AList.Count - 1 do
    begin
      S := AList.ValueFromIndex[I];
      if SameText(S, AValue) then
      begin
        Result :=  AList.Names[I];
        Exit;
      end;
    end;
  end;
begin
  with TPropertyForm.Create(nil) do
  try
    Caption := Format('Свойства элемента "%s"', [TagName]);

    sgAttr.RowCount := 2;
    sgAttr.Cells[0,0] := 'Наименование атрибута';
    sgAttr.Cells[1,0] := 'Значение атрибута';

    PageControl1.ActivePageIndex := 0;
    TabSheet2.TabVisible := Assigned(StyleList);

    if Assigned(StyleList) then
    begin
      sgStyle.RowCount := 2;
      sgStyle.Cells[0,0] := 'Наименование стиля';
      sgStyle.Cells[1,0] := 'Значение стиля';
    end;

    for I := 0 to AttrList.Count - 1 do
    begin
      S := AttribTranslatesList.Values[AttrList.Names[I]];
      if S = '' then
        S := AttrList.Names[I];
      sgAttr.Cells[0,sgAttr.RowCount-1] := S;
      sgAttr.Cells[1,sgAttr.RowCount-1] := AttrList.ValueFromIndex[I];

      CreateAttribControl(sgAttr, THTMLAttribType(AttrList.Objects[I]), sgAttr.RowCount-1, AttrList.ValueFromIndex[I]);

      sgAttr.RowCount := sgAttr.RowCount + 1;
    end;

    if Assigned(StyleList) then
    begin
      for I := 0 to StyleList.Count - 1 do
      begin
        AttrType := GetStyleType(StyleList.Names[I]);
        S := StyleTranslatesList.Values[StyleList.Names[I]];
        if S = '' then
          S := StyleList.Names[I];
        sgStyle.Cells[0,sgStyle.RowCount-1] := S;
        sgStyle.Cells[1,sgStyle.RowCount-1] := StyleList.ValueFromIndex[I];

        CreateAttribControl(sgStyle, AttrType, sgStyle.RowCount-1, StyleList.ValueFromIndex[I]);

        sgStyle.RowCount := sgStyle.RowCount + 1;
      end;
    end;


    Result := ShowModal = mrOk;
    if Result then
    begin
      AttrList.Clear;
      for I := 1 to sgAttr.RowCount-1 do
      begin
        S := Trim(sgAttr.Cells[0,I]);
        S := GetNameByValue(AttribTranslatesList, S);

        cntrl := GetControlForCell(I, sgAttr);
        if Assigned(cntrl) then
          S1 := cntrl.AsText
        else
          S1 := sgAttr.Cells[1, I];

        if S <> '' then
          AttrList.Add(S + '=' + S1);
      end;

      if Assigned(StyleList) then
      begin
        StyleList.Clear;
        for I := 1 to sgStyle.RowCount-1 do
        begin
          S := Trim(sgStyle.Cells[0,I]);
          S := GetNameByValue(StyleTranslatesList, S);

          cntrl := GetControlForCell(I, sgStyle);
          if Assigned(cntrl) then
            S1 := cntrl.AsText
          else
            S1 := sgStyle.Cells[1,I];

          if S <> '' then
            StyleList.Add(S + '=' + S1);
        end;
      end;
    end;

    inttostr(1);
  finally
    ClearControlList;
    Free;
  end;
end;

procedure TPropertyForm.FormShow(Sender: TObject);
begin
  TrackBar1Change(TrackBar1);
end;

procedure TPropertyForm.sgStyleDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  cntrl: TBaseAttribControl;
begin
  if (ACol = 1) and (ARow > 0) then
  begin
    cntrl := GetControlForCell(ARow, TStringGrid(Sender));
    if Assigned(cntrl) then
    begin
      //cntrl.ShowOnGrid(TStringGrid(Sender), ACol, ARow);
      cntrl.DrawOnCell(Sender, ACol, ARow, Rect, State);
    end;
    //GetControlForCell
  end;
end;

procedure TPropertyForm.sgStyleEnter(Sender: TObject);
begin
  HideAllControls;
end;

procedure TPropertyForm.sgStyleSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  cntrl: TBaseAttribControl;
begin
  HideAllControls;

  if (ACol = 1) and (ARow > 0) then
  begin
    cntrl := GetControlForCell(ARow, TStringGrid(Sender));
    if Assigned(cntrl) then
    begin
      TStringGrid(Sender).EditorMode := False;
      cntrl.ShowOnGrid(TStringGrid(Sender), ACol, ARow);
    end;
    //GetControlForCell
  end;
//
end;

procedure TPropertyForm.TrackBar1Change(Sender: TObject);
begin
  AlphaBlend := TrackBar1.Position <> 255;
  AlphaBlendValue := TrackBar1.Position;
end;

end.
