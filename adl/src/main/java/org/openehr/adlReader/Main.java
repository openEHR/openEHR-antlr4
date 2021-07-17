package org.openehr.adlReader;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.openehr.adlparser.AdlLexer;
import org.openehr.adlparser.AdlParser;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        String adlTestFile = args[0];
        String adlText;
        try {
            adlText = getResourceFileAsString (adlTestFile);
            System.out.println(adlTestFile);
            System.out.println(adlText);
            AdlLexer adlLexer = new AdlLexer(CharStreams.fromString(adlText));
            AdlParser adlParser = new AdlParser(new CommonTokenStream(adlLexer));
        } catch (IOException e) {
            e.printStackTrace();
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