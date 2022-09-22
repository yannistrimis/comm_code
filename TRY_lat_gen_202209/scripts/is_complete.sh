#!/bin/bash

times_found=$(cat $1 | grep -c "$2")

if [ ! ${times_found} -eq 0 ]
then
echo "1"
else
echo "0"
fi
