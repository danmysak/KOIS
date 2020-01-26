object infofrm: Tinfofrm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1030#1085#1092#1086#1088#1084#1072#1094#1110#1103' '#1087#1088#1086' '#1091#1095#1072#1089#1085#1080#1082#1072
  ClientHeight = 312
  ClientWidth = 727
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    727
    312)
  PixelsPerInch = 120
  TextHeight = 17
  object grid: TAdvStringGrid
    Left = 12
    Top = 12
    Width = 703
    Height = 245
    Cursor = crDefault
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ColCount = 2
    Ctl3D = True
    DefaultColWidth = 400
    DrawingStyle = gdsClassic
    RowCount = 11
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goTabs]
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnTopLeftChanged = gridTopLeftChanged
    OnClickCell = gridClickCell
    OnEditChange = gridEditChange
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ColumnSize.StretchColumn = 1
    ControlLook.FixedGradientHoverFrom = 16775139
    ControlLook.FixedGradientHoverTo = 16775139
    ControlLook.FixedGradientHoverMirrorFrom = 16772541
    ControlLook.FixedGradientHoverMirrorTo = 16508855
    ControlLook.FixedGradientHoverBorder = 12033927
    ControlLook.FixedGradientDownFrom = 16377020
    ControlLook.FixedGradientDownTo = 16377020
    ControlLook.FixedGradientDownMirrorFrom = 16242317
    ControlLook.FixedGradientDownMirrorTo = 16109962
    ControlLook.FixedGradientDownBorder = 11440207
    ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownHeader.Font.Color = clWindowText
    ControlLook.DropDownHeader.Font.Height = -13
    ControlLook.DropDownHeader.Font.Name = 'Tahoma'
    ControlLook.DropDownHeader.Font.Style = []
    ControlLook.DropDownHeader.Visible = True
    ControlLook.DropDownHeader.Buttons = <>
    ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownFooter.Font.Color = clWindowText
    ControlLook.DropDownFooter.Font.Height = -13
    ControlLook.DropDownFooter.Font.Name = 'Tahoma'
    ControlLook.DropDownFooter.Font.Style = []
    ControlLook.DropDownFooter.Visible = True
    ControlLook.DropDownFooter.Buttons = <>
    Filter = <>
    FilterDropDown.Font.Charset = DEFAULT_CHARSET
    FilterDropDown.Font.Color = clWindowText
    FilterDropDown.Font.Height = -11
    FilterDropDown.Font.Name = 'Tahoma'
    FilterDropDown.Font.Style = []
    FilterDropDownClear = '(All)'
    FixedColWidth = 300
    FixedRowHeight = 22
    FixedColAlways = True
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -11
    FixedFont.Name = 'Tahoma'
    FixedFont.Style = [fsBold]
    FloatFormat = '%.2f'
    Look = glStandard
    Navigation.AdvanceOnEnter = True
    Navigation.TabToNextAtEnd = True
    PrintSettings.DateFormat = 'dd/mm/yyyy'
    PrintSettings.Font.Charset = DEFAULT_CHARSET
    PrintSettings.Font.Color = clWindowText
    PrintSettings.Font.Height = -11
    PrintSettings.Font.Name = 'Tahoma'
    PrintSettings.Font.Style = []
    PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
    PrintSettings.FixedFont.Color = clWindowText
    PrintSettings.FixedFont.Height = -11
    PrintSettings.FixedFont.Name = 'Tahoma'
    PrintSettings.FixedFont.Style = []
    PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
    PrintSettings.HeaderFont.Color = clWindowText
    PrintSettings.HeaderFont.Height = -11
    PrintSettings.HeaderFont.Name = 'Tahoma'
    PrintSettings.HeaderFont.Style = []
    PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
    PrintSettings.FooterFont.Color = clWindowText
    PrintSettings.FooterFont.Height = -11
    PrintSettings.FooterFont.Name = 'Tahoma'
    PrintSettings.FooterFont.Style = []
    PrintSettings.PageNumSep = '/'
    RowHeaders.Strings = (
      #1055#1088#1110#1079#1074#1080#1097#1077
      #1030#1084#8217#1103
      #1055#1086' '#1073#1072#1090#1100#1082#1086#1074#1110
      #1056#1072#1081#1086#1085' '#1088#1086#1079#1090#1072#1096#1091#1074#1072#1085#1085#1103' '#1085#1072#1074#1095#1072#1083#1100#1085#1086#1075#1086' '#1079#1072#1082#1083#1072#1076#1091
      #1053#1086#1084#1077#1088' '#1095#1080' '#1072#1073#1088#1077#1074#1110#1072#1090#1091#1088#1072' '#1085#1072#1074#1095#1072#1083#1100#1085#1086#1075#1086' '#1079#1072#1082#1083#1072#1076#1091
      #1055#1086#1074#1085#1072' '#1085#1072#1079#1074#1072' '#1085#1072#1074#1095#1072#1083#1100#1085#1086#1075#1086' '#1079#1072#1082#1083#1072#1076#1091
      #1050#1083#1072#1089' ('#1073#1077#1079' '#1083#1110#1090#1077#1088#1080')'
      #1050#1086#1085#1090#1072#1082#1090#1085#1080#1081' '#1090#1077#1083#1077#1092#1086#1085
      #1045#1083#1077#1082#1090#1088#1086#1085#1085#1072' '#1072#1076#1088#1077#1089#1072
      #1053#1086#1084#1077#1088' '#1082#1072#1073#1110#1085#1077#1090#1091
      #1053#1086#1084#1077#1088' '#1082#1086#1084#1087#8217#1102#1090#1077#1088#1072' '#1074' '#1082#1072#1073#1110#1085#1077#1090#1110)
    ScrollWidth = 21
    SearchFooter.Color = clBtnFace
    SearchFooter.FindNextCaption = 'Find &next'
    SearchFooter.FindPrevCaption = 'Find &previous'
    SearchFooter.Font.Charset = DEFAULT_CHARSET
    SearchFooter.Font.Color = clWindowText
    SearchFooter.Font.Height = -11
    SearchFooter.Font.Name = 'Tahoma'
    SearchFooter.Font.Style = []
    SearchFooter.HighLightCaption = 'Highlight'
    SearchFooter.HintClose = 'Close'
    SearchFooter.HintFindNext = 'Find next occurence'
    SearchFooter.HintFindPrev = 'Find previous occurence'
    SearchFooter.HintHighlight = 'Highlight occurences'
    SearchFooter.MatchCaseCaption = 'Match case'
    SelectionColor = clSkyBlue
    SelectionTextColor = clWhite
    ShowDesignHelper = False
    SortSettings.HeaderColor = 16579058
    SortSettings.HeaderColorTo = 16579058
    SortSettings.HeaderMirrorColor = 16380385
    SortSettings.HeaderMirrorColorTo = 16182488
    Version = '6.0.4.4'
    WordWrap = False
    ColWidths = (
      300
      400)
  end
  object memo: TRichEdit
    Left = 481
    Top = 73
    Width = 106
    Height = 117
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    PlainText = True
    TabOrder = 1
    Visible = False
    WordWrap = False
  end
  object savebtn: TButton
    Left = 203
    Top = 265
    Width = 321
    Height = 36
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = []
    Caption = #1047#1073#1077#1088#1077#1075#1090#1080
    Enabled = False
    TabOrder = 2
    OnClick = savebtnClick
  end
end
