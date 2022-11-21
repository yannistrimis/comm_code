import numpy as np
from utils import *
from action import *
import globals
"generation of pure gauge non-compact U(1) ensembles"

n_of_lat = 10
trajectories = 1

nx = 4
nt = 4

for beta in [0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17, 0.18, 0.19, 0.2] :
    #beta = 0.1 # beta=1/g0^2
    beta_str = "0500"
    D_update = 10
    stream = "a"
    ens_name = "l"+str(nx)+str(nt)+"b"+beta_str+stream
    lat_dir = "/home/yannis/Physics/LQCD/pure_u1_lattices/"+ens_name

    start_type = "fresh" # "reload"
    fresh_type = "hot" # "cold"

    lattice = np.zeros((4,nx**3*nt))

    if (start_type == "fresh") :
        if (fresh_type == "hot") :
            D_hot = 10
            lattice = hot(nx**3*nt,D_hot)
        else :
            D_cold = 10
            lattice = cold(nx**3*nt,D_cold)
    else :
        prev_lat = "NO_PREV_LAT"
        with open("%s/%s"%(lat_dir,prev_lat), "rb") as f:
            lattice = np.load(f)
            f.close()
        
    init = 1
    action = action_func(lattice,beta,nx,nt)

    with open("%s/%s.lat.%d"%(lat_dir,ens_name,init), "wb") as f:
        np.save(f,lattice)
    f.close()

    for i in range(init+1,n_of_lat+1) :    
        lattice = update(action,lattice,beta,nx,nt,D_update,trajectories)
        with open("%s/%s.lat.%d"%(lat_dir,ens_name,i), "wb") as f:
            np.save(f,lattice)
        f.close()

    globals.q_help = globals.q_help/(nx**3*nt*4*trajectories*(n_of_lat-1))
    
    print("%f %f"%(globals.q_help,beta))