import numpy as np
from matplotlib import pyplot as plt
from utils import *
from action import *

n_of_lat = 30
traj = 1

nx = 4
nt = 4

#beta = 1.0 # beta=1/g0^2
beta_arr = [1.0, 2.0, 4.0, 6.0, 8.0]
D_update = 0.1

plaq_arr = np.zeros((len(beta_arr),n_of_lat))
q_array = np.zeros((len(beta_arr),n_of_lat))

# beta_str = ""
# stream = "a"
# ens_name = "l"+str(nx)+str(nt)+"b"+beta_str+stream
# lat_dir = "/home/yannis/Physics/LQCD/pure_u1_lattices/"+ens_name
for i_beta in range(len(beta_arr)) :
    beta = beta_arr[i_beta]
    lattice = np.zeros((4, nx**3*nt))
    D_hot = 1.0
    lattice = hot(nx**3*nt, D_hot)

    action = action_func(lattice, nx, nt)
    plaq_arr[i_beta,0] = action/(nx**3*nt*6)
    q_help = 0.0

    for i in range(1,n_of_lat) :

        lattice, action, q_help = update(action, lattice, beta, nx, nt, D_update, q_help, traj)
        
        plaq_arr[i_beta,i] = action/(nx**3*nt*6)
        q_help = q_help/(nx**3*nt*4)
        q_array[i_beta,i] = q_help
        if q_help > 0.7 :
            D_update = D_update + 0.1
        elif q_help < 0.5 :
            D_update = D_update - 0.1
        q_help = 0.0
        
        print("%d out of %d\n############"%(i+1,n_of_lat))

fig1 = plt.figure()
plt.plot( plaq_arr[0,:], label=r"$\beta=1.0$")
plt.plot( plaq_arr[1,:], label=r"$\beta=2.0$")
plt.plot( plaq_arr[2,:], label=r"$\beta=4.0$")
plt.plot( plaq_arr[3,:], label=r"$\beta=6.0$")
plt.plot( plaq_arr[4,:], label=r"$\beta=8.0$")
plt.legend()
plt.title(r"Plaquette vs sweeps, $4^4$")

fig2 = plt.figure()
plt.plot( q_array[0,:], label=r"$\beta=1.0$")
plt.plot( q_array[1,:], label=r"$\beta=2.0$")
plt.plot( q_array[2,:], label=r"$\beta=4.0$")
plt.plot( q_array[3,:], label=r"$\beta=6.0$")
plt.plot( q_array[4,:], label=r"$\beta=8.0$")
plt.legend()
plt.title(r"acceptance vs sweeps, $4^4$")
plt.show()