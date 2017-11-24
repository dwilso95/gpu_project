#include <fstream>
#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>

using namespace std;

/*
Compares two integers lexicographically from least to greatest. 

First the input integers are reversed. Next reversed integers are traversed from right to left using mod 10 and divide 10 operations. The operator returns as soon as a digit is found that is not the same.

If all digits compared in the loop are the same, then the lengths of the input integers are compared and the operator returns the longer of the two input integers as being greater.
*/
struct lex_comparator
{
  __host__ __device__
  bool operator()(int x, int y)
  {
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
 
 
/*
Sorts the file, line by line lexicographically.
*/
int main(int argc, char* argv[]) 
{

  cout << "Running " << argv[0] << '\n';
  cout << "Input file: " << argv[1] << '\n';
  cout << "Number of values: " << argv[2] << '\n';
 
  ifstream ifile(argv[1]);
  int num = std::atoi(argv[2]);
  
  // create host vector of size num
  thrust::host_vector<int> H(num);
  
  // read file
  istream_iterator<int> beg(ifile), end;
 
  // copy into host vecotr
  thrust::copy(beg, end, H.begin());
 
  // crete device vector
  thrust::device_vector<int> D(num);
 
  // copy host vector to device vector
  thrust::copy(H.begin(), H.end(), D.begin());
 
  ifile.close();

  // thrust::sort(D.begin(), D.end());
  thrust::sort(D.begin(), D.end(), lex_comparator());
 
  // copy device vector to host vector
  thrust::copy(D.begin(), D.end(), H.begin());
 
 
  // create output file
  ofstream ofile("sort.txt");
 
  // copy host vector to output file
  thrust::copy(H.begin(), H.end(), ostream_iterator<int>(ofile, "\n"));

  ofile.close();
 
  return 0;
}