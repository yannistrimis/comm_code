#!/bin/bash

init_seed=1258
n_of_lat=2

nx=24
ny=24
nz=24
nt=24

# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0
# beta_t=beta*xi_0

beta_s=7.433 #in the MILC colde this appears first
beta_t=7.433 #and this appears second

beta_name="7433"
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
directory="/mnt/scratch/trimisio/lattices/${lat_name}" #this is for hpcc
out_dir="/mnt/home/trimisio/outputs/${lat_name}"
erase="yes"
