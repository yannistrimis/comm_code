#!/bin/bash

nt=64 # DON'T FORGET TO CHANGE !!!

ens_name="1664b70805x18876"
masses=("0.1" "0.12")
mas_len=${#masses[@]}

prefix="str"
src_label="cw"

xq_arr=("1950")
sinks_arr=("PION_5")

mom_arr=("p000")


for mom in ${mom_arr[@]}
do
echo "${mom}"

for sinks in ${sinks_arr[@]}
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

python fold_one.py <<EOF
${nt}
${ens_name}a
averspec${prefix}${mom}${src_label}${ens_name}xq${xq}_m${mass1}m${mass2}${sinks}
${i_file}
foldspec${prefix}${mom}${src_label}${ens_name}xq${xq}_m${mass1}m${mass2}${sinks}
EOF

done #xq

done # m1

done # i_file

done # sinks

done # momenta

