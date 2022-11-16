import numpy as np
from utils import *

"generation of pure gauge non-compact U(1) ensembles"

n_of_lat = 10

nx = 8
nt = 8 
vol = nt*(nx**3)

beta = 0.5 # beta=1/g0^2
beta_str = "0500"
D = 10
stream = "a"
lat_dir = "l" + str(nx) + str(nt) + "b" + beta_str + stream
out_dir = lat_dir + "_out"

start_type = "fresh" # "reload"
fresh_type = "hot" # "cold"

lattice = np.zeros((4,vol))

if (start_type == "fresh") :
    if (fresh_type == "hot") :
        D_hot = 10
        lattice = hot(vol,D_hot)
    else :
        D_cold = 10
        lattice = cold(vol,D_cold)
    init=1
    
else
    
    init=0

for i in range(init,n_of_lat) :
    
    with open("l%d%db%s%s.%d.npy"%(nx,nt,beta_str,stream,i), "wb") as f:
        np.save( f, K )
    f.close()
    
""" a=16**4

import random as rd
K = np.zeros((4,a))

for i in range(4):
    for j in range(a):
        K[i,j] = rd.random()

with open("test4.npy", "wb") as f:
    np.save( f, K )
f.close() """