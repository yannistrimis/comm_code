#!/bin/bash

for tmin in {4..8..1}
do


python3 my_fitter.py <<EOF
0.0788
0.0788
CORNER
CORNER
PION_5
strange
${tmin}
no
EOF


done
