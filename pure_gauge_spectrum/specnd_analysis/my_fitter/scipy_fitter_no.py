### FOUR SPACES INSTEAD OF TAB ###
import numpy as np
from scipy.optimize import curve_fit
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

an_start = float(str_an)
En_start = float(str_En)
ao_start = float(str_ao)
Eo_start = float(str_Eo)

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

    p0 = np.array([an_start,En_start,ao_start,Eo_start])
    print('STARTING VALUES:\n')
    print(p0,'\n')

    popt, pcov = curve_fit(f11, x, y_av, p0=p0, sigma=y_cov, full_output=False, method='trf')

    an_sdev = np.sqrt(pcov[0,0])
    En_sdev = np.sqrt(pcov[1,1])
    ao_sdev = np.sqrt(pcov[2,2])
    Eo_sdev = np.sqrt(pcov[3,3])

    an = popt[0]
    En = popt[1]
    ao = popt[2]
    Eo = popt[3]

    print('an = ', an,' +- ',an_sdev)
    print('En = ', En,' +- ',En_sdev)
    print('ao = ', ao,' +- ',ao_sdev)
    print('Eo = ', Eo,' +- ',Eo_sdev)
    print('\n')

    fit_points = np.zeros(tmax+1-tmin)
    for i in range(tmax+1-tmin):
        fit_points[i] = f11(x[i],an,En,ao,Eo)

    dof = tmax + 1 - tmin - 4

    chi2dof = chisq_by_dof(y_av,fit_points,y_cov,dof)
    print('chisquare/dof = ',chi2dof,'\n')

    print('# t, meas_points, err_meas_points, fit_points, distances')
    for i in range(tmax+1-tmin):
        print(x[i], y_av[i], y_sdev[i], fit_points[i], (y_av[i]-fit_points[i])/y_sdev[i])    


def f11(x,an,En,ao,Eo) :
    return an*( np.exp(-En*x)+np.exp(-En*nt+En*x) ) + np.cos(np.pi*x)*ao*( np.exp(-Eo*x)+np.exp(-Eo*nt+Eo*x) )


if __name__ == '__main__' :
    main()

