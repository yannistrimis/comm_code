import numpy as np
from scipy.optimize import curve_fit
from matplotlib import pyplot as plt

def func(x,a,b,c):
    return a*x*x+b*x+c

'''
xi_ren = 2.00
'''

xi_ren = 4.00

w0_phys = 0.17355
mss_phys = 685.8
hc = 197.327

'''
w0_lat = 1.08403
'''

w0_lat = 1.08461

mss_lat = (w0_phys/w0_lat) * mss_phys / hc

'''
my_arr = np.array([ [0.04, 0.20210, 0.00029],\
[0.06, 0.24634, 0.00029],\
[0.08, 0.28441, 0.00028],\
[0.10, 0.31876, 0.00026],\
[0.12, 0.35054, 0.00026] ])
'''

my_arr = np.array([ [0.037, 0.09963, 0.00016],\
[0.057, 0.12333, 0.00014],\
[0.077, 0.14351, 0.00013],\
[0.097, 0.16167, 0.00013],\
[0.117, 0.17848, 0.00012] ])

pmean, pcov = curve_fit( func, my_arr[:,0], xi_ren*my_arr[:,1], sigma=xi_ren*my_arr[:,2] )

x_vec = np.linspace(0,0.13,num=50)
y_vec = np.zeros(50)

for ix in range(len(x_vec)):
    y_vec[ix] = func(x_vec[ix],pmean[0],pmean[1],pmean[2])

plt.errorbar(my_arr[:,0],xi_ren*my_arr[:,1],yerr=xi_ren*my_arr[:,2],fmt='o')
plt.plot(x_vec,y_vec)

coeffs = [pmean[0],pmean[1],pmean[2]]
coeffs[2] = coeffs[2] - mss_lat

ms = 0.0
solutions = np.roots(coeffs)
for ii in range( len(solutions) ): # FOR SECURITY
    if solutions[ii] <  0.2  and solutions[ii] >  0.01  :
        ms = np.real(solutions[ii])
        break
print(ms)
plt.show()
