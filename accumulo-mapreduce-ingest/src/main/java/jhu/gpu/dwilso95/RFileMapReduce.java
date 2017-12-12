package jhu.gpu.dwilso95;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.accumulo.core.client.mapreduce.AccumuloFileOutputFormat;
import org.apache.accumulo.core.data.Key;
import org.apache.accumulo.core.data.Value;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class RFileMapReduce {

	public static void main(String args[]) {
		Job rfileCreationJob;

		try {
			final Configuration conf = new Configuration();
			rfileCreationJob = Job.getInstance(conf, "RFile_Creation");

			rfileCreationJob.setSpeculativeExecution(false);

			// Specify the Input path
			FileInputFormat.addInputPath(rfileCreationJob, new Path(args[0]));

			// Specify max split size
			FileInputFormat.setMaxInputSplitSize(rfileCreationJob, Long.MAX_VALUE);

			// Set the Input Data Format
			rfileCreationJob.setInputFormatClass(TextInputFormat.class);

			// Set the Mapper and Reducer Classes
			rfileCreationJob.setMapperClass(RFileMapper.class);
			rfileCreationJob.setReducerClass(Reducer.class);

			// Set the Jar file
			rfileCreationJob.setJarByClass(RFileMapReduce.class);

			// Set the Output path to second argument
			FileOutputFormat.setOutputPath(rfileCreationJob, new Path(args[1]));

			// Set the Output Data Format
			rfileCreationJob.setOutputFormatClass(AccumuloFileOutputFormat.class);

			// Set the Output Key and Value Class
			rfileCreationJob.setMapOutputKeyClass(Key.class);
			rfileCreationJob.setMapOutputValueClass(Value.class);

			// Set Header
			rfileCreationJob.getConfiguration().set("csv.input.header.index", args[2]);

		} catch (IOException ex) {
			Logger.getLogger(RFileMapReduce.class.getName()).log(Level.SEVERE, null, ex);
			return;
		}

		try {
			rfileCreationJob.waitForCompletion(true);
		} catch (IOException ex) {
			Logger.getLogger(RFileMapReduce.class.getName()).log(Level.SEVERE, null, ex);
		} catch (InterruptedException ex) {
			Logger.getLogger(RFileMapReduce.class.getName()).log(Level.SEVERE, null, ex);
		} catch (ClassNotFoundException ex) {
			Logger.getLogger(RFileMapReduce.class.getName()).log(Level.SEVERE, null, ex);
		}

	}

}
