#!/bin/bash

ens_name="16128b7225x36836"
masses=("0.0724")
mas_len=${#masses[@]}

prefix="tuncheck"

xq_arr=("3750")
sinks_arr=("PION_5")

mom_arr=("p000" "p100" "p110")
src_label="rcw"

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

