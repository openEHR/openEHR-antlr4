//
//  description: Antlr4 grammar for openEHR Basic Expression Language specified at
//               https://specifications.openehr.org/releases/LANG/latest/basic_expression_language.html
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

parser grammar BelParser;
options { tokenVocab=BelLexer; }
import Cadl2PrimitiveConstraintsParser, AdlPathParser;

//
//  ======================= Top-level Objects ========================
//

statementBlock: statement+ EOF ;

// ------------------------- statements ---------------------------
statement: declaration | assignment | assertion;

declaration:
      variableDeclaration
    | constantDeclaration
    ;

variableDeclaration: variableName ':' typeId ( SYM_ASSIGNMENT expression )? ;

constantDeclaration: constantName ':' typeId  ( SYM_EQ primitiveObject )? ;

assignment:
      binding
    | localAssignment
    ;

//
// The following is the means of binding a data context path to a local variable
// TODO: remove this rule when proper external bindings are supported
binding: variableName SYM_ASSIGNMENT rawPath ;

localAssignment: variableName SYM_ASSIGNMENT expression ;

assertion: ( ( LC_ID | UC_ID ) ':' )? expression ;

// ========================== EL Expressions ==========================

//
// Expressions are either value-generators, or operator expressions (containing value-generators)
//
expression:
      elExpr
    ;

// ------------------- Boolean-returning operator expressions --------------------

//
// Expressions evaluating to boolean values, using standard precedence
// The equalityBinop ones are not strictly necessary, but allow the use
// of booleanLeaf = true, which some people like
//
elExpr:
      <assoc=right> elExpr '^' elExpr                                  #elExprExp
    | elExpr ( '/' | SYM_ASTERISK | '%' ) elExpr                        #elExprMultDiv
    | elExpr ( '+' | '-' ) elExpr                                        #elExprAddSub
    | elExpr SYM_MATCHES '{' cInlinePrimitiveObject '}'                   #elExprMatches
    | elExpr elComparisonBinop elExpr                                      #elExprCompare
    | SYM_NOT elExpr                                                        #elExprNot
    | elExpr SYM_AND elExpr                                                  #elExprAnd
    | elExpr SYM_XOR elExpr                                                   #elExprXor
    | elExpr SYM_OR elExpr                                                     #elExprOr
    | elExpr SYM_IMPLIES elExpr                                                 #elExprImplies
    | SYM_FOR_ALL VARIABLE_ID ':' valueRef '|' elExpr                           #elExprForAll
    | SYM_THERE_EXISTS VARIABLE_ID ':' valueRef '|' elExpr                       #elExprThereExists
    | elExpr '?' elSimpleTerminal ':' elSimpleTerminal                             #elExprTernary
    | elAtom                                                                        #elExprAtom
    ;

//
// The usual binary comparison operators.
//
elComparisonBinop:
      SYM_EQ
    | SYM_NE
    | SYM_GT
    | SYM_LT
    | SYM_LE
    | SYM_GE
    ;

//
// Atomic Boolean-valued expression elements
// TODO: SYM_EXISTS alternative to be replaced by defined() predicate
elAtom:
      booleanValue
    | arithmeticValue
    | stringValue
    | characterValue
    | termCodeValue
    | SYM_EXISTS ( rawPath | variableSubPath )
    | '(' elExpr ')'
    | valueRef
    ;

arithmeticValue:
      integerValue
    | realValue
    | dateValue
    | dateTimeValue
    | timeValue
    | durationValue
    ;

//
// A narrower terminal, used where only a leaf value (no operators) is syntactically valid,
// e.g. decision-table branches and ternary results.
//
elSimpleTerminal:
      booleanValue
    | arithmeticValue
    | stringValue
    | termCodeValue
    | valueRef
    ;

//
// instances references: data references, variables, and function calls.
// TODO: Remove rawPath from this rule when external binding supported
//
valueRef:
      functionCall
    | rawPath
    | variableSubPath
    | variableName
    | constantName
    ;

variableName: VARIABLE_ID ;

// TODO: change to [] form, e.g.     book_list [{title.contains("Quixote")}]
variableSubPath: VARIABLE_ID adlPath;

// TODO: Remove this rule when external binding supported
rawPath: adlPath ;

constantName: UC_ID ;

functionCall: LC_ID '(' exprList? ')' ;

exprList: expression ( ',' expression )* ;

typeId: UC_ID ( '<' typeId ( ',' typeId )* '>' )? ;
