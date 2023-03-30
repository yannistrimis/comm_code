#!/bin/bash
path=$(pwd)
source ${path}/params.sh


if [ ! -d "${run_dir}" ]
then
        mkdir "${run_dir}"
fi

cd ${run_dir}

for i in {1..1..1}
do

if [ $i -eq 1 ]
then
sbatch ${path}/submit_script.sb ${path} > ${run_dir}/id_file
prev_id=$( awk '{print $4}' ${run_dir}/id_file )
else
sbatch --dependency=afterany:${prev_id} ${path}/submit_script.sb ${path} > ${run_dir}/id_file
prev_id=$( awk '{print $4}' ${run_dir}/id_file )
fi

done