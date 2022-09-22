#!/bin/bash

#directory="/mnt/scratch/trimisio/lattices/try_lattices20220920" #this is for iCER
directory="/home/trimis/Code/costas" #this is for workstation
erase="yes"

init_seed=7692
n_of_lat=10

nx=4
ny=4
nz=4
nt=4

warms=0
trajecs=3
traj_between_meas=1
beta_s=5.0 #in the MILC colde this appears first
beta_t=7.0 #and this appears second
u0=0.870
steps_per_trajectory=2
qhb_steps=1