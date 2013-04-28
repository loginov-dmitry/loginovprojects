{
Copyright (c) 2005-2006, Loginov Dmitry Sergeevich
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

{                                                                             }
{                                                                             }
{                                                                             }
{                                                                             }
{
Каждый пункт в TreeView имеет заданное свойство ImageIndex, к иконкам оно
отношения не имеет. При выборе любого пункта ищется панель со свойством
Tag таким же, как свойство ImageIndex у выбранного пункта.
Нумерация выполнена следующим образом:

Рабочая область: 1, 2, 3
Функции ядра: 11 - 15
Графика: 21, 22
Взаимодействие с Matlab: 31
Модуль Signals: 41
Модуль DemoFunc: 51
Модуль NNet: 61, 63

Благодаря пропущенным числам можно для каждого модуля создать до 9 панелей
}

unit U_MatTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, Matrix, Signals, NNet,
  FileCtrl, Spin, Math, TeEngine, Series, TeeProcs, Chart, DemoFunc;

type
  TForm1 = class(TForm)
    panMain: TPanel;
    Panel5: TPanel;
    TreeView1: TTreeView;
    Panel6: TPanel;
    panLoadFromFiles: TPanel;
    GroupBox1: TGroupBox;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    Memo2: TMemo;
    GroupBox3: TGroupBox;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    Memo3: TMemo;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    Label1: TLabel;
    OpenDialog3: TOpenDialog;
    OpenDialog2: TOpenDialog;
    OpenDialog1: TOpenDialog;
    panViewArrays: TPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    GroupBox4: TGroupBox;
    ListBox1: TListBox;
    Panel4: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button63: TButton;
    Splitter1: TSplitter;
    Panel7: TPanel;
    Button3: TButton;
    Button5: TButton;
    Memo4: TMemo;
    GroupBox5: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Panel8: TPanel;
    Button4: TButton;
    Label2: TLabel;
    Label3: TLabel;
    panSaveLoad: TPanel;
    GroupBox15: TGroupBox;
    Label46: TLabel;
    Label49: TLabel;
    Edit23: TEdit;
    Edit25: TEdit;
    Button19: TButton;
    Button20: TButton;
    GroupBox16: TGroupBox;
    Label50: TLabel;
    Label51: TLabel;
    Edit26: TEdit;
    Edit27: TEdit;
    Button21: TButton;
    Button22: TButton;
    Label4: TLabel;
    GroupBox6: TGroupBox;
    Label5: TLabel;
    Edit2: TEdit;
    Button6: TButton;
    Button7: TButton;
    GroupBox7: TGroupBox;
    Label15: TLabel;
    Edit4: TEdit;
    Button8: TButton;
    Button9: TButton;
    Button26: TButton;
    Button10: TButton;
    panSet1: TPanel;
    GroupBox8: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Edit3: TEdit;
    Edit5: TEdit;
    Button11: TButton;
    GroupBox9: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Edit6: TEdit;
    Button12: TButton;
    GroupBox10: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    Edit7: TEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Edit8: TEdit;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    GroupBox11: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Button13: TButton;
    Button14: TButton;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    GroupBox12: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label136: TLabel;
    Edit12: TEdit;
    Edit13: TEdit;
    SpinEdit5: TSpinEdit;
    Button15: TButton;
    Button16: TButton;
    CheckBox1: TCheckBox;
    SpinEdit25: TSpinEdit;
    GroupBox13: TGroupBox;
    Label31: TLabel;
    Label32: TLabel;
    Edit14: TEdit;
    Edit15: TEdit;
    Button17: TButton;
    GroupBox14: TGroupBox;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Edit16: TEdit;
    SpinEdit6: TSpinEdit;
    SpinEdit7: TSpinEdit;
    Button18: TButton;
    GroupBox17: TGroupBox;
    Label10: TLabel;
    Label33: TLabel;
    Edit17: TEdit;
    Edit18: TEdit;
    Button23: TButton;
    panTestSpeed: TPanel;
    Label168: TLabel;
    Label169: TLabel;
    Label170: TLabel;
    Label171: TLabel;
    SpinEdit30: TSpinEdit;
    Edit120: TEdit;
    panSet2: TPanel;
    GroupBox24: TGroupBox;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Edit52: TEdit;
    SpinEdit8: TSpinEdit;
    SpinEdit9: TSpinEdit;
    Button43: TButton;
    Edit53: TEdit;
    SpinEdit10: TSpinEdit;
    SpinEdit11: TSpinEdit;
    GroupBox25: TGroupBox;
    Label83: TLabel;
    Label84: TLabel;
    Edit54: TEdit;
    Edit55: TEdit;
    Button44: TButton;
    Button71: TButton;
    GroupBox28: TGroupBox;
    Label94: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Edit64: TEdit;
    Button50: TButton;
    Edit65: TEdit;
    SpinEdit14: TSpinEdit;
    SpinEdit15: TSpinEdit;
    GroupBox38: TGroupBox;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    Edit87: TEdit;
    Edit89: TEdit;
    Edit90: TEdit;
    Button60: TButton;
    GroupBox34: TGroupBox;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Edit78: TEdit;
    Edit79: TEdit;
    Edit80: TEdit;
    Button56: TButton;
    GroupBox40: TGroupBox;
    Label133: TLabel;
    Label134: TLabel;
    Label135: TLabel;
    Edit92: TEdit;
    Button62: TButton;
    SpinEdit23: TSpinEdit;
    SpinEdit24: TSpinEdit;
    GroupBox39: TGroupBox;
    Label131: TLabel;
    Label132: TLabel;
    Edit91: TEdit;
    Button61: TButton;
    CheckBox6: TCheckBox;
    SpinEdit22: TSpinEdit;
    GroupBox26: TGroupBox;
    Label85: TLabel;
    Label86: TLabel;
    Label167: TLabel;
    Edit56: TEdit;
    Button45: TButton;
    Edit57: TEdit;
    SpinEdit29: TSpinEdit;
    Button72: TButton;
    panSet3: TPanel;
    GroupBox35: TGroupBox;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label121: TLabel;
    Edit81: TEdit;
    Edit82: TEdit;
    Edit83: TEdit;
    Button57: TButton;
    SpinEdit18: TSpinEdit;
    GroupBox36: TGroupBox;
    Label120: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Edit84: TEdit;
    Edit85: TEdit;
    Edit86: TEdit;
    Button58: TButton;
    SpinEdit19: TSpinEdit;
    GroupBox32: TGroupBox;
    Label105: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Edit71: TEdit;
    Edit72: TEdit;
    Edit73: TEdit;
    Button54: TButton;
    Edit74: TEdit;
    SpinEdit17: TSpinEdit;
    GroupBox29: TGroupBox;
    Label95: TLabel;
    Label96: TLabel;
    Label100: TLabel;
    Edit66: TEdit;
    Edit67: TEdit;
    Button51: TButton;
    CheckBox3: TCheckBox;
    SpinEdit12: TSpinEdit;
    GroupBox30: TGroupBox;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Edit68: TEdit;
    Edit69: TEdit;
    Button52: TButton;
    CheckBox4: TCheckBox;
    SpinEdit13: TSpinEdit;
    GroupBox33: TGroupBox;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Edit75: TEdit;
    Edit76: TEdit;
    Edit77: TEdit;
    Button55: TButton;
    GroupBox31: TGroupBox;
    Label104: TLabel;
    Label106: TLabel;
    Edit70: TEdit;
    Button53: TButton;
    CheckBox5: TCheckBox;
    SpinEdit16: TSpinEdit;
    panFillArrays: TPanel;
    GroupBox18: TGroupBox;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Button24: TButton;
    GroupBox19: TGroupBox;
    Label52: TLabel;
    Edit28: TEdit;
    Button25: TButton;
    GroupBox20: TGroupBox;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Button27: TButton;
    Edit35: TEdit;
    GroupBox47: TGroupBox;
    Label159: TLabel;
    Label160: TLabel;
    Label161: TLabel;
    Label162: TLabel;
    Edit112: TEdit;
    Edit113: TEdit;
    Edit114: TEdit;
    Button36: TButton;
    Edit115: TEdit;
    panStreams: TPanel;
    GroupBox21: TGroupBox;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label34: TLabel;
    ComboBox1: TComboBox;
    Edit19: TEdit;
    Button28: TButton;
    Edit20: TEdit;
    Button29: TButton;
    Button30: TButton;
    Memo6: TMemo;
    Button39: TButton;
    Label41: TLabel;
    Label42: TLabel;
    SpinEdit20: TSpinEdit;
    SpinEdit21: TSpinEdit;
    GroupBox22: TGroupBox;
    ComboBox2: TComboBox;
    Label43: TLabel;
    Label44: TLabel;
    SpinEdit26: TSpinEdit;
    Label45: TLabel;
    Edit21: TEdit;
    Label47: TLabel;
    OpenDialog4: TOpenDialog;
    Button31: TButton;
    Label48: TLabel;
    Edit22: TEdit;
    Button32: TButton;
    Button33: TButton;
    Label60: TLabel;
    SpinEdit27: TSpinEdit;
    Label61: TLabel;
    SpinEdit28: TSpinEdit;
    panCreateGrArray: TPanel;
    Panel9: TPanel;
    Label91: TLabel;
    Edit62: TEdit;
    Button47: TButton;
    Button48: TButton;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Panel10: TPanel;
    Label90: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Edit61: TEdit;
    Edit63: TEdit;
    Button49: TButton;
    panDrawArray: TPanel;
    Panel11: TPanel;
    Label154: TLabel;
    Edit109: TEdit;
    SpinEdit31: TSpinEdit;
    Button34: TButton;
    Panel12: TPanel;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Chart2: TChart;
    LineSeries1: TLineSeries;
    CheckBox2: TCheckBox;
    panMatlab: TPanel;
    Label62: TLabel;
    Label63: TLabel;
    Button35: TButton;
    Edit37: TEdit;
    Button37: TButton;
    Button38: TButton;
    Edit36: TMemo;
    Button40: TButton;
    Label64: TLabel;
    GroupBox23: TGroupBox;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Edit24: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    ComboBox3: TComboBox;
    Button41: TButton;
    GroupBox27: TGroupBox;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Edit40: TEdit;
    Edit41: TEdit;
    ComboBox4: TComboBox;
    Button42: TButton;
    panSignals1: TPanel;
    GroupBox45: TGroupBox;
    Label150: TLabel;
    Label151: TLabel;
    Label152: TLabel;
    Label153: TLabel;
    Edit42: TEdit;
    Edit43: TEdit;
    Edit44: TEdit;
    Edit108: TEdit;
    Button46: TButton;
    GroupBox37: TGroupBox;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Button59: TButton;
    GroupBox41: TGroupBox;
    Label75: TLabel;
    Label76: TLabel;
    Label87: TLabel;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit50: TEdit;
    Button64: TButton;
    GroupBox42: TGroupBox;
    Label88: TLabel;
    Label89: TLabel;
    Label125: TLabel;
    Edit51: TEdit;
    Edit58: TEdit;
    Edit59: TEdit;
    Button65: TButton;
    GroupBox43: TGroupBox;
    Label126: TLabel;
    Label127: TLabel;
    Label137: TLabel;
    Edit60: TEdit;
    Edit88: TEdit;
    Edit93: TEdit;
    Button66: TButton;
    CheckBox9: TCheckBox;
    GroupBox44: TGroupBox;
    Label138: TLabel;
    Label148: TLabel;
    Label149: TLabel;
    Edit99: TEdit;
    Edit100: TEdit;
    Button67: TButton;
    SpinEdit32: TSpinEdit;
    panDemoFunc: TPanel;
    GroupBox46: TGroupBox;
    Label139: TLabel;
    Label140: TLabel;
    Label141: TLabel;
    Edit94: TEdit;
    Button68: TButton;
    SpinEdit33: TSpinEdit;
    SpinEdit34: TSpinEdit;
    GroupBox48: TGroupBox;
    Label142: TLabel;
    Label143: TLabel;
    Label144: TLabel;
    Edit95: TEdit;
    Edit96: TEdit;
    Edit97: TEdit;
    Button69: TButton;
    panZaglushka: TPanel;
    CheckBox10: TCheckBox;
    panNNet1: TPanel;
    GroupBox49: TGroupBox;
    Label145: TLabel;
    Label146: TLabel;
    Label147: TLabel;
    Button70: TButton;
    Edit98: TEdit;
    Edit101: TEdit;
    Edit102: TEdit;
    Button73: TButton;
    GroupBox50: TGroupBox;
    Label155: TLabel;
    Label156: TLabel;
    Edit103: TEdit;
    Edit104: TEdit;
    Button74: TButton;
    GroupBox51: TGroupBox;
    Label163: TLabel;
    Label164: TLabel;
    Label165: TLabel;
    Label166: TLabel;
    Edit116: TEdit;
    Edit117: TEdit;
    Edit118: TEdit;
    Button75: TButton;
    Edit119: TEdit;
    NNet2: TPanel;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    GroupBox52: TGroupBox;
    Label157: TLabel;
    Label158: TLabel;
    Label172: TLabel;
    Label173: TLabel;
    Label174: TLabel;
    Label175: TLabel;
    Label176: TLabel;
    Edit105: TEdit;
    Edit106: TEdit;
    Edit107: TEdit;
    Edit110: TEdit;
    Edit111: TEdit;
    Edit121: TEdit;
    Edit122: TEdit;
    Button76: TButton;
    panStat: TPanel;
    GroupBox53: TGroupBox;
    Label177: TLabel;
    Edit123: TEdit;
    Edit124: TEdit;
    Edit125: TEdit;
    Label180: TLabel;
    Label181: TLabel;
    CheckBox11: TCheckBox;
    Button77: TButton;
    Button78: TButton;
    GroupBox54: TGroupBox;
    Label178: TLabel;
    Label179: TLabel;
    Edit126: TEdit;
    Edit127: TEdit;
    CheckBox12: TCheckBox;
    Button79: TButton;
    GroupBox55: TGroupBox;
    Label182: TLabel;
    Label183: TLabel;
    Edit128: TEdit;
    Edit129: TEdit;
    CheckBox13: TCheckBox;
    Button80: TButton;
    GroupBox56: TGroupBox;
    Edit130: TEdit;
    Label184: TLabel;
    Button81: TButton;
    GroupBox57: TGroupBox;
    Button83: TButton;
    CheckBox14: TCheckBox;
    Label185: TLabel;
    Edit131: TEdit;
    Label186: TLabel;
    Edit132: TEdit;
    Button82: TButton;
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button63Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure SpinEdit30Change(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button43Click(Sender: TObject);
    procedure Button50Click(Sender: TObject);
    procedure Button61Click(Sender: TObject);
    procedure Button44Click(Sender: TObject);
    procedure Button71Click(Sender: TObject);
    procedure Button56Click(Sender: TObject);
    procedure Button62Click(Sender: TObject);
    procedure Button60Click(Sender: TObject);
    procedure Button45Click(Sender: TObject);
    procedure Button72Click(Sender: TObject);
    procedure Button55Click(Sender: TObject);
    procedure Button53Click(Sender: TObject);
    procedure Button51Click(Sender: TObject);
    procedure Button52Click(Sender: TObject);
    procedure Button54Click(Sender: TObject);
    procedure Button58Click(Sender: TObject);
    procedure Button57Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button36Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button39Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
    procedure panCreateGrArrayResize(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button49Click(Sender: TObject);
    procedure Button48Click(Sender: TObject);
    procedure Button47Click(Sender: TObject);
    procedure Button34Click(Sender: TObject);
    procedure Button40Click(Sender: TObject);
    procedure Button35Click(Sender: TObject);
    procedure Button37Click(Sender: TObject);
    procedure Button38Click(Sender: TObject);
    procedure Button41Click(Sender: TObject);
    procedure Button42Click(Sender: TObject);
    procedure Button59Click(Sender: TObject);
    procedure Button64Click(Sender: TObject);
    procedure Button65Click(Sender: TObject);
    procedure Button46Click(Sender: TObject);
    procedure Button66Click(Sender: TObject);
    procedure Button67Click(Sender: TObject);
    procedure Button69Click(Sender: TObject);
    procedure Button68Click(Sender: TObject);
    procedure Button70Click(Sender: TObject);
    procedure Button73Click(Sender: TObject);
    procedure Button74Click(Sender: TObject);
    procedure Button75Click(Sender: TObject);
    procedure Button76Click(Sender: TObject);
    procedure Button77Click(Sender: TObject);
    procedure Button78Click(Sender: TObject);
    procedure Button79Click(Sender: TObject);
    procedure Button80Click(Sender: TObject);
    procedure Button81Click(Sender: TObject);
    procedure Button82Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshInfo();
  end;
  
  function DelBackslash(S: String): String;
var
  Form1: TForm1;
  Cnt: Integer = 1;
  C: Integer;
  Tc: Cardinal;
  ByteArray:      array[1..100] of Byte;
  ShortintArray:  array[1..100] of Shortint;
  WordArray:      array[1..100] of Word;
  ShortArray:     array[1..100] of Short;
  DWordArray:     array[1..100] of DWord;
  IntegerArray:   array[1..100] of Integer;
  Int64Array:     array[1..100] of Int64;
  RealArray:      array[1..100] of Real;
  MDown: Boolean=False;
  OldCoord: TPoint;
  L: TMatrixList;
implementation

uses PolyFuncs, USlau;

{$R *.dfm}
procedure StartCikle;
begin
  Tc := GetTickCount;
  Form1.Edit120.Text :='';
end;
procedure EndCikle;
begin
  Tc := GetTickCount-Tc;
  Form1.Edit120.Text :=Inttostr(Tc);
  Beep;
end;

function DelBackslash(S: String): String;
begin
  Result := S;
  if S = '' then Exit;
  if S[Length(S)] = '\' then
  Result := Copy(S, 1, Length(S)-1);
end;

function GetStandartType(Str: string): TStandartType;
begin
  Str := AnsiLowerCase(Str);
  Result := stByte;
  if Str = 'byte' then Result := stByte;
  if Str = 'shortint' then Result := stShortint;
  if Str = 'word' then Result := stWord;
  if Str = 'smallint' then Result := stSmallint;
  if Str = 'short' then Result := stShort;
  if Str = 'integer' then Result := stInteger;
  if Str = 'longint' then Result := stLongint;
  if Str = 'cardinal' then Result := stCardinal;
  if Str = 'longword' then Result := stLongword;
  if Str = 'dword' then Result := stDword;
  if Str = 'int64' then Result := stInt64;
  if Str = 'real' then Result := stReal;
  if Str = 'double' then Result := stDouble;
  if Str = 'real48' then Result := stReal48;
  if Str = 'single' then Result := stSingle;
  if Str = 'extended' then Result := stExtended;
  if Str = 'comp' then Result := stComp;
  if Str = 'currency' then Result := stCurrency;
end;

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  Num, I, Cnt: Integer;  
begin
  Num := Node.ImageIndex;   

  if Num = 2 then RefreshInfo;

  Cnt := panMain.ControlCount;
  for I := 1 to Cnt do
    begin
      if panMain.Controls[I - 1].Tag <> Num then
        panMain.Controls[I - 1].Visible := False else
      begin
        with panMain.Controls[I - 1] do begin
          Left := 0; Top := 0;
          Align := alClient;
          Visible := True;  
        end;
      end
    end;
  panTestSpeed.Visible := True;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  TreeView1.SetFocus;
  TreeView1.FullExpand;
  Edit20.Text := InttoHex(Integer(@ByteArray),8);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  Dir: String;
begin
  Dir := Edit1.Text;
  if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],1000) then
  Edit1.Text := Dir+'\';
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Ext: String;
begin
  Edit1.Text := ExtractFilePath(ParamStr(0));
  if (ParamStr(1) <> '') then begin
    Edit1.Text := ExtractFilePath(ParamStr(1));
    Ext := ExtractFileName(ParamStr(1));
    Ext := AnsiLowerCase(Copy(Ext, Length(Ext) - 2, 3));
    if Ext = 'bin' then Base.LoadFromBinFile(ParamStr(1));
    if Ext = 'asc' then Base.LoadFromAscii(ParamStr(1));
    if Ext = 'dat' then Base.LoadFromTextFile(ParamStr(1));
    RefreshInfo();
  end;
  L:= TMatrixList.Create;
end;

procedure TForm1.RefreshInfo;
begin
  Base.GetNameList(ListBox1.Items);    
  Label3.Caption := IntToStr(Base.GetElemCount);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  OpenDialog1.InitialDir:=Edit1.Text;
  if OpenDialog1.Execute then  Memo1.Text := OpenDialog1.Files.Text;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Memo1.Lines.Count-1 do
    Base.LoadFromAscii(Memo1.Lines.Strings[I]);
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  OpenDialog2.InitialDir:=Edit1.Text;
  if OpenDialog2.Execute then  Memo2.Text := OpenDialog2.Files.Text;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
var
 I: Integer;
begin
  for I := 0 to Memo2.Lines.Count-1 do
   Base.LoadFromBinFile(Memo2.Lines.Strings[I]);
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
  OpenDialog3.InitialDir:=Edit1.Text;
  if OpenDialog3.Execute then  Memo3.Text := OpenDialog3.Files.Text;
end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
var
 I: Integer;
begin
  for I := 0 to Memo3.Lines.Count-1 do
   Base.LoadFromTextFile(Memo3.Lines.Strings[I]);
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
  Memo2.Clear;
end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
begin
  Memo3.Clear;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  VarName: String;
  RowCount, ColCount,SizeInBytes: Integer;
  Address: Integer;
  AdrInt: Integer;
begin
  VarName:=ListBox1.Items.Strings[ListBox1.ItemIndex];
  with Base do
  begin
    Address := GetAddress(GetSize(VarName, RowCount, ColCount));
    SizeInBytes := RowCount * ColCount * 8;
  end; 
  AdrInt := Address;
  Label11.Caption := Inttostr(RowCount);
  Label12.Caption := Inttostr(ColCount);
  Label13.Caption := Inttostr(SizeInBytes);
  Label14.Caption := Inttohex(AdrInt,8);

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to ListBox1.Items.Count-1 do
   if ListBox1.Selected[I] then
     Base.SaveToAscii(DelBackslash(Edit1.Text)+'\'+
     ListBox1.Items.Strings[I], ListBox1.Items.Strings[I]);   
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to ListBox1.Items.Count-1 do
   if ListBox1.Selected[I] then
    Base.Clear(ListBox1.Items.Strings[I]);
  RefreshInfo;
end;

procedure TForm1.Button63Click(Sender: TObject);
begin
  Base.Clear;
  ListBox1.Clear;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  I: Integer;
  StrBuf, StrTmp: String;
begin
  StrBuf:='';

  for I := 0 to ListBox1.Items.Count-1 do
   if ListBox1.Selected[I] then begin
    StrTmp := Base.SaveArrayToString(ListBox1.Items.Strings[I]);
    Insert(StrTmp, StrBuf, Length(StrBuf)+1);
   end;

   Memo4.Text := StrBuf;
   StrBuf:='';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Memo4.Lines.SaveToFile(DelBackslash(Edit1.Text)+'\'+'TempWS.dat');
  Base.LoadFromTextFile(DelBackslash(Edit1.Text)+'\'+'TempWS.dat');
  DeleteFile(DelBackslash(Edit1.Text)+'\'+'TempWS.dat');
  RefreshInfo;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Memo4.Clear;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Base.SaveToBinFile(DelBackslash(Edit1.Text)+'\'+Edit2.Text);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Base.LoadFromBinFile(DelBackslash(Edit1.Text)+'\'+Edit2.Text);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  Base.SaveToTextFile(DelBackslash(Edit1.Text)+'\'+Edit4.Text);
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  Base.LoadFromTextFile(DelBackslash(Edit1.Text)+'\'+Edit4.Text);
end;

procedure TForm1.Button26Click(Sender: TObject);
begin
  with TWorkspace.Create('defrag') do begin
    LoadFromBinFile(DelBackslash(Edit1.Text)+'\'+Edit2.Text);
    SaveToBinFile(DelBackslash(Edit1.Text)+'\'+Edit2.Text);
    Free;
  end;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  with TWorkspace.Create('defrag') do begin
    LoadFromTextFile(DelBackslash(Edit1.Text)+'\'+Edit4.Text);
    SaveToTextFile(DelBackslash(Edit1.Text)+'\'+Edit4.Text);
    Free;
  end;
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
  Base.SaveToBinFile(DelBackslash(Edit1.Text)+'\'+Edit23.Text, Edit25.Text);
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
  Base.LoadFromBinFile(DelBackslash(Edit1.Text)+'\'+Edit23.Text, Edit25.Text);
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
  Base.SaveToTextFile(DelBackslash(Edit1.Text)+'\'+Edit26.Text, Edit27.Text);
end;

procedure TForm1.Button22Click(Sender: TObject);
begin
  Base.LoadFromTextFile(DelBackslash(Edit1.Text)+'\'+Edit26.Text, Edit27.Text);
end;

procedure TForm1.SpinEdit30Change(Sender: TObject);
begin
  Cnt := SpinEdit30.Value;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    base.NewArray(Edit6.Text, SpinEdit1.Value, SpinEdit2.Value,
      CheckBox10.Checked);
  EndCikle;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
  Base.CopyArray(Edit3.Text, Edit5.Text);
  EndCikle;
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
  Base.Transpose(Edit14.Text, Edit15.Text);
  EndCikle;
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
  Base.RenameArray(Edit17.Text, Edit18.Text);
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  Base.Resize(Edit16.Text, SpinEdit6.Value, SpinEdit7.Value);
end;

procedure TForm1.SpeedButton13Click(Sender: TObject);
begin
  Edit8.Text := FloatToStr(Base.Elem[Edit7.Text,SpinEdit3.Value,
    SpinEdit4.Value]);
end;

procedure TForm1.SpeedButton14Click(Sender: TObject);
begin
  Base.SetEl(Edit7.Text, AnyStrToFloat(Edit8.Text),SpinEdit3.Value,
    SpinEdit4.Value, CheckBox7.Checked, CheckBox8.Checked);
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.AddRows(Edit9.Text, Edit10.Text, Edit11.Text);
  EndCikle;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.AddCols(Edit9.Text, Edit10.Text, Edit11.Text);
  EndCikle;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    if CheckBox1.Checked then
      Base.CopyCutRows(Edit12.Text, Edit13.Text, SpinEdit5.Value, SpinEdit25.Value)
    else
      Base.CopyCutCols(Edit12.Text, Edit13.Text, SpinEdit5.Value, SpinEdit25.Value);
  EndCikle;
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
  if CheckBox1.Checked then
    Base.CopyCutRows(Edit12.Text, Edit13.Text, SpinEdit5.Value, SpinEdit25.Value, True)
  else
    Base.CopyCutCols(Edit12.Text, Edit13.Text, SpinEdit5.Value, SpinEdit25.Value, True);
  EndCikle;
end;

procedure TForm1.Button43Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.CopySubmatrix(Edit52.Text, Edit53.Text, SpinEdit10.Value, SpinEdit8.Value,
    SpinEdit11.Value, SpinEdit9.Value);
  EndCikle;
end;

procedure TForm1.Button50Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.PasteSubmatrix(Edit64.Text, Edit65.Text, SpinEdit14.Value, SpinEdit15.Value);
  EndCikle;
end;

procedure TForm1.Button61Click(Sender: TObject);
var
  I: Integer;
  R: Real;
begin
  R := Base.GetMinOrMax(Edit91.Text, SpinEdit22.Value, TDim(not CheckBox14.Checked),
   CheckBox6.Checked, I);
  Edit132.Text := FloatToStr(R);
  Edit131.Text := FloatToStr(I);
end;

procedure TForm1.Button44Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.SumRows(Edit54.Text, Edit55.Text);
  EndCikle;
end;

procedure TForm1.Button71Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.SumCols(Edit54.Text, Edit55.Text);
  EndCikle;
end;

procedure TForm1.Button56Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.MulMatrix(Edit78.Text, Edit79.Text, Edit80.Text);
  EndCikle;
end;

procedure TForm1.Button62Click(Sender: TObject);
begin
  Base.ResizeMatrix(Edit92.Text, SpinEdit23.Value, SpinEdit24.Value); 
end;

procedure TForm1.Button60Click(Sender: TObject);
begin
  if Base.IsEqual(Edit87.Text, Edit89.Text, Edit90.Text) then
    ShowMessage('Матрицы равны') else ShowMessage('Матрицы не равны')
end;

procedure TForm1.Button45Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.InsertRows(Edit56.Text, Edit57.Text, SpinEdit29.Value);
  EndCikle;
end;

procedure TForm1.Button72Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.InsertCols(Edit56.Text, Edit57.Text, SpinEdit29.Value);
  EndCikle;
end;

procedure TForm1.Button55Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    SLAU(Base, Edit75.Text, Edit76.Text, Edit77.Text);
  EndCikle;
end;

procedure TForm1.Button53Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    GenerateGaluaTable(Base, Edit70.Text,SpinEdit16.Value, CheckBox5.Checked);
  EndCikle;
end;

procedure TForm1.Button51Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Shift(Base, Edit66.Text,Edit67.Text,SpinEdit12.Value, CheckBox3.Checked);
  EndCikle;   
end;

procedure TForm1.Button52Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    CirShift(Base, Edit68.Text,Edit69.Text,SpinEdit13.Value, CheckBox4.Checked);
  EndCikle;
end;

procedure TForm1.Button54Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    DivPolinoms(Base, Edit71.Text, Edit72.Text, Edit73.Text, Edit74.Text, SpinEdit17.Value,
   False);
  EndCikle;
end;

procedure TForm1.Button58Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    MulPolinoms(Base, Edit84.Text, Edit85.Text, Edit86.Text, SpinEdit19.Value);
  EndCikle;
end;

procedure TForm1.Button57Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    SumPolinoms(Base, Edit81.Text, Edit82.Text, Edit83.Text, SpinEdit18.Value);
  EndCikle;
end;

procedure TForm1.Button25Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.RandomAr(Edit28.Text);
  EndCikle;
end;

procedure TForm1.Button24Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.FillAr(Edit29.Text, AnyStrtofloat(Edit30.Text),
      AnyStrtofloat(Edit31.Text));
  EndCikle;
end;

procedure TForm1.Button27Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.NewArray(Edit32.Text, AnyStrtofloat(Edit33.Text),
      AnyStrtofloat(Edit35.Text), AnyStrtofloat(Edit34.Text));
  EndCikle;
end;

procedure TForm1.Button36Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.NewFillAr(Edit112.Text, AnyStrtofloat(Edit113.Text),
      AnyStrtofloat(Edit115.Text), StrtoInt(Edit114.Text));
  EndCikle;
end;

procedure TForm1.Button30Click(Sender: TObject);
var
  I: Integer;
begin
  if ComboBox1.Text='0 to 2^8 (Byte)' then
    for I := 1 to 100 do ByteArray[I]:=Random($FF);
  if ComboBox1.Text='-2^7 to 2^7 (Shortint)' then
    for I := 1 to 100 do ShortintArray[I]:=Random($FF);
  if ComboBox1.Text='0 to 2^16 (Word)' then
    for I := 1 to 100 do WordArray[I]:=Random($FFFF);
  if ComboBox1.Text='-2^15 to 2^15 (Short)' then
    for I := 1 to 100 do ShortArray[I]:=Random($FFFF);
  if ComboBox1.Text='0 to 2^32 (DWord)' then
    for I := 1 to 100 do DWordArray[I]:=Random($FFFFFFFF);
  if ComboBox1.Text='-2^31 to 2^31 (Integer)' then
    for I := 1 to 100 do IntegerArray[I]:=Random($FFFFFFFF);
  if ComboBox1.Text='-2^63 to 2^63 (Int64)' then
    for I := 1 to 100 do Int64Array[I]:=Random($FFFFFFFF)*1000;
  if ComboBox1.Text='Real' then
    for I := 1 to 100 do RealArray[I]:=Random($FFFFFFFF)*9999999999999;
end;

procedure TForm1.Button29Click(Sender: TObject);
var
  I: Integer;
  S: String;
  R: Real;
begin
  if ComboBox1.Text='0 to 2^8 (Byte)' then
    for I := 1 to 100 do S := S+' '+Inttostr(ByteArray[I]);
  if ComboBox1.Text='-2^7 to 2^7 (Shortint)' then
    for I := 1 to 100 do S := S+' '+Inttostr(ShortintArray[I]);
  if ComboBox1.Text='0 to 2^16 (Word)' then
    for I := 1 to 100 do S := S+' '+Inttostr(WordArray[I]);
  if ComboBox1.Text='-2^15 to 2^15 (Short)' then
    for I := 1 to 100 do S := S+' '+Inttostr(ShortArray[I]);
  if ComboBox1.Text='0 to 2^32 (DWord)' then
    for I := 1 to 100 do S := S+' '+Inttostr(DWordArray[I]);
  if ComboBox1.Text='-2^31 to 2^31 (Integer)' then
    for I := 1 to 100 do S := S+' '+Inttostr(IntegerArray[I]);
  if ComboBox1.Text='-2^63 to 2^63 (Int64)' then
    for I := 1 to 100 do begin
      R := Int64Array[I];
      S := S+' '+FloatToStrGen(R);
    end;

  if ComboBox1.Text='Real' then
    for I := 1 to 100 do S := S+' '+FloattostrGen(RealArray[I]);

  Memo6.Text := S;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.Text='0 to 2^8 (Byte)' then
    Edit20.Text := InttoHex(Integer(@ByteArray),8);
  if ComboBox1.Text='-2^7 to 2^7 (Shortint)' then
    Edit20.Text := InttoHex(Integer(@ShortintArray),8);
  if ComboBox1.Text='0 to 2^16 (Word)' then
    Edit20.Text := InttoHex(Integer(@WordArray),8);
  if ComboBox1.Text='-2^15 to 2^15 (Short)' then
    Edit20.Text := InttoHex(Integer(@ShortArray),8);
  if ComboBox1.Text='0 to 2^32 (DWord)' then
    Edit20.Text := InttoHex(Integer(@DWordArray),8);
  if ComboBox1.Text='-2^31 to 2^31 (Integer)' then
    Edit20.Text := InttoHex(Integer(@IntegerArray),8);
  if ComboBox1.Text='-2^63 to 2^63 (Int64)' then
    Edit20.Text := InttoHex(Integer(@Int64Array),8);
  if ComboBox1.Text='Real' then
    Edit20.Text := InttoHex(Integer(@RealArray),8);
end;

procedure TForm1.Button28Click(Sender: TObject);
var
  VarName: String;
  Address: Pointer;
  Rows, Cols: Integer;
begin
  VarName := Edit19.Text;
  Address := Pointer(StrToInt('$'+Edit20.Text));
  Rows := SpinEdit20.Value;
  Cols := SpinEdit21.Value;
  StartCikle;
  for C := 1 to Cnt do
  with Base do begin
    if ComboBox1.Text='0 to 2^8 (Byte)' then
      LoadArrayFromMemory(VarName, Address, Rows, Cols, GetStandartType('BYTE'));
    if ComboBox1.Text='-2^7 to 2^7 (Shortint)' then
      LoadArrayFromMemory(VarName, Address, Rows, Cols, GetStandartType('Shortint'));
    if ComboBox1.Text='0 to 2^16 (Word)' then
      LoadArrayFromMemory(VarName, Address, Rows, Cols, GetStandartType('Word'));
    if ComboBox1.Text='-2^15 to 2^15 (Short)' then
      LoadArrayFromMemory(VarName, Address, Rows, Cols, GetStandartType('Short'));
    if ComboBox1.Text='0 to 2^32 (DWord)' then
      LoadArrayFromMemory(VarName, Address, Rows, Cols, GetStandartType('DWord'));
    if ComboBox1.Text='-2^31 to 2^31 (Integer)' then
      LoadArrayFromMemory(VarName, Address, Rows, Cols, GetStandartType('Integer'));
    if ComboBox1.Text='-2^63 to 2^63 (Int64)' then
      LoadArrayFromMemory(VarName, Address, Rows, Cols, GetStandartType('Int64'));
    if ComboBox1.Text='Real' then
      LoadArrayFromMemory(VarName, Address, Rows, Cols, GetStandartType('Real'));
  end;
  EndCikle;

end;

procedure TForm1.Button39Click(Sender: TObject);
var
  VarName: String;
  Address: Pointer;
begin
  VarName := Edit19.Text;
  Address := Pointer(StrToInt('$'+Edit20.Text));
  StartCikle;
  for C := 1 to Cnt do
  with Base do begin
    if ComboBox1.Text='0 to 2^8 (Byte)' then
      SaveArrayToMemory(VarName, Address, GetStandartType('BYTE'));
    if ComboBox1.Text='-2^7 to 2^7 (Shortint)' then
      SaveArrayToMemory(VarName, Address, GetStandartType('Shortint'));
    if ComboBox1.Text='0 to 2^16 (Word)' then
      SaveArrayToMemory(VarName, Address, GetStandartType('Word'));
    if ComboBox1.Text='-2^15 to 2^15 (Short)' then
      SaveArrayToMemory(VarName, Address, GetStandartType('Short'));
    if ComboBox1.Text='0 to 2^32 (DWord)' then
      SaveArrayToMemory(VarName, Address, GetStandartType('DWord'));
    if ComboBox1.Text='-2^31 to 2^31 (Integer)' then
      SaveArrayToMemory(VarName, Address, GetStandartType('Integer'));
    if ComboBox1.Text='-2^63 to 2^63 (Int64)' then
      SaveArrayToMemory(VarName, Address, GetStandartType('Int64'));
    if ComboBox1.Text='Real' then
      SaveArrayToMemory(VarName, Address, GetStandartType('Real'));
  end;
  EndCikle;

end;

procedure TForm1.Button31Click(Sender: TObject);
begin
  if OpenDialog4.Execute then
    Edit21.Text := OpenDialog4.FileName;
end;

procedure TForm1.Button33Click(Sender: TObject);
var
  Fs: TFileStream;
  fName: String;
begin
  fName := Edit21.Text;
  if not FileExists(fName) then Exit;
  Fs := TFileStream.Create(fName, fmOpenRead);
  try
    Base.LoadArrayFromStream(Edit22.Text, Fs, SpinEdit27.Value, SpinEdit28.Value,
      GetStandartType(ComboBox2.Text), SpinEdit26.Value);
  finally
    Fs.Free;
  end;
end;

procedure TForm1.Button32Click(Sender: TObject);
var
  Fs: TFileStream;
  fName: String;
begin
  fName := Edit21.Text;
  Fs := TFileStream.Create(fName, fmCreate);
  try
    Base.SaveArrayToStream(Edit22.Text, Fs, GetStandartType(ComboBox2.Text), SpinEdit26.Value);
  finally
    Fs.Free;
  end;
end;

procedure TForm1.panCreateGrArrayResize(Sender: TObject);
var
  W,H,I: Integer;
begin
  W := StrToInt(Edit61.Text);
  H := StrToInt(Edit63.Text);

  with Image1 do begin
    Width:=W;
    Height:=H;

    Picture.Bitmap := nil;
    Canvas.Brush.Color := clWhite;
    Canvas.Pen.Color := clBlack;
    Canvas.Rectangle(0,0,W,H);

    for I:=1 to W-1 do
      Canvas.Pixels[I, H div 2]:=clBlue;
  end;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if mbLeft in [Button] then begin
   MDown:=True;
   OldCoord.X :=X;
   OldCoord.Y :=Y;
   Image1.Canvas.PenPos := OldCoord;
  end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if mbLeft in [Button] then MDown:=False;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label92.Caption := Inttostr(X);
  Label93.Caption := Inttostr(StrToInt(Edit63.Text)div 2-Y);

  if not MDown then Exit;

  // Проводим линию
  Image1.Canvas.LineTo(X,Y);
  OldCoord.X :=X;
  OldCoord.Y :=Y;
end;

procedure TForm1.Button49Click(Sender: TObject);
begin
  panCreateGrArrayResize(nil);
end;

procedure TForm1.Button48Click(Sender: TObject);
var
  VarName, Temp: String;
  I, J, K: Integer;
  W,H: Integer;
begin
  Temp := Base.GenName;
  W := StrToInt(Edit61.Text);
  H := StrToInt(Edit63.Text);
  VarName := Edit62.text;
  K:=0;
  for I:= 1 to W-2 do begin
    for J := 1 to H-2 do begin
      if Image1.Canvas.Pixels[I,J]=clBlack then begin
        Inc(K);
        Base.SetEl(Temp, H div 2 - J, 1, K, True, True);
        Break;
      end;
    end;
  end;
  Base.RenameArray(Temp, VarName);

end;

procedure TForm1.Button47Click(Sender: TObject);
var
  VarName: String;
  CC, I: Integer;
  P: TPoint;
  H: Integer;
function GetMax(SourVar: String): Real;
var
  I,CC: Integer;
begin
  CC := Base.GetCols(SourVar);
  Result:= -MaxDouble;
  for I := 1 to CC do
    if Abs(Base.Elem[SourVar,1,I])>Result then Result :=
      Abs(Base.Elem[SourVar,1,I]);
end;
begin
  VarName := Edit62.text;
  CC:=Base.GetCols(VarName);
  Edit61.Text := IntToStr(CC + 2);
  Edit63.Text := IntToStr(Round(GetMax(VarName)*2) + 2);
  panCreateGrArrayResize(nil);

  H := StrToInt(Edit63.Text);
  P:=Point(1, Round(H div 2 - Base.Elem[VarName, 1, 1]));

  Image1.Canvas.PenPos := P;

  for I:=1 to CC do
   Image1.Canvas.LineTo(I, Round(H div 2 - Base.Elem[VarName, 1, I]));

end;

procedure TForm1.Button34Click(Sender: TObject);
var
  I, Cols, Rows, Row, Idx: Integer;
begin
  Chart2.Series[0].Clear;
  Row := SpinEdit31.Value;
  Idx := Base.GetSize(Edit109.Text, Rows, Cols);

  if CheckBox2.Checked then
    for I := 1 to Cols do
     Chart2.Series[0].AddXY(I, Base.ElemI[Idx, Row, I])
    else
    for I := 1 to Rows do
     Chart2.Series[0].AddXY(I, Base.ElemI[Idx, I, Row]);
end;

procedure TForm1.Button40Click(Sender: TObject);
begin
  Edit36.Text:='addpath('''+ExtractFileDir(Application.ExeName)+''')';
end;

procedure TForm1.Button35Click(Sender: TObject);
begin
  Base.SendMatlabCommand(Edit36.Text);
end;

procedure TForm1.Button37Click(Sender: TObject);
begin
  Base.PutArrayToMatlab(Edit37.Text);
end;

procedure TForm1.Button38Click(Sender: TObject);
begin
  Base.LoadArrayFromMatlab(Edit37.Text);
end;

procedure TForm1.Button41Click(Sender: TObject);
var
  Op: string;
  Fnc: TRealFunc2;
begin
  Op := ComboBox3.Text;
  Fnc := nil;
  if Op = '+' then Fnc := fncSum;
  if Op = '-' then Fnc := fncSub;
  if Op = '*' then Fnc := fncMul;
  if Op = '/' then Fnc := fncDiv;
  if Op = '^' then Fnc := fncPower;
  if Op = '=' then Fnc := fncEQ;
  if Op = '<>' then Fnc := fncNE;
  if Op = '<' then Fnc := fncLT;
  if Op = '>' then Fnc := fncGT;
  if Op = '<=' then Fnc := fncLE;
  if Op = '>=' then Fnc := fncGE; 
  StartCikle;
  for C := 1 to Cnt do
    Base.CalcFunc2(Edit24.Text, Edit38.Text, Edit39.Text, Fnc);
  EndCikle;
end;

procedure TForm1.Button42Click(Sender: TObject);
var
  Op: String;
  Fnc: TRealFunc;
begin
  Op := ComboBox4.Text;
  Fnc := fncSin;
  if Op = 'SIN'  then Fnc := fncSin;
  if Op = 'COS'  then Fnc := fncCos;
  if Op = 'SQRT' then Fnc := fncSqrt;
  if Op = 'ABS'  then Fnc := fncAbs;
  if Op = 'SQR'  then Fnc := fncSqr;
  if Op = 'ROUND' then Fnc := fncRound;
  if Op = 'TRUNC' then Fnc := fncTrunc;
  if Op = 'INT'  then Fnc := fncInt;
  if Op = 'FRAC' then Fnc := fncFrac;
  if Op = 'EXP'  then Fnc := fncExp;
  if Op = 'NONE' then Fnc := fncNone;
  StartCikle;
  for C := 1 to Cnt do
    Base.CalcFunc(Edit40.Text, Edit41.Text, Fnc);
  EndCikle;
end;

procedure TForm1.Button59Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
   mScaleSignals(Base, Edit45.Text, Edit46.Text, Strtoint(Edit47.Text));
  EndCikle;
end;

procedure TForm1.Button64Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    mNormAmplitude(Base, Edit48.Text, Edit49.Text, AnyStrtofloat(Edit50.Text));
  EndCikle;
end;

procedure TForm1.Button65Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    mSmoothSignals(Base, Edit51.Text, Edit58.Text, Strtoint(Edit59.Text));
  EndCikle;
end;

procedure TForm1.Button46Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    mFastInterp(Base, Edit42.Text, Edit43.Text, Edit44.Text, Edit108.Text);
  EndCikle;
end;

procedure TForm1.Button66Click(Sender: TObject);
begin
  if not
    mFindMaxPoints(Base, Edit60.Text, Edit88.Text,
      AnyStrtoFloat(Edit93.Text), CheckBox9.Checked)
  then
  ShowMessage('Ни одна точка экстремума не найдена');
end;

procedure TForm1.Button67Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Edit100.Text := FloatToStr(mFindIzoline(Base, Edit99.Text, SpinEdit32.Value));
  EndCikle;
end;

procedure TForm1.Button69Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    SlauLU(Base, edit95.Text,edit96.Text,edit97.Text);
  EndCikle;
end;

procedure TForm1.Button68Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    mGenBinaryCombinations(Base, SpinEdit33.Value, SpinEdit34.Value, Edit94.Text);
  EndCikle;
end;

procedure TForm1.Button70Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
  CalcDist(Base, Edit98.Text, Edit101.Text, Edit102.Text);
  EndCikle;
end;

procedure TForm1.Button73Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
  CalcNegDist(Base, Edit98.Text, Edit101.Text, Edit102.Text);
  EndCikle;
end;

procedure TForm1.Button74Click(Sender: TObject);
begin
  {StartCikle;
  for C := 1 to Cnt do
  mCompet(Base, Edit103.Text, Edit104.Text);
  EndCikle;}
end;

procedure TForm1.Button75Click(Sender: TObject);
{var
  E: Real; }
begin
  {StartCikle;
  for C := 1 to Cnt do
  mCalcKohon(Base, Edit116.Text, Edit117.Text, Edit118.Text, E);
  Edit119.Text := Floattostr(E);
  EndCikle;}
end;

procedure  DrawTrainProgress(epoch: Integer; err, ideal: Real);
var
  I: Integer;
begin
  // рисуем идеальную линию
  for I := 0 to epoch do 
  Form1.Series1.AddXY(I, ideal);

  // рисуем текущую ошибку обучения
  Form1.Series2.AddXY(epoch, err);
  Application.ProcessMessages;
end;

procedure TForm1.Button76Click(Sender: TObject);
begin
  {Chart1.Series[0].Clear;
  Chart1.Series[1].Clear;  
  mTrainPerceptron(Base, Edit105.Text, Edit106.Text, Strtoint(Edit110.Text),
    AnyStrtofloat(Edit111.Text), Edit107.Text, Edit122.Text,
    Edit121.Text, DrawTrainProgress); }
end;

procedure TForm1.Button77Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.GetMin(Edit123.Text, Edit124.Text, Edit125.Text, TDim(not CheckBox11.Checked));
  EndCikle;
end;

procedure TForm1.Button78Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.GetMax(Edit123.Text, Edit124.Text, Edit125.Text, TDim(not CheckBox11.Checked));
  EndCikle;                                               
end;

procedure TForm1.Button79Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.GetMinMax(Edit126.Text, Edit127.Text, TDim(not CheckBox12.Checked));
  EndCikle;
end;

procedure TForm1.Button80Click(Sender: TObject);
begin
  StartCikle;
  for C := 1 to Cnt do
    Base.GetMean(Edit128.Text, Edit129.Text, TDim(not CheckBox13.Checked));
  EndCikle;
end;

procedure TForm1.Button81Click(Sender: TObject);
var
  S: String;
begin
  case Base.GetElemType(Edit130.Text) of
    stReal     : S := 'Real';
    stByte     : S := 'Byte';
    stShortint : S := 'Shortint';
    stWord     : S := 'Word';
    stShort    : S := 'Short';
    stDWord    : S := 'DWord';
    stInteger  : S := 'Integer';
  end;
  ShowMessage(S);
end;


procedure TForm1.Button82Click(Sender: TObject);
var
  Net: TNetLVQ;
begin
 // CalcMSE(Base, 'A');
//  ShowMessage(Floattostr(CalcMSE(Base, 'A')));
//
  with Base do
  begin
    SLoad('TrainMatrix = [1 2 5 4 1; 2 7 1 1 9; 3 8 3 1 7; 5 9 4 2 8];');
    SLoad('Target = [1 0 0 1 0; 0 1 0 0 1; 0 0 1 0 0];');
    Net := TNetLVQ.Create([2, 3], [tfNone, tfNone]);
    Net.SetTrainAndTargetData(SelfWS, 'TrainMatrix', 'Target');
    Net.InitWeights;
    Net.Train;
   // Net.Simulate(Base, 'TrainMatrix', 'Res');
   // ShowMessage(Base.SaveArrayToString('Res'));
    Net.Free;
  end;
end;

end.
