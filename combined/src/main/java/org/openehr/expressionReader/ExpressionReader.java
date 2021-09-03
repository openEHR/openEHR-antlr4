package org.openehr.expressionReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.openehr.combinedparser.*;
import org.openehr.common.SyntaxReader;

public class ExpressionReader extends SyntaxReader<ExpressionLexer, ExpressionParser> {

    // ---------------------- Creation ----------------------

    public ExpressionReader(boolean logging, boolean keepAntlrErrors) {
        super (logging, keepAntlrErrors);
    }

    // ---------------------- Implementation ----------------------

    protected void createLexerParser (CharStream stream) {
        lexer = new ExpressionLexer (stream);
        parser = new ExpressionParser (new CommonTokenStream (lexer));
    }

    protected void doParse() {
        ExpressionParser.StatementBlockContext stmtBlock = parser.statementBlock();

        // don't bother with traversal if artefact not well-formed
        if (errors.hasNoErrors()) {
            ParseTreeWalker walker = new ParseTreeWalker();
            ExpressionParserBaseListener reader =  new ExpressionParserBaseListener();
            walker.walk (reader, stmtBlock);
        }
    }

}
