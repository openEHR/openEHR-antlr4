package org.openehr.commonReader;

import org.junit.jupiter.api.Test;
import org.openehr.antlr4.ReaderTestUtil;
import org.openehr.belReader.BelReader;
import org.openehr.cadlReader.Cadl2Reader;
import org.openehr.elReader.ElReader;
import org.openehr.odinReader.OdinReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

public class CommonReaderTest {

    private static final Logger log = LoggerFactory.getLogger(CommonReaderTest.class);

    @Test
    public void testAllOdin() throws IOException {
        ReaderTestUtil testRunner = new ReaderTestUtil();
        testRunner.runTest ("odin", "odin", new OdinReader (false, false), this.getClass());
    }

    @Test
    public void testAllCadl2() throws IOException {
        ReaderTestUtil testRunner = new ReaderTestUtil();
        testRunner.runTest ("cadl", "cadl2", new Cadl2Reader(false, false), this.getClass());
    }


    /**
     * Test BMM-based EL grammar
     * @throws IOException
     */
    @Test
    public void testAllEl() throws IOException {
        ReaderTestUtil testRunner = new ReaderTestUtil();
        testRunner.runTest ("el", "el", new ElReader(false, false), this.getClass());
    }

    /**
     * Test old BEL grammar
     * @throws IOException
     */
    @Test
    public void testAllBel() throws IOException {
        ReaderTestUtil testRunner = new ReaderTestUtil();
        testRunner.runTest ("el", "bel", new BelReader(false, false), this.getClass());
    }

}