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
SELECT: S E L E C T ;
AS: A S ;
FROM: F R O M ;
WHERE: W H E R E ;
ORDER: O R D E R ;
BY: B Y ;
DESC: D E S C ;
DESCENDING: D E S C E N D I N G ;
ASC: A S C ;
ASCENDING: A S C E N D I N G ;
LIMIT: L I M I T ;
OFFSET: O F F S E T ;
// other keywords
DISTINCT: D I S T I N C T ;
VERSION : V E R S I O N ;
LATEST_VERSION : L A T E S T '_' V E R S I O N ;
ALL_VERSIONS : A L L '_' V E R S I O N S ;
NULL: N U L L ;

// deprecated
TOP: T O P ;
FORWARD: F O R W A R D ;
BACKWARD: B A C K W A R D ;

// Operators
// Containment operator
CONTAINS : C O N T A I N S ;
// Logical operators
AND : A N D ;
OR : O R ;
NOT : N O T ;
EXISTS: E X I S T S ;
// Comparison operators
LIKE: L I K E ;
MATCHES: M A T C H E S ;

// functions
STRING_FUNCTION_ID: LENGTH | CONTAINS | POSITION | SUBSTRING | CONCAT_WS | CONCAT ;
NUMERIC_FUNCTION_ID: ABS | MOD | CEIL | FLOOR | ROUND ;
DATE_TIME_FUNCTION_ID: NOW | CURRENT_DATE_TIME | CURRENT_DATE | CURRENT_TIMEZONE | CURRENT_TIME ;
// string functions
LENGTH: L E N G T H ;
POSITION: P O S I T I O N ;
SUBSTRING: S U B S T R I N G ;
CONCAT: C O N C A T ;
CONCAT_WS: C O N C A T '_' W S ;
// numeric functions
ABS: A B S ;
MOD: M O D ;
CEIL: C E I L ;
FLOOR: F L O O R ;
ROUND: R O U N D ;
// date and time functions
CURRENT_DATE: C U R R E N T '_' D A T E ;
CURRENT_TIME: C U R R E N T '_' T I M E ;
CURRENT_DATE_TIME: C U R R E N T '_' D A T E '_' T I M E ;
NOW: N O W ;
CURRENT_TIMEZONE: C U R R E N T '_' T I M E Z O N E ;
// aggregate function
COUNT: C O U N T ;
MIN: M I N ;
MAX: M A X ;
SUM: S U M ;
AVG: A V G ;
// other functions
TERMINOLOGY: T E R M I N O L O G Y ;

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
