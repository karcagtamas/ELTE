package lambdas;

import static org.junit.Assert.assertEquals;

import java.util.function.IntUnaryOperator;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

public class FactTest {

	private IntUnaryOperator fact = (num) -> {
		Integer sum = 1;

		for (int i = 2; i <= num; i++) {
			sum *= i;
		}

		return sum;
	};
	
	private IntUnaryOperator factRec;
	
	@BeforeEach
	public void before() {
		factRec = (num) -> {
			return num == 1 ? 1 : factRec.applyAsInt(num - 1) * num;
		};
	}

	@ParameterizedTest
	@CsvSource({"1, 1", "2, 2", "6, 3", "40320, 8"})
	public void testFactIterative(int expected, int param) {
		assertEquals(expected, fact.applyAsInt(param));
	}
	
	@ParameterizedTest
	@CsvSource({"1, 1", "2, 2", "6, 3", "40320, 8"})
	public void testFactRecursive(int expected, int param) {
		assertEquals(expected, factRec.applyAsInt(param));
	}

}
