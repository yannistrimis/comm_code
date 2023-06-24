#!/bin/bash

masses=("0.0372")

mas_len=${#masses[@]}

#sinks_arr=("PION_5" "PION_05" "RHO_i" "RHO_i0")
sinks_arr=("PION_5")

source1="CORNER"
source2="CORNER"

for sinks in "${sinks_arr[@]}"
do

echo "====${sinks}===="

for i_file in {101..300..1}
do

echo "    ${i_file}"

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do


for (( m2=$m1 ; m2<${mas_len} ; m2++ ));
do


mass1=${masses[$m1]}
mass2=${masses[$m2]}

python aver_one.py <<EOF
${i_file}
${mass1}
${mass2}
${source1}
${source2}
${sinks}
specnd
EOF


done # m2

done # m1

done # i_file

done # sinks
