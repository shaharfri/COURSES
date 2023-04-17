#!/bin/bash

#arrange packets
packet=$(cat)
packet=$(sed -r 's/\s+//g' <<< "$packet")
packet=$(sed -r '/^$/d' <<< "$packet")


rules=$(cat $1)
#delete all comments from rules
rules=$(sed -r 's/#/\n#/g' <<< "$rules")
rules=$(sed -r '/^#/d' <<< "$rules")
# #arrage rules
rules=$(sed -r 's/,/ /g' <<< "$rules")
rules=$(sed -r '/^ /d' <<< "$rules")
rules=$(sed -r '/^$/d' <<< "$rules")

#get only the pkts that fit the rules
result=""
while read -r line;
    do
        tmp_line=$(awk {'print $1'} <<< "$line")
        first_result=$(echo -n "$packet" | ./firewall.exe "$tmp_line")
        tmp_line=$(awk {'print $2'} <<< "$line")
        second_result=$(echo -n "$packet" | ./firewall.exe "$tmp_line")
        tmp_line=$(awk {'print $3'} <<< "$line")
        third_result=$(echo -n "$packet" | ./firewall.exe "$tmp_line")
        tmp_line=$(awk {'print $4'} <<< "$line")
        fourth_result=$(echo -n "$packet" | ./firewall.exe "$tmp_line")
        first_result=$(sort <<< "$first_result")
        second_result=$(sort <<< "$second_result")
        third_result=$(sort <<< "$third_result")
        fourth_result=$(sort <<< "$fourth_result")
        tmp_result=$(comm -12 <(echo "$first_result") <(echo "$second_result"))
        tmp_result=$(sort <<< "$tmp_result")
        tmp_result=$(comm -12 <(echo "$tmp_result") <(echo "$third_result"))
        tmp_result=$(sort <<< "$tmp_result")
        tmp_result=$(comm -12 <(echo "$tmp_result") <(echo "$fourth_result"))
        tmp_result=$(sort <<< "$tmp_result")
        result+="$tmp_result"
        result+="new_line"
    done <<< "$rules"

#sort and delete reapeting pkts
result=$(sed -r 's/new_line/\n/g' <<< "$result")
result=$(sort -n -k6 <<< "$result"| uniq)
result=$(sed -r '/^$/d' <<< "$result")
echo "$result" 
