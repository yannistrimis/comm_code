import numpy as np
from utils import *
import random as rd

def action_func(lattice,nx,nt) :
    act = 0.0
    for ind in range(nx**3*nt) :
        for a in range(4) :
            for b in range(a) :
                nna = nn(ind,a,nx,nt)
                nnb = nn(ind,b,nx,nt)
                act = act + (lattice[a,ind]+lattice[b,nna]-lattice[a,nnb]-lattice[b,ind])**2           
    return act

def single_update(lattice,nx,nt,action,beta,ind,mu,D_update,q_help) :
    lattice_prop = np.zeros((4,nx**3*nt))
    
    A = rd.random()
    A = (2*A-1)*D_update + lattice[mu,ind]

    act_prop = action
    pnn0 = pnn(ind,0,nx,nt)
    pnn1 = pnn(ind,1,nx,nt)
    pnn2 = pnn(ind,2,nx,nt)
    pnn3 = pnn(ind,3,nx,nt)

    for i in [ind,pnn0,pnn1,pnn2,pnn3] :
        for a in range(4) :
            for b in range(a) :
                nna = nn(i,a,nx,nt)
                nnb = nn(i,b,nx,nt)
                act_prop = act_prop - (lattice[a,i]+lattice[b,nna]-lattice[a,nnb]-lattice[b,i])**2

    for mm in range(nx**3*nt) :
        for ll in range(4):
                lattice_prop[ll,mm] = lattice[ll,mm]
    
    lattice_prop[mu,ind] = A

    for i in [ind,pnn0,pnn1,pnn2,pnn3] :
        for a in range(4) :
            for b in range(a) :
                nna = nn(i,a,nx,nt)
                nnb = nn(i,b,nx,nt)
                act_prop = act_prop + (lattice_prop[a,i]+lattice_prop[b,nna]-lattice_prop[a,nnb]-lattice_prop[b,i])**2

    if act_prop < action :
        q_help = q_help + 1
        return lattice_prop, act_prop, q_help
    else :
        r = rd.random()
        exp_action = np.exp(-0.5*beta*act_prop+0.5*beta*action)
        if r <= exp_action :
            q_help = q_help + 1
            return lattice_prop, act_prop, q_help
        else :
            return lattice, action, q_help

def update(lattice,nx,nt,action,beta,D_update, q_help, traj) :
    for i_traj in range(traj) :
        for ind in range(nx**3*nt) :
            for mu in range(4) :
                lattice, action, q_help = single_update(lattice,nx,nt,action,beta,ind,mu,D_update,q_help)
    return lattice, action, q_help