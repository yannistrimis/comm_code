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
${sinks}
${spec_type}
$3
$4
${an}
${En}
$5
EOF

elif [ ${my_fitter} = "scipy_fitter_o.py"  ]
then

cat <<EOF > fitter_input.dat
${nx}
${nt}
${beta}
${x0}
${stream}
$1
$2
${sinks}
${spec_type}
$3
$4
${ao}
${Eo}
$5
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
${sinks}
${spec_type}
$3
$4
${an}
${En}
${ao}
${Eo}
$5
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
${sinks}
${spec_type}
$3
$4
${an}
${En}
${ao}
${Eo}
${a1n}
${E1n}
$5
EOF

elif [ ${my_fitter} = "scipy_fitter_nn.py"  ]
then

cat <<EOF > fitter_input.dat
${nx}
${nt}
${beta}
${x0}
${stream}
$1
$2
${sinks}
${spec_type}
$3
$4
${an}
${En}
${a1n}
${E1n}
$5
EOF

fi

cat fitter_input.dat | python3 ../my_fitter/${my_fitter}

