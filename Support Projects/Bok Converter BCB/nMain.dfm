object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 505
  ClientWidth = 687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    687
    505)
  PixelsPerInch = 96
  TextHeight = 13
  object DBMemo1: TDBMemo
    Left = 8
    Top = 271
    Width = 649
    Height = 218
    Alignment = taRightJustify
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = dsADO
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 33
    Width = 649
    Height = 232
    Anchors = [akLeft, akTop, akRight]
    DataSource = dsADO
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object adoCon: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\sm.mdb;Persist S' +
      'ecurity Info=False'
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 56
    Top = 312
  end
  object query: TADOQuery
    Connection = adoCon
    Parameters = <>
    Left = 88
    Top = 312
  end
  object dsADO: TDataSource
    DataSet = query
    Left = 120
    Top = 312
  end
end
