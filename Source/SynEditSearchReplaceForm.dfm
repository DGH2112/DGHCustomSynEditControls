object frmSearchAndReplace: TfrmSearchAndReplace
  Left = 476
  Top = 333
  BorderStyle = bsDialog
  Caption = 'Search and Replace'
  ClientHeight = 347
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    469
    347)
  PixelsPerInch = 96
  TextHeight = 16
  object lblTextToFind: TLabel
    Left = 9
    Top = 12
    Width = 64
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = '&Text to find'
    FocusControl = cbxSearch
  end
  object lblReplaceWith: TLabel
    Left = 9
    Top = 44
    Width = 77
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = '&Replace with'
    FocusControl = cbxReplace
  end
  object cbxSearch: TComboBox
    Left = 122
    Top = 9
    Width = 338
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object cbxReplace: TComboBox
    Left = 122
    Top = 41
    Width = 338
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object gbxOptions: TGroupBox
    Left = 9
    Top = 73
    Width = 232
    Height = 139
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Options:'
    TabOrder = 2
    object cbxCaseSensitive: TCheckBox
      Left = 15
      Top = 21
      Width = 129
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Case sensitive'
      TabOrder = 0
    end
    object cbxWholeWordsOnly: TCheckBox
      Left = 15
      Top = 50
      Width = 139
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Whole words only'
      TabOrder = 1
    end
    object cbxRegularExpressions: TCheckBox
      Left = 15
      Top = 79
      Width = 144
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Regular e&xpressions'
      TabOrder = 2
    end
    object cbxPrompt: TCheckBox
      Left = 15
      Top = 108
      Width = 149
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Prompt for replace'
      TabOrder = 3
    end
  end
  object btnOK: TBitBtn
    Left = 167
    Top = 308
    Width = 92
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 7
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 267
    Top = 308
    Width = 92
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 8
  end
  object grpDirection: TGroupBox
    Left = 251
    Top = 73
    Width = 209
    Height = 139
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Direction:'
    TabOrder = 4
    DesignSize = (
      209
      139)
    object rbtnForward: TRadioButton
      Left = 16
      Top = 21
      Width = 190
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Forwar&d'
      TabOrder = 0
    end
    object rbtnBackward: TRadioButton
      Left = 15
      Top = 50
      Width = 190
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight]
      Caption = '&Backward'
      TabOrder = 1
    end
  end
  object rgrpScope: TRadioGroup
    Left = 10
    Top = 223
    Width = 232
    Height = 79
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Scope:'
    Items.Strings = (
      '&Global'
      '&Selected text')
    TabOrder = 3
  end
  object rgrpOrigin: TRadioGroup
    Left = 250
    Top = 223
    Width = 209
    Height = 79
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Origin:'
    Items.Strings = (
      '&From cursor'
      '&Entire scope')
    TabOrder = 5
  end
  object btnReplaceAll: TBitBtn
    Left = 37
    Top = 308
    Width = 122
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Caption = 'Replace &All'
    Kind = bkAll
    NumGlyphs = 2
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnHelp: TBitBtn
    Left = 367
    Top = 308
    Width = 93
    Height = 30
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Kind = bkHelp
    NumGlyphs = 2
    TabOrder = 9
  end
end
