//
//  description: Antlr4 grammar for openEHR Expression Language baed on BMM meta-model.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

lexer grammar ElLexer;
import Cadl2Lexer, SymbolsLexer, GeneralIdsLexer;

// The COMMENT channel receives all regular comments.
channels {
    COMMENT
}

// ------------------ lines and comments ------------------

// inline comment, i.e. right side of text
CMT_LINE : '||' ~[\r\n]* -> channel(COMMENT) ;

// These are used in decision tables, but are really comments
BLOCK_DELIM : '====' '='* EOL ;
BLOCK_ROW : '----' '-'* EOL -> channel(COMMENT) ;

EOL      : '\r'? '\n'  -> channel(HIDDEN) ;
WS       : [ \t\r]     -> channel(HIDDEN) ;

// --------- keywords ----------

SYM_RESULT  : 'Result' ;
SYM_SELF    : 'Self' ;
SYM_IN      : 'in' ;
SYM_WHEN    : 'when' ;
SYM_CASE    : 'case' ;

// --------- symbols ----------
SYM_ASSIGNMENT: ':=' ;
SYM_INTERROGATION: '?' ;
SYM_LEFT_GUILLEMET: '«' ;
SYM_RIGHT_GUILLEMET: '»' ;

SYM_BROKEN_BAR: '¦' ;

SYM_DOUBLE_MINUS: '--' ;
SYM_DOUBLE_PLUS: '++' ;

SYM_THEN     : 'then' | 'THEN' ;
SYM_AND      : 'and' | 'AND' | '∧' ;
SYM_OR       : 'or' | 'OR' | '∨' ;
SYM_XOR      : 'xor' | 'XOR' | '⊻' ;
SYM_NOT      : 'not' | 'NOT' | '~' | '¬' ;
SYM_IMPLIES  : 'implies' | '⇒' | '→' ;
SYM_IFF      : '⇔' | '↔' ;
SYM_FOR_ALL  : 'for_all' | '∀' ;
SYM_THERE_EXISTS: 'there_exists' | '∃' ;
SYM_MATCHES  : 'matches' | 'is_in' | '∈' ;
SYM_ASSERT   : 'assert' ;

BOUND_VARIABLE_ID: '$' LC_ID ;

// ---------- local code that are not ADL codes -------
// e.g. [heart_rate]
LOCAL_TERM_CODE_REF: '[' ALPHANUM_US_CHAR+ ']' ;

