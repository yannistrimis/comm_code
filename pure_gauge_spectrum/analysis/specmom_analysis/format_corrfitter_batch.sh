#!/bin/bash

masses=("0.01576")
mas_len=${#masses[@]}

sinks_arr=("PION_5")

source1="even_and_odd_wall"
source2="even_and_odd_wall/momentum"

for sinks in "${sinks_arr[@]}"
do

echo "====${sinks}===="

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

mass1=${masses[$m1]}
mass2=${mass1}

python format_corrfitter_one.py <<EOF
${mass1}
${mass2}
${source1}
${source2}
${sinks}
specmom
EOF

done # m1

done # sinks

