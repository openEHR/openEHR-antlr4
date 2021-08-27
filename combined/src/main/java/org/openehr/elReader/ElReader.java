package org.openehr.elReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.openehr.combinedparser.CadlLexer;
import org.openehr.combinedparser.CadlParser;
import org.openehr.combinedparser.ElLexer;
import org.openehr.combinedparser.ElParser;
import org.openehr.common.SyntaxReader;

public class ElReader extends SyntaxReader<ElLexer, ElParser> {
    
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
    }

}
