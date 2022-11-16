import numpy as np
import random as rd

def hot(vol,D_hot) :
    lattice = np.zeros((4,vol))
    for j2 in range(vol):
            for j1 in range(4):
                r = rd.random()
                r = 2*r-1.0
                r = r*D_hot
                lattice[j1,j2] = r
    
    return lattice
                
def cold(vol,D_cold) :
    lattice = np.zeros((4,vol))
    for j2 in range(vol):
            for j1 in range(4):
                lattice[j1,j2] = D_cold
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

def aver_plaq(lattice) :

