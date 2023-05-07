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
to_print = input()

tmin = int(str_tmin)
cur_dir = '/mnt/home/trimisio/plot_data/spec_data'

f_read = open('%s/l%s/%s_m1_%s_m2_%s_%s.fold.data'%(cur_dir,ens_name,pre_name,mass1,mass2,sinks),'r')
content = f_read.readlines()
f_read.close()
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
 
    y_cov = np.cov(y_arr)
    y_cov = y_cov / n_of_meas # NUMPY COV RETURNS COVARIANCE OF SAMPLE, 
    # WHEREAS WE NEED COVARIANCE OF THE MEAN
    y_av = np.average(y_arr,axis=1)   
#    p0 = dict(an=-800,En=1.2,ao=500,Eo=2.0) # OSCILLATING
    p0 = dict(an=500,En=0.5)
    fit0 = lsqfit.nonlinear_fit( data=(x,y_av,y_cov), prior=None, p0=p0, fcn=fitfcn0 )
    if to_print == 'yes' :
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
        err = np.sqrt(y_cov[i,i])
        if to_print == 'yes' :
            print(x[i],av,err)
    if to_print == 'yes' :
        print("== DISTANCES ==")
    for i in range(int(nt/2)-tmin+1) :
        av = y_av[i]
        err = np.sqrt(y_cov[i,i])
        quantity = ( av-fitfcn0(x[i],fit0.p).mean ) / err
        if to_print == 'yes' :
            print(x[i],quantity)

    if to_print == 'no' :
        print(tmin,fit0.chi2/fit0.dof,fit0.Q,fit0.p['En'].mean)


# =============== TWO STATE FIT =================

#    q0 = dict(an=fit0.pmean['an'], En=fit0.pmean['En'], ao=fit0.pmean['ao'], Eo=fit0.pmean['Eo'], an1=1.0, En1=1.0, ao1=1.0, Eo1=1.0,)
#    q0 = dict(an=fit0.pmean['an'], En=fit0.pmean['En'], an1=-300, En1=1.0 )
#    fit1 = lsqfit.nonlinear_fit( data=(x,y_av,y_cov), prior=None, p0=q0, fcn=fitfcn1 )
#    print('\n')
#    print('====== GROUND STATE + 1ST EXITED =======')
#    print('\ntmin = %d\n'%tmin)
#    print(fit1)
#    print('== FIT POINTS AND ERRORS ==')
#    for i in range(int(nt/2)-tmin+1) :
#        print( x[i],fitfcn1(x[i],fit1.p).mean,fitfcn1(x[i],fit1.p).sdev )
#    print('== MEASUREMENT AVERAGES AND ERRORS ==')
#    for i in range(int(nt/2)-tmin+1) :
#        av = y_av[i]
#        err = np.sqrt(y_cov[i,i])
#        print(x[i],av,err)
#    print("== DISTANCES ==")
#    for i in range(int(nt/2)-tmin+1) :
#        av = y_av[i]
#        err = np.sqrt(y_cov[i,i])
#        quantity = ( av-fitfcn1(x[i],fit1.p).mean ) / err
#        print(x[i],quantity)


# =============== THREE STATE FIT =================

#    s0 = ??? FOR OSCILLATING
#    s0 = dict(an=fit1.pmean['an'], En=fit1.pmean['En'], an1=fit1.pmean['an1'], En1=fit1.pmean['En1'], an2=1.0, En2=1.0)
#    fit2 = lsqfit.nonlinear_fit( data=(x,y_av,y_cov), prior=None, p0=s0, fcn=fitfcn2 )
#    print('\n')
#    print('====== GROUND STATE + 1ST EXITED + 2ND EXITED =======')
#    print('\ntmin = %d\n'%tmin)
#    print(fit2)
#    print('== FIT POINTS AND ERRORS ==')
#    for i in range(int(nt/2)-tmin+1) :
#        print( x[i],fitfcn2(x[i],fit2.p).mean,fitfcn2(x[i],fit2.p).sdev )
#    print('== MEASUREMENT AVERAGES AND ERRORS ==')
#    for i in range(int(nt/2)-tmin+1) :
#        av = y_av[i]
#        err = np.sqrt(y_cov[i,i])
#        print(x[i],av,err)
#    print("== DISTANCES ==")
#    for i in range(int(nt/2)-tmin+1) :
#        av = y_av[i]
#        err = np.sqrt(y_cov[i,i])
#        quantity = ( av-fitfcn2(x[i],fit2.p).mean ) / err
#        print(x[i],quantity)



def fitfcn0(x,p) :
#    return p['an']*( np.exp(-p['En']*x)+np.exp(-p['En']*(nt-x)) ) + (-1)**x*p['ao']*( np.exp(-p['Eo']*x)+np.exp(-p['Eo']*(nt-x)) )
    return p['an']*( np.exp(-p['En']*x)+np.exp(-p['En']*(nt-x)) )

# def fitfcn1(x,q) :
#    return q['an']*( np.exp(-q['En']*x)+np.exp(-q['En']*(nt-x)) ) + (-1)**x*q['ao']*( np.exp(-q['Eo']*x)+np.exp(-q['Eo']*(nt-x)) ) + q['an1']*( np.exp(-q['En1']*x)+np.exp(-q['En1']*(nt-x)) ) + (-1)**x*q['ao1']*( np.exp(-q['Eo1']*x)+np.exp(-q['Eo1']*(nt-x)) ) 
#    return q['an']*( np.exp(-q['En']*x)+np.exp(-q['En']*(nt-x)) ) + q['an1']*( np.exp(-q['En1']*x)+np.exp(-q['En1']*(nt-x)) )

# def fitfcn2(x,s) :
#    return ??? OSCILLATING STATE
#    return s['an']*( np.exp(-s['En']*x)+np.exp(-s['En']*(nt-x)) ) + s['an1']*( np.exp(-s['En1']*x)+np.exp(-s['En1']*(nt-x)) ) + s['an2']*( np.exp(-s['En2']*x)+np.exp(-s['En2']*(nt-x)) )


if __name__ == '__main__' :
    main()
