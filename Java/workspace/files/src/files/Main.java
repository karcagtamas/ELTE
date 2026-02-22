package files;

import java.io.IOException;
import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.zip.ZipFile;

public class Main {
	public static void main(String[] args) throws IOException {
		ByteBuffer bb = ByteBuffer.allocateDirect(100);
		
		try (RandomAccessFile raf = new RandomAccessFile("src/files/file.txt", "rwd"); FileChannel fc = raf.getChannel()) {
			
			bb.put((byte)65);
			fc.read(bb);
			bb.flip();
			System.out.println(bb.get());
		}
		
		// bb.flip();
		
		readZip();
	}
	
	public static void readZip() throws IOException {
		try (// ByteBuffer bfBuffer;
		var zip = new ZipFile("src/files/Test.zip")) {
			zip.stream().forEach(e -> System.out.println(e.getName()));
		}
	}
}
