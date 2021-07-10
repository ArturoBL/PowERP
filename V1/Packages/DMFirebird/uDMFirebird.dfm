object DMData: TDMData
  Left = 0
  Top = 0
  ClientHeight = 201
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  PixelsPerInch = 96
  TextHeight = 13
  object fbDatabase: TpFIBDatabase
    AutoReconnect = True
    DefaultTransaction = fbt
    DefaultUpdateTransaction = fbtU
    SQLDialect = 3
    Timeout = 0
    WaitForRestoreConnect = 0
    BeforeConnect = fbDatabaseBeforeConnect
    Left = 40
    Top = 24
  end
  object fbt: TpFIBTransaction
    DefaultDatabase = fbDatabase
    Left = 104
    Top = 24
  end
  object fbtU: TpFIBTransaction
    DefaultDatabase = fbDatabase
    Left = 168
    Top = 24
  end
end
