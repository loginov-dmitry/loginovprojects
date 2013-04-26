object EditFormatForm: TEditFormatForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1092#1086#1088#1084#1072#1090#1086#1074' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1095#1080#1089#1077#1083
  ClientHeight = 394
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    519
    394)
  PixelsPerInch = 96
  TextHeight = 16
  object SpeedButton1: TSpeedButton
    Left = 16
    Top = 335
    Width = 81
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    OnClick = SpeedButton1Click
    ExplicitTop = 176
  end
  object SpeedButton2: TSpeedButton
    Left = 98
    Top = 335
    Width = 81
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    OnClick = SpeedButton2Click
    ExplicitTop = 176
  end
  object SpeedButton3: TSpeedButton
    Left = 207
    Top = 334
    Width = 58
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #1042#1099#1096#1077
    OnClick = SpeedButton3Click
    ExplicitTop = 175
  end
  object SpeedButton4: TSpeedButton
    Left = 267
    Top = 334
    Width = 58
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = #1053#1080#1078#1077
    OnClick = SpeedButton4Click
    ExplicitTop = 175
  end
  object Panel1: TPanel
    Left = 0
    Top = 360
    Width = 519
    Height = 34
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      519
      34)
    object btnOK: TButton
      Left = 357
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 438
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object sg: TStringGrid
    Left = 13
    Top = 16
    Width = 488
    Height = 312
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 3
    DefaultColWidth = 120
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 6
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    ParentFont = False
    TabOrder = 1
    OnDrawCell = sgDrawCell
    OnSelectCell = sgSelectCell
  end
end
