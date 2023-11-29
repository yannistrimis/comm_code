import numpy as np
from scipy.optimize import curve_fit
from matplotlib import pyplot as plt

def func(x,a,b):
    return a+b*x

w0_phys = 0.17355
mss_phys = 685.8

my_arr = np.array([ [0.02,0,0], [0.04,0,0], [0.06,0,0], [0.08,0,0] ])

for m in range( np.shape(my_arr)[0] ) :
    my_arr[m,0] = my_arr[m,0]*my_arr[m,0]
    my_arr[m,2] = 2*my_arr[m,1]*my_arr[m,2]
    my_arr[m,1] = my_arr[m,1]*my_arr[m,1]

pmean, pcov = curve_fit( func, my_arr[:,0], my_arr[:,1], sigma=my_arr[:,2] )

plt.errorbar(my_arr[:,0],my_arr[:,1],yerr=my_arr[:,2])

plt.show()
