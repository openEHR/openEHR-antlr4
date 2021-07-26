//
// description: Antlr4 grammar for cADL non-primitves sub-syntax of Archetype Definition Language (ADL2)
// author:      Thomas Beale <thomas.beale@openehr.org>
// contributors:Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar Cadl;
import CPrimitiveValues, Odin, El;

//
//  ======================= Top-level Objects ========================
//

cComplexObject: rmTypeId '[' ( ROOT_ID_CODE | ID_CODE ) ']' cOccurrences? ( SYM_MATCHES '{' cAttributeDef+ defaultValue? '}' )? ;

// ------------ Complex constraints -------------

cAttributeDef:
      cAttribute
    | cAttributeTuple
    ;

cAttribute: (ADL_PATH | rmAttributeId) cExistence? cCardinality? ( SYM_MATCHES '{' cObjects '}' )? ;

cExistence: SYM_EXISTENCE SYM_MATCHES '{' existence '}' ;
existence: INTEGER | INTEGER '..' INTEGER ;

cCardinality    : SYM_CARDINALITY SYM_MATCHES '{' cardinality '}' ;
cardinality      : multiplicity ( multiplicityMod multiplicityMod? )? ; // max of two
orderingMod     : ';' ( SYM_ORDERED | SYM_UNORDERED ) ;
uniqueMod       : ';' SYM_UNIQUE ;
multiplicityMod : orderingMod | uniqueMod ;
multiplicity  : INTEGER | '*' | INTEGER '..' ( INTEGER | '*' ) ;

defaultValue: SYM_DEFAULT SYM_EQ '<' odinObject '>';

cObjects: cRegularObjectOrdered+ | cInlinePrimitiveObject ;

cRegularObjectOrdered: siblingOrder? cRegularObject ;

siblingOrder: ( SYM_AFTER | SYM_BEFORE ) '[' ID_CODE ']' ;

cRegularObject:
      cComplexObject
    | cArchetypeRoot
    | cComplexObjectProxy
    | archetypeSlot
    | cRegularPrimitiveObject
    ;

cArchetypeRoot: SYM_USE_ARCHETYPE rmTypeId '[' ID_CODE ',' ARCHETYPE_REF ']' cOccurrences? ;

cComplexObjectProxy: SYM_USE_NODE rmTypeId '[' ID_CODE ']' cOccurrences? ADL_PATH ;

archetypeSlot: SYM_ALLOW_ARCHETYPE rmTypeId '[' ID_CODE ']' (( cOccurrences? ( SYM_MATCHES '{' cIncludes? cExcludes? '}' )? ) | SYM_CLOSED ) ;

cIncludes : SYM_INCLUDE assertion+ ;
cExcludes : SYM_EXCLUDE assertion+ ;

cRegularPrimitiveObject: rmTypeId '[' ID_CODE ']' cOccurrences? ( SYM_MATCHES '{' cInlinePrimitiveObject '}' )? ;

cOccurrences : SYM_OCCURRENCES SYM_MATCHES '{' multiplicity '}' ;

cAttributeTuple : '[' rmAttributeId ( ',' rmAttributeId )* ']' SYM_MATCHES '{' cPrimitiveTuple ( ',' cPrimitiveTuple )* '}' ;

cPrimitiveTuple : '[' '{' cInlinePrimitiveObject '}' ( ',' '{' cInlinePrimitiveObject '}' )* ']' ;


// ---------------- model references --------------
rmTypeId      : ALPHA_UC_ID ( '<' rmTypeId ( ',' rmTypeId )* '>' )? ;
rmAttributeId : ALPHA_LC_ID ;

// =================== CADL lexer rules ===================

// ------------------ lines and comments ------------------
CMT_LINE   : '--' .*? EOL -> skip ;             // increment line count
EOL        : '\r'? '\n'   -> channel(HIDDEN) ;  // increment line count
WS         : [ \t\r]+     -> channel(HIDDEN) ;

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

SYM_DEFAULT     : '_'[Dd][Ee][Ff][Aa][Uu][Ll][Tt] ;

SYM_MATCHES  : [Mm][Aa][Tt][Cc][Hh][Ee][Ss] | [Ii][Ss]'_'[Ii][Nn] | '∈' ;

// ---------------- various ADL codes --------------------

ROOT_ID_CODE : 'id1' '.1'* ;
ID_CODE      : 'id' CODE_STR ;
AT_CODE      : 'at' CODE_STR ;
AC_CODE      : 'ac' CODE_STR ;
fragment CODE_STR : ('0' | [1-9][0-9]*) ( '.' ('0' | [1-9][0-9]* ))* ;

