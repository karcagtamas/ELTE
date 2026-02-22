package org.example;

public class Clock {
    private int hours = 0;

    public void addHours(int hours) {
        int calculated = this.hours + hours;

        calculated %= 24;

        while (calculated < 0) {
            calculated += 24;
        }

        this.hours = calculated;
    }

    public int getHours() {
        return hours;
    }
}
