#!/bin/bash

# THIS SCRIPT CREATES DIRECTORIES FOR PURE GAUGE GRADIENT FLOW.
# IF MULTIPLE DIRECTORIES ARE NEEDED, THE USER CAN CREATE ARRAYS
# FOR THE CHANGING PARAMETERS.

cluster="fnal"
n_of_ens=1

nx=16
nt=32

beta_name="6900"
xi_0_name="178"
stream="a"

xi_f=2.00
xi_f_name="200"

flow_action="wilson"
exp_order="16"
dt="0.015625"
stoptime="2.4"

sbatch_time="00:40:00"
sbatch_nodes=4 # N/A WHEN icer IS SELECTED
sbatch_ntasks=128
sbatch_jobname="sfl178"

n_of_sub=1
n_of_lat=10

for (( i_ens=0; i_ens<${n_of_ens}; i_ens++ )); do

# SUBSTITUTE ARRAY ELEMENTS HERE, IF ANY
# SUBSTITUTE ARRAY ELEMENTS HERE, IF ANY
# SUBSTITUTE ARRAY ELEMENTS HERE, IF ANY
# SUBSTITUTE ARRAY ELEMENTS HERE, IF ANY
# SUBSTITUTE ARRAY ELEMENTS HERE, IF ANY

ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"
lat_name="l${ensemble}"

ensemble_nostream="${nx}${nt}b${beta_name}x${xi_0_name}"

if [ ${flow_action}=="wilson"  ]
out_name="wflow${ensemble_nostream}xf${xi_f_name}${stream}_dt${dt}"
elif [ ${flow_action}=="symanzik" ]
out_name="sflow${ensemble_nostream}xf${xi_f_name}${stream}_dt${dt}"
fi

my_dir="${cluster}_${flow_action}_scripts_${ensemble}"

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

nx=${nx}
ny=${nx}
nz=${nx}
nt=${nt}

lat_name="${lat_name}"
out_name="${out_name}"

xi_f=${xi_f}

flow_action="${flow_action}"
exp_order="${exp_order}"
dt="${dt}"
stoptime="${stoptime}"

EOF

if [ ${cluster} == "icer" ]
then

cat <<EOF >> ../${my_dir}/params.sh

directory="/mnt/scratch/trimisio/lattices/${lat_name}"
out_dir="/mnt/home/trimisio/outputs/${lat_name}"
path_build="/mnt/home/trimisio/comm_code/wilson_flow_ani/build"
run_dir="/mnt/scratch/trimisio/runs/runflow${lat_name}"
submit_dir="/mnt/home/trimisio/submits/subflow${lat_name}"

executable=""

sbatch_time="${sbatch_time}"
sbatch_ntasks="${sbatch_ntasks}"
sbatch_jobname="${sbatch_jobname}"
sbatch_module="intel/2020b"

EOF

elif [ ${cluster} == "fnal" ]
then

cat <<EOF >> ../${my_dir}/params.sh

directory="/lustre1/ahisq/yannis_puregauge/lattices/${lat_name}"
out_dir="/project/ahisq/yannis_puregauge/outputs/${lat_name}"
path_build="/home/trimisio/all/comm_code/wilson_flow_ani/build"
run_dir="/project/ahisq/yannis_puregauge/runs/runflow${lat_name}"
submit_dir="/project/ahisq/yannis_puregauge/submits/subflow${lat_name}"

executable=""

sbatch_time="${sbatch_time}"
sbatch_nodes="${sbatch_nodes}"
sbatch_ntasks="${sbatch_ntasks}"
sbatch_jobname="${sbatch_jobname}"
sbatch_module1="gnu8"
sbatch_module2="openmpi3"

EOF

fi

# =====================================================================================
# =====================================================================================


cp control_script.sh ../${my_dir}/control_script.sh
cp is_complete.sh ../${my_dir}/is_complete.sh
cp make_input.sh ../${my_dir}/make_input.sh
cp make_submit.sh ../${my_dir}/make_submit.sh
cp envelope_script.sh ../${my_dir}/envelope_script.sh


done # i_ens
