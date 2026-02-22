package homework;

public class TestClass2 extends java.lang.Thread {
    private static final int CONST = 2;
    transient volatile boolean flag;
    protected java.lang.Object obj;
    public int n = 2;

    public static void printConst() {
        System.out.println(CONST);
    }
}