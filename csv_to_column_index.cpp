#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
using namespace std;

/*
Main method takes two arguments. 
First is the input file to be read into files, each containing a single column of data.
Next is the column to index.
*/
int main(int argc, char* argv[])
{
 cout << "Running " << argv[0] << '\n';
 cout << "Input file: " << argv[1] << '\n';
 cout << "Column to index: " << argv[2] << '\n';
 
 int col = std::atoi(argv[2]);
 ofstream outFile;

 cout << "\nCreating output file..."; 
 cout << '\n' << '\t' << "Created: output.col";
 outFile.open("output.col");   

 cout << "\n\nFilling column file from input..." ;

 // create input file
 std::ifstream infile(argv[1]);
 
 std::string line;
 int lineCount = 0;
 // read line by line and write to each output file
 while (std::getline(infile, line))
 { 
   std::string token;
   std::istringstream iss(line);
   int i = 0;
   while(std::getline(iss, token, ',')) 
   {
    if(i == col)
    {
      outFile << token <<  '\n';
    }
    i++;
   }
   lineCount++;
 }

 cout << "\n\nFinished.\n";
 //exit

}
