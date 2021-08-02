//
// description: Antlr4 grammar for consuming Object Data Instance Notation (ODIN) text
//              for proper parsing later
// author:      Thomas Beale <thomas.beale@openehr.org>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2021- openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

parser grammar OdinParser;
options { tokenVocab=OdinLexer; }
import PrimitiveValuesParser;

//
// -------------------------- Parse Rules --------------------------
//

odinObject : ( odinAttrVal+ | odinObjectValueBlock ) EOF ;

odinAttrVal : odinAttrName '=' odinObjectBlock ';'? ;

odinAttrName : ALPHA_UC_ID | ALPHA_UNDERSCORE_ID | rmAttributeId ;

odinObjectBlock :
      odinObjectValueBlock
    | odinObjectReferenceBlock
    ;

odinObjectValueBlock : rmTypeSpec? '<' ( primitiveObject | odinAttrVal+ | odinKeyedObject+ )? '>' ;
rmTypeSpec : '(' rmTypeId ')' ;

odinKeyedObject : odinKeySpec '=' odinObjectBlock ;
odinKeySpec: '[' primitiveValue ']' ;

// ----------------- references ------------------

odinObjectReferenceBlock : '<' odinPathList '>' ;

odinPathList : ODIN_PATH ( ',' SYM_LIST_CONTINUE | ( ',' ODIN_PATH )+ )? ;

// ---------------- model references --------------
rmTypeId      : ALPHA_UC_ID ( '<' rmTypeId ( ',' rmTypeId )* '>' )? ;
rmAttributeId : ALPHA_LC_ID ;

// ------------------- leaf types -----------------

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
