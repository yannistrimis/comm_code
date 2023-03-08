#!/bin/bash

cd /mnt/home/trimisio/runs/runs4
path="/mnt/home/trimisio/comm_code/wilson_flow_ani/scripts4"

for i in {1..4..1}
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
