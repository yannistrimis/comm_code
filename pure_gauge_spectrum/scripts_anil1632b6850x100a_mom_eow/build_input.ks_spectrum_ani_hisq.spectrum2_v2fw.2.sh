#! /bin/bash

# Script for building parameter input for ks_spectrum code
# to produce output in the style of spectrum2

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

# Iterate over source time slices
for ((i=0; i<${n_sources}; i++)); do
t0=$[${source_start}+${i}*${source_inc}]
corrfilet=${corrfile}_t${t0}.test-out

cat <<EOF

######################################################################
# source time ${t0}
######################################################################

# Gauge field description

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


# Eigenpairs

max_number_of_eigenpairs 0

# Chiral condensate and related measurements

number_of_pbp_masses ${nmasses}

max_cg_iterations 300
max_cg_restarts 5
npbp_reps 1
prec_pbp 1

EOF

for ((m=0; m<${nmasses}; m++)); do

cat <<EOF
mass ${mass[m]}
${naik_cmd[m]}
error_for_propagator ${error_for_propagator[m]}
rel_error_for_propagator 0
EOF

done

cat <<EOF
# Description of base sources

number_of_base_sources 1

# base source 0

evenandodd_wall
field_type KS
subset full
t0 ${t0}
source_label q
forget_source

# Description of completed sources

number_of_modified_sources 1

source 0

funnywall2
op_label f2
forget_source

EOF

###############################################################################

cat  <<EOF

# Description of propagators

number_of_sets 2

# Parameters for set 0

max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}

source 0

number_of_propagators ${nmasses}

EOF

for ((m=0; m<${nmasses}; m++)); do

cat <<EOF
# Propagators for mass ${m}

# propagator ${m}

mass ${mass[m]}
${naik_cmd[m]}
error_for_propagator ${error_for_propagator[m]}
rel_error_for_propagator 0

fresh_ksprop
forget_ksprop

EOF

done

cat  <<EOF

# Parameters for set 1

max_cg_iterations ${max_cg_iterations}
max_cg_restarts 5
check yes
momentum_twist 0 0 0
precision ${precision}

source 1

number_of_propagators ${nmasses}

EOF

for ((m=0; m<${nmasses}; m++)); do

cat <<EOF
# Propagators for mass ${m}

# propagator $[${nmasses}+${m}]

mass ${mass[m]}
${naik_cmd[m]}
error_for_propagator ${error_for_propagator[m]}
rel_error_for_propagator 0

fresh_ksprop
forget_ksprop

EOF

done

########################################################################

cat <<EOF
# Definition of quarks

number_of_quarks $[2*${nmasses}]

EOF

# QUARKS WITHOUT FUNNYWALL2

for ((m=0; m<${nmasses}; m++)); do

cat <<EOF
# mass ${m}

propagator ${m}

identity
op_label d
forget_ksprop
EOF

done

# QUARKS WITH FUNNYWALL2

for ((m=0; m<${nmasses}; m++)); do

cat <<EOF
# mass ${m}

propagator $[${nmasses}+${m}]

identity
op_label d
forget_ksprop
EOF

done



#######################################################################

cat <<EOF
# Description of mesons

number_of_mesons ${nmasses}

EOF

for ((m=0; m<${nmasses}; m++)); do

n1=$[${nmasses}+${m}]

cat <<EOF

# pair ${m}

pair ${m} ${n1}
spectrum_request meson

forget_corr
r_offset 0 0 0 ${t0}

number_of_correlators 1

correlator PION_05 p000  1 * ${norm} pion05 0 0 0 E E E           

EOF

done

cat  <<EOF

# Description of baryons

number_of_baryons 0

EOF
done
