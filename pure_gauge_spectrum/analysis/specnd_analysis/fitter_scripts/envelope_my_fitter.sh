#!/bin/bash
source fitter_params.sh

if [ $1 = "scan" ]
then

for (( m1=0 ; m1<${mas_len} ; m1++ ));
do

mass1=${masses[$m1]}
mass2=${mass1}

bash call_my_fitter.sh ${mass1} ${mass2} > /mnt/home/trimisio/plot_data/spec_data/${ens_name}/specnd_m1_${mass1}_m2_${mass2}_${sinks}.${my_fitter_suffix}.scanfit 

done # m1

elif [ $1 = "one" ]
then

bash one_call_my_fitter.sh ${one_mass1} ${one_mass2} ${one_tmin} ${one_tmax} "yes" > /mnt/home/trimisio/plot_data/spec_data/${ens_name}/specnd_m1_${one_mass1}_m2_${one_mass2}_${sinks}.${my_fitter_suffix}.onefit

fi
