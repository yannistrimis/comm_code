
#!/bin/bash

cluster=icer

n_of_lat=50
n_of_sub=2

nx=20
ny=20
nz=20
nt=40

lat_name="l2040b7200x1900a"
out_name="sflow2040b7200x1900xf200a_dt0.015625"

xi_f=2.00

flow_action="symanzik"
exp_order="16"
dt="0.015625"
stoptime="3.0"


directory="/mnt/scratch/trimisio/lattices/l2040b7200x1900a"
out_dir="/mnt/home/trimisio/outputs/l2040b7200x1900a"
path_build="/mnt/home/trimisio/comm_code/wilson_flow_ani/build"
run_dir="/mnt/scratch/trimisio/runs/runsflowl2040b7200x1900a"
submit_dir="/mnt/home/trimisio/submits/subsflowl2040b7200x1900a"

executable="wilson_flow_bbb_a_dbl_intel_20231006"

sbatch_time="08:00:00"
sbatch_ntasks="125"
sbatch_jobname="sfl190"
sbatch_module="intel/2020b"

