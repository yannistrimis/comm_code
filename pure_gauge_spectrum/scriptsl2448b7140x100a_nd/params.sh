#!/bin/bash

n_of_lat=20

nx=24
ny=24
nz=24
nt=48

set_i_lat=101
set_seed=5204

beta_name="7140"
xi_0_name="100"
xq_0_name="100"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

path_build="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/build"
directory="/mnt/home/trimisio/outputs/pure_gauge_spec/${lat_name}"
lat_directory="/mnt/home/bazavov/scratch/puregauge/lattices/${lat_name}"
run_dir="/mnt/home/trimisio/scratch/runs/runspecnd${lat_name}"
submit_dir="/mnt/home/trimisio/submits/subspecnd${lat_name}"

u0=1

set_source_start=0
n_sources=2
source_inc=24
source_prec=13 # CHANGE ACCORDING TO nt

nmasses=2
mass1=0.01154
mass2=0.0577

mass1_name="01154"
mass2_name="0577"

err=1e-6
max_cg_iterations=300
action=hisq
precision=2

