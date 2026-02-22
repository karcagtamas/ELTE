package org.example.post;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static java.util.Collections.emptyList;

public class PostaFiok {

    private final List<Level> levels;

    public PostaFiok() {
        levels = new ArrayList<>();
    }

    public void add(Level level) {
        levels.add(level);
    }

    @Override
    public String toString() {
        return levels.stream()
                .map(Object::toString)
                .collect(Collectors.joining(", "));
    }
}
