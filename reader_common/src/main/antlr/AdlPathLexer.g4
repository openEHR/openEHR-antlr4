//
//  Path patterns lexer
//  author:      Thomas Beale <thomas.beale@openEHR.org>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2021- openEHR Foundation <http://www.openEHR.org>
//

lexer grammar AdlPathLexer;
import OpenehrIdsLexer, SymbolsLexer, GeneralIdsLexer;

//
// Include this grammar in a main lexer grammar if you want to match ADL and pure
// RM paths as single lexical units rather than pieces. This lexer is
// useful for matching paths in legacy archetypes, where they are allowed inline
// in expressions, where the '/' character is also allowed.
//

//
// An ADL path always starts with /rm_attr_name[idNNN] or /rm_attr_name[archetype_ref]
//
ADL_PATH: ADL_PATH_SEG+ RM_PATH_SEG* ;

//
// An RmPath can be relative
//
RM_PATH: LC_ID? RM_PATH_SEG+ ;

fragment ADL_PATH_SEG: RM_PATH_SEG '[' ( ARCHETYPE_REF | ID_CODE ) ']' ;
fragment RM_PATH_SEG: '/' LC_ID ;

