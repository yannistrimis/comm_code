#!/bin/bash
source fitter_params.sh

if [ ${my_fitter} = "my_fitter_n.py"  ]
then
echo "#tmin tmax chi2/dof Emean Esdev"
elif [ ${my_fitter} = "my_fitter_no.py"  ]
then
echo "#tmin tmax chi2/dof Emean Esdev EOmean EOsdev"
elif [ ${my_fitter} = "my_fitter_non.py"  ]
then
echo "#tmin tmax chi2/dof Emean Esdev EOmean EOsdev E1mean E1sdev"

fi

for (( tmin=0 ; tmin<=${tmin_max} ; tmin++ ))
do
for tmax in ${tmax_arr[@]}
do

if [ ${my_fitter} = "scipy_fitter_n.py"  ]
then

cat <<EOF > fitter_input.dat 
$1
$2
${source1}
${source2}
${sinks}
specnd
${tmin}
${tmax}
${an}
${En}
no
EOF

elif [ ${my_fitter} = "scipy_fitter_no.py"  ]
then

cat <<EOF > fitter_input.dat
$1
$2
${source1}
${source2}
${sinks}
specnd
${tmin}
${tmax}
${an}
${En}
${ao}
${Eo}
no
EOF

elif [ ${my_fitter} = "scipy_fitter_non.py"  ]
then

cat <<EOF > fitter_input.dat
${one_mass1}
${one_mass2}
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

fi

cat fitter_input.dat | python3 ${my_fitter}

done # tmin
done # tmax
