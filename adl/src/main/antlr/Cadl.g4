//
// description: Antlr4 grammar for cADL non-primitves sub-syntax of Archetype Definition Language (ADL2)
// author:      Thomas Beale <thomas.beale@openehr.org>
// contributors:Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar Cadl;
import Odin, El;

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

// ------------ Primitive type constraints -------------

cInlinePrimitiveObject:
      cInteger
    | cReal
    | cDate
    | cTime
    | cDateTime
    | cDuration
    | cString
    | cTerminology_code
    | cBoolean
    ;

cInteger: ( integerValue | integerListValue | integerIntervalValue | integerIntervalListValue ) assumedIntegerValue? ;
assumedIntegerValue: ';' integerValue ;

cReal: ( realValue | realListValue | realIntervalValue | realIntervalListValue ) assumedRealValue? ;
assumedRealValue: ';' realValue ;

cDateTime: ( DATE_TIME_CONSTRAINT_PATTERN | dateTimeValue | dateTimeListValue | dateTimeIntervalValue | dateTimeIntervalListValue ) assumedDateTimeValue? ;
assumedDateTimeValue: ';' dateTimeValue ;

cDate: ( DATE_CONSTRAINT_PATTERN | dateValue | dateListValue | dateIntervalValue | dateIntervalListValue ) assumedDateValue? ;
assumedDateValue: ';' dateValue ;

cTime: ( TIME_CONSTRAINT_PATTERN | timeValue | timeListValue | timeIntervalValue | timeIntervalListValue ) assumedTimeValue? ;
assumedTimeValue: ';' timeValue ;

cDuration: ( DURATION_CONSTRAINT_PATTERN ( '/' ( durationIntervalValue | durationValue ))?
    | durationValue | durationListValue | durationIntervalValue | durationIntervalListValue ) assumedDurationValue?
    ;
assumedDurationValue: ';' durationValue ;

cString: ( stringValue | stringListValue | DELIMITED_REGEX ) assumedStringValue? ;
assumedStringValue: ';' stringValue ;

// ADL2 term types: [ac3], [ac3; at5], [at5]
// NOTE: an assumed at-code (the ';' AT_CODE pattern) can only occur after an ac-code not after the single at-code
cTerminology_code: '[' ( ( AC_CODE ( ';' AT_CODE )? ) | AT_CODE ) ']' ;

cBoolean: ( booleanValue | booleanListValue ) assumedBooleanValue? ;
assumedBooleanValue: ';' booleanValue ;

// -------- from base/basePatterns ----------
rmTypeId      : ALPHA_UC_ID ( '<' rmTypeId ( ',' rmTypeId )* '>' )? ;
rmAttributeId : ALPHA_LC_ID ;

// =================== CADL lexer rules ================

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

// ---------- Delimited Regex matcher ------------
// In ADL, a regexp can only exist between {}.
// allows for '/' or '^' delimiters
// logical form - REGEX: '/' ( '\\/' | ~'/' )+ '/' | '^' ( '\\^' | ~'^' )+ '^';

DELIMITED_REGEX: SLASH_REGEX | CARET_REGEX ;
fragment SLASH_REGEX: '/' SLASH_REGEX_CHAR+ '/';
fragment SLASH_REGEX_CHAR: ~[/\n\r] | ESCAPE_SEQ | '\\/';

fragment CARET_REGEX: '^' CARET_REGEX_CHAR+ '^';
fragment CARET_REGEX_CHAR: ~[^\n\r] | ESCAPE_SEQ | '\\^';

// ---------- various ADL2 codes -------

ROOT_ID_CODE : 'id1' '.1'* ;
ID_CODE      : 'id' CODE_STR ;
AT_CODE      : 'at' CODE_STR ;
AC_CODE      : 'ac' CODE_STR ;
fragment CODE_STR : ('0' | [1-9][0-9]*) ( '.' ('0' | [1-9][0-9]* ))* ;


// ---------- ISO8601-based date/time/duration constraint patterns

DATE_CONSTRAINT_PATTERN      : YEAR_PATTERN '-' MONTH_PATTERN '-' DAY_PATTERN ;
TIME_CONSTRAINT_PATTERN      : HOUR_PATTERN ':' MINUTE_PATTERN ':' SECOND_PATTERN ;
DATE_TIME_CONSTRAINT_PATTERN : DATE_CONSTRAINT_PATTERN 'T' TIME_CONSTRAINT_PATTERN ;
DURATION_CONSTRAINT_PATTERN  : 'P' [yY]?[mM]?[Ww]?[dD]? ( 'T' [hH]?[mM]?[sS]? )? ;

fragment YEAR_PATTERN   : ( 'yyy' 'y'? ) | ( 'YYY' 'Y'? ) ;
fragment MONTH_PATTERN  : 'mm' | 'MM' | '??' | 'XX' | 'xx' ;
fragment DAY_PATTERN    : 'dd' | 'DD' | '??' | 'XX' | 'xx'  ;
fragment HOUR_PATTERN   : 'hh' | 'HH' | '??' | 'XX' | 'xx'  ;
fragment MINUTE_PATTERN : 'mm' | 'MM' | '??' | 'XX' | 'xx'  ;
fragment SECOND_PATTERN : 'ss' | 'SS' | '??' | 'XX' | 'xx'  ;


