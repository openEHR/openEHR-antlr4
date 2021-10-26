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

// ---------------------------- UIDs ---------------------------
fragment UID: UUID | INTERNET_ID | ISO_OID ;
fragment INTERNET_ID: LABEL ( '.' LABEL )+ ;
fragment ISO_OID : NUMBER ( '.' NUMBER )+ ;

// ---------------------- HIER_OBJECT_HRID ---------------------
fragment HIER_OBJECT_HRID: UID_BASED_ID ;
fragment UID_BASED_ID: UID ( '::' UID_EXTENSION )? ;
fragment UID_EXTENSION: ( URI_UNRESERVED | URI_RESERVED )+ ; // ideally any printable

// ---------------------- OBJECT_VERSION_ID ---------------------
// OBJECT_VERSION_ID = object_id '::' creating_system_id '::' version_tree_id
// VERSION_TREE_ID = trunk_version [ '.' branch_number '.' branch_version ]
OBJECT_VERSION_ID: UID '::' UID '::' VERSION_TREE_ID ;
fragment VERSION_TREE_ID: NUMBER ( '.' NUMBER '.' NUMBER )? ;

// ---------------------- ARCHETYPE_HRID ---------------------
ARCHETYPE_HRID : FULLY_QUALIFIED_RM_ENTITY '.v' VERSION_ID ;
ARCHETYPE_REF  : FULLY_QUALIFIED_RM_ENTITY '.v' VERSION_REF ;
VERSION_ID     : NUMBER '.' NUMBER '.' NUMBER VERSION_MOD? ;
fragment FULLY_QUALIFIED_RM_ENTITY : ( NAMESPACE '::' )? QUALIFIED_RM_ENTITY ;
fragment QUALIFIED_RM_ENTITY : WORD_ID '-' WORD_ID '-' WORD_ID '.' NAME_ID ;
fragment VERSION_REF: NUMBER ( '.' NUMBER ( '.' NUMBER VERSION_MOD? )? )? ;
fragment VERSION_MOD: ( '-rc' | '-alpha' ) ( '.' DIGIT+ )? ;
fragment WORD_ID : ALPHANUM_CHAR ALPHANUM_US_CHAR* ;
fragment NAME_ID : ALPHANUM_CHAR ALPHANUM_US_HYP_CHAR* ;

// According to IETF http://tools.ietf.org/html/rfc1034[RFC 1034] and
// http://tools.ietf.org/html/rfc1035[RFC 1035], as clarified by
// http://tools.ietf.org/html/rfc2181[RFC 2181] (section 11)
fragment NAMESPACE : LABEL ( '.' LABEL )* ;
fragment LABEL : ALPHA_CHAR ( ALPHANUM_CHAR | '_' | '-' | PCT_ENCODED )* ;
fragment PCT_ENCODED : '%' HEX_DIGIT HEX_DIGIT ;

// ---------------------- Terminology ids and refs ---------------------
fragment TERMINOLOGY_ID: NAME_ID | URI ;

// e.g. [ICD10AM(1998)::F23]; [ISO_639-1::en]
QUALIFIED_TERM_CODE_REF: '[' COMPACT_QUALIFIED_TERM_CODE ']' ;
fragment COMPACT_QUALIFIED_TERM_CODE : TERM_CODE_STRING ( '(' TERM_CODE_STRING ')' )? '::' TERM_CODE_STRING ( '|' .+? '|' )? ;
fragment TERM_CODE_STRING: TERM_CODE_CHAR+ ;
fragment TERM_CODE_CHAR : ALPHANUM_US_HYP_CHAR | '.' ;

// ---------- various ADL2 patterns -------
ROOT_ID_CODE : 'id1' '.1'* ;
ID_CODE      : 'id' CODE_STR ;
AT_CODE      : 'at' CODE_STR ;
AC_CODE      : 'ac' CODE_STR ;
fragment CODE_STR : NUMBER ( '.' NUMBER )* ;

// ---------- legacy ADL14 patterns -------
ADL14_AT_CODE : 'at' ADL14_CODE_STR ;
ADL14_AC_CODE : 'ac' ADL14_CODE_STR ;
fragment ADL14_CODE_STR : [0-9]+ ( '.' NUMBER )* ;

