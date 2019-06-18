#!/bin/bash
#
# add your solution after each of the 10 comments below
#

# count the number of unique stations
cat 201402-citibike-tripdata.csv | cut -d, -f4,8 | tr , '\n' | sort | uniq | wc -l  
# count the number of unique bikes
cat 201402-citibike-tripdata.csv | cut -d, -f12 | tr , '\n' | sort | uniq | wc -l
# count the number of trips per day
cat 201402-citibike-tripdata.csv | cut -d, -f2  |cut -d" " -f1| sort | uniq -c
# find the day with the most rides
cat 201402-citibike-tripdata.csv | cut -d, -f2 |cut -d" " -f1| sort | uniq -c| sort -nr| head -n1
# find the day with the fewest rides
cat 201402-citibike-tripdata.csv | cut -d, -f2| cut -d" " -f1|sort| uniq -c| sort| head -n1
# find the id of the bike with the most ridescat
cat 201402-citibike-tripdata.csv |cut -d, -f12|sort| uniq -c| sort -n| tail 
# count the number of rides by gender and birth year
cat 201402-citibike-tripdata.csv |cut -d, -f14,15| sort|uniq -c
# count the number of trips that start on cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)
cat 201402-citibike-tripdata.csv |cut -d, -f5| grep ':[0-9].*&.*[0-9]'|sort| wc -l
# compute the average trip duration
cut -d, -f1| tr'"' ' '| awk -F, '{total+=$1/60} END {print total/NR}'

