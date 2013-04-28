object fmFontDialog: TfmFontDialog
  Left = 178
  Top = 80
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1096#1088#1080#1092#1090#1072
  ClientHeight = 187
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 490
    Height = 187
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1063#1080#1089#1083#1072
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 74
        Height = 13
        Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 16
        Top = 80
        Width = 147
        Height = 13
        Caption = #1054#1090#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 16
        Top = 104
        Width = 147
        Height = 13
        Caption = #1047#1072#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ColorBox1: TColorBox
        Left = 120
        Top = 8
        Width = 145
        Height = 22
        Selected = clNavy
        ItemHeight = 16
        TabOrder = 0
        OnSelect = CheckBox1Click
      end
      object CheckBox1: TCheckBox
        Left = 16
        Top = 48
        Width = 97
        Height = 17
        Caption = #1046#1080#1088#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = CheckBox1Click
      end
      object CheckBox2: TCheckBox
        Left = 136
        Top = 48
        Width = 97
        Height = 17
        Caption = #1050#1091#1088#1089#1080#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = CheckBox1Click
      end
      object CheckBox3: TCheckBox
        Left = 272
        Top = 48
        Width = 105
        Height = 17
        Caption = #1055#1086#1076#1095#1077#1088#1082#1085#1091#1090#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = CheckBox1Click
      end
      object Edit1: TEdit
        Left = 168
        Top = 72
        Width = 289
        Height = 21
        TabOrder = 4
        Text = '<span style="color: navy;">'
      end
      object Edit2: TEdit
        Left = 168
        Top = 96
        Width = 289
        Height = 21
        TabOrder = 5
        Text = '</span>'
      end
      object Button1: TButton
        Left = 384
        Top = 125
        Width = 75
        Height = 25
        Caption = #1047#1072#1082#1088#1099#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = Button9Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1057#1090#1088#1086#1082#1080
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label4: TLabel
        Left = 8
        Top = 16
        Width = 74
        Height = 13
        Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 16
        Top = 80
        Width = 147
        Height = 13
        Caption = #1054#1090#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 16
        Top = 104
        Width = 147
        Height = 13
        Caption = #1047#1072#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ColorBox2: TColorBox
        Left = 120
        Top = 8
        Width = 145
        Height = 22
        Selected = clNavy
        ItemHeight = 16
        TabOrder = 0
        OnSelect = CheckBox4Click
      end
      object CheckBox4: TCheckBox
        Left = 16
        Top = 48
        Width = 97
        Height = 17
        Caption = #1046#1080#1088#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = CheckBox4Click
      end
      object CheckBox5: TCheckBox
        Left = 136
        Top = 48
        Width = 97
        Height = 17
        Caption = #1050#1091#1088#1089#1080#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = CheckBox4Click
      end
      object CheckBox6: TCheckBox
        Left = 272
        Top = 48
        Width = 105
        Height = 17
        Caption = #1055#1086#1076#1095#1077#1088#1082#1085#1091#1090#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = CheckBox4Click
      end
      object Edit3: TEdit
        Left = 168
        Top = 72
        Width = 289
        Height = 21
        TabOrder = 4
        Text = '<span style="color: navy;">'
      end
      object Edit4: TEdit
        Left = 168
        Top = 96
        Width = 289
        Height = 21
        TabOrder = 5
        Text = '</span>'
      end
      object Button2: TButton
        Left = 384
        Top = 125
        Width = 75
        Height = 25
        Caption = #1047#1072#1082#1088#1099#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = Button9Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1047#1072#1088#1077#1079#1077#1088#1074#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1089#1083#1086#1074#1072
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 8
        Top = 16
        Width = 74
        Height = 13
        Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 16
        Top = 80
        Width = 147
        Height = 13
        Caption = #1054#1090#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 16
        Top = 104
        Width = 147
        Height = 13
        Caption = #1047#1072#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ColorBox3: TColorBox
        Left = 120
        Top = 8
        Width = 145
        Height = 22
        ItemHeight = 16
        TabOrder = 0
        OnSelect = CheckBox7Click
      end
      object CheckBox7: TCheckBox
        Left = 16
        Top = 48
        Width = 97
        Height = 17
        Caption = #1046#1080#1088#1085#1099#1081
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 1
        OnClick = CheckBox7Click
      end
      object CheckBox8: TCheckBox
        Left = 136
        Top = 48
        Width = 97
        Height = 17
        Caption = #1050#1091#1088#1089#1080#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = CheckBox7Click
      end
      object CheckBox9: TCheckBox
        Left = 272
        Top = 48
        Width = 105
        Height = 17
        Caption = #1055#1086#1076#1095#1077#1088#1082#1085#1091#1090#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = CheckBox7Click
      end
      object Edit5: TEdit
        Left = 168
        Top = 72
        Width = 289
        Height = 21
        TabOrder = 4
        Text = '<b>'
      end
      object Edit6: TEdit
        Left = 168
        Top = 96
        Width = 289
        Height = 21
        TabOrder = 5
        Text = '</b>'
      end
      object Button3: TButton
        Left = 384
        Top = 125
        Width = 75
        Height = 25
        Caption = #1047#1072#1082#1088#1099#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = Button9Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label10: TLabel
        Left = 8
        Top = 16
        Width = 74
        Height = 13
        Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 16
        Top = 80
        Width = 147
        Height = 13
        Caption = #1054#1090#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 16
        Top = 104
        Width = 147
        Height = 13
        Caption = #1047#1072#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ColorBox4: TColorBox
        Left = 120
        Top = 8
        Width = 145
        Height = 22
        Selected = clNavy
        ItemHeight = 16
        TabOrder = 0
        OnSelect = CheckBox10Click
      end
      object CheckBox10: TCheckBox
        Left = 16
        Top = 48
        Width = 97
        Height = 17
        Caption = #1046#1080#1088#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = CheckBox10Click
      end
      object CheckBox11: TCheckBox
        Left = 136
        Top = 48
        Width = 97
        Height = 17
        Caption = #1050#1091#1088#1089#1080#1074
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 2
        OnClick = CheckBox10Click
      end
      object CheckBox12: TCheckBox
        Left = 272
        Top = 48
        Width = 106
        Height = 17
        Caption = #1055#1086#1076#1095#1077#1088#1082#1085#1091#1090#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = CheckBox10Click
      end
      object Edit7: TEdit
        Left = 168
        Top = 72
        Width = 289
        Height = 21
        TabOrder = 4
        Text = '<i style="color: navy;">'
      end
      object Edit8: TEdit
        Left = 168
        Top = 96
        Width = 289
        Height = 21
        TabOrder = 5
        Text = '</i>'
      end
      object Button4: TButton
        Left = 384
        Top = 125
        Width = 75
        Height = 25
        Caption = #1047#1072#1082#1088#1099#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = Button9Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = #1044#1080#1088#1077#1082#1090#1080#1074#1099' '#1082#1086#1084#1087#1080#1083#1103#1090#1086#1088#1072
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label13: TLabel
        Left = 8
        Top = 16
        Width = 74
        Height = 13
        Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 16
        Top = 80
        Width = 147
        Height = 13
        Caption = #1054#1090#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label15: TLabel
        Left = 16
        Top = 104
        Width = 147
        Height = 13
        Caption = #1047#1072#1082#1088#1099#1074#1072#1102#1097#1080#1081' HTML-'#1090#1101#1075
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ColorBox5: TColorBox
        Left = 120
        Top = 8
        Width = 145
        Height = 22
        Selected = clGreen
        ItemHeight = 16
        TabOrder = 0
        OnSelect = CheckBox13Click
      end
      object CheckBox13: TCheckBox
        Left = 16
        Top = 48
        Width = 97
        Height = 17
        Caption = #1046#1080#1088#1085#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = CheckBox13Click
      end
      object CheckBox14: TCheckBox
        Left = 136
        Top = 48
        Width = 97
        Height = 17
        Caption = #1050#1091#1088#1089#1080#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = CheckBox13Click
      end
      object CheckBox15: TCheckBox
        Left = 272
        Top = 48
        Width = 106
        Height = 17
        Caption = #1055#1086#1076#1095#1077#1088#1082#1085#1091#1090#1099#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = CheckBox13Click
      end
      object Edit9: TEdit
        Left = 168
        Top = 72
        Width = 289
        Height = 21
        TabOrder = 4
        Text = '<span style="color: green;">'
      end
      object Edit10: TEdit
        Left = 168
        Top = 96
        Width = 289
        Height = 21
        TabOrder = 5
        Text = '</span>'
      end
      object Button9: TButton
        Left = 384
        Top = 125
        Width = 75
        Height = 25
        Caption = #1047#1072#1082#1088#1099#1090#1100
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = Button9Click
      end
    end
  end
end
