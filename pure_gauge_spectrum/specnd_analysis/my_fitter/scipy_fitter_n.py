### FOUR SPACES INSTEAD OF TAB ###
import numpy as np
from scipy.optimize import curve_fit

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
to_print = input()

tmin = int(str_tmin)
tmax = int(str_tmax)

an_start = float(str_an)
En_start = float(str_En)

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
    y_sdev = np.diag(y_cov)
    # WHEREAS WE NEED COVARIANCE OF THE MEAN
    y_av = np.average(y_arr,axis=1)   

    p0 = np.array([an_start,En_start])
    print('STARTING VALUES:\n')
    print(p0,'\n')

    popt, pcov = curve_fit(f10, x, y_av, p0=p0, sigma=y_cov, full_output=False)

    an_sdev = np.sqrt(pcov[0,0])
    En_sdev = np.sqrt(pcov[1,1])

    print('an = ', popt[0],' +- ',an_sdev,'\nEn = ',popt[1],' +- ',En_sdev,'\n')
    print('PARAMETER COVARIANCE MATRIX IS:\n')
    print(pcov[0,0],'  ',pcov[0,1])
    print(pcov[1,0],'  ',pcov[1,1])
    print('\n')




def f10(x,an,En) :
    return an*( np.exp(-En*x)+np.exp(-En*nt+En*x) )


if __name__ == '__main__' :
    main()

