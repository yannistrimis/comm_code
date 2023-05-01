#!/bin/bash

for tmin in {1..8..1}
do

python3 my_fitter_n.py <<EOF
$1
$2
$3
$4
$5
specnd
${tmin}
no
EOF

done
