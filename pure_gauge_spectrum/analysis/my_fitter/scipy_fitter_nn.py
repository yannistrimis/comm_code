### FOUR SPACES INSTEAD OF TAB ###
import numpy as np
from scipy.optimize import curve_fit
from python_funcs import *

str_nx = input()
str_nt = input()
beta = input()
x0 = input()
stream = input()
mass1 = input()
mass2 = input()
sinks = input()
pre_name = input()
str_tmin = input()
str_tmax = input()
str_an = input()
str_En = input()
str_a1n = input()
str_E1n = input()
to_print = input()

nt = int(str_nt)
vol = str_nx + str_nt
ens_name = vol+'b'+beta+'x'+x0+stream
tmin = int(str_tmin)
tmax = int(str_tmax)

an_start = float(str_an)
En_start = float(str_En)
a1n_start = float(str_a1n)
E1n_start = float(str_E1n)


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
    y_sdev = np.sqrt(np.diag(y_cov))
    # WHEREAS WE NEED COVARIANCE OF THE MEAN
    y_av = np.average(y_arr,axis=1)   

    p0 = np.array([an_start,En_start])
    popt, pcov = curve_fit(f10, x, y_av, p0=p0, sigma=y_cov, full_output=False, method='trf')

    an_sdev = np.sqrt(pcov[0,0])
    En_sdev = np.sqrt(pcov[1,1])

    an = popt[0]
    En = popt[1]

    p1 = np.array([an,En,a1n_start,E1n_start])
    popt1, pcov1 = curve_fit(f20, x, y_av, p0=p1, sigma=y_cov, full_output=False, method='trf')

    an_sdev = np.sqrt(pcov1[0,0])
    En_sdev = np.sqrt(pcov1[1,1])
    a1n_sdev = np.sqrt(pcov1[2,2])
    E1n_sdev = np.sqrt(pcov1[3,3])

    an = popt1[0]
    En = popt1[1]
    a1n = popt1[2]
    E1n = popt1[3]

    fit_points = np.zeros(tmax+1-tmin)
    for i in range(tmax+1-tmin):
        fit_points[i] = f20(x[i],an,En,a1n,E1n)

    dof = tmax + 1 - tmin - 4

    chi2dof = chisq_by_dof(y_av,fit_points,y_cov,dof)
    q_val = q_value(chi2dof,dof)


    if to_print == 'yes' :
        print('FIT TYPE: non  tmin = %d  tmax = %d\n'%(tmin,tmax))
        print('STARTING VALUES FOR no:\n')
        print(p0,'\n')
        print('STARTING VALUES FOR non:\n')
        print(p1,'\n')

        print('an = ', an,' +- ',an_sdev)
        print('En = ', En,' +- ',En_sdev)
        print('a1n = ', a1n,' +- ',a1n_sdev)
        print('E1n = ', E1n,' +- ',E1n_sdev)
 
        print('\n')

        print('chisquare/dof = ',chi2dof,'  Q = ',q_val,'\n')
        print('# t, meas_points, err_meas_points, fit_points, distances')
        for i in range(tmax+1-tmin):
            print(x[i], y_av[i], y_sdev[i], fit_points[i], (y_av[i]-fit_points[i])/y_sdev[i]) 
    
    elif to_print == 'no' :
        print(tmin,tmax,chi2dof,q_val,En,En_sdev,E1n,E1n_sdev)


def f10(x,an,En) :
    return an*( np.exp(-En*x)+np.exp(-En*nt+En*x) ) 


def f20(x,an,En,a1n,E1n) :
    res = an*( np.exp(-En*x)+np.exp(-En*nt+En*x) )
    res = res + a1n*( np.exp(-E1n*x)+np.exp(-E1n*nt+E1n*x) ) 
    return res

if __name__ == '__main__' :
    main()

