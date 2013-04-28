inherited MedEditVarTypesForm: TMedEditVarTypesForm
  Caption = #1058#1080#1087#1099' '#1076#1083#1103' '#1089#1090#1088#1086#1082' '#1087#1086#1076#1089#1090#1072#1085#1086#1074#1082#1080
  ClientHeight = 244
  ClientWidth = 684
  ExplicitWidth = 700
  ExplicitHeight = 282
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 16
    Top = 8
    Width = 182
    Height = 16
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1090#1088#1086#1082#1091' '#1087#1086#1076#1089#1090#1072#1085#1086#1074#1082#1080':'
  end
  object Label2: TLabel [1]
    Left = 451
    Top = 8
    Width = 225
    Height = 16
    Caption = #1059#1082#1072#1078#1080#1090#1077' '#1090#1080#1087' '#1076#1083#1103' '#1089#1090#1088#1086#1082#1080' '#1087#1086#1076#1089#1090#1072#1085#1086#1074#1082#1080':'
  end
  object labList: TLabel [2]
    Left = 416
    Top = 66
    Width = 232
    Height = 32
    Caption = 
      #1059#1082#1072#1078#1080#1090#1077' '#1074#1089#1077' '#1074#1086#1079#1084#1086#1078#1085#1099#1077' '#1074#1072#1088#1080#1072#1085#1090#1099' '#1076#1083#1103' '#1074#1099#1073#1086#1088#1072', '#1088#1072#1079#1076#1077#1083#1103#1103' '#1080#1093' '#1089#1080#1084#1074#1086#1083#1086#1084':' +
      ' /'
    Visible = False
    WordWrap = True
  end
  inherited panOkCancel: TPanel
    Top = 203
    Width = 684
    ExplicitTop = 203
    ExplicitWidth = 684
    inherited btnOK: TBitBtn
      Left = 503
      ExplicitLeft = 503
    end
    inherited btnCancel: TBitBtn
      Left = 600
      ExplicitLeft = 600
    end
  end
  object lbTypesList: TListBox [4]
    Left = 16
    Top = 30
    Width = 385
    Height = 155
    ItemHeight = 16
    TabOrder = 1
    OnClick = lbTypesListClick
  end
  object cbTypesNames: TComboBox [5]
    Left = 465
    Top = 30
    Width = 184
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 2
    Text = #1058#1077#1082#1089#1090
    OnSelect = cbTypesNamesSelect
    Items.Strings = (
      #1058#1077#1082#1089#1090
      #1063#1080#1089#1083#1086
      #1044#1072#1090#1072
      #1042#1099#1073#1086#1088)
  end
  object edList: TEdit [6]
    Left = 416
    Top = 100
    Width = 260
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Visible = False
  end
  object btnSet: TButton [7]
    Left = 407
    Top = 126
    Width = 122
    Height = 33
    Caption = '<- '#1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
    TabOrder = 4
    OnClick = btnSetClick
  end
end
