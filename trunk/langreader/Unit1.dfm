object Form1: TForm1
  Left = 246
  Top = 137
  Caption = 'Form1'
  ClientHeight = 262
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 256
    Top = 56
    Width = 129
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 40
    Width = 185
    Height = 89
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object RadioGroup1: TRadioGroup
    Left = 24
    Top = 144
    Width = 185
    Height = 105
    Caption = 'RadioGroup1'
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5')
    TabOrder = 3
  end
  object Button3: TButton
    Left = 256
    Top = 224
    Width = 129
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1103#1079#1099#1082
    TabOrder = 4
    OnClick = Button3Click
  end
  object LabeledEdit1: TLabeledEdit
    Left = 296
    Top = 128
    Width = 121
    Height = 21
    EditLabel.Width = 61
    EditLabel.Height = 13
    EditLabel.Caption = 'LabeledEdit1'
    TabOrder = 5
  end
  object Button1: TBitBtn
    Left = 256
    Top = 24
    Width = 129
    Height = 25
    Caption = 'Button1'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object MainMenu1: TMainMenu
    Left = 248
    Top = 136
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N2: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        ShortCut = 16465
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        ShortCut = 16463
        OnClick = N3Click
      end
    end
  end
end
