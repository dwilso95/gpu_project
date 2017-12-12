package jhu.gpu.dwilso95;

import java.io.IOException;
import java.util.Map;
import java.util.UUID;

import org.apache.accumulo.core.data.Key;
import org.apache.accumulo.core.data.Value;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import com.beust.jcommander.internal.Maps;

public class RFileMapper extends Mapper<LongWritable, Text, Key, Value> {

	final Map<Integer, String> indexedColumnsToName = Maps.newHashMap();

	protected void setup(Context context) throws IOException, InterruptedException {
		final String[] header = context.getConfiguration().getStrings("csv.input.header.index");
		System.out.println("Using header: " + header);

		for (final String index : header) {
			final String[] indexName = index.split(":");
			indexedColumnsToName.put(Integer.valueOf(indexName[0]), indexName[1]);
		}

	}

	@Override
	protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
		final String uuidString = UUID.randomUUID().toString();
		final Value outputValue = new Value(value.toString().getBytes());
		final String[] fields = value.toString().split(",");

		for (int i = 0; i < fields.length; i++) {
			if (fields[i] != null) {
				if (indexedColumnsToName.containsKey(i)) {
					context.write(new Key(fields[i], indexedColumnsToName.get(i), uuidString), outputValue);
				}
			}
		}
	}

}
