#!/bin/bash
source fitter_params.sh

if [ ${my_fitter} = "scipy_fitter_n.py"  ]
then

cat <<EOF > fitter_input.dat
<<<<<<< HEAD
${nx}
${nt}
${beta}
${x0}
${stream}
$1
$2
=======
non
${nt}
${ens_name}
${one_mass1}
${one_mass2}
>>>>>>> a322b94853357662e48a0d647535d63fac6d2dfb
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

<<<<<<< HEAD
fi

=======
>>>>>>> a322b94853357662e48a0d647535d63fac6d2dfb
cat fitter_input.dat | python3 ../../my_fitter/${my_fitter}

