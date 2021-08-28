package org.openehr.adlReader;

import org.openehr.antlr.ANTLRParserErrors;
import org.openehr.antlr.ANTLRParserMessage;
import org.openehr.antlr.IANTLRParserErrors;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

public class AdlReaderErrors implements IANTLRParserErrors {

    // ------------------ Creation ------------------

    public AdlReaderErrors() {
        errorTable = new HashMap<>();
    }

    // ------------------ Access ------------------

    public boolean hasNoErrors() {
        return errorTable.values().stream().allMatch (ANTLRParserErrors::hasNoErrors);
    }

    public boolean hasErrors() {
        return errorTable.values().stream().anyMatch (ANTLRParserErrors::hasErrors);
    }

    public boolean hasWarnings() {
        return errorTable.values().stream().anyMatch (ANTLRParserErrors::hasWarnings);
    }

    public List<ANTLRParserMessage> getWarnings() {
        return errorTable.values()
                .stream()
                .flatMap(x -> x.getWarnings().stream())
                .collect(Collectors.toList());
    }

    @Override
    public boolean hasNoMessages() {
        return errorTable.values().stream().allMatch (ANTLRParserErrors::hasNoMessages);
    }

    public List<ANTLRParserMessage> getErrors() {
        return errorTable.values()
                .stream()
                .flatMap(x -> x.getErrors().stream())
                .collect(Collectors.toList());
    }


    // ------------------ Member Access ------------------

    public ANTLRParserErrors getAdlErrors() {
        return errorTable.get("adl");
    }

    public ANTLRParserErrors getLanguageErrors() {
        return errorTable.get("language");
    }

    public ANTLRParserErrors getDescriptionErrors() {
        return errorTable.get("description");
    }

    public ANTLRParserErrors getDefinitionErrors() {
        return errorTable.get("definition");
    }

    public ANTLRParserErrors getRulesErrors() {
        return errorTable.get("rules");
    }

    public ANTLRParserErrors getRmOverlayErrors() {
        return errorTable.get("rmOverlay");
    }

    public ANTLRParserErrors getTerminologyErrors() {
        return errorTable.get("terminology");
    }

    public ANTLRParserErrors getAnnotationsErrors() {
        return errorTable.get("annotations");
    }

    public ANTLRParserErrors getComponentsTerminologiesErrors() {
        return errorTable.get("componentTerminologies");
    }


    // ------------------ Modification ------------------

    public void setAdlErrors(ANTLRParserErrors adlErrors) {
        errorTable.put("adl", adlErrors);
    }

    public void setLanguageErrors(ANTLRParserErrors languageErrors) {
        errorTable.put("language", languageErrors);
    }

    public void setDescriptionErrors(ANTLRParserErrors descriptionErrors) {
        errorTable.put("description", descriptionErrors);
    }

    public void setDefinitionErrors(ANTLRParserErrors definitionErrors) {
        errorTable.put("definition", definitionErrors);
    }

    public void setRulesErrors(ANTLRParserErrors rulesErrors) {
        errorTable.put("rules", rulesErrors);
    }

    public void setRmOverlayErrors(ANTLRParserErrors rmOverlayErrors) {
        errorTable.put("rmOverlay", rmOverlayErrors);
    }

    public void setTerminologyErrors(ANTLRParserErrors terminologyErrors) {
        errorTable.put("terminology", terminologyErrors);
    }

    public void setAnnotationsErrors(ANTLRParserErrors annotationsErrors) {
        errorTable.put("annotations", annotationsErrors);
    }

    public void setComponentsTerminologiesErrors(ANTLRParserErrors componentsTerminologiesErrors) {
        errorTable.put("componentTerminologies", componentsTerminologiesErrors);
    }


    // ------------------ Implementation ------------------

    private final HashMap<String, ANTLRParserErrors> errorTable;
}
