#include <fstream>
#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>
#include <thrust/random.h>

using namespace std;

/*
Compares two integers lexicographically from least to greatest. 

First the input integers are reversed. Next reversed integers are traversed from right to left using mod 10 and divide 10 operations. The operator returns as soon as a digit is found that is not the same.

If all digits compared in the loop are the same, then the lengths of the input integers are compared and the operator returns the longer of the two input integers as being greater.
*/
struct lex_comparator
{
  __host__ __device__
  bool operator()(thrust::pair<int, char*> xPair, thrust::pair<int, char*> yPair)
  {
    int x = xPair.first;
    int y = yPair.first;
    unsigned numOfDigits;
  
    if (x > y) {
     numOfDigits = log10f(x) + 1;
    }
    else
    {
     numOfDigits = log10f(y) + 1;
    }
 
    int rX = 0, rY = 0, remainderX, remainderY;
 
    while(x != 0)
    {
        remainderX = x%10;
        rX = rX*10 + remainderX;
        x /= 10;
    }
 
     while(y != 0)
    {
        remainderY = y%10;
        rY = rY*10 + remainderY;
        y /= 10;
    }
 

    for(int i=0; i < numOfDigits; i++, rX/=10, rY/=10)
    { 
      if(rX % 10 == rY % 10)
      {
      // do nothing
      }
      else if(rX % 10 > rY % 10)
      {
        return false;
      }
      else
      {
        return true;
      }  
    }
 
 
   int numOfDigitsX = log10f(x) + 1;
   int numOfDigitsY = log10f(y) + 1;
 
 
   if(numOfDigitsY < numOfDigitsX) {
      return true;
   } else {
     return false;
   }
 
  }
};
 
                                  
void print(const thrust::device_vector< thrust::pair<int, char*> >& v)
{
  for(size_t i = 0; i < v.size(); i++)
  {
    thrust::pair<int, char*> p = v[i];
    cout << "Column value: " << p.first << " => Row: " << p.second << "\n";
  }
  cout << "\n";
}
 
void printToFile(const thrust::device_vector< thrust::pair<int, char*> >& v, char* file)
{
  ofstream myfile;
  myfile.open (file);
 
  for(size_t i = 0; i < v.size(); i++)
  {
    thrust::pair<int, char*> p = v[i];
    myfile << p.first << " " << p.second << '\n';
  }
  myfile.close();
}


                                  
void initializePairs(thrust::device_vector< thrust::pair<int, char*> >& v, char* inputFile, char* colfile)
{
  // read file
  ifstream ifile(colfile);
  istream_iterator<int> beg(ifile); 
  std::ifstream infile(inputFile);

  std::string line;
  int i = 0;
  while (std::getline(infile, line))
  {
    char *cstr = new char[line.length() + 1];
    strcpy(cstr, line.c_str());
    v[i++] = thrust::make_pair(*beg++, cstr);
  }
}
 
 
/*
Sorts the input file, line by line lexicographically based on the given column file.
 
Results in a file of pairs. Each pair has a key of column value and value of entire row.
*/
int main(int argc, char* argv[]) 
{

  cout << "Running " << argv[0] << '\n';
  cout << "Input file: " << argv[1] << '\n';
  cout << "Column file: " << argv[2] << '\n';
  cout << "Number of values: " << argv[3] << '\n';
  cout << "Output file: " << argv[4] << '\n';
 
  // num of columns
  int num = std::atoi(argv[3]);
  
  // device vector
  thrust::device_vector< thrust::pair<int, char*> > pairs(num);
  
  // initialie device vector from files
  initializePairs(pairs, argv[1], argv[2]);
  
  // for debugging
  print(pairs);
  
  // sort by key using lex comparator
  thrust::sort(pairs.begin(), pairs.end(), lex_comparator());
  
  // print output to file
  printToFile(pairs, argv[4]);

  return 0;
}
