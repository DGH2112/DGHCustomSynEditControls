object frmEditorOptions: TfrmEditorOptions
  Left = 493
  Top = 291
  ActiveControl = chkAutoSize
  BorderIcons = []
  Caption = 'Editor Options'
  ClientHeight = 590
  ClientWidth = 484
  Color = clBtnFace
  Constraints.MinHeight = 625
  Constraints.MinWidth = 500
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    484
    590)
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 10
    Top = 9
    Width = 464
    Height = 539
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = tabGutter
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    ExplicitWidth = 524
    ExplicitHeight = 528
    object tabEditor: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Editor'
      ExplicitWidth = 516
      ExplicitHeight = 497
      DesignSize = (
        456
        508)
      object lblActiveLineColour: TLabel
        Left = 4
        Top = 41
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = '&Active Line Colour'
        FocusControl = cbxActiveLineColour
      end
      object lblEditorFontName: TLabel
        Left = 4
        Top = 76
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Editor Font &Name'
        FocusControl = cbxFontName
      end
      object lblEditorFontSize: TLabel
        Left = 4
        Top = 110
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Editor Font &Size'
        FocusControl = edtFontSize
      end
      object lblRightEdgePosition: TLabel
        Left = 4
        Top = 244
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = '&Right Edge Position'
        FocusControl = edtRightEdge
      end
      object lblRightEdgeColour: TLabel
        Left = 4
        Top = 277
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Right &Edge Colour'
        FocusControl = cbxRightEdgeColour
      end
      object lblForeColour: TLabel
        Left = 4
        Top = 311
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Selected Text &Fore Colour'
        FocusControl = cbxSelectedForeground
      end
      object lblBackColour: TLabel
        Left = 4
        Top = 346
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Selected &Text Back Colour'
        FocusControl = cbxSelectedBackground
      end
      object lblEditorBackgroundColour: TLabel
        Left = 4
        Top = 7
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Editor &Background Colour'
        FocusControl = cbxEditorBackgroundColour
      end
      object lblTabWidth: TLabel
        Left = 4
        Top = 380
        Width = 216
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Tab &width in Spaces'
        FocusControl = edtTabWidth
      end
      object lblFontColour: TLabel
        Left = 4
        Top = 141
        Width = 216
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Font &Colour'
        FocusControl = cbxFontColour
      end
      object lblMaxScrollWidth: TLabel
        Left = 4
        Top = 412
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Ma&ximum Scroll Width'
        FocusControl = edtMaxScrollWidth
      end
      object cbxActiveLineColour: TColorBox
        Left = 227
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
        ExplicitLeft = 287
      end
      object cbxFontName: TComboBox
        Left = 227
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
        ExplicitLeft = 287
      end
      object edtFontSize: TEdit
        Left = 227
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
        ExplicitLeft = 287
      end
      object udEditorFontSize: TUpDown
        Left = 432
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
        ExplicitLeft = 492
      end
      object edtRightEdge: TEdit
        Left = 227
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
        ExplicitLeft = 287
      end
      object udRightEdgePosition: TUpDown
        Left = 432
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
        ExplicitLeft = 492
      end
      object cbxRightEdgeColour: TColorBox
        Left = 227
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
        ExplicitLeft = 287
      end
      object cbxSelectedForeground: TColorBox
        Left = 227
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
        ExplicitLeft = 287
      end
      object cbxSelectedBackground: TColorBox
        Left = 227
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
        ExplicitLeft = 287
      end
      object cbxEditorBackgroundColour: TColorBox
        Left = 227
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
        ExplicitLeft = 287
      end
      object edtTabWidth: TEdit
        Left = 228
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
        ExplicitLeft = 288
      end
      object udTabWidth: TUpDown
        Left = 433
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
        ExplicitLeft = 493
      end
      object chkWordWrap: TCheckBox
        Left = 5
        Top = 470
        Width = 447
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Word Wrap text in editor'
        TabOrder = 17
        ExplicitWidth = 507
      end
      object cbxFontColour: TColorBox
        Left = 228
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
        ExplicitLeft = 288
      end
      object gbxFontStyle: TGroupBox
        Left = 3
        Top = 167
        Width = 442
        Height = 66
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Font Style'
        TabOrder = 6
        ExplicitWidth = 502
        object gpnlFontStyles: TGridPanel
          AlignWithMargins = True
          Left = 5
          Top = 21
          Width = 432
          Height = 40
          Align = alClient
          ColumnCollection = <
            item
              Value = 24.999999773201270000
            end
            item
              Value = 24.999999773201280000
            end
            item
              Value = 24.999999993075410000
            end
            item
              Value = 25.000000460522050000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = chkBold
              Row = 0
            end
            item
              Column = 1
              Control = chkItalics
              Row = 0
            end
            item
              Column = 2
              Control = chkStrikeout
              Row = 0
            end
            item
              Column = 3
              Control = chkUnderline
              Row = 0
            end>
          RowCollection = <
            item
              Value = 100.000000000000000000
            end>
          TabOrder = 0
          ExplicitLeft = 8
          ExplicitTop = 25
          ExplicitWidth = 289
          ExplicitHeight = 41
          DesignSize = (
            432
            40)
          object chkBold: TCheckBox
            Left = 19
            Top = 11
            Width = 71
            Height = 17
            Anchors = []
            Caption = '&Bold'
            TabOrder = 0
            ExplicitLeft = 1
            ExplicitTop = 12
          end
          object chkItalics: TCheckBox
            Left = 126
            Top = 11
            Width = 71
            Height = 17
            Anchors = []
            Caption = '&Italics'
            TabOrder = 1
            ExplicitLeft = 72
            ExplicitTop = 12
          end
          object chkStrikeout: TCheckBox
            Left = 233
            Top = 11
            Width = 71
            Height = 17
            Anchors = []
            Caption = '&Strikeout'
            TabOrder = 2
            ExplicitLeft = 143
            ExplicitTop = 12
          end
          object chkUnderline: TCheckBox
            Left = 339
            Top = 11
            Width = 74
            Height = 17
            Anchors = []
            Caption = '&Underline'
            TabOrder = 3
            ExplicitLeft = 214
            ExplicitTop = 12
          end
        end
      end
      object chkWantTabs: TCheckBox
        Left = 5
        Top = 441
        Width = 447
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Want Tabs'
        TabOrder = 16
        ExplicitWidth = 507
      end
      object edtMaxScrollWidth: TEdit
        Left = 227
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
        ExplicitLeft = 287
      end
      object udMaxScrollWidth: TUpDown
        Left = 432
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
        ExplicitLeft = 492
      end
    end
    object tabGutter: TTabSheet
      Caption = 'Gutter'
      ImageIndex = 4
      ExplicitWidth = 516
      ExplicitHeight = 497
      DesignSize = (
        456
        508)
      object lblModifiedColour: TLabel
        Left = 4
        Top = 186
        Width = 216
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Modified Line Colour'
        FocusControl = cbxModifiedColour
      end
      object lblSavedColour: TLabel
        Left = 4
        Top = 216
        Width = 216
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Saved Line Colour'
        FocusControl = cbxSavedColour
      end
      object lblModifiedBarWidth: TLabel
        Left = 5
        Top = 247
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Modified Line Bar &Width'
        FocusControl = edtModifiedBarWidth
      end
      object lblGutterColour: TLabel
        Left = 4
        Top = 68
        Width = 216
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Gutter Colour'
        FocusControl = cbxGutterColour
      end
      object lblGutterBorderColour: TLabel
        Left = 4
        Top = 98
        Width = 216
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Gutter Border Colour'
        FocusControl = cbxGutterBorderColour
      end
      object lblGutterWidth: TLabel
        Left = 4
        Top = 37
        Width = 215
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Caption = 'Gutter Width'
        FocusControl = edtGutterWidth
      end
      object chxLineNumbers: TCheckBox
        Left = 4
        Top = 302
        Width = 447
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'S&how Line Numbers in the Editor Gutter'
        TabOrder = 10
        ExplicitWidth = 507
      end
      object chkAutoSize: TCheckBox
        Left = 4
        Top = 4
        Width = 447
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Auto Size Editor Gutter'
        TabOrder = 0
        ExplicitWidth = 507
      end
      object chkShowModifications: TCheckBox
        Left = 4
        Top = 125
        Width = 447
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Caption = 'S&how Line Modifications in the Editor Gutter'
        TabOrder = 5
        ExplicitWidth = 507
      end
      object cbxModifiedColour: TColorBox
        Left = 228
        Top = 183
        Width = 224
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 6
        ExplicitLeft = 288
      end
      object cbxSavedColour: TColorBox
        Left = 228
        Top = 213
        Width = 224
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 7
        ExplicitLeft = 288
      end
      object upModifiedBarWidth: TUpDown
        Left = 433
        Top = 243
        Width = 20
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Associate = edtModifiedBarWidth
        Max = 1024
        TabOrder = 9
        ExplicitLeft = 493
      end
      object edtModifiedBarWidth: TEdit
        Left = 228
        Top = 243
        Width = 205
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        TabOrder = 8
        Text = '0'
        ExplicitLeft = 288
      end
      object cbxGutterColour: TColorBox
        Left = 228
        Top = 65
        Width = 224
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 3
        ExplicitLeft = 288
      end
      object cbxGutterBorderColour: TColorBox
        Left = 228
        Top = 95
        Width = 224
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
        Anchors = [akTop, akRight]
        TabOrder = 4
        ExplicitLeft = 288
      end
      object edtGutterWidth: TEdit
        Left = 227
        Top = 33
        Width = 205
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        TabOrder = 1
        Text = '0'
        ExplicitLeft = 287
      end
      object udGutterWidth: TUpDown
        Left = 432
        Top = 33
        Width = 16
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Associate = edtGutterWidth
        Max = 1024
        TabOrder = 2
        ExplicitLeft = 492
      end
    end
    object tabBehaviour: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Behaviour'
      ImageIndex = 1
      ExplicitWidth = 516
      ExplicitHeight = 497
      DesignSize = (
        456
        508)
      object clbOptions: TCheckListBox
        Left = 4
        Top = 4
        Width = 447
        Height = 497
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        ExplicitWidth = 507
        ExplicitHeight = 486
      end
    end
    object tabCommands: TTabSheet
      Caption = '&Commands'
      ImageIndex = 3
      ExplicitWidth = 516
      ExplicitHeight = 497
    end
    object tabSyntax: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Syntax Highlighting'
      ImageIndex = 2
      ExplicitWidth = 516
      ExplicitHeight = 497
      DesignSize = (
        456
        508)
      object lblAttrForeColour: TLabel
        Left = 262
        Top = 49
        Width = 160
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akTop, akRight]
        Caption = 'Attribute &Foreground Colour'
        FocusControl = cbxAttrForeColour
        ExplicitLeft = 322
      end
      object lblAttrBackColour: TLabel
        Left = 267
        Top = 107
        Width = 160
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Anchors = [akTop, akRight]
        Caption = 'Attribute Background &Colour'
        FocusControl = cbxAttrBackColour
        ExplicitLeft = 327
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
        Width = 448
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
        ExplicitWidth = 508
      end
      object lbAttributes: TListBox
        Left = 4
        Top = 69
        Width = 251
        Height = 432
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        OnClick = lbAttributesClick
        ExplicitWidth = 311
        ExplicitHeight = 421
      end
      object cbxAttrForeColour: TColorBox
        Left = 262
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
        ExplicitLeft = 322
      end
      object cbxAttrBackColour: TColorBox
        Left = 262
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
        ExplicitLeft = 322
      end
      object grpFontStyles: TGroupBox
        Left = 262
        Top = 162
        Width = 189
        Height = 339
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight, akBottom]
        Caption = 'Attribute Font Styles'
        TabOrder = 3
        ExplicitLeft = 322
        ExplicitHeight = 328
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
    Left = 317
    Top = 556
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
    ExplicitLeft = 377
    ExplicitTop = 545
  end
  object btnCancel: TBitBtn
    Left = 400
    Top = 556
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
    ExplicitLeft = 460
    ExplicitTop = 545
  end
end
