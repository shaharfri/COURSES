#!/bin/bash

#Check that the length of course number entered is legal
len=$(echo "$1" | grep '[0,9]' | wc -c)
if [ "$#" -ne 1 ]; then 
    echo "Wrong number of arguments" 1>&2 
    exit
fi
#last spot in string array is end char
if [ $len != 7 ]; then 
    echo "Wrong number of arguments" 1>&2 
    exit
fi
#check that the course has a txt file
ls ./*.txt > exist.txt
if ! grep -Fxq "./$1.txt"  < exist.txt; then
    echo "Course not found" 1>&2 
    rm exist.txt
    exit
fi
rm exist.txt
#create a new folder, delete if exists.
[[ -d "$1"_stat ]] && rm -r "$1"_stat
mkdir -p "$1"_stat
#create a grades.txt file containing all grades and compile+run c program on it
awk '{print $2}' $1.txt | sed '1d' > "$1"_stat/grades.txt
./prog.exe "$1"_stat/course_statistics.txt "$1"_stat/grades.txt
cat "$1"_stat/course_statistics.txt #print result file to terminal