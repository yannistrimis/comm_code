#!/bin/bash

nx=16
nt=16
stream="a"
beta_name_arr=("0250" "0500" "0750" "1000" "1250")
for beta_name in ${beta_name_arr[@]};do
ens_name="l${nx}${nt}b${beta_name}${stream}" #CMSE
out_name="/home/trimis/data/pure_u1/outputs/${ens_name}/wloop${ens_name}" # CMSE
wloop_data_dir="/home/trimis/data/pure_u1/wilson_loop/${ens_name}" # CMSE

if [ ! -d "${wloop_data_dir}" ];then
mkdir ${wloop_data_dir}
fi

r_arr=("1" "2" "3" "4" "5" "6")
t_arr=("1" "2" "3" "4" "5" "6" "7" "8")

for r in ${r_arr[@]};do
for t in ${t_arr[@]};do
for i_lat in {101..200..1};do

awk -v vr="${r}" -v vt="${t}" '$1==vr && $2==vt {print $3,$4}' "${out_name}.${i_lat}" >> "${wloop_data_dir}/wloop_r${r}t${t}.data"


done # i_lat
done # t
done # r
echo "${beta_name} done"
done # beta_name
