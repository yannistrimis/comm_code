
#!/bin/bash

cluster=icer

n_of_lat=100
n_of_sub=4

nx=20
ny=20
nz=20
nt=40

lat_name="l2040b7200x1880a"
out_name="wflow2040b7200x1880xf200a_dt0.015625"

xi_f=2.00

flow_action="wilson"
exp_order="16"
dt="0.015625"
stoptime="3.0"


directory="/mnt/scratch/trimisio/lattices/l2040b7200x1880a"
out_dir="/mnt/home/trimisio/outputs/l2040b7200x1880a"
path_build="/mnt/home/trimisio/comm_code/wilson_flow_ani/build"
run_dir="/mnt/scratch/trimisio/runs/runwflowl2040b7200x1880a"
submit_dir="/mnt/home/trimisio/submits/subwflowl2040b7200x1880a"

executable="wilson_flow_bbb_a_dbl_intel_20231006"

sbatch_time="08:00:00"
sbatch_ntasks="125"
sbatch_jobname="wfl188"
sbatch_module="intel/2020b"

