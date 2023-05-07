#!/bin/bash

if [ $1 = "scan" ]
then 

bash call_my_fitter.sh  > temp_fit.data
gnuplot -p -e 'plot "temp_fit.data" u 1:2 w lp title "chi2"'
gnuplot -p -e 'plot "temp_fit.data" u 1:3 w lp title "Q"'
gnuplot -p -e 'plot "temp_fit.data" u 1:4 w lp title "E0"'

elif [ $1 = "fit" ]
then

rm temp_fit.data

python3 my_fitter.py <<EOF
0.0788
0.0788
CORNER
CORNER
PION_5
strange
$2
yes
EOF


fi
