
#!/bin/bash

cluster=fnal

init_seed=1158
n_of_lat=50
n_of_sub=10

nx=16
ny=16
nz=16
nt=128

# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0
# beta_t=beta*xi_0

beta_s=1.96140 #in the MILC colde this appears first
beta_t=26.61401 #and this appears second

beta_name="7225"
xi_0_name="36836"

warms=0
trajecs=20
traj_between_meas=1
steps_per_trajectory=4
u0=1.0 # THIS IS !=1 FOR 1-LOOP SYMANZIK
qhb_steps=1

stream="a"

ensemble="16128b7225x36836a"
lat_name="l16128b7225x36836a"
out_name="out16128b7225x36836a"


directory="/lustre1/ahisq/yannis_puregauge/lattices/l16128b7225x36836a"
out_dir="/project/ahisq/yannis_puregauge/outputs/l16128b7225x36836a"
path_build="/home/trimisio/all/comm_code/pure_gauge_ani_generation/build"
run_dir="/project/ahisq/yannis_puregauge/runs/rungenl16128b7225x36836a"
submit_dir="/project/ahisq/yannis_puregauge/submits/subgenl16128b7225x36836a"

executable="su3_ora_symzk0_a_dbl_gcc12openmpi4_20231030"

sbatch_time="20:00:00"
sbatch_nodes="4"
sbatch_ntasks="128"
sbatch_jobname="gen4"
sbatch_module1="gcc/12"
sbatch_module2="openmpi/4"

