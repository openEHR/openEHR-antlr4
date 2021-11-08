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

lexer grammar Cadl14Lexer;
import OpenehrPatterns, Cadl14PrimitiveValuesLexer, OdinLexer, GeneralLexer;

channels {
    COMMENT
}

// ------------------ lines and comments ------------------
CMT_LINE : '--' .*? EOL -> channel(COMMENT) ;
EOL      : '\r'? '\n'   -> channel(HIDDEN) ;
WS       : [ \t\r]+     -> channel(HIDDEN) ;

// ----------------------- keywords -----------------------
SYM_EXISTENCE   : 'existence' ;
SYM_OCCURRENCES : 'occurrences' ;
SYM_CARDINALITY : 'cardinality' ;
SYM_ORDERED     : 'ordered' ;
SYM_UNORDERED   : 'unordered' ;
SYM_UNIQUE      : 'unique' ;
SYM_USE_NODE    : 'use_node' ;
SYM_USE_ARCHETYPE : 'use_archetype' ;
SYM_ALLOW_ARCHETYPE : 'allow_archetype' ;
SYM_INCLUDE     : 'include' ;
SYM_EXCLUDE     : 'exclude' ;
SYM_CLOSED      : 'closed' ;

// --------------------- general symbols ------------------------
SYM_MATCHES  : 'matches' | 'is_in' | '∈' ;
SYM_ASTERISK  : '*' ;
SYM_LE : '<=' | '≤' ;
SYM_GE : '>=' | '≥' ;
SYM_GT : '>' ;
SYM_LT : '<' ;
SYM_SLASH: '/' ;

// ------------------ symbols for intervals ---------------------
SYM_IVL_DELIM: '|' ;
SYM_IVL_SEP  : '..' ;

