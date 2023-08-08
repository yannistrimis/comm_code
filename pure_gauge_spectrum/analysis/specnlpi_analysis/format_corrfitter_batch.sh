#!/bin/bash

masses=("0.01576")
mas_len=${#masses[@]}

#sinks_arr=("PION_5" "PION_i5" "PION_i" "PION_s" "PION_05" "PION_ij" "PION_i0" "PION_0")
sinks_arr=("PION_5")

source1="eow"
source2="eow_fw"

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
specnlpi
EOF


done # m1

done # sinks

