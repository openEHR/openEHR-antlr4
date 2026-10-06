//
// description: Antlr4 grammar for cADL non-primitves sub-syntax of Archetype Definition Language (ADL2).
//              This has to include
//              other relevant Lexer grammars in the correct order, in order to generate a
//              correct total tokens file for use by the parser grammar.
// author:      Thomas Beale <thomas.beale@openehr.org>
// contributors:Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

lexer grammar BmmlLexer;
import ElLexer, PrimitiveTypesLexer, GeneralIdsLexer;

channels {
    COMMENT, NOTICE
}

// ------------------ lines and comments ------------------
// See ElLexer for block comments; ; the NOTICE channel
// receives only header comments at the top of a file, usually containing
// meta-data items like author, license, support URL etc

//
// Block comment line containing header comments at the top of a file, usually containing
// meta-data items like author, license, support URL etc.
// looks like this.
//
// +------------------ (at least 4 dashes)
// |
// |
// +------------------
//
// Note that we soak up the whitespace to keep the indent if there is one
//
NOTICE_CMT_START : '+----------' '-'* [ \t\r]* '\r'? '\n' -> channel(NOTICE), pushMode(IN_NOTICE) ;

// BMM style block comments using vertical bars
// Any empty comment line starts the block comment.
BLOCK_CMT_START : [ \t\r]* '|' [ \t\r]* '\r'? '\n' -> channel(COMMENT), pushMode(BLOCK_COMMENT) ;

EOL      : '\r'? '\n'  -> channel(HIDDEN) ;
WS       : [ \t\r]+    -> channel(HIDDEN) ;

// ----------------------- keywords -----------------------
SYM_CLASS     : 'class' ;
SYM_ENUMERATION: 'enumeration' ;

SYM_IMPORT    : 'import' ;

SYM_ABSTRACT  : 'abstract' ;
SYM_INHERIT   : 'is_a' ;
SYM_BASE_TYPE : 'base_type' ;

SYM_CONSTANT  : 'const' ;
SYM_SINGLETON : 'singleton' ;
SYM_PROPERTY  : 'prop' ;
SYM_REF       : 'ref' ;

SYM_FUNCTION  : 'func' ;
SYM_PROCEDURE : 'proc' ;

SYM_ALIAS     : 'alias' ;
SYM_DEFERRED  : 'deferred' ;

SYM_PRECOND   : 'pre_cond' ;
SYM_POSTCOND  : 'post_cond' ;

SYM_BUILTIN   : 'builtin' ;
SYM_DO        : 'do' ;

SYM_FEATURE_GROUP : 'feature_group' ;

SYM_INVARIANT : 'invariant' ;
SYM_END       : 'end' ;

SYM_NULLABLE_TYPE_DECL: ':?' ;


// ----------------- MODE: IN_NOTICE --------------------
mode IN_NOTICE ;
NOTICE_CMT_END : '+----------' '-'* '\r'? '\n' -> channel(NOTICE), popMode ;
NOTICE_CMT_LINE : '|' [ \t] ~[\r\n]* '\r'? '\n' -> channel(NOTICE) ;

// ----------------- MODE: BLOCK_COMMENT --------------------
mode BLOCK_COMMENT ;

// Block comment line containing content; assumed to be Asciidoc / markdown
// We detect it by looking for a newline to the left, i.e. the bar character
// has to be the first non-white space char on the line. The block main contain
// empty comment lines; we exit when we hit anything that is not a '| at the
// start of a line (ignoring leading white space).
BLOCK_CMT_LINE : '|' [ \t] ~[\r\n]+ '\r'? '\n' -> channel(COMMENT) ;
BLOCK_CMT_LINE_EMPTY : '|' [ \t\r]* '\r'? '\n' -> channel(COMMENT) ;
// get rid of any leading white space
BLOCK_CMT_WS     : [ \t\r]+ -> channel(HIDDEN) ;
// If we match this rule, nothing else could match, and we return.
EXIT: {} -> skip, popMode ;

// The following rule should work to terminate, but doesn't - it appears that
// the lexer starts matching the next token on the basis of the characters
// *following* the one matched here. E.g. if here we match the 'a' of 'abstract'
// the next matching attempt will only be matching on 'bstract', so it won't
// match a keyword matching rule for 'abstract'. But when it does match a rule -
// most likely an identifier (LC_ID, for example), it returns that token,
// but with the full text 'abstract'. Because of this, we muse the trick above
// instead - a rule matching nothing, which acts as an else statement.
//
//OTHER    : . -> more, popMode ;
