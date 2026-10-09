//
//  Path patterns lexer
//  author:      Thomas Beale <thomas.beale@openEHR.org>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2021- openEHR Foundation <http://www.openEHR.org>
//

parser grammar AdlPathParser;
options { tokenVocab=AdlPathLexer; }

//
// ADL paths can be recognised at lexer level, or this parser. The lexer is
// useful for matching pathsin legacy archetypes, where they are allowed inline
// in expressions, where the '/' character is also allowed. This parser can then
// be used on the matched string.
//
// This parser can also be used directly in contexts where paths appearing inline
// causes no ambiguity.
//
// Match a path to a node in an archetype, which will potentially match
// one or more data items in runtime data
//
adlPath: adlPathSegment+ ;
adlPathSegment : '/' attributeId=LC_ID ( '[' adlPathPredicate ']' )? ;

adlPathPredicate:
      archetypeIdPredicate=ARCHETYPE_REF
    | idCode
    ;

idCode:
      AT_CODE
    | ADL14_AT_CODE
    | ID_CODE
    ;

//
// A path within a type defined in the underlying reference model
//
rmRelPath: varName=LC_ID rmPathSegment+ ;
rmPathSegment: '/' attributeId=LC_ID ;
