unit MainFrm;

interface

{$IF RTLVersion >= 24.00}
   {$DEFINE DXE3PLUS}
{$IFEND}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Matrix32, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons,
  TeEngine, Series, TeeProcs, Chart, matrixMatlab, strutils, Spin, SafeIniFiles,
  Grids, Mask, CommCtrl, ActnList, ToolWin, matrixLapack, matrixBlas,
  VclTee.TeeGDIPlus, Actions;

{Внимание! Модули VclTee.TeeGDIPlus и System.Actions добавляются средой
 разработки Delphi XE5 по умолчанию. Удалите их, если используете более
 старую версию Delphi!}

type
  TMainForm = class(TForm)
    Panel3: TPanel;
    Panel5: TPanel;
    ILMatrixTree: TImageList;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    OpenDialog1: TOpenDialog;
    SaveDialog2: TSaveDialog;
    Panel2: TPanel;
    Panel1: TPanel;
    TabSheet3: TTabSheet;
    Panel8: TPanel;
    seChartRowNum: TSpinEdit;
    btnDiag: TButton;
    Chart1: TChart;
    Series1: TLineSeries;
    rbChartFromRow: TRadioButton;
    rbChartFromCol: TRadioButton;
    Timer1: TTimer;
    ImageList1: TImageList;
    ActionList1: TActionList;
    acAddMatrix: TAction;
    acDeleteMatrix: TAction;
    acTreeRefresh: TAction;
    acLoadFromFile: TAction;
    acSaveToFile: TAction;
    TabSheet4: TTabSheet;
    cbAutoSaveWorkspace: TCheckBox;
    Label3: TLabel;
    Panel10: TPanel;
    btnSaveParams: TButton;
    TabSheet5: TTabSheet;
    Splitter2: TSplitter;
    panMatrixInfo: TPanel;
    panMatrixView: TPanel;
    Panel11: TPanel;
    Panel7: TPanel;
    Label1: TLabel;
    lbMatrixInfo: TLabel;
    Label4: TLabel;
    labObjCount: TLabel;
    panMatrixTree: TPanel;
    Panel4: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    twMatrix: TTreeView;
    Splitter3: TSplitter;
    Panel9: TPanel;
    twCateg: TTreeView;
    Panel12: TPanel;
    edCellEditor: TEdit;
    dgElems: TDrawGrid;
    panCategTitle: TPanel;
    Panel13: TPanel;
    GroupBox1: TGroupBox;
    btnPutToMatlab: TButton;
    rgToMatlabNameType: TRadioGroup;
    edToMatlabMatrixName: TEdit;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    edMatlabObjectName: TEdit;
    Button8: TButton;
    cbOtherMatrixObjectName: TCheckBox;
    edOtherMatrixObjectName: TEdit;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Splitter4: TSplitter;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    btnExecuteMatlabCommand: TButton;
    memoMatlabCommand: TMemo;
    memoMatlabCommandHistory: TMemo;
    cbAutoClearMatlabCommand: TCheckBox;
    Button1: TButton;
    Panel20: TPanel;
    Label2: TLabel;
    cbFormat: TComboBox;
    sbEditFormat: TSpeedButton;
    Label5: TLabel;
    ToolBar2: TToolBar;
    ToolButton7: TToolButton;
    acAddRow: TAction;
    acAddCol: TAction;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    acDelRow: TAction;
    acDelCol: TAction;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    seColWidth: TSpinEdit;
    edWorkspaceFileName: TEdit;
    Button3: TButton;
    Panel6: TPanel;
    Panel21: TPanel;
    labM1: TLabel;
    labM2: TLabel;
    labDelFromM1: TLabel;
    labDelFromM2: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel22: TPanel;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Button2: TButton;
    seFillStart: TSpinEdit;
    seFillStep: TSpinEdit;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    rbStep: TRadioButton;
    rbFinish: TRadioButton;
    acClearMatrix: TAction;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button7: TButton;
    Label8: TLabel;
    labM3: TLabel;
    SpeedButton3: TSpeedButton;
    labDelFromM3: TLabel;
    Button9: TButton;
    cbFuncList: TComboBox;
    Button10: TButton;
    cbOpList: TComboBox;
    TabSheet2: TTabSheet;
    Panel23: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Panel24: TPanel;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    rbRandom: TRadioButton;
    btnReshape: TButton;
    seMatrixRows: TSpinEdit;
    Label15: TLabel;
    seMatrixCols: TSpinEdit;
    btnPresaveResize: TButton;
    TabSheet6: TTabSheet;
    Panel25: TPanel;
    GroupBox4: TGroupBox;
    Button17: TButton;
    Label16: TLabel;
    labMinElem: TLabel;
    Label18: TLabel;
    labMaxElem: TLabel;
    labMinIndex1: TLabel;
    labMinIndex: TLabel;
    Label22: TLabel;
    labMaxIndex: TLabel;
    GroupBox5: TGroupBox;
    Button18: TButton;
    Label17: TLabel;
    cbStatInfoType: TComboBox;
    rgStatDim: TRadioGroup;
    TabSheet7: TTabSheet;
    Panel26: TPanel;
    Button16: TButton;
    seScalePoints: TSpinEdit;
    Button19: TButton;
    seNormSignal: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnDiagClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure twMatrixClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure cbFormatSelect(Sender: TObject);
    procedure seChartRowNumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPutToMatlabClick(Sender: TObject);
    procedure sbEditFormatClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dgElemsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure dgElemsGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure edCellEditorExit(Sender: TObject);
    procedure twMatrixChange(Sender: TObject; Node: TTreeNode);
    procedure Button8Click(Sender: TObject);
    procedure twMatrixEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure twMatrixDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure twMatrixEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure twMatrixKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure twMatrixEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure acAddMatrixExecute(Sender: TObject);
    procedure acDeleteMatrixExecute(Sender: TObject);
    procedure acTreeRefreshExecute(Sender: TObject);
    procedure acLoadFromFileExecute(Sender: TObject);
    procedure acSaveToFileExecute(Sender: TObject);
    procedure btnSaveParamsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure twCategChange(Sender: TObject; Node: TTreeNode);
    procedure seChartRowNumChange(Sender: TObject);
    procedure rgToMatlabNameTypeClick(Sender: TObject);
    procedure cbOtherMatrixObjectNameClick(Sender: TObject);
    procedure btnExecuteMatlabCommandClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure memoMatlabCommandKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure acAddRowExecute(Sender: TObject);
    procedure acAddColExecute(Sender: TObject);
    procedure acDelRowExecute(Sender: TObject);
    procedure acDelColExecute(Sender: TObject);
    procedure seColWidthChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure labDelFromM1Click(Sender: TObject);
    procedure labDelFromM2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure acClearMatrixExecute(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure labDelFromM3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure btnReshapeClick(Sender: TObject);
    procedure btnPresaveResizeClick(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
  private
    { Private declarations }
    FCurMatrix: TMatrix;

    EditingRow, EditingCol: Integer;
    EditingString: string;

    BaseTreeNode: TTreeNode;

    FM1, FM2, FM3: TMatrix;

    FloatFuncList: TStringList;
    FloatOpList: TStringList;

    {Обновление дерева массивов}
    procedure RefreshMatrixTree(ABaseNode: TTreeNode = nil);


    procedure LoadFormatList;

    procedure ApplySelectedFormat;

    function GetCellText(ACol, ARow: Integer): string;

    procedure ApplyEditingValue;

    function CanDragMatrix(Target: TObject; X, Y: Integer;
      var SourMatrix, SourParentMatrix, DestMatrix: TMatrix; var DestNode: TTreeNode): Boolean;

    procedure FillCategoryList;
    function GetCellStrInfo(M: TMatrix): string;
    function GetRecordStrInfo(Rec: TMatrix; FieldIndex: Integer): string;

    function InputSizeValue(AText: string; var AValue: Integer): Boolean;

    procedure FillFloatFuncList();
    procedure FillFloatOpList();
  public
    { Public declarations }

    function CurMatrix: TMatrix;

    function M1: TMatrix;
    function M2: TMatrix;
    function M3: TMatrix;

    function TryGetSelectedMatrixName: string;
  end;

  TMyClass = class(TObject)
  private
    FMyVar: TMatrix;
  public
    property MyVar: TMatrix read FMyVar;
    constructor Create;
    destructor Destroy; override;
  end;

  THackGrid = class(TCustomGrid);

var
  MainForm: TMainForm;
  CurFloatFormat: string = '%g';
{$IFDEF DXE3PLUS}
  ThousandSeparator: Char;
{$ENDIF DXE3PLUS}

implementation

uses Math, {cUtils,} matrixFourier, matrixNNet, matrixTests, matrixDemos,
  matrixNNetLVQ, EditFormatFrm, UtilsUnit, AddMatrixFrm, MoveToCellFrm;

{$R *.dfm}

function DoFloatToStr(Value: Extended): string;
begin
  Result := Format(CurFloatFormat, [Value]);
end;


procedure TMainForm.acAddColExecute(Sender: TObject);
var
  V: Integer;
begin
  if FCurMatrix.IsLiving and (FCurMatrix.IsNumeric or FCurMatrix.IsCell) and
     (FCurMatrix.DimensionCount < 3) then
  begin
    V := 1;
    if InputSizeValue('Укажите количество столбцов', V) then
    begin
      if FCurMatrix.DimensionCount = 0 then
      begin
        FCurMatrix.PreservResize([V]);
      end else if FCurMatrix.DimensionCount = 1 then
      begin
        FCurMatrix.PreservResize([FCurMatrix.Cols + V]);
      end else if FCurMatrix.DimensionCount = 2 then
      begin
        FCurMatrix.PreservResize([FCurMatrix.Rows, FCurMatrix.Cols + V]);
      end;

      if FCurMatrix.IsCell then
        RefreshMatrixTree(twMatrix.Selected);
      twMatrixClick(twMatrix);
    end;
  end;
end;

procedure TMainForm.acAddMatrixExecute(Sender: TObject);
begin
  if ShowAddMatrixForm(twMatrix.Selected) then
    RefreshMatrixTree;
end;

procedure TMainForm.acAddRowExecute(Sender: TObject);
var
  V: Integer;
begin
  if FCurMatrix.IsLiving and (FCurMatrix.IsNumeric or FCurMatrix.IsCell) and (FCurMatrix.DimensionCount < 3) then
  begin
    V := 1;
    if InputSizeValue('Укажите количество строк', V) then
    begin
      if FCurMatrix.DimensionCount = 0 then
      begin
        FCurMatrix.PreservResize([V, 1]);
      end else if FCurMatrix.DimensionCount = 1 then // Если это вектор
      begin
        if V = 1 then
          FCurMatrix.Reshape([1, FCurMatrix.ElemCount]) // Преобразуем в матрицу
        else // Добавляем новые строки в матрицу
          FCurMatrix.PreservResize([1 + V, FCurMatrix.Cols]);
      end else if FCurMatrix.DimensionCount = 2 then
      begin
        FCurMatrix.PreservResize([FCurMatrix.Rows + V, FCurMatrix.Cols]);
      end;

      if FCurMatrix.IsCell then
        RefreshMatrixTree(twMatrix.Selected);
      twMatrixClick(twMatrix);
    end;
  end;
end;

procedure TMainForm.acClearMatrixExecute(Sender: TObject);
begin
  if FCurMatrix.IsLiving then
  begin
    if Application.MessageBox(
      PChar('Вы действительно хотите очистить выбранный объект:'#13#10+
      TryGetSelectedMatrixName), 'Подтверждение',
      MB_OKCANCEL or MB_ICONQUESTION) = IDCANCEL then Exit;
    FCurMatrix.Clear;
    RefreshMatrixTree(twMatrix.Selected);
    twMatrixClick(twMatrix);
  end;
end;

procedure TMainForm.acDelColExecute(Sender: TObject);
begin
  if FCurMatrix.IsLiving and (FCurMatrix.IsNumeric or FCurMatrix.IsCell) and (FCurMatrix.DimensionCount < 3) then
  begin
    if FCurMatrix.DimensionCount = 1 then
    begin
      if FCurMatrix.Cols = 1 then
      begin
        if FCurMatrix.ElemCount = 1 then
          FCurMatrix.Resize([0])
        else
          FCurMatrix.PreservResize([1]);
      end
      else
        FCurMatrix.CopyArrayPart(FCurMatrix, [dgElems.Col - 1], [1], False, False);
    end else if FCurMatrix.DimensionCount = 2 then
    begin
      if FCurMatrix.Cols = 1 then
      begin
        FCurMatrix.PreservResize([1]);
      end
      else
        FCurMatrix.CopyArrayPart(FCurMatrix, [1, dgElems.Col - 1], [0, 1], False, False);
    end;

    if FCurMatrix.IsCell then
      RefreshMatrixTree(twMatrix.Selected);
    twMatrixClick(twMatrix);
  end;
end;

procedure TMainForm.acDeleteMatrixExecute(Sender: TObject);
begin
  if FCurMatrix.IsLiving then
  begin
    if FCurMatrix.IsWorkspace then
    begin
      if Application.MessageBox(
        'Вы уверены, что хотите удалить все объекты из рабочей области?', 'Внимание!',
        MB_ICONQUESTION or MB_OKCANCEL) = IDCANCEL then Exit;
      FCurMatrix.Clear;
      RefreshMatrixTree;
    end else
    begin
      if Application.MessageBox(
        'Вы уверены, что хотите удалить выбранный объект?', 'Внимание!',
        MB_ICONQUESTION or MB_OKCANCEL) = IDCANCEL then Exit;
      FCurMatrix.FreeMatrix;
      FCurMatrix := nil;

      RefreshMatrixTree(twMatrix.Selected.Parent);
    end;

  end;
end;

procedure TMainForm.acDelRowExecute(Sender: TObject);
begin
  if FCurMatrix.IsLiving and (FCurMatrix.IsNumeric or FCurMatrix.IsCell) and (FCurMatrix.DimensionCount < 3) then
  begin
    if FCurMatrix.DimensionCount = 1 then
    begin
      if FCurMatrix.ElemCount = 1 then // Если был один элемент, то очищаем массив полностью
        FCurMatrix.Resize([0])
      else
      begin // Если несколько элементов, то оставляем только один элемент
        FCurMatrix.PreservResize([1]);
      end;
    end else if FCurMatrix.DimensionCount = 2 then
    begin
      if FCurMatrix.Rows = 1 then // Если одна строка, то преобразуем ее в вектор
      begin
        FCurMatrix.Reshape([FCurMatrix.ElemCount]);
      end
      else // Если несколько строк
      begin
        FCurMatrix.CopyArrayPart(FCurMatrix, [dgElems.Row - 1, 1], [1, 0], False, False);
      end;
    end;

    if FCurMatrix.IsCell then
      RefreshMatrixTree(twMatrix.Selected);
    twMatrixClick(twMatrix);
  end;
end;

procedure TMainForm.acLoadFromFileExecute(Sender: TObject);
var
  S: string;
begin
  if OpenDialog1.Execute then
  begin
    S := AnsiLowerCaseFileName(OpenDialog1.FileName);
    if Pos('.txt', S) > 0 then
    begin
      if FCurMatrix.IsNumeric then
      begin
        with TStringList.Create do
        try
          LoadFromFile(OpenDialog1.FileName);
          FCurMatrix.AsString := Text;
        finally
          Free;
        end;
      end else
        raise Exception.Create('Значения для данного объекта невозможно загрузить из текстового файла!');
    end else
    begin
      Base.LoadWorkspace(OpenDialog1.FileName);
    end;

    RefreshMatrixTree;
  end;
end;

procedure TMainForm.acSaveToFileExecute(Sender: TObject);
begin
  if SaveDialog2.Execute then
  begin
    case SaveDialog2.FilterIndex of
      2: // Сохраняем выбранный объект в двоичный файл
        begin
          FCurMatrix.SaveToBinaryFile(SaveDialog2.FileName, TryGetSelectedMatrixName);
          DefragBinaryFile(SaveDialog2.FileName);
        end;
      3: // Сохраняем выбранный объект в текстовый файл
        begin
          if FCurMatrix.IsNumeric and (FCurMatrix.DimensionCount in [1, 2]) then
          begin
            with TStringList.Create do
            try
              Text := FCurMatrix.AsString;
              SaveToFile(SaveDialog2.FileName);
            finally
              Free;
            end;
          end else
            raise Exception.Create('Данный объект невозможно сохранить в текстовый файл!');
        end;
    else
      Base.SaveWorkspace(SaveDialog2.FileName);
    end;
  end;
end;

procedure TMainForm.acTreeRefreshExecute(Sender: TObject);
begin
  RefreshMatrixTree;
end;

procedure TMainForm.ApplyEditingValue;
var
  S: string;
  C: Char;
begin
  S := EditingString;
  if (EditingRow > 0) and (EditingCol > 0) then
  begin
    if FCurMatrix.IsLiving and FCurMatrix.IsNumeric and (FCurMatrix.DimensionCount < 3) then
    begin
      if not FCurMatrix.IsChar then
      begin
        if Pos(ThousandSeparator, S) > 0 then
          S := FastStringReplace(S, ThousandSeparator, '');
      end;

      if FCurMatrix.DimensionCount = 1 then
      begin
        if FCurMatrix.ElemCount >= EditingCol then
        begin
          if FCurMatrix.IsChar then
          begin
            C := ' ';
            if S <> '' then
              C := S[1];
            FCurMatrix.VecChar[EditingCol - 1] := C;
          end
          else
            FCurMatrix.VecElemStr[EditingCol - 1] := S;
        end;
      end else if FCurMatrix.DimensionCount = 2 then
      begin
        if (FCurMatrix.Rows >= EditingRow) and (FCurMatrix.Cols >= EditingCol) then
        begin
          if FCurMatrix.IsChar then
          begin
            C := ' ';
            if S <> '' then
              C := S[1];
            FCurMatrix.ElemChar[EditingRow - 1, EditingCol - 1] := C
          end
          else
            FCurMatrix.ElemStr[EditingRow - 1, EditingCol - 1] := S;
        end;
      end;

      dgElems.Repaint;
    end;

    EditingRow := 0;
    EditingCol := 0;
  end;
{    EditingRow, EditingCol: Integer;
    EditingString: string;}
end;

procedure TMainForm.ApplySelectedFormat;
var
  S: string;
  APos: Integer;
begin
  S := cbFormat.Text;
  APos := Pos(' (', S);
  if APos > 0 then
  begin
    S := Copy(S, 1, APos - 1);

    CurFloatFormat := S;
    twMatrixClick(twMatrix);
  end;

end;

procedure TMainForm.RefreshMatrixTree(ABaseNode: TTreeNode = nil);


  procedure WriteChildNodes(ANode: TTreeNode);
  var
    I, J: Integer;
    AList: TStringList;
    AMatrix, TmpMatrix: TMatrix;
    Node: TTreeNode;
    S: string;
  begin
    if (ANode = nil) or (ANode.Data = nil) then Exit;

    AMatrix := TMatrix(ANode.Data);

    AList := TStringList.Create;
    try

      if AMatrix.IsWorkspace then
      begin
        ANode.ImageIndex := 0;
        ANode.SelectedIndex := 0;

        AMatrix.GetMatrixList(AList);
        for I := 0 to AList.Count - 1 do
        begin
          TmpMatrix := TMatrix(AList.Objects[I]);
          S := TmpMatrix.MatrixName;
          if S = '' then
            S := '#NoName' + IntToStr(I) + '#';
          Node := twMatrix.Items.AddChild(ANode, S);
          Node.Data := TmpMatrix;

          WriteChildNodes(Node);
        end;


      end else if AMatrix.IsRecord then
      begin
        ANode.ImageIndex := 3;
        ANode.SelectedIndex := 3;

        AMatrix.GetFieldList(AList);
        for I := 0 to AList.Count - 1 do
        begin
          Node := twMatrix.Items.AddChild(ANode, AList[I]);
          Node.Data := AMatrix.Fields[AList[I]];

          WriteChildNodes(Node);
        end;

      end else if AMatrix.IsCell then
      begin
        ANode.ImageIndex := 1;
        ANode.SelectedIndex := 1;

        if AMatrix.DimensionCount = 1 then
        begin
          for I := 0 to AMatrix.ElemCount - 1 do
          begin

            if Assigned(AMatrix.VecCells[I]) then
            begin
              S := AMatrix.VecCells[I].MatrixName;
              if S <> '' then
                S := '_' + S;
            end
            else
              S := '#NoObject#';

            Node := twMatrix.Items.AddChild(ANode, Format('Cell%s(%d)', [S, I+1]));

            Node.Data := AMatrix.VecCells[I];

            WriteChildNodes(Node);
          end;
        end else if AMatrix.DimensionCount = 2 then
        begin
          for I := 0 to AMatrix.Rows - 1 do
            for J := 0 to AMatrix.Cols - 1 do
            begin

              if Assigned(AMatrix.Cells[I, J]) then
              begin
                S := AMatrix.Cells[I, J].MatrixName;
                if S <> '' then
                  S := '_' + S;
              end
              else
                S := '#NoObject#';

              Node := twMatrix.Items.AddChild(ANode, Format('Cell%s(%d,%d)', [S, I+1, J+1]));
              Node.Data := AMatrix.Cells[I, J];

              WriteChildNodes(Node);
            end;
        end;

      end else if AMatrix.IsChar then
      begin
        ANode.ImageIndex := 4;
        ANode.SelectedIndex := 4;
      end else
      begin // Если обычный числовой массив
        ANode.ImageIndex := 2;
        ANode.SelectedIndex := 2;
      end;
    finally
      AList.Free;
    end;

  end;

var
  CanExpand: Boolean;
begin

  twMatrix.Items.BeginUpdate;

  try
    if ABaseNode = nil then
    begin
      twMatrix.Items.Clear;

      ABaseNode := twMatrix.Items.AddChild(nil, Base.MatrixName);
      ABaseNode.Data := Base;
      BaseTreeNode := ABaseNode;
      CanExpand := True;
    end else
    begin
      CanExpand := ABaseNode.Expanded;
      ABaseNode.DeleteChildren;
    end;

    WriteChildNodes(ABaseNode);

  finally
    twMatrix.Items.EndUpdate;
  end;

  if CanExpand then
    ABaseNode.Expand(False);
end;

procedure TMainForm.rgToMatlabNameTypeClick(Sender: TObject);
begin
  edToMatlabMatrixName.Enabled := rgToMatlabNameType.ItemIndex = 1;
  if edToMatlabMatrixName.Enabled then
  begin
    edToMatlabMatrixName.Color := clWindow;
    edToMatlabMatrixName.SetFocus;
  end
  else
    edToMatlabMatrixName.Color := clInactiveCaption;
end;

procedure TMainForm.sbEditFormatClick(Sender: TObject);
begin
  if ShowEditFormatForm then
    LoadFormatList;
end;

procedure TMainForm.seChartRowNumChange(Sender: TObject);
begin
  btnDiag.Click;
end;

procedure TMainForm.seChartRowNumKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnDiag.Click;
end;

procedure TMainForm.FillCategoryList;
var
  ActiveNode: TTreeNode;
  I: Integer;
begin
  // Отключаем видимость вкладок
  for I := 0 to PageControl1.PageCount - 1 do
    PageControl1.Pages[I].TabVisible := False;

  twCateg.Items.Clear;
  ActiveNode := twCateg.Items.AddChildObject(nil, 'Операции с массивом', Pointer(1));
  twCateg.Items.AddChildObject(nil, 'Статистика', Pointer(2));
  twCateg.Items.AddChildObject(nil, 'Обработка сигналов', Pointer(7));
  twCateg.Items.AddChildObject(nil, 'Диаграмма', Pointer(3));
  twCateg.Items.AddChildObject(nil, 'Параметры', Pointer(4));
  twCateg.Items.AddChildObject(nil, 'Взаимодействие с Matlab', Pointer(5));
  twCateg.Items.AddChildObject(nil, 'Blas, Lapack', Pointer(6));

  twCateg.FullExpand;

  // Делаем вкладку ActiveNode активной
  twCateg.Selected := ActiveNode;
  twCateg.OnChange(nil, nil);
end;

procedure TMainForm.FillFloatFuncList;
begin
  FloatFuncList.Clear;

  FloatFuncList.AddObject('Round', TObject(@fncRound));
  FloatFuncList.AddObject('Trunc', TObject(@fncTrunc));
  FloatFuncList.AddObject('Int', TObject(@fncInt));
  FloatFuncList.AddObject('Frac', TObject(@fncFrac));
  FloatFuncList.AddObject('Sqrt', TObject(@fncSqrt));
  FloatFuncList.AddObject('Sqr', TObject(@fncSqr));
  FloatFuncList.AddObject('Abs', TObject(@fncAbs));
  FloatFuncList.AddObject('Neg', TObject(@fncNeg));
  FloatFuncList.AddObject('Exp', TObject(@fncExp));
  FloatFuncList.AddObject('Sign', TObject(@fncSign));


  FloatFuncList.AddObject('Log10', TObject(@fncLog10));
  FloatFuncList.AddObject('Log2', TObject(@fncLog2));
  FloatFuncList.AddObject('LnXP1', TObject(@fncLnXP1));

  FloatFuncList.AddObject('Sin', TObject(@fncSin));
  FloatFuncList.AddObject('Cos', TObject(@fncCos));
  FloatFuncList.AddObject('Tan', TObject(@fncTan));
  FloatFuncList.AddObject('Cotan', TObject(@fncCotan));
  FloatFuncList.AddObject('Secant', TObject(@fncSecant));
  FloatFuncList.AddObject('Cosecant', TObject(@fncCosecant));

  FloatFuncList.AddObject('Arcsin', TObject(@fncArcsin));
  FloatFuncList.AddObject('Arccos', TObject(@fncArccos));

  FloatFuncList.AddObject('Cosh', TObject(@fncCosh));
  FloatFuncList.AddObject('Sinh', TObject(@fncSinh));
  FloatFuncList.AddObject('Tanh', TObject(@fncTanh));
  FloatFuncList.AddObject('CotH', TObject(@fncCotH));
  FloatFuncList.AddObject('SecH', TObject(@fncSecH));
  FloatFuncList.AddObject('CscH', TObject(@fncCscH));
  FloatFuncList.AddObject('ArcCot', TObject(@fncArcCot));
  FloatFuncList.AddObject('ArcSec', TObject(@fncArcSec));
  FloatFuncList.AddObject('ArcCsc', TObject(@fncArcCsc));
  FloatFuncList.AddObject('ArcCosh', TObject(@fncArcCosh));
  FloatFuncList.AddObject('ArcSinh', TObject(@fncArcSinh));
  FloatFuncList.AddObject('ArcTanh', TObject(@fncArcTanh));
  FloatFuncList.AddObject('ArcCotH', TObject(@fncArcCotH));
  FloatFuncList.AddObject('ArcSecH', TObject(@fncArcSecH));
  FloatFuncList.AddObject('ArcCscH', TObject(@fncArcCscH));

  FloatFuncList.AddObject('Not', TObject(@fncNot));
  FloatFuncList.AddObject('None', TObject(@fncNone));
end;

procedure TMainForm.FillFloatOpList;
begin
  FloatOpList.AddObject('Sum', TObject(@opSum));
  FloatOpList.AddObject('Sub', TObject(@opSub));
  FloatOpList.AddObject('Mul', TObject(@opMul));
  FloatOpList.AddObject('Div', TObject(@opDiv));
  FloatOpList.AddObject('TruncDiv', TObject(@opTruncDiv));
  FloatOpList.AddObject('Power', TObject(@opPower));
  FloatOpList.AddObject('EQ', TObject(@opEQ));
  FloatOpList.AddObject('NE', TObject(@opNE));
  FloatOpList.AddObject('LT', TObject(@opLT));
  FloatOpList.AddObject('GT', TObject(@opGT));
  FloatOpList.AddObject('LE', TObject(@opLE));
  FloatOpList.AddObject('GE', TObject(@opGE));
  FloatOpList.AddObject('And', TObject(@opAnd));
  FloatOpList.AddObject('Or', TObject(@opOr));
  FloatOpList.AddObject('Xor', TObject(@opXor));
  //FloatOpList.AddObject('', TObject(@));

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IniObject.WriteInteger('VALUEFORMAT', 'SelIndex', cbFormat.ItemIndex);
  IniObject.WriteInteger('POSITION', 'panMatrixInfo_Height', panMatrixInfo.Height);
  IniObject.WriteInteger('POSITION', 'panMatrixTree_Height', panMatrixTree.Height);

  if MainForm.WindowState = wsNormal then
  begin
    IniObject.WriteInteger('POSITION', 'MainForm_Height', MainForm.Height);
    IniObject.WriteInteger('POSITION', 'MainForm_Width', MainForm.Width);
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  if cbAutoSaveWorkspace.Checked then
    Base.SaveWorkspace(edWorkspaceFileName.Text, True);
  CanClose := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
//memo1.Text := DoFloatToStr(-1.00E-11);
  Matrix32.SetFloatToStringFunction(DoFloatToStr);
//
  {TByteMatrix.Create(Base, 'Byte');
  TRecordMatrix.Create(Base, 'Record');

  Base['Record'].Fields['F1'] := TIntegerMatrix.Create();
  Base['Record'].Fields['C1'] := TCellMatrix.Create();

  Base['Record'].Fields['F1'] := TRecordMatrix.Create();
  Base['Record'].Fields['F1'].Fields['F1'] := TByteMatrix.Create(); }

  FillCategoryList;

  FloatFuncList := TStringList.Create;
  FillFloatFuncList;
  cbFuncList.Items.Assign(FloatFuncList);
  cbFuncList.ItemIndex := 0;

  FloatOpList := TStringList.Create;
  FillFloatOpList;
  cbOpList.Items.Assign(FloatOpList);
  cbOpList.ItemIndex := 0;

  LoadFormatList;

  cbAutoSaveWorkspace.Checked := IniObject.ReadBool('GLOBAL', 'AutoSaveWorkspace', False);

  edWorkspaceFileName.Text :=
    IniObject.ReadString('GLOBAL', 'WorkspaceFileName', AppPath + 'Workspace.bin');

  MainForm.Height := IniObject.ReadInteger('POSITION', 'MainForm_Height', MainForm.Height);
  MainForm.Width := IniObject.ReadInteger('POSITION', 'MainForm_Width', MainForm.Width);
  panMatrixInfo.Height := IniObject.ReadInteger('POSITION', 'panMatrixInfo_Height', panMatrixInfo.Height);
  panMatrixTree.Height := IniObject.ReadInteger('POSITION', 'panMatrixTree_Height', panMatrixTree.Height);

  if cbAutoSaveWorkspace.Checked then
    if FileExists(edWorkspaceFileName.Text) then
      Base.LoadWorkspace(edWorkspaceFileName.Text);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FloatFuncList.Free;
  FloatOpList.Free;
end;

procedure LoadNetData;
begin

end;


procedure TMainForm.Button10Click(Sender: TObject);
var
  Op: TFloatOperation;
begin
  Op := TFloatOperation(cbOpList.Items.Objects[cbOpList.ItemIndex]);
  M3.CalcOperation([M1, M2], Op);
  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button11Click(Sender: TObject);
begin
  BlasMulMatrices(M1, M2, M3);
  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button12Click(Sender: TObject);
begin
  LapackLUFactorization(M1, M2, M3);
  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button13Click(Sender: TObject);
var
  V: Extended;
begin
  M1.CheckForNumeric;
  M2.CheckForNumeric;

  V := LapackDeterminant(M1);
  M2.Resize([0]);
  M2.Value := V;
  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button14Click(Sender: TObject);
begin
  M1.CheckForNumeric;
  M2.CheckForNumeric;
  M3.CheckForNumeric;
  LapackSolveSLE(M1, M2, M3);
  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button15Click(Sender: TObject);
begin
  M1.CheckForNumeric;
  M2.CheckForNumeric;

  LapackInverseMatrix(M1, M2);

  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button16Click(Sender: TObject);
begin
  M1.CheckForNumeric;
  M2.CheckForNumeric;
  StretchRows(M1, M2, seScalePoints.Value);
  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button17Click(Sender: TObject);
var
  MinValue, MaxValue: Extended;
  MinIndex, MaxIndex: Integer;
begin
  M1.GetMinMaxValues(@MinValue, @MaxValue, @MinIndex, @MaxIndex);

  labMinElem.Caption := DoFloatToStr(MinValue);
  labMaxElem.Caption := DoFloatToStr(MaxValue);

  labMinIndex.Caption := IntToStr(MinIndex);
  labMaxIndex.Caption := IntToStr(MaxIndex);
end;

procedure TMainForm.Button18Click(Sender: TObject);
var
  Ar: array of TMatrix;
  Dim: Integer;
begin
  if M1 = M2 then
    raise Exception.Create('Укажите другой массив в качестве М2!');

  SetLength(Ar, 6);
  Ar[cbStatInfoType.ItemIndex] := M2;

  if rgStatDim.ItemIndex = 0 then
    Dim := M1.DimRows
  else
    Dim := M1.DimCols;

  M1.GetMinMaxMean(Dim, Ar[0], Ar[1], Ar[2], Ar[3], Ar[4], Ar[5]);
  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button19Click(Sender: TObject);
var
  Res, MinMax: TMatrix;
  V: Extended;
  I, J: Integer;
  Factor: Integer;
begin
  M1.CheckForNumeric;
  M2.CheckForNumeric;

  if M2.DimensionCount > 2 then
    raise Exception.Create('Слишком большая размерность!');

  Factor := seNormSignal.Value;

  Res := M2.CreateInstance();
  try
    MinMax := M1.CreateInstance(Res);
    M1.GetMinMaxMean(M1.DimCols, nil, nil, MinMax);

    Res.CopyFrom(M1);

    if Res.DimensionCount = 1 then
    begin
      V := Max(Abs(MinMax.VecElem[0]), Abs(MinMax.VecElem[1]));
      for I := 0 to Res.ElemCount - 1 do
      begin
        if V = 0 then
          Res.VecElem[I] := 0
        else
          Res.VecElem[I] := Res.VecElem[I] * Factor / V;
      end;
    end else
    begin
      for I := 0 to Res.Rows - 1 do
      begin
        V := Max(Abs(MinMax.Elem[I, 0]), Abs(MinMax.Elem[I, 1]));
        for J := 0 to Res.Cols - 1 do
        begin
          if V = 0 then
            Res.Elem[I, J] := 0
          else
            Res.Elem[I, J] := Res.Elem[I, J] * Factor / V;
        end;
      end;
    end;

    M2.MoveFrom(Res);
    twMatrixClick(twMatrix);
  finally
    Res.FreeMatrix;
  end;
//
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  memoMatlabCommandHistory.Clear;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  if M1.IsNumeric then
  begin
    if rbStep.Checked then
      M1.FillByStep(seFillStart.Value, seFillStep.Value)
    else if rbFinish.Checked then
      M1.FillByStep2(seFillStart.Value, seFillStep.Value)
    else
      M1.Rand(seFillStep.Value);

    twMatrixClick(twMatrix);
  end
  else
    ShowMessage('ОШИБКА! Объект не является числовым массивом!');
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edWorkspaceFileName.Text := OpenDialog1.FileName;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  if M1.IsDynamic and M2.IsDynamic then
  begin
    M2.Transpose(M1);
    twMatrixClick(twMatrix);
  end
  else
    ShowMessage('ОШИБКА! Объект не является массивом!');
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  M2.CopyFrom(M1);
  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  M2.MoveFrom(M1);
  twMatrixClick(twMatrix);
end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
  M3.MulMatrices([M1, M2]);
  twMatrixClick(twMatrix);
end;

{Передаточная функия.  Hyperbolic tangent sigmoid transfer function.
 Формула: n = 2/(1+exp(-2*n))-1}
procedure CalcTanSigEx(AMatrix, AResult: TMatrix);
var
  TempMatrix: TMatrix;
begin
  try
    CheckForMatrixTypes([AMatrix, AResult], [mtNumeric]);

    TempMatrix := TExtendedMatrix.Create();
    try
      TempMatrix.ValueOperation(-0.1, AMatrix, opMul);
      TempMatrix.CalcFunction(TempMatrix, fncExp);
     // TempMatrix.ValueOperation(1, TempMatrix, opSum);
      TempMatrix.ValueOperation(20, TempMatrix, opDiv);
      //TempMatrix.ValueOperation(TempMatrix, 1, opSub);
      AResult.MoveFrom(TempMatrix);
    finally
      TempMatrix.FreeMatrix;
    end;
  except
    on E: Exception do
      raise {$IFDEF RecreateEObj}MatrixReCreateExceptObj(E, 'procedure CalcTanSig'){$ENDIF}
  end;
end;

procedure TMainForm.btnPresaveResizeClick(Sender: TObject);
begin
  if M1.IsDynamic then
  begin
    if (seMatrixRows.Value < 1) then
      raise Exception.Create('Недопустимое значение размеров!')
    else
    if seMatrixCols.Value = 0 then
    begin
      M1.PreservResize([seMatrixRows.Value]);
    end else
    begin
      M1.PreservResize([seMatrixRows.Value, seMatrixCols.Value])
    end;
    twMatrixClick(twMatrix);
  end
  else
    ShowMessage('ОШИБКА! Объект не является массивом!');
end;

procedure TMainForm.btnPutToMatlabClick(Sender: TObject);
var
  MName: string;
begin
  if rgToMatlabNameType.ItemIndex = 0 then
  begin
    MName := TryGetSelectedMatrixName;
  end else
    MName := edToMatlabMatrixName.Text;

  if Trim(MName) = '' then
    raise Exception.Create('Имя объекта не задано');

  Matlab.PutMatrix(FCurMatrix, MName);
end;

procedure TMainForm.btnReshapeClick(Sender: TObject);
begin
  if M1.IsDynamic then
  begin
    if (seMatrixRows.Value < 1) or (seMatrixCols.Value < 0) then
      raise Exception.Create('Недопустимое значение размеров!')
    else
    if seMatrixCols.Value = 0 then
    begin
      if M1.ElemCount = seMatrixRows.Value then
        M1.Reshape([seMatrixRows.Value])
      else
        raise Exception.Create('Число элементов должно оставаться прежним!')
    end else
    begin
      if M1.ElemCount = seMatrixRows.Value * seMatrixCols.Value then
        M1.Reshape([seMatrixRows.Value, seMatrixCols.Value])
      else
        raise Exception.Create('Число элементов должно оставаться прежним!')
    end;
    twMatrixClick(twMatrix);
  end
  else
    ShowMessage('ОШИБКА! Объект не является массивом!');
end;

procedure TMainForm.btnDiagClick(Sender: TObject);
var
  I: Integer;
begin
  if CurMatrix.IsNumeric then
  begin
    Series1.Clear;

    Chart1.Title.Text.Text := CurMatrix.MatrixName;

    if rbChartFromRow.Checked then
    begin
      for I := 0 to CurMatrix.Cols - 1 do
        Series1.Add(CurMatrix.Elem[seChartRowNum.Value - 1, I]);
    end else
    begin
      for I := 0 to CurMatrix.Rows - 1 do
        Series1.Add(CurMatrix.Elem[I, seChartRowNum.Value - 1]);
    end;

  end else
    ShowMessage('ОШИБКА! Объект не является числовым массивом!');
end;

procedure TMainForm.btnExecuteMatlabCommandClick(Sender: TObject);
var
  Res: string;
begin
  Res := Matlab.Execute(memoMatlabCommand.Text, False);
  memoMatlabCommandHistory.Lines.Add('==============================');
  memoMatlabCommandHistory.Lines.Add('>>Команда: ');
  memoMatlabCommandHistory.Text := memoMatlabCommandHistory.Text + Trim(memoMatlabCommand.Text);
  memoMatlabCommandHistory.Lines.Add('');
  memoMatlabCommandHistory.Lines.Add('');
  memoMatlabCommandHistory.Lines.Add('>>Результат: ');
  memoMatlabCommandHistory.Lines.Add('');
  memoMatlabCommandHistory.Text := memoMatlabCommandHistory.Text + TrimRight(Res);
  memoMatlabCommandHistory.SelStart := Length(memoMatlabCommandHistory.Text);
  memoMatlabCommandHistory.SelLength := 1;
  if cbAutoClearMatlabCommand.Checked then
    memoMatlabCommand.Clear;
  memoMatlabCommand.SetFocus;
end;

procedure TMainForm.btnSaveParamsClick(Sender: TObject);
begin
  IniObject.WriteBool('GLOBAL', 'AutoSaveWorkspace', cbAutoSaveWorkspace.Checked);
  IniObject.WriteString('GLOBAL', 'WorkspaceFileName', edWorkspaceFileName.Text);
end;

{ TMyClass }

constructor TMyClass.Create;
begin
  with TByteMatrix.Create do
    AssignPointers([@FMyVar]);
end;

destructor TMyClass.Destroy;
begin
  FMyVar.FreeMatrix;
  inherited;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  RefreshMatrixTree;

  labObjCount.Caption := IntToStr(MatrixObjectCounter);

  if Assigned(BaseTreeNode) then
    twMatrix.Selected := BaseTreeNode;
end;


function TMainForm.GetCellStrInfo(M: TMatrix): string;
var
  S: string;
begin
  if Assigned(M) then
  begin
    if M.IsRecord then
      S := IntToStr(M.FieldCount)
    else
      S := FastStringReplace(DimValuesToString(M.GetDimensions), ' ', '');

    Result := Format('%s(%s)', [string(M.GetAlias), S]);
  end
  else
    Result := 'NoObject';
end;

function TMainForm.GetRecordStrInfo(Rec: TMatrix; FieldIndex: Integer): string;
var
  S, SValue: string;
  M: TMatrix;
begin
  if Assigned(Rec) then
  begin
    M := Rec.FieldByIndex(FieldIndex);
    if M.IsRecord then
      S := IntToStr(M.FieldCount)
    else
      S := FastStringReplace(DimValuesToString(M.GetDimensions), ' ', '');

    if M.IsNumeric then
      if M.ElemCount = 1 then
      begin
        if M.IsChar then
          SValue := M.VecChar[0]
        else if M.IsInteger then
          SValue := IntToStr(M.ValueI)
        else if M.IsInt64 then
          SValue := IntToStr(M.ValueI64)
        else
          SValue := M.ValueStr;

        SValue := '=' + SValue;
      end;

    Result := Format('%s: %s(%s)%s', [Rec.FieldName(FieldIndex), string(M.GetAlias), S, SValue]);
  end
  else
    Result := 'NoObject';
end;

function TMainForm.InputSizeValue(AText: string; var AValue: Integer): Boolean;
var
  S: string;
  V: Integer;
begin
  Result := False;
  S := IntToStr(AValue);
  if not InputQuery('Введите значение', AText, S) then Exit;

  while (not TryStrToInt(S, V)) or (V < 0) do
  begin
    if not InputQuery('Введите ПРАВИЛЬНОЕ значение!', AText, S) then Exit;
  end;

  AValue := V;
  Result := True;
end;

procedure TMainForm.labDelFromM2Click(Sender: TObject);
begin
  if Assigned(FM2) then
  begin
    FM2 := nil;
    twMatrixClick(twMatrix);
  end;

end;

procedure TMainForm.labDelFromM3Click(Sender: TObject);
begin
  if Assigned(FM3) then
  begin
    FM3 := nil;
    twMatrixClick(twMatrix);
  end;

end;

procedure TMainForm.labDelFromM1Click(Sender: TObject);
begin
  if Assigned(FM1) then
  begin
    FM1 := nil;
    twMatrixClick(twMatrix);
  end;
end;

function TMainForm.GetCellText(ACol, ARow: Integer): string;
var
  S: string;
begin
  S := '';
  if FCurMatrix.IsLiving and (FCurMatrix.IsNumeric or FCurMatrix.IsCell or FCurMatrix.IsRecord) and
    (FCurMatrix.DimensionCount < 3) then
  begin
    if FCurMatrix.IsRecord then
    begin
      if FCurMatrix.FieldCount >= ARow then
      begin
        S := GetRecordStrInfo(FCurMatrix, ARow - 1)
      end;
    end else
    begin
      if FCurMatrix.DimensionCount = 1 then
      begin
        if FCurMatrix.ElemCount >= ACol then
        begin
          if FCurMatrix.IsChar then
            S := FCurMatrix.VecChar[ACol - 1]
          else if FCurMatrix.IsNumeric then
            S := FCurMatrix.VecElemStr[ACol - 1]
          else if FCurMatrix.IsCell then
          begin
            S := GetCellStrInfo(FCurMatrix.VecCells[ACol - 1]);
          end;
        end;
      end else if FCurMatrix.DimensionCount = 2 then
      begin
        if (FCurMatrix.Rows >= ARow) and (FCurMatrix.Cols >= ACol) then
        begin
          if FCurMatrix.IsChar then
            S := FCurMatrix.ElemChar[ARow - 1, ACol - 1]
          else if FCurMatrix.IsNumeric then
            S := FCurMatrix.ElemStr[ARow - 1, ACol - 1]
          else
          begin
            S := GetCellStrInfo(FCurMatrix.Cells[ARow - 1, ACol - 1]);
          end;
        end;
      end;
    end;


  end;

  Result := S;
end;

procedure TMainForm.seColWidthChange(Sender: TObject);
var
  W: Integer;
begin
  W := dgElems.ColWidths[0];
  dgElems.DefaultColWidth := seColWidth.Value;
  dgElems.ColWidths[0] := W;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  if FCurMatrix.IsLiving then
  begin
    FM1 := FCurMatrix;
    labM1.Caption := Format('%s: %s', [TryGetSelectedMatrixName, string(FM1.GetAlias)]);
    labM1.Font.Color := clBlack;
  end;
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  if FCurMatrix.IsLiving then
  begin
    FM2 := FCurMatrix;
    labM2.Caption := Format('%s: %s', [TryGetSelectedMatrixName, string(FM2.GetAlias)]);
    labM2.Font.Color := clBlack;
  end;
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
  if FCurMatrix.IsLiving then
  begin
    FM3 := FCurMatrix;
    labM3.Caption := Format('%s: %s', [TryGetSelectedMatrixName, string(FM3.GetAlias)]);
    labM3.Font.Color := clBlack;
  end;
end;

function TMainForm.M1: TMatrix;
begin
  if Assigned(FM1) then
    Result := FM1
  else
    Result := FCurMatrix;

  if not Result.IsLiving then
    raise Exception.Create('Массив-источник не выбран!');
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  labObjCount.Caption := IntToStr(MatrixObjectCounter);
end;

function TMainForm.TryGetSelectedMatrixName: string;
begin
  Result := '';
  if FCurMatrix.IsLiving then
  begin
    Result := FCurMatrix.MatrixName;
    if Result = '' then
      Result := twMatrix.Selected.Text;
  end;
end;

procedure TMainForm.LoadFormatList;
var
  Index: Integer;
begin

  FillFormatList(cbFormat.Items);

  Index := IniObject.ReadInteger('VALUEFORMAT', 'SelIndex', 0);
  if cbFormat.Items.Count > Index then
    cbFormat.ItemIndex := Index;

  ApplySelectedFormat;
end;

const
  MatlabCommands =
    '#break#case #catch #continue#else#elseif#end#'+
    'for #if #otherwise#parfor#return#switch#try#while #';

procedure TMainForm.memoMatlabCommandKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  S: string;
  CanExecute: Boolean;
  AList: TStringList;
  I: Integer;
begin
  if Key = VK_RETURN then
  begin
    S := AnsiLowerCase(memoMatlabCommand.Text);
    CanExecute := True;

    AList := TStringList.Create;
    try
      AList.Text := FastStringReplace(MatlabCommands, '#', #13#10);
      for I := 0 to AList.Count - 1 do
        if (Pos(AList[I], S) > 0) then
        begin
          CanExecute := False;
          Break;
        end;
    finally
      AList.Free;
    end;
    if CanExecute then
      btnExecuteMatlabCommand.Click;
  end;
end;

procedure TMainForm.twCategChange(Sender: TObject; Node: TTreeNode);
var
  ATag, I: Integer;
begin
  if Assigned(twCateg.Selected) then
  begin
    ATag := Integer(twCateg.Selected.Data);
    if ATag > 0 then
    begin
      for I := 0 to PageControl1.PageCount - 1 do
        if PageControl1.Pages[I].Tag = ATag then
        begin
          PageControl1.ActivePageIndex := I;
          panCategTitle.Parent := PageControl1.Pages[I];
          panCategTitle.Caption := twCateg.Selected.Text;
          Break;
        end;
    end;
  end;
end;

procedure TMainForm.twMatrixChange(Sender: TObject; Node: TTreeNode);
begin
  twMatrixClick(twMatrix);
end;

procedure TMainForm.twMatrixClick(Sender: TObject);
var
  I: Integer;
  S, WStr: string;
  M: TMatrix;
begin
  FCurMatrix := nil;
  lbMatrixInfo.Caption := '';
  if Assigned(twMatrix.Selected) then
  begin
    M := TMatrix(twMatrix.Selected.Data);

    FCurMatrix := M;

    WStr := '000';

    if M.IsLiving then
    begin
      // На всякий случай обнуляем ссылки на M1 и M2
      if not FM1.IsLiving then
        FM1 := nil;

      if not FM2.IsLiving then
        FM2 := nil;

      if not FM3.IsLiving then
        FM3 := nil;

      if FM1 = nil then
      begin
        labM1.Caption := Format('%s: %s', [TryGetSelectedMatrixName, string(FCurMatrix.GetAlias)]);
        labM1.Font.Color := clGray;
      end;

      if FM2 = nil then
      begin
        labM2.Caption := Format('%s: %s', [TryGetSelectedMatrixName, string(FCurMatrix.GetAlias)]);
        labM2.Font.Color := clGray;
      end;

      if FM3 = nil then
      begin
        labM3.Caption := Format('%s: %s', [TryGetSelectedMatrixName, string(FCurMatrix.GetAlias)]);
        labM3.Font.Color := clGray;
      end;



      S := '';
      if M.IsRecord then
      begin
        S := 'Число полей: ' + IntToStr(M.FieldCount);
      end else if M.IsCell or M.IsNumeric then
      begin
        S := Format('Размерность: (%s)', [FastStringReplace(DimValuesToString(M.GetDimensions), ' ', '')]);
      end else if M.IsWorkspace then
      begin
        S := 'Число объектов: ' + IntToStr(M.MatrixCount);
      end;

      btnReshape.Enabled := M.IsCell or M.IsNumeric;
      btnPresaveResize.Enabled := btnReshape.Enabled;

      if btnReshape.Enabled then
      begin
        if M.DimensionCount = 2 then
        begin
          seMatrixRows.Value := M.Rows;
          seMatrixCols.Value := M.Cols;
        end else
        begin
          seMatrixRows.Value := M.ElemCount;
          seMatrixCols.Value := 0;
        end;
      end;

      lbMatrixInfo.Caption := Format('Имя: %s; Тип: %s; %s; Память: %d байт',
        [twMatrix.Selected.Text, M.GetAlias, S, M.MatrixSize]);

      if (M.IsNumeric or M.IsCell) and (M.DimensionCount < 3) then
      begin
        if M.DimensionCount = 1 then
        begin
          dgElems.RowCount := 2;
          dgElems.ColCount := M.Cols + 1;
        end else if M.DimensionCount = 2 then
        begin
          dgElems.RowCount := M.Rows + 1;
          dgElems.ColCount := M.Cols + 1;
        end else if M.IsEmpty then
        begin
          dgElems.RowCount := 2;
          dgElems.ColCount := 2;
        end;

        // Определяем размер первого столбца
        S := IntToStr(dgElems.RowCount);
        dgElems.ColWidths[0] := dgElems.Canvas.TextWidth(S + 'W');

        // Перебираем элементы массива и ищем самый "широкий"

        // Ищем среди первых 500 элементов
        for I := 0 to Min(M.ElemCount, 500) - 1 do
        begin
          if M.IsChar then
            S := M.VecChar[I]
          else if M.IsNumeric then
            S := M.VecElemStr[I]
          else if M.IsCell then
            S := GetCellStrInfo(M.VecCells[I]);

          if Length(S) > Length(WStr) then
            WStr := S;
        end;

        // Ищем среди последних 500 элементов
        if M.ElemCount > 500 then
        begin
          for I := Max(M.ElemCount - 500, 500) to M.ElemCount - 1 do
          begin
            if M.IsChar then
              S := M.VecChar[I]
            else if M.IsNumeric then
              S := M.VecElemStr[I]
            else if M.IsCell then
              S := GetCellStrInfo(M.VecCells[I]);

            if Length(S) > Length(WStr) then
              WStr := S;
          end;
        end;

      end else if M.IsRecord then
      begin
        if M.FieldCount = 0 then
          dgElems.RowCount := 2
        else
          dgElems.RowCount := M.FieldCount + 1;
        dgElems.ColCount := 2;
        for I := 0 to M.FieldCount - 1 do
        begin
          S := GetRecordStrInfo(M, I);
          if Length(S) > Length(WStr) then
            WStr := S;
        end;
      end else
      begin
        // Сбрасываем размеры массива
        dgElems.RowCount := 2;
        dgElems.ColCount := 2;
      end;

      if M.IsChar then
        WStr := 'W';

    end else
    begin
      // Сбрасываем размеры массива
      dgElems.RowCount := 2;
      dgElems.ColCount := 2;
    end;

    seColWidth.Value := dgElems.Canvas.TextWidth(WStr + 'WW');
    dgElems.Repaint;
  end;
end;

procedure TMainForm.twMatrixDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  SourMatrix, SourParentMatrix, DestMatrix: TMatrix;
  DestNode: TTreeNode;
begin
  Accept := CanDragMatrix(Sender, X, Y, SourMatrix, SourParentMatrix, DestMatrix, DestNode);
end;

procedure TMainForm.twMatrixEdited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  M, MParent: TMatrix;
  ParentNode: TTreeNode;
begin
  M := TMatrix(Node.Data);
  if M.IsLiving then
  begin
    // Препятствуем изменению имени рабочей области
    if M.IsWorkspace then Abort;

    ParentNode := Node.Parent;
    if Assigned(ParentNode) then
      MParent := TMatrix(ParentNode.Data)
    else
      MParent := nil;

    if MParent.IsLiving and MParent.IsRecord then
    begin
      M.MatrixName := S; // В случае чего автоматически сработает проверка
      MParent.Fields[S] := M;
    end else
    begin
      M.MatrixName := S;
    end;
  end;
end;

procedure TMainForm.twMatrixEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
var
  M: TMatrix;
begin
  M := TMatrix(Node.Data);
  if M.IsLiving then
  begin
    // Препятствуем изменению имени рабочей области
    if M.IsWorkspace then
      AllowEdit := False;
  end;
end;

procedure TMainForm.twMatrixEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  SourMatrix, SourParentMatrix, DestMatrix: TMatrix;
  I: Integer;
  SName, SFielsName: string;
  DestNode: TTreeNode;
begin
  if not CanDragMatrix(Target, X, Y, SourMatrix, SourParentMatrix, DestMatrix, DestNode) then
    Exit;

  if Application.MessageBox(
    'Вы уверены, что хотите переместить массив?', 'Внимание!',
    MB_ICONQUESTION or MB_OKCANCEL) = IDCANCEL then Exit;

  // Определяем имя массива
  if SourParentMatrix.IsLiving and SourParentMatrix.IsRecord then
  begin
    SFielsName := '';
    for I := 0 to SourParentMatrix.FieldCount - 1 do
      if SourParentMatrix.FieldByIndex(I) = SourMatrix then
      begin
        SFielsName := SourParentMatrix.FieldName(I);
        Break;
      end;

    SName := SFielsName;
  end else
  begin
    SName := SourMatrix.MatrixName;
  end;

  if SName = '' then
    SName := GenMatrixName;

  if DestMatrix.IsRecord or DestMatrix.IsWorkspace then
    SourMatrix.OwnerMatrix := nil;

  // Если результирующий массив - это запись, то
  if DestMatrix.IsRecord then
  begin
    DestMatrix.Fields[SName] := SourMatrix;
  end else if DestMatrix.IsWorkspace then
  begin
    SourMatrix.MatrixName := SName;
    SourMatrix.OwnerMatrix := DestMatrix;
  end else if DestMatrix.IsCell then
  begin
    if ShowMoveToCellForm(SourMatrix, DestMatrix) then
    begin
      SourMatrix.MatrixName := SName;
      SourMatrix.OwnerMatrix := nil;
    end else // Иначе выходим
      Exit;
  end;

  // Если старый родительский объект - это массив ячеек
  if SourParentMatrix.IsCell then
  begin
    for I := 0 to SourParentMatrix.ElemCount - 1 do
      if SourParentMatrix.VecCells[I] = SourMatrix then
        SourParentMatrix.VecCells[I] := nil;
  end else if SourParentMatrix.IsRecord then
  begin // Если старый объект - это запись
    // Удаляем массив из списка полей записи
    if SFielsName <> '' then
      SourParentMatrix.Fields[SFielsName] := nil;
  end;

  // Обновляем исходный родительский узел
  if DestMatrix.IsWorkspace or SourParentMatrix.IsWorkspace then
  begin
    RefreshMatrixTree;
  end else
  begin
    if DestNode.HasAsParent(twMatrix.Selected.Parent) then
      RefreshMatrixTree(twMatrix.Selected.Parent)
    else if twMatrix.Selected.Parent.HasAsParent(DestNode) then
      RefreshMatrixTree(DestNode)
    else
    begin // Независимое обносление веток
      RefreshMatrixTree(twMatrix.Selected.Parent);
      RefreshMatrixTree(DestNode);
    end;
  end;
  //

  //TRecordMatrix.Create().FieldCount;


  //ShowMessage('twMatrixEndDrag');
end;

procedure TMainForm.twMatrixKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F2 then
  begin
    if Assigned(twMatrix.Selected) then
      TreeView_EditLabel(twMatrix.Handle, twMatrix.Selected.ItemId);
  end else if (Key = VK_DELETE) and (not twMatrix.IsEditing) then
  begin
    acDeleteMatrix.Execute;
  end;
end;

procedure TMainForm.Button8Click(Sender: TObject);
var
  MatlabObjectName: string;
  OtherMatrixObjectName: string;
begin
  MatlabObjectName := edMatlabObjectName.Text;
  if cbOtherMatrixObjectName.Checked then
    OtherMatrixObjectName := edOtherMatrixObjectName.Text
  else
    OtherMatrixObjectName := StrSameName;

  Matlab.GetMatrix(MatlabObjectName, OtherMatrixObjectName).OwnerMatrix := Base;
  RefreshMatrixTree;
end;

procedure TMainForm.Button9Click(Sender: TObject);
var
  Func: TFloatFunction;
begin
  Func := TFloatFunction(cbFuncList.Items.Objects[cbFuncList.ItemIndex]);
  M2.CalcFunction(M1, Func);
  twMatrixClick(twMatrix);
end;

function TMainForm.CanDragMatrix(Target: TObject; X, Y: Integer;
  var SourMatrix, SourParentMatrix, DestMatrix: TMatrix; var DestNode: TTreeNode): Boolean;
var
  MTmp: TMatrix;
  TmpNode: TTreeNode;
begin
  Result := False;

  if Target <> twMatrix then Exit;

  if not Assigned(twMatrix.Selected) then Exit;

  SourMatrix := TMatrix(twMatrix.Selected.Data);
  if not SourMatrix.IsLiving then Exit;

  if SourMatrix.IsWorkspace then Exit;

  DestNode := twMatrix.GetNodeAt(X, Y);
  if not Assigned(DestNode) then Exit;

  DestMatrix := TMatrix(DestNode.Data);
  if not DestMatrix.IsLiving then Exit;

  // Результирующий массив должен быть записью / массивом ячеек / рабочей областью
  if not (DestMatrix.IsWorkspace or DestMatrix.IsRecord or DestMatrix.IsCell) then Exit;

  // Определяем владельца исходного объекта
  SourParentMatrix := nil;
  TmpNode := twMatrix.Selected.Parent;
  if Assigned(TmpNode) then
    SourParentMatrix := TMatrix(TmpNode.Data);

  // Отменяем перемещение, если элемент уже итак имеет этого же владельца
  if SourParentMatrix = DestMatrix then Exit;

  // Если результирующий массив имеет в предках массив-источник, то
  // отменяем перемещение
  TmpNode := DestNode;
  MTmp := DestMatrix;
  while MTmp <> nil do
  begin
    if MTmp = SourMatrix then Exit;

    MTmp := nil;
    TmpNode := TmpNode.Parent;
    if Assigned(TmpNode) then
    begin
      MTmp := TMatrix(TmpNode.Data);
    end;
  end;

  Result := True;
end;

procedure TMainForm.cbFormatSelect(Sender: TObject);
begin
  ApplySelectedFormat;
end;

procedure TMainForm.cbOtherMatrixObjectNameClick(Sender: TObject);
begin
  edOtherMatrixObjectName.Enabled := cbOtherMatrixObjectName.Checked;
  if edOtherMatrixObjectName.Enabled then
  begin
    edOtherMatrixObjectName.Color := clWindow;
    edOtherMatrixObjectName.SetFocus;
  end
  else
    edOtherMatrixObjectName.Color := clInactiveCaption;
end;

function TMainForm.CurMatrix: TMatrix;
begin
  if FCurMatrix.IsLiving then
    Result := FCurMatrix
  else
    raise Exception.Create('ОШИБКА! Массив не выбран!');
end;

function TMainForm.M2: TMatrix;
begin
  if Assigned(FM2) then
    Result := FM2
  else
    Result := FCurMatrix;

  if not Result.IsLiving then
    raise Exception.Create('Массив-приемник не выбран!');
end;

function TMainForm.M3: TMatrix;
begin
  if Assigned(FM3) then
    Result := FM3
  else
    Result := FCurMatrix;

  if not Result.IsLiving then
    raise Exception.Create('Массив-приемник не выбран!');
end;

procedure TMainForm.dgElemsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  S, S2: string;
  X: Integer;
begin

  if FCurMatrix.IsLiving and (FCurMatrix.IsNumeric or FCurMatrix.IsCell or FCurMatrix.IsRecord) and
    (FCurMatrix.DimensionCount < 3) then
  begin
    S := '';
    if (ACol = 0) and (ARow = 0) then
      S := ''
    else if ACol = 0 then
      S := IntToStr(ARow)
    else if ARow = 0 then
      S := IntToStr(ACol)
    else
      S := GetCellText(ACol, ARow);

    if S <> '' then
    begin
      Rect.Left := Rect.Left + 1;
      dgElems.Canvas.FillRect(Rect);
      if (ACol = 0) or (ARow = 0) then
        X := Rect.Left + ((Rect.Right - Rect.Left) - dgElems.Canvas.TextWidth(S)) div 2
      else
      begin
        if FCurMatrix.IsCell or FCurMatrix.IsRecord then
        begin
          if FCurMatrix.IsRecord then
          begin
            S2 := Copy(S, Pos(':', S) + 1, MaxByte);
            X := Rect.Right - dgElems.Canvas.TextWidth(S2) - 1;
            dgElems.Canvas.TextOut(X, Rect.Top, S2);

            S := Copy(S, 1, Pos(':', S) - 1);
          end;
          X := Rect.Left;
        end
        else
        begin
          X := Rect.Right - dgElems.Canvas.TextWidth(S) - 1;
          if X < Rect.Left + 1 then
            X := Rect.Left + 1;
        end;
      end;
      dgElems.Canvas.TextOut(X, Rect.Top, S);
    end;
  end;


end;

procedure TMainForm.dgElemsGetEditText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
var
  S: string;
  ARect: TRect;
begin
  S := GetCellText(ACol, ARow);
  if (S <> '') and (not FCurMatrix.IsChar) then
  begin
    if Pos(ThousandSeparator, S) > 0 then
      S := FastStringReplace(S, ThousandSeparator, '');
  end;

  ARect := dgElems.CellRect(ACol, ARow);
  Inc(ARect.Left, 3);
  Inc(ARect.Top, 3);
  Inc(ARect.Right, 3);
  Inc(ARect.Bottom, 3);
  edCellEditor.BoundsRect := ARect;
  // edCellEditor.Left := ARect.Left;
  edCellEditor.Text := S;
  edCellEditor.Visible := True;
  edCellEditor.BringToFront;
  edCellEditor.SetFocus;
  edCellEditor.SelectAll;

  EditingRow := ARow;
  EditingCol := ACol;
  EditingString := S;
end;

procedure TMainForm.edCellEditorExit(Sender: TObject);
begin
  edCellEditor.Visible := False;

  if edCellEditor.Text = EditingString then // Если ничего не изменилось
  begin
    EditingRow := 0;
    EditingCol := 0;
  end;

  EditingString := edCellEditor.Text;
  ApplyEditingValue;
end;

initialization
{$IFDEF DXE3PLUS}
  ThousandSeparator := FormatSettings.ThousandSeparator;
{$ENDIF DXE3PLUS}

end.


