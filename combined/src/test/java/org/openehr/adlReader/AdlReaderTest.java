package org.openehr.adlReader;

import com.google.common.base.Charsets;
import org.antlr.v4.runtime.CharStreams;
import org.apache.commons.io.input.BOMInputStream;
import org.junit.Test;
import org.openehr.antlr.ANTLRParserErrors;
import org.openehr.antlr.ANTLRParserMessage;
import org.openehr.antlr.ArchieErrorListener;
import org.openehr.cadlReader.CadlReader;
import org.openehr.odinReader.OdinReader;
import org.reflections.Reflections;
import org.reflections.scanners.ResourcesScanner;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class AdlReaderTest {

    private static final Logger log = LoggerFactory.getLogger(AdlReaderTest.class);

    @Test
    public void simpleAdlTest() throws IOException {
        String pathName = "/adl2/pass/description/text/openEHR-EHR-EVALUATION.unicode_farsi.v1.0.0.adls";

        AdlReader reader = new AdlReader(false, false);
        try (InputStream stream = getClass().getResourceAsStream (pathName)) {
            reader.read (CharStreams.fromStream (new BOMInputStream(stream), Charsets.UTF_8), "adl");
        }
    }

    @Test
    public void simpleOdinTest() throws IOException {
        String pathName = "odin/adl_terminology.odin";

        OdinReader reader = new OdinReader(false, false);
        String text = getResourceFileAsString (pathName);
        reader.read (CharStreams.fromString(text), "odin");
        ANTLRParserErrors errors = reader.getErrors();
        for (ANTLRParserMessage msg: errors.getErrors()) {
            System.out.println("ERROR: " + msg.qualifiedMessage());
        }
        for (ANTLRParserMessage msg: errors.getWarnings()) {
            System.out.println("WARNING: " + msg.qualifiedMessage());
        }
    }

    @Test
    public void simpleCadlTest() throws IOException {
        String pathName = "cadl/generic_type_use_node.v1.0.0.cadl";

        CadlReader reader = new CadlReader (false, false);
        String text = getResourceFileAsString (pathName);
        reader.read (CharStreams.fromString(text), "cadl");
        ANTLRParserErrors errors = reader.getErrors();
        for (ANTLRParserMessage msg: errors.getErrors()) {
            System.out.println("ERROR: " + msg.qualifiedMessage());
        }
        for (ANTLRParserMessage msg: errors.getWarnings()) {
            System.out.println("WARNING: " + msg.qualifiedMessage());
        }
    }

    @Test
    public void testAll() throws IOException {
        AdlReader adlReader = new AdlReader(false, false);

        Reflections reflections = new Reflections("adl2/pass", new ResourcesScanner());
        //List<String> files = new ArrayList<>(reflections.getResources (Pattern.compile(".*\\.adls")));
        List<String> files = new ArrayList<>(reflections.getResources (Pattern.compile(".*\\.adls")));

        for (String pathName : files) {
            try (InputStream stream = getClass().getResourceAsStream ("/" + pathName)) {
                adlReader.read (CharStreams.fromStream (new BOMInputStream (stream), Charsets.UTF_8), "adl");

                // report results
                if (adlReader.getErrorCollector().hasErrors()) {
                    System.out.println("ERRORS: ----------------- " + pathName + " ----------------");
                    System.out.println (adlReader.getErrorCollector().errors().get(0).qualifiedMessage());
//                    adlReader.getErrorCollector().errors().forEach (e-> System.out.println (e.qualifiedMessage()));
                }
                if (adlReader.getErrorCollector().hasWarnings()) {
                    System.out.println("WARNINGS:  ----------------- " + pathName + " ----------------");
                    System.out.println (adlReader.getErrorCollector().warnings().get(0).qualifiedMessage());
                }

            }
            catch (Exception e) {

            }
        }
    }

    /**
     * Reads given resource file as a string.
     *
     * @param fileName path to the resource file
     * @return the file's contents
     * @throws IOException if read fails for any reason
     */
    static String getResourceFileAsString(String fileName) throws IOException {
        ClassLoader classLoader = ClassLoader.getSystemClassLoader();
        try (InputStream is = classLoader.getResourceAsStream(fileName)) {
            if (is == null) return null;
            try (InputStreamReader isr = new InputStreamReader(is);
                 BufferedReader reader = new BufferedReader(isr)) {
                 return reader.lines().collect(Collectors.joining(System.lineSeparator()));
            }
        }
    }

}