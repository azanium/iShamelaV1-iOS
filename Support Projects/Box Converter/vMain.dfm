object fMain: TfMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Shamela Bok Converter'
  ClientHeight = 417
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 267
    Width = 64
    Height = 13
    Caption = 'Target Path :'
  end
  object Label2: TLabel
    Left = 24
    Top = 21
    Width = 164
    Height = 13
    Caption = 'Drag Box Files to the Box below...'
  end
  object Label3: TLabel
    Left = 24
    Top = 387
    Width = 177
    Height = 13
    Caption = 'Copyright (C) 2010, Abu Zaid Ahmad'
    Enabled = False
  end
  object lblStatus: TLabel
    Left = 25
    Top = 340
    Width = 31
    Height = 13
    Caption = 'Ready'
  end
  object lblTable: TLabel
    Left = 25
    Top = 298
    Width = 3
    Height = 13
  end
  object listFiles: TListBox
    Left = 24
    Top = 40
    Width = 353
    Height = 201
    ItemHeight = 13
    TabOrder = 0
  end
  object btnBrowse: TButton
    Left = 351
    Top = 262
    Width = 27
    Height = 25
    Caption = '...'
    TabOrder = 1
    Visible = False
    OnClick = btnBrowseClick
  end
  object edtDest: TEdit
    Left = 94
    Top = 264
    Width = 283
    Height = 21
    TabOrder = 2
  end
  object prgFile: TProgressBar
    Left = 25
    Top = 317
    Width = 353
    Height = 17
    TabOrder = 3
  end
  object btnConvert: TButton
    Left = 303
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Convert'
    TabOrder = 4
    OnClick = btnConvertClick
  end
  object adoCon: TADOConnection
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 72
    Top = 168
  end
  object adoQuery: TADOQuery
    Connection = adoCon
    Parameters = <>
    Left = 104
    Top = 168
  end
  object adoSource: TDataSource
    DataSet = adoQuery
    Left = 136
    Top = 168
  end
  object dlgOpen: TOpenDialog
    Left = 256
    Top = 168
  end
  object Updater: TTimer
    Interval = 10
    OnTimer = UpdaterTimer
    Left = 264
    Top = 344
  end
  object ddb: TDISQLite3Database
    Left = 280
    Top = 168
  end
end
