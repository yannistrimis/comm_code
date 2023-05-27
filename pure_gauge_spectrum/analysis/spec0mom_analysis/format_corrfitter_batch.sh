#!/bin/bash

masses=("0.04" "0.06" "0.08" "0.1" "0.12")
mas_len=${#masses[@]}

sinks_arr=("PION_5")

source1="CORNER"
source2="CORNER"

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
spec0mom
EOF

done # m1

done # sinks

