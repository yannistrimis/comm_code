
#!/bin/bash

cluster=fnal

n_of_lat=400
n_of_sub=1

set_i_lat=101
set_seed=78324

nx=16
ny=16
nz=16
nt=128

lat_name="l16128b7225x36836a"
out_name="specstr16128b7225x36836"

nmasses=2
mass_arr=( 0.097 0.117   )

nxq=1
xq_arr=( 3.75      )
xq_name_arr=( 3750      )

u0=1

set_source_start=0
n_sources=2
source_inc=64
source_prec=31

err=1e-6
max_cg_iterations=300
action=hisq
precision=2

build_script=build_input_str.sh


directory="/lustre1/ahisq/yannis_puregauge/lattices/l16128b7225x36836a"
out_dir="/project/ahisq/yannis_puregauge/outputs/pure_gauge_spec/l16128b7225x36836a"
path_build="/home/trimisio/all/comm_code/pure_gauge_spectrum/build"
run_dir="/project/ahisq/yannis_puregauge/runs/runspecstrl16128b7225x36836a"
submit_dir="/project/ahisq/yannis_puregauge/submits/subspecstrl16128b7225x36836a"

executable="ks_spectrum_ani_hisq_dbl_gcc12openmpi4_20231030"

sbatch_time="05:00:00"
sbatch_nodes="4"
sbatch_ntasks="128"
sbatch_jobname="str_xi4"
sbatch_module1="gcc/12"
sbatch_module2="openmpi/4"

