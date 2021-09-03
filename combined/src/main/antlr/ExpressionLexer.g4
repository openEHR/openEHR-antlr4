//
//  description: Antlr4 grammar for openEHR Expression Language.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

lexer grammar ExpressionLexer;
import PathLexer, CPrimitiveValuesLexer, GeneralLexer;

channels {
    COMMENT
}

// ------------------ lines and comments ------------------
CMT_LINE : '--' .*? EOL -> channel(COMMENT) ;
EOL      : '\r'? '\n'   -> channel(HIDDEN) ; 
WS       : [ \t\r]+     -> channel(HIDDEN) ;

// --------- symbols ----------
SYM_ASSIGNMENT: ':=' | '::=' ;
SYM_COLON : ':' ;
SYM_NE : '/=' | '!=' | '≠' ;
SYM_EQ : '=' ;
SYM_GT : '>' ;
SYM_LT : '<' ;
SYM_LE : '<=' | '≤' ;
SYM_GE : '>=' | '≥' ;

SYM_PLUS    : '+' ;
SYM_MINUS   : '-' ;
SYM_TIMES   : '*' ;
SYM_SLASH   : '/' ;
SYM_PERCENT : '%' ;
SYM_CARET   : '^' ;

SYM_THEN     : [Tt][Hh][Ee][Nn] ;
SYM_AND      : [Aa][Nn][Dd] | '∧' ;
SYM_OR       : [Oo][Rr] | '∨' ;
SYM_XOR      : [Xx][Oo][Rr] ;
SYM_NOT      : [Nn][Oo][Tt] | '!' | '~' | '¬' ;
SYM_IMPLIES  : [Ii][Mm][Pp][Ll][Ii][Ee][Ss] | '⇒' ;
SYM_FOR_ALL  : 'for_all' | '∀' ;
SYM_THERE_EXISTS: 'there_exists' | '∃' ;
SYM_EXISTS   : 'exists' ;
SYM_MATCHES  : [Mm][Aa][Tt][Cc][Hh][Ee][Ss] | [Ii][Ss]'_'[Ii][Nn] | '∈' ;

// TODO: remove when [] path predicates supported
SYM_IN: 'in' ;

// TODO: remove when [] path predicates supported
VARIABLE_WITH_PATH: VARIABLE_ID ADL_PATH ;

VARIABLE_ID: '$' LC_ID ;
