//
//  description: Antlr4 grammar for openEHR Expression Language baed on BMM meta-model.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

parser grammar ElParser;
options { tokenVocab=ElLexer; }
import Cadl2Parser;


// ========================== Type names ==========================

typeId: simpleTypeId | genericTypeId ;

simpleTypeId: simpleTypeName typeValueConstraint? ;
simpleTypeName: UC_ID ;
typeValueConstraint: SYM_LEFT_GUILLEMET namespaceId SYM_RIGHT_GUILLEMET ;

// a namespace id has at least one '.'
namespaceId: namespaceSegmentId ( '.' namespaceSegmentId )+ ;
namespaceSegmentId: LC_ID | UC_ID | WEB_ID ;

genericTypeId: simpleTypeName '<' typeId ( ',' typeId )* '>' ;

// ========================== EL Expressions ==========================

//
// Stratified expression grammar
//
// Note on spurious "FULL AMBIGUITY" warnings: parsing real .bmml sources through this grammar
// reports numerous ANTLR FULL AMBIGUITY warnings (always exact: false), centred on the
// loop-continue-vs-exit decision of the `( op operand )*` repetitions below - most visibly
// elExprAnd's and elExprEquality's. These are confirmed benign, not a grammar defect:
//
// - elExpression (and everything under it) is reached from dozens of unrelated call sites
//   across the combined Bmml+Cadl2+El grammar (bmmConstantDecl, bmmPropertyDecl,
//   bmmVariableDecl, bmmAssignment, dlConditionBranch, elArgsList, bmmClassAssertion,
//   elExprForAll/ThereExists bodies, etc.), each with a different follow context. When ANTLR
//   escalates one of these loop-exit decisions to full-context (LL) analysis, its default
//   (non-exact) mode deliberately stops looking as soon as it can guarantee the correct
//   prediction, without proving there is no ambiguity for some other, unreached follow
//   context - hence exact is always false here. See ParserATNSimulator's own comment on this
//   trade-off ("we just can't say for sure there is an ambiguity without looking further").
// - ANTLR always resolves a reported ambiguity by picking the lowest-numbered alternative,
//   and for a `(...)* ` loop that is always "take another iteration" (the greedy, intended
//   reading) - never "exit early".
// - Verified directly: dumping the parse tree for inputs like `r.source = self` and
//   `a = b and c = d` (both of which trigger this warning) shows the operators are built
//   correctly regardless - e.g. `elExprEquality(elExprComparison(r.source), =,
//   elExprComparison(self))` - not truncated or misparsed.
//
// Net effect: noisy but harmless. Eliminating the warning would require restructuring away
// from a widely shared elExpression subtree (e.g. back to native left-recursion, which is
// what an earlier grammar iteration used to dodge a *different*, genuine ambiguity - see git
// history) - not something to take on just to silence a cosmetic warning.
//
elExpression:
      elExprTernary
    | elTuple
    ;

elExprTernary: elExprImplies ( '?' elSimpleTerminal ':' elSimpleTerminal )? ;

elExprImplies: elExprOr ( SYM_IMPLIES elExprOr )* ;

elExprOr: elExprAnd ( elOrBinop elExprAnd )* ;

elExprAnd: elExprEquality ( SYM_AND elExprEquality )* ;

elExprEquality: elExprComparison ( elEqualityBinop elExprComparison )* ;

elExprComparison: elExprAddSub ( elComparisonBinop elExprAddSub )* ;

elExprAddSub: elExprMultDiv ( elAddSubBinop elExprMultDiv )* ;

elExprMultDiv: elExprExp ( elMultDivBinop elExprExp )* ;

// Uses RHS recursion to achieve right-associativity
elExprExp: elExprNot ( '^' elExprExp )? ;

elExprNot: SYM_NOT? elExprPostfixUnary ;

//
// Placeholder, if/when postfix markers needed
//
elExprPostfixUnary: elExprTerminal ;

elExprTerminal:
      elExprVoidComparison
    | elExprParen
    | elAtom
    | elExprMatches
    | elExprForAll
    | elExprThereExists
    | dlDecisionTable
    ;

elExprParen: '(' elExpression ')' ;

elExprMatches: elValueGenerator SYM_MATCHES '{' primitiveObjectMatcher '}' ;

elExprForAll: SYM_FOR_ALL elVariableId ':' elValueGenerator '¦' elExpression ;

elExprThereExists: SYM_THERE_EXISTS elVariableId ':' elValueGenerator '¦' elExpression ;

//
// Equivalent of aaa != Void, or similar. We use instead the form ∃aaa
//
elExprVoidComparison: SYM_THERE_EXISTS elValueGenerator ;

//
// --------- Various operators ----------
//

elOrBinop:
      SYM_OR
    | SYM_XOR
    ;

elEqualityBinop:
      SYM_EQ
    | SYM_NE
    ;

elComparisonBinop:
      SYM_GT
    | SYM_LT
    | SYM_LE
    | SYM_GE
    ;

elAddSubBinop:
      '+'
    | '-'
    ;

elMultDivBinop:
      '/'
    | '*'
    | '%'
    ;

//
// ----------- Semantic and structural atoms -------------
//
elAtom:
      booleanValue
    | elArithmeticValue
    | stringValue
    | characterValue
    | termCodeValue
    | primitiveStructure
    | elValueGenerator
    ;

elArithmeticValue:
      integerValue
    | realValue
    | dateValue
    | dateTimeValue
    | timeValue
    | durationValue
    ;



//
// -------------------------- tuples -----------------------------
//

elTuple: '[' elExpression ( ',' elExpression )+ ']';

//
// -------------------------- value-generating expressions -----------------------------
//

//
// A narrower terminal, used where only a leaf value (no operators) is syntactically valid,
// e.g. decision-table branches and ternary results.
//
elSimpleTerminal:
      booleanValue
    | elArithmeticValue
    | stringValue
    | termCodeValue
    | primitiveStructure
    | elValueGenerator
    ;

//
// TODO: Can't syntactically distinguish between a local variable
//       and a property or constant reference.
//
elValueGenerator:
      SYM_SELF
    | elBareRef
    | elScopedFeatureRef
    ;

//
// An unscoped reference of some kind
// Will map to EL_WRITABLE_VARIABLE or EL_PROPERTY_REF (unscoped)
//
elBareRef:
      elInstantiableRef
    | elFunctionCall
    | elConstantId
    ;

//
// Instantiable feature refs; may be the target of an assignment
//
elInstantiableRef:
      SYM_RESULT
    | elBoundVariableId
    | elVariableId
    ;


//
// Scoped feature references. Has to have at least one scoping element, either a
// class name and then any number of bareRefs. Will map to any ElValueGenerator (scoped)
//
elScopedFeatureRef: elScoper elBareRef ;

elScoper: ( typeId '.' )?  ( elBareRef '.' )+ ;

//
// A variable bound to a data source, lexical form '$xxxx'
// TODO: analyse how a boundVariableId can be created as a built-in feature
//
elBoundVariableId: BOUND_VARIABLE_ID ;

//
// A 'variable' reference could be to a property; parameter; local variable. The parser cannot know
// which one, it depends on the context e.g. being in an invariant or being in a routine pre-condition
// or statement.
//
elVariableId: elLcId ;

elConstantId: UC_ID ;

//
// Function calls: Build a BmmFunctionCall object
//
elFunctionCall: elLcId '(' elArgsList? ')' ;

elArgsList: elExpression ( ',' elExpression )* ;

//
// -------------------------- decision tables -----------------------------
//

// Ugly, but we need to allow certain keywords as routine names; the following
// is a hard-wired list of names that will have been matched as keyowods, rather than
// LC_ID
elLcId:
          LC_ID
        | SYM_FOR_ALL
        | SYM_THERE_EXISTS
        | SYM_MATCHES
        | SYM_ASSERT
        | SYM_CARDINALITY
        | SYM_EXISTENCE
        | SYM_OCCURRENCES
        ;

//
// The ternary form (dlBinaryChoice / 'cond ? a : b') is not part of this rule - see the note
// on elAtom above; it is inlined directly into elExpr as #elExprTernary.
//
dlDecisionTable:
      dlCaseTable
    | dlConditionTable
    ;

dlCaseTable:
      dlSimpleCaseTable
    | dlGeneralCaseTable
    ;

//
// condition chains (if/then statement equivalent)
// when
//   =========================================================
//   er_positive and
//   her2_negative and
//   not ki67.in_range (#high) ->  #luminal_A,
//   ---------------------------------------------------------
//   er_positive and
//   her2_negative and
//   ki67.in_range (#high)     ->  #luminal_B_HER2_negative,
//   ---------------------------------------------------------
//   *                         ->  #none
//   =========================================================
//
dlConditionTable: SYM_WHEN BLOCK_DELIM ( dlConditionBranch ',' )+ ( dlConditionBranch | dlConditionDefaultBranch ) BLOCK_DELIM ;

dlConditionBranch: elExpression SYM_ARROW elExpression ;

dlConditionDefaultBranch: SYM_ASTERISK SYM_ARROW elExpression ;

//
// Case tables, e.g.:
//     Result := case qCSI_score in
//        ============================
//        0:          expr0,
//        ----------------------------
//        |1..2|:     expr1,
//        ----------------------------
//        |3..5|:     expr2,
//        ----------------------------
//        |6..8|:     expr3,
//        ----------------------------
//        |≥ 9|:      expr4
//        ============================
//     ;
//
dlGeneralCaseTable: SYM_CASE elExpression SYM_IN BLOCK_DELIM ( dlGeneralCaseBranch ',' )+ ( dlGeneralCaseBranch | dlGeneralCaseDefaultBranch ) BLOCK_DELIM ;

dlGeneralCaseBranch: primitiveObject ':' elExpression ;

dlGeneralCaseDefaultBranch: SYM_ASTERISK ':' elExpression ;

//
// Simple value-based (typed) Case tables, e.g.:
// case gfr_range in
//   =================
//   |>20|:      1,
//   |10..20|:   0.75,
//   |<10|:      0.5
//   =================
//   ;
//
dlSimpleCaseTable: SYM_CASE elSimpleTerminal SYM_IN BLOCK_DELIM ( dlSimpleCaseBranch ',' )+ ( dlSimpleCaseBranch | dlSimpleCaseDefaultBranch ) BLOCK_DELIM ;

dlSimpleCaseBranch: primitiveObject ':' elSimpleTerminal ;

dlSimpleCaseDefaultBranch: SYM_ASTERISK ':' elSimpleTerminal ;
