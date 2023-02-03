#!/bin/bash
start_time=$(date +%s.%N)
path=$1
source ${path}/params.sh

if [ ! -d "${directory}" ]
then
	mkdir "${directory}"
fi

### guard FILE CONTAINS NUMBER OF THE NEXT LATTICE TO BE MEASURED
if [ -f "${directory}/guard" ]
then
	i_lat=$(head -1 "${directory}/guard")
	seed=$(tail -1 "${directory}/guard")
else 
	i_lat=${set_i_lat}
	seed=${set_seed}
cat << EOF > "${directory}/guard"
${i_lat}
${seed}
EOF
fi

n_produced=0
echo "Measuring on ${lat_name}..."
i=1
while [ $i -le $n_of_lat ]
do

	file_name="${directory}/spec${nx}${nt}b${beta_name}x${xi_0_name}${stream}.lat.${i_lat}"
	if [ -f "${file_name}" ]
	then
		rm "${file_name}"
	fi
	bash ${path}/make_input_nd.sh ${i_lat} ${seed} ${path}
	bash ${path_build}/build_input.ks_spectrum_hisq.ndv3.2.sh ${run_dir}/param_input > ${run_dir}/spec_input
	srun -n 128 ${path_build}/ks_spectrum_hisq_dbl_icc_20230125 ${run_dir}/spec_input > ${file_name}
#	${path_build}/ks_spectrum_hisq_dbl_scalar_icc_20230120 ${run_dir}/spec_input > ${file_name}

	text="RUNNING COMPLETED"
	complete_flag=$(bash ${path}/is_complete.sh ${file_name} ${text})
	if [ "${complete_flag}" = "1" ]
	then
		n_produced=$((${n_produced}+1))
		i_lat=$((${i_lat}+1)) 
		seed=$((${seed}+1))
cat << EOF > "${directory}/guard"
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

