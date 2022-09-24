#!/bin/bash

init_seed=7692
n_of_lat=2

nx=4
ny=4
nz=4
nt=8

# We want to reproduce arxiv 1205.0781 for: beta=6.1, xi_0=2.46, 24^3x48
# MILC convention (in the improved action) is: beta=10/g^2
# arxiv 1205.0781 convention is beta=6/g^2

# beta=6.1*5/3=10.167

# Now one has to calculate spatial and temporal beta. 
# beta_s=beta/xi_0=4.133
# beta_t=beta*xi_0=25.010

beta=10.167
xi_0=2.46

beta_s=4.133 #in the MILC colde this appears first
beta_t=25.010 #and this appears second

beta_name="10167"
xi_0_name="246"

warms=0
trajecs=1
traj_between_meas=1
u0=1.0
steps_per_trajectory=1
qhb_steps=1

stream="a"

ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

out_name="out${ensemble}"
lat_name="l${ensemble}"

#directory="/mnt/scratch/trimisio/lattices/try_lattices20220920" #this is for iCER
#directory="/home/trimis/Code/lat${ensemble}" #this is for workstation
directory="/home/yannis/Physics/LQCD/code_local/lat${ensemble}" #this is for laptop
erase="yes"