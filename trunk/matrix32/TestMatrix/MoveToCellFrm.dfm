object MoveToCellForm: TMoveToCellForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072' '#1074' '#1084#1072#1089#1089#1080#1074' '#1103#1095#1077#1077#1082
  ClientHeight = 163
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 346
    Height = 16
    Caption = #1059#1082#1072#1078#1080#1090#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' '#1103#1095#1077#1081#1082#1080', '#1074' '#1082#1086#1090#1086#1088#1091#1102' '#1073#1091#1076#1077#1090' '#1087#1077#1088#1077#1084#1077#1097#1077#1085
  end
  object Label2: TLabel
    Left = 8
    Top = 24
    Width = 341
    Height = 16
    Caption = #1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1086#1073#1098#1077#1082#1090'. '#1045#1089#1083#1080' '#1103#1095#1077#1081#1082#1080' '#1089' '#1091#1082#1072#1079#1072#1085#1085#1099#1084' '#1085#1086#1084#1077#1088#1086#1084' '#1085#1077
  end
  object Label3: TLabel
    Left = 8
    Top = 40
    Width = 349
    Height = 16
    Caption = #1089#1091#1097#1077#1089#1090#1074#1091#1077#1090', '#1090#1086' '#1087#1088#1086#1075#1088#1072#1084#1084#1072' '#1087#1086#1087#1099#1090#1072#1077#1090#1089#1103' '#1091#1074#1077#1083#1080#1095#1080#1090#1100' '#1088#1072#1079#1084#1077#1088#1099
  end
  object Label4: TLabel
    Left = 8
    Top = 56
    Width = 299
    Height = 16
    Caption = #1084#1072#1089#1089#1080#1074#1072' '#1103#1095#1077#1077#1082'. '#1053#1091#1084#1077#1088#1072#1094#1080#1103' '#1085#1072#1095#1080#1085#1072#1077#1090#1089#1103' '#1089' '#1077#1076#1080#1085#1080#1094#1099'.'
  end
  object labRowNum: TLabel
    Left = 16
    Top = 88
    Width = 85
    Height = 16
    Caption = #1053#1086#1084#1077#1088' '#1089#1090#1088#1086#1082#1080':'
  end
  object labColNum: TLabel
    Left = 198
    Top = 88
    Width = 93
    Height = 16
    Caption = #1053#1086#1084#1077#1088' '#1089#1090#1086#1083#1073#1094#1072':'
  end
  object Panel1: TPanel
    Left = 0
    Top = 129
    Width = 399
    Height = 34
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 99
    ExplicitWidth = 383
    DesignSize = (
      399
      34)
    object btnOK: TButton
      Left = 237
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
      ExplicitLeft = 221
    end
    object btnCancel: TButton
      Left = 318
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 302
    end
  end
  object seRow: TSpinEdit
    Left = 114
    Top = 85
    Width = 46
    Height = 26
    MaxValue = 2147483647
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
  object seCol: TSpinEdit
    Left = 320
    Top = 85
    Width = 46
    Height = 26
    MaxValue = 2147483647
    MinValue = 1
    TabOrder = 2
    Value = 1
  end
end
