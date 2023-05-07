#!/bin/bash
source fitter_params.sh

echo "#tmin tmax chi2/dof Emean Esdev EOmean EOsdev E1mean E1sdev"

fi

for (( tmin=0 ; tmin<=${tmin_max} ; tmin++ ))
do
for tmax in ${tmax_arr[@]}
do

cat <<EOF > fitter_input.dat
non
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

cat fitter_input.dat | python3 ${my_fitter}

done # tmin
done # tmax
