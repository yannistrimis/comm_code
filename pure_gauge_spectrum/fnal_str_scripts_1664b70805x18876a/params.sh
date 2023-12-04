
#!/bin/bash

cluster=fnal

n_of_lat=400
n_of_sub=1

set_i_lat=101
set_seed=78324

nx=16
ny=16
nz=16
nt=64

lat_name="l1664b70805x18876a"
out_name="specstr1664b70805x18876"

nmasses=2
mass_arr=( 0.10 0.12   )

nxq=1
xq_arr=( 1.95      )
xq_name_arr=( 1950      )

u0=1

set_source_start=0
n_sources=2
source_inc=32
source_prec=17

err=1e-6
max_cg_iterations=300
action=hisq
precision=2

build_script=build_input_str.sh


directory="/lustre1/ahisq/yannis_puregauge/lattices/l1664b70805x18876a"
out_dir="/project/ahisq/yannis_puregauge/outputs/pure_gauge_spec/l1664b70805x18876a"
path_build="/home/trimisio/all/comm_code/pure_gauge_spectrum/build"
run_dir="/project/ahisq/yannis_puregauge/runs/runspecstrl1664b70805x18876a"
submit_dir="/project/ahisq/yannis_puregauge/submits/subspecstrl1664b70805x18876a"

executable="ks_spectrum_ani_hisq_dbl_gcc12openmpi4_20231030"

sbatch_time="04:00:00"
sbatch_nodes="4"
sbatch_ntasks="128"
sbatch_jobname="str_xi2"
sbatch_module1="gcc/12"
sbatch_module2="openmpi/4"

