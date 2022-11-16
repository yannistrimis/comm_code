import numpy as np
import random as rd
from matplotlib import pyplot as plt
# PART (c)
time = 10.0
dt = 0.005

temp = 1.0
zeta = 1.0 
x0 = 0.0
p0 = 0.0

n_t = int(time/dt)
n_toy = 10000

mu = 0.0
sigma = 1.0

res = np.zeros(n_t+1)
res_dist = np.zeros(n_toy)

time_vec = np.zeros(n_t+1)
for i in range(n_t+1) :
    time_vec[i] = dt*i

for i_toy in range(n_toy) :
    x = x0
    p = p0
    res[0] = res[0] + x*x
    for i_dt in range(1,n_t+1) :
        eta = rd.gauss(mu,sigma)
        p = p - x*dt - zeta*p*dt + np.sqrt(2*zeta*temp*dt)*eta
        x = x + p*dt
        res[i_dt] = res[i_dt] + x*x
    res_dist[i_toy] = x 
res = res/n_toy

# A = np.vstack(( time_vec , np.zeros_like(time_vec) )).T

# coeffs = np.linalg.lstsq(A,res,rcond=-1)[0]

# D = coeffs[0]/2
# print(D)

plt.figure(1)
# plt.plot(time_vec,2*D*time_vec,"--y",label="theory")
plt.plot(time_vec,res,"b",label="simulation")
plt.legend()
plt.title("position autocorrelation")
plt.xlabel("time")
plt.ylabel("<x^2>")
plt.show()

# x_vec = np.linspace(-4.0,4.0,num=50)
# thermal = np.zeros(50)
# for i in range(50):
#     thermal[i] = 1/(np.sqrt(2*np.pi))*np.exp( -0.5*x_vec[i]**2 )

plt.figure(2)
plt.hist(res_dist,bins=50,density=True, label="simulation")
# plt.plot(x_vec,thermal,"y",linewidth=1.8,label="thermal distribution")
plt.legend()
plt.show()

# prime_time = 2.0
# fix_time = 7.0
# prime_minus = fix_time - prime_time
# prime_plus = fix_time + prime_time

# fix_n_t = int(fix_time/dt)+1
# minus_n_t = int(prime_minus/dt)+1
# plus_n_t = int(prime_plus/dt)+1

# res = np.zeros(plus_n_t-minus_n_t+1)
# time_vec = np.zeros(plus_n_t-minus_n_t+1)
# l=0
# for i_dt in range(minus_n_t,plus_n_t+1) :
#     time_vec[l] = dt*i_dt
#     l = l+1
# for i_toy in range(n_toy) :
#     x = np.zeros(n_t+1)
#     eta_arr = np.zeros(n_t+1)
#     x[0] = x0
#     eta_arr[0] = 0
#     for i_dt in range(1,n_t+1) :
#         # eta = rd.gauss(mu,sigma)
#         eta = rd.uniform(-1.5,1.5)
#         x[i_dt] = x[i_dt-1] - x[i_dt-1]*dt + np.sqrt(2*zeta*temp*dt)*eta #this is for part b,c,d
#         eta_arr[i_dt] = eta
#     j = 0
#     for i_dt in range(minus_n_t,plus_n_t+1) :
#         res[j] = res[j] + x[fix_n_t]*eta_arr[i_dt]
#         j = j+1

# res = res/n_toy*1/(np.sqrt(2*zeta*temp*dt))
# jj=0
# theory_curve = np.zeros(plus_n_t-minus_n_t+1)
# for i in range(minus_n_t,plus_n_t+1) :
#     if time_vec[jj]<fix_time:
#         theory_curve[jj] = np.exp(-abs(time_vec[jj]-fix_time))
#     else :
#         theory_curve[jj] = 0
#     jj =jj+1

# plt.figure(1)

# plt.plot(time_vec,res,"b",label="simulation")
# # plt.plot(time_vec,theory_curve,"--y",label="theory")
# plt.legend()
# plt.title("position time correlation, dt=0.005, Nsim=10000, uniform [-1.5,1.5]")
# plt.xlabel("t'")
# plt.ylabel("<x(7)x(t')>")
# plt.show()