#include <stdlib.h>
#include <math.h>
#include <fftw3.h>
#include <bits/stdc++.h>
#include <chrono>
#include <sstream>
#include <cmath>
const double PI = 3.141592653589793238460;

int main(int argc, char *argv[]) {
  if (argc == 0)
	{
        std::cout << "Usage: ./fftw3 N" << '\n';
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
        fftw_complex* in, *out, *in2;
        in = new fftw_complex[N];
        out = new fftw_complex[N];
        in2 = new fftw_complex[N];

        fftw_plan p, q;
        int i;

        /* prepare a cosine wave */
        for (i = 0; i < N; i++) {
          in[i][0] = cos(3 * 2*PI/N);
          in[i][1] = 0;
        }

        double time_taken = 0;
        for (int i = 0; i < 10; ++i)
        {
            /* forward Fourier transform, save the result in 'out' */
            auto start = std::chrono::high_resolution_clock::now();
            p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
            fftw_execute(p);
            auto end = std::chrono::high_resolution_clock::now();
            auto time_taken_1 = end - start;
            std::cout << "Forward transform took "
            << std::chrono::duration_cast<std::chrono::milliseconds>(time_taken_1).count() << " ms\n";
            time_taken += time_taken_1 / std::chrono::milliseconds(1);
        }
        printf("Time taken by forward transform is %9.5f ms\n", time_taken / 10);
        fftw_destroy_plan(p);
        fftw_cleanup();
        delete[] in;
        delete[] out;
        delete[] in2;
    }

  return 0;
}
