object MedMainFrm: TMedMainFrm
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1076#1083#1103' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1103' '#1074#1099#1087#1080#1089#1082#1080
  ClientHeight = 378
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 24
  object btnEditElems: TButton
    Left = 16
    Top = 205
    Width = 201
    Height = 41
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1083#1086#1074#1072#1088#1103'...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnEditElemsClick
  end
  object btnNewCheckout: TButton
    Left = 16
    Top = 24
    Width = 441
    Height = 97
    Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1080#1077' '#1074#1099#1087#1080#1089#1082#1080
    TabOrder = 1
    OnClick = btnNewCheckoutClick
  end
  object btnExit: TButton
    Left = 256
    Top = 342
    Width = 201
    Height = 28
    Caption = #1042#1099#1093#1086#1076
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnExitClick
  end
  object btnCheckoutList: TButton
    Left = 16
    Top = 127
    Width = 441
    Height = 34
    Caption = #1057#1087#1080#1089#1086#1082' '#1074#1099#1087#1080#1089#1086#1082
    TabOrder = 3
    Visible = False
  end
  object Button2: TButton
    Left = 16
    Top = 342
    Width = 201
    Height = 28
    Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 256
    Top = 205
    Width = 201
    Height = 41
    Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1074#1088#1072#1095#1077#1081'...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = Button1Click
  end
end
