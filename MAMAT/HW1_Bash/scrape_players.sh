#!/bin/bash

wget https://www.premierleague.com/players
#get all the player links start at /players
grep -P -io '/players/[0-9]*/[a-z]*-[a-z]*/overview' players > temp_player.txt
grep -P -io '/players/[0-9]*/[a-z]*-[a-z]*-[a-z]*/overview' players >> temp_player.txt
grep -P -io '/players/[0-9]*/[a-z]*/overview' players >> temp_player.txt
totPlayers=$(wc -l < temp_player.txt)
#add the start of url to all players
sed -i -e 's/^/https:\/\/www.premierleague.com\//' temp_player.txt
(( counter=$totPlayers + 1 )) 
while [ $counter -gt 1 ] 
do 
    line=$(sed -n "$counter p" temp_player.txt)
    wget $line
    grep -Eio 'midfielder' overview > tmp.txt
    wordNum=$(wc -l < tmp.txt)
    Midfielder=", Midfielder, "
    if [ $wordNum -gt 0 ] #add only if player is midfielder
    then
        finalLine=$line$Midfielder$wordNum
        echo $finalLine >> player_results.csv
    fi
    rm tmp.txt
    rm overview
    counter=$(( $counter - 1 ))
done
echo Total players $totPlayers | cat - player_results.csv > temp && mv temp player_results.csv
#delete all temp files
rm temp_player.txt
rm players
