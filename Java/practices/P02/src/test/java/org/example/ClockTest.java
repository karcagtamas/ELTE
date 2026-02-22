package org.example;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ClockTest {

    private Clock clock;

    @BeforeEach
    public void setup() {
        clock = new Clock();
    }

    @Test
    public void testClockInitializationIs0() {
        assertEquals(0, clock.getHours());
    }

    @Test
    public void testAddHoursWith0Hour() {
        clock.addHours(0);

        assertEquals(0, clock.getHours());
    }

    @Test
    public void testAddHoursWith12Hours() {
        clock.addHours(12);

        assertEquals(12, clock.getHours());
    }

    @Test
    public void testAddHoursWith24Hours() {
        clock.addHours(24);

        assertEquals(0, clock.getHours());
    }

    @Test
    public void testAddHoursWith75Hours() {
        clock.addHours(75);

        assertEquals(3, clock.getHours());
    }

    @Test
    public void testAddHoursWithMinus5Hours() {
        clock.addHours(-5);

        assertEquals(19, clock.getHours());
    }

    @Test
    public void testAddHoursWithMinus24() {
        clock.addHours(-24);

        assertEquals(0, clock.getHours());
    }

    @Test
    public void testAddHoursWithMinus78() {
        clock.addHours(-78);

        assertEquals(18, clock.getHours());
    }
}