#!/bin/bash

ens_name="1664b70805x18876"
masses=("0.1" "0.12")
mas_len=${#masses[@]}

prefix="str"
src_label="cw"

xq_arr=("1950")
sinks_arr=("PION_5")

mom_arr=("p000")

first=101
last=500

for mom in ${mom_arr[@]}
do
echo "${mom}"

for sinks in ${sinks_arr[@]}
do

echo "${sinks}"

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

mass1=${masses[$m1]}
mass2=${mass1}

for xq in "${xq_arr[@]}"
do

python format_corrfitter_one.py <<EOF
${ens_name}a
${prefix}${mom}${src_label}${ens_name}xq${xq}_m${mass1}m${mass2}${sinks}
${first}
${last}
EOF

done #xq

done # m1

done # sinks

done # momenta

