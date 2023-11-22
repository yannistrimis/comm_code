#!/bin/bash

n_of_ens=3

nx=16
nt=16

beta_name_arr=( "0750" "1000" "1250" )
stream="a"

initial_ilat=101

n_of_lat=100
r_min=1
r_step=1
r_max=6
t_min=1
t_step=1
t_max=8


for (( i_ens=0; i_ens<${n_of_ens}; i_ens++ )); do
beta_name=${beta_name_arr[${i_ens}]}

ens_name="l${nx}${nt}b${beta_name}${stream}"

lat_dir="/home/trimis/data/pure_u1/lattices/${ens_name}" # CMSE
out_dir="/home/trimis/data/pure_u1/outputs/${ens_name}"  # CMSE

# lat_dir="/home/yannis/Physics/LQCD/pure_u1/lattices/${ens_name}" # LAPTOP
# out_dir="/home/yannis/Physics/LQCD/pure_u1/outputs/${ens_name}"  # LAPTOP

ilat=${initial_ilat}
counter=1
while [ ${counter} -le $n_of_lat ]
do

lat_name="${lat_dir}/${ens_name}.${ilat}"
out_name="${out_dir}/wloop${ens_name}.${ilat}"

if [ -f {out_name} ] # PRECAUTION ABOUT OUTPUT
then
rm ${out_name}
fi

cat <<EOF > wloop_input.dat
lat_name = ${lat_name}
nx = ${nx}
nt = ${nt}
r_min = ${r_min}
r_step = ${r_step}
r_max = ${r_max}
t_min = ${t_min}
t_step = ${t_step}
t_max = ${t_max}

EOF

cat wloop_input.dat | ./wloop  > ${out_name}

text="END:"
complete_flag=$(bash is_complete.sh ${out_name} ${text})
if [ "${complete_flag}" = "1" ]
then
ilat=$((${ilat}+1))
fi

counter=$((${counter}+1))
done # LATTICES
done # ENSEMBLES
