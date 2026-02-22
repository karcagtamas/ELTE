package homework;

import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.Supplier;

public class Either<L, R> {
	
	private L left;
	private R right;
	
	private Either() {}
	
	private Either(L left, R right) {
		this.left = left;
		this.right = right;
	}
	
	public static <L, R> Either<L,R> left(L leftValue) {
		return new Either<L, R>(leftValue, null);
	}
	
	public static <L, R> Either<L,R> right(R rightValue) {
		return new Either<L, R>(null, rightValue);
	}
	
	public static <R> R iterate(Either<R, R> either, int n, Function<R, R> func) {
		if (either.isLeft()) {
			return either.getLeft();
		}
		
		var right = either.getRight();
		for (int i = 0; i < n; i++) {
			right = func.apply(right);
		}
		
		return right;
	}
	
	public Either<R, L> swap() {
		return new Either<R, L>(this.right, this.left);
	}
	
	public boolean isLeft() {
		return left != null;
	}
	
	public boolean isRight() {
		return !isLeft();
	}
	
	public L getLeft() {
		if (!isLeft()) {
			throw new NoSuchElementException();
		}
		
		return this.left;
	}
	
	public R getRight() {
		if (!isRight()) {
			throw new NoSuchElementException();
		}
		
		return this.right;
	}
	
	public R orElseGet(Supplier<R> otherGetter) {
		return Optional.ofNullable(this.right).orElseGet(otherGetter);
	}
	
	public <T> Either<L, T> map(Function<R, T> func) {
		if (isLeft()) {
			return new Either<L, T>(getLeft(), null);
		}
		
		return new Either<L, T>(null, func.apply(getRight()));
	}
	
	public <T> Either<L, T> bind(Function<R, Either<L, T>> func) {
		if (isLeft()) {
			return new Either<L, T>(getLeft(), null);
		}
		
		return func.apply(getRight());
	}
}
