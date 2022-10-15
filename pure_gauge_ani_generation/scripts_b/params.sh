#!/bin/bash

init_seed=1475
n_of_lat=720

nx=24
ny=24
nz=24
nt=48

# We want to reproduce arxiv 1205.0781 for: beta=6.1, xi_0=2.46, 24^3x48
# MILC convention in the improved action is: beta=10/g^2
# Here we use plaquette action and so that is not relevant.
# arxiv 1205.0781 convention is beta=6/g^2

# Now one has to calculate spatial and temporal beta. 

# beta_s=beta/xi_0=2.480
# beta_t=beta*xi_0=15.006

beta_s=2.480 #in the MILC colde this appears first
beta_t=15.006 #and this appears second

beta_name="61"
xi_0_name="246"

warms=0
trajecs=4
traj_between_meas=1
steps_per_trajectory=4
# u0=1.0 THIS IS FOR SYMANZIK
qhb_steps=1

stream="b"

ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

out_name="out${ensemble}"
lat_name="l${ensemble}"

directory="/mnt/scratch/trimisio/lattices/wlat${ensemble}" #this is for hpcc

erase="no"
