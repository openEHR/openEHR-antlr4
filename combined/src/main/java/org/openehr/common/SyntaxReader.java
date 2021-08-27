package org.openehr.common;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.Parser;
import org.openehr.antlr.ANTLRParserErrors;
import org.openehr.antlr.ArchieErrorListener;

public abstract class SyntaxReader<L extends Lexer, P extends Parser> {

    // ---------------------- Creation ----------------------

    public SyntaxReader (boolean logging, boolean keepAntlrErrors) {
        this.logging = logging;
        this.keepAntlrErrors = keepAntlrErrors;
    }

    // ---------------------- Commands ----------------------

    /**
     * Read an archetype, with a locally created error listener
     * @param textStream source text
     * TODO: need to make this stream based, or add stream-based overloads
     */
    public void read (CharStream textStream, String tag) {
        // set up error listener
        errors = new ANTLRParserErrors ();
        ArchieErrorListener errorListener = new ArchieErrorListener (errors, tag);
        errorListener.setLogEnabled (logging);

        // Create lexer and parser
        createLexerParser (textStream) ;

        // hook up error listeners
        if (!keepAntlrErrors)
            lexer.removeErrorListeners();
        lexer.addErrorListener (errorListener);
        if (!keepAntlrErrors)
            parser.removeErrorListeners();
        parser.addErrorListener (errorListener);

        // do any specific processing of the parse result
        doParse();
    }

    // ---------------------- Access ----------------------

    public ANTLRParserErrors getErrors() {
        return errors;
    }

    // ---------------------- Implementation ----------------------

    // template routine for descendants to implement
    protected abstract void createLexerParser (CharStream textStream) ;

    // template routine for Parser-specific processing
    protected abstract void doParse() ;

    protected ANTLRParserErrors errors;
    protected final boolean logging;
    protected final boolean keepAntlrErrors;

    protected L lexer;
    protected P parser;
}
