# 4 SPACES INSTEAD OF TAB
import numpy as np

out_dir = '/mnt/home/trimisio/plot_data/spec_data'
nx=16
nt=32
vol = str(nx)+str(nt)
beta = '6850'
x0 = '100'
stream = 'a'

i_file = input() # FILE NUMBER
mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinks = input()
pre_name = input()

ens_name = vol+'b'+beta+'x'+x0+stream

f_write = open('%s/l%s/%s_spec_m1_%s_m2_%s_%s.%s'%(out_dir,ens_name,pre_name,mass1,mass2,sinks,i_file),'w')
f_read_a = open('%s/l%s/%s_spec_m1_%s_m2_%s_%s.%sa'%(out_dir,ens_name,pre_name,mass1,mass2,sinks,i_file),'r')
f_read_b = open('%s/l%s/%s_spec_m1_%s_m2_%s_%s.%sb'%(out_dir,ens_name,pre_name,mass1,mass2,sinks,i_file),'r')

content_a = f_read_a.readlines()
content_b = f_read_b.readlines()

for i_line in range(len(content_a)) :
    re = 0.0
    im = 0.0

    split_a = content_a[i_line].split(' ')
    split_b = content_b[i_line].split(' ')

    re = 0.5*( float(split_a[1]) + float(split_b[1]) )
    im = 0.5*( float(split_a[2]) + float(split_b[2]) )

    f_write.write('%s %.16f %.16f\n'%(split_a[0],re,im))

f_write.close()
f_read_a.close()
f_read_b.close()

