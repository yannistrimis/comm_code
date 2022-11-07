#!/bin/bash

n_of_lat=15

nx=16
ny=16
nz=16
nt=16

beta_name="7000"
xi_0_name="100"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

xf=1.00
xf_name="100"
dt=0.03125 # aka 1/32

stoptime=2.4
exp_order=12
flow_action="symanzik"

f_ensemble="sflow${nx}${nt}b${beta_name}x${xi_0_name}xf${xf_name}${stream}_dt${dt}"

directory="/mnt/home/trimisio/outputs/${lat_name}"

lat_directory="/mnt/home/bazavov/scratch/puregauge/lattices/${lat_name}"

erase="no"
