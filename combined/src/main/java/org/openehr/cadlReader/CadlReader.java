package org.openehr.cadlReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.openehr.adlReader.AdlReaderListener;
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
        // do the parse
        CadlParser.CComplexObjectContext ccoObjectCtx = parser.cComplexObject();

        // don't bother with traversal if artefact not well-formed
        if (errors.hasNoErrors()) {
            ParseTreeWalker walker = new ParseTreeWalker();
            CadlParserBaseListener reader =  new CadlParserBaseListener();
            walker.walk (reader, ccoObjectCtx);
        }
    }
}
