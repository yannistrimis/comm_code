#!/bin/bash

ens_name="1664b70805x18876"
masses=("0.1" "0.12")
mas_len=${#masses[@]}

prefix="str"

xq_arr=("1950")
sinks_arr=("PION_5")

mom_arr=("p000")

for mom in ${mom_arr[@]}
do
echo "${mom}"

source1="CORNER"
source2="CORNER"

src_label="cw"

sinkop1="identity"
sinkop2="identity"

for sinks in "${sinks_arr[@]}"
do
echo "${sinks}"

for i_file in {101..501..1}
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
