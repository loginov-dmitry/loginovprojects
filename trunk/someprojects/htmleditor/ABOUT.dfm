object AboutBox: TAboutBox
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 241
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 369
    Height = 192
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object ProductName: TLabel
      Left = 107
      Top = 16
      Width = 143
      Height = 24
      Caption = 'HTML-'#1088#1077#1076#1072#1082#1090#1086#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object Version: TLabel
      Left = 149
      Top = 62
      Width = 64
      Height = 13
      Caption = #1042#1077#1088#1089#1080#1103' 1.0.1'
      IsControl = True
    end
    object Label1: TLabel
      Left = 16
      Top = 89
      Width = 266
      Height = 13
      Caption = #1056#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082' '#1087#1088#1080#1084#1077#1088#1072': '#1051#1086#1075#1080#1085#1086#1074' '#1044#1084#1080#1090#1088#1080#1081' '#1057#1077#1088#1075#1077#1077#1074#1080#1095
    end
    object Label2: TLabel
      Left = 16
      Top = 108
      Width = 127
      Height = 13
      Caption = 'mailto: loginov_d@inbox.ru'
    end
    object Label3: TLabel
      Left = 16
      Top = 140
      Width = 333
      Height = 13
      Caption = #1044#1072#1085#1085#1099#1081' '#1087#1088#1086#1077#1082#1090' '#1103#1074#1083#1103#1077#1090#1089#1103' open-source '#1080' '#1084#1086#1078#1077#1090' '#1088#1072#1089#1087#1088#1086#1089#1090#1088#1072#1085#1103#1090#1100#1089#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 16
      Top = 154
      Width = 97
      Height = 13
      Caption = #1087#1086' '#1083#1080#1094#1077#1085#1079#1080#1080' BSD 2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object OKButton: TButton
    Left = 157
    Top = 206
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
