package org.openehr.cadlReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.openehr.antlr.ANTLRParserErrors;
import org.openehr.antlr.ArchieErrorListener;
import org.openehr.combinedparser.*;
import org.openehr.common.SyntaxReader;

public class CadlReader extends SyntaxReader<CadlLexer, CadlParser> {

    // -------------- Creation ------------------

    public CadlReader (boolean logging, boolean keepAntlrErrors) {
        super (logging, keepAntlrErrors);
    }

    // -------------- Implementation ------------------

    protected void createLexerParser (CharStream stream) {
        lexer = new CadlLexer (stream);
        parser = new CadlParser (new CommonTokenStream (lexer));
    }

    protected void doParse() {
        CadlParser.CComplexObjectContext ccoObjectCtx = parser.cComplexObject();
    }

}
