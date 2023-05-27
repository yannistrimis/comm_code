#!/bin/bash
source ${3}/params.sh

inlat="${lat_directory}/${lat_name}.lat.${1}"

source_start=$(python3 -c "a=int(   ${set_source_start} + (  (${1}-${set_i_lat})*${source_prec}  ) % int(${nt}/2)   );print(a)")
echo "source start = ${source_start}"

cat << EOF > ${submit_dir}/param_input
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

n_of_bs=${n_of_bs}
bs_arr=( ${bs1} ${bs2} ${bs3} ${bs4} )

n_of_mom=${n_of_mom}
mom_labels=( ${moml1} ${moml2} ${moml3} ${moml4} ${moml5} ${moml6} ${moml7} ${moml8} ${moml9} )

naik_term_epsilon=( 0 0 0 0 0 )
error_for_propagator=( ${err} ${err} ${err} ${err} ${err} )
max_cg_iterations=${max_cg_iterations}
corrfile=none
action="${action}"
precision=${precision}

EOF
