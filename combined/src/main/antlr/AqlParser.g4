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

selectQuery
    : selectClause fromClause whereClause? orderByClause? limitClause? SYM_DOUBLE_DASH? EOF
    ;

selectClause
    : SELECT DISTINCT? top? selectExpr (SYM_COMMA selectExpr)*
    ;

fromClause
    : FROM fromExpr
    ;

whereClause
    : WHERE whereExpr
    ;

orderByClause
    : ORDER BY orderByExpr (SYM_COMMA orderByExpr)*
    ;

limitClause
    : LIMIT limit=INTEGER (OFFSET offset=INTEGER) ?
    ;

selectExpr
    : columnExpr (AS aliasName=IDENTIFIER)?
    ;

fromExpr
    : containsExpr
    ;

whereExpr
    : identifiedExpr
    | NOT whereExpr
    | whereExpr AND whereExpr
    | whereExpr OR whereExpr
    | SYM_LPAREN whereExpr SYM_RPAREN
    ;

orderByExpr
    : identifiedPath order=( DESCENDING | DESC | ASCENDING | ASC )?
    ;

columnExpr
    : identifiedPath
    | primitive
    | aggregateFunctionCall
    | functionCall
    ;

containsExpr
    : classExprOperand (NOT? CONTAINS containsExpr)?
    | containsExpr AND containsExpr
    | containsExpr OR containsExpr
    | SYM_LPAREN containsExpr SYM_RPAREN
    ;

identifiedExpr
    : EXISTS identifiedPath
    | identifiedPath COMPARISON_OPERATOR terminal
    | functionCall COMPARISON_OPERATOR terminal
    | identifiedPath LIKE likeOperand
    | identifiedPath MATCHES matchesOperand
    | SYM_LPAREN identifiedExpr SYM_RPAREN
    ;

classExprOperand
    : IDENTIFIER variable=IDENTIFIER? pathPredicate?                              #classExpression
    | VERSION variable=IDENTIFIER? (SYM_LBRACKET versionPredicate SYM_RBRACKET)?  #versionClassExpr
    ;

terminal
    : primitive
    | PARAMETER
    | identifiedPath
    | functionCall
    ;

identifiedPath
    : IDENTIFIER pathPredicate? (SYM_SLASH objectPath)?
    ;

pathPredicate
    : SYM_LBRACKET (standardPredicate | archetypePredicate | nodePredicate) SYM_RBRACKET
    ;

standardPredicate
    : objectPath COMPARISON_OPERATOR pathPredicateOperand
    ;

archetypePredicate
    : ARCHETYPE_HRID
    | PARAMETER
    ;

nodePredicate
    : (ID_CODE | AT_CODE) (SYM_COMMA (STRING | PARAMETER | COMPACT_TERM_CODE | AT_CODE | ID_CODE))?
    | ARCHETYPE_HRID (SYM_COMMA (STRING | PARAMETER | COMPACT_TERM_CODE | AT_CODE | ID_CODE))?
    | PARAMETER
    | objectPath COMPARISON_OPERATOR pathPredicateOperand
    | objectPath MATCHES CONTAINED_REGEX
    | nodePredicate AND nodePredicate
    | nodePredicate OR nodePredicate
    ;

versionPredicate
    : LATEST_VERSION
    | ALL_VERSIONS
    | standardPredicate
    ;

pathPredicateOperand
    : primitive
    | objectPath
    | PARAMETER
    | ID_CODE
    | AT_CODE
    ;

objectPath
    : pathPart (SYM_SLASH pathPart)*
    ;
pathPart
    : IDENTIFIER pathPredicate?
    ;

likeOperand
    : STRING
    | PARAMETER
    ;
matchesOperand
    : SYM_LCURLY valueListItem (SYM_COMMA valueListItem)* SYM_RCURLY
    | terminologyFunction
    | SYM_LCURLY AQL_URI SYM_RCURLY
    ;

valueListItem
    : primitive
    | PARAMETER
    | terminologyFunction
    ;

primitive
    : STRING
    | numericPrimitive
    | DATE_STRING | TIME_STRING | DATE_TIME_STRING
    | BOOLEAN
    | NULL
    ;

numericPrimitive
    : INTEGER
    | REAL
    | SCI_INTEGER
    | SCI_REAL
    | SYM_MINUS numericPrimitive
    ;

functionCall
    : terminologyFunction
    | name=(STRING_FUNCTION_ID | NUMERIC_FUNCTION_ID | DATE_TIME_FUNCTION_ID | IDENTIFIER) SYM_LPAREN (terminal (SYM_COMMA terminal)*)? SYM_RPAREN
    ;

aggregateFunctionCall
    : name=COUNT SYM_LPAREN (DISTINCT? identifiedPath | SYM_ASTERISK) SYM_RPAREN
    | name=(MIN | MAX | SUM | AVG) SYM_LPAREN identifiedPath SYM_RPAREN
    ;

terminologyFunction
    : TERMINOLOGY SYM_LPAREN STRING SYM_COMMA STRING SYM_COMMA STRING SYM_RPAREN
    ;

// (deprecated)
top
    : TOP INTEGER direction=(FORWARD|BACKWARD)?
    ;
