object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 536
  ClientWidth = 745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 745
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object WSSB: TScrollBox
    Left = 0
    Top = 41
    Width = 745
    Height = 495
    Align = alClient
    Color = clAppWorkSpace
    ParentColor = False
    TabOrder = 1
    object PagePn: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 13
      Width = 729
      Height = 356
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      object PageWS: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 719
        Height = 346
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 0
        object Label1: TLabel
          Left = 0
          Top = 80
          Width = 719
          Height = 16
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Align = alTop
          Caption = #1041#1088#1072#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 32
        end
        object Label2: TLabel
          Left = 0
          Top = 48
          Width = 719
          Height = 16
          Margins.Left = 0
          Margins.Right = 0
          Align = alTop
          Caption = #1043#1086#1090#1086#1074#1072#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 131
        end
        object Label3: TLabel
          Left = 0
          Top = 64
          Width = 719
          Height = 16
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Align = alTop
          ExplicitWidth = 4
        end
        object Label4: TLabel
          Left = 0
          Top = 32
          Width = 719
          Height = 16
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Align = alTop
          ExplicitWidth = 4
        end
        object Label5: TLabel
          Left = 0
          Top = 16
          Width = 719
          Height = 16
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Align = alTop
          ExplicitWidth = 4
        end
        object Label6: TLabel
          Left = 0
          Top = 0
          Width = 719
          Height = 16
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Align = alTop
          ExplicitWidth = 4
        end
        object pb: TImage
          Left = 0
          Top = 153
          Width = 719
          Height = 32
          Align = alTop
        end
        object FaultSG: TStringGrid
          Left = 0
          Top = 96
          Width = 719
          Height = 57
          Align = alTop
          BevelInner = bvNone
          BevelKind = bkSoft
          BevelOuter = bvNone
          ColCount = 14
          Ctl3D = False
          DefaultColWidth = 60
          FixedCols = 0
          FixedRows = 0
          ParentCtl3D = False
          ScrollBars = ssNone
          TabOrder = 0
        end
      end
    end
    object Button1: TButton
      Left = 648
      Top = 320
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
    end
  end
end
