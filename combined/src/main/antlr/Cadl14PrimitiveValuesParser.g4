//
// description: Antlr4 grammar for cADL primitives, used within Cadl grammar, but also by
//              other languages that allow constraints on primitive objects.
// author:      Thomas Beale <thomas.beale@openehr.org>
// contributors:Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

parser grammar Cadl14PrimitiveValuesParser;
options { tokenVocab=Cadl14PrimitiveValuesLexer; }
import Cadl2PrimitiveValuesParser;

// ------------------------- C_TERMINOLOGY_CODE ---------------------------

cTerminologyCode: cTerminologyLocalCode | cQualifiedTermCode ;

cQualifiedTermCode: '[' TERMINOLOGY_ID '::' ( (CODE_STRING ( ',' CODE_STRING )* ';' CODE_STRING ) )? ']' | TERM_CODE_REF;

cTerminologyLocalCode: '[' ( AC_CODE ( ';' AT_CODE )? | AT_CODE ) ']' ;

