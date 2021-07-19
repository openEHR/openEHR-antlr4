//
// grammar defining ODIN terminal value types, including atoms, lists and intervals
// author:      Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2018- openEHR Foundation <http://www.openEHR.org>
//

grammar primitiveValues;
import baseLexer;

stringValue : STRING ;
stringListValue : stringValue ( ( ',' stringValue )+ | ',' SYM_LIST_CONTINUE ) ;

integerValue : ( '+' | '-' )? INTEGER ;
integerListValue : integerValue ( ( ',' integerValue )+ | ',' SYM_LIST_CONTINUE ) ;
integerIntervalValue :
      '|' SYM_GT? integerValue SYM_INTERVAL_SEP SYM_LT? integerValue '|'
    | '|' relop? integerValue '|'
    | '|' integerValue SYM_PLUS_OR_MINUS integerValue '|'
    ;
integerIntervalListValue : integerIntervalValue ( ( ',' integerIntervalValue )+ | ',' SYM_LIST_CONTINUE ) ;

realValue : ( '+' | '-' )? REAL ;
realListValue : realValue ( ( ',' realValue )+ | ',' SYM_LIST_CONTINUE ) ;
realIntervalValue :
      '|' SYM_GT? realValue SYM_INTERVAL_SEP SYM_LT? realValue '|'
    | '|' relop? realValue '|'
    | '|' realValue SYM_PLUS_OR_MINUS realValue '|'
    ;
realIntervalListValue : realIntervalValue ( ( ',' realIntervalValue )+ | ',' SYM_LIST_CONTINUE ) ;

booleanValue : SYM_TRUE | SYM_FALSE ;
booleanListValue : booleanValue ( ( ',' booleanValue )+ | ',' SYM_LIST_CONTINUE ) ;

characterValue : CHARACTER ;
characterListValue : characterValue ( ( ',' characterValue )+ | ',' SYM_LIST_CONTINUE ) ;

dateValue : ISO8601_DATE ;
dateListValue : dateValue ( ( ',' dateValue )+ | ',' SYM_LIST_CONTINUE ) ;
dateIntervalValue :
      '|' SYM_GT? dateValue SYM_INTERVAL_SEP SYM_LT? dateValue '|'
    | '|' relop? dateValue '|'
    | '|' dateValue SYM_PLUS_OR_MINUS durationValue '|'
    ;
dateIntervalListValue : dateIntervalValue ( ( ',' dateIntervalValue )+ | ',' SYM_LIST_CONTINUE ) ;

timeValue : ISO8601_TIME ;
timeListValue : timeValue ( ( ',' timeValue )+ | ',' SYM_LIST_CONTINUE ) ;
timeIntervalValue :
      '|' SYM_GT? timeValue SYM_INTERVAL_SEP SYM_LT? timeValue '|'
    | '|' relop? timeValue '|'
    | '|' timeValue SYM_PLUS_OR_MINUS durationValue '|'
    ;
timeIntervalListValue : timeIntervalValue ( ( ',' timeIntervalValue )+ | ',' SYM_LIST_CONTINUE ) ;

date_timeValue : ISO8601_DATE_TIME ;
date_timeListValue : date_timeValue ( ( ',' date_timeValue )+ | ',' SYM_LIST_CONTINUE ) ;
date_timeIntervalValue :
      '|' SYM_GT? date_timeValue SYM_INTERVAL_SEP SYM_LT? date_timeValue '|'
    | '|' relop? date_timeValue '|'
    | '|' date_timeValue SYM_PLUS_OR_MINUS durationValue '|'
    ;
date_timeIntervalListValue : date_timeIntervalValue ( ( ',' date_timeIntervalValue )+ | ',' SYM_LIST_CONTINUE ) ;

durationValue : ISO8601_DURATION ;
durationListValue : durationValue ( ( ',' durationValue )+ | ',' SYM_LIST_CONTINUE ) ;
durationIntervalValue :
      '|' SYM_GT? durationValue SYM_INTERVAL_SEP SYM_LT? durationValue '|'
    | '|' relop? durationValue '|'
    | '|' durationValue SYM_PLUS_OR_MINUS durationValue '|'
    ;
durationIntervalListValue : durationIntervalValue ( ( ',' durationIntervalValue )+ | ',' SYM_LIST_CONTINUE ) ;

termCodeValue : TERM_CODE_REF ;
termCodeListValue : termCodeValue ( ( ',' termCodeValue )+ | ',' SYM_LIST_CONTINUE ) ;

uriValue : URI ;

relop : SYM_GT | SYM_LT | SYM_LE | SYM_GE ;

// ---------- symbols ----------

SYM_GT : '>' ;
SYM_LT : '<' ;
SYM_LE : '<=' | '≤' ;
SYM_GE : '>=' | '≥' ;
//SYM_NE : '/=' | '!=' | '≠' ;
//SYM_EQ : '=' ;
SYM_PLUS_OR_MINUS : '+/-' | '±' ;

SYM_INTERVAL_SEP: '..' ;
SYM_LIST_CONTINUE: '...' ;
