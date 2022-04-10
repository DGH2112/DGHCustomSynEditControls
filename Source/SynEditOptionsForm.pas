(**

  This module contains a for editing the visual, behavioural and highlighting
  properties of a currently configured TSynEdit editor.

  @Version 2.316
  @Author  David Hoyle
  @Date    10 Apr 2022

**)
Unit SynEditOptionsForm;

Interface

Uses
  System.Classes,
  System.SysUtils,
  System.Variants,
  System.Contnrs,
  System.Generics.Collections,
  VCL.Graphics,
  VCL.Controls,
  VCL.Forms,
  VCL.Dialogs,
  VCL.ComCtrls,
  VCL.StdCtrls,
  VCL.ExtCtrls,
  VCL.Buttons,
  VCL.CheckLst,
  WinApi.Windows,
  WinAPI.Messages,
  SynEdit,
  SynEditKeyCmds,
  SynEditHighlighter;

Type
  (** This is a private class to hold information about each highlighter
      attribute. **)
  TAttribute = Class
  Strict Private
    FForeColour : TColor;
    FBackColour : TColor;
    FStyle      : TFontStyles;
    FName       : String;
    FAttribute  : TSynHighlighterAttributes;
    FParent     : TSynCustomHighlighter;
  Strict Protected
  Public
    Constructor Create(Const Name: String; Const Fore, Back: TColor; Const Style: TFontStyles;
      Const Attr : TSynHighlighterAttributes; Const Parent : TSynCustomHighlighter);
    (**
      This property reads and writes the Attribute Name
      @precon  None
      @postcon Reads and writes the Attribute Name
      @return  a String
    **)
    Property Name : String Read FName Write FName;
    (**
      This property reads and writes the Attribute ForeColour
      @precon  None
      @postcon Reads and writes the Attribute ForeColour
      @return  a TColor
    **)
    Property ForeColour : TColor Read FForeColour Write FForeColour;
    (**
      This property reads and writes the Attribute BackColour
      @precon  None
      @postcon Reads and writes the Attribute BackColour
      @return  a TColor
    **)
    Property BackColour : TColor Read FBackColour Write FBackColour;
    (**
      This property reads and writes the Attribute Style
      @precon  None
      @postcon Reads and writes the Attribute Style
      @return  a TFontStyles
    **)
    Property Style : TFontStyles Read FStyle Write FStyle;
    (**
      This property reads and writes the referenced TSynHighlighterAttributes
      @precon  None
      @postcon Reads and writes the referenced TSynHighlighterAttributes
      @return  a TSynHighlighterAttributes
    **)
    Property Attribute : TSynHighlighterAttributes Read FAttribute Write FAttribute;
    (**
      This property reads and writes the Parent Highlighter
      @precon  None
      @postcon Reads and writes the Parent Highlighter
      @return  a TSynCustomHighlighter
    **)
    Property Parent : TSynCustomHighlighter Read FParent Write FParent;
  End;

  (** A class to represent a collection of attributes. **)
  TAttributes = Class
  Private
    FAttributes     : TObjectList;
    FProcessedAttrs : TList;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function Add(Const Attr : TSynHighlighterAttributes;
      Const Parent : TSynCustomHighlighter) : TAttribute;
    Procedure Update(Const boolIncTags : Boolean);
  End;

  (** This class represents the form interface for editing the editor
      options. **)
  TfrmEditorOptions = Class(TForm)
    PageControl1: TPageControl;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    tabEditor: TTabSheet;
    cbxActiveLineColour: TColorBox;
    lblActiveLineColour: TLabel;
    tabBehaviour: TTabSheet;
    cbxFontName: TComboBox;
    edtFontSize: TEdit;
    udEditorFontSize: TUpDown;
    chxLineNumbers: TCheckBox;
    edtRightEdge: TEdit;
    udRightEdgePosition: TUpDown;
    cbxRightEdgeColour: TColorBox;
    cbxSelectedForeground: TColorBox;
    cbxSelectedBackground: TColorBox;
    tabSyntax: TTabSheet;
    lblEditorFontName: TLabel;
    lblEditorFontSize: TLabel;
    lblRightEdgePosition: TLabel;
    lblRightEdgeColour: TLabel;
    lblForeColour: TLabel;
    lblBackColour: TLabel;
    clbOptions: TCheckListBox;
    cbxEditorBackgroundColour: TColorBox;
    lblEditorBackgroundColour: TLabel;
    lbAttributes: TListBox;
    cbxAttrForeColour: TColorBox;
    cbxAttrBackColour: TColorBox;
    lblAttrForeColour: TLabel;
    lblAttrBackColour: TLabel;
    grpFontStyles: TGroupBox;
    cbxBold: TCheckBox;
    cbxItalic: TCheckBox;
    cbxUnderlined: TCheckBox;
    cbxStrikeout: TCheckBox;
    lblTabWidth: TLabel;
    edtTabWidth: TEdit;
    udTabWidth: TUpDown;
    lblAttributes: TLabel;
    lblHighlighterType: TLabel;
    chkWordWrap: TCheckBox;
    cbxFontColour: TColorBox;
    lblFontColour: TLabel;
    gbxFontStyle: TGroupBox;
    chkBold: TCheckBox;
    chkItalics: TCheckBox;
    chkUnderline: TCheckBox;
    chkStrikeout: TCheckBox;
    chkWantTabs: TCheckBox;
    tabCommands: TTabSheet;
    tabGutter: TTabSheet;
    edtMaxScrollWidth: TEdit;
    lblMaxScrollWidth: TLabel;
    udMaxScrollWidth: TUpDown;
    chkAutoSize: TCheckBox;
    chkShowModifications: TCheckBox;
    cbxModifiedColour: TColorBox;
    lblModifiedColour: TLabel;
    cbxSavedColour: TColorBox;
    lblSavedColour: TLabel;
    upModifiedBarWidth: TUpDown;
    edtModifiedBarWidth: TEdit;
    lblModifiedBarWidth: TLabel;
    cbxGutterColour: TColorBox;
    lblGutterColour: TLabel;
    cbxGutterBorderColour: TColorBox;
    lblGutterBorderColour: TLabel;
    edtGutterWidth: TEdit;
    udGutterWidth: TUpDown;
    lblGutterWidth: TLabel;
    gpnlFontStyles: TGridPanel;
    lvKeyStrokes: TListView;
    chkShowGutter: TCheckBox;
    chkUseEditorFont: TCheckBox;
    cbxGutterFontName: TComboBox;
    gbxGutterFontStyle: TGroupBox;
    gpnlGutterFontStyles: TGridPanel;
    chkGutterFontBold: TCheckBox;
    chkGutterFontItalic: TCheckBox;
    chkGutterFontUnderline: TCheckBox;
    chkGutterFontStrikeout: TCheckBox;
    cbxGutterFontColour: TColorBox;
    udGutterFontSize: TUpDown;
    edtGutterFontSize: TEdit;
    lblGutterFontName: TLabel;
    lblGutterFontSize: TLabel;
    lblGutterFontColour: TLabel;
    cbxModifiedSavedColour: TColorBox;
    lblModifiedSavedLineColour: TLabel;
    cbxOriginalLineColour: TColorBox;
    lblOriginalLineColour: TLabel;
    chkShowLeadingZeros: TCheckBox;
    edtStartLineNumber: TEdit;
    udStartLineNumber: TUpDown;
    lblStartLineNumber: TLabel;
    Procedure lbAttributesClick(Sender: TObject);
    Procedure AttributeChange(Sender: TObject);
    procedure lbAttributesDrawItem(Sender: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
  Private
    { Private declarations }
    FAttributes : TAttributes;
    FUpdating : Boolean;
    Procedure AddHighlighter(Const Highlighter : TSynCustomHighlighter);
    Procedure InitialiseDlg(Const Editor: TSynEdit);
    Procedure InitialiseEditor(Const Editor: TSynEdit);
    Procedure InitialiseGutter(Const Editor: TSynEdit);
    Procedure InitialiseBehaviour(Const Editor: TSynEdit);
    Procedure InitialiseHighlighter(Const Editor: TSynEdit);
    Procedure FinaliseDlg(Const Editor: TSynEdit; Const boolIncTag: Boolean);
    Procedure FinaliseEditor(Const Editor: TSynEdit);
    Procedure FinaliseGutter(Const Editor: TSynEdit);
    Procedure FinaliseBehaviour(Const Editor: TSynEdit);
    Procedure FinaliseHighlighter(Const boolIncTag : Boolean);
  Public
    { Public declarations }
    Constructor Create(AOwner : TComponent); Override;
    Destructor Destroy; Override;
    Class Function Execute(Const OwnerForm : TForm; Const Editor : TSynEdit;
      Const boolIncTag : Boolean) : Boolean;
  End;

Implementation

{$R *.dfm}

Uses
  {$IFDEF CODESITE}
  CodeSiteLogging,
  {$ENDIF}
  System.UITypes,
  System.TypInfo,
  System.Types,
  VCL.Menus,
  VCL.Themes,
  SynHighlighterMulti;

Type
  (** A record to describe descriptions for each TSynEditorOption. **)
  TSynEditorOptionsRecord = Record
    Description : String;
    Value : TSynEditorOption;
  End;

Const
  (** A constant array of records to place descriptions against each of the
      TSynEditorOption. Use to provide an list of options. **)
  BehaviouralOptions : Array[TSynEditorOption] Of
    TSynEditorOptionsRecord = (
    (Description : '<Alt> key invokes Column Selection Mode'; Value: eoAltSetsColumnMode),               //eoAltSetsColumnMode,       //Holding down the Alt Key will put the selection mode into columnar format
    (Description : 'Auto Indent';                             Value: eoAutoIndent),                      //eoAutoIndent,              //Will indent the caret on new lines with the same amount of leading white space as the preceding line
    (Description : 'Disable Scroll Arrows';                   Value: eoDisableScrollArrows),             //eoDisableScrollArrows,     //Disables the scroll bar arrow buttons when you can't scroll in that direction any more     
    (Description : 'Drag and Drop Editing';                   Value: eoDragDropEditing),                 //eoDragDropEditing,         //Allows you to select a block of text and drag it within the document to another location     
    (Description : 'Drag and Drop Files';                     Value: eoDropFiles),                       //eoDropFiles,               //Allows the editor accept OLE file drops     
    (Description : 'Enhanced Home Key';                       Value: eoEnhanceHomeKey),                  //eoEnhanceHomeKey,          //enhances home key positioning, similar to visual studio     
    (Description : 'Enhanced End key';                        Value: eoEnhanceEndKey),                   //eoEnhanceEndKey,           //enhances End key positioning, similar to JDeveloper     
    (Description : 'Group Undo';                              Value: eoGroupUndo),                       //eoGroupUndo,               //When undoing/redoing actions, handle all continous changes of the same kind in one call instead undoing/redoing each command separately     
    (Description : 'Half Page Scroll';                        Value: eoHalfPageScroll),                  //eoHalfPageScroll,          //When scrolling with page-up and page-down commands, only scroll a half page at a time     
    (Description : 'Hide and Show Scroll Bars';               Value: eoHideShowScrollbars),              //eoHideShowScrollbars,      //if enabled, then the scrollbars will only show when necessary.  If you have ScrollPastEOL, then it the horizontal bar will always be there (it uses MaxLength instead)     
    (Description : 'Keep Caret X';                            Value: eoKeepCaretX),                      //eoKeepCaretX,              //When moving through lines w/o Cursor Past EOL, keeps the X position of the cursor     
    (Description : 'No Caret';                                Value: eoNoCaret),                         //eoNoCaret,                 //Makes it so the caret is never visible     
    (Description : 'No Selection';                            Value: eoNoSelection),                     //eoNoSelection,             //Disables selecting text     
    (Description : 'Right Mouse Moves Cursor';                Value: eoRightMouseMovesCursor),           //eoRightMouseMovesCursor,   //When clicking with the right mouse for a popup menu, move the cursor to that location     
    (Description : 'Scroll By One Less';                      Value: eoScrollByOneLess),                 //eoScrollByOneLess,         //Forces scrolling to be one less     
    (Description : 'Scroll Hint Follows';                     Value: eoScrollHintFollows),               //eoScrollHintFollows,       //The scroll hint follows the mouse when scrolling vertically     
    (Description : 'Scroll Past End of File';                 Value: eoScrollPastEof),                   //eoScrollPastEof,           //Allows the cursor to go past the end of file marker     
    (Description : 'Scroll Past End of Line';                 Value: eoScrollPastEol),                   //eoScrollPastEol,           //Allows the cursor to go past the last character into the white space at the end of a line     
    (Description : 'Show Scroll Hints';                       Value: eoShowScrollHint),                  //eoShowScrollHint,          //Shows a hint of the visible line numbers when scrolling vertically     
    (Description : 'Show Special Characters';                 Value: eoShowSpecialChars),                //eoShowSpecialChars,        //Shows the special Characters     
    (Description : 'Smart Tab Delete';                        Value: eoSmartTabDelete),                  //eoSmartTabDelete,          //similar to Smart Tabs, but when you delete characters     
    (Description : 'Smart Tabs';                              Value: eoSmartTabs),                       //eoSmartTabs,               //When tabbing, the cursor will go to the next non-white space character of the previous line     
    (Description : 'Special Line Default FG';                 Value: eoSpecialLineDefaultFg),            //eoSpecialLineDefaultFg,    //disables the foreground text color override when using the OnSpecialLineColor event     
    (Description : 'Tab Indent';                              Value: eoTabIndent),                       //eoTabIndent,               //When active <Tab> and <Shift><Tab> act as block indent, unindent when text is selected     
    (Description : 'Tabs to Spaces';                          Value: eoTabsToSpaces),                    //eoTabsToSpaces,            //Converts a tab character to a specified number of space characters     
    (Description : 'Trim Trailing Spaces';                    Value: eoTrimTrailingSpaces),              //eoTrimTrailingSpaces,      //Spaces at the end of lines will be trimmed and not saved     
    (Description : 'Show Ligatures';                          Value: eoShowLigatures),                   //eoShowLigatures,           //Shows font ligatures, by default it is disabled     
    (Description : 'Copy Plain Text';                         Value: eoCopyPlainText),                   //eoCopyPlainText,           //Do not include additional clipboard formats when you copy to Clipboard or drag text
    (Description : 'Wrap with Right Edge';                    Value: eoWrapWithRightEdge)                //eoWrapWithRightEdge        //WordWrap with RightEdge position instead of the whole text area
  );                                                                                                     
                                                                                                              
Var                                                                                                      
  (** A private variable to give the EnumFontProc access to the Combo Box. **)
  FontNames : TComboBox;

(**

  An enumeration procedure for extracting fixed width fonts.

  @precon  None.
  @postcon Adds fixed width fonts to the combo box.

  @nohint  TextMetric lParam

  @param   LogFont    as a PEnumLogFontEx as a constant
  @param   TextMetric as a PNewTextMetric as a constant
  @param   FontType   as an Integer as a constant
  @param   lParam     as a lParam as a constant
  @return  an Integer

**)
Function FontEnumExProc(Const LogFont : PEnumLogFontEx; Const TextMetric : PNewTextMetric; //FI:O804
  Const FontType: Integer; Const lParam: lParam): Integer; StdCall; //FI:O804

Var
  S : String;
  ELF : TEnumLogFontEx;

Begin
  ELF := TEnumLogFontEx(LogFont^);
  If ELF.elfLogFont.lfPitchAndFamily And FIXED_PITCH > 0 Then
    Begin
      S := ELF.elfLogFont.lfFaceName;
      If FontNames.Items.IndexOf(S) = -1 Then
        FontNames.Items.AddObject(S, TObject(FontType));
    End;
  Result := 1;
End;

(**

  This is the constructor method for the TAttribute class.

  @precon  None.
  @postcon Creates an instance of a TAttribute class.

  @param   Name   as a String as a constant
  @param   Fore   as a TColor as a constant
  @param   Back   as a TColor as a constant
  @param   Style  as a TFontStyles as a constant
  @param   Attr   as a TSynHighlighterAttributes as a constant
  @param   Parent as a TSynCustomHighlighter as a constant

**)
Constructor TAttribute.Create(Const Name: String; Const Fore, Back: TColor;
  Const Style : TFontStyles; Const Attr : TSynHighlighterAttributes;
  Const Parent : TSynCustomHighlighter);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod(Self, 'Create', tmoTiming);{$ENDIF}
  FName       := Name;
  FForeColour := Fore;
  FBackColour := Back;
  FStyle      := Style;
  FAttribute  := Attr;
  FParent     := Parent;
End;

(**

  This method adds a TAttribute to the collection based on the passed TSynHighlighterAttributes.

  @precon  Attr and Parent must be valid instances of an attribute and highlighter respectively.
  @postcon Adds a TAttribute to the collection based on the passed TSynHighlighterAttributes.

  @param   Attr   as a TSynHighlighterAttributes as a constant
  @param   Parent as a TSynCustomHighlighter as a constant
  @return  a TAttribute

**)
Function TAttributes.Add(Const Attr : TSynHighlighterAttributes;
  Const Parent : TSynCustomHighlighter) : TAttribute;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TAttributes.Add', tmoTiming);{$ENDIF}
  Result := Nil;
  If FProcessedAttrs.IndexOf(Attr) = -1 Then  // Only add it not already in list
    Begin
      FProcessedAttrs.Add(Attr);
      Result := TAttribute.Create(Attr.Name, Attr.Foreground, Attr.Background,
        Attr.Style, Attr, Parent);
      FAttributes.Add(Result);
    End;
End;

(**

  This is a constructor method for the TAttributes class.
  
  @precon  None.
  @postcon Initialise the collection.
  
**)
Constructor TAttributes.Create;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TAttributes.Create', tmoTiming);{$ENDIF}
  FAttributes := TObjectList.Create(True);
  FProcessedAttrs := TList.Create;
End;

(**

  This is a destructor for the Attributes class.
  
  @precon  None.
  @postcon Frees the classes internal memory.
  
**)
Destructor TAttributes.Destroy;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TAttributes.Destroy', tmoTiming);{$ENDIF}
  FProcessedAttrs.Free;
  FAttributes.Free;
  Inherited Destroy;
End;

(**

  This method updates the referenced highlighter attributes and highlighter.

  @precon  None.
  @postcon Updates the referenced highlighter attributes and highlighter.

  @param   boolIncTags as a Boolean as a constant

**)
Procedure TAttributes.Update(Const boolIncTags : Boolean);

Var
  i : Integer;
  A: TAttribute;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TAttributes.Update', tmoTiming);{$ENDIF}
  For i := 0 To FAttributes.Count - 1 Do
    Begin
      A := FAttributes[i] As TAttribute;
      A.Attribute.Foreground := A.ForeColour;
      A.Attribute.Background := A.BackColour;
      A.Attribute.Style      := A.Style;
      If boolIncTags Then
        A.Parent.Tag := A.Parent.Tag + 1;
    End;
End;

(**

  This method add the attributes of the given high lighters to the attribute collection.

  @precon  Highlighter must be a valid instance.
  @postcon Add the attributes of the given high lighters to the attribute collection.

  @param   Highlighter as a TSynCustomHighlighter as a constant

**)
Procedure TfrmEditorOptions.AddHighlighter(Const Highlighter : TSynCustomHighlighter);

Var
  A : TAttribute;
  strName : String;
  i : Integer;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.AddHighlighter', tmoTiming);{$ENDIF}
  strName := Highlighter.FriendlyLanguageName;
  For i := 0 To Highlighter.AttrCount - 1 Do
    Begin
      A := FAttributes.Add(Highlighter.Attribute[i], Highlighter);
      If A <> Nil Then
        lbAttributes.Items.AddObject(Format('%s:%s', [strName,
          Highlighter.Attribute[i].Name]), A);
    End;
End;

(**

  This method is an on changes event handler for the attribute controls.

  @precon  None.
  @postcon Updates the attribute with the changes in the attribute controls.

  @param   Sender as a TObject

**)
Procedure TfrmEditorOptions.AttributeChange(Sender: TObject);

  (**

    This procedure updates the types of the attribute with the given style if boolInclude is true.

    @precon  A must be a valid instance.
    @postcon The style is added to the attribute if required.

    @param   A           as a TAttribute as a constant
    @param   eStyle      as a TFontStyle as a constant
    @param   boolInclude as a Boolean as a constant

  **)
  Procedure UpdateStyle(Const A : TAttribute; Const eStyle : TFontStyle; Const boolInclude : Boolean);

  Begin
    {$IFDEF CODESITE}CodeSite.TraceMethod('UpdateStyle', tmoTiming);{$ENDIF}
    If boolInclude Then
      A.Style := A.Style + [eStyle];
  End;

Var
  A : TAttribute;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.AttributeChange', tmoTiming);{$ENDIF}
  If lbAttributes.ItemIndex > -1 Then
    If Not FUpdating Then
      Begin
        A := lbAttributes.Items.Objects[lbAttributes.ItemIndex] As TAttribute;
        If A <> Nil Then
          Begin
            A.ForeColour := cbxAttrForeColour.Selected;
            A.BackColour := cbxAttrBackColour.Selected;
            A.Style := [];
            UpdateStyle(A, fsBold, cbxBold.Checked);
            UpdateStyle(A, fsItalic, cbxItalic.Checked);
            UpdateStyle(A, fsUnderline, cbxUnderlined.Checked);
            UpdateStyle(A, fsStrikeOut, cbxStrikeout.Checked);
            lbAttributes.Invalidate;
          End;
      End;
End;

(**

  This is the constructor method for the TfrmEditorOptions class.

  @precon  None.
  @postcon Creates an instance of the form and initialises the interface controls.

  @nocheck MissingCONSTInParam
  
  @param   AOwner as a TComponent

**)
Constructor TfrmEditorOptions.Create(AOwner : TComponent);

Var
  j : TSynEditorOption;
  FontInfo : TLogFont;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.Create', tmoTiming);{$ENDIF}
  Inherited Create(AOwner);
  FAttributes := TAttributes.Create;
  FontInfo.lfCharSet := DEFAULT_CHARSET;
  FontInfo.lfFaceName := '';
  FontInfo.lfPitchAndFamily := FIXED_PITCH;
  FontNames := cbxFontName;
  EnumFontFamiliesEx(Canvas.Handle, FontInfo, @FontEnumExProc, 0, Integer(cbxFontName));
  cbxGutterFontName.Items.Assign(cbxFontName.Items);
  For j := Low(TSynEditorOption) To High(TSynEditorOption) Do
    clbOptions.Items.Add(BehaviouralOptions[j].Description);
End;

(**

  This is the destructor method for the TfrmEditorOptions class.

  @precon  None.
  @postcon Frees the memory used for the highlighter attributes.

**)
Destructor TfrmEditorOptions.Destroy;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.Destroy', tmoTiming);{$ENDIF}
  FAttributes.Free;
  Inherited Destroy;
End;

(**

  This is the forms main interface method.

  @precon  Editor must be a valid instance of a TSynEdit control.
  @postcon invokes a form for editing the given instance of the TSynEdit control.

  @param   OwnerForm  as a TForm as a constant
  @param   Editor     as a TSynEdit as a constant
  @param   boolIncTag as a Boolean as a constant
  @return  a Boolean

**)
Class Function TfrmEditorOptions.Execute(Const OwnerForm : TForm; Const Editor : TSynEdit;
  Const boolIncTag : Boolean) : Boolean;

Var
  F: TfrmEditorOptions;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.Execute', tmoTiming);{$ENDIF}
  Result := False;
  F := TfrmEditorOptions.Create(OwnerForm);
  Try
    F.InitialiseDlg(Editor);
    If F.ShowModal = mrOK Then
      Begin
        F.FinaliseDlg(Editor, boolIncTag);
        Result := True;
      End;
  Finally
    F.Free;
  End;
End;

(**

  This method saves the behavioural changes back to the editor.

  @precon  Editor must be a valid instance.
  @postcon The behavioural aspects of the editor are updated.

  @param   Editor as a TSynEdit as a constant

**)
Procedure TfrmEditorOptions.FinaliseBehaviour(Const Editor: TSynEdit);

Var
  i : TSynEditorOption;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.FinaliseBehaviour', tmoTiming);{$ENDIF}
  For i := Low(TSynEditorOption) To High(TSynEditorOption) Do
    If clbOptions.Checked[Integer(i)] Then
      Editor.Options := Editor.Options + [i]
    Else
      Editor.Options := Editor.Options - [i];
End;

(**

  This method saves the dialogue settings to the given SynEdit control and its associated highlighter.

  @precon  Editor must be a valid instance.
  @postcon The dialogues settings are saved to the SynEdit`s configuration and its high lighters 
           configuration.

  @param   Editor     as a TSynEdit as a constant
  @param   boolIncTag as a Boolean as a constant

**)
Procedure TfrmEditorOptions.FinaliseDlg(Const Editor: TSynEdit; Const boolIncTag: Boolean);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.FinaliseDlg', tmoTiming);{$ENDIF}
  FinaliseEditor(Editor);
  FinaliseGutter(Editor);
  FinaliseBehaviour(Editor);
  FinaliseHighlighter(boolIncTag);
End;

(**

  This method saves the editor changes back to the editor.

  @precon  Editor must be a valid instance.
  @postcon The editor is updated with any changes.

  @param   Editor as a TSynEdit as a constant

**)
Procedure TfrmEditorOptions.FinaliseEditor(Const Editor: TSynEdit);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.FinaliseEditor', tmoTiming);{$ENDIF}
  Editor.TabWidth := udTabWidth.Position;
  Editor.Color := cbxEditorBackgroundColour.Selected;
  Editor.ActiveLineColor := cbxActiveLineColour.Selected;
  Editor.Font.Name := cbxFontName.Text;
  Editor.Font.Size := udEditorFontSize.Position;
  Editor.Font.Color := cbxFontColour.Selected;
  Editor.Font.Style := [];
  If chkBold.Checked Then
    Editor.Font.Style := Editor.Font.Style + [fsBold];
  If chkItalics.Checked Then
    Editor.Font.Style := Editor.Font.Style + [fsItalic];
  If chkUnderline.Checked Then
    Editor.Font.Style := Editor.Font.Style + [fsUnderline];
  If chkStrikeout.Checked Then
    Editor.Font.Style := Editor.Font.Style + [fsStrikeout];
  Editor.RightEdge := udRightEdgePosition.Position;
  Editor.RightEdgeColor := cbxRightEdgeColour.Selected;
  Editor.SelectedColor.Foreground := cbxSelectedForeground.Selected;
  Editor.SelectedColor.Background := cbxSelectedBackground.Selected;
  Editor.WantTabs := chkWantTabs.Checked;
  Editor.WordWrap := chkWordWrap.Checked;
End;

(**

  This method saves the gutter changes to the editor gutter.

  @precon  Editor must be a valid instance.
  @postcon The gutter of the editor is updated with any changes.

  @param   Editor as a TSynEdit as a constant

**)
Procedure TfrmEditorOptions.FinaliseGutter(Const Editor: TSynEdit);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.FinaliseGutter', tmoTiming);{$ENDIF}
  Editor.Gutter.Visible := chkShowGutter.Checked;
  Editor.Gutter.UseFontStyle := Not chkUseEditorFont.Checked;
  Editor.Gutter.Font.Name := cbxGutterFontName.Text;
  Editor.Gutter.Font.Size := udGutterFontSize.Position;
  Editor.Gutter.Font.Color := cbxGutterFontColour.Selected;
  Editor.Gutter.Font.Style := [];
  If chkGutterFontBold.Checked Then
    Editor.Gutter.Font.Style := Editor.Gutter.Font.Style + [fsBold];
  If chkGutterFontItalic.Checked Then
    Editor.Gutter.Font.Style := Editor.Gutter.Font.Style + [fsItalic];
  If chkGutterFontUnderline.Checked Then
    Editor.Gutter.Font.Style := Editor.Gutter.Font.Style + [fsUnderline];
  If chkGutterFontStrikeout.Checked Then
    Editor.Gutter.Font.Style := Editor.Gutter.Font.Style + [fsStrikeout];
  Editor.Gutter.AutoSize := chkAutoSize.Checked;
  Editor.Gutter.ShowLineNumbers := chxLineNumbers.Checked;
  Editor.Gutter.LeadingZeros := chkShowLeadingZeros.Checked;
  Editor.Gutter.LineNumberStart := udStartLineNumber.Position;
  Editor.Gutter.Color := cbxGutterColour.Selected;
  Editor.Gutter.BorderColor := cbxGutterBorderColour.Selected;
  Editor.Gutter.TrackChanges.Visible := chkShowModifications.Checked;
  Editor.Gutter.TrackChanges.Width := upModifiedBarWidth.Position;
  Editor.Gutter.TrackChanges.ModifiedColor := cbxModifiedColour.Selected;
  Editor.Gutter.TrackChanges.SavedColor := cbxSavedColour.Selected;
  Editor.Gutter.TrackChanges.SavedModifiedColor := cbxModifiedSavedColour.Selected;
  Editor.Gutter.TrackChanges.OriginalColor := cbxOriginalLineColour.Selected;
  Editor.Gutter.DigitCount := udGutterWidth.Position;
End;

(**

  This method saves the attribute changes back to the editors highlighter.

  @precon  None.
  @postcon The highlighter changes are saved back to the editors highlighter.

  @param   boolIncTag as a Boolean as a constant

**)
Procedure TfrmEditorOptions.FinaliseHighlighter(Const boolIncTag : Boolean);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.FinaliseHighlighter', tmoTiming);{$ENDIF}
  FAttributes.Update(boolIncTag);
End;

(**

  This method loads the dialogue with settings from the given SynEdit control and its associated 
  highlighter.

  @precon  Editor must be a valid instance.
  @postcon The dialogue is loaded with the SynEdit`s configuration and its high lighters configuration.

  @param   Editor as a TSynEdit as a constant

**)
Procedure TfrmEditorOptions.InitialiseBehaviour(Const Editor: TSynEdit);

Var
  i: TSynEditorOption;
  
Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.InitialiseBehaviour', tmoTiming);{$ENDIF}
  For i := Low(TSynEditorOption) To High(TSynEditorOption) Do
    clbOptions.Checked[Integer(i)] := i In Editor.Options;
End;

(**

  This method method initialises the dialogue controls with the settings from the given Editor.

  @precon  Editor must be a valid instance.
  @postcon The control a=on the dialogue are set to the properties of the given editor.

  @param   Editor as a TSynEdit as a constant

**)
Procedure TfrmEditorOptions.InitialiseDlg(Const Editor: TSynEdit);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.InitialiseDlg', tmoTiming);{$ENDIF}
  InitialiseEditor(Editor);
  InitialiseGutter(Editor);
  InitialiseBehaviour(Editor);
  InitialiseHighlighter(Editor);
  If lbAttributes.Items.Count > 0 Then
    Begin
      lbAttributes.ItemIndex := 0;
      lbAttributesClick(Nil);
    End;
  PageControl1.ActivePageIndex := 0;
End;

(**

  This method sets the control on the Editor page of the dialogue to the main properties of the editor
  control.

  @precon  Editor must be a valid instance.
  @postcon The Controls on the Editor page of he dialogue are set to the main properties of the given
           editor.

  @param   Editor as a TSynEdit as a constant

**)
Procedure TfrmEditorOptions.InitialiseEditor(Const Editor: TSynEdit);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.InitialiseEditor', tmoTiming);{$ENDIF}
  udTabWidth.Position := Editor.TabWidth;
  cbxEditorBackgroundColour.Selected := Editor.Color;
  cbxActiveLineColour.Selected := Editor.ActiveLineColor;
  cbxFontName.ItemIndex := cbxFontName.Items.IndexOf(Editor.Font.Name);
  udEditorFontSize.Position := Editor.Font.Size;
  cbxFontColour.Selected := Editor.Font.Color;
  chkBold.Checked := fsBold In Editor.Font.Style;
  chkItalics.Checked := fsItalic In Editor.Font.Style;
  chkUnderline.Checked := fsUnderline In Editor.Font.Style;
  chkStrikeout.Checked := fsStrikeout In Editor.Font.Style;
  udRightEdgePosition.Position := Editor.RightEdge;
  cbxRightEdgeColour.Selected := Editor.RightEdgeColor;
  cbxSelectedForeground.Selected := Editor.SelectedColor.Foreground;
  cbxSelectedBackground.Selected := Editor.SelectedColor.Background;
  chkWantTabs.Checked := Editor.WantTabs;
  chkWordWrap.Checked := Editor.WordWrap;
End;

(**

  This method sets the controls on the gutter page of the dialogue to the properties of the given editor
  gutter.

  @precon  Editor must be a valid instance.
  @postcon The controls on the gutter page of the dialogue are set to the properties of the given editor
           gutter.

  @param   Editor as a TSynEdit as a constant

**)
Procedure TfrmEditorOptions.InitialiseGutter(Const Editor: TSynEdit);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.InitialiseGutter', tmoTiming);{$ENDIF}
  chkShowGutter.Checked := Editor.Gutter.Visible;
  chkUseEditorFont.Checked := Not Editor.Gutter.UseFontStyle;
  cbxGutterFontName.ItemIndex := cbxGutterFontName.Items.IndexOf(Editor.Gutter.Font.Name);
  udGutterFontSize.Position := Editor.Gutter.Font.Size;
  cbxGutterFontColour.Selected := Editor.Gutter.Font.Color;
  chkGutterFontBold.Checked := fsBold In Editor.Gutter.Font.Style;
  chkGutterFontItalic.Checked := fsItalic In Editor.Gutter.Font.Style;
  chkGutterFontUnderline.Checked := fsUnderline In Editor.Gutter.Font.Style;
  chkGutterFontStrikeout.Checked := fsStrikeout In Editor.Gutter.Font.Style;
  chkAutoSize.Checked := Editor.Gutter.AutoSize;
  chxLineNumbers.Checked := Editor.Gutter.ShowLineNumbers;
  chkShowLeadingZeros.Checked := Editor.Gutter.LeadingZeros;
  udStartLineNumber.Position := Editor.Gutter.LineNumberStart;
  cbxGutterColour.Selected := Editor.Gutter.Color;
  cbxGutterBorderColour.Selected := Editor.Gutter.BorderColor;
  chkShowModifications.Checked := Editor.Gutter.TrackChanges.Visible;
  upModifiedBarWidth.Position := Editor.Gutter.TrackChanges.Width;
  cbxModifiedColour.Selected := Editor.Gutter.TrackChanges.ModifiedColor;
  cbxSavedColour.Selected := Editor.Gutter.TrackChanges.SavedColor;
  cbxModifiedSavedColour.Selected := Editor.Gutter.TrackChanges.SavedModifiedColor;
  cbxOriginalLineColour.Selected := Editor.Gutter.TrackChanges.OriginalColor;
  udGutterWidth.Position := Editor.Gutter.DigitCount;
End;

(**

  This method initialises the highlighter controls to the settings of the given editors highlighter else
  the tab is hidden.

  @precon  Editor must be a valid instance.
  @postcon The syntax tab of the editor is set to the values of the Editors highlighter.

  @param   Editor as a TSynEdit as a constant

**)
Procedure TfrmEditorOptions.InitialiseHighlighter(Const Editor: TSynEdit);

Const
  strMarker = 'Marker';

Var
  M: TSynMultiSyn;
  S: TScheme;
  j: Integer;
  A: TAttribute;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.InitialiseHighlighter', tmoTiming);{$ENDIF}
  If Assigned(Editor.Highlighter) Then
    Begin
      If Editor.Highlighter Is TSynMultiSyn Then
        Begin
          M := Editor.Highlighter As TSynMultiSyn;
          AddHighlighter(M.DefaultHighlighter);
          lblHighlighterType.Caption := M.DefaultHighlighter.FriendlyLanguageName;
          For j := 0 To M.Schemes.Count - 1 Do
            Begin
              S := M.Schemes[j] As TScheme;
              A := FAttributes.Add(S.MarkerAttri, M);
              If A <> Nil Then
                lbAttributes.Items.AddObject(Format('%s:%s', [S.SchemeName, strMarker]), A);
              AddHighlighter(S.Highlighter);
            End;
        End
      Else
        Begin
          lblHighlighterType.Caption := Editor.Highlighter.FriendlyLanguageName;
          AddHighlighter(Editor.Highlighter);
        End;
    End
  Else
    tabSyntax.TabVisible := False;
End;

(**

  This is the attribute list box`s on click event handler.

  @precon  None.
  @postcon Updates the attribute controls with the selected attribute in the
           list box.

  @param   Sender as a TObject

**)
Procedure TfrmEditorOptions.lbAttributesClick(Sender: TObject);

Var
  A : TAttribute;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.lbAttributesClick', tmoTiming);{$ENDIF}
  If lbAttributes.ItemIndex > -1 Then
    Begin
      A := lbAttributes.Items.Objects[lbAttributes.ItemIndex] As TAttribute;
      If A <> Nil Then
        Begin
          FUpdating := True;
          Try
            cbxAttrForeColour.Selected := A.ForeColour;
            cbxAttrBackColour.Selected := A.BackColour;
            cbxBold.Checked := fsBold In A.Style;
            cbxItalic.Checked := fsItalic In A.Style;
            cbxUnderlined.Checked := fsUnderline In A.Style;
            cbxStrikeout.Checked := fsStrikeOut In A.Style;
          Finally
            FUpdating := False;
          End;
        End;
    End;
End;

(**

  This is an on raw item event handler for the attribute list.

  @precon  None.
  @postcon Draws each attribute in its own colours and font style.

  @param   Sender as a TWinControl
  @param   Index  as an Integer
  @param   Rect   as a TRect
  @param   State  as a TOwnerDrawState

**)
Procedure TfrmEditorOptions.lbAttributesDrawItem(Sender: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);

Var
  strText : String;
  R : TRect;
  A: TAttribute;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmEditorOptions.lbAttributesDrawItem', tmoTiming);{$ENDIF}
  lbAttributes.Canvas.FillRect(Rect);
  strText := lbAttributes.Items[Index];
  R := Rect;
  A := lbAttributes.Items.Objects[Index] As TAttribute;
  If odSelected In State Then
    lbAttributes.Canvas.Brush.Color := StyleServices.GetSystemColor(clHighlight)
  Else
    lbAttributes.Canvas.Brush.Color := StyleServices.GetSystemColor(clWindow);
  If A.BackColour <> clNone Then
    lbAttributes.Canvas.Brush.Color := A.BackColour;
  lbAttributes.Canvas.Font.Color := StyleServices.GetSystemColor(clWindowText);
  If A.ForeColour <> clNone Then
    lbAttributes.Canvas.Font.Color := A.ForeColour;
  lbAttributes.Canvas.Font.Style := A.Style;
  lbAttributes.Canvas.TextRect(R, strText, [tfLeft]);
End;

End.

