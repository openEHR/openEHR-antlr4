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
import Cadl2PrimitiveValuesParser;



// ========================== EL Statements ==========================

statementBlock: statement+ EOF ;

statement: declaration | assignment | assertion ;

declaration:
      variableDeclaration
    | constantDeclaration
    ;

variableDeclaration: scopableVariableRef ':' typeId ( SYM_ASSIGNMENT expression )? ;

constantDeclaration: constantRef ':' typeId ( SYM_EQ primitiveObject )? ;

assignment: variableRef SYM_ASSIGNMENT expression ;

assertion: ( ( LC_ID | UC_ID ) ':' )? SYM_ASSERT booleanExpr ;

// ========================== EL Expressions ==========================

//
// Expressions are either value-generators, or operator expressions (containing value-generators)
//
expression:
      valueGenerator
    | operatorExpression
    ;

operatorExpression:
      booleanExpr
    | arithmeticExpr
    ;

// ------------------- Boolean-returning operator expressions --------------------

//
// Expressions evaluating to boolean values, using standard precedence;
// These map to ordinary 1- and 2-argument function calls on Boolean instances
//
booleanExpr:
      SYM_NOT booleanExpr
    | booleanExpr SYM_AND booleanExpr
    | booleanExpr SYM_XOR booleanExpr
    | booleanExpr SYM_OR booleanExpr
    | booleanExpr SYM_IMPLIES booleanExpr
    | booleanExpr ( SYM_IFF | SYM_EQ ) booleanExpr
    | booleanLeaf
    ;

//
// Atomic Boolean-valued expression elements
//
booleanLeaf:
      booleanValue
    | forAllExpr
    | thereExistsExpr
    | '(' booleanExpr ')'
    | constraintExpr
    | SYM_DEFINED '(' valueRef ')'
    | arithmeticComparisonExpr
    | objectComparisonExpr
    | valueRef
    ;

//
//  Universal and existential quantifier
//
forAllExpr: SYM_FOR_ALL localVariableId ':' valueRef '|' booleanExpr ;

thereExistsExpr: SYM_THERE_EXISTS localVariableId ':' valueRef '|' booleanExpr ;

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
constraintExpr: arithmeticExpr SYM_MATCHES '{' cInlinePrimitiveObject '}' ;


// --------------------------- Arithmetic operator expressions --------------------------

//
// Comparison expressions of arithmetic operands generating Boolean results
//
arithmeticComparisonExpr: arithmeticExpr comparisonBinop arithmeticExpr ;

comparisonBinop:
      SYM_EQ
    | SYM_NE
    | SYM_GT
    | SYM_LT
    | SYM_LE
    | SYM_GE
    ;

//
// Expressions evaluating to values of arithmetic types, using standard precedence
//
arithmeticExpr:
      <assoc=right> arithmeticExpr '^' arithmeticExpr
    | arithmeticExpr ( '/' | '*' | '%' ) arithmeticExpr
    | arithmeticExpr ( '+' | '-' ) arithmeticExpr
    | arithmeticLeaf
    ;

// TODO: need to be able to plug in valueGenerator to allow decision tables in expressions
arithmeticLeaf:
      arithmeticValue
    | '(' arithmeticExpr ')'
    | valueRef
    | simpleCaseTable
    ;

arithmeticValue:
      integerValue
    | realValue
    | dateValue
    | dateTimeValue
    | timeValue
    | durationValue
    ;

// -------------------- Equality operator expressions for other types ------------------------

//
// Compare any kind of objects
//
objectComparisonExpr: valueTerminal equalityBinop valueTerminal ;

equalityBinop:
    SYM_EQ
  | SYM_NE
  ;

//
// -------------------------- value-generating expressions -----------------------------
//

valueGenerator:
      valueTerminal
    | decisionTable
    ;

valueTerminal:
      primitiveValue
    | valueRef
    ;

valueRef:
      scopedFeatureRef
    | featureRef
    | SYM_SELF
    | tuple
    ;

tuple: '[' expression ( ',' expression )+ ']';

//
// scoped and local feature references
//

scopedFeatureRef: 
      scopedFunctionCall
    | scopedPropertyRef
    | scopedConstantRef
    ;

scopedFunctionCall: scoper functionCall ;

scopedPropertyRef: scoper scopableVariableRef ;

scopedConstantRef: scoper constantRef ;

scoper: ( typeRef '.' )? ( featureRef '.' )* ;

typeRef: '{' typeId '}' ;

featureRef:
      functionCall
    | variableRef
    | constantRef
    ;

variableRef:
      scopableVariableRef
    | SYM_RESULT
    ;

scopableVariableRef:
      boundVariableId
    | localVariableId
    ;

boundVariableId: BOUND_VARIABLE_ID ;

localVariableId: LC_ID ;

constantRef: UC_ID ;

functionCall: LC_ID '(' exprList? ')' ';'? ;

exprList: expression ( ',' expression )* ;

typeId: UC_ID ( '<' typeId ( ',' typeId )* '>' )? ;

//
// -------------------------- decision tables -----------------------------
//

decisionTable:
      binaryChoice
    | caseTable
    | conditionTable
    ;

caseTable:
    | simpleCaseTable
    | generalCaseTable
    ;

//
// condition chains (if/then statement equivalent)
// choice in
//   =========================================================
//   er_positive and
//   her2_negative and
//   not ki67.in_range (#high):    #luminal_A,
//   ---------------------------------------------------------
//   er_positive and
//   her2_negative and
//   ki67.in_range (#high):        #luminal_B_HER2_negative,
//   ---------------------------------------------------------
//   *:                            #none
//   =========================================================
//   ;
//
conditionTable: SYM_CHOICE SYM_IN ( conditionBranch ',' )+ ( conditionBranch | conditionDefaultBranch ) ';' ;

conditionBranch: booleanExpr ':' expression ;

conditionDefaultBranch: '*' ':' expression ;

//
// Binary-choice version of condition table, using old-school
// C/Java syntax:
// booleanExpr ? x : y ;
//
binaryChoice:  booleanExpr '?' valueTerminal ':' valueTerminal ;

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
generalCaseTable: SYM_CASE expression SYM_IN ( generalCaseBranch ',' )+ ( generalCaseBranch | generalCaseDefaultBranch ) ';' ;

generalCaseBranch: primitiveObject ':' expression ;

generalCaseDefaultBranch: '*' ':' expression ;

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
simpleCaseTable: SYM_CASE valueTerminal SYM_IN ( simpleCaseBranch ',' )+ ( simpleCaseBranch | simpleCaseDefaultBranch ) ';' ;

simpleCaseBranch: primitiveObject ':' valueTerminal ;

simpleCaseDefaultBranch: '*' ':' valueTerminal ;
