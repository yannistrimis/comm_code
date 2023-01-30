#!/bin/bash

n_of_lat=1

nx=8
ny=8
nz=8
nt=8

set_i_lat=101
set_seed=5682304

beta_name="7167"
xi_0_name="100"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

path="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/scripts"
path_build="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/build"
directory="/mnt/home/trimisio/outputs/pure_gauge_spec/${lat_name}"
lat_directory="/mnt/scratch/trimisio/lattices/${lat_name}"
run_dir="/mnt/home/trimisio/runs/run_spec${lat_name}"

u0=1
set_source_start=0
source_inc=0
n_sources=1
nmasses=2
mass1=0.03
mass2=0.05
err=1e-6
max_cg_iterations=300
action=hisq
precision=2

