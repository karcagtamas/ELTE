package homework;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ClassDumper {
	
	private static String INDENT = "    ";
	
	public static <T> String dump(Class<T> clazz) {
		return Stream.of(List.of(getClassRow(clazz) + " {"), getFields(clazz), getMethods(clazz), List.of("}"))
				.flatMap(items -> items.stream())
				.collect(Collectors.joining("\n"));
	}
	
	private static <T> String getClassRow(Class<T> clazz) {
		return Stream.of(Modifier.toString(clazz.getModifiers()), "class", clazz.getSimpleName(), getExtend(clazz), getImplements(clazz))
				.filter(item -> !stringIsNullOrEmpty(item))
				.collect(Collectors.joining(" "));
	}
	
	private static <T> String getExtend(Class<T> clazz) {
		return Optional.of(clazz.getSuperclass())
				.map(c -> c.getName())
				.map(n -> "extends %s".formatted(n))
				.orElse(null);
	}
	
	private static <T> String getImplements(Class<T> clazz) {
		final var interfaces = Arrays.stream(clazz.getInterfaces())
				.map(i -> i.getName())
				.collect(Collectors.joining(", "));
		
		if (!stringIsNullOrEmpty(interfaces)) {
			return "implements %s".formatted(interfaces);
		}
		
		return null;
	}
	
	private static <T> List<String> getFields(Class<T> clazz) {
		return Arrays.stream(clazz.getDeclaredFields())
				.map(field -> "%s%s".formatted(INDENT, getField(field)))
				.toList();
	}
	
	private static String getField(Field field) {
		return Stream.of(Modifier.toString(field.getModifiers()), field.getType().getName(), field.getName() + ";")
				.collect(Collectors.joining(" "));
	}
	
	private static <T> List<String> getMethods(Class<T> clazz) {
		return Arrays.stream(clazz.getDeclaredMethods())
				.map(method -> "\n%s%s".formatted(INDENT, getMethod(method)))
				.toList();
	}
	
	private static String getMethod(Method method) {
		return Stream.of(Modifier.toString(method.getModifiers()), method.getReturnType().getTypeName(), "%s(...)".formatted(method.getName()), "{ /* method body */ }")
				.collect(Collectors.joining(" "));
	}
	
	private static boolean stringIsNullOrEmpty(String value) {
		return value == null || value.equals("");
	}
}
