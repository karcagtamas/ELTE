package org.example;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class TestUtils {

    @Test
    void test1() {
        //assertEquals(1, new Test().test());
        assertEquals(int.class, int.class);
    }

    @Test
    void addTest() {
        assertEquals(12, new Utils().add(8, 4));
    }
}