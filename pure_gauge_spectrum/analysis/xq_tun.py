import numpy as np
from scipy.optimize import curve_fit
from matplotlib import pyplot as plt

print('\n')

def func(x,a,b):
    return a+b*x

N_space = 16
x_ren = 4.0


my_arr = np.array([[0.00, 0.11532, 0.00012, 0.11338, 0.00012, 0.11154, 0.00012],\
[1.00, 0.15102, 0.00085, 0.14858, 0.00071, 0.14623, 0.00061],\
[2.00, 0.1805, 0.0010, 0.17744, 0.00094, 0.17451, 0.00088]])


'''
my_arr = np.array([[0.00, 0.25147, 0.00030, 0.24717, 0.00030, 0.24307, 0.00029, 0.23910, 0.00028],\
[1.00, 0.32191, 0.00047, 0.31638, 0.00046, 0.31098, 0.00049, 0.30594, 0.00048],\
[2.00, 0.3776, 0.0017, 0.3712, 0.0016, 0.3652, 0.0015, 0.3594, 0.0014]])
'''

'''
for i in range(3):
    for j in range(9):
        print('%.10f\t'%(my_arr[i,j]),end='')
    print('\n',end='')
print('\n')
'''

for i in range(3):
    my_arr[i,0]=my_arr[i,0]*((2*np.pi)/N_space)**2

    my_arr[i,2]=2*my_arr[i,1]*my_arr[i,2]
    my_arr[i,4]=2*my_arr[i,3]*my_arr[i,4]
    my_arr[i,6]=2*my_arr[i,5]*my_arr[i,6]
#    my_arr[i,8]=2*my_arr[i,7]*my_arr[i,8]

    my_arr[i,1]=my_arr[i,1]**2
    my_arr[i,3]=my_arr[i,3]**2
    my_arr[i,5]=my_arr[i,5]**2
#    my_arr[i,7]=my_arr[i,7]**2

'''
for i in range(3):
    for j in range(9):
        print('%.10f\t'%(my_arr[i,j]),end='')
    print('\n',end='')
'''

x0_arr=np.array([ 3.76, 3.88, 4.00 ])
x_arr=np.zeros((3,2))

l = -1
for j in [1,3,5]:

    l = l + 1
    p_mean, p_cov = curve_fit(func, my_arr[:,0], my_arr[:,j],sigma=my_arr[:,j+1])
    x_arr[l,0] = 1/np.sqrt(p_mean[1])
    x_arr[l,1] = 0.5*np.sqrt(p_cov[1,1])*x_arr[l,0]**3
    print ('bare: %.2f  output: %.5f +- %.5f'%(x0_arr[l],x_arr[l,0],x_arr[l,1]) )

print('\n')

coeffs = np.polyfit( x0_arr[:], x_arr[:,0], 2, w=x_arr[:,1] )
coeffs[2] = coeffs[2] - x_ren
solutions = np.roots(coeffs)

for ii in range( len(solutions) ):
    if solutions[ii] < ( x_ren + 2.0 ) and solutions[ii] > ( x_ren - 2.0 ) :
        predicted_xq0  = np.real(solutions[ii])
        break

print('predicted xq0: %.5f'%predicted_xq0)

plt.errorbar(x0_arr[:],x_arr[:,0],yerr=x_arr[:,1],fmt='o')





#plt.plot( my_arr[:,0], func(my_arr[:,0],c_mean[0],c_mean[1]),'--' )
#plt.errorbar( my_arr[:,0], my_arr[:,3], yerr=my_arr[:,4],fmt='o' )

plt.show()

print('\n')
