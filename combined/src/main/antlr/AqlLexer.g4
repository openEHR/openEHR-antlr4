//
//  description:  ANTLR4 lexer grammar for Archetype Query Language (AQL)
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

lexer grammar AqlLexer;
import OpenehrPatterns, BaseLexer, AqlGeneral;

channels {
    COMMENT_CHANNEL
}

// SKIP
WS: [ \t\r\n]+ -> channel(HIDDEN);
UNICODE_BOM: (
      '\uEFBBBF' // UTF-8 BOM
    | '\uFEFF' // UTF16_BOM
    | '\u0000FEFF' // UTF32_BOM
    ) -> skip;
COMMENT: (
      SYM_DOUBLE_DASH ' ' ~[\r\n]* ('\r'? '\n' | EOF)
    | SYM_DOUBLE_DASH ('\r'? '\n' | EOF)
    ) -> channel (COMMENT_CHANNEL);

// Keywords
// Common Keywords
SYM_SELECT: 'SELECT' ;
SYM_AS: 'AS' ;
SYM_FROM: 'FROM' ;
SYM_WHERE: 'WHERE' ;
SYM_ORDER: 'ORDER' ;
SYM_BY: 'BY' ;
SYM_DESC: 'DESC' ;
SYM_DESCENDING: 'DESCENDING' ;
SYM_ASC: 'ASC' ;
SYM_ASCENDING: 'ASCENDING' ;
SYM_LIMIT: 'LIMIT' ;
SYM_OFFSET: 'OFFSET' ;

// other keywords
SYM_DISTINCT: 'DISTINCT' ;
SYM_VERSION : 'VERSION' ;
SYM_LATEST_VERSION : 'LATEST_VERSION' ;
SYM_ALL_VERSIONS : 'ALL_VERSIONS' ;
SYM_NULL: 'NULL' ;

// deprecated
SYM_TOP: 'TOP' ;
SYM_FORWARD: 'FORWARD' ;
SYM_BACKWARD: 'BACKWARD' ;

// Operators
// Containment operator
SYM_CONTAINS : 'CONTAINS' ;

// Logical operators
SYM_AND : 'AND' ;
SYM_OR : 'OR' ;
SYM_NOT : 'NOT' ;
SYM_EXISTS: 'EXISTS' ;

// Comparison operators
SYM_LIKE: 'LIKE' ;
SYM_MATCHES: 'MATCHES' ;

// string functions
SYM_LENGTH: 'LENGTH' ;
SYM_POSITION: 'POSITION' ;
SYM_SUBSTRING: 'SUBSTRING' ;
SYM_CONCAT: 'CONCAT' ;
SYM_CONCAT_WS: 'CONCAT_WS' ;

// numeric functions
SYM_ABS: 'ABS' ;
SYM_MOD: 'MOD' ;
SYM_CEIL: 'CEIL' ;
SYM_FLOOR: 'FLOOR' ;
SYM_ROUND: 'ROUND' ;

// date and time functions
SYM_CURRENT_DATE: 'CURRENT_DATE' ;
SYM_CURRENT_TIME: 'CURRENT_TIME' ;
SYM_CURRENT_DATE_TIME: 'CURRENT_DATE_TIME' ;
SYM_NOW: 'NOW' ;
SYM_CURRENT_TIMEZONE: 'CURRENT_TIMEZONE' ;

// aggregate function
SYM_COUNT: 'COUNT' ;
SYM_MIN: 'MIN' ;
SYM_MAX: 'MAX' ;
SYM_SUM: 'SUM' ;
SYM_AVG: 'AVG' ;

// other functions
SYM_TERMINOLOGY: 'TERMINOLOGY' ;

//
//  ======================= Lexical rules ========================

// ---------- Delimited Regex matcher ------------

CONTAINED_REGEX: '{'WS* SLASH_REGEX WS* (';' WS* STRING)? WS* '}';
fragment SLASH_REGEX: '/' SLASH_REGEX_CHAR+ '/';
fragment SLASH_REGEX_CHAR: ~[/\n\r] | ESCAPE_SEQ | '\\/';

// --------------------- composed primitive types -------------------

AQL_URI: URI ;

// --------------------- atomic primitive types -------------------

BOOLEAN: SYM_TRUE | SYM_FALSE ;

DATE_STRING
    : SYM_SINGLE_QUOTE ( ISO8601_DATE_EXTENDED | ISO8601_DATE_COMPACT ) SYM_SINGLE_QUOTE
    | SYM_DOUBLE_QUOTE ( ISO8601_DATE_EXTENDED | ISO8601_DATE_COMPACT ) SYM_DOUBLE_QUOTE
    ;

TIME_STRING
    : SYM_SINGLE_QUOTE ( ISO8601_TIME_EXTENDED | ISO8601_TIME_COMPACT ) SYM_SINGLE_QUOTE
    | SYM_DOUBLE_QUOTE ( ISO8601_TIME_EXTENDED | ISO8601_TIME_COMPACT ) SYM_DOUBLE_QUOTE
    ;

DATE_TIME_STRING
    : SYM_SINGLE_QUOTE ( ISO8601_DATE_TIME_EXTENDED | ISO8601_DATE_TIME_COMPACT ) SYM_SINGLE_QUOTE
    | SYM_DOUBLE_QUOTE ( ISO8601_DATE_TIME_EXTENDED | ISO8601_DATE_TIME_COMPACT ) SYM_DOUBLE_QUOTE
    ;

STRING
    : SYM_SINGLE_QUOTE ( ESCAPE_SEQ | UTF8CHAR | OCTAL_ESC | ~('\\'|'\'') )* SYM_SINGLE_QUOTE
    | SYM_DOUBLE_QUOTE ( ESCAPE_SEQ | UTF8CHAR | OCTAL_ESC | ~('\\'|'"') )* SYM_DOUBLE_QUOTE
    ;

AQL_COMPACT_QUALIFIED_TERM_CODE: COMPACT_QUALIFIED_TERM_CODE;

// ---------- symbols ----------

SYM_LT: '<' ;
SYM_GT: '>' ;
SYM_LE: '<=' ;
SYM_GE: '>=' ;
SYM_NE: '!=' ;
SYM_EQ: '=' ;

SYM_SLASH: '/';
SYM_ASTERISK: '*';
SYM_PLUS: '+';
SYM_MINUS: '-';

SYM_DOUBLE_DASH: '--';

fragment SYM_SINGLE_QUOTE: '\'';
fragment SYM_DOUBLE_QUOTE: '"';

// ------------------- Fragment letters ---------------------
fragment A: [aA];
fragment B: [bB];
fragment C: [cC];
fragment D: [dD];
fragment E: [eE];
fragment F: [fF];
fragment G: [gG];
fragment H: [hH];
fragment I: [iI];
fragment J: [jJ];
fragment K: [kK];
fragment L: [lL];
fragment M: [mM];
fragment N: [nN];
fragment O: [oO];
fragment P: [pP];
fragment Q: [qQ];
fragment R: [rR];
fragment S: [sS];
fragment T: [tT];
fragment U: [uU];
fragment V: [vV];
fragment W: [wW];
fragment X: [xX];
fragment Y: [yY];
fragment Z: [zZ];
