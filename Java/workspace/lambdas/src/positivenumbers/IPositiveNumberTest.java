package positivenumbers;

import static org.junit.Assert.assertEquals;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class IPositiveNumberTest {
	
	private int state = 0;

	private IPositiveNumber getStateInside;
	
	private IPositiveNumber getStateOutside = () -> state++;

	@BeforeEach
	void setup() {
		getStateInside = new IPositiveNumber() {
			private int state = 0;

			@Override
			public int get() {
				return state++;
			}
		};
		
		state = 0;
	}

	@Test
	void testInisdeStateFirstGetIs0() {
		assertEquals(0, getStateInside.get());
	}
	
	@Test 
	void testInisdeStateSecondGetIs1() {
		getStateInside.get();
		assertEquals(1, getStateInside.get());
	}
	
	@Test
	void testOutsideStateFirstGetIs0() {
		assertEquals(0, getStateOutside.get());
	}
	
	@Test 
	void testOutsideStateSecondGetIs1() {
		getStateOutside.get();
		assertEquals(1, getStateOutside.get());
	}

}
