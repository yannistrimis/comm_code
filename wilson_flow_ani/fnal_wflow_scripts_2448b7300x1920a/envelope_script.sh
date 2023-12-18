#!/bin/bash
path=$(pwd)
source ${path}/params.sh


if [ ! -d "${run_dir}" ]
then
mkdir "${run_dir}"
fi

if [ ! -d "${submit_dir}" ]
then
mkdir "${submit_dir}"
fi

if [ ! -d "${out_dir}" ]
then
mkdir "${out_dir}"
fi

bash ${path}/make_submit.sh ${path}
cd ${submit_dir}

for (( i=0; i<${n_of_sub}; i++ )); do

if [ $i -eq 0 ]
then
sbatch ${submit_dir}/submit_script.sb > ${submit_dir}/id_file
prev_id=$( awk '{print $4}' ${submit_dir}/id_file )
else
sbatch --dependency=afterany:${prev_id} ${submit_dir}/submit_script.sb > ${submit_dir}/id_file
prev_id=$( awk '{print $4}' ${submit_dir}/id_file )
fi

done
