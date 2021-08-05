//
// description: Antlr4 grammar for consuming Object Data Instance Notation (ODIN) text
//              for proper parsing later
// author:      Thomas Beale <thomas.beale@openehr.org>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2021- openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

lexer grammar OdinLexer;
import PrimitiveValuesLexer, BaseLexer;


// ---------- lines and comments ----------
CMT_LINE   : '--' .*? EOL -> skip ;             // increment line count
EOL        : '\r'? '\n'   -> channel(HIDDEN) ;  // increment line count
WS         : [ \t\r]+     -> channel(HIDDEN) ;

// -------------------- symbols for lists ------------------------
SYM_LIST_CONTINUE: '...' ;

// ------------------ symbols  ----------------------
SYM_EQ : '=' ;

// -------------------- ODIN paths ------------------------
ODIN_PATH : ODIN_PATH_PREDICATE? ODIN_PATH_SEGMENT+ ;
fragment ODIN_PATH_SEGMENT: '/' ALPHA_LC_ID ODIN_PATH_PREDICATE? ;
fragment ODIN_PATH_PREDICATE: '[' .+? ']' ;
