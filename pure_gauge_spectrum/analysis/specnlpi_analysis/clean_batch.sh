#!/bin/bash

masses=("0.01576")
mas_len=${#masses[@]}

#sinks_arr=("PION_5" "PION_i5" "PION_i" "PION_s")
#sinks_arr=("PION_05" "PION_ij" "PION_i0" "PION_0")

sinks_arr=("PION_5")

source1="even_and_odd_wall"
source2="even_and_odd_wall/FUNNYWALL1"
#source2="even_and_odd_wall/FUNNYWALL2"

for sinks in "${sinks_arr[@]}"
do

echo "====${sinks}===="

for i_file in {101..500..1}
do

echo "    ${i_file}"

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

mass1=${masses[$m1]}
mass2=${mass1}

python clean_one.py <<EOF
${i_file}
01576
${mass1}
${mass2}
${source1}
${source2}
${sinks}
specnlpi
EOF


done #m1

done #i_file

done #sinks
