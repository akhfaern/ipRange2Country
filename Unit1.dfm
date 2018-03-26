object IP2Location: TIP2Location
  Left = 192
  Top = 117
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'IP2Location'
  ClientHeight = 340
  ClientWidth = 218
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 38
    Height = 13
    Caption = 'IP Start:'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 35
    Height = 13
    Caption = 'IP End:'
  end
  object Label3: TLabel
    Left = 8
    Top = 96
    Width = 47
    Height = 13
    Caption = 'Countries:'
  end
  object edtIPStart: TEdit
    Left = 88
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtIPEnd: TEdit
    Left = 88
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object btnStart: TButton
    Left = 136
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = btnStartClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 112
    Width = 201
    Height = 201
    ItemHeight = 13
    TabOrder = 3
    OnDblClick = ListBox1DblClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 321
    Width = 218
    Height = 19
    Panels = <
      item
        Width = 180
      end>
    SimplePanel = False
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.txt'
    Filter = 'Text Files (*.txt)|*.txt'
    Left = 48
    Top = 72
  end
end
