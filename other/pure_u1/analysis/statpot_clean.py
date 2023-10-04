import numpy as np
from python_funcs import *

# my_dir = '/home/yannis/Physics/LQCD/projects/dark_coupling/data' # LAPTOP
my_dir = '/home/trimis/data/pure_u1/wilson_loop' # CMSE DESKTOP

nx = 16
nt = 16
beta = 200
stream = 'a'
f_read = open('%s/l%d%db%d%s/wl_r123456_t12345678.data'%(my_dir,nx,nt,beta,stream),'r')
content = f_read.readlines()
f_read.close()
rr_arr = ['1','2','3','4','5','6']
tt_arr = ['1','2','3','4','5','6','7','8']


i_col = 0
for rr in rr_arr : 
    for tt in tt_arr :        

        f_write_log = open('%s/l%d%db%d%s/wl_r%s_t%s.log.re.data'%(my_dir,nx,nt,beta,stream,rr,tt),'w')
        f_write = open('%s/l%d%db%d%s/wl_r%s_t%s.re.data'%(my_dir,nx,nt,beta,stream,rr,tt),'w')
        
        i_col = i_col + 2
        for i_line in range(len(content)) :
            line = content[i_line].split(' ')
            value = float(line[i_col])
            value_log = np.log(value)
            f_write_log.write('%lf\n'%value_log)
            f_write.write('%lf\n'%value)
        
        f_write_log.close()
        f_write.close()

