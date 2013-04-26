object AddMatrixForm: TAddMatrixForm
  Left = 0
  Top = 0
  ActiveControl = edNewMatrixName
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1086#1073#1098#1077#1082#1090
  ClientHeight = 133
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 16
    Top = 14
    Width = 142
    Height = 16
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1086#1073#1098#1077#1082#1090#1072':'
  end
  object Label3: TLabel
    Left = 16
    Top = 53
    Width = 78
    Height = 16
    Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1072':'
  end
  object Panel1: TPanel
    Left = 0
    Top = 99
    Width = 383
    Height = 34
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      383
      34)
    object btnOK: TButton
      Left = 221
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 302
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object edNewMatrixName: TEdit
    Left = 164
    Top = 11
    Width = 164
    Height = 24
    TabOrder = 1
    Text = 'NewMatrix'
  end
  object ComboBox1: TComboBox
    Left = 164
    Top = 50
    Width = 164
    Height = 24
    Style = csDropDownList
    DropDownCount = 10
    ItemIndex = 0
    TabOrder = 2
    Text = 'Double'
    Items.Strings = (
      'Double'
      'Integer'
      'Short'
      'Byte'
      'Extended'
      'DoubleCx'
      'Cell'
      'Record'
      'Char')
  end
end
