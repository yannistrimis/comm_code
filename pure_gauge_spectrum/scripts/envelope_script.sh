#!/bin/bash
source params.sh

cd ${run_dir}

for i in {1..1..1}
do
	if [ $i -eq 1 ]
	then
		sbatch ${path}/submit_script.sb ${path} > id_file
		prev_id=$( awk '{print $4}' id_file )
	else
		sbatch --dependency=afterany:${prev_id} ${path}/submit_script.sb ${path} > id_file
		prev_id=$( awk '{print $4}' id_file )
	fi

done
