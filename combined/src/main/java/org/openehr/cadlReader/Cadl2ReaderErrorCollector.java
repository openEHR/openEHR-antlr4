package org.openehr.cadlReader;

import org.openehr.adlReader.Adl2ReaderDefinitions;
import org.openehr.antlr.IANTLRParserErrors;
import org.openehr.antlr.MultiSyntaxErrorCollector;

public class Cadl2ReaderErrorCollector extends MultiSyntaxErrorCollector {

    // ------------------ Member Access ------------------

    public IANTLRParserErrors getCadlErrors() {
        return errorTable.get (Cadl14ReaderDefinitions.CADL_ARTEFACT_NAME);
    }

    public IANTLRParserErrors getDefaultBlockErrors() {
        return errorTable.get (Cadl14ReaderDefinitions.EMBEDDED_ODIN_BLOCK_NAME);
    }

    // ------------------ Modification ------------------

    public void setCadlErrors(IANTLRParserErrors cadlErrors) {
        errorTable.put (Cadl14ReaderDefinitions.CADL_ARTEFACT_NAME, cadlErrors);
    }

    public void setDefaultBlockErrors(IANTLRParserErrors defaultBlockErrors) {
        errorTable.put (Cadl14ReaderDefinitions.EMBEDDED_ODIN_BLOCK_NAME, defaultBlockErrors);
    }

}
