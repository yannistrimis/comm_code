import numpy as np
from matplotlib import pyplot as plt
from utils import *
from action import *

n_of_lat = 35
traj = 2

nx = 4
nt = 4

# beta=1/g0^2
beta_arr = [10,12]
beta_str_arr = ["10","12"]
D_update = 0.1

plaq_arr = np.zeros((len(beta_arr),n_of_lat)) # this keeps track of 
# # the plaquette for all generated lattices
# q_array = np.zeros((len(beta_arr),n_of_lat))

my_dir = "/home/yannis/Physics/LQCD/pure_u1/data/"

for i_beta in range(len(beta_arr)) :
    beta = beta_arr[i_beta]
    beta_str = beta_str_arr[i_beta]
    ens_name = "l"+str(nx)+str(nt)+"b"+beta_str   
    f_name = my_dir + ens_name
    f_keep = open("%s_plaq"%f_name,"w")

    lattice = np.zeros((4, nx**3*nt))
    D_hot = 1.0
    lattice = hot(nx**3*nt, D_hot)

    action = action_func(lattice, nx, nt)
    plaq = action/(nx**3*nt*6)
    plaq_arr[i_beta,0] = plaq 
    f_keep.write("%f\n"%plaq)
    print("1 generated\n############")
    q_help = 0.0
    i = 0

    for i in range(1,n_of_lat) :# the 0th (aka first) lattice has already been created outside the loop
        lattice, action, q_help = update(action, lattice, beta, nx, nt, D_update, q_help, traj)

        plaq = action/(nx**3*nt*6)
        plaq_arr[i_beta,i-1] = plaq
        f_keep.write("%f\n"%plaq)

        q_help = q_help/(nx**3*nt*4)
        # q_array[i_beta,i] = q_help
        if q_help > 0.7 :
            D_update = D_update + 0.1
        elif q_help < 0.5 :
            D_update = D_update - 0.1
        q_help = 0.0
        
        print("%d generated\n############"%(i+1))
    f_keep.close()

# fig1 = plt.figure()
# plt.plot( plaq_arr[0,:], label=r"$\beta=1.0$")
# plt.plot( plaq_arr[1,:], label=r"$\beta=2.0$")
# plt.plot( plaq_arr[2,:], label=r"$\beta=4.0$")
# plt.plot( plaq_arr[3,:], label=r"$\beta=6.0$")
# plt.plot( plaq_arr[4,:], label=r"$\beta=8.0$")
# plt.legend()
# plt.title(r"Plaquette vs sweeps, $4^4$")

# fig2 = plt.figure()
# plt.plot( q_array[0,:], label=r"$\beta=1.0$")
# plt.plot( q_array[1,:], label=r"$\beta=2.0$")
# plt.plot( q_array[2,:], label=r"$\beta=4.0$")
# plt.plot( q_array[3,:], label=r"$\beta=6.0$")
# plt.plot( q_array[4,:], label=r"$\beta=8.0$")
# plt.legend()
# plt.title(r"acceptance vs sweeps, $4^4$")
# plt.show()