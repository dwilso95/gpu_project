package jhu.gpu.dwilso95.rfile.ingest;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import org.apache.accumulo.core.client.rfile.RFile;
import org.apache.accumulo.core.client.rfile.RFileWriter;
import org.apache.accumulo.core.data.Key;
import org.apache.accumulo.core.data.Value;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;

import com.google.common.base.Strings;

public class WriteRFile {

	public static void main(String args[]) throws IOException {
		final Long start = System.currentTimeMillis();
		final File inputFile = new File(args[0]);
		final File outputFile = new File(args[1]);
		final String columnName = args[2];

		try (final BufferedReader reader = new BufferedReader(new FileReader(inputFile));
				final RFileWriter out = RFile.newWriter().to(outputFile.toString())
						.withFileSystem(FileSystem.getLocal(new Configuration())).build();) {
			out.startDefaultLocalityGroup();

			String line = null;
			while ((line = reader.readLine()) != null && !Strings.isNullOrEmpty(line)) {
				final int separatorIndex = line.indexOf(' ');
				final Key key = new Key(line.substring(0, separatorIndex), columnName);
				final Value value = new Value(line.substring(separatorIndex + 1).getBytes());
				out.append(key, value);
			}
		}
		System.out.println("Done writing rfile [" + outputFile.getAbsolutePath() + "]");
		System.out.println("Completed in " + (System.currentTimeMillis() - start) + " milliseconds.");
	}

}