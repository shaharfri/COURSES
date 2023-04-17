//
//  linked-list.c
//  
//
//  Created by Liad Mordhy on 01/05/2022.
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include "grades.h"
#include "linked-list.h"

#define MAX_GRADE 100
#define ERROR 1
#define FAIL -1
#define SUCCESS 0

struct grades{
    struct list *students_list;
};

struct student{
    char *name;
    int id;
    struct list *student_courses;
};

struct course{
    char *course_name;
    int grade;
};

/* My user functions*/
int student_clone(void *element, void **output);
void student_destroy(void *element);
int course_clone(void *element, void **output);
void course_destroy(void *element);

/* Private functions for this module */
static struct iterator* list_find_id(struct list *students_list, const int id);
static struct iterator* list_find_course(struct list *student_courses,
                                         const char *name);

/* User function, clones “element” to “*output”. Returns 0 on success.
 * Note: "output" is a pointer to void*. Meaning, your function should
 * allocate memory on the heap and set "*output" to point on that memory.
 * This methodology (of returning values via pointers) is very common in C.
 * An example of C method that returns a value via pointer:
 * void foo(int *out) {
 *   *out = 1;
 * }
 *typedef int(*element_clone_t)(void *element, void **output);
 */

/* course clone and destroy */
int student_clone(void *element, void **output){
    struct student *student_data = (struct student*)element;
    struct student *new_student;
    new_student = (struct student*)malloc(sizeof(struct student));
    if(new_student == NULL){
        free(new_student);
        return ERROR;
    }
    new_student->id = student_data->id;
    new_student->name = malloc(sizeof(char)*(strlen(student_data->name)+1));
    if(new_student->name == NULL){
        free(new_student->name);
        return ERROR;
    }
    strcpy(new_student->name, student_data->name);
    new_student->student_courses = list_init(course_clone, course_destroy);
    *output = (void*)new_student;
    return 0;
}


void student_destroy(void *element){
    struct student *rm_student = (struct student*)element;
    list_destroy(rm_student->student_courses);
    free(rm_student->name);
    free(rm_student);
}


int course_clone(void *element, void **output){
    struct course *course_data = (struct course*)element;
    struct course *new_course = (struct course*)malloc(sizeof(struct course));
    if(new_course == NULL){
        free(new_course);
        return ERROR;
    }
    int len_name = strlen(course_data->course_name) + 1;
    new_course->course_name = malloc(sizeof(char)*len_name);
    if(new_course->course_name == NULL){
        free(new_course->course_name);
        return ERROR;
    }
    strcpy(new_course->course_name,course_data->course_name);
    new_course->grade = course_data->grade;
    *output = (void*)new_course;
    return 0;
}


void course_destroy(void *element){
    struct course *rm_course = (struct course*)element;
    free(rm_course->course_name);
    free(rm_course);
}


/* functions of grades */
struct grades* grades_init(void){
    struct grades *grades;
    grades = (struct grades*)malloc(sizeof(*grades));
    if(!grades){
        return NULL;
    }
    grades->students_list = list_init(student_clone,student_destroy);
    return grades;
    
}

void grades_destroy(struct grades *grades){
    if(grades == NULL){
        return;
    }
    list_destroy(grades->students_list);
    free(grades);
    return;
}

int grades_add_student(struct grades *grades, const char *name, int id){
    /*check if the student already exists*/
    if(grades == NULL){
        return ERROR;
    }
    if(list_find_id(grades->students_list, id)!=NULL){
        return ERROR;
    }
    struct student *new_student;
    new_student = (struct student*)malloc(sizeof(*new_student));
    if(new_student == NULL){
        free(new_student);
        return ERROR;
    }
    new_student->id = id;
    new_student->name = malloc(sizeof(char)*(strlen(name)+1));
    if(new_student->name == NULL){
        free(new_student->name);
        free(new_student);
        return ERROR;
    }
    strcpy(new_student->name,name);
    new_student->student_courses = list_init(course_clone, course_destroy);
    if(new_student->student_courses == NULL){
        free(new_student->name);
        free(new_student);
        return ERROR;
    }
    if(list_push_back(grades->students_list,new_student)!=SUCCESS){
        student_destroy(new_student);
        return ERROR;
    }
    student_destroy(new_student);
    return SUCCESS;
}

int grades_add_grade(struct grades *grades,
                     const char *name,
                     int id,
                     int grade){
    if(grades == NULL || grade < 0 || grade > MAX_GRADE){
        return ERROR;
    }
    struct iterator *current_student = list_find_id(grades->students_list, id);
    if(current_student ==  NULL){
        return ERROR;
    }
    struct student *student_data;
    student_data = (struct student*)list_get(current_student);
    if(list_find_course(student_data->student_courses, name) != NULL){
        return ERROR;
    }
    struct course *new_course;
    new_course = (struct course*)malloc(sizeof(struct course));
    if(new_course == NULL){
        free(new_course);
        return ERROR;
    }
    new_course->course_name = malloc(sizeof(char)*(strlen(name)+1));
    if(new_course->course_name == NULL){
        free(new_course->course_name);
        free(new_course);
        return ERROR;
    }
    strcpy(new_course->course_name, name);
    new_course->grade = grade;

    if(list_push_back(student_data->student_courses, new_course) != SUCCESS){
        course_destroy(new_course);
        return ERROR;
    }
    course_destroy(new_course);
    return 0;
}

float grades_calc_avg(struct grades *grades, int id, char **out){
    if(grades == NULL){
        return ERROR;
    }
    struct iterator *current_student = list_find_id(grades->students_list, id);
    if(current_student ==  NULL){
        *out = NULL;
        return FAIL;
    }
    struct student *student_data;
    student_data = (struct student*)list_get(current_student);
    
    char *student_name = malloc(sizeof(char)*(strlen(student_data->name)+1));
    if(student_name == NULL){
        free(student_name);
        *out = NULL;
        return FAIL;
    }
    
    strcpy(student_name, student_data->name);
    *out = student_name;
    struct iterator *course_data = list_begin(student_data->student_courses);
    size_t list_len = list_size(student_data->student_courses);
    float avg = 0.0;
    if(course_data == NULL){
        return avg;
    }
    for(size_t i = 0; i < list_len; i++){
        struct course *current_course = (struct course*)list_get(course_data);
        avg += current_course->grade;
        course_data = list_next(course_data);
    }
    avg = avg/list_len;
    return avg;
}
   

int grades_print_student(struct grades *grades, int id){
    struct iterator *current_student = list_find_id(grades->students_list,id);
    if (current_student==NULL||grades==NULL)
        return ERROR;
    struct student *student_data = (struct student*)list_get(current_student);
    printf("%s %d:",student_data->name,student_data->id);
    if (student_data->student_courses==NULL){
        printf("\n");
        return 0;
    }
    struct iterator *course_data = list_begin(student_data->student_courses);
    size_t list_len = list_size(student_data->student_courses);
    for (size_t i = 0; i < list_len; i++)
    {
        struct course *current_course = (struct course*)list_get(course_data);
        printf(" %s %d,",current_course->course_name,current_course->grade);
        course_data= list_next(course_data);
    }
    printf("\n");
    return 0;
    }

int grades_print_all(struct grades *grades){
    struct iterator *current_student = list_begin(grades->students_list);
    if(grades == NULL){
        return ERROR;
    }
    size_t list_len = list_size(grades->students_list);
    for (size_t i = 0; i < list_len; i++)
    {
        struct student *student_data = (struct student*)list_get(current_student);
        grades_print_student(grades,student_data->id);
        current_student = list_next(current_student);
    }
    return SUCCESS;
}

    
/* Added functions */

static struct iterator *list_find_id(struct list *students_list, const int id){
    struct iterator *current_student = list_begin(students_list);
    size_t list_len = list_size(students_list);
    for(size_t i=0; i<list_len;i++){
        struct student *student_data;
        student_data = (struct student*)list_get(current_student);
        if(student_data->id==id){
            return current_student;
        }
        current_student = list_next(current_student);
    }
    return NULL;
}


static struct iterator *list_find_course(struct list *student_courses,
                                         const char *name){
    struct iterator *current_course = list_begin(student_courses);
    size_t list_len = list_size(student_courses);
    for(size_t i=0; i<list_len;i++){
        struct course *course_data;
        course_data = (struct course*)list_get(current_course);
        if(strcmp(course_data->course_name, name) == SUCCESS){
            return current_course;
        }
        current_course = list_next(current_course);
    }
    return NULL;
}
