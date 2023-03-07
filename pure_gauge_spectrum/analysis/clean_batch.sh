#!/bin/bash

masses=("0.02")
mas_len=${#masses[@]}
sinks="PION_5"
source1="CORNER"
source2="CORNER"


for i_file in {101..300..1}
do

echo ${i_file}

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

# for (( m2=$m1 ; m2<${mas_len} ; m2++ ));
# do

m2=$m1

mass1=${masses[$m1]}
mass2=${masses[$m2]}

python ONE_SOURCE_clean_one.py <<EOF
${i_file}
${mass1}
${mass2}
${source1}
${source2}
${sinks}
EOF


# done

done

done
