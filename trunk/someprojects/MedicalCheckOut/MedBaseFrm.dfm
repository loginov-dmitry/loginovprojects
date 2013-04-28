object MedBaseForm: TMedBaseForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'MedBaseForm'
  ClientHeight = 303
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object panOkCancel: TPanel
    Left = 0
    Top = 262
    Width = 482
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      482
      41)
    object btnOK: TBitBtn
      Left = 301
      Top = 4
      Width = 91
      Height = 34
      Hint = #1055#1088#1080#1085#1103#1090#1100' (F4)'
      Anchors = [akTop, akRight]
      Caption = 'OK (F4)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Kind = bkOK
    end
    object btnCancel: TBitBtn
      Left = 398
      Top = 17
      Width = 75
      Height = 21
      Hint = #1054#1090#1084#1077#1085#1072' (ESC)'
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object JvFormStorage1: TJvFormStorage
    AppStorage = JvAppRegistryStorage1
    AppStoragePath = '%FORM_NAME%\'
    StoredValues = <>
    Left = 40
    Top = 24
  end
  object JvAppRegistryStorage1: TJvAppRegistryStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    Root = 'Software\LoginovProjects\MedicalCheckOuts'
    SubStorages = <>
    Left = 152
    Top = 24
  end
  object BaseActionList: TActionList
    Left = 96
    Top = 24
    object acOK: TAction
      Caption = 'acOK'
      ShortCut = 115
      OnExecute = acOKExecute
    end
  end
  object TimerAfterShow: TTimer
    Interval = 1
    OnTimer = TimerAfterShowTimer
    Top = 512
  end
end
