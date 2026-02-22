package networks;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.BindException;
import java.util.Scanner;
import java.io.*;
import java.nio.*;

public class Main {
	public static void main(String[] args) throws IOException {
		// DataOutputStream ds;
		// BufferedReader br;
		// Channel c;
		// Selector s;
		// SelectionKey sk;
		// ObjectOutputStream oos;
		// BufferedWriter bw;
		
		try(InputStream is = new FileInputStream("f.txt");) {
			int read = is.read(); // -1 if the end of the file is reached
			System.out.println(read);
		}// Closed is automatically - is.close(); - tobb elem eseten az osszes elemre meghivja, illetve a belso elemekre is (gc)
		
		try(var br = new BufferedReader(new FileReader("f.txt"))) {
			var l = br.readLine();
			System.out.println(l);
		}
		
		try (var scanner = new Scanner(new FileReader("f.txt"))) {
			if (scanner.hasNextLine()) {
				var l = scanner.nextLine(); // Throws exception if does not have any other line
				System.out.println(l);
			}
		}
		
		//BufferedWriter bf = new BufferedWriter();
	}
}
