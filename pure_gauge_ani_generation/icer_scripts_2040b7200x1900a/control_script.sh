#!/bin/bash
start_time=$(date +%s.%N)
path=$1
source ${path}/params.sh

# guard FILE CONTAINS NUMBER AND SEED OF NEXT LATTICE TO BE PRODUCED

if [ -f "${submit_dir}/guard" ]
then

i_lat=$(head -n 1 "${submit_dir}/guard" | tail -n 1)
seed=$(head -n 2 "${submit_dir}/guard" | tail -n 1)

else

i_lat=1
seed=${init_seed}
cat << EOF > "${submit_dir}/guard"
${i_lat}
${seed}
EOF

fi

n_produced=0

i=1
while [ $i -le $n_of_lat ]
do

echo $seed $i_lat
file_name="${out_dir}/${out_name}.${i_lat}"

if [ -f "${directory}/${lat_name}.${i_lat}" ] # PRECAUTION ABOUT THE BINARY
then
rm "${directory}/${lat_name}.${i_lat}"
fi

if [ -f "${file_name}" ] # PRECAUTION ABOUT THE OUTPUT
then
rm ${file_name}
fi

bash ${path}/make_input.sh $i_lat $seed $path

cd ${run_dir}

if [ ${cluster} == "icer"  ]
then

srun -n ${sbatch_ntasks} ${path_build}/${executable} ${submit_dir}/input ${file_name}

elif [ ${cluster} == "fnal" ]
then

srun -n ${sbatch_ntasks} --mpi=pmix ${path_build}/${executable} ${submit_dir}/input ${file_name}

fi

cd ${submit_dir}

text="Saved gauge configuration serially to binary file ${directory}/${lat_name}.${i_lat}"
complete_flag=$(bash ${path}/is_complete.sh ${file_name} ${text})

if [ "${complete_flag}" = "1" ]
then

n_produced=$((${n_produced}+1))
i_lat=$(($i_lat+1))
seed=$((${seed}+1))
cat << EOF > "${submit_dir}/guard"
${i_lat}
${seed}
EOF

fi

i=$(($i+1))

done # LATTICES

echo "produced ${n_produced} out of ${n_of_lat} requested"

end_time=$(date +%s.%N)

elapsed_time=$(python3 -c "res=${end_time}-${start_time};print(res)")
echo "elapsed time = ${elapsed_time} sec"

