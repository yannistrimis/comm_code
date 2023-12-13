#!/bin/bash

ens_name="16128b7225x36836"
masses=("0.01448")
mas_len=${#masses[@]}

prefix="nlpi"

xq_arr=("3750")
#sinks_arr=("PION_5" "PION_i5" "PION_i" "PION_s")
sinks_arr=("PION_05" "PION_ij" "PION_i0" "PION_0")
mom_arr=("p000")

source1="even_and_odd_wall"
#source2="even_and_odd_wall/FUNNYWALL1"
source2="even_and_odd_wall/FUNNYWALL2"

src_label="eowfw"

sinkop1="identity"
sinkop2="identity"

for mom in ${mom_arr[@]}
do
echo "${mom}"

for sinks in "${sinks_arr[@]}"
do
echo "${sinks}"

for i_file in {101..500..1}
do

echo "    ${i_file}"

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

mass1=${masses[$m1]}
mass2=${mass1}

for xq in "${xq_arr[@]}"
do

python3 clean_one.py <<EOF
${ens_name}a
spec${prefix}${ens_name}xq${xq}
${i_file}
${mom}
${mass1}
${mass2}
${source1}
${source2}
${sinkop1}
${sinkop2}
${sinks}
cleanspec${prefix}${mom}${src_label}${ens_name}xq${xq}_m${mass1}m${mass2}${sinks}
EOF

done #xq

done #m1

done #i_file

done #sinks

done #mom
