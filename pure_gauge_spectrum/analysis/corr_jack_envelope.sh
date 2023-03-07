#!/bin/bash

masses=("0.02" "0.04" "0.06" "0.08")
mas_len=${#masses[@]}
sinks="PION_5"
source1="CORNER"
source2="CORNER"


for (( m1=0 ; m1<${mas_len} ; m1++ ));
do


# for (( m2=$m1 ; m2<${mas_len} ; m2++ ));
# do

m2=$m1

mass1=${masses[$m1]}
mass2=${masses[$m2]}

echo $mass1 $mass2

python corr_jack.py <<EOF
${mass1}
${mass2}
${source1}
${source2}
${sinks}
EOF


# done
done
