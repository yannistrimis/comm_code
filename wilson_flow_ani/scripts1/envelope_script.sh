#!/bin/bash

cd /mnt/home/trimisio/runs/runs1
for i in {1..1..1}
do

if [ $i -eq 1 ]
then
sbatch /mnt/home/trimisio/comm_code/wilson_flow_ani/scripts1/submit_script.sb > id_file
prev_id=$( awk '{print $4}' id_file )
else
sbatch --dependency=afterany:${prev_id} /mnt/home/trimisio/comm_code/wilson_flow_ani/scripts1/submit_script.sb > id_file
prev_id=$( awk '{print $4}' id_file )
fi

done
