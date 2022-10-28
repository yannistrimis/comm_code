#!/bin/bash

for i in {1..1..1}
do

if [ $i -eq 1 ]
then
sbatch submit_script.sb > id_file
prev_id=$( awk '{print $4}' id_file )
else
sbatch --dependency=afterany:${prev_id} submit_script.sb > id_file
prev_id=$( awk '{print $4}' id_file )
fi

done
