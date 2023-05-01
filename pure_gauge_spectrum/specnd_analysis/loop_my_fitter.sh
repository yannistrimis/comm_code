#!/bin/bash

ens_name="l1632b6850x100a"
masses=("0.01576" "0.0788")
mas_len=${#masses[@]}

sinks_arr=("PION_5")

source1="CORNER"
source2="CORNER"

for sinks in "${sinks_arr[@]}"
do

echo ${sinks}

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

for (( m2=$m1 ; m2<${mas_len} ; m2++ ));
do

mass1=${masses[$m1]}
mass2=${masses[$m2]}

bash call_my_fitter.sh ${mass1} ${mass2} ${source1} ${source2} ${sinks} > /mnt/home/trimisio/plot_data/spec_data/${ens_name}/specnd_m1_${mass1}_m2_${mass2}_${sinks}.fit 

done # m2
done # m1
done # sinks
