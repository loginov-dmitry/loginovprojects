object PropertyForm: TPropertyForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1101#1083#1077#1084#1077#1085#1090#1072
  ClientHeight = 594
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 553
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 432
      Height = 551
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #1040#1090#1088#1080#1073#1091#1090#1099' '#1101#1083#1077#1084#1077#1085#1090#1099
        object sgAttr: TStringGrid
          Left = 0
          Top = 0
          Width = 424
          Height = 523
          Align = alClient
          ColCount = 2
          DefaultColWidth = 200
          DefaultRowHeight = 20
          FixedCols = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
          TabOrder = 0
          OnDrawCell = sgStyleDrawCell
          OnEnter = sgStyleEnter
          OnSelectCell = sgStyleSelectCell
          RowHeights = (
            20
            20
            20
            20
            20)
        end
      end
      object TabSheet2: TTabSheet
        Caption = #1057#1090#1080#1083#1080' '#1101#1083#1077#1084#1077#1085#1090#1072
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object sgStyle: TStringGrid
          Left = 0
          Top = 0
          Width = 424
          Height = 523
          Align = alClient
          ColCount = 2
          DefaultColWidth = 200
          DefaultRowHeight = 20
          FixedCols = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
          TabOrder = 0
          OnDrawCell = sgStyleDrawCell
          OnEnter = sgStyleEnter
          OnSelectCell = sgStyleSelectCell
          RowHeights = (
            20
            20
            20
            20
            20)
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 553
    Width = 434
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      434
      41)
    object Label5: TLabel
      Left = 8
      Top = 12
      Width = 75
      Height = 13
      Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100':'
    end
    object btnOk: TButton
      Left = 256
      Top = 6
      Width = 81
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 343
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
    object TrackBar1: TTrackBar
      Left = 96
      Top = 7
      Width = 145
      Height = 27
      Max = 255
      Min = 75
      PageSize = 10
      Frequency = 5
      Position = 255
      TabOrder = 2
      OnChange = TrackBar1Change
    end
  end
end
