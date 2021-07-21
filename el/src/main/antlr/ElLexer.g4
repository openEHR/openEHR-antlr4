//
//  Expression-related lexer patterns
//  author:      Pieter Bos <thomas.beale@openehr.org>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2018- openEHR Foundation <http://www.openEHR.org>
//

lexer grammar ElLexer;
import BaseLexer;


// ---------- symbols ----------

SYM_ASSIGNMENT: ':=' | '::=' ;

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

// ---------- rule patterns -----------------

VARIABLE_ID: '$' ALPHA_LC_ID;
