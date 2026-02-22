package templates;

import java.util.Comparator;
import java.util.List;
import java.util.TreeMap;

public class BiMap<K, V> {

	private final TreeMap<K, V> byKeys;
	private final TreeMap<V, K> byValues;

	private BiMap() {
		this.byKeys = new TreeMap<K, V>();
		this.byValues = new TreeMap<V, K>();
	}

	private BiMap(Comparator<K> compKey, Comparator<V> compValue) {
		this.byKeys = new TreeMap<K, V>(compKey);
		this.byValues = new TreeMap<V, K>(compValue);
	}

	public static <K extends Comparable<K>, V extends Comparable<V>> BiMap<K, V> create() {
		return new BiMap<K, V>();
	}

	public static <K, V> BiMap<K, V> create(Comparator<K> compKey, Comparator<V> compValue) {
		return new BiMap<K, V>(compKey, compValue);
	}

	public void insert(K key, V value) {
		byKeys.put(key, value);
		byValues.put(value, key);
	}

	public void byKey(K key) {
		byKeys.get(key);
	}

	public void byValue(V value) {
		byValues.get(value);
	}

	public void insertAll(List<K> keys, List<V> values) {
		if (keys.size() != values.size()) {
			return;
		}

		for (int i = 0; i < keys.size(); i++) {
			insert((K) keys.get(i), (V) values.get(i));
		}
	}
}
