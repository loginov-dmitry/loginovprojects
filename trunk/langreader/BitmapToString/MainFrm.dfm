object Form1: TForm1
  Left = 192
  Top = 107
  Width = 484
  Height = 434
  Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081' '#1074' lng-'#1092#1072#1081#1083#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    476
    407)
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 16
    Top = 217
    Width = 77
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1082#1072#1082':'
  end
  object Button2: TButton
    Left = 8
    Top = 182
    Width = 193
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' '#1089' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077#1084'...'
    TabOrder = 0
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 246
    Width = 457
    Height = 136
    Anchors = [akLeft, akBottom]
    Caption = #1052#1077#1089#1090#1086#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1074' '#1080#1085#1080'-'#1092#1072#1081#1083#1077
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 48
      Width = 37
      Height = 13
      Caption = #1057#1077#1082#1094#1080#1103
    end
    object Label2: TLabel
      Left = 168
      Top = 48
      Width = 80
      Height = 13
      Caption = #1048#1084#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
    end
    object Label4: TLabel
      Left = 16
      Top = 87
      Width = 48
      Height = 13
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077
    end
    object FilenameEdit1: TFilenameEdit
      Left = 8
      Top = 16
      Width = 377
      Height = 21
      NumGlyphs = 1
      TabOrder = 0
      Text = 'C:\Delphi\Sources\My Sources\LangReader\Russian.lng'
    end
    object Edit1: TEdit
      Left = 8
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'TForm1'
    end
    object Edit2: TEdit
      Left = 160
      Top = 64
      Width = 225
      Height = 21
      TabOrder = 2
      Text = 'Image1.Picture'
    end
    object Button6: TButton
      Left = 392
      Top = 61
      Width = 49
      Height = 25
      Hint = #1059#1076#1072#1083#1103#1077#1090' '#1079#1072#1076#1072#1085#1085#1099#1081' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1080#1079' '#1092#1072#1081#1083#1072
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = Button6Click
    end
    object Edit3: TEdit
      Left = 8
      Top = 103
      Width = 305
      Height = 21
      TabOrder = 4
    end
    object Button7: TButton
      Left = 320
      Top = 103
      Width = 59
      Height = 25
      Hint = #1057#1095#1080#1090#1099#1074#1072#1077#1090' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1090#1077#1082#1089#1090#1086#1074#1086#1075#1086' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
      Caption = #1057#1095#1080#1090#1072#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 384
      Top = 103
      Width = 57
      Height = 25
      Hint = #1047#1072#1087#1080#1089#1099#1074#1072#1077#1090' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1090#1077#1082#1089#1090#1086#1074#1086#1075#1086' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
      Caption = #1047#1072#1087#1080#1089#1072#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = Button8Click
    end
  end
  object ComboBox1: TComboBox
    Left = 104
    Top = 214
    Width = 97
    Height = 21
    Hint = 
      #1054#1087#1088#1077#1076#1077#1083#1103#1077#1090', '#1082#1072#1082' '#1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077':'#13#10'- Picture - '#1074' '#1087#1086#1090#1086#1082' '#1079#1072#1087#1080 +
      #1089#1099#1074#1072#1077#1090#1089#1103' '#1080#1084#1103' '#1082#1083#1072#1089#1089#1072#13#10'  ('#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1076#1083#1103' TImage.Picture)'#13#10'- Grap' +
      'hic - '#1080#1084#1103' '#1082#1083#1072#1089#1089#1072' '#1074' '#1087#1086#1090#1086#1082' '#1085#1077' '#1087#1080#1096#1077#1090#1089#1103#13#10'  ('#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1076#1083#1103' TBitBtn' +
      ', TSpeedButton '#1080' '#1090'.'#1087'.)'
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    ItemIndex = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Text = 'Picture'
    Items.Strings = (
      'Picture'
      'Graphic')
  end
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 8
    Width = 461
    Height = 166
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 193
      Height = 137
      AutoSize = True
    end
  end
  object Button5: TButton
    Left = 216
    Top = 214
    Width = 97
    Height = 25
    Hint = #1057#1086#1093#1088#1072#1085#1103#1077#1090' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1074' HEX-'#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1080
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' ini'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button1: TButton
    Left = 328
    Top = 214
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' ini'
    TabOrder = 5
    OnClick = Button1Click
  end
  object opDialog1: TOpenPictureDialog
    Left = 424
    Top = 16
  end
  object FormStorage1: TFormStorage
    StoredProps.Strings = (
      'FilenameEdit1.Text'
      'Edit1.Text'
      'Edit2.Text')
    StoredValues = <>
    Left = 384
    Top = 16
  end
end
