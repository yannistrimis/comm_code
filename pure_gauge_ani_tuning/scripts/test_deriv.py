import numpy as np
from python_funcs import *

N=100
len=2*np.pi
dx = len/N
x = np.zeros(N)
y = np.zeros(N)
yprime = np.zeros(N)

for i in range(N):
	x[i] = i*dx
	y[i] = x[i]*np.sin(x[i])/np.exp(x[i])
yprime = deriv(y,dx)
for i in range(N):
	print(x[i],y[i],yprime[i])
