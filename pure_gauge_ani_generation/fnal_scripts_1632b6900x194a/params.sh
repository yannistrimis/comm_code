
#!/bin/bash

cluster=fnal


init_seed=1158
n_of_lat=200
n_of_sub=1

nx=16
ny=16
nz=16
nt=32

# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0
# beta_t=beta*xi_0

beta_s=3.55670103 #in the MILC colde this appears first
beta_t=13.38600000 #and this appears second

beta_name="6900"
xi_0_name="194"

warms=0
trajecs=20
traj_between_meas=1
steps_per_trajectory=4
u0=1.0 # THIS IS FOR SYMANZIK
qhb_steps=1

stream="a"

ensemble="1632b6900x194a"
lat_name="l1632b6900x194a"
out_name="out1632b6900x194a"


directory="/lustre1/ahisq/yannis_puregauge/lattices/l1632b6900x194a"
out_dir="/project/ahisq/yannis_puregauge/outputs/l1632b6900x194a"
path_build="/home/trimisio/all/comm_code/pure_gauge_ani_generation/build"
run_dir="/project/ahisq/yannis_puregauge/runs/rungenl1632b6900x194a"
submit_dir="/project/ahisq/yannis_puregauge/submits/subgenl1632b6900x194a"

executable="su3_ora_symzk0_a_dbl_gnu8openmpi3_fnal_20230906"

sbatch_time="03:00:00"
sbatch_nodes="4"
sbatch_ntasks="128"
sbatch_jobname="gen194"
sbatch_module1="gnu8"
sbatch_module2="openmpi3"

