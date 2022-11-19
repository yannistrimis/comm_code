import numpy as np
from utils import *
import random as rd

def action(lattice,beta,nx,nt) :
    action = 0.0
    for ind in range(nx**3*nt) :
        for a in range(4) :
            for b in range(a) :
                nna = nn(ind,a,nx,nt)
                nnb = nn(ind,b,nx,nt)
                action = action + lattice[b,nna] - lattice[b,ind]
                action = action - lattice[a,nnb] + lattice[a,ind]

    action = 2*beta*action
    return action

def single_update(ind,lattice,beta,nx,nt,D_update) :
    