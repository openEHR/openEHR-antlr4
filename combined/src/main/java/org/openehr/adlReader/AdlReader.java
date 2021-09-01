package org.openehr.adlReader;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.openehr.antlr.ANTLRParserErrors;
import org.openehr.antlr.IANTLRParserErrors;
import org.openehr.combinedparser.*;
import org.openehr.common.SyntaxReader;

public class AdlReader extends SyntaxReader<AdlLexer, AdlParser> {

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
        lexer = new AdlLexer (stream);
        parser = new AdlParser (new CommonTokenStream (lexer));
    }

    protected void doParse() {
        // set up the top-level Error collector
        errorCollector = new AdlReaderErrors();
        errorCollector.setAdlErrors (errors);

        // do the parse
        AdlParser.AdlObjectContext adlObjectCtx = parser.adlObject();

        // don't bother with second level parsing if artefact not well-formed
        if (errors.hasNoErrors()) {
            ParseTreeWalker walker = new ParseTreeWalker();
            AdlReaderListener reader =  new AdlReaderListener (logging, keepAntlrErrors, errorCollector);
            walker.walk (reader, adlObjectCtx);
        }
    }

    private AdlReaderErrors errorCollector;
}
