#!/bin/bash

# THIS SCRIPT CREATES DIRECTORIES FOR PURE GAUGE ENSEMBLE GENERATION.
# IF MULTIPLE DIRECTORIES ARE NEEDED, THE USER CAN CREATE ARRAYS
# FOR THE CHANGING PARAMETERS.

cluster="fnal"
n_of_ens=2

nx_arr=(16 16)
nt_arr=(64 128)

beta_arr=(7.0805 7.225)
beta_name_arr=("70805" "7225")

xi_0_arr=(1.8876 3.6836)
xi_0_name_arr=("18876" "36836")

stream="a"

sbatch_time="02:00:00"
sbatch_nodes=4 # N/A WHEN icer IS SELECTED
sbatch_ntasks=256
sbatch_jobname_arr=("gen2" "gen4")

n_of_sub=1
n_of_lat=5


for (( i_ens=0; i_ens<${n_of_ens}; i_ens++ )); do

# SUBSTITUTE ARRAY ELEMENTS HERE, IF ANY
nx=${nx_arr[${i_ens}]}
nt=${nt_arr[${i_ens}]}

beta=${beta_arr[${i_ens}]}
beta_name=${beta_name_arr[${i_ens}]}

xi_0=${xi_0_arr[${i_ens}]}
xi_0_name=${xi_0_name_arr[${i_ens}]}

sbatch_jobname=${sbatch_jobname_arr[${i_ens}]}


beta_s=$(python3 -c "b_s=${beta}/${xi_0};print('%.5lf'%b_s)")
beta_t=$(python3 -c "b_t=${beta}*${xi_0};print('%.5lf'%b_t)")

ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"
lat_name="l${ensemble}"
out_name="out${ensemble}"

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
u0=1.0 # THIS IS !=1 FOR 1-LOOP SYMANZIK
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

executable="su3_ora_symzk0_a_dbl_gnu8openmpi3_fnal_20230906"

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
