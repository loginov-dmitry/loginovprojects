object MedInputDataForm: TMedInputDataForm
  Left = 0
  Top = 0
  Caption = #1042#1074#1086#1076' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1086' '#1087#1072#1094#1080#1077#1085#1090#1077
  ClientHeight = 494
  ClientWidth = 716
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 550
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    716
    494)
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 8
    Top = 37
    Width = 114
    Height = 19
    Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072':'
  end
  object Label2: TLabel
    Left = 8
    Top = 72
    Width = 119
    Height = 19
    Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103':'
  end
  object Label3: TLabel
    Left = 8
    Top = 105
    Width = 163
    Height = 19
    Caption = #1044#1072#1090#1072' '#1075#1086#1089#1087#1080#1090#1072#1083#1080#1079#1072#1094#1080#1080':'
  end
  object Label4: TLabel
    Left = 304
    Top = 105
    Width = 107
    Height = 19
    Caption = #1044#1072#1090#1072' '#1074#1099#1087#1080#1089#1082#1080':'
  end
  object Label5: TLabel
    Left = 8
    Top = 140
    Width = 88
    Height = 19
    Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072':'
  end
  object Label6: TLabel
    Left = 8
    Top = 170
    Width = 66
    Height = 19
    Caption = #1044#1080#1072#1075#1085#1086#1079':'
  end
  object Label7: TLabel
    Left = 8
    Top = 295
    Width = 399
    Height = 19
    Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1086' '#1087#1072#1094#1080#1077#1085#1090#1077':'
  end
  object Label8: TLabel
    Left = 531
    Top = 105
    Width = 90
    Height = 19
    Caption = #8470' '#1074#1099#1087#1080#1089#1082#1080':'
  end
  object edPatFIO: TEdit
    Left = 128
    Top = 34
    Width = 582
    Height = 27
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object dtpPatBirthDay: TDateTimePicker
    Left = 133
    Top = 69
    Width = 108
    Height = 27
    Date = 41197.897342615740000000
    Time = 41197.897342615740000000
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 259
    Top = 73
    Width = 209
    Height = 21
    BevelOuter = bvNone
    TabOrder = 2
    object cbPatIsMan: TRadioButton
      Left = 5
      Top = 1
      Width = 97
      Height = 17
      Caption = #1052#1091#1078#1095#1080#1085#1072
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object cbPatIsGirl: TRadioButton
      Left = 108
      Top = 1
      Width = 97
      Height = 17
      Caption = #1046#1077#1085#1097#1080#1085#1072
      TabOrder = 1
    end
  end
  object dtpCheckInDate: TDateTimePicker
    Left = 177
    Top = 103
    Width = 108
    Height = 27
    Date = 41197.897342615740000000
    Time = 41197.897342615740000000
    TabOrder = 3
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 716
    Height = 28
    Align = alTop
    Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1080#1077' '#1074#1099#1087#1080#1089#1082#1080': '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1072#1094#1080#1077#1085#1090#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object dtpCheckOutDate: TDateTimePicker
    Left = 417
    Top = 103
    Width = 108
    Height = 27
    Date = 41197.897342615740000000
    Time = 41197.897342615740000000
    TabOrder = 5
  end
  object cbDoctorFIO: TComboBox
    Left = 102
    Top = 137
    Width = 565
    Height = 27
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 19
    TabOrder = 6
  end
  object memDiagnoz: TMemo
    Left = 80
    Top = 170
    Width = 630
    Height = 119
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object Panel3: TPanel
    Left = 0
    Top = 453
    Width = 716
    Height = 41
    Align = alBottom
    TabOrder = 8
    DesignSize = (
      716
      41)
    object BitBtn1: TBitBtn
      Left = 506
      Top = 5
      Width = 99
      Height = 31
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 616
      Top = 14
      Width = 91
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object edNumber: TEdit
    Left = 627
    Top = 102
    Width = 59
    Height = 27
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 9
  end
  object Panel4: TPanel
    Left = 8
    Top = 320
    Width = 700
    Height = 125
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 10
    object wb: TWebBrowser
      Left = 1
      Top = 1
      Width = 698
      Height = 123
      Align = alClient
      TabOrder = 0
      OnDocumentComplete = wbDocumentComplete
      ExplicitWidth = 582
      ExplicitHeight = 93
      ControlData = {
        4C00000024480000B60C00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 24
    Top = 200
  end
end
