#!/bin/bash
start_time=$(date +%s.%N)

source /mnt/home/trimisio/comm_code/wilson_flow_ani/scripts1/params.sh

#if [ "${erase}" = "yes" ] && [ -d "${directory}" ]
#then
#
#fi

if [ ! -d "${directory}" ]
then
mkdir "${directory}"
fi

#guard file contains number and seed of THE NEXT lattice to be produced
if [ -f "${directory}/guard" ]
then
i_lat=$(head -n 1 "${directory}/guard" | tail -n 1)
else
i_lat=101 ###############INITIAL FILE
cat << EOF > "${directory}/guard"
${i_lat}
EOF
fi

n_produced=0
counter=0
max_counter


i=1
while [ $i -le $n_of_lat ]
do













bash make_input.sh $i_lat

srun -n 128 /mnt/home/trimisio/comm_code/wilson_flow_ani/build/wilson_flow_bbb_a input "${directory}/${f_ensemble}_$1.${i_lat}"

file_name="${directory}/${f_ensemble}_$1.${i_lat}"
text="RUNNING COMPLETED"
complete_flag=$(bash is_complete.sh ${file_name} ${text})

if [ "${complete_flag}" = "1" ]
then
counter=$$(${counter}+1)
fi










if [ ${counter} -eq ${max_counter} ]
then
counter=0
n_produced=$((${n_produced}+1))
i_lat=$(($i_lat+1)) #####################FILE STEP
cat << EOF > "${directory}/guard"
${i_lat}
EOF
echo "${n_produced} completed"
fi

i=$(($i+1))
done

echo "flowed ${n_produced} out of ${n_of_lat} requested"

end_time=$(date +%s.%N)

elapsed_time=$(python3 -c "res=${end_time}-${start_time};print(res)")
echo "elapsed time = ${elapsed_time} sec"
