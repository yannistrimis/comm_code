#!/bin/bash

n_of_lat=1

nx=16
ny=16
nz=16
nt=32

set_i_lat=103
set_seed=5294

beta_name="6850"

xi_0_name="100"
xq_0_name="100"

stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

path_build="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/build"
directory="/mnt/home/trimisio/outputs/pure_gauge_spec/${lat_name}"
lat_directory="/mnt/home/trimisio/scratch/lattices/${lat_name}"
run_dir="/mnt/home/trimisio/scratch/runs/runspecmom${lat_name}"
submit_dir="/mnt/home/trimisio/submits/subspecmom${lat_name}"

u0=1

set_source_start=0
n_sources=1
source_inc=0
source_prec=7 # CHANGE ACCORDING TO nt


nmasses=1
mass1=0.08
mass1_name="08000"

n_of_mom=0

err=1e-6
max_cg_iterations=300
action=hisq
precision=2

