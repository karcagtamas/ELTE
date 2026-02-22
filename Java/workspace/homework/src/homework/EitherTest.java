package homework;

import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;
import static org.junit.jupiter.api.Assertions.*;

import java.util.NoSuchElementException;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

class EitherTest {

	@Test
	public void leftShouldReturnAnEitherWithLeftValue() {
		final var value = "Alma";
		
		final var either = Either.left(value);
		
		assertEquals(value, either.getLeft());
	}
	
	@Test
	public void rightShouldReturnAnEitherWithRightValue() {
		final var value = "Alma";
		
		final var either = Either.right(value);
		
		assertEquals(value, either.getRight());
	}
	
	@Test
	public void iterateShouldReturnTheLeftValueWhenEitherIsLeft() {
		final var value = 1;
		
		final Either<Integer, Integer> either = Either.left(value);
		
		assertEquals(value, Either.iterate(either, 10, (e) -> e));
	}
	
	@ParameterizedTest
	@CsvSource({ "1, 10, 11", "100, 100, 200" })
	public void iterateShouldIterateNTimesWithTheGivenFunctionWhenEitherIsRight(Integer start, Integer n, Integer res) {	
		final Either<Integer, Integer> either = Either.right(start);
		
		assertEquals(res, Either.iterate(either, n, (e) -> e + 1));
	}
	
	@Test
	public void getLeftShouldThrowNoSuchElementExceptionWhenTheEitherIsRight() {
		final var either = Either.right("Alma");
		
		assertThrows(NoSuchElementException.class, () -> either.getLeft());
	}
	
	@Test
	public void getLeftShouldThrowNoSuchElementExceptionWhenTheEitherIsLeft() {
		final var either = Either.left("Alma");
		
		assertThrows(NoSuchElementException.class, () -> either.getRight());
	}
	
	@Test
	public void isLeftShouldReturnTrueWhenEitherIsLeft() {
		final var either = Either.left("Alma");
		
		assertTrue(either.isLeft());
	}

	@Test
	public void isLeftShouldReturnFalseWhenEitherIsRight() {
		final var either = Either.right("Alma");
		
		assertFalse(either.isLeft());
	}
	
	@Test
	public void isRightShouldReturnTrueWhenEitherIsRight() {
		final var either = Either.right("Alma");
		
		assertTrue(either.isRight());
	}
	
	@Test
	public void isRightShouldReturnFalseWhenEitherIsLeft() {
		final var either = Either.left("Alma");
		
		assertFalse(either.isRight());
	}
	
	@Test
	public void swapShouldSwapLeftToRight() {
		final var value = "Alma";
		
		final var either = Either.left(value);
		final var swapped = either.swap();
		
		assertEquals(value, swapped.getRight());
	}
	
	@Test
	public void swapShouldSwapRightToLeft() {
		final var value = "Alma";
		
		final var either = Either.right(value);
		final var swapped = either.swap();
		
		assertEquals(value, swapped.getLeft());
	}

	
	@ParameterizedTest
	@CsvSource({ "Alma", "Beta" })
	public void swapShouldSwapLeftToRightWhenSameType(String value) {
		final Either<String, String> either = Either.left(value);
		final var swapped = either.swap();
		
		assertEquals(value, swapped.getRight());
	}
	
	@ParameterizedTest
	@CsvSource({ "Alma", "Beta" })
	public void swapShouldSwapRightToLeftWhenSameType(String value) {
		final Either<String, String> either = Either.right(value);
		final var swapped = either.swap();
		
		assertEquals(value, swapped.getLeft());
	}
	
	@Test
	public void orElseGetReturnsRightValueWhenEitherIsRight() {
		final var value = "Alma";
		final var otherValue = "Korte";
		
		final var either = Either.right(value);
		
		assertEquals(value, either.orElseGet(() -> otherValue));
	}
	
	@Test
	public void orElseGetReturnsOtherValueWhenEitherIsLeft() {
		final var value = "Alma";
		final var otherValue = "Korte";
		
		final var either = Either.left(value);
		
		assertEquals(otherValue, either.orElseGet(() -> otherValue));
	}
	
	@Test
	public void mapShouldReturnTheWrappedLeftValueWhenEitherIsLeft() {
		final var value = 1;
		
		final var mappedEither = Either.left(value).map((r) -> r.toString());
		
		assertEquals(value, mappedEither.getLeft());
	}
	
	@Test
	public void mapShouldReturnTheMappedRightValueWhenEitherIsRight() {
		final var value = 1;
		
		final var mappedEither = Either.right(value).map((r) -> r.toString());
		
		assertEquals("1", mappedEither.getRight());
	}
	
	@Test
	public void bindShouldReturnTheWrappedLeftValueWhenEitherIsLeft() {
		final var value = 1;
		
		final var bindedEither = Either.left(value).bind((r) -> Either.right(r.toString()));
		
		assertEquals(1, bindedEither.getLeft());
	}
	
	@Test
	public void bindShouldReturnTheBindedRightEitherWhenEitherIsRight() {
		final var value = 1;
		
		final var bindedEither = Either.right(value).bind((r) -> Either.right(r.toString()));
		
		assertEquals("1", bindedEither.getRight());
	}

}
