#include "string.h"
#include <cstring>

const int LENGTH_FIX = 1;
const int STR_EQUAL = 0;
const int EMPTY_STR = 0;
const char EMPTY = ' ';

/**
 * @brief Initiates an empty string
 */
String::String() {
    length = EMPTY_STR;
    data = new char[length + LENGTH_FIX];
    strcpy(data,"");
}

/**
 * @brief Initiates string from other string
 */
String::String(const String &str) {
    length = str.length;
    data = new char[length + LENGTH_FIX];
    strcpy(data, str.data);
}

/**
 * @brief Initiates a string from char array
 */
String::String(const char *str) {
    length = strlen(str);
    data = new char[length + LENGTH_FIX];
    strcpy(data, str);
}

String::~String() {
    delete[] data;
}

/**
 * @brief Changes this from String
 */
String &String::operator=(const String &rhs) {
    if (this->equals(rhs)) {
        return *this;
    }
    delete[] data;
    length = rhs.length;
    data = new char[length+LENGTH_FIX];
    strcpy(data, rhs.data);
    return *this;
}

/**
 * @brief Changes this from char array
 */
String &String::operator=(const char *str) {
    delete[] data;
    length = strlen(str);
    data = new char[length + LENGTH_FIX];
    strcpy(data, str);
    return *this;
}

/**
 * @brief Returns true iff the contents of this equals to the
 * contents of rhs
 */
bool String::equals(const String &rhs) const {
    if (strcmp(data, rhs.data) == STR_EQUAL) {
        return true;
    }
    return false;
}

/**
 * @brief Returns true iff the contents of this equals to rhs
 */
bool String::equals(const char *rhs) const {
    if (strcmp(data, rhs) == STR_EQUAL) {
        return true;
    }
    return false;
}

/**
 * @brief Splits this to several sub-strings according to delimiters.
 * Allocates memory for output that the user must delete (using delete[]).
 * @note Does not affect this.
 * @note If "output" is set to NULL, do not allocated memory, only
 * compute "size".
 */
void String::split(const char *delimiters,String **output,size_t *size) const {
    if(length == 0) {
        *size = 0;
        return;
    }
    char **token = new char*[length + LENGTH_FIX];
    int counter = 0;
    token[counter] = strtok(data,delimiters);
    while(token[counter] != NULL) {
        if(strcmp(token[counter],"") != 0) {
            counter++;
        }
        token[counter] = strtok(NULL,delimiters);
    }
    *size = counter;
    if(output != NULL && counter != 0) {
        *output = new String[counter];
        for(int i = 0; i < counter; i++) {
            (*output)[i] = token[i];
        }
    }
    delete[] token;
    return;
}

/**
 * @brief Try to convert this to an integer. Returns 0 on error.
 */
int String::to_integer() const {
    if (strlen(data) == EMPTY_STR) {
        return 0;
    }
    return atoi(data);
}

/**
 * @brief Remove any leading or trailing white-spaces.
 * Does not change this.
 */
String String::trim() const {
    int left_counter = 0;
    int right_counter = 0;
    int right_index = length-1;
    while(data[left_counter] == EMPTY) {
        left_counter++;
    }
    while(data[right_index] == EMPTY) {
        right_counter++;
        right_index--;
    }
    int new_len = length-right_counter-left_counter;
    if(new_len <= 0) {
        return String();
    }
    char *tmp_str = new char[new_len+LENGTH_FIX]();
    memcpy(tmp_str,&data[left_counter],new_len);
    String tmp_string = tmp_str;
    delete[] tmp_str;
    return tmp_string;
}