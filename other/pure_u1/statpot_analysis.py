import numpy as np
from python_funcs import *

# my_dir = '/home/yannis/Physics/LQCD/projects/dark_coupling/data' # LAPTOP
my_dir = '/home/trimis/data/pure_u1/wilson_loop' # CMSE DESKTOP

nx = 16
nt = 16
beta = 200
stream = 'a'

n_of_lat = 60 # HOW MANY WE WANT TO KEEP
nbins = 10

rr_arr = ['1','2','3','4','5','6']
tt_arr = ['5','6','7','8']

vr_av_arr = np.zeros(len(rr_arr))
vr_err_arr = np.zeros(len(rr_arr))

i_rr = -1
for rr in rr_arr :
    
    i_rr = i_rr + 1
    
    vr_av = 0.0
    vr_err = 0.0

    for 














    vr_av_arr[i_rr] = vr_av
    vr_err_arr[i_rr] = vr_err
