package org.openehr.elReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.openehr.combinedparser.*;
import org.openehr.common.SyntaxReader;

public class ElReader extends SyntaxReader<ElLexer, ElParser> {

    // ---------------------- Creation ----------------------

    public ElReader (boolean logging, boolean keepAntlrErrors) {
        super (logging, keepAntlrErrors);
    }

    // ---------------------- Implementation ----------------------

    protected void createLexerParser (CharStream stream) {
        lexer = new ElLexer (stream);
        parser = new ElParser (new CommonTokenStream (lexer));
    }

    protected void doParse() {
        ElParser.StatementBlockContext stmtBlock = parser.statementBlock();

        // don't bother with traversal if artefact not well-formed
        if (errors.hasNoErrors()) {
            ParseTreeWalker walker = new ParseTreeWalker();
            ElBaseListener reader =  new ElBaseListener();
            walker.walk (reader, stmtBlock);
        }
    }

}
