#!/bin/bash

#cat<<EOF > scanplot.plt 
#unset key
#plot "$1" u 1:5:6 every 3::0 w err, "$1" u (\$1+0.1):5:6 every 3::1 w err, "$1" u (\$1+0.2):5:6 every 3::2 w err
#EOF

cat<<EOF > scanplot.plt
unset key
plot "$1" u 1:5:6 every 3::0 w err, "$1" u (\$1+0.1):5:6 every 3::1 w err, "$1" u (\$1+0.2):5:6 every 3::2 w err, "$1" u 1:7:8 every 3::0 w err, "$1" u (\$1+0.1):7:8 every 3::1 w err, "$1" u (\$1+0.2):7:8 every 3::2 w err
EOF


gnuplot -p scanplot.plt
