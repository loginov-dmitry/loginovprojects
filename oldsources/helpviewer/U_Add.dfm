object fmAdd: TfmAdd
  Left = 316
  Top = 231
  BorderStyle = bsDialog
  Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086
  ClientHeight = 230
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 369
    Height = 230
    ActivePage = TabSheet2
    Align = alClient
    HotTrack = True
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 338
        Height = 58
        Alignment = taCenter
        Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1099
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label2: TLabel
        Left = 16
        Top = 88
        Width = 320
        Height = 48
        Caption = 
          #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' '#1103#1074#1083#1103#1077#1090#1089#1103' '#1073#1077#1089#1087#1083#1072#1090#1085#1099#1084', '#1086#1076#1085#1072#1082#1086' '#1074#1099' '#1085#1077' '#1080#1084#1077#1077#1090#1077' '#1087#1088#1072#1074#1072' '#1080#1089#1087#1086#1083#1100 +
          #1079#1086#1074#1072#1090#1100' '#1077#1075#1086' '#1074' '#1082#1086#1084#1084#1077#1088#1095#1077#1089#1082#1080#1093' '#1094#1077#1083#1103#1093
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label3: TLabel
        Left = 16
        Top = 152
        Width = 292
        Height = 16
        Caption = '('#1089') '#1051#1086#1075#1080#1085#1086#1074' '#1044#1084#1080#1090#1088#1080#1081' '#1057#1077#1088#1075#1077#1077#1074#1080#1095', 2005 '#1075'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 8
        Top = 184
        Width = 166
        Height = 13
        Caption = #1053#1086#1074#1086#1089#1090#1080' Matrix '#1095#1080#1090#1072#1081#1090#1077' '#1085#1072' '#1089#1072#1081#1090#1077':'
        Enabled = False
      end
      object Label9: TLabel
        Left = 184
        Top = 184
        Width = 140
        Height = 13
        Cursor = crHandPoint
        Caption = 'http://matrix.kladovka.net.ru/'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Label7Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1042#1099#1073#1086#1088' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1099
      ImageIndex = 1
      object Label4: TLabel
        Left = 0
        Top = 8
        Width = 320
        Height = 32
        Alignment = taCenter
        Caption = #1059#1082#1072#1078#1080#1090#1077' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102', '#1074' '#1082#1086#1090#1086#1088#1086#1081' '#1085#1072#1093#1086#1076#1080#1090#1089#1103' '#1089#1087#1088#1072#1074#1086#1095#1085#1072#1103' '#1089#1080#1089#1090#1077#1084#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label5: TLabel
        Left = 0
        Top = 144
        Width = 350
        Height = 26
        Caption = 
          #1056#1072#1079#1076#1077#1083#1099' '#1089#1087#1088#1072#1074#1082#1080' '#1085#1077' '#1073#1099#1083#1080' '#1085#1072#1081#1076#1077#1085#1099'. '#1055#1086#1078#1072#1083#1091#1081#1089#1090#1072', '#1091#1082#1072#1078#1080#1090#1077' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102' ' +
          #1089' '#1088#1072#1079#1076#1077#1083#1072#1084#1080' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1099'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
        WordWrap = True
      end
      object Label6: TLabel
        Left = 8
        Top = 184
        Width = 166
        Height = 13
        Caption = #1053#1086#1074#1086#1089#1090#1080' Matrix '#1095#1080#1090#1072#1081#1090#1077' '#1085#1072' '#1089#1072#1081#1090#1077':'
        Enabled = False
      end
      object Label7: TLabel
        Left = 184
        Top = 184
        Width = 140
        Height = 13
        Cursor = crHandPoint
        Caption = 'http://matrix.kladovka.net.ru/'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Label7Click
      end
      object Edit1: TEdit
        Left = 8
        Top = 56
        Width = 313
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        Text = 'Doc'
      end
      object BitBtn1: TBitBtn
        Left = 176
        Top = 96
        Width = 75
        Height = 25
        Caption = #1055#1088#1080#1085#1103#1090#1100
        TabOrder = 1
        Kind = bkYes
      end
      object BitBtn2: TBitBtn
        Left = 264
        Top = 96
        Width = 75
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1072
        TabOrder = 2
        Kind = bkCancel
      end
      object Button1: TButton
        Left = 320
        Top = 56
        Width = 21
        Height = 21
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = Button1Click
      end
    end
  end
end
