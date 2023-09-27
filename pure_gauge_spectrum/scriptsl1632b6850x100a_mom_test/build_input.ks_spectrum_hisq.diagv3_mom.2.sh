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

t0=0

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

# SOURCE 0
evenandodd_wall
field_type KS
subset full
t0 0
source_label eow
forget_source

# DESCRIPTION OF MODIFIED SOURCES

number_of_modified_sources 1

# SOURCE 1
source 0
momentum
momentum 1 0 0
op_label mom
forget_source

EOF

######################################################################
# PROPAGATORS

cat  <<EOF

# DESCRIPTION OF PROPAGATORS

number_of_sets 2

# PARAMETERS FOR SET 0
set_type multimass
inv_type UML
max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source 0
number_of_propagators 1

# PROPAGATOR 0
mass ${mass[0]}
${naik_cmd[0]}
error_for_propagator ${error_for_propagator[0]}
rel_error_for_propagator 0
fresh_ksprop
forget_ksprop


# PARAMETERS FOR SET 1
set_type multimass
inv_type UML
max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source 1
number_of_propagators 1

# PROPAGATOR 1
mass ${mass[0]}
${naik_cmd[0]}
error_for_propagator ${error_for_propagator[0]}
rel_error_for_propagator 0
fresh_ksprop
forget_ksprop


EOF


######################################################################
# QUARKS

cat  <<EOF

# DESCRIPTION OF QUARKS

number_of_quarks 4

# QUARK 0
propagator 0
identity
op_label id
forget_ksprop

# QUARK 1
propagator 0
momentum
momentum 1 0 0
op_label id_mom
forget_ksprop

# QUARK 2
propagator 1
identity
op_label id
forget_ksprop

# QUARK 3
propagator 1
momentum
momentum 1 0 0
op_label id_mom
forget_ksprop

EOF

######################################################################
# MESONS

cat  <<EOF
# DESCRIPTION OF MESONS

number_of_mesons 4

pair 2 0
spectrum_request meson

forget_corr
r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p100  1 * 1 pion5  1 0 0 EO EO EO

pair 0 2
spectrum_request meson

forget_corr
r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p100  1 * 1 pion5  1 0 0 EO EO EO

pair 0 3
spectrum_request meson

forget_corr
r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p000  1 * 1 pion5  0 0 0 EO EO EO

pair 1 2
spectrum_request meson

forget_corr
r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p000  1 * 1 pion5  0 0 0 EO EO EO

EOF

######################################################################
# BARYONS

cat  <<EOF
# DESCRIPTION OF BARYONS
number_of_baryons 0
EOF

reload_gauge_cmd="continue"


