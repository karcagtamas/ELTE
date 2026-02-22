package homework;

import static homework.ClassDumper.dump;
import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class ClassDumperTest {

	@Test
	void testTestClass1() {
		final var result = dump(TestClass1.class);
		
 		assertEquals("public class TestClass1 extends java.lang.Thread implements java.lang.Runnable, java.io.Serializable {\n"
 				+ "    private static final int CONST;\n"
 				+ "    transient volatile boolean flag;\n"
 				+ "    protected java.lang.Object obj;\n"
 				+ "    public int n;\n"
 				+ "\n"
 				+ "    public static void printConst(...) { /* method body */ }\n"
 				+ "}", result);
	}

	@Test
	void testTestClass2() {
		final var result = dump(TestClass2.class);
		
 		assertEquals("public class TestClass2 extends java.lang.Thread {\n"
 				+ "    private static final int CONST;\n"
 				+ "    transient volatile boolean flag;\n"
 				+ "    protected java.lang.Object obj;\n"
 				+ "    public int n;\n"
 				+ "\n"
 				+ "    public static void printConst(...) { /* method body */ }\n"
 				+ "}", result);
	}
	
	@Test
	void testTestClass3() {
		final var result = dump(TestClass3.class);
		
 		assertEquals("class TestClass3 extends java.lang.Object {\n"
 				+ "    private static final int CONST;\n"
 				+ "    transient volatile boolean flag;\n"
 				+ "    protected java.lang.Object obj;\n"
 				+ "    public int n;\n"
 				+ "\n"
 				+ "    public static void printConst(...) { /* method body */ }\n"
 				+ "}", result);
	}

}
