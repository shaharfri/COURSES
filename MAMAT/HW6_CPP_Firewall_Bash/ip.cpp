#include "ip.h"

const int NO_BITS = 0;
const int BITS_IN_BYTE = 8;
const int MIN_VAL = 0;
const int MAX_VAL = 255;
const int NO_MASK = 4;
const int MASK = 5;
const int NUM_OF_BITS = 32;
const char *IP_DELIMETERS = "./";



/**
 * @brief Construct a new Ip object
 * @param pattern string we expect to be before the value to check
 */
Ip::Ip(String pattern):Field(pattern) {
    legal_mask = 0;
    bits = 0;
    mask = 0;
}

/**
 * @brief Destroy the Ip object
 */
Ip::~Ip() {
}

/**
 * @brief get the power of a number
 * @param num The base number
 * @param power The power of the number we want to get
 * @return number in the power of power
 */
int pow(int num, int power) {
    int result = 1;
    for(int i; i <= power; i++) {
        result = result * num;
    }
    return result;
}
/**
 * @brief turn an ip adress into binary
 * @param rule The ip adress
 * @param bits The binary number
 * @return true if we turned the ip adress into binary, false if failed
 */
bool to_binary(String *rule, unsigned int *bits) {
    int tmp_integer;
    for (int i = 0; i < NO_MASK; i++) {
        tmp_integer = rule[i].to_integer();
        if (tmp_integer > MAX_VAL || tmp_integer < MIN_VAL) {
            return false;
        }
        *bits = (*bits << BITS_IN_BYTE) | tmp_integer;
    }
    return true;
}
/**
 * @brief sets the legal values for each bit in the ip adress
 * @param val The rules for legal values.
 * @return true if the values were set succsessfully, false otherwise
 */
bool Ip::set_value(String val) {
    String *rule;
    size_t rule_size;
    val.split(IP_DELIMETERS, &rule, &rule_size);
    if (rule_size < NO_MASK || rule_size > MASK) {
        delete[] rule;
        return false;
    }
    /* turn the ip adress of rule into binary */
    if (!(to_binary(rule, &bits))) {
        delete[] rule;
        return false;
    }
    /* get the legal size of the mask */
    if (rule_size == MASK) {
        legal_mask = rule[MASK - 1].to_integer();
    }
    if (legal_mask < NO_BITS || legal_mask > NUM_OF_BITS) {
        delete[] rule;
        return false;
    }
    /* turn the mask into binary */
    for(int i = 0; i < legal_mask; i++) {
        mask = (mask+1) << 1;
    }
    if(legal_mask != 0) {
        mask = (mask+1) << (NUM_OF_BITS - legal_mask);
    }
    delete[] rule;
    return true;
}
/**
 * @brief check if an ip adress fits the legal requirments
 * @param packet The ip adress to check
 * @return true if the adress is legal, false otherwise
 */
bool Ip::match_value(String packet) const {
    String *adress;
    size_t adress_size;
    unsigned int packet_bits = 0;
    packet.split(IP_DELIMETERS, &adress, &adress_size);
    if ((int)adress_size != NO_MASK) {
        if(adress != NULL) {
            delete[] adress;
        }
        return false;
    }
    /* get the value of the ip in binary */
    if (!(to_binary(adress, &packet_bits))) {
        delete[] adress;
        return false;
    }
    /* get only the needed bits to compare */
    packet_bits = packet_bits & mask;
    unsigned int tmp_bits = bits & mask;
    if(packet_bits == tmp_bits) {
        delete[] adress;
        return true;
    }
    delete[] adress;
    return false;
}
