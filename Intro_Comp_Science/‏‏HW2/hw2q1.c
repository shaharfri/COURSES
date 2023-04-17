#define _CRT_SECURE_NO_WARNINGS
#define N 4
#include <stdio.h>
#include <stdbool.h>



int is_strong(int mat[N][N], int row, int column)
{
bool strong = 0, equal = 0;
int my_value = mat[row][column];
int up_value = mat[row - 1][column], down_value = mat[row + 1][column];
int right_value = mat[row][column + 1], left_value = mat[row][column - 1];
//cheking if a number is equal to one of his neighboors
equal = (my_value - up_value) * (my_value - down_value)
	* (my_value - right_value) * (my_value - left_value);
//cheking if a number is smaller then one of his neighboors
bool bigger_up = (my_value - up_value > 0 || row == 0);
bool bigger_down = (my_value - down_value > 0 || row == N - 1);
bool bigger_left = (my_value - left_value > 0 || column == 0);
bool bigger_right = (my_value - right_value > 0 || column == N - 1);
bool bigger = bigger_left * bigger_right * bigger_up * bigger_down;
//the pionter of our number 
strong =(bigger * equal);
return (strong);
}



int space_rank(int mat[N][N], int row, int column)
{
	bool edge = (column != N - 1);
//what is the distance between 2 numbers
bool delta = ((mat[row][column] - mat[row][column + 1]) >= 0);
//making the distance positive
int positive_or_negative = (delta - 1) * 2 + 1;
int rank = ((mat[row][column]) - (mat[row][column + 1]))
		* positive_or_negative*edge;
return (rank);
}

int main()
{
	int mat[N][N] = { {0} };
	int row = 0, column = 0, sum_strong = 0, sum_rank = 0;
	printf("Please enter a matrix:\n");
	for (row = 0; row  < 4; row++ )
	{
		for (column = 0; column < 4; column++)
		{
			scanf("%d", &mat[row][column]);
		}
	}
	for (row = 0; row < 4; row++)
	{
		for (column = 0; column < 4; column++)
		{
			sum_strong = sum_strong + is_strong(mat, row, column);
			sum_rank = sum_rank + space_rank(mat, row, column);
		}
	}
	printf("Strong elements: %d\n", sum_strong);
	printf("Space rank: %d\n", sum_rank);
	return 0;
}



