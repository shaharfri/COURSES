// 123456789
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

#define HIST_LENGTH 10
#define MAX_LEN 1000
#define MIN_DIGIT 0
#define MAX_DIGIT 9

void create_histogram(char* string);

int main() {
    char input[MAX_LEN];
    scanf("%s", input);
    create_histogram(input);
    return 0;
}

/**
 * .
 * @brief Creates a frequency histogram of each digit in the input string
 * and prints it on the screen
 * @param string The input string
 */
void create_histogram(char *string)
{
    int distance;
    int freq_hist[HIST_LENGTH] = {0};

    int length = strlen(string);

    for (int i = 0; i < length; i++)
    {
        distance = string[i] - '0';
        if ((distance >= MIN_DIGIT) && (distance <= MAX_DIGIT))
        {
            freq_hist[distance]++;
        }
    }
    for (int i = 0; i < HIST_LENGTH - 1; i++)
    {
        printf("%d ", freq_hist[i]);
    }
    
    printf("%d\n", freq_hist[HIST_LENGTH - 1]);
}

