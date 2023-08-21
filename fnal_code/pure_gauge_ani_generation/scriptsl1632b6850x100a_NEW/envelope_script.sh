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

cd ${submit_dir}

cat <<EOF > ${submit_dir}/submit_script.sb
#!/bin/bash

#SBATCH --time=${sbatch_time}
#SBATCH --partition=lq1csl
#SBATCH --nodes=${sbatch_nodes}
#SBATCH --ntasks=${sbatch_tasks}
#SBATCH -A ahisq
#SBATCH --qos=normal

#SBATCH --job-name=${sbatch_jobname}

module purge
module load ${sbatch_module}

bash ${path}/control_script.sh ${path}

EOF

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
