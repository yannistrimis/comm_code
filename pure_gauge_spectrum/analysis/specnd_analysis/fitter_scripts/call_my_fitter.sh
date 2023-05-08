#!/bin/bash
source fitter_params.sh

if [ ${my_fitter} = "scipy_fitter_n.py"  ]
then
echo "#tmin tmax chi2/dof Emean Esdev"
elif [ ${my_fitter} = "scipy_fitter_no.py"  ]
then
echo "#tmin tmax chi2/dof Emean Esdev EOmean EOsdev"
elif [ ${my_fitter} = "scipy_fitter_non.py"  ]
then
echo "#tmin tmax chi2/dof Emean Esdev EOmean EOsdev E1mean E1sdev"

fi

for (( tmin=${tmin_min} ; tmin<=${tmin_max} ; tmin++ ))
do
for tmax in ${tmax_arr[@]}
do

bash one_call_my_fitter.sh $1 $2 ${tmin} ${tmax}

done # tmin
done # tmax
