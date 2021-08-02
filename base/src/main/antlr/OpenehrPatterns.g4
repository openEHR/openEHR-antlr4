//
// description: Antlr4 grammar for openEHR-specific lexical patterns
// author:      Thomas Beale <thomas.beale@openehr.org>
// contributors:Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

lexer grammar OpenehrPatterns;
import BaseLexer;

// ---------------------- openEHR Identifiers ---------------------

ARCHETYPE_HRID      : ARCHETYPE_HRID_ROOT '.v' VERSION_ID ;
ARCHETYPE_REF       : ARCHETYPE_HRID_ROOT '.v' VERSION_REF ;
fragment ARCHETYPE_HRID_ROOT : (NAMESPACE '::')? ARCHETYPE_HRID_ID '-' ARCHETYPE_HRID_ID '-' ARCHETYPE_HRID_ID '.' LABEL ;
fragment VERSION_REF: DIGIT+ ('.' DIGIT+ ('.' DIGIT+ ( ( '-rc' | '-alpha' ) ( '.' DIGIT+ )? )?)?)? ;
VERSION_ID          : DIGIT+ '.' DIGIT+ '.' DIGIT+ ( ( '-rc' | '-alpha' ) ( '.' DIGIT+ )? )? ;
fragment ARCHETYPE_HRID_ID : ALPHA_CHAR WORD_CHAR* ;

// ---------- various ADL codes -------

ROOT_ID_CODE : 'id1' '.1'* ;
ID_CODE      : 'id' CODE_STR ;
AT_CODE      : 'at' CODE_STR ;
AC_CODE      : 'ac' CODE_STR ;
fragment CODE_STR : ('0' | [1-9][0-9]*) ( '.' ('0' | [1-9][0-9]* ))* ;


