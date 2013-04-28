object DBFViewerForm: TDBFViewerForm
  Left = 233
  Top = 114
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1090#1072#1073#1083#1080#1094' DBF'
  ClientHeight = 427
  ClientWidth = 954
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 954
    Height = 61
    Align = alTop
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 3
      Top = 0
      Width = 182
      Height = 57
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
      TabOrder = 0
      object cbSortFields: TComboBox
        Left = 6
        Top = 14
        Width = 145
        Height = 24
        Hint = 
          #1059#1082#1072#1078#1080#1090#1077' '#1080#1084#1077#1085#1072' '#1087#1086#1083#1077#1081' '#1095#1077#1088#1077#1079' ";".'#13#10#1044#1072#1085#1085#1099#1077' '#1074' '#1090#1072#1073#1083#1080#1094#1077' '#1073#1091#1076#1091#1090' '#1086#1090#1089#1086#1088#1090#1080#1088#1086 +
          #1074#1072#1085#1099#13#10#1087#1086' '#1074#1086#1079#1088#1072#1089#1090#1072#1085#1080#1102' '#1074' '#1091#1082#1072#1079#1072#1085#1085#1086#1084' '#1087#1086#1088#1103#1076#1082#1077'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object btnSort: TButton
        Left = 152
        Top = 14
        Width = 25
        Height = 24
        Hint = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1091
        Caption = '>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnSortClick
      end
      object rbSortASC: TRadioButton
        Left = 8
        Top = 38
        Width = 65
        Height = 17
        Hint = 
          #1057#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103' '#1082#1086#1076#1080#1088#1086#1074#1082#1072' '#1076#1083#1103' '#1090#1072#1073#1083#1080#1094' DBF.'#13#10#1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103' ' +
          #1076#1083#1103' DOS'#13#10#1082#1086#1076#1086#1074#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072' 866 ('#1082#1080#1088#1080#1083#1083#1080#1094#1072').'#13#10#1052#1086#1078#1085#1086' '#1086#1090#1082#1088#1099#1090#1100' '#1074' '#1087#1086#1084#1086 +
          #1097#1100#1102' MS Excel,'#13#10'OpenOffice Calc, 1C '#1080' '#1084#1085#1086#1075#1080#1093' '#1076#1088#1091#1075#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084'.'
        Caption = #1055#1088#1103#1084#1072#1103
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object rbSortDESC: TRadioButton
        Left = 72
        Top = 38
        Width = 73
        Height = 17
        Hint = 
          #1057#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103' '#1082#1086#1076#1080#1088#1086#1074#1082#1072' '#1076#1083#1103' '#1090#1072#1073#1083#1080#1094' DBF.'#13#10#1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103' ' +
          #1076#1083#1103' DOS'#13#10#1082#1086#1076#1086#1074#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072' 866 ('#1082#1080#1088#1080#1083#1083#1080#1094#1072').'#13#10#1052#1086#1078#1085#1086' '#1086#1090#1082#1088#1099#1090#1100' '#1074' '#1087#1086#1084#1086 +
          #1097#1100#1102' MS Excel,'#13#10'OpenOffice Calc, 1C '#1080' '#1084#1085#1086#1075#1080#1093' '#1076#1088#1091#1075#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084'.'
        Caption = #1054#1073#1088#1072#1090#1085#1072#1103
        Checked = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        TabStop = True
      end
    end
    object GroupBox3: TGroupBox
      Left = 192
      Top = 1
      Width = 238
      Height = 56
      Caption = #1060#1080#1083#1100#1090#1088
      TabOrder = 1
      object edFilter: TEdit
        Left = 8
        Top = 15
        Width = 195
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object Button1: TButton
        Left = 206
        Top = 14
        Width = 25
        Height = 24
        Hint = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1092#1080#1083#1100#1090#1088#1072#1094#1080#1102
        Caption = '>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button1Click
      end
      object cbFilterCaseInsensitive: TCheckBox
        Left = 8
        Top = 38
        Width = 97
        Height = 17
        Caption = #1059#1095#1080#1090'. '#1088#1077#1075#1080#1089#1090#1088
        TabOrder = 2
      end
      object cbFilterPartialKey: TCheckBox
        Left = 100
        Top = 38
        Width = 135
        Height = 17
        Caption = #1063#1072#1089#1090#1080#1095#1085#1086#1077' '#1089#1088#1072#1074#1085#1077#1085#1080#1077
        TabOrder = 3
      end
    end
    object gbFind: TGroupBox
      Left = 435
      Top = 1
      Width = 253
      Height = 57
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 2
      object Label6: TLabel
        Left = 114
        Top = 16
        Width = 11
        Height = 20
        Caption = '='
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object cbFindFields: TComboBox
        Left = 6
        Top = 14
        Width = 107
        Height = 24
        Hint = 
          #1059#1082#1072#1078#1080#1090#1077' '#1080#1084#1077#1085#1072' '#1087#1086#1083#1077#1081' '#1095#1077#1088#1077#1079' ";".'#13#10#1044#1072#1085#1085#1099#1077' '#1074' '#1090#1072#1073#1083#1080#1094#1077' '#1073#1091#1076#1091#1090' '#1086#1090#1089#1086#1088#1090#1080#1088#1086 +
          #1074#1072#1085#1099#13#10#1087#1086' '#1074#1086#1079#1088#1072#1089#1090#1072#1085#1080#1102' '#1074' '#1091#1082#1072#1079#1072#1085#1085#1086#1084' '#1087#1086#1088#1103#1076#1082#1077'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object Button2: TButton
        Left = 222
        Top = 14
        Width = 25
        Height = 24
        Hint = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1080#1089#1082
        Caption = '>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button2Click
      end
      object edFindValue: TEdit
        Left = 129
        Top = 14
        Width = 89
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object cbCaseInsensitive: TCheckBox
        Left = 8
        Top = 38
        Width = 97
        Height = 17
        Caption = #1059#1095#1080#1090'. '#1088#1077#1075#1080#1089#1090#1088
        TabOrder = 3
      end
      object cbPartialKey: TCheckBox
        Left = 110
        Top = 38
        Width = 121
        Height = 17
        Caption = #1063#1072#1089#1090#1080#1095#1085#1099#1081' '#1087#1086#1080#1089#1082
        TabOrder = 4
      end
    end
    object Button3: TButton
      Left = 696
      Top = 33
      Width = 90
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 792
      Top = 33
      Width = 90
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 696
      Top = 4
      Width = 185
      Height = 25
      Caption = #1055#1077#1088#1077#1082#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = Button5Click
    end
    object btnClear: TButton
      Left = 888
      Top = 8
      Width = 55
      Height = 18
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 6
      OnClick = btnClearClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 61
    Width = 201
    Height = 366
    Align = alLeft
    TabOrder = 1
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 199
      Height = 165
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 0
        Width = 149
        Height = 13
        Caption = #1050#1072#1090#1072#1083#1086#1075' '#1089' '#1092#1072#1081#1083#1072#1084#1080' DBF:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 8
        Top = 144
        Width = 69
        Height = 13
        Caption = #1050#1086#1076#1080#1088#1086#1074#1082#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object deDBFDir: TJvDirectoryEdit
        Left = 8
        Top = 16
        Width = 185
        Height = 21
        OnAfterDialog = deDBFDirAfterDialog
        DialogKind = dkWin32
        TabOrder = 0
      end
      object gbSortType: TRadioGroup
        Left = 8
        Top = 40
        Width = 185
        Height = 55
        Caption = #1057#1087#1086#1089#1086#1073' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1092#1072#1081#1083#1086#1074':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          #1087#1086' '#1080#1084#1077#1085#1080
          #1087#1086' '#1076#1072#1090#1077
          #1087#1086' '#1088#1072#1079#1084#1077#1088#1091)
        ParentFont = False
        TabOrder = 1
        OnClick = gbSortTypeClick
      end
      object gbSortDirection: TRadioGroup
        Left = 6
        Top = 96
        Width = 185
        Height = 42
        Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          #1087#1088#1103#1084#1086#1077'    ('#1072' -> '#1103')'
          #1086#1073#1088#1072#1090#1085#1086#1077' ('#1103' -> '#1072')')
        ParentFont = False
        TabOrder = 2
        OnClick = gbSortTypeClick
      end
      object rbPage866: TRadioButton
        Left = 80
        Top = 144
        Width = 41
        Height = 17
        Hint = 
          #1057#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103' '#1082#1086#1076#1080#1088#1086#1074#1082#1072' '#1076#1083#1103' '#1090#1072#1073#1083#1080#1094' DBF.'#13#10#1048#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103' ' +
          #1076#1083#1103' DOS'#13#10#1082#1086#1076#1086#1074#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072' 866 ('#1082#1080#1088#1080#1083#1083#1080#1094#1072').'#13#10#1052#1086#1078#1085#1086' '#1086#1090#1082#1088#1099#1090#1100' '#1074' '#1087#1086#1084#1086 +
          #1097#1100#1102' MS Excel,'#13#10'OpenOffice Calc, 1C '#1080' '#1084#1085#1086#1075#1080#1093' '#1076#1088#1091#1075#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084'.'
        Caption = '866'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        TabStop = True
        OnClick = rbPage866Click
      end
      object rbPage1251: TRadioButton
        Left = 123
        Top = 144
        Width = 49
        Height = 17
        Hint = 
          #1044#1072#1085#1085#1072#1103' '#1082#1086#1076#1086#1074#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072' '#1085#1077' '#1103#1074#1083#1103#1077#1090#1089#1103#13#10#1089#1090#1072#1085#1076#1072#1088#1090#1085#1086#1081' '#1076#1083#1103' DBF. MS Exc' +
          'el '#1085#1077' '#1089#1084#1086#1078#1077#1090#13#10#1087#1088#1072#1074#1080#1083#1100#1085#1086' '#1086#1090#1086#1073#1088#1072#1079#1080#1090#1100' '#1082#1086#1076#1080#1088#1086#1074#1082#1091' '#1090#1072#1082#1086#1075#1086#13#10'DBF '#1092#1072#1081#1083#1072'.'
        Caption = '1251'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = rbPage866Click
      end
    end
    object Panel6: TPanel
      Left = 1
      Top = 166
      Width = 199
      Height = 199
      Align = alClient
      TabOrder = 1
      object lbDBFList: TListBox
        Left = 1
        Top = 1
        Width = 197
        Height = 134
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnClick = lbDBFListClick
      end
      object Panel7: TPanel
        Left = 1
        Top = 135
        Width = 197
        Height = 63
        Align = alBottom
        TabOrder = 1
        object GroupBox1: TGroupBox
          Left = 8
          Top = 2
          Width = 177
          Height = 57
          Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1092#1072#1081#1083#1077' DBF'
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 14
            Width = 42
            Height = 13
            Caption = #1056#1072#1079#1084#1077#1088':'
          end
          object labDBFSize: TLabel
            Left = 56
            Top = 14
            Width = 18
            Height = 13
            Caption = '000'
          end
          object Label3: TLabel
            Left = 8
            Top = 26
            Width = 40
            Height = 13
            Caption = #1057#1086#1079#1076#1072#1085':'
          end
          object labDBFDate: TLabel
            Left = 56
            Top = 26
            Width = 18
            Height = 13
            Caption = '000'
          end
          object Label5: TLabel
            Left = 7
            Top = 39
            Width = 46
            Height = 13
            Caption = #1047#1072#1087#1080#1089#1077#1081':'
          end
          object labDBFRecCount: TLabel
            Left = 56
            Top = 39
            Width = 18
            Height = 13
            Caption = '000'
          end
        end
      end
    end
  end
  object Panel4: TPanel
    Left = 201
    Top = 61
    Width = 753
    Height = 366
    Align = alClient
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 751
      Height = 364
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object DataSource1: TDataSource
    Left = 217
    Top = 97
  end
  object timFind: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = timFindTimer
    Left = 297
    Top = 101
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.DBF'
    Filter = 'DBF|*.DBF|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 337
    Top = 101
  end
  object JvFormStorage1: TJvFormStorage
    AppStorage = JvAppRegistryStorage1
    AppStoragePath = '%FORM_NAME%'
    StoredProps.Strings = (
      'deDBFDir.Text'
      'gbSortDirection.ItemIndex'
      'gbSortType.ItemIndex'
      'rbPage1251.Checked'
      'rbPage866.Checked'
      'rbSortASC.Checked'
      'rbSortDESC.Checked'
      'edFilter.Text'
      'cbSortFields.Text'
      'cbFindFields.Text'
      'edFindValue.Text'
      'cbFilterCaseInsensitive.Checked'
      'cbFilterPartialKey.Checked')
    StoredValues = <>
    Left = 120
    Top = 120
  end
  object JvAppRegistryStorage1: TJvAppRegistryStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    Root = 'Software\LoginovProjects\DBFViewer'
    SubStorages = <>
    Left = 120
    Top = 160
  end
end
