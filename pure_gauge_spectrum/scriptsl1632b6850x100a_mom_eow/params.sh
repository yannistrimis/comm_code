#!/bin/bash

n_of_lat=1

nx=16
ny=16
nz=16
nt=32

set_i_lat=101
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
n_sources=2
source_inc=16
source_prec=8 # CHANGE ACCORDING TO nt


nmasses=1
mass1=0.01576
mass1_name="01576"

n_of_mom=9
moml1="100"
moml2="010"
moml3="001"
moml4="110"
moml5="101"
moml6="011"
moml7="200"
moml8="020"
moml9="002"

err=1e-6
max_cg_iterations=300
action=hisq
precision=2
