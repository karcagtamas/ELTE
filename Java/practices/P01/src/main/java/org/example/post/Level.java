package org.example.post;

import org.example.enums.City;
import org.example.enums.WeekDay;

public class Level {
    private final int zip;
    private WeekDay day;

    public Level(int zip, WeekDay day) {
        this.zip = zip;
        this.day = day;
    }

    public Level(City city, WeekDay day) {
        this.zip = city.getZipCode();
        this.day = day;
    }

    public int getZip() {
        return zip;
    }

    public Level increaseDay() {
        this.day = day.nextDay();

        return this;
    }

    @Override
    public String toString() {
        return "[Day = %s, ZIP = %d]".formatted(day, zip);
    }
}
