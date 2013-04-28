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

unit MedBaseFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, StdCtrls, Buttons,
  JvAppStorage, JvAppRegistryStorage, JvComponentBase, JvFormPlacement,
  ActnList, MedGlobalUnit;

type
  TMedBaseForm = class(TForm)
    panOkCancel: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    JvFormStorage1: TJvFormStorage;
    JvAppRegistryStorage1: TJvAppRegistryStorage;
    BaseActionList: TActionList;
    acOK: TAction;
    TimerAfterShow: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure acOKExecute(Sender: TObject);
    procedure TimerAfterShowTimer(Sender: TObject);
  private
    { Private declarations }
  protected
    Objs: TObjHolder;
    procedure ApplyRights(IsAdmin: Boolean); virtual;
    procedure OnAfterShow; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  MedBaseForm: TMedBaseForm;

implementation

{$R *.dfm}

{ TMedBaseForm }

procedure TMedBaseForm.acOKExecute(Sender: TObject);
begin
  if btnOK.Visible and btnOK.Enabled then
    btnOK.Click;
end;

procedure TMedBaseForm.ApplyRights(IsAdmin: Boolean);
begin
  //
end;

constructor TMedBaseForm.Create(AOwner: TComponent);
begin
  inherited;
  Objs := TObjHolder.Create;
end;

destructor TMedBaseForm.Destroy;
begin
  Objs.Free;
  inherited;
end;

procedure TMedBaseForm.FormCreate(Sender: TObject);
begin
  ApplyRights(IsAdmin);
end;

procedure TMedBaseForm.OnAfterShow;
begin
//
end;

procedure TMedBaseForm.TimerAfterShowTimer(Sender: TObject);
begin
  TimerAfterShow.Enabled := False;
  OnAfterShow;
end;

end.
