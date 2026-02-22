package post;

import enums.City;
import enums.WeekDay;

public class Letter {
    private final int zip;
    private WeekDay day;
    
    private boolean notSendable;

    public Letter(int zip, WeekDay day) {
        this.zip = zip;
        this.day = day;
    }

    public Letter(City city, WeekDay day) {
        this.zip = city.getZipCode();
        this.day = day;
    }

    public int getZip() {
        return zip;
    }

    public Letter increaseDay() {
        this.day = day.nextDay();

        return this;
    }
    
    public void setAsNotSenable() {
    	this.notSendable = true;
    }
    
    public boolean isNotSendable() {
    	return this.notSendable;
    }

    @Override
    public String toString() {
        return "[Day = %s, ZIP = %d]".formatted(day, zip);
    }
}
