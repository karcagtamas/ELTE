package sample_2;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Timeout;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class HelloLinkAdvancedTests {
    
    @Test
    public void IndexOutOfBoundsTest() {
        HelloLink vHelloLink = new HelloLink(5);
        assertThrows(IndexOutOfBoundsException.class, () -> {
            vHelloLink.mVector.get(6);
        });
    }

    @Test
    @Disabled("Test is ignored as a demonstration")
    public void testSame() {
        assertEquals(1, 1);
    }

    @Test
    @Timeout(1)
    public void testWithTimeout() {
        //
    }

}