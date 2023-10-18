#!/bin/bash

ens_name="1632b6850x100"
masses=("0.0788")
mas_len=${#masses[@]}

xq_arr=("100")
sinks_arr=("PION_5")

mom_arr=("p100")

for mom in ${mom_arr[@]}
do

echo "    ${mom}"

for sinks in ${sinks_arr[@]}
do

echo "====${sinks}===="

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

mass1=${masses[$m1]}
mass2=${mass1}

for xq in "${xq_arr[@]}"
do

python format_corrfitter_one.py <<EOF
${ens_name}a
${mom}pt${ens_name}xq${xq}a_m${mass1}m${mass2}${sinks}
101
500
EOF

done #xq

done # m1

done # sinks

done # momenta

