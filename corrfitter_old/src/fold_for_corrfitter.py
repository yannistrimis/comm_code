import numpy as np

nt = 32

f_read = open('/home/trimis/hpcc/plot_data/spec_data/l1632b6850x100a/specnlpi_m1_0.01576_m2_0.01576_PION_05.data','r')
f_write = open('/home/trimis/hpcc/plot_data/spec_data/l1632b6850x100a/specnlpi_m1_0.01576_m2_0.01576_PION_05.corrfitterfold.data','w')

content = f_read.readlines()

for i_line in range(len(content)) :

    line = content[i_line]
    line_strip = line.strip('\n')
    line_split = line_strip.split(' ')

    f_write.write( '%s'%(line_split[0]) )
    f_write.write( ' %s'%(line_split[1]) )

    for i_time in range(1,int(nt/2)) :
        val = 0.5*( float(line_split[i_time+1]) + float(line_split[nt-i_time+1]) )
        f_write.write( ' %.16f'%(val) )

    f_write.write( ' %s'%(line_split[int(nt/2)+1]) )

    for i_time in range(int(nt/2+1),nt) :
        val = 0.5*( float(line_split[i_time+1]) + float(line_split[nt-i_time+1]) )
        f_write.write( ' %.16f'%(val) )
    f_write.write('\n')



f_read.close()
f_write.close()
