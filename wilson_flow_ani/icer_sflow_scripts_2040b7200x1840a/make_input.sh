#!/bin/bash

source ${4}/params.sh

i_curr=$1

cat << EOF > ${submit_dir}/input
prompt 0
nx $nx
ny $ny
nz $nz
nt $nt
anisotropy $3

reload_serial ${directory}/${lat_name}.${i_curr}
${flow_action}
exp_order ${exp_order}
stepsize $2
stoptime ${stoptime}
forget
EOF

