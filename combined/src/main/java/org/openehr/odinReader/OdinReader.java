package org.openehr.odinReader;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.openehr.adlReader.AdlReaderDefinitions;
import org.openehr.antlr.ANTLRParserErrors;
import org.openehr.antlr.ArchieErrorListener;
import org.openehr.combinedparser.*;
import org.openehr.common.SyntaxReader;

import java.util.List;

public class OdinReader extends SyntaxReader<OdinLexer, OdinParser> {

    // -------------- Creation ------------------

    public OdinReader (boolean logging, boolean keepAntlrErrors) {
        super (logging, keepAntlrErrors);
    }

    // -------------- Implementation ------------------

    protected void createLexerParser (CharStream stream) {
        lexer = new OdinLexer(stream);
        parser = new OdinParser(new CommonTokenStream (lexer));
    }

    protected void doParse() {
        OdinParser.OdinObjectContext odinObjectCtx = parser.odinObject();

        // don't bother with traversal if artefact not well-formed
        if (errors.hasNoErrors()) {
            ParseTreeWalker walker = new ParseTreeWalker();
            OdinParserBaseListener reader =  new OdinParserBaseListener();
            walker.walk (reader, odinObjectCtx);
        }
    }
}
