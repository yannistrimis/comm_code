#!/bin/bash

n_of_lat=2

nx=20
ny=20
nz=20
nt=80

beta_name="7433"
xi_0_name="35221"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

xf_array=(3.60 3.70 3.80 3.90)
xf_name_array=("360" "370" "380" "390")
dt_array=(0.015625 0.03125)

stoptime=3.5
exp_order=16
flow_action="symanzik"

directory="/mnt/home/trimisio/outputs/${lat_name}"

lat_directory="/mnt/scratch/trimisio/lattices/${lat_name}"

erase="no"
