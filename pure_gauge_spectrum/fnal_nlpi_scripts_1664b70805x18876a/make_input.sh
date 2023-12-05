#!/bin/bash
source ${4}/params.sh

inlat="${directory}/${lat_name}.${1}"

source_start=$(python3 -c "a=int(   ${set_source_start} + (  (${1}-${set_i_lat})*${source_prec}  ) % int(${nt}/2)   );print(a)")
echo "source start = ${source_start}"

cat << EOF > ${submit_dir}/param_input

nx=${nx}
ny=${ny}
nz=${nz}
nt=${nt}

iseed=${2}
jobid=none
inlat=${inlat}
u0=${u0}

ani_dir="t"
ani_xiq=$3

source_start=${source_start}
source_inc=${source_inc}
n_sources=${n_sources}

nmasses=${nmasses}
mass=( ${mass_arr[0]} ${mass_arr[1]} ${mass_arr[2]} ${mass_arr[3]} ${mass_arr[4]} ${mass_arr[5]} )

naik_term_epsilon=( 0 0 0 0 0 0 )
error_for_propagator=( ${err} ${err} ${err} ${err} ${err} ${err} )
max_cg_iterations=${max_cg_iterations}
corrfile=none
action="${action}"
precision=${precision}

EOF

