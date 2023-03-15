#!/bin/bash

n_of_lat=20

nx=16
ny=16
nz=16
nt=32

beta_name="6850"
xi_0_name="100"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

xf_array=(0.96 0.98 1.00 1.02 1.04)
xf_name_array=("096" "098" "100" "102" "104")

dt_array=(0.015625)

stoptime=4.0
exp_order=16
flow_action="symanzik"

directory="/mnt/home/trimisio/outputs/${lat_name}"
lat_directory="/mnt/scratch/trimisio/lattices/${lat_name}"

path_build="/mnt/home/trimisio/comm_code/wilson_flow_ani/build"
submit_dir="/mnt/home/trimisio/submits/subsflow${lat_name}"
run_dir="/mnt/scratch/trimisio/runs/runsflow${lat_name}"

erase="no"
