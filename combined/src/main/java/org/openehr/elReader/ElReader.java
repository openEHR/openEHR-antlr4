package org.openehr.elReader;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.openehr.combinedparser.ElLexer;
import org.openehr.combinedparser.ElParser;

public class ElReader {
    
    public ElReader() {
    }

    public void readExpression(String adlText) {
        // Create an EL lexer and parser and get top-level context
        ElLexer elLexer = new ElLexer(CharStreams.fromString(adlText));
        ElParser elParser = new ElParser(new CommonTokenStream(elLexer));
        ElParser.StatementBlockContext stmtBlockCtx = elParser.statementBlock();

    }


}
