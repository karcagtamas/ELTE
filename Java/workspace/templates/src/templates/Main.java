package templates;

import java.util.List;
import java.util.ArrayList;
import java.util.function.Supplier;

public class Main {
	public static void main(String[] args) {
		
	}
	
	public <T> void genetic(int populationCount, int crossoverCount, Supplier<T> createRandomEntity) {
		List<T> entities = new ArrayList<T>();
		
		for (int i = 0; i < populationCount; i++) {
			entities.add(createRandomEntity.get());
		}
	}
}
