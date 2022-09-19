#!/bin/bash

echo 'entered control_script'

i_start=$1

cat << EOF > input
prompt 0
nx 4
ny 4
nz 4
nt 4
iseed 9435

warms 0
trajecs 3
traj_between_meas 1
beta 5.0 7.0
u0 0.870
steps_per_trajectory 2
qhb_steps 1
fresh
save_serial TRY_1.lat.${i_start}
EOF

srun -n 4 ./su3_ora_symzk0_a_intel input output.${i_start}

for i in {1..4..1}
do

i_lat=$(awk "BEGIN {printf \"%i\" , ${i_start}+${i}}")
i_prev=$(awk "BEGIN {printf \"%i\" , ${i_start}+${i}-1}")
cat << EOF > input
prompt 0
nx 4
ny 4
nz 4
nt 4
iseed 9435

warms 0
trajecs 3
traj_between_meas 1
beta 5.0 7.0
u0 0.870
steps_per_trajectory 2
qhb_steps 1
reload_serial TRY_1.lat.${i_prev}
save_serial TRY_1.lat.${i_lat}
EOF

srun -n 4 ./su3_ora_symzk0_a_intel input output.${i_lat}

done
