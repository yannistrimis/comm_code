# 4 SPACES INSTEAD OF TAB
import numpy as np

cur_dir = '/mnt/home/trimisio/outputs/pure_gauge_spec'
nx=16
nt=16
vol = str(nx)+str(nt)
beta = '7000'
x0 = '100'
stream = 'a'
i_file = input() # FILE NUMBER
i_source = input() # a OR b
ens_name = vol+'b'+beta+'x'+x0+stream

out_dir = '/mnt/home/trimisio/plot_data/spec_data'

f_write = open('%s/l%s/folded_spec%s.lat.%s%s'%(out_dir,ens_name,ens_name,i_file,i_source),'w')
f_read = open('%s/l%s/clean_spec%s.lat.%s%s'%(cur_dir,ens_name,ens_name,i_file,i_source),'r')

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
