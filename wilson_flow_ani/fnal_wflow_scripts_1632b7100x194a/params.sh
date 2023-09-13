
#!/bin/bash

cluster=fnal

n_of_lat=400
n_of_sub=1

nx=16
ny=16
nz=16
nt=32

lat_name="l1632b7100x194a"
out_name="wflow1632b7100x194xf200a_dt0.015625"

xi_f=2.00

flow_action="wilson"
exp_order="16"
dt="0.015625"
stoptime="2.6"


directory="/lustre1/ahisq/yannis_puregauge/lattices/l1632b7100x194a"
out_dir="/project/ahisq/yannis_puregauge/outputs/l1632b7100x194a"
path_build="/home/trimisio/all/comm_code/wilson_flow_ani/build"
run_dir="/project/ahisq/yannis_puregauge/runs/runwflowl1632b7100x194a"
submit_dir="/project/ahisq/yannis_puregauge/submits/subwflowl1632b7100x194a"

executable="wilson_flow_bbb_a_dbl_gnu8openmpi3"

sbatch_time="04:00:00"
sbatch_nodes="4"
sbatch_ntasks="128"
sbatch_jobname="fl194"
sbatch_module1="gnu8"
sbatch_module2="openmpi3"

