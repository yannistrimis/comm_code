reset
set term pngcairo size 2000, 1200 font ',10';
#set xrange [0.5:2.5]
#set yrange [0:*]

unset xtics

#set logscale y 10

set key top left

#set xtics 0.5,0.1, 1.1



set output 'plot_together_g1.png'
set multiplot layout 6,5 title "Observables vs. {/Symbol b} for {/Symbol g} = 1" font ', 16' margins 0.05,0.95,.05,.94 spacing 0.03,0




######################################### en ###############################################

set xrange [0.3:0.8]

#unset xlabel
#unset xtics
set ylabel "C_V (part. energy)"

set title "q = 2" font ', 14'
plot "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_en.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_en.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_en.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_en.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_en.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 7 ,\

unset ylabel
unset key
set xrange [0.6:1.0]

set title "q = 3" font ', 14'
plot "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_en.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_en.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_en.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_en.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_en.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 7 ,\

set xrange [0.7:1.1]
set title "q = 4" font ', 14'
plot "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_en.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_en.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_en.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_en.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_en.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 7 ,\

set xrange [0.6:1.6]
set title "q = 5" font ', 14'
plot "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_en.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_en.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_en.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_en.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_en.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 7 ,\
     
set xrange [0.6:2.5]
set title "q = 6" font ', 14'
plot "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_en.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_en.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_en.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_en.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_en.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_en.txt" using 1:4:5 notitle with errorbars lc 7 ,\

unset title
######################################### fullen ###############################################

set xrange [0.3:0.8]
set ylabel "C_V (full energy)"


plot "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 7 ,\

unset ylabel
set xrange [0.6:1.0]

plot "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 7 ,\

set xrange [0.7:1.1]
plot "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 7 ,\
     
set xrange [0.6:1.6]
plot "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 7 ,\
     
set xrange [0.6:2.5]
plot "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_fullen.txt" using 1:4:5 notitle with errorbars lc 7 ,\
     
     
######################################### mg0 ###############################################

set xrange [0.3:0.8]
set ylabel "{/Symbol c}_M (mg0)"

plot "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 7 ,\

unset ylabel
set xrange [0.6:1.0]

plot "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 7 ,\

set xrange [0.7:1.1]
plot "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 7 ,\
     
set xrange [0.6:1.6]
plot "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 7 ,\
     
set xrange [0.6:2.5]
plot "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_mg0.txt" using 1:4:5 notitle with errorbars lc 7 ,\


######################################### SF1 ###############################################

set xrange [0.3:0.8]
set ylabel "SF1"

plot "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 7 ,\


unset ylabel
set xrange [0.6:1.0]

plot "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 7 ,\

set xrange [0.7:1.1]
plot "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 7 ,\

set xrange [0.6:1.6]
plot "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 7 ,\

set xrange [0.6:2.5]
plot "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_SF1.txt" using 1:2:3 notitle with errorbars lc 7 ,\

     
     
######################################### Binder cumulant ###############################################
set xrange [0.3:0.8]
set ylabel "U_L (mg0)"

plot "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\
     
     
unset ylabel
set xrange [0.6:1.0]

plot "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\

set xrange [0.7:1.1]
plot "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\

set xrange [0.6:1.6]
plot "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\

set xrange [0.6:2.5]
plot "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_mg0_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\
     
     
######################################### Binder cumulant ###############################################

set xrange [0.3:0.8]
set xlabel "{/Symbol b}"
set xtics

set ylabel "U_L (mga)"

plot "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_2p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\
     
     
unset ylabel
set xrange [0.6:1.0]

plot "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_3p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\

set xrange [0.7:1.1]
plot "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_4p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\

set xrange [0.6:1.6]
plot "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_5p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\

set xrange [0.6:2.5]
plot "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "4x4" with lines lc 1 ,\
     "results/spinexto2_nd2_nl4_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 1 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "8x8" with lines lc 2 ,\
     "results/spinexto2_nd2_nl8_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 2 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "16x16" with lines lc 3 ,\
     "results/spinexto2_nd2_nl16_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 3 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "32x32" with lines lc 5 ,\
     "results/spinexto2_nd2_nl32_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 5 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2 title "64x64" with lines lc 7 ,\
     "results/spinexto2_nd2_nl64_id2_6p0000_1p0000_0p00_mga_bindercum.txt" using 1:2:3 notitle with errorbars lc 7 ,\



      
unset multiplot
