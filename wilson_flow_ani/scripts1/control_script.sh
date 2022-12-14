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

#guard file contains number of THE NEXT lattice to be flowed
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
max_counter=$((${#dt_array[@]}*${#xf_name_array[@]}))

i=1
while [ $i -le $n_of_lat ]
do
#############################################################################
#############################################################################
#############################################################################
for dt in ${dt_array[@]}
do
for i_xf in ${!xf_name_array[@]}
do

xf_name=${xf_name_array[${i_xf}]}
xf=${xf_array[${i_xf}]}
file_name="${directory}/sflow${nx}${nt}b${beta_name}x${xi_0_name}xf${xf_name}${stream}_dt${dt}.lat.${i_lat}"

if [ -f "${file_name}" ]
then
rm "${file_name}"
fi

bash /mnt/home/trimisio/comm_code/wilson_flow_ani/scripts1/make_input.sh ${i_lat} ${dt} ${xf}
srun -n 128 /mnt/home/trimisio/comm_code/wilson_flow_ani/build/wilson_flow_bbb_a input "${file_name}"
text="RUNNING COMPLETED"
complete_flag=$(bash /mnt/home/trimisio/comm_code/wilson_flow_ani/scripts1/is_complete.sh ${file_name} ${text})

if [ "${complete_flag}" = "1" ]
then
counter=$((${counter}+1))
else

if [ -f "${file_name}" ]
then
rm "${file_name}"
fi

fi

done
done
#############################################################################
#############################################################################
#############################################################################
if [ ${counter} -eq ${max_counter} ]
then
counter=0
n_produced=$((${n_produced}+1))
i_lat=$((${i_lat}+1)) #####################FILE STEP
cat << EOF > "${directory}/guard"
${i_lat}
EOF
echo "${n_produced} completed"
fi

i=$(($i+1))
done

echo "flowed ${n_produced} out of ${n_of_lat} requested. Next is ${i_lat}"

end_time=$(date +%s.%N)

elapsed_time=$(python3 -c "res=${end_time}-${start_time};print(res)")
echo "elapsed time = ${elapsed_time} sec"
