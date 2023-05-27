#!/bin/bash

# SHOULD BE RUN WITH 2 ARGS: <FILE_FULL_PATH> <#_OF_TMAX>

cat<<EOF > scanplot.plt
unset key
plot "$1" u 1:5:6 every $2::0 w err, "$1" u (\$1+0.1):5:6 every $2::1 w err, "$1" u (\$1+0.2):5:6 every $2::2 w err
EOF


gnuplot -p scanplot.plt
