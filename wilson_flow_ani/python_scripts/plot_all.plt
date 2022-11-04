set logscale
set tics font "Helvetica,30"
plot "ct.dat" using ((2.4/$1)*6):2 w lp, "ct.dat" using ((2.4/$1)*3):3 w lp,"ct.dat" using ((2.4/$1)*5):4 w lp,"ct.dat" using ((2.4/$1)*3):5 w lp,"ct.dat" using ((2.4/$1)*3):6 w lp,"ct.dat" using ((2.4/$1)*4):7 w lp

#pause 5
pause -1

