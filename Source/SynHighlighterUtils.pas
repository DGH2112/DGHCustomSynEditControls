(**
  
  This module provides a set of useful utility functions for working with SynEdit controls and allows
  the loading and saving of the settings.

  @Author  David Hoyle
  @Version 1.985
  @Date    10 Apr 2022
  
**)
Unit SynHighlighterUtils;

Interface

Uses
  System.IniFiles,
  SynEdit,
  SynEditHighlighter;

Type
  (** A record to encapsulate the functions. **)
  TDGHCustomSynEditFunctions = Record
  Strict Private
    Class Procedure LoadEditorSettings(Const INIFile : TMemIniFile; Const Editor : TSynEdit); Static;
    Class Procedure LoadGutterSettings(Const INIFile : TMemIniFile; Const Editor : TSynEdit); Static;
    Class Procedure SaveEditorSettings(Const INIFile : TMemIniFile; Const Editor : TSynEdit); Static;
    Class Procedure SaveGutterSettings(Const INIFile : TMemIniFile; Const Editor : TSynEdit); Static;
  Public
    Class Function  HighlighterName(Const Highlighter : TSynCustomHighlighter) : String; Static;
    Class Procedure LoadFromIniFile(Const INIFile : TMemIniFile; Const Editor : TSynEdit); Static;
    Class Procedure LoadHighlighterFromINIFile(Const INIFile : TMemIniFile;
      Const Highlighter: TSynCustomHighlighter); Static;
    Class Procedure SaveToIniFile(Const INIFile : TMemIniFile; Const Editor : TSynEdit); Static;
    Class Procedure SaveHighlighterToINIFile(Const INIFile : TMemIniFile;
      Const Highlighter : TSynCustomHighlighter);  Static;
  End;

Implementation

Uses
  {$IFDEF CODESITE}
  CodeSiteLogging,
  {$ENDIF CODESITE}
  System.SysUtils,
  System.Classes,
  System.TypInfo,
  System.StrUtils,
  System.UITypes,
  VCL.Controls,
  VCL.Graphics,
  SynHighlighterMulti;

Const
  (** A constant for the INI Key for the Editor Colour **)
  strColourKey = 'Colour';
  (** A constant for the INI Key for the Editor Active Line Colour **)
  strActiveLineColourKey = 'Active Line Colour';
  (** A constant for the INI Key for the Editor Font Name **)
  strFontNameKey = 'Font Name';
  (** A constant for the INI Key for the Editor Font Size **)
  strFontSizeKey = 'Font Size';
  (** A constant for the INI Key for the Editor Font Colour **)
  strFontColourKey = 'Font Colour';
  (** A constant for the INI Key for the Editor Font Style **)
  strFontKey = 'Font.';
  (** A constant for the INI Key for the Editor Word wrap **)
  strWordwrapKey = 'Wordwrap';
  (** A constant for the INI Key for the editor GUtter visibility **)
  strShowGutter = 'Show Gutter';
  (** A constant for the INI Key for the Editor Gutter Font Name **)
  strGutterFontNameKey = 'Gutter Font Name';
  (** A constant for the INI Key for the Editor Gutter Font Size **)
  strGutterFontSizeKey = 'Gutter Font Size';
  (** A constant for the INI Key for the Editor Gutter Font Colour **)
  strGutterFontColourKey = 'Gutter Font Colour';
  (** A constant for the INI Key for the Editor Gutter Font Style **)
  strGutterFontKey = 'Gutter Font.';
  (** A constant for whether the gutter uses the Editor Font or not. **)
  strUseEditorFontKey = 'UseEditorFont';
  (** A constant for the INI Key for the Editor Gutter Auto size **)
  strAutoSizeKey = 'AutoSize';
  (** A constant for the INI Key for the Editor Gutter Width **)
  strGutterColourKey = 'Gutter Colour';
  (** A constant for the INI Key for the Editor Gutter Border Colour **)
  strGutterBorderColourKey = 'Gutter Border Colour';
  (** A constant for the INI Key for the Editor Line Numbers **)
  strShowLineNumbersKey = 'Show Line Numbers';
  (** A constant for the INI Key for the Editor Options **)
  strOptionsKey = 'Options.';
  (** A constant for the INI Key for the Editor Right Edge **)
  strRightEdgeKey = 'Right Edge';
  (** A constant for the INI Key for the Editor Right Edge Colour **)
  strRightEdgeColourKey = 'Right Edge Colour';
  (** A constant for the INI Key for the Editor Selected Foreground Colour **)
  strSelectedForegroundKey = 'Selected Foreground';
  (** A constant for the INI Key for the Editor Selected Background Colour **)
  strSelectedBackgroundKey = 'Selected Background';
  (** A constant for the INI Key for the Editor Tab Width **)
  strTabWidthKey = 'Tab Width';
  (** A constant for the INI Key for the Editor Want Tabs **)
  strWantTabsKey = 'WantTabs';
  (** A constant for the INI Key for the Editor Attribute Background Colours **)
  strBackgroundKey = '.Background';
  (** A constant for the INI Key for the Editor Attribute Foreground Colour **)
  strForegroundKey = '.Foreground';
  (** A constant for the INI Key for the Editor Attribute Font Style **)
  strStyleKey = '.Style';
  (** A constant for the default font size for the Editor and its gutter. **)
  iDefaultFontSize = 11;
  (** A constant to define the default editor font name and gutter font name. **)
  strDefaultFontName = 'Consolas';
  (** A constant to define whether Tracked Changes are shown. **)
  strShowTrackedChangesINIKey = 'ShowTrackedChanges';
  (** A constant to define the colour of Saved Tracked Changes. **)
  strTrackedChangesSavedColourINIKey = 'TrackedChangesSavedColour';
  (** A constant to define the colour of Modified Tracked Changes. **)
  strTrackedChangesModifiedColourINIKey = 'TrackedChangesModifiedColour';
  (** A constant to define the colour of Saved Modified Tracked Changes. **)
  strTrackedChangesSavedModifiedColourINIKey = 'TrackedChangesSavedModifiedColour';
  (** A constant to define the colour of Original Tracked Changes. **)
  strTrackedChangesOriginalColourINIKey = 'TrackedChangesOriginalColour';
  (** A constant for the INI Editor Settings Section. **)
  strIniSection = 'EditorSettings';
  (** A constant for the INI Key for the number of digits for line numbers in the gutter. **)
  strDigitCountINIKey = 'DigitCount';
  (** A constant for the INI Key whether leading zeros are shown for line numbers in the gutter. **)
  strLeadingZerosINIKey = 'LeadingZeros';
  (** A constant for the INI Key whether line numbers start at in the gutter. **)
  strZeroStartINIKey = 'ZeroStart';
  (** A constant for the INI Key what line numbers start at in the gutter. **)
  strLineNumberStartINIKey = 'LineNumberStart';
  (** A constant for the INI Key for the width of the tracked changes bar in the gutter. **)
  strTrackedChangeBarWdithINIKey = 'TrackedChangeBarWdith';

(**

  This function returns the Highlighter name from the first part of the Highlighter`s Default Filter 
  string.

  @precon  Highlighter must be a valid instance.
  @postcon Returns the Highlighter name from the first part of the Highlighter`s Default Filter string.

  @param   Highlighter as a TSynCustomHighlighter as a constant
  @return  a String

**)
Class Function TDGHCustomSynEditFunctions.HighlighterName(
  Const Highlighter : TSynCustomHighlighter) : String;

ResourceString
  strNoHighlighter = 'No Highlighter';

Var
  iPos : Integer;
  
Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.HighlighterName', tmoTiming);{$ENDIF}
  If Assigned(Highlighter) Then
    Begin
      Result := GetShortHint(Highlighter.DefaultFilter);
      iPos := Pos('(', Result);
      If iPos > 0 Then
        Delete(Result, iPos, Result.Length - iPos + 1);
      Result := Trim(Result);
    End Else
      Result := strNoHighlighter;
End;

(**

  This method loads the editor settings from the INI file.

  @precon  INIFile and Editor must be valid instances.
  @postcon The Editors base settings are loaded from the INI File.

  @param   INIFile       as a TMemIniFile as a constant
  @param   Editor        as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.LoadEditorSettings(Const INIFile: TMemIniFile;
  Const Editor: TSynEdit);

Const
  iDefaultRightMargin = 80;
  iDefaultSpacePerTab = 2;
  DefaultOptions = [eoAltSetsColumnMode, eoAutoIndent, eoDragDropEditing,
    eoEnhanceHomeKey, eoEnhanceEndKey, eoGroupUndo, eoScrollHintFollows, eoScrollPastEof,
    eoScrollPastEol, eoShowScrollHint, eoSmartTabs, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces,
    eoShowLigatures, eoCopyPlainText
  ];

Var
  eStyle : TFontStyle;
  eoption : TSynEditorOption;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.LoadEditorSettings', tmoTiming);{$ENDIF}
  Editor.Color := StringToColor(INIFile.ReadString(strIniSection, strColourKey,
    ColorToString(clWindow)));
  Editor.ActiveLineColor := StringToColor(INIFile.ReadString(strIniSection, strActiveLineColourKey,
    ColorToString(clSkyBlue)));
  Editor.Font.Name := INIFile.ReadString(strIniSection, strFontNameKey, strDefaultFontName);
  Editor.Font.Size := INIFile.ReadInteger(strIniSection, strFontSizeKey, iDefaultFontSize);
  Editor.Font.Color := StringToColor(INIFile.ReadString(strIniSection, strFontColourKey,
    ColorToString(clWindowText)));
  For eStyle := fsBold To fsStrikeOut Do
    If INIFile.ReadBool(strIniSection, strFontKey + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
      False) Then
      Editor.Font.Style := Editor.Font.Style +  [eStyle];
  Editor.WordWrap := INIFile.ReadBool(strIniSection, strWordwrapKey, False);
  For eOption := Low(TSynEditorOption) To High(TSynEditorOption) Do
    If INIFile.ReadBool(strIniSection, strOptionsKey + GetEnumName(TypeInfo(TSynEditorOption),
      Ord(eOption)), eOption In DefaultOptions) Then
      Editor.Options := Editor.Options + [eOption]
    Else
      Editor.Options := Editor.Options - [eOption];
  Editor.RightEdge := INIFile.ReadInteger(strIniSection, strRightEdgeKey, iDefaultRightMargin);
  Editor.RightEdgeColor := StringToColor(INIFile.ReadString(strIniSection, strRightEdgeColourKey,
    ColorToString(clMaroon)));
  Editor.SelectedColor.Foreground := StringToColor(INIFile.ReadString(strIniSection,
    strSelectedForegroundKey, ColorToString(clHighlightText)));
  Editor.SelectedColor.Background := StringToColor(INIFile.ReadString(strIniSection,
    strSelectedBackgroundKey, ColorToString(clHighlight)));
  Editor.TabWidth := INIFile.ReadInteger(strIniSection, strTabWidthKey, iDefaultSpacePerTab);
  Editor.WantTabs := INIFile.ReadBool(strIniSection, strWantTabsKey, True);
End;

(**

  This method loads the editor and highlighter settings from the INI file for the type of file being 
  edited.

  @precon  None.
  @postcon The editor and the highlighter has its settings loaded for the file type.

  @param   INIFile as a TMemIniFile as a constant
  @param   Editor  as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.LoadFromIniFile(Const INIFile : TMemIniFile;
  Const Editor : TSynEdit);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.LoadFromIniFile', tmoTiming);{$ENDIF}
  Editor.BeginUpdate;
  Try
    LoadEditorSettings(INIFile, Editor);
    LoadGutterSettings(INIFile, Editor);
  Finally
    Editor.EndUpdate;
  End;
End;

(**

  This method loads the given editors gutter settings from the INI file.

  @precon  INIFile and Editor must be valid instances.
  @postcon The Editors gutter settings are loaded from the INI file.

  @param   INIFile       as a TMemIniFile as a constant
  @param   Editor        as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.LoadGutterSettings(Const INIFile : TMemIniFile;
  Const Editor : TSynEdit);

Const
  iDefaultDigitCount = 4;
  iDefaultTrackChangesBarWidth = 4;

Var
  eStyle : TFontStyle;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.LoadGutterSettings', tmoTiming);{$ENDIF}
  Editor.Gutter.Visible := INIFile.ReadBool(strIniSection, strShowGutter, True);
  Editor.Gutter.UseFontStyle := Not INIFile.ReadBool(strIniSection, strUseEditorFontKey, True);
  Editor.Gutter.Font.Name := INIFile.ReadString(strIniSection, strGutterFontNameKey, strDefaultFontName);
  Editor.Gutter.Font.Size := INIFile.ReadInteger(strIniSection, strGutterFontSizeKey, iDefaultFontSize);
  Editor.Gutter.Font.Color := StringToColor(INIFile.ReadString(strIniSection, strGutterFontColourKey,
    ColorToString(clWindowText)));
  For eStyle := fsBold To fsStrikeOut Do
    If INIFile.ReadBool(strIniSection, strGutterFontKey + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
      False) Then
      Editor.Font.Style := Editor.Font.Style +  [eStyle];
  Editor.Gutter.AutoSize := INIFile.ReadBool(strIniSection, strAutoSizeKey, False);
  Editor.Gutter.Color := StringToColor(INIFile.ReadString(strIniSection, strGutterColourKey,
    ColorToString(clBtnFace)));
  Editor.Gutter.BorderColor := StringToColor(INIFile.ReadString(strIniSection, strGutterBorderColourKey,
    ColorToString(clWindow)));
  Editor.Gutter.ShowLineNumbers := INIFile.ReadBool(strIniSection, strShowLineNumbersKey, True);
  Editor.Gutter.TrackChanges.Visible := INIFile.ReadBool(strIniSection, strShowTrackedChangesINIKey,
    True);
  Editor.Gutter.TrackChanges.Width := INIFile.ReadInteger(strIniSection, strTrackedChangeBarWdithINIKey,
    iDefaultTrackChangesBarWidth);
  Editor.Gutter.TrackChanges.SavedColor := StringToColor(INIFile.ReadString(strIniSection,
    strTrackedChangesSavedColourINIKey, ColorToString(clLime)));
  Editor.Gutter.TrackChanges.ModifiedColor := StringToColor(INIFile.ReadString(strIniSection,
    strTrackedChangesModifiedColourINIKey, ColorToString(clRed)));
  Editor.Gutter.TrackChanges.SavedModifiedColor := StringToColor(INIFile.ReadString(strIniSection,
    strTrackedChangesSavedModifiedColourINIKey, ColorToString(clYellow)));
  Editor.Gutter.TrackChanges.OriginalColor := StringToColor(INIFile.ReadString(strIniSection,
    strTrackedChangesOriginalColourINIKey, ColorToString(clFuchsia)));
  Editor.Gutter.DigitCount := INIFile.ReadInteger(strIniSection, strDigitCountINIKey, iDefaultDigitCount);
  Editor.Gutter.LeadingZeros := INIFile.ReadBool(strIniSection, strLeadingZerosINIKey, False);
  Editor.Gutter.ZeroStart := INIFile.ReadBool(strIniSection, strZeroStartINIKey, False);
  Editor.Gutter.LineNumberStart := INIFile.ReadInteger(strIniSection, strLineNumberStartINIKey, 1);
End;

(**

  This method loads the given highlighter information from the given INI file.

  @precon  INIFile and Highlighter must be valid instances.
  @postcon Loads the given highlighter information from the given INI file.

  @param   INIFile     as a TMemIniFile as a constant
  @param   Highlighter as a TSynCustomHighlighter as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.LoadHighlighterFromINIFile(Const INIFile : TMemIniFile;
  Const Highlighter: TSynCustomHighlighter);

  (**

    This procedure loads the properties of the given attribute from the information stored in the INI
    File.

    @precon  A must be a valid instance.
    @postcon The attribute has its settings loaded from the INI file.

    @param   A       as a TSynHighlighterAttributes as a constant
    @param   strKey  as a String as a constant
    @param   strName as a String as a constant

  **)
  Procedure LoadAttribute(Const A : TSynHighlighterAttributes; Const strKey, strName : String);

  Begin
    {$IFDEF CODESITE}CodeSite.TraceMethod('LoadAttribute', tmoTiming);{$ENDIF}
    A.Background := StringToColor(INIFile.ReadString(strKey, strName + strBackgroundKey,
      ColorToString(A.Background)));
    A.Foreground := StringToColor(INIFile.ReadString(strKey, strName + strForegroundKey,
      ColorToString(A.Foreground)));
    A.Style := TFontStyles(Byte(INIFile.ReadInteger(strKey, strName + strStyleKey,
      Byte(A.Style))));
  End;

Var
  iAttr : Integer;
  A : TSynHighlighterAttributes;
  M : TSynMultiSyn;
  S : TScheme;
  strName : String;
  iScheme : Integer;

begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.LoadHighlighterFromINIFile', tmoTiming);{$ENDIF}
  Highlighter.BeginUpdate;
  Try
    If Assigned(Highlighter) Then
      Begin
        If Highlighter Is TSynMultiSyn Then
          Begin
            M := Highlighter As TSynMultiSyn;
            If M.DefaultHighlighter.Tag < 0 Then
              LoadHighlighterFromINIFile(INIFile, M.DefaultHighlighter);
            For iScheme := 0 To M.Schemes.Count - 1 Do
              Begin
                S := M.Schemes[iScheme] As TScheme;
                A := S.MarkerAttri;
                strName := Format('%s:%s', [S.SchemeName, A.Name]);
                LoadAttribute(A, HighlighterName(M), strName);
                If Highlighter.Tag < 0 Then
                  LoadHighlighterFromINIFile(INIFile, S.Highlighter);
              End;
          End Else
            For iAttr := 0 To Highlighter.AttrCount - 1 Do
              Begin
                A := Highlighter.Attribute[iAttr];
                LoadAttribute(A, HighlighterName(Highlighter), A.Name);
              End;
        Highlighter.Tag := 0;
      End;
  Finally
    Highlighter.EndUpdate;
  End;    
end;

(**

  This method saves the editor settings to the INI file.

  @precon  INIFile and Editor must be valid instances.
  @postcon The Editors base settings are saved to the INI File.

  @param   INIFile       as a TMemIniFile as a constant
  @param   Editor        as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.SaveEditorSettings(Const INIFile: TMemIniFile;
  Const Editor: TSynEdit);

Var
  eStyle : TFontStyle;
  eOption : TSynEditorOption;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.SaveEditorSettings', tmoTiming);{$ENDIF}
  INIFile.WriteString(strIniSection, strColourKey, ColorToString(Editor.Color));
  INIFile.WriteString(strIniSection, strActiveLineColourKey, ColorToString(Editor.ActiveLineColor));
  INIFile.WriteString(strIniSection, strFontNameKey, Editor.Font.Name);
  INIFile.WriteInteger(strIniSection, strFontSizeKey, Editor.Font.Size);
  INIFile.WriteString(strIniSection, strFontColourKey, ColorToString(Editor.Font.Color));
  For eStyle := fsBold To fsStrikeOut Do
    INIFile.WriteBool(strIniSection, strFontKey + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
      eStyle In Editor.Font.Style);
  INIFile.WriteBool(strIniSection, strWordwrapKey, Editor.WordWrap);
  For eOption := Low(TSynEditorOption) To High(TSynEditorOption) Do 
    INIFile.WriteBool(strIniSection, strOptionsKey + GetEnumName(TypeInfo(TSynEditorOption),
      Ord(eOption)), eOption In Editor.Options);
  INIFile.WriteInteger(strIniSection, strRightEdgeKey, Editor.RightEdge);
  INIFile.WriteString(strIniSection, strRightEdgeColourKey, ColorToString(Editor.RightEdgeColor));
  INIFile.WriteString(strIniSection, strSelectedForegroundKey,
    ColorToString(Editor.SelectedColor.Foreground));
  INIFile.WriteString(strIniSection, strSelectedBackgroundKey,
    ColorToString(Editor.SelectedColor.Background));
  INIFile.WriteInteger(strIniSection, strTabWidthKey, Editor.TabWidth);
  INIFile.WriteBool(strIniSection, strWantTabsKey, Editor.WantTabs);
End;

(**

  This method saves the given editors gutter settings to the INI file.

  @precon  INIFile and Editor must be valid instances.
  @postcon The Editors gutter settings are saved to the INI file.

  @param   INIFile       as a TMemIniFile as a constant
  @param   Editor        as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.SaveGutterSettings(Const INIFile: TMemIniFile;
  Const Editor: TSynEdit);

Var
  eStyle: TFontStyle;

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.SaveGutterSettings', tmoTiming);{$ENDIF}
  INIFile.WriteBool(strIniSection, strShowGutter, Editor.Gutter.Visible);
  INIFile.WriteBool(strIniSection, strUseEditorFontKey, Not Editor.Gutter.UseFontStyle);
  INIFile.WriteString(strIniSection, strGutterFontNameKey, Editor.Gutter.Font.Name);
  INIFile.WriteInteger(strIniSection, strGutterFontSizeKey, Editor.Gutter.Font.Size);
  INIFile.WriteString(strIniSection, strGutterFontColourKey, ColorToString(Editor.Gutter.Font.Color));
  For eStyle := fsBold To fsStrikeOut Do
    INIFile.WriteBool(strIniSection, strGutterFontKey + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
      eStyle In Editor.Gutter.Font.Style);
  INIFile.WriteBool(strIniSection, strAutoSizeKey, Editor.Gutter.AutoSize);
  INIFile.WriteString(strIniSection, strGutterColourKey, ColorToString(Editor.Gutter.Color));
  INIFile.WriteString(strIniSection, strGutterBorderColourKey, ColorToString(Editor.Gutter.BorderColor));
  INIFile.WriteBool(strIniSection, strShowLineNumbersKey, Editor.Gutter.ShowLineNumbers);
  INIFile.WriteBool(strIniSection, strShowTrackedChangesINIKey, Editor.Gutter.TrackChanges.Visible);
  INIFile.WriteInteger(strIniSection, strTrackedChangeBarWdithINIKey, Editor.Gutter.TrackChanges.Width);
  INIFile.WriteString(strIniSection, strTrackedChangesSavedColourINIKey,
    ColorToString(Editor.Gutter.TrackChanges.SavedColor));
  INIFile.WriteString(strIniSection, strTrackedChangesModifiedColourINIKey,
    ColorToString(Editor.Gutter.TrackChanges.ModifiedColor));
  INIFile.WriteString(strIniSection, strTrackedChangesSavedModifiedColourINIKey,
    ColorToString(Editor.Gutter.TrackChanges.SavedModifiedColor));
  INIFile.WriteString(strIniSection, strTrackedChangesOriginalColourINIKey,
    ColorToString(Editor.Gutter.TrackChanges.OriginalColor));
  INIFile.WriteInteger(strIniSection, strDigitCountINIKey, Editor.Gutter.DigitCount);
  INIFile.WriteBool(strIniSection, strLeadingZerosINIKey, Editor.Gutter.LeadingZeros);
  INIFile.WriteBool(strIniSection, strZeroStartINIKey, Editor.Gutter.ZeroStart);
  INIFile.WriteInteger(strIniSection, strLineNumberStartINIKey, Editor.Gutter.LineNumberStart);
End;

(**

  This method saves the given highlighter to the given INI file.

  @precon  INIFile and Highlighter must be valid instances.
  @postcon Saves the given highlighter to the given INI file.

  @param   INIFile     as a TMemIniFile as a constant
  @param   Highlighter as a TSynCustomHighlighter as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.SaveHighlighterToINIFile(Const INIFile : TMemIniFile;
  Const Highlighter : TSynCustomHighlighter);

  (**

    This procedure save the given attribute to the INI File.

    @precon  A must be a valid instance.
    @postcon The attribute is saved to the INI file.

    @param   A       as a TSynHighlighterAttributes as a constant
    @param   strKey  as a String as a constant
    @param   strName as a String as a constant

  **)
  Procedure SaveAttribute(Const A : TSynHighlighterAttributes; Const strKey, strName : String);

  Begin
    {$IFDEF CODESITE}CodeSite.TraceMethod('SaveAttribute', tmoTiming);{$ENDIF}
    INIFile.WriteString(strKey, strName + strBackgroundKey, ColorToString(A.Background));
    INIFile.WriteString(strKey, strName + strForegroundKey, ColorToString(A.Foreground));
    INIFile.WriteInteger(strKey, strName + strStyleKey, Byte(A.Style));
  End;

Var
  iAttr : Integer;
  A : TSynHighlighterAttributes;
  S : TScheme;
  M : TSynMultiSyn;
  iScheme : Integer;
  strName : String;

begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.SaveHighlighterToINIFile', tmoTiming);{$ENDIF}
  If Assigned(Highlighter) Then
    Begin
      If Highlighter Is TSynMultiSyn Then
        Begin
          M := Highlighter As TSynMultiSyn;
          For iScheme := 0 To M.Schemes.Count - 1 Do
            Begin
              S := M.Schemes[iScheme] As TScheme;
              A := S.MarkerAttri;
              strName := Format('%s:%s', [S.SchemeName, A.Name]);
              SaveAttribute(A, HighlighterName(M), strName);
            End;
        End Else
        For iAttr := 0 To Highlighter.AttrCount - 1 Do
          Begin
            A := Highlighter.Attribute[iAttr];
            SaveAttribute(A, HighlighterName(Highlighter), A.Name);
          End;
      INIFile.UpdateFile;
    End;
End;

(**

  This method saves the editor and highlighter settings to the INI file for the type of file being edited
  .

  @precon  None.
  @postcon The editor and the highlighter has its settings saved for the file type.

  @param   INIFile as a TMemIniFile as a constant
  @param   Editor  as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.SaveToIniFile(Const INIFile : TMemIniFile;
  Const Editor : TSynEdit);

Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.SaveToIniFile', tmoTiming);{$ENDIF}
  SaveEditorSettings(INIFile, Editor);
  SaveGutterSettings(INIFile, Editor);
  INIFile.UpdateFile();
End;

End.

