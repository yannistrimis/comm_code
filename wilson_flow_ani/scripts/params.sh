#!/bin/bash

n_of_lat=4

nx=4
ny=4
nz=4
nt=8

beta_name="10167"
xi_0_name="246"
stream="a"
ensemble="${nx}${nt}b${beta_name}x${xi_0_name}${stream}"
lat_name="l${ensemble}"

xf=2.85
xf_name="285"
dt=0.025

stoptime=4.0
exp_order=12
flow_action="wilson"

f_ensemble="wflow${nx}${nt}b${beta_name}x${xi_0_name}xf${xf_name}${stream}_dt${dt}"

#directory="/mnt/scratch/trimisio/flows/${f_ensemble}" #this is for hpcc
directory="/home/trimis/local_code/${f_ensemble}" #this is for workstation
#directory="/home/yannis/Physics/LQCD/local_code/${f_ensemble}" #this is for laptop

#lat_directory="/mnt/scratch/trimisio/lattices/lat${ensemble}" #this is for hpcc
lat_directory="/home/trimis/local_code/lat${ensemble}" #this is for workstation
#lat_directory="/home/yannis/Physics/LQCD/local_code/lat${ensemble}" #this is for laptop

erase="yes"
