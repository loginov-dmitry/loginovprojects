inherited MedAddEditElemForm: TMedAddEditElemForm
  ActiveControl = edName
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' / '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1101#1083#1077#1084#1077#1085#1090#1072' '#1086#1087#1080#1089#1072#1085#1080#1103
  ClientHeight = 474
  ClientWidth = 505
  ExplicitWidth = 521
  ExplicitHeight = 512
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 60
    Top = 8
    Width = 124
    Height = 16
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1086#1087#1080#1089#1072#1085#1080#1103':'
  end
  object labCateg: TLabel [1]
    Left = 190
    Top = 8
    Width = 133
    Height = 16
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1086#1087#1080#1089#1072#1085#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel [2]
    Left = 34
    Top = 33
    Width = 150
    Height = 16
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1101#1083#1077#1084#1077#1085#1090#1072':'
  end
  object Label3: TLabel [3]
    Left = 9
    Top = 60
    Width = 175
    Height = 16
    Caption = #1058#1077#1082#1089#1090' '#1101#1083#1077#1084#1077#1085#1090#1072' '#1076#1083#1103' '#1074#1099#1087#1080#1089#1082#1080':'
  end
  object Label4: TLabel [4]
    Left = 46
    Top = 87
    Width = 138
    Height = 16
    Caption = #1057#1090#1088#1086#1082#1072' '#1089#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1080':'
    Visible = False
  end
  object Label5: TLabel [5]
    Left = 16
    Top = 113
    Width = 182
    Height = 16
    Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1080#1077' '#1090#1077#1082#1089#1090#1072' '#1101#1083#1077#1084#1077#1085#1090#1072':'
  end
  object Label6: TLabel [6]
    Left = 16
    Top = 240
    Width = 216
    Height = 16
    Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1074#1072#1088#1080#1072#1085#1090#1086#1074' '#1086#1087#1080#1089#1072#1085#1080#1103':'
  end
  object Label7: TLabel [7]
    Left = 16
    Top = 264
    Width = 310
    Height = 16
    Caption = #1057#1080#1084#1074#1086#1083', '#1086#1090#1076#1077#1083#1103#1102#1097#1080#1081' '#1090#1077#1082#1089#1090' '#1101#1083#1077#1084#1077#1085#1090#1072' '#1086#1090' '#1074#1072#1088#1080#1072#1085#1090#1086#1074':'
  end
  object Label8: TLabel [8]
    Left = 16
    Top = 291
    Width = 276
    Height = 16
    Caption = #1057#1080#1084#1074#1086#1083', '#1086#1090#1076#1077#1083#1103#1102#1097#1080#1081' '#1074#1072#1088#1080#1072#1085#1090#1099' '#1076#1088#1091#1075' '#1086#1090' '#1076#1088#1091#1075#1072':'
  end
  object Label9: TLabel [9]
    Left = 22
    Top = 318
    Width = 182
    Height = 16
    Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103':'
  end
  inherited panOkCancel: TPanel
    Top = 433
    Width = 505
    ExplicitTop = 433
    ExplicitWidth = 505
    inherited btnOK: TBitBtn
      Left = 324
      OnClick = btnOKClick
      ExplicitLeft = 324
    end
    inherited btnCancel: TBitBtn
      Left = 421
      ExplicitLeft = 421
    end
  end
  object edName: TEdit [11]
    Left = 191
    Top = 30
    Width = 298
    Height = 24
    TabOrder = 1
    OnExit = edNameExit
  end
  object edText: TEdit [12]
    Left = 191
    Top = 57
    Width = 298
    Height = 24
    TabOrder = 2
  end
  object edCode: TEdit [13]
    Left = 191
    Top = 84
    Width = 298
    Height = 24
    TabOrder = 3
    Visible = False
  end
  object cbBold: TCheckBox [14]
    Left = 204
    Top = 114
    Width = 77
    Height = 17
    Caption = #1046#1080#1088#1085#1099#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object cbItalic: TCheckBox [15]
    Left = 289
    Top = 114
    Width = 79
    Height = 17
    Caption = #1050#1091#1088#1089#1080#1074#1086#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 5
  end
  object cbUnderline: TCheckBox [16]
    Left = 373
    Top = 114
    Width = 107
    Height = 17
    Caption = #1055#1086#1076#1095#1077#1088#1082#1085#1091#1090#1099#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
  end
  object cbIsReqiured: TCheckBox [17]
    Left = 16
    Top = 136
    Width = 297
    Height = 17
    Caption = #1069#1083#1077#1084#1077#1085#1090' '#1103#1074#1083#1103#1077#1090#1089#1103' '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1084' '#1076#1083#1103' '#1074#1099#1087#1080#1089#1082#1080
    TabOrder = 7
    Visible = False
  end
  object cbContinuePrev: TCheckBox [18]
    Left = 16
    Top = 159
    Width = 377
    Height = 17
    Caption = #1056#1072#1079#1084#1077#1097#1072#1090#1100' '#1074' '#1086#1076#1085#1086#1084' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1080' '#1089' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1084' '#1101#1083#1077#1084#1077#1085#1090#1086#1084
    TabOrder = 8
  end
  object cbCustomVars: TCheckBox [19]
    Left = 16
    Top = 182
    Width = 489
    Height = 17
    Caption = 
      #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1074#1074#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1083#1100#1085#1086#1075#1086' '#1074#1072#1088#1080#1072#1085#1090#1072' '#1086#1087#1080#1089#1072#1085#1080#1103' '#1087#1088#1080' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1080' '#1074#1099 +
      #1087#1080#1089#1082#1080
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object cbRequireVars: TCheckBox [20]
    Left = 16
    Top = 205
    Width = 489
    Height = 17
    Caption = #1058#1088#1077#1073#1086#1074#1072#1090#1100' '#1074#1074#1086#1076' '#1093#1086#1090#1103' '#1073#1099' '#1086#1076#1085#1086#1075#1086' '#1074#1072#1088#1080#1072#1085#1090#1072' '#1086#1087#1080#1089#1072#1085#1080#1103
    TabOrder = 10
    Visible = False
  end
  object rbLeft: TRadioButton [21]
    Left = 369
    Top = 241
    Width = 97
    Height = 17
    Caption = #1044#1086' '#1101#1083#1077#1084#1077#1085#1090#1072
    TabOrder = 11
  end
  object rbRight: TRadioButton [22]
    Left = 238
    Top = 241
    Width = 125
    Height = 17
    Caption = #1055#1086#1089#1083#1077' '#1101#1083#1077#1084#1077#1085#1090#1072
    Checked = True
    TabOrder = 12
    TabStop = True
  end
  object cbDelimAfter: TComboBox [23]
    Left = 332
    Top = 261
    Width = 77
    Height = 24
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 13
    Text = #1055#1088#1086#1073#1077#1083
    Items.Strings = (
      #1055#1088#1086#1073#1077#1083
      ':'
      '-'
      ',')
  end
  object cbVarSeparator: TComboBox [24]
    Left = 332
    Top = 288
    Width = 77
    Height = 24
    ItemHeight = 16
    ItemIndex = 1
    TabOrder = 14
    Text = ','
    Items.Strings = (
      #1055#1088#1086#1073#1077#1083
      ','
      ';')
  end
  object memComment: TMemo [25]
    Left = 22
    Top = 336
    Width = 458
    Height = 89
    ScrollBars = ssVertical
    TabOrder = 15
  end
  inherited JvFormStorage1: TJvFormStorage
    Left = 8
    Top = 360
  end
  inherited JvAppRegistryStorage1: TJvAppRegistryStorage
    Left = 120
    Top = 336
  end
  inherited BaseActionList: TActionList
    Left = 64
    Top = 336
  end
end
