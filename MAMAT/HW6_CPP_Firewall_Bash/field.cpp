#include "field.h"

const char *FIELD_DELIMITERS = "=,";

Field::Field(String pattern) {
    this->pattern = String(pattern);
}
Field::~Field() {
}

bool Field::match(String packet) {
    String *packet_data;
    size_t data_size;
    packet.split(FIELD_DELIMITERS, &packet_data, &data_size);
    int i = 0;
    if((int)data_size == 0) {
        return false;
    }
    packet_data[0] = packet_data[0].trim();
    /* search for the part of the packet we need to check*/
    while (!(pattern.equals(packet_data[i].trim())) && i < ((int)data_size)) {
        i++;
        packet_data[i] = packet_data[i].trim();
    }
    /* if we didnt find the right part of the packet */
    if (i >= ((int)data_size)) {
        delete[] packet_data;
        return false;
    }
    /* check if the packet fits the laws */
    String to_check = packet_data[i+1];
    to_check = packet_data[i+1];
    delete[] packet_data;
    return match_value(to_check);
}
