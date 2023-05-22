#!/bin/bash

n_of_lat=5

nx=16
ny=16
nz=16
nt=32

set_i_lat=101
set_seed=5204

beta_name="6850"
xi_0_name="100"
xq_0_name="100"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

path_build="/mnt/home/trimisio/comm_code/pure_gauge_ani_spectrum/build" # TEMPORARY FIX
directory="/mnt/home/trimisio/outputs/pure_gauge_spec/${lat_name}"
lat_directory="/mnt/home/trimisio/scratch/lattices/${lat_name}"
run_dir="/mnt/home/trimisio/scratch/runs/runspecnd_ani2${lat_name}"
submit_dir="/mnt/home/trimisio/submits/subspecnd_ani2${lat_name}"

u0=1

set_source_start=0
n_sources=2
source_inc=16
source_prec=7 # CHANGE ACCORDING TO nt

nmasses=1
mass1=0.01576
#mass2=0.0788

mass1_name="01576"
#mass2_name="0788"


err=1e-6
max_cg_iterations=300
action=hisq
precision=2

ani_dir="t"
ani_xiq=1.00
