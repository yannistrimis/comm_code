#!/bin/bash

n_of_lat=1

nx=16
ny=16
nz=16
nt=80

beta_name="7000"
xi_0_name="42000"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

xf_array=[4.50]
xf_name_array=["450"]
dt_array=(0.015625 0.03125)

stoptime=2.4
exp_order=16
flow_action="symanzik"

f_ensemble="sflow${nx}${nt}b${beta_name}x${xi_0_name}xf${xf_name}${stream}_dt${dt}"

directory="/mnt/home/trimisio/outputs/${lat_name}"

lat_directory="/mnt/home/bazavov/scratch/puregauge/lattices/${lat_name}"

erase="no"
