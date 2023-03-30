#!/bin/bash

n_of_lat=30

nx=16
ny=16
nz=16
nt=16

set_i_lat=101
set_seed=521204

beta_name="7000"
xi_0_name="100"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

path_build="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/build"
directory="/mnt/home/trimisio/outputs/pure_gauge_spec/${lat_name}"
lat_directory="/mnt/home/bazavov/scratch/puregauge/lattices/${lat_name}"
run_dir="/mnt/home/trimisio/runs/runspec${lat_name}"

u0=1

set_source_start=0
n_sources=2
source_inc=8
source_prec=3 # CHANGE ACCORDING TO nt !!!

nmasses=5
mass1=0.02
mass2=0.04
mass3=0.06
mass4=0.08
mass5=1.00

err=1e-6
max_cg_iterations=300
action=hisq
precision=2
