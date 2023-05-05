### FOUR SPACES INSTEAD OF TAB ###
from __future__ import print_function
import gvar as gv
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
str_san = input()
str_En = input()
str_sEn = input()
str_ao = input()
str_sao = input()
str_Eo = input()
str_sEo = input()
str_a1n = input()
str_sa1n= input()
str_E1n = input()
str_sE1n = input()
to_print = input()

gvan = str_an+'('+str_san+')'
gvEn = str_En+'('+str_sEn+')'
gvao = str_ao+'('+str_sao+')'
gvEo = str_Eo+'('+str_sEo+')'

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

    prior0 = gv.gvar(dict(an=gvan,En=gvEn,ao=gvao,Eo=gvEo))
    fit0 = lsqfit.nonlinear_fit( data=(x,y_av,y_cov), prior=prior0, p0=None, fcn=fitfcn0 )

    kvan = str(fit0.pmean['an']) + '(' + str_san + ')'
    kvEn = str(fit0.pmean['En']) + '(' + str_sEn + ')'
    kvao = str(fit0.pmean['ao']) + '(' + str_sao + ')'
    kvEo = str(fit0.pmean['Eo']) + '(' + str_sEo + ')'
    kva1n = str_a1n + '(' + str_sa1n + ')'
    kvE1n = str_E1n + '(' + str_sE1n + ')'

    prior1 = gv.gvar(dict(an=kvan,En=kvEn,ao=kvao,Eo=kvEo,a1n=kva1n,E1n=kvE1n))
    fit1 = lsqfit.nonlinear_fit( data=(x,y_av,y_cov), prior=prior1, p0=None, fcn=fitfcn1 )

    if to_print == 'yes' :
        print('\n')
        print('====== n+o+n =======')
        print('\ntmin = %d, tmax = %d\n'%(tmin,tmax))
        print(fit1)
        print('== FIT POINTS AND ERRORS ==')
        for i in range(tmax+1-tmin) :
            print( x[i],fitfcn1(x[i],fit1.p).mean,fitfcn1(x[i],fit1.p).sdev )
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
        quantity = ( av-fitfcn1(x[i],fit1.p).mean ) / err
        if to_print == 'yes' :
            print(x[i],quantity)

    if to_print == 'no' :
        print(tmin,tmax,fit0.chi2/fit0.dof,fit0.Q,fit1.pmean['En'],fit1.psdev['En'],fit1.pmean['Eo'],fit1.psdev['Eo'],fit1.pmean['E1n'],fit1.psdev['E1n'])


def fitfcn0(x,p) :
    return p['an']*( np.exp(-p['En']*x)+np.exp(-p['En']*(nt-x)) ) + (-1)**x*p['ao']*( np.exp(-p['Eo']*x)+np.exp(-p['Eo']*(nt-x)) )

def fitfcn1(x,p) :
    return p['an']*( np.exp(-p['En']*x)+np.exp(-p['En']*(nt-x)) ) + (-1)**x*p['ao']*( np.exp(-p['Eo']*x)+np.exp(-p['Eo']*(nt-x)) ) \
    + p['a1n']*( np.exp(-p['E1n']*x)+np.exp(-p['E1n']*(nt-x)) ) 


if __name__ == '__main__' :
    main()

