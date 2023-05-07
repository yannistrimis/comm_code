reset

set term pngcairo
set output "meff_specnd_m1_0.01576_m2_0.01576_RHO_i0.png"
set title "meff_specnd_m1_0.01576_m2_0.01576_RHO_i0"
set xrange[0:7]
set yrange[0.5:2.0]


f(x) = 0.698073
fpp(x) = f(x) + 0.0150785
fmm(x) = f(x) - 0.0150785

g(x) = 1.30706
gpp(x) = g(x) + 0.198273
gmm(x) = g(x) - 0.198273


plot "test_maezawa.data" u 1:2 w lp lw 2 pt 4 title "NON OSCILLATING", "test_maezawa.data" u 1:3 w lp lw 2 pt 4 title "OSCILLATING", \
f(x) lt 3 notitle, fpp(x) lt 3 notitle, fmm(x) lt 3 notitle, g(x) lt 3 notitle, gpp(x) lt 3 notitle, gmm(x) lt 3 notitle


reset
