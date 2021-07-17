//
//  description: Antlr4 grammar for Archetype Definition Language (ADL2)
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2015- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

lexer grammar AdlLexer;

// ---------- lines and comments ----------

EOL : '\n' ;
H_CMT_LINE : '--------' '-'*? '\r'? EOL  ;         // long comment line for splitting template overlays
CMT_LINE   : '--' .*? '\r'? EOL  -> skip ;   // (increment line count)
WS : [ \t\r]+    -> channel(HIDDEN) ;

// ----------------- ADL keywords ---------------

SYM_ARCHETYPE            : [Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;
SYM_TEMPLATE_OVERLAY     : [Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee]'_'[Oo][Vv][Ee][Rr][Ll][Aa][Yy] ;
SYM_TEMPLATE             : [Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee] ;
SYM_OPERATIONAL_TEMPLATE : [Oo][Pp][Ee][Rr][Aa][Tt][Ii][Oo][Nn][Aa][Ll]'_'[Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee] ;

SPECIALIZE_SECTION : EOL SYM_SPECIALIZE WS? EOL ;
fragment SYM_SPECIALIZE  : [Ss][Pp][Ee][Cc][Ii][Aa][Ll][Ii][SsZz][Ee] ;

LANGUAGE_SECTION : EOL SYM_LANGUAGE WS? EOL -> mode (LANGUAGE) ;
fragment SYM_LANGUAGE    : [Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee] ;

// ---------------- meta-data keywords and symbols
SYM_EQUAL:          '=' ;
SYM_SEMI_COLON:     ';' ;
SYM_LPAREN:         '(' ;
SYM_RPAREN:         ')' ;
SYM_ADL_VERSION:    'adl_version' ;
SYM_UID:            'uid' ;
SYM_BUILD_UID:      'build_uid' ;
SYM_RM_RELEASE:     'rm_release' ;
SYM_CONTROLLED:     'controlled' ;
SYM_GENERATED:      'generated' ;

ALPHANUM_ID : [a-zA-Z0-9][a-zA-Z0-9_.+-]* ;

mode LANGUAGE;
DESCRIPTION_SECTION : EOL SYM_DESCRIPTION WS? EOL -> mode (DESCRIPTION) ;
fragment SYM_DESCRIPTION : [Dd][Ee][Ss][Cc][Rr][Ii][Pp][Tt][Ii][Oo][Nn] ;
LANGUAGE_LINE : NON_EOL+ EOL ;
fragment NON_EOL : ~'\n' ;

mode DESCRIPTION ;
DEFINITION_SECTION       : EOL SYM_DEFINITION WS? EOL -> mode (DEFINITION) ;
fragment SYM_DEFINITION  : [Dd][Ee][Ff][Ii][Nn][Ii][Tt][Ii][Oo][Nn] ;
DESCRIPTION_LINE         : NON_EOL+ EOL ;

mode DEFINITION ;
RULES_SECTION       : EOL SYM_RULES WS? EOL -> mode (RULES);
fragment SYM_RULES  : [Rr][Uu][Ll][Ee][Ss] ;
TERMINOLOGY_SECTION : EOL SYM_TERMINOLOGY WS? EOL -> mode (TERMINOLOGY);
fragment SYM_TERMINOLOGY : [Tt][Ee][Rr][Mm][Ii][Nn][Oo][Ll][Oo][Gg][Yy] ;
DEFINITION_LINE     : NON_EOL+ EOL ;

mode RULES ;
TERMINOLOGY_SECTION2 : EOL SYM_TERMINOLOGY WS? EOL -> mode (TERMINOLOGY), type (TERMINOLOGY_SECTION);
RULES_LINE           : NON_EOL+ EOL ;

mode TERMINOLOGY;
ANNOTATIONS_SECTION : EOL SYM_ANNOTATIONS WS? EOL -> mode (ANNOTATIONS);
fragment SYM_ANNOTATIONS : [Aa][Nn][Nn][Oo][Tt][Aa][Tt][Ii][Oo][Nn][Ss] ;
COMPONENT_TERMINOLOGIES_SECTION : EOL SYM_COMPONENT_TERMINOLOGIES WS? EOL+ -> mode (COMPONENT_TERMINOLOGIES);
fragment SYM_COMPONENT_TERMINOLOGIES : [Cc][Oo][Mm][Pp][Oo][Nn][Ee][Nn][Tt]'_'[Tt][Ee][Rr][Mm][Ii][Nn][Oo][Ll][Oo][Gg][Ii][Ee][Ss] ;
TERMINOLOGY_LINE : NON_EOL+ EOL ;

mode ANNOTATIONS;
COMPONENT_TERMINOLOGIES_SECTION2 : EOL SYM_COMPONENT_TERMINOLOGIES WS? EOL+  -> mode (COMPONENT_TERMINOLOGIES), type (COMPONENT_TERMINOLOGIES_SECTION);
ANNOTATIONS_LINE : NON_EOL+ EOL ;

mode COMPONENT_TERMINOLOGIES;
COMPONENT_TERMINOLOGIES_LINE : NON_EOL+ EOL ;

