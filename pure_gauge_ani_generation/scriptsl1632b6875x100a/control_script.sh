#!/bin/bash
start_time=$(date +%s.%N)
path=$1
source ${path}/params.sh

#if [ "${erase}" = "yes" ] && [ -d "${directory}" ]
#then
#
#
#fi

if [ ! -d "${directory}" ]
then
mkdir "${directory}"
mkdir "${out_dir}"
fi


# guard FILE CONTAINS NUMBER AND SEED OF NEXT LATTICE TO BE PRODUCED
if [ -f "${directory}/guard" ]
then
i_lat=$(head -n 1 "${directory}/guard" | tail -n 1)
seed=$(head -n 2 "${directory}/guard" | tail -n 1)
else
i_lat=1
seed=${init_seed}
cat << EOF > "${directory}/guard"
${i_lat}
${seed}
EOF
fi

n_produced=0

i=1
while [ $i -le $n_of_lat ]
do
echo $seed $i_lat
file_name="${out_dir}/${out_name}.lat.${i_lat}"

if [ -f "${directory}/${lat_name}.lat.${i_lat}" ] # THIS PRECAUTION IS ONLY ABOUT THE BINARY
then
rm "${directory}/${lat_name}.lat.${i_lat}"
fi

bash ${path}/make_input.sh $i_lat $seed $path
srun -n 128 ${path_build}/su3_ora_symzk1_a_dbl_icc_20230309 ${run_dir}/input ${file_name}

text="Saved gauge configuration serially to binary file ${directory}/${lat_name}.lat.${i_lat}"
complete_flag=$(bash ${path}/is_complete.sh ${file_name} ${text})

if [ "${complete_flag}" = "1" ]
then
n_produced=$((${n_produced}+1))
i_lat=$(($i_lat+1))
seed=$((${seed}+1))
cat << EOF > "${directory}/guard"
${i_lat}
${seed}
EOF
fi

i=$(($i+1))

done

echo "produced ${n_produced} out of ${n_of_lat} requested"

end_time=$(date +%s.%N)

elapsed_time=$(python3 -c "res=${end_time}-${start_time};print(res)")
echo "elapsed time = ${elapsed_time} sec"

