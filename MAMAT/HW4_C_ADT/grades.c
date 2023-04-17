#include "grades.h"
#include "linked-list.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "stdbool.h"

/* macros */
#define ERROR -1
#define WORKS 0
#define MAX_GRADE 100
#define MIN_GRADE 0

/* declaration of data structures */
struct grades {
    struct list *students;
};

struct student {
    int id;
    char *name;
    struct list *course;
};

struct course {
    char *course_name;
    int course_grade;
};

/* User functions for linked list*/
/* clone functions for our structs */
int course_clone(void *element, void **output) {
    struct course *course;
    struct course *out;

    course = (struct course*)element;
    *output = (struct course*)malloc(sizeof(*course));
    if (!(*output)) {
        return ERROR;
    }
    out = *output;
    out->course_name=(char*)malloc(sizeof(char)*strlen(course->course_name)+1);
    strcpy(out->course_name, course->course_name);
    out->course_grade = course->course_grade;
    return WORKS;
}

int student_clone(void *element, void **output) {
    struct student *student;
    struct student *out;

    student = (struct student*)element;
    *output = (struct student*)malloc(sizeof(*student));
    if (!(*output)) {
        return ERROR;
    }
    out = *output;
    out->name = (char*)malloc(sizeof(char)*(strlen(student->name)+1));
    strcpy(out->name, student->name);
    out->id = student->id;
    out->course = student->course;
    return WORKS;
}
/* destroy functions for our structs */
void course_destroy(void *element) {
    if (!(element)) {
        return;
    }

    struct course *course;
    course = (struct course*)element;

    free(course->course_name);
    free(course);
}

void student_destroy(void *element) {
    if (!(element)) {
        return;
    }

    struct student *student;
    student = (struct student*)element;

    free(student->name);
    list_destroy(student->course);
    free(student);
}

/* asisting functions */

/**
 * @brief Initializes the "course" data-structure.
 * @returns A pointer to the data-structure, of NULL in case of an error
 */
static struct course *course_init() {
    struct course *course;
    course = (struct course*)malloc(sizeof(*course));
    if (!course) {
        return NULL;
    }
    course->course_name = NULL;
    return course;
}

/**
 * @brief Initializes the "student" data-structure.
 * @returns A pointer to the data-structure, of NULL in case of an error
 */
static struct student *student_init() {
    struct student *student;
    student = (struct student*)malloc(sizeof(*student));
    if (!student) {
        return NULL;
    }
    student->course = list_init(course_clone, course_destroy);
    if (!student->course) {
        list_destroy(student->course);
        free(student);
        return NULL;
    }
    student->name = NULL;
    return student;
}

/**
 * @brief search a list of students for the student with a given id
 * @param list the list of students
 * @param id the id of the student we want to find
 * @return 0 if we didnt find the student with id in the list,
 * ERROR if we found him
 */
static int search_id(struct list *list, int id) {
    struct iterator *student = list_begin(list);
    struct student *tmp_student;
    while (student != NULL) {
        tmp_student = (struct student*)list_get(student);
        if (tmp_student->id == id) {
            return ERROR;
        }
        student = list_next(student);
    }
    return WORKS;
}

/**
 * @brief find the student with a given id
 * @param list The list of students
 * @param id The id of the student to find
 * @return the student with id
 */
static struct iterator *get_student(struct list *list, int id) {
    struct iterator *student = list_begin(list);
    struct student *tmp_student;
    while (student != NULL) {
        tmp_student = (struct student*)list_get(student);
        if (tmp_student->id == id) {
            return student;
        }
        student = list_next(student);
    }
    return NULL;
}

/**
 * @brief check if the grade is in the valid range
 * @param grade The grade to check
 * @return True if grade is valid, false otherwise
 */
static bool grade_valid(int grade) {
    if (grade <= MAX_GRADE && grade >= MIN_GRADE) {
        return true;
    }
    return false;
}

/**
 * @brief search for course with a given name in the list
 * @param list The list of courses to search
 * @param name The name of the course to find
 * @return 0 if we didnt find the course in the list, ERROR if found.
 *
 */
int search_name(struct list *list, char *name) {
    struct iterator *course = list_begin(list);
    struct course *tmp_course;
    while (course != NULL) {
        tmp_course = (struct course*)list_get(course);
        if (!strcmp(tmp_course->course_name, name)) {
            return ERROR;
        }
        course = list_next(course);
    }
    return WORKS;
}

/* general functions*/
/**
 * @brief Initializes the "grades" data-structure.
 * @returns A pointer to the data-structure, or NULL in case of an error
 */
struct grades *grades_init() {
    struct grades *grades;
    grades = (struct grades*)malloc(sizeof(*grades));
    if (!grades) {
        free(grades);
        return NULL;
    }
    struct list *student;
    student = list_init(student_clone, student_destroy);
    if (!student) {
        list_destroy(student);
        free(grades);
        return NULL;
    }
    grades->students = student;
    return grades;
}

/**
 * @brief Destroys "grades", de-allocate all memory!
 */
void grades_destroy(struct grades *grades) {
    list_destroy(grades->students);
    free(grades);
}

/**
 * @brief Adds a student with "name" and "id" to "grades"
 * @returns 0 on success
 * @note Failes if "grades" is invalid, or a student with
 * the same "id" already exists in "grades"
 */
int grades_add_student(struct grades *grades, const char *name, int id) {
    if (!grades) {
        return ERROR;
    }
    if (search_id(grades->students, id) == ERROR) {
        return ERROR;
    }
    struct student *new_student = student_init();
    new_student->id = id;
    new_student->name = (char *)malloc(sizeof(char)*(strlen(name)+1));
    if (!(new_student->name)) {
        student_destroy(new_student);
        return ERROR;
    }
    strcpy(new_student->name, name);
    list_push_back(grades->students, new_student);
    free(new_student->name);
    free(new_student);
    return 0;
}

/**
 * @brief Adds a course with "name" and "grade" to the student with "id"
 * @return 0 on success
 * @note Failes if "grades" is invalid, if a student with "id" does not exist
 * in "grades", if the student already has a course with "name", or if "grade"
 * is not between 0 to 100.
 */
int grades_add_grade(struct grades *grades,
                     const char *name,
                     int id,
                     int grade) {
    if (!grade_valid(grade) || !grades) {
        return ERROR;
    }
    struct iterator *student = get_student(grades->students, id);
    if (!student) {
        return ERROR;
    }
    struct student *tmp_student = (struct student *)list_get(student);
    char *tmp_name;
    tmp_name = (char*)malloc(sizeof(char)*(strlen(name)+1));
    strcpy(tmp_name, name);
    if (search_name(tmp_student->course, tmp_name) == ERROR) {
        free(tmp_name);
        return ERROR;
    }
    struct course *course = course_init();
    course->course_name = tmp_name;
    course->course_grade = grade;
    /* clone to the end of the list */
    list_push_back(tmp_student->course, course);
    /* delete temp variables */
    free(tmp_name);
    free(course);
    return WORKS;
}

/**
 * @brief Calcs the average of the student with "id" in "grades".
 * @param[out] out This method sets the variable pointed by "out" to the
 * student's name. Needs to allocate memory. The user is responsible for
 * freeing the memory.
 * @returns The average, or -1 on error
 * @note Fails if "grades" is invalid, or if a student with "id" does not exist
 * in "grades".
 * @note If the student has no courses, the average is 0.
 * @note On error, sets "out" to NULL.
 */
float grades_calc_avg(struct grades *grades, int id, char **out) {
    
    if (!grades || (search_id(grades->students, id) != ERROR)) {
        *out = NULL;
        return ERROR;
    }
    struct iterator *tmp_student;
    tmp_student = get_student(grades->students, id);
    if (!tmp_student) {
        *out = NULL;
        return ERROR;
    }
    struct student *student = (struct student *)list_get(tmp_student);
    if (!student) {
        *out = NULL;
        return ERROR;
    }
    *out = (char*)malloc((strlen(student->name)+1)*sizeof(char));
    strcpy(*out, student->name);
    struct iterator *curr = list_begin(student->course);
    if (!curr) {
        return 0; /* no courses */
    }
    struct course *course;
    int totGrades = 0;
    int numOfGrades = 0;
    while (curr != NULL) {
        course = (struct course *)list_get(curr);
        totGrades += course->course_grade;
        numOfGrades++;
        curr = list_next(curr);
    }
    return ((float)totGrades / (float)numOfGrades);
}

/**
 * @brief Prints the courses of the student with "id" in the following format:
 * STUDENT-NAME STUDENT-ID: COURSE-1-NAME COURSE-1-GRADE, [...]
 * @returns 0 on success
 * @note Fails if "grades" is invalid, or if a student with "id" does not exist
 * in "grades".
 * @note The courses should be printed according to the order
 * in which they were inserted into "grades"
 */
int grades_print_student(struct grades *grades, int id) {
    if (!grades) {
        return ERROR;
    }
    struct iterator *tmp_student;
    tmp_student = get_student(grades->students, id);
    if (!tmp_student) {
        return ERROR;
    }
    struct student *student = (struct student *)list_get(tmp_student);
    if (!student) {
        return ERROR;
    }
    struct course *course;
    struct iterator *curr = list_begin(student->course);
    printf("%s %d:", student->name, student->id);
    while (curr != NULL) {
        course = (struct course*)list_get(curr);
        if (list_next(curr) == NULL) {
            /* reached end, no need space */
            printf(" %s %d\n", course->course_name, course->course_grade);
            return WORKS;
        }
        printf(" %s %d,", course->course_name, course->course_grade);
        curr = list_next(curr);
    }
    printf("\n");
    return WORKS;
}

/**
 * @brief Prints all students in "grade", in the following format:
 * STUDENT-1-NAME STUDENT-1-ID: COURSE-1-NAME COURSE-1-GRADE, [...]
 * STUDENT-2-NAME STUDENT-2-ID: COURSE-1-NAME COURSE-1-GRADE, [...]
 * @returns 0 on success
 * @note Fails if "grades" is invalid
 * @note The students should be printed according to the order
 * in which they were inserted into "grades"
 * @note The courses should be printed according to the order
 * in which they were inserted into "grades"
 */
int grades_print_all(struct grades *grades) {
    if (!grades) {
        return ERROR;
    }
    struct iterator *tmp = list_begin(grades->students);
    struct student *student;

    while (tmp != NULL) {
        student = (struct student*)list_get(tmp);
        grades_print_student(grades, student->id);
        tmp = list_next(tmp);
    }
    return WORKS;
}
