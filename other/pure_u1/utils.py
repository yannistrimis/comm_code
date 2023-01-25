import numpy as np
import random as rd

def hot(vol,D_hot) :
    lattice = np.zeros((4,vol))
    for ind in range(vol):
            for a in range(4):
                r = rd.random()
                r = (2*r-1.0)*D_hot
                lattice[a,ind] = r
    
    return lattice
                
def ind_to_vec(i,nx,nt) :
    it = i//(nx**3)
    iz = (i%(nx**3))//(nx**2)
    iy = ((i%(nx**3))%(nx**2))//nx
    ix = ((i%(nx**3))%(nx**2))%nx
    vec = np.array([ix,iy,iz,it])
    return vec

def vec_to_ind(vec,nx,nt) :
    ix = vec[0]
    iy = vec[1]
    iz = vec[2]
    it = vec[3]
    ind = it*nx**3+iz*nx**2+iy*nx+ix
    return ind

def nn(ind,mu,nx,nt):
# finds the forward neighbour in the mu direction
    vec = ind_to_vec(ind,nx,nt)
    if mu == 3 :
        if vec[mu] == (nt-1) :
            vec_mu_nn = 0
        else :
            vec_mu_nn = vec[mu] + 1
    else :
        if vec[mu] == (nx-1) :
            vec_mu_nn = 0
        else :
            vec_mu_nn = vec[mu] + 1

    vec_nn = vec
    vec_nn[mu] = vec_mu_nn
    ind_nn = vec_to_ind(vec_nn,nx,nt)
    return ind_nn

def pnn(ind,mu,nx,nt):
# finds the backward neighbor in the mu direction
    vec = ind_to_vec(ind,nx,nt)
    if mu == 3 :
        if vec[mu] == 0 :
            vec_mu_pnn = (nt-1)
        else :
            vec_mu_pnn = vec[mu] - 1
    else :
        if vec[mu] == 0 :
            vec_mu_pnn = (nx-1)
        else :
            vec_mu_pnn = vec[mu] - 1

    vec_pnn = vec
    vec_pnn[mu] = vec_mu_pnn
    ind_pnn = vec_to_ind(vec_pnn,nx,nt)
    return ind_pnn
    
