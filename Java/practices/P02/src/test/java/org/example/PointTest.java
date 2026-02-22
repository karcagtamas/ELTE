package org.example;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

import static org.junit.jupiter.api.Assertions.*;

class PointTest {

    private Point point;

    @BeforeEach
    void setUp() {
        point = new Point(1, 3);
    }

    @Test
    public void testPointInitializationOfX() {
        assertEquals(1, point.getX());
    }

    @Test
    public void testPointInitializationOfY() {
        assertEquals(3, point.getY());
    }

    @ParameterizedTest
    @CsvSource({"3, 2", "-3, -4", "1, 0"})
    public void testShiftingOfX(int excepted, int shiftX) {
        point.shift(shiftX, 0);

        assertEquals(excepted, point.getX());
    }

    @ParameterizedTest
    @CsvSource({"5, 2", "-1, -4", "3, 0"})
    public void testShiftingOfY(int excepted, int shiftY) {
        point.shift(0, shiftY);

        assertEquals(excepted, point.getY());
    }

    @Test
    public void testShiftingByZeroXAndZeroY() {
        point.shift(0, 0);

        assertEquals(1, point.getX());
        assertEquals(3, point.getY());
    }

    @Test
    public void testShiftingByXAndZero() {
        point.shift(3, -2);

        assertEquals(4, point.getX());
        assertEquals(1, point.getY());
    }
}