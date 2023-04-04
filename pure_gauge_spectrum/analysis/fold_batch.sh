#!/bin/bash

#masses=("0.02" "0.04" "0.06" "0.08" "0.1")
masses=("0.08128")
mas_len=${#masses[@]}
sinks="PION_5"
source1="random_color_wall"
source2="random_color_wall"

momenta=("px0py0pz0" "px1py0pz0" "px1py1pz1" "px2py0pz0" "px2py1pz0")
momenta_len=${#momenta[@]}

for (( i_mom=0 ; i_mom<${momenta_len} ; i_mom++ ));
do


for i_file in {101..200..1}
do


echo ${i_file}


for (( m1=0 ; m1<${mas_len} ; m1++ ));
do


# for (( m2=$m1 ; m2<${mas_len} ; m2++ ));
# do

m2=$m1

mass1=${masses[$m1]}
mass2=${masses[$m2]}

python fold_one.py <<EOF
${i_file}
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

done
