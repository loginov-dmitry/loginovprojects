object LoginForm: TLoginForm
  Left = 0
  Top = 0
  ActiveControl = edPassword
  BorderIcons = [biSystemMenu]
  Caption = #1042#1093#1086#1076' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  ClientHeight = 367
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 23
  object Label1: TLabel
    Left = 32
    Top = 16
    Width = 310
    Height = 23
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1080#1079' '#1089#1087#1080#1089#1082#1072':'
  end
  object Label2: TLabel
    Left = 32
    Top = 301
    Width = 275
    Height = 23
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1087#1072#1088#1086#1083#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
  end
  object edPassword: TEdit
    Left = 32
    Top = 328
    Width = 310
    Height = 31
    PasswordChar = '*'
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 348
    Top = 325
    Width = 118
    Height = 38
    Caption = #1042#1093#1086#1076
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 480
    Top = 337
    Width = 81
    Height = 26
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
  end
  object GridDoctors: TDBGrid
    Left = 32
    Top = 45
    Width = 529
    Height = 252
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -19
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnMouseUp = GridDoctorsMouseUp
  end
  object DataSource1: TDataSource
    DataSet = dsDoctors
    Left = 392
    Top = 16
  end
  object dsDoctors: TIBDataSet
    SelectSQL.Strings = (
      'SELECT * FROM DOCTORS'
      'WHERE ISDELETE=0'
      'ORDER BY ISBOSS DESC, NAME')
    Left = 304
    Top = 16
    object dsDoctorsID: TIntegerField
      FieldName = 'ID'
      Origin = '"DOCTORS"."ID"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Visible = False
    end
    object dsDoctorsTABNUM: TIBStringField
      FieldName = 'TABNUM'
      Origin = '"DOCTORS"."TABNUM"'
      Visible = False
    end
    object dsDoctorsNAME: TIBStringField
      DisplayLabel = #1060#1048#1054' '#1074#1088#1072#1095#1072
      FieldName = 'NAME'
      Origin = '"DOCTORS"."NAME"'
      Size = 100
    end
    object dsDoctorsADDDATE: TDateTimeField
      FieldName = 'ADDDATE'
      Origin = '"DOCTORS"."ADDDATE"'
      Visible = False
    end
    object dsDoctorsISDELETE: TIntegerField
      FieldName = 'ISDELETE'
      Origin = '"DOCTORS"."ISDELETE"'
      Visible = False
    end
    object dsDoctorsCOMMENT: TIBStringField
      FieldName = 'COMMENT'
      Origin = '"DOCTORS"."COMMENT"'
      Visible = False
      Size = 300
    end
    object dsDoctorsCOMPNAME: TIBStringField
      FieldName = 'COMPNAME'
      Origin = '"DOCTORS"."COMPNAME"'
      Visible = False
      Size = 100
    end
    object dsDoctorsMODIFYDATE: TDateTimeField
      FieldName = 'MODIFYDATE'
      Origin = '"DOCTORS"."MODIFYDATE"'
      Visible = False
    end
    object dsDoctorsFULLNAME: TIBStringField
      FieldName = 'FULLNAME'
      Origin = '"DOCTORS"."FULLNAME"'
      Visible = False
      Size = 200
    end
    object dsDoctorsUSERPASSW: TIBStringField
      FieldName = 'USERPASSW'
      Origin = '"DOCTORS"."USERPASSW"'
      Visible = False
    end
    object dsDoctorsISBOSS: TIntegerField
      FieldName = 'ISBOSS'
      Origin = '"DOCTORS"."ISBOSS"'
      Visible = False
    end
  end
end
