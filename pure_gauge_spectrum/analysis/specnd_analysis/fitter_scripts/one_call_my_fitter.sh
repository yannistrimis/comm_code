#!/bin/bash
source fitter_params.sh

if [ ${my_fitter} = "scipy_fitter_n.py"  ]
then

cat <<EOF > fitter_input.dat
${nx}
${nt}
${beta}
${x0}
${stream}
$1
$2
${source1}
${source2}
${sinks}
specnd
$3
$4
${an}
${En}
yes
EOF

elif [ ${my_fitter} = "scipy_fitter_no.py"  ]
then

cat <<EOF > fitter_input.dat
${nx}
${nt}
${beta}
${x0}
${stream}
$1
$2
${source1}
${source2}
${sinks}
specnd
$3
$4
${an}
${En}
${ao}
${Eo}
yes
EOF

elif [ ${my_fitter} = "scipy_fitter_non.py"  ]
then

cat <<EOF > fitter_input.dat
${nx}
${nt}
${beta}
${x0}
${stream}
$1
$2
${source1}
${source2}
${sinks}
specnd
$3
$4
${an}
${En}
${ao}
${Eo}
${a1n}
${E1n}
yes
EOF

fi

cat fitter_input.dat | python3 ../../my_fitter/${my_fitter}
