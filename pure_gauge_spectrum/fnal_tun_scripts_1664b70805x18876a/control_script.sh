#!/bin/bash
start_time=$(date +%s.%N)
path=$1
source ${path}/params.sh

# guard FILE CONTAINS NUMBER OF NEXT LATTICE TO BE MEASURED

if [ -f "${submit_dir}/guard" ]
then

i_lat=$(head -n 1 "${submit_dir}/guard")
seed=$(tail -n 1 "${submit_dir}/guard")

else

i_lat=${set_i_lat}
seed=${set_seed}

cat << EOF > "${submit_dir}/guard"
${i_lat}
${seed}
EOF

fi

n_meas=0

i=1
while [ $i -le $n_of_lat ]
do
echo $i_lat

complete_number=0
for (( i_xq=0; i_xq<${nxq}; i_xq++ )); do

xiq=${xq_arr[$i_xq]}
xiq_name=${xq_name_arr[$i_xq]}

file_name="${out_dir}/${out_name}xq${xiq_name}${stream}.${i_lat}"

if [ -f "${file_name}" ] # PRECAUTION ABOUT THE OUTPUT
then
rm ${file_name}
fi

bash ${path}/make_input.sh $i_lat $seed $xiq $path
bash ${path}/${build_script} ${submit_dir}/param_input > ${submit_dir}/spec_input

cd ${run_dir}

if [ ${cluster} == "icer"  ]
then

srun -n ${sbatch_ntasks} ${path_build}/${executable} ${submit_dir}/spec_input ${file_name}

elif [ ${cluster} == "fnal" ]
then

srun -n ${sbatch_ntasks} --mpi=pmix ${path_build}/${executable} ${submit_dir}/spec_input ${file_name}

fi

cd ${submit_dir}

text="RUNNING COMPLETED"
complete_flag=$(bash ${path}/is_complete.sh ${file_name} ${text})

if [ "${complete_flag}" = "1" ]
then
complete_number=$((${complete_number}+1))
fi

done # i_xq

if [ ${complete_number} -eq ${nxq} ]
then

n_meas=$((${n_meas}+1))
i_lat=$(($i_lat+1))
seed=$(($seed+1))
cat << EOF > "${submit_dir}/guard"
${i_lat}
${seed}
EOF

fi

i=$(($i+1))

done # LATTICES

echo "measured ${n_meas} out of ${n_of_lat} requested"

end_time=$(date +%s.%N)

elapsed_time=$(python3 -c "res=${end_time}-${start_time};print(res)")
echo "elapsed time = ${elapsed_time} sec"

