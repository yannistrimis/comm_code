### FOUR SPACES INSTEAD OF TAB ###
from __future__ import print_function
import numpy as np
import lsqfit
from python_funcs import *

nx = 16
nt = 32
vol = str(nx) + str(nt)
beta = '6850'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinks = input()
pre_name = input()
str_tmin = input()
str_tmax = input()
str_an = input()
str_En = input()
str_ao = input()
str_Eo = input()
to_print = input()


tmin = int(str_tmin)
tmax = int(str_tmax)
cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

f_read = open('%s/l%s/%s_m1_%s_m2_%s_%s.fold.data'%(cur_dir,ens_name,pre_name,mass1,mass2,sinks),'r')
content = f_read.readlines()
f_read.close()
n_of_meas = len(content)
x = np.zeros(tmax+1-tmin)
for i in range(tmax+1-tmin) :
    x[i] = float(i) + tmin

def main() :

    y_arr = np.zeros(( tmax+1-tmin, n_of_meas ))

    for kk in range(n_of_meas) :
        line = content[kk].split(' ')
        for i in range(tmax+1-tmin) :
            y_arr[i,kk] = float(line[i+tmin+1])
 
    y_cov = np.cov(y_arr)
    y_cov = y_cov / n_of_meas # NUMPY COV RETURNS COVARIANCE OF SAMPLE, 
    # WHEREAS WE NEED COVARIANCE OF THE MEAN
    y_av = np.average(y_arr,axis=1)   
    p0 = dict(an=float(str_an),En=float(str_En),ao=float(str_ao),Eo=float(str_Eo)) # OSCILLATING
    fit0 = lsqfit.nonlinear_fit( data=(x,y_av,y_cov), prior=None, p0=p0, fcn=fitfcn0 )
    if to_print == 'yes' :
        print('\n')
        print('====== n+o =======')
        print('\ntmin = %d, tmax = %d\n'%(tmin,tmax))
        print(fit0)
        print('== FIT POINTS AND ERRORS ==')
        for i in range(tmax+1-tmin) :
            print( x[i],fitfcn0(x[i],fit0.p).mean,fitfcn0(x[i],fit0.p).sdev )
        print('== MEASUREMENT AVERAGES AND ERRORS ==')
    
    for i in range(tmax+1-tmin) :
        av = y_av[i]
        err = np.sqrt(y_cov[i,i])
        if to_print == 'yes' :
            print(x[i],av,err)
    if to_print == 'yes' :
        print("== DISTANCES ==")
    for i in range(tmax+1-tmin) :
        av = y_av[i]
        err = np.sqrt(y_cov[i,i])
        quantity = ( av-fitfcn0(x[i],fit0.p).mean ) / err
        if to_print == 'yes' :
            print(x[i],quantity)

    if to_print == 'no' :
        print(tmin,tmax,fit0.chi2/fit0.dof,fit0.Q,fit0.p['En'].mean,fit0.p['En'].sdev,fit0.p['Eo'].mean,fit0.p['Eo'].sdev)


def fitfcn0(x,p) :
    return p['an']*( np.exp(-p['En']*x)+np.exp(-p['En']*(nt-x)) ) + (-1)**x*p['ao']*( np.exp(-p['Eo']*x)+np.exp(-p['Eo']*(nt-x)) )


if __name__ == '__main__' :
    main()
