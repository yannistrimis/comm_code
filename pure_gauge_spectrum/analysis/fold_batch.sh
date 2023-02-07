#!/bin/bash
source_list=("a" "b")
for i_file in {101..300..1}
do
    echo ${i_file}
    for i_source in ${source_list[@]}
    do
       
cat <<EOF > input_fold
${i_file}
${i_source}
EOF

        python fold_one.py < input_fold
    done
done

rm input_fold
