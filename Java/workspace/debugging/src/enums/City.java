package enums;

public enum City {
    BUDAPEST(1000),
    DEBRECEN(BUDAPEST), // Has to be after Budapest!!!
    GYOR(9021);

    private final int zipCode;

    City(int zipCode) {
        this.zipCode = zipCode;
    }

    City(City city) {
        this(city.zipCode);
    }

    public int getZipCode() {
        return zipCode;
    }

    @Override
    public String toString() {
        return "[Name = %s, ZIP = %d]".formatted(name(), zipCode);
    }

}
