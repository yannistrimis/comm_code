#!/bin/bash

init_seed=1355
n_of_lat=50

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

beta_s=3.9368 #in the MILC colde this appears first
beta_t=13.0475 #and this appears second

beta_name="7167"
xi_0_name="18205"

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
erase="no"
