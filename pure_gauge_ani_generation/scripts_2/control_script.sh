#!/bin/bash
start_time=$(date +%s.%N)

source params.sh

if [ "${erase}" = "yes" ] && [ -d "${directory}" ]
then
rm -r "${directory}"
rm -r "${out_dir}"
fi

if [ ! -d "${directory}" ]
then
mkdir "${directory}"
mkdir "${out_dir}"
fi


#guard file contains number and seed of THE NEXT lattice to be produced
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
echo $seed
bash make_input.sh $i_lat $seed
srun -n 144 ../build/su3_ora_symzk1_a input "${out_dir}/${out_name}.lat.${i_lat}"

file_name="${out_dir}/${out_name}.lat.${i_lat}"
text="Saved gauge configuration serially to binary file ${directory}/${lat_name}.lat.${i_lat}"
complete_flag=$(bash is_complete.sh ${file_name} ${text})

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