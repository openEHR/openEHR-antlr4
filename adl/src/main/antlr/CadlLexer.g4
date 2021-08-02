//
// description: Antlr4 grammar for cADL non-primitves sub-syntax of Archetype Definition Language (ADL2)
// author:      Thomas Beale <thomas.beale@openehr.org>
// contributors:Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

lexer grammar CadlLexer;
import PathLexer, BaseLexer;

// ------------------ lines and comments ------------------
CMT_LINE : '--' .*? EOL -> skip ;             // increment line count
EOL      : '\r'? '\n'   -> channel(HIDDEN) ;  // increment line count
WS       : [ \t\r]+     -> channel(HIDDEN) ;

// --------------------- general symbols ------------------------
SYM_GT : '>' ;
SYM_LT : '<' ;
SYM_MATCHES  : [Mm][Aa][Tt][Cc][Hh][Ee][Ss] | [Ii][Ss]'_'[Ii][Nn] | '∈' ;

// ------------------ symbols for intervals ---------------------
SYM_IVL_DELIM: '|' ;
SYM_IVL_SEP  : '..' ;

// ----------------------- keywords -----------------------
SYM_EXISTENCE   : [Ee][Xx][Ii][Ss][Tt][Ee][Nn][Cc][Ee] ;
SYM_OCCURRENCES : [Oo][Cc][Cc][Uu][Rr][Rr][Ee][Nn][Cc][Ee][Ss] ;
SYM_CARDINALITY : [Cc][Aa][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy] ;
SYM_ORDERED     : [Oo][Rr][Dd][Ee][Rr][Ee][Dd] ;
SYM_UNORDERED   : [Uu][Nn][Oo][Rr][Dd][Ee][Rr][Ee][Dd] ;
SYM_UNIQUE      : [Uu][Nn][Ii][Qq][Uu][Ee] ;
SYM_USE_NODE    : [Uu][Ss][Ee][_][Nn][Oo][Dd][Ee] ;
SYM_USE_ARCHETYPE : [Uu][Ss][Ee][_][Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;
SYM_ALLOW_ARCHETYPE : [Aa][Ll][Ll][Oo][Ww][_][Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;
SYM_INCLUDE     : [Ii][Nn][Cc][Ll][Uu][Dd][Ee] ;
SYM_EXCLUDE     : [Ee][Xx][Cc][Ll][Uu][Dd][Ee] ;
SYM_AFTER       : [Aa][Ff][Tt][Ee][Rr] ;
SYM_BEFORE      : [Bb][Ee][Ff][Oo][Rr][Ee] ;
SYM_CLOSED      : [Cc][Ll][Oo][Ss][Ee][Dd] ;

// ---------------- various ADL codes --------------------
ROOT_ID_CODE : 'id1' '.1'* ;
ID_CODE      : 'id' CODE_STR ;
AT_CODE      : 'at' CODE_STR ;
AC_CODE      : 'ac' CODE_STR ;
fragment CODE_STR : ('0' | [1-9][0-9]*) ( '.' ('0' | [1-9][0-9]* ))* ;

// ------------------ default blocks --------------------
DEFAULT_BLOCK_START : '_'[Dd][Ee][Ff][Aa][Uu][Ll][Tt] WS? '=' -> mode (OBJECT_BLOCK);

// modes to grab included object blocks; these do explicit whitespace handling
// since they have to capture everything so it can be passed to other parsers
mode OBJECT_BLOCK ;
SERIAL_BLOCK_START: WS? '(' ALPHA_CHAR WORD_CHAR* ')' WS? '<#' WS? EOL -> mode (SERIAL_BLOCK);
ODIN_BLOCK_START: WS? '(' ALPHA_CHAR WORD_CHAR* ')' WS? '<' WS? EOL -> mode (ODIN_BLOCK);
WS2 : WS -> channel(HIDDEN) ;

mode SERIAL_BLOCK ;
SERIAL_BLOCK_END: WS '#>' WS? EOL -> mode(DEFAULT_MODE) ;
SERIAL_BLOCK_LINE : NON_EOL* EOL ;
fragment NON_EOL : ~'\n' ;

mode ODIN_BLOCK ;
ODIN_BLOCK_END: WS '>' WS? EOL -> mode(DEFAULT_MODE) ;
ODIN_BLOCK_LINE : NON_EOL* EOL ;
 
