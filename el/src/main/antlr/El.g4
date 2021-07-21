//
//  description: Antlr4 grammar for openEHR Rules core syntax.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar El;
import PrimitiveValues, ElLexer;

//
// Statements: currently, assignment or assertion
// TODO: the direct assignment of symbol to path ('mappedDataRef')
// is ambiguous; to be reviewed in next version
//

statement: assignment | assertion;

assignment: 
      VARIABLE_ID ':' ALPHA_UC_ID SYM_ASSIGNMENT mappedDataRef
    | VARIABLE_ID ( ':' ALPHA_UC_ID )? SYM_ASSIGNMENT expression 
    ;

assertion: ( identifier ':' )? booleanExpr 
    ;


//
// General expressions
//

expression:
      simpleExpression
    | forAllExpr
    | thereExistsExpr
    ;
    
simpleExpression:
      booleanExpr
    | arithmeticExpr
    ;
    
// Universal and existential quantifier

forAllExpr:
      SYM_FOR_ALL VARIABLE_ID ':' valueRef '|'? booleanExpr
    ;

thereExistsExpr:
      SYM_THERE_EXISTS VARIABLE_ID ':' valueRef '|'? booleanExpr
    ;

//
// Expressions evaluating to boolean values
//

booleanExpr:
      booleanExpr SYM_AND booleanLeaf
    | booleanExpr SYM_XOR booleanLeaf
    | booleanExpr SYM_OR booleanLeaf
    | booleanExpr SYM_IMPLIES booleanLeaf
    | booleanLeaf
    ;

// basic boolean expression elements

booleanLeaf:
      booleanLiteral
    | instanceRef
    | '(' booleanExpr ')'
    | relationalExpr
    | comparisonExpr
    | constraintExpr
    | SYM_EXISTS mappedDataRef
    | SYM_NOT booleanLeaf
    ;

constraintExpr: 
      mappedDataRef SYM_MATCHES '{' cPrimitiveObject '}' 
    ;

booleanLiteral:
      SYM_TRUE
    | SYM_FALSE
    ;
    
//
// Comparison expression between any operand
//

comparisonExpr: 
      simpleExpression equalityBinop simpleExpression
    ;

//
// Relational expressions of arithmetic operands
//

relationalExpr: 
      arithmeticExpr relationalBinop arithmeticExpr
    ;

equalityBinop:
      SYM_EQ
    | SYM_NE
    ;
    
relationalBinop:
      equalityBinop
    | SYM_GT
    | SYM_LT
    | SYM_LE
    | SYM_GE
    ;

//
// Expressions evaluating to arithmetic values
//

arithmeticExpr: 
      <assoc=right> arithmeticExpr '^' arithmeticLeaf
    | arithmeticExpr multOp arithmeticLeaf
    | arithmeticExpr addOp arithmeticLeaf
    | arithmeticLeaf
    ;

arithmeticLeaf:
      integerValue
    | realValue
    | instanceRef   
    | '(' arithmeticExpr ')'
    ;

multOp:
      '/'
    | '*'
    ;

addOp:
      '+'
    | '-'
    ;

//
// instances references: data references, variables, and function calls.
// TODO: Currently treat ADL paths as 'mapped' data references;
// which is ambiguous, since an ADL path may match multiple runtime objects
//

instanceRef:
      valueRef
    | functionCall
    ;

valueRef:
      mappedDataRef
    | variableId
    ;

mappedDataRef: ADL_PATH ;

variableId: ALPHA_LC_ID ;

identifier: ALPHA_LC_ID | ALPHA_UC_ID ;

functionCall: ALPHA_LC_ID '(' ( expression (',' expression)* )? ')' ;


	
    
