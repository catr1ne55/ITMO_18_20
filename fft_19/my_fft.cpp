#include <bits/stdc++.h>
#include <complex>
#include <iostream>
#include <valarray>
#include <chrono>
#include <sstream>
#include <cmath>
#include <fstream>
using namespace std;

typedef std::complex<double> Complex;
typedef std::valarray<Complex> CArray;

const double PI = 3.141592653589793238460;

// Cooley–Tukey FFT (in-place, divide-and-conquer)
void fft(CArray& x)
{
    unsigned int N = x.size(), k = N, n;
	double thetaT = 3.14159265358979323846264338328L / N;
	Complex phiT = Complex(cos(thetaT), -sin(thetaT)), T;
	while (k > 1)
	{
		n = k;
		k >>= 1;
		phiT = phiT * phiT;
		T = 1.0L;
		for (unsigned int l = 0; l < k; l++)
		{
			for (unsigned int a = l; a < N; a += n)
			{
				unsigned int b = a + k;
				Complex t = x[a] - x[b];
				x[a] += x[b];
				x[b] = t * T;
			}
			T *= phiT;
		}
	}
	// Decimate
	unsigned int m = (unsigned int)log2(N);
	for (unsigned int a = 0; a < N; a++)
	{
		unsigned int b = a;
		// Reverse bits
		b = (((b & 0xaaaaaaaa) >> 1) | ((b & 0x55555555) << 1));
		b = (((b & 0xcccccccc) >> 2) | ((b & 0x33333333) << 2));
		b = (((b & 0xf0f0f0f0) >> 4) | ((b & 0x0f0f0f0f) << 4));
		b = (((b & 0xff00ff00) >> 8) | ((b & 0x00ff00ff) << 8));
		b = ((b >> 16) | (b << 16)) >> (32 - m);
		if (b > a)
		{
			Complex t = x[a];
			x[a] = x[b];
			x[b] = t;
		}
	}
}
// inverse fft (in-place)
void ifft(CArray& x)
{
    // conjugate the complex numbers
    x = x.apply(std::conj);

    // forward fft
    fft( x );

    // conjugate the complex numbers again
    x = x.apply(std::conj);

    // scale the numbers
    x /= x.size();
}


int main(int argc, char *argv[])
{
  if (argc == 0)
	{
        std::cout << "Usage: ./my_fft N" << '\n';
        exit(1);
    }

  if (argc >= 2)
    {
        std::istringstream iss( argv[1] );
        int val;
        if ((iss >> val) && iss.eof()) // Check eofbit
        {
            // Conversion successful
        }

        const int N = pow(2, val);
        Complex* test = new Complex[N];

        for (int i = 0; i < N; ++i)
        {
             test[i] = cos(3 * 2*PI/N);
        }
        CArray data(test, N);

     	std::cout << "Original data:" << std::endl;
		ofstream fout;
		fout.open("original_data.txt");
     	for (int i = 0; i < N; ++i)
     	{
			fout << data[i] << '\n';

     	}
		fout.close();

        fft(data);

		ofstream ffout;
		ffout.open("after_fft_data.txt");
		std::cout << std::endl << "Result of forward fft:" << std::endl;
		for (int i = 0; i < N; ++i)
		{
			ffout << data[i] << '\n';
		}
		ffout.close();

		ifft(data);

		ofstream ifout;
		ifout.open("after_ifft_data.txt");
		std::cout << std::endl << "Result of inverse fft:" << std::endl;
		for (int i = 0; i < N; ++i)
		{
			ifout << data[i] << '\n';
		}
		ifout.close();

		// Time measurement:

        double time_taken = 0;
        for (int i = 0; i < 10; ++i)
        {
            auto start = std::chrono::high_resolution_clock::now();
            fft(data);
            auto end = std::chrono::high_resolution_clock::now();
            auto time_taken_1 = end - start;
            std::cout << "Forward transform took "
            << std::chrono::duration_cast<std::chrono::milliseconds>(time_taken_1).count() << " ms\n";
            time_taken += time_taken_1 / std::chrono::milliseconds(1);
        }
        printf("Time taken by forward transform is %9.5f ms\n", time_taken / 10);
	}
    return 0;
}
