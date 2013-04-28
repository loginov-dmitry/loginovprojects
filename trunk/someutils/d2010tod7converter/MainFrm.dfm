object Form1: TForm1
  Left = 192
  Top = 124
  BorderStyle = bsDialog
  Caption = 'D2010 to D7 converter'
  ClientHeight = 116
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 260
    Height = 16
    Caption = #1059#1082#1072#1078#1080#1090#1077' '#1082#1072#1090#1072#1083#1086#1075' '#1089' DFM '#1080' PAS '#1092#1072#1081#1083#1072#1084#1080'.'
  end
  object Label2: TLabel
    Left = 8
    Top = 22
    Width = 322
    Height = 16
    Caption = #1053#1077' '#1079#1072#1073#1091#1076#1100#1090#1077' '#1079#1072#1088#1072#1085#1077#1077' '#1089#1076#1077#1083#1072#1090#1100' '#1088#1077#1079#1077#1088#1074#1085#1091#1102' '#1082#1086#1087#1080#1102'.'
  end
  object Edit1: TEdit
    Left = 8
    Top = 40
    Width = 313
    Height = 24
    TabOrder = 0
    Text = 'C:\Delphi\Projects\Matrix32\TestMatrix7'
  end
  object Button1: TButton
    Left = 322
    Top = 39
    Width = 33
    Height = 25
    Caption = '...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 80
    Width = 185
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button2Click
  end
end
