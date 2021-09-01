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
        return errorTable.values().stream().allMatch (IANTLRParserErrors::hasNoErrors);
    }

    public boolean hasErrors() {
        return errorTable.values().stream().anyMatch (IANTLRParserErrors::hasErrors);
    }

    public boolean hasWarnings() {
        return errorTable.values().stream().anyMatch (IANTLRParserErrors::hasWarnings);
    }

    public List<ANTLRParserMessage> getWarnings() {
        return errorTable.values()
                .stream()
                .flatMap(x -> x.getWarnings().stream())
                .collect(Collectors.toList());
    }

    @Override
    public boolean hasNoMessages() {
        return errorTable.values().stream().allMatch (IANTLRParserErrors::hasNoMessages);
    }

    public List<ANTLRParserMessage> getErrors() {
        return errorTable.values()
                .stream()
                .flatMap(x -> x.getErrors().stream())
                .collect(Collectors.toList());
    }


    // ------------------ Member Access ------------------

    public IANTLRParserErrors getAdlErrors() {
        return errorTable.get(AdlReaderDefinitions.ADL_ARTEFACT_NAME);
    }

    public IANTLRParserErrors getLanguageErrors() {
        return errorTable.get(AdlReaderDefinitions.LANGUAGE_SECTION_NAME);
    }

    public IANTLRParserErrors getDescriptionErrors() {
        return errorTable.get (AdlReaderDefinitions.DESCRIPTION_SECTION_NAME);
    }

    public IANTLRParserErrors getDefinitionErrors() {
        return errorTable.get(AdlReaderDefinitions.DEFINITION_SECTION_NAME);
    }

    public IANTLRParserErrors getRulesErrors() {
        return errorTable.get(AdlReaderDefinitions.RULES_SECTION_NAME);
    }

    public IANTLRParserErrors getRmOverlayErrors() {
        return errorTable.get(AdlReaderDefinitions.RM_OVERLAY_SECTION_NAME);
    }

    public IANTLRParserErrors getTerminologyErrors() {
        return errorTable.get(AdlReaderDefinitions.TERMINOLOGY_SECTION_NAME);
    }

    public IANTLRParserErrors getAnnotationsErrors() {
        return errorTable.get(AdlReaderDefinitions.ANNOTATIONS_SECTION_NAME);
    }

    public IANTLRParserErrors getComponentsTerminologiesErrors() {
        return errorTable.get(AdlReaderDefinitions.COMPONENT_TERMINOLOGIES_SECTION_NAME);
    }


    // ------------------ Modification ------------------

    public void setAdlErrors(IANTLRParserErrors adlErrors) {
        errorTable.put(AdlReaderDefinitions.ADL_ARTEFACT_NAME, adlErrors);
    }

    public void setLanguageErrors(IANTLRParserErrors languageErrors) {
        errorTable.put(AdlReaderDefinitions.LANGUAGE_SECTION_NAME, languageErrors);
    }

    public void setDescriptionErrors(IANTLRParserErrors descriptionErrors) {
        errorTable.put(AdlReaderDefinitions.DESCRIPTION_SECTION_NAME, descriptionErrors);
    }

    public void setDefinitionErrors(IANTLRParserErrors definitionErrors) {
        errorTable.put(AdlReaderDefinitions.DEFINITION_SECTION_NAME, definitionErrors);
    }

    public void setRulesErrors(IANTLRParserErrors rulesErrors) {
        errorTable.put(AdlReaderDefinitions.RULES_SECTION_NAME, rulesErrors);
    }

    public void setRmOverlayErrors(IANTLRParserErrors rmOverlayErrors) {
        errorTable.put(AdlReaderDefinitions.RM_OVERLAY_SECTION_NAME, rmOverlayErrors);
    }

    public void setTerminologyErrors(IANTLRParserErrors terminologyErrors) {
        errorTable.put(AdlReaderDefinitions.TERMINOLOGY_SECTION_NAME, terminologyErrors);
    }

    public void setAnnotationsErrors(IANTLRParserErrors annotationsErrors) {
        errorTable.put(AdlReaderDefinitions.ANNOTATIONS_SECTION_NAME, annotationsErrors);
    }

    public void setComponentsTerminologiesErrors(IANTLRParserErrors componentsTerminologiesErrors) {
        errorTable.put(AdlReaderDefinitions.COMPONENT_TERMINOLOGIES_SECTION_NAME, componentsTerminologiesErrors);
    }


    // ------------------ Implementation ------------------

    private final HashMap<String, IANTLRParserErrors> errorTable;
}
