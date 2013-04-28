object RepVarsForm: TRepVarsForm
  Left = 0
  Top = 0
  Caption = #1042#1089#1090#1072#1074#1082#1072' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1093' '#1076#1083#1103' '#1086#1090#1095#1077#1090#1072
  ClientHeight = 400
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 82
    Align = alTop
    TabOrder = 0
    DesignSize = (
      632
      82)
    object Label1: TLabel
      Left = 163
      Top = 2
      Width = 99
      Height = 16
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1086#1090#1095#1077#1090':'
    end
    object Label2: TLabel
      Left = 58
      Top = 48
      Width = 86
      Height = 16
      Caption = #1042#1099#1073#1088#1072#1085' '#1086#1090#1095#1077#1090':'
    end
    object Label3: TLabel
      Left = 8
      Top = 64
      Width = 136
      Height = 16
      Caption = #1060#1072#1081#1083' '#1096#1072#1073#1083#1086#1085#1072' '#1086#1090#1095#1077#1090#1072':'
    end
    object labRepName: TLabel
      Left = 148
      Top = 48
      Width = 4
      Height = 16
      Caption = '.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object labRepFile: TLabel
      Left = 148
      Top = 64
      Width = 4
      Height = 16
      Caption = '.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 5
      Top = 2
      Width = 139
      Height = 16
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077':'
    end
    object cbRepList: TComboBox
      Left = 157
      Top = 19
      Width = 469
      Height = 24
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      ItemHeight = 16
      TabOrder = 0
      OnSelect = cbRepListSelect
    end
    object cbProgramList: TComboBox
      Left = 7
      Top = 19
      Width = 145
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 1
      Text = #1055#1058#1050' '#1040#1047#1057': '#1043#1057#1052
      OnSelect = cbProgramListSelect
      Items.Strings = (
        #1055#1058#1050' '#1040#1047#1057': '#1043#1057#1052
        #1055#1058#1050' '#1040#1047#1057': '#1052#1072#1075#1072#1079#1080#1085
        #1050#1052#1040#1047#1057
        #1055#1088#1086#1062#1077#1085#1090#1050#1072#1088#1090)
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 366
    Width = 632
    Height = 34
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      632
      34)
    object Label5: TLabel
      Left = 8
      Top = 6
      Width = 87
      Height = 16
      Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100':'
    end
    object btnOK: TButton
      Left = 446
      Top = 3
      Width = 85
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object Button2: TButton
      Left = 540
      Top = 3
      Width = 85
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
      OnClick = Button2Click
    end
    object TrackBar1: TTrackBar
      Left = 96
      Top = 1
      Width = 166
      Height = 27
      Max = 255
      Min = 75
      PageSize = 10
      Frequency = 5
      Position = 255
      TabOrder = 2
      OnChange = TrackBar1Change
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 82
    Width = 632
    Height = 284
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1099#1077' '#1076#1083#1103' '#1086#1090#1095#1077#1090#1072
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sg: TStringGrid
        Left = 0
        Top = 0
        Width = 624
        Height = 253
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 20
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        OnDblClick = sgDblClick
        OnKeyDown = sgKeyDown
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1054#1073#1097#1080#1077' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1077
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sg1: TStringGrid
        Left = 0
        Top = 0
        Width = 624
        Height = 253
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 20
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        OnDblClick = sgDblClick
        OnKeyDown = sgKeyDown
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1050#1086#1084#1072#1085#1076#1099
      ImageIndex = 2
      object sg2: TStringGrid
        Left = 0
        Top = 0
        Width = 624
        Height = 253
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 20
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        OnDblClick = sgDblClick
        OnKeyDown = sgKeyDown
      end
    end
  end
end
