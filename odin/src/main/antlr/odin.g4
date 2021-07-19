//
// description: Antlr4 grammar for consuming Object Data Instance Notation (ODIN) text
//              for proper parsing later
// author:      Thomas Beale <thomas.beale@openehr.org>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2021- openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar odin;
import primitiveValues;

//
// -------------------------- Parse Rules --------------------------
//

odinText :
      odinAttrVals
    | odinObjectValueBlock
    ;

odinAttrVals : ( odinAttrVal ';'? )+ ;

odinAttrVal : odinKey '=' odinObjectBlock ;

odinKey : ALPHA_UC_ID | ALPHA_UNDERSCORE_ID | rmAttributeId ;

odinObjectBlock :
      odinObjectValueBlock
    | odinObject_referenceBlock
    ;

odinObjectValueBlock : ( '(' rmTypeId ')' )? '<' ( primitiveObject | odinAttrVals? | odinKeyedObject* ) '>' ;

odinKeyedObject : '[' primitiveValue ']' '=' odinObjectBlock ;

// ----------- references -------------

odinObject_referenceBlock : '<' odinPathList '>' ;

odinPathList : path ( ( ',' path )+ | SYM_LIST_CONTINUE )? ;
path         : pathSegment? ( '/' pathSegment? )+ ;
pathSegment : ALPHA_LC_ID ('[' .*? ']')? ;

// -------- from base/basePatterns ----------
rmTypeId      : ALPHA_UC_ID ( '<' rmTypeId ( ',' rmTypeId )* '>' )? ;
rmAttributeId : ALPHA_LC_ID ;

// ------ leaf types ------

primitiveObject :
      primitiveValue 
    | primitiveListValue 
    | primitiveIntervalValue 
    ;

primitiveValue :
      stringValue 
    | integerValue 
    | realValue 
    | booleanValue 
    | characterValue 
    | termCodeValue
    | dateValue
    | timeValue 
    | dateTimeValue 
    | durationValue 
    | uriValue 
    ;

primitiveListValue : 
      stringListValue 
    | integerListValue 
    | realListValue 
    | booleanListValue 
    | characterListValue 
    | termCodeListValue
    | dateListValue
    | timeListValue 
    | dateTimeListValue 
    | durationListValue 
    ;

primitiveIntervalValue :
      integerIntervalValue
    | realIntervalValue
    | dateIntervalValue
    | timeIntervalValue
    | dateTimeIntervalValue
    | durationIntervalValue
    ;


