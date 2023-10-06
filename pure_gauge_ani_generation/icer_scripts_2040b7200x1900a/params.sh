
#!/bin/bash

cluster=icer

init_seed=1158
n_of_lat=20
n_of_sub=1

nx=20
ny=20
nz=20
nt=40

# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0
# beta_t=beta*xi_0

beta_s=3.78947 #in the MILC colde this appears first
beta_t=13.68000 #and this appears second

beta_name="7200"
xi_0_name="1900"

warms=0
trajecs=20
traj_between_meas=1
steps_per_trajectory=4
u0=1.0 # THIS IS !=1 FOR 1-LOOP SYMANZIK
qhb_steps=1

stream="a"

ensemble="2040b7200x1900a"
lat_name="l2040b7200x1900a"
out_name="out2040b7200x1900a"


directory="/mnt/scratch/trimisio/lattices/l2040b7200x1900a"
out_dir="/mnt/home/trimisio/outputs/l2040b7200x1900a"
path_build="/mnt/home/trimisio/comm_code/pure_gauge_ani_generation/build"
run_dir="/mnt/scratch/trimisio/runs/rungenl2040b7200x1900a"
submit_dir="/mnt/home/trimisio/submits/subgenl2040b7200x1900a"

executable="su3_ora_symzk0_a_dbl_intel_ICER_20230828"

sbatch_time="02:00:00"
sbatch_ntasks="250"
sbatch_jobname="gen190"
sbatch_module="intel/2020b"

