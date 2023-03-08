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

xf=4.50
xf_name="450"
dt=0.00390625 # aka 1/256

stoptime=2.4
exp_order=12
flow_action="symanzik"

f_ensemble="sflow${nx}${nt}b${beta_name}x${xi_0_name}xf${xf_name}${stream}_dt${dt}"

directory="/mnt/home/trimisio/outputs/${lat_name}"

lat_directory="/mnt/home/bazavov/scratch/puregauge/lattices/${lat_name}"

erase="no"
