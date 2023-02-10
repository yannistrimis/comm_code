#include "utils.h"
#include "lattice.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void initialize (int my_seed, double d_hot){
    for(int i=0;i<4;i++){    
        lattice[i] = malloc( sizeof( double ) * vol );
    }
    srand(my_seed);
    for(int ind=0;ind<vol;ind++){
        for(int i=0;i<4;i++){
            double r = (double)rand()/(double)RAND_MAX;
            r = (2*r-1)*d_hot;
            lattice[i][ind] = r;
        }
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