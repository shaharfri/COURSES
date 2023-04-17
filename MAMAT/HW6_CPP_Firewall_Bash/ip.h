#ifndef IP_H
#define IP_H

#include "field.h"

class Ip : public Field {
private:
    int legal_mask;
    unsigned int bits;
    unsigned int mask;

public:
    /**
     * @brief Construct a new Ip object
     * @param pattern string we expect to be before the value to check
     */
    Ip(String pattern);

    /**
     * @brief Destroy the Ip object
     */
    ~Ip();

    /**
     * @brief sets the legal values for each bit in the ip adress
     * @param val The rules for legal values.
     * @return true if the values were set succsessfully, false otherwise
     */
    bool set_value(String val);

    /**
     * @brief check if an ip adress fits the legal requirments
     * @param packet The ip adress to check
     * @return true if the adress is legal, false otherwise
     */
    bool match_value(String packet) const;
};


#endif