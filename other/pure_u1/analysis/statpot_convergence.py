import numpy as np
from python_funcs import *

# my_dir = '/home/yannis/Physics/LQCD/projects/dark_coupling/data' # LAPTOP
my_dir = '/home/trimis/data/pure_u1/wilson_loop' # CMSE DESKTOP

nx = 16
nt = 16
beta = 200
stream = 'a'

rr_arr = ['1','2','3','4','5','6']
tt_arr = ['1','2','3','4','5','6','7','8']

n_of_lat = 60 # HOW MANY WE WANT TO KEEP
nbins = 10

for rr in rr_arr :
    f_write = open('%s/l%d%db%d%s/wl_r%s.ratios'%(my_dir,nx,nt,beta,stream,rr),'w')
    aver_arr = np.zeros(len(tt_arr))
    i_av = -1
    for tt in tt_arr :
        i_av = i_av + 1
        data_arr = np.zeros(n_of_lat)
        data_arr_all = np.loadtxt('%s/l%d%db%d%s/wl_r%s_t%s.re.data'%(my_dir,nx,nt,beta,stream,rr,tt), dtype=float)
        n_total = len(data_arr_all)
        if n_of_lat > n_total :
            print('WARNING: NUMBER OF KEPT MEASUREMENTS LARGER THAN NUMBER OF TOTAL MEASUREMENTS')
        data_arr = data_arr_all[(n_total-n_of_lat):n_total]
        aver_arr[i_av] = jackknife(data_arr,nbins,'average')
    
    
    for i_tt in range( len(tt_arr)-1 ) :
        time = 0.5*( float(tt_arr[i_tt+1])+float(tt_arr[i_tt]) )
        ratio = aver_arr[i_tt+1]/aver_arr[i_tt]
        f_write.write('%lf %lf\n'%(time,ratio))
    f_write.close()





