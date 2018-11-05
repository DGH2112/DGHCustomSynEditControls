(**
  
  This module provides a set of useful utility functions for working with SynEdit controls and allows
  the loading and saving of the settings.

  @Author  David Hoyle
  @Version 1.0
  @Date    05 Nov 2018
  
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
    Class Procedure LoadGutterSettings(Const INIFile : TMemIniFile; Const strIniSection : String;
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
  System.SysUtils,
  System.TypInfo,
  System.StrUtils,
  VCL.Controls,
  VCL.Graphics,
  SynHighlighterMulti;

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

Var
  iPos : Integer;
  
Begin
  If Assigned(Highlighter) Then
    Begin
      Result := GetShortHint(Highlighter.DefaultFilter);
      iPos := Pos('(', Result);
      If iPos > 0 Then
        Delete(Result, iPos, Result.Length - iPos + 1);
      Result := Trim(Result);
    End Else
      Result := 'No Highlighter';
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

Const
  iDefaultFonrSize = 11;
  iDefaultRightMargin = 80;
  iDefaultSpacePerTab = 2;
  iDefaultMaxScrollWidth = 8192;

Var
  strIniSection : String;
  eStyle : TFontStyle;
  DefaultOptions : TSynEditorOptions;
  eoption : TSynEditorOption;
  
Begin
  strIniSection := IfThen(Assigned(Editor.Highlighter), HighlighterName(Editor.Highlighter),
    'General');
  Editor.Color := StringToColor(INIFile.ReadString(strIniSection, 'Colour', ColorToString(clWindow)));
  Editor.ActiveLineColor := StringToColor(INIFile.ReadString(strIniSection, 'Active Line Colour',
    ColorToString(clSkyBlue)));
  Editor.Font.Name := INIFile.ReadString(strIniSection, 'Font Name', 'Consolas');
  Editor.Font.Size := INIFile.ReadInteger(strIniSection, 'Font Size', iDefaultFonrSize);
  Editor.Font.Color := StringToColor(INIFile.ReadString(strIniSection, 'Font Colour',
    ColorToString(clWindowText)));
  For eStyle := fsBold To fsStrikeOut Do
    If INIFile.ReadBool(strIniSection, 'Font.' + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
      False) Then
      Editor.Font.Style := Editor.Font.Style +  [eStyle];
  Editor.WordWrap := INIFile.ReadBool(strIniSection, 'Wordwrap', False);
  LoadGutterSettings(INIFile, strIniSection, Editor);
  DefaultOptions := [eoAltSetsColumnMode, eoAutoIndent, eoAutoSizeMaxScrollWidth, eoDragDropEditing,
    eoEnhanceHomeKey, eoEnhanceEndKey, eoGroupUndo, eoScrollHintFollows, eoScrollPastEof,
    eoScrollPastEol, eoShowScrollHint, eoSmartTabs, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces];
  For eOption := Low(TSynEditorOption) To High(TSynEditorOption) Do
    If INIFile.ReadBool(strIniSection, 'Options.' + GetEnumName(TypeInfo(TSynEditorOption),
      Ord(eOption)), eOption In DefaultOptions) Then
      Editor.Options := Editor.Options + [eOption];
  Editor.RightEdge := INIFile.ReadInteger(strIniSection, 'Right Edge', iDefaultRightMargin);
  Editor.RightEdgeColor := StringToColor(INIFile.ReadString(strIniSection, 'Right Edge Colour',
    ColorToString(clMaroon)));
  Editor.SelectedColor.Foreground := StringToColor(INIFile.ReadString(strIniSection,
    'Selected Foreground', ColorToString(clHighlightText)));
  Editor.SelectedColor.Background := StringToColor(INIFile.ReadString(strIniSection,
    'Selected Background', ColorToString(clHighlight)));
  Editor.TabWidth := INIFile.ReadInteger(strIniSection, 'Tab Width', iDefaultSpacePerTab);
  Editor.WantTabs := INIFile.ReadBool(strIniSection, 'WantTabs', true);
  Editor.MaxScrollWidth := INIFile.ReadInteger(strIniSection, 'MaxScrollWidth', iDefaultMaxScrollWidth);
  Editor.FontSmoothing := fsmClearType;
  Editor.Gutter.Font.Assign(Editor.Font);
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

Begin
  Editor.Gutter.AutoSize := INIFile.ReadBool(strIniSection, 'AutoSize', False);
  Editor.Gutter.Width := INIFile.ReadInteger(strIniSection, 'Gutter Width', iDefaultGutterWidth);
  Editor.Gutter.Color := StringToColor(INIFile.ReadString(strIniSection, 'Gutter Colour',
    ColorToString(clBtnFace)));
  Editor.Gutter.BorderColor := StringToColor(INIFile.ReadString(strIniSection, 'Gutter Border Colour',
    ColorToString(clWindow)));
  Editor.Gutter.ShowModification := INIFile.ReadBool(strIniSection, 'ShowModification', True);
  Editor.Gutter.ModificationColorModified := StringToColor(INIFile.ReadString(strIniSection,
    'ModificationColourModified', ColorToString(clRed)));
  Editor.Gutter.ModificationColorSaved := StringToColor(INIFile.ReadString(strIniSection,
    'ModificationColourSaved', ColorToString(clGreen)));
  Editor.Gutter.ModificationBarWidth := INIFile.ReadInteger(strIniSection, 'ModificationBarWidth',
    iDefaultModificationBarWidth);
  Editor.Gutter.ShowLineNumbers := INIFile.ReadBool(strIniSection, 'Show Line Numbers', True);
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

Var
  iAttr : Integer;
  A : TSynHighlighterAttributes;
  strKey : String;
  M : TSynMultiSyn;
  S : TScheme;
  strName : String;
  iScheme : Integer;

begin
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
              strKey := HighlighterName(M);
              strName := Format('%s:%s', [S.SchemeName, A.Name]);
              A.Background := StringToColor(INIFile.ReadString(strKey, strName + '.Background',
                ColorToString(A.Background)));
              A.Foreground := StringToColor(INIFile.ReadString(strKey, strName + '.Foreground',
                ColorToString(A.Foreground)));
              A.Style := TFontStyles(Byte(INIFile.ReadInteger(strKey, strName + '.Style',
                Byte(A.Style))));
              If Highlighter.Tag < 0 Then
                LoadHighlighterFromINIFile(INIFile, S.Highlighter);
            End;
        End Else
          For iAttr := 0 To Highlighter.AttrCount - 1 Do
            Begin
              A := Highlighter.Attribute[iAttr];
              strKey := HighlighterName(Highlighter);
              A.Background := StringToColor(INIFile.ReadString(strKey, A.Name + '.Background',
                ColorToString(A.Background)));
              A.Foreground := StringToColor(INIFile.ReadString(strKey, A.Name + '.Foreground',
                ColorToString(A.Foreground)));
              A.Style := TFontStyles(Byte(INIFile.ReadInteger(strKey, A.Name + '.Style',
                Byte(A.Style))));
            End;
      Highlighter.Tag := 0;
    End;
end;

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

Begin
  INIFile.WriteBool(strIniSection, 'AutoSize', Editor.Gutter.AutoSize);
  INIFile.WriteInteger(strIniSection, 'Gutter Width', Editor.Gutter.Width);
  INIFile.WriteString(strIniSection, 'Gutter Colour', ColorToString(Editor.Gutter.Color));
  INIFile.WriteString(strIniSection, 'Gutter Border Colour', ColorToString(Editor.Gutter.BorderColor));
  INIFile.WriteBool(strIniSection, 'ShowModification', Editor.Gutter.ShowModification);
  INIFile.WriteString(strIniSection, 'ModificationColourModified',
    ColorToString(Editor.Gutter.ModificationColorModified));
  INIFile.WriteString(strIniSection, 'ModificationColourSaved',
    ColorToString(Editor.Gutter.ModificationColorSaved));
  INIFile.WriteInteger(strIniSection, 'ModificationBarWidth', Editor.Gutter.ModificationBarWidth);
  INIFile.WriteBool(strIniSection, 'Show Line Numbers', Editor.Gutter.ShowLineNumbers);
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

Var
  iAttr : Integer;
  A : TSynHighlighterAttributes;
  strKey : String;
  S : TScheme;
  M : TSynMultiSyn;
  iScheme : Integer;
  strName : String;

begin
  If Assigned(Highlighter) Then
    Begin
      If Highlighter Is TSynMultiSyn Then
        Begin
          M := Highlighter As TSynMultiSyn;
          For iScheme := 0 To M.Schemes.Count - 1 Do
            Begin
              S := M.Schemes[iScheme] As TScheme;
              A := S.MarkerAttri;
              strKey := HighlighterName(M);
              strName := Format('%s:%s', [S.SchemeName, A.Name]);
              INIFile.WriteString(strKey, strName + '.Background', ColorToString(A.Background));
              INIFile.WriteString(strKey, strName + '.Foreground', ColorToString(A.Foreground));
              INIFile.WriteInteger(strKey, strName + '.Style', Byte(A.Style));
            End;
        End Else
        For iAttr := 0 To Highlighter.AttrCount - 1 Do
          Begin
            A := Highlighter.Attribute[iAttr];
            strKey := HighlighterName(Highlighter);
            INIFile.WriteString(strKey, A.Name + '.Background', ColorToString(A.Background));
            INIFile.WriteString(strKey, A.Name + '.Foreground', ColorToString(A.Foreground));
            INIFile.WriteInteger(strKey, A.Name + '.Style', Byte(A.Style));
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
  eStyle : TFontStyle;
  eOption : TSynEditorOption;
  
Begin
  strIniSection := IfThen(Assigned(Editor.Highlighter), HighlighterName(Editor.Highlighter), 
    'General');
  INIFile.WriteString(strIniSection, 'Colour', ColorToString(Editor.Color));
  INIFile.WriteString(strIniSection, 'Active Line Colour', ColorToString(Editor.ActiveLineColor));
  INIFile.WriteString(strIniSection, 'Font Name', Editor.Font.Name);
  INIFile.WriteInteger(strIniSection, 'Font Size', Editor.Font.Size);
  INIFile.WriteString(strIniSection, 'Font Colour', ColorToString(Editor.Font.Color));
  For eStyle := fsBold To fsStrikeOut Do
    INIFile.WriteBool(strIniSection, 'Font.' + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
      eStyle In Editor.Font.Style);
  INIFile.WriteBool(strIniSection, 'Wordwrap', Editor.WordWrap);
  SaveGutterSettings(INIFile, strIniSection, Editor);
  For eOption := Low(TSynEditorOption) To High(TSynEditorOption) Do 
    INIFile.WriteBool(strIniSection, 'Options.' + GetEnumName(TypeInfo(TSynEditorOption),
      Ord(eOption)), eOption In Editor.Options);
  INIFile.WriteInteger(strIniSection, 'Right Edge', Editor.RightEdge);
  INIFile.WriteString(strIniSection, 'Right Edge Colour', ColorToString(Editor.RightEdgeColor));
  INIFile.WriteString(strIniSection, 'Selected Foreground',
    ColorToString(Editor.SelectedColor.Foreground));
  INIFile.WriteString(strIniSection, 'Selected Background',
    ColorToString(Editor.SelectedColor.Background));
  INIFile.WriteInteger(strIniSection, 'Tab Width', Editor.TabWidth);
  INIFile.WriteBool(strIniSection, 'WantTabs', Editor.WantTabs);
  INIFile.WriteInteger(strIniSection, 'MaxScrollWidth', Editor.MaxScrollWidth);
  SaveHighlighterToINIFile(INIFile, Editor.Highlighter);
  INIFile.UpdateFile();
End;

End.
