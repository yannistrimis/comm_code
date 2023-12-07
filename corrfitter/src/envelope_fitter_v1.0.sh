#!/bin/bash

vol=1632
beta=6850
xg=100
src="rcw"
prefix="str"
taste="PION_5"
print_state="n0"

fitdir="/home/trimis/spec_data" # CMSE
dir="/home/trimis/fnal/all/spec_data/l${vol}b${beta}x${xg}a" # CMSE
# fitdir="/home/yannis/Physics/LQCD/spec_data" # LAPTOP
# dir="/home/yannis/Physics/LQCD/fnal/all/spec_data/l${vol}b${beta}x${xg}a" # LAPTOP
tdata=17
tp=32
n_states=1
m_states=0

if [ $1 == "scan" ]
then

tmin_min=0
tmin_max=15

tmax_min=17
tmax_max=17

xq_arr=( "100" )
mom_arr=( "p000" )
mass_arr=( "0.0788" )

for xq in ${xq_arr[@]};do
echo "xq = ${xq}"
for mom in ${mom_arr[@]};do
echo "	mom: ${mom}"
for mass in ${mass_arr[@]};do
echo "		mass: ${mass}"

if [ -f ${fitdir}/${prefix}${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.${n_states}p${m_states}.scanfit ]
then
rm ${fitdir}/${prefix}${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.${n_states}p${m_states}.scanfit
fi

for ((tmin=${tmin_min};tmin<=${tmin_max};tmin++));do
for ((tmax=${tmax_min};tmax<=${tmax_max};tmax++));do

python3 fitter_v1.0.py <<EOF >> ${fitdir}/${prefix}${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.${n_states}p${m_states}.scanfit
${dir}
${prefix}${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.specdata
${tmin}
${tmax}
${tdata}
${tp}
${n_states}
${m_states}
scanfit
${print_state}
EOF

done # tmin
done # tmax

done # mass
done # mom
done # xq

elif [ $1 == "one"  ]
then

xq="1950"
mom="p000"
tmin=25
tmax=33

mass=0.01532

python3 fitter_v1.0.py <<EOF
${dir}
${prefix}${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.specdata
${tmin}
${tmax}
${tdata}
${tp}
${n_states}
${m_states}
onefit
NA
EOF


fi
