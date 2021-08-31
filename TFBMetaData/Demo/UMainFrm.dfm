object MainFrm: TMainFrm
  Left = 0
  Top = 0
  Caption = 'MainFrm'
  ClientHeight = 418
  ClientWidth = 837
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    837
    418)
  PixelsPerInch = 96
  TextHeight = 13
  object lDataBase: TLabel
    Left = 16
    Top = 24
    Width = 78
    Height = 13
    Caption = 'Select DataBase'
  end
  object bDataBase: TSpeedButton
    Left = 392
    Top = 21
    Width = 21
    Height = 21
    Caption = '...'
    OnClick = bDataBaseClick
  end
  object eDataBase: TEdit
    Left = 104
    Top = 21
    Width = 289
    Height = 21
    TabOrder = 0
  end
  object bConnect: TButton
    Left = 440
    Top = 19
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 1
    OnClick = bConnectClick
  end
  object pcPages: TPageControl
    Left = 8
    Top = 56
    Width = 821
    Height = 354
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Tables and Fields'
      DesignSize = (
        813
        326)
      object bTables: TButton
        Left = 23
        Top = 21
        Width = 75
        Height = 25
        Caption = 'Get Tables'
        TabOrder = 0
        OnClick = bTablesClick
      end
      object lbTables: TListBox
        Left = 23
        Top = 52
        Width = 121
        Height = 261
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        Sorted = True
        TabOrder = 1
        OnClick = lbTablesClick
      end
      object PageControl1: TPageControl
        Left = 184
        Top = 21
        Width = 609
        Height = 292
        ActivePage = TabSheet4
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
        object TabSheet4: TTabSheet
          Caption = 'Fields'
          DesignSize = (
            601
            264)
          object Label1: TLabel
            Left = 23
            Top = 18
            Width = 56
            Height = 13
            Caption = 'Table Fields'
          end
          object lbFields: TListBox
            Left = 23
            Top = 37
            Width = 233
            Height = 221
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 0
          end
        end
        object TabSheet5: TTabSheet
          Caption = 'Primary Key'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          DesignSize = (
            601
            264)
          object Label3: TLabel
            Left = 23
            Top = 18
            Width = 57
            Height = 13
            Caption = 'Primary Key'
          end
          object lbPrimary: TListBox
            Left = 23
            Top = 37
            Width = 121
            Height = 215
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 0
          end
        end
        object TabSheet6: TTabSheet
          Caption = 'Index'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          DesignSize = (
            601
            264)
          object Label4: TLabel
            Left = 31
            Top = 18
            Width = 28
            Height = 13
            Caption = 'Index'
          end
          object Label5: TLabel
            Left = 199
            Top = 18
            Width = 58
            Height = 13
            Caption = 'Fields Index'
          end
          object lbFieldsIndex: TListBox
            Left = 192
            Top = 37
            Width = 121
            Height = 212
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            TabOrder = 0
          end
          object lbIndex: TListBox
            Left = 31
            Top = 37
            Width = 121
            Height = 216
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            Sorted = True
            TabOrder = 1
            OnClick = lbIndexClick
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'Triggers'
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          DesignSize = (
            601
            264)
          object Label2: TLabel
            Left = 31
            Top = 18
            Width = 39
            Height = 13
            Caption = 'Triggers'
          end
          object lbTriggers: TListBox
            Left = 31
            Top = 37
            Width = 121
            Height = 216
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            Sorted = True
            TabOrder = 0
            OnClick = lbTriggersClick
          end
          object mTriggerSource: TMemo
            Left = 158
            Top = 37
            Width = 425
            Height = 216
            Anchors = [akLeft, akTop, akRight, akBottom]
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Views'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        813
        326)
      object bViews: TButton
        Left = 23
        Top = 21
        Width = 75
        Height = 25
        Caption = 'Get Views'
        TabOrder = 0
        OnClick = bViewsClick
      end
      object lbViews: TListBox
        Left = 23
        Top = 52
        Width = 121
        Height = 261
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 1
        OnClick = lbViewsClick
      end
      object mViewSource: TMemo
        Left = 152
        Top = 52
        Width = 643
        Height = 261
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 2
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Procedures'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        813
        326)
      object mProcedureSource: TMemo
        Left = 152
        Top = 52
        Width = 643
        Height = 261
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object lbProcedures: TListBox
        Left = 23
        Top = 52
        Width = 121
        Height = 261
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 1
        OnClick = lbProceduresClick
      end
      object bProcedures: TButton
        Left = 23
        Top = 21
        Width = 90
        Height = 25
        Caption = 'Get Procedures'
        TabOrder = 2
        OnClick = bProceduresClick
      end
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Left = 560
    Top = 16
  end
  object OpenDialog1: TOpenDialog
    Left = 640
    Top = 16
  end
end
