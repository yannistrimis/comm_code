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

def aver_plaq(lattice) :

