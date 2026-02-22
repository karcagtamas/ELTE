package unittesting;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

class FibonacciTest {

	@Test
	void testFib1() {
		assertEquals(1, Fibonacci.fib(1));
	}
	
	@Test
	void testFib2() {
		assertEquals(2, Fibonacci.fib(2));
	}
	
	@ParameterizedTest
	@CsvSource({"3,3", "4,5"})
	void testFibHigherThan2(int src, int expected) {
		assertEquals(expected, Fibonacci.fib(src));
	}
	
	@Test
	void testExceptionThrowing() {
		assertThrows(IllegalArgumentException.class, () -> {
			Fibonacci.fib(-1);
		});
	}

}
