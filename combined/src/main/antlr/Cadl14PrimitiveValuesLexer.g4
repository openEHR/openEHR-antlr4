//
// description: Antlr4 grammar for cADL primitives, used within Cadl1.4 grammar, but also by
//              other languages that allow constraints on primitive objects. This has to include
//              other relevant Lexer grammars in the correct order, in order to generate a
//              correct total tokens file for use by the parser grammar.
// author:      Thomas Beale <thomas.beale@openehr.org>
// contributors:Pieter Bos <pieter.bos@nedap.com>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation <http://www.openEHR.org>
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

lexer grammar Cadl14PrimitiveValuesLexer;
import Cadl2PrimitiveValuesLexer, OpenehrPatterns, PrimitiveValuesLexer;

// -------------------- Symbols ------------------------

