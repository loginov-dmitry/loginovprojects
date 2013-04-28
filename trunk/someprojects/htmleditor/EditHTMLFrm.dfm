object EditHTMLForm: TEditHTMLForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1090#1088#1077#1073#1091#1077#1084#1099#1081' HTML-'#1082#1086#1076
  ClientHeight = 358
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 317
    Width = 548
    Height = 41
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      548
      41)
    object btnOk: TButton
      Left = 296
      Top = 8
      Width = 159
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1050' [Shift + Enter]'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 461
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 548
    Height = 317
    Align = alClient
    TabOrder = 1
  end
  object ActionList1: TActionList
    Left = 120
    Top = 8
    object acClose: TAction
      Caption = 'acClose'
      ShortCut = 8205
      OnExecute = acCloseExecute
    end
    object acCancel: TAction
      Caption = 'acCancel'
      ShortCut = 27
      OnExecute = acCancelExecute
    end
  end
end
