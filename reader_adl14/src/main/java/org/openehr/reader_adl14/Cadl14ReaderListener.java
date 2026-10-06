// Generated from Cadl14Parser.g4 by ANTLR 4.9.2
package org.openehr.reader_adl14;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.openehr.parser_adl14.Cadl14Parser;
import org.openehr.parser_adl14.Cadl14ParserBaseListener;
import org.openehr.parser_adl14.Cadl14ParserListener;
import org.openehr.common.SyntaxUtils;
import org.openehr.odinReader.OdinReader;

import java.util.ArrayList;
import java.util.List;

/**
 * This class provides an empty implementation of {@link Cadl14ParserListener},
 * which can be extended to create a listener which only needs to handle a subset
 * of the available methods.
 */
public class Cadl14ReaderListener extends Cadl14ParserBaseListener {

	public Cadl14ReaderListener (boolean logging, boolean keepAntlrErrors, Cadl14ReaderErrorCollector errorCollector, int lineOffset) {
		odinReader = new OdinReader(logging, keepAntlrErrors);
		this.errorCollector = errorCollector;
		this.lineOffset = lineOffset;
	}


	/**
	 * Enter a parse tree produced by {@link Cadl14Parser#domainSpecificExtension}.
	 * @param ctx the parse tree
	 */
	@Override public void enterDomainSpecificExtension(Cadl14Parser.DomainSpecificExtensionContext ctx) {
		// concatenate the DEFAULT_BLOCK_START and odinBlock.ODIN_BLOCK_LINEs from the parser
		List<TerminalNode> odinNodes = new ArrayList<>();

		odinNodes.add(ctx.ODIN14_BLOCK_START());
		odinNodes.addAll(ctx.ODIN14_BLOCK_LINE());
		odinReader.read (SyntaxUtils.textToCharStream (odinNodes),
				Cadl14ReaderDefinitions.EMBEDDED_ODIN_BLOCK_NAME, ctx.ODIN14_BLOCK_START().getSymbol().getLine() + lineOffset);
		errorCollector.setDefaultBlockErrors (odinReader.getErrors());
	}

	/**
	 * Exit a parse tree produced by {@link Cadl14Parser#domainSpecificExtension}.
	 * @param ctx the parse tree
	 */
	@Override public void exitDomainSpecificExtension(Cadl14Parser.DomainSpecificExtensionContext ctx) {}

	// -------------- Implementation ------------------

	private final int lineOffset;

	private final OdinReader odinReader;

	private final Cadl14ReaderErrorCollector errorCollector;
}