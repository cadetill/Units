object MainFrm: TMainFrm
  Left = 0
  Top = 0
  Caption = 'MainFrm'
  ClientHeight = 436
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    492
    436)
  PixelsPerInch = 96
  TextHeight = 13
  object bGet: TButton
    Left = 32
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Get Services'
    TabOrder = 0
    OnClick = bGetClick
  end
  object lbServices: TListBox
    Left = 32
    Top = 63
    Width = 428
    Height = 354
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
  end
end
