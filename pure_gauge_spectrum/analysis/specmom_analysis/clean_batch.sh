#!/bin/bash

masses=("0.01576")
mas_len=${#masses[@]}

sinks_arr=("PION_5")

source1="even_and_odd_wall"
source2="even_and_odd_wall/momentum"

for sinks in "${sinks_arr[@]}"
do

echo "====${sinks}===="

for i_file in {101..200..1}
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
3
p100
p010
p001
specmom
EOF


done #m1

done #i_file

done #sinks
