#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main()
{
	char letter = 0, big_letter = 0, sequence = 0;
	int counter = 0;
	printf("Enter letter to count:\n");
	scanf(" %c", &letter);
	if (letter <= 'Z' && letter >= 'A') // ����� ��� ����� ��� �����
	{
		big_letter = letter + 32;
	}
	else if (letter >= 'a' && letter <= 'z') // ����� ��� ����� ��� ����
	{
		big_letter = letter - 32;
	}
	else { return 0; } // ����� ���� ��� ������ ���� ���
		printf("Enter the char sequence:\n");
	scanf(" %c", &sequence); // ����� ����
	while (sequence != '#') // ���� �������� �� ���� �� ��� ���� #
	{
		if (sequence == letter) // ����� �� ����� ����� ���� �����
		{
			counter = counter + 1;
		}
		if (sequence == big_letter) // ����� �� ����� ����� ���� ������
		{
			counter = counter + 1;
		}
		scanf(" %c", &sequence);
	}
	printf("The letter appeared %d times\n", counter);
	return 0;
}