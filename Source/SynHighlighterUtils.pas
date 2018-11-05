Unit SynHighlighterUtils;

Interface

Uses
  SynEdit,
  SynEditHighlighter,
  MyEditor.Interfaces;

  Function  HighlighterName(Const Highlighter : TSynCustomHighlighter) : String;
  Procedure LoadFromIniFile(Const INIFileReadWriter : IMEINIFileReadWriter; Const Editor : TSynEdit);
  procedure LoadHighlighterFromINIFile(Const INIFileReadWriter : IMEINIFileReadWriter;
    Const Highlighter: TSynCustomHighlighter);
  Procedure SaveToIniFile(Const INIFileReadWriter : IMEINIFileReadWriter; Const Editor : TSynEdit);
  Procedure SaveHighlighterToINIFile(Const INIFileReadWriter : IMEINIFileReadWriter;
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

  @param   INIFileReadWriter as an IMEINIFileReadWriter as a constant
  @param   Editor            as a TSynEdit as a constant

**)
Procedure LoadFromIniFile(Const INIFileReadWriter : IMEINIFileReadWriter; Const Editor : TSynEdit);

Var
  strIniSection : String;
  eStyle : TFontStyle;
  DefaultOptions : TSynEditorOptions;
  eoption : TSynEditorOption;
  
Begin
  strIniSection := IfThen(Assigned(Editor.Highlighter), HighlighterName(Editor.Highlighter),
    'General');
  Editor.Color := StringToColor(INIFileReadWriter.ReadString(strIniSection, 'Colour', ColorToString(clWindow)));
  Editor.ActiveLineColor := StringToColor(INIFileReadWriter.ReadString(strIniSection, 'Active Line Colour',
    ColorToString(clSkyBlue)));
  Editor.Font.Name := INIFileReadWriter.ReadString(strIniSection, 'Font Name', 'Consolas');
  Editor.Font.Size := INIFileReadWriter.ReadInteger(strIniSection, 'Font Size', 11);
  Editor.Font.Color := StringToColor(INIFileReadWriter.ReadString(strIniSection, 'Font Colour',
    ColorToString(clWindowText)));
  For eStyle := fsBold To fsStrikeOut Do
    If INIFileReadWriter.ReadBool(strIniSection, 'Font.' + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
      False) Then
      Editor.Font.Style := Editor.Font.Style +  [eStyle];
  Editor.WordWrap := INIFileReadWriter.ReadBool(strIniSection, 'Wordwrap', False);
  Editor.Gutter.ShowLineNumbers := INIFileReadWriter.ReadBool(strIniSection, 'Show Line Numbers', True);
  Editor.Gutter.ShowModification := INIFileReadWriter.ReadBool(strIniSection, 'ShowModification', True);
  Editor.Gutter.AutoSize := INIFileReadWriter.ReadBool(strIniSection, 'AutoSize', True);
  Editor.Gutter.ModificationColorModified := StringToColor(INIFileReadWriter.ReadString(strIniSection,
    'ModificationColourModified', ColorToString(clRed)));
  Editor.Gutter.ModificationColorSaved := StringToColor(INIFileReadWriter.ReadString(strIniSection,
    'ModificationColourSaved', ColorToString(clGreen)));
  Editor.Gutter.ModificationBarWidth := INIFileReadWriter.ReadInteger(strIniSection, 'ModificationBarWidth', 4);
  DefaultOptions := [eoAltSetsColumnMode, eoAutoIndent, eoAutoSizeMaxScrollWidth, eoDragDropEditing,
    eoEnhanceHomeKey, eoEnhanceEndKey, eoGroupUndo, eoScrollHintFollows, eoScrollPastEof,
    eoScrollPastEol, eoShowScrollHint, eoSmartTabs, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces];
  For eOption := Low(TSynEditorOption) To High(TSynEditorOption) Do
    If INIFileReadWriter.ReadBool(strIniSection, 'Options.' + GetEnumName(TypeInfo(TSynEditorOption),
      Ord(eOption)), eOption In DefaultOptions) Then
      Editor.Options := Editor.Options + [eOption];
  Editor.RightEdge := INIFileReadWriter.ReadInteger(strIniSection, 'Right Edge', 80);
  Editor.RightEdgeColor := StringToColor(INIFileReadWriter.ReadString(strIniSection, 'Right Edge Colour',
    ColorToString(clMaroon)));
  Editor.SelectedColor.Foreground := StringToColor(INIFileReadWriter.ReadString(strIniSection,
    'Selected Foreground', ColorToString(clHighlightText)));
  Editor.SelectedColor.Background := StringToColor(INIFileReadWriter.ReadString(strIniSection,
    'Selected Background', ColorToString(clHighlight)));
  Editor.TabWidth := INIFileReadWriter.ReadInteger(strIniSection, 'Tab Width', 2);
  Editor.WantTabs := INIFileReadWriter.ReadBool(strIniSection, 'WantTabs', true);
  Editor.MaxScrollWidth := INIFileReadWriter.ReadInteger(strIniSection, 'MaxScrollWidth', 8192);
  Editor.FontSmoothing := fsmClearType;
  Editor.Gutter.Font.Assign(Editor.Font);
  LoadHighlighterFromINIFile(INIFileReadWriter, Editor.Highlighter);
End;

(**

  This method loads the given highlighter information from the given ini file.

  @precon  INIFile and Highlighter must be valid instances.
  @postcon Loads the given highlighter information from the given ini file.

  @param   INIFileReadWriter as an IMEINIFileReadWriter as a constant
  @param   Highlighter       as a TSynCustomHighlighter as a constant

**)
procedure LoadHighlighterFromINIFile(Const INIFileReadWriter : IMEINIFileReadWriter;
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
    If Highlighter Is TSynMultiSyn Then
      Begin
        M := Highlighter As TSynMultiSyn;
        If M.DefaultHighlighter.Tag < 0 Then
          LoadHighlighterFromINIFile(INIFileReadWriter, M.DefaultHighlighter);
        For iScheme := 0 To M.Schemes.Count - 1 Do
          Begin
            S := M.Schemes[iScheme] As TScheme;
            A := S.MarkerAttri;
            strKey := HighlighterName(M);
            strName := Format('%s:%s', [S.SchemeName, A.Name]);
            A.Background := StringToColor(INIFileReadWriter.ReadString(strKey, strName + '.Background',
              ColorToString(A.Background)));
            A.Foreground := StringToColor(INIFileReadWriter.ReadString(strKey, strName + '.Foreground',
              ColorToString(A.Foreground)));
            A.Style := TFontStyles(Byte(INIFileReadWriter.ReadInteger(strKey, strName + '.Style',
              Byte(A.Style))));
            If Highlighter.Tag < 0 Then
              LoadHighlighterFromINIFile(INIFileReadWriter, S.Highlighter);
          End;
      End Else
        For iAttr := 0 To Highlighter.AttrCount - 1 Do
          Begin
            A := Highlighter.Attribute[iAttr];
            strKey := HighlighterName(Highlighter);
            A.Background := StringToColor(INIFileReadWriter.ReadString(strKey, A.Name + '.Background',
              ColorToString(A.Background)));
            A.Foreground := StringToColor(INIFileReadWriter.ReadString(strKey, A.Name + '.Foreground',
              ColorToString(A.Foreground)));
            A.Style := TFontStyles(Byte(INIFileReadWriter.ReadInteger(strKey, A.Name + '.Style',
              Byte(A.Style))));
          End;
    Highlighter.Tag := 0;
end;

(**

  This method saves the editor and highlighter settings to the INI file for the type of file being edited
  .

  @precon  None.
  @postcon The editor and the highlighter has its settings saved for the file type.

  @param   INIFileReadWriter as an IMEINIFileReadWriter as a constant
  @param   Editor            as a TSynEdit as a constant

**)
Procedure SaveToIniFile(Const INIFileReadWriter : IMEINIFileReadWriter; Const Editor : TSynEdit);

Var
  strIniSection : String;
  eStyle : TFontStyle;
  eOption : TSynEditorOption;
  
Begin
  strIniSection := IfThen(Assigned(Editor.Highlighter), HighlighterName(Editor.Highlighter), 
    'General');
  INIFileReadWriter.WriteString(strIniSection, 'Colour', ColorToString(Editor.Color));
  INIFileReadWriter.WriteString(strIniSection, 'Active Line Colour', ColorToString(Editor.ActiveLineColor));
  INIFileReadWriter.WriteString(strIniSection, 'Font Name', Editor.Font.Name);
  INIFileReadWriter.WriteInteger(strIniSection, 'Font Size', Editor.Font.Size);
  INIFileReadWriter.WriteString(strIniSection, 'Font Colour', ColorToString(Editor.Font.Color));
  For eStyle := fsBold To fsStrikeOut Do
    INIFileReadWriter.WriteBool(strIniSection, 'Font.' + GetEnumName(TypeInfo(TFontStyle), Ord(eStyle)),
      eStyle In Editor.Font.Style);
  INIFileReadWriter.WriteBool(strIniSection, 'Wordwrap', Editor.WordWrap);
  INIFileReadWriter.WriteBool(strIniSection, 'Show Line Numbers', Editor.Gutter.ShowLineNumbers);
  INIFileReadWriter.WriteBool(strIniSection, 'ShowModification', Editor.Gutter.ShowModification);
  INIFileReadWriter.WriteBool(strIniSection, 'AutoSize', Editor.Gutter.AutoSize);
  INIFileReadWriter.WriteString(strIniSection, 'ModificationColourModified',
    ColorToString(Editor.Gutter.ModificationColorModified));
  INIFileReadWriter.WriteString(strIniSection, 'ModificationColourSaved',
    ColorToString(Editor.Gutter.ModificationColorSaved));
  INIFileReadWriter.WriteInteger(strIniSection, 'ModificationBarWidth', Editor.Gutter.ModificationBarWidth);
  For eOption := Low(TSynEditorOption) To High(TSynEditorOption) Do 
    INIFileReadWriter.WriteBool(strIniSection, 'Options.' + GetEnumName(TypeInfo(TSynEditorOption),
      Ord(eOption)), eOption In Editor.Options);
  INIFileReadWriter.WriteInteger(strIniSection, 'Right Edge', Editor.RightEdge);
  INIFileReadWriter.WriteString(strIniSection, 'Right Edge Colour', ColorToString(Editor.RightEdgeColor));
  INIFileReadWriter.WriteString(strIniSection, 'Selected Foreground',
    ColorToString(Editor.SelectedColor.Foreground));
  INIFileReadWriter.WriteString(strIniSection, 'Selected Background',
    ColorToString(Editor.SelectedColor.Background));
  INIFileReadWriter.WriteInteger(strIniSection, 'Tab Width', Editor.TabWidth);
  INIFileReadWriter.WriteBool(strIniSection, 'WantTabs', Editor.WantTabs);
  INIFileReadWriter.WriteInteger(strIniSection, 'MaxScrollWidth', Editor.MaxScrollWidth);
  SaveHighlighterToINIFile(INIFileReadWriter, Editor.Highlighter);
  INIFileReadWriter.Save();
End;

(**

  This method saves the given highlighter to the given ini file.

  @precon  INIFile and Highlighter must be valid instances.
  @postcon Saves the given highlighter to the given ini file.

  @param   INIFileReadWriter as an IMEINIFileReadWriter as a constant
  @param   Highlighter       as a TSynCustomHighlighter as a constant

**)
Procedure SaveHighlighterToINIFile(Const INIFileReadWriter : IMEINIFileReadWriter;
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
              INIFileReadWriter.WriteString(strKey, strName + '.Background', ColorToString(A.Background));
              INIFileReadWriter.WriteString(strKey, strName + '.Foreground', ColorToString(A.Foreground));
              INIFileReadWriter.WriteInteger(strKey, strName + '.Style', Byte(A.Style));
            End;
        End Else
        For iAttr := 0 To Highlighter.AttrCount - 1 Do
          Begin
            A := Highlighter.Attribute[iAttr];
            strKey := HighlighterName(Highlighter);
            INIFileReadWriter.WriteString(strKey, A.Name + '.Background', ColorToString(A.Background));
            INIFileReadWriter.WriteString(strKey, A.Name + '.Foreground', ColorToString(A.Foreground));
            INIFileReadWriter.WriteInteger(strKey, A.Name + '.Style', Byte(A.Style));
          End;
      INIFileReadWriter.Save;
    End;
end;

End.
