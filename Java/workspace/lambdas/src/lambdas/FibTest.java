package lambdas;

import static org.junit.Assert.assertEquals;

import java.util.function.IntUnaryOperator;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

public class FibTest {

	private IntUnaryOperator fib = (num) -> {
		int ptp = 0;
	    int p = 1;
	    int sum = 0;

	    if (num == 0) {
	        return 0;
	    }

	    else if (num == 1) {
	        return 1;
	    }

	    else {
	        for (int i = 2; i <= num; i++) {

	            sum = ptp + p;
	            ptp = p;
	            p = sum;
	        }
	    }
	    return sum;
	};

	@ParameterizedTest
	@CsvSource({ "1,1", "1,2", "2, 3", "3, 4", "5, 5", "8, 6" })
	public void testFib1Is1(int expected, int param) {
		assertEquals(expected, fib.applyAsInt(param));
	}
}
