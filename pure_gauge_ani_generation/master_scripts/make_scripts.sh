#!/bin/bash


# THIS SCRIPT CREATES DIRECTORIES FOR PURE GAUGE ENSEMBLE GENERATION.
# ALL THE PARAMETERS THAT DEFINE AN ENSEMBLE ARE PLACED IN ARRAYS OF AS MANY ELEMENTS
# AS THE NUMBER OF ENSEMBLES TO BE GENERATED. IF A PARAMETER IS E.G. SAME IN TWO ENSEMBLES
# THEN THE VALUE HAS TO BE REPEATED, I.E. THERE IS NO LOOP OVER INDIVIDUAL PARAMETERS, BUT 
# ONLY OVER THE ENSEMBLES (i_ens).


cluster="fnal"
n_of_ens=1

# THE FOLLOWING ARRAYS SHOULD ALL HAVE
# THE SAME LENGTH, EQUAL TO n_of_ens

nx_arr=(4)
nt_arr=(4)

beta_s_arr=(6.86)
beta_t_arr=(6.86)

beta_name_arr=("6860")
xi_0_name_arr=("100")

stream_arr=("a")

sbatch_time_arr=("00:30:00")
sbatch_nodes_arr=(1)                         # N/A WHEN icer IS SELECTED
sbatch_ntasks_arr=(1)
sbatch_jobname_arr=("gentest1")

n_of_sub_arr=(2)
n_of_lat_arr=(1)


for (( i_ens=0; i_ens<${n_of_ens}; i_ens++ )); do

nx=${nx_arr[${i_ens}]}
nt=${nt_arr[${i_ens}]}

beta_s=${beta_s_arr[${i_ens}]}
beta_t=${beta_t_arr[${i_ens}]}

beta_name=${beta_name_arr[${i_ens}]}
xi_0_name=${xi_0_name_arr[${i_ens}]}

stream=${stream_arr[${i_ens}]}

ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"
lat_name="l${ensemble}"
out_name="out${ensemble}"

sbatch_time=${sbatch_time_arr[${i_ens}]}
sbatch_nodes=${sbatch_nodes_arr[${i_ens}]} # N/A WHEN icer IS SELECTED
sbatch_ntasks=${sbatch_ntasks_arr[${i_ens}]}        
sbatch_jobname=${sbatch_jobname_arr[${i_ens}]}

n_of_sub=${n_of_sub_arr[${i_ens}]}
n_of_lat=${n_of_lat_arr[${i_ens}]}

my_dir="${cluster}_scripts_${ensemble}"

cd ..
mkdir ${my_dir}
cd master_scripts

# ==================================================================================
# ==================================================================================
cat <<EOF > ../${my_dir}/params.sh

#!/bin/bash

cluster=${cluster}


init_seed=1158
n_of_lat=${n_of_lat}
n_of_sub=${n_of_sub}

nx=${nx}
ny=${nx}
nz=${nx}
nt=${nt}

# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0
# beta_t=beta*xi_0

beta_s=${beta_s} #in the MILC colde this appears first
beta_t=${beta_t} #and this appears second

beta_name="${beta_name}"
xi_0_name="${xi_0_name}"

warms=0
trajecs=20
traj_between_meas=1
steps_per_trajectory=4
u0=1.0 # THIS IS FOR SYMANZIK
qhb_steps=1

stream="${stream}"

ensemble="${ensemble}"
lat_name="${lat_name}"
out_name="${out_name}"

EOF

if [ ${cluster} == "icer" ]
then

cat <<EOF >> ../${my_dir}/params.sh

directory="/mnt/scratch/trimisio/lattices/${lat_name}"
out_dir="/mnt/home/trimisio/outputs/${lat_name}"
path_build="/mnt/home/trimisio/comm_code/pure_gauge_ani_generation/build"
run_dir="/mnt/scratch/trimisio/runs/rungen${lat_name}"
submit_dir="/mnt/home/trimisio/submits/subgen${lat_name}"

executable="su3_ora_symzk0_a_dbl_intel_ICER_20230828"

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
path_build="/home/trimisio/all/comm_code/pure_gauge_ani_generation/build"
run_dir="/project/ahisq/yannis_puregauge/runs/rungen${lat_name}"
submit_dir="/project/ahisq/yannis_puregauge/submits/subgen${lat_name}"

executable="su3_ora_symzk0_a_dbl_intel_FNAL_20230829"

sbatch_time="${sbatch_time}"
sbatch_nodes="${sbatch_nodes}"
sbatch_ntasks="${sbatch_ntasks}"
sbatch_jobname="${sbatch_jobname}"
sbatch_module="intel"

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
