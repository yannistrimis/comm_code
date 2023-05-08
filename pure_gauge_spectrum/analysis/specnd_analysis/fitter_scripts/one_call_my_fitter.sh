#!/bin/bash
source fitter_params.sh

cat <<EOF > fitter_input.dat
non
${nt}
${ens_name}
${one_mass1}
${one_mass2}
${source1}
${source2}
${sinks}
specnd
${one_tmin}
${one_tmax}
${an}
${En}
${ao}
${Eo}
${a1n}
${E1n}
yes
EOF

cat fitter_input.dat | python3 ../../my_fitter/${my_fitter}

