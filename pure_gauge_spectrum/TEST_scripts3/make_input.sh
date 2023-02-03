#!/bin/bash
source ${3}/params.sh

inlat="${lat_directory}/${lat_name}.lat.${1}"

# THIS IS FOR TESTING
# inlat="/mnt/home/trimisio/local_code/milc/git20230120_develop/milc_qcd/binary_samples/lat.sample.l8888"

source_start=$(python3 -c "a=int( ${set_source_start}+( (${1}-${set_i_lat})*${source_prec} )%${nt} );print(a)")
echo "source start = ${source_start}"
cat << EOF > ${run_dir}/param_input
# Parameter file to be sourced by build_spectrum2 script
nx=${nx}
ny=${ny}
nz=${nz}
nt=${nt}
iseed=${2}
jobid=none
inlat=${inlat}
u0=${u0}
source_start=${source_start}
source_inc=${source_inc}
n_sources=${n_sources}
nmasses=${nmasses}
mass=( ${mass1} ${mass2} ${mass3} ${mass4} ${mass5} )
err=${err}
naik_term_epsilon=( 0 0 0 0 0 )
error_for_propagator=( ${err} ${err} ${err} ${err} ${err} )
pbp_error_for_propagator=${err}
max_cg_iterations=${max_cg_iterations}
corrfile=none
action=${action}
precision=${precision}
EOF
