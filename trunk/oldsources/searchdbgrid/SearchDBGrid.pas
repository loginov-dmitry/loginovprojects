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

unit SearchDBGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Menus, Controls, DBGrids, DB,
  ExtCtrls;

const
  CBMSG_KEYDOWN = 45078;
  CBMSG_KEYPRESS = 48386;

type
  // Определяет тип процедуры, которая будет вызывается в начале,
  // в процессе и в конце поиска
  TSearchUpdate = procedure(Sender: TObject; InSearchMode: Boolean; SearchText: string) of object;

  TSearchDBGrid = class(TComponent)
  private
    FShortCut: TShortCut;
    FAltShortCut: TShortCut;
    FIsSearchMode: Boolean;
    FOnSearchUpdate: TSearchUpdate;
    FSearchText: string;
    FDBGridList: TList;
    FDBGridListOptions: TList;
    FOnKeyDown: TKeyEvent;
    FOnKeyPress: TKeyPressEvent;
    FTimer: TTimer;
    FCanFastSearch: Boolean;
    procedure SetIsSearchMode(const Value: Boolean);

    // Определяет, можно ли в принципе выполнять поиск (фокус должен быть)
    // на компоненте DBGrid
    function CanSearch: Boolean;

    // Определяет, находится ли компонент на активном окне приложения
    function IsOnActiveForm: Boolean;
    procedure SetAltShortCut(const Value: TShortCut);
    procedure SetShortCut(const Value: TShortCut);
    procedure SetOnKeyDown(const Value: TKeyEvent);
    procedure SetOnKeyPress(const Value: TKeyPressEvent);

    procedure ProcOnTimer(Sender: TObject);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    function LocateRecByText(Txt: string): Boolean;

    procedure ProcKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ProcKeyPress(Sender: TObject; var Key: Char);

    constructor Create(AOwner: TComponent); override;

    destructor Destroy; override;
    // Возвращает True, если пользователь нажал одну из 2-х заданных
    // горячих клавич (если они конечно заданы!)
    function IsAssignedShortCut(AShortCut: TShortCut): Boolean;

    // Свойство устанавливает или сбрасывает режим поиска
    property IsSearchMode: Boolean read FIsSearchMode write SetIsSearchMode;

    property CanFastSearch: Boolean read FCanFastSearch write FCanFastSearch;

    property SearchText: string read FSearchText;
  published
    { Published declarations }

    // Назначаются быстрые клавиши.
    property ShortCut: TShortCut read FShortCut write SetShortCut default 0;
    // Альтернативные быстные клавиши
    property AltShortCut: TShortCut read FAltShortCut write SetAltShortCut default 0;
    property OnSearchUpdate: TSearchUpdate read FOnSearchUpdate write FOnSearchUpdate;

    // Обработчики, заданные этими свойствами, будут вызываться
    // на наше усмотрение. Эти обработчики круче, чем при использовании
    // KeyPreview - у них приоритет выше
    property OnKeyDown: TKeyEvent read FOnKeyDown write SetOnKeyDown;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write SetOnKeyPress;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('loginOFF', [TSearchDBGrid]);
end;

var
  Hook: HHOOK;
  SearchDBGridList: TList;

function CallBackWndProc(Code, Flag, PData: Integer): Integer; stdcall;
var
  Msg: TCWPStruct;
  AKey: Word;
  AChar: Char;
  ShiftState: TShiftState;
  I: Integer;
  Obj: TSearchDBGrid;
begin
  Result := 0;
  
  try
    Msg := PCWPStruct(PData)^;

    case Msg.message of
      CBMSG_KEYDOWN:
        begin
          ShiftState := KeyDataToShiftState(Msg.lParam);
          AKey := Msg.wParam;
          // Посылаем сообщение всем элементам списка
          for I := 0 to SearchDBGridList.Count - 1 do
          begin
            Obj := SearchDBGridList[I];
            if Obj.CanSearch then
              Obj.ProcKeyDown(Obj, AKey, ShiftState);

            if Obj.IsOnActiveForm and (AKey <> 0) and (Assigned(Obj.FOnKeyDown)) then
            begin
              Obj.FOnKeyDown(Obj, AKey, ShiftState);
              if AKey = 0 then Exit;
            end;

          end;
        end;

      CBMSG_KEYPRESS:
        begin
          AChar := Chr(Msg.wParam);
          for I := 0 to SearchDBGridList.Count - 1 do
          begin
            Obj := SearchDBGridList[I];
            if Obj.CanSearch then
              Obj.ProcKeyPress(Obj, AChar);

            if Obj.IsOnActiveForm and (Ord(AChar) <> 0) and Assigned(Obj.FOnKeyPress) then
            begin
              Obj.FOnKeyPress(Obj, AChar);
              if Ord(AChar) = 0 then Exit;
            end;

          end;
        end;
    end;
  finally
    Result := CallNextHookEx(Hook, Code, Flag, PData);
  end;
end;

{ TSearchDBGrid }

function TSearchDBGrid.CanSearch: Boolean;
var
  Grid: TDBGrid;
  DataSet: TDataSet;
begin
  Result := False;
  if (not FCanFastSearch) or (not IsOnActiveForm) then Exit;
  if not (TForm(Owner).ActiveControl is TDBGrid) then Exit;
  Grid := TDBGrid(TForm(Owner).ActiveControl);
  if Grid.SelectedField = nil then Exit;
  DataSet := Grid.DataSource.DataSet;  
  if not Assigned(DataSet) or not DataSet.Active then Exit;
  Result := True;
end;

constructor TSearchDBGrid.Create(AOwner: TComponent);
begin
  inherited;

  FTimer := TTimer.Create(Self);
  FTimer.Enabled := False;
  FTimer.OnTimer := ProcOnTimer;

  FTimer.Interval := 2000;
  // Если владелец не форма, то отменяем создание
  if not (AOwner is TForm) then
    raise Exception.Create('Владелец компонента TSearchDBGrid должен быть формой');

  FDBGridList := TList.Create;
  FDBGridListOptions := TList.Create;

  SearchDBGridList.Add(Self);

  FCanFastSearch := True;   
end;

destructor TSearchDBGrid.Destroy;
begin
  FDBGridList.Free;
  FDBGridListOptions.Free;
  SearchDBGridList.Remove(Self);
  inherited;
end;

function TSearchDBGrid.IsAssignedShortCut(AShortCut: TShortCut): Boolean;
begin
  Result := ((FShortCut <> 0) and (FShortCut = AShortCut)) or
            ((FShortCut <> 0) and (FAltShortCut = AShortCut));
end;

function TSearchDBGrid.IsOnActiveForm: Boolean;
begin
  Result := TForm(Owner) = Screen.ActiveForm;
end;

function TSearchDBGrid.LocateRecByText(Txt: string): Boolean;
var
  DataSet: TDataSet;
  FieldName: string;
begin
  
  Result := False;

  if CanSearch then
  begin
    DataSet := TDBGrid(TForm(Owner).ActiveControl).DataSource.DataSet;
    FieldName := TDBGrid(TForm(Owner).ActiveControl).SelectedField.FieldName;
    try
      Result := DataSet.Locate(FieldName, Txt, [loCaseInsensitive, loPartialKey]);
      
      // Если тип поля не строковый, то скорее всего сразу выполнить поиск
      // не получится, поэтому все-же вернем True
      if TDBGrid(TForm(Owner).ActiveControl).SelectedField.DataType <> ftString then
        Result := True;
    except    
    end;
  end;
end;

procedure TSearchDBGrid.ProcKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin 
  // Если в режиме поиска была нажата клавиша VK_BACK, то стираем последний символ
  if (Key = VK_BACK) and IsSearchMode and (FSearchText <> '') then
  begin
    // Удаляем последний символ
    Delete(FSearchText, Length(FSearchText), 1);
    LocateRecByText(FSearchText);
    if Assigned(FOnSearchUpdate) then FOnSearchUpdate(Self, True, FSearchText);
    // Сбрасываем таймер
    FTimer.Enabled := False;
    FTimer.Enabled := True;    
    Key := 0;
  end;

  // Если нажали ESCAPE, то в первый раз очищаем строку поиска, а второй -
  // выходим из режима поиска
  if (Key = VK_ESCAPE) and IsSearchMode then
  begin
    if FSearchText <> '' then
    begin
      FSearchText := '';
      LocateRecByText(FSearchText);
      if Assigned(FOnSearchUpdate) then FOnSearchUpdate(Self, True, FSearchText);
    end else
      IsSearchMode := False;

    Key := 0;
  end;

  // Если в режиме поиска нажали Enter, то завершаем поиск
  if (Key = VK_RETURN) and IsSearchMode then
  begin
    IsSearchMode := False;   
    Key := 0;
  end;

  // Здесь регистрируется только факт начала поиска и завершения поиска
  if (Key <> 0) and IsAssignedShortCut(Menus.ShortCut(Key, Shift)) then
  begin
    IsSearchMode := not IsSearchMode;
    Key := 0;
  end;         
end;

procedure TSearchDBGrid.ProcKeyPress(Sender: TObject; var Key: Char);
begin
  // Регистрирует только клавиши, код которых не меньше кода пробела
  if Ord(Key) < VK_SPACE then Exit;    

  if IsSearchMode then
  begin
    if LocateRecByText(FSearchText + Key) then
      FSearchText := FSearchText + Key;

    // Сбрасываем таймер
    FTimer.Enabled := False;
    FTimer.Enabled := True;
    
    if Assigned(FOnSearchUpdate) then FOnSearchUpdate(Self, True, FSearchText);
    Key := Chr(0);
  end;
end;

// Устанавливает или сбрасывает режим поиска
procedure TSearchDBGrid.ProcOnTimer(Sender: TObject);
begin
  FSearchText := '';
  if Assigned(FOnSearchUpdate) then FOnSearchUpdate(Self, True, FSearchText);
  FTimer.Enabled := False;
end;

procedure TSearchDBGrid.SetAltShortCut(const Value: TShortCut);
begin
  FAltShortCut := Value;
end;

procedure TSearchDBGrid.SetIsSearchMode(const Value: Boolean);
var
  I: Integer;
  sp: TSmallPoint;
begin
  if Value then
  begin
    // Мы не может перейти в режим поиска, если активный компонент - не сетка
    if not CanSearch then Exit;
    // Запоминаем все сетки DBGrid, находящиеся на форме
    FDBGridList.Clear;
    FDBGridListOptions.Clear;
    for I := 0 to TForm(Owner).ComponentCount - 1 do
      if TForm(Owner).Components[I] is TDBGrid then
      begin
        FDBGridList.Add(TForm(Owner).Components[I]);
        with TDBGrid(FDBGridList[FDBGridList.Count - 1]) do
        begin
          // Запоминаем настройки
          sp.x := SmallInt(ReadOnly);
          sp.y := SmallInt(dgEditing in Options);
          if Assigned(DataSource) then
            if Assigned(DataSource.DataSet) and
              (DataSource.DataSet.State in [dsEdit, dsInsert])
            then
              DataSource.DataSet.Cancel;
              
          FDBGridListOptions.Add(Pointer(sp));
          // Меняем настройки
          ReadOnly := True;
          Options := Options - [dgEditing];
          Repaint;

        end;
      end; // of if
  end else
  begin
    // Восстанавливаем настройки сеток
    for I := 0 to FDBGridList.Count - 1 do
    begin
      sp := TSmallPoint(FDBGridListOptions[I]);
      with TDBGrid(FDBGridList[I]) do
      begin
        ReadOnly := Boolean(sp.x);
        if Boolean(sp.y) then Options := Options + [dgEditing];
        Repaint;
      end;
    end;
    // Очищаем ненужные списки
    FDBGridList.Clear;
    FDBGridListOptions.Clear;
    FTimer.Enabled := False;
  end;
  
  FIsSearchMode := Value;
  FSearchText := '';
  if Assigned(FOnSearchUpdate) then FOnSearchUpdate(Self, Value, FSearchText);
end;

procedure TSearchDBGrid.SetOnKeyDown(const Value: TKeyEvent);
begin
  FOnKeyDown := Value;
end;

procedure TSearchDBGrid.SetOnKeyPress(const Value: TKeyPressEvent);
begin
  FOnKeyPress := Value;
end;

procedure TSearchDBGrid.SetShortCut(const Value: TShortCut);
begin
  FShortCut := Value;
end;

initialization
  Hook := SetWindowsHookEx(WH_CALLWNDPROC, CallBackWndProc, 0, GetCurrentThreadId);
  SearchDBGridList := TList.Create;

finalization
  UnhookWindowsHookEx(Hook);
  SearchDBGridList.Free;
end.
 