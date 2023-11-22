from __future__ import print_function
import lsqfit
import numpy as np
from python_funcs import *

# my_dir = '/home/yannis/Physics/LQCD/projects/dark_coupling/data' # LAPTOP
my_dir = '/home/trimis/data/pure_u1/wilson_loop' # CMSE DESKTOP

nx = 16
nt = 16
beta = 200
stream = 'a'

n_of_lat = 60 # HOW MANY WE WANT TO KEEP

tt_arr = np.array([5.0,6.0,7.0,8.0])
tt_name_arr = ['5','6','7','8']
len_tt = len(tt_arr)

rr = input()

def main() :
    y_arr = np.zeros((len_tt,n_of_lat))
    for i_tt in range(len_tt) :
        tt = tt_name_arr[i_tt]
        y_all = np.loadtxt('%s/l%d%db%d%s/wl_r%s_t%s.log.re.data'%(my_dir,nx,nt,beta,stream,rr,tt), dtype=float)
        n_total = len(y_all)
        y_arr[i_tt,:] = y_all[(n_total-n_of_lat):n_total]

    y_cov = np.cov(y_arr)
    y_cov = y_cov / n_of_lat # NUMPY COV RETURNS COVARIANCE OF SAMPLE, 
    # WHEREAS WE NEED COVARIANCE OF THE MEAN
    y_av = np.average(y_arr,axis=1) 
    # for i_tt in range(len_tt) :
        # print( tt_arr[i_tt], y_av[i_tt], np.sqrt(y_cov[i_tt,i_tt]) )
    
    p1 = dict(v_r=1.0,c_r=1.0)

    fit1 = lsqfit.nonlinear_fit( data=(tt_arr,y_av,y_cov), prior=None, p0=p1, fcn=fitfcn1 )
    # print(fit1)
    print( rr, fit1.p['v_r'].mean, fit1.p['v_r'].sdev, fit1.p['c_r'].mean, fit1.p['c_r'].sdev )
 
def fitfcn1(t,p) : 
    return -p['v_r']*t + p['c_r']



if __name__ == '__main__' :
    main()
