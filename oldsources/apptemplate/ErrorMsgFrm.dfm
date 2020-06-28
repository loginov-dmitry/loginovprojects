object ErrorMsgForm: TErrorMsgForm
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  BorderWidth = 5
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1086#1073' '#1086#1096#1080#1073#1082#1077
  ClientHeight = 271
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    483
    271)
  PixelsPerInch = 96
  TextHeight = 13
  object memoErrorText: TMemo
    Left = 0
    Top = 0
    Width = 483
    Height = 228
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      #1040' '#1085#1077#1085#1072#1076#1086' '#1074#1099#1079#1099#1074#1072#1090#1100' '#1092#1086#1088#1084#1091' '#1087#1088#1086#1089#1090#1086' '#1090#1072#1082'!'
      '')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    OnKeyDown = memoErrorTextKeyDown
  end
  object btnAppQuit: TBitBtn
    Left = 329
    Top = 240
    Width = 75
    Height = 25
    Hint = 
      #1054#1089#1091#1097#1077#1089#1090#1074#1083#1103#1077#1090' '#1074#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099'. '#1044#1072#1085#1085#1099#1077', '#1080#1079#1084#1077#1085#1077#1085#1085#1099#1077' '#13#10#1074' '#1093#1086#1076#1077' '#1088#1072#1073 +
      #1086#1090#1099' '#1087#1088#1086#1075#1088#1072#1084#1084#1099', '#1085#1077' '#1089#1086#1093#1088#1072#1085#1103#1102#1090#1089#1103'|'#1054#1089#1091#1097#1077#1089#1090#1074#1083#1103#1077#1090' '#1074#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1093#1086#1076
    ModalResult = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object btnCancel: TBitBtn
    Left = 407
    Top = 240
    Width = 75
    Height = 25
    Hint = #1047#1072#1082#1088#1099#1074#1072#1077#1090' '#1076#1072#1085#1085#1086#1077' '#1086#1082#1085#1086
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    Default = True
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
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
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 8
    Top = 8
  end
end