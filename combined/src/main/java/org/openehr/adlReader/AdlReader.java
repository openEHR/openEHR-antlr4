package org.openehr.adlReader;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.openehr.cadlReader.CadlReader;
import org.openehr.combinedparser.*;
import org.openehr.common.SyntaxReader;
import org.openehr.elReader.ElReader;
import org.openehr.odinReader.OdinReader;

import java.util.List;

public class AdlReader extends SyntaxReader<AdlLexer, AdlParser> {

    // ------------------ Creation ----------------------

    public AdlReader (boolean logging, boolean keepAntlrErrors) {
        super (logging, keepAntlrErrors);
        odinReader = new OdinReader (logging, keepAntlrErrors);
        cadlReader = new CadlReader (logging, keepAntlrErrors);
        elReader = new ElReader (logging, keepAntlrErrors);
    }


    // ---------------------- Access ----------------------

    public AdlReaderErrors getErrorCollector() {
        return errorCollector;
    }

    // -------------- Implementation ------------------

    protected void createLexerParser (CharStream stream) {
        lexer = new AdlLexer (stream);
        parser = new AdlParser (new CommonTokenStream (lexer));
    }

    protected void doParse() {
        // set up the top-level Error collector
        errorCollector = new AdlReaderErrors();
        errorCollector.setAdlErrors (errors);

        // do the parse
        AdlParser.AdlObjectContext adlObjectCtx = parser.adlObject();

        // don't bother with second level parsing if artefact not well-formed
        if (errors.hasNoErrors()) {
            for (ParserRuleContext ruleContext : adlObjectCtx.getRuleContexts(ParserRuleContext.class)) {
                if (ruleContext instanceof AdlParser.AuthoredArchetypeContext)
                    readAuthoredArchetype((AdlParser.AuthoredArchetypeContext) ruleContext);

                else if (ruleContext instanceof AdlParser.TemplateContext)
                    readTemplate((AdlParser.TemplateContext) ruleContext);

                else if (ruleContext instanceof AdlParser.TemplateOverlayContext)
                    readTemplateOverlay((AdlParser.TemplateOverlayContext) ruleContext);

                else if (ruleContext instanceof AdlParser.OperationalTemplateContext)
                    readOperationalTemplate((AdlParser.OperationalTemplateContext) ruleContext);

                else
                    throw new RuntimeException("no valid ADL artefact found");
            }
        }
    }

    private void readAuthoredArchetype (AdlParser.AuthoredArchetypeContext archCtx) {
        // Header (part of top-level parse)
        AdlParser.HeaderContext header = archCtx.header();
        readMetaData (header.metaData());

        // Specialise section (part of top-level parse)  [0..1]
        AdlParser.SpecializeSectionContext specSectionCtx = archCtx.specializeSection();
        if (specSectionCtx != null) {

        }

        // Language section: ODIN [1]
        AdlParser.LanguageSectionContext langSectionCtx = archCtx.languageSection();
        if (langSectionCtx != null) {
            odinReader.read(textToCharStream(langSectionCtx.odinText().ODIN_LINE()), "language");
            errorCollector.setLanguageErrors(odinReader.getErrors());
        }

        // Description section [1]
        AdlParser.DescriptionSectionContext descSectionCtx = archCtx.descriptionSection();
        if (descSectionCtx != null) {
            odinReader.read(textToCharStream (descSectionCtx.odinText().ODIN_LINE()), "description");
            errorCollector.setDescriptionErrors (odinReader.getErrors());
        }

        // Definition section: CADL [1]
        AdlParser.DefinitionSectionContext defSectionCtx = archCtx.definitionSection();
        if (defSectionCtx != null) {
            cadlReader.read(textToCharStream(defSectionCtx.cadlText().CADL_LINE()), "definition");
            errorCollector.setDefinitionErrors(cadlReader.getErrors());
        }

        // Rules section: EL [0..1]
        AdlParser.RulesSectionContext rulesSectionCtx = archCtx.rulesSection();
        if (rulesSectionCtx != null) {
            elReader.read (textToCharStream (rulesSectionCtx.elText().EL_LINE()), "el");
            errorCollector.setRulesErrors (elReader.getErrors());
        }

        // Rm_overlay section: ODIN [0..1]
        AdlParser.RmOverlaySectionContext rmOvlSectionCtx = archCtx.rmOverlaySection();
        if (rmOvlSectionCtx != null) {
            odinReader.read (textToCharStream (rmOvlSectionCtx.odinText().ODIN_LINE()), "rm_overlay");
            errorCollector.setRmOverlayErrors (odinReader.getErrors());
        }

        // Terminology section: ODIN [1]
        AdlParser.TerminologySectionContext termSectionCtx = archCtx.terminologySection();
        if (termSectionCtx != null) {
            odinReader.read (textToCharStream(termSectionCtx.odinText().ODIN_LINE()), "terminology");
            errorCollector.setTerminologyErrors(odinReader.getErrors());
        }

        // Annotations section: ODIN [0..1]
        AdlParser.AnnotationsSectionContext annotSectionCtx = archCtx.annotationsSection();
        if (annotSectionCtx != null) {
            odinReader.read (textToCharStream(annotSectionCtx.odinText().ODIN_LINE()), "annotations");
            errorCollector.setAnnotationsErrors (odinReader.getErrors());
        }

    }

    private void readTemplate (AdlParser.TemplateContext archCtx) {
        // Header (part of top-level parse)
        AdlParser.HeaderContext header = archCtx.header();
        readMetaData (header.metaData());

        // Specialise section (part of top-level parse)
        AdlParser.SpecializeSectionContext specSectionCtx = archCtx.specializeSection();

        // Language section: ODIN
        odinReader.read (textToCharStream(archCtx.languageSection().odinText().ODIN_LINE()), "language");
        errorCollector.setLanguageErrors(odinReader.getErrors());

        // Description section: ODIN
        odinReader.read (textToCharStream(archCtx.descriptionSection().odinText().ODIN_LINE()), "description");
        errorCollector.setDescriptionErrors (odinReader.getErrors());

        // Definition section: CADL
        cadlReader.read (textToCharStream(archCtx.definitionSection().cadlText().CADL_LINE()), "definition");
        errorCollector.setDefinitionErrors (cadlReader.getErrors());

        // Rules section: EL
        AdlParser.RulesSectionContext rulesSectionCtx = archCtx.rulesSection();
        if (rulesSectionCtx != null) {
            elReader.read (textToCharStream(rulesSectionCtx.elText().EL_LINE()), "el");
            errorCollector.setRulesErrors (elReader.getErrors());
        }

        // Rm_overlay section: ODIN
        AdlParser.RmOverlaySectionContext rmOvlSectionCtx = archCtx.rmOverlaySection();
        if (rmOvlSectionCtx != null) {
            odinReader.read (textToCharStream(rmOvlSectionCtx.odinText().ODIN_LINE()), "rm_overlay");
            errorCollector.setRmOverlayErrors (odinReader.getErrors());
        }

        // Terminology section: ODIN
        odinReader.read (textToCharStream(archCtx.terminologySection().odinText().ODIN_LINE()), "terminology");
        errorCollector.setTerminologyErrors (odinReader.getErrors());

        // Annotations section: ODIN
        AdlParser.AnnotationsSectionContext annotSectionCtx = archCtx.annotationsSection();
        if (annotSectionCtx != null) {
            odinReader.read (textToCharStream(annotSectionCtx.odinText().ODIN_LINE()), "annotations");
            errorCollector.setAnnotationsErrors (odinReader.getErrors());
        }

        // now deal with template overlays
    }

    private void readOperationalTemplate (AdlParser.OperationalTemplateContext archCtx) {
    }

    private void readTemplateOverlay (AdlParser.TemplateOverlayContext archCtx) {
    }

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

    /**
     * Read an archetype meta-data section
     * @param metaDataCtx
     */
    private void readMetaData (AdlParser.MetaDataContext metaDataCtx) {
        // Header
        for (AdlParser.MetaDataItemContext metaDataItemCtx : metaDataCtx.metaDataItem()) {
            //metaDataItemCtx.xx;
//            if (metaDataItemCtx.metaDataFlag() != null)
//                System.out.println("\t" + metaDataItemCtx.metaDataFlag().ALPHANUM_ID().getText());
//            else if (metaDataItemCtx.metaDataValueItem() != null)
//                System.out.println("\t" + metaDataItemCtx.metaDataValueItem().ALPHANUM_ID().getText() +
//                        " = " + metaDataItemCtx.metaDataValueItem().metaDataItemValue().getText());
        }
    }

    private AdlReaderErrors errorCollector;

    private final OdinReader odinReader;
    private final CadlReader cadlReader;
    private final ElReader elReader;

}
