import numpy as np
from scipy.optimize import curve_fit
from matplotlib import pyplot as plt

def func(x,a,b):
    return a+b*x

N=16

my_arr = np.array([[0.00, 0.25147, 0.00030, 0.24717, 0.00030, 0.24307, 0.00029, 0.23910, 0.00028],\
[1.00, 0.32191, 0.00047, 0.31638, 0.00046, 0.31098, 0.00049, 0.30594, 0.00048],\
[2.00, 0.3776, 0.0017, 0.3712, 0.0016, 0.3652, 0.0015, 0.3594, 0.0014]])

'''
for i in range(3):
    for j in range(9):
        print('%.10f\t'%(my_arr[i,j]),end='')
    print('\n',end='')
print('\n')
'''

for i in range(3):
    my_arr[i,0]=my_arr[i,0]*((2*np.pi)/N)**2

    my_arr[i,2]=2*my_arr[i,1]*my_arr[i,2]
    my_arr[i,4]=2*my_arr[i,3]*my_arr[i,4]
    my_arr[i,6]=2*my_arr[i,5]*my_arr[i,6]
    my_arr[i,8]=2*my_arr[i,7]*my_arr[i,8]

    my_arr[i,1]=my_arr[i,1]**2
    my_arr[i,3]=my_arr[i,3]**2
    my_arr[i,5]=my_arr[i,5]**2
    my_arr[i,7]=my_arr[i,7]**2

'''
for i in range(3):
    for j in range(9):
        print('%.10f\t'%(my_arr[i,j]),end='')
    print('\n',end='')
'''
for j in [1,3,5,7]:

    c_mean, c_cov = curve_fit(func, my_arr[:,0], my_arr[:,j],sigma=my_arr[:,j+1])
    x_mean = 1/np.sqrt(c_mean[1])
    x_sdev = 2*np.sqrt(c_cov[1,1])/x_mean**3
    print(x_mean,x_sdev)


#plt.plot( my_arr[:,0], func(my_arr[:,0],c_mean[0],c_mean[1]),'--' )
#plt.errorbar( my_arr[:,0], my_arr[:,3], yerr=my_arr[:,4],fmt='o' )

plt.show()
