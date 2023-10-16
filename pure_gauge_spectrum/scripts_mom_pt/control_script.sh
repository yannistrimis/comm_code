#!/bin/bash
start_time=$(date +%s.%N)
path=$1
source ${path}/params.sh

if [ ! -d "${directory}" ]
then
	mkdir "${directory}"
fi

### guard_mom_ani FILE CONTAINS NUMBER OF THE NEXT LATTICE TO BE MEASURED

if [ -f "${submit_dir}/guard_mom_ani" ]
then

i_lat=$(head -1 "${submit_dir}/guard_mom_ani")
seed=$(tail -1 "${submit_dir}/guard_mom_ani")

else 

i_lat=${set_i_lat}
seed=${set_seed}

cat << EOF > "${submit_dir}/guard_mom_ani"
${i_lat}
${seed}
EOF

fi

n_produced=0
counter=0
max_counter=${#xq_arr[@]}

echo "Measuring on ${lat_name}..."
i=1
while [ $i -le $n_of_lat ]
do

for i_xq in ${!xq_arr[@]}; do

xq_0=${xq_arr[$i_xq]}
xq_0_name=${xq_name_arr[$i_xq]}

file_name="${directory}/specmompt${nx}${nt}b${beta_name}x${xi_0_name}xq${xq_0_name}${stream}.${i_lat}"

if [ -f "${file_name}" ]
then
rm "${file_name}"
fi

bash ${path}/make_input.sh ${i_lat} ${seed} ${path} ${xq_0}
bash ${path}/build_input.sh ${submit_dir}/param_input > ${submit_dir}/spec_input

cd ${run_dir}
srun -n 128 ${path_build}/ks_spectrum_ani_hisq_icc_dbl_20230619 ${submit_dir}/spec_input  > ${file_name}
cd ${submit_dir}

text="RUNNING COMPLETED"
complete_flag=$(bash ${path}/is_complete.sh ${file_name} ${text})

if [ "${complete_flag}" = "1" ]
then
counter=$((${counter}+1))
elif [ -f "${file_name}" ]
then
rm "${file_name}"
fi

done # FERMION ANISOTROPIES


if [ ${counter} -eq ${max_counter} ]
then

counter=0
n_produced=$((${n_produced}+1))
i_lat=$((${i_lat}+1)) 
seed=$((${seed}+1))

cat << EOF > "${submit_dir}/guard_mom_ani"
${i_lat}
${seed}
EOF

echo "${n_produced} completed. Next is ${i_lat}"

fi

i=$(($i+1))
done # LATTICES

echo "measured ${n_produced} out of ${n_of_lat} requested, at xq_0 = ${xq_0}. Next is ${i_lat}"
end_time=$(date +%s.%N)
elapsed_time=$(python3 -c "res=${end_time}-${start_time};print(res)")
echo "elapsed time = ${elapsed_time} sec"

