#include "field.h"
#include "ip.h"
#include "port.h"
#include "string.h"
#include "input.h"
#include <iostream>

const char *DST_PORT = "dst-port";
const char *SRC_PORT = "src-port";
const char *DST_IP = "dst-ip";
const char *SRC_IP = "src-ip";
const char *DELIMITERS = "=";
const char UNWANTED_CHAR = ',';
const int IP = 1;
const int PORT = 2;
const int ERROR = 1;
const int RULE_SIZE = 2;

int main(int argc, char **argv) {
    /* check if the arguments are legal */
    if(check_args(argc,argv) != 0) {
        return ERROR;
    }
    /* delete unwanted chars */
    char *curr = argv[1];
    while (*curr) {
        if(*curr == UNWANTED_CHAR) {
            *curr = ' ';
        }
        curr++;
    }
    String *rule_check;
    size_t rule_size;
    String rule = String(argv[1]);
    Field *pattern;
    rule.split(DELIMITERS,&rule_check,&rule_size);
    /* check if the rule was split properly and trim it */
    if((int)rule_size != RULE_SIZE) {
        if(rule_check != NULL) {
            delete[] rule_check;
        }
        return ERROR;
    }
    rule_check[1] = rule_check[1].trim();
    rule_check[0] = rule_check[0].trim();
    /* check what kind of rule was inputed and create an object accordingly */
    if(rule_check[0].equals(DST_IP) || rule_check[0].equals(SRC_IP)) {
        pattern = new Ip(rule_check[0]);
    }
    if(rule_check[0].equals(DST_PORT) || rule_check[0].equals(SRC_PORT)) {
        pattern = new Port(rule_check[0]);
    }
    if(!(pattern->set_value(rule_check[1]))) {
        delete[] rule_check;
        delete pattern;
        return ERROR;
    }
    if(pattern != NULL) {
        parse_input(*pattern);
    }
    delete pattern;
    delete[] rule_check;
    return 0;
}