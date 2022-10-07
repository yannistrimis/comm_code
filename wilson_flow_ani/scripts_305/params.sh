#!/bin/bash

n_of_lat=30

nx=24
ny=24
nz=24
nt=48

beta_name="10167"
xi_0_name="246"
stream="c"
ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"
lat_name="l${ensemble}"

xf=3.05
xf_name="305"
dt=0.025

stoptime=4.0
exp_order=12
flow_action="wilson"

f_ensemble="wflow${nx}${nt}b${beta_name}x${xi_0_name}xf${xf_name}${stream}_dt${dt}"

directory="/mnt/scratch/trimisio/flows/${f_ensemble}" #this is for hpcc
#directory="/home/trimis/local_code/${f_ensemble}" #this is for workstation
#directory="/home/yannis/Physics/LQCD/local_code/${f_ensemble}" #this is for laptop

lat_directory="/mnt/scratch/trimisio/lattices/lat${ensemble}" #this is for hpcc
#lat_directory="/home/trimis/local_code/lat${ensemble}" #this is for workstation
#lat_directory="/home/yannis/Physics/LQCD/local_code/lat${ensemble}" #this is for laptop

erase="yes"
