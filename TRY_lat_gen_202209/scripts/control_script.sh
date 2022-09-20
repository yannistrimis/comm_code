#!/bin/bash

source params.sh

if [! -d "${directory}" ]
then
mkdir "${directory}"
mkdir "${directory}/outs"
fi



if [ -f "${directory}/guard" ]
then

i_lat=$(head -n 1 "${directory}/guard" | tail -n 1)
seed=$(head -n 2 "${directory}/guard" | tail -n 1)

else

i_lat=101
seed=${init_seed}

cat << EOF > "${directory}/guard"
${i_lat}
${init_seed}
EOF

fi

i=1
while [ $i -le $n_of_lat ]
do
echo $seed
bash make_input.sh $i_lat $seed
#srun -n 4 ../su3_ora_symzk0_a_par_intel input
mpirun -n 4 ../su3_ora_symzk0_a_sca_gnu input "${directory}/outs/out.${i_lat}"
i_lat=$(($i_lat+1))
seed=$((${seed}+1))

cat << EOF > "${directory}/guard"
${i_lat}
${seed}
EOF

i=$(($i+1))
done
