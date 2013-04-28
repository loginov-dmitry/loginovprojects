object TestChildForm: TTestChildForm
  Left = 192
  Top = 114
  Caption = 'TestChildForm'
  ClientHeight = 196
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 27
    Height = 13
    Caption = #1060#1048#1054
  end
  object Label2: TLabel
    Left = 8
    Top = 72
    Width = 20
    Height = 13
    Caption = #1055#1086#1083
  end
  object Label3: TLabel
    Left = 8
    Top = 96
    Width = 24
    Height = 13
    Caption = #1056#1086#1089#1090
  end
  object Label4: TLabel
    Left = 8
    Top = 120
    Width = 19
    Height = 13
    Caption = #1042#1077#1089
  end
  object Label5: TLabel
    Left = 48
    Top = 8
    Width = 203
    Height = 26
    Caption = #1050#1085#1086#1087#1082#1072' '#1054#1050' '#1085#1077' '#1089#1088#1072#1073#1086#1090#1072#1077#1090', '#1087#1086#1082#1072' '#1085#1077' '#1073#1091#1076#1091#1090' '#1074#1074#1077#1076#1077#1085#1099' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1099#1077' '#1076#1072#1085#1085#1099#1077
    WordWrap = True
  end
  object Edit1: TEdit
    Left = 48
    Top = 40
    Width = 265
    Height = 21
    MaxLength = 30
    TabOrder = 0
    OnExit = Edit1Exit
  end
  object Edit2: TEdit
    Left = 48
    Top = 64
    Width = 41
    Height = 21
    MaxLength = 1
    TabOrder = 1
    Text = #1052
    OnExit = Edit2Exit
  end
  object Edit3: TEdit
    Left = 48
    Top = 88
    Width = 105
    Height = 21
    MaxLength = 3
    TabOrder = 2
    Text = '180'
    OnExit = Edit3Exit
  end
  object Edit4: TEdit
    Left = 48
    Top = 112
    Width = 105
    Height = 21
    MaxLength = 3
    TabOrder = 3
    Text = '70'
    OnExit = Edit4Exit
  end
  object btbtnOk: TBitBtn
    Left = 144
    Top = 152
    Width = 75
    Height = 25
    TabOrder = 4
    OnClick = btbtnOkClick
    Kind = bkOK
  end
  object btbtnCancel: TBitBtn
    Left = 232
    Top = 152
    Width = 75
    Height = 25
    TabOrder = 5
    OnClick = btbtnCancelClick
    Kind = bkCancel
  end
end
