//
//  description: Antlr4 grammar for openEHR BMM Language based on BMM meta-model.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

parser grammar BmmlParser;
options { tokenVocab=BmmlLexer; }
import ElParser;


// ========================== BMML Classes ==========================

bmmModuleDef: noticeBlock? bmmModuleImport* bmmModuleDecl SYM_END EOF ;

noticeBlock: NOTICE_CMT_START NOTICE_CMT_LINE+ NOTICE_CMT_END ;

bmmModuleImport: SYM_IMPORT bmmModuleImportId ';' ;

bmmModuleImportId: namespaceId ':' bmmModelComponent ;

bmmModelComponent: LC_ID ;

bmmModuleDecl: bmmClassDecl | bmmEnumDecl ;

bmmClassDecl: SYM_ABSTRACT? SYM_BUILTIN? SYM_CLASS classNameDecl bmmClassInheritDecl? bmmFeatureGroup* bmmInvariantDecl? ;

bmmClassInheritDecl: SYM_INHERIT typeId ( ',' typeId )* ;

bmmEnumDecl: SYM_ENUMERATION classNameDecl bmmEnumBaseDecl bmmEnumValueGroup ;

bmmEnumBaseDecl: SYM_BASE_TYPE simpleTypeId ;

// -------------------- enumerations -----------------------

bmmEnumValueGroup: bmmFeatureGroupDecl bmmEnumValueDecl+ ;

bmmEnumValueDecl: ( bmmEnumIntegerValueDecl | bmmEnumStringValueDecl ) ';' ;

bmmEnumIntegerValueDecl: bmmVarId '(' INTEGER ')' ;

bmmEnumStringValueDecl: bmmVarId '(' STRING ')' ;

// -------------------- constants, singletons, properties -------------------

bmmFeatureGroup: bmmFeatureGroupDecl ( bmmFeatureDecl ';' )+ ;

bmmFeatureGroupDecl: SYM_FEATURE_GROUP '(' STRING ')' ;

bmmFeatureDecl: bmmConstantDecl | bmmSingletonDecl | bmmPropertyDecl | bmmRoutineDecl ;

//
// A constant declaration consists of a type declaration and an assignment that sets
// its value, e.g.
//
//    Max_speed: Quantity = Quantity (100, 'km/h') ;
//
bmmConstantDecl: SYM_CONSTANT bmmStaticId ':' typeId SYM_EQ elExpression ;

//
// A singleton declaration consists of a type declaration and a do-block.
//
bmmSingletonDecl: SYM_SINGLETON bmmStaticId ':' typeId bmmStatementBlock? ;

//
// Properties are nullable. A property declaration consists of a type declaration and
// optionally an assignment that sets its initial value, e.g.
//
//    is_built: Boolean := false ;
//
bmmPropertyDecl: (SYM_REF | SYM_PROPERTY) bmmFeatureName ( ':' | ':?' ) typeId ( SYM_ASSIGNMENT elExpression )? ;

// ------------------------------ routines -----------------------------------

bmmRoutineDecl: SYM_ABSTRACT? ( bmmProcedureDecl | bmmFunctionDecl )  ;

bmmProcedureDecl: SYM_PROCEDURE bmmFeatureName bmmParamsDecl? bmmRoutineBody?;

bmmFunctionDecl: SYM_FUNCTION bmmFeatureName bmmParamsDecl? ':' typeId bmmAliasBlock? ( bmmRoutineBody | bmmFunctionExpr )? ;

bmmRoutineBody: bmmPrecondBlock? bmmStatementBlock? bmmPostcondBlock? ;

bmmFunctionExpr: SYM_EQ elExpression ;

// Re-use a form of LC_ID that has some keywords allowed as well; plus we allow others defined
// only in BmmLexer
bmmFeatureName: elLcId | SYM_ALIAS;

// nullable args not allowed - use overloads
bmmParamsDecl: '(' bmmParamDecl ( ',' bmmParamDecl )* ')' ;
bmmParamDecl: bmmVarId ':' ( typeId | functionalTypeId ) ;

bmmAliasBlock: SYM_ALIAS bmmAliasId ( ',' bmmAliasId )* ';' ;
bmmAliasId: STRING ;

bmmPrecondBlock: SYM_PRECOND bmmRoutineAssertion+ ;
bmmPostcondBlock: SYM_POSTCOND bmmRoutineAssertion+ ;

//
// Functional type ids have the same form. For a procedure, use
// 'Unit' as the return type. Currently at least one arg expected.
// Examples:
//
// func taking the generic param type and returning Boolean:
//      (v: T) -> Boolean
//
// func taking a String and an Integer argument and returning String:
//      (valStr: String, valInt: Integer) -> String
//
// proc taking a String argument:
//      (v: String) -> Unit
//
functionalTypeId: '(' functionalParamTypeId ( ',' functionalParamTypeId )* ')' SYM_ARROW functionalResultTypeId;

functionalParamTypeId: typeId;

functionalResultTypeId: typeId;

// ------------------------------ Identifiers ----------------------------------

bmmVarId: LC_ID ;
bmmStaticId: UC_ID ;

classNameDecl: simpleTypeName classGenParmsDecl? ;
classGenParmsDecl: '<' classGenParmDecl ( ',' classGenParmDecl )* '>' ;
classGenParmDecl: simpleTypeName ( ':' typeId )? ;

// ------------------------------ invariants -----------------------------------

bmmInvariantDecl: SYM_INVARIANT bmmClassAssertion+ ;


// ------------------------------ Statements -----------------------------------

bmmStatementBlock: SYM_DO bmmStatement+ ;

// elRoutineCall corresponds to a procedure call
bmmStatement: bmmVariableDecl | bmmAssignment | bmmProcedureCall | bmmAssertionStatement ;

bmmVariableDecl: elInstantiableRef ':' typeId ( SYM_ASSIGNMENT elExpression )? ';' ;

bmmAssignment: elValueGenerator SYM_ASSIGNMENT elExpression ';' ;

//
// Procedure calls: Build a BmmProcedureCall object
//
bmmProcedureCall: LC_ID '(' elArgsList? ')' ;

//
// A routine assertion is parsed as a parameter-less Boolean-returning function
// consisting of just one Boolean-valued expression.
// So we don't declare the return Type, nor do we use the 'do' keyword, or allow
// any pre- or post-conditions. Creates a BmmRoutineAssertion
//
bmmRoutineAssertion: LC_ID ':' elExpression ';' ;

//
// A class assertion is parsed as a parameter-less Boolean-returning function
// consisting of just one Boolean-valued expression.
// We don't declare the return Type, nor do we use the 'do' keyword, or allow
// any pre- or post-conditions. Creates a BmmFunction.
//
bmmClassAssertion: LC_ID ':' elExpression ';' ;

//
// An assertion statement is a wrapper of an Assertion expression that when executed
// will cause an exception if it fails, and may generate a message.
//
bmmAssertionStatement: SYM_ASSERT '(' elExpression ',' bmmAssertionMessage ')' ;

bmmAssertionMessage: STRING ;
