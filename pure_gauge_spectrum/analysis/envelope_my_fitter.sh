#!/bin/bash

bash call_my_fitter.sh > temp_fit.data

gnuplot -p -e 'plot "temp_fit.data" u 1:2 w lp title "chi2"'
gnuplot -p -e 'plot "temp_fit.data" u 1:3 w lp title "Q"'
gnuplot -p -e 'plot "temp_fit.data" u 1:4 w lp title "E0"'
