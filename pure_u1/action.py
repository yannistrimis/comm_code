import numpy as np
from utils import *
import random as rd
import globals

def action_func(lattice,beta,nx,nt) :
    action = 0.0
    for ind in range(nx**3*nt) :
        for a in range(4) :
            for b in range(a) :
                nna = nn(ind,a,nx,nt)
                nnb = nn(ind,b,nx,nt)
                action = action + (lattice[b,nna] - lattice[b,ind])**2
                action = action - (lattice[a,nnb] + lattice[a,ind])**2
    return action

def single_update(action,ind,mu,lattice,beta,nx,nt,D_update) :
    A = rd.random()
    A = (2*A-1)*D_update

    action_restore = 0.0
    pnn0 = pnn(ind,0,nx,nt)
    pnn1 = pnn(ind,1,nx,nt)
    pnn2 = pnn(ind,2,nx,nt)
    pnn3 = pnn(ind,3,nx,nt)

    for i in [ind,pnn0,pnn1,pnn2,pnn3] :
        for a in range(4) :
            for b in range(a) :
                nna = nn(i,a,nx,nt)
                nnb = nn(i,b,nx,nt)
                action_restore = action_restore + (lattice[b,nna] - lattice[b,i])**2
                action_restore = action_restore - (lattice[a,nnb] + lattice[a,i])**2

    action_restore = action_restore
    action_prop = action - action_restore

    lattice_prop = lattice
    lattice_prop[mu,ind] = A

    for i in [ind,pnn0,pnn1,pnn2,pnn3] :
        for a in range(4) :
            for b in range(a) :
                nna = nn(i,a,nx,nt)
                nnb = nn(i,b,nx,nt)
                action_prop = action_prop + (lattice_prop[b,nna] - lattice_prop[b,i])**2
                action_prop = action_prop - (lattice_prop[a,nnb] + lattice_prop[a,i])**2

    
    action = 0.5*beta*action
    action_prop = 0.5*beta*action_prop

    if action_prop <= action :
        return A , action_prop
    else :
        r = rd.random()
        exp_action = np.exp(-0.5*beta*action_prop)
        if r <= exp_action :
            globals.q_help = globals.q_help + 1
            return A , action_prop
        else :
            return lattice[mu,ind] , action_prop 

def update(action,lattice,beta,nx,nt,D_update,trajectories) :
    for i_traj in range(trajectories) :
        for ind in range(nx**3*nt) :
            for mu in range(4) :
                lattice[mu,ind] , action = single_update(action,ind,mu,lattice,beta,nx,nt,D_update)
    return lattice