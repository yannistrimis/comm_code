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

if [ ! -d "${directory}" ]
then
mkdir "${directory}"
fi

if [ ! -d "${out_dir}" ]
then
mkdir "${out_dir}"
fi

bash ${path}/make_submit.sh ${path}
cd ${submit_dir}

for i in {1..2..1}
do

if [ $i -eq 1 ]
then
sbatch ${submit_dir}/submit_script.sb > ${submit_dir}/id_file
prev_id=$( awk '{print $4}' ${submit_dir}/id_file )
else
sbatch --dependency=afterany:${prev_id} ${submit_dir}/submit_script.sb > ${submit_dir}/id_file
prev_id=$( awk '{print $4}' ${submit_dir}/id_file )
fi

done