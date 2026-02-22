import java.util.Arrays;
import java.util.List;

import enums.City;
import enums.WeekDay;

import post.*;

public class Main {
	
	public static void main(String[] args) {
        Arrays.stream(City.values())
                .forEach(c -> System.out.println(c.toString()));

        /*
        System.out.println(WeekDay.FRI.nextDay());
        System.out.println(WeekDay.FRI.nextDay(3));
        System.out.println(WeekDay.MON.nextDay(-1));

        System.out.println(WeekDay.MON.get("en"));
        System.out.println(WeekDay.MON.get("hu"));
        System.out.println(WeekDay.SUN.get("hu"));
        System.out.println(WeekDay.THU.get("hu"));
        System.out.println(WeekDay.FRI.get("hu"));
        */
        
        final var posta1 = new Posta(City.BUDAPEST.getZipCode(), List.of(new PostaFiok()));        
        final var posta2 = new Posta(City.GYOR.getZipCode(), List.of(new PostaFiok(), new PostaFiok()))
        		.addRedirection(City.BUDAPEST.getZipCode(), posta1);
       

        posta2.sendLetter(new Letter(City.BUDAPEST, WeekDay.THU));
        posta1.sendLetter(new Letter(City.DEBRECEN, WeekDay.TUE));
        posta2.sendLetter(new Letter(City.GYOR, WeekDay.SUN));
        posta2.sendLetter(new Letter(City.GYOR, WeekDay.MON));
        var l1 = new Letter(2222, WeekDay.THU);
        posta2.sendLetter(l1);
        // posta1.sendLetter(l1); // Cannot send not sendable letter again
        
    }
}
