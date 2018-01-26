object frmEditorOptions: TfrmEditorOptions
  Left = 493
  Top = 291
  ActiveControl = chxLineNumbers
  BorderIcons = []
  Caption = 'Editor Options'
  ClientHeight = 579
  ClientWidth = 544
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 554
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    544
    579)
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 10
    Top = 9
    Width = 524
    Height = 528
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = tabGutter
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tabEditor: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Editor'
      DesignSize = (
        516
        497)
      object lblActiveLineColour: TLabel
        Left = 4
        Top = 41
        Width = 102
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Active Line Colour'
        FocusControl = cbxActiveLineColour
      end
      object lblEditorFontName: TLabel
        Left = 4
        Top = 76
        Width = 99
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Editor Font &Name'
        FocusControl = cbxFontName
      end
      object lblEditorFontSize: TLabel
        Left = 4
        Top = 110
        Width = 90
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Editor Font &Size'
        FocusControl = edtFontSize
      end
      object lblRightEdgePosition: TLabel
        Left = 4
        Top = 244
        Width = 109
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Right Edge Position'
        FocusControl = edtRightEdge
      end
      object lblRightEdgeColour: TLabel
        Left = 4
        Top = 277
        Width = 102
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Right &Edge Colour'
        FocusControl = cbxRightEdgeColour
      end
      object lblForeColour: TLabel
        Left = 4
        Top = 311
        Width = 149
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Selected Text &Fore Colour'
        FocusControl = cbxSelectedForeground
      end
      object lblBackColour: TLabel
        Left = 4
        Top = 346
        Width = 149
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Selected &Text Back Colour'
        FocusControl = cbxSelectedBackground
      end
      object lblEditorBackgroundColour: TLabel
        Left = 4
        Top = 7
        Width = 144
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Editor &Background Colour'
        FocusControl = cbxEditorBackgroundColour
      end
      object lblTabWidth: TLabel
        Left = 4
        Top = 380
        Width = 116
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Tab &width in Spaces'
        FocusControl = edtTabWidth
      end
      object lblFontColour: TLabel
        Left = 4
        Top = 141
        Width = 66
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Font &Colour'
        FocusControl = cbxFontColour
      end
      object lblMaxScrollWidth: TLabel
        Left = 4
        Top = 412
        Width = 128
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Ma&ximum Scroll Width'
        FocusControl = edtMaxScrollWidth
      end
      object cbxActiveLineColour: TColorBox
        Left = 287
        Top = 38
        Width = 224
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 1
      end
      object cbxFontName: TComboBox
        Left = 287
        Top = 73
        Width = 224
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = csDropDownList
        Anchors = [akTop, akRight]
        Sorted = True
        TabOrder = 2
      end
      object edtFontSize: TEdit
        Left = 287
        Top = 106
        Width = 205
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        TabOrder = 3
        Text = '6'
      end
      object udEditorFontSize: TUpDown
        Left = 492
        Top = 106
        Width = 20
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Associate = edtFontSize
        Min = 6
        Max = 72
        Position = 6
        TabOrder = 4
      end
      object edtRightEdge: TEdit
        Left = 287
        Top = 240
        Width = 205
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        TabOrder = 7
        Text = '0'
      end
      object udRightEdgePosition: TUpDown
        Left = 492
        Top = 240
        Width = 20
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Associate = edtRightEdge
        Max = 1024
        TabOrder = 8
      end
      object cbxRightEdgeColour: TColorBox
        Left = 287
        Top = 273
        Width = 225
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 9
      end
      object cbxSelectedForeground: TColorBox
        Left = 287
        Top = 308
        Width = 225
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 10
      end
      object cbxSelectedBackground: TColorBox
        Left = 287
        Top = 342
        Width = 225
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 11
      end
      object cbxEditorBackgroundColour: TColorBox
        Left = 287
        Top = 4
        Width = 224
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 0
      end
      object edtTabWidth: TEdit
        Left = 288
        Top = 377
        Width = 205
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        TabOrder = 12
        Text = '1'
      end
      object udTabWidth: TUpDown
        Left = 493
        Top = 377
        Width = 20
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Associate = edtTabWidth
        Min = 1
        Max = 8
        Position = 1
        TabOrder = 13
      end
      object chkWordWrap: TCheckBox
        Left = 5
        Top = 470
        Width = 507
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Word Wrap text in editor'
        TabOrder = 17
      end
      object cbxFontColour: TColorBox
        Left = 288
        Top = 138
        Width = 224
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 5
      end
      object gbxFontStyle: TGroupBox
        Left = 3
        Top = 167
        Width = 502
        Height = 66
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Font Style'
        TabOrder = 6
        object chkBold: TCheckBox
          Left = 13
          Top = 32
          Width = 97
          Height = 17
          Caption = '&Bold'
          TabOrder = 0
        end
        object chkItalics: TCheckBox
          Left = 136
          Top = 32
          Width = 97
          Height = 17
          Caption = '&Italics'
          TabOrder = 1
        end
        object chkUnderline: TCheckBox
          Left = 263
          Top = 32
          Width = 97
          Height = 17
          Caption = '&Underline'
          TabOrder = 2
        end
        object chkStrikeout: TCheckBox
          Left = 392
          Top = 32
          Width = 97
          Height = 17
          Caption = '&Strikeout'
          TabOrder = 3
        end
      end
      object chkWantTabs: TCheckBox
        Left = 5
        Top = 441
        Width = 507
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Want Tabs'
        TabOrder = 16
      end
      object edtMaxScrollWidth: TEdit
        Left = 287
        Top = 409
        Width = 205
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        TabOrder = 14
        Text = '80'
      end
      object udMaxScrollWidth: TUpDown
        Left = 492
        Top = 409
        Width = 20
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Associate = edtMaxScrollWidth
        Min = 80
        Max = 65535
        Position = 80
        TabOrder = 15
      end
    end
    object tabGutter: TTabSheet
      Caption = 'Gutter'
      ImageIndex = 4
      DesignSize = (
        516
        497)
      object chxLineNumbers: TCheckBox
        Left = 4
        Top = 299
        Width = 507
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'S&how Line Numbers in the Editor Gutter'
        TabOrder = 0
      end
    end
    object tabBehaviour: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Behaviour'
      ImageIndex = 1
      DesignSize = (
        516
        497)
      object clbOptions: TCheckListBox
        Left = 4
        Top = 4
        Width = 507
        Height = 486
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
      end
    end
    object tabCommands: TTabSheet
      Caption = '&Commands'
      ImageIndex = 3
    end
    object tabSyntax: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Syntax Highlighting'
      ImageIndex = 2
      DesignSize = (
        516
        497)
      object lblAttrForeColour: TLabel
        Left = 322
        Top = 49
        Width = 160
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akTop, akRight]
        Caption = 'Attribute &Foreground Colour'
        FocusControl = cbxAttrForeColour
      end
      object lblAttrBackColour: TLabel
        Left = 327
        Top = 107
        Width = 160
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akTop, akRight]
        Caption = 'Attribute Background &Colour'
        FocusControl = cbxAttrBackColour
      end
      object lblAttributes: TLabel
        Left = 4
        Top = 46
        Width = 55
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = '&Attributes'
        FocusControl = lbAttributes
      end
      object lblHighlighterType: TLabel
        Left = 4
        Top = 4
        Width = 508
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'No Highligher Available'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lbAttributes: TListBox
        Left = 4
        Top = 69
        Width = 311
        Height = 421
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        OnClick = lbAttributesClick
      end
      object cbxAttrForeColour: TColorBox
        Left = 322
        Top = 73
        Width = 189
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 1
        OnChange = AttributeChange
      end
      object cbxAttrBackColour: TColorBox
        Left = 322
        Top = 128
        Width = 189
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 2
        OnChange = AttributeChange
      end
      object grpFontStyles: TGroupBox
        Left = 322
        Top = 162
        Width = 189
        Height = 328
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight, akBottom]
        Caption = 'Attribute Font Styles'
        TabOrder = 3
        object cbxBold: TCheckBox
          Left = 10
          Top = 30
          Width = 119
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Bold'
          TabOrder = 0
          OnClick = AttributeChange
        end
        object cbxItalic: TCheckBox
          Left = 10
          Top = 59
          Width = 119
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Italic'
          TabOrder = 1
          OnClick = AttributeChange
        end
        object cbxUnderlined: TCheckBox
          Left = 10
          Top = 89
          Width = 119
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Underlined'
          TabOrder = 2
          OnClick = AttributeChange
        end
        object cbxStrikeout: TCheckBox
          Left = 10
          Top = 118
          Width = 119
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Strikeout'
          TabOrder = 3
          OnClick = AttributeChange
        end
      end
    end
  end
  object btnOK: TBitBtn
    Left = 377
    Top = 545
    Width = 75
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
  object btnCancel: TBitBtn
    Left = 460
    Top = 545
    Width = 75
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
