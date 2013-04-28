object AboutBox: TAboutBox
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 215
  ClientWidth = 283
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020040000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000010000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000003333000000000000000000
    0000000033333333000000000000000000000000000000000000000000000000
    0000000033333333000000000000000000000000000000000000000000000000
    0000000033333333000000000000000000000000033333300000000000000000
    00000000000000000000000000000000000000000F8778F00000000000000000
    00000000FF8778FF000000000000000000000000FF8778FF0000000000000000
    0000000FFF8778FFF0000000000000000000000FFF8778FFF000000000000000
    000000FFF888888FFF00000000000000000000FFB80BB08BFF00000000000000
    00000FFBFB0BB0FBFFF000000000000000000FBFBB0BB0BFBFF0000000000000
    0000FBFBB0BBBB0BFBFF0000000000000000FFBB0BBBBBB0BFBF000000000000
    000FFBFB0BBBBBB0BBFBF00000000000000FBFBB1B9B9B91BFBFF00000000000
    000FFBFBBBBBBBBBBBFBF00000000000000FBFBFBBBBBBBBBFBFF00000000000
    000FFBFBFBBBBBBBFBFBF000000000000000FFBFBFBFBFBFBFBF000000000000
    0000FFFBFBFBFBFBFBFF00000000000000000FFFBFBFBFBFFFF0000000000000
    00000FFFFFFFFFFFFFF00000000000000000000FFFFFFFFFF000000000000000
    000000000FFFFFF000000000000000000000000000000000000000000000FFFC
    3FFFFFF00FFFFFE007FFFFF00FFFFFE007FFFFF00FFFFFE007FFFFF00FFFFFF0
    0FFFFFF00FFFFFE007FFFFE007FFFFC003FFFFC003FFFF8001FFFF8001FFFF00
    00FFFF0000FFFE00007FFE00007FFC00003FFC00003FFC00003FFC00003FFC00
    003FFE00007FFE00007FFF0000FFFF0000FFFF8001FFFFE007FFFFF81FFF}
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 265
    Height = 161
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProductName: TLabel
      Left = 48
      Top = 8
      Width = 165
      Height = 13
      Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1076#1074#1086#1080#1095#1085#1099#1093' '#1092#1072#1081#1083#1086#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      IsControl = True
    end
    object Copyright: TLabel
      Left = 8
      Top = 80
      Width = 218
      Height = 13
      Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1091' '#1088#1072#1079#1088#1072#1073#1086#1090#1072#1083'  '#1051#1086#1075#1080#1085#1086#1074' '#1044#1084#1080#1090#1088#1080#1081
      WordWrap = True
      IsControl = True
    end
    object Label1: TLabel
      Left = 16
      Top = 40
      Width = 224
      Height = 32
      Caption = 'MatriX Project'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clPurple
      Font.Height = -24
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 112
      Width = 66
      Height = 13
      Caption = #1040#1076#1088#1077#1089' '#1089#1072#1081#1090#1072':'
      Enabled = False
    end
    object Label3: TLabel
      Left = 80
      Top = 112
      Width = 135
      Height = 13
      Cursor = crHandPoint
      Caption = 'http://matrix.kladovka.net.ru'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label3Click
    end
    object Label4: TLabel
      Left = 80
      Top = 128
      Width = 142
      Height = 13
      Cursor = crHandPoint
      Caption = 'mailto:matrix@kladovka.net.ru'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label4Click
    end
    object Label5: TLabel
      Left = 8
      Top = 128
      Width = 31
      Height = 13
      Caption = 'E-mail:'
      Enabled = False
    end
  end
  object OKButton: TButton
    Left = 95
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
