# 4 SPACES INSTEAD OF TAB
import numpy as np

str_nt = input()
ens_name = input()
pre_name = input()
i_file = input()
out_name = input()

nt = int(str_nt)

# out_dir = '/mnt/home/trimisio/plot_data/spec_data' # ICER

out_dir = '/home/trimisio/all/spec_data' # FNAL


f_write = open('%s/l%s/%s.%s'%(out_dir,ens_name,out_name,i_file),'w')
f_read = open('%s/l%s/%s.%s'%(out_dir,ens_name,pre_name,i_file),'r')

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
