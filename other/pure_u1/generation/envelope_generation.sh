#!/bin/bash

n_of_ens=5

nx=16
nt=16

beta_arr=( 0.25 0.50 0.75 1.00 1.25 )
beta_name_arr=( "0250" "0500" "0750" "1000" "1250" )
stream="a"

initial_seed=7832
initial_ilat=1

n_of_lat=210
trajectories=20
d_hot=1.0
d_update=2.0

for (( i_ens=0; i_ens<${n_of_ens}; i_ens++ )); do
beta=${beta_arr[${i_ens}]}
beta_name=${beta_name_arr[${i_ens}]}

ens_name="l${nx}${nt}b${beta_name}${stream}"

lat_dir="/home/trimis/data/pure_u1/lattices/${ens_name}" # CMSE
out_dir="/home/trimis/data/pure_u1/outputs/${ens_name}"  # CMSE

# lat_dir="/home/yannis/Physics/LQCD/pure_u1/lattices/${ens_name}" # LAPTOP
# out_dir="/home/yannis/Physics/LQCD/pure_u1/outputs/${ens_name}"  # LAPTOP

if [ ! -d "${lat_dir}" ]
then
mkdir "${lat_dir}"
fi

if [ ! -d "${out_dir}" ]
then
mkdir "${out_dir}"
fi

seed=${initial_seed}
ilat=${initial_ilat}
counter=1
while [ ${counter} -le $n_of_lat ]
do

lat_name="${lat_dir}/${ens_name}.${ilat}"
out_name="${out_dir}/out_${ens_name}.${ilat}"

if [ -f ${lat_name} ] # PRECAUTION ABOUT BINARY
then
rm ${lat_name}
fi

if [ -f {out_name} ] # PRECAUTION ABOUT OUTPUT
then
rm ${out_name}
fi

if [ ${ilat} -eq 1  ]
then

cat <<EOF > input.dat
seed = ${seed}
nx = ${nx}
nt = ${nt}
beta = ${beta}
trajectories = ${trajectories}
startlat = fresh
d_hot = ${d_hot}
d_update = ${d_update}
prevlat_name = NA
endlat = save
lat_name = ${lat_name}

EOF

else

ilat_prev=$((${ilat}-1))
prevlat_name="${lat_dir}/${ens_name}.${ilat_prev}"

cat <<EOF > input.dat
seed = ${seed}
nx = ${nx}
nt = ${nt}
beta = ${beta}
trajectories = ${trajectories}
startlat = reload
d_hot = ${d_hot}
d_update = ${d_update}
prevlat_name = ${prevlat_name}
endlat = save
lat_name = ${lat_name}

EOF

fi

cat input.dat | ./pure_u1  > ${out_name}

text="END:"
complete_flag=$(bash is_complete.sh ${out_name} ${text})
if [ "${complete_flag}" = "1" ]
then
seed=$((${seed}+1))
ilat=$((${ilat}+1))
fi

counter=$((${counter}+1))
done # LATTICES
done # ENSEMBLES
