inherited MedDoctorsForm: TMedDoctorsForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1074#1088#1072#1095#1077#1081
  ClientHeight = 289
  ClientWidth = 509
  ExplicitWidth = 525
  ExplicitHeight = 327
  PixelsPerInch = 96
  TextHeight = 16
  inherited panOkCancel: TPanel
    Top = 248
    Width = 509
    ExplicitTop = 248
    ExplicitWidth = 509
    inherited btnOK: TBitBtn
      Left = 332
      ExplicitLeft = 332
    end
    inherited btnCancel: TBitBtn
      Left = 425
      ExplicitLeft = 425
    end
  end
  object DBGrid1: TDBGrid [1]
    Left = 0
    Top = 0
    Width = 509
    Height = 212
    Align = alClient
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 212
    Width = 509
    Height = 36
    Align = alBottom
    TabOrder = 2
    object btnAddRec: TBitBtn
      Left = 8
      Top = 6
      Width = 75
      Height = 25
      Caption = '&'#1044#1086#1073#1072#1074#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnAddRecClick
    end
    object btnEditRec: TBitBtn
      Left = 89
      Top = 6
      Width = 75
      Height = 25
      Caption = '&'#1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 1
      OnClick = btnEditRecClick
    end
    object btnDelRec: TBitBtn
      Left = 170
      Top = 6
      Width = 31
      Height = 25
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      Cancel = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnDelRecClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
  end
  object DataSource1: TDataSource [5]
    DataSet = dsDoctors
    Left = 32
    Top = 88
  end
  object dsDoctors: TIBDataSet [6]
    SelectSQL.Strings = (
      'SELECT * FROM DOCTORS'
      'WHERE ISDELETE=0'
      'ORDER BY ISBOSS DESC, NAME')
    Left = 112
    Top = 88
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
      Size = 999
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
  end
end
