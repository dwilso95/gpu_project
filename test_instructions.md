## Test Instructions

### CUDA

1. Build
   - [yourshell]$ g++ csv_to_column_index.cpp -std=c++0x -o csvToColumn
   - [yourshell]$ nvcc lex_sort_column.cu -o lex_sort
   - [yourshell]$ mvn -f rfile-ingest clean package

2. Execute with test data
   - [yourshell]$ ./csvToColumn test_files/noaa_500.txt 10
   - [yourshell]$ ./sort test_files/noaa_500.txt output.col 500 key_value.txt
   - [yourshell]$ java -cp target/rfile-ingest-0.0.1-SNAPSHOT.jar jhu.gpu.dwilso95.rfile.ingest.WriteRFile key_value.txt output.rf observations

### MapReduce

1. Build
   - [yourshell]$ mvn clean package
2. Execute
   - [yourshell]$ hadoop jar accumulo-mapreduce-ingest-0.0.1-SNAPSHOT.jar jhu.gpu.dwilso95.RFileMapReduce ${input.directory} ${output.directory} ${columnToIndex}:${columnName}
