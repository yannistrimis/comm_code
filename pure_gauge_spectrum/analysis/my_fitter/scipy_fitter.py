### FOUR SPACES INSTEAD OF TAB ###
import numpy as np
from scipy.optimize import curve_fit
from python_funcs import *

fit_type = input()
nt = input()
ens_name = input()
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
str_a1n = input()
str_E1n = input()
to_print = input()

tmin = int(str_tmin)
tmax = int(str_tmax)

an_start = float(str_an)
En_start = float(str_En)
ao_start = float(str_ao)
Eo_start = float(str_Eo)
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


    if fit_type == 'non' :

        p0 = np.array([an_start,En_start,ao_start,Eo_start])
        popt, pcov = curve_fit(f11, x, y_av, p0=p0, sigma=y_cov, full_output=False, method='trf')

        an_sdev = np.sqrt(pcov[0,0])
        En_sdev = np.sqrt(pcov[1,1])
        ao_sdev = np.sqrt(pcov[2,2])
        Eo_sdev = np.sqrt(pcov[3,3])

        an = popt[0]
        En = popt[1]
        ao = popt[2]
        Eo = popt[3]

        p1 = np.array([an,En,ao,Eo,a1n,E1n])
        popt1, pcov1 = curve_fit(f21, x, y_av, p0=p1, sigma=y_cov, full_output=False, method='trf')

        an_sdev = np.sqrt(pcov1[0,0])
        En_sdev = np.sqrt(pcov1[1,1])
        ao_sdev = np.sqrt(pcov1[2,2])
        Eo_sdev = np.sqrt(pcov1[3,3])
        a1n_sdev = np.sqrt(pcov1[4,4])
        E1n_sdev = np.sqrt(pcov1[5,5])

        an = popt1[0]
        En = popt1[1]
        ao = popt1[2]
        Eo = popt1[3]
        a1n = popt1[4]
        E1n = popt1[5]

        fit_points = np.zeros(tmax+1-tmin)
        for i in range(tmax+1-tmin):
            fit_points[i] = f21(x[i],an,En,ao,Eo,a1n,E1n)

        dof = tmax + 1 - tmin - 6

    elif fit_type == 'non_fix' :

        p0 = np.array([a1n,E1n])
        popt, pcov = curve_fit(f21_fix, x, y_av, p0=p0, sigma=y_cov, full_output=False, method='trf')

        an_sdev = 'N/A'
        En_sdev = 'N/A'
        ao_sdev = 'N/A'
        Eo_sdev = 'N/A'
        a1n_sdev = np.sqrt(pcov[0,0])
        E1n_sdev = np.sqrt(pcov[1,1])

        a1n = popt[0]
        E1n = popt[1]

        fit_points = np.zeros(tmax+1-tmin)
        for i in range(tmax+1-tmin):
            fit_points[i] = f21_fix(x[i],a1n,E1n)

        dof = tmax + 1 - tmin - 2

    elif fit_type == 'no' :

        p0 = np.array([an,En,ao,Eo])
        popt, pcov = curve_fit(f11, x, y_av, p0=p0, sigma=y_cov, full_output=False, method='trf')

        an_sdev = np.sqrt(pcov[0,0])
        En_sdev = np.sqrt(pcov[1,1])
        ao_sdev = np.sqrt(pcov[2,2])
        Eo_sdev = np.sqrt(pcov[3,3])
        a1n_sdev = 'N/A'
        E1n_sdev = 'N/A'

        an = popt[0]
        En = popt[1]
        ao = popt[2]
        Eo = popt[3]

        fit_points = np.zeros(tmax+1-tmin)
        for i in range(tmax+1-tmin):
            fit_points[i] = f11(x[i],an,En,ao,Eo)

        dof = tmax + 1 - tmin - 4

    elif fit_type == 'no_fix' :

        p0 = np.array([ao,Eo])
        popt, pcov = curve_fit(f11_fix, x, y_av, p0=p0, sigma=y_cov, full_output=False, method='trf')

        an_sdev = 'N/A'
        En_sdev = 'N/A'
        ao_sdev = np.sqrt(pcov[0,0])
        Eo_sdev = np.sqrt(pcov[1,1])
        a1n_sdev = 'N/A'
        E1n_sdev = 'N/A'

        ao = popt[0]
        Eo = popt[1]


        fit_points = np.zeros(tmax+1-tmin)
        for i in range(tmax+1-tmin):
            fit_points[i] = f11_fix(x[i],ao,Eo)

        dof = tmax + 1 - tmin - 2

    elif fit_type == 'n' :

        p0 = np.array([an,En])
        popt, pcov = curve_fit(f10, x, y_av, p0=p0, sigma=y_cov, full_output=False, method='trf')

        an_sdev = np.sqrt(pcov[0,0])
        En_sdev = np.sqrt(pcov[1,1])
        ao_sdev = 'N/A'
        Eo_sdev = 'N/A'
        a1n_sdev = 'N/A'
        E1n_sdev = 'N/A'

        an = popt[0]
        En = popt[1]

        fit_points = np.zeros(tmax+1-tmin)
        for i in range(tmax+1-tmin):
            fit_points[i] = f10(x[i],an,En)

        dof = tmax + 1 - tmin - 2

    chi2dof = chisq_by_dof(y_av,fit_points,y_cov,dof)

    if to_print == 'yes' :
        print('FIT TYPE: ',fit_type,'\n')
        print('STARTING VALUES:\n')
        print(p1,'\n')

        print('an = ', an,' +- ',an_sdev)
        print('En = ', En,' +- ',En_sdev)        
        print('ao = ', ao,' +- ',ao_sdev)
        print('Eo = ', Eo,' +- ',Eo_sdev)
        print('a1n = ', a1n,' +- ',a1n_sdev)
        print('E1n = ', E1n,' +- ',E1n_sdev)
 
        print('\n')

        print('chisquare/dof = ',chi2dof,'\n')
        print('# t, meas_points, err_meas_points, fit_points, distances')
        for i in range(tmax+1-tmin):
            print(x[i], y_av[i], y_sdev[i], fit_points[i], (y_av[i]-fit_points[i])/y_sdev[i]) 
    
    elif to_print == 'no' :
        print(tmin,tmax,chi2dof,En,En_sdev,Eo,Eo_sdev,E1n,E1n_sdev)


# FUNCTION DEFINITIONS


def f10(x,an,En) :
    return an*( np.exp(-En*x)+np.exp(-En*nt+En*x) )


def f11_fix(x,ao,Eo) :
    return an*( np.exp(-En*x)+np.exp(-En*nt+En*x) ) + np.cos(np.pi*x)*ao*( np.exp(-Eo*x)+np.exp(-Eo*nt+Eo*x) )


def f11(x,an,En,ao,Eo) :
    return an*( np.exp(-En*x)+np.exp(-En*nt+En*x) ) + np.cos(np.pi*x)*ao*( np.exp(-Eo*x)+np.exp(-Eo*nt+Eo*x) )


def f21_fix(x,a1n,E1n) :
    res = an*( np.exp(-En*x)+np.exp(-En*nt+En*x) )
    res = res + np.cos(np.pi*x)*ao*( np.exp(-Eo*x)+np.exp(-Eo*nt+Eo*x) )
    res = res + a1n*( np.exp(-E1n*x)+np.exp(-E1n*nt+E1n*x) )
    return res


def f21(x,an,En,ao,Eo,a1n,E1n) :
    res = an*( np.exp(-En*x)+np.exp(-En*nt+En*x) )
    res = res + np.cos(np.pi*x)*ao*( np.exp(-Eo*x)+np.exp(-Eo*nt+Eo*x) )
    res = res + a1n*( np.exp(-E1n*x)+np.exp(-E1n*nt+E1n*x) ) 
    return res


if __name__ == '__main__' :
    main()

