package org.openehr.cadlReader;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.openehr.antlr.ANTLRParserErrors;
import org.openehr.antlr.ArchieErrorListener;
import org.openehr.combinedparser.CadlLexer;
import org.openehr.combinedparser.CadlParser;
import org.openehr.combinedparser.OdinLexer;
import org.openehr.combinedparser.OdinParser;

public class CadlReader {

    //
    // -------------- Creation ------------------
    //
    public CadlReader(boolean logging, boolean keepAntlrErrors) {
        this.logging = logging;
        this.keepAntlrErrors = keepAntlrErrors;
    }

    //
    // -------------- Procedures ------------------
    //
    /**
     * Read an archetype, with a locally created error listener
     * @param text ODIN text
     * TODO: need to make this stream based, or add stream-based overloads
     */
    public void readCadl (String text, String tag) {
        // set up error listener
        errors = new ANTLRParserErrors ();
        ArchieErrorListener errorListener = new ArchieErrorListener (errors, tag);
        errorListener.setLogEnabled (logging);

        // Create an ADL lexer and parser and add error listener
        CadlLexer lexer = new CadlLexer (CharStreams.fromString (text));
        if (!keepAntlrErrors)
            lexer.removeErrorListeners();
        lexer.addErrorListener (errorListener);

        CadlParser parser = new CadlParser(new CommonTokenStream (lexer));
        if (!keepAntlrErrors)
            parser.removeErrorListeners();
        parser.addErrorListener (errorListener);

        // look at the parse structure
        CadlParser.CComplexObjectContext ccoObjectCtx = parser.cComplexObject();
    }

    //
    // -------------- Access ------------------
    //
    public ANTLRParserErrors getErrors() {
        return errors;
    }

    //
    // -------------- Implementation ------------------
    //
    private ANTLRParserErrors errors;
    private boolean logging;
    private boolean keepAntlrErrors;

}
