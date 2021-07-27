//
//  description: Antlr4 grammar for Archetype Definition Language (ADL2). This is a line-oriented
//               grammar designed to extract the verious sub-parts of an archetype and parse them
//               in a second pass, using the appropriate sub-language parser, ie. Cadl, EL, ODIN etc.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2015- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

//
// This grammar is separated to allow modes in the lexical part.
// Combined grammars can't have modes.
//
parser grammar AdlParser;
options { tokenVocab=AdlLexer; }

//
//  ============== Parser rules ==============
//

adlObject: ( authoredArchetype | template | templateOverlay | operationalTemplate ) EOF ;

//
// --------------- parser ----------------
//

authoredArchetype:
    SYM_ARCHETYPE metaData?
    ALPHANUM_ID
    ( SPECIALIZE_SECTION
        ALPHANUM_ID ) ?
    LANGUAGE_SECTION
        LANGUAGE_LINE+
    DESCRIPTION_SECTION
        DESCRIPTION_LINE+
    DEFINITION_SECTION
        DEFINITION_LINE+
    ( RULES_SECTION
        RULES_LINE+ )?
    TERMINOLOGY_SECTION
        TERMINOLOGY_LINE+
    ( ANNOTATIONS_SECTION
        ANNOTATIONS_LINE+ )?
    ;

template:
    SYM_TEMPLATE metaData?
        ALPHANUM_ID
    SPECIALIZE_SECTION
        ALPHANUM_ID
    LANGUAGE_SECTION
        LANGUAGE_LINE+
    DESCRIPTION_SECTION
        DESCRIPTION_LINE+
    DEFINITION_SECTION
        DEFINITION_LINE+
    ( RULES_SECTION
        RULES_LINE+ )?
    TERMINOLOGY_SECTION
        TERMINOLOGY_LINE+
    ( ANNOTATIONS_SECTION
        ANNOTATIONS_LINE+ )?
    ( H_CMT_LINE+ templateOverlay )*
    ;

templateOverlay:
    SYM_TEMPLATE_OVERLAY
        ALPHANUM_ID
    SPECIALIZE_SECTION
        ALPHANUM_ID
    DEFINITION_SECTION
        DEFINITION_LINE+
    TERMINOLOGY_SECTION
        TERMINOLOGY_LINE+
    ;

operationalTemplate:
    SYM_OPERATIONAL_TEMPLATE metaData?
        ALPHANUM_ID
    LANGUAGE_SECTION
        LANGUAGE_LINE+
    DESCRIPTION_SECTION
        DESCRIPTION_LINE+
    DEFINITION_SECTION
        DEFINITION_LINE+
    ( RULES_SECTION
        RULES_LINE+ )?
    TERMINOLOGY_SECTION
        TERMINOLOGY_LINE+
    ( ANNOTATIONS_SECTION
        ANNOTATIONS_LINE+ )?
    ( COMPONENT_TERMINOLOGIES_SECTION
        COMPONENT_TERMINOLOGIES_LINE+ )?
    ;

metaData: SYM_LPAREN metaDataItem (SYM_SEMI_COLON metaDataItem )* SYM_RPAREN ;

metaDataItem:
      SYM_ADL_VERSION SYM_EQUAL WS? ALPHANUM_ID
    | SYM_UID SYM_EQUAL WS? ALPHANUM_ID
    | SYM_BUILD_UID SYM_EQUAL WS? ALPHANUM_ID
    | SYM_RM_RELEASE SYM_EQUAL WS? ALPHANUM_ID
    | SYM_CONTROLLED
    | SYM_GENERATED
    | ALPHANUM_ID ( SYM_EQUAL WS? ALPHANUM_ID )?
    ;
