#!/bin/bash

init_seed=7562
n_of_lat=4

nx=24
ny=24
nz=24
nt=48

# We want to reproduce arxiv 1205.0781 for: beta=6.1, xi_0=2.46, 24^3x48
# MILC convention (in the improved action) is: beta=10/g^2
# arxiv 1205.0781 convention is beta=6/g^2

# beta=6.1*5/3=10.167

# Now one has to calculate spatial and temporal beta. 
# beta_s=beta/xi_0=4.133
# beta_t=beta*xi_0=25.010

# beta=10.167
# xi_0=2.46

beta_s=4.133 #in the MILC colde this appears first
beta_t=25.010 #and this appears second

beta_name="10167"
xi_0_name="246"

warms=0
trajecs=4
traj_between_meas=1
u0=1.0
steps_per_trajectory=3
qhb_steps=2

stream="a"

ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

out_name="out${ensemble}"
lat_name="l${ensemble}"

#directory="/mnt/scratch/trimisio/lattices/lat${ensemble}" #this is for iCER
#directory="/home/trimis/local_code/lat${ensemble}" #this is for workstation
directory="/home/yannis/Physics/LQCD/code_local/lat${ensemble}" #this is for laptop
erase="yes"