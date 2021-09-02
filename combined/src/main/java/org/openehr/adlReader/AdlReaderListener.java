// Generated from AdlParser.g4 by ANTLR 4.9.2
package org.openehr.adlReader;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.openehr.cadlReader.CadlReader;
import org.openehr.combinedparser.Adl2Parser;
import org.openehr.combinedparser.Adl2ParserListener;
import org.openehr.elReader.ElReader;
import org.openehr.odinReader.OdinReader;

import java.util.List;

/**
 * This class provides an empty implementation of {@link AdlReaderListener},
 * which can be extended to create a listener which only needs to handle a subset
 * of the available methods.
 */
public class AdlReaderListener implements Adl2ParserListener {

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
	@Override public void enterAdlObject(Adl2Parser.AdlObjectContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitAdlObject(Adl2Parser.AdlObjectContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterAuthoredArchetype(Adl2Parser.AuthoredArchetypeContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitAuthoredArchetype(Adl2Parser.AuthoredArchetypeContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterTemplate(Adl2Parser.TemplateContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitTemplate(Adl2Parser.TemplateContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterTemplateOverlay(Adl2Parser.TemplateOverlayContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitTemplateOverlay(Adl2Parser.TemplateOverlayContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterOperationalTemplate(Adl2Parser.OperationalTemplateContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitOperationalTemplate(Adl2Parser.OperationalTemplateContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterHeader(Adl2Parser.HeaderContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitHeader(Adl2Parser.HeaderContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaData(Adl2Parser.MetaDataContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaData(Adl2Parser.MetaDataContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaDataItem(Adl2Parser.MetaDataItemContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaDataItem(Adl2Parser.MetaDataItemContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaDataValueItem(Adl2Parser.MetaDataValueItemContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaDataValueItem(Adl2Parser.MetaDataValueItemContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaDataFlag(Adl2Parser.MetaDataFlagContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaDataFlag(Adl2Parser.MetaDataFlagContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterMetaDataItemValue(Adl2Parser.MetaDataItemValueContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitMetaDataItemValue(Adl2Parser.MetaDataItemValueContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterSpecializeSection (Adl2Parser.SpecializeSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitSpecializeSection (Adl2Parser.SpecializeSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterLanguageSection (Adl2Parser.LanguageSectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "language", ctx.LANGUAGE_HEADER().getSymbol().getLine());
		errorCollector.setLanguageErrors (odinReader.getErrors());

	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitLanguageSection (Adl2Parser.LanguageSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterDescriptionSection (Adl2Parser.DescriptionSectionContext ctx) {
		odinReader.read(textToCharStream (ctx.odinText().ODIN_LINE()), "description", ctx.DESCRIPTION_HEADER().getSymbol().getLine());
		errorCollector.setDescriptionErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitDescriptionSection (Adl2Parser.DescriptionSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterDefinitionSection (Adl2Parser.DefinitionSectionContext ctx) {
		cadlReader.read (textToCharStream (ctx.cadlText().CADL_LINE()), "definition", ctx.DEFINITION_HEADER().getSymbol().getLine());
		errorCollector.setDefinitionErrors (cadlReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitDefinitionSection (Adl2Parser.DefinitionSectionContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterRulesSection (Adl2Parser.RulesSectionContext ctx) {
		elReader.read (textToCharStream (ctx.elText().EL_LINE()), "el", ctx.RULES_HEADER().getSymbol().getLine());
		errorCollector.setRulesErrors (elReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitRulesSection (Adl2Parser.RulesSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterRmOverlaySection (Adl2Parser.RmOverlaySectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "rm_overlay", ctx.RM_OVERLAY_HEADER().getSymbol().getLine());
		errorCollector.setRmOverlayErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitRmOverlaySection (Adl2Parser.RmOverlaySectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterTerminologySection (Adl2Parser.TerminologySectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "terminology", ctx.TERMINOLOGY_HEADER().getSymbol().getLine());
		errorCollector.setTerminologyErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitTerminologySection (Adl2Parser.TerminologySectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterAnnotationsSection (Adl2Parser.AnnotationsSectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "annotations", ctx.ANNOTATIONS_HEADER().getSymbol().getLine());
		errorCollector.setAnnotationsErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitAnnotationsSection (Adl2Parser.AnnotationsSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterComponentTerminologiesSection (Adl2Parser.ComponentTerminologiesSectionContext ctx) {
		odinReader.read (textToCharStream (ctx.odinText().ODIN_LINE()), "component_terminologies", ctx.COMPONENT_TERMINOLOGIES_HEADER().getSymbol().getLine());
		errorCollector.setAnnotationsErrors (odinReader.getErrors());
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitComponentTerminologiesSection (Adl2Parser.ComponentTerminologiesSectionContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterOdinText(Adl2Parser.OdinTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitOdinText(Adl2Parser.OdinTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterCadlText(Adl2Parser.CadlTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitCadlText(Adl2Parser.CadlTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterElText(Adl2Parser.ElTextContext ctx) { }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitElText(Adl2Parser.ElTextContext ctx) { }

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