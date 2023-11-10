#!/bin/bash

vol=1664
beta=70805
xg=18876
src="pt"
mass="0.06"
taste="PION_5"

fitdir="/home/yannis/Physics/LQCD"
dir="/home/yannis/Physics/LQCD/fnal/all/spec_data/l${vol}b${beta}x${xg}a"
tdata=33
tp=64
n_states=1
m_states=0

if [ $1 == "scan" ]
then

xq_arr=( "2000" )
mom_arr=( "p000" )

for xq in ${xq_arr[@]};do
echo "xq = ${xq}"
for mom in ${mom_arr[@]};do
echo "	${mom}"

if [ -f ${fitdir}/${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.scanfit ]
then
rm ${fitdir}/${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.scanfit
fi


tmin_min=8
tmin_max=29

tmax_min=33
tmax_max=33

for ((tmin=${tmin_min};tmin<=${tmin_max};tmin++));do
for ((tmax=${tmax_min};tmax<=${tmax_max};tmax++));do

python3 fitter_v1.0.py <<EOF >> ${fitdir}/${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.scanfit
${dir}
${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.specdata
${tmin}
${tmax}
${tdata}
${tp}
${n_states}
${m_states}
scanfit
EOF

done # tmin
done # tmax

done # mom
done # xq

elif [ $1 == "one"  ]
then

xq="2000"
mom="p100"
tmin=10
tmax=30

python3 fitter_v1.0.py <<EOF
${dir}
${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.specdata
${tmin}
${tmax}
${tdata}
${tp}
${n_states}
${m_states}
onefit
EOF


fi
