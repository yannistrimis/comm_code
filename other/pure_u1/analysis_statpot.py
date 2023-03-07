import numpy as np
from python_funcs import *

my_dir = '/home/trimis/data/pure_u1/wilson_loop' # DESKTOP CMSE

nx = 16
nt = 16
beta = 100
stream = 'a'
f_read = open('%s/l%d%db%d%s/wl_r_2_4_6_t_2_3_4_5_6.data'%(my_dir,nx,nt,beta,stream),'r')
content = f_read.readlines()

n_of_lat = 60



f_read.close()