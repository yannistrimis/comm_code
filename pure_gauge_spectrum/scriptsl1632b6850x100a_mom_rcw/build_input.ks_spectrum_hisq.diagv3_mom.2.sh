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

# EIGENPAIRS

max_number_of_eigenpairs 0

# CHIRAL CONDENSATE AND RELATED MEASUREMENTS

number_of_pbp_masses 0

######################################################################

# DESCRIPTION OF BASE SOURCES

number_of_base_sources 4

# BASE, SOURCE 0

random_color_wall
field_type KS
subset full
t0 ${t0}
ncolor 3
source_label rcw0
forget_source

# BASE, SOURCE 1

evenandodd_wall
field_type KS
subset full
t0 ${t0}
source_label eow0

# DESCRIPTION OF MODIFIED SOURCES

number_of_modified_sources 2

# MODIFIED, SOURCE 2
source 0
momentum
momentum 1 0 0
op_label rcwmom
forget_source
EOF

# MODIFIED, SOURCE 3 
source 1
momentum
momentum 1 0 0
op_label eowmom
forget_source
EOF


######################################################################
# PROPAGATORS

cat <<EOF

# DESCRIPTION OF PROPAGATORS

number_of_sets 4

for i_src in {0..3..1}; do

# PARAMETERS FOR SET 0
set_type multimass
inv_type UML
max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source ${i_src}
number_of_propagators ${nmasses}

EOF

for ((m=0; m<${nmasses}; m++)); do

cat <<EOF
# PROPAGATOR $((${i_src}+${m}))
mass ${mass[$m]}
${naik_cmd[$m]}
error_for_propagator ${error_for_propagator[$m]}
rel_error_for_propagator 0
fresh_ksprop
forget_ksprop
EOF

done # m
done # i_src

######################################################################
# QUARKS

cat  <<EOF

# DESCRIPTION OF QUARKS

number_of_quarks $((4*${nmasses}))

EOF

k=0
for i_src in {0..3..1}; do
for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF
# QUARK ${k}
propagator ${k}
identity
op_label id
forget_ksprop
EOF

k=$((${k}+1))
done # m
done # i_src

######################################################################
# MESONS

cat  <<EOF
# DESCRIPTION OF MESONS

number_of_mesons $((2*${nmasses}))

EOF



cat  <<EOF

pair 
spectrum_request meson

forget_corr
r_offset 0 0 0 ${t0}

number_of_correlators 3

correlator PION_5  p100 1 * 1 pion5  1 0 0 EO EO EO
correlator PION_5  p100 1 * 1 pion5  0 1 0 EO EO EO
correlator PION_5  p100 1 * 1 pion5  0 0 1 EO EO EO


EOF


done
done # momenta



######################################################################
# BARYONS

cat  <<EOF
# DESCRIPTION OF BARYONS
number_of_baryons 0
EOF

reload_gauge_cmd="continue"

done # t0
