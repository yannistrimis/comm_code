#!/bin/bash

source params.sh

i_curr=$1
seed=$2
if [ $i_curr -gt 101 ]
then
i_prev=$((${i_curr}-1))

cat << EOF > input
prompt 0
nx 4
ny 4
nz 4
nt 4
iseed ${seed}

warms 0
trajecs 3
traj_between_meas 1
beta 5.0 7.0
u0 0.870
steps_per_trajectory 2
qhb_steps 1
reload_serial ${directory}/try.lat.${i_prev}
save_serial ${directory}/try.lat.${i_curr}
EOF

elif [ $i_curr -eq 101 ]
then

cat << EOF > input
prompt 0
nx 4
ny 4
nz 4
nt 4
iseed ${seed}

warms 0
trajecs 3
traj_between_meas 1
beta 5.0 7.0
u0 0.870
steps_per_trajectory 2
qhb_steps 1
fresh
save_serial ${directory}/try.lat.${i_curr}
EOF

fi


