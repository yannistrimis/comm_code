#!/bin/bash

read_text=$(head -n $1 "${directory}/guard" | tail -n 1)

if [ ${read_text} = $2 ]
then
echo "1"
else
echo "0"
fi