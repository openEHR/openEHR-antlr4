//
//  Path patterns lexer
//  author:      Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2018- openEHR Foundation <http://www.openEHR.org>
//

lexer grammar Adl14PathLexer;
import OpenehrPatterns;

// ---------- path patterns -----------

ADL_PATH : ( '/' ADL_PATH_SEGMENT )+ ;
fragment ADL_PATH_SEGMENT  : ATTR_ID ( '[' ADL_PATH_PREDICATE ']' )? ;
fragment ATTR_ID :   '_'? ALPHA_LCHAR ALPHANUM_US_CHAR* ;

// TODO: AT_CODE is to be backward compatible with ADL1.4. archetypes
fragment ADL_PATH_PREDICATE : ADL14_AT_CODE | AT_CODE | STRING | INTEGER | ARCHETYPE_REF;

