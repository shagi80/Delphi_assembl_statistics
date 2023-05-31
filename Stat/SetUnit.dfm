object MySetForm: TMySetForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  BorderWidth = 10
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 235
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DwnPn: TPanel
    Left = 0
    Top = 194
    Width = 370
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 310
    object BitBtn1: TBitBtn
      Left = 291
      Top = 16
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 0
      Kind = bkCancel
    end
    object BitBtn2: TBitBtn
      Left = 210
      Top = 16
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkOK
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 370
    Height = 194
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 310
    object TabSheet2: TTabSheet
      Caption = #1057#1074#1103#1079#1100
      ImageIndex = 1
      ExplicitHeight = 282
      object LocalGB: TGroupBox
        AlignWithMargins = True
        Left = 20
        Top = 20
        Width = 332
        Height = 117
        Margins.Left = 20
        Margins.Top = 20
        Margins.Right = 10
        Align = alTop
        Caption = #1055#1091#1090#1100' '#1082' '#1089#1077#1090#1077#1074#1086#1081' '#1087#1072#1087#1082#1077': '
        TabOrder = 0
        object LocalFolderED: TEdit
          Left = 16
          Top = 24
          Width = 265
          Height = 21
          TabOrder = 0
          Text = 'Edit1'
        end
        object Button1: TButton
          Left = 287
          Top = 22
          Width = 27
          Height = 25
          Caption = '...'
          TabOrder = 1
          OnClick = Button1Click
        end
        object LocalFolder2ED: TEdit
          Left = 16
          Top = 64
          Width = 265
          Height = 21
          TabOrder = 2
          Text = 'LocalFolder2ED'
        end
        object Button2: TButton
          Left = 287
          Top = 62
          Width = 27
          Height = 25
          Caption = '...'
          TabOrder = 3
          OnClick = Button1Click
        end
      end
    end
  end
end
