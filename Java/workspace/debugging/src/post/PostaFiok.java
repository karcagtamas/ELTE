package post;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class PostaFiok {

    private final List<Letter> levels;

    public PostaFiok() {
        levels = new ArrayList<>();
    }

    public void add(Letter level) {
        levels.add(level);
    }

    @Override
    public String toString() {
        return levels.stream()
                .map(Object::toString)
                .collect(Collectors.joining(", "));
    }
}
