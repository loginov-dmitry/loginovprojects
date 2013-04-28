{
Copyright (c) 2005, Loginov Dmitry Sergeevich
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

unit U_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, ExtCtrls, ComCtrls, ImgList, StdCtrls,
  Buttons, FileCtrl;

type
  THelpForm = class(TForm)
    Panel1: TPanel;
    TreeView1: TTreeView;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    WebBrowser1: TWebBrowser;
    ImageList1: TImageList;
    btnBack: TBitBtn;
    btnForward: TBitBtn;
    BitBtn3: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreeView1Collapsed(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Expanded(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure btnBack1Click(Sender: TObject);
    procedure btnForward1Click(Sender: TObject);
    procedure WebBrowser1NavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshHelp;
    procedure GetDirList(DirName: String; List: TStringList);
    procedure GetFileList(DirName: String; List: TStringList);
    procedure SortList(Path: String; List: TStringList);
  public
    { Public declarations }
  end;

var
  HelpForm: THelpForm;
  AppPath, HelpPath: String;
  MainList: TStringList;
  HistoryList: TStringList;
  HistoryCursor: Integer;

implementation

uses U_Add;

{$R *.dfm}

{ TForm1 }

{=============================================================================
Построение дерева разделов справки}
procedure THelpForm.RefreshHelp;
var
  DirList, FileList: TStringList;
  I, J: Integer;
  S: String;
  TN: TTreeNode;
begin
  HistoryList.Clear;
  HistoryCursor := -1;
  btnBack.Enabled := False;
  btnForward.Enabled := False;
  DirList := TStringList.Create; 
  HelpPath := AppPath + 'Doc\';
  if FileExists(AppPath+'HelpDir.sys') then begin
    DirList.LoadFromFile(AppPath+'HelpDir.sys');
    if DirList[0]<>'' then begin
      if (Length(DirList[0]) > 3) and (DirList[0][2] = ':') then
        HelpPath := DirList[0] else HelpPath := AppPath+DirList[0];
      if  HelpPath[Length(HelpPath)]<>'\' then HelpPath:=HelpPath+'\';
      if not DirectoryExists(HelpPath) then HelpPath := AppPath + 'Doc\';
    end;
  end;    
  fmAdd.Label5.Visible := True;
  if not DirectoryExists(HelpPath) then begin
    BitBtn2.Click;
    ShowMessage('Пожалуйста, нажмите кнопку "Обновить"');
    Exit;
  end;
  fmAdd.Label5.Visible := False;

  DirList.Clear;
  FileList := TStringList.Create;
  TreeView1.Items.Clear;  // Очиства дерева объектов
  GetDirList(HelpPath, DirList);
  SortList(HelpPath, DirList);
  if DirList.Count = 0 then begin
    ShowMessage('Разделы справки не найдены');
    WebBrowser1.Navigate('about:blank');
    Exit;
  end;
  MainList.Clear;
  for I := 0 to DirList.Count - 1 do begin
    MainList.Append(DirList[I]+'\');
    GetFileList(DirList[I], FileList);
    SortList(DirList[I]+'\', FileList);
    if FileList.Count > 0 then
      for J := 0 to FileList.Count - 1 do
        MainList.Append(DirList[I]+'\'+FileList[J]);
  end;
  // Построение дерева объектов
  for I := 0 to MainList.Count - 1 do begin
    // Если папка:
    if MainList[I][Length(MainList[I])] = '\' then begin
      S := MainList[I]; Delete(S, Length(S), 1);
      S := ExtractFileName(S);
      TN:=TreeView1.Items.Add(nil, S);
      TN.ImageIndex := 0;
      TN.SelectedIndex := 0;  
    end  else begin // Если файл:
      S := ExtractFileName(MainList[I]);   
      Delete(S, Length(S) - 4, 5);
      with TreeView1.Items.AddChild(TN, S) do begin
        ImageIndex := 2;
        SelectedIndex := 2;
      end;
    end;
  end;
  with DirList, FileList do Free;
end;

procedure THelpForm.GetDirList(DirName: String; List: TStringList);
var
  FS: TSearchRec;
  Path: String;
begin
   if DirName[Length(DirName)]<>'\' then DirName := DirName+'\';
   Path := DirName+'*.*';
   List.Clear;
   List.Sort;
  if
    FindFirst(Path, faAnyFile, FS)=0 then
  begin
    if (DirectoryExists(DirName+FS.Name))
    and ((FS.Name<>'.') and (FS.Name<>'..')) then
    List.Append(DirName+FS.Name);
    while FindNext(FS)=0 do
    begin
      if (DirectoryExists(DirName+FS.Name))
       and ((FS.Name<>'.') and (FS.Name<>'..'))
        then
      List.Append(DirName+FS.Name);
    end;
    FindClose(FS);
  end;
end;


procedure THelpForm.GetFileList(DirName: String; List: TStringList);
var
  FS: TSearchRec;
  Path: String;
begin
  if DirName[Length(DirName)]<>'\' then DirName := DirName+'\';
  Path := DirName+'*.html';
  List.Clear;
  if FindFirst(Path, $00000020, FS)=0 then
  begin
    List.Append(FS.Name);
    while FindNext(FS)=0 do
    begin
      List.Append(FS.Name);
    end;
    FindClose(FS);
  end;
end;


procedure THelpForm.FormCreate(Sender: TObject);
begin
  AppPath := ExtractFilePath(ParamStr(0));
  MainList := TStringList.Create;
  HistoryList:= TStringList.Create;     
 // RefreshHelp;
//  TreeView1.Select(TreeView1.TopItem);
end;

procedure THelpForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainList.Free;
  HistoryList.Free;
end;

procedure THelpForm.TreeView1Collapsed(Sender: TObject; Node: TTreeNode);
begin
  Node.ImageIndex := 0;
  Node.SelectedIndex := 0;
end;

procedure THelpForm.TreeView1Expanded(Sender: TObject; Node: TTreeNode);
begin
  Node.ImageIndex := 1;
  Node.SelectedIndex := 1;
  TreeView1.Invalidate;
end;

procedure THelpForm.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  Num: Integer;
  S: String;
begin
  Num := Node.AbsoluteIndex;
  S := MainList[Num];
  if S[Length(S)] = '\' then S := S + 'Describe.htm';
  if not FileExists(S) then StatusBar1.Panels[0].Text := 'Страница не найдена' else
    StatusBar1.Panels[0].Text := S;
  WebBrowser1.Navigate(S);     
end;

procedure THelpForm.btnBack1Click(Sender: TObject);
begin
  Dec(HistoryCursor);
  btnBack.Enabled := HistoryCursor <> 0;
  WebBrowser1.Navigate(HistoryList[HistoryCursor]);
 // if  WebBrowser1.
 // WebBrowser1.GoBack;
end;

procedure THelpForm.btnForward1Click(Sender: TObject);
begin
  Inc(HistoryCursor);
  btnForward.Enabled := HistoryCursor <> HistoryList.Count - 1;
  WebBrowser1.Navigate(HistoryList[HistoryCursor]);
 // WebBrowser1.GoForward;
end;

procedure THelpForm.WebBrowser1NavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  S: String;
  I: Integer;
  Flag: Boolean;
begin
  btnBack.Enabled := True;
  btnForward.Enabled := True;
  S := URL;
  if Pos('%', S) > 0 then Exit;
  Flag := False;
  if HistoryList.Count > 0 then
    for I := 0 to HistoryList.Count-1 do
      if AnsiUpperCase(HistoryList[I]) = AnsiUpperCase(S) then begin
        HistoryCursor := I;
        Flag := True;
        Break;
      end;
  // Если в списке еще не было данной страницы, то добавляем ее
  if not Flag then begin
    HistoryList.Append(S);
    Inc(HistoryCursor);
  end;
  btnBack.Enabled := HistoryCursor <> 0;
  btnForward.Enabled := HistoryCursor <> HistoryList.Count-1;
  if not FileExists(S) then StatusBar1.Panels[0].Text := 'Страница не найдена' else
    StatusBar1.Panels[0].Text := S;
end;

procedure THelpForm.BitBtn3Click(Sender: TObject);
begin
  RefreshHelp();
  WebBrowser1.Navigate(MainList[0]+'Describe.htm');
end;

procedure THelpForm.BitBtn1Click(Sender: TObject);
begin
  Close();
end;

procedure THelpForm.SortList(Path: String; List: TStringList);
var
  TmpFullList, TmpSmallList: TStringList;
  I, C: Integer;
  S, S1: String;
begin
  C := 0;
  TmpFullList := TStringList.Create();
  TmpSmallList := TStringList.Create();
  if not FileExists(Path+'Sort.txt') then Exit;
  TmpSmallList.LoadFromFile(Path+'Sort.txt');
  if TmpSmallList.Count = 0 then Exit;
  while true do begin
    Inc(C);
    if C = 1000 then Break;
    if TmpSmallList.Count = 0 then Break;
    S1 := TmpSmallList[0];
    for I := 0 to List.Count - 1 do begin
      S := AnsiUpperCase(ExtractFileName(List[I]));
      if TmpSmallList.Count = 0 then Break; 
      if S = AnsiUpperCase(TmpSmallList[0]) then begin
        TmpFullList.Append(List[I]);
        TmpSmallList.Delete(0);
        List.Delete(I);
        Break;
      end;
    end;
    if TmpSmallList.Count = 0 then Break;
    if S1 = TmpSmallList[0] then TmpSmallList.Delete(0);
  end;
  if List.Count > 0 then
    for I := 0 to List.Count - 1 do
      TmpFullList.Append(List[I]);
  List.Text := TmpFullList.Text;
  with TmpFullList, TmpSmallList do Free();
end;

procedure THelpForm.BitBtn2Click(Sender: TObject);
var
  List: TStringList;
begin
  if fmAdd.ShowModal = mrYes then begin
    List:= TStringList.Create;
    List.Text := fmAdd.Edit1.Text;
    List.SaveToFile(AppPath+'HelpDir.sys');
    List.Free;
  end;
end;

procedure THelpForm.FormShow(Sender: TObject);
begin
  RefreshHelp;
  TreeView1.Select(TreeView1.TopItem);
end;

end.
