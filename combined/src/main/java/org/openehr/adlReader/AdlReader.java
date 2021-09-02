package org.openehr.adlReader;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.openehr.antlr.IANTLRParserErrors;
import org.openehr.combinedparser.*;
import org.openehr.common.SyntaxReader;

public class AdlReader extends SyntaxReader<Adl2Lexer, Adl2Parser> {

    // ---------------------- Creation ----------------------

    public AdlReader (boolean logging, boolean keepAntlrErrors) {
        super (logging, keepAntlrErrors);
    }

    // ---------------------- Access ----------------------

    public IANTLRParserErrors getErrors() {
        return errorCollector;
    }

    public AdlReaderErrors getErrorCollector() {
        return errorCollector;
    }

    // ---------------------- Implementation ----------------------

    protected void createLexerParser (CharStream stream) {
        lexer = new Adl2Lexer (stream);
        parser = new Adl2Parser(new CommonTokenStream (lexer));
    }

    protected void doParse() {
        // set up the top-level Error collector
        errorCollector = new AdlReaderErrors();
        errorCollector.setAdlErrors (errors);

        // do the parse
        Adl2Parser.AdlObjectContext adlObjectCtx = parser.adlObject();

        // don't bother with second level parsing if artefact not well-formed
        if (errors.hasNoErrors()) {
            ParseTreeWalker walker = new ParseTreeWalker();
            AdlReaderListener reader =  new AdlReaderListener (logging, keepAntlrErrors, errorCollector);
            walker.walk (reader, adlObjectCtx);
        }
    }

    private AdlReaderErrors errorCollector;
}
