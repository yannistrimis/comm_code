#!/bin/bash

for i_file in {101..300..1}
do
echo ${i_file}
cat <<EOF > input
${i_file}
EOF
python clean_one.py < input

done
