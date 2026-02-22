package unittesting;

public class Fibonacci {
	public static int fib(int number) throws IllegalArgumentException {
		if (number <= 0) {
			throw new IllegalArgumentException("Not valid number for fibonacci calculation");
		}
		
		if (number == 1) {
			return 1;
		}
		
		if (number == 2) {
			return 2;
		}
		
		return fib(number - 1) + fib(number - 2);
	} 
}
