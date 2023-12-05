#!/bin/bash

paramfile=$1

if [ $# -lt 1 ]
then
    echo "Usage $0 <paramfile>"
    exit 1
fi

source $paramfile

vol3=$[${nx}*${ny}*${nz}]
norm=`echo $vol3 | awk '{print 1./$1}'`

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

evenandodd_wall
field_type KS
subset full
t0 ${t0}
source_label q
forget_source

# DESCRIPTION OF MODIFIED SOURCES'

number_of_modified_sources 2

# MODIFIED, SOURCE 1

source 0

funnywall1
op_label f1
forget_source

# MODIFIED, SOURCE 2

source 0

funnywall2
op_label f2
forget_source

######################################################################

### PROPAGATORS

# DESCRIPTION OF PROPAGATORS

number_of_sets 3

# PARAMETERS FOR SET 0

max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source 0
number_of_propagators ${nmasses}

# PROPAGATORS FOR SET 0

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

done # m

cat <<EOF

# PARAMETERS FOR SET 1

max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source 1
number_of_propagators ${nmasses}

# PROPAGATORS FOR SET 1

EOF

for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF

# PROPAGATOR $[${nmasses}+${m}]

mass ${mass[$m]}
${naik_cmd[$m]}
error_for_propagator ${error_for_propagator[$m]}
rel_error_for_propagator 0
fresh_ksprop
forget_ksprop

EOF

done # m

cat <<EOF

# PARAMETERS FOR SET 2

max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}
source 2
number_of_propagators ${nmasses}

# PROPAGATORS FOR SET 2

EOF

for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF

# PROPAGATOR $[2*${nmasses}+${m}]

mass ${mass[$m]}
${naik_cmd[$m]}
error_for_propagator ${error_for_propagator[$m]}
rel_error_for_propagator 0
fresh_ksprop
forget_ksprop

EOF

done # m

cat <<EOF

######################################################################
### QUARKS

# DESCRIPTION OF QUARKS

number_of_quarks $[3*${nmasses}]

# QUARKS FOR evenandodd_wall SOURCE

EOF

for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF

# MASS ${m}

propagator ${m}
identity
op_label d
forget_ksprop

EOF

done # m

# QUARKS WITH funnywall1 SOURCE

for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF

# MASS ${m}

propagator $[${nmasses}+${m}]
identity
op_label d
forget_ksprop

EOF

done # m

# QUARKS WITH funnywall2 SOURCE

for ((m=0; m<${nmasses}; m++)); do

cat  <<EOF

# MASS ${m}

propagator $[2*${nmasses}+${m}]
identity
op_label d
forget_ksprop

EOF

done # m

cat <<EOF

######################################################################
### MESONS

# DESCRIPTION OF MESONS

number_of_mesons $[2*${nmasses}]

EOF

for ((m=0; m<${nmasses}; m++)); do

n1=$[${nmasses}+${m}]
n2=$[2*${nmasses}+${m}]

cat  <<EOF

# evenandodd_wall WITH funnywall1

pair ${m} ${n1}
spectrum_request meson

forget_corr
r_offset 0 0 0 ${t0}

number_of_correlators 6

# Normalization is 1/vol3
correlator PION_5  p000  1 * ${norm} pion5  0 0 0 E E E
correlator PION_i5 p000  1 * ${norm} pioni5 0 0 0 E E E
correlator PION_i  p000  1 * ${norm} pioni  0 0 0 E E E
correlator PION_s  p000  1 * ${norm} pions  0 0 0 E E E
correlator RHO_i   p000  1 * ${norm} rhoi   0 0 0 E E E
correlator RHO_s   p000  1 * ${norm} rhois  0 0 0 E E E

# evenandodd_wall WITH funnywall2

pair ${m} ${n2}
spectrum_request meson

forget_corr
r_offset 0 0 0 ${t0}

number_of_correlators 6

# Normalization is 1/vol3
correlator PION_05 p000  1 * ${norm} pion05 0 0 0 E E E
correlator PION_ij p000  1 * ${norm} pionij 0 0 0 E E E
correlator PION_i0 p000  1 * ${norm} pioni0 0 0 0 E E E
correlator PION_0  p000  1 * ${norm} pion0  0 0 0 E E E
correlator RHO_i0  p000  1 * ${norm} rhoi0  0 0 0 E E E
correlator RHO_0   p000  1 * ${norm} rho0   0 0 0 E E E

EOF

done # m

cat <<EOF

######################################################################
# BARYONS

# DESCRIPTION OF BARYONS
number_of_baryons 0

EOF

reload_gauge_cmd="continue"

done # t0


















