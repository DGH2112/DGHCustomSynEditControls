{$IFNDEF QREGEXSYNHIGHLIGHTERGRAMMAR}
(**

  This module contains a SynEdit Highlighter for Backus-Naur grammar.

  @Author  David Hoyle
  @Version 1.0
  @Date    28 Jan 2018

**)
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
  (** An enumerate to define the types of token in the highlighter. **)
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

  (** An enumerate to define the tokens that can have a range. **)
  TRangeState = (
    rsUnKnown,
    rsCPPLineComment,
    rsCPPBlockComment,
    rsSingleLiteral,
    rsDoubleLiteral,
    rsRule,
    rsFreeText
  );

  (** A pointer to a function table. **)
  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  (** A type defining a function for the function table. **)
  TIdentFuncTableFunc = Function(Const Index: Integer): TtkTokenKind Of Object;

Type
  (** A custom synedit highlighter component for the backus-naur grammar. **)
  TSynBNFSyn = Class(TSynCustomHighlighter)
  Strict Private
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
  Strict Protected
    Function  FuncKeyword(Const Index: Integer): TtkTokenKind;
    Procedure IdentProc;
    Procedure UnknownProc;
    Function  AltFunc(Const Index: Integer): TtkTokenKind;
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
    Function  GetSampleSource: UnicodeString; Override;
    Function  IsFilterStored: Boolean; Override;
    Procedure AddAndUpdateAttributes(Const Attribute: TSynHighlighterAttributes; Const ForeColour,
      BackColour: TColor; Const FontStyle: TFontStyles);
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
    (**
      A property for accessing the attributes of the character class elements.
      @precon  None.
      @postcon Gets and sets the character class attributes.
      @return  a TSynHighlighterAttributes
    **)
    Property CharacterAttri: TSynHighlighterAttributes Read fCharacterAttri Write fCharacterAttri;
    (**
      A property for accessing the attributes of the C++ Comments elements.
      @precon  None.
      @postcon Gets and sets the character attributes for C++ Comments.
      @return  a TSynHighlighterAttributes
    **)
    Property CPPCommentAttri: TSynHighlighterAttributes Read fCPPCommentAttri
      Write fCPPCommentAttri;
    (**
      A property for accessing the attributes of the Rule elements.
      @precon  None.
      @postcon Gets and sets the character attributes for Rules.
      @return  a TSynHighlighterAttributes
    **)
    Property RulesAttri: TSynHighlighterAttributes Read fRulesAttri Write fRulesAttri;
    (**
      A property for accessing the attributes of the Optional Pipe elements.
      @precon  None.
      @postcon Gets and sets the character attributes for optional pipes.
      @return  a TSynHighlighterAttributes
    **)
    Property OptionalPipeAttri: TSynHighlighterAttributes Read fOptionalPipeAttri
      Write fOptionalPipeAttri;
    (**
      A property for accessing the attributes of the reap operator elements.
      @precon  None.
      @postcon Gets and sets the character attributes for repeat operators.
      @return  a TSynHighlighterAttributes
    **)
    Property RepeatAttri: TSynHighlighterAttributes Read fRepeatAttri Write fRepeatAttri;
    (**
      A property for accessing the attributes of the grouping elements.
      @precon  None.
      @postcon Gets and sets the character attributes for grouping.
      @return  a TSynHighlighterAttributes
    **)
    Property GroupingAttri: TSynHighlighterAttributes Read fGroupingAttri Write fGroupingAttri;
    (**
      A property for accessing the attributes of the brace elements.
      @precon  None.
      @postcon Gets and sets the character attributes for braces.
      @return  a TSynHighlighterAttributes
    **)
    Property OptionalBraceAttri: TSynHighlighterAttributes Read fOptionalBraceAttri
      Write fOptionalBraceAttri;
    (**
      A property for accessing the attributes of the space elements.
      @precon  None.
      @postcon Gets and sets the character attributes for spaces.
      @return  a TSynHighlighterAttributes
    **)
    Property SpaceAttri: TSynHighlighterAttributes Read fSpaceAttri Write fSpaceAttri;
    (**
      A property for accessing the attributes of the symbols elements.
      @precon  None.
      @postcon Gets and sets the character attributes for symbols.
      @return  a TSynHighlighterAttributes
    **)
    Property RegExSymbols : TSynHighlighterAttributes Read fSymbolAttri Write fSymbolAttri;
    (**
      A property for accessing the attributes of the single literals elements.
      @precon  None.
      @postcon Gets and sets the character attributes for single literals.
      @return  a TSynHighlighterAttributes
    **)
    Property SingleLiteral : TSynHighlighterAttributes Read fSingleLiteralAttri
      Write fSingleLiteralAttri;
    (**
      A property for accessing the attributes of the Double Literal elements.
      @precon  None.
      @postcon Gets and sets the character attributes for double literals.
      @return  a TSynHighlighterAttributes
    **)
    Property DoubleLiteral : TSynHighlighterAttributes Read fDoubleLiteralAttri
      Write fDoubleLiteralAttri;
    (**
      A property for accessing the attributes of the Free text elements.
      @precon  None.
      @postcon Gets and sets the character attributes for Free Text.
      @return  a TSynHighlighterAttributes
    **)
    Property FreeText : TSynHighlighterAttributes Read fFreeTextAttri Write fFreeTextAttri;
  End;

Implementation

Uses
  {$IFDEF SYN_CLX}
  QSynEditStrConst;
  {$ELSE}
  SynEditStrConst;
  {$ENDIF}

Resourcestring
  (** A resource string for the default file filters **)
  SYNS_FilterRegularExpressions = 'Backus-Naur Grammar Files (*.bnf)|*.bnf';
  (** A resource string for the highlighter language name **)
  SYNS_LangRegularExpressions = 'Backus-Naur';
  (** A resource string for C++ Comment attribute **)
  SYNS_AttrCPPComment = 'C++ Comment';
  (** A resource string for the BNF Rule attribute. **)
  SYNS_AttrRules = 'BNF Rule';
  (** A resource string for the Optional Pipe Operator **)
  SYNS_AttrOptionalPipe = 'Optional Pipe Operator';
  (** A resource string for the Optional Brace **)
  SYNS_AttrOptionalBrace = 'Optional Brace';
  (** A resource string for the Repeat Operator **)
  SYNS_AttrRepeat = 'Repeat Operator';
  (** A resource string for the Grouping Parenthesis **)
  SYNS_AttrGrouping = 'Grouping Parenthesis';
  (** A resource string for the Single Quote String Literal **)
  SYNS_AttrSingleLiteral = 'Single Quoted String Literal';
  (** A resource string for the Double Quote String Literal **)
  SYNS_AttrDoubleLiteral = 'Double Quoted String Literal';
  (** A resource string for the Free Text **)
  SYNS_AttrFreeText = 'Free Text';

Const
  (** Not sure... **)
  KeyIndices: Array [0..1] Of Integer = (0, -1);
  (** A character array for the repeat operators. **)
  RepeatOperatorsChars = ['+', '*'];
  (** A character array for the optional operators. **)
  OptionalOperatorsChars = ['|'];
  (** A character array for the character class grouping. **)
  CharacterClassChars = ['[', ']'];
  (** A character array for grouping. **)
  GroupingChars = ['(', ')'];
  (** A character array for C++ Line Comments. **)
  CPPCommentChars = ['/'];
  (** A character array for Single String Literals **)
  SingleLiteralChars = [''''];
  (** A character array for Double String Literals **)
  DoubleLiteralChars = ['"'];
  (** A character array for Free Text **)
  FreeTextChar = ['?'];
  (** A character array for Symbols **)
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

{$Q-}


Procedure TSynBNFSyn.AddAndUpdateAttributes(Const Attribute: TSynHighlighterAttributes; Const ForeColour,
  BackColour: TColor; Const FontStyle: TFontStyles);

Begin
  AddAttribute(Attribute);
  Attribute.Foreground := ForeColour;
  Attribute.Background := BackColour;
  Attribute.Style := FontStyle;
End;

Function TSynBNFSyn.AltFunc(Const Index: Integer): TtkTokenKind; //FI:O804

Begin
  Result := tkRules;
End;

Procedure TSynBNFSyn.CharClassProc;

Begin
  inc(Run);
  fTokenID := tkOptionalBrace;
  While CharInSet(FLine[Run], CharacterClassChars) And Not IsLineEnd(Run) Do
    inc(Run);
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

Constructor TSynBNFSyn.Create(AOwner: TComponent);

Const
  iLightYellow = $80FFFF;

Begin
  Inherited Create(AOwner);
  fCaseSensitive := False;
  fCharacterAttri := TSynHighlighterAttributes.Create(SYNS_AttrCharacter, SYNS_FriendlyAttrCharacter);
  AddAndUpdateAttributes(fCharacterAttri, clRed, clYellow, []);
  fCPPCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrCPPComment, SYNS_AttrCPPComment);
  AddAndUpdateAttributes(fCPPCommentAttri, clPurple, clNone, [fsItalic]);
  fRulesAttri := TSynHighlighterAttributes.Create(SYNS_AttrRules, SYNS_AttrRules);
  AddAndUpdateAttributes(fRulesAttri, clBlue, clNone, []);
  fGroupingAttri := TSynHighlighterAttributes.Create(SYNS_AttrGrouping, SYNS_AttrGrouping);
  AddAndUpdateAttributes(fGroupingAttri, clMaroon, clNone, [fsBold]);
  fOptionalPipeAttri := TSynHighlighterAttributes.Create(SYNS_AttrOptionalPipe, SYNS_AttrOptionalPipe);
  AddAndUpdateAttributes(fOptionalPipeAttri, clMaroon, clNone, [fsBold]);
  fOptionalBraceAttri := TSynHighlighterAttributes.Create(SYNS_AttrOptionalBrace, SYNS_AttrOptionalBrace);
  AddAndUpdateAttributes(fOptionalBraceAttri, clMaroon, clNone, [fsBold]);
  fRepeatAttri := TSynHighlighterAttributes.Create(SYNS_AttrRepeat, SYNS_AttrRepeat);
  AddAndUpdateAttributes(fRepeatAttri, clMaroon, clNone, [fsBold]);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol, SYNS_AttrSymbol);
  AddAndUpdateAttributes(fSymbolAttri, clMaroon, clNone, []);
  fSingleLiteralAttri := TSynHighlighterAttributes.Create(SYNS_AttrSingleLiteral, SYNS_AttrSingleLiteral);
  AddAndUpdateAttributes(fSingleLiteralAttri, clBlack, clNone, []);
  fDoubleLiteralAttri := TSynHighlighterAttributes.Create(SYNS_AttrDoubleLiteral, SYNS_AttrDoubleLiteral);
  AddAndUpdateAttributes(fDoubleLiteralAttri, clBlack, clNone, []);
  fFreeTextAttri := TSynHighlighterAttributes.Create(SYNS_AttrFreeText, SYNS_AttrFreeText);
  AddAndUpdateAttributes(fFreeTextAttri, clGreen, iLightYellow, []);
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace, SYNS_AttrSpace);
  AddAndUpdateAttributes(fSpaceAttri, clNone, clNone, []);
  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  fDefaultFilter := SYNS_FilterRegularExpressions;
  fRange := rsUnKnown;
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

Function TSynBNFSyn.FuncKeyword(Const Index: Integer): TtkTokenKind; //FI:O804

Begin
  Result := tkRules;
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

Class Function TSynBNFSyn.GetFriendlyLanguageName: UnicodeString;

Begin
  Result := SYNS_LangRegularExpressions;
End;

Class Function TSynBNFSyn.GetLanguageName: String;

Begin
  Result := SYNS_LangRegularExpressions;
End;

Function TSynBNFSyn.GetRange: Pointer;

Begin
  Result := Pointer(fRange);
End;

Function TSynBNFSyn.GetSampleSource: UnicodeString;

ResourceString
  strSampleSource = 'Sample source for: '#13#10'RegEx Syntax Parser/Highlighter';

Begin
  Result := strSampleSource;
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

Function TSynBNFSyn.GetTokenID: TtkTokenKind;

Begin
  Result := fTokenID;
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

Procedure TSynBNFSyn.IdentProc;

Begin
  While IsIdentChar(FLine[Run]) Do
    inc(Run);
  fTokenID := tkIdentifier;
End;

Procedure TSynBNFSyn.InitIdent;

Var
  i: Integer;

Begin
  For i := Low(fIdentFuncTable) To High(fIdentFuncTable) Do
    If KeyIndices[i] = - 1 Then
      fIdentFuncTable[i] := AltFunc;
  fIdentFuncTable[0] := FuncKeyword;
End;

Function TSynBNFSyn.IsFilterStored: Boolean;

Begin
  Result := fDefaultFilter <> SYNS_FilterRegularExpressions;
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

Procedure TSynBNFSyn.LFProc;

Begin
  If Not (fTokenID In [tkCPPBlockComment]) Then
    Begin
      fTokenID := tkSpace;
      fRange := rsUnKnown;
    End;
  inc(Run);
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

Procedure TSynBNFSyn.RuleOpenProc;

Begin
  inc(Run);
  fRange := rsRule;
  fTokenID := tkRules;
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

Procedure TSynBNFSyn.UnknownProc;

Begin
  inc(Run);
  fTokenID := tkUnknown;
End;

(** Registers the highlighter. **)
Initialization
  {$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynBNFSyn);
  {$ENDIF}
End.
