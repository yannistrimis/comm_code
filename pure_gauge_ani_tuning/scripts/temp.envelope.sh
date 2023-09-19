#!/bin/bash

flow_type_arr=("s" "w")
obs_type_arr=("clover" "wilson" "symanzik")

for flow_type in ${flow_type_arr[@]}; do
for obs_type in ${obs_type_arr[@]}; do

python3 tuning_wuppertal_new.py <<EOF
${flow_type}
${obs_type}
EOF

done
done

