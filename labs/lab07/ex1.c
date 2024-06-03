#include <time.h>
#include <stdio.h>
#include <x86intrin.h>
#include "ex1.h"

long long int sum(int vals[NUM_ELEMS]) {
    clock_t start = clock();

    long long int sum = 0;
    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        for(unsigned int i = 0; i < NUM_ELEMS; i++) {
            if(vals[i] >= 128) {
                sum += vals[i];
            }
        }
    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return sum;
}

long long int sum_unrolled(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    long long int sum = 0;

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
            if(vals[i] >= 128) sum += vals[i];
            if(vals[i + 1] >= 128) sum += vals[i + 1];
            if(vals[i + 2] >= 128) sum += vals[i + 2];
            if(vals[i + 3] >= 128) sum += vals[i + 3];
        }

        // TAIL CASE, for when NUM_ELEMS isn't a multiple of 4
        // NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
        // Order is important, since (NUM_ELEMS / 4) effectively rounds down first
        for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
            if (vals[i] >= 128) {
                sum += vals[i];
            }
        }
    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return sum;
}

long long int sum_simd(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    __m128i _127 = _mm_set1_epi32(127); // This is a vector with 127s in it... Why might you need this?
    long long int result = 0; // This is where you should put your final result!
    /* DO NOT MODIFY ANYTHING ABOVE THIS LINE (in this function) */

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        /* YOUR CODE GOES HERE */
        __m128i sum = _mm_setzero_si128();
        unsigned int end = NUM_ELEMS / 4 * 4;
        for (unsigned int i = 0; i < end; i += 4) {
            __m128i temp = _mm_loadu_si128((__m128i*)(vals+i));
            temp = _mm_and_si128(temp, _mm_cmpgt_epi32(temp, _127));
            sum = _mm_add_epi32(sum, temp);
        }
        int t[4];
        _mm_storeu_si128((void*)t, sum);
        result += (long long int)t[0] + t[1] + t[2] + t[3];
        for (unsigned int i = end; i < NUM_ELEMS; i++)
        {
            if (vals[i] >= 128) result += vals[i];
        }
    }

    /* DO NOT MODIFY ANYTHING BELOW THIS LINE (in this function) */
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return result;
}

long long int sum_simd_unrolled(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    __m128i _127 = _mm_set1_epi32(127);
    long long int result = 0;
    /* DO NOT MODIFY ANYTHING ABOVE THIS LINE (in this function) */

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        __m128i sum = _mm_setzero_si128();
        __m128i sum0 = _mm_setzero_si128();
        __m128i sum1 = _mm_setzero_si128();
        __m128i sum2 = _mm_setzero_si128();
        __m128i sum3 = _mm_setzero_si128();
        int end = NUM_ELEMS / 16 * 16;
        for (unsigned int i = 0; i < end; i += 16) {
            __m128i temp0 = _mm_loadu_si128((__m128i*)&vals[i]);
            __m128i temp1 = _mm_loadu_si128((__m128i*)&vals[i+4]);
            __m128i temp2 = _mm_loadu_si128((__m128i*)&vals[i+8]);
            __m128i temp3 = _mm_loadu_si128((__m128i*)&vals[i+12]);
            temp0 = _mm_and_si128(temp0, _mm_cmpgt_epi32(temp0, _127));
            temp1 = _mm_and_si128(temp1, _mm_cmpgt_epi32(temp1, _127));
            temp2 = _mm_and_si128(temp2, _mm_cmpgt_epi32(temp2, _127));
            temp3 = _mm_and_si128(temp3, _mm_cmpgt_epi32(temp3, _127));
            sum0 = _mm_add_epi32(sum0, temp0);
            sum1 = _mm_add_epi32(sum1, temp1);
            sum2 = _mm_add_epi32(sum2, temp2);
            sum3 = _mm_add_epi32(sum3, temp3);
        }
        sum = _mm_add_epi32(sum, sum0);
        sum = _mm_add_epi32(sum, sum1);
        sum = _mm_add_epi32(sum, sum2);
        sum = _mm_add_epi32(sum, sum3);
        end = NUM_ELEMS / 4 * 4;
        for (unsigned int i = NUM_ELEMS / 16 * 16; i < end; i += 4)
        {
            __m128i temp = _mm_loadu_si128((__m128i*)(vals+i));
            temp = _mm_and_si128(temp, _mm_cmpgt_epi32(temp, _127));
            sum = _mm_add_epi32(sum, temp);
        }
        int t[4];
        _mm_storeu_si128((void*)t, sum);
        result += (long long int)t[0] + t[1] + t[2] + t[3];
        for (unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++)
        {
            if (vals[i] >= 128) result += vals[i];
        }
    }

    /* DO NOT MODIFY ANYTHING BELOW THIS LINE (in this function) */
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return result;
}
