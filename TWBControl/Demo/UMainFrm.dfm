object MainFrm: TMainFrm
  Left = 0
  Top = 0
  Caption = 'MainFrm'
  ClientHeight = 452
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 356
    Width = 796
    Height = 7
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 360
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 13
      Height = 13
      Caption = 'Url'
    end
    object eUrl: TEdit
      Left = 27
      Top = 5
      Width = 487
      Height = 21
      TabOrder = 0
      Text = 'https://stackoverflow.com/'
    end
    object bNavigate: TButton
      Left = 520
      Top = 3
      Width = 57
      Height = 25
      Caption = 'Go'
      TabOrder = 1
      OnClick = bNavigateClick
    end
  end
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 34
    Width = 796
    Height = 322
    Align = alClient
    TabOrder = 1
    OnBeforeNavigate2 = WebBrowser1BeforeNavigate2
    OnDocumentComplete = WebBrowser1DocumentComplete
    ExplicitLeft = 88
    ExplicitTop = 80
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C00000045520000482100000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620A000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object mData: TMemo
    Left = 0
    Top = 363
    Width = 796
    Height = 89
    Align = alBottom
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
