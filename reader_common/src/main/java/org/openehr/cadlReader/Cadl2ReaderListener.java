// Generated from Cadl2Parser.g4 by ANTLR 4.9.2
package org.openehr.cadlReader;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.openehr.common.SyntaxUtils;
import org.openehr.odinReader.OdinReader;
import org.openehr.reader_common.Cadl2Parser;
import org.openehr.reader_common.Cadl2ParserBaseListener;
import org.openehr.reader_common.Cadl2ParserListener;

/**
 * This class provides an empty implementation of {@link Cadl2ParserListener},
 * which can be extended to create a listener which only needs to handle a subset
 * of the available methods.
 */
public class Cadl2ReaderListener extends Cadl2ParserBaseListener {
		public Cadl2ReaderListener(boolean logging, boolean keepAntlrErrors, Cadl2ReaderErrorCollector errorCollector, int lineOffset) {
		odinReader = new OdinReader (logging, keepAntlrErrors);
		this.errorCollector = errorCollector;
		this.lineOffset = lineOffset;
	}

	/**
	 * Enter a parse tree produced by {@link Cadl2Parser#cRootObject}.
	 * @param ctx the parse tree
	 */
	@Override public void enterCRootObject(Cadl2Parser.CRootObjectContext ctx) {}
	/**
	 * Exit a parse tree produced by {@link Cadl2Parser#cRootObject}.
	 * @param ctx the parse tree
	 */
	@Override public void exitCRootObject(Cadl2Parser.CRootObjectContext ctx) {}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterDefaultValue(Cadl2Parser.DefaultValueContext ctx) {
		// figure out if it's ODIN or something else - have to check serialBlock rule
		if (ctx.serialBlock().odinBlock() != null) {
			odinReader.read (SyntaxUtils.textToCharStream (ctx.serialBlock().odinBlock().ODIN_BLOCK_LINE()),
					Cadl2ReaderDefinitions.DEFAULT_BLOCK_NAME, ctx.DEFAULT_BLOCK_START().getSymbol().getLine() + lineOffset);
			errorCollector.setDefaultBlockErrors (odinReader.getErrors());
		}
		else if (ctx.serialBlock().otherSerialBlock() != null) {
			// TODO: figure out what syntax from ctx.DEFAULT_BLOCK_START()
			// TODO: get a reader for that syntax and consume
			// ctx.serialBlock().otherSerialBlock().SERIAL_BLOCK_LINE()
		}
		else {
			// TODO: should never arrive here
		}
	}

	/**
	 * Enter a parse tree produced by {@link Cadl2Parser#rmPathSegment}.
	 * @param ctx the parse tree
	 */
	@Override public void enterRmPathSegment(Cadl2Parser.RmPathSegmentContext ctx) {}
	/**
	 * Exit a parse tree produced by {@link Cadl2Parser#rmPathSegment}.
	 * @param ctx the parse tree
	 */
	@Override public void exitRmPathSegment(Cadl2Parser.RmPathSegmentContext ctx) {}

	// -------------- Implementation ------------------

	private final int lineOffset;

	private final OdinReader odinReader;

	private final Cadl2ReaderErrorCollector errorCollector;

}