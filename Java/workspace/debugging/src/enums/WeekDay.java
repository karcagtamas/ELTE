package enums;

import java.util.Map;

public enum WeekDay {
    MON(Map.of("en", "Monday", "hu", "Hetfo")),
    TUE(Map.of("en", "Tuesday", "hu", "Kedd")),
    WEN(Map.of("en", "Wednesday", "hu", "Szerda")),
    THU(Map.of("en", "Thursday")),
    FRI(Map.of("en", "Friday", "hu", "Pentek")),
    SAT(Map.of("en", "Saturday", "hu", "Szombat")),
    SUN(Map.of("en", "Sunday")),
    ;

    private final Map<String, String> names;

    WeekDay(String lang, String name) {
        this.names = Map.of(lang, name);
    }

    WeekDay(Map<String, String> names) {
        this.names = names;
    }

    public WeekDay nextDay() {
        return nextDay(1);
    }

    public WeekDay nextDay(int x) {
        return values()[(ordinal() + x + (((Math.abs(x) / values().length) + 1) * values().length)) % values().length];
    }

    public String get(String lang) {
        return names.getOrDefault(lang, "?");
    }
}
