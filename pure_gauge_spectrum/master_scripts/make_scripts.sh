#!/bin/bash

# THIS SCRIPT CREATES DIRECTORIES FOR PURE GAUGE GRADIENT FLOW.
# IF MULTIPLE DIRECTORIES ARE NEEDED, THE USER CAN CREATE ARRAYS
# FOR THE CHANGING PARAMETERS.

cluster="fnal"
n_of_ens=1

nx=16
nt=128

set_i_lat=101
set_seed=78324

beta_name="7225"
xi_0_name="36836"
stream="a"

u0=1

set_source_start=0
n_sources=2
source_inc=64 # CHANGE ACCORDING TO nt
source_prec=34 # CHANGE ACCORDING TO nt

nmasses=1
mass1=0.01448

nxq=1
xq1=3.75

xq1_name="3750"

err=1e-6
max_cg_iterations=300
action=hisq
precision=2

sbatch_time="02:00:00"
sbatch_nodes=4 # N/A WHEN icer IS SELECTED
sbatch_ntasks=128
sbatch_jobname="nlpi_xi4"

prefix="nlpi"
build_prefix="nlpi"

n_of_sub=1
n_of_lat=5

for (( i_ens=0; i_ens<${n_of_ens}; i_ens++ )); do

# SUBSTITUTE ARRAY ELEMENTS HERE, IF ANY

ensemble_nostream="${nx}${nt}b${beta_name}x${xi_0_name}"
ensemble="${ensemble_nostream}${stream}"
lat_name="l${ensemble}"

out_name="spec${prefix}${ensemble_nostream}"
my_dir="${cluster}_${prefix}_scripts_${ensemble}"

build_script="build_input_${build_prefix}.sh"

cd ..
mkdir ${my_dir}
cd master_scripts

# ==================================================================================
# ==================================================================================
cat <<EOF > ../${my_dir}/params.sh

#!/bin/bash

cluster=${cluster}

n_of_lat=${n_of_lat}
n_of_sub=${n_of_sub}

set_i_lat=${set_i_lat}
set_seed=${set_seed}

nx=${nx}
ny=${nx}
nz=${nx}
nt=${nt}

lat_name="${lat_name}"
out_name="${out_name}"

nmasses=${nmasses}
mass_arr=( ${mass1} ${mass2} ${mass3} ${mass4} ${mass5} ${mass6} )

nxq=${nxq}
xq_arr=( ${xq1} ${xq2} ${xq3} ${xq4} ${xq5} ${xq6} )
xq_name_arr=( ${xq1_name} ${xq2_name} ${xq3_name} ${xq4_name} ${xq5_name} ${xq6_name} )

u0=${u0}

set_source_start=${set_source_start}
n_sources=${n_sources}
source_inc=${source_inc}
source_prec=${source_prec}

err=${err}
max_cg_iterations=${max_cg_iterations}
action=${action}
precision=${precision}

build_script=${build_script}

EOF

if [ ${cluster} == "icer" ]
then

cat <<EOF >> ../${my_dir}/params.sh

directory="/mnt/scratch/trimisio/lattices/${lat_name}"
out_dir="/mnt/home/trimisio/outputs/pure_gauge_spec/${lat_name}"
path_build="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/build"
run_dir="/mnt/scratch/trimisio/runs/runspec${prefix}${lat_name}"
submit_dir="/mnt/home/trimisio/submits/subspec${prefix}${lat_name}"

executable="ks_spectrum_ani_hisq_icc_dbl_20230619"

sbatch_time="${sbatch_time}"
sbatch_ntasks="${sbatch_ntasks}"
sbatch_jobname="${sbatch_jobname}"
sbatch_module="intel/2020b"

EOF

elif [ ${cluster} == "fnal" ]
then

cat <<EOF >> ../${my_dir}/params.sh

directory="/lustre1/ahisq/yannis_puregauge/lattices/${lat_name}"
out_dir="/project/ahisq/yannis_puregauge/outputs/pure_gauge_spec/${lat_name}"
path_build="/home/trimisio/all/comm_code/pure_gauge_spectrum/build"
run_dir="/project/ahisq/yannis_puregauge/runs/runspec${prefix}${lat_name}"
submit_dir="/project/ahisq/yannis_puregauge/submits/subspec${prefix}${lat_name}"

executable="ks_spectrum_ani_hisq_dbl_gcc12openmpi4_20231207"

sbatch_time="${sbatch_time}"
sbatch_nodes="${sbatch_nodes}"
sbatch_ntasks="${sbatch_ntasks}"
sbatch_jobname="${sbatch_jobname}"
sbatch_module1="gcc/12"
sbatch_module2="openmpi/4"

EOF

fi

# =====================================================================================
# =====================================================================================


cp control_script.sh ../${my_dir}/control_script.sh
cp is_complete.sh ../${my_dir}/is_complete.sh
cp make_input.sh ../${my_dir}/make_input.sh
cp make_submit.sh ../${my_dir}/make_submit.sh
cp envelope_script.sh ../${my_dir}/envelope_script.sh
cp ${build_script} ../${my_dir}/${build_script}

done # i_ens
