# fft_19
### Usage:
```
make
./lib_fft N
./my_fft N
```

##    1. Сравнение реализации из бибилиотеки и собственной реализации
###   в качестве входных данных - in[i][0] = cos(3 * 2*M_PI*i/N); in[i][1] = 0;

**lib_implementation.cpp**  
~/fft_19$ ./lib_fft 10  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Time taken by forward transform is   0.00000 ms  

~/fft_19$ ./lib_fft 15  
Forward transform took 4 ms  
Forward transform took 1 ms  
Forward transform took 1 ms  
Forward transform took 1 ms  
Forward transform took 1 ms  
Forward transform took 1 ms  
Forward transform took 1 ms  
Forward transform took 1 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Time taken by forward transform is   1.10000 ms  

~/fft_19$ ./lib_fft 17  
Forward transform took 13 ms  
Forward transform took 5 ms  
Forward transform took 6 ms  
Forward transform took 5 ms  
Forward transform took 6 ms  
Forward transform took 5 ms  
Forward transform took 5 ms  
Forward transform took 6 ms  
Forward transform took 5 ms  
Forward transform took 6 ms  
Time taken by forward transform is   6.20000 ms  

~/fft_19$ ./lib_fft 20  
Forward transform took 89 ms  
Forward transform took 83 ms  
Forward transform took 82 ms  
Forward transform took 82 ms  
Forward transform took 83 ms  
Forward transform took 83 ms  
Forward transform took 84 ms  
Forward transform took 82 ms  
Forward transform took 82 ms  
Forward transform took 83 ms  
Time taken by forward transform is  83.30000 ms  

**my_fft.cpp**  
~/fft_19$ ./my_fft 10  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Forward transform took 0 ms  
Time taken by forward transform is   0.00000 ms  

~/fft_19$ ./my_fft 15  
Forward transform took 3 ms  
Forward transform took 3 ms  
Forward transform took 3 ms  
Forward transform took 3 ms  
Forward transform took 3 ms  
Forward transform took 3 ms  
Forward transform took 3 ms  
Forward transform took 3 ms  
Forward transform took 3 ms  
Forward transform took 3 ms  
Time taken by forward transform is   3.00000 ms  


~/fft_19$ ./my_fft 17  
Forward transform took 17 ms  
Forward transform took 20 ms  
Forward transform took 19 ms  
Forward transform took 18 ms  
Forward transform took 18 ms  
Forward transform took 17 ms  
Forward transform took 17 ms  
Forward transform took 17 ms  
Forward transform took 17 ms  
Forward transform took 17 ms  
Time taken by forward transform is  17.70000 ms   

~/fft_19$ ./my_fft 20  
Forward transform took 356 ms  
Forward transform took 364 ms  
Forward transform took 374 ms  
Forward transform took 374 ms  
Forward transform took 360 ms  
Forward transform took 361 ms  
Forward transform took 363 ms  
Forward transform took 361 ms  
Forward transform took 359 ms  
Forward transform took 356 ms  
Time taken by forward transform is 362.80000 ms  

##    2. Проверка на совпадение после преобразования
###      осуществляется внутри my_fft.cpp
  - файл с исходными данными: original_data.txt  
  - файл с данными после обратного преобразования: after_ifft_data.txt  
