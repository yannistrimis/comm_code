### FOUR SPACES INSTEAD OF TAB ###
from __future__ import print_function
import numpy as np
import lsqfit
from python_funcs import *

nx = 16
nt = 16
vol = str(nx) + str(nt)
beta = '7000'
x0 = '100'
stream = 'a'
ens_name = vol+'b'+beta+'x'+x0+stream

mass1 = input()
mass2 = input()
source1 = input()
source2 = input()
sinks = input()

cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

f_read = open('%s/l%s/m1_%s_m2_%s_%s_%s_%s.data'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2),'r')
content = f_read.readlines()
f_read.close()
tmin = 1
tmax = 15
n_of_meas = len(content)
x = np.zeros(tmax-tmin+1)
for i in range(tmax-tmin+1) :
    x[i] = float(i) + tmin

def main() :
    y_arr = np.zeros(( tmax-tmin+1,n_of_meas ))

    for kk in range(n_of_meas) :
        line = content[kk].split(' ')
        for i in range(tmax-tmin+1) :
            y_arr[i,kk] = float(line[i+1+tmin])
 
    y_cov = np.cov(y_arr)
    y_av = np.average(y_arr,axis=1)   
    p0 = dict(an=-200,En=0.5,ao=150,Eo=0.5)
#    p0 = dict(an=594,En=0.42)

    fit = lsqfit.nonlinear_fit(data=(x,y_av,y_cov), prior=None, p0=p0, fcn=fitfcn)
    print('\ntmin = %d   tmax = %d\n'%(tmin,tmax))
    print(fit)
    print('========FIT POINTS AND ERRORS=========')
    for i in range(tmax-tmin+1) :
        print( x[i],fitfcn(x[i],fit.p).mean,fitfcn(x[i],fit.p).sdev )
    print('========MEASUREMENT AVERAGES AND ERRORS=========')
    for i in range(tmax-tmin+1) :
        av = y_av[i]
        err = np.sqrt(y_cov[i,i])
        print(x[i],av,err)
    print("===========DISTANCES============")
    for i in range(tmax-tmin+1) :
        av = y_av[i]
        err = np.sqrt(y_cov[i,i])
        quantity = ( av-fitfcn(x[i],fit.p).mean )**2 / err**2
        print(x[i],quantity)

def fitfcn(x,p) :
    return p['an']*( np.exp(-p['En']*x)+np.exp(-p['En']*(nt-x)) ) + (-1)**x*p['ao']*( np.exp(-p['Eo']*x)+np.exp(-p['Eo']*(nt-x)) )
#    return p['an']*( np.exp(-p['En']*x)+np.exp(-p['En']*(nt-x)) )

if __name__ == '__main__' :
    main()
