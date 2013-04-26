object MainForm: TMainForm
  Left = 57
  Top = 101
  Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1076#1083#1103' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1092#1091#1085#1082#1094#1080#1081' '#1089#1080#1089#1090#1077#1084#1099' Matrix32'
  ClientHeight = 543
  ClientWidth = 894
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 250
    Top = 0
    Height = 543
    Color = clAqua
    ParentColor = False
    ExplicitLeft = 435
    ExplicitHeight = 446
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 250
    Height = 543
    Align = alLeft
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 1
      Top = 209
      Width = 248
      Height = 3
      Cursor = crVSplit
      Align = alTop
      Color = clAqua
      ParentColor = False
      ExplicitWidth = 300
    end
    object Panel5: TPanel
      Left = 1
      Top = 212
      Width = 248
      Height = 330
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinHeight = 100
      TabOrder = 0
      object Panel9: TPanel
        Left = 0
        Top = 0
        Width = 248
        Height = 16
        Align = alTop
        BevelOuter = bvLowered
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080
        TabOrder = 0
      end
      object twCateg: TTreeView
        Left = 0
        Top = 16
        Width = 248
        Height = 314
        Align = alClient
        HideSelection = False
        Indent = 19
        TabOrder = 1
        OnChange = twCategChange
      end
    end
    object panMatrixTree: TPanel
      Left = 1
      Top = 1
      Width = 248
      Height = 208
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinHeight = 200
      TabOrder = 1
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 248
        Height = 24
        Align = alTop
        TabOrder = 0
        object ToolBar1: TToolBar
          Left = 1
          Top = 1
          Width = 246
          Height = 29
          Caption = 'ToolBar1'
          Images = ImageList1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TabStop = True
          object ToolButton1: TToolButton
            Left = 0
            Top = 0
            Action = acAddMatrix
          end
          object ToolButton2: TToolButton
            Left = 23
            Top = 0
            Action = acDeleteMatrix
          end
          object ToolButton3: TToolButton
            Left = 46
            Top = 0
            Action = acTreeRefresh
          end
          object ToolButton4: TToolButton
            Left = 69
            Top = 0
            Width = 8
            Caption = 'ToolButton4'
            ImageIndex = 3
            Style = tbsSeparator
          end
          object ToolButton5: TToolButton
            Left = 77
            Top = 0
            Action = acLoadFromFile
          end
          object ToolButton6: TToolButton
            Left = 100
            Top = 0
            Action = acSaveToFile
          end
        end
      end
      object twMatrix: TTreeView
        Left = 0
        Top = 24
        Width = 248
        Height = 131
        Align = alClient
        DragMode = dmAutomatic
        HideSelection = False
        Images = ILMatrixTree
        Indent = 19
        TabOrder = 1
        OnChange = twMatrixChange
        OnClick = twMatrixClick
        OnDragOver = twMatrixDragOver
        OnEdited = twMatrixEdited
        OnEditing = twMatrixEditing
        OnEndDrag = twMatrixEndDrag
        OnKeyDown = twMatrixKeyDown
      end
      object Panel6: TPanel
        Left = 0
        Top = 155
        Width = 248
        Height = 53
        Align = alBottom
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        DesignSize = (
          248
          53)
        object labDelFromM1: TLabel
          Left = 232
          Top = 0
          Width = 12
          Height = 13
          Cursor = crHandPoint
          Hint = #1048#1079#1074#1083#1077#1095#1100' '#1086#1073#1098#1077#1082#1090' '#1080#1079' '#1087#1072#1084#1103#1090#1080' '#1052'1'
          Anchors = [akTop, akRight]
          Caption = ' X '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = labDelFromM1Click
        end
        object labDelFromM2: TLabel
          Left = 232
          Top = 19
          Width = 12
          Height = 13
          Cursor = crHandPoint
          Hint = #1048#1079#1074#1083#1077#1095#1100' '#1086#1073#1098#1077#1082#1090' '#1080#1079' '#1087#1072#1084#1103#1090#1080' '#1052'2'
          Anchors = [akTop, akRight]
          Caption = ' X '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = labDelFromM2Click
        end
        object SpeedButton1: TSpeedButton
          Left = 173
          Top = 0
          Width = 59
          Height = 17
          Hint = #1047#1072#1087#1086#1084#1080#1085#1072#1077#1090' '#1086#1073#1098#1077#1082#1090' '#1074' '#1087#1072#1084#1103#1090#1080' '#1052'1'
          Anchors = [akTop, akRight]
          Caption = #1074' '#1087#1072#1084#1103#1090#1100
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton1Click
        end
        object SpeedButton2: TSpeedButton
          Left = 173
          Top = 18
          Width = 59
          Height = 17
          Hint = #1047#1072#1087#1086#1084#1080#1085#1072#1077#1090' '#1086#1073#1098#1077#1082#1090' '#1074' '#1087#1072#1084#1103#1090#1080' '#1052'2'
          Anchors = [akTop, akRight]
          Caption = #1074' '#1087#1072#1084#1103#1090#1100
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton2Click
        end
        object SpeedButton3: TSpeedButton
          Left = 173
          Top = 35
          Width = 59
          Height = 17
          Hint = #1047#1072#1087#1086#1084#1080#1085#1072#1077#1090' '#1086#1073#1098#1077#1082#1090' '#1074' '#1087#1072#1084#1103#1090#1080' '#1052'3'
          Anchors = [akTop, akRight]
          Caption = #1074' '#1087#1072#1084#1103#1090#1100
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton3Click
        end
        object labDelFromM3: TLabel
          Left = 232
          Top = 36
          Width = 12
          Height = 13
          Cursor = crHandPoint
          Hint = #1048#1079#1074#1083#1077#1095#1100' '#1086#1073#1098#1077#1082#1090' '#1080#1079' '#1087#1072#1084#1103#1090#1080' '#1052'3'
          Anchors = [akTop, akRight]
          Caption = ' X '
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = labDelFromM3Click
        end
        object Panel21: TPanel
          Left = 1
          Top = -1
          Width = 163
          Height = 51
          Anchors = [akLeft, akTop, akRight]
          BevelOuter = bvNone
          TabOrder = 0
          object labM1: TLabel
            Left = 22
            Top = 2
            Width = 18
            Height = 13
            Caption = '???'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object labM2: TLabel
            Left = 22
            Top = 20
            Width = 18
            Height = 13
            Caption = '???'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label9: TLabel
            Left = 1
            Top = 20
            Width = 18
            Height = 13
            Caption = 'M2:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object Label10: TLabel
            Left = 1
            Top = 2
            Width = 18
            Height = 13
            Caption = 'M1:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object Label8: TLabel
            Left = 1
            Top = 38
            Width = 18
            Height = 13
            Caption = 'M3:'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object labM3: TLabel
            Left = 22
            Top = 38
            Width = 18
            Height = 13
            Caption = '???'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 253
    Top = 0
    Width = 641
    Height = 543
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 546
    object Splitter2: TSplitter
      Left = 1
      Top = 186
      Width = 639
      Height = 3
      Cursor = crVSplit
      Align = alTop
      Color = clAqua
      ParentColor = False
      ExplicitLeft = 3
      ExplicitTop = 218
      ExplicitWidth = 636
    end
    object PageControl1: TPageControl
      Left = 1
      Top = 189
      Width = 639
      Height = 353
      ActivePage = TabSheet1
      Align = alClient
      Constraints.MinHeight = 100
      Constraints.MinWidth = 100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 544
      object TabSheet1: TTabSheet
        Tag = 1
        Caption = #1052#1072#1089#1089#1080#1074
        ExplicitWidth = 536
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 631
          Height = 322
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 536
          object panCategTitle: TPanel
            Left = 1
            Top = 1
            Width = 629
            Height = 24
            Align = alTop
            BevelInner = bvRaised
            BevelOuter = bvLowered
            Caption = 'panCategTitle'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            ExplicitWidth = 534
          end
          object Panel22: TPanel
            Left = 1
            Top = 25
            Width = 629
            Height = 296
            Align = alClient
            TabOrder = 1
            ExplicitTop = 31
            ExplicitWidth = 534
            object Label15: TLabel
              Left = 453
              Top = 240
              Width = 6
              Height = 16
              Caption = 'x'
            end
            object GroupBox3: TGroupBox
              Left = 0
              Top = 6
              Width = 369
              Height = 64
              Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1084#1072#1089#1089#1080#1074#1072' M1'
              TabOrder = 0
              object Label7: TLabel
                Left = 8
                Top = 24
                Width = 58
                Height = 16
                Caption = #1053#1072#1095#1072#1090#1100' '#1089
              end
              object Button2: TButton
                Left = 243
                Top = 21
                Width = 115
                Height = 25
                Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1052'1'
                TabOrder = 0
                OnClick = Button2Click
              end
              object seFillStart: TSpinEdit
                Left = 72
                Top = 23
                Width = 49
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
              object seFillStep: TSpinEdit
                Left = 189
                Top = 23
                Width = 48
                Height = 22
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                MaxValue = 0
                MinValue = 0
                ParentFont = False
                TabOrder = 2
                Value = 1
              end
              object rbStep: TRadioButton
                Left = 128
                Top = 14
                Width = 56
                Height = 17
                Caption = #1064#1072#1075
                Checked = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 3
                TabStop = True
              end
              object rbFinish: TRadioButton
                Left = 128
                Top = 29
                Width = 58
                Height = 17
                Caption = #1060#1080#1085#1080#1096
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 4
              end
              object rbRandom: TRadioButton
                Left = 128
                Top = 44
                Width = 58
                Height = 17
                Caption = #1056#1072#1085#1076#1086#1084
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 5
              end
            end
            object Button4: TButton
              Left = 12
              Top = 70
              Width = 186
              Height = 25
              Caption = #1058#1088#1072#1085#1089#1087#1086#1085#1080#1088#1086#1074#1072#1090#1100' M1 -> M2'
              TabOrder = 1
              OnClick = Button4Click
            end
            object Button5: TButton
              Left = 12
              Top = 98
              Width = 186
              Height = 25
              Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' M1 -> M2'
              TabOrder = 2
              OnClick = Button5Click
            end
            object Button6: TButton
              Left = 204
              Top = 71
              Width = 186
              Height = 25
              Caption = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' M1 -> M2'
              TabOrder = 3
              OnClick = Button6Click
            end
            object Button7: TButton
              Left = 204
              Top = 98
              Width = 186
              Height = 25
              Hint = #1044#1077#1084#1086#1085#1089#1090#1088#1080#1088#1091#1077#1090' '#1086#1073#1099#1095#1085#1086#1077' ('#1085#1077' '#1073#1099#1089#1090#1088#1086#1077') '#1084#1072#1090#1088#1080#1095#1085#1086#1077' '#1091#1084#1085#1086#1078#1077#1085#1080#1077
              Caption = #1059#1084#1085#1086#1078#1077#1085#1080#1077' M3=M1*M2'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = Button7Click
            end
            object Button9: TButton
              Left = 12
              Top = 138
              Width = 237
              Height = 25
              Caption = #1042#1099#1095#1080#1089#1083#1080#1090#1100' '#1092#1091#1085#1082#1094#1080#1102' M2=F(M1)'
              TabOrder = 5
              OnClick = Button9Click
            end
            object cbFuncList: TComboBox
              Left = 251
              Top = 138
              Width = 89
              Height = 24
              Style = csDropDownList
              TabOrder = 6
            end
            object Button10: TButton
              Left = 12
              Top = 165
              Width = 237
              Height = 25
              Caption = #1042#1099#1095#1080#1089#1083#1080#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102' M3=O(M1,M2)'
              TabOrder = 7
              OnClick = Button10Click
            end
            object cbOpList: TComboBox
              Left = 251
              Top = 165
              Width = 89
              Height = 24
              Style = csDropDownList
              TabOrder = 8
            end
            object btnReshape: TButton
              Left = 12
              Top = 223
              Width = 389
              Height = 25
              Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1088#1072#1079#1084#1077#1088#1099' M1 ('#1095#1080#1089#1083#1086' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1089#1086#1093#1088#1072#1085#1103#1077#1090#1089#1103')'
              TabOrder = 9
              OnClick = btnReshapeClick
            end
            object seMatrixRows: TSpinEdit
              Left = 402
              Top = 238
              Width = 48
              Height = 22
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              MaxValue = 2000000000
              MinValue = 0
              ParentFont = False
              TabOrder = 10
              Value = 1
            end
            object seMatrixCols: TSpinEdit
              Left = 465
              Top = 238
              Width = 48
              Height = 22
              Hint = #1045#1089#1083#1080' = 0, '#1090#1086' '#1087#1086#1083#1091#1095#1080#1090#1089#1103' '#1086#1076#1085#1086#1084#1077#1088#1085#1099#1081' '#1074#1077#1082#1090#1086#1088
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              MaxValue = 2000000000
              MinValue = 0
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 11
              Value = 1
            end
            object btnPresaveResize: TButton
              Left = 12
              Top = 249
              Width = 389
              Height = 25
              Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1088#1072#1079#1084#1077#1088#1099' M1 ('#1074#1086#1079#1084#1086#1078#1085#1072' '#1087#1086#1090#1077#1088#1103' '#1101#1083#1077#1084#1077#1085#1090#1086#1074')'
              TabOrder = 12
              OnClick = btnPresaveResizeClick
            end
          end
        end
      end
      object TabSheet6: TTabSheet
        Tag = 2
        Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
        ImageIndex = 5
        ExplicitWidth = 536
        object Panel25: TPanel
          Left = 0
          Top = 0
          Width = 631
          Height = 193
          Align = alTop
          TabOrder = 0
          ExplicitLeft = 1
          ExplicitWidth = 536
          object GroupBox4: TGroupBox
            Left = 1
            Top = 4
            Width = 416
            Height = 50
            Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1084#1080#1084#1080#1085#1091#1084' '#1080' '#1084#1072#1082#1089#1080#1084#1091#1084' '#1084#1072#1089#1089#1080#1074#1072' M1'
            TabOrder = 0
            object Label16: TLabel
              Left = 121
              Top = 16
              Width = 64
              Height = 16
              Caption = #1052#1080#1085#1080#1084#1091#1084':'
            end
            object labMinElem: TLabel
              Left = 188
              Top = 16
              Width = 7
              Height = 16
              Caption = '0'
            end
            object Label18: TLabel
              Left = 115
              Top = 30
              Width = 70
              Height = 16
              Caption = #1052#1072#1082#1089#1080#1084#1091#1084':'
            end
            object labMaxElem: TLabel
              Left = 188
              Top = 30
              Width = 7
              Height = 16
              Caption = '0'
            end
            object labMinIndex1: TLabel
              Left = 279
              Top = 16
              Width = 51
              Height = 16
              Caption = #1048#1085#1076#1077#1082#1089':'
            end
            object labMinIndex: TLabel
              Left = 331
              Top = 16
              Width = 7
              Height = 16
              Caption = '0'
            end
            object Label22: TLabel
              Left = 279
              Top = 30
              Width = 51
              Height = 16
              Caption = #1048#1085#1076#1077#1082#1089':'
            end
            object labMaxIndex: TLabel
              Left = 331
              Top = 30
              Width = 7
              Height = 16
              Caption = '0'
            end
            object Button17: TButton
              Left = 6
              Top = 19
              Width = 92
              Height = 25
              Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
              TabOrder = 0
              OnClick = Button17Click
            end
          end
          object GroupBox5: TGroupBox
            Left = 1
            Top = 60
            Width = 416
            Height = 69
            Caption = #1055#1086#1083#1091#1095#1077#1085#1080#1077' '#1089#1090#1072#1090#1080#1089#1090#1080#1095#1077#1089#1082#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1086' '#1084#1072#1089#1089#1080#1074#1077' M1 (-> M2)'
            TabOrder = 1
            object Label17: TLabel
              Left = 8
              Top = 16
              Width = 156
              Height = 16
              Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1102':'
            end
            object Button18: TButton
              Left = 318
              Top = 32
              Width = 89
              Height = 25
              Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
              TabOrder = 0
              OnClick = Button18Click
            end
            object cbStatInfoType: TComboBox
              Left = 16
              Top = 38
              Width = 200
              Height = 21
              Style = csDropDownList
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemIndex = 0
              ParentFont = False
              TabOrder = 1
              Text = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
              Items.Strings = (
                #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
                #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
                #1052#1080#1085#1080#1084#1072#1083#1100#1085#1099#1077', '#1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1077
                #1057#1088#1077#1076#1085#1077#1077' '#1072#1088#1080#1092#1084#1077#1090#1080#1095#1077#1089#1082#1086#1077
                #1048#1085#1076#1077#1082#1089#1099' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1093
                #1048#1085#1076#1077#1082#1089#1099' '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1093)
            end
            object rgStatDim: TRadioGroup
              Left = 222
              Top = 22
              Width = 90
              Height = 43
              Caption = 'M2 '#1073#1091#1076#1077#1090
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                #1057#1090#1088#1086#1082#1086#1081
                #1057#1090#1086#1083#1073#1094#1086#1084)
              ParentFont = False
              TabOrder = 2
            end
          end
        end
      end
      object TabSheet3: TTabSheet
        Tag = 3
        Caption = #1044#1080#1072#1075#1088#1072#1084#1084#1072
        ImageIndex = 2
        ExplicitWidth = 536
        object Panel8: TPanel
          Left = 0
          Top = 0
          Width = 631
          Height = 37
          Align = alTop
          TabOrder = 0
          ExplicitWidth = 536
          object seChartRowNum: TSpinEdit
            Left = 174
            Top = 6
            Width = 56
            Height = 26
            MaxValue = 2147483647
            MinValue = 1
            TabOrder = 0
            Value = 1
            OnChange = seChartRowNumChange
            OnKeyDown = seChartRowNumKeyDown
          end
          object btnDiag: TButton
            Left = 236
            Top = 6
            Width = 113
            Height = 25
            Caption = #1055#1086#1089#1090#1088#1086#1080#1090#1100
            TabOrder = 1
            OnClick = btnDiagClick
          end
          object rbChartFromRow: TRadioButton
            Left = 1
            Top = 2
            Width = 152
            Height = 17
            Caption = #1047#1085#1072#1095#1077#1085#1080#1103' '#1080#1079' '#1089#1090#1088#1086#1082#1080
            Checked = True
            TabOrder = 2
            TabStop = True
          end
          object rbChartFromCol: TRadioButton
            Left = 1
            Top = 18
            Width = 163
            Height = 17
            Caption = #1047#1085#1072#1095#1077#1085#1080#1103' '#1080#1079' '#1089#1090#1086#1083#1073#1094#1072
            TabOrder = 3
          end
        end
        object Chart1: TChart
          Left = 0
          Top = 37
          Width = 631
          Height = 285
          Legend.Visible = False
          Title.Text.Strings = (
            'TChart')
          View3D = False
          Align = alClient
          TabOrder = 1
          ExplicitWidth = 536
          object Series1: TLineSeries
            Marks.Arrow.Visible = True
            Marks.Callout.Brush.Color = clBlack
            Marks.Callout.Arrow.Visible = True
            Marks.Visible = False
            Pointer.InflateMargins = True
            Pointer.Style = psRectangle
            Pointer.Visible = False
            XValues.Name = 'X'
            XValues.Order = loAscending
            YValues.Name = 'Y'
            YValues.Order = loNone
          end
        end
      end
      object TabSheet4: TTabSheet
        Tag = 4
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
        ImageIndex = 3
        ExplicitWidth = 536
        object Label3: TLabel
          Left = 32
          Top = 49
          Width = 194
          Height = 13
          Caption = #1059#1082#1072#1078#1080#1090#1077' '#1080#1084#1103' '#1092#1072#1081#1083#1072' '#1088#1072#1073#1086#1095#1077#1081' '#1086#1073#1083#1072#1089#1090#1080':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object cbAutoSaveWorkspace: TCheckBox
          Left = 8
          Top = 32
          Width = 514
          Height = 17
          Caption = 
            #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1089#1086#1093#1088#1072#1085#1103#1090#1100' '#1080' '#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1088#1072#1073#1086#1095#1091#1102' '#1086#1073#1083#1072#1089#1090#1080' '#1087#1088#1080' '#1087#1077#1088#1077#1079#1072#1087#1091 +
            #1089#1082#1077
          TabOrder = 0
        end
        object Panel10: TPanel
          Left = 0
          Top = 288
          Width = 631
          Height = 34
          Align = alBottom
          TabOrder = 1
          ExplicitWidth = 536
          DesignSize = (
            631
            34)
          object btnSaveParams: TButton
            Left = 428
            Top = 5
            Width = 193
            Height = 25
            Anchors = [akTop, akRight]
            Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
            Default = True
            TabOrder = 0
            OnClick = btnSaveParamsClick
            ExplicitLeft = 333
          end
        end
        object edWorkspaceFileName: TEdit
          Left = 24
          Top = 65
          Width = 457
          Height = 24
          TabOrder = 2
          Text = 'edWorkspaceFileName'
        end
        object Button3: TButton
          Left = 483
          Top = 65
          Width = 33
          Height = 25
          Caption = '...'
          TabOrder = 3
          OnClick = Button3Click
        end
      end
      object TabSheet5: TTabSheet
        Tag = 5
        Caption = #1056#1072#1073#1086#1090#1072' '#1089' Matlab'
        ImageIndex = 4
        ExplicitWidth = 536
        object Panel13: TPanel
          Left = 0
          Top = 0
          Width = 631
          Height = 126
          Align = alTop
          TabOrder = 0
          ExplicitLeft = 1
          ExplicitTop = -6
          ExplicitWidth = 536
          object GroupBox1: TGroupBox
            Left = 1
            Top = 0
            Width = 454
            Height = 54
            Caption = #1055#1077#1088#1077#1076#1072#1095#1072' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072' '#1074' Matlab'
            TabOrder = 0
            object btnPutToMatlab: TButton
              Left = 369
              Top = 24
              Width = 78
              Height = 25
              Caption = #1055#1077#1088#1077#1076#1072#1090#1100
              TabOrder = 0
              OnClick = btnPutToMatlabClick
            end
            object rgToMatlabNameType: TRadioGroup
              Left = 8
              Top = 19
              Width = 183
              Height = 31
              Caption = #1054#1073#1098#1077#1082#1090' '#1073#1091#1076#1077#1090' '#1080#1084#1077#1090#1100' '#1080#1084#1103
              Columns = 2
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemIndex = 0
              Items.Strings = (
                #1050#1072#1082' '#1080' '#1090#1091#1090
                #1044#1088#1091#1075#1086#1077)
              ParentFont = False
              TabOrder = 1
              OnClick = rgToMatlabNameTypeClick
            end
            object edToMatlabMatrixName: TEdit
              Left = 195
              Top = 25
              Width = 172
              Height = 24
              Color = clInactiveCaption
              Enabled = False
              TabOrder = 2
            end
          end
          object GroupBox2: TGroupBox
            Left = 1
            Top = 57
            Width = 454
            Height = 65
            Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1086#1073#1098#1077#1082#1090#1072' '#1080#1079' Matlab'
            TabOrder = 1
            object Label6: TLabel
              Left = 8
              Top = 17
              Width = 146
              Height = 13
              Caption = #1048#1084#1103' '#1079#1072#1075#1088#1091#1078#1072#1077#1084#1086#1075#1086' '#1086#1073#1098#1077#1082#1090#1072':'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object edMatlabObjectName: TEdit
              Left = 5
              Top = 31
              Width = 186
              Height = 24
              TabOrder = 0
            end
            object Button8: TButton
              Left = 370
              Top = 30
              Width = 77
              Height = 25
              Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
              TabOrder = 1
              OnClick = Button8Click
            end
            object cbOtherMatrixObjectName: TCheckBox
              Left = 197
              Top = 13
              Width = 121
              Height = 17
              Caption = #1053#1086#1074#1086#1077' '#1080#1084#1103' '#1086#1073#1098#1077#1082#1090#1072':'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              OnClick = cbOtherMatrixObjectNameClick
            end
            object edOtherMatrixObjectName: TEdit
              Left = 195
              Top = 31
              Width = 172
              Height = 24
              Color = clInactiveCaption
              Enabled = False
              TabOrder = 3
            end
          end
        end
        object Panel14: TPanel
          Left = 0
          Top = 126
          Width = 631
          Height = 196
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitWidth = 536
          object Splitter4: TSplitter
            Left = 0
            Top = 102
            Width = 631
            Height = 3
            Cursor = crVSplit
            Align = alTop
            Color = clAqua
            ParentColor = False
            ExplicitLeft = 1
            ExplicitTop = 73
            ExplicitWidth = 88
          end
          object Panel15: TPanel
            Left = 0
            Top = 0
            Width = 631
            Height = 17
            Align = alTop
            Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077' '#1089#1082#1088#1080#1087#1090#1086#1074' '#1074' Matlab'
            TabOrder = 0
            ExplicitWidth = 536
          end
          object Panel16: TPanel
            Left = 0
            Top = 17
            Width = 631
            Height = 85
            Align = alTop
            TabOrder = 1
            ExplicitWidth = 536
            object Panel18: TPanel
              Left = 1
              Top = 1
              Width = 629
              Height = 19
              Align = alTop
              Alignment = taLeftJustify
              BevelOuter = bvNone
              Caption = #1048#1089#1090#1086#1088#1080#1103' '#1082#1086#1084#1072#1085#1076
              TabOrder = 0
              ExplicitWidth = 534
              DesignSize = (
                629
                19)
              object Button1: TButton
                Left = 550
                Top = 0
                Width = 75
                Height = 18
                Anchors = [akTop, akRight]
                Caption = #1054#1095#1080#1089#1090#1080#1090#1100
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                OnClick = Button1Click
                ExplicitLeft = 455
              end
            end
            object memoMatlabCommandHistory: TMemo
              Left = 1
              Top = 20
              Width = 629
              Height = 64
              Align = alClient
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = []
              ParentFont = False
              ScrollBars = ssBoth
              TabOrder = 1
              ExplicitWidth = 534
            end
          end
          object Panel17: TPanel
            Left = 0
            Top = 105
            Width = 631
            Height = 91
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 2
            ExplicitWidth = 536
            object Panel19: TPanel
              Left = 0
              Top = 63
              Width = 631
              Height = 28
              Align = alBottom
              Alignment = taLeftJustify
              BevelInner = bvLowered
              Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1084#1072#1085#1076#1091' '#1076#1083#1103' Matlab'
              TabOrder = 0
              ExplicitWidth = 536
              DesignSize = (
                631
                28)
              object btnExecuteMatlabCommand: TButton
                Left = 535
                Top = 3
                Width = 89
                Height = 23
                Anchors = [akTop, akRight]
                Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
                TabOrder = 0
                OnClick = btnExecuteMatlabCommandClick
                ExplicitLeft = 440
              end
              object cbAutoClearMatlabCommand: TCheckBox
                Left = 445
                Top = 7
                Width = 87
                Height = 17
                Anchors = [akTop, akRight]
                Caption = #1040#1074#1090#1086#1086#1095#1080#1089#1090#1082#1072
                Checked = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                State = cbChecked
                TabOrder = 1
                ExplicitLeft = 350
              end
            end
            object memoMatlabCommand: TMemo
              Left = 0
              Top = 0
              Width = 631
              Height = 63
              Align = alClient
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = []
              ParentFont = False
              ScrollBars = ssBoth
              TabOrder = 1
              OnKeyDown = memoMatlabCommandKeyDown
              ExplicitWidth = 536
            end
          end
        end
      end
      object TabSheet2: TTabSheet
        Tag = 6
        Caption = 'Blas, Lapack'
        ImageIndex = 4
        ExplicitWidth = 536
        object Panel23: TPanel
          Left = 0
          Top = 0
          Width = 631
          Height = 58
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ExplicitWidth = 536
          object Label11: TLabel
            Left = 1
            Top = 4
            Width = 468
            Height = 13
            Caption = 
              #1044#1072#1085#1085#1099#1077' '#1092#1091#1085#1082#1094#1080#1080' '#1086#1073#1077#1089#1087#1077#1095#1080#1074#1072#1102#1090' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1099#1077' '#1086#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1084#1072#1090#1088#1080#1094#1072#1084#1080' '#1089' '#1087 +
              #1086#1084#1086#1097#1100#1102' '#1073#1080#1073#1083#1080#1086#1090#1077#1082
          end
          object Label12: TLabel
            Left = 1
            Top = 16
            Width = 435
            Height = 13
            Caption = 
              'Blas '#1080' Lapack. '#1069#1090#1086' '#1074#1099#1089#1086#1082#1086#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100#1085#1099#1077' '#1073#1080#1073#1083#1080#1086#1090#1077#1082#1080', '#1074#1093#1086#1076#1103#1097#1080#1077' '#1074 +
              ' '#1089#1086#1089#1090#1072#1074' '#1083#1102#1073#1086#1075#1086
          end
          object Label13: TLabel
            Left = 1
            Top = 29
            Width = 461
            Height = 13
            Caption = 
              #1084#1072#1090#1077#1084#1072#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1072#1082#1077#1090#1072' (Matlab, Scilab '#1080' '#1076#1088'.). '#1042' '#1082#1072#1090#1072#1083#1086#1075#1077' '#1089' '#1076#1072#1085#1085 +
              #1099#1084' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077#1084' '#1076#1086#1083#1078#1085#1099
          end
          object Label14: TLabel
            Left = 1
            Top = 41
            Width = 284
            Height = 13
            Caption = #1085#1072#1093#1086#1076#1080#1090#1100#1089#1103' '#1092#1072#1081#1083#1099': matrixatlas.dll, matrixlapack.dll, dforrt.dll'
          end
        end
        object Panel24: TPanel
          Left = 0
          Top = 58
          Width = 631
          Height = 264
          Align = alClient
          TabOrder = 1
          ExplicitWidth = 536
          object Button11: TButton
            Left = 1
            Top = 6
            Width = 310
            Height = 25
            Caption = #1041#1067#1057#1058#1056#1054#1045' '#1059#1084#1085#1086#1078#1077#1085#1080#1077' M3=M1*M2'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnClick = Button11Click
          end
          object Button12: TButton
            Left = 1
            Top = 37
            Width = 310
            Height = 25
            Caption = 'LU-'#1088#1072#1079#1083#1086#1078#1077#1085#1080#1077' '#1084#1072#1090#1088#1080#1094#1099' M1 '#1085#1072' L=M2 '#1080' U=M2'
            TabOrder = 1
            OnClick = Button12Click
          end
          object Button13: TButton
            Left = 1
            Top = 68
            Width = 310
            Height = 25
            Caption = #1042#1099#1095#1080#1089#1083#1080#1090#1100' '#1076#1077#1090#1077#1088#1084#1080#1085#1072#1085#1090' '#1084#1072#1090#1088#1080#1094#1099' M1 -> M2'
            TabOrder = 2
            OnClick = Button13Click
          end
          object Button14: TButton
            Left = 1
            Top = 99
            Width = 310
            Height = 25
            Caption = #1056#1077#1096#1080#1090#1100' '#1057#1051#1040#1059' A * X = B (A=M1, B=M2, X=M3)'
            TabOrder = 3
            OnClick = Button14Click
          end
          object Button15: TButton
            Left = 1
            Top = 130
            Width = 310
            Height = 25
            Caption = #1042#1099#1095#1080#1089#1083#1080#1090#1100' '#1086#1073#1088#1072#1090#1085#1091#1102' '#1084#1072#1090#1088#1080#1094#1091' M1 -> M2'
            TabOrder = 4
            OnClick = Button15Click
          end
        end
      end
      object TabSheet7: TTabSheet
        Tag = 7
        Caption = #1057#1080#1075#1085#1072#1083#1099
        ImageIndex = 6
        ExplicitLeft = 5
        ExplicitTop = 23
        ExplicitWidth = 536
        object Panel26: TPanel
          Left = 0
          Top = 0
          Width = 631
          Height = 113
          Align = alTop
          TabOrder = 0
          object Button16: TButton
            Left = 4
            Top = 16
            Width = 285
            Height = 25
            Hint = 
              #1042#1099#1087#1086#1083#1085#1103#1077#1090' '#1084#1072#1089#1096#1090#1072#1073#1080#1088#1086#1074#1072#1085#1080#1077' '#1089' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077#1084' '#1073#1099#1089#1090#1088#1086#1081' 3-'#1090#1086#1095#1077#1095#1085#1086#1081' '#1080#1085 +
              #1090#1077#1088#1087#1086#1083#1103#1094#1080#1080
            Caption = #1056#1072#1089#1090#1103#1078#1077#1085#1080#1077' / '#1089#1078#1072#1090#1080#1077' '#1089#1080#1075#1085#1072#1083#1086#1074' M2=F(M1)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = Button16Click
          end
          object seScalePoints: TSpinEdit
            Left = 291
            Top = 18
            Width = 67
            Height = 22
            Hint = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1074#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxValue = 0
            MinValue = 0
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            Value = 0
          end
          object Button19: TButton
            Left = 4
            Top = 47
            Width = 285
            Height = 25
            Caption = #1053#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' ('#1096#1082#1072#1083#1080#1088#1086#1074#1072#1085#1080#1077') M2=F(M1)'
            TabOrder = 2
            OnClick = Button19Click
          end
          object seNormSignal: TSpinEdit
            Left = 291
            Top = 49
            Width = 67
            Height = 22
            Hint = #1042#1074#1077#1076#1080#1090#1077' '#1087#1086#1088#1086#1075' '#1096#1082#1072#1083#1080#1088#1086#1074#1072#1085#1080#1103
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxValue = 0
            MinValue = 0
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            Value = 1
          end
        end
      end
    end
    object panMatrixInfo: TPanel
      Left = 1
      Top = 1
      Width = 639
      Height = 185
      Align = alTop
      Constraints.MinHeight = 100
      TabOrder = 1
      ExplicitWidth = 544
      object panMatrixView: TPanel
        Left = 1
        Top = 28
        Width = 637
        Height = 156
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 542
        object Panel11: TPanel
          Left = 1
          Top = 1
          Width = 635
          Height = 25
          Align = alTop
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ExplicitWidth = 540
          object Panel20: TPanel
            Left = 0
            Top = 0
            Width = 372
            Height = 25
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            object Label2: TLabel
              Left = 0
              Top = 5
              Width = 45
              Height = 13
              Caption = #1060#1086#1088#1084#1072#1090':'
            end
            object sbEditFormat: TSpeedButton
              Left = 202
              Top = 1
              Width = 26
              Height = 23
              Hint = #1053#1072#1089#1090#1088#1086#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1092#1086#1088#1084#1072#1090#1086#1074
              Caption = '...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              OnClick = sbEditFormatClick
            end
            object Label5: TLabel
              Left = 237
              Top = 5
              Width = 74
              Height = 13
              Caption = #1064#1080#1088#1080#1085#1072' '#1103#1095#1077#1077#1082':'
            end
            object cbFormat: TComboBox
              Left = 48
              Top = 2
              Width = 153
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 0
              Text = '%g ('#1054#1073#1099#1095#1085#1099#1081')'
              OnSelect = cbFormatSelect
              Items.Strings = (
                '%g ('#1054#1073#1099#1095#1085#1099#1081')'
                '%f ('#1044#1088#1086#1073#1085#1099#1081')'
                '%n ('#1063#1080#1089#1083#1086#1074#1086#1081')'
                '%.10f ('#1058#1086#1095#1085#1099#1081')'
                '%e ('#1053#1072#1091#1095#1085#1099#1081')')
            end
            object seColWidth: TSpinEdit
              Left = 316
              Top = 2
              Width = 48
              Height = 22
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              MaxValue = 500
              MinValue = 9
              ParentFont = False
              TabOrder = 1
              Value = 50
              OnChange = seColWidthChange
            end
          end
          object ToolBar2: TToolBar
            Left = 503
            Top = 0
            Width = 132
            Height = 25
            Align = alRight
            Caption = 'ToolBar2'
            Images = ImageList1
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            ExplicitLeft = 408
            object ToolButton7: TToolButton
              Left = 0
              Top = 0
              Action = acAddRow
            end
            object ToolButton8: TToolButton
              Left = 23
              Top = 0
              Action = acAddCol
            end
            object ToolButton9: TToolButton
              Left = 46
              Top = 0
              Width = 8
              Caption = 'ToolButton9'
              ImageIndex = 6
              Style = tbsSeparator
            end
            object ToolButton10: TToolButton
              Left = 54
              Top = 0
              Action = acDelRow
            end
            object ToolButton11: TToolButton
              Left = 77
              Top = 0
              Action = acDelCol
            end
            object ToolButton12: TToolButton
              Left = 100
              Top = 0
              Width = 8
              Caption = 'ToolButton12'
              ImageIndex = 8
              Style = tbsSeparator
            end
            object ToolButton13: TToolButton
              Left = 108
              Top = 0
              Action = acClearMatrix
            end
          end
        end
        object Panel12: TPanel
          Left = 1
          Top = 26
          Width = 635
          Height = 129
          Align = alClient
          TabOrder = 1
          ExplicitWidth = 540
          object dgElems: TDrawGrid
            Left = 1
            Top = 1
            Width = 633
            Height = 127
            Align = alClient
            DefaultColWidth = 20
            DefaultRowHeight = 16
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goThumbTracking, goFixedColClick, goFixedRowClick]
            ParentFont = False
            TabOrder = 1
            OnDrawCell = dgElemsDrawCell
            OnGetEditText = dgElemsGetEditText
            ExplicitWidth = 538
          end
          object edCellEditor: TEdit
            Left = 176
            Top = 48
            Width = 105
            Height = 24
            BorderStyle = bsNone
            Ctl3D = True
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 0
            Text = 'edCellEditor'
            Visible = False
            OnExit = edCellEditorExit
          end
        end
      end
      object Panel7: TPanel
        Left = 1
        Top = 1
        Width = 637
        Height = 27
        Align = alTop
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        ExplicitWidth = 542
        object Label1: TLabel
          Left = 5
          Top = 12
          Width = 69
          Height = 13
          Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103':'
        end
        object lbMatrixInfo: TLabel
          Left = 77
          Top = 12
          Width = 22
          Height = 13
          Caption = 'info'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 5
          Top = 0
          Width = 122
          Height = 13
          Caption = #1042#1089#1077#1075#1086' '#1086#1073#1098#1077#1082#1090#1086#1074' TMatrix:'
        end
        object labObjCount: TLabel
          Left = 128
          Top = 0
          Width = 70
          Height = 13
          Caption = 'labObjCount'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
  end
  object ILMatrixTree: TImageList
    Left = 18
    Top = 24
    Bitmap = {
      494C010105000900D40010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000DB
      FF0000003A00000000000090660000663A0000FFFF000090DB00003A3A000000
      00000000000000B6660000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000090
      DB0000903A0000FFFF000066B600003A000000FFDB0000B6FF0000903A0000FF
      FF0000FFFF000000660000DB9000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000B6
      FF0000903A0000FFFF0000FFFF00003A900000FFB60000DBFF0000663A0000FF
      FF0000FFFF000090DB0000903A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000DB
      FF0000003A0000FFB60000FFFF000066B60000B6660000FFFF000000660000B6
      660000FFFF0000B6FF0000660000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000B6FF000000000000000000003A3A0000903A0000FFFF00003A90000066
      6600000000000000000000DB9000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000090DB0000DB
      900000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000B6FF000090
      3A0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005A525200000000000000
      000000000000000000000000000000000000000000008CC6C6008CC6C60000FF
      FF008CC6C6008CC6C6008CC6C6008CC6C6008CC6C6008CC6C6008CC6C6008CC6
      C60000FFFF008CC6C6008CC6C600000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E700FFE7E700FFE7E700FFE7E700FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E700FFE7E700000000000000000000000000000000000000
      00000000000000000000000000000000000084949C00005AA500636363000000
      000000000000000000000000000000000000000000008CC6C60000FFFF000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF008CC6C600000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E700FFE7E70000ADAD0000ADAD0000ADAD0000ADAD0000AD
      AD0000ADAD00FFE7E700FFE7E700000000000000000000000000000000000000
      00000000000000000000000000000000000000080800005AA5004AADD6001010
      1000000000000000000000000000000000000000000000FFFF000000000000FF
      FF005A5A5A005A5A5A005A5A5A0000FFFF0000FFFF005A5A5A005A5A5A005A5A
      5A0000FFFF000000000000FFFF00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E70000ADAD00000000000000000000000000000000000000
      00000000000000ADAD00FFE7E7000000000000000000FFFFFF00ADADAD00ADAD
      AD00ADADAD009C9C9C0031313100101010000008080000318400003184004AAD
      D600636363000008080000080800000000000000000000FFFF000000000000FF
      FF005A5A5A00FFFFFF005A5A5A0000FFFF0000FFFF005A5A5A00FFFFFF005A5A
      5A0000FFFF000000000000FFFF00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E70000ADAD000000000000ADAD0000ADAD0000ADAD0000AD
      AD0000ADAD00FFE7E700FFE7E700000000000000000000000000000000000000
      000000000000101010007B7B7B0063636300393929000008080000080800005A
      A5004AADD6000031840000080800000000000000000000FFFF000000000000FF
      FF005A5A5A00FFFFFF005A5A5A0000FFFF0000FFFF005A5A5A00FFFFFF005A5A
      5A0000FFFF000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E70000ADAD000000000000ADAD0000ADAD0000ADAD0000AD
      AD0000ADAD00FFE7E700FFE7E70000000000000000007B7B7B007B7B7B000000
      00007B7B7B005A5242007B7B7B007B7B7B005A5242000008080000080800005A
      A5004AADD6000031840063636300000000000000000000FFFF000000000000FF
      FF005A5A5A005A5A5A005A5A5A0000FFFF0000FFFF005A5A5A005A5A5A005A5A
      5A0000FFFF000000000000FFFF00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E70000ADAD00000000000000000000000000000000000000
      00000000000000ADAD00FFE7E7000000000000000000ADADAD00ADADAD007B7B
      7B00FFFFFF007B7B7B004A52520010101000000000000000000000080800005A
      A5004AADD600003184007B7B7B00000000000000000000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E70000AD
      AD0000ADAD0000ADAD0000ADAD000000000000ADAD0000ADAD0000ADAD0000AD
      AD0000ADAD00FFE7E700FFE7E7000000000000000000ADADAD00ADADAD007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00ADADAD00000808003939290010101000005A
      A5004AADD600000808007B7B7B00000000000000000000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E70000ADAD000000
      00000000000000000000000000000000000000ADAD0000ADAD0000ADAD0000AD
      AD0000ADAD00FFE7E700FFE7E70000000000000000007B7B7B007B7B7B000000
      00007B7B7B007B7B7B007B7B7B007B7B7B000000000039392900393929003939
      3900005AA50000080800ADA5AD00000000000000000000FFFF000000000000FF
      FF005A5A5A005A5A5A005A5A5A0000FFFF0000FFFF005A5A5A005A5A5A005A5A
      5A0000FFFF000000000000FFFF00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E70000AD
      AD0000ADAD0000ADAD0000ADAD00000000000000000000000000000000000000
      00000000000000ADAD00FFE7E7000000000000000000ADADAD00ADADAD007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00101010003939
      39000031840000000000ADADAD00000000000000000000FFFF000000000000FF
      FF005A5A5A00FFFFFF005A5A5A0000FFFF0000FFFF005A5A5A00FFFFFF005A5A
      5A0000FFFF000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E70000ADAD000000000000ADAD0000ADAD0000ADAD0000AD
      AD0000ADAD00FFE7E700FFE7E7000000000000000000ADADAD00ADADAD007B7B
      7B00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B7B00FFFFFF00ADADAD001010
      10003131310000000000ADADAD00000000000000000000FFFF000000000000FF
      FF005A5A5A00FFFFFF005A5A5A0000FFFF0000FFFF005A5A5A00FFFFFF005A5A
      5A0000FFFF000000000000FFFF00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E70000ADAD000000000000ADAD0000ADAD0000ADAD0000AD
      AD0000ADAD00FFE7E700FFE7E70000000000000000007B7B7B007B7B7B000000
      00007B7B7B007B7B7B007B7B7B007B7B7B00000000007B7B7B007B7B7B007B7B
      7B007B7B7B0000000000ADADAD00000000000000000000FFFF000000000000FF
      FF005A5A5A005A5A5A005A5A5A0000FFFF0000FFFF005A5A5A005A5A5A005A5A
      5A0000FFFF000000000000FFFF00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E70000ADAD00000000000000000000000000000000000000
      00000000000000ADAD00FFE7E7000000000000000000ADADAD00ADADAD007B7B
      7B00ADADAD00ADADAD00ADADAD00ADADAD007B7B7B00ADADAD00ADADAD00ADAD
      AD00ADADAD0000000000ADADAD0000000000000000008CC6C60000FFFF000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF008CC6C600000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E700FFE7E70000ADAD0000ADAD0000ADAD0000ADAD0000AD
      AD0000ADAD00FFE7E700FFE7E7000000000000000000ADADAD00ADADAD007B7B
      7B00ADADAD00ADADAD00ADADAD00ADADAD007B7B7B00ADADAD00ADADAD00ADAD
      AD00ADADAD0000000000FFFFFF0000000000000000008CC6C6008CC6C60000FF
      FF008CC6C6008CC6C6008CC6C6008CC6C6008CC6C6008CC6C6008CC6C6008CC6
      C60000FFFF008CC6C6008CC6C600000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E700FFE7E700FFE7E700FFE7E700FFE7E700FFE7E700FFE7
      E700FFE7E700FFE7E700FFE7E700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF000000000000FFBF000000000000
      FF1F000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.bin'
    FileName = 'BaseWorkspace.bin'
    Filter = 
      #1044#1074#1086#1080#1095#1085#1099#1081' '#1092#1086#1088#1084#1072#1090' Matrix32 (*.bin)|*.bin|'#1058#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083' (*.txt)|*.' +
      'txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083' '#1089' '#1084#1072#1089#1089#1080#1074#1072#1084#1080' Matrix32'
    Left = 120
    Top = 32
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = '*.bin'
    FileName = 'BaseWorkspace.bin'
    Filter = 
      #1042#1089#1077' '#1086#1073#1098#1077#1082#1090#1099' Matrix32 (*.bin)|*.bin|'#1058#1086#1083#1100#1082#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1086#1073#1098#1077#1082#1090' (*.bi' +
      'n)|*.bin|'#1058#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083' (*.txt)|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1080#1084#1103' '#1092#1072#1081#1083#1072' '#1076#1083#1103' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1084#1072#1089#1089#1080#1074#1086#1074
    Left = 40
    Top = 96
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 88
    Top = 80
  end
  object ImageList1: TImageList
    Left = 184
    Top = 40
    Bitmap = {
      494C010109008001040110001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004C4C4C004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004C4CA5004C4CA5004C4CA5004C4C
      A5004C4CA5004C4CA5004C4CA5004C4CA5004C4CA5004C4CA5004C4CA5000000
      0000000000004C4CA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFE4C00FEFEFE00FEFE4C00FEFE
      FE00FEFE4C00FEFEFE00FEFE4C00FEFEFE00FEFE4C00FEFEFE004C4CA5000000
      0000000000004C4CA5004C4CA500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFE4C00FEFEFE00FEFE
      4C00FEFEFE00FEFE4C00FEFEFE00FEFE4C00FEFEFE00FEFE4C004C4CA5004C4C
      A5004C4CA5004C4CA5004C4CA5004C4CA5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFE4C00FEFEFE00FEFE4C00FEFE
      FE00FEFE4C00FEFEFE00FEFE4C00FEFEFE00FEFE4C00FEFEFE004C4CA5000000
      0000000000004C4CA5004C4CA500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004C4CA5004C4CA5004C4CA5004C4C
      A5004C4CA5004C4CA5004C4CA5004C4CA5004C4CA5004C4CA5004C4CA5000000
      0000000000004C4CA50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFEFE00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004C4C4C004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C0000000000000000004C4C4C00A54C4C00A54C
      4C00A54C4C004C4C4C000000000000000000000000004C4C4C00FEFEFE00FEFE
      FE00FEFEFE004C4C4C0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C000000000000000000000000000000
      00000000000000000000000000004C4CA5000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004CA2
      A2004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C00D0D0D000D0D0
      D0004C4C4C004CA2A2004C4C4C0000000000000000004C4C4C00A54C4C00A54C
      4C00A54C4C004C4C4C000000000000000000000000004C4C4C00FEFEFE00FEFE
      FE00FEFEFE004C4C4C0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      000000000000000000004C4CA5004C4CA5004C4CA50000000000000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004CA2
      A2004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C00D0D0D000D0D0
      D0004C4C4C004CA2A2004C4C4C0000000000000000004C4C4C00A54C4C00A54C
      4C00A54C4C004C4C4C000000000000000000000000004C4C4C00FEFEFE00FEFE
      FE00FEFEFE004C4C4C0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      0000000000004C4CA5004C4CA5004C4CA5004C4CA5004C4CA500000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004CA2
      A2004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C00D0D0D000D0D0
      D0004C4C4C004CA2A2004C4C4C0000000000000000004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C000000000000000000000000004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C00FEFEFE00FEFE
      FE00FEFEFE00FEFEFE00FEFEFE00FEFEFE000000000000000000000000000000
      00000000000000000000000000004C4CA5000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004CA2
      A2004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C
      4C004C4C4C004CA2A2004C4C4C00000000000000000000000000000000000000
      0000000000000000000000000000A54C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C000000000000000000000000000000
      00000000000000000000000000004C4CA5000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004CA2
      A2004CA2A2004CA2A2004CA2A2004CA2A2004CA2A2004CA2A2004CA2A2004CA2
      A2004CA2A2004CA2A2004C4C4C00000000000000000000000000000000000000
      00000000000000000000A54C4C00A54C4C00A54C4C0000000000000000000000
      0000000000000000000000000000000000004C4C4C004C4C4C004C4C4C004C4C
      4C004C4C4C000000000000000000A54C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004C4CA5004C4CA5004C4CA5004C4CA5004C4CA500000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004CA2
      A2004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C
      4C004CA2A2004CA2A2004C4C4C00000000000000000000000000000000000000
      000000000000A54C4C00A54C4C00A54C4C00A54C4C00A54C4C00000000000000
      000000000000000000000000000000000000FEFEFE00FEFE4C00FEFEFE00FEFE
      4C004C4C4C000000000000000000A54C4C00A54C4C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004C4CA500FEFE4C00FEFEFE00FEFE4C004C4CA500000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004C4C
      4C00D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0
      D0004C4C4C004CA2A2004C4C4C00000000000000000000000000000000000000
      0000000000000000000000000000A54C4C000000000000000000000000000000
      000000000000000000000000000000000000FEFE4C00FEFEFE00FEFE4C00FEFE
      FE004C4C4C00A54C4C00A54C4C00A54C4C00A54C4C00A54C4C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004C4CA500FEFEFE00FEFE4C00FEFEFE004C4CA500000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004C4C
      4C00D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0
      D0004C4C4C004CA2A2004C4C4C00000000000000000000000000000000000000
      0000000000000000000000000000A54C4C000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00FEFE4C00FEFEFE00FEFE
      4C004C4C4C000000000000000000A54C4C00A54C4C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004C4CA500FEFE4C00FEFEFE00FEFE4C004C4CA500000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004C4C
      4C00D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0
      D0004C4C4C004CA2A2004C4C4C00000000000000000000000000000000000000
      0000000000004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C00000000000000
      0000000000000000000000000000000000004C4C4C004C4C4C004C4C4C004C4C
      4C004C4C4C000000000000000000A54C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004C4CA500FEFEFE00FEFE4C00FEFEFE004C4CA500000000000000
      000000000000000000000000000000000000000000004C4C4C004CA2A2004C4C
      4C00D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0
      D0004C4C4C004CA2A2004C4C4C00000000000000000000000000000000000000
      0000000000004C4C4C00FEFE4C00FEFEFE00FEFE4C004C4C4C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C00000000004C4C4C004C4C4C004C4C
      4C004C4C4C004C4CA500FEFE4C00FEFEFE00FEFE4C004C4CA5004C4C4C004C4C
      4C004C4C4C004C4C4C000000000000000000000000004C4C4C004CA2A2004C4C
      4C00D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0
      D0004C4C4C004C4C4C004C4C4C00000000000000000000000000000000000000
      0000000000004C4C4C00FEFEFE00FEFE4C00FEFEFE004C4C4C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C00A54C4C00A54C
      4C00A54C4C00A54C4C00A54C4C00A54C4C00000000004C4C4C00FEFEFE00FEFE
      FE00FEFEFE004C4CA500FEFEFE00FEFE4C00FEFEFE004C4CA500FEFEFE00FEFE
      FE00FEFEFE004C4C4C000000000000000000000000004C4C4C004CA2A2004C4C
      4C00D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000D0D0
      D0004C4C4C00D0D0D0004C4C4C00000000000000000000000000000000000000
      0000000000004C4C4C00FEFE4C00FEFEFE00FEFE4C004C4C4C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C00A54C4C00A54C
      4C00A54C4C00A54C4C00A54C4C00A54C4C00000000004C4C4C00FEFEFE00FEFE
      FE00FEFEFE004C4CA500FEFE4C00FEFEFE00FEFE4C004C4CA500FEFEFE00FEFE
      FE00FEFEFE004C4C4C000000000000000000000000004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C00000000000000000000000000000000000000
      0000000000004C4C4C00FEFEFE00FEFE4C00FEFEFE004C4C4C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C00A54C4C00A54C
      4C00A54C4C00A54C4C00A54C4C00A54C4C00000000004C4C4C00FEFEFE00FEFE
      FE00FEFEFE004C4CA500FEFEFE00FEFE4C00FEFEFE004C4CA500FEFEFE00FEFE
      FE00FEFEFE004C4C4C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000632DE000632DE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00241CED0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000000000000000000632DE000632DE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000632DE000632DE000000000000000000B6857B00A5787300A578
      7300A5787300A5787300A5787300A5787300A5787300A5787300A5787300A578
      7300A5787300986D670000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00241CED00241CED00241CED0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000000000000000000632DE000632DE000632
      DE00000000000000000000000000000000000000000000000000000000000000
      00000632DE000632DE00000000000000000000000000B6857B00F8EFE300EDE2
      CC00EADEC400EDDBBB00EBD8B200EBD4AA00EAD0A000E4CC9C00E4CC9C00E4CC
      9C00EAD0A000986D670000000000000000004C4C4C004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF00241CED00241CED00241CED00241CED00241CED0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000000000000000000632DE000632DD000632
      DE000632DE000000000000000000000000000000000000000000000000000632
      DE000632DE0000000000000000000000000000000000B2817700F8EFE300EFE6
      D400EDE2CC00EADEC400E6CE9D000189020001890200DDC59400E4CC9C00E4CC
      9C00EAD0A000986D670000000000000000004C4C4C004C4C4C004CA8A8004CA8
      A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004C4C
      4C00000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00241CED0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000000000000433ED000632
      DE000632DE000632DE00000000000000000000000000000000000632DE000632
      DE000000000000000000000000000000000000000000B2817700FBF4EC00F3EB
      DD0001890200EBD6AF0001890200E6CE9D00DFC8970001890200DDC59400E6CE
      9D00EAD0A000986D670000000000000000004C4C4C004CFEFE004C4C4C004CA8
      A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8
      A8004C4C4C000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00241CED0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      00000632DE000632DE000632DD00000000000632DD000632DE000632DE000000
      00000000000000000000000000000000000000000000C18D7E00FEFCFA00F8EF
      E3000189020001890200EBD6AF00EADEC400EDDBBB00DFC8970001890200EAD0
      A000EAD0A000986D670000000000000000004C4C4C00FEFEFE004CFEFE004C4C
      4C004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8
      A8004CA8A8004C4C4C0000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF00241CED0000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000632DD000533E7000533E7000533E9000632DD00000000000000
      00000000000000000000000000000000000000000000C18D7E00FEFDFC00FBF4
      EC00018902000189020001890200EDE2CC00EADEC400EDDBBB00EBD8B200EBD4
      AA00EBD2A500986D670000000000000000004C4C4C004CFEFE00FEFEFE004CFE
      FE004C4C4C004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8A8004CA8
      A8004CA8A8004CA8A8004C4C4C00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      000000000000000000000632E4000632E4000433EF0000000000000000000000
      00000000000000000000000000000000000000000000CE9A8300FEFDFC00FDF9
      F600FBF4EC00F8EFE300F3EBDD00EFE6D400018902000189020001890200EBD8
      B200EBD6AF00986D670000000000000000004C4C4C00FEFEFE004CFEFE00FEFE
      FE004CFEFE004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C
      4C004C4C4C004C4C4C004C4C4C004C4C4C000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000632DD000433ED000533E9000433EF000434F400000000000000
      00000000000000000000000000000000000000000000CE9A8300FEFDFC00FEFD
      FC0001890200EDE2CC00F8EFE300F3EBDD00EBD8B2000189020001890200EDDB
      B900EDDBB900986D670000000000000000004C4C4C004CFEFE00FEFEFE004CFE
      FE00FEFEFE004CFEFE00FEFEFE004CFEFE00FEFEFE004CFEFE004C4C4C000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      00000434F4000433EF000533EB0000000000000000000434F4000335F8000000
      00000000000000000000000000000000000000000000D5A18100FEFDFC00FEFD
      FC00F3EBDD0001890200ECDFC800EADEC40001890200EBD8B20001890200EADE
      C400EBDAB600986D670000000000000000004C4C4C00FEFEFE004CFEFE00FEFE
      FE004CFEFE00FEFEFE004CFEFE00FEFEFE004CFEFE00FEFEFE004C4C4C000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000335
      F8000433EF000334F800000000000000000000000000000000000335F8000335
      F8000000000000000000000000000000000000000000D5A18100FEFDFC00FEFD
      FC00FEFDFC00F3EBDD000189020001890200EADEC400F3EBDD00F8EFE300EADE
      C400DDBB9500986D670000000000000000004C4C4C004CFEFE00FEFEFE004CFE
      FE004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C004C4C4C000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF000000000000000000000000000335F8000335
      F8000335F8000000000000000000000000000000000000000000000000000335
      F8000335F80000000000000000000000000000000000E0B19600FEFDFC00FEFD
      FC00FEFDFC00FEFDFC00FEFDFC00FCF8F300FBF4EC00EFE6D400B2817700B281
      7700B2817700B28177000000000000000000000000004C4C4C004C4C4C004C4C
      4C00000000000000000000000000000000000000000000000000000000000000
      00004C4C4C004C4C4C004C4C4C00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000000000000000000335F8000335F8000335
      F800000000000000000000000000000000000000000000000000000000000000
      0000000000000335F800000000000000000000000000E0B19600FEFDFC00FEFD
      FC00FEFDFC00FEFDFC00FEFDFC00FEFDFC00FEFDFB00ECDFC800B2817700E0B1
      9600D5A18100BA887C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004C4C4C004C4C4C00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000335F8000335F8000335F8000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEBD9400FEFDFC00FEFD
      FC00FEFDFC00FEFDFC00FEFDFC00FEFDFC00FEFDFC00ECDFC800B2817700DDC5
      9400C99582000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004C4C4C0000000000000000000000
      00004C4C4C00000000004C4C4C00000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000335F8000335F800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEBD9400FCF8F300FCF8
      F300FCF8F300FCF8F300FCF8F300FCF8F300FCF8F300ECDFC800B2817700D09C
      8300000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004C4C4C004C4C4C004C4C
      4C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DEBD9400D5A18100D5A1
      8100D5A18100D5A18100D5A18100D5A18100D5A18100D5A18100B28177000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      00FF00000000000000FF00000000000000FF00000000000000FF000000000000
      001B000000000000001900000000000000000000000000000019000000000000
      001B00000000000000FF00000000000000FF00000000000000FF000000000000
      00FF000000000000FFFF000000000000FFFFFFFFFFFFFFFFC0018383FF80FEFF
      80018383FF80FC7F80018383FF80F83F80018383FF80FEFF8001FEFFFF80FEFF
      8001FC7F06FFF83F8001F83F067FF83F8001FEFF003FF83F8001FEFF067FF83F
      8001F83F06FFF83F8001F83FFF8080038001F83FFF8080038001F83FFF808003
      8001F83FFF808003FFFFFFFFFF80FFFF0000FFFCFFFFFFFF00009FF98003FFFF
      00008FF38003001F000087E78003000F0000C3CF800300070000F11F80030003
      0000F83F800300010000FC7F800300000000F83F8003001F0000F19F8003001F
      0000E3CF8003001F0000C7E780038FF100008FFB8003FFF900001FFF8007FF75
      00003FFF800FFF8F0000FFFF801FFFFF00000000000000000000000000000000
      000000000000}
  end
  object ActionList1: TActionList
    Images = ImageList1
    Left = 168
    Top = 104
    object acAddMatrix: TAction
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1086#1073#1098#1077#1082#1090
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1086#1073#1098#1077#1082#1090
      ImageIndex = 0
      OnExecute = acAddMatrixExecute
    end
    object acDeleteMatrix: TAction
      Caption = 'acDeleteMatrix'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1086#1073#1098#1077#1082#1090
      ImageIndex = 1
      OnExecute = acDeleteMatrixExecute
    end
    object acTreeRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1086#1073#1098#1077#1082#1090#1086#1074
      ImageIndex = 2
      OnExecute = acTreeRefreshExecute
    end
    object acLoadFromFile: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1073#1098#1077#1082#1090#1099' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1073#1098#1077#1082#1090#1099' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 3
      OnExecute = acLoadFromFileExecute
    end
    object acSaveToFile: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1086#1073#1098#1077#1082#1090#1099' '#1074' '#1092#1072#1081#1083
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1086#1073#1098#1077#1082#1090#1099' '#1074' '#1092#1072#1081#1083
      ImageIndex = 4
      OnExecute = acSaveToFileExecute
    end
    object acAddRow: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      ImageIndex = 6
      OnExecute = acAddRowExecute
    end
    object acAddCol: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1086#1083#1073#1077#1094
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1086#1083#1073#1077#1094
      ImageIndex = 5
      OnExecute = acAddColExecute
    end
    object acDelRow: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      ImageIndex = 8
      OnExecute = acDelRowExecute
    end
    object acDelCol: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1086#1083#1073#1077#1094
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1086#1083#1073#1077#1094
      ImageIndex = 7
      OnExecute = acDelColExecute
    end
    object acClearMatrix: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1086#1073#1098#1077#1082#1090
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1086#1073#1098#1077#1082#1090
      ImageIndex = 1
      OnExecute = acClearMatrixExecute
    end
  end
end
