#!/bin/bash

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

###RUN COMMAND HERE

for i in {1..10..1}
do

i_lat=$(awk "BEGIN {printf \"%i\" , ${i_start}+${i}}")
echo "${i_lat}"

done
