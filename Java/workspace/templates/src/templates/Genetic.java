package templates;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

public abstract class Genetic<T> {

	private int populationCount;
	private int crossoverCount;
	private double mutationProbability;
	private int pruneCount;

	List<T> entities = new ArrayList<T>();

	public Genetic(int populationCount, int crossoverCount, double mutationProbability, int pruneCount) {
		this.populationCount = populationCount;
		this.crossoverCount = crossoverCount;
		this.mutationProbability = mutationProbability;
		this.pruneCount = pruneCount;

		for (int i = 0; i < populationCount; i++) {
			entities.add(createRandomEntity());
		}
	}

	public T forward(int generationCount) {
		for (int i = 0; i < generationCount; i++) {
			generation();
		}
		
		return entities.stream()
				.max(Comparator.comparing(e -> calculateFitness(e)))
				.orElseThrow();
	}

	protected abstract T createRandomEntity();

	protected abstract void doCrossOver(T entity1, T entity2);

	protected abstract void mutateEntity(T entity, double mutationProbability);

	protected abstract Integer calculateFitness(T entity);

	private void generation() {
		Random random = new Random();

		for (int i = 0; i < crossoverCount; i++) {
			doCrossOver(entities.get(random.nextInt(entities.size())), entities.get(random.nextInt(entities.size())));
		}

		for (var entity : entities) {
			mutateEntity(entity, mutationProbability);
		}

		entities = entities.stream().map(entity -> {
			return Map.entry(entity, calculateFitness(entity));
		}).sorted(Comparator.<Map.Entry<T, Integer>, Integer>comparing(e -> e.getValue())).limit(pruneCount)
				.map(e -> e.getKey()).collect(Collectors.toList());

		for (int i = entities.size(); i < populationCount; i++) {
			entities.add(createRandomEntity());
		}
	}
}
