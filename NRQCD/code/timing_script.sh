#!/bin/bash
start_time=$(date +%s.%N)

for i in {1..10..1}
do

/mnt/home/trimisio/comm_code/NRQCD/build/mainprogram

done

end_time=$(date +%s.%N)
elapsed_time=$(python3 -c "res=${end_time}-${start_time};print(res)")
echo "elapsed time = ${elapsed_time} sec"

