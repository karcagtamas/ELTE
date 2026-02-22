package reflections;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.List;

public class Main {
	public static void main(String[] args) {
		
	}
	
	public static <T> boolean allDataMembersArePrivate(Class<T> clazz) {
		return Arrays.stream(clazz.getDeclaredFields())
			.map(field -> field.getModifiers())
			.allMatch(m -> Modifier.isPrivate(m));
	}
	
	public static String getClassAuthor(String className) throws ClassNotFoundException {
		final var clazz = Class.forName(className);
		
		return getClassAuthor(clazz);
	}
	
	public static <T> String getClassAuthor(Class<T> clazz) {		
		if (clazz.isAnnotationPresent(Author.class)) {
			return clazz.getAnnotation(Author.class).name();
		}
		
		return null;
	}
	
	public static List<String> getClassMethodAuthors(String className) throws ClassNotFoundException {
		final var clazz = Class.forName(className);
		
		final var classAuthor = getClassAuthor(clazz);
		
		return Arrays.stream(clazz.getDeclaredMethods())
				.filter(method -> method.isAnnotationPresent(Author.class))
				.map(method -> method.getAnnotation(Author.class))
				.map(author -> author.name())
				.filter(name -> !name.equals(classAuthor))
				.toList();
	}
	
	public static void getDate(String className, int date) throws ClassNotFoundException {
		final var clazz = Class.forName(className);
		
		Arrays.stream(clazz.getDeclaredMethods())
				.filter(method -> method.isAnnotationPresent(Date.class))
				.filter(method -> method.getParameterCount() == 0)
				.filter(method -> method.getAnnotation(Date.class).date() > date)
				.forEach(method -> {
					try {
						method.invoke(clazz.newInstance());
					} catch (Exception e) {
						e.printStackTrace();
					}
				});
	}
}
