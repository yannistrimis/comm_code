#!/bin/bash

rr_arr=("1" "2" "3" "4" "5" "6")

for rr in ${rr_arr[@]}
do

python3 statpot_analysis.py <<EOF >> TEST_vr.data
$rr
EOF

done
