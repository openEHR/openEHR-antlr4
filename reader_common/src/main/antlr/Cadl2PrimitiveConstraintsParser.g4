//
// description: Antlr4 grammar for cADL primitives, used within Cadl grammar, but also by
//              other languages that allow constraints on primitive objects.
// author:      Thomas Beale <thomas.beale@openehr.org>
// contributors:Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

parser grammar Cadl2PrimitiveConstraintsParser;
options { tokenVocab=Cadl2PrimitiveConstraintsLexer; }
import PrimitiveValuesParser;

// ------------ ADL Primitive type constraints -------------

cInlinePrimitiveObject:
      cInlineOrderedObject
    | cString
    | cTerminologyCode
    | cBoolean
    ;

cInlineOrderedObject:
      cInteger
    | cReal
    | cInlineDTemporalObject
    ;

cInlineDTemporalObject:
      cDate
    | cTime
    | cDateTime
    | cDuration
    ;

// ------------ Primitive type matchers -------------

primitiveObjectMatcher:
      orderedObjectMatcher
    | stringMatcher
    | terminologyCodeMatcher
    | booleanMatcher
    ;

orderedObjectMatcher:
      integerMatcher
    | realMatcher
    | temporalObjectMatcher
    ;

temporalObjectMatcher:
      dateMatcher
    | timeMatcher
    | dateTimeMatcher
    | durationMatcher
    ;


// ------------ Primitive type constraints -------------

cBoolean: booleanMatcher assumedBooleanValue? ;
booleanMatcher: booleanValues ;
assumedBooleanValue: ';' booleanValue ;

cInteger: integerMatcher assumedIntegerValue? ;
integerMatcher: integerValues | integerIntervals ;
assumedIntegerValue: ';' integerValue ;

cReal: realMatcher assumedRealValue? ;
realMatcher: realValues | realIntervals ;
assumedRealValue: ';' realValue ;

cDateTime: dateTimeMatcher assumedDateTimeValue? ;
dateTimeMatcher: DATE_TIME_CONSTRAINT_PATTERN | dateTimeValues | dateTimeIntervals ;
assumedDateTimeValue: ';' dateTimeValue ;

cDate: dateMatcher assumedDateValue? ;
dateMatcher: DATE_CONSTRAINT_PATTERN | dateValues | dateIntervals ;
assumedDateValue: ';' dateValue ;

cTime: timeMatcher assumedTimeValue? ;
timeMatcher: TIME_CONSTRAINT_PATTERN | timeValues | timeIntervals ;
assumedTimeValue: ';' timeValue ;

// The inner `durationInterval | durationValue` here is a different, non-overlapping position
// (gated behind DURATION_CONSTRAINT_PATTERN '/'), so it is unaffected by the above.
cDuration: durationMatcher assumedDurationValue? ;
durationMatcher:
      DURATION_CONSTRAINT_PATTERN ( '/' ( durationInterval | durationValue ))?
    | durationValues
    | durationIntervals
    ;
assumedDurationValue: ';' durationValue ;

cString: stringMatcher assumedStringValue? ;
stringMatcher: stringValues | DELIMITED_REGEX ;
assumedStringValue: ';' stringValue ;

// ADL2 term types: [ac3], [ac3; at5], [at5]
// NOTE: an assumed at-code (the ';' AT_CODE pattern) can only occur after an ac-code not after the single at-code
// TPFP: the 3rd branch using IDs should be removed; the first two patterns are correct
cTerminologyCode:
      '[' ( AC_CODE ( ';' AT_CODE )? | AT_CODE ) ']'
    | LOCAL_TERM_CODE_ID
    | LOCAL_TERM_CODE_ID (',' LOCAL_TERM_CODE_ID)+ ( ';' LOCAL_TERM_CODE_ID )?
    ;

terminologyCodeMatcher: '[' ( AC_CODE | AT_CODE ) ']' | termCodeValues ;
