#!/bin/bash

vol=1664
beta=70805
xg=18876
src="rcw"
mass="0.06"
taste="PION_5"

# fitdir="/home/trimis/local_code" # CMSE
# dir="/home/trimis/fnal/all/spec_data/l${vol}b${beta}x${xg}a" # CMSE
fitdir="/home/yannis/Physics/LQCD" # LAPTOP
dir="/home/yannis/Physics/LQCD/fnal/all/spec_data/l${vol}b${beta}x${xg}a" # LAPTOP
tdata=33
tp=64
n_states=2
m_states=2

if [ $1 == "scan" ]
then

xq_arr=( "1880" "1940" "2000" "2060" )
mom_arr=( "p110" )

for xq in ${xq_arr[@]};do
echo "xq = ${xq}"
for mom in ${mom_arr[@]};do
echo "	${mom}"

if [ -f ${fitdir}/${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.${n_states}p${m_states}.scanfit ]
then
rm ${fitdir}/${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.${n_states}p${m_states}.scanfit
fi


tmin_min=3
tmin_max=12

tmax_min=33
tmax_max=33

for ((tmin=${tmin_min};tmin<=${tmin_max};tmin++));do
for ((tmax=${tmax_min};tmax<=${tmax_max};tmax++));do

python3 fitter_v1.0.py <<EOF >> ${fitdir}/${mom}${src}${vol}b${beta}x${xg}xq${xq}_m${mass}m${mass}${taste}.${n_states}p${m_states}.scanfit
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

xq="1880"
mom="p000"
tmin=22
tmax=33

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
