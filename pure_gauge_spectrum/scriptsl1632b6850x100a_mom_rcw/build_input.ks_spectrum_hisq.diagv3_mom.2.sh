#! /bin/bash

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

number_of_base_sources 1

# BASE SOURCE 0

random_color_wall
field_type KS
subset full
t0 ${t0}
ncolor 3
momentum 0 0 0
source_label c
forget_source

# DESCRIPTION OF MODIFIED SOURCES

number_of_modified_sources ${n_of_mom}

EOF

for (( i_mom=0; i_mom<${n_of_mom}; i_mom++ )); do # MOMENTUM LOOP
mom="${mom_labels[${i_mom}]:0:1} ${mom_labels[${i_mom}]:1:1} ${mom_labels[${i_mom}]:2:1}"

cat <<EOF
# MODIFIED SOURCE ${i_mom}
source 0
momentum
momentum ${mom}
op_label m
forget_source
EOF

done # momenta

######################################################################
# PROPAGATORS

cat  <<EOF

# DESCRIPTION OF PROPAGATORS

number_of_sets $[1+${n_of_mom}]

# PARAMETERS FOR SET 0
set_type multimass
inv_type UML
max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source 0
number_of_propagators ${nmasses}

EOF

for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF

# PROPAGATOR ${m}
mass ${mass[$m]}
${naik_cmd[$m]}
error_for_propagator ${error_for_propagator[$m]}
rel_error_for_propagator 0
fresh_ksprop
forget_ksprop

EOF

done # masses

k=${nmasses}
for (( i_mom=0; i_mom<${n_of_mom}; i_mom++ )); do # MOMENTUM LOOP

cat  <<EOF

# PARAMETERS FOR SET $[1+${i_mom}]
set_type multimass
inv_type UML
max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source $[1+${i_mom}]
number_of_propagators ${nmasses}

EOF

for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF

# PROPAGATOR ${k}
mass ${mass[$m]}
${naik_cmd[$m]}
error_for_propagator ${error_for_propagator[$m]}
rel_error_for_propagator 0
fresh_ksprop
forget_ksprop

EOF

k=$[1+${k}]

done # masses
done # momenta

######################################################################
# QUARKS

cat  <<EOF

# DESCRIPTION OF QUARKS

number_of_quarks $[2*${nmasses}*${n_of_mom}]

EOF

# QUARKS WITH MOMENTUM AT THE SINK. THEY ALL USE
# THE SAME PROPAGATOR THAT WAS CALCULATED WITH A
# ZERO MOMENTUM SOURCE

for (( i_mom=0; i_mom<${n_of_mom}; i_mom++ )); do # MOMENTUM LOOP
mom="${mom_labels[${i_mom}]:0:1} ${mom_labels[${i_mom}]:1:1} ${mom_labels[${i_mom}]:2:1}"

for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF
# MASS ${m}
propagator ${m}
momentum
momentum ${mom}
op_label d
forget_ksprop
EOF

done # masses
done # momenta

# QUARKS WITH MOMENTUM AT THE SOURCE. THEY WILL RECEIVE
# JUST THE IDENTITY AT THE SINK.

k=${nmasses}

for (( i_mom=0; i_mom<${n_of_mom}; i_mom++ )); do # MOMENTUM LOOP

for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF
# MASS ${m}
propagator ${k}
identity
op_label d
forget_ksprop
EOF

k=$[${k}+1]
done # masses
done # momenta

######################################################################
# MESONS

cat  <<EOF
# DESCRIPTION OF MESONS

number_of_mesons $[${n_of_mom}*${nmasses}]

EOF

for (( i_mom=0; i_mom<${n_of_mom}; i_mom++ )); do # MOMENTUM LOOP
mom_label=${mom_labels[${i_mom}]}

q1_min=$[${i_mom}*${nmasses}]
q1_max=$[${i_mom}*${nmasses}+${nmasses}]
for (( q1=${q1_min}; q1<${q1_max}; q1++ )); do

q2=$[${n_of_mom}*${nmasses}+${q1}]

cat  <<EOF

pair ${q1} ${q2}
spectrum_request meson

forget_corr
r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p${mom_label}  1 * 1 pion5  0 0 0 E E E

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

done # sources
