#!/bin/bash

masses=("0.02" "0.04" "0.06" "0.08" "0.1")
mas_len=${#masses[@]}
sinks="PION_5"
source1="random_color_wall"
source2="random_color_wall"

momenta=("px0py0pz0" "px1py0pz0" "px1py1pz1" "px2py0pz0" "px2py1pz0")
momenta_len=${#momenta[@]}


for (( i_mom=0 ; i_mom<${momenta_len} ; i_mom++ ));
do


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
nd_strange_${momenta[$i_mom]}_rcw
EOF


# done

done

done
