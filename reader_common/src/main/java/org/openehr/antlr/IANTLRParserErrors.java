package org.openehr.antlr;

import java.util.List;

/**
 * Created by pieter.bos on 19/10/15.
 */
public interface IANTLRParserErrors {

    public List<ANTLRParserMessage> getErrors() ;

    public List<ANTLRParserMessage> getWarnings();

    public boolean hasNoMessages() ;

    public boolean hasNoErrors() ;

    public boolean hasErrors() ;

    public boolean hasWarnings() ;

}
