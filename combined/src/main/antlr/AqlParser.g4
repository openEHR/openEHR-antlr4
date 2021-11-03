//
//  description:  ANTLR4 parser grammar for Archetype Query Language (AQL)
//  authors:      Sebastian Iancu, Code24, Netherlands
//                Teun van Hemert, Nedap, Netherlands
//                Thomas Beale, Ars Semantica UK, openEHR Foundation Management Board
//  contributors: This version of the grammar is a complete rewrite of previously published antlr3 grammar,
//                based on current AQL specifications in combination with grammars of AQL implementations.
//                The openEHR Foundation would like to recognise the following people for their contributions:
//                  - Chunlan Ma & Heath Frankel, Ocean Health Systems, Australia
//                  - Bostjan Lah, Better, Slovenia
//                  - Christian Chevalley, EHRBase, Germany
//                  - Michael Böckers, Nedap, Netherlands
//  support:      openEHR Specifications PR tracker <https://specifications.openehr.org/releases/QUERY/open_issues>
//  copyright:    Copyright (c) 2021- openEHR Foundation
//  license:      Creative Commons CC-BY-SA <https://creativecommons.org/licenses/by-sa/3.0/>
//

parser grammar AqlParser;

options { tokenVocab=AqlLexer; }

//
// --------------- top-level parts of query --------------
//

selectQuery
    : selectClause fromClause whereClause? orderByClause? limitClause? SYM_DOUBLE_DASH? EOF
    ;

selectClause
    : SYM_SELECT SYM_DISTINCT? top? columnSpec ( ',' columnSpec )*
    ;

fromClause
    : SYM_FROM fromExpr
    ;

whereClause
    : SYM_WHERE whereExpr
    ;

orderByClause
    : SYM_ORDER BY orderByExpr ( ',' orderByExpr )*
    ;

limitClause
    : SYM_LIMIT limit=INTEGER ( SYM_OFFSET offset=INTEGER ) ?
    ;

//
// --------------- sub-parts --------------
//

columnSpec
    : columnValue ( SYM_AS aliasName=IDENTIFIER )?
    ;

columnValue
    : identifiedPath
    | primitiveLiteral
    | aggregateFunctionCall
    | functionCall
    ;

whereExpr
    : identifiedPathExpr
    | SYM_NOT whereExpr
    | whereExpr SYM_AND whereExpr
    | whereExpr SYM_OR whereExpr
    | '(' whereExpr ')'
    ;

orderByExpr
    : identifiedPath order=( SYM_DESCENDING | SYM_DESC | SYM_ASCENDING | SYM_ASC )?
    ;

fromExpr
    : classExprOperand (SYM_NOT? SYM_CONTAINS fromExpr)?
    | fromExpr SYM_AND fromExpr
    | fromExpr SYM_OR fromExpr
    | '(' fromExpr ')'
    ;

//
// Boolean-returning expressions with identifiedPath
// as an operand
//
identifiedPathExpr
    : SYM_EXISTS identifiedPath
    | identifiedPath comparisonOperator terminal
    | functionCall comparisonOperator terminal
    | identifiedPath SYM_LIKE likeOperand
    | identifiedPath SYM_MATCHES matchesOperand
    | '(' identifiedPathExpr ')'
    ;

classExprOperand
    : IDENTIFIER variable=IDENTIFIER? pathPredicate?                              #classExpression
    | SYM_VERSION variable=IDENTIFIER? ('[' versionPredicate ']')?  #versionClassExpr
    ;

terminal
    : primitiveLiteral
    | PARAMETER
    | identifiedPath
    | functionCall
    ;

identifiedPath
    : IDENTIFIER pathPredicate? ('/' objectPath)?
    ;

pathPredicate
    : '[' (standardPredicate | archetypePredicate | nodePredicate) ']'
    ;

standardPredicate
    : objectPath comparisonOperator pathPredicateOperand
    ;

archetypePredicate
    : ARCHETYPE_REF
    | PARAMETER
    ;

nodePredicate
    : idCode (',' (STRING | PARAMETER | AQL_COMPACT_QUALIFIED_TERM_CODE | idCode ))?
    | ARCHETYPE_REF (',' (STRING | PARAMETER | AQL_COMPACT_QUALIFIED_TERM_CODE | idCode ))?
    | PARAMETER
    | objectPath comparisonOperator pathPredicateOperand
    | objectPath SYM_MATCHES CONTAINED_REGEX
    | nodePredicate SYM_AND nodePredicate
    | nodePredicate SYM_OR nodePredicate
    ;

versionPredicate
    : SYM_LATEST_VERSION
    | SYM_ALL_VERSIONS
    | standardPredicate
    ;

pathPredicateOperand
    : primitiveLiteral
    | objectPath
    | PARAMETER
    | idCode
    ;

objectPath
    : pathPart ('/' pathPart)*
    ;

pathPart
    : IDENTIFIER pathPredicate?
    ;

likeOperand
    : STRING
    | PARAMETER
    ;

matchesOperand
    : '{' valueListItem (',' valueListItem)* '}'
    | terminologyFunction
    | '{' AQL_URI '}'
    ;

valueListItem
    : primitiveLiteral
    | PARAMETER
    | terminologyFunction
    ;

//
// --------------------- literal values ------------------
//
primitiveLiteral:
      STRING
    | numericLiteral
    | dateTimeLiteral
    | BOOLEAN
    | SYM_NULL
    ;

numericLiteral:
      INTEGER
    | REAL
    | SCI_INTEGER
    | SCI_REAL
    | SYM_MINUS numericLiteral
    ;

dateTimeLiteral:
      DATE_STRING
    | TIME_STRING
    | DATE_TIME_STRING
    ;

//
// --------------------- function calls ------------------
//
functionCall
    : terminologyFunction
    | name=(stringFunction | numericFunction | dateTimeFunction | IDENTIFIER) '(' (terminal (',' terminal)*)? ')'
    ;

aggregateFunctionCall
    : name=SYM_COUNT '(' (SYM_DISTINCT? identifiedPath | SYM_ASTERISK) ')'
    | name=(SYM_MIN | SYM_MAX | SYM_SUM | SYM_AVG) SYM_LPAREN identifiedPath SYM_RPAREN
    ;

terminologyFunction
    : SYM_TERMINOLOGY '(' STRING ',' STRING ',' STRING ')'
    ;

// built-in functions
stringFunction: SYM_LENGTH | SYM_CONTAINS | SYM_POSITION | SYM_SUBSTRING | SYM_CONCAT_WS | SYM_CONCAT ;
numericFunction: SYM_ABS | SYM_MOD | SYM_CEIL | SYM_FLOOR | SYM_ROUND ;
dateTimeFunction: SYM_NOW | SYM_CURRENT_DATE_TIME | SYM_CURRENT_DATE | SYM_CURRENT_TIMEZONE | SYM_CURRENT_TIME ;

//
// ---------------- basic elements --------------------
//

idCode:
      AT_CODE
    | ADL14_AT_CODE
    | ID_CODE
    ;
    
comparisonOperator: SYM_EQ | SYM_NE | SYM_GT | SYM_GE | SYM_LT | SYM_LE ;

// (deprecated)
top
    : SYM_TOP INTEGER direction=( SYM_FORWARD | SYM_BACKWARD )?
    ;
