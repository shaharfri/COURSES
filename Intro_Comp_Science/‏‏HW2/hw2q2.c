#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <math.h>

int main()
{
	int length = 0, seq = 0, counter = 0, n = 1, i = 0;
	printf("Please enter a length:\n");
	scanf("%d", &length);
	printf("Please enter a sequence:\n");
	int numbers[10] = { 0 };
	scanf("%d", &seq);
	if (length == 1 && seq >= 0 && seq <= 9) //if the length is 1
	{
		printf("The requested palindrome is: %d\n", seq);
		return 0;
	}
	n = seq;
	while (n > 0) //counter of the amount of characters.
	{
		n = n / 10;
		counter = counter + 1;
	}
	for (i = counter; i > 0; i--) //put all the characters in array
	{
		numbers[i - 1] = seq % 10;
		seq = seq / 10;
	}
	int j = 0, p = length - 1, Success = 0, failure = 0; //j and p are integers that compare parameters in numbers array
	if (length % 2 == 0) //if we got a double length
	{
		while (j < p)
		{
			if (numbers[j] == numbers[p])
			{
				j++;
				p--;
				Success++;
			}
			else
			{
				if (Success == 1)
				{
					p = p + 2;
					Success = 0;
					++failure;
					if (p > counter)
					{
						printf("There is no such palindrome.\n");
						return 0;
					}
				}
					else 
					{
					j++;
					p++;
					Success = 0;
					++failure;
						if (p > counter)
						{
						printf("There is no such palindrome.\n");
						return 0;
						}
					}	
							
			}

		}
		if (Success == length / 2)
		{
			printf("The requested palindrome is: ");
			for (; length > 0; length--, failure++)
			{
				printf("%d", numbers[failure]);
			}
			return 0;
		}
		else
		{
			printf("There is no such palindrome.\n");
			return 0;
		}
	}

	if (length % 2 != 0) //if we got an odd number length
	{
		while (j != p)
		{
			if (numbers[j] == numbers[p])
			{
				j++;
				p--;
				Success++;

			}
			else 
				if (Success == 1)
				{
					p = p + 2;
					Success = 0;
					++failure;
					if (p > counter)
					{
						printf("There is no such palindrome.\n");
						return 0;
					}
				}
				else
				{
				j++;
				p++;
				Success = 0;
				++failure;
				if (p > counter)
					{
					printf("There is no such palindrome.\n");
					return 0;
					}
				}

		}
		if (Success == length - 2)
		{
			printf("The requested palindrome is: ");
			for (; length > 0; length--, failure++)
			{
				printf("%d", numbers[failure]);
			}
			return 0;
		}

		else
		{
			printf("There is no such palindrome.\n");
			return 0;
		}
	}
}




		
	
