object Form1: TForm1
  Left = 109
  Top = 57
  Width = 830
  Height = 640
  Caption = #1058#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1092#1091#1085#1082#1094#1080#1081' '#1089#1080#1089#1090#1077#1084#1099' MatriX'
  Color = clBtnFace
  Constraints.MaxHeight = 640
  Constraints.MaxWidth = 830
  Constraints.MinHeight = 640
  Constraints.MinWidth = 830
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    000877777777777777777777777000000008FFFFFFFFFFFFFFFFFFFFFF700000
    0008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFFF777777778888777FF700000
    0008FFFFFFFFFFFFFFFFFFFFFF7000000008FFF7778888777777777FFF700000
    00088FFFFFFFFFFFFFFFFFFFFF7000000007B87FFFFFFFFF7777FFFFFF700000
    0007BB3FFFFFFFFFFFFFFFFFFF70000000033B917FFFFF8F77788877FF700000
    00811BB93FFFF81FFFFFFFFFFF700008001111BB918F818F7777777FFF700088
    1001111B339111FFFFFFFFFFFF7008111100111BB39918FF77777777FF707811
    11100111BB9917FFFFFFFFFFFF70008811100011BB911FF7788877FFFF700000
    71000011BB918FFFFFFFFFFFFF700000000000113B91FF7777777777FF700000
    007000013B91FFFFFFFFFFFFFF700000000870013B98FF77777FFFFFFF700000
    0008F7003B17FFFFFFFFFFFFFF7000000008FF803B1FF77777FF800000000000
    0008FFF8337FFFFFFFFF8FFF780000000008FFF711FFFFFFFFFF8FF780000000
    0008FFFFFFFFFFFFFFFF8F78000000000008F7777777777777FF878000000000
    0008FFFFFFFFFFFFFFFF8800000000000008FFFFFFFFFFFFFFFF800000000000
    000888888888888888888000000000000000000000000000000000000000FFFF
    FFFFFE000000FE000000FE000000FE000000FE000000FE000000FE000000FE00
    0000FE000000FE000000FE000000FC000000E0000000C0000000800000000000
    0000C0000000F0000000FC000000FC000000FE000000FE000000FE000000FE00
    0001FE000003FE000007FE00000FFE00001FFE00003FFE00007FFFFFFFFF}
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object panMain: TPanel
    Left = 177
    Top = 0
    Width = 645
    Height = 606
    Align = alClient
    TabOrder = 0
    object panFillArrays: TPanel
      Tag = 14
      Left = 153
      Top = 241
      Width = 589
      Height = 553
      TabOrder = 7
      object GroupBox18: TGroupBox
        Left = 0
        Top = 80
        Width = 481
        Height = 105
        Caption = #1056#1072#1074#1085#1086#1084#1077#1088#1085#1086#1077' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label53: TLabel
          Left = 8
          Top = 16
          Width = 44
          Height = 13
          Caption = #1052#1072#1090#1088#1080#1094#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label54: TLabel
          Left = 8
          Top = 56
          Width = 105
          Height = 13
          Caption = #1053#1072#1095#1072#1083#1100#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label55: TLabel
          Left = 136
          Top = 56
          Width = 83
          Height = 13
          Caption = #1064#1072#1075' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit29: TEdit
          Left = 8
          Top = 32
          Width = 249
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'A'
        end
        object Edit30: TEdit
          Left = 8
          Top = 72
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = '1'
        end
        object Edit31: TEdit
          Left = 136
          Top = 72
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '0'
        end
        object Button24: TButton
          Left = 272
          Top = 32
          Width = 177
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button24Click
        end
      end
      object GroupBox19: TGroupBox
        Left = 0
        Top = 8
        Width = 481
        Height = 65
        Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1089#1083#1091#1095#1072#1081#1085#1099#1084#1080' '#1095#1080#1089#1083#1072#1084#1080' '#1086#1090' 0 '#1076#1086' 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label52: TLabel
          Left = 8
          Top = 16
          Width = 44
          Height = 13
          Caption = #1052#1072#1090#1088#1080#1094#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit28: TEdit
          Left = 8
          Top = 32
          Width = 249
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'A'
        end
        object Button25: TButton
          Left = 272
          Top = 32
          Width = 177
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Button25Click
        end
      end
      object GroupBox20: TGroupBox
        Left = 0
        Top = 192
        Width = 481
        Height = 105
        Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1072'-'#1076#1080#1072#1087#1072#1079#1086#1085#1072', '#1087#1086' '#1079#1072#1076#1072#1085#1085#1099#1084' '#1075#1088#1072#1085#1080#1094#1072#1084' '#1080' '#1096#1072#1075#1086#1084
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label56: TLabel
          Left = 8
          Top = 16
          Width = 44
          Height = 13
          Caption = #1052#1072#1090#1088#1080#1094#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label57: TLabel
          Left = 8
          Top = 56
          Width = 105
          Height = 13
          Caption = #1053#1072#1095#1072#1083#1100#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label58: TLabel
          Left = 136
          Top = 56
          Width = 20
          Height = 13
          Caption = #1064#1072#1075
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label59: TLabel
          Left = 256
          Top = 56
          Width = 98
          Height = 13
          Caption = #1050#1086#1085#1077#1095#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit32: TEdit
          Left = 8
          Top = 32
          Width = 249
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'A'
        end
        object Edit33: TEdit
          Left = 8
          Top = 72
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = '1'
        end
        object Edit34: TEdit
          Left = 128
          Top = 72
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '10'
        end
        object Button27: TButton
          Left = 272
          Top = 24
          Width = 177
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button27Click
        end
        object Edit35: TEdit
          Left = 264
          Top = 72
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Text = '100'
        end
      end
      object GroupBox47: TGroupBox
        Left = 0
        Top = 304
        Width = 481
        Height = 105
        Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1072' - '#1076#1080#1072#1087#1072#1079#1086#1085#1072' '#1087#1086' '#1079#1072#1076#1072#1085#1085#1099#1084' '#1075#1088#1072#1085#1080#1094#1072#1084' '#1080' '#1095#1080#1089#1083#1091' '#1090#1086#1095#1077#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object Label159: TLabel
          Left = 8
          Top = 16
          Width = 44
          Height = 13
          Caption = #1052#1072#1090#1088#1080#1094#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label160: TLabel
          Left = 8
          Top = 56
          Width = 105
          Height = 13
          Caption = #1053#1072#1095#1072#1083#1100#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label161: TLabel
          Left = 240
          Top = 56
          Width = 63
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1090#1086#1095#1077#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label162: TLabel
          Left = 120
          Top = 56
          Width = 98
          Height = 13
          Caption = #1050#1086#1085#1077#1095#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit112: TEdit
          Left = 8
          Top = 32
          Width = 249
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'A'
        end
        object Edit113: TEdit
          Left = 8
          Top = 72
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = '1'
        end
        object Edit114: TEdit
          Left = 232
          Top = 72
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '10'
        end
        object Button36: TButton
          Left = 272
          Top = 24
          Width = 177
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button36Click
        end
        object Edit115: TEdit
          Left = 120
          Top = 72
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Text = '100'
        end
      end
    end
    object NNet2: TPanel
      Tag = 999
      Left = 465
      Top = 41
      Width = 544
      Height = 553
      TabOrder = 16
      DesignSize = (
        544
        553)
      object Chart1: TChart
        Left = 8
        Top = 144
        Width = 529
        Height = 234
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        BottomAxis.Title.Caption = #1048#1090#1077#1088#1072#1094#1080#1080' '#1086#1073#1091#1095#1077#1085#1080#1103
        BottomAxis.Title.Font.Charset = DEFAULT_CHARSET
        BottomAxis.Title.Font.Color = clBlue
        BottomAxis.Title.Font.Height = -11
        BottomAxis.Title.Font.Name = 'Arial'
        BottomAxis.Title.Font.Style = []
        LeftAxis.Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1094#1077#1083#1077#1074#1086#1081' '#1092#1091#1085#1082#1094#1080#1080
        LeftAxis.Title.Font.Charset = DEFAULT_CHARSET
        LeftAxis.Title.Font.Color = clBlue
        LeftAxis.Title.Font.Height = -11
        LeftAxis.Title.Font.Name = 'Arial'
        LeftAxis.Title.Font.Style = []
        Legend.Visible = False
        TabOrder = 0
        Anchors = [akLeft, akTop, akRight]
        object Series1: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clRed
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
        object Series2: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clGreen
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
      object GroupBox52: TGroupBox
        Left = 8
        Top = 8
        Width = 409
        Height = 129
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1073#1091#1095#1077#1085#1080#1103
        TabOrder = 1
        object Label157: TLabel
          Left = 8
          Top = 16
          Width = 74
          Height = 13
          Caption = #1054#1073#1091#1095'. '#1074#1099#1073#1086#1088#1082#1072
        end
        object Label158: TLabel
          Left = 104
          Top = 16
          Width = 100
          Height = 13
          Caption = #1058#1088#1077#1073#1091#1077#1084#1099#1077' '#1074#1099#1093#1086#1076#1099
        end
        object Label172: TLabel
          Left = 8
          Top = 64
          Width = 85
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' - '#1074#1077#1089#1072
        end
        object Label173: TLabel
          Left = 208
          Top = 16
          Width = 58
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1101#1087#1086#1093
        end
        object Label174: TLabel
          Left = 104
          Top = 64
          Width = 97
          Height = 13
          Caption = #1058#1088#1077#1073'. '#1087#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100
        end
        object Label175: TLabel
          Left = 208
          Top = 64
          Width = 82
          Height = 13
          Caption = #1042#1088#1077#1084#1103' '#1086#1073#1091#1095#1077#1085#1080#1103
        end
        object Label176: TLabel
          Left = 304
          Top = 16
          Width = 89
          Height = 13
          Caption = #1054#1096#1080#1073#1082#1072' '#1086#1073#1091#1095#1077#1085#1080#1103
        end
        object Edit105: TEdit
          Left = 8
          Top = 32
          Width = 89
          Height = 21
          TabOrder = 0
        end
        object Edit106: TEdit
          Left = 104
          Top = 32
          Width = 89
          Height = 21
          TabOrder = 1
        end
        object Edit107: TEdit
          Left = 8
          Top = 80
          Width = 89
          Height = 21
          TabOrder = 2
          Text = 'W'
        end
        object Edit110: TEdit
          Left = 208
          Top = 32
          Width = 89
          Height = 21
          TabOrder = 3
          Text = '50'
        end
        object Edit111: TEdit
          Left = 104
          Top = 80
          Width = 89
          Height = 21
          TabOrder = 4
          Text = '0.01'
        end
        object Edit121: TEdit
          Left = 208
          Top = 80
          Width = 89
          Height = 21
          TabOrder = 5
          Text = 'T'
        end
        object Edit122: TEdit
          Left = 304
          Top = 32
          Width = 89
          Height = 21
          TabOrder = 6
          Text = 'E'
        end
        object Button76: TButton
          Left = 304
          Top = 77
          Width = 87
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          TabOrder = 7
          OnClick = Button76Click
        end
      end
    end
    object panStreams: TPanel
      Tag = 15
      Left = 177
      Top = 217
      Width = 638
      Height = 553
      TabOrder = 8
      object GroupBox21: TGroupBox
        Left = 8
        Top = 8
        Width = 569
        Height = 316
        Caption = 
          #1063#1090#1077#1085#1080#1077'/'#1079#1072#1087#1080#1089#1100' '#1084#1072#1089#1089#1080#1074#1072' '#1087#1086' '#1091#1082#1072#1079#1072#1085#1085#1086#1084#1091' '#1072#1076#1088#1077#1089#1091' ('#1089#1084#1077#1097#1077#1085#1080#1102') '#1086#1087#1077#1088#1072#1090#1080#1074#1085#1086 +
          #1081' '#1087#1072#1084#1103#1090#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label38: TLabel
          Left = 8
          Top = 24
          Width = 546
          Height = 13
          Caption = 
            #1044#1083#1103' '#1087#1088#1080#1084#1077#1088#1072' '#1074' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1074#1089#1090#1088#1086#1077#1085#1086' '#1085#1077#1089#1082#1086#1083#1100#1082#1086' '#1088#1072#1079#1085#1086#1090#1080#1087#1085#1099#1093' '#1084#1072#1089#1089#1080#1074#1086#1074 +
            ' '#1088#1072#1079#1084#1077#1088#1086#1084' 10 '#1093' 10'
        end
        object Label39: TLabel
          Left = 8
          Top = 172
          Width = 170
          Height = 13
          Caption = #1042#1074#1077#1076#1080#1090#1077' '#1080#1084#1103' '#1084#1072#1089#1089#1080#1074#1072' Matrix'
        end
        object Label40: TLabel
          Left = 8
          Top = 131
          Width = 137
          Height = 13
          Caption = #1040#1076#1088#1077#1089' '#1085#1072#1095#1072#1083#1072' '#1084#1072#1089#1089#1080#1074#1072
        end
        object Label34: TLabel
          Left = 8
          Top = 40
          Width = 337
          Height = 13
          Caption = #1052#1072#1089#1089#1080#1074' '#1090#1088#1077#1073#1091#1077#1084#1086#1075#1086' '#1090#1080#1087#1072' '#1074#1099' '#1084#1086#1078#1077#1090#1077' '#1074#1099#1073#1088#1072#1090#1100' '#1080#1079' '#1089#1087#1080#1089#1082#1072
        end
        object Label41: TLabel
          Left = 8
          Top = 215
          Width = 76
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1088#1086#1082
        end
        object Label42: TLabel
          Left = 96
          Top = 215
          Width = 97
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
        end
        object ComboBox1: TComboBox
          Left = 8
          Top = 80
          Width = 185
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = '0 to 2^8 (Byte)'
          OnChange = ComboBox1Change
          Items.Strings = (
            '0 to 2^8 (Byte)'
            '-2^7 to 2^7 (Shortint)'
            '0 to 2^16 (Word)'
            '-2^15 to 2^15 (Short)'
            '0 to 2^32 (DWord)'
            '-2^31 to 2^31 (Integer)'
            '-2^63 to 2^63 (Int64)'
            'Real')
        end
        object Edit19: TEdit
          Left = 8
          Top = 188
          Width = 185
          Height = 21
          TabOrder = 1
          Text = 'A'
        end
        object Button28: TButton
          Left = 9
          Top = 262
          Width = 185
          Height = 22
          Caption = #1057#1095#1080#1090#1072#1090#1100' '#1080#1079' '#1054#1047#1059
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = Button28Click
        end
        object Edit20: TEdit
          Left = 8
          Top = 147
          Width = 185
          Height = 21
          TabOrder = 3
        end
        object Button29: TButton
          Left = 208
          Top = 80
          Width = 193
          Height = 21
          Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1101#1083#1077#1084#1077#1085#1090#1099' '#1084#1072#1089#1089#1080#1074#1072
          TabOrder = 4
          OnClick = Button29Click
        end
        object Button30: TButton
          Left = 8
          Top = 104
          Width = 185
          Height = 21
          Caption = #1047#1072#1087#1086#1083#1085'. '#1089#1083#1091#1095'. '#1095#1080#1089#1083#1072#1084#1080
          TabOrder = 5
          OnClick = Button30Click
        end
        object Memo6: TMemo
          Left = 200
          Top = 104
          Width = 353
          Height = 206
          ScrollBars = ssBoth
          TabOrder = 6
        end
        object Button39: TButton
          Left = 9
          Top = 288
          Width = 185
          Height = 22
          Caption = #1047#1072#1087#1080#1089#1072#1090#1100' '#1074' '#1054#1047#1059
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
          OnClick = Button39Click
        end
        object SpinEdit20: TSpinEdit
          Left = 8
          Top = 232
          Width = 81
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 8
          Value = 10
        end
        object SpinEdit21: TSpinEdit
          Left = 112
          Top = 232
          Width = 81
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 9
          Value = 10
        end
      end
      object GroupBox22: TGroupBox
        Left = 8
        Top = 328
        Width = 569
        Height = 121
        Caption = 
          #1056#1072#1073#1086#1090#1072' '#1089' '#1087#1086#1090#1086#1082#1072#1084#1080' ('#1079#1072#1087#1080#1089#1100'/'#1095#1090#1077#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1072' '#1080#1079' '#1087#1088#1086#1080#1079#1074#1086#1083#1100#1085#1086#1075#1086' '#1076#1074#1086#1080#1095#1085 +
          #1086#1075#1086' '#1092#1072#1081#1083#1072')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object Label43: TLabel
          Left = 8
          Top = 16
          Width = 105
          Height = 13
          Caption = #1059#1082#1072#1078#1080#1090#1077' '#1090#1080#1087' '#1076#1072#1085#1085#1099#1093
        end
        object Label44: TLabel
          Left = 8
          Top = 64
          Width = 99
          Height = 26
          Caption = #1059#1082#1072#1078#1080#1090#1077' '#1076#1083#1080#1085#1091' '#1079#1072#1075#1086#1083#1086#1074#1086#1095#1085#1086#1081' '#1079#1086#1085#1099
          WordWrap = True
        end
        object Label45: TLabel
          Left = 104
          Top = 96
          Width = 23
          Height = 13
          Caption = #1073#1072#1081#1090
        end
        object Label47: TLabel
          Left = 152
          Top = 16
          Width = 103
          Height = 13
          Caption = #1059#1082#1072#1078#1080#1090#1077' '#1080#1084#1103' '#1092#1072#1081#1083#1072
        end
        object Label48: TLabel
          Left = 152
          Top = 72
          Width = 69
          Height = 13
          Caption = #1048#1084#1103' '#1084#1072#1089#1089#1080#1074#1072
        end
        object Label60: TLabel
          Left = 248
          Top = 68
          Width = 64
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1088#1086#1082
        end
        object Label61: TLabel
          Left = 336
          Top = 68
          Width = 82
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
        end
        object ComboBox2: TComboBox
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = 'Byte'
          OnChange = ComboBox1Change
          Items.Strings = (
            'Byte'
            'Shortint'
            'Word'
            'Short'
            'DWord'
            'Integer'
            'Int64'
            'Single'
            'Real48'
            'Real'
            'Extended'
            'Comp'
            'CURRENCY')
        end
        object SpinEdit26: TSpinEdit
          Left = 8
          Top = 91
          Width = 89
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 10
        end
        object Edit21: TEdit
          Left = 152
          Top = 32
          Width = 265
          Height = 21
          TabOrder = 2
          Text = 'MyFile.bin'
        end
        object Button31: TButton
          Left = 418
          Top = 32
          Width = 29
          Height = 20
          Caption = '...'
          TabOrder = 3
          OnClick = Button31Click
        end
        object Edit22: TEdit
          Left = 152
          Top = 88
          Width = 89
          Height = 21
          TabOrder = 4
          Text = 'A'
        end
        object Button32: TButton
          Left = 464
          Top = 72
          Width = 75
          Height = 25
          Caption = #1047#1072#1087#1080#1089#1072#1090#1100
          TabOrder = 5
          OnClick = Button32Click
        end
        object Button33: TButton
          Left = 464
          Top = 32
          Width = 75
          Height = 25
          Caption = #1057#1095#1080#1090#1072#1090#1100
          TabOrder = 6
          OnClick = Button33Click
        end
        object SpinEdit27: TSpinEdit
          Left = 252
          Top = 87
          Width = 81
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 7
          Value = 10
        end
        object SpinEdit28: TSpinEdit
          Left = 340
          Top = 87
          Width = 81
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 8
          Value = 10
        end
      end
    end
    object panStat: TPanel
      Tag = 16
      Left = 81
      Top = 25
      Width = 544
      Height = 553
      TabOrder = 17
      object GroupBox53: TGroupBox
        Left = 7
        Top = 8
        Width = 338
        Height = 105
        Caption = #1054#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' min '#1080#1083#1080' max '#1101#1083#1077#1084#1077#1085#1090#1086#1074' (GetMin, GetMax)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label177: TLabel
          Left = 8
          Top = 16
          Width = 92
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label180: TLabel
          Left = 8
          Top = 59
          Width = 89
          Height = 13
          Caption = #1053#1072#1081#1076#1077#1085#1085#1099#1077' '#1101#1083'-'#1090#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label181: TLabel
          Left = 120
          Top = 59
          Width = 81
          Height = 13
          Caption = #1048#1085#1076#1077#1082#1089#1099' '#1101#1083'-'#1090#1086#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit123: TEdit
          Left = 8
          Top = 32
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'A'
        end
        object Edit124: TEdit
          Left = 8
          Top = 72
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = 'Elems'
        end
        object Edit125: TEdit
          Left = 120
          Top = 72
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = 'Indexes'
        end
        object CheckBox11: TCheckBox
          Left = 112
          Top = 32
          Width = 113
          Height = 17
          Caption = #1055#1086#1080#1089#1082' '#1074' '#1089#1090#1088#1086#1082#1072#1093
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object Button77: TButton
          Left = 232
          Top = 24
          Width = 89
          Height = 25
          Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = Button77Click
        end
        object Button78: TButton
          Left = 232
          Top = 64
          Width = 89
          Height = 25
          Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = Button78Click
        end
      end
      object GroupBox54: TGroupBox
        Left = 7
        Top = 128
        Width = 274
        Height = 105
        Caption = #1054#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' min '#1080' max '#1101#1083#1077#1084#1077#1085#1090#1086#1074' (MinMax)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label178: TLabel
          Left = 8
          Top = 16
          Width = 92
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label179: TLabel
          Left = 8
          Top = 59
          Width = 89
          Height = 13
          Caption = #1053#1072#1081#1076#1077#1085#1085#1099#1077' '#1101#1083'-'#1090#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit126: TEdit
          Left = 8
          Top = 32
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'A'
        end
        object Edit127: TEdit
          Left = 8
          Top = 72
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = 'MinMax'
        end
        object CheckBox12: TCheckBox
          Left = 112
          Top = 32
          Width = 113
          Height = 17
          Caption = #1055#1086#1080#1089#1082' '#1074' '#1089#1090#1088#1086#1082#1072#1093
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button79: TButton
          Left = 120
          Top = 68
          Width = 89
          Height = 25
          Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button79Click
        end
      end
      object GroupBox55: TGroupBox
        Left = 7
        Top = 240
        Width = 274
        Height = 105
        Caption = #1054#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1089#1088#1077#1076#1085#1077#1075#1086' '#1072#1088#1080#1092#1084#1077#1090#1080#1095#1077#1089#1082#1086#1075#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label182: TLabel
          Left = 8
          Top = 16
          Width = 92
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label183: TLabel
          Left = 8
          Top = 59
          Width = 52
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit128: TEdit
          Left = 8
          Top = 32
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'A'
        end
        object Edit129: TEdit
          Left = 8
          Top = 72
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = 'Mean'
        end
        object CheckBox13: TCheckBox
          Left = 112
          Top = 32
          Width = 97
          Height = 17
          Caption = #1044#1083#1103' '#1089#1090#1088#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button80: TButton
          Left = 120
          Top = 68
          Width = 89
          Height = 25
          Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button80Click
        end
      end
      object GroupBox56: TGroupBox
        Left = 8
        Top = 352
        Width = 265
        Height = 57
        Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1090#1080#1087' '#1101#1083#1077#1084#1077#1085#1090#1086#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object Label184: TLabel
          Left = 8
          Top = 16
          Width = 69
          Height = 13
          Caption = #1048#1084#1103' '#1084#1072#1089#1089#1080#1074#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit130: TEdit
          Left = 8
          Top = 32
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'A'
        end
        object Button81: TButton
          Left = 112
          Top = 24
          Width = 129
          Height = 25
          Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100
          TabOrder = 1
          OnClick = Button81Click
        end
      end
    end
    object panSet3: TPanel
      Tag = 13
      Left = -215
      Top = -159
      Width = 638
      Height = 553
      TabOrder = 6
      object GroupBox35: TGroupBox
        Left = 320
        Top = 256
        Width = 265
        Height = 119
        Caption = #1057#1083#1086#1078#1077#1085#1080#1077' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1086#1074' ('#1074' '#1087#1086#1083#1103#1093' '#1043#1072#1083#1091#1072')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label117: TLabel
          Left = 9
          Top = 12
          Width = 55
          Height = 13
          Caption = #1055#1086#1083#1080#1085#1086#1084' 1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label118: TLabel
          Left = 9
          Top = 49
          Width = 55
          Height = 13
          Caption = #1055#1086#1083#1080#1085#1086#1084' 2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label119: TLabel
          Left = 112
          Top = 51
          Width = 52
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label121: TLabel
          Left = 113
          Top = 11
          Width = 74
          Height = 13
          Caption = #1057#1090#1077#1087#1077#1085#1100' '#1043#1072#1083#1091#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit81: TEdit
          Left = 8
          Top = 26
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit82: TEdit
          Left = 8
          Top = 65
          Width = 98
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit83: TEdit
          Left = 113
          Top = 64
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button57: TButton
          Left = 68
          Top = 91
          Width = 77
          Height = 24
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button57Click
        end
        object SpinEdit18: TSpinEdit
          Left = 112
          Top = 25
          Width = 97
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 0
          ParentFont = False
          TabOrder = 4
          Value = 0
        end
      end
      object GroupBox36: TGroupBox
        Left = 320
        Top = 138
        Width = 265
        Height = 119
        Caption = #1059#1084#1085#1086#1078#1077#1085#1080#1077' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1086#1074' ('#1074' '#1087#1086#1083#1103#1093' '#1043#1072#1083#1091#1072')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label120: TLabel
          Left = 9
          Top = 12
          Width = 55
          Height = 13
          Caption = #1055#1086#1083#1080#1085#1086#1084' 1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label122: TLabel
          Left = 9
          Top = 49
          Width = 55
          Height = 13
          Caption = #1055#1086#1083#1080#1085#1086#1084' 2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label123: TLabel
          Left = 112
          Top = 51
          Width = 52
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label124: TLabel
          Left = 113
          Top = 12
          Width = 74
          Height = 13
          Caption = #1057#1090#1077#1087#1077#1085#1100' '#1043#1072#1083#1091#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit84: TEdit
          Left = 8
          Top = 26
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit85: TEdit
          Left = 8
          Top = 65
          Width = 98
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit86: TEdit
          Left = 113
          Top = 64
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button58: TButton
          Left = 68
          Top = 91
          Width = 77
          Height = 24
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button58Click
        end
        object SpinEdit19: TSpinEdit
          Left = 112
          Top = 25
          Width = 97
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 0
          ParentFont = False
          TabOrder = 4
          Value = 0
        end
      end
      object GroupBox32: TGroupBox
        Left = 322
        Top = 4
        Width = 263
        Height = 132
        Caption = #1044#1077#1083#1077#1085#1080#1077' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1086#1074' ('#1074' '#1087#1086#1083#1103#1093' '#1043#1072#1083#1091#1072')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label105: TLabel
          Left = 9
          Top = 12
          Width = 47
          Height = 13
          Caption = #1044#1077#1083#1080#1084#1086#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label107: TLabel
          Left = 9
          Top = 49
          Width = 50
          Height = 13
          Caption = #1044#1077#1083#1080#1090#1077#1083#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label108: TLabel
          Left = 112
          Top = 12
          Width = 43
          Height = 13
          Caption = #1063#1072#1089#1090#1085#1086#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label109: TLabel
          Left = 112
          Top = 51
          Width = 42
          Height = 13
          Caption = #1054#1089#1090#1072#1090#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label110: TLabel
          Left = 9
          Top = 89
          Width = 74
          Height = 13
          Caption = #1057#1090#1077#1087#1077#1085#1100' '#1043#1072#1083#1091#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit71: TEdit
          Left = 8
          Top = 26
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit72: TEdit
          Left = 8
          Top = 65
          Width = 98
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit73: TEdit
          Left = 113
          Top = 24
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button54: TButton
          Left = 132
          Top = 99
          Width = 77
          Height = 24
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button54Click
        end
        object Edit74: TEdit
          Left = 113
          Top = 64
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object SpinEdit17: TSpinEdit
          Left = 8
          Top = 103
          Width = 97
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 0
          ParentFont = False
          TabOrder = 5
          Value = 0
        end
      end
      object GroupBox29: TGroupBox
        Left = 0
        Top = 160
        Width = 313
        Height = 97
        Caption = #1055#1088#1086#1089#1090#1086#1081' '#1089#1076#1074#1080#1075' '#1089#1090#1088#1086#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object Label95: TLabel
          Left = 16
          Top = 24
          Width = 71
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085'. '#1084#1072#1090#1088'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label96: TLabel
          Left = 120
          Top = 24
          Width = 78
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090'. '#1084#1072#1090#1088#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label100: TLabel
          Left = 120
          Top = 72
          Width = 74
          Height = 13
          Caption = #1042#1077#1083#1080#1095'. '#1089#1076#1074#1080#1075#1072':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit66: TEdit
          Left = 8
          Top = 40
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit67: TEdit
          Left = 112
          Top = 40
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Button51: TButton
          Left = 224
          Top = 36
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button51Click
        end
        object CheckBox3: TCheckBox
          Left = 8
          Top = 72
          Width = 65
          Height = 17
          Caption = #1042#1087#1088#1072#1074#1086
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 3
        end
        object SpinEdit12: TSpinEdit
          Left = 200
          Top = 67
          Width = 102
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 0
          ParentFont = False
          TabOrder = 4
          Value = 1
        end
      end
      object GroupBox30: TGroupBox
        Left = 0
        Top = 256
        Width = 313
        Height = 97
        Caption = #1062#1080#1082#1083#1080#1095#1077#1089#1082#1080#1081' '#1089#1076#1074#1080#1075' '#1089#1090#1088#1086#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object Label101: TLabel
          Left = 16
          Top = 24
          Width = 71
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085'. '#1084#1072#1090#1088'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label102: TLabel
          Left = 120
          Top = 24
          Width = 78
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090'. '#1084#1072#1090#1088#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label103: TLabel
          Left = 132
          Top = 72
          Width = 74
          Height = 13
          Caption = #1042#1077#1083#1080#1095'. '#1089#1076#1074#1080#1075#1072':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit68: TEdit
          Left = 8
          Top = 40
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit69: TEdit
          Left = 112
          Top = 40
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Button52: TButton
          Left = 224
          Top = 36
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button52Click
        end
        object CheckBox4: TCheckBox
          Left = 8
          Top = 72
          Width = 65
          Height = 17
          Caption = #1042#1087#1088#1072#1074#1086
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 3
        end
        object SpinEdit13: TSpinEdit
          Left = 212
          Top = 67
          Width = 89
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 0
          ParentFont = False
          TabOrder = 4
          Value = 1
        end
      end
      object GroupBox33: TGroupBox
        Left = 0
        Top = 4
        Width = 313
        Height = 84
        Caption = #1057#1051#1040#1059' '#1040'*'#1061'='#1042
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object Label111: TLabel
          Left = 16
          Top = 13
          Width = 7
          Height = 13
          Caption = #1040
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label112: TLabel
          Left = 120
          Top = 13
          Width = 7
          Height = 13
          Caption = #1042
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label113: TLabel
          Left = 232
          Top = 13
          Width = 7
          Height = 13
          Caption = #1061
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit75: TEdit
          Left = 8
          Top = 30
          Width = 89
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'A'
        end
        object Edit76: TEdit
          Left = 104
          Top = 30
          Width = 89
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = 'B'
        end
        object Edit77: TEdit
          Left = 200
          Top = 30
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button55: TButton
          Left = 103
          Top = 53
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button55Click
        end
      end
      object GroupBox31: TGroupBox
        Left = 0
        Top = 91
        Width = 313
        Height = 68
        Caption = #1043#1077#1085#1077#1088#1072#1094#1080#1103' '#1090#1072#1073#1083#1080#1094' '#1076#1083#1103' '#1087#1086#1083#1077#1081' '#1043#1072#1083#1091#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        object Label104: TLabel
          Left = 8
          Top = 24
          Width = 70
          Height = 13
          Caption = #1048#1084#1103' '#1084#1072#1090#1088#1080#1094#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label106: TLabel
          Left = 104
          Top = 24
          Width = 69
          Height = 13
          Caption = #1057#1090#1077#1087#1077#1085#1100' '#1087#1086#1083#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit70: TEdit
          Left = 8
          Top = 40
          Width = 81
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Button53: TButton
          Left = 198
          Top = 36
          Width = 90
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Button53Click
        end
        object CheckBox5: TCheckBox
          Left = 200
          Top = 16
          Width = 89
          Height = 17
          Caption = #1057#1083#1086#1078#1077#1085#1080#1077
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 2
        end
        object SpinEdit16: TSpinEdit
          Left = 96
          Top = 39
          Width = 97
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 0
          ParentFont = False
          TabOrder = 3
          Value = 1
        end
      end
      object GroupBox23: TGroupBox
        Left = 0
        Top = 360
        Width = 313
        Height = 129
        Caption = #1055#1086#1101#1083#1077#1084#1077#1085#1090#1085#1099#1077' '#1084#1072#1090#1077#1084#1072#1090#1080#1095#1077#1089#1082#1080#1077' '#1086#1087#1077#1088#1072#1094#1080#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        object Label65: TLabel
          Left = 8
          Top = 16
          Width = 81
          Height = 13
          Caption = #1055#1077#1088#1074#1099#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label66: TLabel
          Left = 136
          Top = 16
          Width = 77
          Height = 13
          Caption = #1042#1090#1086#1088#1086#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label67: TLabel
          Left = 8
          Top = 56
          Width = 91
          Height = 13
          Caption = #1042#1099#1093#1086#1076#1085#1086#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label68: TLabel
          Left = 168
          Top = 56
          Width = 50
          Height = 13
          Caption = #1054#1087#1077#1088#1072#1094#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit24: TEdit
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit38: TEdit
          Left = 136
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit39: TEdit
          Left = 8
          Top = 72
          Width = 153
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object ComboBox3: TComboBox
          Left = 168
          Top = 72
          Width = 89
          Height = 21
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 3
          Items.Strings = (
            '+'
            '-'
            '*'
            '/'
            '^'
            '='
            '<>'
            '<'
            '>'
            '<='
            '>=')
        end
        object Button41: TButton
          Left = 8
          Top = 101
          Width = 249
          Height = 21
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = Button41Click
        end
      end
      object GroupBox27: TGroupBox
        Left = 320
        Top = 376
        Width = 265
        Height = 129
        Caption = #1052#1072#1090#1077#1084#1072#1090#1080#1095#1077#1089#1082#1080#1077' '#1092#1091#1085#1082#1094#1080#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 8
        object Label69: TLabel
          Left = 8
          Top = 16
          Width = 83
          Height = 13
          Caption = #1042#1093#1086#1076#1085#1086#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label70: TLabel
          Left = 8
          Top = 56
          Width = 91
          Height = 13
          Caption = #1042#1099#1093#1086#1076#1085#1086#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label71: TLabel
          Left = 176
          Top = 16
          Width = 46
          Height = 13
          Caption = #1060#1091#1085#1082#1094#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit40: TEdit
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit41: TEdit
          Left = 8
          Top = 72
          Width = 249
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object ComboBox4: TComboBox
          Left = 136
          Top = 32
          Width = 121
          Height = 21
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ItemIndex = 0
          ParentFont = False
          TabOrder = 2
          Text = 'SIN'
          Items.Strings = (
            'SIN'
            'COS'
            'SQRT'
            'ABS'
            'SQR'
            'ROUND'
            'TRUNC'
            'INT'
            'FRAC'
            'EXP'
            'NONE')
        end
        object Button42: TButton
          Left = 8
          Top = 96
          Width = 249
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button42Click
        end
      end
    end
    object panMatlab: TPanel
      Tag = 31
      Left = 265
      Top = 137
      Width = 638
      Height = 553
      TabOrder = 11
      object Label62: TLabel
        Left = 8
        Top = 48
        Width = 90
        Height = 13
        Caption = #1050#1086#1084#1072#1085#1076#1072' '#1084#1072#1090#1083#1072#1073#1091
      end
      object Label63: TLabel
        Left = 16
        Top = 392
        Width = 190
        Height = 13
        Caption = #1055#1077#1088#1077#1076#1072#1090#1100'/'#1089#1095#1080#1090#1072#1090#1100' '#1084#1072#1089#1089#1080#1074' '#1080#1079' Matlaba'
      end
      object Label64: TLabel
        Left = 8
        Top = 8
        Width = 403
        Height = 26
        Caption = 
          #1042#1099' '#1084#1086#1078#1077#1090#1077' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1077#1088#1074#1077#1088#1091' Matlab '#1083#1102#1073#1091#1102' '#1082#1086#1084#1072#1085#1076#1091' '#1080#1083#1080' '#1087#1086#1089#1083#1077#1076#1086#1074#1072#1090#1077 +
          #1083#1100#1085#1086#1089#1090#1100' '#1082#1086#1084#1072#1085#1076', '#1087#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1093' '#1089#1080#1089#1090#1077#1084#1086#1081' Matlab'
        WordWrap = True
      end
      object Button35: TButton
        Left = 8
        Top = 344
        Width = 201
        Height = 25
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1082#1086#1084#1072#1085#1076#1091' '#1089#1077#1088#1074#1077#1088#1091' Matlab'
        TabOrder = 0
        OnClick = Button35Click
      end
      object Edit37: TEdit
        Left = 16
        Top = 408
        Width = 305
        Height = 21
        TabOrder = 1
      end
      object Button37: TButton
        Left = 16
        Top = 432
        Width = 89
        Height = 25
        Caption = #1055#1077#1088#1077#1076#1072#1090#1100
        TabOrder = 2
        OnClick = Button37Click
      end
      object Button38: TButton
        Left = 120
        Top = 432
        Width = 89
        Height = 25
        Caption = #1057#1095#1080#1090#1072#1090#1100
        TabOrder = 3
        OnClick = Button38Click
      end
      object Edit36: TMemo
        Left = 8
        Top = 64
        Width = 425
        Height = 273
        TabOrder = 4
      end
      object Button40: TButton
        Left = 304
        Top = 344
        Width = 129
        Height = 25
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1087#1091#1090#1100
        TabOrder = 5
        OnClick = Button40Click
      end
    end
    object panSignals1: TPanel
      Tag = 41
      Left = 313
      Top = 105
      Width = 638
      Height = 553
      TabOrder = 12
      object GroupBox45: TGroupBox
        Left = 360
        Top = 8
        Width = 273
        Height = 145
        Caption = #1041#1099#1089#1090#1088#1072#1103' '#1080#1085#1090#1077#1088#1087#1086#1083#1103#1094#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label150: TLabel
          Left = 8
          Top = 16
          Width = 87
          Height = 13
          Caption = #1052#1072#1089#1089#1080#1074' '#1086#1090#1089#1095#1077#1090#1086#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label151: TLabel
          Left = 8
          Top = 56
          Width = 89
          Height = 13
          Caption = #1052#1072#1089#1089#1080#1074' '#1079#1085#1072#1095#1077#1085#1080#1081
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label152: TLabel
          Left = 144
          Top = 16
          Width = 116
          Height = 13
          Caption = #1052#1072#1089#1089#1080#1074' '#1090#1088#1077#1073'. '#1086#1090#1089#1095#1077#1090#1086#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label153: TLabel
          Left = 144
          Top = 56
          Width = 52
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit42: TEdit
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'X'
        end
        object Edit43: TEdit
          Left = 8
          Top = 72
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = 'Y'
        end
        object Edit44: TEdit
          Left = 144
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = 'X1'
        end
        object Edit108: TEdit
          Left = 144
          Top = 72
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Text = 'R'
        end
        object Button46: TButton
          Left = 104
          Top = 104
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = Button46Click
        end
      end
      object GroupBox37: TGroupBox
        Left = 0
        Top = 8
        Width = 353
        Height = 89
        Caption = #1052#1072#1089#1096#1090#1072#1073#1080#1088#1086#1074#1072#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1072' '#1087#1086' '#1089#1090#1088#1086#1082#1072#1084
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label72: TLabel
          Left = 16
          Top = 14
          Width = 71
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085'. '#1084#1072#1090#1088'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label73: TLabel
          Left = 120
          Top = 14
          Width = 78
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090'. '#1084#1072#1090#1088#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label74: TLabel
          Left = 232
          Top = 14
          Width = 105
          Height = 13
          Caption = #1044#1083#1080#1085#1072' '#1088#1077#1079'. '#1084#1072#1090#1088#1080#1094#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit45: TEdit
          Left = 8
          Top = 33
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit46: TEdit
          Left = 112
          Top = 33
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit47: TEdit
          Left = 224
          Top = 33
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button59: TButton
          Left = 127
          Top = 56
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button59Click
        end
      end
      object GroupBox41: TGroupBox
        Left = -1
        Top = 98
        Width = 353
        Height = 87
        Caption = #1053#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1090#1088#1086#1082' '#1084#1072#1089#1089#1080#1074#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label75: TLabel
          Left = 16
          Top = 15
          Width = 71
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085'. '#1084#1072#1090#1088'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label76: TLabel
          Left = 120
          Top = 15
          Width = 78
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090'. '#1084#1072#1090#1088#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label87: TLabel
          Left = 224
          Top = 15
          Width = 125
          Height = 13
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1085#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit48: TEdit
          Left = 8
          Top = 33
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit49: TEdit
          Left = 112
          Top = 33
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit50: TEdit
          Left = 224
          Top = 33
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button64: TButton
          Left = 125
          Top = 56
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button64Click
        end
      end
      object GroupBox42: TGroupBox
        Left = 0
        Top = 192
        Width = 353
        Height = 105
        Caption = #1057#1075#1083#1072#1078#1080#1074#1072#1085#1080#1077' '#1089#1080#1075#1085#1072#1083#1086#1074' '#1074' '#1089#1090#1088#1086#1082#1072#1093
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object Label88: TLabel
          Left = 16
          Top = 14
          Width = 81
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085'. '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label89: TLabel
          Left = 120
          Top = 14
          Width = 85
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090'. '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label125: TLabel
          Left = 224
          Top = 14
          Width = 100
          Height = 13
          Caption = #1050#1086#1101#1092'. '#1089#1075#1083#1072#1078#1080#1074#1072#1085#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit51: TEdit
          Left = 8
          Top = 31
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit58: TEdit
          Left = 112
          Top = 31
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit59: TEdit
          Left = 224
          Top = 31
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button65: TButton
          Left = 127
          Top = 55
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button65Click
        end
      end
      object GroupBox43: TGroupBox
        Left = 360
        Top = 152
        Width = 273
        Height = 108
        Caption = #1053#1072#1093#1086#1078#1076#1077#1085#1080#1077' '#1101#1082#1089#1090#1088#1077#1084#1091#1084#1086#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object Label126: TLabel
          Left = 16
          Top = 17
          Width = 85
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085'. '#1084#1072#1090#1088'.'
        end
        object Label127: TLabel
          Left = 16
          Top = 64
          Width = 93
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090'. '#1084#1072#1090#1088#1080
        end
        object Label137: TLabel
          Left = 128
          Top = 17
          Width = 66
          Height = 13
          Caption = #1054#1075#1088'. '#1083#1080#1085#1080#1103
        end
        object Edit60: TEdit
          Left = 8
          Top = 32
          Width = 97
          Height = 21
          TabOrder = 0
        end
        object Edit88: TEdit
          Left = 8
          Top = 80
          Width = 105
          Height = 21
          TabOrder = 1
        end
        object Edit93: TEdit
          Left = 120
          Top = 32
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object Button66: TButton
          Left = 120
          Top = 76
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          TabOrder = 3
          OnClick = Button66Click
        end
        object CheckBox9: TCheckBox
          Left = 120
          Top = 56
          Width = 137
          Height = 17
          Caption = #1042#1077#1088#1093#1085#1080#1077' '#1074#1077#1088#1096#1080#1085#1099
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
      end
      object GroupBox44: TGroupBox
        Left = 360
        Top = 264
        Width = 273
        Height = 105
        Caption = #1048#1079#1086#1083#1080#1085#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object Label138: TLabel
          Left = 8
          Top = 16
          Width = 69
          Height = 13
          Caption = #1048#1084#1103' '#1084#1072#1089#1089#1080#1074#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label148: TLabel
          Left = 144
          Top = 15
          Width = 72
          Height = 13
          Caption = #1053#1086#1084#1077#1088' '#1089#1090#1088#1086#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label149: TLabel
          Left = 8
          Top = 55
          Width = 52
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit99: TEdit
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit100: TEdit
          Left = 8
          Top = 72
          Width = 73
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Button67: TButton
          Left = 88
          Top = 60
          Width = 153
          Height = 33
          Caption = #1055#1086#1080#1089#1082' '#1080#1079#1086#1083#1080#1085#1080#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button67Click
        end
        object SpinEdit32: TSpinEdit
          Left = 144
          Top = 28
          Width = 97
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 0
          ParentFont = False
          TabOrder = 3
          Value = 1
        end
      end
    end
    object panDemoFunc: TPanel
      Tag = 51
      Left = 337
      Top = 81
      Width = 638
      Height = 553
      TabOrder = 13
      object GroupBox46: TGroupBox
        Left = 8
        Top = 96
        Width = 249
        Height = 97
        Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1074#1086#1080#1095#1085#1099#1093' '#1082#1086#1084#1073#1080#1085#1072#1094#1080#1081
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label139: TLabel
          Left = 120
          Top = 16
          Width = 78
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090'. '#1084#1072#1090#1088#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label140: TLabel
          Left = 8
          Top = 16
          Width = 83
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1088#1072#1079#1088#1103#1076#1086#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label141: TLabel
          Left = 8
          Top = 55
          Width = 71
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1077#1076#1080#1085#1080#1094
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit94: TEdit
          Left = 112
          Top = 28
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Button68: TButton
          Left = 128
          Top = 64
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Button68Click
        end
        object SpinEdit33: TSpinEdit
          Left = 8
          Top = 29
          Width = 97
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 0
          ParentFont = False
          TabOrder = 2
          Value = 6
        end
        object SpinEdit34: TSpinEdit
          Left = 8
          Top = 68
          Width = 97
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 0
          ParentFont = False
          TabOrder = 3
          Value = 3
        end
      end
      object GroupBox48: TGroupBox
        Left = 8
        Top = 4
        Width = 353
        Height = 85
        Caption = #1057#1051#1040#1059' '#1040'*'#1061'='#1042' '#1084#1077#1090#1086#1076#1086#1084' '#1061#1086#1083#1077#1094#1082#1086#1075#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label142: TLabel
          Left = 16
          Top = 15
          Width = 7
          Height = 13
          Caption = #1040
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label143: TLabel
          Left = 120
          Top = 15
          Width = 7
          Height = 13
          Caption = #1042
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label144: TLabel
          Left = 232
          Top = 15
          Width = 7
          Height = 13
          Caption = #1061
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit95: TEdit
          Left = 8
          Top = 31
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit96: TEdit
          Left = 112
          Top = 31
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit97: TEdit
          Left = 224
          Top = 31
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button69: TButton
          Left = 127
          Top = 54
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          TabOrder = 3
          OnClick = Button69Click
        end
      end
    end
    object panNNet1: TPanel
      Tag = 61
      Left = 193
      Top = 9
      Width = 544
      Height = 553
      TabOrder = 15
      object GroupBox49: TGroupBox
        Left = 8
        Top = 16
        Width = 273
        Height = 105
        Caption = #1045#1074#1082#1083#1080#1076#1086#1074#1086' '#1088#1072#1089#1089#1090#1086#1103#1085#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          273
          105)
        object Label145: TLabel
          Left = 8
          Top = 16
          Width = 25
          Height = 13
          Caption = #1042#1077#1089#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label146: TLabel
          Left = 136
          Top = 16
          Width = 80
          Height = 13
          Caption = #1042#1093#1086#1076#1085#1086#1081' '#1074#1077#1082#1090#1086#1088
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label147: TLabel
          Left = 8
          Top = 56
          Width = 52
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Button70: TButton
          Left = 152
          Top = 56
          Width = 99
          Height = 17
          Anchors = [akLeft, akBottom]
          Caption = 'Dist'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = Button70Click
        end
        object Edit98: TEdit
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit101: TEdit
          Left = 136
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Edit102: TEdit
          Left = 8
          Top = 72
          Width = 137
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object Button73: TButton
          Left = 152
          Top = 74
          Width = 99
          Height = 17
          Anchors = [akLeft, akBottom]
          Caption = 'Negdist'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = Button73Click
        end
      end
      object GroupBox50: TGroupBox
        Left = 8
        Top = 128
        Width = 273
        Height = 89
        Caption = 'Compet'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label155: TLabel
          Left = 8
          Top = 16
          Width = 83
          Height = 13
          Caption = #1042#1093#1086#1076#1085#1086#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label156: TLabel
          Left = 136
          Top = 16
          Width = 91
          Height = 13
          Caption = #1042#1099#1093#1086#1076#1085#1086#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit103: TEdit
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit104: TEdit
          Left = 136
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Button74: TButton
          Left = 96
          Top = 56
          Width = 75
          Height = 25
          Caption = 'OK'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button74Click
        end
      end
      object GroupBox51: TGroupBox
        Left = 8
        Top = 224
        Width = 273
        Height = 105
        Caption = #1056#1072#1089#1095#1077#1090' '#1075#1080#1073#1088#1080#1076#1085#1086#1081' '#1089#1077#1090#1080' '#1050#1086#1093#1086#1085#1077#1085#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label163: TLabel
          Left = 8
          Top = 16
          Width = 48
          Height = 13
          Caption = #1048#1084#1103' '#1089#1077#1090#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label164: TLabel
          Left = 136
          Top = 16
          Width = 126
          Height = 13
          Caption = #1058#1077#1089#1090#1080#1088#1091#1077#1084#1099#1081' '#1074#1077#1082#1090#1086#1088
        end
        object Label165: TLabel
          Left = 8
          Top = 56
          Width = 52
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label166: TLabel
          Left = 96
          Top = 56
          Width = 47
          Height = 13
          Caption = #1058#1086#1095#1085#1086#1089#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit116: TEdit
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit117: TEdit
          Left = 136
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit118: TEdit
          Left = 8
          Top = 72
          Width = 81
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button75: TButton
          Left = 152
          Top = 72
          Width = 103
          Height = 21
          Caption = #1056#1072#1089#1095#1080#1090#1072#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button75Click
        end
        object Edit119: TEdit
          Left = 96
          Top = 72
          Width = 50
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Text = '0'
        end
      end
      object GroupBox57: TGroupBox
        Left = 8
        Top = 336
        Width = 345
        Height = 185
        Caption = 'GroupBox57'
        TabOrder = 3
        object Button83: TButton
          Left = 8
          Top = 152
          Width = 75
          Height = 25
          Caption = 'Button83'
          TabOrder = 0
        end
      end
    end
    object panSaveLoad: TPanel
      Tag = 3
      Left = 148
      Top = 273
      Width = 512
      Height = 444
      TabOrder = 2
      object Label4: TLabel
        Left = 8
        Top = 176
        Width = 251
        Height = 26
        Caption = 
          #1057#1083#1077#1076#1091#1102#1097#1080#1077' 2 '#1092#1091#1085#1082#1094#1080#1080' '#1084#1086#1075#1091#1090' '#1076#1086#1087#1080#1089#1099#1074#1072#1090#1100' '#1084#1072#1089#1089#1080#1074#1099' '#1074' '#1091#1078#1077' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1077' ' +
          #1092#1072#1081#1083#1099
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        WordWrap = True
      end
      object GroupBox15: TGroupBox
        Left = 8
        Top = 216
        Width = 361
        Height = 65
        Caption = #1063#1090#1077#1085#1080#1077'/'#1079#1072#1087#1080#1089#1100' '#1084#1072#1089#1089#1080#1074#1072' '#1074' bin-'#1092#1072#1081#1083
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label46: TLabel
          Left = 11
          Top = 20
          Width = 121
          Height = 13
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' bin-'#1092#1072#1081#1083#1072
        end
        object Label49: TLabel
          Left = 144
          Top = 21
          Width = 81
          Height = 13
          Caption = #1048#1084#1103' '#1084#1072#1089#1089#1080#1074#1072
        end
        object Edit23: TEdit
          Left = 8
          Top = 36
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'Workspace.bin'
        end
        object Edit25: TEdit
          Left = 144
          Top = 35
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object Button19: TButton
          Left = 272
          Top = 18
          Width = 75
          Height = 15
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
          TabOrder = 2
          OnClick = Button19Click
        end
        object Button20: TButton
          Left = 272
          Top = 40
          Width = 75
          Height = 14
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
          TabOrder = 3
          OnClick = Button20Click
        end
      end
      object GroupBox16: TGroupBox
        Left = 8
        Top = 288
        Width = 361
        Height = 65
        Caption = #1063#1090#1077#1085#1080#1077'/'#1079#1072#1087#1080#1089#1100' '#1084#1072#1089#1089#1080#1074#1072' '#1074' dat-'#1092#1072#1081#1083
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label50: TLabel
          Left = 11
          Top = 20
          Width = 122
          Height = 13
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' dat-'#1092#1072#1081#1083#1072
        end
        object Label51: TLabel
          Left = 143
          Top = 19
          Width = 81
          Height = 13
          Caption = #1048#1084#1103' '#1084#1072#1089#1089#1080#1074#1072
        end
        object Edit26: TEdit
          Left = 8
          Top = 36
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'Workspace.dat'
        end
        object Edit27: TEdit
          Left = 141
          Top = 35
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object Button21: TButton
          Left = 272
          Top = 16
          Width = 75
          Height = 17
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
          TabOrder = 2
          OnClick = Button21Click
        end
        object Button22: TButton
          Left = 272
          Top = 40
          Width = 75
          Height = 17
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
          TabOrder = 3
          OnClick = Button22Click
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 16
        Width = 361
        Height = 65
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072'/'#1079#1072#1087#1080#1089#1100' '#1088#1072#1073#1086#1095#1077#1081' '#1086#1073#1083#1072#1089#1090#1080' '#1074' bin-'#1092#1072#1081#1083
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label5: TLabel
          Left = 11
          Top = 20
          Width = 121
          Height = 13
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' bin-'#1092#1072#1081#1083#1072
        end
        object Edit2: TEdit
          Left = 8
          Top = 36
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'Workspace.bin'
        end
        object Button6: TButton
          Left = 144
          Top = 18
          Width = 75
          Height = 15
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
          TabOrder = 1
          OnClick = Button6Click
        end
        object Button7: TButton
          Left = 144
          Top = 40
          Width = 75
          Height = 14
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
          TabOrder = 2
          OnClick = Button7Click
        end
        object Button26: TButton
          Left = 224
          Top = 24
          Width = 129
          Height = 22
          Caption = #1044#1077#1092#1088#1072#1075#1084#1077#1085#1090#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 3
          OnClick = Button26Click
        end
      end
      object GroupBox7: TGroupBox
        Left = 8
        Top = 88
        Width = 361
        Height = 65
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072'/'#1079#1072#1087#1080#1089#1100' '#1088#1072#1073#1086#1095#1077#1081' '#1086#1073#1083#1072#1089#1090#1080' '#1074' dat-'#1092#1072#1081#1083
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object Label15: TLabel
          Left = 11
          Top = 20
          Width = 122
          Height = 13
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' dat-'#1092#1072#1081#1083#1072
        end
        object Edit4: TEdit
          Left = 8
          Top = 36
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'Workspace.dat'
        end
        object Button8: TButton
          Left = 144
          Top = 16
          Width = 75
          Height = 17
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
          TabOrder = 1
          OnClick = Button8Click
        end
        object Button9: TButton
          Left = 144
          Top = 40
          Width = 75
          Height = 17
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
          TabOrder = 2
          OnClick = Button9Click
        end
        object Button10: TButton
          Left = 224
          Top = 24
          Width = 129
          Height = 22
          Caption = #1044#1077#1092#1088#1072#1075#1084#1077#1085#1090#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 3
          OnClick = Button10Click
        end
      end
    end
    object panLoadFromFiles: TPanel
      Tag = 1
      Left = 11
      Top = 407
      Width = 461
      Height = 444
      Caption = 'panLoadFromFiles'
      TabOrder = 0
      object GroupBox1: TGroupBox
        Left = 1
        Top = 52
        Width = 459
        Height = 141
        Align = alTop
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1092#1072#1081#1083#1086#1074' '#1092#1086#1088#1084#1072#1090#1072' *.asc'
        TabOrder = 0
        DesignSize = (
          459
          141)
        object SpeedButton2: TSpeedButton
          Left = 8
          Top = 14
          Width = 121
          Height = 19
          Caption = #1042#1099#1073#1088#1072#1090#1100' '#1092#1072#1081#1083#1099
          OnClick = SpeedButton2Click
        end
        object SpeedButton3: TSpeedButton
          Left = 144
          Top = 14
          Width = 121
          Height = 19
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1052#1077#1084#1086
          OnClick = SpeedButton3Click
        end
        object SpeedButton4: TSpeedButton
          Left = 280
          Top = 14
          Width = 121
          Height = 19
          Caption = #1055#1088#1080#1085#1103#1090#1100
          OnClick = SpeedButton4Click
        end
        object Memo1: TMemo
          Left = 8
          Top = 37
          Width = 441
          Height = 96
          Anchors = [akLeft, akTop, akRight, akBottom]
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
      object GroupBox2: TGroupBox
        Left = 1
        Top = 193
        Width = 459
        Height = 103
        Align = alClient
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1092#1072#1081#1083#1086#1074' '#1092#1086#1088#1084#1072#1090#1072' *.bin ('#1076#1074#1086#1080#1095#1085#1099#1077' '#1092#1072#1081#1083#1099')'
        TabOrder = 1
        DesignSize = (
          459
          103)
        object SpeedButton5: TSpeedButton
          Left = 8
          Top = 14
          Width = 121
          Height = 19
          Caption = #1042#1099#1073#1088#1072#1090#1100' '#1092#1072#1081#1083#1099
          OnClick = SpeedButton5Click
        end
        object SpeedButton6: TSpeedButton
          Left = 144
          Top = 14
          Width = 121
          Height = 19
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1052#1077#1084#1086
          OnClick = SpeedButton6Click
        end
        object SpeedButton7: TSpeedButton
          Left = 280
          Top = 14
          Width = 121
          Height = 19
          Caption = #1055#1088#1080#1085#1103#1090#1100
          OnClick = SpeedButton7Click
        end
        object Memo2: TMemo
          Left = 8
          Top = 37
          Width = 441
          Height = 56
          Anchors = [akLeft, akTop, akRight, akBottom]
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
      object GroupBox3: TGroupBox
        Left = 1
        Top = 296
        Width = 459
        Height = 147
        Align = alBottom
        Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1092#1072#1081#1083#1086#1074' '#1092#1086#1088#1084#1072#1090#1072' *.dat ('#1090#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099')'
        TabOrder = 2
        DesignSize = (
          459
          147)
        object SpeedButton8: TSpeedButton
          Left = 8
          Top = 14
          Width = 121
          Height = 19
          Caption = #1042#1099#1073#1088#1072#1090#1100' '#1092#1072#1081#1083#1099
          OnClick = SpeedButton8Click
        end
        object SpeedButton9: TSpeedButton
          Left = 144
          Top = 14
          Width = 121
          Height = 19
          Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1052#1077#1084#1086
          OnClick = SpeedButton9Click
        end
        object SpeedButton10: TSpeedButton
          Left = 280
          Top = 14
          Width = 121
          Height = 19
          Caption = #1055#1088#1080#1085#1103#1090#1100
          OnClick = SpeedButton10Click
        end
        object Memo3: TMemo
          Left = 8
          Top = 37
          Width = 441
          Height = 100
          Anchors = [akLeft, akTop, akRight, akBottom]
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 459
        Height = 51
        Align = alTop
        TabOrder = 3
        DesignSize = (
          459
          51)
        object SpeedButton1: TSpeedButton
          Left = 385
          Top = 23
          Width = 65
          Height = 22
          Anchors = [akTop, akRight]
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          OnClick = SpeedButton1Click
        end
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 164
          Height = 13
          Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1072#1084' '#1088#1072#1073#1086#1095#1077#1081' '#1086#1073#1083#1072#1089#1090#1080
        end
        object Edit1: TEdit
          Left = 8
          Top = 24
          Width = 374
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
    end
    object panCreateGrArray: TPanel
      Tag = 21
      Left = 195
      Top = 401
      Width = 638
      Height = 553
      TabOrder = 9
      OnResize = panCreateGrArrayResize
      object Panel9: TPanel
        Left = 1
        Top = 1
        Width = 636
        Height = 25
        Align = alTop
        TabOrder = 0
        object Label91: TLabel
          Left = 8
          Top = 8
          Width = 72
          Height = 13
          Caption = #1048#1084#1103' '#1084#1072#1089#1089#1080#1074#1072':'
        end
        object Edit62: TEdit
          Left = 88
          Top = 1
          Width = 201
          Height = 21
          TabOrder = 0
          Text = 'A'
        end
        object Button47: TButton
          Left = 296
          Top = 4
          Width = 81
          Height = 17
          Caption = #1054#1090#1086#1073#1088#1072#1079#1080#1090#1100
          TabOrder = 1
          OnClick = Button47Click
        end
        object Button48: TButton
          Left = 381
          Top = 4
          Width = 85
          Height = 17
          Caption = #1057#1086#1079#1076#1072#1090#1100
          TabOrder = 2
          OnClick = Button48Click
        end
      end
      object ScrollBox1: TScrollBox
        Left = 1
        Top = 26
        Width = 636
        Height = 501
        Align = alClient
        TabOrder = 1
        object Image1: TImage
          Left = 0
          Top = 0
          Width = 225
          Height = 192
          Cursor = crCross
          OnMouseDown = Image1MouseDown
          OnMouseMove = Image1MouseMove
          OnMouseUp = Image1MouseUp
        end
      end
      object Panel10: TPanel
        Left = 1
        Top = 527
        Width = 636
        Height = 25
        Align = alBottom
        TabOrder = 2
        object Label90: TLabel
          Left = 8
          Top = 8
          Width = 50
          Height = 13
          Caption = #1056#1072#1079#1084#1077#1088#1099':'
        end
        object Label92: TLabel
          Left = 296
          Top = 8
          Width = 6
          Height = 13
          Caption = '0'
        end
        object Label93: TLabel
          Left = 344
          Top = 8
          Width = 6
          Height = 13
          Caption = '0'
        end
        object Edit61: TEdit
          Left = 64
          Top = 1
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '600'
        end
        object Edit63: TEdit
          Left = 140
          Top = 2
          Width = 73
          Height = 21
          TabOrder = 1
          Text = '300'
        end
        object Button49: TButton
          Left = 216
          Top = 4
          Width = 73
          Height = 17
          Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
          TabOrder = 2
          OnClick = Button49Click
        end
      end
    end
    object panDrawArray: TPanel
      Tag = 22
      Left = 144
      Top = 401
      Width = 638
      Height = 553
      TabOrder = 10
      object Splitter2: TSplitter
        Left = 1
        Top = 492
        Width = 636
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        Color = clPurple
        ParentColor = False
      end
      object Splitter3: TSplitter
        Left = 569
        Top = 1
        Height = 491
        Align = alRight
        Color = clPurple
        ParentColor = False
      end
      object Panel11: TPanel
        Left = 1
        Top = 496
        Width = 636
        Height = 56
        Align = alBottom
        TabOrder = 0
        DesignSize = (
          636
          56)
        object Label154: TLabel
          Left = 8
          Top = 35
          Width = 39
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = #1052#1072#1089#1089#1080#1074
        end
        object Edit109: TEdit
          Left = 53
          Top = 31
          Width = 121
          Height = 21
          Anchors = [akLeft, akBottom]
          TabOrder = 0
          Text = 'A'
        end
        object SpinEdit31: TSpinEdit
          Left = 304
          Top = 31
          Width = 73
          Height = 22
          Anchors = [akLeft, akBottom]
          MaxValue = 1000000000
          MinValue = 1
          TabOrder = 1
          Value = 1
        end
        object Button34: TButton
          Left = 387
          Top = 31
          Width = 81
          Height = 21
          Anchors = [akLeft, akBottom]
          Caption = #1054#1090#1086#1073#1088#1072#1079#1080#1090#1100
          TabOrder = 2
          OnClick = Button34Click
        end
        object CheckBox2: TCheckBox
          Left = 184
          Top = 32
          Width = 113
          Height = 17
          Anchors = [akLeft, akBottom]
          Caption = #1056#1080#1089#1086#1074#1072#1090#1100' '#1089#1090#1088#1086#1082#1091
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
      end
      object Panel12: TPanel
        Left = 572
        Top = 1
        Width = 65
        Height = 491
        Align = alRight
        TabOrder = 1
      end
      object Chart2: TChart
        Left = 1
        Top = 1
        Width = 568
        Height = 491
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Gradient.EndColor = 12615808
        Gradient.StartColor = clSilver
        Gradient.Visible = True
        Title.Alignment = taLeftJustify
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        BottomAxis.TickLength = 0
        LeftAxis.ExactDateTime = False
        LeftAxis.Increment = 0.200000000000000000
        LeftAxis.Labels = False
        LeftAxis.TitleSize = 5
        Legend.Alignment = laLeft
        Legend.ColorWidth = 15
        Legend.Visible = False
        RightAxis.ExactDateTime = False
        RightAxis.Increment = 0.100000000000000000
        RightAxis.LabelsSize = 16
        RightAxis.Title.Angle = 0
        TopAxis.Title.Caption = 'sdzfdsf'
        View3D = False
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object LineSeries1: TLineSeries
          Marks.ArrowLength = 8
          Marks.Visible = False
          SeriesColor = clBlack
          VertAxis = aBothVertAxis
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          XValues.DateTime = False
          XValues.Name = 'X'
          XValues.Multiplier = 1.000000000000000000
          XValues.Order = loAscending
          YValues.DateTime = False
          YValues.Name = 'Y'
          YValues.Multiplier = 1.000000000000000000
          YValues.Order = loNone
        end
      end
    end
    object panTestSpeed: TPanel
      Tag = 7777777
      Left = 1
      Top = 576
      Width = 643
      Height = 29
      Align = alBottom
      BevelInner = bvLowered
      TabOrder = 4
      object Label168: TLabel
        Left = 120
        Top = 8
        Width = 97
        Height = 13
        Caption = #1063#1080#1089#1083#1086' '#1087#1086#1074#1090#1086#1088#1077#1085#1080#1081':'
      end
      object Label169: TLabel
        Left = 302
        Top = 8
        Width = 101
        Height = 13
        Caption = #1042#1088#1077#1084#1103' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103':'
      end
      object Label170: TLabel
        Left = 486
        Top = 8
        Width = 14
        Height = 13
        Caption = #1084#1089
      end
      object Label171: TLabel
        Left = 8
        Top = 8
        Width = 104
        Height = 13
        Caption = #1054#1094#1077#1085#1082#1072' '#1089#1082#1086#1088#1086#1089#1090#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SpinEdit30: TSpinEdit
        Left = 218
        Top = 4
        Width = 81
        Height = 22
        MaxValue = 2000000000
        MinValue = 1
        TabOrder = 0
        Value = 1
        OnChange = SpinEdit30Change
      end
      object Edit120: TEdit
        Left = 405
        Top = 4
        Width = 70
        Height = 21
        TabOrder = 1
        Text = '0'
      end
    end
    object panZaglushka: TPanel
      Left = 840
      Top = 40
      Width = 9
      Height = 9
      Caption = #1056#1072#1079#1076#1077#1083' '#1085#1077' '#1085#1072#1081#1076#1077#1085
      TabOrder = 14
    end
    object panSet2: TPanel
      Tag = 12
      Left = 217
      Top = 489
      Width = 566
      Height = 499
      TabOrder = 5
      object GroupBox24: TGroupBox
        Left = 0
        Top = 8
        Width = 273
        Height = 153
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077' '#1095#1072#1089#1090#1080' '#1084#1072#1089#1089#1080#1074#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label77: TLabel
          Left = 8
          Top = 16
          Width = 48
          Height = 13
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label78: TLabel
          Left = 8
          Top = 96
          Width = 64
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1088#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label79: TLabel
          Left = 96
          Top = 96
          Width = 82
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label80: TLabel
          Left = 128
          Top = 16
          Width = 52
          Height = 13
          Caption = #1055#1088#1080#1077#1084#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label81: TLabel
          Left = 8
          Top = 56
          Width = 76
          Height = 13
          Caption = #1055#1077#1088#1074#1072#1103' '#1089#1090#1088#1086#1082#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label82: TLabel
          Left = 96
          Top = 56
          Width = 84
          Height = 13
          Caption = #1055#1077#1088#1074#1099#1081' '#1089#1090#1086#1083#1073#1077#1094
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit52: TEdit
          Left = 8
          Top = 32
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object SpinEdit8: TSpinEdit
          Left = 8
          Top = 112
          Width = 81
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 1
          Value = 1
        end
        object SpinEdit9: TSpinEdit
          Left = 96
          Top = 112
          Width = 81
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 2
          Value = 1
        end
        object Button43: TButton
          Left = 184
          Top = 72
          Width = 75
          Height = 23
          Caption = #1055#1088#1080#1085#1103#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button43Click
        end
        object Edit53: TEdit
          Left = 128
          Top = 32
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object SpinEdit10: TSpinEdit
          Left = 8
          Top = 72
          Width = 81
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 5
          Value = 1
        end
        object SpinEdit11: TSpinEdit
          Left = 96
          Top = 72
          Width = 81
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 6
          Value = 1
        end
      end
      object GroupBox25: TGroupBox
        Left = 282
        Top = 8
        Width = 279
        Height = 73
        Caption = #1057#1091#1084#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1090#1088#1086#1082'/'#1089#1090#1086#1083#1073#1094#1086#1074' '#1084#1072#1089#1089#1080#1074#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label83: TLabel
          Left = 16
          Top = 16
          Width = 71
          Height = 13
          Caption = #1048#1089#1093#1086#1076#1085'. '#1084#1072#1090#1088'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label84: TLabel
          Left = 96
          Top = 16
          Width = 78
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090'. '#1084#1072#1090#1088#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit54: TEdit
          Left = 8
          Top = 32
          Width = 81
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit55: TEdit
          Left = 96
          Top = 32
          Width = 73
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Button44: TButton
          Left = 185
          Top = 19
          Width = 75
          Height = 19
          Caption = #1057#1090#1088#1086#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button44Click
        end
        object Button71: TButton
          Left = 184
          Top = 44
          Width = 75
          Height = 18
          Caption = #1057#1090#1086#1083#1073#1094#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button71Click
        end
      end
      object GroupBox28: TGroupBox
        Left = -1
        Top = 162
        Width = 273
        Height = 105
        Caption = #1047#1072#1084#1077#1085#1072' '#1095#1072#1089#1090#1080' '#1084#1072#1089#1089#1080#1074#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label94: TLabel
          Left = 16
          Top = 16
          Width = 48
          Height = 13
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label97: TLabel
          Left = 136
          Top = 16
          Width = 52
          Height = 13
          Caption = #1055#1088#1080#1077#1084#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label98: TLabel
          Left = 8
          Top = 56
          Width = 36
          Height = 13
          Caption = #1057#1090#1088#1086#1082#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label99: TLabel
          Left = 96
          Top = 56
          Width = 42
          Height = 13
          Caption = #1057#1090#1086#1083#1073#1077#1094
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit64: TEdit
          Left = 8
          Top = 32
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Button50: TButton
          Left = 184
          Top = 72
          Width = 75
          Height = 23
          Caption = #1055#1088#1080#1085#1103#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Button50Click
        end
        object Edit65: TEdit
          Left = 128
          Top = 32
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object SpinEdit14: TSpinEdit
          Left = 8
          Top = 72
          Width = 81
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 3
          Value = 1
        end
        object SpinEdit15: TSpinEdit
          Left = 96
          Top = 72
          Width = 81
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 4
          Value = 1
        end
      end
      object GroupBox38: TGroupBox
        Left = 282
        Top = 264
        Width = 279
        Height = 81
        Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1086#1074
        TabOrder = 3
        object Label128: TLabel
          Left = 9
          Top = 12
          Width = 48
          Height = 13
          Caption = #1052#1072#1089#1089#1080#1074' 1'
        end
        object Label129: TLabel
          Left = 89
          Top = 12
          Width = 48
          Height = 13
          Caption = #1052#1072#1089#1089#1080#1074' 2'
        end
        object Label130: TLabel
          Left = 168
          Top = 11
          Width = 91
          Height = 13
          Caption = #1042#1099#1093#1086#1076#1085#1086#1081' '#1084#1072#1089#1089#1080#1074
        end
        object Edit87: TEdit
          Left = 8
          Top = 24
          Width = 73
          Height = 21
          TabOrder = 0
        end
        object Edit89: TEdit
          Left = 88
          Top = 25
          Width = 73
          Height = 21
          TabOrder = 1
        end
        object Edit90: TEdit
          Left = 169
          Top = 24
          Width = 72
          Height = 21
          TabOrder = 2
        end
        object Button60: TButton
          Left = 84
          Top = 51
          Width = 77
          Height = 19
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          TabOrder = 3
          OnClick = Button60Click
        end
      end
      object GroupBox34: TGroupBox
        Left = 282
        Top = 84
        Width = 279
        Height = 69
        Caption = #1059#1084#1085#1086#1078#1077#1085#1080#1077' '#1084#1072#1090#1088#1080#1094' '#1040'*'#1042'='#1057
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object Label114: TLabel
          Left = 8
          Top = 15
          Width = 7
          Height = 13
          Caption = #1040
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label115: TLabel
          Left = 128
          Top = 15
          Width = 7
          Height = 13
          Caption = #1042
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label116: TLabel
          Left = 6
          Top = 39
          Width = 7
          Height = 13
          Caption = #1057
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit78: TEdit
          Left = 24
          Top = 15
          Width = 89
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit79: TEdit
          Left = 144
          Top = 15
          Width = 81
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Edit80: TEdit
          Left = 24
          Top = 39
          Width = 89
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button56: TButton
          Left = 144
          Top = 40
          Width = 81
          Height = 20
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button56Click
        end
      end
      object GroupBox40: TGroupBox
        Left = 282
        Top = 160
        Width = 279
        Height = 97
        Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1088#1072#1079#1084#1077#1088#1086#1074' '#1052#1040#1058#1056#1048#1062#1067
        TabOrder = 5
        object Label133: TLabel
          Left = 8
          Top = 13
          Width = 70
          Height = 13
          Caption = #1048#1084#1103' '#1084#1072#1090#1088#1080#1094#1099
        end
        object Label134: TLabel
          Left = 8
          Top = 53
          Width = 64
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1088#1086#1082
        end
        object Label135: TLabel
          Left = 104
          Top = 52
          Width = 82
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
        end
        object Edit92: TEdit
          Left = 8
          Top = 25
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object Button62: TButton
          Left = 193
          Top = 17
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          TabOrder = 1
          OnClick = Button62Click
        end
        object SpinEdit23: TSpinEdit
          Left = 8
          Top = 65
          Width = 81
          Height = 22
          MaxValue = 1000000000
          MinValue = 0
          TabOrder = 2
          Value = 1
        end
        object SpinEdit24: TSpinEdit
          Left = 104
          Top = 65
          Width = 81
          Height = 22
          MaxValue = 1000000000
          MinValue = 0
          TabOrder = 3
          Value = 1
        end
      end
      object GroupBox39: TGroupBox
        Left = 0
        Top = 272
        Width = 273
        Height = 137
        Caption = #1055#1086#1080#1089#1082' '#1084#1080#1085'/'#1084#1072#1082#1089' '#1101#1083#1077#1084#1077#1085#1090#1072' '#1089#1090#1088#1086#1082#1080
        TabOrder = 6
        object Label131: TLabel
          Left = 8
          Top = 13
          Width = 69
          Height = 13
          Caption = #1048#1084#1103' '#1084#1072#1089#1089#1080#1074#1072
        end
        object Label132: TLabel
          Left = 104
          Top = 13
          Width = 34
          Height = 13
          Caption = #1053#1086#1084#1077#1088
        end
        object Label185: TLabel
          Left = 8
          Top = 93
          Width = 38
          Height = 13
          Caption = #1048#1085#1076#1077#1082#1089
        end
        object Label186: TLabel
          Left = 8
          Top = 53
          Width = 48
          Height = 13
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        end
        object Edit91: TEdit
          Left = 8
          Top = 29
          Width = 81
          Height = 21
          TabOrder = 0
        end
        object Button61: TButton
          Left = 160
          Top = 65
          Width = 75
          Height = 25
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          TabOrder = 1
          OnClick = Button61Click
        end
        object CheckBox6: TCheckBox
          Left = 160
          Top = 21
          Width = 105
          Height = 17
          Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object SpinEdit22: TSpinEdit
          Left = 96
          Top = 28
          Width = 57
          Height = 22
          MaxValue = 1000000000
          MinValue = 0
          TabOrder = 3
          Value = 1
        end
        object CheckBox14: TCheckBox
          Left = 160
          Top = 40
          Width = 97
          Height = 17
          Caption = #1044#1083#1103' '#1089#1090#1088#1086#1082#1080
          TabOrder = 4
        end
        object Edit131: TEdit
          Left = 8
          Top = 109
          Width = 81
          Height = 21
          TabOrder = 5
        end
        object Edit132: TEdit
          Left = 8
          Top = 69
          Width = 81
          Height = 21
          TabOrder = 6
        end
      end
      object GroupBox26: TGroupBox
        Left = 281
        Top = 346
        Width = 280
        Height = 89
        Caption = #1042#1089#1090#1072#1074#1082#1072' '#1089#1090#1088#1086#1082'/'#1089#1090#1086#1083#1073#1094#1086#1074' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        object Label85: TLabel
          Left = 8
          Top = 12
          Width = 48
          Height = 13
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label86: TLabel
          Left = 107
          Top = 12
          Width = 52
          Height = 13
          Caption = #1055#1088#1080#1077#1084#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label167: TLabel
          Left = 8
          Top = 48
          Width = 118
          Height = 13
          Caption = #1053#1086#1084#1077#1088' '#1089#1090#1088#1086#1082#1080'/'#1089#1090#1086#1083#1073#1094#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit56: TEdit
          Left = 8
          Top = 24
          Width = 89
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Button45: TButton
          Left = 208
          Top = 24
          Width = 57
          Height = 23
          Caption = #1057#1090#1088#1086#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Button45Click
        end
        object Edit57: TEdit
          Left = 104
          Top = 24
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object SpinEdit29: TSpinEdit
          Left = 8
          Top = 64
          Width = 121
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 3
          Value = 1
        end
        object Button72: TButton
          Left = 208
          Top = 50
          Width = 57
          Height = 23
          Caption = #1057#1090#1086#1083#1073#1094#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = Button72Click
        end
      end
    end
    object panSet1: TPanel
      Tag = 11
      Left = -39
      Top = 521
      Width = 619
      Height = 499
      TabOrder = 3
      object GroupBox8: TGroupBox
        Left = 8
        Top = 120
        Width = 233
        Height = 81
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label16: TLabel
          Left = 8
          Top = 16
          Width = 48
          Height = 13
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label17: TLabel
          Left = 112
          Top = 16
          Width = 52
          Height = 13
          Caption = #1055#1088#1080#1077#1084#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit3: TEdit
          Left = 8
          Top = 32
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit5: TEdit
          Left = 112
          Top = 32
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Button11: TButton
          Left = 72
          Top = 56
          Width = 73
          Height = 21
          Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button11Click
        end
      end
      object GroupBox9: TGroupBox
        Left = 8
        Top = 8
        Width = 233
        Height = 105
        Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1085#1091#1083#1077#1074#1086#1075#1086' '#1084#1072#1089#1089#1080#1074#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object Label18: TLabel
          Left = 8
          Top = 16
          Width = 64
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1088#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label19: TLabel
          Left = 128
          Top = 16
          Width = 82
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label20: TLabel
          Left = 8
          Top = 56
          Width = 97
          Height = 13
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpinEdit1: TSpinEdit
          Left = 8
          Top = 32
          Width = 97
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 0
          MinValue = 0
          ParentFont = False
          TabOrder = 0
          Value = 1
        end
        object SpinEdit2: TSpinEdit
          Left = 128
          Top = 32
          Width = 89
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 0
          MinValue = 0
          ParentFont = False
          TabOrder = 1
          Value = 1
        end
        object Edit6: TEdit
          Left = 8
          Top = 72
          Width = 113
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Button12: TButton
          Left = 128
          Top = 72
          Width = 81
          Height = 21
          Caption = #1054#1050
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button12Click
        end
        object CheckBox10: TCheckBox
          Left = 128
          Top = 56
          Width = 97
          Height = 17
          Caption = #1047#1072#1073#1080#1090#1100' '#1085#1091#1083#1103#1084#1080
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 4
        end
      end
      object GroupBox10: TGroupBox
        Left = 248
        Top = 264
        Width = 273
        Height = 153
        Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1086#1090#1076#1077#1083#1100#1085#1099#1093' '#1101#1083#1077#1084#1077#1085#1090#1086#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object Label21: TLabel
          Left = 8
          Top = 56
          Width = 97
          Height = 13
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label22: TLabel
          Left = 8
          Top = 16
          Width = 72
          Height = 13
          Caption = #1053#1086#1084#1077#1088' '#1089#1090#1088#1086#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label23: TLabel
          Left = 96
          Top = 16
          Width = 78
          Height = 13
          Caption = #1053#1086#1084#1077#1088' '#1089#1090#1086#1083#1073#1094#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label24: TLabel
          Left = 8
          Top = 101
          Width = 48
          Height = 13
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton13: TSpeedButton
          Left = 144
          Top = 102
          Width = 73
          Height = 17
          Caption = #1055#1086#1082#1072#1079#1072#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = SpeedButton13Click
        end
        object SpeedButton14: TSpeedButton
          Left = 144
          Top = 120
          Width = 73
          Height = 17
          Caption = #1047#1072#1087#1080#1089#1072#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          OnClick = SpeedButton14Click
        end
        object Edit7: TEdit
          Left = 8
          Top = 72
          Width = 137
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object SpinEdit3: TSpinEdit
          Left = 8
          Top = 32
          Width = 81
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 1
          Value = 1
        end
        object SpinEdit4: TSpinEdit
          Left = 96
          Top = 32
          Width = 81
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 2
          Value = 1
        end
        object Edit8: TEdit
          Left = 8
          Top = 117
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object CheckBox7: TCheckBox
          Left = 152
          Top = 64
          Width = 65
          Height = 17
          Caption = 'AutoSize'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object CheckBox8: TCheckBox
          Left = 152
          Top = 80
          Width = 73
          Height = 17
          Caption = 'AutoCreate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
      end
      object GroupBox11: TGroupBox
        Left = 248
        Top = 8
        Width = 273
        Height = 137
        Caption = #1057#1083#1080#1103#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1086#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        DesignSize = (
          273
          137)
        object Label25: TLabel
          Left = 8
          Top = 16
          Width = 81
          Height = 13
          Caption = #1055#1077#1088#1074#1099#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label26: TLabel
          Left = 136
          Top = 16
          Width = 77
          Height = 13
          Caption = #1042#1090#1086#1088#1086#1081' '#1084#1072#1089#1089#1080#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label27: TLabel
          Left = 8
          Top = 56
          Width = 52
          Height = 13
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Button13: TButton
          Left = 8
          Top = 104
          Width = 113
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = #1055#1086' '#1089#1090#1088#1086#1082#1072#1084
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = Button13Click
        end
        object Button14: TButton
          Left = 160
          Top = 104
          Width = 99
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = #1055#1086' '#1089#1090#1086#1083#1073#1094#1072#1084
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Button14Click
        end
        object Edit9: TEdit
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Edit10: TEdit
          Left = 136
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object Edit11: TEdit
          Left = 8
          Top = 72
          Width = 249
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
      end
      object GroupBox12: TGroupBox
        Left = 248
        Top = 152
        Width = 273
        Height = 105
        Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077'/'#1074#1099#1088#1077#1079#1072#1085#1080#1077' '#1089#1090#1088#1086#1082'/'#1089#1090#1086#1083#1073#1094#1086#1074
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        object Label28: TLabel
          Left = 8
          Top = 16
          Width = 48
          Height = 13
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label29: TLabel
          Left = 152
          Top = 16
          Width = 52
          Height = 13
          Caption = #1055#1088#1080#1077#1084#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label30: TLabel
          Left = 8
          Top = 56
          Width = 34
          Height = 13
          Caption = #1053#1086#1084#1077#1088
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label136: TLabel
          Left = 64
          Top = 56
          Width = 34
          Height = 13
          Caption = #1050#1086#1083'-'#1074#1086
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit12: TEdit
          Left = 8
          Top = 32
          Width = 121
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit13: TEdit
          Left = 152
          Top = 32
          Width = 113
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object SpinEdit5: TSpinEdit
          Left = 8
          Top = 72
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 2
          Value = 1
        end
        object Button15: TButton
          Left = 132
          Top = 72
          Width = 67
          Height = 22
          Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = Button15Click
        end
        object Button16: TButton
          Left = 200
          Top = 72
          Width = 59
          Height = 22
          Caption = #1042#1099#1088#1077#1079#1072#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = Button16Click
        end
        object CheckBox1: TCheckBox
          Left = 128
          Top = 56
          Width = 137
          Height = 15
          Caption = '1 - '#1089#1090#1088#1086#1082#1072', 0 - '#1089#1090#1086#1083#1073#1077#1094
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 5
        end
        object SpinEdit25: TSpinEdit
          Left = 64
          Top = 72
          Width = 49
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxValue = 1000000000
          MinValue = 1
          ParentFont = False
          TabOrder = 6
          Value = 1
        end
      end
      object GroupBox13: TGroupBox
        Left = 8
        Top = 208
        Width = 233
        Height = 81
        Caption = #1058#1088#1072#1085#1089#1087#1086#1085#1080#1088#1086#1074#1072#1085#1080#1077
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object Label31: TLabel
          Left = 8
          Top = 16
          Width = 48
          Height = 13
          Caption = #1048#1089#1090#1086#1095#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label32: TLabel
          Left = 120
          Top = 16
          Width = 52
          Height = 13
          Caption = #1055#1088#1080#1077#1084#1085#1080#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit14: TEdit
          Left = 8
          Top = 32
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit15: TEdit
          Left = 112
          Top = 32
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Button17: TButton
          Left = 56
          Top = 58
          Width = 105
          Height = 19
          Caption = #1058#1088#1072#1085#1089#1087#1086#1085#1080#1088#1086#1074#1072#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button17Click
        end
      end
      object GroupBox14: TGroupBox
        Left = 8
        Top = 384
        Width = 233
        Height = 105
        Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1088#1072#1079#1084#1077#1088#1086#1074' '#1084#1072#1089#1089#1080#1074#1072
        TabOrder = 6
        object Label35: TLabel
          Left = 8
          Top = 16
          Width = 97
          Height = 13
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1072
        end
        object Label36: TLabel
          Left = 8
          Top = 56
          Width = 64
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1088#1086#1082
        end
        object Label37: TLabel
          Left = 96
          Top = 56
          Width = 82
          Height = 13
          Caption = #1063#1080#1089#1083#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
        end
        object Edit16: TEdit
          Left = 8
          Top = 32
          Width = 129
          Height = 21
          TabOrder = 0
        end
        object SpinEdit6: TSpinEdit
          Left = 8
          Top = 72
          Width = 81
          Height = 22
          MaxValue = 1000000000
          MinValue = 1
          TabOrder = 1
          Value = 1
        end
        object SpinEdit7: TSpinEdit
          Left = 96
          Top = 72
          Width = 81
          Height = 22
          MaxValue = 1000000000
          MinValue = 1
          TabOrder = 2
          Value = 1
        end
        object Button18: TButton
          Left = 144
          Top = 32
          Width = 75
          Height = 23
          Caption = #1055#1088#1080#1085#1103#1090#1100
          TabOrder = 3
          OnClick = Button18Click
        end
      end
      object GroupBox17: TGroupBox
        Left = 8
        Top = 296
        Width = 233
        Height = 81
        Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1080#1084#1077#1085#1080' '#1084#1072#1089#1089#1080#1074#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        object Label10: TLabel
          Left = 8
          Top = 16
          Width = 59
          Height = 13
          Caption = #1057#1090#1072#1088#1086#1077' '#1080#1084#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label33: TLabel
          Left = 112
          Top = 16
          Width = 55
          Height = 13
          Caption = #1053#1086#1074#1086#1077' '#1080#1084#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit17: TEdit
          Left = 8
          Top = 32
          Width = 97
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Edit18: TEdit
          Left = 112
          Top = 32
          Width = 105
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Button23: TButton
          Left = 64
          Top = 56
          Width = 89
          Height = 21
          Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Button23Click
        end
      end
    end
    object panViewArrays: TPanel
      Tag = 2
      Left = -2
      Top = -1
      Width = 645
      Height = 607
      TabOrder = 1
      object Splitter1: TSplitter
        Left = 1
        Top = 185
        Width = 643
        Height = 3
        Cursor = crVSplit
        Align = alTop
      end
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 643
        Height = 184
        Align = alTop
        TabOrder = 0
        object GroupBox4: TGroupBox
          Left = 1
          Top = 1
          Width = 641
          Height = 182
          Align = alClient
          Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1084#1077#1085' '#1084#1072#1089#1089#1080#1074#1086#1074' '#1088#1072#1073#1086#1095#1077#1081' '#1086#1073#1083#1072#1089#1090#1080' Base'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          DesignSize = (
            641
            182)
          object Label2: TLabel
            Left = 392
            Top = 24
            Width = 151
            Height = 13
            Anchors = [akTop, akRight]
            Caption = #1054#1073#1097#1077#1077' '#1095#1080#1089#1083#1086' '#1101#1083#1077#1084#1077#1085#1090#1086#1074':'
          end
          object Label3: TLabel
            Left = 545
            Top = 24
            Width = 5
            Height = 13
            Anchors = [akTop, akRight]
          end
          object ListBox1: TListBox
            Left = 2
            Top = 15
            Width = 384
            Height = 124
            Align = alLeft
            Anchors = [akLeft, akTop, akRight, akBottom]
            ItemHeight = 13
            MultiSelect = True
            TabOrder = 0
            OnClick = ListBox1Click
          end
          object Panel4: TPanel
            Left = 2
            Top = 139
            Width = 637
            Height = 41
            Align = alBottom
            TabOrder = 1
            object Button1: TButton
              Left = 152
              Top = 8
              Width = 73
              Height = 25
              Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
              TabOrder = 0
              OnClick = Button1Click
            end
            object Button2: TButton
              Left = 228
              Top = 8
              Width = 81
              Height = 25
              Caption = #1059#1076#1072#1083#1080#1090#1100
              TabOrder = 1
              OnClick = Button2Click
            end
            object Button63: TButton
              Left = 312
              Top = 8
              Width = 113
              Height = 25
              Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1105
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = Button63Click
            end
            object Button4: TButton
              Left = 3
              Top = 8
              Width = 145
              Height = 25
              Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1077
              TabOrder = 3
              OnClick = Button4Click
            end
            object Button82: TButton
              Left = 464
              Top = 8
              Width = 89
              Height = 25
              Caption = 'Button82'
              TabOrder = 4
              OnClick = Button82Click
            end
          end
          object GroupBox5: TGroupBox
            Left = 393
            Top = 55
            Width = 246
            Height = 82
            Anchors = [akTop, akRight]
            Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1084#1072#1089#1089#1080#1074#1072':'
            TabOrder = 2
            object Label6: TLabel
              Left = 8
              Top = 16
              Width = 76
              Height = 13
              Caption = #1063#1080#1089#1083#1086' '#1089#1090#1088#1086#1082
            end
            object Label7: TLabel
              Left = 8
              Top = 32
              Width = 97
              Height = 13
              Caption = #1063#1080#1089#1083#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
            end
            object Label8: TLabel
              Left = 8
              Top = 48
              Width = 158
              Height = 13
              Caption = #1047#1072#1085#1080#1084#1072#1077#1084#1072#1103' '#1087#1072#1084#1103#1090#1100', '#1073#1072#1081#1090
            end
            object Label9: TLabel
              Left = 8
              Top = 64
              Width = 141
              Height = 13
              Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085' '#1087#1086' '#1072#1076#1088#1077#1089#1091':'
            end
            object Label11: TLabel
              Left = 96
              Top = 16
              Width = 5
              Height = 13
            end
            object Label12: TLabel
              Left = 112
              Top = 32
              Width = 5
              Height = 13
            end
            object Label13: TLabel
              Left = 173
              Top = 48
              Width = 5
              Height = 13
            end
            object Label14: TLabel
              Left = 152
              Top = 64
              Width = 5
              Height = 13
            end
          end
        end
      end
      object Panel3: TPanel
        Left = 1
        Top = 188
        Width = 643
        Height = 418
        Align = alClient
        TabOrder = 1
        object Panel7: TPanel
          Left = 1
          Top = 376
          Width = 641
          Height = 41
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object Button3: TButton
            Left = 8
            Top = 8
            Width = 185
            Height = 25
            Caption = #1057#1086#1079#1076#1072#1090#1100' '#1079#1072#1076#1072#1085#1085#1099#1077' '#1084#1072#1089#1089#1080#1074#1099
            TabOrder = 0
            OnClick = Button3Click
          end
          object Button5: TButton
            Left = 198
            Top = 8
            Width = 75
            Height = 25
            Caption = #1054#1095#1080#1089#1090#1080#1090#1100
            TabOrder = 1
            OnClick = Button5Click
          end
        end
        object Memo4: TMemo
          Left = 1
          Top = 18
          Width = 641
          Height = 358
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Fixedsys'
          Font.Style = []
          Lines.Strings = (
            'A=[1; 2; 3; 4]'
            ''
            'B=[11 22; 33 44; 5 4; 3 2]')
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 1
        end
        object Panel8: TPanel
          Left = 1
          Top = 1
          Width = 641
          Height = 17
          Align = alTop
          Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080' '#1089#1086#1079#1076#1072#1085#1080#1077' '#1084#1072#1089#1089#1080#1074#1086#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 606
    Align = alLeft
    TabOrder = 1
    object TreeView1: TTreeView
      Left = 1
      Top = 25
      Width = 175
      Height = 580
      Align = alClient
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      OnChange = TreeView1Change
      Items.Data = {
        05000000280000000200000000000000FFFFFFFFFFFFFFFF0000000003000000
        0FD0E0E1EEF7E0FF20EEE1EBE0F1F2FC2B0000000100000000000000FFFFFFFF
        FFFFFFFF000000000000000012C7E0E3F0F3E7EAE020E8E720F4E0E9EBEEE22A
        0000000200000000000000FFFFFFFFFFFFFFFF000000000000000011CFF0EEF1
        ECEEF2F020ECE0F1F1E8E2EEE2390000000300000000000000FFFFFFFFFFFFFF
        FF000000000000000020C7E0EFE8F1FC2FF7F2E5EDE8E520EEF2E4E5EBFCEDFB
        F520ECE0F1F1E8E2EEE2250000000B00000000000000FFFFFFFFFFFFFFFF0000
        0000070000000CD4F3EDEAF6E8E820FFE4F0E0200000000B00000000000000FF
        FFFFFFFFFFFFFF000000000000000007CDE0E1EEF02031200000000C00000000
        000000FFFFFFFFFFFFFFFF000000000000000007CDE0E1EEF02032200000000D
        00000000000000FFFFFFFFFFFFFFFF000000000000000007CDE0E1EEF020332C
        0000000E00000000000000FFFFFFFFFFFFFFFF000000000000000013C7E0EFEE
        EBEDE5EDE8E520ECE0F1F1E8E2EEE2340000000F00000000000000FFFFFFFFFF
        FFFFFF00000000000000001BD0E0E1EEF2E020F120EFEEF2EEEAE0ECE820E820
        EFE0ECFFF2FCFE280000001000000000000000FFFFFFFFFFFFFFFF0000000000
        0000000FD1F2E0F22E20EEE1F0E0E1EEF2EAE0280000000000000000000000FF
        FFFFFFFFFFFFFF00000000000000000FCDE520E8F1EFEEEBFCE7F3E5F2F1FF20
        0000001500000000000000FFFFFFFFFFFFFFFF000000000200000007C3F0E0F4
        E8EAE0290000001500000000000000FFFFFFFFFFFFFFFF000000000000000010
        D1EEE7E4E0EDE8E520ECE0F1F1E8E2E0250000001600000000000000FFFFFFFF
        FFFFFFFF00000000000000000CC2E8E7F3E0EBE8E7E0F6E8FF300000001F0000
        0000000000FFFFFFFFFFFFFFFF000000000000000017C2E7E0E8ECEEE4E5E9F1
        F2E2E8E520F1204D61746C6162280000000000000000000000FFFFFFFFFFFFFF
        FF00000000030000000FC2EDE5F8EDE8E520F4F3EDEAF6E8E827000000290000
        0000000000FFFFFFFFFFFFFFFF00000000020000000ECCEEE4F3EBFC20536967
        6E616C73200000002900000000000000FFFFFFFFFFFFFFFF0000000000000000
        07CDE0E1EEF02031200000000000000000000000FFFFFFFFFFFFFFFF00000000
        0000000007CDE0E1EEF02032280000003300000000000000FFFFFFFFFFFFFFFF
        00000000000000000FCCEEE4F3EBFC2044656D6F46756E63240000003D000000
        00000000FFFFFFFFFFFFFFFF00000000020000000BCCEEE4F3EBFC204E4E6574
        200000003D00000000000000FFFFFFFFFFFFFFFF000000000000000007CDE0E1
        EEF020312D0000003F00000000000000FFFFFFFFFFFFFFFF0000000000000000
        14CEE1F3F7E5EDE8E520EFE5F0F1E5EFF2F0EEEDE0}
    end
    object Panel6: TPanel
      Left = 1
      Top = 1
      Width = 175
      Height = 24
      Align = alTop
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object OpenDialog3: TOpenDialog
    DefaultExt = '*.dat'
    Filter = 'DAT-'#1092#1072#1081#1083#1099'|*.dat|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofAllowMultiSelect, ofEnableSizing]
    Left = 64
    Top = 184
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = '*.bin'
    Filter = 'BIN-'#1092#1072#1081#1083#1099'|*.bin|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofAllowMultiSelect, ofEnableSizing]
    Left = 80
    Top = 184
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.asc'
    Filter = 'ACSII-'#1092#1072#1081#1083#1099'|*.asc|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofAllowMultiSelect, ofEnableSizing]
    Left = 104
    Top = 184
  end
  object OpenDialog4: TOpenDialog
    DefaultExt = '*.*'
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofAllowMultiSelect, ofEnableSizing]
    Left = 80
    Top = 224
  end
end
