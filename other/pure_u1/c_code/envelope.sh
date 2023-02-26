#!/bin/bash

my_dir="/home/yannis/Physics/LQCD/pure_u1/data" # LAPTOP
beta_arr=(0.125 0.25 0.5 1.0 2.0  4.0)
beta_str_arr=("125" "250" "500" "1000" "2000" "4000")

seed=7832
nx=8
nt=8
n_of_lat=50
trajectories=4
d_hot=1.0
d_update=0.1

for i in ${!beta_arr[@]}; do

beta=${beta_arr[$i]}
beta_str=${beta_str_arr[$i]}
seed=$((${seed}+1))
out_name="${my_dir}/l${nx}${nt}b${beta_str}_plaq"

cat <<EOF > input.dat
seed = ${seed}
nx = ${nx}
nt = ${nt}
beta = ${beta}
n_of_lat = ${n_of_lat}
trajectories = ${trajectories}
d_hot = ${d_hot}
d_update = ${d_update}
EOF

cat input.dat | ./pure_u1 > ${out_name} 
echo "${beta_str} done"

done
