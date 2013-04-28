inherited MedInputVarForm: TMedInputVarForm
  Caption = #1042#1074#1086#1076' '#1074#1072#1088#1080#1072#1085#1090#1072' '#1086#1087#1080#1089#1072#1085#1080#1103
  ClientHeight = 390
  ClientWidth = 502
  OnShow = FormShow
  ExplicitWidth = 518
  ExplicitHeight = 428
  PixelsPerInch = 96
  TextHeight = 16
  inherited panOkCancel: TPanel
    Top = 349
    Width = 502
    ExplicitTop = 349
    ExplicitWidth = 502
    inherited btnOK: TBitBtn
      Left = 321
      ExplicitLeft = 321
    end
    inherited btnCancel: TBitBtn
      Left = 418
      ExplicitLeft = 418
    end
  end
  object panVarText: TPanel [1]
    Left = 0
    Top = 49
    Width = 502
    Height = 69
    Align = alTop
    TabOrder = 1
    Visible = False
    DesignSize = (
      502
      69)
    object Label3: TLabel
      Left = 9
      Top = 10
      Width = 97
      Height = 16
      Caption = #1058#1077#1082#1089#1090' '#1074#1072#1088#1080#1072#1085#1090#1072':'
    end
    object Label10: TLabel
      Left = 9
      Top = 35
      Width = 79
      Height = 32
      Caption = #1058#1080#1087#1099' '#1087#1086#1083#1077#1081' '#1087#1086#1076#1089#1090#1072#1085#1086#1074#1082#1080':'
      WordWrap = True
    end
    object btnEditVarTypes: TSpeedButton
      Left = 467
      Top = 40
      Width = 25
      Height = 24
      Hint = #1042#1074#1077#1089#1090#1080' '#1090#1080#1087#1099' '#1087#1086#1076#1089#1090#1072#1085#1086#1074#1086#1095#1085#1099#1093' '#1087#1086#1083#1077#1081
      Anchors = [akTop, akRight]
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      OnClick = btnEditVarTypesClick
    end
    object edName: TEdit
      Left = 112
      Top = 7
      Width = 380
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnExit = edNameExit
    end
    object edVarTypes: TEdit
      Left = 112
      Top = 40
      Width = 354
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      Color = clInfoBk
      ReadOnly = True
      TabOrder = 1
    end
  end
  object panShowVarText: TPanel [2]
    Left = 0
    Top = 20
    Width = 502
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object labCanEditVarText: TCheckBox
      Left = 9
      Top = 4
      Width = 280
      Height = 17
      TabStop = False
      Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1074#1074#1086#1076' '#1090#1077#1082#1089#1090#1072' '#1074#1072#1088#1080#1072#1085#1090#1072' '#1086#1087#1080#1089#1072#1085#1080#1103
      TabOrder = 0
      OnClick = labCanEditVarTextClick
    end
  end
  object panVarValuesHolder: TPanel [3]
    Left = 0
    Top = 118
    Width = 502
    Height = 231
    Align = alClient
    TabOrder = 3
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 500
      Height = 18
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 9
        Top = 0
        Width = 287
        Height = 16
        Caption = #1042#1074#1077#1076#1080#1090#1077' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1087#1086#1076#1089#1090#1072#1085#1086#1074#1086#1095#1085#1099#1093' '#1087#1086#1083#1077#1081':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object panVarValues: TPanel
      Left = 1
      Top = 19
      Width = 500
      Height = 211
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object panCaption: TPanel [4]
    Left = 0
    Top = 0
    Width = 502
    Height = 20
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  inherited JvFormStorage1: TJvFormStorage
    Left = 16
    Top = 328
  end
  inherited JvAppRegistryStorage1: TJvAppRegistryStorage
    Left = 128
    Top = 328
  end
  inherited BaseActionList: TActionList
    Left = 72
    Top = 328
  end
end
