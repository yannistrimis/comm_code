set key top left
set yrange [0:2]
plot "/mnt/home/trimisio/plot_data/spec_data/l1632b6850x100a/specnd_m1_0.01576_m2_0.01576_PION_05.non.scanfit" u 1:5:6 w err title "NON OSC", "/mnt/home/trimisio/plot_data/spec_data/l1632b6850x100a/specnd_m1_0.01576_m2_0.01576_PION_05.non.scanfit" u 1:7:8 w err title "OSC", "/mnt/home/trimisio/plot_data/spec_data/l1632b6850x100a/specnd_m1_0.01576_m2_0.01576_PION_05.non.scanfit" u 1:9:10 w err title "NON OSC 2"

