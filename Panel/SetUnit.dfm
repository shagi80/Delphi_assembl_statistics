object MySetForm: TMySetForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  BorderWidth = 10
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 351
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
    Top = 310
    Width = 370
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
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
    Height = 310
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      object Label3: TLabel
        Left = 49
        Top = 51
        Width = 113
        Height = 13
        Caption = #1063#1072#1089#1090#1086#1090#1072' '#1095#1090#1077#1085#1080#1103', '#1084#1080#1085' :'
      end
      object Label1: TLabel
        Left = 23
        Top = 24
        Width = 123
        Height = 13
        Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 23
        Top = 88
        Width = 186
        Height = 13
        Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1072#1085#1072#1083#1080#1079#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 23
        Top = 160
        Width = 188
        Height = 13
        Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1086#1082#1085#1072' '#1080#1085#1092#1086#1088#1084#1077#1088#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object StOnTopCB: TCheckBox
        Left = 49
        Top = 195
        Width = 137
        Height = 17
        Caption = #1087#1086#1074#1077#1088#1093' '#1074#1089#1077#1093' '#1086#1082#1086#1085
        TabOrder = 0
      end
      object FrReadED: TEdit
        Left = 248
        Top = 48
        Width = 42
        Height = 21
        ReadOnly = True
        TabOrder = 1
        Text = '5'
      end
      object UpDown1: TUpDown
        Left = 290
        Top = 48
        Width = 16
        Height = 21
        Associate = FrReadED
        Min = 1
        Max = 60
        Position = 5
        TabOrder = 2
      end
      object ViewAppNameED: TEdit
        Left = 48
        Top = 117
        Width = 226
        Height = 21
        TabStop = False
        TabOrder = 3
        Text = 'Edit1'
      end
      object Button2: TButton
        Left = 280
        Top = 115
        Width = 26
        Height = 25
        Caption = '...'
        TabOrder = 4
        OnClick = Button2Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1057#1074#1103#1079#1100
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LocalRB: TRadioButton
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 342
        Height = 17
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Align = alTop
        Caption = #1087#1086' '#1083#1086#1082#1072#1083#1100#1085#1086#1081' '#1089#1077#1090#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = LocalRBClick
      end
      object LocalGB: TGroupBox
        AlignWithMargins = True
        Left = 20
        Top = 33
        Width = 332
        Height = 70
        Margins.Left = 20
        Margins.Right = 10
        Align = alTop
        Caption = #1055#1091#1090#1100' '#1082' '#1089#1077#1090#1077#1074#1086#1081' '#1087#1072#1087#1082#1077': '
        TabOrder = 1
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
      end
      object FTPRB: TRadioButton
        AlignWithMargins = True
        Left = 10
        Top = 116
        Width = 342
        Height = 17
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Align = alTop
        Caption = #1095#1077#1088#1077#1079' FTP '#1089#1077#1088#1074#1077#1088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = LocalRBClick
      end
      object FTPGB: TGroupBox
        AlignWithMargins = True
        Left = 20
        Top = 139
        Width = 332
        Height = 124
        Margins.Left = 20
        Margins.Right = 10
        Margins.Bottom = 20
        Align = alTop
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1076#1086#1089#1090#1091#1087#1072' '#1082' '#1089#1077#1088#1074#1077#1088#1091': '
        TabOrder = 3
        object Label5: TLabel
          Left = 16
          Top = 24
          Width = 105
          Height = 21
          AutoSize = False
          Caption = #1055#1091#1090#1100' '#1082' '#1087#1072#1087#1082#1077' '#1085#1072' FTP:'
          Layout = tlCenter
        end
        object Label6: TLabel
          Left = 16
          Top = 51
          Width = 105
          Height = 21
          AutoSize = False
          Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
          Layout = tlCenter
        end
        object Label7: TLabel
          Left = 16
          Top = 78
          Width = 105
          Height = 21
          AutoSize = False
          Caption = #1055#1072#1088#1086#1083#1100':'
          Layout = tlCenter
        end
        object FTPNameED: TEdit
          Left = 136
          Top = 24
          Width = 178
          Height = 21
          TabOrder = 0
          Text = 'FTPNameED'
        end
        object UserNameED: TEdit
          Left = 136
          Top = 51
          Width = 178
          Height = 21
          TabOrder = 1
          Text = 'Edit1'
        end
        object PswrdED: TEdit
          Left = 136
          Top = 78
          Width = 178
          Height = 21
          TabOrder = 2
          Text = 'Edit1'
        end
      end
    end
  end
  object OpenDlg: TOpenDialog
    Filter = #1048#1089#1087#1086#1083#1085#1103#1077#1084#1099#1077' '#1092#1072#1081#1083#1099'|*.exe'
    Title = #1042#1099#1073#1086#1088' '#1092#1072#1081#1083#1072
    Top = 392
  end
end
