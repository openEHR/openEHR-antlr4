package org.openehr.cadlReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.openehr.combinedparser.*;
import org.openehr.common.SyntaxReader;

public class Cadl2Reader extends SyntaxReader<Cadl2Lexer, Cadl2Parser> {

    // -------------- Creation ------------------

    public Cadl2Reader(boolean logging, boolean keepAntlrErrors) {
        super (logging, keepAntlrErrors);
    }

    // -------------- Implementation ------------------

    protected void createLexerParser (CharStream stream) {
        lexer = new Cadl2Lexer (stream);
        parser = new Cadl2Parser (new CommonTokenStream (lexer));
    }

    protected void doParse() {
        // do the parse
        Cadl2Parser.CComplexObjectContext ccoObjectCtx = parser.cComplexObject();

        // don't bother with traversal if artefact not well-formed
        if (errors.hasNoErrors()) {
            ParseTreeWalker walker = new ParseTreeWalker();
            Cadl2ReaderListener reader =  new Cadl2ReaderListener();
            walker.walk (reader, ccoObjectCtx);
        }
    }
}
