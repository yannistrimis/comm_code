#!/bin/bash

source params.sh

if [ -d "${directory}/guard" ]
then

i_lat=$(head -n 1 "${directory}/guard" | tail -n 1)
seed=$(head -n 2 "${directory}/guard" | tail -n 1)

else

i_lat=101

cat << EOF > "${directory}/guard"
${i_lat}
${init_seed}
EOF

fi

i=1
while [ $i -le $n_of_lat ]
do

bash make_input $i_lat
srun -n 4 ./su3_ora_symzk0_a_intel input
i_lat=$(($i_lat+1))
seed=$((${seed}+1))

cat << EOF > "${directory}/guard"
${i_lat}
${seed}
EOF

i=$(($i+1))
done
