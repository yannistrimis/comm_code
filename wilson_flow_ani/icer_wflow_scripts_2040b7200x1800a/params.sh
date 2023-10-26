
#!/bin/bash

cluster=icer

n_of_lat=3
n_of_sub=1

nx=20
ny=20
nz=20
nt=40

lat_name="l2040b7200x1800a"
out_name="wflow2040b7200x1800xf200a_dt0.015625"

xi_f=2.00

flow_action="wilson"
exp_order="16"
dt="0.015625"
stoptime="3.0"


directory="/mnt/scratch/trimisio/lattices/l2040b7200x1800a"
out_dir="/mnt/home/trimisio/outputs/l2040b7200x1800a"
path_build="/mnt/home/trimisio/comm_code/wilson_flow_ani/build"
run_dir="/mnt/scratch/trimisio/runs/runwflowl2040b7200x1800a"
submit_dir="/mnt/home/trimisio/submits/subwflowl2040b7200x1800a"

executable="wilson_flow_bbb_a_dbl_intel_20231006"

sbatch_time="02:00:00"
sbatch_ntasks="125"
sbatch_jobname="wfl180"
sbatch_module="intel/2020b"

