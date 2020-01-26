object solfrm: Tsolfrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1055#1077#1088#1077#1075#1083#1103#1076' '#1079#1076#1072#1085#1086#1075#1086' '#1088#1086#1079#1074#8217#1103#1079#1082#1091
  ClientHeight = 613
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
  DesignSize = (
    727
    613)
  PixelsPerInch = 120
  TextHeight = 17
  object HTMLabel1: THTMLabel
    Left = 21
    Top = 11
    Width = 57
    Height = 17
    AutoSizing = True
    AutoSizeType = asHorizontal
    HTMLText.Strings = (
      #1047#1072#1076#1072#1095#1072':')
    Transparent = True
    Version = '1.8.3.4'
  end
  object HTMLabel2: THTMLabel
    Left = 21
    Top = 37
    Width = 105
    Height = 17
    AutoSizing = True
    AutoSizeType = asHorizontal
    HTMLText.Strings = (
      #1058#1077#1089#1090#1080' '#1079' '#1091#1084#1086#1074#1080':')
    Transparent = True
    Version = '1.8.3.4'
  end
  object HTMLabel3: THTMLabel
    Left = 21
    Top = 63
    Width = 71
    Height = 17
    AutoSizing = True
    AutoSizeType = asHorizontal
    HTMLText.Strings = (
      #1063#1072#1089' '#1079#1076#1072#1095#1110':')
    Transparent = True
    Version = '1.8.3.4'
  end
  object HTMLabel4: THTMLabel
    Left = 21
    Top = 89
    Width = 87
    Height = 17
    AutoSizing = True
    AutoSizeType = asHorizontal
    HTMLText.Strings = (
      #1050#1086#1084#1087#1110#1083#1103#1090#1086#1088':')
    Transparent = True
    Version = '1.8.3.4'
  end
  object HTMLabel5: THTMLabel
    Left = 21
    Top = 115
    Width = 131
    Height = 17
    AutoSizing = True
    AutoSizeType = asHorizontal
    HTMLText.Strings = (
      #1060#1072#1081#1083' '#1110#1079' '#1088#1086#1079#1074#8217#1103#1079#1082#1086#1084':')
    Transparent = True
    Version = '1.8.3.4'
  end
  object panel: TPanel
    Left = 12
    Top = 150
    Width = 703
    Height = 450
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      703
      450)
    object memo: TSynEdit
      Left = 1
      Top = 1
      Width = 700
      Height = 447
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Pitch = fpFixed
      Font.Style = []
      TabOrder = 0
      BorderStyle = bsNone
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -13
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.LeftOffset = 0
      Gutter.ShowLineNumbers = True
      Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
      ReadOnly = True
      FontSmoothing = fsmNone
    end
  end
  object cppsyn: TSynCppSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 432
    Top = 328
  end
  object passyn: TSynPasSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 408
    Top = 416
  end
end
