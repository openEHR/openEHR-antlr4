package org.openehr.adlReader;

import org.junit.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.stream.Collectors;

public class AdlReaderTest {

    @Test
    public void simpleTest() throws IOException {
        String adlTestFile = "adl2/aom_structures/basic/openehr-TEST_PKG-WHOLE.most_minimal.v2.0.0.adls";
        // String adlTestFile = "adl/ADL2_test_set/templates/openEHR-DEMOGRAPHIC-PERSON.t_patient_ds_sf.v1.0.0.adls";

        AdlReader adlReader = new AdlReader();
        String adlText = getResourceFileAsString (adlTestFile);

        adlReader.readArchetype(adlText);
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