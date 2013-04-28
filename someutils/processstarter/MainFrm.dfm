object Form1: TForm1
  Left = 192
  Top = 114
  Caption = #1047#1072#1087#1091#1089#1082' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1081' '#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081' '#1082' '#1087#1088#1086#1094#1077#1089#1089#1086#1088#1072#1084
  ClientHeight = 282
  ClientWidth = 554
  Color = clBtnFace
  Constraints.MinHeight = 320
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    554
    282)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 111
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1087#1088#1086#1075#1088#1072#1084#1084':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 192
    Top = 24
    Width = 102
    Height = 13
    Caption = #1048#1084#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1099':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 192
    Top = 49
    Width = 71
    Height = 13
    Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 192
    Top = 73
    Width = 93
    Height = 13
    Caption = #1056#1072#1073#1086#1095#1072#1103' '#1087#1072#1087#1082#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 192
    Top = 97
    Width = 125
    Height = 13
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1087#1091#1089#1082#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 192
    Top = 126
    Width = 163
    Height = 13
    Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100' '#1082' '#1087#1088#1086#1094#1077#1089#1089#1086#1088#1072#1084':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 8
    Top = 24
    Width = 169
    Height = 177
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 13
    ParentFont = False
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object edProcName: TEdit
    Left = 320
    Top = 20
    Width = 237
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object edFileName: TEdit
    Left = 320
    Top = 44
    Width = 203
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object edDirName: TEdit
    Left = 320
    Top = 68
    Width = 237
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object edParams: TEdit
    Left = 320
    Top = 92
    Width = 237
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object btnAdd: TButton
    Left = 40
    Top = 208
    Width = 121
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 5
    OnClick = btnAddClick
  end
  object Button2: TButton
    Left = 176
    Top = 208
    Width = 121
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 6
    OnClick = Button2Click
  end
  object btnRewrite: TButton
    Left = 312
    Top = 208
    Width = 121
    Height = 25
    Caption = #1055#1077#1088#1077#1079#1072#1087#1080#1089#1072#1090#1100
    TabOrder = 7
    OnClick = btnRewriteClick
  end
  object ScrollBox1: TScrollBox
    Left = 184
    Top = 144
    Width = 374
    Height = 57
    HorzScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 8
  end
  object BitBtn1: TBitBtn
    Left = 168
    Top = 248
    Width = 177
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object Button4: TButton
    Left = 527
    Top = 44
    Width = 28
    Height = 22
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 10
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.exe'
    Filter = 
      #1048#1089#1087#1086#1083#1085#1103#1077#1084#1099#1077' '#1092#1072#1081#1083#1099' (*.exe)|*.exe|'#1050#1086#1084#1072#1085#1076#1085#1099#1077' '#1092#1072#1081#1083#1099' (*.bat)|*.bat|'#1055#1088 +
      #1086#1095#1080#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 264
    Top = 16
  end
end
