//
//  General purpose patterns used in all openEHR parser and lexer tools
//  author:      Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2018- openEHR Foundation <http://www.openEHR.org>
//

grammar basePatterns;
import baseLexer;


rmTypeId      : ALPHA_UC_ID ( '<' rmTypeId ( ',' rmTypeId )* '>' )? ;
rmAttributeId : ALPHA_LC_ID ;
identifier    : ALPHA_UC_ID | ALPHA_LC_ID ;



