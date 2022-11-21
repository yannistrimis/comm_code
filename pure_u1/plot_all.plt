reset
set terminal postscript eps size 8.0,3.5 enhanced color \
    font 'Helvetica,16' linewidth 1
set output "acceptances.ps"

#set logscale
#set multiplot layout 1,2 title "Error vs real time cost at {/Symbol x}_0=4.2" font ", 16"

set title "acceptance vs beta at D=10, 10 sweeps, 4x4x4x4"

set ylabel "acceptance"
set xlabel "beta"

plot "acceptance.dat" using 2:1 w p

