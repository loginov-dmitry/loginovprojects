object frmAboutBox: TfrmAboutBox
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077' '#1057#1051#1045#1044#1054#1055#1067#1058
  ClientHeight = 213
  ClientWidth = 298
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
    Width = 281
    Height = 161
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProductName: TLabel
      Left = 88
      Top = 16
      Width = 118
      Height = 20
      Caption = #1057#1083#1077#1076#1086#1087#1099#1090' 1.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      IsControl = True
    end
    object Copyright: TLabel
      Left = 8
      Top = 80
      Width = 197
      Height = 13
      Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1091' '#1088#1072#1079#1088#1072#1073#1086#1090#1072#1083':  '#1051#1086#1075#1080#1085#1086#1074' '#1044'.'#1057'.'
      IsControl = True
    end
    object Label1: TLabel
      Left = 32
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
      Width = 124
      Height = 13
      Cursor = crHandPoint
      Caption = 'mailto:loginov_d@inbox.ru'
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
    Left = 111
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OKButtonClick
  end
end
