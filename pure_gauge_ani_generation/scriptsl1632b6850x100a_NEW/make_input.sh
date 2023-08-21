#!/bin/bash

source ${3}/params.sh

i_curr=$1
seed=$2

if [ $i_curr -gt 1 ]
then
i_prev=$((${i_curr}-1))

cat << EOF > ${submit_dir}/input
prompt 0
nx $nx
ny $ny
nz $nz
nt $nt
iseed ${seed}

warms $warms
trajecs $trajecs
traj_between_meas $traj_between_meas
beta $beta_s $beta_t
ani_dir t
u0 $u0
steps_per_trajectory $steps_per_trajectory
qhb_steps $qhb_steps
reload_serial ${directory}/${lat_name}.${i_prev}
save_serial ${directory}/${lat_name}.${i_curr}
EOF

elif [ $i_curr -eq 1 ]
then

cat << EOF > ${submit_dir}/input
prompt 0
nx $nx
ny $ny
nz $nz
nt $nt
iseed ${seed}

warms $warms
trajecs $trajecs
traj_between_meas $traj_between_meas
beta $beta_s $beta_t
ani_dir t
u0 $u0
steps_per_trajectory $steps_per_trajectory
qhb_steps $qhb_steps
fresh
save_serial ${directory}/${lat_name}.${i_curr}
EOF

fi


