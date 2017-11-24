#include <fstream>
#include <iostream>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>

using namespace std;

 
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
 
 
    for(int i=0; i < numOfDigits; i++, x/=10, y/10)
    { 
      if(x % 10 == y % 10)
      {
        // do nothing
      }
      else if(x % 10 > y % 10)
      {
        return false;
      }
	  else
	  {
        return true;
      }                    
    }

    return false;
  }
};
 
 
/*
Sorts the file, line by line lexicographically.
*/
int main() {

  ifstream ifile("col1.txt");
  int num = 3;
  
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