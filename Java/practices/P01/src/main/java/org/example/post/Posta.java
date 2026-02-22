package org.example.post;

public class Posta {

    private final PostaFiok postaFiok1;
    private final PostaFiok postaFiok2;

    public Posta(PostaFiok postaFiok1, PostaFiok p2) {
        this.postaFiok1 = postaFiok1;
        this.postaFiok2 = p2;
    }

    public void valogat(Level level) {
        final var p = level.getZip() % 2 == 0
                ? postaFiok1
                : postaFiok2;

        p.add(level.increaseDay());
    }

    @Override
    public String toString() {
        return "P1 = %s\nP2 = %s".formatted(postaFiok1.toString(), postaFiok2.toString());
    }
}
