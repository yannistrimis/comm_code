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

f_read = open('%s/l%s/m1_%s_m2_%s_%s_%s_%s.fold.data'%(cur_dir,ens_name,mass1,mass2,sinks,source1,source2),'r')
content = f_read.readlines()
f_read.close()
tmin = 3
n_of_meas = len(content)
x = np.zeros(int(nt/2)-tmin+1)
for i in range(int(nt/2)-tmin+1) :
    x[i] = float(i) + tmin

def main() :
    y_arr = np.zeros(( int(nt/2)-tmin+1, n_of_meas ))

    for kk in range(n_of_meas) :
        line = content[kk].split(' ')
        for i in range(int(nt/2)-tmin+1) :
            y_arr[i,kk] = float(line[i+1+tmin])
 
    y_std = np.std(y_arr,axis=1)
    y_stda = y_std/200
    y_stdb = y_std/199
    print(y_stda)
    print(y_stdb)
    y_av = np.average(y_arr,axis=1)   
    print(y_av)
#    p0 = dict(an=-200,En=0.5,ao=150,Eo=0.5)
    p0 = dict(an=500,En=0.5)
    fit0 = lsqfit.nonlinear_fit( data=(x,y_av,y_std), prior=None, p0=p0, fcn=fitfcn0 )
    print('\n')
    print('====== GROUND STATE ONLY =======')
    print('\ntmin = %d\n'%tmin)
    print(fit0)
    print('== FIT POINTS AND ERRORS ==')
    for i in range(int(nt/2)-tmin+1) :
        print( x[i],fitfcn0(x[i],fit0.p).mean,fitfcn0(x[i],fit0.p).sdev )
    print('== MEASUREMENT AVERAGES AND ERRORS ==')
    for i in range(int(nt/2)-tmin+1) :
        av = y_av[i]
        err = y_std[i]
        print(x[i],av,err)
    print("== DISTANCES ==")
    for i in range(int(nt/2)-tmin+1) :
        av = y_av[i]
        err = y_std[i]
        quantity = ( av-fitfcn0(x[i],fit0.p).mean ) / err
        print(x[i],quantity)

# =============== TWO STATE FIT =================

#   q0 = ??? FOR OSCILLATING
    q0 = dict(an=fit0.pmean['an'], En=fit0.pmean['En'], an1=-300, En1=1.0 )
    fit1 = lsqfit.nonlinear_fit( data=(x,y_av,y_std), prior=None, p0=q0, fcn=fitfcn1 )
    print('\n')
    print('====== GROUND STATE + 1ST EXITED =======')
    print('\ntmin = %d\n'%tmin)
    print(fit1)
    print('== FIT POINTS AND ERRORS ==')
    for i in range(int(nt/2)-tmin+1) :
        print( x[i],fitfcn1(x[i],fit1.p).mean,fitfcn1(x[i],fit1.p).sdev )
    print('== MEASUREMENT AVERAGES AND ERRORS ==')
    for i in range(int(nt/2)-tmin+1) :
        av = y_av[i]
        err = y_std[i]
        print(x[i],av,err)
    print("== DISTANCES ==")
    for i in range(int(nt/2)-tmin+1) :
        av = y_av[i]
        err = y_std[i]
        quantity = ( av-fitfcn1(x[i],fit1.p).mean ) / err
        print(x[i],quantity)





def fitfcn0(x,p) :
#    return p['an']*( np.exp(-p['En']*x)+np.exp(-p['En']*(nt-x)) ) + (-1)**x*p['ao']*( np.exp(-p['Eo']*x)+np.exp(-p['Eo']*(nt-x)) )
    return p['an']*( np.exp(-p['En']*x)+np.exp(-p['En']*(nt-x)) )

def fitfcn1(x,q) :
#   return ??? OSCILLATING STATE 
    return q['an']*( np.exp(-q['En']*x)+np.exp(-q['En']*(nt-x)) ) + q['an1']*( np.exp(-q['En1']*x)+np.exp(-q['En1']*(nt-x)) )

if __name__ == '__main__' :
    main()
