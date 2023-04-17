#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#define N 11

int main()
{
	char character;
	int grade = 0;
	printf("Please enter a character:\n");
	scanf("%c", &character);
	int arr[N] = { 0 };
	printf("Please enter grades:\n");
	while ((scanf("%d", &grade)) != EOF) //input of grades and ordering in array
		{
		arr[grade]++;
		}
	int max = 0;
	int j = 0;
	int i= 0;
	for (i = 0; i < N; i++) //cheking the maximum duplicates grade
	{
		if (arr[i] > max)
		{
			for (j = 0; j < N; j++)
			{
				if (arr[i] >= arr[j] && arr[i] != 0)
				{
				max=arr[i];
				}
			}
		}
	}
	int count_down =max;
	printf("Histogram:\n");
	for (i = 0; i < max; i++) //printing the histogram
	{
		for (j = 1; j < N; j++)
		{
			if (arr[j]>=count_down)
				{
				printf("%c ", character);
				}
			else 
				{
				printf("  ");
				}
		}
		count_down--;
		printf("\n");
	}
	printf("1 2 3 4 5 6 7 8 9 10");
}
