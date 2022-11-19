import numpy as np
from utils import *
from action import *

"generation of pure gauge non-compact U(1) ensembles"

n_of_lat = 10
trajectories = 10

nx = 8
nt = 8

beta = 0.5 # beta=1/g0^2
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

for i in range(init,n_of_lat) :
    
    lattice = update(lattice,nx,nt,trajectories,D_update)

    with open("%s/%s.lat.%d"%(lat_dir,ens_name,i), "wb") as f:
        np.save(f,lattice)
    f.close()
