import numpy as np
import sys
sys.path.insert(0, '../../..')

from python_funcs import *

my_dir = '/home/trimis/data/pure_u1/wilson_loop' # CMSE DESKTOP

nx = 16
nt = 16

beta_arr=['0250'] #,'0500','0750','1000','1250']

stream='a'

rr_arr = ['1'] #,'2','3','4','5','6']
tt_arr = ['1','2','3','4','5','6','7','8']

firstlat = 101
lastlat = 200

n_of_lat = lastlat - firstlat + 1

nbins = 20

for beta in beta_arr :
    for rr in rr_arr :
        f_write = open( '%s/wloop_data/l%s%sb%s_r%s.ratios'%(my_dir,nx,nt,beta,rr), 'w' )
        for tt in tt_arr :
            data_arr = np.zeros(n_of_lat)

            f_read = open( '%s/l%s%sb%s%s/wloop_r%st%s.data'%(my_dir,nx,nt,beta,stream,rr,tt), 'r' )
            lines = f_read.readlines()
            f_read.close()
            i_lat = -1
            for line in lines :
                i_lat = i_lat + 1
                line = line.strip()
                line = line.split(' ')
                data_arr[i_lat] = float(line[0])
