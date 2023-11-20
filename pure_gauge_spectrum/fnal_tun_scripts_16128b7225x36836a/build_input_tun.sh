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

number_of_base_sources 3

# BASE, SOURCE 0

random_color_wall
field_type KS
subset full
t0 ${t0}
ncolor 3
momentum 0 0 0
source_label rcw0
forget_source

# BASE, SOURCE 1

corner_wall
field_type KS
subset full
t0 ${t0}
source_label cw0
forget_source

# BASE, SOURCE 2

point
field_type KS
subset full
origin 0 0 0 ${t0}
source_label pt
forget_source

### DESCRIPTION OF MODIFIED SOURCES

number_of_modified_sources 4

# MODIFIED, SOURCE 3
source 0
momentum
momentum 1 0 0
op_label rcwm1
forget_source

# MODIFIED, SOURCE 4
source 1
momentum
momentum 1 0 0
op_label cwm1
forget_source


# MODIFIED, SOURCE 5
source 0
momentum
momentum 1 1 0
op_label rcwm2
forget_source

# MODIFIED, SOURCE 6
source 1
momentum
momentum 1 1 0
op_label cwm2
forget_source

######################################################################

### PROPAGATORS

# DESCRIPTION OF PROPAGATORS

number_of_sets 7

EOF

i_prop=-1
for i_src in {0..6..1}; do

cat <<EOF

# PARAMETERS FOR SET ${i_src}
max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source ${i_src}
number_of_propagators ${nmasses}

EOF

for (( i_mass=0; i_mass<${nmasses}; i_mass++ )); do
i_prop=$(($i_prop+1))

cat <<EOF

# PROPAGATOR ${i_prop}
mass ${mass[$i_mass]}
${naik_cmd[$i_mass]}
error_for_propagator ${error_for_propagator[$i_mass]}
rel_error_for_propagator 0
fresh_ksprop
forget_ksprop

EOF

done # i_mass
done # i_src

n_of_prop=$((${nmasses}*7))

cat<<EOF
######################################################################
### QUARKS


# DESCRIPTION OF QUARKS

number_of_quarks ${n_of_prop}

EOF

for (( i_prop=0; i_prop<${n_of_prop}; i_prop++ )); do

cat  <<EOF

# QUARK ${i_prop}
propagator ${i_prop}
identity
op_label id
forget_ksprop

EOF

done # i_prop


n_of_mesons=$((9*${nmasses}))

cat <<EOF

######################################################################
### MESONS

# DESCRIPTION OF MESONS

number_of_mesons ${n_of_mesons}

EOF

for (( i_mass=0; i_mass<${nmasses}; i_mass++ )); do

cat <<EOF

pair ${i_mass} ${i_mass}
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p000 1 * 1 pion5  0 0 0 EO EO EO

pair $((1*${nmasses}+${i_mass})) $((1*${nmasses}+${i_mass}))
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p000 1 * 1 pion5  0 0 0 EO EO EO

pair $((2*${nmasses}+${i_mass})) $((2*${nmasses}+${i_mass}))
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p000 1 * 1 pion5  0 0 0 EO EO EO

EOF

done # i_mass

for (( i_mass=0; i_mass<${nmasses}; i_mass++ )); do

cat <<EOF

pair $((3*${nmasses}+${i_mass})) ${i_mass}
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p100 1 * 1 pion5  1 0 0 EO EO EO

pair $((4*${nmasses}+${i_mass})) $((${nmasses}+${i_mass}))
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p100 1 * 1 pion5  1 0 0 EO EO EO

pair $((2*${nmasses}+${i_mass})) $((2*${nmasses}+${i_mass}))
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 3

correlator PION_5  p100 1 * 1 pion5  1 0 0 EO EO EO
correlator PION_5  p100 1 * 1 pion5  0 1 0 EO EO EO
correlator PION_5  p100 1 * 1 pion5  0 0 1 EO EO EO

EOF

done # i_mass

for (( i_mass=0; i_mass<${nmasses}; i_mass++ )); do

cat <<EOF

pair $((5*${nmasses}+${i_mass})) ${i_mass}
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p110 1 * 1 pion5  1 1 0 EO EO EO

pair $((6*${nmasses}+${i_mass})) $((${nmasses}+${i_mass}))
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_5  p110 1 * 1 pion5  1 1 0 EO EO EO

pair $((2*${nmasses}+${i_mass})) $((2*${nmasses}+${i_mass}))
spectrum_request meson

forget_corr

r_offset 0 0 0 ${t0}

number_of_correlators 3

correlator PION_5  p110 1 * 1 pion5  1 1 0 EO EO EO
correlator PION_5  p110 1 * 1 pion5  1 0 1 EO EO EO
correlator PION_5  p110 1 * 1 pion5  0 1 1 EO EO EO

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
