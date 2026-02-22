package sample_2;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import sample_2.HelloLink;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class HelloLinkParameterizedTests {

    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{{0, 0}, {1, 1}, {2, 1},
                {3, 2}, {4, 3}, {5, 5}, {6, 8}, {7, 13}, {8, 21}});
    }

    @ParameterizedTest(name = "{index}: fub[{0}]={1}")
    @MethodSource("data")
    public void test(int input, int expected) {
        assertEquals(expected, HelloLink.compute(input));
    }

}