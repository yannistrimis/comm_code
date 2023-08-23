#!/bin/bash

cluster="icer"
#cluster="fnal"

init_seed=1158
n_of_lat=2

nx=4
ny=4
nz=4
nt=16

# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0
# beta_t=beta*xi_0

beta_s=6.850 #in the MILC colde this appears first
beta_t=6.850 #and this appears second

beta_name="6850"
xi_0_name="100"

warms=0
trajecs=20
traj_between_meas=1
steps_per_trajectory=4
u0=1.0 # THIS IS FOR SYMANZIK
qhb_steps=1

stream="a"

ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"
lat_name="l${ensemble}"
out_name="out${ensemble}"

if [ ${cluster} == "icer" ]
then

directory="/mnt/scratch/trimisio/lattices/${lat_name}"
out_dir="/mnt/home/trimisio/outputs/${lat_name}"
path_build="/mnt/home/trimisio/comm_code/pure_gauge_ani_generation/build"
run_dir="/mnt/scratch/trimisio/runs/rungen${lat_name}"
submit_dir="/mnt/home/trimisio/submits/subgen${lat_name}"

exec="su3_ora_symzk0_a_dbl_icc_20230822_icer"

sbatch_time="00:30:00"
sbatch_ntasks=4
sbatch_jobname="test"
sbatch_module="intel/2020b"

elif [ ${cluster} == "fnal" ]
then

directory="/home/trimisio/lattices/${lat_name}"
out_dir="/home/trimisio/outputs/${lat_name}"
path_build="/home/trimisio/all/comm_code/fnal_code/pure_gauge_ani_generation/build"
run_dir="/home/trimisio/runs/rungen${lat_name}"
submit_dir="/home/trimisio/submits/subgen${lat_name}"

exec=""

sbatch_time="00:30:00"
sbatch_nodes=1
sbatch_ntasks=4
sbatch_jobname="test"
sbatch_module="intel"

fi