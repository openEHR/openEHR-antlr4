// Generated from AdlParser.g4 by ANTLR 4.9.2
package org.openehr.adlReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.openehr.cadlReader.CadlReader;
import org.openehr.combinedparser.AdlParser;
import org.openehr.combinedparser.AdlParserListener;
import org.openehr.elReader.ElReader;
import org.openehr.odinReader.OdinReader;

import java.util.List;

/**
 * This class provides an empty implementation of {@link AdlReaderListener},
 * which can be extended to create a listener which only needs to handle a subset
 * of the available methods.
 */
public class AdlReaderListener implements AdlParserListener {

	public AdlReaderListener (boolean logging, boolean keepAntlrErrors, AdlReaderErrors errorCollector) {
		odinReader = new OdinReader (logging, keepAntlrErrors);
		cadlReader = new CadlReader (logging, keepAntlrErrors);
		elReader = new ElReader (logging, keepAntlrErrors);
		this.errorCollector = errorCollector;
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterAdlObject(AdlParser.AdlObjectContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitAdlObject(AdlParser.AdlObjectContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterAuthoredArchetype(AdlParser.AuthoredArchetypeContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitAuthoredArchetype(AdlParser.AuthoredArchetypeContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterTemplate(AdlParser.TemplateContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitTemplate(AdlParser.TemplateContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterTemplateOverlay(AdlParser.TemplateOverlayContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitTemplateOverlay(AdlParser.TemplateOverlayContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterOperationalTemplate(AdlParser.OperationalTemplateContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitOperationalTemplate(AdlParser.OperationalTemplateContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterHeader(AdlParser.HeaderContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitHeader(AdlParser.HeaderContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaData(AdlParser.MetaDataContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaData(AdlParser.MetaDataContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaDataItem(AdlParser.MetaDataItemContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaDataItem(AdlParser.MetaDataItemContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaDataValueItem(AdlParser.MetaDataValueItemContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaDataValueItem(AdlParser.MetaDataValueItemContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaDataFlag(AdlParser.MetaDataFlagContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaDataFlag(AdlParser.MetaDataFlagContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaDataItemValue(AdlParser.MetaDataItemValueContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaDataItemValue(AdlParser.MetaDataItemValueContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterSpecializeSection (AdlParser.SpecializeSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitSpecializeSection (AdlParser.SpecializeSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterLanguageSection (AdlParser.LanguageSectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "language", ctx.LANGUAGE_HEADER().getSymbol().getLine());
		errorCollector.setLanguageErrors (odinReader.getErrors());

	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitLanguageSection (AdlParser.LanguageSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterDescriptionSection (AdlParser.DescriptionSectionContext ctx) {
		odinReader.read(textToCharStream (ctx.odinText().ODIN_LINE()), "description", ctx.DESCRIPTION_HEADER().getSymbol().getLine());
		errorCollector.setDescriptionErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitDescriptionSection (AdlParser.DescriptionSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterDefinitionSection (AdlParser.DefinitionSectionContext ctx) {
		cadlReader.read (textToCharStream (ctx.cadlText().CADL_LINE()), "definition", ctx.DEFINITION_HEADER().getSymbol().getLine());
		errorCollector.setDefinitionErrors (cadlReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitDefinitionSection (AdlParser.DefinitionSectionContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterRulesSection (AdlParser.RulesSectionContext ctx) {
		elReader.read (textToCharStream (ctx.elText().EL_LINE()), "el", ctx.RULES_HEADER().getSymbol().getLine());
		errorCollector.setRulesErrors (elReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitRulesSection (AdlParser.RulesSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterRmOverlaySection (AdlParser.RmOverlaySectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "rm_overlay", ctx.RM_OVERLAY_HEADER().getSymbol().getLine());
		errorCollector.setRmOverlayErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitRmOverlaySection (AdlParser.RmOverlaySectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterTerminologySection (AdlParser.TerminologySectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "terminology", ctx.TERMINOLOGY_HEADER().getSymbol().getLine());
		errorCollector.setTerminologyErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitTerminologySection (AdlParser.TerminologySectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterAnnotationsSection (AdlParser.AnnotationsSectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "annotations", ctx.ANNOTATIONS_HEADER().getSymbol().getLine());
		errorCollector.setAnnotationsErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitAnnotationsSection (AdlParser.AnnotationsSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterComponentTerminologiesSection (AdlParser.ComponentTerminologiesSectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "component_terminologies", ctx.COMPONENT_TERMINOLOGIES_HEADER().getSymbol().getLine());
		errorCollector.setAnnotationsErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitComponentTerminologiesSection (AdlParser.ComponentTerminologiesSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterOdinText(AdlParser.OdinTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitOdinText(AdlParser.OdinTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterCadlText(AdlParser.CadlTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitCadlText(AdlParser.CadlTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterElText(AdlParser.ElTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitElText(AdlParser.ElTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterEveryRule(ParserRuleContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitEveryRule(ParserRuleContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void visitTerminal(TerminalNode node) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void visitErrorNode(ErrorNode node) { }

	// -------------- Implementation ------------------
	/**
	 * Efficiently crunch a List<TerminalNode> containing lines of text
	 * into a single string
	 */
	private static CharStream textToCharStream (List<TerminalNode> nodeList) {
		StringBuilder sb = new StringBuilder(AdlReaderDefinitions.ADL_TEXT_SECTION_SIZE);
		for (TerminalNode node: nodeList)
			sb.append(node.getText());
		return CharStreams.fromString (sb.toString());
	}

	private final OdinReader odinReader;
	private final CadlReader cadlReader;
	private final ElReader elReader;

	private final AdlReaderErrors errorCollector;

}