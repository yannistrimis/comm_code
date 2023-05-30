#!/bin/bash
source fitter_params.sh

if [ $1 = "scan" ]
then

bash call_my_fitter.sh ${mass1} ${mass2} > /mnt/home/trimisio/plot_data/spec_data/${ens_name}/${spec_type}_m1_${mass1}_m2_${mass2}_${sinks}.${my_fitter_suffix}.scanfit 

elif [ $1 = "one" ]
then

bash one_call_my_fitter.sh ${mass1} ${mass2} ${one_tmin} ${one_tmax} "yes" > /mnt/home/trimisio/plot_data/spec_data/${ens_name}/${spec_type}_m1_${mass1}_m2_${mass2}_${sinks}.${my_fitter_suffix}.onefit

fi
