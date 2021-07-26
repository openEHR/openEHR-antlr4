//
//  description: Antlr4 grammar for openEHR Rules core syntax.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar El;
import PathLexer, Cadl;

elText: statement+ ;

statement: variableDeclaration | assignment | assertion;

variableDeclaration: VARIABLE_ID ':' typeId ( SYM_ASSIGNMENT expression )? ;

assignment: VARIABLE_ID SYM_ASSIGNMENT expression ;

assertion: ( ( ALPHA_LC_ID | ALPHA_UC_ID ) ':' )? booleanExpr ;

//
// Expressions
//
expression:
      booleanExpr
    | arithmeticExpr
    ;

//
// Expressions evaluating to boolean values, using standard precedence
// The equalityBinop ones are not strictly necessary, but allow the use
// of booleanLeaf = true, which some people like
//
booleanExpr:
      SYM_NOT booleanExpr
    | booleanExpr SYM_AND booleanExpr
    | booleanExpr SYM_XOR booleanExpr
    | booleanExpr SYM_OR booleanExpr
    | booleanExpr SYM_IMPLIES booleanExpr
    | booleanLeaf equalityBinop booleanLiteral
    | booleanLeaf
    ;

//
// Atomic boolean expression elements
//
booleanLeaf:
      booleanLiteral
    | instanceRef
    | forAllExpr
    | thereExistsExpr
    | '(' booleanExpr ')'
    | relationalExpr
    | equalityExpr
    | constraintExpr
    | SYM_EXISTS mappedDataRef
    ;

// Universal and existential quantifier
// TODO: 'in' probably isn't needed in the long term
forAllExpr: SYM_FOR_ALL VARIABLE_ID ( ':' | 'in' ) valueRef '|'? booleanExpr ;

thereExistsExpr: SYM_THERE_EXISTS VARIABLE_ID ( ':' | 'in' ) valueRef '|'? booleanExpr ;

// Constraint expressions
constraintExpr:
      instanceRef SYM_MATCHES '{' cInlinePrimitiveObject '}'
    ;

booleanLiteral:
      SYM_TRUE
    | SYM_FALSE
    ;

//
// Expressions evaluating to arithmetic values, using standard precedence
//
arithmeticExpr:
      <assoc=right> arithmeticExpr '^' arithmeticLeaf
    | arithmeticExpr ( '/' | '*' ) arithmeticLeaf
    | arithmeticExpr ( '+' | '-' ) arithmeticLeaf
    | arithmeticLeaf
    ;

arithmeticLeaf:
      integerValue
    | realValue
    | instanceRef
    | '(' arithmeticExpr ')'
    ;

//
// Equality expression between any arithmetic value; precedence is
// lowest, so only needed between leaves, since () will be needed for
// larger expressions anyway
//
equalityExpr: arithmeticExpr equalityBinop arithmeticExpr ;

equalityBinop:
      SYM_EQ
    | SYM_NE
    ;

//
// Relational expressions of arithmetic operands
//
relationalExpr: arithmeticExpr relationalBinop arithmeticExpr ;

relationalBinop:
      SYM_GT
    | SYM_LT
    | SYM_LE
    | SYM_GE
    ;

//
// instances references: data references, variables, and function calls.
// TODO: Currently treat ADL paths as 'mapped' data references;
// which is ambiguous, since an ADL path may match multiple runtime objects
//
instanceRef:
      functionCall
    | valueRef
    ;

valueRef:
      mappedDataRef
    | VARIABLE_ID
    ;

mappedDataRef: ADL_PATH ;

functionCall: ALPHA_LC_ID '(' ( expression ( ',' expression )* )? ')' ;

typeId: ALPHA_UC_ID ( '<' typeId ( ',' typeId )* '>' )? ;


//
// ---------- Lexer definitions ----------
//

// ---------- lines and comments ----------
CMT_LINE   : '--' .*? EOL -> skip ;             // increment line count
EOL        : '\r'? '\n'   -> channel(HIDDEN) ;  // increment line count
WS         : [ \t\r]+     -> channel(HIDDEN) ;

// --------- symbols ----------
SYM_ASSIGNMENT: ':=' | '::=' ;

SYM_NE : '/=' | '!=' | '≠' ;
SYM_EQ : '=' ;

SYM_THEN     : [Tt][Hh][Ee][Nn] ;
SYM_AND      : [Aa][Nn][Dd] | '∧' ;
SYM_OR       : [Oo][Rr] | '∨' ;
SYM_XOR      : [Xx][Oo][Rr] ;
SYM_NOT      : [Nn][Oo][Tt] | '!' | '~' | '¬' ;
SYM_IMPLIES  : [Ii][Mm][Pp][Ll][Ii][Ee][Ss] | '⇒' ;
SYM_FOR_ALL  : 'for_all' | '∀' ;
SYM_THERE_EXISTS: 'there_exists' | '∃' ;
SYM_EXISTS   : 'exists' ;
SYM_MATCHES  : [Mm][Aa][Tt][Cc][Hh][Ee][Ss] | [Ii][Ss]'_'[Ii][Nn] | '∈' ;

VARIABLE_ID: '$' ALPHA_LC_ID;
