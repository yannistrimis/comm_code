#!/bin/bash

n_of_lat=5

nx=16
ny=16
nz=16
nt=32

set_i_lat=101
set_seed=52664

beta_name="6647"
xi_0_name="100"
stream="a"
lat_name="l${nx}${nt}b${beta_name}x${xi_0_name}${stream}"

u0=1

set_source_start=0
n_sources=2
source_inc=16
source_prec=7 # CHANGE ACCORDING TO nt

nmasses=5
mass1=0.02
mass2=0.04
mass3=0.06
mass4=0.08
mass5=0.10

px=0
py=0
pz=0

source="cw"


if [ "${source}" = "cw"  ]
then
    source_legal_name="corner_wall"
elif [ "${source}" = "rcw" ]
then
    source_legal_name="random_color_wall"
fi

err=1e-6
max_cg_iterations=300
action=hisq
precision=2

path_build="/mnt/home/trimisio/comm_code/pure_gauge_spectrum/build"
directory="/mnt/home/trimisio/outputs/pure_gauge_spec/${lat_name}"
lat_directory="/mnt/home/bazavov/scratch/puregauge/lattices/${lat_name}"
run_dir="/mnt/home/trimisio/scratch/runs/runspec${lat_name}_nd_px${px}py${py}pz${pz}_${source}"
submit_dir="/mnt/home/trimisio/submits/subspec${lat_name}_nd_px${px}py${py}pz${pz}_${source}"

