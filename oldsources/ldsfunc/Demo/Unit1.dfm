object Form1: TForm1
  Left = 187
  Top = 114
  Width = 696
  Height = 480
  Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1076#1083#1103' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103' LDS-'#1092#1091#1085#1082#1094#1080#1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 688
    Height = 427
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1055#1088#1086#1094#1077#1089#1089#1086#1088'/'#1055#1086#1080#1089#1082' '#1074' '#1092#1072#1081#1083#1077
      object cpu_freq: TLabel
        Left = 32
        Top = 16
        Width = 48
        Height = 13
        Caption = #1063#1072#1089#1090#1086#1090#1072': '
      end
      object cpu_ident: TLabel
        Left = 32
        Top = 40
        Width = 73
        Height = 13
        Caption = #1054#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077': '
      end
      object cpu_name: TLabel
        Left = 32
        Top = 64
        Width = 56
        Height = 13
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077': '
      end
      object cpu_vendor: TLabel
        Left = 32
        Top = 88
        Width = 85
        Height = 13
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100': '
      end
      object cpu_mmx: TLabel
        Left = 32
        Top = 112
        Width = 73
        Height = 13
        Caption = #1057#1086#1087#1088#1086#1094#1077#1089#1089#1086#1088': '
      end
      object Label44: TLabel
        Left = 8
        Top = 160
        Width = 571
        Height = 13
        Caption = 
          #1042#1089#1077', '#1095#1090#1086' '#1074#1099' '#1079#1076#1077#1089#1100' '#1074#1080#1076#1080#1090#1077', '#1074#1099' '#1079#1072#1087#1088#1086#1089#1090#1086' '#1084#1086#1078#1077#1090#1077' '#1088#1077#1072#1083#1080#1079#1086#1074#1072#1090#1100' '#1074' '#1083#1102#1073#1086#1081 +
          ' '#1076#1088#1091#1075#1086#1081' '#1089#1074#1086#1077#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 192
        Width = 489
        Height = 177
        Caption = #1055#1086#1080#1089#1082' '#1074' '#1092#1072#1081#1083#1077
        TabOrder = 0
        object Label42: TLabel
          Left = 24
          Top = 120
          Width = 118
          Height = 13
          Caption = #1042#1074#1077#1076#1080#1090#1077' '#1089#1090#1088#1086#1082#1091' '#1087#1086#1080#1089#1082#1072
        end
        object Label43: TLabel
          Left = 250
          Top = 72
          Width = 74
          Height = 13
          Caption = #1058#1080#1087' '#1080#1089#1082#1086#1084#1086#1075#1086':'
        end
        object Gauge3: TGauge
          Left = 248
          Top = 33
          Width = 225
          Height = 20
          Progress = 0
        end
        object Label1: TLabel
          Left = 8
          Top = 16
          Width = 32
          Height = 13
          Caption = #1060#1072#1081#1083':'
        end
        object Label36: TLabel
          Left = 248
          Top = 16
          Width = 52
          Height = 13
          Caption = #1055#1088#1086#1075#1088#1077#1089#1089':'
        end
        object Button20: TButton
          Left = 8
          Top = 56
          Width = 209
          Height = 25
          Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1087#1086#1080#1089#1082
          TabOrder = 0
          OnClick = Button20Click
        end
        object Edit7: TEdit
          Left = 16
          Top = 140
          Width = 457
          Height = 21
          TabOrder = 1
        end
        object Button21: TButton
          Left = 8
          Top = 88
          Width = 209
          Height = 25
          Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086#1080#1089#1082
          TabOrder = 2
          OnClick = Button21Click
        end
        object ComboBox1: TComboBox
          Left = 248
          Top = 88
          Width = 225
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 3
          Text = 'HEX - '#1087#1086#1089#1083#1077#1076#1086#1074#1072#1090#1077#1083#1100#1085#1086#1089#1090#1100
          Items.Strings = (
            'HEX - '#1087#1086#1089#1083#1077#1076#1086#1074#1072#1090#1077#1083#1100#1085#1086#1089#1090#1100
            #1058#1077#1082#1089#1090' '#1089' '#1091#1095#1077#1090#1086#1084' '#1088#1077#1075#1080#1089#1090#1088#1072
            #1058#1077#1082#1089#1090' '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072)
        end
        object Edit8: TEdit
          Left = 8
          Top = 31
          Width = 185
          Height = 21
          TabOrder = 4
        end
        object Button24: TButton
          Left = 194
          Top = 31
          Width = 23
          Height = 22
          Caption = '...'
          TabOrder = 5
          OnClick = Button24Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1055#1072#1084#1103#1090#1100
      ImageIndex = 1
      object meml_PhisTotal: TLabel
        Left = 8
        Top = 16
        Width = 181
        Height = 13
        Caption = #1042#1089#1077#1075#1086' '#1092#1080#1079#1080#1095#1077#1089#1082#1086#1081' '#1087#1072#1084#1103#1090#1080', '#1052#1073#1072#1081#1090':  '
      end
      object meml_PhisUsage: TLabel
        Left = 8
        Top = 32
        Width = 146
        Height = 13
        Caption = #1047#1072#1085#1103#1090#1086' '#1092#1080#1079'. '#1087#1072#1084#1103#1090#1080', '#1052#1073#1072#1081#1090': '
      end
      object meml_PageTotal: TLabel
        Left = 8
        Top = 72
        Width = 168
        Height = 13
        Caption = #1056#1072#1079#1084#1077#1088' '#1092#1072#1081#1083#1072' '#1087#1086#1076#1082#1072#1095#1082#1080', '#1052#1073#1072#1081#1090': '
      end
      object meml_PageUsage: TLabel
        Left = 8
        Top = 88
        Width = 209
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077' '#1092#1072#1081#1083#1072' '#1087#1086#1076#1082#1072#1095#1082#1080', '#1052#1073#1072#1081#1090': '
      end
      object meml_VirtualTotal: TLabel
        Left = 8
        Top = 128
        Width = 181
        Height = 13
        Caption = #1042#1089#1077#1075#1086' '#1074#1080#1088#1090#1091#1072#1083#1100#1085#1086#1081' '#1087#1072#1084#1103#1090#1080', '#1052#1073#1072#1081#1090': '
      end
      object meml_VirtualUsage: TLabel
        Left = 8
        Top = 144
        Width = 225
        Height = 13
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086' '#1074#1080#1088#1090#1091#1072#1083#1100#1085#1086#1081' '#1087#1072#1084#1103#1090#1080', '#1052#1073#1072#1081#1090': '
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1044#1080#1089#1082#1080
      ImageIndex = 2
      object dil_Label: TLabel
        Left = 352
        Top = 16
        Width = 3
        Height = 13
      end
      object dil_Ser: TLabel
        Left = 352
        Top = 40
        Width = 3
        Height = 13
      end
      object dil_Fat: TLabel
        Left = 352
        Top = 64
        Width = 3
        Height = 13
      end
      object dil_TotSize: TLabel
        Left = 352
        Top = 88
        Width = 3
        Height = 13
      end
      object dil_FreeSize: TLabel
        Left = 352
        Top = 112
        Width = 3
        Height = 13
      end
      object dil_MaxPath: TLabel
        Left = 352
        Top = 136
        Width = 3
        Height = 13
      end
      object dil_TotClast: TLabel
        Left = 352
        Top = 160
        Width = 3
        Height = 13
      end
      object dil_FreeClast: TLabel
        Left = 352
        Top = 184
        Width = 3
        Height = 13
      end
      object dil_SecOnClast: TLabel
        Left = 352
        Top = 208
        Width = 3
        Height = 13
      end
      object dil_ByteOnSect: TLabel
        Left = 352
        Top = 232
        Width = 3
        Height = 13
      end
      object Label2: TLabel
        Left = 192
        Top = 16
        Width = 66
        Height = 13
        Caption = #1052#1077#1090#1082#1072' '#1090#1086#1084#1072': '
      end
      object Label3: TLabel
        Left = 192
        Top = 40
        Width = 92
        Height = 13
        Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088': '
      end
      object Label4: TLabel
        Left = 192
        Top = 64
        Width = 105
        Height = 13
        Caption = #1060#1072#1081#1083#1086#1074#1072#1103' '#1089#1080#1089#1090#1077#1084#1072': '
      end
      object Label9: TLabel
        Left = 192
        Top = 88
        Width = 113
        Height = 13
        Caption = #1056#1072#1079#1084#1077#1088' '#1076#1080#1089#1082#1072', '#1043#1073#1072#1081#1090': '
      end
      object Label10: TLabel
        Left = 192
        Top = 112
        Width = 124
        Height = 13
        Caption = #1054#1089#1090#1072#1083#1086#1089#1100' '#1084#1077#1089#1090#1072', '#1043#1073#1072#1081#1090': '
      end
      object Label11: TLabel
        Left = 192
        Top = 136
        Width = 152
        Height = 13
        Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1087#1091#1090#1100', '#1079#1085#1072#1082#1086#1074': '
      end
      object Label12: TLabel
        Left = 192
        Top = 160
        Width = 115
        Height = 13
        Caption = #1042#1089#1077#1075#1086' '#1082#1083#1072#1089#1090#1077#1088#1086#1074' ('#1061#1056'): '
      end
      object Label13: TLabel
        Left = 192
        Top = 184
        Width = 134
        Height = 13
        Caption = #1057#1074#1086#1073#1086#1076#1085#1086' '#1082#1083#1072#1089#1090#1077#1088#1086#1074' ('#1061#1056'): '
      end
      object Label14: TLabel
        Left = 192
        Top = 208
        Width = 113
        Height = 13
        Caption = #1057#1077#1082#1090#1086#1088#1086#1074' '#1074' '#1082#1083#1072#1089#1090#1077#1088#1077': '
      end
      object Label15: TLabel
        Left = 192
        Top = 232
        Width = 83
        Height = 13
        Caption = #1041#1072#1081#1090' '#1074' '#1089#1077#1082#1090#1086#1088#1077': '
      end
      object DriveComboBox1: TDriveComboBox
        Left = 8
        Top = 16
        Width = 145
        Height = 19
        TabOrder = 0
      end
      object Button1: TButton
        Left = 8
        Top = 48
        Width = 145
        Height = 25
        Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1074#1077#1076#1077#1085#1080#1103
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 8
        Top = 80
        Width = 145
        Height = 25
        Caption = #1059#1079#1085#1072#1090#1100' '#1088#1072#1079#1084#1077#1088' '#1082#1083#1072#1089#1090#1077#1088#1072
        TabOrder = 2
        OnClick = Button2Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1092#1072#1081#1083#1072#1084#1080
      ImageIndex = 3
      object Label16: TLabel
        Left = 8
        Top = 72
        Width = 111
        Height = 13
        Caption = #1044#1080#1088#1077#1082#1090#1086#1088#1080#1103'-'#1080#1089#1090#1086#1095#1085#1080#1082
      end
      object Label17: TLabel
        Left = 8
        Top = 120
        Width = 115
        Height = 13
        Caption = #1044#1080#1088#1077#1082#1090#1086#1088#1080#1103'-'#1087#1088#1080#1077#1084#1085#1080#1082
      end
      object Label18: TLabel
        Left = 8
        Top = 176
        Width = 78
        Height = 13
        Caption = #1060#1072#1081#1083'-'#1080#1089#1090#1086#1095#1085#1080#1082
      end
      object Label19: TLabel
        Left = 8
        Top = 216
        Width = 82
        Height = 13
        Caption = #1060#1072#1081#1083'-'#1087#1088#1080#1077#1084#1085#1080#1082
      end
      object Label8: TLabel
        Left = 8
        Top = 8
        Width = 48
        Height = 13
        Caption = #1051#1086#1075'-'#1092#1072#1081#1083
      end
      object Edit1: TEdit
        Left = 8
        Top = 88
        Width = 201
        Height = 21
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 8
        Top = 136
        Width = 201
        Height = 21
        TabOrder = 1
      end
      object Button3: TButton
        Left = 216
        Top = 88
        Width = 75
        Height = 25
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
        TabOrder = 2
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 216
        Top = 136
        Width = 75
        Height = 25
        Caption = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100
        TabOrder = 3
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 488
        Top = 304
        Width = 113
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1082#1072#1090#1072#1083#1086#1075
        TabOrder = 4
        OnClick = Button5Click
      end
      object Edit3: TEdit
        Left = 8
        Top = 304
        Width = 473
        Height = 21
        TabOrder = 5
      end
      object Edit4: TEdit
        Left = 8
        Top = 192
        Width = 201
        Height = 21
        TabOrder = 6
      end
      object Edit5: TEdit
        Left = 8
        Top = 232
        Width = 201
        Height = 21
        TabOrder = 7
      end
      object Button6: TButton
        Left = 488
        Top = 272
        Width = 113
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1092#1072#1081#1083
        TabOrder = 8
        OnClick = Button6Click
      end
      object Edit6: TEdit
        Left = 8
        Top = 272
        Width = 473
        Height = 21
        TabOrder = 9
      end
      object Button7: TButton
        Left = 216
        Top = 192
        Width = 75
        Height = 25
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
        TabOrder = 10
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 216
        Top = 232
        Width = 75
        Height = 25
        Caption = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100
        TabOrder = 11
        OnClick = Button8Click
      end
      object Button23: TButton
        Left = 384
        Top = 212
        Width = 289
        Height = 25
        Caption = #1055#1056#1045#1050#1056#1040#1058#1048#1058#1068' '#1069#1058#1054'!!!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        TabOrder = 12
        OnClick = Button23Click
      end
      object GroupBox1: TGroupBox
        Left = 384
        Top = 32
        Width = 289
        Height = 169
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077
        TabOrder = 13
        object Label5: TLabel
          Left = 72
          Top = 16
          Width = 51
          Height = 13
          Caption = #1057#1082#1086#1088#1086#1089#1090#1100':'
        end
        object Label6: TLabel
          Left = 16
          Top = 81
          Width = 105
          Height = 13
          Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077' '#1092#1072#1081#1083#1072':'
        end
        object Gauge1: TGauge
          Left = 16
          Top = 97
          Width = 217
          Height = 20
          Progress = 0
        end
        object lSpeed: TLabel
          Left = 128
          Top = 16
          Width = 3
          Height = 13
        end
        object Gauge2: TGauge
          Left = 16
          Top = 136
          Width = 217
          Height = 20
          Progress = 0
        end
        object L11: TLabel
          Left = 16
          Top = 40
          Width = 3
          Height = 13
        end
        object L22: TLabel
          Left = 16
          Top = 61
          Width = 3
          Height = 13
        end
        object Label7: TLabel
          Left = 16
          Top = 120
          Width = 111
          Height = 13
          Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1085#1086' '#1092#1072#1081#1083#1086#1074':'
        end
      end
      object edLog: TEdit
        Left = 8
        Top = 24
        Width = 201
        Height = 21
        TabOrder = 14
      end
    end
    object TabSheet5: TTabSheet
      Caption = #1052#1086#1085#1080#1090#1086#1088
      ImageIndex = 4
      object Label20: TLabel
        Left = 16
        Top = 24
        Width = 117
        Height = 13
        Caption = #1056#1072#1079#1088#1103#1076#1085#1086#1089#1090#1100' '#1087#1080#1082#1089#1077#1083#1103': '
      end
      object Label21: TLabel
        Left = 16
        Top = 48
        Width = 148
        Height = 13
        Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1087#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080':'
      end
      object Label22: TLabel
        Left = 16
        Top = 72
        Width = 137
        Height = 13
        Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1087#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080':'
      end
      object Label23: TLabel
        Left = 16
        Top = 96
        Width = 68
        Height = 13
        Caption = #1063#1072#1089#1090#1086#1090#1072' ('#1061#1056'):'
      end
      object Label24: TLabel
        Left = 16
        Top = 120
        Width = 145
        Height = 13
        Caption = #1064#1080#1088#1080#1085#1072' '#1074' '#1084#1080#1083#1083#1080#1084#1077#1090#1088#1072#1093' ('#1061#1056'):'
      end
      object Label25: TLabel
        Left = 16
        Top = 144
        Width = 144
        Height = 13
        Caption = #1042#1099#1089#1086#1090#1072' '#1074' '#1084#1080#1083#1083#1080#1084#1077#1090#1088#1072#1093' ('#1061#1056'):'
      end
      object Label26: TLabel
        Left = 16
        Top = 168
        Width = 116
        Height = 13
        Caption = #1055#1080#1082#1089'. '#1085#1072' '#1076#1102#1081#1084' '#1087#1086' '#1075#1086#1088'.:'
      end
      object Label27: TLabel
        Left = 16
        Top = 192
        Width = 122
        Height = 13
        Caption = #1055#1080#1082#1089'. '#1085#1072' '#1076#1102#1081#1084' '#1087#1086' '#1074#1077#1088#1090'.:'
      end
      object dsl_PixBits: TLabel
        Left = 208
        Top = 24
        Width = 3
        Height = 13
      end
      object dsl_PixHor: TLabel
        Left = 208
        Top = 48
        Width = 3
        Height = 13
      end
      object dsl_PixVert: TLabel
        Left = 208
        Top = 72
        Width = 3
        Height = 13
      end
      object dsl_Freq: TLabel
        Left = 208
        Top = 96
        Width = 3
        Height = 13
      end
      object dsl_MMHor: TLabel
        Left = 208
        Top = 120
        Width = 3
        Height = 13
      end
      object dsl_MMVert: TLabel
        Left = 208
        Top = 144
        Width = 3
        Height = 13
      end
      object dsl_PixHorInch: TLabel
        Left = 208
        Top = 168
        Width = 3
        Height = 13
      end
      object dsl_PixVertInch: TLabel
        Left = 208
        Top = 192
        Width = 3
        Height = 13
      end
      object Label28: TLabel
        Left = 352
        Top = 16
        Width = 107
        Height = 13
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      end
      object Label29: TLabel
        Left = 272
        Top = 40
        Width = 86
        Height = 13
        Caption = #1043#1086#1088'. '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1077
      end
      object Label30: TLabel
        Left = 416
        Top = 40
        Width = 92
        Height = 13
        Caption = #1042#1077#1088#1090'. '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1077
      end
      object Label31: TLabel
        Left = 272
        Top = 88
        Width = 134
        Height = 13
        Caption = #1056#1072#1079#1088#1103#1076#1085#1086#1089#1090#1100' '#1087#1080#1082#1089#1077#1083#1103', '#1073#1080#1090
      end
      object Label32: TLabel
        Left = 272
        Top = 136
        Width = 307
        Height = 13
        Caption = #1042#1053#1048#1052#1040#1053#1048#1045'! '#1044#1083#1103' '#1061#1056' '#1077#1089#1090#1100' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1095#1072#1089#1090#1086#1090#1099
      end
      object Label34: TLabel
        Left = 272
        Top = 152
        Width = 269
        Height = 13
        Caption = #1059#1082#1072#1078#1080#1090#1077' '#1085#1086#1083#1100', '#1077#1089#1083#1080' '#1085#1077' '#1093#1086#1090#1080#1090#1077' '#1084#1077#1085#1103#1090#1100' '#1082'.-'#1083'. '#1087#1072#1088#1072#1084#1077#1090#1088
      end
      object Button9: TButton
        Left = 16
        Top = 208
        Width = 75
        Height = 25
        Caption = #1054#1073#1085#1086#1074#1080#1090#1100
        TabOrder = 0
        OnClick = Button9Click
      end
      object SpinEdit1: TSpinEdit
        Left = 272
        Top = 56
        Width = 121
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object SpinEdit2: TSpinEdit
        Left = 416
        Top = 56
        Width = 121
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 2
        Value = 0
      end
      object SpinEdit3: TSpinEdit
        Left = 272
        Top = 104
        Width = 121
        Height = 22
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 0
      end
      object Button10: TButton
        Left = 272
        Top = 168
        Width = 265
        Height = 25
        Caption = #1055#1088#1080#1085#1103#1090#1100
        TabOrder = 4
        OnClick = Button10Click
      end
    end
    object TabSheet6: TTabSheet
      Caption = #1057#1080#1089#1090#1077#1084#1072
      ImageIndex = 5
      object Label33: TLabel
        Left = 392
        Top = 24
        Width = 193
        Height = 52
        Caption = 
          #1042' '#1044#1077#1083#1092#1080' '#1077#1089#1090#1100' '#1072#1078' 3 '#1092#1091#1085#1082#1094#1080#1080' '#1076#1083#1103' '#1080#1079#1074#1083#1077#1095#1077#1085#1080#1103' '#1074#1088#1077#1084#1077#1085#1085#1086#1081' '#1087#1072#1087#1082#1080', '#1085#1086' '#1074#1089#1077 +
          ' '#1086#1085#1080' '#1074#1086#1079#1074#1088#1072#1097#1072#1102#1090' '#1101#1090#1086#1090' '#1087#1091#1090#1100' '#1074' '#1044#1054#1057'-'#1092#1086#1088#1084#1072#1090#1077' (8 '#1079#1085#1072#1082#1086#1074')'
        WordWrap = True
      end
      object Label37: TLabel
        Left = 392
        Top = 240
        Width = 178
        Height = 78
        Caption = 
          #1042#1053#1048#1052#1040#1053#1048#1045'!!! '#1042' '#1088#1072#1079#1085#1099#1093' '#1054#1057' '#1084#1086#1078#1077#1090' '#1073#1099#1090#1100' '#1089#1074#1086#1081' '#1085#1072#1073#1086#1088' '#1089#1080#1089#1090#1077#1084#1085#1099#1093' '#1087#1091#1090#1077#1081'. '#1057 +
          #1086#1086#1090#1074#1077#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1077' '#1087#1086#1084#1077#1095#1072#1102#1090#1089#1103' '#1087#1086#1084#1077#1090#1082#1086#1081' '#1061#1056', '#1085#1072#1087#1088#1080#1084#1077#1088', PATH' +
          '_RESOURCES_XP  '
        WordWrap = True
      end
      object Button11: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Caption = #1055#1086#1082#1072#1079#1072#1090#1100
        TabOrder = 0
        OnClick = Button11Click
      end
      object Memo1: TMemo
        Left = 0
        Top = 40
        Width = 377
        Height = 321
        ScrollBars = ssBoth
        TabOrder = 1
      end
      object Button14: TButton
        Left = 384
        Top = 208
        Width = 217
        Height = 25
        Caption = #1057#1087#1080#1089#1086#1082' '#1089#1080#1089#1090#1077#1084#1085#1099#1093' '#1087#1091#1090#1077#1081
        TabOrder = 2
        OnClick = Button14Click
      end
    end
    object TabSheet7: TTabSheet
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1082#1086#1085#1090#1091#1088#1086#1074
      ImageIndex = 6
      object Label39: TLabel
        Left = 16
        Top = 80
        Width = 182
        Height = 78
        Caption = 
          #1042#1099#1073#1077#1088#1080#1090#1077' '#1088#1080#1089#1091#1085#1086#1082'. '#1062#1074#1077#1090#1085#1072#1103' '#1087#1072#1085#1077#1083#1100' '#1076#1086#1083#1078#1085#1072' '#1087#1086#1084#1077#1085#1103#1090#1100' '#1089#1074#1086#1081' '#1082#1086#1085#1090#1091#1088'. '#1055#1088 +
          #1080' '#1085#1072#1078#1072#1090#1080#1080' '#1084#1099#1096#1082#1086#1081' '#1085#1072' '#1101#1090#1086#1081' '#1087#1072#1085#1077#1083#1080' '#1086#1085#1072' '#1080#1079#1084#1077#1085#1080#1090' '#1094#1074#1077#1090'. '#1047#1072#1084#1077#1090#1100', '#1095#1090#1086' '#1087#1072 +
          #1085#1077#1083#1100' '#1088#1077#1072#1075#1080#1088#1091#1077#1090' '#1085#1072' '#1084#1099#1096#1100', '#1077#1089#1083#1080' '#1082#1083#1080#1082#1085#1091#1083#1080' '#1074' '#1094#1074#1077#1090#1085#1086#1081' '#1086#1073#1083#1072#1089#1090#1080
        WordWrap = True
      end
      object Label41: TLabel
        Left = 16
        Top = 184
        Width = 153
        Height = 130
        Caption = 
          #1050#1088#1086#1084#1077' '#1101#1090#1086#1075#1086' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1085#1090#1091#1088' '#1084#1086#1078#1085#1086' '#1091' '#1074#1089#1077#1093' '#1082#1086#1084#1087#1086#1085#1077#1085#1090', '#1080#1084#1077#1102#1097#1080#1093' '#1089#1074#1086#1081 +
          #1089#1090#1074#1086' Handle. '#1058#1072#1082' '#1084#1086#1078#1085#1086' '#1087#1086#1084#1077#1085#1103#1090#1100' '#1096#1082#1091#1088#1082#1091' '#1091' '#1092#1086#1088#1084#1099', '#1082#1085#1086#1087#1086#1082' '#1080' '#1076#1088'. '#1045#1089#1083 +
          #1080' '#1085#1072' '#1092#1086#1088#1084#1091' '#1087#1086#1084#1077#1089#1090#1080#1090#1100' TImage '#1080' '#1074' '#1085#1077#1075#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1090#1078#1077' '#1088#1080#1089#1091#1085#1086#1082', '#1090#1086 +
          ' '#1084#1086#1078#1085#1086' '#1089#1076#1077#1083#1072#1090#1100' '#1090#1072#1082', '#1095#1090#1086#1073#1099' '#1092#1086#1088#1084#1072' '#1080#1084#1077#1083#1072' '#1074#1080#1076' '#1088#1080#1089#1091#1085#1082#1072
        WordWrap = True
      end
      object Button12: TButton
        Left = 8
        Top = 8
        Width = 145
        Height = 25
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1041#1052#1055'-'#1092#1072#1081#1083
        TabOrder = 0
        OnClick = Button12Click
      end
      object Panel1: TPanel
        Left = 224
        Top = 8
        Width = 361
        Height = 345
        DockSite = True
        TabOrder = 1
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 359
          Height = 343
          Align = alClient
          Color = clMaroon
          DockSite = True
          DragCursor = crHandPoint
          DragKind = dkDock
          TabOrder = 0
          OnMouseDown = Panel2MouseDown
        end
      end
      object Button18: TButton
        Left = 16
        Top = 336
        Width = 153
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1092#1086#1088#1084#1091
        TabOrder = 2
        OnClick = Button18Click
      end
    end
    object TabSheet8: TTabSheet
      Caption = #1047#1072#1087#1091#1089#1082' '#1092#1072#1081#1083#1086#1074
      ImageIndex = 7
      object Label38: TLabel
        Left = 352
        Top = 96
        Width = 225
        Height = 26
        Caption = 
          #1045#1089#1083#1080' '#1074#1099' '#1086#1089#1090#1072#1074#1080#1090#1077' '#1074#1089#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1091#1089#1090#1099#1084#1080', '#1090#1086' '#1086#1082#1072#1078#1080#1090#1077#1083#1100' '#1074' '#1087#1072#1087#1082#1077' '#1089' '#1101 +
          #1090#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1086#1081'!!!'
        WordWrap = True
      end
      object Label35: TLabel
        Left = 352
        Top = 24
        Width = 176
        Height = 52
        Caption = 
          #1047#1076#1077#1089#1100' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1074#1099#1079#1086#1074' '#1092#1091#1085#1082#1094#1080#1080' ShellExecute. '#1053#1077' '#1085#1091#1078#1085#1086' '#1082#1072#1078#1076#1099#1081' '#1088#1072#1079 +
          ' '#1074#1089#1087#1086#1084#1080#1085#1072#1090#1100', '#1074' '#1082#1072#1082#1086#1084' '#1084#1086#1076#1091#1083#1077' '#1085#1072#1093#1086#1076#1080#1090#1089#1103' '#1101#1090#1072' '#1092#1091#1085#1082#1094#1080#1103
        WordWrap = True
      end
      object LabeledEdit1: TLabeledEdit
        Left = 64
        Top = 40
        Width = 241
        Height = 21
        EditLabel.Width = 241
        EditLabel.Height = 13
        EditLabel.Caption = #1048#1084#1103' '#1079#1072#1087#1091#1089#1082#1072#1077#1084#1086#1075#1086' '#1092#1072#1081#1083#1072' ('#1085#1077' '#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1086' '#1077#1093#1077')'
        TabOrder = 0
      end
      object LabeledEdit2: TLabeledEdit
        Left = 64
        Top = 88
        Width = 241
        Height = 21
        EditLabel.Width = 138
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1077#1088#1077#1076#1072#1074#1072#1077#1084#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
        TabOrder = 1
      end
      object LabeledEdit3: TLabeledEdit
        Left = 64
        Top = 136
        Width = 241
        Height = 21
        EditLabel.Width = 85
        EditLabel.Height = 13
        EditLabel.Caption = #1056#1072#1073#1086#1095#1080#1081' '#1082#1072#1090#1072#1083#1086#1075
        TabOrder = 2
      end
      object Button13: TButton
        Left = 64
        Top = 192
        Width = 241
        Height = 25
        Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100
        TabOrder = 3
        OnClick = Button13Click
      end
    end
    object TabSheet9: TTabSheet
      Caption = #1071#1088#1083#1099#1082#1080
      ImageIndex = 8
      object Label40: TLabel
        Left = 456
        Top = 32
        Width = 135
        Height = 65
        Caption = 
          #1042' '#1082#1072#1095#1077#1089#1090#1074#1077' '#1087#1086#1083#1085#1086#1075#1086' '#1080#1084#1077#1085#1080' '#1092#1072#1081#1083#1072' '#1074#1099' '#1084#1086#1078#1077#1090#1077' '#1079#1072#1076#1072#1090#1100' '#1095#1090#1086' '#1091#1075#1086#1076#1085#1086', '#1085#1086' '#1088 +
          #1072#1073#1086#1090#1072#1090#1100' '#1089#1086#1079#1076#1072#1085#1085#1099#1081' '#1103#1088#1083#1099#1082' '#1073#1091#1076#1077#1090' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1086
        WordWrap = True
      end
      object LabeledEdit4: TLabeledEdit
        Left = 88
        Top = 32
        Width = 353
        Height = 21
        EditLabel.Width = 229
        EditLabel.Height = 13
        EditLabel.Caption = #1054#1090#1085#1086#1089#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1091#1090#1100' ('#1044#1083#1103' "'#1042#1089#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099'")'
        TabOrder = 0
      end
      object LabeledEdit5: TLabeledEdit
        Left = 88
        Top = 80
        Width = 353
        Height = 21
        EditLabel.Width = 158
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1086#1083#1085#1086#1077' '#1080#1084#1103' '#1090#1088#1077#1073#1091#1077#1084#1086#1075#1086' '#1092#1072#1081#1083#1072
        TabOrder = 1
      end
      object LabeledEdit6: TLabeledEdit
        Left = 88
        Top = 128
        Width = 353
        Height = 21
        EditLabel.Width = 138
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1077#1088#1077#1076#1072#1074#1072#1077#1084#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
        TabOrder = 2
      end
      object Button15: TButton
        Left = 88
        Top = 240
        Width = 353
        Height = 25
        Caption = #1071#1088#1083#1099#1082' '#1074' '#1084#1077#1085#1102' '#1055#1059#1057#1050'\'#1042#1089#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
        TabOrder = 3
        OnClick = Button15Click
      end
      object Button16: TButton
        Left = 88
        Top = 280
        Width = 353
        Height = 25
        Caption = #1071#1088#1083#1099#1082' '#1085#1072' '#1088#1072#1073#1086#1095#1080#1081' '#1089#1090#1086#1083
        TabOrder = 4
        OnClick = Button16Click
      end
      object LabeledEdit7: TLabeledEdit
        Left = 88
        Top = 168
        Width = 353
        Height = 21
        EditLabel.Width = 221
        EditLabel.Height = 13
        EditLabel.Caption = #1050#1072#1090#1072#1083#1086#1075' '#1103#1088#1083#1099#1082#1072' ('#1076#1083#1103' "'#1042' '#1091#1082#1072#1079#1072#1085#1085#1086#1084' '#1084#1077#1089#1090#1077'")'
        TabOrder = 5
      end
      object Button17: TButton
        Left = 88
        Top = 200
        Width = 353
        Height = 25
        Caption = #1071#1088#1083#1099#1082' '#1074' '#1091#1082#1072#1079#1072#1085#1085#1086#1084' '#1084#1077#1089#1090#1077
        TabOrder = 6
        OnClick = Button17Click
      end
    end
    object TabSheet10: TTabSheet
      Caption = #1061#1077#1096#1080#1088#1086#1074#1072#1085#1080#1077' '#1090#1077#1082#1089#1090#1072
      ImageIndex = 9
      object Label46: TLabel
        Left = 256
        Top = 24
        Width = 73
        Height = 13
        Caption = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1082#1089#1090
      end
      object memoHash: TMemo
        Left = 16
        Top = 40
        Width = 569
        Height = 281
        TabOrder = 0
      end
      object Button22: TButton
        Left = 16
        Top = 336
        Width = 121
        Height = 25
        Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1093#1077#1096
        TabOrder = 1
        OnClick = Button22Click
      end
      object edHash: TEdit
        Left = 152
        Top = 336
        Width = 433
        Height = 21
        TabOrder = 2
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 427
    Width = 688
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 20
    Top = 72
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.*|*.*'
    Left = 260
    Top = 234
  end
  object cpu_Timer: TTimer
    OnTimer = cpu_TimerTimer
    Left = 20
    Top = 16
  end
end
