package org.example;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.time.Duration;

import static org.junit.jupiter.api.Assertions.*;

public class ExampleTest {

    @ParameterizedTest
    @CsvSource({"-1, -1", "0, 0", "1, 1", "1, 2", "8, 6"})
    public void testFibReReturnsCorrectNumber(int expected, int number) {
        assertEquals(expected, Example.fibRe(number));
    }

    @ParameterizedTest
    @CsvSource({"-1, -1", "0, 0", "1, 1", "1, 2", "8, 6"})
    public void testFibItReturnsCorrectNumber(int expected, int number) {
        assertEquals(expected, Example.fibIt(number));
    }

    @Test
    public void testDivisionByZeroExceptionThrowing() {
        var ex = assertThrows(ArithmeticException.class, Example::divByZero);

        assertEquals(ex.getMessage(), "/ by zero");
    }

    @Test
    public void testArrayIndexOutOfBoundExceptionThrowing() {
        assertThrows(ArrayIndexOutOfBoundsException.class, Example::arrayOutOfBound);
    }

    @Test
    public void testInfiniteLoopTermination() {
        assertTimeout(Duration.ofSeconds(1), Example::infiniteLoop);
    }
}