#!/bin/bash

xq_arr=( "1880" "1940" "2000" "2060" )
mom_arr=( "p100" "p110" )

for xq in ${xq_arr[@]};do
echo "xq = ${xq}"
for mom in ${mom_arr[@]};do
echo "	${mom}"
tmin_min=4
tmin_max=20

tmax_min=30
tmax_max=30

for ((tmin=${tmin_min};tmin<=${tmin_max};tmin++));do
for ((tmax=${tmax_min};tmax<=${tmax_max};tmax++));do

python3 fitter_v1.0.py <<EOF
/home/yannis/Physics/LQCD/fnal/all/spec_data/l1664b70805x18876a
${mom}pt1664b70805x18876xq${xq}_m0.06m0.06PION_5.specdata
${tmin}
${tmax}
33
64
EOF

done # tmin
done # tmax

done # mom
done # xq
