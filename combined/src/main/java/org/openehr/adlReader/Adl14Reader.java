package org.openehr.adlReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.openehr.antlr.IANTLRParserErrors;
import org.openehr.combinedparser.Adl14Lexer;
import org.openehr.combinedparser.Adl14Parser;
import org.openehr.common.SyntaxReader;

public class Adl14Reader extends SyntaxReader<Adl14Lexer, Adl14Parser> {

    // ---------------------- Creation ----------------------

    public Adl14Reader(boolean logging, boolean keepAntlrErrors) {
        super (logging, keepAntlrErrors);
    }

    // ---------------------- Access ----------------------

    public IANTLRParserErrors getErrors() {
        return errorCollector;
    }

    public Adl2ReaderErrorCollector getErrorCollector() {
        return errorCollector;
    }

    // ---------------------- Implementation ----------------------

    protected void createLexerParser (CharStream stream) {
        lexer = new Adl14Lexer (stream);
        parser = new Adl14Parser(new CommonTokenStream (lexer));
    }

    protected void doParse (int lineOffset) {
        // set up the top-level Error collector
        errorCollector = new Adl2ReaderErrorCollector();
        errorCollector.setAdlErrors (errors);

        // do the parse
        Adl14Parser.AdlObjectContext adlObjectCtx = parser.adlObject();

        // enter second level parsing if artefact well-formed
        if (errors.hasNoErrors()) {
            ParseTreeWalker walker = new ParseTreeWalker();
            Adl14ReaderListener reader =  new Adl14ReaderListener (logging, keepAntlrErrors, errorCollector, lineOffset);
            walker.walk (reader, adlObjectCtx);
        }
    }

    private Adl2ReaderErrorCollector errorCollector;
}
