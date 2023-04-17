#ifndef PORT_H
#define PORT_H

#include "field.h"

class Port : public Field {
private:
    int min_port;
    int max_port;

public:
    /**
     * @brief Construct a new Port object
     * @param pattern string we expect to be before the value to check
     */
    Port(String pattern);
    /**
     * @brief Destroy the Port object
     */
    ~Port();
    /**
     * @brief sets the legal range for ports
     * @param val The rules for legal ports
     * @return True if the rules were set succsessfully, false otherwise
     */
    bool set_value(String val);
    /**
     * @brief check if a port is in the legal range
     * @param packet The port to check
     * @return True if the port fits the legal requirments, false otherwise
     */
    bool match_value(String packet) const;
};


#endif