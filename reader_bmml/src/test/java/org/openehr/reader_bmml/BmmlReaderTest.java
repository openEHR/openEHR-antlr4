package org.openehr.commonReader;

import org.junit.jupiter.api.Test;
import org.openehr.antlr4.ReaderTestUtil;
import org.openehr.reader_bmml.BmmlReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

public class BmmlReaderTest {

    private static final Logger log = LoggerFactory.getLogger(BmmlReaderTest.class);

    /**
     * Test BMML grammar
     * @throws IOException
     */
    @Test
    public void testAllBmml() throws IOException {
        ReaderTestUtil testRunner = new ReaderTestUtil();
        testRunner.runTest ("bmml", "bmml", new BmmlReader(false, false), this.getClass());
    }

}