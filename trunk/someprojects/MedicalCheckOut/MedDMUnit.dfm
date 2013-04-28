object MedDataModule: TMedDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 272
  Width = 315
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 24
    Top = 24
  end
  object FMedDB: TIBDatabase
    DatabaseName = 'localhost/3050:C:\Delphi\Projects\MedicalCheckOut\DB\MEDICAL.FDB'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = FTranR
    Left = 40
    Top = 104
  end
  object FTranR: TIBTransaction
    DefaultDatabase = FMedDB
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait'
      'read')
    Left = 128
    Top = 176
  end
  object FTranW: TIBTransaction
    DefaultDatabase = FMedDB
    DefaultAction = TARollback
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Left = 24
    Top = 184
  end
  object IBDataSet1: TIBDataSet
    Left = 232
    Top = 128
  end
end
