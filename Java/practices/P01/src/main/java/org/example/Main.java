package org.example;

import org.example.enums.City;
import org.example.enums.WeekDay;
import org.example.post.Level;
import org.example.post.Posta;
import org.example.post.PostaFiok;

import java.time.temporal.Temporal;
import java.util.Arrays;

public class Main {
    public static void main(String[] args) {
        Arrays.stream(City.values())
                .forEach(c -> System.out.println(c.toString()));


        System.out.println(WeekDay.FRI.nextDay());
        System.out.println(WeekDay.FRI.nextDay(3));
        System.out.println(WeekDay.MON.nextDay(-1));

        System.out.println(WeekDay.MON.get("en"));
        System.out.println(WeekDay.MON.get("hu"));
        System.out.println(WeekDay.SUN.get("hu"));
        System.out.println(WeekDay.THU.get("hu"));
        System.out.println(WeekDay.FRI.get("hu"));

        final var p1 = new PostaFiok();
        final var p2 = new PostaFiok();

        final var posta = new Posta(p1, p2);

        posta.valogat(new Level(City.BUDAPEST, WeekDay.THU));
        posta.valogat(new Level(City.DEBRECEN, WeekDay.TUE));
        posta.valogat(new Level(City.GYOR, WeekDay.SUN));
        posta.valogat(new Level(City.GYOR, WeekDay.MON));
        System.out.println(posta);
    }
}