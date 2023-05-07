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


f_write = open('%s/l%s/%s_foldspec_m1_%s_m2_%s_%s.%s'%(out_dir,ens_name,pre_name,mass1,mass2,sinks,i_file),'w')
f_read = open('%s/l%s/%s_spec_m1_%s_m2_%s_%s.%s'%(out_dir,ens_name,pre_name,mass1,mass2,sinks,i_file),'r')

content = f_read.readlines()
re = 0.0
im = 0.0
flag = 0
for i_line in range(len(content)) :
    split = content[i_line].split(' ')
    if split[0] == '0' :
        re = float(split[1])
        im = float(split[2])
        flag = 1
        f_write.write('%s %.16f %.16f\n'%(split[0],re,im))
    elif split[0] == str(int(nt/2)) :
        re = float(split[1])
        im = float(split[2])
        flag = 0
        f_write.write('%s %.16f %.16f\n'%(split[0],re,im))
    elif flag == 1 :
        split2 = content[ i_line+nt-2*int(split[0]) ].split(' ')
        re = ( float(split[1]) + float(split2[1]) ) / 2   
        im = ( float(split[2]) + float(split2[2]) ) / 2
        f_write.write('%s %.16f %.16f\n'%(split[0],re,im))

f_write.close()
f_read.close()
