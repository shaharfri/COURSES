#include "port.h"

const char *PORT_DELIMITERS = "-";
const int RULE_SIZE = 2;
const int LOWER_LOCATION = 0;
const int UPPER_LOCATION = 1;
const int MAX_PORT = 65535;
const int MIN_PORT = 0;

Port::Port(String pattern) : Field(pattern) {
    min_port = MIN_PORT;
    max_port = MAX_PORT;
}
Port::~Port() {
}

bool Port::set_value(String val) {
    String *tmp_port;
    size_t port_size;
    val.split(PORT_DELIMITERS, &tmp_port, &port_size);
    /* check if the rule is written in a legal format */
    if ((int)port_size != RULE_SIZE) {
        return false;
    }
    min_port = tmp_port[LOWER_LOCATION].to_integer();
    max_port = tmp_port[UPPER_LOCATION].to_integer();
    /* check if the rule is in the legal range */
    if (min_port > max_port || min_port < MIN_PORT || max_port > MAX_PORT) {
        return false;
    }
    return true;
}

bool Port::match_value(String packet) const {
    int curr_port = packet.to_integer();
    if(curr_port < min_port || curr_port > max_port) {
        return false;
    }
    return true;
}