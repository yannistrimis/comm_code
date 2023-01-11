#!/bin/bash

n_of_lat=2

nx=24
ny=24
nz=24
nt=48

beta_name="7433"
xi_0_name="18293"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

xf_array=(1.80 1.86 1.90 1.94 2.00)
xf_name_array=("180" "186" "190" "194" "200")
dt_array=(0.015625 0.03125)

stoptime=4.0
exp_order=16
flow_action="symanzik"

directory="/mnt/home/trimisio/outputs/${lat_name}"

lat_directory="/mnt/scratch/trimisio/lattices/${lat_name}"

erase="no"
