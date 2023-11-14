#!/bin/bash

ens_name="1664b70805x18876"
masses=("0.06")
mas_len=${#masses[@]}

xq_arr=("1880" "1940" "2000" "2060")
sinks_arr=("PION_5")

mom_arr=("p100" "p110")

for mom in ${mom_arr[@]}
do
echo "${mom}"

source1="random_color_wall/momentum"
source2="random_color_wall"

src_label="rcw"

sinkop1="identity"
sinkop2="identity"

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
spectun${ens_name}xq${xq}
${i_file}
${mom}
${mass1}
${mass2}
${source1}
${source2}
${sinkop1}
${sinkop2}
${sinks}
cleanspec${mom}${src_label}${ens_name}xq${xq}_m${mass1}m${mass2}${sinks}
EOF

done #xq

done #m1

done #i_file

done #sinks

done #mom
