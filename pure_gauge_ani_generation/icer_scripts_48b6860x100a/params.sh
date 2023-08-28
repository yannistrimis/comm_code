
#!/bin/bash

cluster=icer


init_seed=1158
n_of_lat=2
n_of_sub=2

nx=4
ny=4
nz=4
nt=8

# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0
# beta_t=beta*xi_0

beta_s=6.860 #in the MILC colde this appears first
beta_t=6.860 #and this appears second

beta_name="6860"
xi_0_name="100"

warms=0
trajecs=20
traj_between_meas=1
steps_per_trajectory=4
u0=1.0 # THIS IS FOR SYMANZIK
qhb_steps=1

stream="a"

ensemble="48b6860x100a"
lat_name="l48b6860x100a"
out_name="out48b6860x100a"


directory="/mnt/scratch/trimisio/lattices/l48b6860x100a"
out_dir="/mnt/home/trimisio/outputs/l48b6860x100a"
path_build="/mnt/home/trimisio/comm_code/pure_gauge_ani_generation/build"
run_dir="/mnt/scratch/trimisio/runs/rungenl48b6860x100a"
submit_dir="/mnt/home/trimisio/submits/subgenl48b6860x100a"

executable="su3_ora_symzk0_a_dbl_intel_ICER_20230828"

sbatch_time="00:30:00"
sbatch_ntasks="4"
sbatch_jobname="gentest"
sbatch_module="intel/2020b"

