#!/bin/bash

times_found=$(cat $1 | grep -c "$2") # $1 is the file and $2 is the text

if [ "${times_found}" = "2" ] # ONE FOR EACH SOURCE
then
echo "1"
else
echo "0"
fi
