#!/bin/bash
start_time=$(date +%s.%N)
path=$1
source ${path}/params.sh

if [ ! -d "${directory}" ]
then
	mkdir "${directory}"
fi

### guard_nlpi FILE CONTAINS NUMBER OF THE NEXT LATTICE TO BE MEASURED
if [ -f "${directory}/guard_nlpi" ]
then
	i_lat=$(head -1 "${directory}/guard_nlpi")
	seed=$(tail -1 "${directory}/guard_nlpi")
else 
	i_lat=${set_i_lat}
	seed=${set_seed}
cat << EOF > "${directory}/guard_nlpi"
${i_lat}
${seed}
EOF
fi

n_produced=0
echo "Measuring on ${lat_name}..."
i=1
while [ $i -le $n_of_lat ]
do

	file_name="${directory}/specnlpi${nx}${nt}b${beta_name}x${xi_0_name}ml${mass1_name}xq${xq_0_name}${stream}.${i_lat}"
	if [ -f "${file_name}" ]
	then
		rm "${file_name}"
	fi
	bash ${path}/make_input_nd.sh ${i_lat} ${seed} ${path}
	bash ${path}/build_input.ks_spectrum_hisq.nlpi2v2.2.sh ${submit_dir}/param_input > ${submit_dir}/spec_input
cd ${run_dir}
	srun -n 128 ${path_build}/ks_spectrum_hisq_dbl_icc_20230618 ${submit_dir}/spec_input > ${file_name}
cd ${submit_dir}
	text="RUNNING COMPLETED"
	complete_flag=$(bash ${path}/is_complete.sh ${file_name} ${text})
	if [ "${complete_flag}" = "1" ]
	then
		n_produced=$((${n_produced}+1))
		i_lat=$((${i_lat}+1)) 
		seed=$((${seed}+1))
cat << EOF > "${directory}/guard_nlpi"
${i_lat}
${seed}
EOF
		echo "${n_produced} completed. Next is ${i_lat}"
	fi
	i=$(($i+1))
done

echo "measured ${n_produced} out of ${n_of_lat} requested. Next is ${i_lat}"
end_time=$(date +%s.%N)
elapsed_time=$(python3 -c "res=${end_time}-${start_time};print(res)")
echo "elapsed time = ${elapsed_time} sec"

