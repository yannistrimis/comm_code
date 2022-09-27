#!/bin/bash

for i in {1..10..1}
do

if [ $i -eq 1 ]
then
sbatch submit_script.sb
else
sbatch --dependency=afterany:${prev_id} submit_script.sb
fi

done
