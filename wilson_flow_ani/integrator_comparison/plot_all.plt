reset
set terminal postscript eps size 8.0,3.5 enhanced color \
    font 'Helvetica,16' linewidth 1
set output "xi_5.ps"

set logscale
set multiplot layout 1,2 title "{/Symbol x}_0=4.2" font ", 16"



set ylabel "logC_t"


plot "sflow1680b7000x42000xf450a_ct.dat" using ((2.4/$1)*6):2 title "bbb" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using ((2.4/$1)*3):3 title "cf3" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using ((2.4/$1)*5):4 title "ck" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using ((2.4/$1)*3):5 title "lue" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using ((2.4/$1)*3):6 title "rkmk3" w lp,\
	"sflow1680b7000x42000xf450a_ct.dat" using ((2.4/$1)*4):7 title "rkmk4" w lp

unset ylabel



set ylabel "logC_s"


plot "sflow1680b7000x42000xf450a_cs.dat" using ((2.4/$1)*6):2 title "bbb" w lp,\
	"sflow1680b7000x42000xf450a_cs.dat" using ((2.4/$1)*3):3 title "cf3" w lp,\
	"sflow1680b7000x42000xf450a_cs.dat" using ((2.4/$1)*5):4 title "ck" w lp,\
	"sflow1680b7000x42000xf450a_cs.dat" using ((2.4/$1)*3):5 title "lue" w lp,\
	"sflow1680b7000x42000xf450a_cs.dat" using ((2.4/$1)*3):6 title "rkmk3" w lp,\
	"sflow1680b7000x42000xf450a_cs.dat" using ((2.4/$1)*4):7 title "rkmk4" w lp

unset multiplot
