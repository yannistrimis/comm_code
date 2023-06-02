#!/bin/bash

masses=("0.01576")
mas_len=${#masses[@]}

sinks_arr=("PION_5")

mom_arr=("p100" "p010" "p001")

for mom in ${mom_arr[@]}
do

echo "    ${mom}"

for sinks in ${sinks_arr[@]}
do

echo "====${sinks}===="

for i_file in {102..200..1}
do

echo "    ${i_file}"

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

mass1=${masses[$m1]}
mass2=${mass1}

python aver_one.py <<EOF
${i_file}
${mass1}
${mass2}
${sinks}
specmomeow${mom}
EOF


done # m1

done # i_file

done # sinks

done # momenta
