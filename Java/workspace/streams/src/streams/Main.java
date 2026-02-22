package streams;

import static java.util.stream.Collectors.toSet;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Scanner;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Main {
	public static void main(String[] args) throws IOException {
		Files.walk(Path.of("")).forEach(System.out::println);
		final var inputPath = Path.of("src/streams/input.txt");
		Files.lines(inputPath).forEach(System.out::println);
		Files.lines(inputPath).map(l -> l + "A").forEach(System.out::println);

		Files.write(Path.of("src/streams/res.txt"), Files.lines(inputPath).toList());
		Files.write(Path.of("src/streams/res2.txt"), Files.lines(inputPath).skip(3).toList());
		Files.write(Path.of("src/streams/res3.txt"), Files.lines(inputPath).limit(10).toList());
		Files.write(Path.of("src/streams/res4.txt"), Files.lines(inputPath).sorted().toList());
		Files.write(Path.of("src/streams/res5.txt"),
				Files.lines(inputPath).sorted(Comparator.comparing(Main::getUniqueCharacterNumber)).toList());
		Files.write(Path.of("src/streams/res6.txt"), Files.lines(inputPath).map(Main::convertSentence).toList());

		Supplier<Supplier<Supplier<Integer>>> s = () -> () -> () -> 1;
		System.out.println(s.get().get().get());

		Function<Scanner, Stream<String>> reader = (scanner) -> {
			return Stream.generate(() -> {
				if (scanner.hasNext()) {
					return scanner.next();
				}

				return null;
			});
		};

		reader.apply(new Scanner(inputPath)).filter(x -> x != null).forEach(System.out::println);

		//IntStream intStream = IntStream.of(1, 2, 3);
		//final var a = intStream.mapToObj(i -> i);
		//final var b = intStream.map(Integer::valueOf);
		//final var c = intStream.boxed();
		//final var d = Stream.of(1, 2, 3).flatMap(i -> Stream.of(i)).toList();
		System.out.println(Stream.iterate(0, i -> i + 1).limit(10).filter(i -> i < -1).count());

		System.out.println(Stream.iterate(0, i -> i + 1).filter(i -> i < -1).limit(10).count());
	}

	public static int getUniqueCharacterNumber(String text) {
		return Arrays.stream(text.split("")).collect(toSet()).size();
	}

	public static String convertSentence(String sentence) {
		return Arrays.stream(sentence.split(" ")).map(Main::convertWord).collect(Collectors.joining());
	}

	public static String convertWord(String word) {
		return word + (new StringBuilder().append(word).reverse().toString());
	}

}
