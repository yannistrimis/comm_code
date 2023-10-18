#!/bin/bash

ens_name="1632b6850x100"
masses=("0.0788")
mas_len=${#masses[@]}

xq_arr=("100")
sinks_arr=("PION_5")

mom_arr=("p100")

for mom in ${mom_arr[@]}
do

source1="point"
source2="point"

sinkop1="identity"
sinkop2="identity"

for sinks in "${sinks_arr[@]}"
do

echo "====${sinks}===="

for i_file in {101..500..1}
do

echo "    ${i_file}"

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

mass1=${masses[$m1]}
mass2=${mass1}

for xq in "${xq_arr[@]}"
do

python clean_one.py <<EOF
${ens_name}a
specmompt${ens_name}xq${xq}a
${i_file}
${mom}
${mass1}
${mass2}
${source1}
${source2}
${sinkop1}
${sinkop2}
${sinks}
cleanspecp100pt${ens_name}xq${xq}a_m${mass1}m${mass2}${sinks}
EOF

done #xq

done #m1

done #i_file

done #sinks

done #mom
