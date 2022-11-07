reset
set terminal postscript eps size 8.0,3.5 enhanced color \
    font 'Helvetica,16' linewidth 1
set output "xi_5.ps"

#set logscale
set multiplot layout 1,2 title "Error vs real time cost at {/Symbol x}_0=4.2" font ", 16"



set ylabel "logC_t"
set xlabel "log(p_i 2.4/ {/Symbol D}{/Symbol t}_i)

plot "sflow1680b7000x42000xf450a_ct.dat" using (log(((2.4/$1)*6))):(log($2)) title "bbb" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using (log(((2.4/$1)*3))):(log($3)) title "cf3" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using (log(((2.4/$1)*5))):(log($4)) title "ck" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using (log(((2.4/$1)*3))):(log($5)) title "lue" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using (log(((2.4/$1)*3))):(log($6)) title "rkmk3" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using (log(((2.4/$1)*4))):(log($7)) title "rkmk4" w lp

unset ylabel



set ylabel "logC_s"

plot "sflow1680b7000x42000xf450a_cs.dat" using (log(((2.4/$1)*6))):(log($2)) title "bbb" w lp,\
        "sflow1680b7000x42000xf450a_cs.dat" using (log(((2.4/$1)*3))):(log($3)) title "cf3" w lp,\
        "sflow1680b7000x42000xf450a_cs.dat" using (log(((2.4/$1)*5))):(log($4)) title "ck" w lp,\
        "sflow1680b7000x42000xf450a_cs.dat" using (log(((2.4/$1)*3))):(log($5)) title "lue" w lp,\
        "sflow1680b7000x42000xf450a_cs.dat" using (log(((2.4/$1)*3))):(log($6)) title "rkmk3" w lp,\
        "sflow1680b7000x42000xf450a_cs.dat" using (log(((2.4/$1)*4))):(log($7)) title "rkmk4" w lp


unset multiplot

