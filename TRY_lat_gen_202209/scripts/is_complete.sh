#!/bin/bash

read_text=$(head -n $2 $1 | tail -n 1)

if [ "${read_text}" = "$3" ]
then
echo "1"
else
echo "0"
fi