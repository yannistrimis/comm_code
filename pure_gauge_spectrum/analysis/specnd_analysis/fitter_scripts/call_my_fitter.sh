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

<<<<<<< HEAD
fi

for (( tmin=${tmin_min} ; tmin<=${tmin_max} ; tmin++ ))
=======
for (( tmin=0 ; tmin<=${tmin_max} ; tmin++ ))
>>>>>>> a322b94853357662e48a0d647535d63fac6d2dfb
do
for tmax in ${tmax_arr[@]}
do

<<<<<<< HEAD
bash one_call_my_fitter.sh $1 $2 ${tmin} ${tmax}
=======
cat <<EOF > fitter_input.dat
non
${nt}
${ens_name}
$1
$1
${source1}
${source2}
${sinks}
specnd
${one_tmin}
${one_tmax}
${an}
${En}
${ao}
${Eo}
${a1n}
${E1n}
no
EOF

cat fitter_input.dat | python3 ../../my_fitter/${my_fitter}
>>>>>>> a322b94853357662e48a0d647535d63fac6d2dfb

done # tmin
done # tmax
