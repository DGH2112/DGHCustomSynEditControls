{$IFNDEF QREGEXSYNHIGHLIGHTERGRAMMAR}
(**

  This module contains a SynEdit highlighter for the Markdown language.

  @Author  David Hoyle
  @Version 1.0
  @Date    28 Jan 2018

**)
Unit SynHighlighterMD;
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
  (** An enumerate to define the types of token that can be highlighted. **)
  TMDTokenKind = (
    tkMDLineComment,
    //: @todo Heading underlined with ======
    //: @todo ## Subheading
    tkMDItalic,
    tkMDBold,
    tkMDMonospace,
    //: @todo Horizontal rule: ---
    //: @todo Bullet:    * apples
    //: @todo Number:    1 wash
    //: @todo [link](http://example.com)
    //: @todo [Image](Image_icon.png)
    //: @todo In-line HTML support
    tkSpace,
    tkSymbol,
    tkText
  );

  (** An enumerate to define the token ranges in the text. **)
  TMDRangeState = (
    rsMDLineComment,
    rsMDItalic,
    rsMDBold,
    rsMDMonospace,
    rsText
  );

  (** A pointer to a function table procedure. **)
  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  (** A function table procedure. **)
  TIdentFuncTableFunc = Function(Const Index: Integer): TMDTokenKind Of Object;

Type
  (** A class to define the Markdown language highlighter. **)
  TSynMDSyn = Class(TSynCustomHighlighter)
  Strict Private
    FRange:          TMDRangeState;
    FTokenID:        TMDTokenKind;
    FIdentFuncTable: Array [0 .. 1] Of TIdentFuncTableFunc;
    FTokenAttri:     Array [Low(TMDTokenKind) .. High(TMDTokenKind)] Of TSynHighlighterAttributes;
  Strict Protected
    Function  FuncKeyword(Const Index: Integer): TMDTokenKind;
    Function  AltFunc(Const Index: Integer): TMDTokenKind;
    Procedure InitIdent;
    Procedure NullProc;
    Procedure SpaceProc;
    Procedure CRProc;
    Procedure LFProc;
    Procedure MDCommentOpenProc;
    Procedure MDLineCommentProc;
    Procedure MDItalicOpenProc;
    Procedure MDItalicProc;
    Procedure MDBoldOpenProc;
    Procedure MDBoldProc;
    Procedure MDMonospaceOpenProc;
    Procedure MDMonospaceProc;
    Procedure SymbolProc;
    Procedure TextProc;
    Function  GetSampleSource: String; Override;
    Function  IsFilterStored: Boolean; Override;
    Procedure AddAndUpdateAttributes(Const Attribute: TSynHighlighterAttributes; Const ForeColour,
      BackColour: TColor; Const FontStyle: TFontStyles);
    Function  GetAttri(Const eTokenKind: TMDTokenKind): TSynHighlighterAttributes;
    Procedure SetAttri(Const eTokenKind: TMDTokenKind; Const Attri: TSynHighlighterAttributes);
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Class Function GetFriendlyLanguageName: UnicodeString; Override;
    Class Function GetLanguageName: String; Override;
    Function GetRange: Pointer; Override;
    Procedure ResetRange; Override;
    Procedure SetRange(Value: Pointer); Override;
    Function GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes; Override;
    Function GetEol: Boolean; Override;
    Function GetTokenID: TMDTokenKind;
    Function GetTokenAttribute: TSynHighlighterAttributes; Override;
    Function GetTokenKind: Integer; Override;
    Function IsIdentChar(AChar: WideChar): Boolean; Override;
    Procedure Next; Override;
  Published
    (**
      A property to hold the MD Comment character attributes.
      @precon  None.
      @postcon Gets and sets the MD Comment character attributes.
      @return  a TSynHighlighterAttributes
    **)
    Property MDCommentAttri: TSynHighlighterAttributes Index tkMDLineComment Read GetAttri Write SetAttri;
    (**
      A property to hold the MD Italic character attributes.
      @precon  None.
      @postcon Gets and sets the MD Italic character attributes.
      @return  a TSynHighlighterAttributes
    **)
    Property MDItalic : TSynHighlighterAttributes Index tkMDItalic Read GetAttri Write SetAttri;
    Property MDBold : TSynHighlighterAttributes Index tkMDBold Read GetAttri Write SetAttri;
    Property MDMonospace : TSynHighlighterAttributes Index tkMDMonospace Read GetAttri Write SetAttri;
    (**
      A property to hold the space character attributes.
      @precon  None.
      @postcon Gets and sets the space character attributes.
      @return  a TSynHighlighterAttributes
    **)
    Property SpaceAttri: TSynHighlighterAttributes Index tkSpace Read GetAttri Write SetAttri;
    (**
      A property to hold the symbol character attributes.
      @precon  None.
      @postcon Gets and sets the symbol character attributes.
      @return  a TSynHighlighterAttributes
    **)
    Property RegExSymbols: TSynHighlighterAttributes Index tkSymbol Read GetAttri Write SetAttri;
    (**
      A property to hold the text character attributes.
      @precon  None.
      @postcon Gets and sets the text character attributes.
      @return  a TSynHighlighterAttributes
    **)
    Property Text: TSynHighlighterAttributes Index tkText Read GetAttri Write SetAttri;
  End;

Implementation

Uses
  {$IFDEF SYN_CLX}
  QSynEditStrConst;
  {$ELSE}
  SynEditStrConst;
{$ENDIF}


Resourcestring
  (** A resource string for the mark down default file filter. **)
  SYNS_FilterMarkdown = 'Markdown Files (*.regex)|*.regex';
  (** A resource string for the language name. **)
  SYNS_LangMarkdown = 'Markdown';
  (** A resource string for the MD Comment attribute name. **)
  SYNS_AttrMDComment = 'Markdown Comment';
  (** A resource string for the MD italic attribute name. **)
  SYNS_AttrItalic = 'Italic Text';
  SYNS_AttrBold = 'Bold Text';
  SYNS_AttrMonospace = 'Monospace Text';
  (** A resource string for the MD text attribute name. **)
  SYNS_AttrText = 'Text';

Const
  (** Table function index. **)
  KeyIndices: Array [0 .. 1] Of Integer = (0, - 1);
  (** A constant to define the characters that start an MD comment **)
  acMDCommentChars = ['#'];
  (** A constant to define the characters that are identifier characters. **)
  acIdentifier = ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_'];
  (** A constant to define the characters that are space characters. **)
  acSpace = [#32, #9];
  (** A constant to define the characters that should be considered as symbols. **)
  acSymbols = [#32 .. #128] - acSpace - acIdentifier - acMDCommentChars;

{$Q-}

{$REGION IGNORE}
(**

  This method sets the given attribute with the given colours and font style.

  @precon  None.
  @postcon The given attribute has its font colour, background colour and font style set.

  @param   Attribute  as a TSynHighlighterAttributes as a constant
  @param   ForeColour as a TColor as a constant
  @param   BackColour as a TColor as a constant
  @param   FontStyle  as a TFontStyles as a constant

**)
Procedure TSynMDSyn.AddAndUpdateAttributes(Const Attribute: TSynHighlighterAttributes; Const ForeColour,
  BackColour: TColor; Const FontStyle: TFontStyles);

Begin
  AddAttribute(Attribute);
  Attribute.Foreground := ForeColour;
  Attribute.Background := BackColour;
  Attribute.Style := FontStyle;
End;

(**

  This method returns Text as the default attribute.

  @precon  None.
  @postcon Returns Text as the default attribute.

  @nohint  Index
  
  @param   Index as an Integer as a constant
  @return  a TMDTokenKind

**)
Function TSynMDSyn.AltFunc(Const Index: Integer): TMDTokenKind;

Begin
  Result := tkText;
End;
{$ENDREGION}

(**

  A constructor for the TSynMDSyn class.

  @precon  None.
  @postcon The control is initialised.

  @nocheck MissingCONSTINParam

  @param   AOwner as a TComponent

**)
Constructor TSynMDSyn.Create(AOwner: TComponent);

Begin
  Inherited Create(AOwner);
  fCaseSensitive := False;
  FTokenAttri[tkMDLineComment] := TSynHighlighterAttributes.Create(SYNS_AttrMDComment, SYNS_AttrMDComment);
  AddAndUpdateAttributes(FTokenAttri[tkMDLineComment], clPurple, clNone, [fsItalic]);
  FTokenAttri[tkMDItalic] := TSynHighlighterAttributes.Create(SYNS_AttrItalic, SYNS_AttrItalic);
  AddAndUpdateAttributes(FTokenAttri[tkMDItalic], clNone, clNone, [fsItalic]);
  FTokenAttri[tkMDBold] := TSynHighlighterAttributes.Create(SYNS_AttrBold, SYNS_AttrBold);
  AddAndUpdateAttributes(FTokenAttri[tkMDBold], clNone, clNone, [fsBold]);
  FTokenAttri[tkMDMonospace] := TSynHighlighterAttributes.Create(SYNS_AttrMonospace, SYNS_AttrMonospace);
  AddAndUpdateAttributes(FTokenAttri[tkMDMonospace], clNone, clNone, []);
  FTokenAttri[tkSymbol] := TSynHighlighterAttributes.Create(SYNS_AttrSymbol, SYNS_FriendlyAttrSymbol);
  AddAndUpdateAttributes(FTokenAttri[tkSymbol], clMaroon, clNone, []);
  FTokenAttri[tkText] := TSynHighlighterAttributes.Create(SYNS_AttrText, SYNS_AttrText);
  AddAndUpdateAttributes(FTokenAttri[tkText], clNone, clNone, []);
  FTokenAttri[tkSpace] := TSynHighlighterAttributes.Create(SYNS_AttrSpace, SYNS_FriendlyAttrSpace);
  AddAndUpdateAttributes(FTokenAttri[tkSpace], clNone, clNone, []);
  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  fDefaultFilter := SYNS_FilterMarkdown;
  FRange := rsText;
End;

(**

  This method processes a carriage return character.

  @precon  None.
  @postcon A carriage return chacracter is processed.

**)
Procedure TSynMDSyn.CRProc;

Begin
  If Not (FRange In [rsMDItalic, rsMDBold, rsMDMonospace]) Then
    Begin
      FTokenID := tkSpace;
      FRange := rsText;
    End;
  Inc(Run);
  If FLine[Run] = #10 Then
    Inc(Run);
End;

{$REGION IGNORE}
(**

  A destructor for the TSynMDSyn class.

  @precon  None.
  @postcon Nothing.

**)
Destructor TSynMDSyn.Destroy;

Begin
  Inherited Destroy;
End;

Function TSynMDSyn.FuncKeyword(Const Index: Integer): TMDTokenKind;

Begin
  Result := tkText;
End;

(**

  This is a getter method for the XxxxxxAttri properties.

  @precon  None.
  @postcon Returns the instance of the given attribute set.

  @param   eTokenKind as a TMDTokenKind as a constant
  @return  a TSynHighlighterAttributes

**)
Function TSynMDSyn.GetAttri(Const eTokenKind: TMDTokenKind): TSynHighlighterAttributes;

Begin
  Result := FTokenAttri[eTokenKind];
End;

(**

  This is a getter method for the DefaultAttribute property.

  @precon  None.
  @postcon Returns the indexed default attribute.

  @nocheck MissingConstInParam

  @param   Index as an Integer
  @return  a TSynHighlighterAttributes

**)
Function TSynMDSyn.GetDefaultAttribute(Index: Integer): TSynHighlighterAttributes;

Begin
  Case Index Of
    SYN_ATTR_COMMENT: Result := FTokenAttri[tkMDLineComment];
    SYN_ATTR_WHITESPACE: Result := FTokenAttri[tkSpace];
  Else
    Result := Nil;
  End;
End;

(**

  This is a getter method for the Eol property.

  @precon  None.
  @postcon Returns true if the Run property is 1 beyond the end of the line.

  @return  a Boolean

**)
Function TSynMDSyn.GetEol: Boolean;

Begin
  Result := Run = fLineLen + 1;
End;

(**

  This is a getter method for the Friendlt=yLanguageName property.

  @precon  None.
  @postcon Returns the name of the language being highlighted.

  @return  an UnicodeString

**)
Class Function TSynMDSyn.GetFriendlyLanguageName: UnicodeString;

Begin
  Result := SYNS_LangMarkdown;
End;

(**

  This is a getter method for the LanguageName property.

  @precon  None.
  @postcon Returns the name of the language.

  @return  a String

**)
Class Function TSynMDSyn.GetLanguageName: String;

Begin
  Result := SYNS_LangMarkdown;
End;

(**

  This is a getter method for the Range property.

  @precon  None.
  @postcon returns the range enumerate as a pointer.

  @return  a Pointer

**)
Function TSynMDSyn.GetRange: Pointer;

Begin
  Result := Pointer(FRange);
End;

(**

  This is a getter method for the SampleSource property.

  @precon  None.
  @postcon Returns a sample of text for the language.

  @return  a String

**)
Function TSynMDSyn.GetSampleSource: String;

ResourceString
  //: @todo Update with some meaningful text example.
  strSampleSource =
    'Sample source for: '#13#10 +
    'MD Syntax Parser/Highlighter';

Begin
  Result := strSampleSource;
End;
{$ENDREGION}

(**

  This is a getter method for the TokenAttribute property.

  @precon  None.
  @postcon Returns the attribute associated with the current Token ID.

  @return  a TSynHighlighterAttributes

**)
Function TSynMDSyn.GetTokenAttribute: TSynHighlighterAttributes;

Begin
  Case GetTokenID Of
    tkMDLineComment: Result := FTokenAttri[tkMDLineComment];
    tkMDItalic:      Result := FTokenAttri[tkMDItalic];
    tkMDBold:        Result := FTokenAttri[tkMDBold];
    tkMDMonospace:   Result := FTokenAttri[tkMDMonospace];
    tkSymbol:        Result := FTokenAttri[tkSymbol];
    tkSpace:         Result := FTokenAttri[tkSpace];
  Else
    Result := FTokenAttri[tkText];
  End;
End;

{$REGION IGNORE}
(**

  This is a getter method for the TokenID property.

  @precon  None.
  @postcon Returns the current token ID.

  @return  a TMDTokenKind

**)
Function TSynMDSyn.GetTokenID: TMDTokenKind;

Begin
  Result := FTokenID;
End;

(**

  This is a getter method for the TokenKind property.

  @precon  None.
  @postcon Returns the token ID as an integer.

  @return  an Integer

**)
Function TSynMDSyn.GetTokenKind: Integer;

Begin
  Result := Ord(FTokenID);
End;

(**

  This method initialises the function table.

  @precon  None.
  @postcon The function table is initialised.

**)
Procedure TSynMDSyn.InitIdent;

Var
  i: Integer;

Begin
  For i := Low(FIdentFuncTable) To High(FIdentFuncTable) Do
    If KeyIndices[i] = - 1 Then
      FIdentFuncTable[i] := AltFunc;
  FIdentFuncTable[0] := FuncKeyword;
End;

(**

  This method returns true if the filter has changed and needs to be stored.

  @precon  None.
  @postcon Returns true if the filter has changed and needs to be stored.

  @return  a Boolean

**)
Function TSynMDSyn.IsFilterStored: Boolean;

Begin
  Result := fDefaultFilter <> SYNS_FilterMarkdown;
End;

(**

  This method returns true if the given character is an identifier character.

  @precon  None.
  @postcon Returns true if the given character is an identifier character.

  @nocheck MissingConstInParam

  @param   AChar as a WideChar
  @return  a Boolean

**)
Function TSynMDSyn.IsIdentChar(AChar: WideChar): Boolean;

Begin
  Case AChar Of
    '!', '_', '0' .. '9', 'a' .. 'z', 'A' .. 'Z':
      Result := True;
  Else
    Result := False;
  End;
End;
{$ENDREGION}

Procedure TSynMDSyn.LFProc;

Begin
  If Not (FRange In [rsMDItalic, rsMDBold, rsMDMonospace]) Then
    Begin
      FTokenID := tkSpace;
      FRange := rsText;
    End;
  Inc(Run);
End;

Procedure TSynMDSyn.MDBoldOpenProc;

Begin
  Inc(Run);
  If FLine[Run] = '*' Then
    Begin
      Inc(Run);
      fRange := rsMDBold;
      fTokenID := tkMDBold;
    End Else
      fTokenID := tkSymbol;
End;

Procedure TSynMDSyn.MDBoldProc;

Begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      fTokenID := tkMDBold;
      Repeat
        If (FLine[Run] = '*') And (FLine[Run - 1] = '*') Then
          Begin
            inc(Run);
            fRange := rsText;
            Break;
          End;
        If Not IsLineEnd(Run) Then
          inc(Run);
      Until IsLineEnd(Run);
    End;
  End;
End;

Procedure TSynMDSyn.MDCommentOpenProc;

Begin
  Inc(Run);
  FRange := rsMDLineComment;
  FTokenID := tkMDLineComment;
End;

Procedure TSynMDSyn.MDItalicOpenProc;

Begin
  Inc(Run);
  FRange := rsMDItalic;
  FTokenID := tkMDItalic;
End;

Procedure TSynMDSyn.MDItalicProc;

Begin
  Case FLine[Run] Of
    #0:  NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      FTokenID := tkMDItalic;
      Repeat
        Inc(Run);
      Until IsLineEnd(Run) Or (FLine[Run] = '_');
      If FLine[Run] = '_' Then
        Begin
          Inc(Run);
          FRange := rsText;
        End;
    End;
  End;
End;

Procedure TSynMDSyn.MDLineCommentProc;

Begin
  Case FLine[Run] Of
    #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      FTokenID := tkMDLineComment;
      Repeat
        If Not IsLineEnd(Run) Then
          Inc(Run);
      Until IsLineEnd(Run);
    End;
  End;
End;

Procedure TSynMDSyn.MDMonospaceOpenProc;

Begin
  Inc(Run);
  FRange := rsMDMonospace;
  FTokenID := tkMDMonospace;
End;

Procedure TSynMDSyn.MDMonospaceProc;

Begin
  Case FLine[Run] Of
    #0:  NullProc;
    #10: LFProc;
    #13: CRProc;
  Else
    Begin
      FTokenID := tkMDMonospace;
      Repeat
        Inc(Run);
      Until IsLineEnd(Run) Or (FLine[Run] = '`');
      If FLine[Run] = '`' Then
        Begin
          Inc(Run);
          FRange := rsText;
        End;
    End;
  End;
End;

Procedure TSynMDSyn.Next;

Begin
  fTokenPos := Run;
  Case FRange Of
    rsMDLineComment: MDLineCommentProc;
    rsMDItalic:      MDItalicProc;
    rsMDBold:        MDBoldProc;
    rsMDMonospace :  MDMonospaceProc;
  Else
    Case FLine[Run] Of
      #00: NullProc;
      #10: LFProc;
      #13: CRProc;
      '#': MDCommentOpenProc;
      '_': MDItalicOpenProc;
      '*': MDBoldOpenProc;
      '`': MDMonospaceOpenProc;
      #1 .. #9, #11, #12, #14..#32: SpaceProc;
    Else
      If CharInSet(FLine[Run], acSymbols) Then
        SymbolProc
      Else
        TextProc;
    End;
  End;
  Inherited;
End;

Procedure TSynMDSyn.NullProc;

Begin
  If Not (FRange In [rsMDItalic, rsMDBold, rsMDMonospace]) Then
    Begin
      FTokenID := tkText;
      FRange := rsText;
    End;
  Inc(Run);
End;

{$REGION IGNORE}
(**

  This method resets the range to text.

  @precon  None.
  @postcon The range is reset to text.

**)
Procedure TSynMDSyn.ResetRange;

Begin
  FRange := rsText;          
End;

(**

  This is a setter method for the XxxxxxxAttri property.

  @precon  None.
  @postcon The given attribute is set.

  @param   eTokenKind as a TMDTokenKind as a constant
  @param   Attri      as a TSynHighlighterAttributes as a constant

**)
Procedure TSynMDSyn.SetAttri(Const eTokenKind: TMDTokenKind; Const Attri: TSynHighlighterAttributes);

Begin
  FTokenAttri[eTokenKind] := Attri;
End;

(**

  This is a setter method for the Range property.

  @precon  None.
  @postcon Sets the range property.

  @nocheck MissingConstInParam

  @param   Value as a Pointer

**)
Procedure TSynMDSyn.SetRange(Value: Pointer);

Begin
  FRange := TMDRangeState(Value);
End;

(**

  This method processes a space token.

  @precon  None.
  @postcon The run property is incremented and TokenID set to space. If there are more spaces these are
           processed.

**)
Procedure TSynMDSyn.SpaceProc;

Begin
  Inc(Run);
  FTokenID := tkSpace;
  While (FLine[Run] <= #32) And Not IsLineEnd(Run) Do
    Inc(Run);
End;

(**

  This method processes a symbol token.

  @precon  None.
  @postcon The run property is incremented and TokenID set to symbol. If there are more symbosl these are
           processed.

**)
Procedure TSynMDSyn.SymbolProc;

Begin
  Inc(Run);
  FTokenID := tkSymbol;
  While CharInSet(FLine[Run], acSymbols) And Not IsLineEnd(Run) Do
    Inc(Run);
End;

(**

  This method processes a text range.

  @precon  None.
  @postcon The token and range are set to text and the run property incremented.

**)
Procedure TSynMDSyn.TextProc;

Begin
  FTokenID := tkText;
  FRange := rsText;
  Inc(Run);
End;
{$ENDREGION}

(** Registers the highlighter. **)
Initialization
  {$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynMDSyn);
  {$ENDIF}
End.
