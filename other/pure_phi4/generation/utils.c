#include "utils.h"
#include "lattice.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void initialize (int my_seed){
    for(int i=0;i<2;i++){    
        phi[i] = malloc( sizeof( double ) * vol );
    }
    srand(my_seed);
    for(int ind=0;ind<vol;ind++){\
        phi[0][ind] = 1.0;
        phi[1][ind] = 0.0;
    }
    
}

int* ind_to_vec(int ind){
    int it,ix,iy,iz;
    static int vec[4];

    it = ind/(nx*nx*nx);
    iz =(ind%(nx*nx*nx))/(nx*nx);
    iy =((ind%(nx*nx*nx))%(nx*nx))/nx;
    ix =((ind%(nx*nx*nx))%(nx*nx))%nx;

    vec[0] = ix;
    vec[1] = iy;
    vec[2] = iz;
    vec[3] = it;

    return vec;
}

int vec_to_ind(int vec[4]){
    int it,ix,iy,iz,ind;
    it = vec[3];
    iz = vec[2];
    iy = vec[1];
    ix = vec[0];

    ind = it*nx*nx*nx + iz*nx*nx + iy*nx + ix;
    return ind;
}

int nn(int ind, int mu){
    int* vec;
    int vec_mu_nn;
    int ind_nn;
    int vec_nn[4];

    vec = ind_to_vec(ind);
    if( mu==3 ){
        if( *(vec+mu)==(nt-1) ){
            vec_mu_nn = 0;
        }
        else{
            vec_mu_nn = *(vec+mu) + 1;
        }
    }
    else{
        if( *(vec+mu)==(nx-1) ){
            vec_mu_nn = 0;
        }
        else{
            vec_mu_nn = *(vec+mu) + 1;
        }
    }
    for(int i=0;i<4;i++){ 
        vec_nn[i] = *(vec+i);
    }
    vec_nn[mu] = vec_mu_nn;
    ind_nn = vec_to_ind(vec_nn);
    return ind_nn;
}


int pnn(int ind, int mu){
    int* vec;
    int vec_mu_pnn;
    int ind_pnn;
    int vec_pnn[4];

    vec = ind_to_vec(ind);
    if( mu==3 ){
        if( *(vec+mu)==0 ){
            vec_mu_pnn = nt - 1;
        }
        else{
            vec_mu_pnn = *(vec+mu) - 1;
        }
    }
    else{
        if( *(vec+mu)==0 ){
            vec_mu_pnn = nx - 1;
        }
        else{
            vec_mu_pnn = *(vec+mu) - 1;
        }
    }
    for(int i=0;i<4;i++){ 
        vec_pnn[i] = *(vec+i);
    }
    vec_pnn[mu] = vec_mu_pnn;
    ind_pnn = vec_to_ind(vec_pnn);
    return ind_pnn;
}