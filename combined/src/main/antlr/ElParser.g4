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
import CPrimitiveValuesParser;

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

assignment: variableName SYM_ASSIGNMENT expression ;

assertion: ( ( LC_ID | UC_ID ) ':' )? booleanExpr ;

//
// -------------------------- Expressions --------------------------
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
    | booleanLeaf equalityBinop booleanLeaf
    | booleanLeaf
    ;

//
// Atomic Boolean-valued expression elements
// TODO: SYM_EXISTS alternative to be replaced by defined() predicate
booleanLeaf:
      booleanLiteral
    | forAllExpr
    | thereExistsExpr
    | '(' booleanExpr ')'
    | relationalExpr
    | equalityExpr
    | constraintExpr
    | SYM_DEFINED '(' valueRef ')'
    | valueRef
    ;

booleanLiteral:
      SYM_TRUE
    | SYM_FALSE
    ;

//
//  Universal and existential quantifier
// TODO: 'in' probably isn't needed in the long term
forAllExpr: SYM_FOR_ALL VARIABLE_ID ':' valueRef '|'? booleanExpr ;

thereExistsExpr: SYM_THERE_EXISTS VARIABLE_ID ':' valueRef '|'? booleanExpr ;

// Constraint expressions
// This provides a way of using one operator (matches) to compare a
// value (LHS) with a value range (RHS). As per ADL, the value range
// for ordered types like Integer, Date etc may be a single value,
// a list of values, or a list of intervals, and in future, potentially
// other comparators, including functions (e.g. divisible_by_N).
//
// For non-ordered types like String and Terminology_code, the RHS
// is in other forms, e.g. regex for Strings.
//
// The matches operator can be used to generate a Boolean value that
// may be used within an expression like any other Boolean (hence it
// is a booleanLeaf).
// TODO: non-primitive objects might be supported on the RHS in future.
constraintExpr: ( arithmeticExpr | valueRef ) SYM_MATCHES '{' cInlinePrimitiveObject '}' ;

//
// Expressions evaluating to arithmetic values, using standard precedence
//
arithmeticExpr:
      <assoc=right> arithmeticExpr '^' arithmeticExpr
    | arithmeticExpr ( '/' | '*' | '%' ) arithmeticExpr
    | arithmeticExpr ( '+' | '-' ) arithmeticExpr
    | arithmeticLeaf
    ;

arithmeticLeaf:
      arithmeticLiteral
    | valueRef
    | '(' arithmeticExpr ')'
    ;

arithmeticLiteral:
      integerValue
    | realValue
    | dateValue
    | dateTimeValue
    | timeValue
    | durationValue
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
// Relational expressions of arithmetic operands generating Boolean values
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
// TODO: Remove rawPath from this rule when external binding supported
//
valueRef:
      functionCall
    | variableName
    | constantName
    ;

variableName: VARIABLE_ID ;

constantName: UC_ID ;

functionCall: LC_ID '(' functionArgs? ')' ;

functionArgs: expression ( ',' expression )* ;

typeId: UC_ID ( '<' typeId ( ',' typeId )* '>' )? ;
