package org.openehr.reader_adl2;

import org.junit.jupiter.api.Test;
import org.openehr.antlr4.ReaderTestUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

public class Adl2ReaderTest {

    private static final Logger log = LoggerFactory.getLogger(Adl2ReaderTest.class);

    @Test
    public void testAllAdl2() throws IOException {
        ReaderTestUtil testRunner = new ReaderTestUtil();
        testRunner.runTest ("adls", "adl2", new Adl2Reader(false, false), this.getClass());
    }

    @Test
    public void testAllAdl3() throws IOException {
        ReaderTestUtil testRunner = new ReaderTestUtil();
        testRunner.runTest ("adls", "adl3", new Adl2Reader(false, false), this.getClass());
    }

}