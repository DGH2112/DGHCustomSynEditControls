(**

  

**)

{$IFNDEF QREGEXSYNHIGHLIGHTERGRAMMAR}
Unit SynHighlighterRegEx;
{$ENDIF}

{$I SynEdit.inc}

Interface

Uses
  {$IFDEF SYN_CLX}
  QGraphics,
  QSynEditTypes,
  QSynEditHighlighter,
  QSynUnicode,
  {$ELSE}
  Graphics,
  SynEditTypes,
  SynEditHighlighter,
  SynUnicode,
  {$ENDIF}
  SysUtils,
  Classes;

Type
  TtkTokenKind = (
    tkCharacter,
    tkRegExComment,
    tkCPPLineComment,
    tkCPPBlockComment,
    tkIdentifier,
    tkKey,
    tkGrouping,
    tkCharClass,
    tkMacro,
    tkNull,
    tkOptional,
    tkRepeat,
    tkEscape,
    tkGroupName,
    tkSpace,
    tkSymbol,
    tkUnknown
  );

  TRangeState = (
    rsUnKnown,
    rsRegExComment,
    rsCPPLineComment,
    rsCPPBlockComment,
    rsMacro,
    rsGroupName,
    rsEscape
  );

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = Function(Index: Integer): TtkTokenKind Of Object;

Type
  TSynRegExSyn = Class(TSynCustomHighlighter)
  Private
    fRange:                 TRangeState;
    fTokenID:               TtkTokenKind;
    fIdentFuncTable:        Array [0 .. 1] Of TIdentFuncTableFunc;
    fCharacterAttri:        TSynHighlighterAttributes;
    fRegExCommentAttri:     TSynHighlighterAttributes;
    fCPPLineCommentAttri:   TSynHighlighterAttributes;
    fCPPBlockCommentAttri:  TSynHighlighterAttributes;
    fIdentifierAttri:       TSynHighlighterAttributes;
    fKeyAttri:              TSynHighlighterAttributes;
    fCharClassAttri:        TSynHighlighterAttributes;
    fGroupingAttri:         TSynHighlighterAttributes;
    fMacroAttri:            TSynHighlighterAttributes;
    fOptionalAttri:         TSynHighlighterAttributes;
    fRepeatAttri:           TSynHighlighterAttributes;
    fGroupNameAttri:        TSynHighlighterAttributes;
    fSymbolAttri:           TSynHighlighterAttributes;
    fEscapeAttri:           TSynHighlighterAttributes;
    fSpaceAttri:            TSynHighlighterAttributes;
    fKeyWords:              TUnicodeStrings;
    procedure SetKeyWords(const Value: TUnicodeStrings);
    Function  FuncKeyword(Index: Integer): TtkTokenKind;
    Procedure IdentProc;
    Procedure UnknownProc;
    Function  AltFunc(Index: Integer): TtkTokenKind;
    Procedure InitIdent;
    Procedure NullProc;
    Procedure SpaceProc;
    Procedure CRProc;
    Procedure LFProc;
    Procedure RegExCommentOpenProc;
    Procedure RegExCommentProc;
    Procedure CPPCommentOpenProc;
    Procedure CPPBlockCommentProc;
    Procedure CPPLineCommentProc;
    Procedure MacroOpenProc;
    Procedure MacroProc;
    Procedure RepeatOperatorProc;
    Procedure OptionalOperatorProc;
    Procedure EscapeProc;
    Procedure GroupNameOpenProc;
    Procedure GroupNameProc;
    Procedure CharClassProc;
    Procedure SymbolProc;
    Procedure GroupingProc;
  Protected
    Function  GetSampleSource: UnicodeString; Override;
    Function  IsFilterStored: Boolean; Override;
    Procedure AddAndUpdateAttributes(Attribute : TSynHighlighterAttributes; ForeColour,
      BackColour : TColor; FontStyle : TFontStyles);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Class Function GetFriendlyLanguageName: UnicodeString; Override;
    Class Function GetLanguageName: String; Override;
    Function  GetRange: Pointer; Override;
    Procedure ResetRange; Override;
    Procedure SetRange(Value: Pointer); Override;
    Function  GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes; Override;
    Function  GetEol: Boolean; Override;
    Function  GetTokenID: TtkTokenKind;
    Function  GetTokenAttribute: TSynHighlighterAttributes; Override;
    Function  GetTokenKind: Integer; Override;
    Function  IsIdentChar(AChar: WideChar): Boolean; Override;
    Procedure Next; Override;
    Function  IsKeyword(const AKeyword: UnicodeString): Boolean; Override;
  Published
    Property CharacterAttri: TSynHighlighterAttributes Read fCharacterAttri Write fCharacterAttri;
    Property RegExCommentAttri: TSynHighlighterAttributes Read fRegExCommentAttri
      Write fRegExCommentAttri;
    Property CPPLineCommentAttri: TSynHighlighterAttributes Read fCPPLineCommentAttri
      Write fCPPLineCommentAttri;
    Property CPPBlockCommentAttri: TSynHighlighterAttributes Read fCPPBlockCommentAttri
      Write fCPPBlockCommentAttri;
    Property IdentifierAttri: TSynHighlighterAttributes Read fIdentifierAttri
      Write fIdentifierAttri;
    Property MacroAttri: TSynHighlighterAttributes Read fMacroAttri Write fMacroAttri;
    Property OptionalAttri: TSynHighlighterAttributes Read fOptionalAttri Write fOptionalAttri;
    Property RepeatAttri: TSynHighlighterAttributes Read fRepeatAttri Write fRepeatAttri;
    Property SpaceAttri: TSynHighlighterAttributes Read fSpaceAttri Write fSpaceAttri;
    Property ReservedWords : TSynHighlighterAttributes Read fKeyAttri Write fKeyAttri;
    Property CharacterClass : TSynHighlighterAttributes Read fCharClassAttri Write fCharClassAttri;
    Property GroupNames : TSynHighlighterAttributes Read fGroupNameAttri Write fGroupNameAttri;
    Property RegExSymbols : TSynHighlighterAttributes Read fSymbolAttri Write fSymbolAttri;
    Property EscapeCharacters : TSynHighlighterAttributes Read fEscapeAttri Write fEscapeAttri;
    Property KeyWords: TUnicodeStrings read fKeyWords write SetKeyWords;
  End;

Implementation

Uses
  {$IFDEF SYN_CLX}
  QSynEditStrConst;
  {$ELSE}
  SynEditStrConst;
  {$ENDIF}

Resourcestring
  SYNS_FilterRegularExpressions = 'Regular Expression Files (*.regex)|*.regex';
  SYNS_LangRegularExpressions = 'Regular Expressions';
  SYNS_AttrFullRegExComment = 'RegEx Comment';
  SYNS_AttrCPPLineComment = 'C++ Line Comment';
  SYNS_AttrCPPBlockComment = 'C++ Block Comment';
  SYNS_AttrOptional = 'Optional Operator';
  SYNS_AttrRepeat = 'Repeat Operator';
  SYNS_AttrCharClass = 'Character Class Brace';
  SYNS_AttrGrouping = 'Grouping Parenthesis';
  SYNS_AttrGroupName = 'Capture Group Name';
  SYNS_AttrEscapeSeq = 'Escaped Character';

Const
  KeyIndices: Array [0..1] Of Integer = (0, -1);
  RepeatOperatorsChars = ['?', '+', '*'];
  OptionalOperatorsChars = ['|'];
  EscapedCharactersChars = ['\'];
  CharacterClassChars = ['[', ']'];
  GroupingChars = ['(', ')'];
  MacroChars = ['$'];
  GroupNamesChars = ['<', '>'];
  CPPCommentChars = ['/'];
  Symbols =
    [#32..#128] - [#32] - ['a'..'z', 'A'..'Z', '0'..'9', '_'] -
      RepeatOperatorsChars -
      OptionalOperatorsChars -
      EscapedCharactersChars -
      CharacterClassChars -
      MacroChars -
      GroupNamesChars -
      GroupingChars -
      CPPCommentChars;

Procedure TSynRegExSyn.InitIdent;

Var
  i: Integer;

Begin
  For i := Low(fIdentFuncTable) To High(fIdentFuncTable) Do
    If KeyIndices[i] = - 1 Then
      fIdentFuncTable[i] := AltFunc;
  fIdentFuncTable[0] := FuncKeyword;
End;

{$Q-}


Function TSynRegExSyn.FuncKeyword(Index: Integer): TtkTokenKind;

Begin
  If (KeyWords.Count > 0) And IsCurrentToken(KeyWords[Index]) Then
    Result := tkKey
  Else
    Result := tkIdentifier;
End;

Procedure TSynRegExSyn.AddAndUpdateAttributes(Attribute: TSynHighlighterAttributes; ForeColour,
  BackColour: TColor; FontStyle: TFontStyles);

Begin
  AddAttribute(Attribute);
  Attribute.Foreground := ForeColour;
  Attribute.Background := BackColour;
  Attribute.Style := FontStyle;
End;

Function TSynRegExSyn.AltFunc(Index: Integer): TtkTokenKind;

Begin
  Result := tkIdentifier;
End;

Procedure TSynRegExSyn.SpaceProc;

Begin
  inc(Run);
  If Not (fTokenID In [tkCPPBlockComment]) Then
    fTokenID := tkSpace;
  While (FLine[Run] <= #32) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynRegExSyn.SymbolProc;

Begin
  inc(Run);
  fTokenID := tkSymbol;
  While CharInSet(FLine[Run], Symbols) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynRegExSyn.NullProc;

Begin
  If Not (fTokenID In [tkCPPBlockComment]) Then
    Begin
      fTokenID := tkNull;
      fRange := rsUnKnown;
    End;
  inc(Run);
End;

Procedure TSynRegExSyn.OptionalOperatorProc;

Begin
  inc(Run);
  fTokenID := tkOptional;
  While CharInSet(FLine[Run], OptionalOperatorsChars) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynRegExSyn.CRProc;

Begin
  If Not (fTokenID In [tkCPPBlockComment]) Then
    Begin
      fTokenID := tkSpace;
      fRange := rsUnKnown;
    End;
  inc(Run);
  If FLine[Run] = #10 Then
    inc(Run);
End;

Destructor TSynRegExSyn.Destroy;

Begin
  fKeyWords.Free;
  Inherited Destroy;
End;

Procedure TSynRegExSyn.EscapeProc;

Begin
  inc(Run);
  fRange := rsEscape;
  fTokenID := tkEscape;
  If Not IsLineEnd(Run) Then
    Inc(Run);
End;

Procedure TSynRegExSyn.LFProc;

Begin
  If Not (fTokenID In [tkCPPBlockComment]) Then
    Begin
      fTokenID := tkSpace;
      fRange := rsUnKnown;
    End;
  inc(Run);
End;

Procedure TSynRegExSyn.MacroOpenProc;

Begin
  inc(Run);
  If (FLine[Run] = '(') Then
    Begin
      inc(Run);
      fRange := rsMacro;
      fTokenID := tkMacro;
    End Else
      fTokenID := tkSymbol;
End;

Procedure TSynRegExSyn.MacroProc;

Begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkMacro;
      Repeat
        If IsIdentChar(FLine[Run]) Then
          inc(Run)
        Else
          Break;
      Until IsLineEnd(Run);
      If Not IsLineEnd(Run) Then
        If FLine[Run] = ')' Then
          Begin
            inc(Run);
            fRange := rsUnKnown;
          End Else
          Begin
            fRange := rsUnknown;
            fTokenID := tkUnknown;
          End;
    End;
  End;
End;

Procedure TSynRegExSyn.RegExCommentOpenProc;

Begin
  Inc(Run);
  If (FLine[Run] = '?') And (FLine[Run + 1] = '#') Then
    Begin
      inc(Run, 2);
      fRange := rsRegExComment;
      fTokenID := tkRegExComment;
    End
  Else
    fTokenID := tkGrouping;
End;

Procedure TSynRegExSyn.RegExCommentProc;

Begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkRegExComment;
      Repeat
        If (FLine[Run] = ')') Then
          Begin
            inc(Run);
            fRange := rsUnKnown;
            Break;
          End;
        If Not IsLineEnd(Run) Then
          inc(Run);
      Until IsLineEnd(Run);
    End;
  End;
End;

Procedure TSynRegExSyn.CharClassProc;

Begin
  inc(Run);
  fTokenID := tkcharclass;
  While CharInSet(FLine[Run], CharacterClassChars) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynRegExSyn.CPPCommentOpenProc;

Begin
  Inc(Run);
  If FLine[Run] = '*' Then
    Begin
      Inc(Run);
      fRange := rsCPPBlockComment;
      fTokenID := tkCPPBlockComment;
    End Else
  If FLine[Run] = '/' Then
    Begin
      Inc(Run);
      fRange := rsCPPLineComment;
      fTokenID := tkCPPLineComment;
    End
  Else
    fTokenID := tkSymbol;
End;

Procedure TSynRegExSyn.CPPLineCommentProc;

Begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkCPPLineComment;
      Repeat
        If Not IsLineEnd(Run) Then
          inc(Run);
      Until IsLineEnd(Run);
    End;
  End;
End;

Procedure TSynRegExSyn.CPPBlockCommentProc;

Begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkCPPBlockComment;
      Repeat
        If (FLine[Run] = '/') And (FLine[Run - 1] = '*') Then
          Begin
            inc(Run);
            fRange := rsUnKnown;
            Break;
          End;
        If Not IsLineEnd(Run) Then
          inc(Run);
      Until IsLineEnd(Run);
    End;
  End;
End;

Constructor TSynRegExSyn.Create(AOwner: TComponent);

Begin
  Inherited Create(AOwner);
  fKeyWords := TUnicodeStringList.Create;
  fCaseSensitive := False;
  fCharacterAttri := TSynHighlighterAttributes.Create(SYNS_AttrCharacter, SYNS_FriendlyAttrCharacter);
  AddAndUpdateAttributes(fCharacterAttri, clNone, clNone, []);
  fRegExCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrFullRegExComment, SYNS_AttrFullRegExComment);
  AddAndUpdateAttributes(fRegExCommentAttri, clNone, clNone, [fsItalic]);
  fCPPLineCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrCPPLineComment, SYNS_AttrCPPLineComment);
  AddAndUpdateAttributes(fCPPLineCommentAttri, clNone, clNone, [fsItalic]);
  fCPPBlockCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrCPPBlockComment, SYNS_AttrCPPBlockComment);
  AddAndUpdateAttributes(fCPPBlockCommentAttri, clNone, clNone, [fsItalic]);
  fIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier, SYNS_AttrIdentifier);
  AddAndUpdateAttributes(fIdentifierAttri, clNone, clNone, []);
  fKeyAttri := TSynHighlighterAttributes.Create(SYNS_AttrKey, SYNS_FriendlyAttrKey);
  AddAndUpdateAttributes(fKeyAttri, clNone, clNone, [fsBold]);
  fCharClassAttri := TSynHighlighterAttributes.Create(SYNS_AttrCharClass, SYNS_AttrCharClass);
  AddAndUpdateAttributes(fCharClassAttri, clNone, clNone, [fsBold]);
  fGroupingAttri := TSynHighlighterAttributes.Create(SYNS_AttrGrouping, SYNS_AttrGrouping);
  AddAndUpdateAttributes(fGroupingAttri, clNone, clNone, [fsBold]);
  fMacroAttri := TSynHighlighterAttributes.Create(SYNS_AttrMacro, SYNS_FriendlyAttrMacro);
  AddAndUpdateAttributes(fMacroAttri, clNone, clNone, [fsItalic]);
  fGroupNameAttri := TSynHighlighterAttributes.Create(SYNS_AttrGroupName, SYNS_AttrGroupName);
  AddAndUpdateAttributes(fGroupNameAttri, clNone, clNone, []);
  fOptionalAttri := TSynHighlighterAttributes.Create(SYNS_AttrOptional, SYNS_AttrOptional);
  AddAndUpdateAttributes(fOptionalAttri, clNone, clNone, [fsBold]);
  fRepeatAttri := TSynHighlighterAttributes.Create(SYNS_AttrRepeat, SYNS_AttrRepeat);
  AddAndUpdateAttributes(fRepeatAttri, clNone, clNone, [fsBold]);
  fEscapeAttri := TSynHighlighterAttributes.Create(SYNS_AttrEscapeSeq, SYNS_AttrEscapeSeq);
  AddAndUpdateAttributes(fEscapeAttri, clNone, clNone, []);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol, SYNS_AttrSymbol);
  AddAndUpdateAttributes(fSymbolAttri, clNone, clNone, []);
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace, SYNS_AttrSpace);
  AddAndUpdateAttributes(fSpaceAttri, clNone, clNone, []);
  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  fDefaultFilter := SYNS_FilterRegularExpressions;
  fRange := rsUnKnown;
End;

Procedure TSynRegExSyn.IdentProc;

Begin
  While IsIdentChar(FLine[Run]) Do
    inc(Run);
  If IsKeyWord(GetToken) Then
    fTokenID := tkKey
  Else
    fTokenID := tkIdentifier;
End;

Procedure TSynRegExSyn.UnknownProc;

Begin
  inc(Run);
  fTokenID := tkUnknown;
End;

Procedure TSynRegExSyn.Next;

Begin
  fTokenPos := Run;
  Case fRange Of
    rsRegExComment: RegExCommentProc;
    rsCPPLineComment: CPPLineCommentProc;
    rsCPPBlockComment: CPPBlockCommentProc;
    rsMacro: MacroProc;
    rsGroupName: GroupNameProc;
  Else
    Case FLine[Run] Of
      #00: NullProc;
      #10: LFProc;
      #13: CRProc;
      '(': RegExCommentOpenProc; //: @todo Breakout to allow for lookaheads
      '/': CPPCommentOpenProc;
      '$': MacroOpenProc;
      '?', '+', '*': RepeatOperatorProc;
      '|': OptionalOperatorProc;
      '\': EscapeProc;
      '[', ']': CharClassProc;
      ')': GroupingProc;
      '<': GroupNameOpenProc;
      #1 .. #9, #11, #12, #14 .. #32: SpaceProc;
      'A' .. 'Z', 'a' .. 'z', '_': IdentProc;
    Else
      If CharInSet(FLine[Run], Symbols) Then
        SymbolProc
      Else
        UnknownProc;
    End;
  End;
  Inherited;
End;

Function TSynRegExSyn.GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes;

Begin
  Case Index Of
    SYN_ATTR_COMMENT: Result := fRegExCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
  Else
    Result := Nil;
  End;
End;

Function TSynRegExSyn.GetEol: Boolean;

Begin
  Result := Run = fLineLen + 1;
End;

Function TSynRegExSyn.GetTokenID: TtkTokenKind;

Begin
  Result := fTokenID;
End;

Function TSynRegExSyn.GetTokenAttribute: TSynHighlighterAttributes;

Begin
  Case GetTokenID Of
    tkRegExComment: Result := fRegExCommentAttri;
    tkCPPLineComment: Result := fCPPLineCommentAttri;
    tkCPPBlockComment: Result := fCPPBlockCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkMacro: Result := fMacroAttri;
    tkOptional: Result := fOptionalAttri;
    tkRepeat: Result := fRepeatAttri;
    tkSymbol: Result := fSymbolAttri;
    tkEscape: Result := fEscapeAttri;
    tkGroupName: Result := fGroupNameAttri;
    tkCharClass: Result := fCharClassAttri;
    tkGrouping: Result := fGroupingAttri;
    tkSpace: Result := fSpaceAttri;
  Else
    Result := fCharacterAttri;
  End;
End;

Function TSynRegExSyn.GetTokenKind: Integer;

Begin
  Result := Ord(fTokenID);
End;

Procedure TSynRegExSyn.GroupingProc;

Begin
  inc(Run);
  fTokenID := tkGrouping;
  While CharInSet(FLine[Run], GroupingChars) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynRegExSyn.GroupNameOpenProc;

Begin
  inc(Run);
  fRange := rsGroupName;
  fTokenID := tkGroupName;
End;

Procedure TSynRegExSyn.GroupNameProc;

Begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkGroupName;
      Repeat
        If IsIdentChar(FLine[Run]) Then
          inc(Run)
        Else
          Break;
      Until IsLineEnd(Run);
      If Not IsLineEnd(Run) Then
        If FLine[Run] = '>' Then
          Begin
            inc(Run);
            fRange := rsUnKnown;
          End Else
          Begin
            fRange := rsUnknown;
            fTokenID := tkUnknown;
          End;
    End;
  End;
End;

Function TSynRegExSyn.IsIdentChar(AChar: WideChar): Boolean;

Begin
  Case AChar Of
    '!', '_', '0' .. '9', 'a' .. 'z', 'A' .. 'Z':
      Result := True;
  Else
    Result := False;
  End;
End;

Function TSynRegExSyn.IsKeyword(Const AKeyword: UnicodeString): Boolean;

Var
  iFirst, iMid, iLast : Integer;

Begin
  Result := Inherited IsKeyword(AKeyword);
  iFirst := 0;
  iLast := fKeyWords.Count - 1;
  While iFirst <= iLast Do
    Begin
      iMid := (iFirst + iLast) Div 2;
      If fKeyWords[iMid] = AKeyword Then
        Begin
          Result := True;
          Break;
        End Else
      If fKeyWords[iMid] < AKeyword Then
        iFirst := iMid + 1
      Else
        iLast := iMid - 1;
    End;
End;

Function TSynRegExSyn.GetSampleSource: UnicodeString;

Begin
  Result :=
    'Sample source for: '#13#10 +
    'RegEx Syntax Parser/Highlighter';
End;

Function TSynRegExSyn.IsFilterStored: Boolean;

Begin
  Result := fDefaultFilter <> SYNS_FilterRegularExpressions;
End;

Class Function TSynRegExSyn.GetFriendlyLanguageName: UnicodeString;

Begin
  Result := SYNS_LangRegularExpressions;
End;

Class Function TSynRegExSyn.GetLanguageName: String;

Begin
  Result := SYNS_LangRegularExpressions;
End;

Procedure TSynRegExSyn.RepeatOperatorProc;

Var
  boolEscape: Boolean;

Begin
  boolEscape := (Run > 0) And (CharInSet(FLine[Pred(Run)], [#32, '(']));
  inc(Run);
  If Not boolEscape Then
    Begin
      fTokenID := tkRepeat;
      While CharInSet(FLine[Run], RepeatOperatorsChars) And Not IsLineEnd(Run) Do
        inc(Run);
    End Else
      fTokenID := tkSymbol;
End;

Procedure TSynRegExSyn.ResetRange;

Begin
  fRange := rsUnKnown;
End;

Procedure TSynRegExSyn.SetKeyWords(Const Value: TUnicodeStrings);

Var
  i: Integer;

Begin
  If Value <> Nil Then
    Begin
      Value.BeginUpdate;
      For i := 0 To Value.Count - 1 Do
        Value[i] := SynWideUpperCase(Value[i]);
      Value.EndUpdate;
    End;
  TUnicodeStringList(fKeyWords).Sorted := False;
  fKeyWords.Assign(Value);
  TUnicodeStringList(fKeyWords).Sorted := True;
  DefHighlightChange(Nil);
End;

Procedure TSynRegExSyn.SetRange(Value: Pointer);

Begin
  fRange := TRangeState(Value);
End;

Function TSynRegExSyn.GetRange: Pointer;

Begin
  Result := Pointer(fRange);
End;

Initialization
  {$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynRegExSyn);
  {$ENDIF}
End.
