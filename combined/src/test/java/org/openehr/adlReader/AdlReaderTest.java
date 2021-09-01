package org.openehr.adlReader;

import com.google.common.base.Charsets;
import org.antlr.v4.runtime.CharStreams;
import org.apache.commons.io.input.BOMInputStream;
import org.junit.Test;
import org.openehr.cadlReader.CadlReader;
import org.openehr.common.SyntaxReader;
import org.openehr.elReader.ElReader;
import org.openehr.odinReader.OdinReader;
import org.reflections.Reflections;
import org.reflections.scanners.ResourcesScanner;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import static org.junit.Assert.fail;

public class AdlReaderTest {

    private static final Logger log = LoggerFactory.getLogger(AdlReaderTest.class);

    @Test
    public void testAllOdin() throws IOException {
        runTest ("odin", "odin", new OdinReader (false, false));
    }

    @Test
    public void testAllCadl() throws IOException {
        runTest ("cadl", "cadl", new CadlReader (false, false));
    }

    @Test
    public void testAllEl() throws IOException {
        runTest ("el", "el", new ElReader(false, false));
    }

    @Test
    public void testAllAdl() throws IOException {
        runTest ("adls", "adl2", new AdlReader (false, false));
    }

    private void runTest (String fileExt, String artefactType, SyntaxReader<?,?> reader) throws IOException {
        Reflections reflections;
        List<String> paths;

        // run passing tests
        reflections = new Reflections (artefactType + "/pass", new ResourcesScanner());
        paths = new ArrayList<>(reflections.getResources (Pattern.compile(".*\\." + fileExt)));
        int passErrorCount = executeTestGroup ( paths, artefactType, reader);
        int passGroupCount = paths.size();

        // run failing tests;
        // TODO: many of these tests will pass pure parsing, until
        // we implement validation passes. Most of this should be in archie.
        reflections = new Reflections (artefactType + "/fail", new ResourcesScanner());
        paths = new ArrayList<>(reflections.getResources (Pattern.compile(".*\\." + fileExt)));
        int failErrorCount = executeTestGroup ( paths, artefactType, reader);
        int failGroupCount = paths.size();

        if (passErrorCount > 0 || failErrorCount != paths.size())
            fail (String.format ("%d files failed from %d in pass group; %d files passed from %d in fail group",
                    passErrorCount, passGroupCount, failGroupCount - failErrorCount, failGroupCount));
    }

    // --------------------------- Implementation ------------------------------

    private int executeTestGroup (List<String> paths, String artefactType, SyntaxReader<?,?> reader) throws IOException {
        int errorCount = 0;
        for (String pathName : paths) {
            try (InputStream stream = getClass().getResourceAsStream("/" + pathName)) {
                reader.read (CharStreams.fromStream(new BOMInputStream(stream), Charsets.UTF_8), artefactType);

                // report results
                if (reader.getErrors().hasErrors()) {
                    errorCount++;
                    System.out.println("ERRORS: ----------------- " + pathName + " ----------------");
                    System.out.println(reader.getErrors().getErrors().get(0).qualifiedMessage());
                }
                if (reader.getErrors().hasWarnings()) {
                    System.out.println("WARNINGS:  ----------------- " + pathName + " ----------------");
                    System.out.println(reader.getErrors().getWarnings().get(0).qualifiedMessage());
                }
            }
        }
        return errorCount;
    }

}