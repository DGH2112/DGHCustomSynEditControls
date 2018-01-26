Unit SynHighlighterUtils;

Interface

Uses
  SynEdit,
  SynEditHighlighter,
  System.IniFiles;

  Function  HighlighterName(Const Highlighter : TSynCustomHighlighter) : String;
  Procedure LoadFromIniFile(Const strIniFile : String; Const Editor : TSynEdit);
  procedure LoadHighlighterFromINIFile(Const INIFile : TCustomIniFile;
    Const Highlighter: TSynCustomHighlighter);
  Procedure SaveToIniFile(Const strIniFile : String; Const Editor : TSynEdit);
  Procedure SaveHighlighterToINIFile(Const INIFile : TCustomIniFile;
    Const Highlighter : TSynCustomHighlighter);

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
Function HighlighterName(Const Highlighter : TSynCustomHighlighter) : String;

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

  @param   strIniFile as a String as a constant
  @param   Editor     as a TSynEdit as a constant

**)
Procedure LoadFromIniFile(Const strIniFile : String; Const Editor : TSynEdit);

Var
  iniFile : TCustomIniFile;
  strIniSection : String;
  eStyle : TFontStyle;
  DefaultOptions : TSynEditorOptions;
  eoption : TSynEditorOption;
  
Begin
  iniFile := TMemIniFile.Create(strIniFile);
  Try
    strIniSection := IfThen(Assigned(Editor.Highlighter), HighlighterName(Editor.Highlighter),
      'General');
    Editor.Color := StringToColor(iniFile.ReadString(strIniSection, 'Colour', ColorToString(clWindow)));
    Editor.ActiveLineColor := StringToColor(iniFile.ReadString(strIniSection, 'Active Line Colour',
      ColorToString(clSkyBlue)));
    Editor.Font.Name := iniFile.ReadString(strIniSection, 'Font Name', 'Consolas');
    Editor.Font.Size := iniFile.ReadInteger(strIniSection, 'Font Size', 11);
    Editor.Font.Color := StringToColor(iniFile.ReadString(strIniSection, 'Font Colour',
      ColorToString(clWindowText)));
    For eStyle := fsBold To fsStrikeOut Do
      If iniFile.ReadBool(strIniSection, 'Font.' + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
        False) Then
        Editor.Font.Style := Editor.Font.Style +  [eStyle];
    Editor.WordWrap := iniFile.ReadBool(strIniSection, 'Wordwrap', False);
    Editor.Gutter.ShowLineNumbers := iniFile.ReadBool(strIniSection, 'Show Line Numbers', True);
    Editor.Gutter.ShowModification := iniFile.ReadBool(strIniSection, 'ShowModification', True);
    Editor.Gutter.AutoSize := iniFile.ReadBool(strIniSection, 'AutoSize', True);
    Editor.Gutter.ModificationColorModified := StringToColor(iniFile.ReadString(strIniSection,
      'ModificationColourModified', ColorToString(clRed)));
    Editor.Gutter.ModificationColorSaved := StringToColor(iniFile.ReadString(strIniSection,
      'ModificationColourSaved', ColorToString(clGreen)));
    Editor.Gutter.ModificationBarWidth := iniFile.ReadInteger(strIniSection, 'ModificationBarWidth', 4);
    DefaultOptions := [eoAltSetsColumnMode, eoAutoIndent, eoAutoSizeMaxScrollWidth, eoDragDropEditing,
      eoEnhanceHomeKey, eoEnhanceEndKey, eoGroupUndo, eoScrollHintFollows, eoScrollPastEof,
      eoScrollPastEol, eoShowScrollHint, eoSmartTabs, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces];
    For eOption := Low(TSynEditorOption) To High(TSynEditorOption) Do
      If iniFile.ReadBool(strIniSection, 'Options.' + GetEnumName(TypeInfo(TSynEditorOption),
        Ord(eOption)), eOption In DefaultOptions) Then
        Editor.Options := Editor.Options + [eOption];
    Editor.RightEdge := iniFile.ReadInteger(strIniSection, 'Right Edge', 80);
    Editor.RightEdgeColor := StringToColor(iniFile.ReadString(strIniSection, 'Right Edge Colour',
      ColorToString(clMaroon)));
    Editor.SelectedColor.Foreground := StringToColor(iniFile.ReadString(strIniSection,
      'Selected Foreground', ColorToString(clHighlightText)));
    Editor.SelectedColor.Background := StringToColor(iniFile.ReadString(strIniSection,
      'Selected Background', ColorToString(clHighlight)));
    Editor.TabWidth := iniFile.ReadInteger(strIniSection, 'Tab Width', 2);
    Editor.WantTabs := iniFile.ReadBool(strIniSection, 'WantTabs', true);
    Editor.MaxScrollWidth := iniFile.ReadInteger(strIniSection, 'MaxScrollWidth', 8192);
    Editor.FontSmoothing := fsmClearType;
    Editor.Gutter.Font.Assign(Editor.Font);
    LoadHighlighterFromINIFile(iniFile, Editor.Highlighter);
  Finally
    iniFile.Free;
  End;
End;

(**

  This method loads the given highlighter information from the given ini file.

  @precon  INIFile and Highlighter must be valid instances.
  @postcon Loads the given highlighter information from the given ini file.

  @param   INIFile     as a TCustomIniFile as a constant
  @param   Highlighter as a TSynCustomHighlighter as a constant

**)
procedure LoadHighlighterFromINIFile(Const INIFile : TCustomIniFile;
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
  
  With INIFile Do
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
              A.Background := StringToColor(ReadString(strKey, strName + '.Background',
                ColorToString(A.Background)));
              A.Foreground := StringToColor(ReadString(strKey, strName + '.Foreground',
                ColorToString(A.Foreground)));
              A.Style := TFontStyles(Byte(ReadInteger(strKey, strName + '.Style',
                Byte(A.Style))));
              If Highlighter.Tag < 0 Then
                LoadHighlighterFromINIFile(INIFile, S.Highlighter);
            End;
        End Else
          For iAttr := 0 To Highlighter.AttrCount - 1 Do
            Begin
              A := Highlighter.Attribute[iAttr];
              strKey := HighlighterName(Highlighter);
              A.Background := StringToColor(ReadString(strKey, A.Name + '.Background',
                ColorToString(A.Background)));
              A.Foreground := StringToColor(ReadString(strKey, A.Name + '.Foreground',
                ColorToString(A.Foreground)));
              A.Style := TFontStyles(Byte(ReadInteger(strKey, A.Name + '.Style',
                Byte(A.Style))));
            End;
      Highlighter.Tag := 0;
    End;
end;

(**

  This method saves the editor and highlighter settings to the INI file for the type of file being edited
  .

  @precon  None.
  @postcon The editor and the highlighter has its settings saved for the file type.

  @param   strIniFile as a String as a constant
  @param   Editor     as a TSynEdit as a constant

**)
Procedure SaveToIniFile(Const strIniFile : String; Const Editor : TSynEdit);

Var
  iniFile : TCustomIniFile;
  strIniSection : String;
  eStyle : TFontStyle;
  eOption : TSynEditorOption;
  
Begin
  iniFile := TMemIniFile.Create(strIniFile);
  Try
    strIniSection := IfThen(Assigned(Editor.Highlighter), HighlighterName(Editor.Highlighter), 
      'General');
    iniFile.WriteString(strIniSection, 'Colour', ColorToString(Editor.Color));
    iniFile.WriteString(strIniSection, 'Active Line Colour', ColorToString(Editor.ActiveLineColor));
    iniFile.WriteString(strIniSection, 'Font Name', Editor.Font.Name);
    iniFile.WriteInteger(strIniSection, 'Font Size', Editor.Font.Size);
    iniFile.WriteString(strIniSection, 'Font Colour', ColorToString(Editor.Font.Color));
    For eStyle := fsBold To fsStrikeOut Do
      iniFile.WriteBool(strIniSection, 'Font.' + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
        eStyle In Editor.Font.Style);
    iniFile.WriteBool(strIniSection, 'Wordwrap', Editor.WordWrap);
    iniFile.WriteBool(strIniSection, 'Show Line Numbers', Editor.Gutter.ShowLineNumbers);
    iniFile.WriteBool(strIniSection, 'ShowModification', Editor.Gutter.ShowModification);
    iniFile.WriteBool(strIniSection, 'AutoSize', Editor.Gutter.AutoSize);
    iniFile.WriteString(strIniSection, 'ModificationColourModified',
      ColorToString(Editor.Gutter.ModificationColorModified));
    iniFile.WriteString(strIniSection, 'ModificationColourSaved',
      ColorToString(Editor.Gutter.ModificationColorSaved));
    iniFile.WriteInteger(strIniSection, 'ModificationBarWidth', Editor.Gutter.ModificationBarWidth);
    For eOption := Low(TSynEditorOption) To High(TSynEditorOption) Do 
      iniFile.WriteBool(strIniSection, 'Options.' + GetEnumName(TypeInfo(TSynEditorOption),
        Ord(eOption)), eOption In Editor.Options);
    iniFile.WriteInteger(strIniSection, 'Right Edge', Editor.RightEdge);
    iniFile.WriteString(strIniSection, 'Right Edge Colour', ColorToString(Editor.RightEdgeColor));
    iniFile.WriteString(strIniSection, 'Selected Foreground',
      ColorToString(Editor.SelectedColor.Foreground));
    iniFile.WriteString(strIniSection, 'Selected Background',
      ColorToString(Editor.SelectedColor.Background));
    iniFile.WriteInteger(strIniSection, 'Tab Width', Editor.TabWidth);
    iniFile.WriteBool(strIniSection, 'WantTabs', Editor.WantTabs);
    iniFile.WriteInteger(strIniSection, 'MaxScrollWidth', Editor.MaxScrollWidth);
    SaveHighlighterToINIFile(iniFile, Editor.Highlighter);
    iniFile.UpdateFile();
  Finally
    iniFile.Free;
  End;
End;

(**

  This method saves the given highlighter to the given ini file.

  @precon  INIFile and Highlighter must be valid instances.
  @postcon Saves the given highlighter to the given ini file.

  @param   INIFile     as a TCustomIniFile as a constant
  @param   Highlighter as a TSynCustomHighlighter as a constant

**)
Procedure SaveHighlighterToINIFile(Const INIFile : TCustomIniFile;
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
  With INIFile Do
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
              WriteString(strKey, strName + '.Background', ColorToString(A.Background));
              WriteString(strKey, strName + '.Foreground', ColorToString(A.Foreground));
              WriteInteger(strKey, strName + '.Style', Byte(A.Style));
            End;
        End Else
        For iAttr := 0 To Highlighter.AttrCount - 1 Do
          Begin
            A := Highlighter.Attribute[iAttr];
            strKey := HighlighterName(Highlighter);
            WriteString(strKey, A.Name + '.Background', ColorToString(A.Background));
            WriteString(strKey, A.Name + '.Foreground', ColorToString(A.Foreground));
            WriteInteger(strKey, A.Name + '.Style', Byte(A.Style));
          End;
      UpdateFile;
    End;
end;

End.
