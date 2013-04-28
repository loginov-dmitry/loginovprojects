object Form1: TForm1
  Left = 192
  Top = 114
  Caption = 'Form1'
  ClientHeight = 440
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 333
    Width = 688
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Panel1: TPanel
    Left = 0
    Top = 336
    Width = 688
    Height = 104
    Align = alBottom
    TabOrder = 0
    object Button4: TButton
      Left = 8
      Top = 8
      Width = 89
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1069#1050#1043
      TabOrder = 0
    end
    object Button1: TButton
      Left = 8
      Top = 40
      Width = 89
      Height = 25
      Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
      TabOrder = 1
      OnClick = Button1Click
    end
    object GroupBox1: TGroupBox
      Left = 112
      Top = 8
      Width = 257
      Height = 89
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1083#1080#1085#1080#1102
      TabOrder = 2
      object Label1: TLabel
        Left = 128
        Top = 16
        Width = 44
        Height = 13
        Caption = #1055#1086#1079#1080#1094#1080#1103
      end
      object RadioButton1: TRadioButton
        Left = 8
        Top = 16
        Width = 113
        Height = 17
        Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1091#1102
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object RadioButton2: TRadioButton
        Left = 8
        Top = 32
        Width = 113
        Height = 17
        Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1091#1102
        TabOrder = 1
      end
      object CheckBox1: TCheckBox
        Left = 8
        Top = 48
        Width = 113
        Height = 17
        Caption = #1055#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1089#1077#1090#1082#1077
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object CheckBox2: TCheckBox
        Left = 8
        Top = 64
        Width = 137
        Height = 17
        Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1084#1099#1096#1082#1086#1081
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object Button6: TButton
        Left = 176
        Top = 48
        Width = 75
        Height = 17
        Caption = #1057#1086#1079#1076#1072#1090#1100
        TabOrder = 4
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 176
        Top = 64
        Width = 75
        Height = 17
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 5
        OnClick = Button7Click
      end
      object Edit1: TEdit
        Left = 176
        Top = 16
        Width = 73
        Height = 21
        TabOrder = 6
        Text = '500'
      end
    end
    object Button2: TButton
      Left = 384
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 8
      Top = 72
      Width = 89
      Height = 25
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' qrs'
      TabOrder = 4
      OnClick = Button3Click
    end
    object Edit2: TEdit
      Left = 408
      Top = 72
      Width = 49
      Height = 21
      TabOrder = 5
      Text = '10'
    end
    object Button5: TButton
      Left = 464
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Create'
      TabOrder = 6
      OnClick = Button5Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 32
    Top = 16
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer2Timer
    Left = 96
    Top = 32
  end
  object ApplicationEvents1: TApplicationEvents
    Left = 72
    Top = 96
  end
  object Timer3: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer3Timer
    Left = 192
    Top = 40
  end
end
