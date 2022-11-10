import numpy as np
import random as rd
from matplotlib import pyplot as plt
# PART (a)
time = 10.0
dt = 0.01

temp = 1.0
zeta = 1.0 
x0 = 0.0

n_t = int(time/dt)
n_toy = 1000

mu = 0.0
sigma = 1.0

res = np.zeros(n_t+1)


for i_toy in range(n_toy) :
    x = x0
    res[0] = res[0] + x*x
    for i_dt in range(1,n_t+1) :
        eta = rd.gauss(mu,sigma)
        x = x + np.sqrt(2*zeta*temp*dt)*eta
        res[i_dt] = res[i_dt] + x*x

res = res/n_toy

plt.plot(res,)
plt.show()