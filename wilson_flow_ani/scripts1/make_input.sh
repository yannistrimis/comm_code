#!/bin/bash

source /mnt/home/trimisio/comm_code/wilson_flow_ani/scripts1/params.sh

i_curr=$1

cat << EOF > input
prompt 0
nx $nx
ny $ny
nz $nz
nt $nt
anisotropy ${xf}

reload_serial ${lat_directory}/${lat_name}.${i_curr}
${flow_action}
exp_order ${exp_order}
stepsize ${dt}
stoptime ${stoptime}
forget
EOF
