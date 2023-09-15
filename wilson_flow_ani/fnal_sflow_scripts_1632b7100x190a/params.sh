
#!/bin/bash

cluster=fnal

n_of_lat=400
n_of_sub=1

nx=16
ny=16
nz=16
nt=32

lat_name="l1632b7100x190a"
out_name="sflow1632b7100x190xf200a_dt0.015625"

xi_f=2.00

flow_action="symanzik"
exp_order="16"
dt="0.015625"
stoptime="2.6"


directory="/lustre1/ahisq/yannis_puregauge/lattices/l1632b7100x190a"
out_dir="/project/ahisq/yannis_puregauge/outputs/l1632b7100x190a"
path_build="/home/trimisio/all/comm_code/wilson_flow_ani/build"
run_dir="/project/ahisq/yannis_puregauge/runs/runsflowl1632b7100x190a"
submit_dir="/project/ahisq/yannis_puregauge/submits/subsflowl1632b7100x190a"

executable="wilson_flow_bbb_a_dbl_gnu8openmpi3"

sbatch_time="09:00:00"
sbatch_nodes="4"
sbatch_ntasks="128"
sbatch_jobname="sfl190"
sbatch_module1="gnu8"
sbatch_module2="openmpi3"
