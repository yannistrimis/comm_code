import numpy as np
from python_funcs import *

my_dir = '/home/yannis/Physics/LQCD/projects/dark_coupling/data' # LAPTOP

nx = 16
nt = 16
beta = 200
stream = 'a'
f_read = open('%s/l%d%db%d%s/wl_r_2_4_6_t_2_3_4_5_6.data'%(my_dir,nx,nt,beta,stream),'r')
content = f_read.readlines()

n_of_lat = 60
nbins = 10

for rr in ['2','4','6'] :
    for tt in ['2','3','4','5','6'] :
        


f_read.close()