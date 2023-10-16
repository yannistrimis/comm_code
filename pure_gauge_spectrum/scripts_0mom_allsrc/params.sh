#!/bin/bash

n_of_lat=50

nx=16
ny=16
nz=16
nt=32

set_i_lat=101
set_seed=5294

beta_name="6850"

xi_0_name="100"
xq_name_arr=("100")
xq_arr=(1.00)

stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

path_build="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/build"
directory="/mnt/home/trimisio/outputs/pure_gauge_spec/${lat_name}"
lat_directory="/mnt/home/trimisio/scratch/lattices/${lat_name}"
run_dir="/mnt/home/trimisio/scratch/runs/runspec0mom_allsrc${lat_name}"
submit_dir="/mnt/home/trimisio/submits/subspec0mom_allsrc${lat_name}"

u0=1

set_source_start=0
n_sources=2
source_inc=16
source_prec=7 # CHANGE ACCORDING TO nt


nmasses=1
mass1=0.0788

err=1e-6
max_cg_iterations=300
action=hisq
precision=2

