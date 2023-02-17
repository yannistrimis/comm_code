#!/bin/bash

source_list=("a" "b")
masses=("0.02" "0.04" "0.06" "0.08" "1")
sinks="PION_5"
source1="CORNER"
source2="CORNER"


for i_file in {201..300..1}
do

echo ${i_file}


for i_source in ${source_list[@]}
do


for (( m1=0 ; m1<5 ; m1++ ));
do


# for (( m2=$m1 ; m2<5 ; m2++ ));
# do

m2=$m1

mass1=${masses[$m1]}
mass2=${masses[$m2]}

python fold_one.py <<EOF
${i_file}
${i_source}
${mass1}
${mass2}
${source1}
${source2}
${sinks}
EOF


# done

done

done

done
