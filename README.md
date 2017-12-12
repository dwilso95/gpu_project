# GPU Final Project

## Objective:
Utililize GPU hardware and libraries to efficiently build Accumulo RFiles from record/row based data

## Background:
Apache Accumulo [1] is a structure data store based on Google BigTable. It offers two mechanisms for data ingest, "batch writing" data in small portions and "bulk importing" prebuild/formatted data. This format is called a Relative Key File (RFile) and is Accumulo's internal storage format for Key Value pairs. Rfiles are a type of Indexed Sequential Access Method [2] file. Accumulo only supports building RFiles using Hadoop MapReduce. Since MapReduce is itself a parallel algorithm, it seems a GPU could be utilized to perform a similar process.

## Scope:
This project will focus on converting a known CSV file into an RFile of a specific schema with the goal of identifying opportunities for generalization and abstraction of functions useful when creating RFiles. 

## Process:
1. Define data
2. Define an Accumulo schema
3. Generate data
4. Generate RFile
   - For each indexed column in data
     - Normalize/transform data if necessary
     - Generate key-value pairs
   - Sort all key-value pairs
   - Write sorted key-value in RFile format

## Execution:
See test instructions [readme](https://github.com/dwilso95/gpu_project/blob/master/test_instructions.md).

### References
[1] - Accumulo - https://accumulo.apache.org/  
[2] - ISAM - https://en.wikipedia.org/wiki/ISAM  
