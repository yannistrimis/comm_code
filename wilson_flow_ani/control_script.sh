#!/bin/bash
start_time=$(date +%s.%N)

source params.sh











































end_time=$(date +%s.%N)

elapsed_time=$(python3 -c "res=${end_time}-${start_time};print(res)")
echo "elapsed time = ${elapsed_time} sec"