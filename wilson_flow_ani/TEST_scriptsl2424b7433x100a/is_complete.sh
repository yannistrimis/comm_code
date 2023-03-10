#!/bin/bash

times_found=$(cat $1 | grep -c "$2") # $1 is the file and $2 is the text

if [ "${times_found}" = "1" ]
then
echo "1"
else
echo "0"
fi
