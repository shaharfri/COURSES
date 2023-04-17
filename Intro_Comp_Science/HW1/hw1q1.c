#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main()
{
	printf("Welcome, please enter the weights of each ingredient:\n");
	double ingredients = 1, sum = 0, counter = 0;
	///input from walter
	while (ingredients >= 0)
	{
		if (scanf("%lf", &ingredients) != 1)
		{
			return 0;
		}
		if (ingredients >= 0) {
			sum = sum + ingredients;
			counter = counter + 1;
		}
	}
	///walter put less then 3 parameters
		if (counter < 3) {
		printf("Not enough ingredients.\n");
		return 0;
	}
	else
		///walter put more then 10 parameters
		if (counter > 10) {
			printf("Too many ingredients.\n");
			return 0;
		}
		else {
			double weight = sum / counter;
			int purity = counter * 10;
			printf("The final product weighs %.3lf pounds and is %d percent pure.\n", weight, purity);
		}
}



