package org.openehr.adlReader;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.openehr.adlparser.*;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class AdlReader {
    
    public AdlReader() {
    }

    public void readArchetype(String adlText) {
        // Create an ADL lexer and parser and get top-level context
        AdlLexer adlLexer = new AdlLexer(CharStreams.fromString(adlText));
        AdlParser adlParser = new AdlParser(new CommonTokenStream(adlLexer));
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
        // Header
        AdlParser.HeaderContext header = archCtx.header();
        System.out.println("--------- header -----------");
        System.out.println(archCtx.SYM_ARCHETYPE().getText());
        System.out.println("\t" + header.ALPHANUM_ID().getText());
        readMetaData (header.metaData());

        // Specialise section
        AdlParser.SpecializeSectionContext specSectionCtx = archCtx.specializeSection();
        if (specSectionCtx != null) {
            System.out.println("--------- specialise section -----------");
            System.out.print (specSectionCtx.ALPHANUM_ID().getText());
        }

        // Language section: ODIN
        System.out.println("--------- language section -----------");
        readOdinText (ConcatNodeText(archCtx.languageSection().ODIN_LINE()));

        // Description section
        System.out.println ("--------- description section -----------");
        readOdinText (ConcatNodeText(archCtx.descriptionSection().ODIN_LINE()));

        // Definition section: CADL
        System.out.println ("--------- definition section -----------");
        readCadlText (ConcatNodeText(archCtx.definitionSection().CADL_LINE()));

        // Rules section: EL
        AdlParser.RulesSectionContext rulesSectionCtx = archCtx.rulesSection();
        if (rulesSectionCtx != null) {
            System.out.println ("--------- rules section -----------");
            readElText (ConcatNodeText(rulesSectionCtx.EL_LINE()));
        }

        // Terminology section: ODIN
        System.out.println ("--------- terminology section -----------");
        readOdinText (ConcatNodeText(archCtx.terminologySection().ODIN_LINE()));

        // Annotations section: ODIN
        AdlParser.AnnotationsSectionContext annotSectionCtx = archCtx.annotationsSection();
        if (annotSectionCtx != null) {
            System.out.println ("--------- annotations section -----------");
            readOdinText (ConcatNodeText(annotSectionCtx.ODIN_LINE()));
        }

    }

    public void readTemplate (AdlParser.TemplateContext archCtx) {
    }

    public void readOperationalTemplate (AdlParser.OperationalTemplateContext archCtx) {
    }

    public void readTemplateOverlay (AdlParser.TemplateOverlayContext archCtx) {
    }

    /**
     * Efficiently crunch a List<TerminalNode> containing lines of text
     * into a single string
     */
    static String ConcatNodeText (List<TerminalNode> nodeList) {
        StringBuilder sb = new StringBuilder(AdlReaderDefinitions.ADL_TEXT_SECTION_SIZE);
        for (TerminalNode node: nodeList)
            sb.append(node.getText());
        
        return sb.toString();
    }

    /**
     * Read an ODIN text
     * @param odinText
     */
    private void readOdinText (String odinText) {
        System.out.print(odinText);

        // Create an ODIN lexer and parser and get top-level context
        OdinLexer odinLexer = new OdinLexer(CharStreams.fromString(odinText));
        OdinParser odinParser = new OdinParser(new CommonTokenStream(odinLexer));
        ParseTree tree = odinParser.odinObject();

        OdinParser.OdinObjectContext odinObjectCtx = odinParser.odinObject();

        // execute listener on structure
        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(new OdinSimpleListener(), tree);
    }

    /**
     * Read a CADL text
     * @param cadlText
     */
    private void readCadlText (String cadlText) {
        System.out.print(cadlText);

        // Create a CADL lexer and parser and get top-level context
        CadlLexer cadlLexer = new CadlLexer(CharStreams.fromString(cadlText));
        CadlParser cadlParser = new CadlParser(new CommonTokenStream(cadlLexer));

        CadlParser.CComplexObjectContext coCtx = cadlParser.cComplexObject();

        // execute listener on structure
    }

    /**
     * Read an EL text
     * @param elText
     */
    private void readElText (String elText) {
        System.out.print(elText);

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
    public void readMetaData (AdlParser.MetaDataContext metaDataCtx) {
        // Header
        for (AdlParser.MetaDataItemContext metaDataItemCtx : metaDataCtx.metaDataItem()) {
            //metaDataItemCtx.xx;
            if (metaDataItemCtx.metaDataFlag() != null)
                System.out.println("\t" + metaDataItemCtx.metaDataFlag().ALPHANUM_ID().getText());
            else if (metaDataItemCtx.metaDataValue() != null)
                System.out.println("\t" + metaDataItemCtx.metaDataValue().ALPHANUM_ID(0).getText() +
                        " = " + metaDataItemCtx.metaDataValue().ALPHANUM_ID(0).getText());
        }
    }

}
