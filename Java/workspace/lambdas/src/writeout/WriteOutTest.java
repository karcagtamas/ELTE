package writeout;

import java.util.Random;
import java.util.function.IntConsumer;

import org.junit.Before;
import org.junit.Test;

public class WriteOutTest {

	private IntConsumer writerA = (number) -> {
		for (int i = 0; i < number; i++) {
			System.out.print(number);
		}
	};

	private IntConsumer writerB = (number) -> {
		for (int i = 0; i < new Random().nextInt(); i++) {
			System.out.print(number);
		}
	};

	private Runnable writerC = new Runnable() {

		int state = 1;

		@Override
		public void run() {
			for (int i = 0; i < state; i++) {
				System.out.print(state);
			}

			state++;
		}
	};
	
	@Before
	public void before() {
		System.setOut(null);
	}

	@Test
	public void testOneWriteOutA() {
		writerA.accept(1);
	}

	@Test
	public void testOneWriteOutB() {
		writerB.accept(1);
	}
	
	@Test
	public void testOneWriteOutC() {
		writerC.run();
	}
}
