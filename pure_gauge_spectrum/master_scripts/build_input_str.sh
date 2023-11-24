#!/bin/bash

paramfile=$1

if [ $# -lt 1 ]
then
    echo "Usage $0 <paramfile>"
    exit 1
fi

source $paramfile

vol3=$[${nx}*${ny}*${nz}]

reload_gauge_cmd="reload_serial ${inlat}"

for ((i=0; i<${nmasses}; i++)); do
case $action in
hisq)
  naik_cmd[$i]="naik_term_epsilon ${naik_term_epsilon[i]}"
;;
asqtad)
  naik_cmd[$i]=""
;;
esac
done

cat <<EOF
prompt 0
nx ${nx}
ny ${ny}
nz ${nz}
nt ${nt}
iseed ${iseed}
job_id ${jobid}
EOF

# ITERATE OVER SOURCE TIME SLICES
for ((i=0; i<${n_sources}; i++)); do
t0=$[${source_start}+${i}*${source_inc}]

cat  <<EOF

######################################################################
# source time ${t0}
######################################################################

# GAUGE FIELD DESCRIPTION

${reload_gauge_cmd}
u0 ${u0}
coulomb_gauge_fix
forget
staple_weight 0
ape_iter 0
coordinate_origin 0 0 0 0
time_bc antiperiodic

# ANISOTROPY
ani_dir ${ani_dir}
ani_xiq ${ani_xiq}


# EIGENPAIRS

max_number_of_eigenpairs 0

# CHIRAL CONDENSATE AND RELATED MEASUREMENTS

number_of_pbp_masses 0

######################################################################

### DESCRIPTION OF BASE SOURCES

number_of_base_sources 1

# BASE, SOURCE 0

corner_wall
field_type KS
subset full
t0 ${t0}
source_label cw
forget_source

# Description of modified sources

number_of_modified_sources 0

######################################################################

### PROPAGATORS

# DESCRIPTION OF PROPAGATORS

number_of_sets 1

# PARAMETERS FOR SET 0
max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source 0
number_of_propagators ${nmasses}

EOF

for (( i_mass=0; i_mass<${nmasses}; i_mass++ )); do

cat <<EOF

# PROPAGATOR ${i_mass}
mass ${mass[$i_mass]}
${naik_cmd[$i_mass]}
error_for_propagator ${error_for_propagator[$i_mass]}
rel_error_for_propagator 0
fresh_ksprop
forget_ksprop

EOF

done # i_mass

cat <<EOF
######################################################################
### QUARKS


# DESCRIPTION OF QUARKS

number_of_quarks ${nmasses}

EOF

for (( i_mass=0; i_mass<${nmasses}; i_mass++ )); do

cat  <<EOF

# QUARK ${i_mass}
propagator ${i_mass}
identity
op_label id
forget_ksprop

EOF

done # i_mass

cat <<EOF
######################################################################
### MESONS

# DESCRIPTION OF MESONS

number_of_mesons ${nmasses}

EOF

for (( i_mass=0; i_mass<${nmasses}; i_mass++ )); do

cat <<EOF

pair ${i_mass} ${i_mass}
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p000 1 * 1 pion5  0 0 0 EO EO EO

EOF

done # i_mass

cat <<EOF

######################################################################
# BARYONS

# DESCRIPTION OF BARYONS
number_of_baryons 0

EOF

reload_gauge_cmd="continue"

done # t0










