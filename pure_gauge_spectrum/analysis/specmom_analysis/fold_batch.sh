#!/bin/bash
nt=64
ens_name="1664b70805x18876"
masses=("0.02" "0.06")
mas_len=${#masses[@]}

xq_arr=("1880" "1940" "2000" "2060")
sinks_arr=("PION_5")

mom_arr=("p000" "p100" "p110")
src_label="pt"

for mom in ${mom_arr[@]}
do
echo "${mom}"

for sinks in ${sinks_arr[@]}
do
echo "${sinks}"

for i_file in {101..200..1}
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
averspec${mom}${src_label}${ens_name}xq${xq}_m${mass1}m${mass2}${sinks}
${i_file}
foldspec${mom}${src_label}${ens_name}xq${xq}_m${mass1}m${mass2}${sinks}
EOF

done #xq

done # m1

done # i_file

done # sinks

done # momenta

