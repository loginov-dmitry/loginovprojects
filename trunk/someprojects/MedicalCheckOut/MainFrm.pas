{
Copyright (c) 2012, Loginov Dmitry Sergeevich
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

unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMedMainFrm = class(TForm)
    btnEditElems: TButton;
    btnNewCheckout: TButton;
    btnExit: TButton;
    btnCheckoutList: TButton;
    Button2: TButton;
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnEditElemsClick(Sender: TObject);
    procedure btnNewCheckoutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MedMainFrm: TMedMainFrm;

implementation

{$R *.dfm}

uses MedDoctorsFrm, MedEditElemBaseFrm, MedCreateCheckOutFrm;

procedure TMedMainFrm.btnEditElemsClick(Sender: TObject);
begin
  EditElemBase;
end;

procedure TMedMainFrm.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMedMainFrm.btnNewCheckoutClick(Sender: TObject);
begin
  ShowCreateCheckOutForm;
end;

procedure TMedMainFrm.Button1Click(Sender: TObject);
begin
  ShowMedDoctorsForm;
end;

procedure TMedMainFrm.Button2Click(Sender: TObject);
begin
  Application.MessageBox(
    'ПРОГРАММА ДЛЯ ОФОРМЛЕНИЯ ВЫПИСОК' + sLineBreak +
    'ДЛЯ СТАЦИОНАРА ГОД. БОЛЬНИЦЫ.' + sLineBreak +
    'Разработчик: к.т.н., доцент каф. ИИТ ПГУ,' + sLineBreak+
    'ведущий программист ООО "АВТОМАТИКА плюс"' + sLineBreak+
    '       Логинов Дмитрий Сергеевич' + sLineBreak +
    'mailto: loginov_d@inbox.ru', 'О ПРОГРАММЕ')
end;

end.
