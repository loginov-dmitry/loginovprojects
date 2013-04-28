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

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ExtDlgs, ComCtrls, StdCtrls, Spin, FileCtrl, Gauges,
  LDSfunc;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    cpu_freq: TLabel;
    cpu_ident: TLabel;
    cpu_name: TLabel;
    cpu_vendor: TLabel;
    cpu_mmx: TLabel;
    TabSheet2: TTabSheet;
    meml_PhisTotal: TLabel;
    meml_PhisUsage: TLabel;
    meml_PageTotal: TLabel;
    meml_PageUsage: TLabel;
    meml_VirtualTotal: TLabel;
    meml_VirtualUsage: TLabel;
    TabSheet3: TTabSheet;
    dil_Label: TLabel;
    dil_Ser: TLabel;
    dil_Fat: TLabel;
    dil_TotSize: TLabel;
    dil_FreeSize: TLabel;
    dil_MaxPath: TLabel;
    dil_TotClast: TLabel;
    dil_FreeClast: TLabel;
    dil_SecOnClast: TLabel;
    dil_ByteOnSect: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    DriveComboBox1: TDriveComboBox;
    Button1: TButton;
    Button2: TButton;
    TabSheet4: TTabSheet;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Button6: TButton;
    Edit6: TEdit;
    Button7: TButton;
    Button8: TButton;
    TabSheet5: TTabSheet;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    dsl_PixBits: TLabel;
    dsl_PixHor: TLabel;
    dsl_PixVert: TLabel;
    dsl_Freq: TLabel;
    dsl_MMHor: TLabel;
    dsl_MMVert: TLabel;
    dsl_PixHorInch: TLabel;
    dsl_PixVertInch: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label34: TLabel;
    Button9: TButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Button10: TButton;
    TabSheet6: TTabSheet;
    Label33: TLabel;
    Label37: TLabel;
    Button11: TButton;
    Memo1: TMemo;
    Button14: TButton;
    TabSheet7: TTabSheet;
    Label39: TLabel;
    Label41: TLabel;
    Button12: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Button18: TButton;
    TabSheet8: TTabSheet;
    Label38: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    Button13: TButton;
    TabSheet9: TTabSheet;
    Label40: TLabel;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    Button15: TButton;
    Button16: TButton;
    LabeledEdit7: TLabeledEdit;
    Button17: TButton;
    TabSheet10: TTabSheet;
    Label46: TLabel;
    memoHash: TMemo;
    Button22: TButton;
    edHash: TEdit;
    StatusBar1: TStatusBar;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenDialog1: TOpenDialog;
    cpu_Timer: TTimer;
    Button23: TButton;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Gauge1: TGauge;
    lSpeed: TLabel;
    Gauge2: TGauge;
    L11: TLabel;
    L22: TLabel;
    Label7: TLabel;
    edLog: TEdit;
    Label8: TLabel;
    Label35: TLabel;
    GroupBox2: TGroupBox;
    Label42: TLabel;
    Label43: TLabel;
    Button20: TButton;
    Edit7: TEdit;
    Button21: TButton;
    ComboBox1: TComboBox;
    Gauge3: TGauge;
    Edit8: TEdit;
    Label1: TLabel;
    Label36: TLabel;
    Button24: TButton;
    Label44: TLabel;
    procedure Button7Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cpu_TimerTimer(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button24Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  StopCopy: Boolean = False;
  StopFind: Boolean = False;

implementation

uses StrUtils;

{$R *.dfm}
function VisualCopyFile(Sour, Dest: String; CopyBytes, Size: DWORD;
    Speed: Real; FileNum, Files: Integer): Boolean;
begin
  Result := not StopCopy;
  with Form1 do begin  
    Gauge1.Progress := Round(CopyBytes / Size * 100);
    lSpeed.Caption := Inttostr(Round(Speed / 1024))+ 'кб/с';
    Gauge2.Progress := Round(FileNum / Files * 100);
    L11.Caption := MinimizeName(Sour, L11.Canvas, 250)+' -->';
    L22.Caption := MinimizeName(Dest, L22.Canvas, 250);
  end;
  Application.ProcessMessages;
end;


procedure TForm1.Button7Click(Sender: TObject);
begin
  StopCopy := False;
  LDSf.FileCopy(Edit4.Text, Edit5.Text, VisualCopyFile);
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
  StopCopy := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  StopCopy := False;
  LDSf.DirCopy(Edit1.Text,Edit2.Text,edLog.Text,VisualCopyFile);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  StopCopy := False;
  LDSf.FileMove(Edit4.Text, Edit5.Text, VisualCopyFile);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  StopCopy := False;
  LDSf.DirMove(Edit1.Text,Edit2.Text,edLog.Text,VisualCopyFile);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  LDSf.DirDelete(Edit3.Text, edLog.Text);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  DeleteFile(Edit6.Text);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  with LDSf do begin
    dil_Label.Caption := GetDiskInfo(DriveComboBox1.Drive,DI_TomLabel);
    dil_Ser.Caption := GetDiskInfo(DriveComboBox1.Drive,DI_SerNumber);
    dil_Fat.Caption := GetDiskInfo(DriveComboBox1.Drive,DI_FileSystem);
    dil_TotSize.Caption := FloatToStr(StrToFloat(GetDiskInfo(DriveComboBox1.Drive,DI_DiskSize))
      / (1024*1024*1024));

    dil_FreeSize.Caption := FloatToStr(StrToFloat(GetDiskInfo(DriveComboBox1.Drive,DI_DiskFreeSize))
      / (1024*1024*1024));
    dil_MaxPath.Caption := GetDiskInfo(DriveComboBox1.Drive,DI_MaximumLength);
    dil_TotClast.Caption := GetDiskInfo(DriveComboBox1.Drive,DI_TotalClasters);
    dil_FreeClast.Caption := GetDiskInfo(DriveComboBox1.Drive,DI_FreeClasters);
    dil_SecOnClast.Caption := GetDiskInfo(DriveComboBox1.Drive,DI_SectorsInClaster);
    dil_ByteOnSect.Caption := GetDiskInfo(DriveComboBox1.Drive,DI_BytesInSector);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowMessage(IntToStr(StrToInt(LDSf.GetDiskInfo(DriveComboBox1.Drive,DI_SectorsInClaster)) *
    StrToInt(LDSf.GetDiskInfo(DriveComboBox1.Drive,DI_BytesInSector))));
end;

procedure TForm1.cpu_TimerTimer(Sender: TObject);
begin
  with LDSf do begin
    meml_PhisTotal.Caption := 'Всего физической памяти, Мбайт:  '     +
       IntToStr(GetMemoryInfo(MEM_TotalPhys) div (1024*1024));
    meml_PhisUsage.Caption := 'Занято физ. памяти, Мбайт: '     +
       IntToStr(GetMemoryInfo(MEM_NotAvailPhys) div (1024*1024));
    meml_PageTotal.Caption := 'Размер файла подкачки, Мбайт: '     +
       IntToStr(GetMemoryInfo(MEM_TotalPageFile) div (1024*1024));
    meml_PageUsage.Caption := 'Использование файла подкачки, Мбайт: '     +
       IntToStr(GetMemoryInfo(MEM_NotAvailPageFile) div (1024*1024));
    meml_VirtualTotal.Caption := 'Всего виртуальной памяти, Мбайт: '     +
       IntToStr(GetMemoryInfo(MEM_TotalVirtual) div (1024*1024));
    meml_VirtualUsage.Caption := 'Использовано виртуальной памяти, Мбайт: '     +
       IntToStr(GetMemoryInfo(MEM_NotAvailVirtual) div (1024*1024));
  end;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
if LDSf.GetDisplayModeNum(SpinEdit3.Value,SpinEdit1.Value,SpinEdit2.Value,0,true)>=0 then
  LDSf.ChangeDisplayMode(LDSf.GetDisplayModeNum(SpinEdit3.Value,SpinEdit1.Value,
   SpinEdit2.Value,0,true));
end;

procedure TForm1.Button22Click(Sender: TObject);
begin
  edHash.Text:=LDSf.md5(memoHash.Text);
end;

procedure TForm1.Button17Click(Sender: TObject);
var
  S: String;
begin
  S := Copy(ExtractFileName(LabeledEdit5.Text),1,Length(LabeledEdit5.Text))+'.lnk';
  LDSf.CreateShotCut(LabeledEdit5.Text, LDSf.ExcludeTrailingBackslash(
    LabeledEdit7.Text)+'\'+S, LabeledEdit6.Text);
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  LDSf.CreateShotCut_InPrograms(LabeledEdit4.Text,LabeledEdit5.Text,
    LabeledEdit6.Text,Handle);
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  LDSf.CreateShotCut_OnDesktop(LabeledEdit5.Text,
    LabeledEdit6.Text,Handle);
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  LDSf.ExecuteFile
    (Handle,        // Указатель на окно, вызвавшее функцию
     LabeledEdit1.Text,    // Имя выполняемого файла (с возможным путем доступа)
     LabeledEdit2.Text,            // Передаваемые параметры
     LabeledEdit3.Text,// Текущая директория для запускаемой программы
     SW_SHOW   // Способ отображения окна запущенного файла (SW_SHOW)
              );
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    LDSf.CreateRgnFromBitmap(Panel2.Handle, OpenPictureDialog1.FileName);
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    LDSf.CreateRgnFromBitmap(Form1.Handle, OpenPictureDialog1.FileName);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  with LDSf do begin
    Memo1.Clear;
    Memo1.Lines.Append('Версия - '+ GetOSInfo(OS_Version,'ХЗ'));
    Memo1.Lines.Append('Платформа - '+ GetOSInfo(OS_Platform,'ХЗ'));
    Memo1.Lines.Append('Название - '+ GetOSInfo(OS_Name,'ХЗ'));
    Memo1.Lines.Append('Организация - '+ GetOSInfo(OS_Organization,'ХЗ'));
    Memo1.Lines.Append('Владелец - '+ GetOSInfo(OS_Owner,'ХЗ'));
    Memo1.Lines.Append('Сер. номер - '+ GetOSInfo(OS_SerNumber,'ХЗ'));
    Memo1.Lines.Append('Имя хоста - '+ GetOSInfo(OS_IPName,'ХЗ'));
    Memo1.Lines.Append('Каталог ОС - '+ GetOSInfo(OS_WinPath,'ХЗ'));
    Memo1.Lines.Append('Системный каталог - '+ GetOSInfo(OS_SysPath,'ХЗ'));
    Memo1.Lines.Append('Временная папка - '+ GetOSInfo(OS_TempPath,'ХЗ'));
    Memo1.Lines.Append('Каталог для программ - '+ GetOSInfo(OS_ProgramFilesPath,'ХЗ'));
  end;
end;

procedure TForm1.Button14Click(Sender: TObject);
var
  I: Integer;
begin
  Memo1.Clear;
  for I := 0 to $0038 do
  begin
    Memo1.Lines.Append(LDSf.GetSystemPath(0,I));
  end;

end;

function VisFind(Pos, Size: Int64): boolean;
begin
  Result := not StopFind;
  Form1.Gauge3.Progress := Round(Pos * 100 / Size);
  Application.ProcessMessages;
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
StopFind := False;
ShowMessage(IntToHex(LDSf.FindHexStringInFile(
Edit8.Text,
Edit7.Text,
0,
ComboBox1.ItemIndex+1, VisFind
),8));
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
  StopFind := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  OpenPictureDialog1.InitialDir := ExtractFileDir(ParamStr(0));
  OpenDialog1.InitialDir := ExtractFileDir(ParamStr(0));
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  with LDSf do begin
    cpu_freq.Caption := cpu_freq.Caption + GetProcessorInfo(CP_SPEED,0,'0');
    cpu_ident.Caption := cpu_ident.Caption + GetProcessorInfo(CP_Identifier,0,'NONE');
    cpu_name.Caption := cpu_name.Caption + GetProcessorInfo(CP_NameString,0,'NONE');
    cpu_vendor.Caption := cpu_vendor.Caption + GetProcessorInfo(CP_VendorIdentifier,0,'NONE');
    cpu_mmx.Caption := cpu_mmx.Caption + GetProcessorInfo(CP_MMXIdentifier,0,'NONE');
  end;

end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  with LDSf do begin
    dsl_PixBits.Caption := IntToStr(GetDisplaySettings(DS_BitsOnPixel));
    dsl_PixHor.Caption := IntToStr(GetDisplaySettings(DS_HorPixelSize));
    dsl_PixVert.Caption := IntToStr(GetDisplaySettings(DS_VerPixelSize));
    dsl_Freq.Caption := IntToStr(GetDisplaySettings(DS_Frequency));
    dsl_MMHor.Caption := IntToStr(GetDisplaySettings(DS_HorMMSize));
    dsl_MMVert.Caption := IntToStr(GetDisplaySettings(DS_VerMMSize));
    dsl_PixHorInch.Caption := IntToStr(GetDisplaySettings(DS_PixelsOnInch_Hor));
    dsl_PixVertInch.Caption := IntToStr(GetDisplaySettings(DS_PixelsOnInch_Ver));
  end;
end;

procedure TForm1.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel2.Color := Random(100000);
end;

procedure TForm1.Button24Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit8.Text := OpenDialog1.FileName;
end;

end.
