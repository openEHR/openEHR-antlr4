package org.openehr.adlReader;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.openehr.antlr.ANTLRParserErrors;
import org.openehr.antlr.ArchieErrorListener;
import org.openehr.cadlReader.CadlReader;
import org.openehr.combinedparser.*;
import org.openehr.odinReader.OdinReader;

import java.util.List;

public class AdlReader {

    //
    // -------------- Creation ------------------
    //
    public AdlReader (boolean logging, boolean keepAntlrErrors) {
        this.logging = logging;
        this.keepAntlrErrors = keepAntlrErrors;
    }

    //
    // -------------- Execution ------------------
    //
    /**
     * Read an archetype, supplying an error listener
     * @param adlStream char stream of the archetype
     */
    public void readArchetype (CharStream adlStream) {
        // set up the Error collector
        errorCollector = new AdlReaderErrors();

        // set up the top-level ADL lexer/parser
        errors = new ANTLRParserErrors ();
        errorCollector.setAdlErrors(errors);
        ArchieErrorListener errorListener = new ArchieErrorListener (errors, "adl");
        errorListener.setLogEnabled (logging);

        // Create an ADL lexer and parser and add error listener
        AdlLexer adlLexer = new AdlLexer(adlStream);
        if (!keepAntlrErrors)
            adlLexer.removeErrorListeners();
        adlLexer.addErrorListener(errorListener);
        AdlParser adlParser = new AdlParser (new CommonTokenStream(adlLexer));
        if (!keepAntlrErrors)
            adlParser.removeErrorListeners();
        adlParser.addErrorListener(errorListener);


        // look at the parse structure
        AdlParser.AdlObjectContext adlObjectCtx = adlParser.adlObject();

        for (ParserRuleContext ruleContext: adlObjectCtx.getRuleContexts(ParserRuleContext.class)) {
            if (ruleContext instanceof AdlParser.AuthoredArchetypeContext)
                readAuthoredArchetype ((AdlParser.AuthoredArchetypeContext) ruleContext);
            else if (ruleContext instanceof AdlParser.TemplateContext)
                readTemplate ((AdlParser.TemplateContext) ruleContext);
            else if (ruleContext instanceof AdlParser.TemplateOverlayContext)
                readTemplateOverlay ((AdlParser.TemplateOverlayContext) ruleContext);
            else if (ruleContext instanceof AdlParser.OperationalTemplateContext)
                readOperationalTemplate ((AdlParser.OperationalTemplateContext) ruleContext);
            else
                throw new RuntimeException("no valid ADL artefact found");
        }
    }

    public void readAuthoredArchetype (AdlParser.AuthoredArchetypeContext archCtx) {
        OdinReader odinReader = new OdinReader(logging, keepAntlrErrors);
        CadlReader cadlReader = new CadlReader(logging, keepAntlrErrors);

        // Header (part of top-level parse)
        AdlParser.HeaderContext header = archCtx.header();
        readMetaData (header.metaData());

        // Specialise section (part of top-level parse)
        AdlParser.SpecializeSectionContext specSectionCtx = archCtx.specializeSection();
        if (specSectionCtx != null) {

        }

        // Language section: ODIN
        odinReader.readOdin (ConcatNodeText(archCtx.languageSection().odinText().ODIN_LINE()), "language");
        errorCollector.setLanguageErrors(odinReader.getErrors());

        // Description section
        odinReader.readOdin (ConcatNodeText(archCtx.descriptionSection().odinText().ODIN_LINE()), "description");
        errorCollector.setDescriptionErrors (odinReader.getErrors());

        // Definition section: CADL
        cadlReader.readCadl (ConcatNodeText(archCtx.definitionSection().cadlText().CADL_LINE()), "definition");
        errorCollector.setDefinitionErrors (cadlReader.getErrors());

        // Rules section: EL
        AdlParser.RulesSectionContext rulesSectionCtx = archCtx.rulesSection();
        if (rulesSectionCtx != null) {
            readElText (ConcatNodeText(rulesSectionCtx.elText().EL_LINE()));
            errorCollector.setRulesErrors (odinReader.getErrors());
        }

        // Rm_overlay section: ODIN
        AdlParser.RmOverlaySectionContext rmOvlSectionCtx = archCtx.rmOverlaySection();
        if (rmOvlSectionCtx != null) {
            odinReader.readOdin (ConcatNodeText(rmOvlSectionCtx.odinText().ODIN_LINE()), "rm_overlay");
            errorCollector.setRmOverlayErrors (odinReader.getErrors());
        }

        // Terminology section: ODIN
        odinReader.readOdin (ConcatNodeText(archCtx.terminologySection().odinText().ODIN_LINE()), "terminology");
        errorCollector.setTerminologyErrors (odinReader.getErrors());

        // Annotations section: ODIN
        AdlParser.AnnotationsSectionContext annotSectionCtx = archCtx.annotationsSection();
        if (annotSectionCtx != null) {
            odinReader.readOdin (ConcatNodeText(annotSectionCtx.odinText().ODIN_LINE()), "annotations");
            errorCollector.setAnnotationsErrors (odinReader.getErrors());
        }

    }

    public void readTemplate (AdlParser.TemplateContext archCtx) {
        OdinReader odinReader = new OdinReader(logging, keepAntlrErrors);
        CadlReader cadlReader = new CadlReader(logging, keepAntlrErrors);

        // Header (part of top-level parse)
        AdlParser.HeaderContext header = archCtx.header();
        readMetaData (header.metaData());

        // Specialise section (part of top-level parse)
        AdlParser.SpecializeSectionContext specSectionCtx = archCtx.specializeSection();


        // Language section: ODIN
        odinReader.readOdin (ConcatNodeText(archCtx.languageSection().odinText().ODIN_LINE()), "language");
        errorCollector.setLanguageErrors(odinReader.getErrors());

        // Description section
        odinReader.readOdin (ConcatNodeText(archCtx.descriptionSection().odinText().ODIN_LINE()), "description");
        errorCollector.setDescriptionErrors (odinReader.getErrors());

        // Definition section: CADL
        cadlReader.readCadl (ConcatNodeText(archCtx.definitionSection().cadlText().CADL_LINE()), "definition");
        errorCollector.setDefinitionErrors (cadlReader.getErrors());

        // Rules section: EL
        AdlParser.RulesSectionContext rulesSectionCtx = archCtx.rulesSection();
        if (rulesSectionCtx != null) {
            readElText (ConcatNodeText(rulesSectionCtx.elText().EL_LINE()));
            errorCollector.setRulesErrors (odinReader.getErrors());
        }

        // Rm_overlay section: ODIN
        AdlParser.RmOverlaySectionContext rmOvlSectionCtx = archCtx.rmOverlaySection();
        if (rmOvlSectionCtx != null) {
            odinReader.readOdin (ConcatNodeText(rmOvlSectionCtx.odinText().ODIN_LINE()), "rm_overlay");
            errorCollector.setRmOverlayErrors (odinReader.getErrors());
        }

        // Terminology section: ODIN
        odinReader.readOdin (ConcatNodeText(archCtx.terminologySection().odinText().ODIN_LINE()), "terminology");
        errorCollector.setTerminologyErrors (odinReader.getErrors());

        // Annotations section: ODIN
        AdlParser.AnnotationsSectionContext annotSectionCtx = archCtx.annotationsSection();
        if (annotSectionCtx != null) {
            odinReader.readOdin (ConcatNodeText(annotSectionCtx.odinText().ODIN_LINE()), "annotations");
            errorCollector.setAnnotationsErrors (odinReader.getErrors());
        }

        // now deal with template overlays
    }

    public void readOperationalTemplate (AdlParser.OperationalTemplateContext archCtx) {
    }

    public void readTemplateOverlay (AdlParser.TemplateOverlayContext archCtx) {
    }

    public ANTLRParserErrors getErrors() {
        return errors;
    }

    public AdlReaderErrors getErrorCollector() {
        return errorCollector;
    }

    //
    // -------------- Implementation ------------------
    //

    /**
     * Efficiently crunch a List<TerminalNode> containing lines of text
     * into a single string
     */
    private static String ConcatNodeText (List<TerminalNode> nodeList) {
        StringBuilder sb = new StringBuilder(AdlReaderDefinitions.ADL_TEXT_SECTION_SIZE);
        for (TerminalNode node: nodeList)
            sb.append(node.getText());
        
        return sb.toString();
    }

    /**
     * Read an EL text
     * @param elText
     */
    private void readElText (String elText) {
        // Create an EL lexer and parser and get top-level context
        ElLexer elLexer = new ElLexer(CharStreams.fromString(elText));
        ElParser elParser = new ElParser(new CommonTokenStream(elLexer));

        ElParser.StatementBlockContext elCtx = elParser.statementBlock();

        // execute listener on structure
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
    private ANTLRParserErrors errors;
    private boolean logging;
    private boolean keepAntlrErrors;

}
