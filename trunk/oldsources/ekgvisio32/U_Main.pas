{
Copyright (c) 2005-2010, Loginov Dmitry Sergeevich
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
  Dialogs, ExtCtrls, StdCtrls, EKGVisio32, Matrix32, matrixProcessSignal, JPEG{, JclDebug},
  AppEvnts;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Button4: TButton;
    Button1: TButton;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button6: TButton;
    Button7: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Edit2: TEdit;
    Button5: TButton;
    Timer1: TTimer;
    Timer2: TTimer;
    ApplicationEvents1: TApplicationEvents;
    Timer3: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { Private declarations }
    FQRSList: TList;

    vertgl: TGraphicLine;
  public
    { Public declarations }
    procedure ChangePositionProc(Sender: TGraphicLine);

    procedure OnMouseDownEKGRect(ARow: Integer);
  end;

var
  Form1: TForm1;
  Ar: TEKGArea;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
const
  EKGFile = 'EKG_.bin';
  GraphicsFile = 'C:\File.jpg';
var
  Jpg: TJPEGImage;
begin          
  FQRSList := TList.Create;

  Ar := TEKGArea.Create(nil);
  Ar.Parent := Form1;
  Ar.Align := alClient;
  Ar.Frequency := 500;
  Ar.Sensitivity := 1000;

  Ar.OnMouseDownEKGRect := OnMouseDownEKGRect;

{  Ar.GetImPanel.Width := 800;
  Ar.GetImPanel.Height := 600;

  Ar.GetImageBuffer.Width := 800;
  Ar.GetImageBuffer.Height := 600;  }

  Ar.DrawGrid(); // Рисуем миллиметровку

  Ar.SetColors([clBlue, clBlue, clBlue, clRed, clRed, clRed, clGreen, clGreen, clGreen]);
  if FileExists(EKGFile) then
  begin
    Base.LoadWorkspace(EKGFile);
    Ar.LoadSignals(Base['EKG']);

    //Ar.AddSegmentLine('1', 100, 500, clRed, psDot, 3, 1);

    Ar.DrawEKG;

   { Jpg := TJPEGImage.Create;
    try
      Jpg.Assign(Ar.GetImageBuffer);   
      //Ar.GetImageBuffer.SaveToFile(GraphicsFile);
      Jpg.SaveToFile(GraphicsFile);
    finally
      Jpg.Free;
    end;  }
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Ar.DrawTextMessage(sCopyright);
end;


procedure TForm1.ChangePositionProc(Sender: TGraphicLine);
begin
  caption := inttostr(random(100));
//
  Sender.Hint := IntToStr(Sender.Position);
   //Sender.Position := Sender.Position + 10;

  Ar.AddSegmentLine('a', 0, Sender.Position, clGreen, psSolid, 2, 1, False);
  Ar.AddColorAreaSegment('a', 100, -600, Sender.Position, 600, clRed, clBlue, psSolid, -1);
  //Ar.DrawEKG;
  Timer1.Enabled := True;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Ar.DeleteGraphicLine();
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  Modes: TGraphicLineSet;
begin
  if RadioButton1.Checked then Modes := [gtVertical];
  if RadioButton2.Checked then Modes := [gtHorizontal];
  if CheckBox1.Checked then Modes := Modes + [gtSynchronize];
  if CheckBox2.Checked then Modes := Modes + [gtMoveAble];

  with Ar.NewGraphicLine(Modes, StrToInt(Edit1.Text){Random(500)+1}{1000}, 2, true) do
  begin
    Color := clBlack;
    ChangePositionProc := Self.ChangePositionProc;
    ShowHint := True;
    Hint := IntToStr(Position);
    PenStyle := psDot;
  end;

  //Caption := IntToStr(Ar.GraphicLines.Count);

  //Ar.DrawEKG;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  gl: TGraphicLine;
  i:integer;
begin
//  showmessage(inttostr(Ar.GetPixelCoord(4)));
  gl := Ar.NewGraphicLine([gtVertical, gtSynchronize, gtMoveAble], Random(500)+1);
  vertgl := gl;
  with gl do
  begin
    Color := clBlack;
    ChangePositionProc := Self.ChangePositionProc;
    ShowHint := True;
    PenStyle := psDot;
  end;
(* for i := 1 to 12 do
  with Ar.NewGraphicLine([gtHorizontal, gtSynchronize{, gtMoveAble}], 0,i) do
  begin
    AttachedVertLine := gl;
    Color := clBlack;
    ChangePositionProc := Self.ChangePositionProc;
    ShowHint := True;
    PenStyle := psDot;
  end;     *)
  //Timer2.Enabled := True;
//  Timer3.Enabled := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  I: Integer;
  Peaks: TMatrix;
begin
  while FQRSList.Count > 0 do
  begin
    Ar.DeleteGraphicLine(TGraphicLine(FQRSList[0]));   
    FQRSList.Delete(0);
  end;

  Peaks := TIntegerMatrix.Create(Base, 'Peaks');
  //FindQRSPeaks(Base['EKG'], Peaks);

  for I := 0 to Peaks.ElemCount - 1 do
  begin
    Ar.NewGraphicLine([gtVertical, gtSynchronize, gtMoveAble], Peaks.VecElemI[I]);
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FQRSList.Free;
end;

procedure TForm1.OnMouseDownEKGRect(ARow: Integer);
begin
  Ar.SelectedCurveNumber := ARow;
  Ar.DrawEKG;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  I: Integer;
begin
{  for I := 1 to StrToInt(Edit2.Text) do
  begin
    Button6.Click;
  end;}
 //  tbutton.Create(tcomponent(123));
  //raise Exception.Create('Бля, ошибка!!!');
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Ar.DrawEKG;
  Timer1.Enabled := False;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
try
  vertgl.Position := vertgl.Position + 1;
except
  on E: Exception do
    ShowMessage('Ошибка: ' + E.Message);
end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
 Timer2.Enabled := False;
end;

initialization

finalization


end.

