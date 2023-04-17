#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#define PASS_GRADE 55

/**
 * @brief swap between the values between two pointers
 * @param a pointer to first value
 * @param b pointer to second value
 */
void swap(int *a, int *b)
{
    int t = *a;
    *a = *b;
    *b = t;
}

/**
 * @brief partition an array into an array that all its values are lower than 
 * the value in the returned index and the second array having all its values
 * larger than the value in the returned index
 * @param arr The array to partiotion
 * @param low The value of the lowest index of the subarray to partition
 * @param high The value of the highest index in the subarray to partition
 * @return index of value that seperates the two sub arrays
 */
int partition(int arr[], int low, int high)
{
    int pivot = arr[high];
    int i = (low - 1);
    for (int j = low; j <= high - 1; j++)
    {
        if (arr[j] <= pivot)
        {
            i++;
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[i + 1], &arr[high]);
    return (i + 1);
}

/**
 * @brief sort a given array from smallest value to largets.
 * @param arr the array to sort
 * @param low The start of the array
 * @param high the end of the array
 */
void quickSort(int arr[], int low, int high)
{
    if (low < high)
    {
        int pi = partition(arr, low, high);
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

/**
 * @brief calculate how many students are there
 * @param filename The file we check
 * @return number of students in the grades file
 */
int getStudentNum(FILE *grades)
{
    int lines = 0;
    fseek(grades, 0, SEEK_SET); /* put pointer in begining of file*/
    /* scan file and every time we reach end of line char we count a new line */
    int c;
    while ((c = getc(grades)) != EOF)    
    {
        if (c == '\n')
        {
            lines = lines + 1;
        }
    }
    return lines;
}

/**
 * @brief transfer all grades from file to array
 * @param grades The file containing the grades
 * @param grade_list The new array that we will fill with grades
 * @param numOfStudents the total number of students that have grades
 */
void createGradeList(FILE *grades, int grade_list[], int numOfStudents)
{
    int curr_grade = 0;
    int line = 0;
    int curr_number = 1;
    fseek(grades, 0, SEEK_SET); /* put pointer in begining of file*/
    int c;
    while ((c = getc(grades)) != EOF)
    {
        /* scan file for new line chars, sum values till newline than reset */
        if (c != '\n')
        { /*  calc using ascii */
            curr_grade = (c - '0') + curr_grade * curr_number; 
            curr_number *= 10;
        }
        else
        {
            curr_number = 1;
            grade_list[line] = curr_grade;
            curr_grade = 0;
            line++;
        }
    }
}

/**
 * @brief get the max(highest) grade
 * @param grade_list array containing the grades
 * @param numOfStudents the total number of students 
 * @return The highest grade in grade_list
 */
int getMax(int grade_list[], int numOfStudents)
{
    int max = 0;
    for (int i = 0; i < numOfStudents; i++)
    {
        if (grade_list[i] > max)
        {
            max = grade_list[i];
        }
    }
    return max;
}
/**
 * @brief get the min(lowest) grade 
 * @param grade_list array containing the grades
 * @param numOfStudents the total number of students
 * @return the lowerst grade in grade_list 
 */
int getMin(int grade_list[], int numOfStudents)
{
    int min = 100;
    for (int i = 0; i < numOfStudents; i++)
    {
        if (grade_list[i] < min)
        {
            min = grade_list[i];
        }
    }
    return min;
}

/**
 * @brief calculate the average grade in class
 * @param grade_list array containing the grades
 * @param numOfStudents the total number of students 
 * @return The average grade in class
 */
double getAverage(int grade_list[], int numOfStudents)
{
    if (numOfStudents == 0)
    {
        return 0;
    }
    double average = 0;
    for (int i = 0; i < numOfStudents; i++)
    {
        average += grade_list[i]; /* get summ of all grades */
    }
    average = average / numOfStudents; /* divide by total students for avrg */
    /* round to only 3 points after dot */
    average *= 1000;
    average = round(average);
    return average / 1000;
}

/**
 * @brief get the median grade in class
 * @param grade_list array containing the grades
 * @param numOfStudents the total number of students 
 * @return The median grade in class
 */
int getMedian(int grade_list[], int numOfStudents)
{
    if (numOfStudents == 0)
    {
        return 0;
    }
    quickSort(grade_list, 0, numOfStudents - 1);
    /* median is the student in spot (totalStudents +1)/2 */
    return grade_list[(numOfStudents + 1) / 2];
}

/**
 * @brief get the precentage of students who passed the class
 * @param grade_list array containing the grades
 * @param numOfStudents the total number of students 
 * @return the precentage of students who passed the class
 */
double getPassPrecentage(int grade_list[], int numOfStudents)
{
    if (numOfStudents == 0)
    {
        return 0;
    }
    int left = 0, right = numOfStudents - 1;
    int mid;
    while (left < right) /* binary search for first student that passed */
    {
        mid = (left + right) / 2;
        if (grade_list[mid] < PASS_GRADE)
        {
            left = mid + 1;
        }
        else if (grade_list[mid] > PASS_GRADE)
        {
            right = mid - 1;
        }
        else
            break;
    }
    if (grade_list[mid] < 55)
    {
        mid++;
    }
    /* calc the precent (totalPassedStudents/TotalStudents) * 100 */
    double passed = numOfStudents - mid;
    double precent = (passed / numOfStudents) * 100;
    /* round to only 2 spots after the dot */
    precent *= 100;
    precent = round(precent);
    return precent / 100;
}
/**
 * @brief reset all values of 10x10 array to 0
 * @param histograma The array to reset
 */
void resetArray(int histograma[10][10])
{
    for (int i = 0; i < 10; i++)
    {
        for (int j = 0; j < 10; j++)
        {
            histograma[i][j] = 0;
        }
    }
}

/**
 * @brief creates a histograma of grades from a given grade list
 * @param grade_list The list to get grades from
 * @param numOfStudents Total num of students
 * @param histograma The array to write histograma into
 */
void createHistograma(int grade_list[],
                      int numOfStudents,
                      int histograma[10][10])
{
    resetArray(histograma);
    for (int i = 0; i < numOfStudents; i++)
    {
        if (grade_list[i] != 0)
        {
            int col = grade_list[i] % 10 - 1;
            int rows = grade_list[i] / 10;
            histograma[rows][col]++;
        }
    }
}

/**
 * @brief print all values of an array into a text file.
 * @param course_statistics Text file to print into
 * @param arr The array to print
 */
void printArr(FILE *course_statistics, int arr[10][10])
{
    for (int i = 0; i < 10; i++)
    {
        for (int j = 0; j < 10; j++)
        {
            fprintf(course_statistics, "%d", arr[i][j]);
            if(j < 9)
            {
                fprintf(course_statistics, " ");
            }
            if (j == 9)
            {
                fprintf(course_statistics, "\n");
            }
        }
    }
}

/**
 * @brief this method calculates min,max,median,average grade, pass precentage 
 * and histograma from a given grade.txt and prints results into a new txt file
 * @param argc number of arguments passed to the program
 * @param argv arr of strings, each string is an argument passed to the program
 * @return a new text file containing min,max,median,average grade, 
 * pass precentage and histograma.
 */
int main(int argc, char *argv[])
{
    if (argc < 1)
    {
        fprintf(stderr, "Error\n");
        return 1;
    }

    FILE *course_statistics, *grades;
    if ((course_statistics = fopen(argv[1], "w")) == NULL)
    {
        fprintf(stderr, "Error- Unable to open %s\n", "course_statistics.txt");
        exit(-1);
    }

    if ((grades = fopen(argv[2], "r")) == NULL)
    {
        fprintf(stderr, "Error- Unable to open %s\n", "grades.txt");
        exit(-2);
    }
    /* calc the number of students and create an array of grades */
    int numOfStudents = getStudentNum(grades);
    int grade_list[numOfStudents];
    createGradeList(grades, grade_list, numOfStudents);
    /* create histograma*/
    int histograma[10][10];
    createHistograma(grade_list, numOfStudents, histograma);
    /* get all needed values */
    int maxGrade = getMax(grade_list, numOfStudents);
    int minGrade = getMin(grade_list, numOfStudents);
    double averageGrade = getAverage(grade_list, numOfStudents);
    int medianGrade = getMedian(grade_list, numOfStudents);
    double passPrecent = getPassPrecentage(grade_list, numOfStudents);
    /* print all needed values */
    fprintf(course_statistics, "num of students = %d\n", numOfStudents);
    fprintf(course_statistics, "avg = %.3f\n", averageGrade);
    fprintf(course_statistics, "the median is - %d\n", medianGrade);
    fprintf(course_statistics, "max grade = %d, min grade = %d\n",
            maxGrade, minGrade);
    fprintf(course_statistics, "pass rate = %.2f%%\n", passPrecent);
    printArr(course_statistics, histograma);

    /* close all files we opened. */
    fclose(grades);
    fclose(course_statistics);

    return 0;
}
