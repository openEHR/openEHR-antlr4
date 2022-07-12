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



// ========================== EL Statements ==========================

statementBlock: statement+ EOF ;

statement: declaration | assignment | assertion ;

declaration:
      variableDeclaration
    | constantDeclaration
    ;

variableDeclaration: instantiableRef ':' typeId ( SYM_ASSIGNMENT expression )? ;

constantDeclaration: constantId ':' typeId ( SYM_EQ expression )? ;

assignment: valueGenerator SYM_ASSIGNMENT expression ;

assertion: ( ( LC_ID | UC_ID ) ':' )? SYM_ASSERT booleanExpr ;

// ========================== EL Expressions ==========================

//
// Expressions are either value-generators, or operator expressions (containing value-generators)
//
expression:
      terminal
    | operatorExpression
    | tuple
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
    | arithmeticConstraintExpr
    | generalConstraintExpr
    | '(' booleanExpr ')'
    | SYM_DEFINED '(' valueGenerator ')'
    | arithmeticComparisonExpr
    | objectComparisonExpr
    | valueGenerator
    ;

//
//  Universal and existential quantifier
//
forAllExpr: SYM_FOR_ALL localVariableId ':' valueGenerator '|' booleanExpr ;

thereExistsExpr: SYM_THERE_EXISTS localVariableId ':' valueGenerator '|' booleanExpr ;

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
arithmeticConstraintExpr: arithmeticLeaf SYM_MATCHES '{' cInlineOrderedObject '}' ;

generalConstraintExpr: simpleTerminal SYM_MATCHES '{' cObjectMatcher '}' ;

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

// TODO: need to be able to plug in terminal to allow decision tables in expressions
arithmeticLeaf:
      arithmeticValue
    | '(' arithmeticExpr ')'
    | valueGenerator
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
objectComparisonExpr: simpleTerminal equalityBinop simpleTerminal ;

equalityBinop:
    SYM_EQ
  | SYM_NE
  ;

//
// -------------------------- tuples -----------------------------
//

tuple: '[' expression ( ',' expression )+ ']';

//
// -------------------------- value-generating expressions -----------------------------
//

terminal:
      simpleTerminal
    | decisionTable
    ;

simpleTerminal:
      primitiveObject
    | valueGenerator
    ;

//
// TODO: Can't syntactically distinguish between a local or other variable id
// and a property or constant reference.
//
valueGenerator:
      bareRef
    | scopedFeatureRef
    | typeRef
    ;

bareRef:
      boundVariableId
    | staticRef
    | localRef
    | functionCall
    ;

//
// Static and constant feature refs, distinguished by the use of
// initial capital in the id.
// Will map to EL_READABLE_VARIABLE or EL_STATIC_REF (unscoped)
//
staticRef:
      SYM_SELF
    | constantId
    ;

//
// Local writable reference, distinguished by use of initial lowercase id
// Will map to EL_WRITABLE_VARIABLE or EL_PROPERTY_REF (unscoped)
//
localRef:
      SYM_RESULT
    | localVariableId
    ;

//
// scoped feature references.
// Will map to any EL_FEATURE_REF (scoped)
//
scopedFeatureRef: scoper featureRef ;

scoper: ( typeRef '.' )? ( bareRef '.' )* ;

typeRef: '{' typeId '}' ;

typeId: UC_ID ( '<' typeId ( ',' typeId )* '>' )? ;

featureRef:
      functionCall
    | instantiableRef
    ;

//
// Instantiable feature refs
//
instantiableRef:
      boundVariableId
    | localVariableId
    | constantId
    ;

//
// TODO: analyse how a boundVariableId can be created as a built-in feature
//
boundVariableId: BOUND_VARIABLE_ID ;

localVariableId: LC_ID ;

constantId: UC_ID ;

//
// Function calls
//
functionCall: LC_ID '(' exprList? ')' ';'? ;

exprList: expression ( ',' expression )* ;

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
binaryChoice:  booleanExpr '?' simpleTerminal ':' simpleTerminal ;

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
simpleCaseTable: SYM_CASE simpleTerminal SYM_IN ( simpleCaseBranch ',' )+ ( simpleCaseBranch | simpleCaseDefaultBranch ) ';' ;

simpleCaseBranch: primitiveObject ':' simpleTerminal ;

simpleCaseDefaultBranch: '*' ':' simpleTerminal ;
