#!/bin/bash
source fitter_params.sh

if [ ${my_fitter} = "scipy_fitter_n.py"  ]
then
echo "#tmin tmax chi2/dof Q Emean Esdev"
elif [ ${my_fitter} = "scipy_fitter_o.py"  ]
then
echo "#tmin tmax chi2/dof Q EOmean EOsdev"
elif [ ${my_fitter} = "scipy_fitter_no.py"  ]
then
echo "#tmin tmax chi2/dof Q Emean Esdev EOmean EOsdev"
elif [ ${my_fitter} = "scipy_fitter_non.py"  ]
then
echo "#tmin tmax chi2/dof Q Emean Esdev EOmean EOsdev E1mean E1sdev"
elif [ ${my_fitter} = "scipy_fitter_nn.py"  ]
then
echo "#tmin tmax chi2/dof Q Emean Esdev E1mean E1sdev"
fi

for (( tmin=${tmin_min} ; tmin<=${tmin_max} ; tmin++ ))
do
for tmax in ${tmax_arr[@]}
do

bash one_call_my_fitter.sh $1 $2 ${tmin} ${tmax} "no"

done # tmin
done # tmax
