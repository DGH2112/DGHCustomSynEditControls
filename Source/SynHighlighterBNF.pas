(**

  

**)

{$IFNDEF QREGEXSYNHIGHLIGHTERGRAMMAR}
Unit SynHighlighterBNF;
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
    tkCPPLineComment,
    tkCPPBlockComment,
    tkIdentifier,
    tkRules,
    tkNull,
    tkOptionalPipe,
    tkRepeat,
    tkGrouping,
    tkOptionalBrace,
    tkSpace,
    tkSymbol,
    tkSingleLiteral,
    tkDoubleLiteral,
    tkFreeText,
    tkUnknown
  );

  TRangeState = (
    rsUnKnown,
    rsCPPLineComment,
    rsCPPBlockComment,
    rsSingleLiteral,
    rsDoubleLiteral,
    rsRule,
    rsFreeText
  );

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = Function(Index: Integer): TtkTokenKind Of Object;

Type
  TSynBNFSyn = Class(TSynCustomHighlighter)
  Private
    fRange:                 TRangeState;
    fTokenID:               TtkTokenKind;
    fIdentFuncTable:        Array [0 .. 1] Of TIdentFuncTableFunc;
    fCharacterAttri:        TSynHighlighterAttributes;
    fCPPCommentAttri:       TSynHighlighterAttributes;
    fRulesAttri:            TSynHighlighterAttributes;
    fOptionalPipeAttri:     TSynHighlighterAttributes;
    fRepeatAttri:           TSynHighlighterAttributes;
    fGroupingAttri:         TSynHighlighterAttributes;
    fOptionalBraceAttri:    TSynHighlighterAttributes;
    fSymbolAttri:           TSynHighlighterAttributes;
    fSpaceAttri:            TSynHighlighterAttributes;
    fSingleLiteralAttri:    TSynHighlighterAttributes;
    fDoubleLiteralAttri:    TSynHighlighterAttributes;
    fFreeTextAttri:         TSynHighlighterAttributes;
    Function  FuncKeyword(Index: Integer): TtkTokenKind;
    Procedure IdentProc;
    Procedure UnknownProc;
    Function  AltFunc(Index: Integer): TtkTokenKind;
    Procedure InitIdent;
    Procedure NullProc;
    Procedure SpaceProc;
    Procedure CRProc;
    Procedure LFProc;
    Procedure CPPCommentOpenProc;
    Procedure CPPBlockCommentProc;
    Procedure CPPLineCommentProc;
    Procedure RepeatOperatorProc;
    Procedure OptionalOperatorProc;
    Procedure RuleOpenProc;
    Procedure RuleNameProc;
    Procedure CharClassProc;
    Procedure SymbolProc;
    Procedure GroupingProc;
    Procedure SingleLiteralOpenProc;
    Procedure SingleLiteralProc;
    Procedure DoubleLiteralOpenProc;
    Procedure DoubleLiteralProc;
    Procedure FreeTextOpenProc;
    Procedure FreeTextProc;
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
  Published
    Property CharacterAttri: TSynHighlighterAttributes Read fCharacterAttri Write fCharacterAttri;
    Property CPPCommentAttri: TSynHighlighterAttributes Read fCPPCommentAttri
      Write fCPPCommentAttri;
    Property RulesAttri: TSynHighlighterAttributes Read fRulesAttri Write fRulesAttri;
    Property OptionalPipeAttri: TSynHighlighterAttributes Read fOptionalPipeAttri
      Write fOptionalPipeAttri;
    Property RepeatAttri: TSynHighlighterAttributes Read fRepeatAttri Write fRepeatAttri;
    Property GroupingAttri: TSynHighlighterAttributes Read fGroupingAttri Write fGroupingAttri;
    Property OptionalBraceAttri: TSynHighlighterAttributes Read fOptionalBraceAttri
      Write fOptionalBraceAttri;
    Property SpaceAttri: TSynHighlighterAttributes Read fSpaceAttri Write fSpaceAttri;
    Property RegExSymbols : TSynHighlighterAttributes Read fSymbolAttri Write fSymbolAttri;
    Property SingleLiteral : TSynHighlighterAttributes Read fSingleLiteralAttri
      Write fSingleLiteralAttri;
    Property DoubleLiteral : TSynHighlighterAttributes Read fDoubleLiteralAttri
      Write fDoubleLiteralAttri;
    Property FreeText : TSynHighlighterAttributes Read fFreeTextAttri Write fFreeTextAttri;
  End;

Procedure Register;

Implementation

Uses
  {$IFDEF SYN_CLX}
  QSynEditStrConst;
  {$ELSE}
  SynEditStrConst;
  {$ENDIF}

Procedure Register;

Begin
  RegisterComponents('DGH Custom SynEdit Controls', [TSynBNFSyn]);
End;

Resourcestring
  SYNS_FilterRegularExpressions = 'Backus-Naur Grammar Files (*.bnf)|*.bnf';
  SYNS_LangRegularExpressions = 'Backus-Naur';
  SYNS_FriendlyLangRegularExpressions = 'Backus-Naur';
  SYNS_AttrCPPComment = 'C++ Comment';
  SYNS_FriendlyAttrCPPComment = 'C++ Comment';
  SYNS_AttrRules = 'BNF Rule';
  SYNS_FriendlyAttrRules = 'BNF Rule';
  SYNS_AttrOptionalPipe = 'Optional Pipe Operator';
  SYNS_FriendlyAttrOptionalPipe = 'Optional Pipe Operator';
  SYNS_AttrOptionalBrace = 'Optional Brace';
  SYNS_FriendlyAttrOptionalBrace = 'Optional Brace';
  SYNS_AttrRepeat = 'Repeat Operator';
  SYNS_FriendlyAttrRepeat = 'Repeat Operator';
  SYNS_AttrGrouping = 'Grouping Parenthesis';
  SYNS_FriendlyAttrGroupingClass = 'Grouping Parenthesis';
  SYNS_AttrSingleLiteral = 'Single Quoted String Literal';
  SYNS_FriendlyAttrSingleLiteral = 'Single Quoted String Literal';
  SYNS_AttrDoubleLiteral = 'Double Quoted String Literal';
  SYNS_FriendlyAttrDoubleLiteral = 'Double Quoted String Literal';
  SYNS_AttrFreeText = 'Free Text';
  SYNS_FriendlyAttrFreeText = 'Free Text';

Const
  KeyIndices: Array [0..1] Of Integer = (0, -1);
  RepeatOperatorsChars = ['+', '*'];
  OptionalOperatorsChars = ['|'];
  CharacterClassChars = ['[', ']'];
  GroupingChars = ['(', ')'];
  CPPCommentChars = ['/'];
  SingleLiteralChars = [''''];
  DoubleLiteralChars = ['"'];
  FreeTextChar = ['?'];
  Symbols =
    [#32..#128] - [#32] - ['a'..'z', 'A'..'Z', '0'..'9', '_'] -
      RepeatOperatorsChars -
      OptionalOperatorsChars -
      CharacterClassChars -
      GroupingChars -
      CPPCommentChars -
      SingleLiteralChars -
      DoubleLiteralChars -
      FreeTextChar;

Procedure TSynBNFSyn.InitIdent;

Var
  i: Integer;

Begin
  For i := Low(fIdentFuncTable) To High(fIdentFuncTable) Do
    If KeyIndices[i] = - 1 Then
      fIdentFuncTable[i] := AltFunc;
  fIdentFuncTable[0] := FuncKeyword;
End;

{$Q-}


procedure TSynBNFSyn.FreeTextOpenProc;
begin
  inc(Run);
  fRange := rsFreeText;
  fTokenID := tkFreeText;
end;

procedure TSynBNFSyn.FreeTextProc;
begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkFreeText;
      Repeat
        If FLine[Run] = '?' Then
          Begin
            inc(Run);
            fRange := rsUnKnown;
            Break;
          End;
        If Not IsLineEnd(Run) Then
          Inc(Run);
      Until IsLineEnd(Run);
    End;
  End;
end;

Function TSynBNFSyn.FuncKeyword(Index: Integer): TtkTokenKind;

Begin
  Result := tkRules;
End;

Procedure TSynBNFSyn.AddAndUpdateAttributes(Attribute: TSynHighlighterAttributes; ForeColour,
  BackColour: TColor; FontStyle: TFontStyles);

Begin
  AddAttribute(Attribute);
  Attribute.Foreground := ForeColour;
  Attribute.Background := BackColour;
  Attribute.Style := FontStyle;
End;

Function TSynBNFSyn.AltFunc(Index: Integer): TtkTokenKind;

Begin
  Result := tkRules;
End;

Procedure TSynBNFSyn.SpaceProc;

Begin
  inc(Run);
  If Not (fTokenID In [tkCPPBlockComment]) Then
    fTokenID := tkSpace;
  While (FLine[Run] <= #32) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynBNFSyn.SymbolProc;

Begin
  inc(Run);
  fTokenID := tkSymbol;
  While CharInSet(FLine[Run], Symbols) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynBNFSyn.NullProc;

Begin
  If Not (fTokenID In [tkCPPBlockComment]) Then
    Begin
      fTokenID := tkNull;
      fRange := rsUnKnown;
    End;
  inc(Run);
End;

Procedure TSynBNFSyn.OptionalOperatorProc;

Begin
  inc(Run);
  fTokenID := tkOptionalPipe;
  While CharInSet(FLine[Run], OptionalOperatorsChars) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynBNFSyn.CRProc;

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

Destructor TSynBNFSyn.Destroy;

Begin
  Inherited Destroy;
End;

procedure TSynBNFSyn.DoubleLiteralOpenProc;
begin
  inc(Run);
  fRange := rsDoubleLiteral;
  fTokenID := tkDoubleLiteral;
end;

procedure TSynBNFSyn.DoubleLiteralProc;
begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkDoubleLiteral;
      Repeat
        If FLine[Run] = '"' Then
          Begin
            inc(Run);
            fRange := rsUnKnown;
            Break;
          End;
        If Not IsLineEnd(Run) Then
          Inc(Run);
      Until IsLineEnd(Run);
    End;
  End;
end;

Procedure TSynBNFSyn.LFProc;

Begin
  If Not (fTokenID In [tkCPPBlockComment]) Then
    Begin
      fTokenID := tkSpace;
      fRange := rsUnKnown;
    End;
  inc(Run);
End;

Procedure TSynBNFSyn.CharClassProc;

Begin
  inc(Run);
  fTokenID := tkOptionalBrace;
  While CharInSet(FLine[Run], CharacterClassChars) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynBNFSyn.CPPCommentOpenProc;

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

Procedure TSynBNFSyn.CPPLineCommentProc;

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

Procedure TSynBNFSyn.CPPBlockCommentProc;

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

Constructor TSynBNFSyn.Create(AOwner: TComponent);

Begin
  Inherited Create(AOwner);
  fCaseSensitive := False;
  fCharacterAttri := TSynHighlighterAttributes.Create(SYNS_AttrCharacter, SYNS_FriendlyAttrCharacter);
  AddAndUpdateAttributes(fCharacterAttri, clRed, clYellow, []);
  fCPPCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrCPPComment,
    SYNS_FriendlyAttrCPPComment);
  AddAndUpdateAttributes(fCPPCommentAttri, clPurple, clNone, [fsItalic]);
  fRulesAttri := TSynHighlighterAttributes.Create(SYNS_AttrRules, SYNS_FriendlyAttrRules);
  AddAndUpdateAttributes(fRulesAttri, clBlue, clNone, []);
  fGroupingAttri := TSynHighlighterAttributes.Create(SYNS_AttrGrouping,
    SYNS_FriendlyAttrGroupingClass);
  AddAndUpdateAttributes(fGroupingAttri, clMaroon, clNone, [fsBold]);
  fOptionalPipeAttri := TSynHighlighterAttributes.Create(SYNS_AttrOptionalPipe,
    SYNS_FriendlyAttrOptionalPipe);
  AddAndUpdateAttributes(fOptionalPipeAttri, clMaroon, clNone, [fsBold]);
  fOptionalBraceAttri := TSynHighlighterAttributes.Create(SYNS_AttrOptionalBrace,
    SYNS_FriendlyAttrOptionalBrace);
  AddAndUpdateAttributes(fOptionalBraceAttri, clMaroon, clNone, [fsBold]);
  fRepeatAttri := TSynHighlighterAttributes.Create(SYNS_AttrRepeat, SYNS_FriendlyAttrRepeat);
  AddAndUpdateAttributes(fRepeatAttri, clMaroon, clNone, [fsBold]);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol, SYNS_FriendlyAttrSymbol);
  AddAndUpdateAttributes(fSymbolAttri, clMaroon, clNone, []);
  fSingleLiteralAttri := TSynHighlighterAttributes.Create(SYNS_AttrSingleLiteral,
    SYNS_FriendlyAttrSingleLiteral);
  AddAndUpdateAttributes(fSingleLiteralAttri, clBlack, clNone, []);
  fDoubleLiteralAttri := TSynHighlighterAttributes.Create(SYNS_AttrDoubleLiteral,
    SYNS_FriendlyAttrDoubleLiteral);
  AddAndUpdateAttributes(fDoubleLiteralAttri, clBlack, clNone, []);
  fFreeTextAttri := TSynHighlighterAttributes.Create(SYNS_AttrFreeText,
    SYNS_FriendlyAttrFreeText);
  AddAndUpdateAttributes(fFreeTextAttri, clGreen, $80FFFF, []);
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace, SYNS_FriendlyAttrSpace);
  AddAndUpdateAttributes(fSpaceAttri, clNone, clNone, []);
  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  fDefaultFilter := SYNS_FilterRegularExpressions;
  fRange := rsUnKnown;
End;

Procedure TSynBNFSyn.IdentProc;

Begin
  While IsIdentChar(FLine[Run]) Do
    inc(Run);
  fTokenID := tkIdentifier;
End;

Procedure TSynBNFSyn.UnknownProc;

Begin
  inc(Run);
  fTokenID := tkUnknown;
End;

Procedure TSynBNFSyn.Next;

Begin
  fTokenPos := Run;
  Case fRange Of
    rsCPPLineComment: CPPLineCommentProc;
    rsCPPBlockComment: CPPBlockCommentProc;
    rsRule: RuleNameProc;
    rsSingleLiteral: SingleLiteralProc;
    rsDoubleLiteral: DoubleLiteralProc;
    rsFreeText: FreeTextProc;
  Else
    Case FLine[Run] Of
      #00: NullProc;
      #10: LFProc;
      #13: CRProc;
      '/': CPPCommentOpenProc;
      '+', '*': RepeatOperatorProc;
      '|': OptionalOperatorProc;
      '[', ']': CharClassProc;
      '(', ')': GroupingProc;
      '<': RuleOpenProc;
      '''': SingleLiteralOpenProc;
      '"': DoubleLiteralOpenProc;
      '?': FreeTextOpenProc;
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

Function TSynBNFSyn.GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes;

Begin
  Case Index Of
    SYN_ATTR_COMMENT: Result := fCPPCommentAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
  Else
    Result := Nil;
  End;
End;

Function TSynBNFSyn.GetEol: Boolean;

Begin
  Result := Run = fLineLen + 1;
End;

Function TSynBNFSyn.GetTokenID: TtkTokenKind;

Begin
  Result := fTokenID;
End;

Function TSynBNFSyn.GetTokenAttribute: TSynHighlighterAttributes;

Begin
  Case GetTokenID Of
    tkCPPLineComment: Result := fCPPCommentAttri;
    tkCPPBlockComment: Result := fCPPCommentAttri;
    tkOptionalPipe: Result := fOptionalPipeAttri;
    tkOptionalBrace: Result := fOptionalBraceAttri;
    tkRules: Result := fRulesAttri;
    tkRepeat: Result := fRepeatAttri;
    tkSymbol: Result := fSymbolAttri;
    tkGrouping: Result := fGroupingAttri;
    tkSpace: Result := fSpaceAttri;
    tkSingleLiteral: Result := SingleLiteral;
    tkDoubleLiteral: Result := DoubleLiteral;
    tkFreeText: Result := FreeText;
  Else
    Result := fCharacterAttri;
  End;
End;

Function TSynBNFSyn.GetTokenKind: Integer;

Begin
  Result := Ord(fTokenID);
End;

Procedure TSynBNFSyn.GroupingProc;

Begin
  inc(Run);
  fTokenID := tkGrouping;
  While CharInSet(FLine[Run], GroupingChars) And Not IsLineEnd(Run) Do
    inc(Run);
End;

Procedure TSynBNFSyn.RuleOpenProc;

Begin
  inc(Run);
  fRange := rsRule;
  fTokenID := tkRules;
End;

Procedure TSynBNFSyn.RuleNameProc;

Begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkRules;
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

Function TSynBNFSyn.IsIdentChar(AChar: WideChar): Boolean;

Begin
  Case AChar Of
    '!', '_', '0' .. '9', 'a' .. 'z', 'A' .. 'Z':
      Result := True;
  Else
    Result := False;
  End;
End;

Function TSynBNFSyn.GetSampleSource: UnicodeString;

Begin
  Result :=
    'Sample source for: '#13#10 +
    'RegEx Syntax Parser/Highlighter';
End;

Function TSynBNFSyn.IsFilterStored: Boolean;

Begin
  Result := fDefaultFilter <> SYNS_FilterRegularExpressions;
End;

Class Function TSynBNFSyn.GetFriendlyLanguageName: UnicodeString;

Begin
  Result := SYNS_FriendlyLangRegularExpressions;
End;

Class Function TSynBNFSyn.GetLanguageName: String;

Begin
  Result := SYNS_LangRegularExpressions;
End;

Procedure TSynBNFSyn.RepeatOperatorProc;

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

Procedure TSynBNFSyn.ResetRange;

Begin
  fRange := rsUnKnown;
End;

Procedure TSynBNFSyn.SetRange(Value: Pointer);

Begin
  fRange := TRangeState(Value);
End;

procedure TSynBNFSyn.SingleLiteralOpenProc;

begin
  inc(Run);
  fRange := rsSingleLiteral;
  fTokenID := tkSingleLiteral;
end;

procedure TSynBNFSyn.SingleLiteralProc;
begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkSingleLiteral;
      Repeat
        If FLine[Run] = '''' Then
          Begin
            inc(Run);
            fRange := rsUnKnown;
            Break;
          End;
        If Not IsLineEnd(Run) Then
          Inc(Run);
      Until IsLineEnd(Run);
    End;
  End;
end;

Function TSynBNFSyn.GetRange: Pointer;

Begin
  Result := Pointer(fRange);
End;

Initialization
  {$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynBNFSyn);
  {$ENDIF}
End.
