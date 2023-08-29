
#!/bin/bash

cluster=icer


init_seed=1158
n_of_lat=2
n_of_sub=2

nx=4
ny=4
nz=4
nt=64

# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0
# beta_t=beta*xi_0

beta_s=3.43 #in the MILC colde this appears first
beta_t=13.72 #and this appears second

beta_name="6860"
xi_0_name="200"

warms=0
trajecs=20
traj_between_meas=1
steps_per_trajectory=4
u0=1.0 # THIS IS FOR SYMANZIK
qhb_steps=1

stream="a"

ensemble="464b6860x200a"
lat_name="l464b6860x200a"
out_name="out464b6860x200a"


directory="/mnt/scratch/trimisio/lattices/l464b6860x200a"
out_dir="/mnt/home/trimisio/outputs/l464b6860x200a"
path_build="/mnt/home/trimisio/comm_code/pure_gauge_ani_generation/build"
run_dir="/mnt/scratch/trimisio/runs/rungenl464b6860x200a"
submit_dir="/mnt/home/trimisio/submits/subgenl464b6860x200a"

executable="su3_ora_symzk0_a_dbl_intel_ICER_20230828"

sbatch_time="00:31:00"
sbatch_ntasks="8"
sbatch_jobname="gentest2"
sbatch_module="intel/2020b"

