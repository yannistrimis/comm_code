#!/bin/bash


# THIS SCRIPT CREATES DIRECTORIES FOR PURE GAUGE GRADIENT FLOW.
# ALL THE PARAMETERS THAT DEFINE AN ENSEMBLE ARE PLACED IN ARRAYS OF AS MANY ELEMENTS
# AS THE NUMBER OF ENSEMBLES TO BE FLOWED. IF A PARAMETER IS E.G. SAME IN TWO ENSEMBLES
# THEN THE VALUE HAS TO BE REPEATED, I.E. THERE IS NO LOOP OVER INDIVIDUAL PARAMETERS, BUT
# ONLY OVER THE ENSEMBLES (i_ens).


cluster="fnal"
n_of_ens=9

# THE FOLLOWING ARRAYS SHOULD ALL HAVE
# THE SAME LENGTH, EQUAL TO n_of_ens

nx_arr=(16 16 16 16 16 16 16 16 16)
nt_arr=(32 32 32 32 32 32 32 32 32)

beta_name_arr=("6900" "6900" "6900" "6900" "6900" "6900" "6900" "6900" "6900")
xi_0_name_arr=("178" "180" "182" "184" "186" "188" "190" "192" "194")

xi_f_arr=(2.00 2.00 2.00 2.00 2.00 2.00 2.00 2.00 2.00)
xi_f_name_arr=("200" "200" "200" "200" "200" "200" "200" "200" "200")

dt_arr=("0.015625" "0.015625" "0.015625" "0.015625" "0.015625" "0.015625" "0.015625" "0.015625" "0.015625" )
flow_action_arr=("symanzik" "symanzik" "symanzik" "symanzik" "symanzik" "symanzik" "symanzik" "symanzik" "symanzik")

stream_arr=("a" "a" "a" "a" "a" "a" "a" "a" "a")

sbatch_time_arr=("09:00:00" "09:00:00" "09:00:00" "09:00:00" "09:00:00" "09:00:00" "09:00:00" "09:00:00" "09:00:00")
sbatch_nodes_arr=(4 4 4 4 4 4 4 4 4 ) # N/A WHEN icer IS SELECTED
sbatch_ntasks_arr=(128 128 128 128 128 128 128 128 128)
sbatch_jobname_arr=("sfl178" "sfl180" "sfl182" "sfl184" "sfl186" "sfl188" "sfl190" "sfl192" "sfl194")

n_of_sub_arr=(1 1 1 1 1 1 1 1 1)
n_of_lat_arr=(500 500 500 500 500 500 500 500 500)


for (( i_ens=0; i_ens<${n_of_ens}; i_ens++ )); do

nx=${nx_arr[${i_ens}]}
nt=${nt_arr[${i_ens}]}

beta_name=${beta_name_arr[${i_ens}]}
xi_0_name=${xi_0_name_arr[${i_ens}]}

xi_f=${xi_f_arr[${i_ens}]}
xi_f_name=${xi_f_name_arr[${i_ens}]}

dt=${dt_arr[${i_ens}]}
flow_action=${flow_action_arr[${i_ens}]}

stream=${stream_arr[${i_ens}]}

ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"
lat_name="l${ensemble}"

ensemble_nostream="${nx}${nt}b${beta_name}x${xi_0_name}"

if []
out_name="sflow${ensemble}xf${}${stream}_dt${}"
elif []
out_name="wflow${ensemble}xf${}${stream}_dt${}"
fi

sbatch_time=${sbatch_time_arr[${i_ens}]}
sbatch_nodes=${sbatch_nodes_arr[${i_ens}]} # N/A WHEN icer IS SELECTED
sbatch_ntasks=${sbatch_ntasks_arr[${i_ens}]}        
sbatch_jobname=${sbatch_jobname_arr[${i_ens}]}

n_of_sub=${n_of_sub_arr[${i_ens}]}
n_of_lat=${n_of_lat_arr[${i_ens}]}

my_dir="${cluster}_${flow_action}_scripts_${ensemble}"

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
path_build="/mnt/home/trimisio/comm_code/wilson_flow_ani/build"
run_dir="/mnt/scratch/trimisio/runs/runflow${lat_name}"
submit_dir="/mnt/home/trimisio/submits/subflow${lat_name}"

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
path_build="/home/trimisio/all/comm_code/wilson_flow_ani/build"
run_dir="/project/ahisq/yannis_puregauge/runs/runflow${lat_name}"
submit_dir="/project/ahisq/yannis_puregauge/submits/subflow${lat_name}"

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
