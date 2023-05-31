object MDIChild: TMDIChild
  Left = 197
  Top = 117
  Caption = 'MDI Child'
  ClientHeight = 487
  ClientWidth = 973
  Color = clWhite
  TransparentColorValue = clNone
  ParentFont = True
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object CapLb: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 20
    Width = 953
    Height = 20
    Margins.Left = 10
    Margins.Top = 20
    Margins.Right = 10
    Align = alTop
    AutoSize = False
    Caption = '  '#1054#1073#1097#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
    Color = clMoneyGreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
    ExplicitLeft = 5
    ExplicitWidth = 590
  end
  object InfoLB: TLabel
    AlignWithMargins = True
    Left = 50
    Top = 46
    Width = 873
    Height = 16
    Margins.Left = 50
    Margins.Right = 50
    Align = alTop
    Caption = #1085#1077#1090' '#1076#1072#1085#1085#1099#1093
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    ExplicitWidth = 67
  end
  object EKLB: TLabel
    Left = 648
    Top = 46
    Width = 110
    Height = 16
    Alignment = taCenter
    Caption = #1069#1092#1092#1077#1082#1090#1080#1074#1085#1086#1089#1090#1100':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PC: TPageControl
    AlignWithMargins = True
    Left = 10
    Top = 85
    Width = 953
    Height = 392
    Margins.Left = 10
    Margins.Top = 20
    Margins.Right = 10
    Margins.Bottom = 10
    ActivePage = TabSheet4
    Align = alClient
    MultiLine = True
    Style = tsButtons
    TabOrder = 0
    OnChange = PCChange
    object TabSheet1: TTabSheet
      Caption = #1058#1072#1073#1083#1080#1094#1099
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 945
        Height = 361
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        object ServPB: TPaintBox
          AlignWithMargins = True
          Left = 0
          Top = 46
          Width = 945
          Height = 31
          Margins.Left = 0
          Margins.Right = 0
          Align = alTop
          PopupMenu = PM
          OnMouseDown = ServPBMouseDown
          OnMouseEnter = ServPBMouseEnter
          OnMouseLeave = ServPBMouseLeave
          OnPaint = ServPBPaint
          ExplicitWidth = 796
        end
        object FltRezPB: TPaintBox
          AlignWithMargins = True
          Left = 0
          Top = 126
          Width = 945
          Height = 31
          Margins.Left = 0
          Margins.Right = 0
          Align = alTop
          PopupMenu = PM
          OnMouseDown = ServPBMouseDown
          OnMouseEnter = ServPBMouseEnter
          OnMouseLeave = ServPBMouseLeave
          OnPaint = FltRezPBPaint
          ExplicitTop = 150
          ExplicitWidth = 796
        end
        object FaultPB: TPaintBox
          AlignWithMargins = True
          Left = 0
          Top = 327
          Width = 945
          Height = 31
          Margins.Left = 0
          Margins.Right = 0
          Align = alBottom
          PopupMenu = PM
          OnMouseDown = ServPBMouseDown
          OnMouseEnter = ServPBMouseEnter
          OnMouseLeave = ServPBMouseLeave
          OnPaint = FaultPBPaint
          ExplicitLeft = 5
          ExplicitTop = 126
          ExplicitWidth = 590
        end
        object Label2: TLabel
          AlignWithMargins = True
          Left = 0
          Top = 20
          Width = 945
          Height = 20
          Margins.Left = 0
          Margins.Top = 20
          Margins.Right = 0
          Align = alTop
          AutoSize = False
          Caption = '  '#1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
          Color = clMoneyGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitTop = 36
          ExplicitWidth = 796
        end
        object Label1: TLabel
          AlignWithMargins = True
          Left = 0
          Top = 180
          Width = 945
          Height = 20
          Margins.Left = 0
          Margins.Top = 20
          Margins.Right = 0
          Align = alTop
          AutoSize = False
          Caption = '  '#1041#1088#1072#1082' '#1087#1086' '#1074#1080#1076#1072#1084
          Color = clMoneyGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 18
          ExplicitTop = 108
          ExplicitWidth = 590
        end
        object Label3: TLabel
          AlignWithMargins = True
          Left = 0
          Top = 100
          Width = 945
          Height = 20
          Margins.Left = 0
          Margins.Top = 20
          Margins.Right = 0
          Align = alTop
          AutoSize = False
          Caption = '  '#1041#1088#1072#1082' '#1087#1086' '#1084#1086#1076#1077#1083#1100#1085#1086
          Color = clMoneyGreen
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitLeft = 18
          ExplicitTop = 108
          ExplicitWidth = 590
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1043#1088#1072#1092#1080#1082' '#1087#1086' '#1095#1072#1089#1072#1084
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GrapPB: TPaintBox
        Left = 0
        Top = 0
        Width = 945
        Height = 361
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = PM
        OnMouseDown = ServPBMouseDown
        OnMouseEnter = ServPBMouseEnter
        OnMouseLeave = ServPBMouseLeave
        OnPaint = GrapPBPaint
        ExplicitLeft = 192
        ExplicitTop = 96
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1058#1077#1084#1087' '#1088#1086#1089#1090#1072
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object AGrapPB: TPaintBox
        Left = 0
        Top = 0
        Width = 945
        Height = 361
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        PopupMenu = PM
        OnMouseDown = ServPBMouseDown
        OnMouseEnter = ServPBMouseEnter
        OnMouseLeave = ServPBMouseLeave
        OnPaint = AGrapPBPaint
        ExplicitLeft = 192
        ExplicitTop = 96
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1058#1077#1082#1089#1090
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TMCP: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 939
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        Color = clMoneyGreen
        TabOrder = 0
        ExplicitTop = 4
        object Label4: TLabel
          AlignWithMargins = True
          Left = 440
          Top = 3
          Width = 61
          Height = 20
          Align = alLeft
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' :'
          Layout = tlCenter
          ExplicitHeight = 13
        end
        object Label5: TLabel
          AlignWithMargins = True
          Left = 126
          Top = 3
          Width = 13
          Height = 20
          Align = alLeft
          Caption = #1076#1086
          Layout = tlCenter
          ExplicitHeight = 13
        end
        object Label6: TLabel
          AlignWithMargins = True
          Left = 10
          Top = 3
          Width = 42
          Height = 20
          Margins.Left = 10
          Align = alLeft
          Caption = #1042#1088#1077#1084#1103': '#1089
          Layout = tlCenter
          ExplicitHeight = 13
        end
        object Label7: TLabel
          AlignWithMargins = True
          Left = 254
          Top = 3
          Width = 46
          Height = 20
          Align = alLeft
          Caption = #1052#1086#1076#1077#1083#1100' :'
          Layout = tlCenter
          ExplicitHeight = 13
        end
        object Splitter1: TSplitter
          Left = 210
          Top = 0
          Width = 41
          Height = 26
          ResizeStyle = rsLine
          ExplicitLeft = 206
        end
        object Splitter2: TSplitter
          Left = 744
          Top = 0
          Width = 41
          Height = 26
          ResizeStyle = rsLine
          ExplicitLeft = 781
        end
        object Splitter3: TSplitter
          Left = 396
          Top = 0
          Width = 41
          Height = 26
          ResizeStyle = rsLine
          ExplicitLeft = 403
        end
        object CntLB: TLabel
          AlignWithMargins = True
          Left = 788
          Top = 3
          Width = 61
          Height = 20
          Align = alLeft
          Caption = #1052#1086#1076#1077#1083#1100' :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          ExplicitHeight = 16
        end
        object DelBtn: TSpeedButton
          AlignWithMargins = True
          Left = 816
          Top = 3
          Width = 120
          Height = 20
          Align = alRight
          Caption = #1091#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
          Flat = True
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            333333333333333333333333000033338833333333333333333F333333333333
            0000333911833333983333333388F333333F3333000033391118333911833333
            38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
            911118111118333338F3338F833338F3000033333911111111833333338F3338
            3333F8330000333333911111183333333338F333333F83330000333333311111
            8333333333338F3333383333000033333339111183333333333338F333833333
            00003333339111118333333333333833338F3333000033333911181118333333
            33338333338F333300003333911183911183333333383338F338F33300003333
            9118333911183333338F33838F338F33000033333913333391113333338FF833
            38F338F300003333333333333919333333388333338FFF830000333333333333
            3333333333333333333888330000333333333333333333333333333333333333
            0000}
          NumGlyphs = 2
          OnClick = DelBtnClick
          ExplicitLeft = 836
        end
        object CodeCB: TComboBox
          AlignWithMargins = True
          Left = 507
          Top = 3
          Width = 234
          Height = 20
          Align = alLeft
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnChange = StHourCBChange
        end
        object StHourCB: TComboBox
          AlignWithMargins = True
          Left = 58
          Top = 3
          Width = 62
          Height = 21
          Align = alLeft
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 8
          TabOrder = 1
          Text = '08:00'
          OnChange = StHourCBChange
          Items.Strings = (
            '00:00'
            '01:00'
            '02:00'
            '03:00'
            '04:00'
            '05:00'
            '06:00'
            '07:00'
            '08:00'
            '09:00'
            '10:00'
            '11:00'
            '12:00'
            '13:00'
            '14:00'
            '15:00'
            '16:00'
            '17:00'
            '18:00'
            '19:00'
            '20:00'
            '21:00'
            '22:00'
            '23:00')
        end
        object FnHourCB: TComboBox
          AlignWithMargins = True
          Left = 145
          Top = 3
          Width = 62
          Height = 21
          Align = alLeft
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 20
          TabOrder = 2
          Text = '20:00'
          OnChange = StHourCBChange
          Items.Strings = (
            '00:00'
            '01:00'
            '02:00'
            '03:00'
            '04:00'
            '05:00'
            '06:00'
            '07:00'
            '08:00'
            '09:00'
            '10:00'
            '11:00'
            '12:00'
            '13:00'
            '14:00'
            '15:00'
            '16:00'
            '17:00'
            '18:00'
            '19:00'
            '20:00'
            '21:00'
            '22:00'
            '23:00')
        end
        object ModelCB: TComboBox
          AlignWithMargins = True
          Left = 306
          Top = 3
          Width = 87
          Height = 20
          Align = alLeft
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 3
          OnChange = StHourCBChange
        end
      end
      object LogSG: TStringGrid
        AlignWithMargins = True
        Left = 3
        Top = 35
        Width = 939
        Height = 323
        Align = alClient
        ColCount = 4
        Ctl3D = False
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        ParentCtl3D = False
        ScrollBars = ssVertical
        TabOrder = 1
        ExplicitLeft = 36
        ExplicitTop = 19
        ColWidths = (
          100
          102
          63
          335)
      end
    end
  end
  object PrintBtn: TButton
    Left = 735
    Top = 85
    Width = 75
    Height = 25
    Caption = #1055#1077#1095#1072#1090#1100
    TabOrder = 1
    OnClick = PrintBtnClick
  end
  object PM: TPopupMenu
    OnPopup = PMPopup
    Left = 328
    Top = 64
    object CopyMI: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = CopyMIClick
    end
    object N1: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1088#1080#1089#1091#1085#1086#1082
      OnClick = N1Click
    end
  end
  object Report: TfrxReport
    Version = '4.15'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 43152.820134571760000000
    ReportOptions.LastChange = 43152.873562013890000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    OnGetValue = ReportGetValue
    Left = 368
    Top = 64
    Datasets = <
      item
        DataSet = UDS
        DataSetName = 'UDS'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 75.590600000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          Align = baWidth
          Width = 718.110700000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1115#1056#1118#1056#167#1056#8226#1056#1118' '#1056#1119#1056#1115' '#1056#8216#1056#160#1056#1106#1056#1113#1056#1032)
          ParentFont = False
        end
        object Memo2: TfrxMemoView
          Align = baWidth
          Top = 18.897650000000000000
          Width = 718.110700000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8 = (
            '[REPDATE]')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          Align = baWidth
          Top = 49.133890000000000000
          Width = 718.110700000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            #1056#8217#1057#1027#1056#181#1056#1110#1056#1109' '#1056#1111#1057#1026#1056#1109#1056#1105#1056#183#1056#1030#1056#181#1056#1169#1056#181#1056#1029#1056#1109': [TOTCOUNT]')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        Height = 41.574830000000000000
        Top = 200.315090000000000000
        Width = 718.110700000000000000
        DataSet = UDS
        DataSetName = 'UDS'
        RowCount = 0
        object Memo3: TfrxMemoView
          Width = 60.472480000000000000
          Height = 41.574830000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[DEFTIME]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Left = 60.472480000000000000
          Width = 241.889920000000000000
          Height = 41.574830000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          Memo.UTF8 = (
            '[DEFNAME]')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          Left = 302.362400000000000000
          Width = 207.874150000000000000
          Height = 41.574830000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          Left = 510.236550000000000000
          Width = 207.874150000000000000
          Height = 41.574830000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          ParentFont = False
        end
      end
      object ColumnHeader1: TfrxColumnHeader
        Height = 22.677180000000000000
        Top = 117.165430000000000000
        Width = 718.110700000000000000
        object Memo7: TfrxMemoView
          Width = 60.472480000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8217#1057#1026#1056#181#1056#1112#1057#1039)
          ParentFont = False
        end
        object Memo8: TfrxMemoView
          Left = 60.472480000000000000
          Width = 241.889920000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1116#1056#181#1056#1105#1057#1027#1056#1111#1057#1026#1056#176#1056#1030#1056#1029#1056#1109#1057#1027#1057#8218#1057#1034)
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Left = 510.236550000000000000
          Width = 207.874150000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#164#1056#176#1056#1112#1056#1105#1056#187#1056#1105#1057#1039' '#1057#1027#1056#177#1056#1109#1057#1026#1057#8240#1056#1105#1056#1108#1056#176)
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          Left = 302.362400000000000000
          Width = 207.874150000000000000
          Height = 22.677180000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#160#1056#176#1056#177#1056#1109#1057#8225#1056#181#1056#181' '#1056#1112#1056#181#1057#1027#1057#8218#1056#1109)
          ParentFont = False
        end
      end
      object Footer1: TfrxFooter
        Height = 45.354360000000000000
        Top = 264.567100000000000000
        Width = 718.110700000000000000
        object Memo12: TfrxMemoView
          Align = baWidth
          Top = 26.456710000000000000
          Width = 718.110700000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haRight
          Memo.UTF8 = (
            
              #1056#1116#1056#176#1057#8225#1056#176#1056#187#1057#1034#1056#1029#1056#1105#1056#1108' '#1057#1027#1056#1112#1056#181#1056#1029#1057#8249' ____________________ / ___________' +
              '_______ /')
          ParentFont = False
        end
      end
    end
  end
  object UDS: TfrxUserDataSet
    UserName = 'UDS'
    Left = 408
    Top = 64
  end
end
