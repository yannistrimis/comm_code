
#!/bin/bash

cluster=fnal


init_seed=1158
n_of_lat=1
n_of_sub=2

nx=4
ny=4
nz=4
nt=4

# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0
# beta_t=beta*xi_0

beta_s=6.86 #in the MILC colde this appears first
beta_t=6.86 #and this appears second

beta_name="6860"
xi_0_name="100"

warms=0
trajecs=20
traj_between_meas=1
steps_per_trajectory=4
u0=1.0 # THIS IS FOR SYMANZIK
qhb_steps=1

stream="a"

ensemble="44b6860x100a"
lat_name="l44b6860x100a"
out_name="out44b6860x100a"


directory="/lustre1/ahisq/yannis_puregauge/lattices/l44b6860x100a"
out_dir="/project/ahisq/yannis_puregauge/outputs/l44b6860x100a"
path_build="/home/trimisio/all/comm_code/pure_gauge_ani_generation/build"
run_dir="/project/ahisq/yannis_puregauge/runs/rungenl44b6860x100a"
submit_dir="/project/ahisq/yannis_puregauge/submits/subgenl44b6860x100a"

executable="su3_ora_symzk0_a_dbl_gnu8openmpi3_fnal_20230906"

sbatch_time="00:30:00"
sbatch_nodes="1"
sbatch_ntasks="1"
sbatch_jobname="gentest1"
sbatch_module1="gnu8"
sbatch_module2="openmpi3"

