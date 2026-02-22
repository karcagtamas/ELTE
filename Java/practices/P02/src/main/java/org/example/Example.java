package org.example;

public class Example {

    // Fibonacci Iterative
    public static int fibIt(int n) {
        if (n <= 1) {
            return n;
        }

        int prevToPrev = 0;
        int prev = 1;
        int sum = 0;

        for (int i = 2; i <= n; i++) {
            sum = prevToPrev + prev;
            prevToPrev = prev;
            prev = sum;
        }

        return sum;
    }

    // Fibonacci recursive
    public static int fibRe(int n) {
        if (n <= 1) {
            return n;
        }

        return fibRe(n - 1) + fibRe(n - 2);
    }

    public static void divByZero() {
        int a = 0;
        int b = 1 / a;
    }

    public static void arrayOutOfBound() {
        int[] a = new int[1];

        int b = a[3];
    }

    public static void infiniteLoop() {
        boolean f = true;

        while (f) {
            f = true;
        }
    }
}