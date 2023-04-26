# 4 SPACES INSTEAD OF TAB
import numpy as np

out_dir = '/mnt/home/trimisio/plot_data/spec_data'
nx=16
nt=32
vol = str(nx)+str(nt)
beta = '6850'
x0 = '100'
stream = 'a'

mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinks = input()
pre_name = input()

first_file = 101
last_file = 400

ens_name = vol+'b'+beta+'x'+x0+stream

f_write = open('%s/l%s/%s_m1_%s_m2_%s_%s.fold.data'%(out_dir,ens_name,pre_name,mass1,mass2,sinks),'w')

for i_file in range(first_file,last_file+1):
    f_read = open('%s/l%s/%s_foldspec_m1_%s_m2_%s_%s.%d'%(out_dir,ens_name,pre_name,mass1,mass2,sinks,i_file),'r')
    content = f_read.readlines()
    f_write.write( 'PROP' )
    for i_line in range(len(content)) :
        split = content[i_line].split(' ')
        f_write.write( ' %s'%(split[1]) )
    f_write.write('\n')
    f_read.close()

f_write.close()

print("first file: %d\nlast file: %d"%(first_file,last_file) )
