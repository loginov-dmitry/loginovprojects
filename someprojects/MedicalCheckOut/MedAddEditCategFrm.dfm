inherited MedAddEditCategForm: TMedAddEditCategForm
  ActiveControl = edName
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' / '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1086#1087#1080#1089#1072#1085#1080#1103
  ClientHeight = 388
  ClientWidth = 496
  ExplicitWidth = 512
  ExplicitHeight = 426
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 28
    Top = 16
    Width = 154
    Height = 16
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1080':'
  end
  object Label2: TLabel [1]
    Left = 38
    Top = 154
    Width = 144
    Height = 16
    Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103' '#1074' '#1096#1072#1073#1083#1086#1085#1077':'
    Visible = False
  end
  object Label3: TLabel [2]
    Left = 42
    Top = 75
    Width = 138
    Height = 16
    Caption = #1057#1090#1088#1086#1082#1072' '#1089#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1080':'
    Visible = False
  end
  object Label4: TLabel [3]
    Left = 16
    Top = 202
    Width = 182
    Height = 16
    Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103':'
  end
  object Label5: TLabel [4]
    Left = 3
    Top = 46
    Width = 179
    Height = 16
    Caption = #1058#1077#1082#1089#1090' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1076#1083#1103' '#1074#1099#1087#1080#1089#1082#1080':'
  end
  object Label6: TLabel [5]
    Left = 9
    Top = 98
    Width = 186
    Height = 16
    Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1080#1077' '#1090#1077#1082#1089#1090#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080':'
  end
  object Label7: TLabel [6]
    Left = 8
    Top = 127
    Width = 186
    Height = 16
    Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090#1099' '#1082#1072#1090#1077#1075#1086#1088#1080#1080':'
  end
  inherited panOkCancel: TPanel
    Top = 347
    Width = 496
    ExplicitTop = 347
    ExplicitWidth = 496
    inherited btnOK: TBitBtn
      Left = 315
      OnClick = btnOKClick
      ExplicitLeft = 315
    end
    inherited btnCancel: TBitBtn
      Left = 412
      ExplicitLeft = 412
    end
  end
  object edName: TEdit [8]
    Left = 186
    Top = 13
    Width = 298
    Height = 24
    TabOrder = 1
  end
  object edTempl: TEdit [9]
    Left = 186
    Top = 151
    Width = 298
    Height = 24
    TabOrder = 2
    Visible = False
  end
  object edCode: TEdit [10]
    Left = 186
    Top = 72
    Width = 298
    Height = 24
    TabOrder = 3
    Visible = False
  end
  object cbShowCateg: TCheckBox [11]
    Left = 16
    Top = 180
    Width = 345
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102' '#1074' '#1086#1082#1085#1077' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1074#1099#1087#1080#1089#1082#1080
    TabOrder = 4
  end
  object memComment: TMemo [12]
    Left = 16
    Top = 220
    Width = 458
    Height = 89
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object edCategText: TEdit [13]
    Left = 186
    Top = 43
    Width = 298
    Height = 24
    TabOrder = 6
  end
  object cbBold: TCheckBox [14]
    Left = 204
    Top = 99
    Width = 77
    Height = 17
    Caption = #1046#1080#1088#1085#1099#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
  end
  object cbItalic: TCheckBox [15]
    Left = 289
    Top = 99
    Width = 79
    Height = 17
    Caption = #1050#1091#1088#1089#1080#1074#1086#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 8
  end
  object cbUnderline: TCheckBox [16]
    Left = 373
    Top = 99
    Width = 107
    Height = 17
    Caption = #1055#1086#1076#1095#1077#1088#1082#1085#1091#1090#1099#1084
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    State = cbChecked
    TabOrder = 9
  end
  object cbElemListStyle: TComboBox [17]
    Left = 200
    Top = 122
    Width = 284
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 10
    Text = #1044#1088#1091#1075' '#1079#1072' '#1076#1088#1091#1075#1086#1084', '#1074' '#1086#1076#1085#1086#1084' '#1072#1073#1079#1072#1094#1077
    Items.Strings = (
      #1044#1088#1091#1075' '#1079#1072' '#1076#1088#1091#1075#1086#1084', '#1074' '#1086#1076#1085#1086#1084' '#1072#1073#1079#1072#1094#1077
      #1053#1091#1084#1077#1088#1086#1074#1072#1085#1085#1099#1081' '#1089#1087#1080#1089#1086#1082
      #1052#1072#1088#1082#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1089#1087#1080#1089#1086#1082)
  end
  inherited JvFormStorage1: TJvFormStorage
    Top = 230
  end
  inherited JvAppRegistryStorage1: TJvAppRegistryStorage
    Top = 244
  end
  inherited BaseActionList: TActionList
    Top = 244
  end
end
