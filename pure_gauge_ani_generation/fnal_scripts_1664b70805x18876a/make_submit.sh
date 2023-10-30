#!/bin/bash

source ${1}/params.sh

if [ ${cluster} == "icer" ]
then

cat <<EOF > ${submit_dir}/submit_script.sb
#!/bin/bash

#SBATCH --time=${sbatch_time}
#SBATCH --ntasks=${sbatch_ntasks}
#SBATCH --exclude=lac-[084-124]
#SBATCH --job-name=${sbatch_jobname}

module purge
module load ${sbatch_module}

bash ${1}/control_script.sh ${1}

EOF

elif [ ${cluster} == "fnal" ]
then

cat <<EOF > ${submit_dir}/submit_script.sb
#!/bin/bash

#SBATCH --time=${sbatch_time}
#SBATCH --partition=lq1_cpu
#SBATCH --nodes=${sbatch_nodes}
#SBATCH --ntasks=${sbatch_ntasks}
#SBATCH -A ahisq
#SBATCH --qos=normal

#SBATCH --job-name=${sbatch_jobname}

module purge
module load ${sbatch_module1}
module load ${sbatch_module2}

bash ${1}/control_script.sh ${1}

EOF

fi
 
