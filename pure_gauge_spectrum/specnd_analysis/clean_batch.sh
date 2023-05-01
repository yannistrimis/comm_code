#!/bin/bash

masses=("0.01576" "0.0788")
mas_len=${#masses[@]}

sinks_arr=("PION_5" "PION_05" "RHO_i" "RHO_i0")

source1="CORNER"
source2="CORNER"

for sinks in "${sinks_arr[@]}"
do

echo "====${sinks}===="

for i_file in {101..500..1}
do

echo "    ${i_file}"

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

for (( m2=$m1 ; m2<${mas_len} ; m2++ ));
do


mass1=${masses[$m1]}
mass2=${masses[$m2]}

python clean_one.py <<EOF
${i_file}
0.01576
0.0788
${mass1}
${mass2}
${source1}
${source2}
${sinks}
specnd
EOF


done #m2

done #m1

done #i_file

done #sinks
