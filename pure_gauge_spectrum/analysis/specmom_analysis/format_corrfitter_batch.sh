#!/bin/bash

masses=("0.0788")
mas_len=${#masses[@]}

sinks_arr=("PION_5")

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
${sinks}
specmomeow_xq100avp110
EOF

done # m1

done # sinks

