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
import Cadl14Parser;
options { tokenVocab=AqlLexer; }

//
// --------------- top-level parts of query --------------
//

aqlQuery
    : selectClause fromClause whereClause? orderByClause? limitClause? SYM_DOUBLE_DASH? EOF
    ;

selectClause
    : SYM_SELECT SYM_DISTINCT? top? resultTable
    ;

fromClause
    : SYM_FROM modelTypeConstraint
    ;

whereClause
    : SYM_WHERE whereExpr
    ;

orderByClause
    : SYM_ORDER SYM_BY orderByExpr ( ',' orderByExpr )*
    ;

limitClause
    : SYM_LIMIT limit=INTEGER ( SYM_OFFSET offset=INTEGER ) ?
    ;

//
// --------------- SELECT sub-parts --------------
//

resultTable: columnSpec ( ',' columnSpec )* ;

columnSpec: columnValue ( SYM_AS aliasName=LC_ID )? ;

columnValue:
      dataMatchPath
    | aggregateFunctionCall
    | functionCall
    | primitiveLiteral
    ;

orderByExpr: modelPath order=( SYM_DESCENDING | SYM_DESC | SYM_ASCENDING | SYM_ASC )? ;

//
// --------------- FROM sub-parts --------------
//

modelTypeConstraint:
      modelType
    | modelTypeChain
    ;

modelTypeChain: modelType SYM_NOT? SYM_CONTAINS modelTypeSubChain ;

modelTypeSubChain:
      modelTypeConstraint
    | '(' modelTypeExpr ')'
    ;

modelTypeExpr:
      SYM_NOT modelTypeExpr
    | modelTypeExpr SYM_AND modelTypeExpr
    | modelTypeExpr SYM_OR modelTypeExpr
    | modelTypeConstraint
    | '(' modelTypeExpr ')'
    ;

modelType: typeName=UC_ID variableName=LC_ID? ( '[' archetypeIdPredicate ']' )? ;

//
// --------------- WHERE sub-parts --------------
//

whereExpr
    : wherePathExpr
    | SYM_NOT whereExpr
    | whereExpr SYM_AND whereExpr
    | whereExpr SYM_OR whereExpr
    | '(' whereExpr ')'
    ;

//
// Boolean-returning expressions with dataMatchPath as an operand
//
wherePathExpr
    : SYM_EXISTS dataMatchPath
    | dataMatchPath SYM_MATCHES matchesOperand
    | dataMatchPath SYM_LIKE likeOperand
    | dataMatchPath comparisonOperator terminal
    | functionCall comparisonOperator terminal
    ;

terminal
    : primitiveLiteral
    | PARAMETER
    | dataMatchPath
    | functionCall
    ;

likeOperand
    : STRING
    | PARAMETER
    ;

matchesOperand:
      '{' matchesConstraint '}'
    | terminologyFunction
    ;

matchesConstraint:
      valueListItem (',' valueListItem)*
    | cComplexObjectMatcher
    | AQL_URI
    ;

valueListItem:
      primitiveLiteral
    | PARAMETER
    ;

//
// ----------------------- paths ------------------------
//

//
// A path to a node in an archetype, which will potentially match
// one or more data items in runtime data
//
archetypePath: archetypePathSegment+ ;

archetypePathSegment: '/' attributeId=LC_ID ( '[' archetypePathPredicate ']' )? ;

archetypePathPredicate:
      archetypeIdPredicate
    | idCode
    ;

archetypeIdPredicate: ARCHETYPE_REF ;

//
// A path to a node in an archetype with further model-based
// path, referring to structure not mentioned in the archetype
//
augmentedArchetypePath: variableName=LC_ID archetypePath modelSubPath? ;

//
// A path within a type defined in the underlying reference model
//
modelPath: variableName=LC_ID modelSubPath ;

modelSubPath: modelPathSegment+ ;

modelPathSegment: '/' attributeId=LC_ID ;

//
// A path to match an item in data, based on an archetype path with
// additional runtime constraint predicates. A degenerate form of
// a dataPath (no predicates) looks like a modelPath
//
dataMatchPath: variableName=LC_ID dataMatchPathSegment+ ;
    
dataMatchPathSegment: '/' attributeId=LC_ID ( '[' dataMatchPathPredicate ']' )? ;

//
// Predicates on a data path node, which are of the general form
//  * archetypeId or nodeId (identifying where we are in the archetype), and optionally
//  further value constraints, linked by Boolean operators, e.g.
//  * name/value=$nameValue
//  * name/defining_code/code_string='F60.1' and name/defining_code/terminology_id/value='icd10AM'
//
// The value constraints may have model-specific shortcuts of the form:
//  * ", value"
// which means 'AND /some/path = value', where the '/some/path' is a path specific to the
// reference model, which is assumed (typically a long, commonly used path)
//
dataMatchPathPredicate: archetypePathPredicate ( SYM_AND dataMatchPathValuePredicate | ',' modelSpecificShortcutValue )? ;

//
// Node-level Boolean-returning predicates based on value
//
dataMatchPathValuePredicate:
      modelPath SYM_MATCHES CONTAINED_REGEX
    | modelPath comparisonOperator modelPathComparatorValue
    | dataMatchPathValuePredicate SYM_AND dataMatchPathValuePredicate
    | dataMatchPathValuePredicate SYM_OR dataMatchPathValuePredicate
    ;

modelPathComparatorValue:
      primitiveLiteral
    | modelPath
    | PARAMETER
    ;

modelSpecificShortcutValue:  ;


versionPredicate
    : SYM_LATEST_VERSION
    | SYM_ALL_VERSIONS
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
    | builtInFunction functionArgs
    | LC_ID functionArgs
    ;

functionArgs: '(' (terminal (',' terminal)*)? ')' ;

aggregateFunctionCall
    : name=SYM_COUNT '(' ( SYM_DISTINCT? augmentedArchetypePath | SYM_ASTERISK ) ')'
    | aggregateMathFunction '(' augmentedArchetypePath ')'
    ;

aggregateMathFunction:
      SYM_MIN
    | SYM_MAX
    | SYM_SUM
    | SYM_AVG
    ;

terminologyFunction
    : SYM_TERMINOLOGY '(' STRING ',' STRING ',' STRING ')'
    ;

// built-in functions
builtInFunction: stringFunction | numericFunction | dateTimeFunction ;
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
    
comparisonOperator:
      SYM_EQ
    | SYM_NE
    | SYM_GT
    | SYM_GE
    | SYM_LT
    | SYM_LE
    ;

// (deprecated)
top: SYM_TOP INTEGER direction=( SYM_FORWARD | SYM_BACKWARD )? ;
