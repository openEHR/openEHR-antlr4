package org.openehr.cadlReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.openehr.combinedparser.Cadl14Lexer;
import org.openehr.combinedparser.Cadl14Parser;
import org.openehr.combinedparser.Cadl2Lexer;
import org.openehr.combinedparser.Cadl2Parser;
import org.openehr.common.SyntaxReader;

public class Cadl14Reader extends SyntaxReader<Cadl14Lexer, Cadl14Parser> {

    // -------------- Creation ------------------

    public Cadl14Reader(boolean logging, boolean keepAntlrErrors) {
        super (logging, keepAntlrErrors);
    }

    // -------------- Implementation ------------------

    protected void createLexerParser (CharStream stream) {
        lexer = new Cadl14Lexer (stream);
        parser = new Cadl14Parser (new CommonTokenStream (lexer));
    }

    protected void doParse() {
        // do the parse
        Cadl14Parser.CComplexObjectContext ccoObjectCtx = parser.cComplexObject();

        // don't bother with traversal if artefact not well-formed
        if (errors.hasNoErrors()) {
            ParseTreeWalker walker = new ParseTreeWalker();
            Cadl14ReaderListener reader =  new Cadl14ReaderListener();
            walker.walk (reader, ccoObjectCtx);
        }
    }
}
