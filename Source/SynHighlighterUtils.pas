(**
  
  This module provides a set of useful utility functions for working with SynEdit controls and allows
  the loading and saving of the settings.

  @Author  David Hoyle
  @Version 1.0
  @Date    11 Nov 2018
  
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
    Class Procedure LoadEditorSettings(Const INIFile : TMemIniFile; Const strIniSection : String;
      Const Editor : TSynEdit); Static;
    Class Procedure LoadGutterSettings(Const INIFile : TMemIniFile; Const strIniSection : String;
      Const Editor : TSynEdit); Static;
    Class Procedure SaveEditorSettings(Const INIFile : TMemIniFile; Const strIniSection : String;
      Const Editor : TSynEdit); Static;
    Class Procedure SaveGutterSettings(Const INIFile : TMemIniFile; Const strIniSection : String;
      Const Editor : TSynEdit); Static;
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
  {$IFDEF DEBUG}
  CodeSiteLogging,
  {$ENDIF}
  System.SysUtils,
  System.Classes,
  System.TypInfo,
  System.StrUtils,
  System.UITypes,
  VCL.Controls,
  VCL.Graphics,
  SynHighlighterMulti;

Const
  (** A constant for the default highlighter name. **)
  strDefaultHighlightName = 'General';
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
  (** A constant for the INI Key for the Editor Wordwrap **)
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
  (** A constant for the INI Key for the Editor Gutter Autosize **)
  strAutoSizeKey = 'AutoSize';
  (** A constant for the INI Key for the Editor Gutter Width **)
  strGutterWidthKey = 'Gutter Width';
  (** A constant for the INI Key for the Editor Gutter Colour **)
  strGutterColourKey = 'Gutter Colour';
  (** A constant for the INI Key for the Editor Gutter Border Colour **)
  strGutterBorderColourKey = 'Gutter Border Colour';
  (** A constant for the INI Key for the Editor Gutter Modifications **)
  strShowModificationKey = 'ShowModification';
  (** A constant for the INI Key for the Editor Gutter Modification Colour **)
  strModificationColourModifiedKey = 'ModificationColourModified';
  (** A constant for the INI Key for the Editor Gutter Modification Saved Colour **)
  strModificationColourSavedKey = 'ModificationColourSaved';
  (** A constant for the INI Key for the Editor Gutter Modication Bar Width **)
  strModificationBarWidthKey = 'ModificationBarWidth';
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
  (** A constant for the INI Key for the Editor Max Scroll Width **)
  strMaxScrollWidthKey = 'MaxScrollWidth';
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
  @param   strIniSection as a String as a constant
  @param   Editor        as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.LoadEditorSettings(Const INIFile: TMemIniFile;
  Const strIniSection: String; Const Editor: TSynEdit);

Const
  iDefaultRightMargin = 80;
  iDefaultSpacePerTab = 2;
  iDefaultMaxScrollWidth = 8192;
  DefaultOptions = [eoAltSetsColumnMode, eoAutoIndent, eoAutoSizeMaxScrollWidth, eoDragDropEditing,
    eoEnhanceHomeKey, eoEnhanceEndKey, eoGroupUndo, eoScrollHintFollows, eoScrollPastEof,
    eoScrollPastEol, eoShowScrollHint, eoSmartTabs, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces];

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
      Editor.Options := Editor.Options + [eOption];
  Editor.RightEdge := INIFile.ReadInteger(strIniSection, strRightEdgeKey, iDefaultRightMargin);
  Editor.RightEdgeColor := StringToColor(INIFile.ReadString(strIniSection, strRightEdgeColourKey,
    ColorToString(clMaroon)));
  Editor.SelectedColor.Foreground := StringToColor(INIFile.ReadString(strIniSection,
    strSelectedForegroundKey, ColorToString(clHighlightText)));
  Editor.SelectedColor.Background := StringToColor(INIFile.ReadString(strIniSection,
    strSelectedBackgroundKey, ColorToString(clHighlight)));
  Editor.TabWidth := INIFile.ReadInteger(strIniSection, strTabWidthKey, iDefaultSpacePerTab);
  Editor.WantTabs := INIFile.ReadBool(strIniSection, strWantTabsKey, True);
  Editor.MaxScrollWidth := INIFile.ReadInteger(strIniSection, strMaxScrollWidthKey,
    iDefaultMaxScrollWidth);
  Editor.FontSmoothing := fsmClearType;
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

Var
  strIniSection : String;
  
Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.LoadFromIniFile', tmoTiming);{$ENDIF}
  strIniSection := IfThen(Assigned(Editor.Highlighter), HighlighterName(Editor.Highlighter),
    strDefaultHighlightName);
  LoadEditorSettings(INIFile, strIniSection, Editor);
  LoadGutterSettings(INIFile, strIniSection, Editor);
  LoadHighlighterFromINIFile(INIFile, Editor.Highlighter);
End;

(**

  This method loads the given editors gutter settings from the INI file.

  @precon  INIFile and Editor must be valid instances.
  @postcon The Editors gutter setings are loade from the INI file.

  @param   INIFile       as a TMemIniFile as a constant
  @param   strIniSection as a String as a constant
  @param   Editor        as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.LoadGutterSettings(Const INIFile : TMemIniFile;
  Const strIniSection : String; Const Editor : TSynEdit);

Const
  iDefaultGutterWidth = 30;
  iDefaultModificationBarWidth = 4;

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
  Editor.Gutter.Width := INIFile.ReadInteger(strIniSection, strGutterWidthKey, iDefaultGutterWidth);
  Editor.Gutter.Color := StringToColor(INIFile.ReadString(strIniSection, strGutterColourKey,
    ColorToString(clBtnFace)));
  Editor.Gutter.BorderColor := StringToColor(INIFile.ReadString(strIniSection, strGutterBorderColourKey,
    ColorToString(clWindow)));
  Editor.Gutter.ShowModification := INIFile.ReadBool(strIniSection, strShowModificationKey, True);
  Editor.Gutter.ModificationColorModified := StringToColor(INIFile.ReadString(strIniSection,
    strModificationColourModifiedKey, ColorToString(clRed)));
  Editor.Gutter.ModificationColorSaved := StringToColor(INIFile.ReadString(strIniSection,
    strModificationColourSavedKey, ColorToString(clGreen)));
  Editor.Gutter.ModificationBarWidth := INIFile.ReadInteger(strIniSection, strModificationBarWidthKey,
    iDefaultModificationBarWidth);
  Editor.Gutter.ShowLineNumbers := INIFile.ReadBool(strIniSection, strShowLineNumbersKey, True);
End;

(**

  This method loads the given highlighter information from the given ini file.

  @precon  INIFile and Highlighter must be valid instances.
  @postcon Loads the given highlighter information from the given ini file.

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
end;

(**

  This method saves the editor settings to the INI file.

  @precon  INIFile and Editor must be valid instances.
  @postcon The Editors base settings are saved to the INI File.

  @param   INIFile       as a TMemIniFile as a constant
  @param   strIniSection as a String as a constant
  @param   Editor        as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.SaveEditorSettings(Const INIFile: TMemIniFile;
  Const strIniSection: String; Const Editor: TSynEdit);

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
  INIFile.WriteInteger(strIniSection, strMaxScrollWidthKey, Editor.MaxScrollWidth);
End;

(**

  This method saves the given editors gutter settings to the INI file.

  @precon  INIFile and Editor must be valid instances.
  @postcon The Editors gutter setings are saved to the INI file.

  @param   INIFile       as a TMemIniFile as a constant
  @param   strIniSection as a String as a constant
  @param   Editor        as a TSynEdit as a constant

**)
Class Procedure TDGHCustomSynEditFunctions.SaveGutterSettings(Const INIFile: TMemIniFile;
  Const strIniSection: String; Const Editor: TSynEdit);

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
  INIFile.WriteInteger(strIniSection, strGutterWidthKey, Editor.Gutter.Width);
  INIFile.WriteString(strIniSection, strGutterColourKey, ColorToString(Editor.Gutter.Color));
  INIFile.WriteString(strIniSection, strGutterBorderColourKey, ColorToString(Editor.Gutter.BorderColor));
  INIFile.WriteBool(strIniSection, strShowModificationKey, Editor.Gutter.ShowModification);
  INIFile.WriteString(strIniSection, strModificationColourModifiedKey,
    ColorToString(Editor.Gutter.ModificationColorModified));
  INIFile.WriteString(strIniSection, strModificationColourSavedKey,
    ColorToString(Editor.Gutter.ModificationColorSaved));
  INIFile.WriteInteger(strIniSection, strModificationBarWidthKey, Editor.Gutter.ModificationBarWidth);
  INIFile.WriteBool(strIniSection, strShowLineNumbersKey, Editor.Gutter.ShowLineNumbers);
End;

(**

  This method saves the given highlighter to the given ini file.

  @precon  INIFile and Highlighter must be valid instances.
  @postcon Saves the given highlighter to the given ini file.

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

Var
  strIniSection : String;
  
Begin
  {$IFDEF CODESITE}CodeSite.TraceMethod('TDGHCustomSynEditFunctions.SaveToIniFile', tmoTiming);{$ENDIF}
  strIniSection := IfThen(Assigned(Editor.Highlighter), HighlighterName(Editor.Highlighter), 
    strDefaultHighlightName);
  SaveEditorSettings(INIFile, strIniSection, Editor);
  SaveGutterSettings(INIFile, strIniSection, Editor);
  SaveHighlighterToINIFile(INIFile, Editor.Highlighter);
  INIFile.UpdateFile();
End;

End.

