inherited MedAddEditDoctorForm: TMedAddEditDoctorForm
  ActiveControl = edFullName
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1091#1095#1077#1090#1085#1086#1081' '#1079#1072#1087#1080#1089#1080' '#1074#1088#1072#1095#1072
  ClientHeight = 278
  ClientWidth = 546
  ExplicitWidth = 562
  ExplicitHeight = 316
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel [0]
    Left = 11
    Top = 11
    Width = 113
    Height = 16
    Caption = #1055#1086#1083#1085#1086#1077' '#1080#1084#1103' '#1074#1088#1072#1095#1072':'
  end
  object Label2: TLabel [1]
    Left = 53
    Top = 41
    Width = 71
    Height = 16
    Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072':'
  end
  object Label3: TLabel [2]
    Left = 34
    Top = 71
    Width = 90
    Height = 16
    Caption = #1058#1072#1073#1077#1083#1100#1085#1099#1081' '#8470':'
  end
  object Label4: TLabel [3]
    Left = 248
    Top = 71
    Width = 48
    Height = 16
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object Label5: TLabel [4]
    Left = 24
    Top = 121
    Width = 182
    Height = 16
    Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103':'
  end
  inherited panOkCancel: TPanel
    Top = 237
    Width = 546
    ExplicitTop = 237
    ExplicitWidth = 546
    inherited btnOK: TBitBtn
      Left = 369
      OnClick = btnOKClick
      ExplicitLeft = 369
    end
    inherited btnCancel: TBitBtn
      Left = 462
      ExplicitLeft = 462
    end
  end
  object edFullName: TEdit [6]
    Left = 135
    Top = 8
    Width = 391
    Height = 24
    TabOrder = 1
    OnExit = edFullNameExit
  end
  object edName: TEdit [7]
    Left = 135
    Top = 38
    Width = 391
    Height = 24
    TabOrder = 2
  end
  object edTabNum: TEdit [8]
    Left = 135
    Top = 68
    Width = 98
    Height = 24
    TabOrder = 3
  end
  object edPassword: TEdit [9]
    Left = 302
    Top = 68
    Width = 121
    Height = 24
    PasswordChar = '*'
    TabOrder = 4
  end
  object cbIsBoss: TCheckBox [10]
    Left = 120
    Top = 98
    Width = 233
    Height = 17
    Caption = #1071#1074#1083#1103#1077#1090#1089#1103' '#1079#1072#1074#1077#1076#1091#1102#1097#1080#1084' '#1086#1090#1076#1077#1083#1077#1085#1080#1103
    TabOrder = 5
  end
  object memComment: TMemo [11]
    Left = 8
    Top = 144
    Width = 521
    Height = 87
    ScrollBars = ssVertical
    TabOrder = 6
  end
end
