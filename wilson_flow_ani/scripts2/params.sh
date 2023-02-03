#!/bin/bash

n_of_lat=2

nx=24
ny=24
nz=24
nt=24

beta_name="7433"
xi_0_name="100"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

xf_array=(0.96 0.98 1.00 1.02 1.04)
xf_name_array=("096" "098" "100" "102" "104")
dt_array=(0.015625)

stoptime=4.0
exp_order=16
flow_action="wilson"

directory="/mnt/home/trimisio/outputs/${lat_name}"

lat_directory="/mnt/scratch/trimisio/lattices/${lat_name}"

erase="no"
