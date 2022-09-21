#!/bin/bash

isInFile=$(cat $1 | grep -c "$2")

if [ ! ${isInFile} -eq 0 ]
then
echo "1"
else
echo "0"
fi
