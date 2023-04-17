
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

#define SIZE 10000

int is_prime(int num);

int main() 
{
	int hist[SIZE] = {0};
	int A = 1;
	int order = 0;
	int order_count = 0;
	int count = 0;
	int factor = 2;
	int number = 0;
	int tmp_number = 0;

	scanf("%d", &number);

	//specific case of input=1
	if (number == 1)				
	{
		return number;
	}

	else 
	{
		tmp_number = number;

		//we make factorization histogram until we reach to 1
		while (tmp_number >= 2)
		{
			if ((tmp_number % factor == 0) && (is_prime(factor)))
			{
				order++;
				hist[factor]++;
				tmp_number = tmp_number / factor;
			}

			else 
			{
				factor++;
			}
		}

		/*The output will contain all the prime factors
		  that divides it at least once */
		for (int i = 0; i < SIZE; i++)
		{
			if (hist[i] > 0) 
			{
				A = A * i;
				order_count++;
				hist[i]--;
			}
		}

		//Cheking if what we did so far enough for us
		if (order_count == 1 && order == 2)
		{
			return A;
		}

		/*We pass on the current histogram and duplicate our
		  A with the smallest prime that still left */
		while ((pow(order_count, order_count) < order) && (count < SIZE))
		{

			if (hist[count] > 0) 
			{
				hist[count]--;
				A = A * count;
				order_count++;
				count = 0;
			}

			else 
			{
				count++;
			}
		}

		//Cheking if what we did so far enough for us
		if (pow(order_count, order_count) >= order)
		{
			printf("%d", A);
		}

		else 
		{
			printf("There is no number");
		}
	}

	return 0;
}

/**
 * @brief A function to check if a number is prime
 * @param num The given number
 */
int is_prime(int num)
{
	int i = 2;
	while (i < num) {
	
		if (num % i == 0) {
			return 0;
		}

		else {
			i++;
		}
	}
	return 1;
}