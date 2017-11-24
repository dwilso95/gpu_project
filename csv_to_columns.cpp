#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
using namespace std;

/*
Main method takes two arguments. 
First is the input file to be read into files, each containing a single column of data.
Next is the number of columns in the file. ** This could be removed by counting columns in the future. **
*/
int main(int argc, char* argv[])
{
 cout << "Running " << argv[0] << '\n';
 cout << "Input file: " << argv[1] << '\n';
 cout << "Number of columns: " << argv[2] << '\n';
 
 int numCols = std::atoi(argv[2]);
 ofstream outFile[numCols];

 cout << "\nCreating columns files..."; 
 for (int i = 0; i < numCols; i++)
 {
  std::string colFileName = "col" + std::to_string(i) + ".txt"; 
  cout << '\n' << '\t' << "Created: " << colFileName;
  outFile[i].open(colFileName);   
 } 

 cout << "\n\nFilling column files from input..." ;

 // create output files
 std::ifstream infile(argv[1]);
 
 std::string line;
 // read line by line and write to each output file
 while (std::getline(infile, line))
 { 
   std::string token;
   std::istringstream iss(line);
   int i = 0;
   while(std::getline(iss, token, ',')) 
   {
    outFile[i] << token << '\n';
    i++;
   }
 }

 cout << "\n\nFinished.\n";
 //exit

}