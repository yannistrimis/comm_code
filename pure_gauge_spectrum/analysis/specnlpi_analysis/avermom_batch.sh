#!/bin/bash

masses=("0.0788")
mas_len=${#masses[@]}

xq_arr=("100" "102")
sinks_arr=("PION_5")

for sinks in ${sinks_arr[@]}
do

echo "====${sinks}===="

for i_file in {101..101..1}
do

echo "    ${i_file}"

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

mass1=${masses[$m1]}
mass2=${mass1}

for xq in "${xq_arr[@]}"
do

python avermom_one.py <<EOF
${i_file}
${mass1}
${mass2}
3
p100
p010
p001
avp100
${sinks}
$xq
specmomeow
EOF

done # xq

done # m1

done # i_file

done # sinks

