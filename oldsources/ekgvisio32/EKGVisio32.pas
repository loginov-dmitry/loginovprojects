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

unit EKGVisio32;

interface

uses
  Windows, Messages, Classes, Dialogs, Graphics, Matrix32, ExtCtrls,
  StdCtrls, Forms, Controls, SysUtils, Math, matrixProcessSignal;

type
  TGraphicLine = class; // Предварительное объявление класса

  TGraphicLineTypes = (gtVertical, gtHorizontal, gtMoveAble, gtSynchronize);
  {gtVertical - вертикальная линия
   gtHorizontal - горизонтальная линия
   gtMoveAble - линию можно перемещать с помощью мышки
   gtSynchronize - линия привязана к сетке}

  TGraphicLineSet = set of TGraphicLineTypes;

  TChangePositionProc = procedure(Sender: TGraphicLine) of Object;

  TMouseDownEKGRect = procedure(ARow: Integer) of Object;

  PSegmentLine = ^TSegmentLine;
  TSegmentLine = record
    segName: string;        // Наименование сегмента
    segX1, segX2: Integer;  // Границы сегмента
    segColor: TColor;       // Цвет сегмента
    segPenStyle: TPenStyle; // Стиль линии
    segSize: Integer;       // Ширина линии
    segCurveNum: Integer;   // Отведение, для которого линия рисуется (-1 - значит для каждого отведения)
    segDrawLine: Boolean;   // Рисовать прямую линию, либо обводить контуры ЭКГ
  end;

  TCanvasParams = record
    prPenColor: TColor;
    prPenStyle: TPenStyle;
    prPenSize: Integer;

    prBrushColor: TColor;
    prBrushStyle: TBrushStyle;
  end;

  // Закрашенный сегмент, ограниченный прямой линией с одной стороны и кривой ЭКГ с другой
  PColorAreaSegment = ^TColorAreaSegment;
  TColorAreaSegment = record
    segName: string;
    segX1: Integer; // Номер отсчета ЭКГ
    segY1: Integer;
    segX2: Integer; // Номер отсчета ЭКГ
    segY2: Integer;
    segPenTopColor: TColor; // Цвет заливки сверху
    segPenBottomColor: TColor; // Цвет заливки снизу
    segPenStyle: TPenStyle; // Стиль заливки
    segCurveNum: Integer; // Отведение, для которого линия рисуется (-1 - значит для каждого отведения)
  end;

  PEKGRect = ^TEKGRect;
  TEKGRect = record
    rRow: Integer;
    rRect: TRect;
  end;

  TColorArray = array of TColor;

  TMyScrollBar = class(TScrollBar)
  private
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  end;

  TEKGArea = class(TPanel)
  private
    FWorkspace: TWorkspace;
    FCaption: String;
    FGridColor: TColor;
    FGridVisible: Boolean;
    FAutoChange: Boolean;
    FPeaksVisible: Boolean;
    FStepVisible: Boolean;
    FInterval: Integer;
    Fmm_on_sec: Integer;
    Fmm_on_mV: Integer;
    FFrequency: Integer;
    FSensitivity: Integer;
    FPeaksColor: TColor;
    FStepColor: TColor;
    FMonoColor: TColor;
    FTakeDownColor: TColor;
    FSignFont: TFont;
    FMessageFont: TFont;
    FListOfNames: TStringList;
    FEKGIsOnScreen: Boolean;
    FMessageText: TStringList;
    FEKGColor: TColor;
    FEKGColor2: TColor;
    FOnDrawEKG: TNotifyEvent;
    FSegmentLineList: TStringList;
    FColorAreaSegmentList: TStringList;
    FCanvasParams: TCanvasParams;
    FEKGRectList: TList;
    procedure SetCaption(const Value: String);
    procedure SetGridColor(const Value: TColor);
    procedure SetGridVisible(const Value: Boolean);
    procedure SetAutoChange(const Value: Boolean);
    procedure SetFrequency(const Value: Integer);
    procedure SetInterval(const Value: Integer);
    procedure Setmm_on_mV(const Value: Integer);
    procedure Setmm_on_sec(const Value: Integer);
    procedure SetMonoColor(const Value: TColor);
    procedure SetPeaksColor(const Value: TColor);
    procedure SetPeaksVisible(const Value: Boolean);
    procedure SetSensitivity(const Value: Integer);
    procedure SetStepColor(const Value: TColor);
    procedure SetStepVisible(const Value: Boolean);
    procedure SetTakeDownColor(const Value: TColor);
    procedure SetListOfNames(const Value: TStringList);
    procedure SetMessageFont(const Value: TFont);
    procedure SetSignFont(const Value: TFont);
    procedure SetMessageText(const Value: TStringList);
    procedure SetEKGColor(const Value: TColor);
    procedure SetEKGColor2(const Value: TColor);

  private
    PaintBox: TPaintBox;
    {Панель, на которой находится холст}
    ImPanel: TPanel;
    {Вектикальная полоса прокрутки}
    VertScrollBar: TMyScrollBar;
    {Горизонтальная полоса прокрутки}
    HorScrollBar: TMyScrollBar;
    {Здесь хранится изображение миллиметровки}
    GridBitmap: TBitmap;
    {Буфер, непосредственно в котором и выполняется рисование}
    ImageBuffer: TBitmap;
    {Буфер для вертикальной линии}
    VertLineBitmap: TBitmap;
    {Буфер для горизонтальной линии}
    HorLineBitmap: TBitmap;
    {Используется при печати}
    IsMonoColors: Boolean;

    {Цвета, которыми раскрашиваются дополнительные кривые ЭКГ}
    Colors2: TColorArray;

    CanRepaint: Boolean;

    IsUpdate: Boolean;

    FMouseDownEKGRect: TMouseDownEKGRect;
    {Заполняет все параметры по умолчанию}
    procedure CreateDefaultParameters();
    {Определяет, сколько отсчетов необходимо скопировать из исходного массива}
    function CalcPointCount(): Integer;
    {Определяет, сколько пикселей отведено для отрисовки ЭКГ}
    function GetEKGAreaWidth(): Integer;
    {Расчитывает параметры ползунков в зависимости от текущих размеров области
     вывода и от других параметров}
    procedure SetScrollBarParams();
    {Включает режим обновления. В этом режиме перерисовка не выполняется}
    procedure BeginUpdate;
    {Выключает режим обновления}
    procedure EndUpdate;

    procedure DoDrawEKG();

    {Обработчик перемещения ползунка}
    procedure ScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    {Обработчик изменения размеров}
    procedure PanelResize(Sender: TObject);
    {Перерисовка картинки}
    procedure PaintBoxPaint(Sender: TObject);
    {Обработка щелчка мыши в области миллиметровки. Устанавливает фокус на
     горизонтальной полосе прокрутки}
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    {Обработка нажатия на клавиши клавиатуры. При нажатии стрелок установится
     фокус на соответствующей полосе прокрутки}
    procedure ScrollBarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure ClearSegmentLines();

    procedure ClearColorAreaSegment();

    procedure ClearEKGRectList();

    {Сохраняет параметры карандаша}
    procedure SaveCanvasParams(ACanvas: TCanvas);

    {Восстанавливает параметры карандаша}
    procedure RestoreCanvasParams(ACanvas: TCanvas);

    procedure DrawColorAreaSegments(SourEKG: TMatrix; ARow, h: Integer);

    procedure DrawSegmentLines(SourEKG: TMatrix; ARow, h: Integer);

    {Рисует основные кривые ЭКГ}
    procedure DrawEKGCurves(SourEKG: TMatrix; ARow, h: Integer);

    {Регистрируем прямоугольник с изображением ЭКГ в списке}
    procedure RegisterEKGRect(SourEKG: TMatrix; ARow, h: Integer);

    {Рисует дополнительные кривые ЭКГ (используются для сравнения с исходными)}
    procedure DrawAdditionalCurves(SourEKG: TMatrix; ARow, h: Integer);

    {Рисует названия кривых ЭКГ}
    procedure DrawCurveNames(ARow, h: Integer);

    {Рисует ступеньку}
    procedure DrawStep(h: Integer);

  protected
    procedure WndProc(var Message: TMessage); override;    
  public
    {Список графических линий}
    GraphicLines: TList;

    FBlackPoint: Windows.TPoint;

    {Цвета, которыми раскрашиваются соответствующие кривые ЭКГ}
    Colors: TColorArray;

    {Номер выбранной кривой. Она должна отрисовываться двойной линией. Если
     SelectedCurveNumber < 0, то это означает, никакие кривые выделяться не должны}
    SelectedCurveNumber: Integer;
    
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    {Возвращает ссылку на рабочую область}
    property Workspace: TWorkspace read FWorkspace;

    {Загружает сигналы ЭКГ. Если ByRef = True, то передача
     массива ЭКГ происходит по ссылке, а иначе - копированием}
    procedure LoadSignals(EKGArray: TMatrix;
      PeaksArray: TMatrix = nil; ByRef: Boolean = True);

    {Загружает дополнительные сигналы ЭКГ. Эти сигналы будут накладываться на
     сигналы, которые были загружены функцией LoadSignals}
    procedure LoadSignals2(EKGArray: TMatrix; ByRef: Boolean = True);

    {Устанавливает цвета для соответствующих кривых ЭКГ. Если для каких-либо
     отведений цвета не указаны, то используется цвет EKGColor}
    procedure SetColors(AColors: array of TColor);

    procedure SetColors2(AColors: array of TColor);

    {Выводит на миллиметровку текстовое сообщение. Это может быть сообщение
     об ошибке, приветствие, описание и любая другая информация}
    procedure DrawTextMessage(AText: String; ClearWorkspace: Boolean = True);

    {Рисует загруженную ЭКГ на миллиметровке. Если ЭКГ не загружена, то
     выводит сообщение об ошибке (в виде рисунка)}
    procedure DrawEKG();

    {Определяет, нарисованы ли сигналы ЭКГ на миллиметровке}
    property EKGIsOnScreen: Boolean read FEKGIsOnScreen;

    {Создает новую графическую линию}
    function NewGraphicLine(AModes: TGraphicLineSet; StartPosition: Integer;
      AttachNum: Integer = 0; DrawNow: Boolean = False): TGraphicLine;

    {Удаляет указанную графическую линию. Если указано nil, то удаляются все линии}
    procedure DeleteGraphicLine(GraphicLine: TGraphicLine = nil);

    {Удаляет ссылку на графическую линию из списка}
    procedure UnRegisterGraphicLine(GraphicLine: TGraphicLine);

    {Перерисовывает графические линии (в случае проблем с перерисовкой)}
    procedure RepaintGraphicLines;

    {Изменяет размер графических линий}
    procedure ResizeGraphicLines;

    {Устанавливает позицию линий в соответствии с положением миллиметровки}
    procedure PosGraphicLines;
    
    {По координате Х определяет положение отсчета в массиве SourEKG}
    function GetEKGPos(PixelX: Integer): Integer;

    {По положению отсчета в массиве SourEKG определяет координату Х}
    function GetPixelCoord(EKGPos: Integer): Integer;

    {Копирует данные из другого аналогичного объекта}
    procedure AssignFrom(Source: TEKGArea);

    {Рисует миллиметровку в буфер GridBitmap}
    procedure DrawGrid(AllCanvas: Boolean = True);

    function GetImageBuffer: TBitmap;

    function GetPaintBox: TPaintBox;

    function GetVertScrollBar: TScrollBar;

    function GetHorScrollBar: TScrollBar;

    function GetImPanel: TPanel;

    property OnDrawEKG: TNotifyEvent read FOnDrawEKG write FOnDrawEKG;

    property OnMouseDownEKGRect: TMouseDownEKGRect read FMouseDownEKGRect write FMouseDownEKGRect;

    {Добавляем сегментную линию.}
    procedure AddSegmentLine(AName: string; X1, X2: Integer; AColor: TColor;
      APenStyle: TPenStyle; ASize: Integer; ACurveNum: Integer; DrawLine: Boolean);

    procedure AddColorAreaSegment(AName: string; X1, Y1, X2, Y2: Integer;
      TopColor, BottomColor: TColor; AStyle: TPenStyle; ACurveNum: Integer);

    {Удаляем сегментную линию.}
    procedure DeleteSegmentLine(AName: string);

  published
    {Название объекта. Используется при выдачи сообщений об ошибках}
    property Caption: String read FCaption write SetCaption;
    {Цвет линий ЭКГ}
    property EKGColor: TColor read FEKGColor write SetEKGColor;
    property EKGColor2: TColor read FEKGColor2 write SetEKGColor2;
    {Цвет миллиметровки}
    property GridColor: TColor read FGridColor write SetGridColor;
    {Определяет, следует ли рисовать миллиметровку}
    property GridVisible: Boolean read FGridVisible write SetGridVisible;
    {Цвет печати, если выбран режим монохромной печати}
    property MonoColor: TColor read FMonoColor write SetMonoColor;
    {Определяет, следует ли отображать калибровочный импульс}
    property StepVisible: Boolean read FStepVisible write SetStepVisible;
    {Цвет калибровочного импульса}
    property StepColor: TColor read FStepColor write SetStepColor;
    {Определяет, следует ли автоматически подсвечивать зубцы R}
    property PeaksVisible: Boolean read FPeaksVisible write SetPeaksVisible;
    {Цвет линий, которыми автоматически подсвечиваются зубцы R}
    property PeaksColor: TColor read FPeaksColor write SetPeaksColor;
    {Цвет линий ЭКГ при снятии}
    property TakeDownColor: TColor read FTakeDownColor write SetTakeDownColor;
    {Расстояние между линиями сигналов ЭКГ в миллиметрах}
    property Interval: Integer read FInterval write SetInterval;
    {Частота снятия сигналов прибором}
    property Frequency: Integer read FFrequency write SetFrequency;
    {Чувствительность прибора (величина Y на 1 милливольт)}
    property Sensitivity: Integer read FSensitivity write SetSensitivity;
    {Число миллиметров на 1 милливольт при рисовании}
    property mm_on_mV: Integer read Fmm_on_mV write Setmm_on_mV;
    {Число миллиметров в секунду при рисовании}
    property mm_on_sec: Integer read Fmm_on_sec write Setmm_on_sec;
    {Определяет, следует ли применять изменения автоматически}
    property AutoChange: Boolean read FAutoChange write SetAutoChange;
    {Список подписей линий ЭКГ}
    property ListOfNames: TStringList read FListOfNames write SetListOfNames;
    {Текст, отображаемый на миллиметровке при отсутствии сигналов ЭКГ}
    property MessageText: TStringList read FMessageText write SetMessageText;
    {Шрифт выводимого на миллиметровку сообщения}
    property MessageFont: TFont read FMessageFont write SetMessageFont;
    {Шрифт подписей для отведений и заголовков для печати}
    property SignFont: TFont read FSignFont write SetSignFont;
  end;


  TGraphicLine = class(TPaintBox)
  private
    OldCoord: Integer;
    FChangePositionProc: TChangePositionProc;
    FIsSetPosition: Boolean;
    Modes: TGraphicLineSet;
    Bitmap: TBitmap;

    {Определяет номер отведения, с которым установлена привязка. Актуально
     только для горизонтальных линий}
    Attach: Integer;
    AttachedHorLines: TList;
    EKGArea: TEKGArea;
    
    FPosition: Integer;
    FPenStyle: TPenStyle;
    FRightLine: TGraphicLine;
    FLeftLine: TGraphicLine;
    FTopLine: TGraphicLine;
    FBottomLine: TGraphicLine;
    FAttachedVertLine: TGraphicLine;

    procedure SetPosition(const Value: Integer);
    procedure SetPenStyle(const Value: TPenStyle);

    {Устанавливает реальное положение линии на экране. Не приводит к вызову ChangePositionProc}
    procedure SetActualPosition;

    {Используется для горизонтальный линий. Переводит значение амплитуды в
     координаты экрана}
    function AmplitudeToScreen(Ampl: Integer): Integer;
    function ScreenToAmplitude(CoordY: Integer): Integer;
    procedure MoveAttachedHorizontalLines;

    procedure SetLeftLine(const Value: TGraphicLine);
    procedure SetRightLine(const Value: TGraphicLine);
    procedure SetBottomLine(const Value: TGraphicLine);
    procedure SetTopLine(const Value: TGraphicLine);
    procedure SetAttachedVertLine(const Value: TGraphicLine);

    { Запрящаем разработчику доступ к следующим свойствам }
    property Height;
    property Width;
    
  protected
    procedure GraphicLineMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure GraphicLineMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GraphicLineMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WndProc(var Message: TMessage); override;   
  public
    destructor Destroy; override;
    
    {==== Вы можете использовать только указанные ниже свойства и методы ====}

    {Выполняет перерисовку линии}
    procedure Draw;
    {Устанавливает CallBack-функцию, вызываемую при перемещении линии. В данном
     обработчики менять свойство Position бесполезно!}
    property ChangePositionProc: TChangePositionProc read FChangePositionProc write FChangePositionProc;
    {Устанавливает позицию. Зависит от режима Modes}
    property Position: Integer read FPosition write SetPosition;
    {Определяет цвет линии}
    property Color;
    {Определяет стиль линии}
    property PenStyle: TPenStyle read FPenStyle write SetPenStyle;
    {Определяет текст подсказки}
    property Hint;
    {Если ShowHint=True, то при наведении мышки появляется всплывающая подсказка}
    property ShowHint;
    {Левая ограничительная линия}
    property LeftLine: TGraphicLine read FLeftLine write SetLeftLine;
    {Правая ограничительная линия}
    property RightLine: TGraphicLine read FRightLine write SetRightLine;
    {Верхняя ограничительная линия}
    property TopLine: TGraphicLine read FTopLine write SetTopLine;
    {Нижняя ограничительная линия}
    property BottomLine: TGraphicLine read FBottomLine write SetBottomLine;
    {Используется для горизонтальных линий. Привязывает линию к указанной вертикальной.
     Далее при перетаскивании вертикальной линии данная линия будет перемещаться
     в соответствии с амплитудой текущего отсчета.}
    property AttachedVertLine: TGraphicLine read FAttachedVertLine write SetAttachedVertLine;
    {Определяет, привязана ли линия к сетке}
    function IsGridAttached: Boolean;
    {Возвращает ссылку на данный объект}
    function ThisLine: TGraphicLine;
  end;

resourcestring
  sCaption = 'Визуализация отведений электрокадриограммы';
  sSigNames = 'I'#13#10'II'#13#10'III'#13#10'aVR'#13#10'aVL'#13#10'aVF'#13#10 +
              'V1'#13#10'V2'#13#10'V3'#13#10'V4'#13#10'V5'#13#10'V6';
  sNoSignals = 'Сигналы ЭКГ не обнаружены!';
  sCopyright = 'EKGVisio 2006-2009 (c) Логинов Д.С.'#13#10 +
               'Сайт: http://matrix.kladovka.net.ru'#13#10 +
               'E-mail: loginov_d@inbox.ru';

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('loginOFF', [TEKGArea]);
end;

{ TEKGArea }

constructor TEKGArea.Create(AOwner: TComponent);
begin
  inherited;

  CreateDefaultParameters();
  
  ImPanel := TPanel.Create(nil);
  with ImPanel do
  begin
    BevelOuter := bvNone;
    Parent := Self;    
  end;  
  
  // Размещаем на панели холст TPaintBox
  PaintBox := TPaintBox.Create(nil);
  with PaintBox do
  begin
    OnPaint := PaintBoxPaint;
    OnMouseDown := PaintBoxMouseDown;
    Top := 1;
    Parent := ImPanel;
  end;

  // Размещаем вертикальную полосу прокрутки
  VertScrollBar := TMyScrollBar.Create(nil);
  with VertScrollBar do
  begin
    Min := 1;
    SmallChange := 4;
    LargeChange := 20;
    Kind := sbVertical;
    OnScroll := ScrollBarScroll;
    OnKeyDown := ScrollBarKeyDown;
    Parent := Self;
  end;

  // Размещаем горизонтальную полосу прокрутки
  HorScrollBar := TMyScrollBar.Create(nil);
  with HorScrollBar do
  begin
    Min := 1;
    SmallChange := 4;
    LargeChange := 16;
    OnScroll := ScrollBarScroll;
    OnKeyDown := ScrollBarKeyDown;
    Parent := Self;
  end;

  OnResize := PanelResize;
  Resize;
end;

procedure TEKGArea.PanelResize(Sender: TObject);
begin
  try
    with ImPanel do
    begin
      Left := 3;
      Top := 3;
      Width := Self.Width - 24;
      Height := Self.Height - 24;
    end;

    with PaintBox do
    begin
      Left := 1;
      Width := Parent.Width - 2;
      Height := Parent.Height - 2;
    end;
  
    with VertScrollBar do
    begin
      Left := Self.Width - 20;
      Top := 3;
      Width := 17;
      Height := Self.Height - 23;
    end;

    with HorScrollBar do
    begin
      Left := 3;
      Top := Self.Height - 20;
      Width := Self.Width - 23;
      Height := 17;
    end;

    VertLineBitmap.Width := 5;
    VertLineBitmap.Height := ImPanel.Height;

    HorLineBitmap.Width := ImPanel.Width - 20;
    HorLineBitmap.Height := 5;

    ImageBuffer.Width := ImPanel.Width;
    ImageBuffer.Height := ImPanel.Height;
    DrawGrid();
    ResizeGraphicLines;

    if EKGIsOnScreen then
      DoDrawEKG
    else
      DrawTextMessage(MessageText.Text);

    SetScrollBarParams;

  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.PanelResize');
  end;
end;

procedure TEKGArea.CreateDefaultParameters;
begin
  FWorkspace := TWorkspace.Create;
  Caption := sCaption;

  FGridColor := $50A0FF;
  FGridVisible := True;
  FMonoColor := clBlack;
  FStepVisible := True;
  FStepColor := clBlack;
  FPeaksVisible := False;
  FPeaksColor := clBlack;
  FTakeDownColor := clBlack;
  FInterval := 15;
  FFrequency := 1000;
  FSensitivity := 10000;
  Fmm_on_mV := 10;
  Fmm_on_sec := 50;
  FAutoChange := False;
  FListOfNames := TStringList.Create;
  FListOfNames.Text := sSigNames;
  FMessageText := TStringList.Create;
  MessageText.Text := sCopyright;
  FMessageFont := TFont.Create;
  FSignFont := TFont.Create;
  GridBitmap := TBitmap.Create;
  ImageBuffer := TBitmap.Create;
  GridBitmap.PixelFormat := pf32bit;
  GraphicLines := TList.Create;

  VertLineBitmap := TBitmap.Create;
  HorLineBitmap := TBitmap.Create;

  FSegmentLineList := TStringList.Create;
  FColorAreaSegmentList := TStringList.Create;

  FEKGRectList := TList.Create;

  SelectedCurveNumber := -1;
end;

destructor TEKGArea.Destroy;
begin
  PaintBox.Free;
  HorScrollBar.Free;
  VertScrollBar.Free;
  Workspace.Free;
  ListOfNames.Free;
  MessageFont.Free;
  FMessageText.Free;
  SignFont.Free;
  GridBitmap.Free;
  ImageBuffer.Free;
  DeleteGraphicLine;
  GraphicLines.Free;
  VertLineBitmap.Free;
  HorLineBitmap.Free;
  ClearSegmentLines();
  FSegmentLineList.Free;
  ClearColorAreaSegment();
  FColorAreaSegmentList.Free;
  ClearEKGRectList();
  FEKGRectList.Free;
  inherited;
end;

procedure TEKGArea.SetAutoChange(const Value: Boolean);
begin
  FAutoChange := Value;
end;

procedure TEKGArea.SetCaption(const Value: String);
begin
  FCaption := Value;
  Workspace.MatrixName := Caption;
end;

procedure TEKGArea.SetFrequency(const Value: Integer);
begin
  FFrequency := Value;
end;

procedure TEKGArea.SetGridColor(const Value: TColor);
begin
  FGridColor := Value;
end;

procedure TEKGArea.SetGridVisible(const Value: Boolean);
begin
  FGridVisible := Value;
end;

procedure TEKGArea.SetInterval(const Value: Integer);
begin
  FInterval := Value;
end;

procedure TEKGArea.SetListOfNames(const Value: TStringList);
begin
  FListOfNames.Assign(Value)
end;

procedure TEKGArea.SetMessageFont(const Value: TFont);
begin
  FMessageFont.Assign(Value)
end;

procedure TEKGArea.Setmm_on_mV(const Value: Integer);
begin
  Fmm_on_mV := Value;
end;

procedure TEKGArea.Setmm_on_sec(const Value: Integer);
begin
  Fmm_on_sec := Value;
end;

procedure TEKGArea.SetMonoColor(const Value: TColor);
begin
  FMonoColor := Value;
end;

procedure TEKGArea.SetPeaksColor(const Value: TColor);
begin
  FPeaksColor := Value;
end;

procedure TEKGArea.SetPeaksVisible(const Value: Boolean);
begin
  FPeaksVisible := Value;
end;

procedure TEKGArea.SetSensitivity(const Value: Integer);
begin
  FSensitivity := Value;
end;

procedure TEKGArea.SetSignFont(const Value: TFont);
begin
  FSignFont.Assign(Value);
end;

procedure TEKGArea.SetStepColor(const Value: TColor);
begin
  FStepColor := Value;
end;

procedure TEKGArea.SetStepVisible(const Value: Boolean);
begin
  FStepVisible := Value;
end;

procedure TEKGArea.SetTakeDownColor(const Value: TColor);
begin
  FTakeDownColor := Value;
end;

function SwapColor(Color: TColor): TColor;
var
  ByteAr: PByteArray;
  B: Byte;
begin
  Result := Color;
  ByteAr := @Result;
  B := ByteAr[0];
  ByteAr[0] := ByteAr[2];
  ByteAr[2] := B;
end;

procedure TEKGArea.DrawGrid(AllCanvas: Boolean);
var
  I, J: Integer;
  FixedColor: Integer;
  P: PIntegerArray;
begin
  try
    GridBitmap.Width := ImPanel.Width + 50;
    GridBitmap.Height := ImPanel.Height + 50;

    if not GridVisible then
    begin
      GridBitmap.Canvas.Rectangle(0, 0, GridBitmap.Width, GridBitmap.Height);
      Exit;
    end;

    if IsMonoColors then
      FixedColor := SwapColor(MonoColor)
    else
      FixedColor := SwapColor(FGridColor);

    for I := 0 to GridBitmap.Height - 1 do
    begin
      P := GridBitmap.ScanLine[I];
      for J := 0 to GridBitmap.Width - 1 do
      begin
        if ((I mod 4 = 0) and (J mod 4 = 0)) or ((J mod 20 = 0) and (I mod 2 = 0)) or
          ((I mod 20 = 0) and (J mod 2 = 0)) then
          P[J] := FixedColor;
      end;
    end;

    // Обрезаем при необходимости все лишнее:
    if not AllCanvas then
    begin
      with GridBitmap.Canvas do
      begin
        Pen.Color := clWhite;
        Brush.Color := clWhite;
        Rectangle(0, 0, Width, 20);
        Rectangle(0, Height - 20, Width, Height);
      end;
    end;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.DrawGrid');
  end;
end;

procedure TEKGArea.LoadSignals(EKGArray: TMatrix;
  PeaksArray: TMatrix; ByRef: Boolean);
begin
  try
    SelectedCurveNumber := -1; // Сбрасываем номер выбранной кривой

    if not EKGArray.IsLiving then
      DrawTextMessage(sNoSignals)
    else
      with Workspace do
      begin
        // Очищаем все массивы рабочей области
        Clear;

        if ByRef then
          EKGArray.CreateReference(Workspace, 'SourEKG')
        else
          EKGArray.CreateCopy(Workspace, 'SourEKG');

        if PeaksArray.IsLiving then
          PeaksArray.CreateCopy(Workspace, 'Peaks');

        SetScrollBarParams;
        HorScrollBar.Position := 1;
        VertScrollBar.Position := 1;
      end;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.LoadSignals');
  end;
end;

procedure TEKGArea.LoadSignals2(EKGArray: TMatrix; ByRef: Boolean = True);
begin
  try
    if EKGArray.IsLiving then
    begin
      with Workspace do
      begin
        if ByRef then
          EKGArray.CreateReference(Workspace, 'SourEKG2')
        else
          EKGArray.CreateCopy(Workspace, 'SourEKG2');
      end;
    end;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.LoadSignals2');
  end;
end;

procedure TEKGArea.DrawTextMessage(AText: String; ClearWorkspace: Boolean);
var
  I: Integer;
begin
  try
    MessageText.Text := AText;

    DrawGrid();
    ImageBuffer.Canvas.Draw(0, 0, GridBitmap);

    ImageBuffer.Canvas.Font.Assign(MessageFont);

    for I := 0 to MessageText.Count - 1 do
      ImageBuffer.Canvas.TextOut(10, Round(10 + I * ImageBuffer.Canvas.TextHeight('A')), MessageText[I]);

    if ClearWorkspace then Workspace.Clear;

    FEKGIsOnScreen := False;

    HorScrollBar.Enabled := False;
    VertScrollBar.Enabled := False;
    
    if CanRepaint then
      PaintBoxPaint(nil);
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.DrawTextMessage');
  end;
end;

procedure TEKGArea.SetMessageText(const Value: TStringList);
begin
  FMessageText.Assign(Value);
end;

function TEKGArea.CalcPointCount: Integer;
begin
  Result := Trunc((GetEKGAreaWidth * Frequency) / (mm_on_sec * 4));
end;

function TEKGArea.GetEKGAreaWidth: Integer;
begin
  Result := ImPanel.Width - 20;
end;

procedure TEKGArea.DoDrawEKG;
var
  I, h, FirstPoint, GridOffsetX, GridOffsetY: Integer;
  AMatrix, EKGPart, SourEKG2, EKGPart2: TMatrix;
  ImageH: Integer;   
begin     
  try
    FEKGIsOnScreen := False;
    with Workspace do
    begin
      AMatrix := FindMatrix('SourEKG');
      if AMatrix = nil then
      begin
        DrawTextMessage(sNoSignals);
        Exit;
      end;

      ClearEKGRectList;

      SourEKG2 := FindMatrix('SourEKG2');

      FirstPoint := HorScrollBar.Position;
      if AMatrix.Cols - FirstPoint < CalcPointCount then
        FirstPoint := Max(AMatrix.Cols - CalcPointCount, 0);

      GridOffsetX := Trunc(FirstPoint/(Frequency/mm_on_sec/4)) mod 40;
      GridOffsetY := VertScrollBar.Position mod 40;

      EKGPart := TSingleMatrix.Create(); // Точности для визуализации вполне хватит!

      try
        EKGPart2 := TSingleMatrix.Create(EKGPart);

        // Координата h, которая будет у самого первого отведения
        h := mm_on_mV * 4 + 20 - VertScrollBar.Position;
        ImageH := ImageBuffer.Height;

        // Копируем часть ЭКГ
        EKGPart.CopyArrayPart(AMatrix, [0, FirstPoint],
          [-1, Min(CalcPointCount, AMatrix.Cols)]);

        // Сжимаем сигналы (это самое слабое место в процедуре)
        StretchRows(EKGPart, EKGPart, Trunc(EKGPart.Cols/(Frequency/mm_on_sec/4)));

        // Выполняем пересчет амплитуды
        for I := 0 to EKGPart.ElemCount - 1 do
          EKGPart.VecElem[I] := -EKGPart.VecElem[I] * 4 * mm_on_mV / Sensitivity;

        if SourEKG2.IsLiving then
        begin
          if SourEKG2.Cols < FirstPoint then
          begin
            EKGPart2.FreeMatrix;
            EKGPart2 := nil;
          end else
          begin
            // Копируем часть ЭКГ
            EKGPart2.CopyArrayPart(SourEKG2, [0, FirstPoint],
              [-1, Min(CalcPointCount, SourEKG2.Cols)]);

            // Сжимаем сигналы (это самое слабое место в процедуре)
            StretchRows(EKGPart2, EKGPart2, Trunc(EKGPart2.Cols/(Frequency/mm_on_sec/4)));

            // Выполняем пересчет амплитуды
            for I := 0 to EKGPart2.ElemCount - 1 do
              EKGPart2.VecElem[I] := -EKGPart2.VecElem[I] * 4 * mm_on_mV / Sensitivity;
          end;
        end;

        {Копируем миллиметровку с учетом смещения}
        ImageBuffer.Canvas.Draw(-GridOffsetX, -GridOffsetY, GridBitmap);

        {Рисуем линии в промежуточном буфере}
        for I := 0 to EKGPart.Rows - 1 do
        begin
          // Выполняем отрисовку только если сигнал не скрыт за границами экрана
          if (h + Fmm_on_mV * 20 >= 0) and (h - Fmm_on_mV * 20 <= ImageH) then
          begin
            // Рисуем закрашенные области
            DrawColorAreaSegments(AMatrix, I, h);

            // Рисование калибровочного импульса
            DrawStep(h);
                       
            // Рисуем основные кривые ЭКГ
            DrawEKGCurves(EKGPart, I, h);

            // Регистрируем координаты прямоугльника с ЭКГ
            RegisterEKGRect(EKGPart, I, h);

            // Рисуем сегментные линии
            DrawSegmentLines(AMatrix, I, h);

            // Выводим дополнительные кривые (используется для визуального сравнения с исходной ЭКГ)
            DrawAdditionalCurves(EKGPart2, I, h);

            // Выводим название кривой
            DrawCurveNames(I, h);
          end;
          h := h + FInterval * 4;
        end;

      finally
        EKGPart.Free;
      end;

    end; // of with

    FEKGIsOnScreen := True;
    
    BeginUpdate;
    try
      SetScrollBarParams;
      PosGraphicLines;
    finally
      EndUpdate;
    end;

    if CanRepaint then
      PaintBoxPaint(nil);
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.DoDrawEKG');
  end;
end;


procedure TEKGArea.SetEKGColor(const Value: TColor);
begin
  FEKGColor := Value;
end;

procedure TEKGArea.ScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  try
    DoDrawEKG;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.ScrollBarScroll');
  end;
end;

procedure TEKGArea.SetScrollBarParams;
begin
  with Workspace do
  begin
    if FindMatrix('SourEKG') <> nil then
    begin
      HorScrollBar.Max := Max((MatrixByName['SourEKG'].Cols - CalcPointCount), 1);
      VertScrollBar.Max := Max((MatrixByName['SourEKG'].Rows - 1) * Interval * 4 +
                                2 * (mm_on_mV * 4 + 20) - PaintBox.Height, 1);
      if EKGIsOnScreen then
      begin
        HorScrollBar.Enabled := True;
        VertScrollBar.Enabled := True;
      end;                         
    end else
    begin // Делаем недоступными ползунки, если ЭКГ не рисуется
      VertScrollBar.Enabled := False;
      HorScrollBar.Enabled := False;
    end;
  end;
end;

procedure TEKGArea.PaintBoxPaint(Sender: TObject);
begin
  try
    CanRepaint := True;

    if IsUpdate then
      Exit;

    PaintBox.Canvas.Draw(0, 0, ImageBuffer);

    if EKGIsOnScreen then
      RepaintGraphicLines;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.PaintBoxPaint');
  end;
end;

procedure TEKGArea.PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  P: PEKGRect;
begin

  if Assigned(OnMouseDownEKGRect) then
  begin
    for I := 0 to FEKGRectList.Count - 1 do
    begin
      P := PEKGRect(FEKGRectList[I]);
      if (X > P.rRect.Left) and (X < P.rRect.Right) and
         (Y > P.rRect.Top) and (Y < P.rRect.Bottom) then
      begin
        //MessageBox(GetActiveWindow, PChar('Отведение: ' + inttostr(P.rRow)), '', 0);
        OnMouseDownEKGRect(P.rRow);
        Break;
      end;
    end;
  end;

  if HorScrollBar.Enabled then HorScrollBar.SetFocus;
end;

procedure TEKGArea.ScrollBarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_UP, VK_DOWN:
      if HorScrollBar.Focused then
      begin
        VertScrollBar.SetFocus;
        Key := 0;
      end;
       
    VK_LEFT, VK_RIGHT:
      if VertScrollBar.Focused then
      begin
        HorScrollBar.SetFocus;
        Key := 0;
      end;             
  end;
end;

procedure TEKGArea.SetColors(AColors: array of TColor);
var
  I: Integer;
begin
  SetLength(Colors, Length(AColors));
  for I := 0 to Length(AColors) - 1 do
    Colors[I] := AColors[I];
end;

procedure TEKGArea.SetColors2(AColors: array of TColor);
var
  I: Integer;
begin
  SetLength(Colors2, Length(AColors));
  for I := 0 to Length(AColors) - 1 do
    Colors2[I] := AColors[I];
end;

function TEKGArea.NewGraphicLine(AModes: TGraphicLineSet; StartPosition: Integer;
  AttachNum: Integer; DrawNow: Boolean ): TGraphicLine;
begin
  Result := TGraphicLine.Create(nil);
  try
    with Result do
    begin
      EKGArea := Self;
      Modes := AModes;
      Cursor := crHandPoint;
      Visible := False;
      if gtHorizontal in Modes then
      begin
        Bitmap := HorLineBitmap;
        Height := 5;
        Left := 20;
        Attach := AttachNum;
        Width := PaintBox.Width - 20;
        if gtMoveAble in Modes then
          Cursor := crSizeNS;
      end else
      begin
        Bitmap := VertLineBitmap;
        Width := 5;
        Height := PaintBox.Height;
        if gtMoveAble in Modes then
          Cursor := crSizeWE;
      end;

      AttachedHorLines := TList.Create;

      Position := StartPosition; // Устанавливает местоположение в соотв. с параметрами

      if gtMoveAble in Modes then
      begin
        OnMouseMove := GraphicLineMouseMove;
        OnMouseDown := GraphicLineMouseDown;
        OnMouseUp := GraphicLineMouseUp;
      end;
     
      Color := clBlack;  

      BringToFront;

      if DrawNow then
        Draw;
    end;

    GraphicLines.Add(Result);
  except
    on E: Exception do
    begin
      Result.Free;
      raise MatrixReCreateExceptObj(E, 'function TEKGArea.NewGraphicLine');
    end;
  end;
end;

procedure TEKGArea.DeleteGraphicLine(GraphicLine: TGraphicLine);
var
  I: Integer;
begin
  for I := GraphicLines.Count - 1 downto 0 do
  begin
    if (GraphicLines[I] = GraphicLine) or (GraphicLine = nil) then
    begin
      with TGraphicLine(GraphicLines[I]) do
      begin
        GraphicLines.Delete(I);
        Free;
      end;
    end;
  end;
end;

procedure TEKGArea.RegisterEKGRect(SourEKG: TMatrix; ARow, h: Integer);
var
  P: PEKGRect;
begin
  New(P);
  P.rRow := ARow;
  P.rRect := Rect(0, h - Fmm_on_mV * 4, SourEKG.Cols + 20, h);
  FEKGRectList.Add(P);
end;

procedure TEKGArea.RepaintGraphicLines;
var
  I: Integer;
begin
  try
    for I := GraphicLines.Count - 1 downto 0 do
      TGraphicLine(GraphicLines[I]).Draw;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.RepaintGraphicLines');
  end;
end;

procedure TEKGArea.ResizeGraphicLines;
var
  I: Integer;
begin
  try
    for I := GraphicLines.Count - 1 downto 0 do
    begin
      with TGraphicLine(GraphicLines[I]) do
      begin
        if Visible then // Изменять размеры множества невидимых линий - очень долго.
        begin
          if gtHorizontal in Modes then
            begin
              Width := Max(PaintBox.Width, 1);
            end
          else
            begin
              Height := Max(PaintBox.Height, 1);
            end;
        end;
      end;
    end;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.ResizeGraphicLines');
  end;
end;

function TEKGArea.GetEKGPos(PixelX: Integer): Integer;
begin
  Result := HorScrollBar.Position + Trunc(((PixelX - 20) * Frequency) / (mm_on_sec * 4));
end;

function TEKGArea.GetPixelCoord(EKGPos: Integer): Integer;
begin
  Result := Trunc((EKGPos - HorScrollBar.Position) * (mm_on_sec * 4) / Frequency) + 20;
end;

procedure TEKGArea.PosGraphicLines;
var
  I: Integer;
begin
  try
    for I := GraphicLines.Count - 1 downto 0 do
      TGraphicLine(GraphicLines[I]).SetActualPosition;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.PosGraphicLines');
  end;
end;

procedure TEKGArea.BeginUpdate;
begin
  IsUpdate := True;
end;

procedure TEKGArea.EndUpdate;
begin
  IsUpdate := False;
end;

procedure TEKGArea.AssignFrom(Source: TEKGArea);
begin
  FGridColor := Source.FGridColor;
  FGridVisible := Source.FGridVisible;
  FMonoColor := Source.FMonoColor;
  FStepVisible := Source.FStepVisible;
  FStepColor := Source.FStepColor;
  FPeaksVisible := Source.FPeaksVisible;
  FPeaksColor := Source.FPeaksColor;
  FTakeDownColor := Source.FTakeDownColor;
  FInterval := Source.FInterval;
  FFrequency := Source.FFrequency;
  FSensitivity := Source.FSensitivity;
  Fmm_on_mV := Source.Fmm_on_mV;
  Fmm_on_sec := Source.Fmm_on_sec;
  Workspace.Clear;
  if Source.Workspace.FindMatrix('SourEKG') <> nil then
    Source.Workspace['SourEKG'].CreateReference(Workspace, 'SourEKG');
end;

procedure TEKGArea.DrawEKG;
begin
  try
    DoDrawEKG;
    if Assigned(FOnDrawEKG) then
      FOnDrawEKG(Self);
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.DrawEKG');
  end;
end;

procedure TEKGArea.UnRegisterGraphicLine(GraphicLine: TGraphicLine);
begin
  GraphicLines.Remove(GraphicLine);
end;

function TEKGArea.GetImageBuffer: TBitmap;
begin
  Result := ImageBuffer;
end;

function TEKGArea.GetPaintBox: TPaintBox;
begin
  Result := PaintBox;
end;

function TEKGArea.GetHorScrollBar: TScrollBar;
begin
  Result := HorScrollBar;
end;

function TEKGArea.GetVertScrollBar: TScrollBar;
begin
  Result := VertScrollBar;
end;

procedure TEKGArea.SetEKGColor2(const Value: TColor);
begin
  FEKGColor2 := Value;
end;

function TEKGArea.GetImPanel: TPanel;
begin
  Result := ImPanel;
end;

procedure TEKGArea.ClearSegmentLines;
var
   I: Integer;
begin
  for I := 0 to FSegmentLineList.Count - 1 do
    Dispose(PSegmentLine(FSegmentLineList.Objects[I]));
  FSegmentLineList.Clear;
end;

procedure TEKGArea.AddSegmentLine(AName: string; X1, X2: Integer;
  AColor: TColor; APenStyle: TPenStyle; ASize, ACurveNum: Integer; DrawLine: Boolean);
var
  Index: Integer;
  Seg: PSegmentLine;
begin
  Index := FSegmentLineList.IndexOf(AName);
  if Index < 0 then
  begin
    New(Seg);
    FSegmentLineList.AddObject(AName, TObject(Seg));
  end else
    Seg := PSegmentLine(FSegmentLineList.Objects[Index]);

  Seg.segName := AName;
  Seg.segX1 := X1;
  Seg.segX2 := X2;
  Seg.segColor := AColor;
  Seg.segPenStyle := APenStyle;
  Seg.segSize := ASize;
  Seg.segCurveNum := ACurveNum;
  Seg.segDrawLine := DrawLine;
end;

procedure TEKGArea.DeleteSegmentLine(AName: string);
var
  Index: Integer;
  Seg: PSegmentLine;
begin
  Index := FSegmentLineList.IndexOf(AName);
  if Index >= 0 then
  begin
    Seg := PSegmentLine(FSegmentLineList.Objects[Index]);
    Dispose(Seg);
    FSegmentLineList.Delete(Index);
  end;
end;

procedure TEKGArea.SaveCanvasParams(ACanvas: TCanvas);
begin
  FCanvasParams.prPenColor := ACanvas.Pen.Color;
  FCanvasParams.prPenStyle := ACanvas.Pen.Style;
  FCanvasParams.prPenSize := ACanvas.Pen.Width;

  FCanvasParams.prBrushColor := ACanvas.Brush.Color;
  FCanvasParams.prBrushStyle := ACanvas.Brush.Style;
end;

procedure TEKGArea.RestoreCanvasParams(ACanvas: TCanvas);
begin
  ACanvas.Pen.Color := FCanvasParams.prPenColor;
  ACanvas.Pen.Style := FCanvasParams.prPenStyle;
  ACanvas.Pen.Width := FCanvasParams.prPenSize;

  ACanvas.Brush.Color := FCanvasParams.prBrushColor;
  ACanvas.Brush.Style := FCanvasParams.prBrushStyle;  
end;

procedure TEKGArea.AddColorAreaSegment(AName: string; X1, Y1, X2, Y2: Integer;
      TopColor, BottomColor: TColor; AStyle: TPenStyle; ACurveNum: Integer);
var
  Index: Integer;
  Seg: PColorAreaSegment;
begin
  Index := FColorAreaSegmentList.IndexOf(AName);
  if Index < 0 then
  begin
    New(Seg);
    FColorAreaSegmentList.AddObject(AName, TObject(Seg));
  end else
    Seg := PColorAreaSegment(FColorAreaSegmentList.Objects[Index]);

  Seg.segName := AName;
  Seg.segX1 := X1;
  Seg.segY1 := Y1;
  Seg.segX2 := X2;
  Seg.segY2 := Y2;
  Seg.segPenTopColor := TopColor;
  Seg.segPenBottomColor := BottomColor;
  Seg.segPenStyle := AStyle;
  Seg.segCurveNum := ACurveNum;
end;

procedure TEKGArea.ClearColorAreaSegment;
var
   I: Integer;
begin
  for I := 0 to FColorAreaSegmentList.Count - 1 do
    Dispose(PColorAreaSegment(FColorAreaSegmentList.Objects[I]));
  FColorAreaSegmentList.Clear;
end;

procedure TEKGArea.ClearEKGRectList;
var
   I: Integer;
begin
  for I := 0 to FEKGRectList.Count - 1 do
    Dispose(PEKGRect(FEKGRectList[I]));
  FEKGRectList.Clear;
end;

procedure TEKGArea.DrawColorAreaSegments(SourEKG: TMatrix; ARow, h: Integer);
var
  I, SegX, SegY, SegY1, K: Integer;
  CSeg: PColorAreaSegment;
begin
  if FColorAreaSegmentList.Count > 0 then
  begin
    SaveCanvasParams(ImageBuffer.Canvas);
    try
      for I := 0 to FColorAreaSegmentList.Count - 1 do
      begin
        CSeg := PColorAreaSegment(FColorAreaSegmentList.Objects[I]);
        if (CSeg.segCurveNum = -1) or (CSeg.segCurveNum = ARow) then
        begin
          if (CSeg.segX1 >= 0) and (CSeg.segX2 < SourEKG.Cols) and (CSeg.segX2 > CSeg.segX1) then
          begin

            
            ImageBuffer.Canvas.Pen.Style := CSeg.segPenStyle;

            SegX := MaxInt;
            for K := CSeg.segX1 to CSeg.segX2 do
            begin
              if GetPixelCoord(K) <> SegX then
              begin
                SegX := GetPixelCoord(K);

                if SegX > 20 then
                begin
                  SegY := Round(-(CSeg.segY1+(K-CSeg.segX1) * (CSeg.segY2-CSeg.segY1)/(CSeg.segX2-CSeg.segX1)) * 4 * mm_on_mV / Sensitivity + h);
                  ImageBuffer.Canvas.MoveTo(SegX, SegY);


                  SegY1 := Round(-SourEKG.Elem[ARow, K] * 4 * mm_on_mV / Sensitivity + h);
                  if SegY1 > SegY then
                    ImageBuffer.Canvas.Pen.Color := CSeg.segPenBottomColor
                  else
                    ImageBuffer.Canvas.Pen.Color := CSeg.segPenTopColor;

                  // Корректируем окончание линии так, чтобы не перекрывала ЭКГ
                  if SourEKG.Elem[ARow, K] > 0 then
                    Inc(SegY, 1)
                  else if SourEKG.Elem[ARow, K] < 0 then
                    Dec(SegY, 1);
                  ImageBuffer.Canvas.LineTo(SegX, SegY1);
                end;
              end;
            end;
          end;
        end;
      end;

      {if (FBlackPoint.X > 0) and (ARow=0) then
      begin
        SegX := GetPixelCoord(FBlackPoint.X);
        SegY := Round(-FBlackPoint.Y * 4 * mm_on_mV / Sensitivity + h);
        ImageBuffer.Canvas.Pen.Color := clBlack;
        ImageBuffer.Canvas.Pen.Width := 4;
        ImageBuffer.Canvas.MoveTo(SegX, SegY);
        ImageBuffer.Canvas.LineTo(SegX+1, SegY+1);
      end;}
    finally
      RestoreCanvasParams(ImageBuffer.Canvas);
    end; // Закрашенные области нарисовали
  end;

end;

procedure TEKGArea.DrawSegmentLines(SourEKG: TMatrix; ARow, h: Integer);
var
  I, SegX, SegY, K: Integer;
  Seg: PSegmentLine;
begin
  if FSegmentLineList.Count > 0 then
  begin
    SaveCanvasParams(ImageBuffer.Canvas);
    try
      for I := 0 to FSegmentLineList.Count - 1 do
      begin
        Seg := PSegmentLine(FSegmentLineList.Objects[I]);
        if (Seg.segCurveNum = -1) or (Seg.segCurveNum = ARow) then
        begin
          if (Seg.segX1 >= 0) and (Seg.segX2 < SourEKG.Cols) then
          begin
            ImageBuffer.Canvas.Pen.Color := Seg.segColor;
            ImageBuffer.Canvas.Pen.Style := Seg.segPenStyle;
            ImageBuffer.Canvas.Pen.Width := Seg.segSize;

            SegX := GetPixelCoord(Seg.segX1);
            SegY := Round(-SourEKG.Elem[ARow, Seg.segX1] * 4 * mm_on_mV / Sensitivity + h);
            ImageBuffer.Canvas.MoveTo(SegX, SegY);

            if Seg.segDrawLine then // Рисуем линию
            begin
              SegX := GetPixelCoord(Seg.segX2);
              SegY := Round(-SourEKG.Elem[ARow, Seg.segX2] * 4 * mm_on_mV / Sensitivity + h);
              ImageBuffer.Canvas.LineTo(SegX, SegY);
            end else
            begin // Обводим ЭКГ
              for K := Seg.segX1 to Seg.segX2 do
              begin
                SegX := GetPixelCoord(K);
                SegY := Round(-SourEKG.Elem[ARow, K] * 4 * mm_on_mV / Sensitivity + h);
                ImageBuffer.Canvas.LineTo(SegX, SegY);
              end;
            end;
          end;
        end;
      end;
    finally
      RestoreCanvasParams(ImageBuffer.Canvas);
    end; // Сегментные линии нарисовали
  end;
end;

procedure TEKGArea.DrawAdditionalCurves(SourEKG: TMatrix; ARow, h: Integer);
var
  I: Integer;
begin
  if SourEKG.IsLiving and (SourEKG.Rows > ARow) then
  begin
     if IsMonoColors then
      ImageBuffer.Canvas.Pen.Color := FMonoColor
    else
      if Length(Colors2) < ARow + 1 then
        ImageBuffer.Canvas.Pen.Color := EKGColor2
      else
        ImageBuffer.Canvas.Pen.Color := Colors2[ARow];

    ImageBuffer.Canvas.MoveTo(21, Round(SourEKG.Elem[ARow, 0] + h));

    for I := 1 to SourEKG.Cols - 1 do
      ImageBuffer.Canvas.LineTo(I + 20, Round(SourEKG.Elem[ARow, I] + h));
  end;
end;

procedure TEKGArea.DrawCurveNames(ARow, h: Integer);
begin
  if ARow + 1 <= FListOfNames.Count then
  begin
    ImageBuffer.Canvas.Font.Assign(FSignFont);

    if IsMonoColors then
      ImageBuffer.Canvas.Font.Color := FMonoColor;
    if ARow = SelectedCurveNumber then
      ImageBuffer.Canvas.Font.Style := ImageBuffer.Canvas.Font.Style + [fsBold];
    if FStepVisible then
      ImageBuffer.Canvas.TextOut(22, h, FListOfNames[ARow])
    else
      ImageBuffer.Canvas.TextOut(3, h - 15, FListOfNames[ARow]);

    // Восстанавливаем шрифт (на всякий случай)
    ImageBuffer.Canvas.Font.Assign(FSignFont);
  end;
end;

procedure TEKGArea.DrawEKGCurves(SourEKG: TMatrix; ARow, h: Integer);
var
  I: Integer;
begin
  // Настраиваем свойства канвы перед выводом основной кривой ЭКГ
  if IsMonoColors then // Черно-белый
    ImageBuffer.Canvas.Pen.Color := FMonoColor
  else
  begin
    if Length(Colors) < ARow + 1 then
      ImageBuffer.Canvas.Pen.Color := EKGColor // Общий для всех кривых
    else
      ImageBuffer.Canvas.Pen.Color := Colors[ARow]; // Разный для каждой кривой
  end;

  if ARow = SelectedCurveNumber then
    ImageBuffer.Canvas.Pen.Width := 2
  else
    ImageBuffer.Canvas.Pen.Width := 1;

  // Точка начала кривой участка ЭКГ
  ImageBuffer.Canvas.MoveTo(21, Round(SourEKG.Elem[ARow, 0] + h));

  // Выводим все точки участка кривой ЭКГ
  for I := 1 to SourEKG.Cols - 1 do
    ImageBuffer.Canvas.LineTo(I + 20, Round(SourEKG.Elem[ARow, I] + h));

  ImageBuffer.Canvas.Pen.Width := 1;

end;

procedure TEKGArea.DrawStep(h: Integer);
begin
  if StepVisible then
  begin
    // Рисуем ступеньку
    if IsMonoColors then
      ImageBuffer.Canvas.Pen.Color := FMonoColor
    else
      ImageBuffer.Canvas.Pen.Color := FStepColor;
    with ImageBuffer.Canvas do
    begin
      MoveTo(5, h);
      LineTo(8, h);
      LineTo(8, h - Fmm_on_mV * 4);
      LineTo(12, h - Fmm_on_mV * 4);
      LineTo(12, h);
      LineTo(16, h);
    end;
  end; // Закончили отрисовку ступеньки
end;

procedure TEKGArea.WndProc(var Message: TMessage);
begin
  try
    inherited;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TEKGArea.WndProc');
  end;
end;

{ TGraphicLine }

procedure TGraphicLine.Draw;
var
  SourRect, DestRect: TRect;
  BegPoint, EndPoint: TPoint;
begin
  try
    {if Assigned(FChangePositionProc) then
      FChangePositionProc(Self);}
    
    if (Left < 18) or (Left > EKGArea.PaintBox.Width - 2) or
      (Top < 0) or (Top > EKGArea.PaintBox.Height) then
    begin
      Visible := False;

      // Сбрасываем Parent только для вертикальных линий
      // Для горизонтальных в VCL происходит ошибка доступа к элементу TList.
      // Ошибка происходит в случае, если к основному холсту приходит событие
      // WMPAINT, запускается цикл перерисовки дочерних компонентов, а эти
      // компоненты (в случае если это горизонтальные линии), могут неожиданно
      // сбросить свойство Parent, и цикл перерисовки дочерних компонентов
      // завершится ошибкой "List index out of bounds"
      if gtVertical in Modes then
        Parent := nil;
        
      Exit;
    end;

    Visible := True;
    Parent := EKGArea.ImPanel;

    // Корректируем размеры линии
    if gtHorizontal in Modes then
    begin
      if Width <> Max(EKGArea.PaintBox.Width, 1) then
        Width := Max(EKGArea.PaintBox.Width, 1);
    end else
    begin
      if Height <> Max(EKGArea.PaintBox.Height, 1) then
        Height := Max(EKGArea.PaintBox.Height, 1);
    end;

    SourRect := Rect(Left, Top, Left + Width, Top + Height);
    DestRect := Rect(0, 0, Width, Height);

    // Копируем часть миллиметровки в буффер Bitmap
    Bitmap.Canvas.CopyRect(DestRect, EKGArea.PaintBox.Canvas, SourRect);

    if gtHorizontal in Modes then
    begin
      BegPoint.X := 0; EndPoint.X := Width;
      BegPoint.Y := 2; EndPoint.Y := 2;
    end else
    begin
      BegPoint.X := 2; EndPoint.X := 2;
      BegPoint.Y := 0; EndPoint.Y := Height;
    end;

    with Bitmap.Canvas do
    begin
      Pen.Color := Color;
      Pen.Style := PenStyle;
      MoveTo(BegPoint.X, BegPoint.Y);
      LineTo(EndPoint.X, EndPoint.Y);
    end;

    // Рисуем на поверхности TGraphicLine линию с миллиметровкой
    Canvas.Draw(1, 1, Bitmap);
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TGraphicLine.Draw');
  end;
end;

procedure TGraphicLine.GraphicLineMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if gtHorizontal in Modes then OldCoord := Y else OldCoord := X;
    // При нажатии на линию цвет инвертируется
    Color := Color xor $00FF00FF;
  end;
end;

procedure TGraphicLine.GraphicLineMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then Color := Color xor $00FF00FF;
end;

procedure TGraphicLine.GraphicLineMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Value: Integer;
  NewPosition: Integer;
begin
  try
    if ssLeft in Shift then
    begin   
      if gtHorizontal in Modes then
      begin
        Value := Top + Y - OldCoord;
        if (Value > 0) and (Value < EKGArea.PaintBox.Height - 3) then
        begin
          if Assigned(TopLine) and (Value <= TopLine.Top) then
            Value := TopLine.Top + 2;
          if Assigned(BottomLine) and (Value >= BottomLine.Top) then
            Value := BottomLine.Top - 2;
          Top := Value;
        end;

        if gtSynchronize in Modes then
          NewPosition := ScreenToAmplitude(Top + 2)
        else
          NewPosition := Top;
      end else
      begin
        Value := Left + X - OldCoord;
        if (Value > 17) and (Value < EKGArea.PaintBox.Width - 3) then
        begin
          if Assigned(LeftLine) and (Value <= LeftLine.Left) then Value := LeftLine.Left + 2;
          if Assigned(RightLine) and (Value >= RightLine.Left) then Value := RightLine.Left - 2;
          Left := Value;
        end;

        if gtSynchronize in Modes then
          NewPosition := EKGArea.GetEKGPos(Left + 2)
        else
          NewPosition := Left;

        MoveAttachedHorizontalLines;
      end;

      if FPosition <> NewPosition then
      begin
        FPosition := NewPosition;
        if Assigned(FChangePositionProc) then
          FChangePositionProc(Self);
      end;
    end;
    
    if ShowHint then
      Application.ActivateHint(Mouse.CursorPos);
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TGraphicLine.GraphicLineMouseMove');
  end;
end;       

procedure TGraphicLine.SetPosition(const Value: Integer);
var
  APos, AValue: Integer;
begin
  try
    // Предотвращаем варианты изменения позиции линии из своего же обработчика FChangePositionProc
    if FIsSetPosition then
      Exit;

    AValue := Value;

    FIsSetPosition := True;
    try
      if gtVertical in Modes then
      begin
        if gtSynchronize in Modes then
          APos := EKGArea.GetPixelCoord(AValue) - 2
        else
          APos := AValue;

        if Assigned(LeftLine) and (APos <= LeftLine.Left) then
        begin
          APos := LeftLine.Left + 2;
          if gtSynchronize in Modes then
            AValue := EKGArea.GetEKGPos(APos)
          else
            AValue := APos;
        end;
 
        if Assigned(RightLine) and (APos >= RightLine.Left) then
        begin
          APos := RightLine.Left - 2;
          if gtSynchronize in Modes then
            AValue := EKGArea.GetEKGPos(APos)
          else
            AValue := APos;
        end;    

        Left := APos;
        MoveAttachedHorizontalLines;
      end;

      if gtHorizontal in Modes then
      begin
        if gtSynchronize in Modes then
          Top := AmplitudeToScreen(AValue) - 1
        else
          Top := AValue;   
      end;

      if FPosition <> AValue then
      begin
        FPosition := AValue;
        if Assigned(FChangePositionProc) then
          FChangePositionProc(Self);
      end;
    finally
      FIsSetPosition := False;
    end;   
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TGraphicLine.SetPosition');
  end;
end;

procedure TGraphicLine.SetActualPosition;
var
  Value: Integer;
begin
  try
    if [gtVertical, gtSynchronize] <= Modes then
    begin
      Value := EKGArea.GetPixelCoord(Position) - 2;
      // Если вертикальная линия была и остается за зоной видимости, то нечего ее перерисовывать
      // Иначе изменяем ее положение Left
      if not (((Value < 0) or (Value > EKGArea.PaintBox.Width)) and
        ((Left < 0) or (Left > EKGArea.PaintBox.Width))) then
        Left := Value;
    end;

    if ([gtHorizontal, gtSynchronize] <= Modes) and (Attach > 0) then
    begin
      Value := AmplitudeToScreen(Position) - 1;
      if not (((Value < 0) or (Value > EKGArea.PaintBox.Height)) and
        ((Top < 0) or (Top > EKGArea.PaintBox.Height))) then
        Top := Value;
    end;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TGraphicLine.SetActualPosition');
  end;
end;

destructor TGraphicLine.Destroy;
begin
  AttachedHorLines.Free;
  EKGArea.UnRegisterGraphicLine(Self);
  inherited;
end;

procedure TGraphicLine.SetPenStyle(const Value: TPenStyle);
begin
  FPenStyle := Value;
end;

function TGraphicLine.AmplitudeToScreen(Ampl: Integer): Integer;
begin
  with EKGArea do
  begin
    Result := -VertScrollBar.Position + Trunc(mm_on_mV * 4 + 20  + Interval * 4 * (Attach - 1) +
      -Ampl * 4 * mm_on_mV / Sensitivity) - 1;
  end;
end;

function TGraphicLine.ScreenToAmplitude(CoordY: Integer): Integer;
begin
  with EKGArea do
  begin
    Result := Trunc((-VertScrollBar.Position + mm_on_mV * 4 + 20  +
      Interval * 4 * (Attach - 1) - CoordY) * Sensitivity / (4 * mm_on_mV));
  end;
end;

procedure TGraphicLine.SetLeftLine(const Value: TGraphicLine);
begin
  FLeftLine := Value;
  Value.FRightLine := Self;
end;

procedure TGraphicLine.SetRightLine(const Value: TGraphicLine);
begin
  FRightLine := Value;
  Value.FLeftLine := Self;
end;

procedure TGraphicLine.SetBottomLine(const Value: TGraphicLine);
begin
  FBottomLine := Value;
  Value.FTopLine := Self;
end;

procedure TGraphicLine.SetTopLine(const Value: TGraphicLine);
begin
  FTopLine := Value;
  Value.FBottomLine := Self;
end;

procedure TGraphicLine.SetAttachedVertLine(const Value: TGraphicLine);
begin
  try
    if (gtSynchronize in Modes) and (gtSynchronize in Value.Modes) and (Attach > 0) then
    begin
      if Value.AttachedHorLines.IndexOf(Self) = -1 then
      begin
        Value.AttachedHorLines.Add(Self);
        Value.MoveAttachedHorizontalLines;
      end;
    end;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TGraphicLine.SetAttachedVertLine');
  end;
end;

procedure TGraphicLine.MoveAttachedHorizontalLines;
var
  I, Amp: Integer;
  SourEKG: TMatrix;
begin
  try
    if [gtVertical, gtSynchronize] <= Modes then
    begin
      for I := 0 to AttachedHorLines.Count - 1 do
      begin
        SourEKG := EKGArea.Workspace.FindMatrix('SourEKG');
        with EKGArea.Workspace do
        begin
          if Assigned(SourEKG) and (Self.Position >= 1) and (Self.Position <= SourEKG.Cols)
          then
            Amp := Trunc(SourEKG.Elem[TGraphicLine(AttachedHorLines[I]).Attach - 1, Self.Position - 1])
          else
            Amp := 0;
        end;
        TGraphicLine(AttachedHorLines[I]).Position := Amp;
      end;
    end;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TGraphicLine.MoveAttachedHorizontalLines');
  end;
end;

function TGraphicLine.IsGridAttached: Boolean;
begin
  Result := gtSynchronize in Modes;
end;

function TGraphicLine.ThisLine: TGraphicLine;
begin
  Result := Self;
end;

procedure TGraphicLine.WndProc(var Message: TMessage);
begin
  try
    inherited;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TGraphicLine.WndProc');
  end;
end;

{ TMyScrollBar }

procedure TMyScrollBar.WMMouseWheel(var Message: TWMMouseWheel);
var
  ScrollPos: Integer;
begin
  try
    if Message.WheelDelta < 0 then
      Position := Position + LargeChange
    else
      Position := Position - LargeChange;

    ScrollPos := Position;
    Scroll(scPageDown, ScrollPos);

    inherited;
  except
    on E: Exception do
      raise MatrixReCreateExceptObj(E, 'procedure TMyScrollBar.WMMouseWheel');
  end;
end;

end.
