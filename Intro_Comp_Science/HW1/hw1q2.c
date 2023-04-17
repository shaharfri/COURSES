#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main()
{
	char letter = 0, big_letter = 0, sequence = 0;
	int counter = 0;
	printf("Enter letter to count:\n");
	scanf(" %c", &letter);
	if (letter <= 'Z' && letter >= 'A') // בדיקה האם קלטנו אות גדולה
	{
		big_letter = letter + 32;
	}
	else if (letter >= 'a' && letter <= 'z') // בדיקה האם קלטנו אות קטנה
	{
		big_letter = letter - 32;
	}
	else { return 0; } // יציאה במצב שלא קיבלנו בכלל אות
		printf("Enter the char sequence:\n");
	scanf(" %c", &sequence); // קליטת משפט
	while (sequence != '#') // תנאי להתעסקות עם הקלט עד אשר יוזן #
	{
		if (sequence == letter) // בדיקה אם קיימת במשפט האות הקטנה
		{
			counter = counter + 1;
		}
		if (sequence == big_letter) // בדיקה אם קיימת במשפט האות הגדולה
		{
			counter = counter + 1;
		}
		scanf(" %c", &sequence);
	}
	printf("The letter appeared %d times\n", counter);
	return 0;
}