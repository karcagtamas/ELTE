package concurency;

import java.util.List;
import java.util.concurrent.Callable;

public class Main {
	public static void main(String[] args) {
		// Thread(() -> {}).run() szekvencialis, garantaltan egy processzor magon fut
		// Thread(() -> {}).start()
		
		final var t = new Thread(() -> {});
		new Thread(() -> {}).start();
		t.start();
		// t.stop(); deprecated
		// t.setDaemon(true); Background thread The application is running until there are any running Thread - The Daemon threads won't extend the program lifetime
		
		
		// t.join(); The t Thread waint until the caller thread (main) is finished, after start
		// Kolcsonos kizaras / mutual exclusion
		// Kritikus szakasz / critical section
		// Monitor
		
		
		List<String> a = List.of();
		Callable<String> c = () -> {return "";};
		
		synchronized (a) {
			
		}
	}
}
