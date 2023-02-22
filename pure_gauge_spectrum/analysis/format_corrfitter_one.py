# 4 SPACES INSTEAD OF TAB
import numpy as np

out_dir = '/mnt/home/trimisio/plot_data/spec_data'
nx=16
nt=16
vol = str(nx)+str(nt)
beta = '7000'
x0 = '100'
stream = 'a'

mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinks = input()

ens_name = vol+'b'+beta+'x'+x0+stream

f_write = open('%s/l%s/m1_%s_m2_%s_%s_%s_%s.data'%(out_dir,ens_name,mass1,mass2,sinks,source1,source2),'w')

for i_file in range(101,301):
    f_read = open('%s/l%s/spec_m1_%s_m2_%s_%s_%s_%s.%d'%(out_dir,ens_name,mass1,mass2,sinks,source1,source2,i_file),'r')
    content = f_read.readlines()

    f_write.write( '%s'%(sinks) )
    for i_line in range(len(content)) :
        split = content[i_line].split(' ')
        f_write.write( ' %s'%(split[1]) )
    f_write.write('\n')
    f_read.close()

f_write.close()

