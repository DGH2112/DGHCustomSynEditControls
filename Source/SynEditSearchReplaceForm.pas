(**

 This module contains a class which represent a modal form for specify Search
 and Replace criteria.

 @Version 1.073
 @Author  David Hoyle
 @Date    25 Feb 2022

 **)
Unit SynEditSearchReplaceForm;

Interface

Uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.IniFiles,
  VCL.Graphics,
  VCL.Controls,
  VCL.Forms,
  VCL.Dialogs,
  VCL.StdCtrls,
  VCL.Buttons,
  VCL.ExtCtrls,
  WinApi.Windows,
  Winapi.Messages,
  SynEdit,
  SynEditTypes,
  SynEditMiscClasses;

Type
  (** this is an enumerate of options for the search find and replace dialogue. **)
  TSearchOption = (soCaseSens, soWholeWords, soRegEx, soPrompt, soBackward, soSelected,
    soEntireScope, soReplaceAll, soReplaceDlg);

  (** This is a set of Search Find and Replace dialogue options. **)
  TSearchOptions = Set Of TSearchOption;

  (** A message handler for Do Search And Replace. **)
  TSearchReplaceMsgProc = Procedure(Const strMsg: String) Of Object;

  (** A class to represent a form for prompting the user for Search and Replace
   information. **)
  TfrmSearchAndReplace = Class(TForm)
    lblTextToFind: TLabel;
    cbxSearch: TComboBox;
    lblReplaceWith: TLabel;
    cbxReplace: TComboBox;
    gbxOptions: TGroupBox;
    cbxCaseSensitive: TCheckBox;
    cbxWholeWordsOnly: TCheckBox;
    cbxRegularExpressions: TCheckBox;
    cbxPrompt: TCheckBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    grpDirection: TGroupBox;
    rbtnForward: TRadioButton;
    rbtnBackward: TRadioButton;
    rgrpScope: TRadioGroup;
    rgrpOrigin: TRadioGroup;
    btnReplaceAll: TBitBtn;
    btnHelp: TBitBtn;
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure btnOKClick(Sender: TObject);
  Strict Private
    FINIFile: TMemIniFile;
  Public
    Constructor CreateDlg(Const AOwner: TComponent; Const INIFile : TMemIniFile);
    Class Function Execute(Const AOwner : TForm; Var strSearch, strReplace: String;
      Var Options: TSearchOptions; Const INIFile : TMemIniFile): Boolean;
  End;

Procedure SearchFind(Const AOwner : TForm; Const Editor: TCustomSynEdit;
  Const MsgHandler: TSearchReplaceMsgProc; Var strFind, strReplace: String; Var Options: TSearchOptions;
  Const RegEng, StdEng: TSynEditSearchCustom; Const IniFile : TMemIniFile);
Procedure SearchFindNext(Const Editor: TCustomSynEdit; Const MsgHandler: TSearchReplaceMsgProc;
  Const strFind, strReplace: String; Var Options: TSearchOptions;
  Const RegEng, StdEng: TSynEditSearchCustom);
Procedure SearchReplace(Const AOwner : TForm; Const Editor: TCustomSynEdit;
  Const MsgHandler: TSearchReplaceMsgProc; Var strFind, strReplace: String; Var Options: TSearchOptions;
  Const RegEng, StdEng: TSynEditSearchCustom; Const INIFile : TMemIniFile);
Procedure SearchReplaceText(Const Editor: TCustomSynEdit; Const ASearch, AReplace: String;
  Const Line, Column: Integer; Var Action: TSynReplaceAction);

Implementation

Uses
  {$IFDEF CODESITE}
  CodeSiteLogging,
  {$ENDIF CODESITE}
  System.UITypes,
  System.Math,
  SynEditConfirmationDlgForm;

{$R *.dfm}

ResourceString
  (** A resource string to indicate that the search text was not found. **)
  strTextNotFound = 'The text "%s" was not found.';

Const
  (** An INI section name for search and replace search strings. **)
  strSearchAndReplaceSearchStrings = 'SearchAndReplace\SearchStrings';
  (** An INI section name for search and replace replace strings. **)
  strSearchAndReplaceReplaceStrings = 'SearchAndReplace\ReplaceStrings';
  (** An INI section name for search and replace dialogue position. **)
  strSearchAndReplace = 'SearchAndReplace';
  (** An INI key for the top position. **)
  strTopKey = 'Top';
  (** An INI key for the left position. **)
  strLeftKey = 'Left';

(**

  This procedure undertakes the actual search (and optional replacing) of the text within the passed 
  Editor control.

  @precon  Editor must be a valid TCustomSynEdit
  @postcon Undertakes the actual search (and optional replacing) of the text within the passed Editor 
           control.

  @param   Editor       as a TCustomSynEdit as a constant
  @param   MsgHandler   as a TSearchReplaceMsgProc as a constant
  @param   strFind      as a String as a constant
  @param   strReplace   as a String as a constant
  @param   Options      as a TSearchOptions as a reference
  @param   RegEng       as a TSynEditSearchCustom as a constant
  @param   StdEng       as a TSynEditSearchCustom as a constant
  @param   boolFindNext as a Boolean as a constant

**)
Procedure DoSearchReplaceText(Const Editor: TCustomSynEdit; Const MsgHandler: TSearchReplaceMsgProc;
  Const strFind, strReplace: String; Var Options: TSearchOptions;
  Const RegEng, StdEng: TSynEditSearchCustom; Const boolFindNext: Boolean = False);

ResourceString
  strRegExError = 'Regular Expression Error';

Var
  SynEditOps: TSynSearchOptions;

  (**

    This procedure updates the main procedure`s SynEditOps variable with the passed search option.

    @precon  None.
    @postcon Updates the main procedure`s SynEditOps variable with the passed search option.

    @param   boolInclude as a Boolean as a constant
    @param   Op          as a TSynSearchOption as a constant

  **)
  Procedure UpdateOptions(Const boolInclude: Boolean; Const Op: TSynSearchOption);

  Begin
    {$IFDEF CODESITE}CodeSite.TraceMethod('UpdateOptions', tmoTiming);{$ENDIF}
    If boolInclude Then
      Include(SynEditOps, Op)
    Else
      Exclude(SynEditOps, Op);
  End;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('DoSearchReplaceText', tmoTiming);{$ENDIF}
  If soRegEx In Options Then
    Editor.SearchEngine := RegEng
  Else
    Editor.SearchEngine := StdEng;
  SynEditOps            := [];
  UpdateOptions(soCaseSens In Options, ssoMatchCase);
  UpdateOptions(soWholeWords In Options, ssoWholeWord);
  UpdateOptions(soPrompt In Options, ssoPrompt);
  UpdateOptions(soBackward In Options, ssoBackwards);
  UpdateOptions(soSelected In Options, ssoSelectedOnly);
  If Not boolFindNext Then
    UpdateOptions(soEntireScope In Options, ssoEntireScope);
  UpdateOptions(soReplaceAll In Options, ssoReplaceAll);
  UpdateOptions(soReplaceDlg In Options, ssoReplace);
  Try
  If Editor.SearchReplace(strFind, strReplace, SynEditOps) = 0 Then
    If Assigned(MsgHandler) Then
      MsgHandler(Format(strTextNotFound, [strFind]));
  Except
    //: @debug On E : ERegExpr Do
    On E : Exception Do
      TaskMessageDlg(strRegExError, E.Message, mtError, [mbOK], 0);
  End;
End;

(**

  This procedure should be invokes from the applications On Edit Find Action ( or similar event) to
  search the passed editor for the passed text.

  @precon  Editor must be a valid TCustomSynEdit control.
  @postcon Search the passed editor for the passed text.

  @param   AOwner     as a TForm as a constant
  @param   Editor     as a TCustomSynEdit as a constant
  @param   MsgHandler as a TSearchReplaceMsgProc as a constant
  @param   strFind    as a String as a reference
  @param   strReplace as a String as a reference
  @param   Options    as a TSearchOptions as a reference
  @param   RegEng     as a TSynEditSearchCustom as a constant
  @param   StdEng     as a TSynEditSearchCustom as a constant
  @param   IniFile    as a TMemIniFile as a constant

**)
Procedure SearchFind(Const AOwner : TForm; Const Editor: TCustomSynEdit;
  Const MsgHandler: TSearchReplaceMsgProc; Var strFind, strReplace: String; Var Options: TSearchOptions;
  Const RegEng, StdEng: TSynEditSearchCustom; Const IniFile : TMemIniFile);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('SearchFind', tmoTiming);{$ENDIF}
  Exclude(Options, soReplaceDlg);
  Exclude(Options, soReplaceAll);
  Exclude(Options, soPrompt);
  If Editor.SelAvail And (Editor.BlockBegin.Line = Editor.BlockEnd.Line) Then
    strFind := Editor.SelText
  Else
    strFind := Editor.GetWordAtRowCol(Editor.CaretXY);
  If Editor.SelAvail Then
    Include(Options, soSelected)
  Else
    Exclude(Options, soSelected);
  If TfrmSearchAndReplace.Execute(AOwner, strFind, strReplace, Options, IniFile) Then
    If strFind <> '' Then
      DoSearchReplaceText(Editor, MsgHandler, strFind, strReplace, Options, RegEng, StdEng);
End;

(**

  This procedure should be invokes from the applications On Edit Find Next Action (or similar event) to 
  search the passed editor for the next occurrence of the passed text.

  @precon  Editor must be a valid TCustomSynEdit control.
  @postcon Search the passed editor for the next occurrence of the passed text.

  @param   Editor     as a TCustomSynEdit as a constant
  @param   MsgHandler as a TSearchReplaceMsgProc as a constant
  @param   strFind    as a String as a constant
  @param   strReplace as a String as a constant
  @param   Options    as a TSearchOptions as a reference
  @param   RegEng     as a TSynEditSearchCustom as a constant
  @param   StdEng     as a TSynEditSearchCustom as a constant

**)
Procedure SearchFindNext(Const Editor: TCustomSynEdit; Const MsgHandler: TSearchReplaceMsgProc;
  Const strFind, strReplace: String; Var Options: TSearchOptions;
  Const RegEng, StdEng: TSynEditSearchCustom);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('SearchFindNext', tmoTiming);{$ENDIF}
  DoSearchReplaceText(Editor, MsgHandler, strFind, strReplace, Options, RegEng,
    StdEng, True);
End;

(**

  This procedure should be invokes from the applications On Edit Replace Action (or similar event) to
  search the passed editor for the passed text and replace them with the passed text.

  @precon  Editor must be a valid TCustomSynEdit control.
  @postcon Search the passed editor for the passed text and replace them with the passed text.

  @param   AOwner     as a TForm as a constant
  @param   Editor     as a TCustomSynEdit as a constant
  @param   MsgHandler as a TSearchReplaceMsgProc as a constant
  @param   strFind    as a String as a reference
  @param   strReplace as a String as a reference
  @param   Options    as a TSearchOptions as a reference
  @param   RegEng     as a TSynEditSearchCustom as a constant
  @param   StdEng     as a TSynEditSearchCustom as a constant
  @param   INIFile    as a TMemIniFile as a constant

**)
Procedure SearchReplace(Const AOwner : TForm; Const Editor: TCustomSynEdit;
  Const MsgHandler: TSearchReplaceMsgProc; Var strFind, strReplace: String; Var Options: TSearchOptions;
  Const RegEng, StdEng: TSynEditSearchCustom; Const INIFile : TMemIniFile);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('SearchReplace', tmoTiming);{$ENDIF}
  Include(Options, soReplaceDlg);
  Include(Options, soReplaceAll);
  Include(Options, soPrompt);
  If Editor.SelAvail And (Editor.BlockBegin.Line = Editor.BlockEnd.Line) Then
    strFind := Editor.SelText
  Else
    strFind := Editor.GetWordAtRowCol(Editor.CaretXY);
  If Editor.SelAvail Then
    Include(Options, soSelected)
  Else
    Exclude(Options, soSelected);
  If TfrmSearchAndReplace.Execute(AOwner, strFind, strReplace, Options, INIFile) Then
    If strFind <> '' Then
      DoSearchReplaceText(Editor, MsgHandler, strFind, strReplace, Options, RegEng, StdEng);
End;

(**

  This procedure should be called from the applications event handler which handles the TCustomSynEdit 
  controls On Replace Text event. If necessary prompts the user to confirm the replacement of text.

  @precon  Editor must be a valid TCustomSynEdit control.
  @postcon If necessary prompts the user to confirm the replacement of text.

  @param   Editor     as a TCustomSynEdit as a constant
  @param   ASearch    as a String as a constant
  @param   AReplace   as a String as a constant
  @param   Line       as an Integer as a constant
  @param   Column     as an Integer as a constant
  @param   Action     as a TSynReplaceAction as a reference

**)
Procedure SearchReplaceText(Const Editor: TCustomSynEdit; Const ASearch, AReplace: String;
  Const Line, Column: Integer; Var Action: TSynReplaceAction);

Var
  P: TPoint;
  R: TRect;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('SearchReplaceText', tmoTiming);{$ENDIF}
  If ASearch = AReplace Then
    Action := raSkip
  Else
    Begin
      P := Editor.ClientToScreen
        (Editor.RowColumnToPixels(Editor.BufferToDisplayPos(BufferCoord(Column, Line))));
      R             := Editor.Parent.ClientRect;
      R.TopLeft     := Editor.Parent.ClientToScreen(R.TopLeft);
      R.BottomRight := Editor.Parent.ClientToScreen(R.BottomRight);
      Case TfrmConfirmationDlg.Execute(R, ASearch, AReplace, P.X, P.Y, P.Y + Editor.LineHeight) Of
        mrYes: Action := raReplace;
        mrNo:  Action := raSkip;
        mrAll: Action := raReplaceAll;
      Else
        Action := raCancel;
      End;
    End;
End;

(**

  This is an on click event handler for the OK button.

  @precon  None.
  @postcon Inserts the current Search and Replace texts at the top of the drop
           down lists.

  @param   Sender as a TObject

**)
Procedure TfrmSearchAndReplace.btnOKClick(Sender: TObject);

  (**

    This function determines if the text is valid and not already in the list.

    @precon  None.
    @postcon Returns true if the text is valid (i.e. not null) and not already in the list.

    @param   strText as a String as a constant
    @param   Control as a TComboBox as a constant
    @return  a Boolean

  **)
  Function CanAdd(Const strText: String; Const Control: TComboBox): Boolean;

  Var
    i: Integer;

  Begin
    {$IFDEF CODESITE}CodeSite.TraceMethod(Self, 'btnOKClick/CanAdd', tmoTiming);{$ENDIF}
    Result := False;
    If strText = '' Then
      Exit;
    For i := 0 To Control.Items.Count - 1 Do
      If AnsiCompareText(strText, Control.Items[i]) = 0 Then
        Exit;
    Result := True;
  End;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod(Self, 'btnOKClick', tmoTiming);{$ENDIF}
  If CanAdd(cbxSearch.Text, cbxSearch) Then
    cbxSearch.Items.Insert(0, cbxSearch.Text);
  If CanAdd(cbxReplace.Text, cbxReplace) Then
    cbxReplace.Items.Insert(0, cbxReplace.Text);
End;

(**

  This is the constructor method for the TfrmSearchAndReplace class.

  @precon  INIFile must be a valid instance.
  @postcon Constructs an instance of the class.

  @param   AOwner  as a TComponent as a constant
  @param   INIFile as a TMemIniFile as a constant

**)
Constructor TfrmSearchAndReplace.CreateDlg(Const AOwner: TComponent; Const INIFile : TMemIniFile);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod(Self, 'CreateDlg', tmoTiming);{$ENDIF}
  Inherited Create(AOwner);
  FINIFile := INIFile;
End;

(**

  This is the forms main interface method.

  @precon  none.
  @postcon Initialises the dialogue with the search settings and returns the Search and Replace texts 
           which are to be used.

  @param   AOwner     as a Tform as a constant
  @param   strSearch  as a String as a reference
  @param   strReplace as a String as a reference
  @param   Options    as a TSearchOptions as a reference
  @param   INIFile    as a TMemIniFile as a constant
  @return  a Boolean

**)
Class Function TfrmSearchAndReplace.Execute(Const AOwner : Tform; Var strSearch, strReplace: String;
  Var Options: TSearchOptions; Const INIFile : TMemIniFile): Boolean;

  (**

    This method updates the options with the passed boolean and option.

    @precon  None.
    @postcon Updates the options with the passed boolean and option.

    @param   boolInclude as a Boolean as a constant
    @param   Option      as a TSearchOption as a constant

  **)
  Procedure UpdateOption(Const boolInclude: Boolean; Const Option: TSearchOption);

  Begin
    {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmSearchAndReplace.Execute/UpdateOption', tmoTiming);{$ENDIF}
    If boolInclude Then
      Include(Options, Option)
    Else
      Exclude(Options, Option);
  End;

ResourceString
  strSearchAndReplaceCaption = 'Search and Replace';
  strSearchCaption = 'Search';

Var
  DlgResult: TModalResult;
  F: TfrmSearchAndReplace;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TfrmSearchAndReplace.Execute', tmoTiming);{$ENDIF}
  Result := False;
  F := TfrmSearchAndReplace.CreateDlg(AOwner, INIFile);
  Try
    F.cbxSearch.Text                := strSearch;
    F.cbxCaseSensitive.Checked      := soCaseSens In Options;
    F.cbxWholeWordsOnly.Checked     := soWholeWords In Options;
    F.cbxRegularExpressions.Checked := soRegEx In Options;
    F.cbxPrompt.Checked             := soPrompt In Options;
    F.rgrpScope.ItemIndex           := Integer(soSelected In Options);
    F.rbtnForward.Checked           := Not(soBackward In Options);
    F.rbtnBackward.Checked          := soBackward In Options;
    F.rgrpOrigin.ItemIndex          := Integer(soEntireScope In Options);
    If soReplaceDlg In Options Then
      F.Caption := strSearchAndReplaceCaption
    Else
      F.Caption              := strSearchCaption;
    F.lblReplaceWith.Visible := soReplaceDlg In Options;
    F.cbxReplace.Visible     := soReplaceDlg In Options;
    F.cbxPrompt.Visible      := soReplaceDlg In Options;
    F.btnReplaceAll.Visible  := soReplaceDlg In Options;
    DlgResult := F.ShowModal;
    If DlgResult In [mrOK, mrAll] Then
      Begin
        strSearch  := F.cbxSearch.Text;
        strReplace := F.cbxReplace.Text;
        UpdateOption(F.cbxCaseSensitive.Checked, soCaseSens);
        UpdateOption(F.cbxWholeWordsOnly.Checked, soWholeWords);
        UpdateOption(F.cbxRegularExpressions.Checked, soRegEx);
        UpdateOption(F.cbxPrompt.Checked, soPrompt);
        UpdateOption(Boolean(F.rgrpScope.ItemIndex), soSelected);
        UpdateOption(F.rbtnBackward.Checked, soBackward);
        UpdateOption(Boolean(F.rgrpOrigin.ItemIndex), soEntireScope);
        UpdateOption(DlgResult = mrAll, soReplaceAll);
        Result := True;
      End;
  Finally
    F.Free;
  End;
End;

(**

  This is the forms on create event handler.

  @precon  None.
  @postcon Fills the drop down list for Search and Replace with previous
           entries.

  @param   Sender as a TObject

**)
Procedure TfrmSearchAndReplace.FormCreate(Sender: TObject);

Const
  iMaximumSearchesToStore = 9;

Var
  sl: TStringList;
  i : Integer;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod(Self, 'FormCreate', tmoTiming);{$ENDIF}
  sl := TStringList.Create;
  Try
    FINIFile.ReadSection(strSearchAndReplaceSearchStrings, sl);
    For i := 0 To Min(sl.Count - 1, iMaximumSearchesToStore) Do
      If FINIFile.ReadString(strSearchAndReplaceSearchStrings, sl[i], '') <> '' Then
        cbxSearch.Items.Add(FINIFile.ReadString(strSearchAndReplaceSearchStrings, sl[i], ''));
    FINIFile.ReadSection(strSearchAndReplaceReplaceStrings, sl);
    For i := 0 To Min(sl.Count - 1, iMaximumSearchesToStore) Do
      If FINIFile.ReadString(strSearchAndReplaceReplaceStrings, sl[i], '') <> '' Then
        cbxReplace.Items.Add(FINIFile.ReadString(strSearchAndReplaceReplaceStrings,
            sl[i], ''));
    Top  := FINIFile.ReadInteger(strSearchAndReplace, strTopKey, (Screen.Height - Height) Div 2);
    Left := FINIFile.ReadInteger(strSearchAndReplace, strLeftKey, (Screen.Width - Width) Div 2);
  Finally
    sl.Free;
  End;
End;

(**

  This is the forms on destroy event handler.

  @precon  None.
  @postcon if the form is confirmed the drop down lists of Search and Replace
           texts are saved to the Ini File.

  @param   Sender as a TObject

**)
Procedure TfrmSearchAndReplace.FormDestroy(Sender: TObject);

Const
  strStringSavePattern = 'String%d';

Var
  i: Integer;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod(Self, 'FormDestroy', tmoTiming);{$ENDIF}
  If ModalResult In [mrOK, mrAll] Then
    Begin
      For i := 0 To cbxSearch.Items.Count - 1 Do
        If cbxSearch.Items[i] <> '' Then
          FINIFile.WriteString(strSearchAndReplaceSearchStrings, Format(strStringSavePattern, [i]),
            cbxSearch.Items[i]);
      For i := 0 To cbxReplace.Items.Count - 1 Do
        If cbxReplace.Items[i] <> '' Then
          FINIFile.WriteString(strSearchAndReplaceReplaceStrings, Format(strStringSavePattern, [i]),
            cbxReplace.Items[i]);
      FINIFile.WriteInteger(strSearchAndReplace, strTopKey, Top);
      FINIFile.WriteInteger(strSearchAndReplace, strLeftKey, Left);
      FINIFile.UpdateFile;
    End;
End;

End.

