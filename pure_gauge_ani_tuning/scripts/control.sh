#!/bin/bash

mother_dir="/home/data/fnal_unzipped"

printf "beta x0 w0 w0_err xi_g xi_g_err\n" >> surface_file

for dir in "${mother_dir}"/*/
do

beta=${dir%x*}
beta=${beta##*b}

x0=${dir%a*}
x0=${x0##*x}



#if [ "${beta}" = "7100" ] && [ "${x0}" = "183" ]
#then

echo $dir

xi_f_arr=("0")
xi_f_flo=("0")
j=0
for file in "${dir}"/*
do
initials=${file##*/}
initials=${initials::5}
dot=${file:(-4)}
dot=${dot::1}

if [ "${initials}" = "sflow" ] && [ "${dot}" = "." ]
then
xi_f=${file##*f}
xi_f=${xi_f::3}
if [ $j -eq 0 ]
then
xi_f_arr[$j]="${xi_f}"
j_prev=$j
j=$(($j+1))
elif [ ! "${xi_f}" = "${xi_f_arr[$j_prev]}" ]
then
xi_f_arr+=("${xi_f}")
j=$(($j+1))
j_prev=$(($j_prev+1))
fi
fi
done

pp=${xi_f_arr[0]}
ppi=${pp::1}
ppf=${pp:1}
xi_f_flo[0]="${ppi}.${ppf}"

i=1
while [ $i -le $j_prev ]
do
pp=${xi_f_arr[$i]}
ppi=${pp::1}
ppf=${pp:1}
xi_f_flo+=("${ppi}.${ppf}")
i=$(($i+1))
done

printf "%s\n" "${xi_f_arr[@]}" > xi_f_arr
printf "%s\n" "${xi_f_flo[@]}" > xi_f_flo
printf "%s %s %s" "${beta}" "${x0}" "${j_prev}" > beta_x0_length

python python_src.py >> surface_file

rm xi_f_arr
rm xi_f_flo
rm beta_x0_length

#fi
done