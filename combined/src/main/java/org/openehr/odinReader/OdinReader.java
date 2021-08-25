package org.openehr.odinReader;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.openehr.adlReader.AdlReaderDefinitions;
import org.openehr.antlr.ANTLRParserErrors;
import org.openehr.antlr.ArchieErrorListener;
import org.openehr.combinedparser.*;

import java.util.List;

public class OdinReader {

    //
    // -------------- Creation ------------------
    //
    public OdinReader(boolean logging, boolean keepAntlrErrors) {
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
    public void readOdin (String text, String tag) {
        // set up error listener
        errors = new ANTLRParserErrors ();
        ArchieErrorListener errorListener = new ArchieErrorListener (errors, tag);
        errorListener.setLogEnabled (logging);

        // Create an ADL lexer and parser and add error listener
        OdinLexer lexer = new OdinLexer (CharStreams.fromString (text));
        if (!keepAntlrErrors)
            lexer.removeErrorListeners();
        lexer.addErrorListener (errorListener);

        OdinParser parser = new OdinParser (new CommonTokenStream (lexer));
        if (!keepAntlrErrors)
            parser.removeErrorListeners();
        parser.addErrorListener (errorListener);

        // look at the parse structure
        OdinParser.OdinObjectContext odinObjectCtx = parser.odinObject();
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
